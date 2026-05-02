'use client'

import { motion } from 'framer-motion'
import { float } from '@/lib/motion'

type MockupVariant = 'map' | 'sos' | 'kyr' | 'web'

interface PhoneMockupProps {
  variant: MockupVariant
  animate?: boolean
  scale?: number
}

function MapScreen() {
  return (
    <div className="w-full h-full bg-[#0A0D10] relative overflow-hidden rounded-[inherit]">
      {[...Array(6)].map((_, i) => (
        <div key={`h${i}`} className="absolute w-full h-px bg-white/5" style={{ top: `${(i + 1) * 14}%` }} />
      ))}
      {[...Array(6)].map((_, i) => (
        <div key={`v${i}`} className="absolute h-full w-px bg-white/5" style={{ left: `${(i + 1) * 16}%` }} />
      ))}
      <div className="absolute top-3 right-3 w-20 h-16 rounded-xl bg-[#0D1B2A] border border-white/10 overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-br from-blue-900/30 to-transparent" />
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2">
          <div className="w-3 h-3 rounded-full bg-blue-500 shadow-[0_0_8px_rgba(59,130,246,0.8)]" />
          <div className="absolute inset-0 rounded-full bg-blue-500/30 animate-ping" />
        </div>
      </div>
      <div className="absolute bottom-4 left-3 right-3 rounded-xl bg-[#0D1B2A] border border-white/10 p-3">
        <div className="flex items-center gap-2 mb-1">
          <div className="w-2 h-2 rounded-full bg-green-400" />
          <span className="text-[10px] text-white/80 font-medium">You are safe</span>
        </div>
        <div className="text-[9px] text-white/40">Location syncing · 2s ago</div>
      </div>
    </div>
  )
}

function SosScreen() {
  return (
    <div className="w-full h-full bg-[#0A0D10] flex flex-col items-center justify-center gap-4 rounded-[inherit]">
      <div className="text-[10px] text-white/40 uppercase tracking-widest">Hold to alert</div>
      <div className="relative flex items-center justify-center">
        <div className="absolute w-20 h-20 rounded-full bg-[#8E2A0B]/20 animate-ping" />
        <div className="absolute w-16 h-16 rounded-full bg-[#8E2A0B]/30" />
        <div className="w-12 h-12 rounded-full bg-[#8E2A0B] flex items-center justify-center shadow-[0_0_20px_rgba(142,42,11,0.6)]">
          <span className="text-white text-xs font-bold">SOS</span>
        </div>
      </div>
      <div className="text-[9px] text-white/40">60s cancel window</div>
    </div>
  )
}

function KyrScreen() {
  return (
    <div className="w-full h-full bg-[#0A0D10] p-3 rounded-[inherit] overflow-hidden">
      <div className="text-[9px] text-white/40 uppercase tracking-widest mb-2">Know Your Rights</div>
      <div className="rounded-xl bg-[#0D1B2A] border border-white/10 p-3 space-y-2">
        <div className="text-[10px] text-white font-semibold">You have the right to remain silent.</div>
        <div className="text-[9px] text-white/50">Tienes derecho a guardar silencio.</div>
        <div className="h-px bg-white/10 my-1" />
        <div className="text-[10px] text-white font-semibold">You may refuse to consent to a search.</div>
        <div className="text-[9px] text-white/50">Puedes negarte a dar permiso para un registro.</div>
        <div className="h-px bg-white/10 my-1" />
        <div className="text-[10px] text-white font-semibold">You have the right to an attorney.</div>
        <div className="text-[9px] text-white/50">Tienes derecho a un abogado.</div>
      </div>
    </div>
  )
}

function WebScreen() {
  return (
    <div className="w-full h-full bg-[#111] rounded-[inherit] overflow-hidden">
      <div className="bg-[#1a1a1a] px-2 py-1.5 flex items-center gap-1.5 border-b border-white/10">
        <div className="w-2 h-2 rounded-full bg-red-500/60" />
        <div className="w-2 h-2 rounded-full bg-yellow-500/60" />
        <div className="w-2 h-2 rounded-full bg-green-500/60" />
        <div className="flex-1 bg-[#0A0D10] rounded text-[7px] text-white/30 px-1.5 py-0.5 text-center">
          accion.app/watch/...
        </div>
      </div>
      <div className="relative w-full h-full bg-[#0D1B2A]">
        {[...Array(5)].map((_, i) => (
          <div key={`h${i}`} className="absolute w-full h-px bg-white/5" style={{ top: `${20 + i * 15}%` }} />
        ))}
        {[...Array(5)].map((_, i) => (
          <div key={`v${i}`} className="absolute h-full w-px bg-white/5" style={{ left: `${20 + i * 15}%` }} />
        ))}
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2">
          <div className="w-4 h-4 rounded-full bg-[#8E2A0B] shadow-[0_0_10px_rgba(142,42,11,0.8)]" />
          <div className="absolute inset-0 rounded-full bg-[#8E2A0B]/30 animate-ping" />
        </div>
        <div className="absolute bottom-2 left-2 right-2 bg-[#0A0D10]/90 rounded-lg p-2 border border-white/10">
          <div className="text-[9px] text-white/80">Live location · Updated now</div>
        </div>
      </div>
    </div>
  )
}

const screens: Record<MockupVariant, React.FC> = {
  map: MapScreen,
  sos: SosScreen,
  kyr: KyrScreen,
  web: WebScreen,
}

export default function PhoneMockup({ variant, animate = false, scale = 1 }: PhoneMockupProps) {
  const Screen = screens[variant]

  const frame = (
    <div
      style={{ transform: `scale(${scale})`, transformOrigin: 'top center' }}
      className="relative w-[180px] h-[360px] rounded-[36px] bg-[#1a1a1a] border-[6px] border-[#2a2a2a] shadow-2xl overflow-hidden"
    >
      <div className="absolute top-2 left-1/2 -translate-x-1/2 w-16 h-4 bg-black rounded-full z-10" />
      <div className="absolute inset-0 rounded-[30px] overflow-hidden">
        <Screen />
      </div>
    </div>
  )

  if (!animate) return frame

  return (
    <motion.div animate="animate" variants={float}>
      {frame}
    </motion.div>
  )
}
