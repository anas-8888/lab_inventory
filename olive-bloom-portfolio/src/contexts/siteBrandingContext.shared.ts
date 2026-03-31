import { createContext } from "react";

export type SiteBrandingContextValue = {
  logoUrl: string;
  iconUrl: string;
  productSections: Record<string, unknown>;
};

export const SiteBrandingContext = createContext<SiteBrandingContextValue>({
  logoUrl: "",
  iconUrl: "",
  productSections: {},
});
