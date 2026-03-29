import { motion } from "framer-motion";
import { useLanguage } from "@/contexts/LanguageContext";
import { MapPin, Phone, Mail, Leaf, Facebook, Instagram } from "lucide-react";
import logo from "@/assets/logo.png";

const Footer = () => {
  const { t } = useLanguage();

  const scrollTo = (href: string) => {
    const el = document.querySelector(href);
    el?.scrollIntoView({ behavior: "smooth" });
  };

  const navLinks = [
    { href: "#home", label: t("nav.home") },
    { href: "#about", label: t("nav.about") },
    { href: "#products", label: t("nav.products") },
    { href: "#production", label: t("nav.production") },
    { href: "#contact", label: t("nav.contact") },
  ];

  return (
    <footer className="relative bg-primary overflow-hidden">
      {/* Decorative top border */}
      <div className="h-1 bg-gradient-gold" />

      {/* Organic shape decorations */}
      <div className="absolute top-10 right-10 w-64 h-64 rounded-full bg-gold/5 blur-3xl pointer-events-none" />
      <div className="absolute bottom-10 left-10 w-48 h-48 rounded-full bg-gold-light/3 blur-3xl pointer-events-none" />

      <div className="relative max-w-7xl mx-auto px-6 md:px-12 pt-16 pb-8">
        <div className="grid md:grid-cols-3 gap-12 mb-12">
          {/* Brand column */}
          <div>
            <div className="flex items-center gap-3 mb-6">
              <img src={logo} alt="Ajaj" className="h-14 w-14 object-contain" />
              <div>
                <p className="text-xl font-display font-semibold tracking-wider text-primary-foreground">AJAJ</p>
                <p className="text-xs font-body text-primary-foreground/50 tracking-wide">{t("footer.tagline")}</p>
              </div>
            </div>
            <p className="font-body text-sm text-primary-foreground/60 leading-relaxed max-w-xs">
              {t("footer.description")}
            </p>
          </div>

          {/* Navigation column */}
          <div>
            <h4 className="font-display text-lg text-primary-foreground mb-6 flex items-center gap-2">
              <Leaf className="w-4 h-4 text-gold-light" />
              {t("footer.quicklinks")}
            </h4>
            <nav className="flex flex-col gap-3">
              {navLinks.map((link) => (
                <button
                  key={link.href}
                  onClick={() => scrollTo(link.href)}
                  className="text-sm font-body text-primary-foreground/60 hover:text-gold-light transition-colors duration-300 text-start w-fit"
                >
                  {link.label}
                </button>
              ))}
            </nav>
          </div>

          {/* Contact column */}
          <div>
            <div className="flex items-center justify-between mb-6">
              <h4 className="font-display text-lg text-primary-foreground flex items-center gap-2">
                <Leaf className="w-4 h-4 text-gold-light" />
                {t("footer.contactinfo")}
              </h4>
              <div className="flex items-center gap-3">
                <a
                  href="https://wa.me/0988111127"
                  target="_blank"
                  rel="noreferrer"
                  aria-label="WhatsApp"
                  className="text-primary-foreground/70 hover:text-gold-light transition-colors w-9 h-9 rounded-lg bg-primary-foreground/10 hover:bg-primary-foreground/15 flex items-center justify-center"
                >
                  <svg
                    viewBox="0 0 448 512"
                    className="w-5 h-5"
                    fill="currentColor"
                    aria-hidden="true"
                  >
                    <path d="M380.9 97.1C339 55.2 283.2 32 224.3 32c-121.7 0-220.7 99-220.7 220.7 0 38.9 10.2 76.9 29.6 110.3L0 480l120.9-31.7c32.9 17.9 70 27.3 107.9 27.3h.1c121.7 0 220.7-99 220.7-220.7 0-58.8-22.9-114.1-64.6-155.8zM224.9 438c-33.2 0-65.7-8.9-94-25.7l-6.7-4-71.7 18.8 19.1-69.9-4.4-7c-18.5-29.4-28.2-63.3-28.2-98.2 0-100.7 82-182.7 182.7-182.7 48.9 0 94.8 19.1 129.4 53.7 34.6 34.6 53.7 80.5 53.7 129.4 0 100.7-82 182.7-182.7 182.7zm101.7-138.1c-5.6-2.8-33-16.3-38.1-18.1-5.1-1.9-8.8-2.8-12.5 2.8-3.7 5.6-14.4 18.1-17.7 21.8-3.2 3.7-6.5 4.2-12.1 1.4-33.4-16.7-55.3-29.8-77.4-67.7-5.9-10.2 5.9-9.5 16.8-31.5 1.9-3.7.9-6.9-.5-9.7-1.4-2.8-12.5-30.1-17.1-41.1-4.5-10.8-9.1-9.3-12.5-9.5-3.2-.2-6.9-.2-10.6-.2-3.7 0-9.7 1.4-14.8 6.9-5.1 5.6-19.4 19-19.4 46.3 0 27.3 19.9 53.7 22.7 57.4 2.8 3.7 39.1 59.7 94.8 83.8 13.2 5.7 23.5 9.1 31.6 11.7 13.3 4.2 25.4 3.6 35 2.2 10.7-1.6 33-13.5 37.6-26.5 4.6-13 4.6-24.2 3.2-26.5-1.3-2.3-5-3.7-10.6-6.5z" />
                  </svg>
                </a>
                <a
                  href="https://www.facebook.com/share/1ASeV8DqZg/?mibextid=wwXIfr"
                  target="_blank"
                  rel="noreferrer"
                  aria-label="Facebook"
                  className="text-primary-foreground/70 hover:text-gold-light transition-colors w-9 h-9 rounded-lg bg-primary-foreground/10 hover:bg-primary-foreground/15 flex items-center justify-center"
                >
                  <Facebook className="w-5 h-5" />
                </a>
                <a
                  href="https://www.instagram.com/ajajbrothersfoodproducts?igsh=MWNvMmxvamY1Z3ZjNQ=="
                  target="_blank"
                  rel="noreferrer"
                  aria-label="Instagram"
                  className="text-primary-foreground/70 hover:text-gold-light transition-colors w-9 h-9 rounded-lg bg-primary-foreground/10 hover:bg-primary-foreground/15 flex items-center justify-center"
                >
                  <Instagram className="w-5 h-5" />
                </a>
              </div>
            </div>
            <div className="flex flex-col gap-4">
              <div className="flex items-start gap-3">
                <MapPin className="w-4 h-4 text-gold-light mt-0.5 shrink-0" />
                <p className="text-sm font-body text-primary-foreground/60">{t("footer.address.value")}</p>
              </div>
              <div className="flex items-center gap-3">
                <Phone className="w-4 h-4 text-gold-light shrink-0" />
                <p className="text-sm font-body text-primary-foreground/60" dir="ltr">0988111127</p>
              </div>
              <div className="flex items-center gap-3">
                <Mail className="w-4 h-4 text-gold-light shrink-0" />
                <p className="text-sm font-body text-primary-foreground/60">ajajbrothers00@gmail.com</p>
              </div>
            </div>
          </div>
        </div>

        {/* Divider */}
        <div className="h-px bg-gradient-to-r from-transparent via-primary-foreground/15 to-transparent mb-8" />

        {/* Bottom bar */}
        <div className="flex flex-col md:flex-row items-center justify-center gap-4">
          <a
            className="font-body text-xs text-primary-foreground/50 hover:text-gold-light transition-colors"
            href="https://nexa-group.net"
            target="_blank"
            rel="noreferrer"
          >
            Developed By NEXA-Group
          </a>
        </div>
      </div>
    </footer>
  );
};

export default Footer;

