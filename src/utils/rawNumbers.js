function isRawNumericString(value) {
    if (typeof value !== 'string') return false;
    const trimmed = value.trim();
    if (!trimmed) return false;
    return /^-?\d+(?:\.\d+)?$/.test(trimmed);
}

function normalizeRawNumeric(value) {
    if (value === null || value === undefined) return null;
    if (typeof value === 'number') {
        if (!Number.isFinite(value)) return null;
        return String(value);
    }
    if (typeof value !== 'string') return null;
    const trimmed = value.trim();
    if (!isRawNumericString(trimmed)) return null;
    return trimmed;
}

function buildRawNumericMap(source, fields) {
    const result = {};
    if (!source || !Array.isArray(fields)) return result;
    fields.forEach((field) => {
        const raw = normalizeRawNumeric(source[field]);
        if (raw !== null) {
            result[field] = raw;
        }
    });
    return result;
}

function parseRawNumericMap(value) {
    if (!value) return {};
    if (typeof value === 'object' && !Array.isArray(value)) return value;
    if (typeof value !== 'string') return {};
    const trimmed = value.trim();
    if (!trimmed) return {};
    try {
        const parsed = JSON.parse(trimmed);
        if (parsed && typeof parsed === 'object' && !Array.isArray(parsed)) {
            return parsed;
        }
    } catch (_) {
        return {};
    }
    return {};
}

function rawOrValue(rawMap, field, fallbackValue) {
    if (rawMap && Object.prototype.hasOwnProperty.call(rawMap, field) && rawMap[field] !== null && rawMap[field] !== undefined) {
        return rawMap[field];
    }
    return fallbackValue;
}

module.exports = {
    isRawNumericString,
    normalizeRawNumeric,
    buildRawNumericMap,
    parseRawNumericMap,
    rawOrValue
};
