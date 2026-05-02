import FadeUp from './FadeUp'

const pillars = [
  {
    icon: '🔒',
    title: 'Privacy-first',
    body: 'Anonymous auth. No PII. Your identity never leaves your device. Zero stored data that could be used against you.',
  },
  {
    icon: '🆘',
    title: 'Emergency SOS',
    body: 'Hold 3 seconds. Your trusted contacts get an SMS with a live map link. A 60-second cancel window keeps you in control.',
  },
  {
    icon: '⚖️',
    title: 'Know Your Rights',
    body: 'CHIRLA and ILRC-verified legal language in English and Spanish. What to say, what to do — always one tap away.',
  },
]

export default function FeaturePillars() {
  return (
    <section id="features" className="py-24 border-t border-white/8">
      <div className="max-w-6xl mx-auto px-6">
        <FadeUp>
          <p className="text-xs font-mono text-muted uppercase tracking-widest mb-4">What it does</p>
          <h2 className="font-display font-bold text-4xl md:text-5xl text-cream mb-16">
            A new kind of <em className="font-serif not-italic">safety</em> app.
          </h2>
        </FadeUp>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          {pillars.map((pillar, i) => (
            <FadeUp key={pillar.title} delay={i * 0.1}>
              <div className="rounded-2xl bg-surface border border-white/8 p-6 h-full">
                <div className="text-2xl mb-4">{pillar.icon}</div>
                <h3 className="font-display font-semibold text-lg text-cream mb-2">{pillar.title}</h3>
                <p className="text-sm text-muted font-sans leading-relaxed">{pillar.body}</p>
              </div>
            </FadeUp>
          ))}
        </div>
      </div>
    </section>
  )
}
