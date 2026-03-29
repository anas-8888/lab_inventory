import { motion, useInView } from "framer-motion";
import { useRef } from "react";
import { useLanguage } from "@/contexts/LanguageContext";
import oliveGrove from "@/assets/olive-grove.jpg";
import oilPour from "@/assets/oil-pour.jpg";

const AboutSection = () => {
  const { t } = useLanguage();
  const ref = useRef(null);
  const inView = useInView(ref, { once: true, margin: "-100px" });

  const stats = [
    { num: t("about.stat1.number"), label: t("about.stat1.label") },
    { num: t("about.stat2.number"), label: t("about.stat2.label") },
    { num: t("about.stat3.number"), label: t("about.stat3.label") },
  ];

  return (
    <>
      <section id="about" className="section-padding bg-background overflow-hidden" ref={ref}>
        <div className="max-w-7xl mx-auto">
        {/* Header */}
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.8 }}
          className="text-center mb-20"
        >
          <p className="text-sm tracking-[0.3em] uppercase text-accent font-body mb-4">
            {t("about.subtitle")}
          </p>
          <h2 className="text-3xl md:text-5xl font-display font-light text-foreground">
            {t("about.title")}
          </h2>
        </motion.div>

        {/* Content grid */}
        <div className="grid lg:grid-cols-2 gap-16 items-center mb-20">
          {/* Images */}
          <motion.div
            initial={{ opacity: 0, x: -50 }}
            animate={inView ? { opacity: 1, x: 0 } : {}}
            transition={{ duration: 1, delay: 0.2 }}
            className="relative"
          >
            <div className="relative">
              <img
                src={oliveGrove}
                alt="Mediterranean olive grove"
                className="w-full h-80 object-cover rounded-2xl"
              />
              <motion.div
                className="absolute -bottom-8 -right-4 md:-right-8 w-48 h-48 md:w-56 md:h-56 rounded-2xl overflow-hidden shadow-2xl border-4 border-background"
                initial={{ scale: 0.8, opacity: 0 }}
                animate={inView ? { scale: 1, opacity: 1 } : {}}
                transition={{ duration: 0.8, delay: 0.5 }}
              >
                <img
                  src={oilPour}
                  alt="Premium olive oil"
                  className="w-full h-full object-cover"
                />
              </motion.div>
            </div>
          </motion.div>

          {/* Text */}
          <motion.div
            initial={{ opacity: 0, x: 50 }}
            animate={inView ? { opacity: 1, x: 0 } : {}}
            transition={{ duration: 1, delay: 0.3 }}
          >
            <p className="text-lg font-body text-foreground/80 leading-relaxed mb-6">
              {t("about.p1")}
            </p>
            <p className="text-lg font-body text-foreground/80 leading-relaxed mb-10">
              {t("about.p2")}
            </p>
            <div className="h-px bg-gradient-to-r from-accent/50 to-transparent mb-10" />
          </motion.div>
        </div>

        {/* Stats */}
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.8, delay: 0.6 }}
          className="grid grid-cols-3 gap-8"
        >
          {stats.map((stat, i) => (
            <div key={i} className="text-center">
              <p className="text-3xl md:text-5xl font-display font-semibold text-gradient-gold mb-2">
                {stat.num}
              </p>
              <p className="text-sm font-body text-muted-foreground tracking-wide">
                {stat.label}
              </p>
            </div>
          ))}
        </motion.div>

        </div>
      </section>

      <section className="section-padding bg-secondary/10 overflow-hidden">
        <div className="max-w-7xl mx-auto">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={inView ? { opacity: 1, y: 0 } : {}}
            transition={{ duration: 0.8, delay: 0.2 }}
            className="grid lg:grid-cols-2 gap-10 items-center"
          >
            <div>
              <h3 className="text-2xl md:text-3xl font-display font-light text-foreground mb-4">
                {t("about.culture.title")}
              </h3>
              <p className="text-base md:text-lg font-body text-foreground/70 leading-relaxed mb-4">
                {t("about.culture.body")}
              </p>
              <div className="space-y-4 text-sm md:text-base font-body text-foreground/70 leading-relaxed">
                <p>{t("about.culture.p1")}</p>
                <p>{t("about.culture.p2")}</p>
                <p>{t("about.culture.p3")}</p>
                <p>{t("about.culture.p4")}</p>
              </div>
            </div>
            <div className="relative">
              <img
                src={oliveGrove}
                alt="Olive heritage"
                className="w-full h-72 md:h-80 object-cover rounded-2xl"
              />
              <div className="absolute inset-0 rounded-2xl ring-1 ring-foreground/10" />
            </div>
          </motion.div>
        </div>
      </section>
    </>
  );
};

export default AboutSection;
