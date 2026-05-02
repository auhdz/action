'use client'

import { motion, useInView } from 'framer-motion'
import { useRef } from 'react'

interface FadeUpProps {
  children: React.ReactNode
  className?: string
  delay?: number
}

export default function FadeUp({ children, className, delay = 0 }: FadeUpProps) {
  const ref = useRef(null)
  const isInView = useInView(ref, { once: true, margin: '-80px' })

  return (
    <motion.div
      ref={ref}
      className={className}
      initial={{ opacity: 0, y: 40 }}
      animate={isInView ? { opacity: 1, y: 0 } : { opacity: 0, y: 40 }}
      transition={{ duration: 0.6, ease: 'easeOut' as const, delay }}
    >
      {children}
    </motion.div>
  )
}
