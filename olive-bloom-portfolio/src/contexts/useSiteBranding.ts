import { useContext } from "react";
import { SiteBrandingContext } from "@/contexts/siteBrandingContext.shared";

export const useSiteBranding = () => useContext(SiteBrandingContext);
