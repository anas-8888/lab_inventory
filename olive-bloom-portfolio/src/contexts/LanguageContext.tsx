import {
  createContext,
  useContext,
  useState,
  useCallback,
  ReactNode,
} from "react";

type Language = "en" | "ar";

interface LanguageContextType {
  language: Language;
  toggleLanguage: () => void;
  t: (key: string) => string;
  dir: "ltr" | "rtl";
}

const translations: Record<string, Record<Language, string>> = {
  // Nav
  "nav.home": { en: "Home", ar: "الرئيسية" },
  "nav.about": { en: "About", ar: "من نحن" },
  "nav.products": { en: "Products", ar: "المنتجات" },
  "nav.production": { en: "Production", ar: "الإنتاج" },
  "nav.contact": { en: "Contact", ar: "تواصل معنا" },

  // Hero
  "hero.subtitle": { en: "Ajaj Foodstuffs", ar: "عجاح الغذائية" },
  "hero.title": {
    en: "Olive Oil Production & Trade",
    ar: "إنتاج وتعبئة الزيتون و زيت الزيتون البكر بجودة عالية",
  },
  "hero.description": {
    en: "We produce and trade premium olive oil, combining authentic Mediterranean craftsmanship with modern quality standards to deliver pure taste in every bottle.",
    ar: "تجارة و تعبئة كافة انواع المحاصيل الزراعية",
  },
  "hero.cta": { en: "Explore Our Products", ar: "استكشف منتجاتنا" },
  "hero.cta2": { en: "Learn More", ar: "اعرف المزيد" },

  // About
  "about.subtitle": { en: "Ajaj Foodstuffs", ar: "عجاح للمواد الغذائية" },
  "about.title": {
    en: "A Legacy of Premium Olive Oil",
    ar: "إرث من الزيتون و زيت الزيتون الفاخر",
  },
  "about.p1": {
    en: "Ajaj Foodstuffs was founded on a deep love for the olive tree and its timeless gifts, becoming a trusted name in premium olive oil production. Our journey began with a simple belief — that the purest olive oil comes from respecting nature’s rhythm, from grove to bottle.",
    ar: "تأسست شركة عجاح الغذائية على حبٍ عميق لشجرة الزيتون وعطاياها الخالدة، لتصبح اسماً موثوقاً في إنتاج الزيتون و زيت الزيتون الفاخر. بدأت رحلتنا بإيمان بسيط — أن أنقى زيت زيتون يأتي من احترام إيقاع الطبيعة، من البستان إلى الزجاجة والمستهلك.",
  },
  "about.p2": {
    en: "We combine generations of Mediterranean olive oil craftsmanship with the latest extraction and packaging technologies. Every bottle we produce carries the warmth of the sun, the richness of the earth, and a steadfast commitment to quality that has defined our name since day one.",
    ar: "نجمع بين أجيال من حرفية زيت الزيتون المتوسطية وأحدث تقنيات الاستخلاص والتعبئة. كل زجاجة ننتجها تحمل دفء الشمس وغنى الأرض والتزاماً راسخاً بالجودة التي عرّفت اسمنا منذ اليوم الأول.",
  },
  "about.stat1.number": { en: "20", ar: "٢٠" },
  "about.stat1.label": { en: "Years of Excellence", ar: "عاماً من التميز" },
  "about.stat2.number": { en: "100%", ar: "١٠٠٪" },
  "about.stat2.label": { en: "Natural & Pure", ar: "طبيعي ونقي" },
  "about.stat3.number": { en: "10", ar: "١٠" },
  "about.stat3.label": { en: "Export Markets", ar: "أسواق تصدير" },
  "about.culture.title": {
    en: "The Heritage of Olives & Crops",
    ar: "حضارة الزيتون وزيت الزيتون والمحاصيل الزراعية",
  },
  "about.culture.body": {
    en: "We celebrate the story of the olive tree, the craft of olive oil, and the richness of agricultural crops. A living heritage that connects our land, our people, and our daily table.",
    ar: "نحتفي بحكاية شجرة الزيتون وفنون زيت الزيتون، وبغنى المحاصيل الزراعية. إرث حي يجمع أرضنا وأهلنا ومائدتنا اليومية.",
  },
  "about.culture.p1": {
    en: "The olive tree is a blessed gift of the land, rooted in heritage and sustained by generations.",
    ar: "شجرة الزيتون هي الابنة السورية البارة... لم تكن دوماً إلا محظية السماء باركها الله منذ الخليقة وأخرجها من رحم تراب أرض سوريا لتغدو بلسم دواء وخير غذاء.",
  },
  "about.culture.p2": {
    en: "Olive culture spread through the Mediterranean over centuries, shaping cuisines and traditions.",
    ar: "سوريا هي المصدر الرئيسي لشجرة زيت الزيتون حيث أن أشجار الزيتون في سوريا وفلسطين قد وجدت منذ ما يقارب 6000 عام، وقام الفينيقيون بنشر ثقافة زيت الزيتون في منطقة المتوسط وأفريقيا وشمال أوروبا.",
  },
  "about.culture.p3": {
    en: "Today, the olive heritage continues with a deep commitment to quality and global reach.",
    ar: "واستمرت ثقافة الزيتون بالانتشار في عهد الرومان واليونانيين وفقاً لتوسع الإمبراطورية الرومانية، وعليه فإن سوريا هي رائدة في إنتاج زيت الزيتون على المستوى العالمي، وهي تحتل المرتبة الرابعة في إنتاج زيت الزيتون عالمياً.",
  },
  "about.culture.p4": {
    en: "We market and export olive oil in line with international standards.",
    ar: "وإن شركة عجاج إخوان التجارية شركة مختصة في تسويق زيت الزيتون من المعاصر والمنتجين (المزارع)، وتقوم بتسويقه محلياً وتصديره للدول العربية والعالمية وذلك طبقاً للمواصفات القياسية العالمية.",
  },

  // Products
  "products.subtitle": { en: "Olive Products", ar: "منتجات الزيتون" },
  "products.title": {
    en: "Olive Products Showcase",
    ar: "عرض منتجات الزيتون",
  },
  "products.intro": {
    en: "Explore our curated selection of olive products crafted with care and quality.",
    ar: "استكشف مجموعتنا المختارة بعناية من منتجات الزيتون المصنوعة بجودة عالية.",
  },
  "productsOil.subtitle": { en: "Olive Oil", ar: "زيت الزيتون" },
  "productsOil.title": {
    en: "Olive Oil Showcase",
    ar: "عرض زيت الزيتون",
  },
  "productsOil.intro": {
    en: "A dedicated selection of premium olive oils for every taste and use.",
    ar: "مجموعة مميزة من زيوت الزيتون الفاخرة لتناسب كل الأذواق والاستخدامات.",
  },
  "productsCrops.subtitle": {
    en: "Agricultural Crops",
    ar: "المحاصيل الزراعية",
  },
  "productsCrops.title": {
    en: "Agricultural Crops Showcase",
    ar: "عرض المحاصيل الزراعية",
  },
  "productsCrops.intro": {
    en: "A curated range of agricultural crops, selected for quality and freshness.",
    ar: "تشكيلة مختارة من المحاصيل الزراعية بجودة عالية وطزاجة مميزة.",
  },
  "products.filter.all": { en: "All", ar: "الكل" },
  "products.filter.premium": { en: "Premium", ar: "فاخر" },
  "products.filter.virgin": { en: "Virgin", ar: "بكر" },
  "products.filter.organic": { en: "Organic", ar: "عضوي" },
  "products.premium": { en: "Premium Quality", ar: "جودة فاخرة" },
  "products.acidity": { en: "Acidity Level", ar: "مستوى الحموضة" },
  "products.natural": { en: "Natural", ar: "طبيعي" },
  "products.1.name": {
    en: "Extra Virgin Olive Oil",
    ar: "زيت زيتون بكر ممتاز",
  },
  "products.1.desc": {
    en: "Cold-pressed from the finest hand-picked olives at peak ripeness. Our flagship product delivers unmatched flavor, aroma, and purity — perfect for salads, dipping, and finishing dishes.",
    ar: "معصور على البارد من أجود أنواع الزيتون المقطوف يدوياً في ذروة النضج. منتجنا الرئيسي يقدّم نكهة ورائحة ونقاء لا مثيل لها — مثالي للسلطات والغموس وتزيين الأطباق.",
  },
  "products.1.f1": { en: "First cold-pressed extraction", ar: "عصر بارد أول" },
  "products.1.f2": {
    en: "Rich, fruity aroma with peppery finish",
    ar: "رائحة فاكهية غنية مع لمسة فلفلية",
  },
  "products.1.f3": {
    en: "Ideal for raw consumption & fine dining",
    ar: "مثالي للاستهلاك الخام والمطابخ الراقية",
  },
  "products.2.name": { en: "Virgin Olive Oil", ar: "زيت زيتون بكر" },
  "products.2.desc": {
    en: "A versatile and flavorful cooking companion with authentic Mediterranean character. Naturally extracted with no chemical processing, bringing wholesome goodness to every meal.",
    ar: "رفيق طهي متعدد الاستخدامات وغني بالنكهة بطابع متوسطي أصيل. مُستخلص طبيعياً دون معالجة كيميائية، ليقدّم الخير الصحي في كل وجبة.",
  },
  "products.2.f1": {
    en: "Natural extraction, no chemicals",
    ar: "استخلاص طبيعي دون مواد كيميائية",
  },
  "products.2.f2": {
    en: "Smooth, balanced Mediterranean flavor",
    ar: "نكهة متوسطية متوازنة وناعمة",
  },
  "products.2.f3": {
    en: "Perfect for cooking & everyday use",
    ar: "مثالي للطبخ والاستخدام اليومي",
  },
  "products.3.name": { en: "Organic Olive Oil", ar: "زيت زيتون عضوي" },
  "products.3.desc": {
    en: "Certified organic and sustainably sourced from heritage groves that have thrived for generations. For the health-conscious connoisseur who values purity and environmental responsibility.",
    ar: "عضوي معتمد ومصدره مستدام من بساتين تراثية ازدهرت لأجيال. لعشّاق الصحة الذين يقدّرون النقاء والمسؤولية البيئية.",
  },
  "products.3.f1": {
    en: "Internationally certified organic",
    ar: "عضوي معتمد دولياً",
  },
  "products.3.f2": {
    en: "Sourced from heritage olive groves",
    ar: "من بساتين زيتون تراثية",
  },
  "products.3.f3": {
    en: "Eco-friendly & sustainable practices",
    ar: "ممارسات صديقة للبيئة ومستدامة",
  },
  "products.4.name": { en: "Reserve Olive Oil", ar: "زيت زيتون احتياطي" },
  "products.4.desc": {
    en: "A refined, small-batch selection with balanced fruitiness and a silky finish. Crafted for those who enjoy a premium everyday pour.",
    ar: "اختيار فاخر محدود الإنتاج بفاكهية متوازنة ولمسة نهائية ناعمة. صُمّم لمن يفضّل جودة ممتازة للاستخدام اليومي.",
  },
  "products.4.f1": {
    en: "Carefully selected mid-harvest olives",
    ar: "زيتون مختار بعناية من حصاد منتصف الموسم",
  },
  "products.4.f2": {
    en: "Smooth texture with gentle pepper notes",
    ar: "قوام ناعم مع لمسة فلفلية خفيفة",
  },
  "products.4.f3": {
    en: "Great for dressings and light sauté",
    ar: "مثالي للسلطات والتشويح الخفيف",
  },
  "products.5.name": { en: "Classic Virgin Olive Oil", ar: "زيت زيتون بكر كلاسيكي" },
  "products.5.desc": {
    en: "A reliable kitchen staple with authentic taste and aroma. Naturally extracted to keep every meal wholesome and flavorful.",
    ar: "أساسي موثوق في المطبخ بنكهة ورائحة أصيلة. مُستخلص طبيعياً ليحافظ على الطعم والفائدة في كل وجبة.",
  },
  "products.5.f1": {
    en: "Everyday cooking friendly",
    ar: "مناسب للطبخ اليومي",
  },
  "products.5.f2": {
    en: "Balanced flavor and aroma",
    ar: "نكهة ورائحة متوازنة",
  },
  "products.5.f3": {
    en: "Versatile for sautés and marinades",
    ar: "مرن للاستخدام في التشويح والتتبيل",
  },
  "products.6.name": { en: "Organic Heritage Olive Oil", ar: "زيت زيتون عضوي تراثي" },
  "products.6.desc": {
    en: "Organic oil from heritage groves, pressed gently to preserve purity. A clean, vibrant profile for health-conscious kitchens.",
    ar: "زيت عضوي من بساتين تراثية، معصور بلطف للحفاظ على النقاء. نكهة نظيفة وحيوية لعشّاق الصحة.",
  },
  "products.6.f1": {
    en: "Certified organic sourcing",
    ar: "مصدر عضوي معتمد",
  },
  "products.6.f2": {
    en: "Cold-pressed for maximum purity",
    ar: "معصور على البارد لأقصى درجات النقاء",
  },
  "products.6.f3": {
    en: "Bright, fresh finish",
    ar: "نهاية مشرقة ومنعشة",
  },

  // Production
  "production.subtitle": { en: "Our Process", ar: "عمليتنا" },
  "production.title": {
    en: "From Grove to Bottle",
    ar: "من البستان إلى الزجاجة",
  },
  "production.step1.title": { en: "Harvesting", ar: "الحصاد" },
  "production.step1.desc": {
    en: "Hand-picked at peak ripeness from our partner groves",
    ar: "يقطف يدويا عند نضوجه من بساتين الخيرات السورية",
  },
  "production.step2.title": { en: "Cold Pressing", ar: "العصر" },
  "production.step2.desc": {
    en: "Extracted within hours using state-of-the-art cold press technology",
    ar: "يُستخلص خلال ساعات باستخدام أحدث تقنيات العصر ",
  },
  "production.step3.title": { en: "Quality Testing", ar: "اختبار الجودة" },
  "production.step3.desc": {
    en: "Rigorous lab testing ensures purity, acidity, and flavor standards",
    ar: "اختبارات مخبرية صارمة تضمن معايير النقاء والحموضة والنكهة",
  },
  "production.step4.title": { en: "Packaging", ar: "التعبئة" },
  "production.step4.desc": {
    en: "Sealed in premium containers to preserve freshness and quality",
    ar: "يُعبّأ في عبوات فاخرة للحفاظ على الطزاجة والجودة",
  },

  // Virgin Olive Oil Classification
  "virgin.subtitle": { en: "Virgin Olive Oil", ar: "زيت الزيتون البكر" },
  "virgin.title": { en: "Quality Classification", ar: "تصنيف زيت الزيتون البكر حسب الجودة" },
  "virgin.intro": {
    en: "A. Virgin olive oil: oil produced by pressing and crushing olive fruits using natural methods. This grade is divided into the following types:",
    ar: "أ. زيت زيتون بكر (Virgin olive oil): هو زيت ناتج عن عصر وكبس ثمار الزيتون باستخدام طرق طبيعية. وتقسم هذه الدرجة من زيت الزيتون إلى الأنواع التالية:",
  },
  "virgin.extra.label": { en: "1", ar: "١" },
  "virgin.extra.title": { en: "Extra Virgin Olive Oil", ar: "زيت بكر ممتاز (Extra virgin olive oil)" },
  "virgin.extra.desc": {
    en: "An exceptionally excellent oil in taste and aroma, with free acidity expressed as oleic acid not exceeding 0.8 g/100 g, and excellent sensory characteristics (taste and other related factors).",
    ar: "هو زيت فوق الممتاز في الطعم والرائحة، ولا تزيد حموضته الحرة المعبر عنها بحمض الأوليك عن 0.8 غرام/100 غم، مع صفات حسية ممتازة تم تحديدها (الطعم وعدد آخر من العوامل ذات العلاقة).",
  },
  "virgin.extra.imageAlt": { en: "Extra virgin olive oil", ar: "زيت زيتون بكر ممتاز" },
  "virgin.fine.label": { en: "2", ar: "٢" },
  "virgin.fine.title": { en: "Fine Virgin Olive Oil", ar: "زيت الزيتون البكر (Fine virgin olive oil)" },
  "virgin.fine.desc": {
    en: "An excellent oil in taste and aroma like Extra, but with higher acidity not exceeding 2 g per 100 g, with a fruity aroma, and color from light yellow to green.",
    ar: "هو زيت ممتاز في الطعم والرائحة مثل زيت الـ Extra عدا عن زيادة الحموضة فيه، بحيث لا تزيد عن 2 غم لكل 100 غم، وله رائحة فاكهية، ولونه أصفر فاتح إلى الأخضر.",
  },
  "virgin.fine.imageAlt": { en: "Fine virgin olive oil", ar: "زيت زيتون بكر" },
  "virgin.ordinary.label": { en: "3", ar: "٣" },
  "virgin.ordinary.title": { en: "Semi-fine (Ordinary) Virgin Olive Oil", ar: "زيت عادي (Semi-fine (ordinary) virgin olive oil)" },
  "virgin.ordinary.desc": {
    en: "A good oil in taste and aroma, with acidity not exceeding 3.3%. Note that in the three previous grades the peroxide value does not exceed 20 milliequivalents of peroxide/kg oil. These are edible oils with defined sensory characteristics.",
    ar: "هو زيت جيد في الطعم والرائحة، ولا تزيد حموضته عن 3.3%، مع العلم بأن الثلاث رتب السابقة من زيت الزيتون لا يزيد فيها رقم البيروكسيد عن 20 ملي مكافئ بيروكسيد/كغم زيت، وهي زيوت غذائية تتمتع بصفات حسية محددة.",
  },
  "virgin.ordinary.imageAlt": { en: "Ordinary virgin olive oil", ar: "زيت زيتون بكر عادي" },
  "virgin.unfit.label": { en: "4", ar: "٤" },
  "virgin.unfit.title": {
    en: "Virgin Olive Oil Not Fit for Consumption",
    ar: "زيت الزيتون البكر غير الصالح للاستهلاك",
  },
  "virgin.unfit.desc": {
    en: "Virgin olive oil with free acidity expressed as oleic acid greater than 3.3 g/100 g and/or organoleptic and other characteristics that match those specified for this category in this standard; it is intended for refining or technical use.",
    ar: "هو زيت الزيتون البكر الذي تبلغ حموضته الحرة المعبر عنها بحمض الأوليك أكثر من 3.3 غرام لكل 100 غرام، و/أو الخصائص العضوية وغيرها من الخصائص والتي تتوافق مع تلك التي حددت لهذه الفئة في هذا المعيار، فهو مخصص للتكرير أو للاستخدام التقني.",
  },
  "virgin.unfit.imageAlt": { en: "Virgin olive oil for refining", ar: "زيت زيتون بكر للتكرير" },

  // Contact
  "contact.subtitle": { en: "Get in Touch", ar: "تواصل معنا" },
  "contact.title": { en: "Let's Work Together", ar: "لنعمل معاً" },
  "contact.name": { en: "Your Name", ar: "اسمك" },
  "contact.email": { en: "name@example.com", ar: "name@example.com" },
  "contact.message": { en: "Your Message", ar: "رسالتك" },
  "contact.send": { en: "Send Message", ar: "إرسال الرسالة" },
  "contact.whatsapp": { en: "WhatsApp", ar: "واتساب" },
  "contact.address": { en: "Address", ar: "العنوان" },
  "contact.phone": { en: "Phone", ar: "الهاتف" },

  // Sell Products Modal
  "sell.title": {
    en: "Sell Your Products With Us",
    ar: "هل ترغب ببيع منتجاتك معنا؟",
  },
  "sell.description": {
    en: "Send your details and at least one photo. Our team will review and contact you.",
    ar: "أرسل بياناتك وصورة واحدة على الأقل، وسيتواصل معك فريقنا بعد المراجعة.",
  },
  "sell.name.label": { en: "Full Name", ar: "الاسم الكامل" },
  "sell.name.placeholder": { en: "Enter your name", ar: "أدخل اسمك" },
  "sell.phone.label": { en: "Phone Number", ar: "رقم الهاتف" },
  "sell.phone.placeholder": { en: "e.g. 09xx xxx xxx", ar: "مثال: 09xx xxx xxx" },
  "sell.photo.label": { en: "Product Photos (at least one)", ar: "صور المنتجات (صورة واحدة على الأقل)" },
  "sell.photo.hint": { en: "You can upload multiple images.", ar: "يمكنك رفع عدة صور." },
  "sell.photo.selected": { en: "Selected Photos", ar: "الصور المختارة" },
  "sell.photo.remove": { en: "Remove photo", ar: "حذف الصورة" },
  "sell.message.label": { en: "Optional Message", ar: "رسالة اختيارية" },
  "sell.message.placeholder": { en: "Tell us more about your products", ar: "أخبرنا المزيد عن منتجاتك" },
  "sell.submit": { en: "Send Request", ar: "إرسال الطلب" },
  "sell.toast": { en: "Request sent. We will contact you soon.", ar: "تم إرسال الطلب. سنعاود التواصل معك قريباً." },
  "sell.sticky": { en: "Sell Your Products", ar: "بيع منتجاتك" },

  // Footer
  "footer.rights": { en: "All rights reserved.", ar: "جميع الحقوق محفوظة." },
  "footer.tagline": { en: "Premium Olive Oil", ar: "زيت زيتون فاخر" },
  "footer.description": {
    en: "Bringing the authentic taste of the Mediterranean to your table through premium quality olive oils crafted with passion and tradition.",
    ar: "نقدّم لمائدتكم المذاق الأصيل للبحر المتوسط من خلال زيوت زيتون فاخرة مصنوعة بشغف وتقاليد عريقة.",
  },
  "footer.quicklinks": { en: "Quick Links", ar: "روابط سريعة" },
  "footer.contactinfo": { en: "Contact Info", ar: "معلومات التواصل" },
  "footer.address.value": {
    en: "Hama, Syria",
    ar: "سوريا، حماة",
  },
  "footer.crafted": {
    en: "Crafted with love & olive oil",
    ar: "صُنع بحب وزيت الزيتون",
  },

  // Loading
  "loading.tagline": { en: "Premium Olive Oil", ar: "زيت زيتون فاخر" },
};

const LanguageContext = createContext<LanguageContextType | undefined>(
  undefined,
);

export function LanguageProvider({ children }: { children: ReactNode }) {
  const [language, setLanguage] = useState<Language>("ar");

  const toggleLanguage = useCallback(() => {
    setLanguage((prev) => (prev === "en" ? "ar" : "en"));
  }, []);

  const t = useCallback(
    (key: string) => translations[key]?.[language] || key,
    [language],
  );

  const dir = language === "ar" ? "rtl" : "ltr";

  return (
    <LanguageContext.Provider value={{ language, toggleLanguage, t, dir }}>
      <div dir={dir}>{children}</div>
    </LanguageContext.Provider>
  );
}

export function useLanguage() {
  const context = useContext(LanguageContext);
  if (!context)
    throw new Error("useLanguage must be used within LanguageProvider");
  return context;
}
