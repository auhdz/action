import type { Variants } from 'framer-motion'

export const fadeUp: Variants = {
  hidden: { opacity: 0, y: 40 },
  visible: {
    opacity: 1,
    y: 0,
    transition: { duration: 0.6, ease: 'easeOut' },
  },
}

export const stagger: Variants = {
  hidden: {},
  visible: {
    transition: { staggerChildren: 0.1 },
  },
}

export const float: Variants = {
  animate: {
    y: [0, -10, 0],
    transition: { duration: 4, repeat: Infinity, ease: 'easeInOut' },
  },
}
