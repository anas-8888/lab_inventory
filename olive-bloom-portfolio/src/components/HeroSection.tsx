import { motion } from "framer-motion";
import { useLanguage } from "@/contexts/LanguageContext";
import { ChevronDown } from "lucide-react";
import heroImg from "@/assets/hero-oil.jpg";

const HeroSection = () => {
  const { t } = useLanguage();

  const handleScrollToProducts = () => {
    const el = document.getElementById("products");
    if (el) {
      el.scrollIntoView({ behavior: "smooth" });
    }
  };

  const handleScrollToAbout = () => {
    const el = document.getElementById("about");
    if (el) {
      el.scrollIntoView({ behavior: "smooth" });
    }
  };

  const handleScrollDown = () => {
    const el = document.getElementById("about");
    if (el) {
      el.scrollIntoView({ behavior: "smooth" });
    }
  };

  return (
    <section id="home" className="relative min-h-screen flex items-center overflow-hidden">
      {/* Background image with overlay */}
      <div className="absolute inset-0">
        <img
          src={heroImg}
          alt="Premium Olive Oil"
          className="w-full h-full object-cover"
        />
        <div className="absolute inset-0 bg-gradient-to-r from-primary/95 via-primary/75 to-primary/50" />
        <div className="absolute inset-0 bg-gradient-to-t from-primary/60 via-transparent to-primary/30" />
      </div>

      {/* Floating organic shapes */}
      <motion.div
        className="absolute top-20 right-10 w-64 h-64 rounded-full bg-gold/5 blur-3xl"
        animate={{ y: [0, -30, 0], scale: [1, 1.1, 1] }}
        transition={{ duration: 8, repeat: Infinity, ease: "easeInOut" }}
      />
      <motion.div
        className="absolute bottom-20 left-10 w-96 h-96 rounded-full bg-gold-light/5 blur-3xl"
        animate={{ y: [0, 20, 0], scale: [1, 1.05, 1] }}
        transition={{ duration: 10, repeat: Infinity, ease: "easeInOut" }}
      />

      {/* Content */}
      <div className="relative z-10 section-padding max-w-7xl mx-auto w-full">
        <div className="max-w-2xl">
          <motion.h1
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 1, delay: 3.2 }}
            className="text-3xl md:text-5xl lg:text-6xl font-display font-light leading-tight text-primary-foreground mb-8"
          >
            {t("hero.title")}
          </motion.h1>

          <motion.p
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 3.5 }}
            className="text-lg md:text-xl text-primary-foreground/70 font-body font-light leading-relaxed mb-12 max-w-lg"
          >
            {t("hero.description")}
          </motion.p>

          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 3.8 }}
            className="flex flex-wrap gap-4"
          >
            <button
              onClick={handleScrollToProducts}
              className="bg-gradient-gold text-primary-foreground px-8 py-3.5 font-body text-sm tracking-wider uppercase rounded-full hover:shadow-lg hover:shadow-gold/20 transition-all duration-500"
            >
              {t("hero.cta")}
            </button>
            <button
              onClick={handleScrollToAbout}
              className="border border-primary-foreground/30 text-primary-foreground px-8 py-3.5 font-body text-sm tracking-wider uppercase rounded-full hover:bg-primary-foreground/10 transition-all duration-500"
            >
              {t("hero.cta2")}
            </button>
          </motion.div>
        </div>
      </div>

      {/* Scroll indicator */}
      <motion.button
        onClick={handleScrollDown}
        className="absolute bottom-8 left-1/2 cursor-pointer z-20"
        style={{ x: "-50%" }}
        animate={{ y: [0, 10, 0] }}
        transition={{ duration: 2, repeat: Infinity }}
        aria-label="Scroll down"
      >
        <div className="w-10 h-14 border-2 border-primary-foreground/40 rounded-full flex flex-col items-center justify-center gap-1 hover:border-gold-light/60 transition-colors">
          <motion.div
            className="w-1.5 h-1.5 bg-gold-light rounded-full"
            animate={{ y: [0, 8, 0], opacity: [1, 0.3, 1] }}
            transition={{ duration: 2, repeat: Infinity }}
          />
          <ChevronDown className="w-4 h-4 text-primary-foreground/50" />
        </div>
      </motion.button>
    </section>
  );
};

export default HeroSection;
