import React, { useState } from 'react';
import { Scale, Target, TrendingDown, TrendingUp, Calendar, Plus } from 'lucide-react';
import Glass from '../components/Glass.jsx';
import GradText from '../components/GradText.jsx';
import WeightChart from '../components/WeightChart.jsx';
import { WEIGHT } from '../data/fixtures.js';

export default function Weight() {
  const w = WEIGHT;
  const [period, setPeriod] = useState('3m');
  const stats = [
    { l: 'Poids actuel', Ic: Scale,        c: '#8B5CF6', v: `${w.current} kg` },
    { l: 'Objectif',     Ic: Target,       c: '#10B981', v: `${w.target} kg` },
    { l: 'Total perdu',  Ic: TrendingDown, c: '#F43F5E', v: `−${(w.start - w.current).toFixed(1)} kg` },
    { l: 'Rythme / sem', Ic: TrendingUp,   c: '#F59E0B', v: `${w.weeklyPace} kg` },
  ];

  return (
    <div style={{ padding: '0 20px 110px', position: 'relative' }}>
      <div style={{ padding: '14px 0 16px' }}>
        <div style={{ fontSize: 12, color: '#64748B', fontWeight: 700, letterSpacing: 0.4, textTransform: 'uppercase' }}>Suivi</div>
        <GradText size={24}>Mon poids</GradText>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10, marginBottom: 12 }}>
        {stats.map(s => {
          const Ic = s.Ic;
          return (
            <Glass key={s.l} pad={14} radius={18}>
              <div style={{ width: 32, height: 32, borderRadius: 10, background: `${s.c}22`, display: 'flex', alignItems: 'center', justifyContent: 'center', marginBottom: 8 }}>
                <Ic size={16} color={s.c}/>
              </div>
              <div style={{ fontSize: 10, color: '#64748B', fontWeight: 800, letterSpacing: 0.5, textTransform: 'uppercase' }}>{s.l}</div>
              <div style={{ fontSize: 19, fontWeight: 800, color: 'var(--ed-text)', letterSpacing: -0.5, marginTop: 2 }}>{s.v}</div>
            </Glass>
          );
        })}
      </div>

      <Glass pad={14} radius={18} accent accentColor="#10B981" style={{ paddingLeft: 20, marginBottom: 12 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
          <div style={{ width: 34, height: 34, borderRadius: 10, background: 'rgba(16,185,129,0.15)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <Calendar size={18} color="#059669"/>
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 11, color: '#059669', fontWeight: 800, letterSpacing: 0.5, textTransform: 'uppercase' }}>Objectif atteint</div>
            <div style={{ fontSize: 14, fontWeight: 800, color: 'var(--ed-text)', marginTop: 1 }}>
              Autour du <span style={{ color: '#059669' }}>{w.projected}</span>
            </div>
          </div>
          <div style={{ fontSize: 11, color: '#64748B', fontWeight: 700, textAlign: 'right' }}>
            <div style={{ fontWeight: 800, color: 'var(--ed-text)' }}>12 sem.</div>
            restantes
          </div>
        </div>
      </Glass>

      <Glass pad={14} radius={20} style={{ marginBottom: 12 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 6 }}>
          <div style={{ fontSize: 13, fontWeight: 800, color: 'var(--ed-text)' }}>Évolution</div>
          <div style={{ display: 'flex', gap: 4, background: 'rgba(15,23,42,0.05)', padding: 3, borderRadius: 10 }}>
            {[{ k: '4w', l: '4 sem' }, { k: '3m', l: '3 mois' }, { k: 'all', l: 'Tout' }].map(p => (
              <button key={p.k} onClick={() => setPeriod(p.k)} style={{
                height: 26, padding: '0 10px', borderRadius: 7, border: 'none',
                background: period === p.k ? '#fff' : 'transparent',
                fontSize: 11, fontWeight: 800,
                color: period === p.k ? 'var(--ed-text)' : '#64748B',
                cursor: 'pointer',
                boxShadow: period === p.k ? '0 1px 3px rgba(0,0,0,0.08)' : 'none',
              }}>{p.l}</button>
            ))}
          </div>
        </div>
        <WeightChart data={w.history}/>
      </Glass>

      <div style={{ fontSize: 11, fontWeight: 800, color: '#64748B', letterSpacing: 0.5, textTransform: 'uppercase', padding: '4px 4px 8px' }}>Historique</div>
      <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
        {[...w.history].reverse().slice(0, 5).map((h, i, arr) => {
          const prev = arr[i + 1]?.v;
          const diff = prev ? (h.v - prev) : null;
          const Dir = diff && diff < 0 ? TrendingDown : TrendingUp;
          return (
            <Glass key={i} pad={12} radius={14}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                <div style={{ width: 30, height: 30, borderRadius: 9, background: 'rgba(16,185,129,0.12)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                  <Scale size={15} color="#059669"/>
                </div>
                <div style={{ flex: 1 }}>
                  <div style={{ fontSize: 14, fontWeight: 800, color: 'var(--ed-text)', letterSpacing: -0.2 }}>{h.v} kg</div>
                  <div style={{ fontSize: 11, color: '#64748B', fontWeight: 600 }}>{h.d} · 2026</div>
                </div>
                {diff !== null && (
                  <div style={{
                    fontSize: 11, fontWeight: 800,
                    color: diff < 0 ? '#059669' : '#BE123C',
                    background: diff < 0 ? 'rgba(16,185,129,0.12)' : 'rgba(244,63,94,0.12)',
                    padding: '3px 8px', borderRadius: 999,
                    display: 'inline-flex', alignItems: 'center', gap: 2,
                  }}>
                    <Dir size={11}/>
                    {diff > 0 ? '+' : ''}{diff.toFixed(1)}
                  </div>
                )}
              </div>
            </Glass>
          );
        })}
      </div>

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
