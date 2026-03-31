import { useState, useEffect } from "react";
import LoadingScreen from "@/components/LoadingScreen";
import Navbar from "@/components/Navbar";
import HeroSection from "@/components/HeroSection";
import AboutSection from "@/components/AboutSection";
import ProductsSection from "@/components/ProductsSection";
import ProductionSection from "@/components/ProductionSection";
import VirginClassificationSection from "@/components/VirginClassificationSection";
import ContactSection from "@/components/ContactSection";
import Footer from "@/components/Footer";
import SellProductsModal from "@/components/SellProductsModal";
import { useLanguage } from "@/contexts/LanguageContext";

const SELL_MODAL_SEEN_KEY = "sell_products_modal_seen";

const Index = () => {
  const [isLoading, setIsLoading] = useState(true);
  const [isSellModalOpen, setIsSellModalOpen] = useState(false);
  const [sellModalSeen, setSellModalSeen] = useState(false);
  const { t } = useLanguage();

  useEffect(() => {
    const timer = setTimeout(() => setIsLoading(false), 3000);
    return () => clearTimeout(timer);
  }, []);

  useEffect(() => {
    if (!isLoading) {
      const hasSeenModal = window.localStorage.getItem(SELL_MODAL_SEEN_KEY) === "1";
      if (hasSeenModal) {
        setSellModalSeen(true);
        return undefined;
      }

      const timer = setTimeout(() => {
        setIsSellModalOpen(true);
        setSellModalSeen(true);
        window.localStorage.setItem(SELL_MODAL_SEEN_KEY, "1");
      }, 200);
      return () => clearTimeout(timer);
    }
    return undefined;
  }, [isLoading]);

  return (
    <>
      <LoadingScreen isLoading={isLoading} />
      <SellProductsModal open={isSellModalOpen} onOpenChange={setIsSellModalOpen} />
      <Navbar />
      <main>
        <HeroSection />
        <AboutSection />
        <ProductsSection />
        <ProductionSection />
        <VirginClassificationSection />
        <ContactSection />
      </main>
      <Footer />
      {sellModalSeen && !isSellModalOpen && (
        <button
          type="button"
          onClick={() => setIsSellModalOpen(true)}
          className="fixed bottom-6 right-6 z-40 rounded-full bg-gradient-gold px-6 py-3 text-sm font-body uppercase tracking-wider text-primary-foreground shadow-lg shadow-gold/30 transition-all duration-300 hover:-translate-y-1 hover:shadow-xl hover:shadow-gold/40"
        >
          {t("sell.sticky")}
        </button>
      )}
    </>
  );
};

export default Index;
