const { spawn } = require('child_process');

let backupInProgress = false;

function buildBackupFilename() {
    const now = new Date();
    const pad = (n) => String(n).padStart(2, '0');
    const date = `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())}`;
    const time = `${pad(now.getHours())}${pad(now.getMinutes())}`;
    return `backup-${date}-${time}.sql`;
}

exports.exportDatabaseBackup = async (req, res) => {
    if (backupInProgress) {
        req.flash('error_msg', 'هناك نسخة احتياطية قيد التنفيذ، حاول بعد قليل.');
        return res.redirect('/home');
    }

    backupInProgress = true;
    const startedAt = Date.now();
    const fileName = buildBackupFilename();

    const host = process.env.DB_HOST || 'localhost';
    const user = process.env.DB_USER || 'root';
    const password = process.env.DB_PASSWORD || '';
    const database = process.env.DB_NAME || 'lab_inventory';
    const mysqldumpPath = process.env.MYSQLDUMP_PATH || 'mysqldump';

    const args = [
        `--host=${host}`,
        `--user=${user}`,
        '--default-character-set=utf8mb4',
        '--single-transaction',
        '--quick',
        '--skip-lock-tables',
        '--routines',
        '--events',
        '--triggers',
        database
    ];

    const spawnEnv = { ...process.env };
    if (password) {
        spawnEnv.MYSQL_PWD = password;
    }

    console.log(`[DB-BACKUP] started by user=${req.session?.user?.username || 'unknown'} file=${fileName}`);

    let bytesSent = 0;
    let stderr = '';
    let finished = false;
    let downloadStarted = false;

    try {
        const dumpProcess = spawn(mysqldumpPath, args, {
            stdio: ['ignore', 'pipe', 'pipe'],
            env: spawnEnv,
            windowsHide: true
        });

        const timeoutMs = 10 * 60 * 1000; // 10 minutes
        const timeout = setTimeout(() => {
            if (!finished) {
                stderr += '\nBackup timed out';
                dumpProcess.kill('SIGKILL');
            }
        }, timeoutMs);
        timeout.unref?.();

        dumpProcess.stdout.on('data', (chunk) => {
            if (!downloadStarted) {
                downloadStarted = true;
                res.setHeader('Content-Type', 'application/sql; charset=utf-8');
                res.setHeader('Content-Disposition', `attachment; filename="${fileName}"`);
            }
            bytesSent += chunk.length;
            res.write(chunk);
        });

        dumpProcess.stderr.on('data', (chunk) => {
            stderr += chunk.toString();
        });

        dumpProcess.on('error', (error) => {
            if (finished) return;
            finished = true;
            clearTimeout(timeout);
            console.error('[DB-BACKUP] spawn error:', error);
            if (!res.headersSent) {
                req.flash('error_msg', 'فشل تشغيل أداة النسخ الاحتياطي (mysqldump).');
                return res.redirect('/home');
            }
            if (!res.writableEnded) res.end();
            backupInProgress = false;
        });

        dumpProcess.on('close', (code, signal) => {
            if (finished) return;
            finished = true;
            clearTimeout(timeout);
            const durationMs = Date.now() - startedAt;
            const stderrText = stderr.trim() || 'n/a';
            console.log(`[DB-BACKUP] finished code=${code} signal=${signal || 'none'} duration=${durationMs}ms bytes=${bytesSent} stderr=${stderrText}`);

            if (code !== 0 || bytesSent === 0) {
                const message = bytesSent === 0
                    ? 'فشل إنشاء النسخة الاحتياطية: لم يتم إنتاج بيانات (ملف فارغ).'
                    : 'فشل إنشاء النسخة الاحتياطية. تأكد من مسار mysqldump وصلاحيات قاعدة البيانات.';

                if (!res.headersSent) {
                    req.flash('error_msg', message);
                    res.redirect('/home');
                } else if (!res.writableEnded) {
                    res.end();
                }
                backupInProgress = false;
                return;
            }

            if (!res.writableEnded) res.end();
            backupInProgress = false;
        });
    } catch (error) {
        console.error('[DB-BACKUP] unexpected error:', error);
        backupInProgress = false;
        req.flash('error_msg', 'حدث خطأ أثناء تصدير النسخة الاحتياطية.');
        return res.redirect('/home');
    }
};
