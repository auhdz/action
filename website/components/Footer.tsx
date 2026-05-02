const columns = [
  {
    heading: 'App',
    links: [
      { label: 'Features', href: '#features' },
      { label: 'How It Works', href: '#how-it-works' },
      { label: 'Privacy', href: '#privacy' },
      { label: 'Download', href: '#' },
    ],
  },
  {
    heading: 'Legal',
    links: [
      { label: 'Terms of Service', href: '#' },
      { label: 'Privacy Policy', href: '#' },
    ],
  },
  {
    heading: 'Community',
    links: [
      { label: 'About', href: '#' },
      { label: 'Contact', href: 'mailto:taquestudios@gmail.com' },
    ],
  },
  {
    heading: 'Connect',
    links: [
      { label: 'GitHub', href: '#' },
      { label: 'X / Twitter', href: '#' },
    ],
  },
]

export default function Footer() {
  return (
    <footer className="pt-20 pb-10">
      <div className="max-w-6xl mx-auto px-6">
        <div className="grid grid-cols-2 md:grid-cols-4 gap-8 mb-16">
          {columns.map((col) => (
            <div key={col.heading}>
              <p className="text-xs font-mono text-muted uppercase tracking-widest mb-4">{col.heading}</p>
              <ul className="flex flex-col gap-2">
                {col.links.map((link) => (
                  <li key={link.label}>
                    <a href={link.href} className="text-sm font-sans text-muted hover:text-cream transition-colors">
                      {link.label}
                    </a>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>
        <div className="pt-6 flex flex-col md:flex-row justify-between items-center gap-4 text-xs font-sans text-muted/50">
          <p>© 2026 Acción. Built for the community.</p>
          <div className="flex gap-4">
            <a href="#" className="hover:text-cream transition-colors">Privacy</a>
            <a href="#" className="hover:text-cream transition-colors">Terms</a>
          </div>
        </div>
      </div>
    </footer>
  )
}
