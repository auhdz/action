import type { Metadata } from 'next'

export const metadata: Metadata = {
  title: 'Acción',
  description: 'Privacy-first safety app for families',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
