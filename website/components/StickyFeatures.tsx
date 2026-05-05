'use client'

import { useRef } from 'react'
import { motion, useScroll, useTransform, type MotionValue } from 'framer-motion'
import PhoneMockup from './PhoneMockup'

type Variant = 'map' | 'sos' | 'kyr' | 'web'

interface Feature {
  label: string
  headline: string
  italic: string
  body: string
  variant: Variant
  flip?: boolean
  glow?: string
}

const features: Feature[] = [
  {
    label: 'Location',
    headline: 'Your family always knows',
    italic: 'where you are.',
    body: 'Acción syncs your GPS location to trusted contacts in real time. They see your exact position on a live map. No app download needed.',
    variant: 'map',
  },
  {
    label: 'SOS',
    headline: 'One hold. Help is',
    italic: 'on the way.',
    body: 'Press and hold 3 seconds. Acción sends an SMS to your trusted contacts with a secure web link to your live location. A 60-second cancel window keeps you in control.',
    variant: 'sos',
    flip: true,
    glow: 'rgba(142, 42, 11, 0.06)',
  },
  {
    label: 'Know Your Rights',
    headline: 'Know your rights in',
    italic: 'any situation.',
    body: 'CHIRLA and ILRC-verified legal language. What to say, what to do. Available in English and Spanish, always inside the app.',
    variant: 'kyr',
  },
  {
    label: 'Web Viewer',
    headline: 'Family sees you.',
    italic: 'No app required.',
    body: 'When you share your location, your contacts get a link. They open it in any browser and see your real-time position. Nothing to install.',
    variant: 'web',
    flip: true,
  },
]

interface CardProps {
  feature: Feature
  index: number
  total: number
  progress: MotionValue<number>
}

function FeatureCard({ feature, index, total, progress }: CardProps) {
  const isFirst = index === 0
  const isLast = index === total - 1
  const N = total
  const start = index / N
  const end = (index + 1) / N
  const overlap = 0.13

  // Y: first card starts at 0, others slide up from below
  const yKeys = isFirst
    ? [end - overlap, end]
    : [Math.max(0, start - overlap), start, end - overlap, end]
  const yVals = isFirst
    ? ['0%', isLast ? '0%' : '-5%']
    : ['108%', '0%', '0%', isLast ? '0%' : '-5%']

  // Scale: cards behind shrink slightly
  const scaleKeys = [end - overlap, end]
  const scaleVals: [number, number] = [1, isLast ? 1 : 0.94]

  const y = useTransform(progress, yKeys, yVals)
  const scale = useTransform(progress, scaleKeys, scaleVals)

  return (
    <motion.div
      style={{ y, scale, zIndex: index + 1, transformOrigin: 'top center' }}
      className="absolute inset-0 bg-bg flex items-center justify-center overflow-hidden"
    >
      {/* Per-card glow */}
      {feature.glow && (
        <div
          className="absolute inset-0 pointer-events-none"
          style={{
            background: `radial-gradient(ellipse 70% 50% at 50% 50%, ${feature.glow}, transparent)`,
          }}
        />
      )}

      {/* Card edge visible when stacked */}
      {!isFirst && (
        <div
          className="absolute top-0 left-0 right-0 h-px"
          style={{ background: 'rgba(247,243,237,0.06)' }}
        />
      )}

      <div
        className={`max-w-6xl w-full mx-auto px-6 grid grid-cols-1 lg:grid-cols-2 gap-12 lg:gap-20 items-center ${
          feature.flip ? 'lg:[&>:first-child]:order-2' : ''
        }`}
      >
        {/* Text */}
        <div className="flex flex-col gap-5">
          <span className="text-xs font-mono text-muted uppercase tracking-widest">
            {feature.label}
          </span>
          <h2
            className="font-display font-bold text-cream"
            style={{
              fontSize: 'clamp(2.2rem, 4.5vw, 3.5rem)',
              lineHeight: 1.1,
              letterSpacing: '-0.02em',
            }}
          >
            {feature.headline}{' '}
            <em className="font-serif not-italic">{feature.italic}</em>
          </h2>
          <p className="text-lg text-muted font-sans leading-relaxed max-w-md">{feature.body}</p>
        </div>

        {/* Phone */}
        <div className="flex justify-center">
          <PhoneMockup variant={feature.variant} animate />
        </div>
      </div>
    </motion.div>
  )
}

export default function StickyFeatures() {
  const containerRef = useRef<HTMLDivElement>(null)
  const { scrollYProgress } = useScroll({
    target: containerRef,
    offset: ['start start', 'end end'],
  })

  return (
    <section
      ref={containerRef}
      style={{ height: `calc(${features.length + 1} * 100vh)` }}
      aria-label="Features"
    >
      <div className="sticky top-0 h-screen overflow-hidden">
        {features.map((feature, i) => (
          <FeatureCard
            key={feature.label}
            feature={feature}
            index={i}
            total={features.length}
            progress={scrollYProgress}
          />
        ))}
      </div>
    </section>
  )
}
