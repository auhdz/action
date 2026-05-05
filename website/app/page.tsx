import Nav from '@/components/Nav'
import Hero from '@/components/Hero'
import ValueProp from '@/components/ValueProp'
import FeaturePillars from '@/components/FeaturePillars'
import StickyFeatures from '@/components/StickyFeatures'
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
      <StickyFeatures />
      <HowItWorks />
      <WhatsNew />
      <Pricing />
      <FuturePlans />
      <FinalCTA />
      <Footer />
    </main>
  )
}
