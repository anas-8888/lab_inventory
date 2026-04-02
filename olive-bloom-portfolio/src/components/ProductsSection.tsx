import { motion, useInView } from "framer-motion";
import { useMemo, useRef, useState } from "react";
import { useLanguage } from "@/contexts/LanguageContext";
import { useSiteBranding } from "@/contexts/useSiteBranding";
import productFallback from "@/assets/product.jpg";
import { Swiper, SwiperSlide } from "swiper/react";
import { Navigation, Pagination } from "swiper/modules";
import "swiper/css";
import "swiper/css/navigation";
import "swiper/css/pagination";

type Localized = { ar?: string; en?: string };
type ProductItem = {
  id?: string;
  category?: Localized;
  name?: Localized;
  description?: Localized;
  features?: Localized | Localized[] | string | string[];
  category_ar?: string;
  category_en?: string;
  name_ar?: string;
  name_en?: string;
  description_ar?: string;
  description_en?: string;
  features_ar?: string | string[];
  features_en?: string | string[];
  acidity?: string;
  image_url?: string;
  image_raw?: string;
};
type ProductSection = {
  key?: string;
  name?: Localized;
  categories?: Localized[];
  items?: ProductItem[];
};

const sectionDefs = [
  { key: "olive_products", fallbackAr: "منتجات الزيتون", fallbackEn: "Olive Products", id: "products" },
  { key: "olive_oil", fallbackAr: "زيت الزيتون", fallbackEn: "Olive Oil", id: "products-oil" },
  { key: "agri_crops", fallbackAr: "المحاصيل الزراعية", fallbackEn: "Agricultural Crops", id: "products-crops" },
];

const pickText = (value: Localized | undefined, language: "ar" | "en", fallback = "") =>
  (language === "ar" ? value?.ar : value?.en) || (language === "ar" ? value?.en : value?.ar) || fallback;

const pickProductText = (
  item: ProductItem | undefined,
  baseKey: "category" | "name" | "description" | "features",
  language: "ar" | "en",
  fallback = "",
) => {
  if (!item) return fallback;
  const localized = item[baseKey] as Localized | undefined;
  const arKey = `${baseKey}_ar` as keyof ProductItem;
  const enKey = `${baseKey}_en` as keyof ProductItem;
  const arDirect = item[arKey] as string | undefined;
  const enDirect = item[enKey] as string | undefined;

  return (
    (language === "ar" ? localized?.ar : localized?.en) ||
    (language === "ar" ? arDirect : enDirect) ||
    (language === "ar" ? localized?.en : localized?.ar) ||
    (language === "ar" ? enDirect : arDirect) ||
    fallback
  );
};

const toFeatureList = (value: unknown) => {
  if (Array.isArray(value)) return value.map((x) => String(x || "").trim()).filter(Boolean);
  if (typeof value !== "string") return [];
  return value
    .split(/\r?\n|[|]/)
    .map((x) => x.trim())
    .filter(Boolean);
};

const productFeatures = (product: ProductItem | undefined, language: "ar" | "en") => {
  if (!product) return [];
  const fromLocalizedArray = Array.isArray(product.features)
    ? product.features
        .map((entry) => {
          if (typeof entry === "string") return entry.trim();
          if (!entry || typeof entry !== "object") return "";
          const localized =
            language === "ar"
              ? entry.ar || entry.en || ""
              : entry.en || entry.ar || "";
          return String(localized).trim();
        })
        .filter(Boolean)
    : [];

  const fromLocalizedSingle =
    product.features && !Array.isArray(product.features)
      ? toFeatureList(
          typeof product.features === "string"
            ? product.features
            : language === "ar"
              ? product.features.ar || product.features.en || ""
              : product.features.en || product.features.ar || "",
        )
      : [];

  const directFeatures =
    language === "ar"
      ? product.features_ar ?? product.features_en
      : product.features_en ?? product.features_ar;
  const localizedText = pickProductText(product, "features", language, "");

  return [
    ...fromLocalizedArray,
    ...fromLocalizedSingle,
    ...toFeatureList(localizedText),
    ...toFeatureList(directFeatures),
  ].filter((item, idx, arr) => item && arr.indexOf(item) === idx);
};

const categoryLabel = (product: ProductItem | undefined, language: "ar" | "en") =>
  pickProductText(product, "category", language, language === "ar" ? "غير مصنف" : "Uncategorized");

function SectionCarousel({
  section,
  sectionId,
  fallbackTitleAr,
  fallbackTitleEn,
}: {
  section: ProductSection;
  sectionId: string;
  fallbackTitleAr: string;
  fallbackTitleEn: string;
}) {
  const { language } = useLanguage();
  const ref = useRef(null);
  const inView = useInView(ref, { once: true, margin: "-100px" });

  const title = pickText(section?.name, language, language === "ar" ? fallbackTitleAr : fallbackTitleEn);
  const items = useMemo(() => (Array.isArray(section?.items) ? section.items : []), [section?.items]);

  const categoryOptions = useMemo(() => {
    const allCategories = Array.isArray(section?.categories) ? section.categories : [];
    const fromItems = items
      .map((item) => categoryLabel(item, language))
      .filter(Boolean);
    const fromSection = allCategories
      .map((cat) => pickText(cat, language, ""))
      .filter(Boolean);
    return Array.from(new Set([...fromSection, ...fromItems]));
  }, [section?.categories, items, language]);

  const [activeFilter, setActiveFilter] = useState<string>("__all__");

  const filteredItems =
    activeFilter === "__all__"
      ? items
      : items.filter((item) => categoryLabel(item, language) === activeFilter);

  return (
    <section id={sectionId} className="section-padding bg-secondary/20 overflow-hidden relative" ref={ref}>
      <div className="max-w-7xl mx-auto">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.8 }}
          className="text-center mb-16"
        >
          <p className="text-sm tracking-[0.3em] uppercase text-accent font-body mb-4">
            {language === "ar" ? "المنتجات" : "Products"}
          </p>
          <h2 className="text-3xl md:text-5xl font-display font-light text-foreground mb-4">{title}</h2>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.8, delay: 0.2 }}
          className="flex flex-wrap justify-center gap-3 mb-10"
        >
          <button
            onClick={() => setActiveFilter("__all__")}
            className={`px-4 py-2 rounded-full text-sm font-body transition-all duration-300 border ${
              activeFilter === "__all__"
                ? "bg-gradient-gold text-primary-foreground border-transparent shadow-lg shadow-gold/20"
                : "bg-background/60 text-foreground/80 border-border/50 hover:border-accent/30"
            }`}
          >
            {language === "ar" ? "الكل" : "All"}
          </button>
          {categoryOptions.map((cat) => (
            <button
              key={cat}
              onClick={() => setActiveFilter(cat)}
              className={`px-4 py-2 rounded-full text-sm font-body transition-all duration-300 border ${
                activeFilter === cat
                  ? "bg-gradient-gold text-primary-foreground border-transparent shadow-lg shadow-gold/20"
                  : "bg-background/60 text-foreground/80 border-border/50 hover:border-accent/30"
              }`}
            >
              {cat}
            </button>
          ))}
        </motion.div>

        {!filteredItems.length ? (
          <div className="text-center text-muted-foreground font-body">
            {language === "ar" ? "لا توجد منتجات ضمن هذا القسم حالياً." : "No products found in this section yet."}
          </div>
        ) : (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={inView ? { opacity: 1, y: 0 } : {}}
            transition={{ duration: 0.8, delay: 0.3 }}
            className="relative"
          >
            <Swiper
              className="products-swiper"
              modules={[Navigation, Pagination]}
              loop={filteredItems.length > 1}
              grabCursor
              centeredSlides
              spaceBetween={32}
              navigation
              pagination={{ clickable: true, dynamicBullets: true }}
              slidesPerView={3}
              breakpoints={{
                0: { slidesPerView: 1 },
                640: { slidesPerView: 2 },
                1024: { slidesPerView: 3 },
              }}
            >
              {filteredItems.map((product, index) => {
                const imageSrc = product?.image_url || product?.image_raw || productFallback;
                const itemName = pickProductText(product, "name", language, language === "ar" ? "منتج" : "Product");
                const itemDesc = pickProductText(product, "description", language, "");
                const itemCategory = categoryLabel(product, language);
                const itemFeatures = productFeatures(product, language);
                return (
                  <SwiperSlide key={`${product?.id || "item"}-${index}`}>
                    <div className="group relative bg-background rounded-3xl border border-border/50 overflow-hidden h-full">
                      <div className="relative aspect-[5/6] overflow-hidden">
                        <img src={imageSrc} alt={itemName} className="w-full h-full object-cover" />
                        <div className="absolute inset-0 bg-gradient-to-t from-background via-transparent to-transparent" />
                        <div className="absolute bottom-4 left-4">
                          <span className="bg-gradient-gold text-primary-foreground text-xs font-body tracking-wider uppercase px-4 py-1.5 rounded-full">
                            {itemCategory}
                          </span>
                        </div>
                      </div>

                      <div className="p-4">
                        <h3 className="text-lg md:text-xl font-display font-semibold text-foreground mb-2">{itemName}</h3>
                      </div>

                      <div className="pointer-events-none absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity duration-300 bg-black/65 p-5 flex flex-col justify-end text-white">
                        <h4 className="text-base md:text-lg font-display font-semibold mb-2">{itemName}</h4>
                        <p className="font-body text-sm leading-relaxed mb-3 line-clamp-4">{itemDesc || (language === "ar" ? "لا يوجد وصف." : "No description available.")}</p>
                        {itemFeatures.length > 0 && (
                          <ul className="space-y-1 text-xs md:text-sm font-body">
                            {itemFeatures.slice(0, 4).map((feature, featureIdx) => (
                              <li key={`${feature}-${featureIdx}`} className="flex items-start gap-2">
                                <span className="mt-1 inline-block h-1.5 w-1.5 rounded-full bg-gold" />
                                <span>{feature}</span>
                              </li>
                            ))}
                          </ul>
                        )}
                      </div>
                    </div>
                  </SwiperSlide>
                );
              })}
            </Swiper>
          </motion.div>
        )}
      </div>
    </section>
  );
}

const ProductsSection = () => {
  const { productSections } = useSiteBranding();
  const sections = productSections as Record<string, ProductSection>;

  return (
    <>
      {sectionDefs.map((def) => (
        <SectionCarousel
          key={def.key}
          section={sections?.[def.key] || {}}
          sectionId={def.id}
          fallbackTitleAr={def.fallbackAr}
          fallbackTitleEn={def.fallbackEn}
        />
      ))}
    </>
  );
};

export default ProductsSection;
