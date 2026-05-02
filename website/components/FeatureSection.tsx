import FadeUp from './FadeUp'
import PhoneMockup from './PhoneMockup'
import type { ComponentProps } from 'react'

type MockupVariant = ComponentProps<typeof PhoneMockup>['variant']

interface FeatureSectionProps {
  headline: React.ReactNode
  body: string
  variant: MockupVariant
  flip?: boolean
  glow?: string
}

export default function FeatureSection({
  headline,
  body,
  variant,
  flip = false,
  glow,
}: FeatureSectionProps) {
  return (
    <section className="py-28 relative overflow-hidden">
      {glow && (
        <div
          className="absolute inset-0 pointer-events-none"
          style={{ background: `radial-gradient(ellipse at center, ${glow} 0%, transparent 70%)` }}
        />
      )}
      <div
        className={`max-w-6xl mx-auto px-6 grid grid-cols-1 lg:grid-cols-2 gap-16 items-center ${
          flip ? 'lg:[&>*:first-child]:order-2' : ''
        }`}
      >
        <div className="flex flex-col gap-5">
          <FadeUp>
            <h2 className="font-display font-bold text-4xl md:text-5xl text-cream leading-tight tracking-tight">
              {headline}
            </h2>
          </FadeUp>
          <FadeUp delay={0.08}>
            <p className="text-lg text-muted font-sans leading-relaxed">{body}</p>
          </FadeUp>
        </div>
        <FadeUp delay={0.15} className="flex justify-center">
          <PhoneMockup variant={variant} animate />
        </FadeUp>
      </div>
    </section>
  )
}
