import React, { useState } from 'react';
import {
  ChevronLeft, ChevronRight, User, Cake, Users, Ruler, Scale, Target,
  Leaf, AlertTriangle, Beef, Wallet, Coffee, Utensils, Moon, Cookie,
  CalendarX, Info, Calculator, Trash2,
} from 'lucide-react';
import Glass from '../components/Glass';
import GradText from '../components/GradText';

type RowProps = {
  Ic: any;
  color: string;
  label: string;
  value?: string;
  last?: boolean;
  onClick?: () => void;
};

function Row({ Ic, color, label, value, last, onClick }: RowProps) {
  return (
    <button
      onClick={onClick}
      style={{
        width: '100%', border: 'none', background: 'transparent', cursor: 'pointer',
        padding: '12px 2px', display: 'flex', alignItems: 'center', gap: 12,
        borderBottom: last ? 'none' : '1px solid rgba(15,23,42,0.06)',
        textAlign: 'left',
      }}
    >
      <div style={{
        width: 34, height: 34, borderRadius: 10, flexShrink: 0,
        background: `${color}1f`,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>
        <Ic size={16} color={color} />
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: 13, fontWeight: 700, color: 'var(--ed-text)', letterSpacing: -0.1 }}>{label}</div>
      </div>
      {value && (
        <div style={{ fontSize: 12, color: '#64748B', fontWeight: 700 }}>{value}</div>
      )}
      <ChevronRight size={16} color="rgba(100,116,139,0.5)" />
    </button>
  );
}

type SwitchProps = { Ic: any; color: string; label: string; sub?: string; on: boolean; onToggle: () => void; last?: boolean };

function SwitchRow({ Ic, color, label, sub, on, onToggle, last }: SwitchProps) {
  return (
    <div style={{
      display: 'flex', alignItems: 'center', gap: 12, padding: '12px 2px',
      borderBottom: last ? 'none' : '1px solid rgba(15,23,42,0.06)',
    }}>
      <div style={{
        width: 34, height: 34, borderRadius: 10, flexShrink: 0,
        background: `${color}1f`,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>
        <Ic size={16} color={color} />
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: 13, fontWeight: 700, color: 'var(--ed-text)' }}>{label}</div>
        {sub && <div style={{ fontSize: 11, color: '#64748B', fontWeight: 600, marginTop: 1 }}>{sub}</div>}
      </div>
      <button
        onClick={onToggle}
        style={{
          width: 44, height: 26, borderRadius: 13, border: 'none', cursor: 'pointer',
          background: on ? 'var(--ed-primary-grad)' : 'rgba(15,23,42,0.14)',
          boxShadow: on ? '0 4px 10px rgba(16,185,129,0.3)' : 'inset 0 0 0 1px rgba(15,23,42,0.06)',
          position: 'relative', transition: 'background 180ms ease-out',
        }}
      >
        <div style={{
          position: 'absolute', top: 3, left: on ? 21 : 3,
          width: 20, height: 20, borderRadius: '50%', background: '#fff',
          boxShadow: '0 2px 4px rgba(0,0,0,0.15)',
          transition: 'left 180ms ease-out',
        }}/>
      </button>
    </div>
  );
}

type SectionProps = { eyebrow: string; title: string; children: React.ReactNode };
function Section({ eyebrow, title, children }: SectionProps) {
  return (
    <div style={{ marginBottom: 18 }}>
      <div style={{ padding: '0 6px 8px' }}>
        <div style={{ fontSize: 10, color: '#059669', fontWeight: 800, letterSpacing: 1.2, textTransform: 'uppercase' }}>{eyebrow}</div>
        <div style={{ fontSize: 15, fontWeight: 800, color: 'var(--ed-text)', letterSpacing: -0.3, marginTop: 2 }}>{title}</div>
      </div>
      <Glass pad={12} radius={18}>
        <div style={{ padding: '0 6px' }}>{children}</div>
      </Glass>
    </div>
  );
}

type ChipProps = { active?: boolean; onClick?: () => void; children: React.ReactNode; color?: string };
function Chip({ active, onClick, children, color = '#10B981' }: ChipProps) {
  return (
    <button
      onClick={onClick}
      style={{
        height: 30, padding: '0 12px', borderRadius: 999, border: 'none',
        background: active ? `${color}22` : 'rgba(15,23,42,0.04)',
        color: active ? color : 'var(--ed-muted)',
        fontSize: 11, fontWeight: 800, letterSpacing: 0.1,
        boxShadow: active ? `inset 0 0 0 1px ${color}44` : 'inset 0 0 0 1px rgba(15,23,42,0.06)',
        cursor: 'pointer', whiteSpace: 'nowrap',
      }}
    >
      {children}
    </button>
  );
}

export default function SettingsPage({ onBack }: { onBack?: () => void }) {
  const [meals, setMeals] = useState({ breakfast: true, lunch: true, dinner: true, snack: true });
  const [economy, setEconomy] = useState(false);
  const [allergies, setAllergies] = useState<string[]>(['Fruits à coque']);
  const [excluded, setExcluded] = useState<string[]>(['Porc']);
  const [diet, setDiet] = useState<'omni' | 'vege' | 'vegan'>('omni');
  const [freeDays, setFreeDays] = useState<number[]>([6]);

  const toggleMeal = (k: keyof typeof meals) => setMeals({ ...meals, [k]: !meals[k] });
  const toggleIn = (arr: string[], set: (v: string[]) => void, v: string) =>
    set(arr.includes(v) ? arr.filter(x => x !== v) : [...arr, v]);

  return (
    <div style={{ padding: '0 20px 40px' }}>
      <div style={{ padding: '8px 0 14px', display: 'flex', alignItems: 'center', gap: 10 }}>
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
          <div style={{ fontSize: 11, color: '#64748B', fontWeight: 800, letterSpacing: 1.2, textTransform: 'uppercase' }}>Compte</div>
          <GradText size={22}>Paramètres</GradText>
        </div>
      </div>

      <Section eyebrow="Vous" title="Profil">
        <Row Ic={User}   color="#10B981" label="Nom"          value="Camille Durand" />
        <Row Ic={Cake}   color="#F59E0B" label="Âge"          value="32 ans" />
        <Row Ic={Users}  color="#8B5CF6" label="Sexe"         value="Femme" />
        <Row Ic={Ruler}  color="#0EA5E9" label="Taille"       value="168 cm" />
        <Row Ic={Scale}  color="#F43F5E" label="Poids actuel" value="68.4 kg" />
        <Row Ic={Target} color="#059669" label="Poids cible"  value="64.0 kg" last />
      </Section>

      <Section eyebrow="Alimentation" title="Régime">
        <div style={{ padding: '10px 0 4px', display: 'grid', gridTemplateColumns: 'repeat(3,1fr)', gap: 8 }}>
          {([
            { k: 'omni',  l: 'Omnivore',   Ic: Beef },
            { k: 'vege',  l: 'Végétarien', Ic: Leaf },
            { k: 'vegan', l: 'Végan',      Ic: Leaf },
          ] as const).map(x => {
            const active = diet === x.k;
            const Ic = x.Ic;
            return (
              <button key={x.k} onClick={() => setDiet(x.k)} style={{
                height: 62, borderRadius: 14, border: 'none', cursor: 'pointer',
                background: active ? 'var(--ed-primary-grad)' : 'rgba(255,255,255,0.55)',
                color: active ? '#fff' : 'var(--ed-text)',
                boxShadow: active ? '0 8px 18px rgba(16,185,129,0.32)' : 'inset 0 0 0 1px var(--ed-glass-border)',
                display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 3,
              }}>
                <Ic size={18} color={active ? '#fff' : '#475569'} />
                <div style={{ fontSize: 11, fontWeight: 800 }}>{x.l}</div>
              </button>
            );
          })}
        </div>

        <div style={{ borderTop: '1px solid rgba(15,23,42,0.06)', marginTop: 12, paddingTop: 12 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 8 }}>
            <AlertTriangle size={14} color="#F59E0B"/>
            <div style={{ fontSize: 11, fontWeight: 800, color: 'var(--ed-text)', letterSpacing: 0.2 }}>Allergies & intolérances</div>
          </div>
          <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6, paddingBottom: 4 }}>
            {['Gluten', 'Lactose', 'Fruits à coque', 'Œufs', 'Soja', 'Crustacés', 'Arachides'].map(a => (
              <Chip key={a} active={allergies.includes(a)} color="#F59E0B" onClick={() => toggleIn(allergies, setAllergies, a)}>{a}</Chip>
            ))}
          </div>
        </div>

        <div style={{ borderTop: '1px solid rgba(15,23,42,0.06)', marginTop: 12, paddingTop: 12 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 8 }}>
            <Beef size={14} color="#F43F5E"/>
            <div style={{ fontSize: 11, fontWeight: 800, color: 'var(--ed-text)', letterSpacing: 0.2 }}>Viandes exclues</div>
          </div>
          <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6, paddingBottom: 4 }}>
            {['Bœuf', 'Porc', 'Agneau', 'Volaille', 'Gibier', 'Charcuterie'].map(a => (
              <Chip key={a} active={excluded.includes(a)} color="#F43F5E" onClick={() => toggleIn(excluded, setExcluded, a)}>{a}</Chip>
            ))}
          </div>
        </div>

        <div style={{ borderTop: '1px solid rgba(15,23,42,0.06)', marginTop: 12 }}>
          <SwitchRow Ic={Wallet} color="#059669" label="Mode économique"
            sub="Privilégier les ingrédients de saison & en promo"
            on={economy} onToggle={() => setEconomy(!economy)} last />
        </div>
      </Section>

      <Section eyebrow="Structure" title="Plan">
        <SwitchRow Ic={Coffee}   color="#F59E0B" label="Petit-déjeuner" sub="07h30"           on={meals.breakfast} onToggle={() => toggleMeal('breakfast')} />
        <SwitchRow Ic={Utensils} color="#10B981" label="Déjeuner"       sub="12h30"           on={meals.lunch}     onToggle={() => toggleMeal('lunch')} />
        <SwitchRow Ic={Moon}     color="#6366F1" label="Dîner"          sub="19h30"           on={meals.dinner}    onToggle={() => toggleMeal('dinner')} />
        <SwitchRow Ic={Cookie}   color="#EC4899" label="Collation"      sub="16h00"           on={meals.snack}     onToggle={() => toggleMeal('snack')} />
        <div style={{ paddingTop: 10, borderTop: '1px solid rgba(15,23,42,0.06)', marginTop: 4 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 8, paddingTop: 6 }}>
            <CalendarX size={14} color="#8B5CF6"/>
            <div style={{ fontSize: 11, fontWeight: 800, color: 'var(--ed-text)', letterSpacing: 0.2 }}>Jours libres (hors plan)</div>
          </div>
          <div style={{ display: 'flex', gap: 6 }}>
            {['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'].map((d, i) => {
              const active = freeDays.includes(i);
              return (
                <button key={d} onClick={() => setFreeDays(active ? freeDays.filter(x => x !== i) : [...freeDays, i])} style={{
                  flex: 1, height: 36, borderRadius: 11, border: 'none', cursor: 'pointer',
                  background: active ? '#8B5CF6' : 'rgba(15,23,42,0.04)',
                  color: active ? '#fff' : 'var(--ed-muted)',
                  fontSize: 11, fontWeight: 800,
                  boxShadow: active ? '0 4px 10px rgba(139,92,246,0.3)' : 'inset 0 0 0 1px rgba(15,23,42,0.06)',
                }}>{d}</button>
              );
            })}
          </div>
        </div>
      </Section>

      <Section eyebrow="Application" title="À propos">
        <Row Ic={Info}       color="#0EA5E9" label="Version"              value="1.4.2" />
        <Row Ic={Calculator} color="#8B5CF6" label="Calculs nutritionnels" value="Harris-Benedict" last />
      </Section>

      <button style={{
        width: '100%', height: 52, borderRadius: 16, border: 'none', cursor: 'pointer',
        background: 'rgba(244,63,94,0.1)', color: '#BE123C',
        boxShadow: 'inset 0 0 0 1px rgba(244,63,94,0.28)',
        display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
        fontSize: 14, fontWeight: 800, letterSpacing: 0.1,
      }}>
        <Trash2 size={16} color="#BE123C"/>
        Réinitialiser l'application
      </button>
    </div>
  );
}
