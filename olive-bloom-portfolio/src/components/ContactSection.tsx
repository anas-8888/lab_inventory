import { motion, useInView } from "framer-motion";
import { useRef, useState } from "react";
import { useLanguage } from "@/contexts/LanguageContext";
import { toast } from "sonner";

const ContactSection = () => {
  const { t } = useLanguage();
  const ref = useRef(null);
  const inView = useInView(ref, { once: true, margin: "-100px" });
  const [form, setForm] = useState({ name: "", email: "", message: "" });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    toast.success(t("nav.contact"));
    setForm({ name: "", email: "", message: "" });
  };

  return (
    <section id="contact" className="section-padding bg-primary overflow-hidden" ref={ref}>
      <div className="max-w-7xl mx-auto">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.8 }}
          className="text-center mb-16"
        >
          <p className="text-sm tracking-[0.3em] uppercase text-gold-light font-body mb-4">
            {t("contact.subtitle")}
          </p>
          <h2 className="text-3xl md:text-5xl font-display font-light text-primary-foreground">
            {t("contact.title")}
          </h2>
        </motion.div>

        <div className="grid lg:grid-cols-2 gap-16 items-start">
          {/* Form */}
          <motion.form
            onSubmit={handleSubmit}
            initial={{ opacity: 0, x: -30 }}
            animate={inView ? { opacity: 1, x: 0 } : {}}
            transition={{ duration: 0.8, delay: 0.2 }}
            className="space-y-6"
          >
            <div>
              <input
                type="text"
                placeholder={t("contact.name")}
                value={form.name}
                onChange={(e) => setForm({ ...form, name: e.target.value })}
                required
                className="w-full bg-primary-foreground/5 border border-primary-foreground/20 rounded-xl px-5 py-4 text-primary-foreground placeholder:text-primary-foreground/40 font-body focus:outline-none focus:border-gold transition-colors"
              />
            </div>
            <div>
              <input
                type="email"
                placeholder={t("contact.email")}
                value={form.email}
                onChange={(e) => setForm({ ...form, email: e.target.value })}
                required
                dir="ltr"
                className="w-full text-left bg-primary-foreground/5 border border-primary-foreground/20 rounded-xl px-5 py-4 text-primary-foreground placeholder:text-primary-foreground/40 font-body focus:outline-none focus:border-gold transition-colors"
              />
            </div>
            <div>
              <textarea
                placeholder={t("contact.message")}
                rows={5}
                value={form.message}
                onChange={(e) => setForm({ ...form, message: e.target.value })}
                required
                className="w-full bg-primary-foreground/5 border border-primary-foreground/20 rounded-xl px-5 py-4 text-primary-foreground placeholder:text-primary-foreground/40 font-body focus:outline-none focus:border-gold transition-colors resize-none"
              />
            </div>
            <div className="flex flex-wrap gap-4">
              <button
                type="submit"
                className="bg-gradient-gold text-primary-foreground px-10 py-4 font-body text-sm tracking-wider uppercase rounded-full hover:shadow-lg hover:shadow-gold/30 transition-all duration-500"
              >
                {t("contact.send")}
              </button>
              <a
                href="https://wa.me/963988111127"
                target="_blank"
                rel="noopener noreferrer"
                className="border border-primary-foreground/30 text-primary-foreground px-10 py-4 font-body text-sm tracking-wider uppercase rounded-full hover:bg-primary-foreground/10 transition-all duration-500"
              >
                {t("contact.whatsapp")}
              </a>
            </div>
          </motion.form>

          {/* Map */}
          <motion.div
            initial={{ opacity: 0, x: 30 }}
            animate={inView ? { opacity: 1, x: 0 } : {}}
            transition={{ duration: 0.8, delay: 0.3 }}
            className="w-full"
          >
            <div className="relative w-full aspect-[4/3] overflow-hidden rounded-2xl border border-primary-foreground/15 bg-primary-foreground/5">
              <iframe
                src="https://www.google.com/maps?q=35.19565997274785,36.74721407542121&z=16&output=embed"
                className="absolute inset-0 h-full w-full"
                style={{ border: 0 }}
                allowFullScreen
                loading="lazy"
                referrerPolicy="no-referrer-when-downgrade"
                title="Ajaj Location"
              />
            </div>
          </motion.div>
        </div>
      </div>
    </section>
  );
};

export default ContactSection;
