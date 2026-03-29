import { motion, useInView, useScroll, useTransform } from "framer-motion";
import { useRef } from "react";
import { useLanguage } from "@/contexts/LanguageContext";
import productionImg from "@/assets/production.jpg";

const steps = ["step1", "step2", "step3", "step4"];

const ProductionSection = () => {
  const { t } = useLanguage();
  const ref = useRef(null);
  const inView = useInView(ref, { once: true, margin: "-100px" });
  const timelineRef = useRef<HTMLDivElement>(null);

  const { scrollYProgress } = useScroll({
    target: timelineRef,
    offset: ["start 0.65", "end 0.45"],
  });

  const lineScaleY = useTransform(scrollYProgress, [0, 1], [0, 1]);

  // Each step activates at these thresholds
  const step1Active = useTransform(scrollYProgress, (v: number) => v >= 0);
  const step2Active = useTransform(scrollYProgress, (v: number) => v >= 0.33);
  const step3Active = useTransform(scrollYProgress, (v: number) => v >= 0.66);
  const step4Active = useTransform(scrollYProgress, (v: number) => v >= 0.95);
  const activeStates = [step1Active, step2Active, step3Active, step4Active];

  return (
    <section id="production" className="section-padding bg-background overflow-hidden" ref={ref}>
      <div className="max-w-7xl mx-auto">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.8 }}
          className="text-center mb-16"
        >
          <p className="text-sm tracking-[0.3em] uppercase text-accent font-body mb-4">
            {t("production.subtitle")}
          </p>
          <h2 className="text-3xl md:text-5xl font-display font-light text-foreground">
            {t("production.title")}
          </h2>
        </motion.div>

        <div className="grid lg:grid-cols-2 gap-16 items-center">
          {/* Steps with animated connecting line */}
          <div ref={timelineRef} className="relative">
            {/* Static background track */}
            <div
              className="absolute w-[2px] bg-border/30 rounded-full left-[23px] rtl:left-auto rtl:right-[23px]"
              style={{ top: "24px", bottom: "24px" }}
            />
            {/* Animated gold fill */}
            <motion.div
              className="absolute w-[2px] rounded-full origin-top left-[23px] rtl:left-auto rtl:right-[23px]"
              style={{
                top: "24px",
                bottom: "24px",
                scaleY: lineScaleY,
                background: "linear-gradient(to bottom, hsl(var(--gold)), hsl(var(--gold-light)))",
              }}
            />

            <div className="flex flex-col">
              {steps.map((step, i) => (
                <motion.div
                  key={step}
                  initial={{ opacity: 0, x: -30 }}
                  animate={inView ? { opacity: 1, x: 0 } : {}}
                  transition={{ duration: 0.6, delay: 0.2 + i * 0.15 }}
                  className="relative flex gap-6"
                >
                  {/* Circle */}
                  <StepCircle index={i} isActive={activeStates[i]} />

                  {/* Text content */}
                  <div className={i < steps.length - 1 ? "pb-14 pt-1" : "pt-1"}>
                    <h3 className="text-xl font-display font-semibold text-foreground mb-2">
                      {t(`production.${step}.title`)}
                    </h3>
                    <p className="font-body text-muted-foreground leading-relaxed">
                      {t(`production.${step}.desc`)}
                    </p>
                  </div>
                </motion.div>
              ))}
            </div>
          </div>

          {/* Image */}
          <motion.div
            initial={{ opacity: 0, x: 50 }}
            animate={inView ? { opacity: 1, x: 0 } : {}}
            transition={{ duration: 1, delay: 0.4 }}
            className="relative"
          >
            <div className="relative aspect-square overflow-hidden bg-secondary/10">
              <img
                src={productionImg}
                alt="Olive oil production facility"
                className="w-full h-full object-contain"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-primary/30 to-transparent" />
            </div>
          </motion.div>
        </div>
      </div>
    </section>
  );
};

function StepCircle({ index, isActive }: { index: number; isActive: any }) {
  const bg = useTransform(isActive, (active: boolean) =>
    active
      ? "linear-gradient(135deg, hsl(var(--gold)), hsl(var(--gold-light)))"
      : "hsl(var(--secondary))"
  );
  const color = useTransform(isActive, (active: boolean) =>
    active ? "hsl(var(--primary-foreground))" : "hsl(var(--muted-foreground))"
  );
  const borderColor = useTransform(isActive, (active: boolean) =>
    active ? "transparent" : "hsl(var(--border))"
  );

  return (
    <motion.div
      className="relative z-10 w-12 h-12 rounded-full flex items-center justify-center font-display text-lg font-semibold shrink-0 border-2"
      style={{
        background: bg,
        color,
        borderColor,
      }}
    >
      {index + 1}
    </motion.div>
  );
}

export default ProductionSection;
