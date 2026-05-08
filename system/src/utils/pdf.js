async function generatePdfWithMetrics(pdfLib, file, options, label = 'pdf') {
    if (!pdfLib || typeof pdfLib.generatePdf !== 'function') {
        throw new Error('Invalid PDF library: generatePdf is not available');
    }

    const startedAt = Date.now();
    try {
        const buffer = await pdfLib.generatePdf(file, options);
        const durationMs = Date.now() - startedAt;
        const bytes = Buffer.isBuffer(buffer) ? buffer.length : 0;
        console.log(`[PDF] ${label} success duration=${durationMs}ms bytes=${bytes}`);
        return buffer;
    } catch (error) {
        const durationMs = Date.now() - startedAt;
        console.error(`[PDF] ${label} failed duration=${durationMs}ms`, error);
        throw error;
    }
}

module.exports = {
    generatePdfWithMetrics
};
