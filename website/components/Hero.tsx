'use client'

import { motion } from 'framer-motion'
import { fadeUp, stagger, float } from '@/lib/motion'
import PhoneMockup from './PhoneMockup'

export default function Hero() {
  return (
    <section className="relative min-h-screen flex flex-col justify-center pt-14 overflow-hidden">
      <div className="absolute inset-0 pointer-events-none">
        <div className="absolute top-1/4 left-1/4 w-96 h-96 bg-[#F39A1E]/5 rounded-full blur-3xl" />
      </div>

      <div className="max-w-6xl mx-auto px-6 py-24 grid grid-cols-1 lg:grid-cols-2 gap-20 items-center">
        <motion.div variants={stagger} initial="hidden" animate="visible" className="flex flex-col gap-8">
          <motion.h1
            variants={fadeUp}
            className="font-display font-bold text-5xl md:text-6xl lg:text-7xl text-cream"
            style={{ lineHeight: '1.08', letterSpacing: '-0.02em' }}
          >
            Keep your family safe without{' '}
            <em className="font-serif not-italic">giving anything</em>{' '}
            away.
          </motion.h1>
        </motion.div>

        <motion.div variants={stagger} initial="hidden" animate="visible" className="flex flex-col gap-7">
          <motion.div variants={fadeUp} className="flex items-center gap-2">
            <div className="w-2 h-2 rounded-full bg-orange animate-pulse" />
            <span className="text-sm text-muted font-sans">
              New: Bilingual support + Know Your Rights card
            </span>
            <span className="text-muted/40">→</span>
          </motion.div>

          <motion.p variants={fadeUp} className="text-lg text-muted font-sans leading-relaxed">
            Acción shares your real-time location with trusted contacts. One hold sends an SOS.
            No account, no email, nothing stored.
          </motion.p>

          <motion.div variants={fadeUp} className="flex flex-wrap gap-3">
            <a
              href="#"
              className="px-6 py-3 rounded-full bg-cream text-bg font-semibold font-sans text-sm hover:bg-cream/90 transition-colors"
            >
              Download on App Store
            </a>
            <a
              href="#how-it-works"
              className="px-6 py-3 rounded-full border border-white/20 text-cream font-semibold font-sans text-sm hover:border-white/40 transition-colors"
            >
              See how it works
            </a>
          </motion.div>
        </motion.div>
      </div>

      <div className="max-w-6xl mx-auto px-6 pb-24">
        <motion.div
          initial={{ opacity: 0, y: 60 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4, duration: 0.8, ease: 'easeOut' }}
          className="flex justify-center items-end gap-4"
        >
          <div className="opacity-60 -rotate-6 translate-y-4">
            <PhoneMockup variant="kyr" scale={0.85} />
          </div>
          <motion.div animate="animate" variants={float}>
            <PhoneMockup variant="map" scale={1} />
          </motion.div>
          <div className="opacity-60 rotate-6 translate-y-4">
            <PhoneMockup variant="sos" scale={0.85} />
          </div>
        </motion.div>
      </div>
    </section>
  )
}
