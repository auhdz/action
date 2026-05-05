import type { Metadata } from 'next'
import { sora, inter, instrumentSerif } from '@/lib/fonts'
import SmoothScrollProvider from '@/components/SmoothScrollProvider'
import '@/styles/globals.css'

export const metadata: Metadata = {
  title: 'Acción: Safety app for families',
  description: 'Keep your family informed. Real-time location sharing, SOS alerts, and Know Your Rights. All anonymous, no account required.',
  openGraph: {
    title: 'Acción: Safety app for families',
    description: 'Real-time location sharing and SOS alerts. Anonymous, free, bilingual.',
    type: 'website',
  },
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html
      lang="en"
      className={`${sora.variable} ${inter.variable} ${instrumentSerif.variable}`}
    >
      <body>
        <SmoothScrollProvider>{children}</SmoothScrollProvider>
      </body>
    </html>
  )
}
