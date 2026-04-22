import React from 'react';

/**
 * Glass — frosted translucent card with backdrop blur.
 * Props: radius, pad, border, accent, accentColor, onClick, style
 */
export default function Glass({
  children,
  radius = 20,
  pad = 16,
  border = true,
  style = {},
  onClick,
  accent = false,
  accentColor,
}) {
  return (
    <div
      onClick={onClick}
      style={{
        position: 'relative',
        borderRadius: radius,
        background: 'var(--ed-glass-bg)',
        backdropFilter: 'blur(var(--ed-glass-blur)) saturate(180%)',
        WebkitBackdropFilter: 'blur(var(--ed-glass-blur)) saturate(180%)',
        border: border ? '1px solid var(--ed-glass-border)' : 'none',
        boxShadow: '0 2px 8px rgba(15,23,42,0.04), 0 12px 32px rgba(15,23,42,0.05)',
        padding: pad,
        overflow: 'hidden',
        cursor: onClick ? 'pointer' : 'default',
        transition: 'transform 180ms ease-out, box-shadow 180ms ease-out',
        ...style,
      }}
    >
      {accent && (
        <div style={{
          position: 'absolute', left: 0, top: 0, bottom: 0, width: 5,
          background: accentColor || 'var(--ed-primary)',
          borderTopLeftRadius: radius, borderBottomLeftRadius: radius,
        }}/>
      )}
      {children}
    </div>
  );
}
