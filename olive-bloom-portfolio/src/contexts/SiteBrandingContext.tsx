import { useEffect, useMemo, useState } from "react";
import { SiteBrandingContext } from "@/contexts/siteBrandingContext.shared";

const BRANDING_CACHE_KEY = "site_branding_cache_v1";

const readBrandingCache = () => {
  if (typeof window === "undefined") return { logoUrl: "", iconUrl: "" };
  try {
    const raw = window.localStorage.getItem(BRANDING_CACHE_KEY);
    if (!raw) return { logoUrl: "", iconUrl: "" };
    const parsed = JSON.parse(raw) as { logoUrl?: string; iconUrl?: string };
    return {
      logoUrl: typeof parsed?.logoUrl === "string" ? parsed.logoUrl : "",
      iconUrl: typeof parsed?.iconUrl === "string" ? parsed.iconUrl : "",
    };
  } catch {
    return { logoUrl: "", iconUrl: "" };
  }
};

const writeBrandingCache = (logoUrl: string, iconUrl: string) => {
  if (typeof window === "undefined") return;
  try {
    window.localStorage.setItem(BRANDING_CACHE_KEY, JSON.stringify({ logoUrl, iconUrl }));
  } catch {
    // Ignore storage write issues.
  }
};

const apiBase = (import.meta.env.VITE_SITE_API_BASE_URL || "http://localhost:3000").replace(/\/+$/, "");

const toAbsoluteUrl = (value: unknown) => {
  const raw = typeof value === "string" ? value.trim() : "";
  if (!raw) return "";
  if (/^https?:\/\//i.test(raw) || raw.startsWith("data:") || raw.startsWith("blob:")) return raw;
  if (raw.startsWith("/")) return `${apiBase}${raw}`;
  return `${apiBase}/${raw}`;
};

const upsertFavicon = (iconUrl: string) => {
  if (!iconUrl) return;
  let link = document.querySelector<HTMLLinkElement>('link[rel="icon"]');
  if (!link) {
    link = document.createElement("link");
    link.setAttribute("rel", "icon");
    document.head.appendChild(link);
  }
  link.setAttribute("href", iconUrl);
};

export const SiteBrandingProvider = ({ children }: { children: React.ReactNode }) => {
  const [logoUrl, setLogoUrl] = useState(() => readBrandingCache().logoUrl);
  const [iconUrl, setIconUrl] = useState(() => readBrandingCache().iconUrl);
  const [productSections, setProductSections] = useState<Record<string, unknown>>({});

  useEffect(() => {
    const controller = new AbortController();

    const load = async () => {
      try {
        const [logoRes, iconRes, categoriesRes, productsRes] = await Promise.all([
          fetch(`${apiBase}/site-management/public/logo`, { signal: controller.signal }),
          fetch(`${apiBase}/site-management/public/icon`, { signal: controller.signal }),
          fetch(`${apiBase}/site-management/public/categories`, { signal: controller.signal }),
          fetch(`${apiBase}/site-management/public/products`, { signal: controller.signal }),
        ]);

        const [logoPayload, iconPayload, categoriesPayload, productsPayload] = await Promise.all([
          logoRes.ok ? logoRes.json() : Promise.resolve(null),
          iconRes.ok ? iconRes.json() : Promise.resolve(null),
          categoriesRes.ok ? categoriesRes.json() : Promise.resolve(null),
          productsRes.ok ? productsRes.json() : Promise.resolve(null),
        ]);

        const nextLogo = toAbsoluteUrl(logoPayload?.data?.logo_url || logoPayload?.data?.logo_raw);
        const nextIcon = toAbsoluteUrl(iconPayload?.data?.icon_url || iconPayload?.data?.icon_raw);
        setLogoUrl(nextLogo);
        setIconUrl(nextIcon);
        writeBrandingCache(nextLogo, nextIcon);

        const categoriesSections = categoriesPayload?.data?.sections;
        const productsSections = productsPayload?.data?.sections;

        if (productsSections && typeof productsSections === "object") {
          const mergedSections: Record<string, unknown> = {};
          Object.entries(productsSections as Record<string, unknown>).forEach(([key, raw]) => {
            const productSection = raw as Record<string, unknown>;
            const categorySection = ((categoriesSections && typeof categoriesSections === "object")
              ? (categoriesSections as Record<string, unknown>)[key]
              : null) as Record<string, unknown> | null;

            mergedSections[key] = {
              ...productSection,
              categories: Array.isArray(categorySection?.categories)
                ? categorySection?.categories
                : (productSection?.categories as unknown[] | undefined) || [],
            };
          });
          setProductSections(mergedSections);
        }
      } catch {
        // Keep fallback branding from static assets on any failure.
      }
    };

    load();
    return () => controller.abort();
  }, []);

  useEffect(() => {
    if (!iconUrl) return;
    upsertFavicon(iconUrl);
  }, [iconUrl]);

  const value = useMemo(
    () => ({
      logoUrl,
      iconUrl,
      productSections,
    }),
    [logoUrl, iconUrl, productSections],
  );

  return <SiteBrandingContext.Provider value={value}>{children}</SiteBrandingContext.Provider>;
};
