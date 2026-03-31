import { motion, AnimatePresence } from "framer-motion";
import { useSiteBranding } from "@/contexts/useSiteBranding";
import logo from "@/assets/logo.png";
import oliveBranch from "@/assets/olive.png";

interface LoadingScreenProps {
  isLoading: boolean;
}

const LoadingScreen = ({ isLoading }: LoadingScreenProps) => {
  const { logoUrl } = useSiteBranding();
  const brandLogo = logoUrl || logo;

  return (
    <AnimatePresence>
      {isLoading && (
        <motion.div
          className="fixed inset-0 z-[100] flex flex-col items-center justify-center bg-primary gap-10 sm:gap-6"
          exit={{ opacity: 0 }}
          transition={{ duration: 1, ease: "easeInOut" }}
        >
          {/* Decorative olive branches */}
          {[
            { top: "10%", left: "8%", size: "w-32 h-32", opacity: "opacity-10", rotate: 360, duration: 28 },
            { top: "16%", left: "70%", size: "w-32 h-32", opacity: "opacity-8", rotate: -360, duration: 32 },
            { top: "40%", left: "10%", size: "w-32 h-32", opacity: "opacity-8", rotate: 360, duration: 26 },
            { top: "52%", left: "78%", size: "w-32 h-32", opacity: "opacity-10", rotate: -360, duration: 30 },
            { top: "70%", left: "28%", size: "w-32 h-32", opacity: "opacity-8", rotate: 360, duration: 34 },
            { top: "78%", left: "60%", size: "w-32 h-32", opacity: "opacity-8", rotate: -360, duration: 25 },
            { top: "24%", left: "40%", size: "w-32 h-32", opacity: "opacity-8", rotate: 360, duration: 27 },
            { top: "62%", left: "50%", size: "w-32 h-32", opacity: "opacity-10", rotate: -360, duration: 31 },
          ].map((item, i) => (
            <motion.div
              key={i}
              className={`absolute ${item.size} ${item.opacity}`}
              style={{ top: item.top, left: item.left }}
              animate={{
                x: [0, 6, 0, -6, 0],
                y: [0, -4, 0, 4, 0],
                rotate: [-1.5, 1.5, -1.5],
                scale: [1, 1.03, 1],
              }}
              transition={{
                duration: item.duration,
                repeat: Infinity,
                ease: "easeInOut",
                delay: i * 0.2,
              }}
            >
              <motion.img
                src={oliveBranch}
                alt=""
                className="w-full h-full object-contain"
                aria-hidden="true"
                initial={{ scale: 0.5, opacity: 0 }}
                animate={{ scale: 1, opacity: 1, rotate: 360 }}
                transition={{
                  scale: { duration: 1, ease: [0.22, 1, 0.36, 1] },
                  opacity: { duration: 1, ease: [0.22, 1, 0.36, 1] },
                  rotate: { duration: 18, repeat: Infinity, ease: "linear" },
                }}
              />
            </motion.div>
          ))}

          {/* Logo / Brand */}
          <motion.div
            initial={{ scale: 0.5, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            transition={{ duration: 1, ease: [0.22, 1, 0.36, 1] }}
            className="relative flex flex-col items-center"
          >
            <motion.div
              className="h-36 w-36 mx-auto mt-4 sm:mt-0 overflow-hidden"
              style={{ transformOrigin: "bottom" }}
              initial={{ scaleY: 0, opacity: 0 }}
              animate={{ scaleY: 1, opacity: 1 }}
              transition={{ duration: 1, delay: 0.4, ease: "easeOut" }}
            >
              <img
                src={brandLogo}
                alt="Ajaj"
                className="h-full w-full object-contain"
              />
            </motion.div>

            <motion.p
              className="mt-6 text-center text-sm sm:text-base text-primary-foreground/80 font-body"
              initial={{ y: 10, opacity: 0 }}
              animate={{ y: 0, opacity: 1 }}
              transition={{ duration: 0.8, delay: 1 }}
            >
              الزيتون و مشتقاته فخرنا و اهتمامنا
            </motion.p>
          </motion.div>

          {/* Loading bar */}
          <motion.div
            className="mt-10 sm:mt-6 w-48 h-[4px] bg-primary-foreground/10 rounded-full overflow-hidden"
          >
            <motion.div
              className="h-full bg-gradient-gold rounded-full"
              initial={{ width: "0%" }}
              animate={{ width: "100%" }}
              transition={{ duration: 2.5, ease: "easeInOut" }}
            />
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
};

export default LoadingScreen;
