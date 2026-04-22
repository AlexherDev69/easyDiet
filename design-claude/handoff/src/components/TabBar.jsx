import React from 'react';
import { Home, Utensils, ShoppingCart, BookOpen, Scale } from 'lucide-react';

const TABS = [
  { k: 'home',     Icon: Home,         l: 'Accueil' },
  { k: 'meals',    Icon: Utensils,     l: 'Repas' },
  { k: 'shopping', Icon: ShoppingCart, l: 'Courses' },
  { k: 'recipes',  Icon: BookOpen,     l: 'Recettes' },
  { k: 'weight',   Icon: Scale,        l: 'Poids' },
];

export default function TabBar({ tab, setTab }) {
  return (
    <div style={{
      position: 'absolute', left: 12, right: 12, bottom: 12, zIndex: 50,
      borderRadius: 26, padding: 8,
      background: 'var(--ed-glass-bg)',
      backdropFilter: 'blur(20px) saturate(180%)',
      WebkitBackdropFilter: 'blur(20px) saturate(180%)',
      border: '1px solid var(--ed-glass-border)',
      boxShadow: '0 10px 28px rgba(15,23,42,0.1)',
      display: 'flex',
    }}>
      {TABS.map(t => {
        const active = tab === t.k;
        const Ic = t.Icon;
        return (
          <button key={t.k} onClick={() => setTab(t.k)} style={{
            flex: 1, height: 52, borderRadius: 18, border: 'none', background: 'transparent',
            display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 2,
            cursor: 'pointer', position: 'relative',
          }}>
            {active && (
              <div style={{
                position: 'absolute', inset: 0, borderRadius: 18,
                background: 'var(--ed-primary-grad)', opacity: 0.14,
              }}/>
            )}
            <Ic size={20} color={active ? '#059669' : '#94A3B8'} strokeWidth={active ? 2.4 : 2}/>
            <div style={{ fontSize: 10, fontWeight: active ? 800 : 700, color: active ? '#059669' : '#94A3B8', letterSpacing: 0.2 }}>
              {t.l}
            </div>
          </button>
        );
      })}
    </div>
  );
}
