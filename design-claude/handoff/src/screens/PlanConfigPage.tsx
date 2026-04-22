import React, { useState } from 'react';
import {
  ChevronLeft, Beef, Leaf, Sprout, Coffee, Utensils, Moon, Cookie,
  Sparkles, Wallet, Sparkle,
} from 'lucide-react';
import Glass from '../components/Glass';
import GradText from '../components/GradText';

type DietKey = 'omni' | 'vege' | 'vegan';
type ModeKey = 'variety' | 'economy';

function Eyebrow({ children }: { children: React.ReactNode }) {
  return (
    <div style={{ fontSize: 10, color: '#059669', fontWeight: 800, letterSpacing: 1.2, textTransform: 'uppercase', marginBottom: 4 }}>{children}</div>
  );
}
function CardTitle({ children }: { children: React.ReactNode }) {
  return (
    <div style={{ fontSize: 15, fontWeight: 800, color: 'var(--ed-text)', letterSpacing: -0.3, marginBottom: 12 }}>{children}</div>
  );
}

export default function PlanConfigPage({ onBack, onGenerate }: { onBack?: () => void; onGenerate?: () => void }) {
  const [diet, setDiet] = useState<DietKey>('omni');
  const [meals, setMeals] = useState({ breakfast: true, lunch: true, dinner: true, snack: false });
  const [freeDays, setFreeDays] = useState<number[]>([6]);
  const [mode, setMode] = useState<ModeKey>('variety');

  const mealRows: Array<{ k: keyof typeof meals; Ic: any; c: string; l: string; time: string }> = [
    { k: 'breakfast', Ic: Coffee,   c: '#F59E0B', l: 'Petit-déjeuner', time: '07h30' },
    { k: 'lunch',     Ic: Utensils, c: '#10B981', l: 'Déjeuner',       time: '12h30' },
    { k: 'dinner',    Ic: Moon,     c: '#6366F1', l: 'Dîner',          time: '19h30' },
    { k: 'snack',     Ic: Cookie,   c: '#EC4899', l: 'Collation',      time: '16h00' },
  ];

  return (
    <div style={{ padding: '0 20px 120px', position: 'relative' }}>
      <div style={{ padding: '8px 0 16px', display: 'flex', alignItems: 'center', gap: 10 }}>
        <button
          onClick={onBack}
          style={{
            width: 40, height: 40, borderRadius: 12, border: 'none',
            background: 'var(--ed-glass-bg)', backdropFilter: 'blur(12px)',
            boxShadow: 'inset 0 0 0 1px var(--ed-glass-border)',
            cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}
        >
          <ChevronLeft size={18} color="#475569" />
        </button>
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: 11, color: '#64748B', fontWeight: 800, letterSpacing: 1.2, textTransform: 'uppercase' }}>Étape 1 / 1</div>
          <GradText size={22}>Nouveau plan</GradText>
        </div>
      </div>

      <Glass pad={16} radius={20} style={{ marginBottom: 12 }}>
        <Eyebrow>Type de régime</Eyebrow>
        <CardTitle>Que mangez-vous ?</CardTitle>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3,1fr)', gap: 8 }}>
          {([
            { k: 'omni',  l: 'Omnivore',   d: 'Viandes, poissons', Ic: Beef   },
            { k: 'vege',  l: 'Végétarien', d: 'Sans viande',       Ic: Leaf   },
            { k: 'vegan', l: 'Végan',      d: 'Zéro produit animal', Ic: Sprout },
          ] as const).map(x => {
            const active = diet === x.k;
            const Ic = x.Ic;
            return (
              <button key={x.k} onClick={() => setDiet(x.k)} style={{
                padding: '14px 8px 12px', borderRadius: 16, border: 'none', cursor: 'pointer',
                background: active ? 'var(--ed-primary-grad)' : 'rgba(255,255,255,0.55)',
                color: active ? '#fff' : 'var(--ed-text)',
                boxShadow: active ? '0 10px 22px rgba(16,185,129,0.32)' : 'inset 0 0 0 1px var(--ed-glass-border)',
                display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6,
                transition: 'transform 150ms ease-out',
              }}>
                <div style={{
                  width: 36, height: 36, borderRadius: 12,
                  background: active ? 'rgba(255,255,255,0.22)' : `${['#10B981', '#10B981', '#059669'][0]}1f`,
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                }}>
                  <Ic size={18} color={active ? '#fff' : '#059669'}/>
                </div>
                <div style={{ fontSize: 12, fontWeight: 800 }}>{x.l}</div>
                <div style={{ fontSize: 10, fontWeight: 700, opacity: active ? 0.85 : 0.55, letterSpacing: 0.1, textAlign: 'center' }}>{x.d}</div>
              </button>
            );
          })}
        </div>
      </Glass>

      <Glass pad={16} radius={20} style={{ marginBottom: 12 }}>
        <Eyebrow>Repas activés</Eyebrow>
        <CardTitle>Quels repas planifier ?</CardTitle>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
          {mealRows.map((m, i) => {
            const on = meals[m.k];
            const Ic = m.Ic;
            return (
              <div key={m.k} style={{
                display: 'flex', alignItems: 'center', gap: 12, padding: '10px 4px',
                borderBottom: i === mealRows.length - 1 ? 'none' : '1px solid rgba(15,23,42,0.06)',
              }}>
                <div style={{
                  width: 36, height: 36, borderRadius: 12, flexShrink: 0,
                  background: `${m.c}1f`, display: 'flex', alignItems: 'center', justifyContent: 'center',
                }}>
                  <Ic size={17} color={m.c}/>
                </div>
                <div style={{ flex: 1 }}>
                  <div style={{ fontSize: 13, fontWeight: 800, color: 'var(--ed-text)' }}>{m.l}</div>
                  <div style={{ fontSize: 11, color: '#64748B', fontWeight: 700 }}>{m.time}</div>
                </div>
                <button onClick={() => setMeals({ ...meals, [m.k]: !on })} style={{
                  width: 44, height: 26, borderRadius: 13, border: 'none', cursor: 'pointer',
                  background: on ? 'var(--ed-primary-grad)' : 'rgba(15,23,42,0.14)',
                  boxShadow: on ? '0 4px 10px rgba(16,185,129,0.3)' : 'inset 0 0 0 1px rgba(15,23,42,0.06)',
                  position: 'relative', transition: 'background 180ms ease-out',
                }}>
                  <div style={{
                    position: 'absolute', top: 3, left: on ? 21 : 3,
                    width: 20, height: 20, borderRadius: '50%', background: '#fff',
                    boxShadow: '0 2px 4px rgba(0,0,0,0.15)',
                    transition: 'left 180ms ease-out',
                  }}/>
                </button>
              </div>
            );
          })}
        </div>
      </Glass>

      <Glass pad={16} radius={20} style={{ marginBottom: 12 }}>
        <Eyebrow>Jours libres</Eyebrow>
        <CardTitle>Jours hors plan</CardTitle>
        <div style={{ display: 'flex', gap: 6 }}>
          {['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'].map((d, i) => {
            const active = freeDays.includes(i);
            return (
              <button key={d} onClick={() => setFreeDays(active ? freeDays.filter(x => x !== i) : [...freeDays, i])} style={{
                flex: 1, height: 42, borderRadius: 12, border: 'none', cursor: 'pointer',
                background: active ? '#8B5CF6' : 'rgba(15,23,42,0.04)',
                color: active ? '#fff' : 'var(--ed-muted)',
                fontSize: 12, fontWeight: 800,
                boxShadow: active ? '0 6px 14px rgba(139,92,246,0.32)' : 'inset 0 0 0 1px rgba(15,23,42,0.06)',
              }}>{d}</button>
            );
          })}
        </div>
        <div style={{ fontSize: 11, color: '#64748B', fontWeight: 600, marginTop: 10 }}>
          Ces jours ne seront pas inclus dans les courses ni les repas générés.
        </div>
      </Glass>

      <Glass pad={16} radius={20} style={{ marginBottom: 16 }}>
        <Eyebrow>Mode de génération</Eyebrow>
        <CardTitle>Priorité du plan</CardTitle>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
          {([
            { k: 'variety', l: 'Variété',    d: 'Recettes diverses chaque jour',      Ic: Sparkles, c: '#10B981' },
            { k: 'economy', l: 'Économique', d: 'Batch cooking & restes optimisés',   Ic: Wallet,   c: '#F59E0B' },
          ] as const).map(x => {
            const active = mode === x.k;
            const Ic = x.Ic;
            return (
              <button key={x.k} onClick={() => setMode(x.k)} style={{
                padding: '14px 12px', borderRadius: 16, border: 'none', cursor: 'pointer', textAlign: 'left',
                background: active ? `${x.c}14` : 'rgba(255,255,255,0.55)',
                boxShadow: active ? `inset 0 0 0 2px ${x.c}` : 'inset 0 0 0 1px var(--ed-glass-border)',
                display: 'flex', flexDirection: 'column', gap: 6,
              }}>
                <div style={{
                  width: 34, height: 34, borderRadius: 11,
                  background: `${x.c}22`, display: 'flex', alignItems: 'center', justifyContent: 'center',
                }}>
                  <Ic size={17} color={x.c}/>
                </div>
                <div style={{ fontSize: 13, fontWeight: 800, color: 'var(--ed-text)' }}>{x.l}</div>
                <div style={{ fontSize: 11, color: '#64748B', fontWeight: 600, lineHeight: 1.35 }}>{x.d}</div>
              </button>
            );
          })}
        </div>
      </Glass>

      <div style={{
        position: 'sticky', bottom: 16, paddingTop: 8,
      }}>
        <button
          onClick={onGenerate}
          style={{
            width: '100%', height: 54, borderRadius: 16, border: 'none', cursor: 'pointer',
            background: 'var(--ed-primary-grad)',
            boxShadow: '0 12px 28px rgba(16,185,129,0.45), inset 0 1px 0 rgba(255,255,255,0.3)',
            color: '#fff', fontSize: 15, fontWeight: 800, letterSpacing: 0.1,
            display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
          }}
        >
          <Sparkle size={16} color="#fff"/>
          Générer mon plan
        </button>
      </div>
    </div>
  );
}
