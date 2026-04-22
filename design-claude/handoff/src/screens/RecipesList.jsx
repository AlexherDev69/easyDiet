import React, { useState } from 'react';
import { Utensils, Flame, Clock, Leaf } from 'lucide-react';
import Glass from '../components/Glass.jsx';
import GradText from '../components/GradText.jsx';
import Pill from '../components/Pill.jsx';
import { RECIPES } from '../data/fixtures.js';

export default function RecipesList({ onOpen }) {
  const [tab, setTab] = useState('week');
  const [cat, setCat] = useState('Toutes');
  const cats = ['Toutes', 'Petit-déj', 'Déjeuner', 'Dîner', 'Snack'];

  let list = RECIPES;
  if (tab === 'week') list = list.slice(0, 6);
  if (cat !== 'Toutes') list = list.filter(r => r.cat === cat);

  return (
    <div style={{ padding: '0 20px 110px' }}>
      <div style={{ padding: '14px 0 14px' }}>
        <div style={{ fontSize: 12, color: '#64748B', fontWeight: 700, letterSpacing: 0.4, textTransform: 'uppercase' }}>Bibliothèque</div>
        <GradText size={24}>Recettes</GradText>
      </div>

      <div style={{ display: 'flex', gap: 8, marginBottom: 12 }}>
        <Pill active={tab === 'week'} onClick={() => setTab('week')}>Cette semaine</Pill>
        <Pill active={tab === 'all'}  onClick={() => setTab('all')}>Toutes les recettes</Pill>
      </div>

      <div className="ed-scroll-x" style={{ display: 'flex', gap: 6, overflowX: 'auto', paddingBottom: 14 }}>
        {cats.map(c => (
          <button key={c} onClick={() => setCat(c)} style={{
            height: 30, padding: '0 12px', borderRadius: 999, border: 'none',
            background: cat === c ? 'var(--ed-text)' : 'rgba(255,255,255,0.5)',
            color: cat === c ? '#fff' : 'var(--ed-text)',
            fontSize: 12, fontWeight: 800, letterSpacing: 0.1,
            cursor: 'pointer', whiteSpace: 'nowrap',
            boxShadow: cat === c ? 'none' : 'inset 0 0 0 1px var(--ed-glass-border)',
          }}>{c}</button>
        ))}
      </div>

      <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
        {list.map((r, i) => (
          <Glass key={i} pad={14} radius={16} accent accentColor={r.color} style={{ paddingLeft: 18 }} onClick={() => onOpen && onOpen(r)}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
              <div style={{
                width: 58, height: 58, borderRadius: 14, flexShrink: 0,
                background: `linear-gradient(135deg, ${r.color}30, ${r.color}10)`,
                border: `1px solid ${r.color}30`,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
              }}>
                {r.cat === 'Snack' ? <Leaf size={22} color={r.color}/> : <Utensils size={22} color={r.color}/>}
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 10, fontWeight: 800, color: r.color, letterSpacing: 0.5, textTransform: 'uppercase', marginBottom: 2 }}>{r.cat}</div>
                <div style={{ fontSize: 14, fontWeight: 800, color: 'var(--ed-text)', lineHeight: 1.25, marginBottom: 4, letterSpacing: -0.2 }}>{r.name}</div>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 11, color: '#64748B', fontWeight: 700 }}>
                  <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3 }}><Flame size={11}/> {r.kcal} kcal</span>
                  <span style={{ width: 3, height: 3, borderRadius: '50%', background: 'rgba(100,116,139,0.4)' }}/>
                  <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3 }}><Clock size={11}/> {r.prep} min</span>
                  <span style={{
                    marginLeft: 'auto', fontSize: 10, fontWeight: 800, padding: '2px 7px', borderRadius: 999,
                    background: r.diff === 'Facile' ? 'rgba(16,185,129,0.15)' : r.diff === 'Moyen' ? 'rgba(245,158,11,0.15)' : 'rgba(244,63,94,0.15)',
                    color:     r.diff === 'Facile' ? '#059669'               : r.diff === 'Moyen' ? '#B45309'               : '#BE123C',
                  }}>{r.diff}</span>
                </div>
              </div>
            </div>
          </Glass>
        ))}
      </div>
    </div>
  );
}
