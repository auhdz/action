import FadeUp from './FadeUp'

const freeTier = [
  'SOS button (up to 3 trusted contacts)',
  'Know Your Rights card',
  'Private web viewer link for family',
  'Full English + Spanish support',
  'No account required',
]

const familiaTier = [
  'Everything in Free',
  'Up to 5 trusted contacts',
  'Family dashboard (proactive status view)',
  'Check-in timer with auto-alert',
  'Community safety map access',
  'Priority SMS delivery',
]

function CheckIcon() {
  return (
    <svg className="w-4 h-4 flex-shrink-0" viewBox="0 0 16 16" fill="none">
      <path d="M3 8l3.5 3.5L13 4" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  )
}

export default function Pricing() {
  return (
    <section id="pricing" className="py-28">
      <div className="max-w-6xl mx-auto px-6">
        <FadeUp>
          <p className="text-xs font-mono text-muted uppercase tracking-widest mb-4">Pricing</p>
          <h2 className="font-display font-bold text-4xl md:text-5xl text-cream mb-4 tracking-tight">
            Safety should be <em className="font-serif not-italic">accessible.</em>
          </h2>
          <p className="text-lg text-muted font-sans mb-16 max-w-xl">
            The core SOS button is always free. Upgrade to Familia for your whole family network.
          </p>
        </FadeUp>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 max-w-3xl">
          <FadeUp delay={0.05}>
            <div className="rounded-2xl bg-surface border border-white/8 p-8 flex flex-col gap-6 h-full">
              <div>
                <p className="text-xs font-mono text-muted uppercase tracking-widest mb-2">Free</p>
                <div className="flex items-baseline gap-2">
                  <span className="font-display font-bold text-4xl text-cream">$0</span>
                  <span className="text-muted font-sans text-sm">/ forever</span>
                </div>
              </div>
              <ul className="flex flex-col gap-3 flex-1">
                {freeTier.map((f) => (
                  <li key={f} className="flex items-start gap-3 text-sm font-sans text-muted">
                    <span className="text-muted/50 mt-0.5"><CheckIcon /></span>
                    {f}
                  </li>
                ))}
              </ul>
              <a
                href="#"
                className="text-center px-6 py-3 rounded-full border border-white/20 text-cream font-semibold font-sans text-sm hover:border-white/40 transition-colors"
              >
                Download on App Store
              </a>
            </div>
          </FadeUp>

          <FadeUp delay={0.1}>
            <div className="rounded-2xl bg-surface border border-white/20 p-8 flex flex-col gap-6 h-full relative overflow-hidden">
              <div className="absolute top-0 right-0 px-3 py-1.5 bg-orange/15 rounded-bl-xl">
                <span className="text-xs font-mono font-medium text-orange uppercase tracking-widest">Familia</span>
              </div>
              <div>
                <p className="text-xs font-mono text-muted uppercase tracking-widest mb-2">Familia</p>
                <div className="flex items-baseline gap-2">
                  <span className="font-display font-bold text-4xl text-cream">$4</span>
                  <span className="text-muted font-sans text-sm">/ month</span>
                </div>
              </div>
              <ul className="flex flex-col gap-3 flex-1">
                {familiaTier.map((f) => (
                  <li key={f} className="flex items-start gap-3 text-sm font-sans text-muted">
                    <span className="text-orange mt-0.5"><CheckIcon /></span>
                    {f}
                  </li>
                ))}
              </ul>
              <a
                href="#"
                className="text-center px-6 py-3 rounded-full bg-cream text-bg font-semibold font-sans text-sm hover:bg-cream/90 transition-colors"
              >
                Get Familia
              </a>
            </div>
          </FadeUp>
        </div>

        <FadeUp delay={0.2}>
          <p className="text-xs text-muted font-sans mt-8">
            Acción is community-funded.{' '}
            <a href="mailto:taquestudios@gmail.com" className="underline underline-offset-2 hover:text-cream transition-colors">
              Contact us
            </a>{' '}
            to support the project or learn about partnerships.
          </p>
        </FadeUp>
      </div>
    </section>
  )
}
