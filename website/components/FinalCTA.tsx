import FadeUp from './FadeUp'

export default function FinalCTA() {
  return (
    <section className="py-36 relative overflow-hidden">
      <div className="absolute inset-0 pointer-events-none">
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[300px] bg-cream/[0.03] rounded-full blur-3xl" />
      </div>
      <div className="max-w-4xl mx-auto px-6 text-center">
        <FadeUp>
          <h2 className="font-display font-bold text-5xl md:text-6xl lg:text-7xl text-cream mb-8 leading-tight tracking-tight">
            Keep your family informed.{' '}
            <em className="font-serif not-italic">Today.</em>
          </h2>
        </FadeUp>
        <FadeUp delay={0.1}>
          <div className="flex flex-wrap gap-4 justify-center">
            <a
              href="#"
              className="px-8 py-3.5 rounded-full bg-cream text-bg font-semibold font-sans hover:bg-cream/90 transition-colors"
            >
              Download on App Store
            </a>
            <a
              href="#how-it-works"
              className="px-8 py-3.5 rounded-full border border-white/20 text-cream font-semibold font-sans hover:border-white/40 transition-colors"
            >
              Learn more
            </a>
          </div>
        </FadeUp>
      </div>
    </section>
  )
}
