import FadeUp from './FadeUp'

function LockIcon() {
  return (
    <svg width="22" height="22" viewBox="0 0 22 22" fill="none" aria-hidden="true">
      <rect x="4" y="10" width="14" height="10" rx="2.5" stroke="currentColor" strokeWidth="1.5" />
      <path d="M7 10V7a4 4 0 0 1 8 0v3" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" />
      <circle cx="11" cy="15" r="1.25" fill="currentColor" />
    </svg>
  )
}

function AlertIcon() {
  return (
    <svg width="22" height="22" viewBox="0 0 22 22" fill="none" aria-hidden="true">
      <circle cx="11" cy="11" r="8.25" stroke="currentColor" strokeWidth="1.5" />
      <path d="M11 7v5" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" />
      <circle cx="11" cy="15" r="1" fill="currentColor" />
    </svg>
  )
}

function ScalesIcon() {
  return (
    <svg width="22" height="22" viewBox="0 0 22 22" fill="none" aria-hidden="true">
      <path d="M11 3v16" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" />
      <path d="M7 19h8" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" />
      <path d="M4 7h14" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" />
      <path d="M4 7l-2 5c0 1.1.9 2 2 2s2-.9 2-2L4 7Z" stroke="currentColor" strokeWidth="1.5" strokeLinejoin="round" />
      <path d="M18 7l-2 5c0 1.1.9 2 2 2s2-.9 2-2L18 7Z" stroke="currentColor" strokeWidth="1.5" strokeLinejoin="round" />
    </svg>
  )
}

const pillars = [
  {
    Icon: LockIcon,
    title: 'Privacy-first',
    body: 'Anonymous auth. No PII. Your identity never leaves your device. Zero stored data that could be used against you.',
  },
  {
    Icon: AlertIcon,
    title: 'Emergency SOS',
    body: 'Hold 3 seconds. Your trusted contacts get an SMS with a live map link. A 60-second cancel window keeps you in control.',
  },
  {
    Icon: ScalesIcon,
    title: 'Know Your Rights',
    body: 'CHIRLA and ILRC-verified legal language in English and Spanish. What to say, what to do. Always one tap away.',
  },
]

export default function FeaturePillars() {
  return (
    <section id="features" className="py-28">
      <div className="max-w-6xl mx-auto px-6">
        <FadeUp>
          <p className="text-xs font-mono text-muted uppercase tracking-widest mb-4">What it does</p>
          <h2 className="font-display font-bold text-4xl md:text-5xl text-cream mb-16 tracking-tight">
            A new kind of <em className="font-serif not-italic">safety</em> app.
          </h2>
        </FadeUp>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          {pillars.map(({ Icon, title, body }, i) => (
            <FadeUp key={title} delay={i * 0.1}>
              <div className="rounded-2xl bg-surface border border-white/8 p-7 h-full">
                <div className="text-cream/70 mb-5">
                  <Icon />
                </div>
                <h3 className="font-display font-semibold text-lg text-cream mb-2">{title}</h3>
                <p className="text-sm text-muted font-sans leading-relaxed">{body}</p>
              </div>
            </FadeUp>
          ))}
        </div>
      </div>
    </section>
  )
}
