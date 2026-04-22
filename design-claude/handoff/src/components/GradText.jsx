import React from 'react';

export default function GradText({ children, size = 24, weight = 800, style = {} }) {
  return (
    <span style={{
      fontSize: size, fontWeight: weight, letterSpacing: -0.5,
      backgroundImage: 'var(--ed-primary-grad)',
      WebkitBackgroundClip: 'text',
      backgroundClip: 'text',
      color: 'transparent',
      lineHeight: 1.15,
      ...style,
    }}>{children}</span>
  );
}
