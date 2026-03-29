import { motion, useInView } from "framer-motion";
import { useRef, useState } from "react";
import { useLanguage } from "@/contexts/LanguageContext";
import { Droplets, Leaf, Award, Star } from "lucide-react";
import productsImg from "@/assets/products-lineup.jpg";
import productImg from "@/assets/product.jpg";
import { Swiper, SwiperSlide } from "swiper/react";
import { Navigation, Pagination } from "swiper/modules";
import "swiper/css";
import "swiper/css/navigation";
import "swiper/css/pagination";

const products = [
  {
    key: "1",
    icon: Droplets,
    category: "premium" as const,
    image: productsImg,
    features: ["products.1.f1", "products.1.f2", "products.1.f3"],
    acidity: "<= 0.8%",
    rating: 5,
  },
  {
    key: "2",
    icon: Leaf,
    category: "virgin" as const,
    image: productImg,
    features: ["products.2.f1", "products.2.f2", "products.2.f3"],
    acidity: "<= 2%",
    rating: 4,
  },
  {
    key: "3",
    icon: Award,
    category: "organic" as const,
    image: productsImg,
    features: ["products.3.f1", "products.3.f2", "products.3.f3"],
    acidity: "<= 0.5%",
    rating: 5,
  },
  {
    key: "4",
    icon: Star,
    category: "premium" as const,
    image: productImg,
    features: ["products.4.f1", "products.4.f2", "products.4.f3"],
    acidity: "<= 0.7%",
    rating: 5,
  },
  {
    key: "5",
    icon: Leaf,
    category: "virgin" as const,
    image: productsImg,
    features: ["products.5.f1", "products.5.f2", "products.5.f3"],
    acidity: "<= 1.8%",
    rating: 4,
  },
  {
    key: "6",
    icon: Award,
    category: "organic" as const,
    image: productImg,
    features: ["products.6.f1", "products.6.f2", "products.6.f3"],
    acidity: "<= 0.6%",
    rating: 5,
  },
];

type FilterKey = "all" | "premium" | "virgin" | "organic";

type ProductsCarouselSectionProps = {
  id: string;
  subtitleKey: string;
  titleKey: string;
  introKey: string;
};

const ProductsCarouselSection = ({
  id,
  subtitleKey,
  titleKey,
  introKey,
}: ProductsCarouselSectionProps) => {
  const { t } = useLanguage();
  const ref = useRef(null);
  const inView = useInView(ref, { once: true, margin: "-100px" });
  const [activeFilter, setActiveFilter] = useState<FilterKey>("all");

  const filters = [
    { key: "all" as const, label: t("products.filter.all") },
    { key: "premium" as const, label: t("products.filter.premium") },
    { key: "virgin" as const, label: t("products.filter.virgin") },
    { key: "organic" as const, label: t("products.filter.organic") },
  ];

  const filteredProducts =
    activeFilter === "all"
      ? products
      : products.filter((p) => p.category === activeFilter);

  return (
    <section
      id={id}
      className="section-padding bg-secondary/20 overflow-hidden relative"
      ref={ref}
    >
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.8 }}
          className="text-center mb-16"
        >
          <p className="text-sm tracking-[0.3em] uppercase text-accent font-body mb-4">
            {t(subtitleKey)}
          </p>
          <h2 className="text-3xl md:text-5xl font-display font-light text-foreground mb-4">
            {t(titleKey)}
          </h2>
          <p className="text-muted-foreground font-body max-w-2xl mx-auto">
            {t(introKey)}
          </p>
        </motion.div>

        {/* Filters */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.8, delay: 0.2 }}
          className="flex flex-wrap justify-center gap-3 mb-10"
        >
          {filters.map((filter) => (
            <button
              key={filter.key}
              onClick={() => setActiveFilter(filter.key)}
              className={`px-4 py-2 rounded-full text-sm font-body transition-all duration-300 border ${
                activeFilter === filter.key
                  ? "bg-gradient-gold text-primary-foreground border-transparent shadow-lg shadow-gold/20"
                  : "bg-background/60 text-foreground/80 border-border/50 hover:border-accent/30"
              }`}
            >
              {filter.label}
            </button>
          ))}
        </motion.div>

        {/* Swiper */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.8, delay: 0.3 }}
          className="relative"
        >
          <Swiper
            className="products-swiper"
            modules={[Navigation, Pagination]}
            loop={filteredProducts.length > 1}
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
            {filteredProducts.map((product) => {
              const Icon = product.icon;
              return (
                <SwiperSlide key={product.key}>
                  <div className="bg-background rounded-3xl border border-border/50 overflow-hidden h-full">
                    <div className="relative aspect-square overflow-hidden">
                      <img
                        src={product.image}
                        alt={t(`products.${product.key}.name`)}
                        className="w-full h-full object-cover"
                      />
                      <div className="absolute inset-0 bg-gradient-to-t from-background via-transparent to-transparent" />
                      <div className="absolute top-4 left-4">
                        <div className="w-11 h-11 rounded-xl flex items-center justify-center bg-gradient-gold">
                          <Icon className="w-5 h-5 text-primary-foreground" />
                        </div>
                      </div>
                      <div className="absolute bottom-4 left-4">
                        <span className="bg-gradient-gold text-primary-foreground text-xs font-body tracking-wider uppercase px-4 py-1.5 rounded-full">
                          {t("products.premium")}
                        </span>
                      </div>
                    </div>

                    <div className="p-4">
                      <h3 className="text-lg md:text-xl font-display font-semibold text-foreground mb-2">
                        {t(`products.${product.key}.name`)}
                      </h3>
                      <p className="font-body text-muted-foreground leading-relaxed mb-4 line-clamp-1 text-sm">
                        {t(`products.${product.key}.desc`)}
                      </p>
                    </div>
                  </div>
                </SwiperSlide>
              );
            })}
          </Swiper>
        </motion.div>
      </div>
    </section>
  );
};

const ProductsSection = () => {
  return (
    <>
      <ProductsCarouselSection
        id="products"
        subtitleKey="products.subtitle"
        titleKey="products.title"
        introKey="products.intro"
      />
      <ProductsCarouselSection
        id="products-oil"
        subtitleKey="productsOil.subtitle"
        titleKey="productsOil.title"
        introKey="productsOil.intro"
      />
      <ProductsCarouselSection
        id="products-crops"
        subtitleKey="productsCrops.subtitle"
        titleKey="productsCrops.title"
        introKey="productsCrops.intro"
      />
    </>
  );
};

export default ProductsSection;
