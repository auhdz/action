import FadeUp from './FadeUp'

export default function ValueProp() {
  return (
    <section className="py-28">
      <div className="max-w-4xl mx-auto px-6 text-center">
        <FadeUp>
          <h2 className="font-display font-bold text-3xl md:text-4xl lg:text-5xl text-cream leading-tight tracking-tight">
            Your location. Your contacts.{' '}
            <em className="font-serif not-italic">Nothing</em> else.
          </h2>
        </FadeUp>
        <FadeUp delay={0.1}>
          <p className="mt-6 text-lg text-muted font-sans max-w-2xl mx-auto leading-relaxed">
            Completely anonymous. No email, no password, no stored identity. Acción works entirely
            from a random device code. Nothing that could identify you.
          </p>
        </FadeUp>
      </div>
    </section>
  )
}
