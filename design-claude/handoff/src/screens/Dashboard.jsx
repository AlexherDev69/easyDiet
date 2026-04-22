import React from 'react';
import { Settings, Droplet, Utensils, TrendingUp, TrendingDown, ShoppingCart, Package, BookOpen, Scale, RotateCcw, ChevronRight, ArrowRight } from 'lucide-react';
import Glass from '../components/Glass.jsx';
import GradText from '../components/GradText.jsx';
import RadialMacro from '../components/RadialMacro.jsx';
import { DAYS, TODAY, NEXT_MEAL, WEIGHT } from '../data/fixtures.js';

function MiniBars({ data, height = 38 }) {
  const max = Math.max(...data);
  const min = Math.min(...data);
  const range = max - min || 1;
  return (
    <svg width={110} height={height} style={{ overflow: 'visible' }}>
      {data.map((v, i) => {
        const h = ((v - min) / range) * (height - 8) + 6;
        const x = i * 13;
        return <rect key={i} x={x} y={height - h} width={9} height={h} rx={3}
          fill={i === data.length - 1 ? '#10B981' : 'rgba(16,185,129,0.28)'}/>;
      })}
    </svg>
  );
}

export default function Dashboard({ onNav }) {
  const d = TODAY;
  const weightData = WEIGHT.history.map(h => h.v);
  const latestWeight = weightData[weightData.length - 1];
  const delta = weightData[0] - latestWeight;

  const quick = [
    { Ic: ShoppingCart, c: '#3B82F6', l: 'Courses',       s: '11 restants', k: 'shopping' },
    { Ic: Package,      c: '#F59E0B', l: 'Batch cooking', s: '3 recettes',  k: 'batch' },
    { Ic: BookOpen,     c: '#8B5CF6', l: 'Recettes',      s: '24 au total', k: 'recipes' },
    { Ic: Scale,        c: '#EC4899', l: 'Poids',         s: '−4.4 kg',     k: 'weight' },
  ];

  return (
    <div style={{ padding: '0 20px 110px' }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '14px 0 20px' }}>
        <div>
          <div style={{ fontSize: 13, color: '#64748B', fontWeight: 600, marginBottom: 2 }}>Mercredi 20 avril</div>
          <div style={{ fontSize: 26, fontWeight: 800, color: 'var(--ed-text)', letterSpacing: -0.8 }}>
            Bonjour, <GradText size={26}>Camille</GradText>
          </div>
        </div>
        <Glass radius={999} pad={0} style={{ width: 44, height: 44, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <Settings size={20} color="#475569"/>
        </Glass>
      </div>

      <div className="ed-scroll-x" style={{ display: 'flex', gap: 8, overflowX: 'auto', paddingBottom: 16 }}>
        {DAYS.map((day, i) => {
          const selected = i === d.dayIdx;
          const date = 18 + i;
          return (
            <button key={i} style={{
              minWidth: 54, height: 68, borderRadius: 18, border: 'none',
              background: selected ? 'var(--ed-primary-grad)' : 'var(--ed-glass-bg)',
              backdropFilter: 'blur(10px)',
              boxShadow: selected ? '0 8px 20px rgba(16,185,129,0.3)' : 'inset 0 0 0 1px var(--ed-glass-border)',
              display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
              color: selected ? '#fff' : 'var(--ed-text)', cursor: 'pointer', padding: 0,
            }}>
              <div style={{ fontSize: 11, fontWeight: 700, letterSpacing: 0.5, opacity: selected ? 0.85 : 0.55, textTransform: 'uppercase' }}>{day}</div>
              <div style={{ fontSize: 20, fontWeight: 800, marginTop: 2 }}>{date}</div>
            </button>
          );
        })}
      </div>

      <Glass pad={20} radius={24} style={{ marginBottom: 14 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 14 }}>
          <div>
            <div style={{ fontSize: 12, color: '#64748B', fontWeight: 700, letterSpacing: 0.5, textTransform: 'uppercase' }}>Aujourd'hui</div>
            <GradText size={20}>Objectif du jour</GradText>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 4, background: 'rgba(16,185,129,0.12)', color: '#059669', fontSize: 11, fontWeight: 800, padding: '4px 8px', borderRadius: 999 }}>
            <TrendingUp size={12}/> EN COURS
          </div>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 18 }}>
          <RadialMacro protein={d.protein} carbs={d.carbs} fat={d.fat} cal={d.calories} target={d.target}/>
          <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 10 }}>
            {[
              { c: '#F43F5E', l: 'Protéines', v: d.protein, t: 110 },
              { c: '#10B981', l: 'Glucides',  v: d.carbs,   t: 200 },
              { c: '#F59E0B', l: 'Lipides',   v: d.fat,     t: 65 },
            ].map(x => (
              <div key={x.l}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 4 }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 12, fontWeight: 700, color: 'var(--ed-text)' }}>
                    <div style={{ width: 8, height: 8, borderRadius: '50%', background: x.c }}/>
                    {x.l}
                  </div>
                  <div style={{ fontSize: 11, color: '#64748B', fontWeight: 600 }}>{x.v}g <span style={{ opacity: 0.6 }}>/ {x.t}g</span></div>
                </div>
                <div style={{ height: 5, borderRadius: 3, background: 'rgba(15,23,42,0.06)', overflow: 'hidden' }}>
                  <div style={{ height: '100%', width: `${Math.min(100, (x.v / x.t) * 100)}%`, background: x.c, borderRadius: 3 }}/>
                </div>
              </div>
            ))}
          </div>
        </div>

        <div style={{ marginTop: 16, paddingTop: 14, borderTop: '1px solid rgba(15,23,42,0.06)', display: 'flex', alignItems: 'center', gap: 10 }}>
          <div style={{ width: 34, height: 34, borderRadius: 10, background: 'rgba(59,130,246,0.12)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <Droplet size={18} color="#3B82F6"/>
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 13, fontWeight: 700, color: 'var(--ed-text)', marginBottom: 4 }}>
              <span>Hydratation</span><span>{d.water}L <span style={{ color: '#64748B', fontWeight: 600 }}>/ {d.waterTarget}L</span></span>
            </div>
            <div style={{ display: 'flex', gap: 4 }}>
              {Array.from({ length: 8 }).map((_, i) => {
                const filled = i < Math.round((d.water / d.waterTarget) * 8);
                return <div key={i} style={{ flex: 1, height: 10, borderRadius: 3, background: filled ? '#3B82F6' : 'rgba(59,130,246,0.15)' }}/>;
              })}
            </div>
          </div>
        </div>
      </Glass>

      <Glass pad={16} radius={20} accent accentColor="#10B981" style={{ marginBottom: 14, paddingLeft: 22 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
          <div style={{ width: 54, height: 54, borderRadius: 16, background: 'linear-gradient(135deg, rgba(16,185,129,0.25), rgba(20,184,166,0.18))', display: 'flex', alignItems: 'center', justifyContent: 'center', border: '1px solid rgba(16,185,129,0.25)' }}>
            <Utensils size={24} color="#059669"/>
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 11, color: '#10B981', fontWeight: 800, letterSpacing: 0.5, textTransform: 'uppercase', marginBottom: 2 }}>
              Prochain repas · {NEXT_MEAL.time}
            </div>
            <div style={{ fontSize: 15, fontWeight: 800, color: 'var(--ed-text)', lineHeight: 1.25, marginBottom: 2 }}>{NEXT_MEAL.name}</div>
            <div style={{ fontSize: 12, color: '#64748B', fontWeight: 600 }}>{NEXT_MEAL.kcal} kcal · 1 portion</div>
          </div>
          <ChevronRight size={20} color="#94A3B8"/>
        </div>
      </Glass>

      <Glass pad={16} radius={20} style={{ marginBottom: 14 }} onClick={() => onNav && onNav('weight')}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
          <div>
            <div style={{ fontSize: 12, color: '#64748B', fontWeight: 700, letterSpacing: 0.5, textTransform: 'uppercase' }}>Poids actuel</div>
            <div style={{ display: 'flex', alignItems: 'baseline', gap: 6, marginTop: 2 }}>
              <span style={{ fontSize: 26, fontWeight: 800, color: 'var(--ed-text)', letterSpacing: -0.6 }}>{latestWeight}</span>
              <span style={{ fontSize: 13, color: '#64748B', fontWeight: 700 }}>kg</span>
              <span style={{ display: 'inline-flex', alignItems: 'center', gap: 2, fontSize: 11, fontWeight: 800, color: '#F43F5E', background: 'rgba(244,63,94,0.1)', padding: '2px 6px', borderRadius: 999, marginLeft: 4 }}>
                <TrendingDown size={11}/> −{delta.toFixed(1)} kg
              </span>
            </div>
          </div>
          <MiniBars data={weightData}/>
        </div>
      </Glass>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12, marginBottom: 14 }}>
        {quick.map(x => {
          const Ic = x.Ic;
          return (
            <Glass key={x.l} pad={14} radius={18} onClick={() => onNav && onNav(x.k)}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                <div style={{ width: 36, height: 36, borderRadius: 11, background: `${x.c}22`, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                  <Ic size={18} color={x.c}/>
                </div>
                <ArrowRight size={14} color="rgba(100,116,139,0.4)" style={{ marginTop: 4 }}/>
              </div>
              <div style={{ fontSize: 14, fontWeight: 800, color: 'var(--ed-text)', marginTop: 12, letterSpacing: -0.2 }}>{x.l}</div>
              <div style={{ fontSize: 11, color: '#64748B', fontWeight: 600, marginTop: 1 }}>{x.s}</div>
            </Glass>
          );
        })}
      </div>

      <button style={{
        width: '100%', height: 52, borderRadius: 16, border: 'none',
        background: 'var(--ed-glass-bg)', backdropFilter: 'blur(12px)',
        boxShadow: 'inset 0 0 0 1px var(--ed-glass-border)',
        display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
        fontSize: 14, fontWeight: 800, color: 'var(--ed-text)', cursor: 'pointer',
      }}>
        <RotateCcw size={16} color="#475569"/>
        Décaler le programme
      </button>
    </div>
  );
}
