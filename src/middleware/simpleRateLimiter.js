const buckets = new Map();

function getClientIp(req) {
  const forwardedFor = String(req.headers['x-forwarded-for'] || '').trim();
  if (forwardedFor) return forwardedFor.split(',')[0].trim();
  return String(req.ip || req.connection?.remoteAddress || req.socket?.remoteAddress || 'unknown');
}

function createRateLimiter(options = {}) {
  const windowMs = Number(options.windowMs) > 0 ? Number(options.windowMs) : 60_000;
  const max = Number(options.max) > 0 ? Number(options.max) : 60;
  const keyPrefix = String(options.keyPrefix || 'default');
  const message = String(options.message || 'Too many requests, please try again later.');

  return (req, res, next) => {
    const now = Date.now();
    const ip = getClientIp(req);
    const key = `${keyPrefix}:${ip}`;
    const existing = buckets.get(key);

    if (!existing || now > existing.resetAt) {
      const nextBucket = { count: 1, resetAt: now + windowMs };
      buckets.set(key, nextBucket);
      res.setHeader('X-RateLimit-Limit', String(max));
      res.setHeader('X-RateLimit-Remaining', String(max - 1));
      res.setHeader('X-RateLimit-Reset', String(Math.ceil(nextBucket.resetAt / 1000)));
      return next();
    }

    existing.count += 1;
    const remaining = Math.max(max - existing.count, 0);
    res.setHeader('X-RateLimit-Limit', String(max));
    res.setHeader('X-RateLimit-Remaining', String(remaining));
    res.setHeader('X-RateLimit-Reset', String(Math.ceil(existing.resetAt / 1000)));

    if (existing.count > max) {
      return res.status(429).json({
        success: false,
        message
      });
    }

    return next();
  };
}

module.exports = {
  createRateLimiter
};
