'use client'

import { motion } from 'framer-motion'
import PhoneMockup from './PhoneMockup'

function MapBackground() {
  return (
    <div className="absolute inset-0 overflow-hidden pointer-events-none">
      {/* Map grid */}
      <div
        className="absolute inset-0"
        style={{
          backgroundImage: `
            linear-gradient(rgba(247,243,237,0.04) 1px, transparent 1px),
            linear-gradient(90deg, rgba(247,243,237,0.04) 1px, transparent 1px)
          `,
          backgroundSize: '56px 56px',
        }}
      />

      {/* Drifting gradient orbs */}
      <motion.div
        className="absolute rounded-full blur-3xl"
        style={{ width: 520, height: 320, top: '20%', right: '15%', background: 'rgba(243,154,30,0.07)' }}
        animate={{ x: [0, 28, -18, 0], y: [0, -22, 18, 0], scale: [1, 1.08, 0.96, 1] }}
        transition={{ duration: 18, repeat: Infinity, ease: 'easeInOut' }}
      />
      <motion.div
        className="absolute rounded-full blur-3xl"
        style={{ width: 380, height: 260, bottom: '25%', left: '20%', background: 'rgba(142,42,11,0.07)' }}
        animate={{ x: [0, -22, 16, 0], y: [0, 20, -18, 0], scale: [1, 0.94, 1.06, 1] }}
        transition={{ duration: 22, repeat: Infinity, ease: 'easeInOut', delay: 4 }}
      />

      {/* Location ping dots */}
      {[
        { top: '30%', left: '63%', delay: 0 },
        { top: '54%', left: '73%', delay: 1.4 },
        { top: '40%', left: '81%', delay: 2.8 },
      ].map((dot, i) => (
        <div key={i} className="absolute" style={{ top: dot.top, left: dot.left }}>
          <motion.div
            className="absolute rounded-full bg-orange/60"
            style={{ width: 8, height: 8, top: -4, left: -4 }}
            animate={{ scale: [1, 3, 1], opacity: [0.6, 0, 0.6] }}
            transition={{ duration: 2.6, repeat: Infinity, ease: 'easeOut', delay: dot.delay }}
          />
          <div className="w-2 h-2 rounded-full bg-orange/80" />
        </div>
      ))}
    </div>
  )
}

const container = {
  hidden: {},
  visible: { transition: { staggerChildren: 0.11 } },
}

const line = {
  hidden: { opacity: 0, y: 28 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.75, ease: 'easeOut' as const } },
}

export default function Hero() {
  return (
    <section className="relative min-h-screen flex items-center pt-14 overflow-hidden">
      <MapBackground />

      {/* Bottom vignette */}
      <div
        className="absolute inset-0 pointer-events-none"
        style={{
          background:
            'radial-gradient(ellipse 100% 50% at 50% 110%, var(--color-bg) 30%, transparent 80%)',
        }}
      />

      <div className="relative max-w-6xl mx-auto px-6 w-full grid grid-cols-1 lg:grid-cols-2 gap-12 lg:gap-20 items-center py-20 lg:py-28">
        {/* Text column */}
        <motion.div
          variants={container}
          initial="hidden"
          animate="visible"
          className="flex flex-col gap-7"
        >
          <motion.div variants={line} className="flex items-center gap-2">
            <motion.span
              className="w-1.5 h-1.5 rounded-full bg-orange"
              animate={{ opacity: [1, 0.3, 1] }}
              transition={{ duration: 1.8, repeat: Infinity }}
            />
            <span className="text-xs font-mono text-muted uppercase tracking-widest">
              Live location safety
            </span>
          </motion.div>

          <motion.h1
            variants={line}
            className="font-display font-bold text-cream"
            style={{
              fontSize: 'clamp(2.6rem, 5.5vw, 4.25rem)',
              lineHeight: 1.07,
              letterSpacing: '-0.025em',
            }}
          >
            Keep your family safe without{' '}
            <em className="font-serif not-italic">giving anything</em> away.
          </motion.h1>

          <motion.p variants={line} className="text-lg text-muted font-sans leading-relaxed max-w-md">
            Real-time location sharing, a one-press SOS, and Know Your Rights. All anonymous. No account. No stored identity.
          </motion.p>

          <motion.div variants={line} className="flex flex-wrap gap-3">
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
              How it works
            </a>
          </motion.div>
        </motion.div>

        {/* Phone stack with frame draw-in */}
        <div className="flex justify-center lg:justify-end items-end gap-4">
          <motion.div
            className="-rotate-6 translate-y-4"
            initial={{ opacity: 0, y: 60 }}
            animate={{ opacity: 0.55, y: 16 }}
            transition={{ delay: 0.45, duration: 0.9, ease: 'easeOut' as const }}
          >
            <PhoneMockup variant="kyr" scale={0.84} />
          </motion.div>

          {/* Center phone with frame reveal */}
          <div className="relative">
            <motion.div
              className="absolute pointer-events-none z-20 rounded-[40px]"
              style={{ inset: -2 }}
            >
              <motion.div
                className="w-full h-full rounded-[40px]"
                style={{ border: '1.5px solid rgba(247,243,237,0.22)' }}
                initial={{ clipPath: 'inset(100% 0% 0% 0% round 40px)' }}
                animate={{ clipPath: 'inset(0% 0% 0% 0% round 40px)' }}
                transition={{ delay: 0.3, duration: 1.2, ease: 'easeOut' as const }}
              />
            </motion.div>
            <motion.div
              initial={{ opacity: 0, y: 50 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2, duration: 0.95, ease: 'easeOut' as const }}
            >
              <PhoneMockup variant="map" animate scale={1} />
            </motion.div>
          </div>

          <motion.div
            className="rotate-6 translate-y-4"
            initial={{ opacity: 0, y: 60 }}
            animate={{ opacity: 0.55, y: 16 }}
            transition={{ delay: 0.6, duration: 0.9, ease: 'easeOut' as const }}
          >
            <PhoneMockup variant="sos" scale={0.84} />
          </motion.div>
        </div>
      </div>

      {/* Scroll cue */}
      <motion.div
        className="absolute bottom-8 left-1/2 -translate-x-1/2 flex flex-col items-center gap-2"
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 1.5, duration: 0.6 }}
      >
        <span className="text-[10px] font-mono text-muted/40 uppercase tracking-widest">Scroll</span>
        <motion.div
          className="w-px h-7 bg-gradient-to-b from-muted/40 to-transparent"
          style={{ transformOrigin: 'top' }}
          animate={{ scaleY: [0, 1, 0] }}
          transition={{ duration: 1.8, repeat: Infinity, ease: 'easeInOut', delay: 1.7 }}
        />
      </motion.div>
    </section>
  )
}
