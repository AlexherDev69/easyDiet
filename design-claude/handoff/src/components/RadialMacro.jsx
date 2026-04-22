import React from 'react';

/**
 * RadialMacro — donut chart with three arcs (protein/carbs/fat by calorie share).
 * Displays cal / target in the center.
 */
export default function RadialMacro({ size = 168, protein, carbs, fat, cal, target }) {
  const stroke = 14;
  const gap = 3;
  const r = (size - stroke) / 2;
  const cx = size / 2, cy = size / 2;
  const cals = { p: protein * 4, c: carbs * 4, f: fat * 9 };
  const calTotal = cals.p + cals.c + cals.f;
  const arcs = [
    { k: 'p', frac: cals.p / calTotal, color: '#F43F5E' },
    { k: 'c', frac: cals.c / calTotal, color: '#10B981' },
    { k: 'f', frac: cals.f / calTotal, color: '#F59E0B' },
  ];

  let angle = -90;
  const totalGap = gap * arcs.length;
  const availDeg = 360 - totalGap;

  const polar = (cx, cy, r, a) => {
    const rad = (a * Math.PI) / 180;
    return [cx + r * Math.cos(rad), cy + r * Math.sin(rad)];
  };
  const arcPath = (a0, a1) => {
    const [x0, y0] = polar(cx, cy, r, a0);
    const [x1, y1] = polar(cx, cy, r, a1);
    const large = (a1 - a0) > 180 ? 1 : 0;
    return `M ${x0} ${y0} A ${r} ${r} 0 ${large} 1 ${x1} ${y1}`;
  };

  return (
    <div style={{ position: 'relative', width: size, height: size }}>
      <svg width={size} height={size}>
        <circle cx={cx} cy={cy} r={r} fill="none" stroke="rgba(15,23,42,0.06)" strokeWidth={stroke}/>
        {arcs.map(a => {
          const sweep = a.frac * availDeg;
          const a0 = angle;
          const a1 = angle + sweep;
          angle = a1 + gap;
          return <path key={a.k} d={arcPath(a0, a1)} stroke={a.color} strokeWidth={stroke} fill="none" strokeLinecap="round"/>;
        })}
      </svg>
      <div style={{
        position: 'absolute', inset: 0, display: 'flex', flexDirection: 'column',
        alignItems: 'center', justifyContent: 'center',
      }}>
        <div style={{ fontSize: 11, fontWeight: 700, color: '#64748B', letterSpacing: 0.5, textTransform: 'uppercase' }}>kcal</div>
        <div style={{ fontSize: 34, fontWeight: 800, letterSpacing: -1, color: 'var(--ed-text)', lineHeight: 1 }}>{cal}</div>
        <div style={{ fontSize: 12, color: '#64748B', fontWeight: 600, marginTop: 4 }}>/ {target}</div>
      </div>
    </div>
  );
}
