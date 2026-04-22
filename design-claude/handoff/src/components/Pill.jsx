import React from 'react';

export default function Pill({ children, active = false, onClick, style = {} }) {
  return (
    <button
      onClick={onClick}
      style={{
        height: 36, padding: '0 16px', borderRadius: 999, border: 'none',
        background: active ? 'var(--ed-primary-grad)' : 'var(--ed-glass-bg)',
        color: active ? '#fff' : 'var(--ed-text)',
        fontSize: 13, fontWeight: 700,
        boxShadow: active
          ? '0 6px 14px rgba(16,185,129,0.3)'
          : 'inset 0 0 0 1px var(--ed-glass-border)',
        backdropFilter: active ? 'none' : 'blur(10px)',
        cursor: 'pointer',
        transition: 'transform 150ms ease-out',
        display: 'inline-flex', alignItems: 'center', gap: 6,
        whiteSpace: 'nowrap',
        ...style,
      }}
      onMouseDown={e => { e.currentTarget.style.transform = 'scale(0.96)'; }}
      onMouseUp={e => { e.currentTarget.style.transform = 'scale(1)'; }}
      onMouseLeave={e => { e.currentTarget.style.transform = 'scale(1)'; }}
    >
      {children}
    </button>
  );
}
