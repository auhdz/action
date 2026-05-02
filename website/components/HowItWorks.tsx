import FadeUp from './FadeUp'

const steps = [
  { n: '01', title: 'Download Acción', body: 'Free on the App Store. No account, no email required.' },
  { n: '02', title: 'Add trusted contacts', body: 'Choose who can see your location and receive your SOS alert.' },
  { n: '03', title: 'Stay connected', body: 'Your location updates automatically. Your contacts are always in the loop.' },
]

export default function HowItWorks() {
  return (
    <section id="how-it-works" className="py-28">
      <div className="max-w-6xl mx-auto px-6">
        <FadeUp>
          <p className="text-xs font-mono text-muted uppercase tracking-widest mb-4">Setup</p>
          <h2 className="font-display font-bold text-4xl md:text-5xl text-cream mb-16 tracking-tight">
            Three steps. That&apos;s <em className="font-serif not-italic">it.</em>
          </h2>
        </FadeUp>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {steps.map((step, i) => (
            <FadeUp key={step.n} delay={i * 0.1}>
              <div className="flex flex-col gap-4">
                <span className="font-mono text-5xl font-bold text-white/10">{step.n}</span>
                <h3 className="font-display font-semibold text-xl text-cream">{step.title}</h3>
                <p className="text-muted font-sans text-sm leading-relaxed">{step.body}</p>
              </div>
            </FadeUp>
          ))}
        </div>
      </div>
    </section>
  )
}
