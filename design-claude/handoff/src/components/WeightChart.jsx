import React from 'react';

/**
 * WeightChart — smoothed cubic line chart + area fill + goal line.
 * data: Array<{d: string, v: number}>
 */
export default function WeightChart({ data, width = 320, height = 150, goal = 64 }) {
  const vals = data.map(d => d.v);
  const min = Math.min(...vals) - 0.5;
  const max = Math.max(...vals) + 0.5;
  const pad = 16;
  const stepX = (width - pad * 2) / (data.length - 1);
  const y = v => pad + ((max - v) / (max - min)) * (height - pad * 2);
  const pts = data.map((d, i) => [pad + i * stepX, y(d.v)]);

  const path = pts.reduce((acc, p, i, arr) => {
    if (i === 0) return `M ${p[0]} ${p[1]}`;
    const prev = arr[i - 1];
    const cx1 = prev[0] + stepX * 0.4, cy1 = prev[1];
    const cx2 = p[0] - stepX * 0.4,    cy2 = p[1];
    return acc + ` C ${cx1} ${cy1}, ${cx2} ${cy2}, ${p[0]} ${p[1]}`;
  }, '');
  const area = path + ` L ${pts[pts.length - 1][0]} ${height - pad} L ${pts[0][0]} ${height - pad} Z`;

  return (
    <svg width={width} height={height} style={{ display: 'block' }}>
      <defs>
        <linearGradient id="wLineGrad" x1="0" x2="1" y1="0" y2="0">
          <stop offset="0" stopColor="#10B981"/>
          <stop offset="1" stopColor="#8B5CF6"/>
        </linearGradient>
        <linearGradient id="wAreaGrad" x1="0" x2="0" y1="0" y2="1">
          <stop offset="0" stopColor="#10B981" stopOpacity="0.28"/>
          <stop offset="1" stopColor="#10B981" stopOpacity="0"/>
        </linearGradient>
      </defs>
      {[0.25, 0.5, 0.75].map(f => (
        <line key={f} x1={pad} x2={width - pad} y1={pad + f * (height - pad * 2)} y2={pad + f * (height - pad * 2)} stroke="rgba(15,23,42,0.06)" strokeDasharray="3 4"/>
      ))}
      <line x1={pad} x2={width - pad} y1={y(goal)} y2={y(goal)} stroke="#F59E0B" strokeWidth="1.5" strokeDasharray="4 4" opacity="0.7"/>
      <text x={width - pad} y={y(goal) - 4} textAnchor="end" fill="#F59E0B" fontSize="10" fontWeight="800">Objectif {goal} kg</text>
      <path d={area} fill="url(#wAreaGrad)"/>
      <path d={path} fill="none" stroke="url(#wLineGrad)" strokeWidth="2.6" strokeLinecap="round" strokeLinejoin="round"/>
      {pts.map(([x, y], i) => (
        <g key={i}>
          <circle cx={x} cy={y} r="4" fill="#fff" stroke="#10B981" strokeWidth="2"/>
          {i === pts.length - 1 && <circle cx={x} cy={y} r="9" fill="#10B981" opacity="0.2"/>}
        </g>
      ))}
      {data.map((d, i) => (i % 2 === 0) && (
        <text key={i} x={pad + i * stepX} y={height - 2} textAnchor="middle" fill="#94A3B8" fontSize="9" fontWeight="700">{d.d}</text>
      ))}
    </svg>
  );
}
