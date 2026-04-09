const CACHE_VERSION = "v1";
const IMAGE_CACHE = `image-cache-${CACHE_VERSION}`;
const MAX_IMAGE_ENTRIES = 80;

const isImageRequest = (request) =>
  request.destination === "image";

const trimCache = async (cache, maxEntries) => {
  const keys = await cache.keys();
  if (keys.length <= maxEntries) return;
  await cache.delete(keys[0]);
  await trimCache(cache, maxEntries);
};

self.addEventListener("install", (event) => {
  self.skipWaiting();
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    (async () => {
      const cacheNames = await caches.keys();
      await Promise.all(
        cacheNames.map((name) => {
          if (name.startsWith("image-cache-") && name !== IMAGE_CACHE) {
            return caches.delete(name);
          }
          return undefined;
        }),
      );
      await self.clients.claim();
    })(),
  );
});

self.addEventListener("fetch", (event) => {
  const { request } = event;
  if (request.method !== "GET") return;
  if (!isImageRequest(request)) return;

  event.respondWith(
    (async () => {
      const cache = await caches.open(IMAGE_CACHE);
      const cached = await cache.match(request);
      if (cached) {
        event.waitUntil(
          (async () => {
            try {
              const response = await fetch(request);
              if (response && response.ok) {
                await cache.put(request, response.clone());
                await trimCache(cache, MAX_IMAGE_ENTRIES);
              }
            } catch (_) {
              // Ignore background refresh errors.
            }
          })(),
        );
        return cached;
      }

      const response = await fetch(request);
      if (response && response.ok) {
        await cache.put(request, response.clone());
        await trimCache(cache, MAX_IMAGE_ENTRIES);
      }
      return response;
    })(),
  );
});
