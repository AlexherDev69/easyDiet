import React, { useEffect, useState } from 'react';
import { ChefHat, Sparkles, Check } from 'lucide-react';
import Glass from '../components/Glass';
import GradText from '../components/GradText';
import BlobBG from '../components/BlobBG';

const PHASES = [
  'Analyse de vos préférences…',
  'Sélection des recettes…',
  'Équilibrage des macros…',
  'Calcul de la liste de courses…',
];

const CHIPS: Array<{ l: string; Ic: any; c: string }> = [
  { l: '96 recettes scannées',  Ic: Sparkles, c: '#10B981' },
  { l: '7 jours planifiés',     Ic: Check,    c: '#8B5CF6' },
  { l: 'Macros équilibrés',     Ic: Check,    c: '#F59E0B' },
];

export default function LoadingPage({ onDone }: { onDone?: () => void }) {
  const [phase, setPhase] = useState(0);
  const [progress, setProgress] = useState(0);
  const [chipsShown, setChipsShown] = useState(0);

  useEffect(() => {
    const phaseI = setInterval(() => {
      setPhase(p => (p + 1) % PHASES.length);
    }, 2200);
    return () => clearInterval(phaseI);
  }, []);

  useEffect(() => {
    let raf = 0;
    const start = performance.now();
    const dur = 7000;
    const tick = (t: number) => {
      const p = Math.min(1, (t - start) / dur);
      setProgress(p);
      if (p < 1) raf = requestAnimationFrame(tick);
      else onDone?.();
    };
    raf = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(raf);
  }, [onDone]);

  useEffect(() => {
    const t1 = setTimeout(() => setChipsShown(1), 900);
    const t2 = setTimeout(() => setChipsShown(2), 2100);
    const t3 = setTimeout(() => setChipsShown(3), 3400);
    return () => { clearTimeout(t1); clearTimeout(t2); clearTimeout(t3); };
  }, []);

  return (
    <div style={{ position: 'relative', height: '100%', minHeight: 600 }}>
      <BlobBG intensity={1.2}/>

      {/* keyframes for pulse, shimmer, chip-in */}
      <style>{`
        @keyframes edPulseRing {
          0%   { transform: translate(-50%,-50%) scale(1);   opacity: 0.55; }
          100% { transform: translate(-50%,-50%) scale(1.8); opacity: 0; }
        }
        @keyframes edPulseCore {
          0%, 100% { transform: scale(1); }
          50%      { transform: scale(1.06); }
        }
        @keyframes edShimmer {
          0%   { transform: translateX(-100%); }
          100% { transform: translateX(250%); }
        }
        @keyframes edChipIn {
          0%   { opacity: 0; transform: translateY(8px); }
          100% { opacity: 1; transform: translateY(0);   }
        }
        @media (prefers-reduced-motion: reduce) {
          .ed-pulse-ring, .ed-pulse-core, .ed-shimmer { animation: none !important; }
        }
      `}</style>

      <div style={{
        position: 'relative', zIndex: 2,
        height: '100%', minHeight: 600,
        display: 'flex', flexDirection: 'column', alignItems: 'center',
        padding: '60px 28px 40px',
      }}>
        {/* Hero icon with pulse rings */}
        <div style={{ position: 'relative', width: 180, height: 180, marginBottom: 28 }}>
          {[0, 1, 2].map(i => (
            <div key={i} className="ed-pulse-ring" style={{
              position: 'absolute', top: '50%', left: '50%',
              width: 140, height: 140, borderRadius: '50%',
              background: 'radial-gradient(circle, rgba(16,185,129,0.5), rgba(16,185,129,0) 65%)',
              animation: `edPulseRing 2.8s ease-out ${i * 0.9}s infinite`,
              pointerEvents: 'none',
            }}/>
          ))}
          <div className="ed-pulse-core" style={{
            position: 'absolute', inset: 0,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            animation: 'edPulseCore 2.4s ease-in-out infinite',
          }}>
            <div style={{
              width: 140, height: 140, borderRadius: '50%',
              background: 'radial-gradient(circle at 32% 28%, #34D399, #10B981 55%, #059669 100%)',
              boxShadow: '0 24px 60px rgba(16,185,129,0.55), inset 0 2px 6px rgba(255,255,255,0.4)',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              position: 'relative', overflow: 'hidden',
            }}>
              <div className="ed-shimmer" style={{
                position: 'absolute', inset: 0,
                background: 'linear-gradient(100deg, transparent 20%, rgba(255,255,255,0.5) 50%, transparent 80%)',
                animation: 'edShimmer 2.4s ease-in-out infinite',
                pointerEvents: 'none',
              }}/>
              <ChefHat size={60} color="#fff" strokeWidth={2.2}/>
            </div>
          </div>
        </div>

        <div style={{ textAlign: 'center', marginBottom: 18 }}>
          <div style={{ fontSize: 11, color: '#059669', fontWeight: 800, letterSpacing: 1.2, textTransform: 'uppercase' }}>Un instant</div>
          <div style={{ marginTop: 4 }}>
            <GradText size={24}>Création de votre plan…</GradText>
          </div>
        </div>

        <div style={{
          height: 20, marginBottom: 20, position: 'relative',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          width: '100%',
        }}>
          {PHASES.map((p, i) => (
            <div key={i} style={{
              position: 'absolute', fontSize: 13, color: '#475569', fontWeight: 600,
              opacity: i === phase ? 1 : 0,
              transform: `translateY(${i === phase ? 0 : 6}px)`,
              transition: 'opacity 320ms ease-out, transform 320ms ease-out',
              textAlign: 'center',
            }}>{p}</div>
          ))}
        </div>

        {/* Progress bar */}
        <div style={{
          width: '100%', maxWidth: 320, height: 6, borderRadius: 3,
          background: 'rgba(15,23,42,0.07)',
          boxShadow: 'inset 0 0 0 1px rgba(15,23,42,0.04)',
          overflow: 'hidden', marginBottom: 28,
          position: 'relative',
        }}>
          <div style={{
            position: 'absolute', left: 0, top: 0, bottom: 0,
            width: `${progress * 100}%`,
            background: 'linear-gradient(90deg, #10B981, #14B8A6, #059669)',
            boxShadow: '0 0 12px rgba(16,185,129,0.6)',
            borderRadius: 3,
            transition: 'width 120ms linear',
          }}/>
          <div className="ed-shimmer" style={{
            position: 'absolute', top: 0, bottom: 0, width: '40%',
            background: 'linear-gradient(90deg, transparent, rgba(255,255,255,0.6), transparent)',
            animation: 'edShimmer 1.6s linear infinite',
          }}/>
        </div>

        {/* Stat chips appearing progressively */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 8, width: '100%', maxWidth: 320 }}>
          {CHIPS.map((c, i) => {
            if (i >= chipsShown) return <div key={i} style={{ height: 44 }}/>;
            const Ic = c.Ic;
            return (
              <Glass key={i} pad={10} radius={14} style={{
                animation: 'edChipIn 420ms ease-out both',
              }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                  <div style={{
                    width: 28, height: 28, borderRadius: 9,
                    background: `${c.c}22`,
                    display: 'flex', alignItems: 'center', justifyContent: 'center',
                  }}>
                    <Ic size={14} color={c.c}/>
                  </div>
                  <div style={{ fontSize: 12, fontWeight: 800, color: 'var(--ed-text)', letterSpacing: -0.1 }}>{c.l}</div>
                  <div style={{ marginLeft: 'auto', width: 18, height: 18, borderRadius: '50%', background: 'rgba(16,185,129,0.15)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                    <Check size={10} color="#059669" strokeWidth={3.4}/>
                  </div>
                </div>
              </Glass>
            );
          })}
        </div>
      </div>
    </div>
  );
}
