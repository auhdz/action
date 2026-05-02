import FadeUp from './FadeUp'

const features = [
  'Real-time location sharing',
  'SOS alerts to trusted contacts',
  'Know Your Rights card',
  'Full English + Spanish support',
  'No account required',
  'Web viewer for family (no app needed)',
]

export default function Pricing() {
  return (
    <section id="privacy" className="py-24 border-t border-white/8">
      <div className="max-w-6xl mx-auto px-6">
        <FadeUp>
          <h2 className="font-display font-bold text-4xl md:text-5xl text-cream mb-12 text-center">
            Free. <em className="font-serif not-italic">Always.</em>
          </h2>
        </FadeUp>
        <FadeUp delay={0.1}>
          <div className="max-w-md mx-auto rounded-2xl bg-surface border border-white/8 p-8 flex flex-col gap-6">
            <div>
              <p className="text-xs font-mono text-muted uppercase tracking-widest mb-1">Community Edition</p>
              <div className="flex items-baseline gap-2">
                <span className="font-display font-bold text-5xl text-cream">$0</span>
                <span className="text-muted font-sans">/ forever</span>
              </div>
            </div>
            <ul className="flex flex-col gap-3">
              {features.map((f) => (
                <li key={f} className="flex items-center gap-3 text-sm font-sans text-muted">
                  <svg className="w-4 h-4 text-orange flex-shrink-0" viewBox="0 0 16 16" fill="none">
                    <path d="M3 8l3.5 3.5L13 4" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
                  </svg>
                  {f}
                </li>
              ))}
            </ul>
            <a
              href="#"
              className="text-center px-6 py-3 rounded-full bg-cream text-bg font-semibold font-sans text-sm hover:bg-cream/90 transition-colors"
            >
              Download on App Store
            </a>
          </div>
        </FadeUp>
        <FadeUp delay={0.2}>
          <p className="text-center text-xs text-muted font-sans mt-6">
            Acción is community-funded.{' '}
            <a href="mailto:taquestudios@gmail.com" className="underline underline-offset-2 hover:text-cream transition-colors">
              Contact us
            </a>{' '}
            if you&apos;d like to support the project.
          </p>
        </FadeUp>
      </div>
    </section>
  )
}
