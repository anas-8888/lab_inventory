import { useRef, useState } from "react";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { useLanguage } from "@/contexts/LanguageContext";
import { toast } from "sonner";

const apiBase = (import.meta.env.VITE_SITE_API_BASE_URL || "http://localhost:3000").replace(/\/+$/, "");
const MAX_ATTACHMENTS = 10;

type SellProductsModalProps = {
  open: boolean;
  onOpenChange: (open: boolean) => void;
};

const SellProductsModal = ({ open, onOpenChange }: SellProductsModalProps) => {
  const { t, dir } = useLanguage();
  const [form, setForm] = useState({ name: "", phone: "", message: "" });
  const [photos, setPhotos] = useState<File[]>([]);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const fileInputRef = useRef<HTMLInputElement | null>(null);

  const syncInputFiles = (files: File[]) => {
    if (!fileInputRef.current) return;
    const dataTransfer = new DataTransfer();
    files.forEach((file) => dataTransfer.items.add(file));
    fileInputRef.current.files = dataTransfer.files;
  };

  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (isSubmitting) return;
    if (!photos.length) {
      toast.error(t("sell.photo.hint"));
      return;
    }

    setIsSubmitting(true);
    try {
      const formData = new FormData();
      formData.append("sender_name", form.name.trim());
      formData.append("sender_phone", form.phone.trim());
      formData.append("message_text", form.message.trim());
      formData.append("message_source", "sell_products_modal");
      photos.forEach((photo) => {
        formData.append("attachments", photo);
      });

      const response = await fetch(`${apiBase}/site-management/contact-messages`, {
        method: "POST",
        body: formData,
      });

      const payload = await response.json().catch(() => ({}));
      if (!response.ok || payload?.success === false) {
        throw new Error(payload?.message || (response.status === 429 ? "Too many requests." : "Request failed."));
      }

      toast.success(payload?.message || t("sell.toast"));
      setForm({ name: "", phone: "", message: "" });
      setPhotos([]);
      if (fileInputRef.current) {
        fileInputRef.current.value = "";
      }
      onOpenChange(false);
    } catch (error) {
      const fallback = t("sell.submit");
      const message = error instanceof Error && error.message ? error.message : fallback;
      toast.error(message);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-[94vw] sm:max-w-lg max-h-[78vh] overflow-y-auto rounded-2xl p-0">
        <div className="px-6 py-6">
          <DialogHeader className={dir === "ltr" ? "text-left sm:text-left" : "text-right sm:text-right"}>
            <DialogTitle className="text-2xl font-display">
              {t("sell.title")}
            </DialogTitle>
            <DialogDescription className="text-sm text-muted-foreground">
              {t("sell.description")}
            </DialogDescription>
          </DialogHeader>

          <form onSubmit={handleSubmit} className="space-y-3">
            <div className="space-y-1">
              <label className="text-sm font-body" htmlFor="sell-name">
                {t("sell.name.label")}
              </label>
              <input
                id="sell-name"
                type="text"
                required
                value={form.name}
                onChange={(event) =>
                  setForm({ ...form, name: event.target.value })
                }
                placeholder={t("sell.name.placeholder")}
                className="w-full rounded-lg border border-border bg-background px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-gold/60"
              />
            </div>

            <div className="space-y-1">
              <label className="text-sm font-body" htmlFor="sell-phone">
                {t("sell.phone.label")}
              </label>
              <input
                id="sell-phone"
                type="tel"
                required
                dir="ltr"
                value={form.phone}
                onChange={(event) =>
                  setForm({ ...form, phone: event.target.value })
                }
                placeholder={t("sell.phone.placeholder")}
                className="w-full rounded-lg border border-border bg-background px-4 py-3 text-sm text-left focus:outline-none focus:ring-2 focus:ring-gold/60"
              />
            </div>

            <div className="space-y-1">
              <label className="text-sm font-body" htmlFor="sell-photos">
                {t("sell.photo.label")}
              </label>
              <input
                id="sell-photos"
                ref={fileInputRef}
                type="file"
                required
                multiple
                accept="image/*"
                onChange={(event) => {
                  const incoming = Array.from(event.target.files ?? []);
                  setPhotos((prev) => {
                    const merged = [...prev];
                    incoming.forEach((file) => {
                      const exists = merged.some(
                        (existing) =>
                          existing.name === file.name &&
                          existing.size === file.size &&
                          existing.lastModified === file.lastModified,
                      );
                      if (!exists) merged.push(file);
                    });
                    if (merged.length > MAX_ATTACHMENTS) {
                      merged.splice(MAX_ATTACHMENTS);
                      toast.error(`يمكنك رفع ${MAX_ATTACHMENTS} صور كحد أقصى.`);
                    }
                    syncInputFiles(merged);
                    return merged;
                  });
                }}
                className="w-full rounded-lg border border-border bg-background px-3 py-2 text-xs file:mr-3 file:rounded-full file:border-0 file:bg-primary file:px-3 file:py-1.5 file:text-xs file:font-medium file:text-primary-foreground hover:file:bg-primary/90"
              />
             
            </div>

            {photos.length > 0 && (
              <div className="space-y-2">
                <p className="text-xs uppercase tracking-wider text-muted-foreground">
                  {t("sell.photo.selected")}
                </p>
                <div className="space-y-2">
                  {photos.map((file) => (
                    <div
                      key={`${file.name}-${file.lastModified}`}
                      className="flex items-center justify-between rounded-lg border border-border bg-muted/10 px-3 py-2 text-sm"
                    >
                      <span className="truncate">{file.name}</span>
                      <button
                        type="button"
                        onClick={() => {
                          setPhotos((prev) => {
                            const next = prev.filter((f) => f !== file);
                            syncInputFiles(next);
                            return next;
                          });
                        }}
                        className="ml-3 inline-flex h-7 w-7 items-center justify-center rounded-full border border-border text-xs text-muted-foreground transition-colors hover:bg-muted"
                        aria-label={t("sell.photo.remove")}
                      >
                        ×
                      </button>
                    </div>
                  ))}
                </div>
              </div>
            )}

            <div className="space-y-1">
              <label className="text-sm font-body" htmlFor="sell-message">
                {t("sell.message.label")}
              </label>
              <textarea
                id="sell-message"
                rows={2}
                value={form.message}
                onChange={(event) =>
                  setForm({ ...form, message: event.target.value })
                }
                placeholder={t("sell.message.placeholder")}
                className="w-full resize-y rounded-lg border border-border bg-background px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-gold/60"
              />
            </div>

            <button
              type="submit"
              disabled={isSubmitting}
              className="w-full rounded-full bg-gradient-gold px-6 py-3 text-sm font-body uppercase tracking-wider text-primary-foreground transition-all duration-300 hover:shadow-lg hover:shadow-gold/30"
            >
              {isSubmitting ? "..." : t("sell.submit")}
            </button>
          </form>
        </div>
      </DialogContent>
    </Dialog>
  );
};

export default SellProductsModal;
