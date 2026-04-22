import React, { useState } from 'react';
import { RotateCcw, Check, Info, Plus } from 'lucide-react';
import Glass from '../components/Glass.jsx';
import GradText from '../components/GradText.jsx';
import Pill from '../components/Pill.jsx';

export default function Shopping({ shopping, setShopping }) {
  const [tripIdx, setTripIdx] = useState(0);
  const trip = shopping.trips[tripIdx];
  const sections = trip?.sections || [];

  let total = 0, done = 0;
  sections.forEach(s => s.items.forEach(it => { total++; if (it.done) done++; }));
  const pct = total === 0 ? 0 : (done / total) * 100;

  const toggleItem = (si, ii) => {
    setShopping({
      ...shopping,
      trips: shopping.trips.map((t, ti) => {
        if (ti !== tripIdx) return t;
        return {
          ...t,
          sections: t.sections.map((s, i) => {
            if (i !== si) return s;
            return { ...s, items: s.items.map((it, j) => j !== ii ? it : { ...it, done: !it.done }) };
          }),
        };
      }),
    });
  };

  return (
    <div style={{ padding: '0 20px 110px', position: 'relative' }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '14px 0 16px' }}>
        <div>
          <div style={{ fontSize: 12, color: '#64748B', fontWeight: 700, letterSpacing: 0.4, textTransform: 'uppercase' }}>Cette semaine</div>
          <GradText size={24}>Liste de courses</GradText>
        </div>
        <Glass radius={999} pad={0} style={{ width: 40, height: 40, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <RotateCcw size={18} color="#475569"/>
        </Glass>
      </div>

      <div className="ed-scroll-x" style={{ display: 'flex', gap: 8, overflowX: 'auto', paddingBottom: 14 }}>
        {shopping.trips.map((t, i) => (
          <Pill key={i} active={i === tripIdx} onClick={() => setTripIdx(i)}>{t.name}</Pill>
        ))}
      </div>

      <Glass pad={16} radius={20} style={{ marginBottom: 14 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
          <div>
            <div style={{ fontSize: 12, color: '#64748B', fontWeight: 700, letterSpacing: 0.4, textTransform: 'uppercase' }}>Progression</div>
            <div style={{ display: 'flex', alignItems: 'baseline', gap: 5, marginTop: 2 }}>
              <span style={{ fontSize: 24, fontWeight: 800, color: 'var(--ed-text)', letterSpacing: -0.6 }}>{done}</span>
              <span style={{ fontSize: 13, color: '#64748B', fontWeight: 700 }}>/ {total} articles</span>
            </div>
          </div>
          <div style={{
            width: 52, height: 52, borderRadius: '50%',
            background: `conic-gradient(#10B981 ${pct * 3.6}deg, rgba(15,23,42,0.08) 0)`,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>
            <div style={{ width: 40, height: 40, borderRadius: '50%', background: 'var(--ed-bg-solid)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 12, fontWeight: 800, color: '#059669' }}>
              {Math.round(pct)}%
            </div>
          </div>
        </div>
      </Glass>

      {sections.map((s, si) => (
        <div key={s.name} style={{ marginBottom: 14 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6, padding: '0 4px 8px' }}>
            <div style={{ fontSize: 11, fontWeight: 800, color: '#059669', letterSpacing: 0.6, textTransform: 'uppercase' }}>{s.name}</div>
            <div style={{ height: 1, flex: 1, background: 'rgba(15,23,42,0.08)' }}/>
            <div style={{ fontSize: 10, fontWeight: 800, color: '#64748B' }}>
              {s.items.filter(i => i.done).length}/{s.items.length}
            </div>
          </div>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
            {s.items.map((it, ii) => (
              <Glass key={ii} pad={12} radius={14}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                  <button onClick={() => toggleItem(si, ii)} style={{
                    width: 26, height: 26, borderRadius: 8, border: 'none',
                    background: it.done ? 'var(--ed-primary-grad)' : 'rgba(15,23,42,0.04)',
                    boxShadow: it.done ? 'none' : 'inset 0 0 0 2px rgba(15,23,42,0.18)',
                    cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center',
                    transition: 'all 180ms ease-out', flexShrink: 0,
                  }}>
                    {it.done && <Check size={14} color="#fff" strokeWidth={3.2}/>}
                  </button>
                  <div style={{ flex: 1 }}>
                    <div style={{ fontSize: 14, fontWeight: 700, color: 'var(--ed-text)', textDecoration: it.done ? 'line-through' : 'none', opacity: it.done ? 0.5 : 1, lineHeight: 1.25 }}>{it.n}</div>
                    <div style={{ fontSize: 11, color: '#64748B', fontWeight: 600, marginTop: 1, opacity: it.done ? 0.5 : 1 }}>{it.q}</div>
                  </div>
                  <button style={{ width: 28, height: 28, borderRadius: 8, border: 'none', background: 'transparent', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                    <Info size={16} color="#94A3B8"/>
                  </button>
                </div>
              </Glass>
            ))}
          </div>
        </div>
      ))}

      <button style={{
        position: 'absolute', right: 20, bottom: 110, zIndex: 40,
        width: 56, height: 56, borderRadius: 18, border: 'none',
        background: 'var(--ed-primary-grad)',
        boxShadow: '0 12px 28px rgba(16,185,129,0.45)',
        display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer',
      }}>
        <Plus size={26} color="#fff" strokeWidth={2.6}/>
      </button>
    </div>
  );
}
