import FadeUp from './FadeUp'

const updates = [
  {
    version: 'v1.2',
    date: 'Apr 2026',
    title: 'Bilingual support',
    body: 'Full English + Spanish throughout the app, including the KYR card and onboarding.',
  },
  {
    version: 'v1.1',
    date: 'Mar 2026',
    title: 'SOS flow updated',
    body: '60-second cancel window before SMS sends, giving you full control after holding the button.',
  },
  {
    version: 'v1.0',
    date: 'Feb 2026',
    title: 'Know Your Rights card',
    body: 'CHIRLA and ILRC-verified legal language added. Available in English and Spanish.',
  },
]

export default function WhatsNew() {
  return (
    <section className="py-28">
      <div className="max-w-6xl mx-auto px-6">
        <FadeUp>
          <h2 className="font-display font-bold text-4xl md:text-5xl text-cream mb-12 tracking-tight">
            What&apos;s <em className="font-serif not-italic">new</em>
          </h2>
        </FadeUp>
        <div className="flex flex-col gap-4">
          {updates.map((update, i) => (
            <FadeUp key={update.version} delay={i * 0.1}>
              <div className="rounded-2xl bg-surface border border-white/8 p-6 flex flex-col md:flex-row md:items-center gap-4">
                <div className="flex items-center gap-3 min-w-[120px]">
                  <span className="px-2 py-0.5 rounded-full bg-[#F39A1E]/15 text-orange text-xs font-mono font-medium">
                    {update.version}
                  </span>
                  <span className="text-xs text-muted font-mono">{update.date}</span>
                </div>
                <div>
                  <h3 className="font-display font-semibold text-cream text-sm mb-1">{update.title}</h3>
                  <p className="text-xs text-muted font-sans leading-relaxed">{update.body}</p>
                </div>
              </div>
            </FadeUp>
          ))}
        </div>
      </div>
    </section>
  )
}
