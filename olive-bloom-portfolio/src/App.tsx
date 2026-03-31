import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import { useEffect } from "react";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { Toaster } from "@/components/ui/toaster";
import { TooltipProvider } from "@/components/ui/tooltip";
import { LanguageProvider, useLanguage } from "@/contexts/LanguageContext";
import { SiteBrandingProvider } from "@/contexts/SiteBrandingContext";
import Index from "./pages/Index.tsx";
import NotFound from "./pages/NotFound.tsx";

const queryClient = new QueryClient();

const metadata = {
  ar: {
    title: "عجاح الغذائية | الموقع الرسمي",
    description:
      "الموقع الرسمي لعجاح الغذائية لزيت الزيتون — المنتجات، الإنتاج، والتواصل.",
  },
  en: {
    title: "Ajaj Foodstuffs | Official Website",
    description:
      "The official Ajaj Foodstuffs website for olive oil — products, production, and contact.",
  },
} as const;

const upsertMeta = (selector: string, content: string) => {
  const element = document.querySelector<HTMLMetaElement>(selector);
  if (!element) return;
  element.setAttribute("content", content);
};

const MetadataSync = () => {
  const { language, dir } = useLanguage();

  useEffect(() => {
    const current = metadata[language];
    document.title = current.title;
    document.documentElement.lang = language;
    document.documentElement.dir = dir;

    upsertMeta('meta[name="description"]', current.description);
    upsertMeta('meta[property="og:title"]', current.title);
    upsertMeta('meta[property="og:description"]', current.description);
    upsertMeta('meta[name="twitter:title"]', current.title);
    upsertMeta('meta[name="twitter:description"]', current.description);
  }, [language, dir]);

  return null;
};

const App = () => (
  <QueryClientProvider client={queryClient}>
    <TooltipProvider>
      <SiteBrandingProvider>
        <LanguageProvider>
          <MetadataSync />
          <Toaster />
          <Sonner />
          <BrowserRouter>
            <Routes>
              <Route path="/" element={<Index />} />
              <Route path="*" element={<NotFound />} />
            </Routes>
          </BrowserRouter>
        </LanguageProvider>
      </SiteBrandingProvider>
    </TooltipProvider>
  </QueryClientProvider>
);

export default App;

