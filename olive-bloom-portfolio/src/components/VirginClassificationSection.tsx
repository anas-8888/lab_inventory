import { motion, useInView } from "framer-motion";
import { useRef } from "react";
import { useLanguage } from "@/contexts/LanguageContext";
import {
  Carousel,
  CarouselContent,
  CarouselItem,
  CarouselNext,
  CarouselPrevious,
} from "@/components/ui/carousel";
import heroOil from "@/assets/hero-oil.jpg";
import oilPour from "@/assets/oil-pour.jpg";
import productImg from "@/assets/product.jpg";
import oliveImg from "@/assets/olive.png";

const items = [
  { key: "extra", image: heroOil },
  { key: "fine", image: oilPour },
  { key: "ordinary", image: productImg },
  { key: "unfit", image: oliveImg },
];

const Card = ({ itemKey, image }: { itemKey: string; image: string }) => {
  const { t } = useLanguage();

  return (
    <article className="flex h-full min-h-[520px] flex-col rounded-2xl border border-border/60 bg-background/80 shadow-sm backdrop-blur">
      <div className="relative h-48 overflow-hidden rounded-t-2xl">
        <img
          src={image}
          alt={t(`virgin.${itemKey}.imageAlt`)}
          className="h-full w-full object-cover"
        />
        <div className="absolute inset-0 bg-gradient-to-t from-black/40 via-black/10 to-transparent" />
      </div>
      <div className="flex-1 p-6 space-y-3">
        <p className="text-sm uppercase tracking-[0.25em] text-accent font-body">
          {t(`virgin.${itemKey}.label`)}
        </p>
        <h3 className="text-xl font-display text-foreground">
          {t(`virgin.${itemKey}.title`)}
        </h3>
        <p className="text-sm font-body text-muted-foreground leading-relaxed">
          {t(`virgin.${itemKey}.desc`)}
        </p>
      </div>
    </article>
  );
};

const VirginClassificationSection = () => {
  const { t, dir } = useLanguage();
  const ref = useRef(null);
  const inView = useInView(ref, { once: true, margin: "-100px" });

  return (
    <section className="section-padding bg-secondary/5" ref={ref}>
      <div className="max-w-7xl mx-auto">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.8 }}
          className="text-center mb-12"
        >
          <p className="text-sm tracking-[0.3em] uppercase text-accent font-body mb-4">
            {t("virgin.subtitle")}
          </p>
          <h2 className="text-3xl md:text-5xl font-display font-light text-foreground">
            {t("virgin.title")}
          </h2>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.8, delay: 0.1 }}
          className="max-w-4xl mx-auto text-center text-muted-foreground font-body leading-relaxed"
        >
          <p>{t("virgin.intro")}</p>
        </motion.div>

        <div className="mt-12 lg:hidden">
          <Carousel
            opts={{ align: "start", loop: true, direction: dir === "rtl" ? "rtl" : "ltr" }}
            className="relative"
          >
            <CarouselContent className="items-stretch">
              {items.map((item, index) => (
                <CarouselItem key={item.key} className="basis-full">
                  <motion.div
                    initial={{ opacity: 0, y: 20 }}
                    animate={inView ? { opacity: 1, y: 0 } : {}}
                    transition={{ duration: 0.8, delay: 0.15 + index * 0.1 }}
                    className="px-1 h-full"
                  >
                    <div className="h-full">
                      <Card itemKey={item.key} image={item.image} />
                    </div>
                  </motion.div>
                </CarouselItem>
              ))}
            </CarouselContent>
          </Carousel>
        </div>

        <div className="mt-12 hidden lg:grid gap-8 lg:grid-cols-4">
          {items.map((item, index) => (
            <motion.div
              key={item.key}
              initial={{ opacity: 0, y: 20 }}
              animate={inView ? { opacity: 1, y: 0 } : {}}
              transition={{ duration: 0.8, delay: 0.15 + index * 0.1 }}
            >
              <Card itemKey={item.key} image={item.image} />
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default VirginClassificationSection;
