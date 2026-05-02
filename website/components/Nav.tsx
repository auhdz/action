'use client'

import { useEffect, useState } from 'react'
import Image from 'next/image'

const links = [
  { label: 'Features', href: '#features' },
  { label: 'How It Works', href: '#how-it-works' },
  { label: 'Privacy', href: '#privacy' },
]

export default function Nav() {
  const [scrolled, setScrolled] = useState(false)

  useEffect(() => {
    const handler = () => setScrolled(window.scrollY > 20)
    window.addEventListener('scroll', handler, { passive: true })
    return () => window.removeEventListener('scroll', handler)
  }, [])

  return (
    <nav
      className="fixed top-0 left-0 right-0 z-50 transition-all duration-300"
      style={{
        backdropFilter: scrolled ? 'blur(12px)' : 'none',
        borderBottom: scrolled ? '1px solid var(--color-border)' : '1px solid transparent',
        backgroundColor: scrolled ? 'rgba(10, 13, 16, 0.85)' : 'transparent',
      }}
    >
      <div className="max-w-6xl mx-auto px-6 h-14 flex items-center justify-between">
        <a href="/" className="flex items-center">
          <Image src="/logo.png" alt="Acción" height={32} width={120} className="object-contain object-left" priority />
        </a>

        <div className="hidden md:flex items-center gap-8">
          {links.map((link) => (
            <a
              key={link.href}
              href={link.href}
              className="text-sm text-muted hover:text-cream transition-colors duration-200 font-sans"
            >
              {link.label}
            </a>
          ))}
        </div>

        <a
          href="#"
          className="px-4 py-1.5 rounded-full bg-cream text-bg text-sm font-semibold font-sans hover:bg-cream/90 transition-colors"
        >
          Get the App
        </a>
      </div>
    </nav>
  )
}
