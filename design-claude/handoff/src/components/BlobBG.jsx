import React from 'react';

/**
 * BlobBG — 3 animated gradient blobs. Place as first child of a positioned parent.
 * Respects prefers-reduced-motion via .ed-blob class (see theme.css).
 */
export default function BlobBG({ intensity = 1 }) {
  return (
    <div style={{
      position: 'absolute', inset: 0, overflow: 'hidden',
      background: 'var(--ed-bg)', zIndex: 0,
      pointerEvents: 'none',
    }}>
      <div className="ed-blob" style={{
        position: 'absolute', left: '-20%', top: '-15%',
        width: '75%', aspectRatio: '1', borderRadius: '50%',
        background: `radial-gradient(circle at 30% 30%, rgba(16,185,129,${0.55 * intensity}), rgba(16,185,129,0) 70%)`,
        filter: 'blur(40px)',
        animation: 'edBlob1 18s ease-in-out infinite',
      }}/>
      <div className="ed-blob" style={{
        position: 'absolute', right: '-25%', top: '20%',
        width: '80%', aspectRatio: '1', borderRadius: '50%',
        background: `radial-gradient(circle at 40% 40%, rgba(20,184,166,${0.45 * intensity}), rgba(20,184,166,0) 70%)`,
        filter: 'blur(40px)',
        animation: 'edBlob2 22s ease-in-out infinite',
      }}/>
      <div className="ed-blob" style={{
        position: 'absolute', left: '10%', bottom: '-20%',
        width: '70%', aspectRatio: '1', borderRadius: '50%',
        background: `radial-gradient(circle at 50% 50%, rgba(139,92,246,${0.38 * intensity}), rgba(139,92,246,0) 70%)`,
        filter: 'blur(40px)',
        animation: 'edBlob3 26s ease-in-out infinite',
      }}/>
    </div>
  );
}
