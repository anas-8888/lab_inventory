import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Menu, X, Leaf } from "lucide-react";
import { useLanguage } from "@/contexts/LanguageContext";
import { useSiteBranding } from "@/contexts/useSiteBranding";
import logo from "@/assets/logo.png";

const Navbar = () => {
  const { t, language, toggleLanguage } = useLanguage();
  const { logoUrl } = useSiteBranding();
  const [scrolled, setScrolled] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);
  const brandLogo = logoUrl || logo;

  useEffect(() => {
    const getThreshold = () => {
      const hero = document.getElementById("home");
      const heroHeight = hero?.offsetHeight ?? 0;
      return Math.max(0, heroHeight - 80);
    };

    const onScroll = () => setScrolled(window.scrollY > getThreshold());

    onScroll();
    window.addEventListener("scroll", onScroll);
    window.addEventListener("resize", onScroll);
    return () => {
      window.removeEventListener("scroll", onScroll);
      window.removeEventListener("resize", onScroll);
    };
  }, []);

  const links = [
    { href: "#home", label: t("nav.home") },
    { href: "#about", label: t("nav.about") },
    { href: "#products", label: t("nav.products") },
    { href: "#production", label: t("nav.production") },
    { href: "#contact", label: t("nav.contact") },
  ];

  const scrollTo = (href: string) => {
    setMobileOpen(false);
    const el = document.querySelector(href);
    el?.scrollIntoView({ behavior: "smooth" });
  };

  return (
    <motion.nav
      initial={{ y: -100 }}
      animate={{ y: 0 }}
      transition={{ duration: 0.8, delay: 2.8 }}
      className={`fixed top-0 left-0 right-0 z-50 transition-all duration-500 ${
        scrolled ? "bg-background" : "bg-transparent"
      }`}
    >
      <div className="max-w-7xl mx-auto px-6 md:px-12 flex items-center justify-between h-20">
        {/* Logo */}
        <button onClick={() => scrollTo("#home")} className="flex items-center gap-3 group">
          <img src={brandLogo} alt="Ajaj" className="h-20 w-20 object-contain group-hover:scale-105 transition-transform duration-300" />
        </button>

        {/* Desktop Links */}
        <div className="hidden md:flex items-center gap-8">
          {links.map((link) => (
            <button
              key={link.href}
              onClick={() => scrollTo(link.href)}
              className={`text-sm font-body tracking-wide transition-colors duration-300 relative group ${
                scrolled ? "text-olive hover:text-olive" : "text-primary-foreground/90 hover:text-gold-light"
              }`}
            >
              {link.label}
              <span
                className={`absolute -bottom-1 left-0 w-0 h-[1.5px] transition-all duration-300 group-hover:w-full ${
                  scrolled ? "bg-olive" : "bg-gold-light"
                }`}
              />
            </button>
          ))}

          <button
            onClick={toggleLanguage}
            className={`flex items-center gap-1.5 text-sm font-body transition-all duration-300 rounded-full px-3 py-1.5 ${
              scrolled
                ? "text-olive hover:text-olive border border-olive/30"
                : "text-primary-foreground/90 hover:text-gold-light border border-primary-foreground/30"
            }`}
          >
            {language === "en" ? "AR" : "EN"}
          </button>
        </div>

        {/* Mobile toggle */}
        <div className="flex md:hidden items-center gap-3">
          <button
            onClick={toggleLanguage}
            className={`text-sm font-body rounded-full px-2.5 py-1 transition-colors ${
              scrolled
                ? "text-olive border border-olive/30"
                : "text-primary-foreground/90 border border-primary-foreground/30"
            }`}
          >
            <span
              className={`fi ${language === "en" ? "fi-sy" : "fi-gb"} text-[12px] rounded-sm shadow-sm align-middle me-1`}
              aria-hidden="true"
            />
            {language === "en" ? "AR" : "EN"}
          </button>
          <button
            onClick={() => setMobileOpen(!mobileOpen)}
            aria-label={
              mobileOpen
                ? (language === "ar" ? "إغلاق القائمة" : "Close menu")
                : (language === "ar" ? "فتح القائمة" : "Open menu")
            }
            title={
              mobileOpen
                ? (language === "ar" ? "إغلاق القائمة" : "Close menu")
                : (language === "ar" ? "فتح القائمة" : "Open menu")
            }
            className={`transition-colors ${scrolled ? "text-olive" : "text-primary-foreground"}`}
          >
            {mobileOpen ? <X size={24} /> : <Menu size={24} />}
          </button>
        </div>
      </div>

      {/* Mobile menu - beautiful sidebar style */}
      <AnimatePresence>
        {mobileOpen && (
          <>
            {/* Overlay */}
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              className="fixed inset-0 bg-foreground/40 backdrop-blur-sm z-40"
              onClick={() => setMobileOpen(false)}
            />
            {/* Slide-in panel */}
            <motion.div
              initial={{ x: language === "ar" ? "-100%" : "100%" }}
              animate={{ x: 0 }}
              exit={{ x: language === "ar" ? "-100%" : "100%" }}
              transition={{ type: "spring", damping: 25, stiffness: 200 }}
              className="fixed top-0 right-0 rtl:right-auto rtl:left-0 bottom-0 w-80 bg-background z-50 shadow-2xl"
            >
              <div className="flex flex-col h-full">
                {/* Header */}
                <div className="flex items-center justify-between p-6 border-b border-border">
                  <div className="flex items-center gap-3">
                    <img src={brandLogo} alt="Ajaj" className="h-10 w-10 object-contain" />
                    <span className="text-lg font-display font-semibold tracking-wider text-foreground">
                      {language === "ar" ? "عجاج للمواد الغذائية" : "AJAJ FOOD STUFFS"}
                    </span>
                  </div>
                  <button
                    onClick={() => setMobileOpen(false)}
                    aria-label={language === "ar" ? "إغلاق القائمة" : "Close menu"}
                    title={language === "ar" ? "إغلاق القائمة" : "Close menu"}
                    className="text-foreground/60 hover:text-foreground transition-colors"
                  >
                    <X size={24} />
                  </button>
                </div>

                {/* Links */}
                <div className="flex-1 flex flex-col p-6 gap-2">
                  {links.map((link, i) => (
                    <motion.button
                      key={link.href}
                      initial={{ opacity: 0, x: 20 }}
                      animate={{ opacity: 1, x: 0 }}
                      transition={{ delay: i * 0.08 }}
                      onClick={() => scrollTo(link.href)}
                      className="flex items-center gap-3 text-lg font-body text-foreground/80 hover:text-accent hover:bg-accent/5 transition-all rounded-xl px-4 py-3 text-start"
                    >
                      <Leaf className="w-4 h-4 text-accent/60" />
                      {link.label}
                    </motion.button>
                  ))}
                </div>

                {/* Footer decoration */}
                <div className="p-6 border-t border-border">
                  <p className="text-xs font-body text-muted-foreground text-center">
                    Developed By{" "}
                    <a
                      className="text-foreground/80 hover:text-accent transition-colors"
                      href="https://nexa-group.net"
                      target="_blank"
                      rel="noopener noreferrer"
                    >
                      NEXA-Group
                    </a>
                  </p>
                </div>
              </div>
            </motion.div>
          </>
        )}
      </AnimatePresence>
    </motion.nav>
  );
};

export default Navbar;



