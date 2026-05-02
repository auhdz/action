import Nav from '@/components/Nav'
import Hero from '@/components/Hero'
import ValueProp from '@/components/ValueProp'
import FeaturePillars from '@/components/FeaturePillars'
import FeatureSection from '@/components/FeatureSection'
import HowItWorks from '@/components/HowItWorks'
import WhatsNew from '@/components/WhatsNew'
import Pricing from '@/components/Pricing'
import FuturePlans from '@/components/FuturePlans'
import FinalCTA from '@/components/FinalCTA'
import Footer from '@/components/Footer'

export default function Home() {
  return (
    <main>
      <Nav />
      <Hero />
      <ValueProp />
      <FeaturePillars />

      <FeatureSection
        headline={<>Your family always knows <em className="font-serif not-italic">where</em> you are.</>}
        body="Acción syncs your GPS location to trusted contacts in real time. They see your exact position on a live map. No app download needed."
        variant="map"
      />

      <FeatureSection
        headline={<>One hold. Help is <em className="font-serif not-italic">on the way.</em></>}
        body="Press and hold 3 seconds. Acción sends an SMS to your trusted contacts with a secure web link to your live location. A 60-second cancel window gives you control."
        variant="sos"
        flip
        glow="rgba(142, 42, 11, 0.06)"
      />

      <FeatureSection
        headline={<>Know your rights in <em className="font-serif not-italic">any</em> situation.</>}
        body="CHIRLA and ILRC-verified legal language. What to say, what to do. Available in English and Spanish, always inside the app."
        variant="kyr"
      />

      <FeatureSection
        headline={<>Family sees you. No app <em className="font-serif not-italic">required.</em></>}
        body="When you share your location, your contacts get a link. They open it in any browser and see your real-time position. Nothing to install."
        variant="web"
        flip
      />

      <HowItWorks />
      <WhatsNew />
      <Pricing />
      <FuturePlans />
      <FinalCTA />
      <Footer />
    </main>
  )
}
