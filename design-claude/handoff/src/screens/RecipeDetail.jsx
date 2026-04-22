import React, { useState } from 'react';
import { Star, Minus, Plus, Clock, Flame, Play, ChevronLeft } from 'lucide-react';
import Glass from '../components/Glass.jsx';
import { BUDDHA_BOWL_DETAIL } from '../data/fixtures.js';

export default function RecipeDetail({ onBack }) {
  const [servings, setServings] = useState(2);
  const r = BUDDHA_BOWL_DETAIL;
  const scale = servings / 2;

  return (
    <div style={{ padding: '0 0 110px', position: 'relative' }}>
      {onBack && (
        <div style={{ padding: '8px 20px 0' }}>
          <button onClick={onBack} style={{
            height: 36, padding: '0 12px', borderRadius: 999, border: 'none',
            background: 'var(--ed-glass-bg)', backdropFilter: 'blur(12px)',
            boxShadow: 'inset 0 0 0 1px var(--ed-glass-border)',
            display: 'inline-flex', alignItems: 'center', gap: 4, cursor: 'pointer',
            color: 'var(--ed-text)', fontSize: 13, fontWeight: 800,
          }}>
            <ChevronLeft size={16} color="#475569"/> Recettes
          </button>
        </div>
      )}

      <div style={{
        height: 220, margin: '8px 20px 0', borderRadius: 24, position: 'relative', overflow: 'hidden',
        background: `linear-gradient(135deg, ${r.color} 0%, #6EE7B7 40%, #14B8A6 70%, #8B5CF6 120%)`,
        boxShadow: '0 16px 40px rgba(16,185,129,0.3)',
      }}>
        <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(circle at 30% 20%, rgba(255,255,255,0.4), transparent 60%)' }}/>
        <div style={{ position: 'absolute', inset: 0, backgroundImage: 'repeating-linear-gradient(45deg, rgba(255,255,255,0.05) 0 8px, transparent 8px 16px)' }}/>
        <div style={{ position: 'absolute', left: 16, top: 16 }}>
          <div style={{ padding: '5px 10px', borderRadius: 999, background: 'rgba(255,255,255,0.25)', backdropFilter: 'blur(10px)', fontSize: 10, fontWeight: 800, color: '#fff', letterSpacing: 0.6, textTransform: 'uppercase' }}>Déjeuner</div>
        </div>
        <button style={{ position: 'absolute', right: 16, top: 16, width: 38, height: 38, borderRadius: 12, border: 'none', background: 'rgba(255,255,255,0.25)', backdropFilter: 'blur(10px)', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <Star size={18} color="#fff"/>
        </button>
      </div>

      <div style={{ padding: '18px 20px 0' }}>
        <div style={{ fontSize: 22, fontWeight: 800, color: 'var(--ed-text)', letterSpacing: -0.6, lineHeight: 1.2, marginBottom: 6 }}>{r.name}</div>
        <div style={{ fontSize: 13, color: '#475569', fontWeight: 500, lineHeight: 1.5, marginBottom: 14 }}>{r.desc}</div>

        <Glass pad={14} radius={18} style={{ marginBottom: 12 }}>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4,1fr)' }}>
            {[
              { l: 'Calories',  v: Math.round(r.kcal * scale),    u: 'kcal', c: '#10B981' },
              { l: 'Protéines', v: Math.round(r.protein * scale), u: 'g',    c: '#F43F5E' },
              { l: 'Glucides',  v: Math.round(r.carbs * scale),   u: 'g',    c: '#F59E0B' },
              { l: 'Lipides',   v: Math.round(r.fat * scale),     u: 'g',    c: '#8B5CF6' },
            ].map((m, i) => (
              <div key={m.l} style={{ textAlign: 'center', padding: '2px 0', borderLeft: i > 0 ? '1px solid rgba(15,23,42,0.06)' : 'none' }}>
                <div style={{ fontSize: 18, fontWeight: 800, color: m.c, letterSpacing: -0.3 }}>{m.v}<span style={{ fontSize: 10, color: '#64748B', fontWeight: 700, marginLeft: 1 }}>{m.u}</span></div>
                <div style={{ fontSize: 10, color: '#64748B', fontWeight: 700, letterSpacing: 0.3, marginTop: 1, textTransform: 'uppercase' }}>{m.l}</div>
              </div>
            ))}
          </div>
        </Glass>

        <div style={{ display: 'flex', gap: 8, marginBottom: 14, alignItems: 'center' }}>
          <Glass pad={0} radius={14} style={{ display: 'flex', alignItems: 'center', height: 40, padding: '0 6px' }}>
            <button onClick={() => setServings(Math.max(0.5, servings - 0.5))} style={{ width: 28, height: 28, borderRadius: 10, border: 'none', background: 'rgba(15,23,42,0.05)', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              <Minus size={14} color="#475569"/>
            </button>
            <div style={{ padding: '0 10px', fontSize: 13, fontWeight: 800, color: 'var(--ed-text)', minWidth: 60, textAlign: 'center' }}>{servings} pers.</div>
            <button onClick={() => setServings(servings + 0.5)} style={{ width: 28, height: 28, borderRadius: 10, border: 'none', background: 'rgba(15,23,42,0.05)', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              <Plus size={14} color="#475569"/>
            </button>
          </Glass>
          <Glass pad={0} radius={999} style={{ height: 40, padding: '0 12px', display: 'inline-flex', alignItems: 'center', gap: 6 }}>
            <Clock size={14} color="#475569"/>
            <span style={{ fontSize: 12, fontWeight: 800, color: 'var(--ed-text)' }}>{r.prep} min</span>
            <span style={{ fontSize: 10, color: '#64748B', fontWeight: 700 }}>prép.</span>
          </Glass>
          <Glass pad={0} radius={999} style={{ height: 40, padding: '0 12px', display: 'inline-flex', alignItems: 'center', gap: 6 }}>
            <Flame size={14} color="#F59E0B"/>
            <span style={{ fontSize: 12, fontWeight: 800, color: 'var(--ed-text)' }}>{r.cook} min</span>
            <span style={{ fontSize: 10, color: '#64748B', fontWeight: 700 }}>cuisson</span>
          </Glass>
        </div>

        <div style={{ fontSize: 13, fontWeight: 800, color: 'var(--ed-text)', marginBottom: 8 }}>Ingrédients</div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 4, marginBottom: 18 }}>
          {r.ingredients.map((it, i) => (
            <div key={i} style={{
              display: 'flex', justifyContent: 'space-between', alignItems: 'center',
              padding: '10px 14px', borderRadius: 12,
              background: i % 2 === 0 ? 'rgba(255,255,255,0.55)' : 'rgba(255,255,255,0.3)',
              border: '1px solid rgba(255,255,255,0.3)',
              backdropFilter: 'blur(8px)', fontSize: 13,
            }}>
              <span style={{ color: 'var(--ed-text)', fontWeight: 700 }}>{it.n}</span>
              <span style={{ color: '#64748B', fontWeight: 700, fontFamily: 'ui-monospace, monospace', fontSize: 12 }}>{it.q}</span>
            </div>
          ))}
        </div>

        <div style={{ fontSize: 13, fontWeight: 800, color: 'var(--ed-text)', marginBottom: 10 }}>Étapes</div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 10, marginBottom: 20 }}>
          {r.steps.map((s, i) => (
            <div key={i} style={{ display: 'flex', gap: 12 }}>
              <div style={{
                width: 28, height: 28, borderRadius: '50%', flexShrink: 0,
                background: 'var(--ed-primary-grad)',
                boxShadow: '0 4px 10px rgba(16,185,129,0.3)',
                color: '#fff', fontSize: 13, fontWeight: 800,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
              }}>{i + 1}</div>
              <div style={{ flex: 1, paddingTop: 4, fontSize: 13, color: 'var(--ed-text)', fontWeight: 500, lineHeight: 1.5 }}>{s}</div>
            </div>
          ))}
        </div>
      </div>

      <div style={{ position: 'sticky', bottom: 80, padding: '0 20px', marginBottom: 8 }}>
        <button style={{
          width: '100%', height: 54, borderRadius: 18, border: 'none',
          background: 'var(--ed-primary-grad)',
          boxShadow: '0 14px 32px rgba(16,185,129,0.5), inset 0 1px 0 rgba(255,255,255,0.3)',
          color: '#fff', fontSize: 15, fontWeight: 800, letterSpacing: 0.1,
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8, cursor: 'pointer',
        }}>
          <Play size={16} color="#fff"/>
          Lancer la cuisson
        </button>
      </div>
    </div>
  );
}
