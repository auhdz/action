import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        bg: 'var(--color-bg)',
        surface: 'var(--color-surface)',
        cream: 'var(--color-text)',
        muted: 'var(--color-text-muted)',
        border: 'var(--color-border)',
        red: 'var(--color-red)',
        orange: 'var(--color-orange)',
        yellow: 'var(--color-yellow)',
      },
      fontFamily: {
        sans: ['var(--font-sans)', 'system-ui', 'sans-serif'],
        display: ['var(--font-display)', 'system-ui', 'sans-serif'],
        serif: ['var(--font-serif-accent)', 'Georgia', 'serif'],
      },
    },
  },
  plugins: [],
}

export default config
