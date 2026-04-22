import React, { useState } from 'react';
import { ArrowLeftRight, RotateCcw, Flame, Clock, Check } from 'lucide-react';
import Glass from '../components/Glass.jsx';
import GradText from '../components/GradText.jsx';
import { DAYS } from '../data/fixtures.js';

export default function MealPlan({ plan, setPlan }) {
  const [dayIdx, setDayIdx] = useState(2);
  const meals = plan[dayIdx].meals;
  const totalKcal = meals.reduce((s, m) => s + (m.done ? m.kcal : 0), 0);
  const targetKcal = 1850;
  const macros = [
    { l: 'Protéines', v: 78,  t: 110, c: '#F43F5E' },
    { l: 'Glucides',  v: 142, t: 200, c: '#10B981' },
    { l: 'Lipides',   v: 52,  t: 65,  c: '#F59E0B' },
  ];

  const toggle = mi => {
    setPlan(plan.map((d, i) => i !== dayIdx ? d : {
      ...d,
      meals: d.meals.map((m, j) => j !== mi ? m : { ...m, done: !m.done }),
    }));
  };

  return (
    <div style={{ padding: '0 20px 110px' }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '14px 0 16px' }}>
        <div>
          <div style={{ fontSize: 12, color: '#64748B', fontWeight: 700, letterSpacing: 0.4, textTransform: 'uppercase' }}>Semaine du 18</div>
          <GradText size={24}>Plan de la semaine</GradText>
        </div>
        <div style={{ display: 'flex', gap: 8 }}>
          <Glass radius={999} pad={0} style={{ width: 40, height: 40, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <ArrowLeftRight size={18} color="#475569"/>
          </Glass>
          <Glass radius={999} pad={0} style={{ width: 40, height: 40, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <RotateCcw size={18} color="#475569"/>
          </Glass>
        </div>
      </div>

      <div className="ed-scroll-x" style={{ display: 'flex', gap: 6, overflowX: 'auto', paddingBottom: 14 }}>
        {DAYS.map((d, i) => (
          <button key={i} onClick={() => setDayIdx(i)} style={{
            minWidth: 46, height: 46, borderRadius: 14, border: 'none',
            background: i === dayIdx ? 'var(--ed-primary-grad)' : 'var(--ed-glass-bg)',
            backdropFilter: 'blur(10px)',
            boxShadow: i === dayIdx ? '0 6px 14px rgba(16,185,129,0.3)' : 'inset 0 0 0 1px var(--ed-glass-border)',
            color: i === dayIdx ? '#fff' : 'var(--ed-text)',
            fontSize: 13, fontWeight: 800, cursor: 'pointer',
          }}>{d}</button>
        ))}
      </div>

      <Glass pad={16} radius={20} style={{ marginBottom: 14 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 12 }}>
          <div style={{ fontSize: 13, fontWeight: 800, color: 'var(--ed-text)' }}>Résumé macro</div>
          <div style={{ fontSize: 12, color: '#64748B', fontWeight: 700 }}>
            <span style={{ color: 'var(--ed-text)', fontWeight: 800 }}>{totalKcal}</span> / {targetKcal} kcal
          </div>
        </div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
          {macros.map(m => (
            <div key={m.l}>
              <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 11, fontWeight: 700, marginBottom: 3 }}>
                <span style={{ color: 'var(--ed-text)' }}>{m.l}</span>
                <span style={{ color: '#64748B' }}>{m.v}g / {m.t}g</span>
              </div>
              <div style={{ height: 6, borderRadius: 3, background: 'rgba(15,23,42,0.06)', overflow: 'hidden' }}>
                <div style={{ height: '100%', width: `${(m.v / m.t) * 100}%`, background: m.c, borderRadius: 3 }}/>
              </div>
            </div>
          ))}
        </div>
      </Glass>

      <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
        {meals.map((m, i) => (
          <Glass key={i} pad={14} radius={18} accent accentColor={m.color} style={{ paddingLeft: 20 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
              <div style={{ flex: 1 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 4 }}>
                  <div style={{ fontSize: 10, fontWeight: 800, color: m.color, letterSpacing: 0.6, textTransform: 'uppercase' }}>{m.type}</div>
                  <div style={{ fontSize: 10, fontWeight: 700, color: '#64748B', background: 'rgba(15,23,42,0.05)', padding: '1px 6px', borderRadius: 999 }}>
                    {m.serv} pers.
                  </div>
                </div>
                <div style={{ fontSize: 14, fontWeight: 800, color: 'var(--ed-text)', lineHeight: 1.25, marginBottom: 3, textDecoration: m.done ? 'line-through' : 'none' }}>
                  {m.name}
                </div>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 11, color: '#64748B', fontWeight: 700 }}>
                  <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3 }}><Flame size={11}/> {m.kcal} kcal</span>
                  <span style={{ width: 3, height: 3, borderRadius: '50%', background: 'rgba(100,116,139,0.4)' }}/>
                  <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3 }}><Clock size={11}/> prêt</span>
                </div>
              </div>
              <button onClick={() => toggle(i)} style={{
                width: 28, height: 28, borderRadius: 9, border: 'none',
                background: m.done ? m.color : 'rgba(15,23,42,0.05)',
                boxShadow: m.done ? 'none' : 'inset 0 0 0 2px rgba(15,23,42,0.15)',
                cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center',
                transition: 'all 180ms ease-out',
              }}>
                {m.done && <Check size={16} color="#fff" strokeWidth={3}/>}
              </button>
            </div>
          </Glass>
        ))}
      </div>
    </div>
  );
}
