import { motion, useInView } from "framer-motion";
import { useMemo, useRef, useState } from "react";
import { useLanguage } from "@/contexts/LanguageContext";
import { useSiteBranding } from "@/contexts/useSiteBranding";
import { Droplets, Leaf, Award, Star } from "lucide-react";
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

const ICONS = [Droplets, Leaf, Award, Star];

const sectionDefs = [
  { key: "olive_products", fallbackAr: "منتجات الزيتون", fallbackEn: "Olive Products", id: "products" },
  { key: "olive_oil", fallbackAr: "زيت الزيتون", fallbackEn: "Olive Oil", id: "products-oil" },
  { key: "agri_crops", fallbackAr: "المحاصيل الزراعية", fallbackEn: "Agricultural Crops", id: "products-crops" },
];

const pickText = (value: Localized | undefined, language: "ar" | "en", fallback = "") =>
  (language === "ar" ? value?.ar : value?.en) || (language === "ar" ? value?.en : value?.ar) || fallback;

const categoryLabel = (category: Localized | undefined, language: "ar" | "en") =>
  pickText(category, language, language === "ar" ? "غير مصنف" : "Uncategorized");

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
      .map((item) => categoryLabel(item?.category, language))
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
      : items.filter((item) => categoryLabel(item?.category, language) === activeFilter);

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
                const Icon = ICONS[index % ICONS.length];
                const imageSrc = product?.image_url || product?.image_raw || productFallback;
                const itemName = pickText(product?.name, language, language === "ar" ? "منتج" : "Product");
                const itemDesc = pickText(product?.description, language, "");
                const itemCategory = categoryLabel(product?.category, language);
                return (
                  <SwiperSlide key={`${product?.id || "item"}-${index}`}>
                    <div className="bg-background rounded-3xl border border-border/50 overflow-hidden h-full">
                      <div className="relative aspect-square overflow-hidden">
                        <img src={imageSrc} alt={itemName} className="w-full h-full object-cover" />
                        <div className="absolute inset-0 bg-gradient-to-t from-background via-transparent to-transparent" />
                        <div className="absolute top-4 left-4">
                          <div className="w-11 h-11 rounded-xl flex items-center justify-center bg-gradient-gold">
                            <Icon className="w-5 h-5 text-primary-foreground" />
                          </div>
                        </div>
                        <div className="absolute bottom-4 left-4">
                          <span className="bg-gradient-gold text-primary-foreground text-xs font-body tracking-wider uppercase px-4 py-1.5 rounded-full">
                            {itemCategory}
                          </span>
                        </div>
                      </div>

                      <div className="p-4">
                        <h3 className="text-lg md:text-xl font-display font-semibold text-foreground mb-2">{itemName}</h3>
                        <p className="font-body text-muted-foreground leading-relaxed mb-3 line-clamp-2 text-sm">{itemDesc || "-"}</p>
                        {!!product?.acidity && (
                          <p className="font-body text-xs text-foreground/70">
                            {language === "ar" ? "الحموضة:" : "Acidity:"} <span className="font-semibold">{product.acidity}</span>
                          </p>
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
