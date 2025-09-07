const moment = require('moment');

// خريطة لتتبع اتصالات المستخدمين
const userConnections = new Map(); // userId -> Set of socketIds
const socketUsers = new Map(); // socketId -> userId
const heartbeatTimers = new Map(); // socketId -> timer

const HEARTBEAT_INTERVAL = 10000; // 10 ثواني
const OFFLINE_TIMEOUT = 20000; // 20 ثانية

module.exports = (io, pool) => {
    
    // تنظيف دوري للاتصالات المعلقة (كل 30 ثانية)
    setInterval(async () => {
        try {
            // تحديد المستخدمين الذين لم يرسلوا heartbeat لفترة طويلة
            const [affectedRows] = await pool.query(`
                UPDATE users 
                SET activity_status = 'offline', last_seen_at = NOW() 
                WHERE activity_status = 'online' 
                AND last_seen_at IS NOT NULL 
                AND last_seen_at < NOW() - INTERVAL 45 SECOND
            `);
            
            if (affectedRows.affectedRows > 0) {
                console.log(`تم تحديث ${affectedRows.affectedRows} مستخدم إلى offline بواسطة التنظيف التلقائي`);
                
                // إشعار المشرفين بالتحديثات
                const [offlineUsers] = await pool.query(`
                    SELECT u.id, u.username, u.role_id 
                    FROM users u 
                    WHERE u.activity_status = 'offline' 
                    AND u.last_seen_at > NOW() - INTERVAL 1 MINUTE
                `);
                
                offlineUsers.forEach(user => {
                    broadcastPresenceUpdate(user.id, 'offline', new Date());
                });
            }
        } catch (error) {
            console.error('خطأ في تنظيف الاتصالات المعلقة:', error);
        }
    }, 30000); // كل 30 ثانية
    
    // تحديث حالة المستخدم في قاعدة البيانات
    async function updateUserStatus(userId, status, lastSeenAt = null) {
        try {
            if (status === 'online') {
                await pool.query(
                    'UPDATE users SET activity_status = ?, last_seen_at = NOW() WHERE id = ?',
                    [status, userId]
                );
            } else {
                await pool.query(
                    'UPDATE users SET activity_status = ?, last_seen_at = ? WHERE id = ?',
                    [status, lastSeenAt || new Date(), userId]
                );
            }
            
            // إشعار جميع المشرفين بالتحديث
            broadcastPresenceUpdate(userId, status, lastSeenAt);
        } catch (error) {
            console.error('خطأ في تحديث حالة المستخدم:', error);
        }
    }
    
    // بث تحديثات الحضور للمشرفين
    async function broadcastPresenceUpdate(userId, status, lastSeenAt = null) {
        try {
            // جلب معلومات المستخدم
            const [users] = await pool.query(
                'SELECT u.id, u.username, u.role_id FROM users u WHERE u.id = ?',
                [userId]
            );
            
            if (users.length === 0) return;
            
            const user = users[0];
            
            // تحويل role_id إلى role name
            const role = user.role_id === 2 ? 'editor' : 
                        user.role_id === 3 ? 'viewer' : 
                        user.role_id === 4 ? 'admin' : 'unknown';
            
            const updateData = {
                userId: user.id,
                username: user.username,
                role: role,
                status: status,
                lastSeenAt: lastSeenAt,
                timestamp: new Date()
            };
            
            // إرسال للمشرفين فقط
            io.sockets.sockets.forEach((socket) => {
                if (socket.userRole === 'admin') {
                    socket.emit(`presence:${status}`, updateData);
                    socket.emit('presence:update', updateData);
                }
            });
        } catch (error) {
            console.error('خطأ في بث تحديث الحضور:', error);
        }
    }
    
    // إضافة اتصال للمستخدم
    function addUserConnection(userId, socketId) {
        if (!userConnections.has(userId)) {
            userConnections.set(userId, new Set());
        }
        userConnections.get(userId).add(socketId);
        socketUsers.set(socketId, userId);
    }
    
    // إزالة اتصال المستخدم
    function removeUserConnection(socketId) {
        const userId = socketUsers.get(socketId);
        if (userId && userConnections.has(userId)) {
            userConnections.get(userId).delete(socketId);
            if (userConnections.get(userId).size === 0) {
                userConnections.delete(userId);
                // المستخدم لم يعد متصلاً من أي جلسة
                updateUserStatus(userId, 'offline', new Date());
            }
        }
        socketUsers.delete(socketId);
        
        // إلغاء مؤقت heartbeat
        if (heartbeatTimers.has(socketId)) {
            clearTimeout(heartbeatTimers.get(socketId));
            heartbeatTimers.delete(socketId);
        }
        
        // إلغاء ping interval
        const socket = io.sockets.sockets.get(socketId);
        if (socket && socket.pingInterval) {
            clearInterval(socket.pingInterval);
        }
    }
    
    // بدء مراقبة heartbeat
    function startHeartbeat(socket) {
        const timer = setTimeout(() => {
            console.log(`Heartbeat timeout for socket ${socket.id} - forcing disconnect`);
            // قطع الاتصال فوراً
            socket.disconnect(true);
        }, OFFLINE_TIMEOUT);
        
        heartbeatTimers.set(socket.id, timer);
    }
    
    // إعادة تعيين مؤقت heartbeat
    function resetHeartbeat(socketId) {
        if (heartbeatTimers.has(socketId)) {
            clearTimeout(heartbeatTimers.get(socketId));
        }
        
        const socket = io.sockets.sockets.get(socketId);
        if (socket) {
            startHeartbeat(socket);
        }
    }
    
    // بدء ping من الخادم للتأكد من الاتصال
    function startServerPing(socket) {
        const pingInterval = setInterval(() => {
            if (socket.connected) {
                const pingTime = Date.now();
                socket.emit('server_ping', { timestamp: pingTime });
                
                // انتظار الرد لمدة 5 ثوان
                const pongTimeout = setTimeout(() => {
                    console.log(`No pong received from socket ${socket.id}, disconnecting`);
                    socket.disconnect(true);
                }, 5000);
                
                // معالج الرد
                const pongHandler = (data) => {
                    clearTimeout(pongTimeout);
                    socket.removeListener('client_pong', pongHandler);
                };
                
                socket.once('client_pong', pongHandler);
            } else {
                clearInterval(pingInterval);
            }
        }, 15000); // ping كل 15 ثانية
        
        // حفظ مرجع لإلغاء الـ interval عند قطع الاتصال
        socket.pingInterval = pingInterval;
    }
    
    // معالج اتصال Socket.IO
    io.on('connection', (socket) => {
        console.log(`Socket connected: ${socket.id}`);
        
        // التحقق من صحة الجلسة
        socket.on('authenticate', async (data) => {
            try {
                const { userId, sessionId } = data;
                
                if (!userId || !sessionId) {
                    socket.emit('auth_error', { message: 'بيانات المصادقة مفقودة' });
                    return;
                }
                
                // التحقق من وجود المستخدم
                const [users] = await pool.query(
                    'SELECT u.id, u.username, u.role_id FROM users u WHERE u.id = ?',
                    [userId]
                );
                
                if (users.length === 0) {
                    socket.emit('auth_error', { message: 'مستخدم غير صحيح' });
                    return;
                }
                
                const user = users[0];
                
                // تحويل role_id إلى role name
                let roleName;
                if (user.role_id === 2) {
                    roleName = 'editor';
                } else if (user.role_id === 3) {
                    roleName = 'viewer';
                } else if (user.role_id === 4) {
                    roleName = 'admin';
                } else {
                    roleName = 'unknown';
                }
                
                socket.userId = user.id;
                socket.username = user.username;
                socket.userRole = roleName;
                
                // إضافة الاتصال
                addUserConnection(user.id, socket.id);
                
                // تحديث الحالة إلى متصل
                await updateUserStatus(user.id, 'online');
                
                // بدء مراقبة heartbeat
                startHeartbeat(socket);
                
                // بدء ping من الخادم
                startServerPing(socket);
                
                // إرسال تأكيد المصادقة
                socket.emit('authenticated', {
                    userId: user.id,
                    username: user.username,
                    role: roleName
                });
                
                console.log(`User ${user.username} authenticated on socket ${socket.id}`);
                
                // إرسال قائمة المستخدمين الحالية للمشرفين
                if (roleName === 'admin') {
                    const [allUsers] = await pool.query(`
                        SELECT u.id, u.username, u.role_id, u.activity_status, u.last_seen_at 
                        FROM users u
                        ORDER BY u.activity_status DESC, u.last_seen_at DESC
                    `);
                    
                    // تحويل role_id إلى role name لكل مستخدم
                    const formattedUsers = allUsers.map(user => ({
                        ...user,
                        role: user.role_id === 2 ? 'editor' : 
                              user.role_id === 3 ? 'viewer' : 
                              user.role_id === 4 ? 'admin' : 'unknown'
                    }));
                    
                    socket.emit('presence:users_list', formattedUsers);
                }
                
            } catch (error) {
                console.error('خطأ في المصادقة:', error);
                socket.emit('auth_error', { message: 'خطأ في المصادقة' });
            }
        });
        
        // معالج heartbeat
        socket.on('heartbeat', async () => {
            resetHeartbeat(socket.id);
            
            // تحديث آخر نشاط في قاعدة البيانات
            if (socket.userId) {
                try {
                    await pool.query(
                        'UPDATE users SET last_seen_at = NOW() WHERE id = ? AND activity_status = "online"',
                        [socket.userId]
                    );
                } catch (error) {
                    console.error('خطأ في تحديث آخر نشاط:', error);
                }
            }
            
            socket.emit('heartbeat_ack');
        });
        
        // معالج قطع الاتصال
        socket.on('disconnect', (reason) => {
            console.log(`Socket disconnected: ${socket.id}, reason: ${reason}, user: ${socket.username || 'unknown'}`);
            removeUserConnection(socket.id);
        });
        
        // معالج خطأ الاتصال
        socket.on('error', (error) => {
            console.error(`Socket error on ${socket.id}:`, error);
            removeUserConnection(socket.id);
        });
        
        // معالج إغلاق الاتصال بواسطة العميل
        socket.on('client_disconnect', () => {
            console.log(`Client initiated disconnect for socket ${socket.id}`);
            removeUserConnection(socket.id);
            socket.disconnect();
        });
        
        // معالج pong من العميل (يتم التعامل معه في startServerPing)
        socket.on('client_pong', (data) => {
            // يتم معالجته في startServerPing
        });
    });
    
    // إرجاع الوظائف المطلوبة للاستخدام في middleware
    return {
        updateUserStatus,
        broadcastPresenceUpdate,
        getUserConnections: () => userConnections,
        getSocketUsers: () => socketUsers
    };
};
