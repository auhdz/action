import { Sora, Inter, Instrument_Serif } from 'next/font/google'

export const sora = Sora({
  subsets: ['latin'],
  variable: '--font-display',
  display: 'swap',
})

export const inter = Inter({
  subsets: ['latin'],
  variable: '--font-sans',
  display: 'swap',
})

export const instrumentSerif = Instrument_Serif({
  subsets: ['latin'],
  style: 'italic',
  weight: '400',
  variable: '--font-serif-accent',
  display: 'swap',
})
