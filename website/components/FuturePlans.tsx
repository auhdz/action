import FadeUp from './FadeUp'

function AndroidIcon() {
  return (
    <svg className="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
      <rect x="5" y="2" width="14" height="20" rx="2" />
      <line x1="12" y1="18" x2="12" y2="18.5" strokeWidth="2" />
    </svg>
  )
}

function HardwareIcon() {
  return (
    <svg className="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="12" cy="12" r="3" />
      <path d="M12 2v3M12 19v3M2 12h3M19 12h3" />
      <path d="M4.93 4.93l2.12 2.12M16.95 16.95l2.12 2.12M4.93 19.07l2.12-2.12M16.95 7.05l2.12-2.12" />
    </svg>
  )
}

function MapPinIcon() {
  return (
    <svg className="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
      <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z" />
      <circle cx="12" cy="9" r="2.5" />
    </svg>
  )
}

const plans = [
  {
    icon: <AndroidIcon />,
    tag: 'Coming next',
    title: 'Acción for Android',
    body: 'Over 80% of smartphones in Latin America run Android. The community Acción is built for should not be limited to iPhone. Android launch follows iOS with full feature parity and direct APK distribution — no app store required.',
    timeline: 'Q3 2026',
  },
  {
    icon: <HardwareIcon />,
    tag: 'The original vision',
    title: 'Acción Hardware',
    body: 'A discreet wearable panic button. One press sends your location to trusted contacts without reaching for your phone. Acción started as a hardware project — the software is the MVP. The device is the roadmap.',
    timeline: '2027',
  },
  {
    icon: <MapPinIcon />,
    tag: 'In development',
    title: 'Community Safety Network',
    body: 'Neighborhood-level safety reports from verified community organizations. A real-time map of how your neighbors feel nearby — built on trust, never on speculation. Launching with partner orgs before opening to the public.',
    timeline: 'v1.5',
  },
]

export default function FuturePlans() {
  return (
    <section id="future-plans" className="py-28">
      <div className="max-w-6xl mx-auto px-6">
        <FadeUp>
          <p className="text-xs font-mono text-muted uppercase tracking-widest mb-4">Roadmap</p>
          <h2 className="font-display font-bold text-4xl md:text-5xl text-cream mb-4 tracking-tight">
            The software is live.{' '}
            <em className="font-serif not-italic">The hardware is next.</em>
          </h2>
          <p className="text-lg text-muted font-sans mb-16 max-w-xl">
            Acción started as a hardware wearable. We built software first because the community needed it now. Here is what comes next.
          </p>
        </FadeUp>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          {plans.map((plan, i) => (
            <FadeUp key={plan.title} delay={i * 0.1}>
              <div className="rounded-2xl bg-surface border border-white/8 p-8 flex flex-col gap-4 h-full">
                <div className="flex items-center justify-between">
                  <span className="text-orange">{plan.icon}</span>
                  <span className="text-xs font-mono text-muted/60 uppercase tracking-widest">{plan.timeline}</span>
                </div>
                <div>
                  <p className="text-xs font-mono text-orange/70 uppercase tracking-widest mb-2">{plan.tag}</p>
                  <h3 className="font-display font-semibold text-xl text-cream mb-3">{plan.title}</h3>
                  <p className="text-sm text-muted font-sans leading-relaxed">{plan.body}</p>
                </div>
              </div>
            </FadeUp>
          ))}
        </div>

        <FadeUp delay={0.3}>
          <p className="text-xs text-muted font-sans mt-10">
            Interested in the hardware project or want to contribute?{' '}
            <a href="mailto:taquestudios@gmail.com" className="underline underline-offset-2 hover:text-cream transition-colors">
              Get in touch.
            </a>
          </p>
        </FadeUp>
      </div>
    </section>
  )
}
