import React, { useState } from 'react';
import {
  Sparkles, User, Ruler, Target, Activity, Leaf, ChevronRight, ChevronLeft,
  Beef, Sprout, AlertTriangle, Check,
} from 'lucide-react';
import Glass from '../components/Glass';
import GradText from '../components/GradText';
import BlobBG from '../components/BlobBG';

type Goal = 'confort' | 'moderate' | 'intensive';
type Diet = 'omni' | 'vege' | 'vegan';
type Activity5 = 0 | 1 | 2 | 3 | 4;

const STEP_COUNT = 6;

const HERO_META: Array<{ Ic: any; tint: string }> = [
  { Ic: Sparkles, tint: '#10B981' },
  { Ic: User,     tint: '#8B5CF6' },
  { Ic: Ruler,    tint: '#0EA5E9' },
  { Ic: Target,   tint: '#F43F5E' },
  { Ic: Activity, tint: '#F59E0B' },
  { Ic: Leaf,     tint: '#10B981' },
];

function HeroIcon({ idx }: { idx: number }) {
  const { Ic, tint } = HERO_META[idx];
  return (
    <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 20 }}>
      <div style={{
        width: 120, height: 120, borderRadius: '50%',
        background: `radial-gradient(circle at 35% 30%, ${tint}, ${tint}88 60%, ${tint}33 100%)`,
        boxShadow: `0 20px 48px ${tint}55, inset 0 2px 4px rgba(255,255,255,0.4)`,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        position: 'relative',
      }}>
        <div style={{
          position: 'absolute', inset: -10, borderRadius: '50%',
          border: `1px solid ${tint}55`, opacity: 0.5,
        }}/>
        <Ic size={52} color="#fff" strokeWidth={2.2}/>
      </div>
    </div>
  );
}

type FieldProps = { label: string; value: string; onChange?: (v: string) => void; placeholder?: string; suffix?: string };
function Field({ label, value, onChange, placeholder, suffix }: FieldProps) {
  return (
    <div>
      <div style={{ fontSize: 10, color: '#64748B', fontWeight: 800, letterSpacing: 1.2, textTransform: 'uppercase', marginBottom: 6 }}>{label}</div>
      <div style={{
        height: 48, padding: '0 14px', borderRadius: 14,
        background: 'rgba(255,255,255,0.7)',
        boxShadow: 'inset 0 0 0 1px var(--ed-glass-border)',
        backdropFilter: 'blur(10px)',
        display: 'flex', alignItems: 'center', gap: 8,
      }}>
        <input
          value={value}
          onChange={e => onChange?.(e.target.value)}
          placeholder={placeholder}
          style={{
            flex: 1, border: 'none', outline: 'none', background: 'transparent',
            fontFamily: 'inherit', fontSize: 14, fontWeight: 700, color: 'var(--ed-text)',
          }}
        />
        {suffix && <div style={{ fontSize: 12, color: '#64748B', fontWeight: 800 }}>{suffix}</div>}
      </div>
    </div>
  );
}

type SliderProps = { label: string; min: number; max: number; value: number; onChange: (v: number) => void; suffix: string };
function Slider({ label, min, max, value, onChange, suffix }: SliderProps) {
  const pct = ((value - min) / (max - min)) * 100;
  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 8 }}>
        <div style={{ fontSize: 10, color: '#64748B', fontWeight: 800, letterSpacing: 1.2, textTransform: 'uppercase' }}>{label}</div>
        <div style={{ fontSize: 18, fontWeight: 800, color: 'var(--ed-text)', letterSpacing: -0.4 }}>
          {value}<span style={{ fontSize: 11, color: '#64748B', fontWeight: 700, marginLeft: 2 }}>{suffix}</span>
        </div>
      </div>
      <div style={{ position: 'relative', height: 8, borderRadius: 4, background: 'rgba(15,23,42,0.06)' }}>
        <div style={{ position: 'absolute', left: 0, top: 0, bottom: 0, width: `${pct}%`, background: 'var(--ed-primary-grad)', borderRadius: 4 }}/>
        <input
          type="range"
          min={min}
          max={max}
          value={value}
          onChange={e => onChange(Number(e.target.value))}
          style={{
            position: 'absolute', inset: -8, width: 'calc(100% + 16px)',
            opacity: 0, cursor: 'pointer',
          }}
        />
        <div style={{
          position: 'absolute', top: '50%', left: `${pct}%`,
          width: 20, height: 20, borderRadius: '50%', background: '#fff',
          transform: 'translate(-50%,-50%)',
          boxShadow: '0 3px 8px rgba(16,185,129,0.4), inset 0 0 0 2px #10B981',
          pointerEvents: 'none',
        }}/>
      </div>
    </div>
  );
}

export default function OnboardingPage({ onDone }: { onDone?: () => void }) {
  const [step, setStep] = useState(0);
  const [name, setName] = useState('Camille');
  const [age, setAge] = useState('32');
  const [sex, setSex] = useState<'f' | 'h'>('f');
  const [height, setHeight] = useState(168);
  const [weight, setWeight] = useState(68);
  const [target, setTarget] = useState(64);
  const [goal, setGoal] = useState<Goal>('moderate');
  const [activity, setActivity] = useState<Activity5>(2);
  const [diet, setDiet] = useState<Diet>('omni');
  const [allergies, setAllergies] = useState<string[]>([]);

  const next = () => (step < STEP_COUNT - 1 ? setStep(step + 1) : onDone?.());
  const prev = () => (step > 0 ? setStep(step - 1) : null);

  const titles = [
    { eyebrow: 'Bienvenue',     title: 'EasyDiet',                     sub: 'Votre compagnon bien-être au quotidien.' },
    { eyebrow: 'Faisons connaissance', title: 'Parlez-nous de vous',    sub: 'Ces infos restent sur votre appareil.' },
    { eyebrow: 'Vos mesures',   title: 'Votre silhouette',              sub: 'Pour adapter vos besoins énergétiques.' },
    { eyebrow: 'Votre objectif', title: 'Quel rythme ?',                sub: 'Choisissez une cadence soutenable.' },
    { eyebrow: 'Votre quotidien', title: 'Mode de vie',                 sub: "Activité et régime alimentaire." },
    { eyebrow: 'Dernière étape', title: 'Allergies & récap',            sub: 'Nous les éviterons dans vos recettes.' },
  ];
  const t = titles[step];

  const allergyList = ['Gluten', 'Lactose', 'Fruits à coque', 'Œufs', 'Soja', 'Crustacés', 'Arachides', 'Poisson'];
  const toggleAllergy = (v: string) =>
    setAllergies(allergies.includes(v) ? allergies.filter(x => x !== v) : [...allergies, v]);

  const activities = [
    { l: 'Sédentaire',       d: 'Peu ou pas d\u2019exercice' },
    { l: 'Légère',           d: '1–3 entraînements / sem.' },
    { l: 'Modérée',          d: '3–5 entraînements / sem.' },
    { l: 'Intense',          d: '6–7 entraînements / sem.' },
    { l: 'Très intense',     d: 'Sport quotidien intense' },
  ] as const;

  return (
    <div style={{ position: 'relative', minHeight: '100%', padding: '0 20px 120px' }}>
      <BlobBG intensity={1}/>
      <div style={{ position: 'relative', zIndex: 2 }}>
        <div style={{ padding: '14px 0 18px', display: 'flex', alignItems: 'center', gap: 10 }}>
          <div style={{ flex: 1, display: 'flex', alignItems: 'center', gap: 6 }}>
            {Array.from({ length: STEP_COUNT }).map((_, i) => {
              const done = i < step;
              const cur = i === step;
              return (
                <div key={i} style={{
                  height: 6, flex: cur ? 2 : 1, borderRadius: 3,
                  background: cur ? 'var(--ed-primary-grad)' : done ? '#10B981' : 'rgba(15,23,42,0.08)',
                  boxShadow: cur ? '0 2px 6px rgba(16,185,129,0.35)' : 'none',
                  transition: 'flex 220ms ease-out',
                }}/>
              );
            })}
          </div>
          {step < STEP_COUNT - 1 && (
            <button onClick={onDone} style={{
              height: 32, padding: '0 12px', borderRadius: 999, border: 'none', cursor: 'pointer',
              background: 'transparent', color: '#64748B', fontSize: 12, fontWeight: 800, letterSpacing: 0.1,
            }}>Passer</button>
          )}
        </div>

        <HeroIcon idx={step}/>

        <div style={{ textAlign: 'center', padding: '0 8px 20px' }}>
          <div style={{ fontSize: 11, color: '#059669', fontWeight: 800, letterSpacing: 1.2, textTransform: 'uppercase' }}>{t.eyebrow}</div>
          <div style={{ marginTop: 4 }}>
            <GradText size={26}>{t.title}</GradText>
          </div>
          <div style={{ fontSize: 13, color: '#475569', fontWeight: 500, marginTop: 8, lineHeight: 1.45 }}>{t.sub}</div>
        </div>

        {/* Step content */}
        {step === 0 && (
          <Glass pad={16} radius={20}>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
              {[
                { Ic: Check, l: 'Plans 100% personnalisés' },
                { Ic: Check, l: 'Liste de courses auto-générée' },
                { Ic: Check, l: 'Suivi du poids avec projection' },
                { Ic: Check, l: 'Fonctionne hors ligne' },
              ].map(x => {
                const Ic = x.Ic;
                return (
                  <div key={x.l} style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                    <div style={{ width: 24, height: 24, borderRadius: '50%', background: 'rgba(16,185,129,0.18)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                      <Ic size={13} color="#059669" strokeWidth={3}/>
                    </div>
                    <div style={{ fontSize: 13, fontWeight: 700, color: 'var(--ed-text)' }}>{x.l}</div>
                  </div>
                );
              })}
            </div>
          </Glass>
        )}

        {step === 1 && (
          <Glass pad={16} radius={20}>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
              <Field label="Prénom" value={name} onChange={setName} placeholder="Votre prénom"/>
              <Field label="Âge" value={age} onChange={setAge} placeholder="32" suffix="ans"/>
              <div>
                <div style={{ fontSize: 10, color: '#64748B', fontWeight: 800, letterSpacing: 1.2, textTransform: 'uppercase', marginBottom: 6 }}>Sexe</div>
                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8 }}>
                  {([{ k: 'f', l: 'Femme' }, { k: 'h', l: 'Homme' }] as const).map(x => {
                    const active = sex === x.k;
                    return (
                      <button key={x.k} onClick={() => setSex(x.k)} style={{
                        height: 44, borderRadius: 12, border: 'none', cursor: 'pointer',
                        background: active ? 'var(--ed-primary-grad)' : 'rgba(255,255,255,0.55)',
                        color: active ? '#fff' : 'var(--ed-text)',
                        boxShadow: active ? '0 6px 14px rgba(16,185,129,0.3)' : 'inset 0 0 0 1px var(--ed-glass-border)',
                        fontSize: 13, fontWeight: 800,
                      }}>{x.l}</button>
                    );
                  })}
                </div>
              </div>
            </div>
          </Glass>
        )}

        {step === 2 && (
          <Glass pad={18} radius={20}>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 22 }}>
              <Slider label="Taille"        min={140} max={210} value={height} onChange={setHeight} suffix="cm"/>
              <Slider label="Poids actuel"  min={40}  max={150} value={weight} onChange={setWeight} suffix="kg"/>
              <Slider label="Poids cible"   min={40}  max={150} value={target} onChange={setTarget} suffix="kg"/>
            </div>
          </Glass>
        )}

        {step === 3 && (
          <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
            {([
              { k: 'confort',   l: 'Confort',    d: '−250 kcal / jour',        pace: '≈ −0.25 kg / sem.', c: '#10B981' },
              { k: 'moderate',  l: 'Modéré',     d: '−500 kcal / jour',        pace: '≈ −0.5 kg / sem.',  c: '#F59E0B' },
              { k: 'intensive', l: 'Intensif',   d: '−750 kcal / jour',        pace: '≈ −0.75 kg / sem.', c: '#F43F5E' },
            ] as const).map(x => {
              const active = goal === x.k;
              return (
                <Glass key={x.k} pad={14} radius={16} onClick={() => setGoal(x.k as Goal)}
                  style={active ? { boxShadow: `inset 0 0 0 2px ${x.c}, 0 10px 22px ${x.c}22` } : {}}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                    <div style={{
                      width: 42, height: 42, borderRadius: 13,
                      background: `${x.c}22`, display: 'flex', alignItems: 'center', justifyContent: 'center',
                    }}>
                      <Target size={18} color={x.c}/>
                    </div>
                    <div style={{ flex: 1 }}>
                      <div style={{ fontSize: 14, fontWeight: 800, color: 'var(--ed-text)' }}>{x.l}</div>
                      <div style={{ fontSize: 11, color: '#64748B', fontWeight: 700, marginTop: 1 }}>{x.d} · {x.pace}</div>
                    </div>
                    <div style={{
                      width: 22, height: 22, borderRadius: '50%',
                      background: active ? x.c : 'transparent',
                      boxShadow: active ? 'none' : 'inset 0 0 0 2px rgba(15,23,42,0.18)',
                      display: 'flex', alignItems: 'center', justifyContent: 'center',
                    }}>
                      {active && <Check size={13} color="#fff" strokeWidth={3.2}/>}
                    </div>
                  </div>
                </Glass>
              );
            })}
          </div>
        )}

        {step === 4 && (
          <>
            <div style={{ fontSize: 11, color: '#64748B', fontWeight: 800, letterSpacing: 1.2, textTransform: 'uppercase', padding: '0 4px 8px' }}>Niveau d'activité</div>
            <Glass pad={10} radius={18} style={{ marginBottom: 14 }}>
              <div style={{ display: 'flex', flexDirection: 'column' }}>
                {activities.map((a, i) => {
                  const active = activity === i;
                  return (
                    <button key={i} onClick={() => setActivity(i as Activity5)} style={{
                      padding: '10px 8px', borderRadius: 12, border: 'none', cursor: 'pointer',
                      background: active ? 'rgba(16,185,129,0.12)' : 'transparent',
                      boxShadow: active ? 'inset 0 0 0 1px rgba(16,185,129,0.4)' : 'none',
                      display: 'flex', alignItems: 'center', gap: 10, textAlign: 'left',
                      marginBottom: i === activities.length - 1 ? 0 : 2,
                    }}>
                      <div style={{
                        width: 8, height: 8, borderRadius: '50%',
                        background: active ? '#10B981' : 'rgba(15,23,42,0.2)',
                      }}/>
                      <div style={{ flex: 1 }}>
                        <div style={{ fontSize: 13, fontWeight: 800, color: 'var(--ed-text)' }}>{a.l}</div>
                        <div style={{ fontSize: 11, color: '#64748B', fontWeight: 600 }}>{a.d}</div>
                      </div>
                    </button>
                  );
                })}
              </div>
            </Glass>

            <div style={{ fontSize: 11, color: '#64748B', fontWeight: 800, letterSpacing: 1.2, textTransform: 'uppercase', padding: '0 4px 8px' }}>Régime alimentaire</div>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3,1fr)', gap: 8 }}>
              {([
                { k: 'omni',  l: 'Omnivore',   Ic: Beef   },
                { k: 'vege',  l: 'Végétarien', Ic: Leaf   },
                { k: 'vegan', l: 'Végan',      Ic: Sprout },
              ] as const).map(x => {
                const active = diet === x.k;
                const Ic = x.Ic;
                return (
                  <button key={x.k} onClick={() => setDiet(x.k)} style={{
                    height: 78, borderRadius: 14, border: 'none', cursor: 'pointer',
                    background: active ? 'var(--ed-primary-grad)' : 'rgba(255,255,255,0.55)',
                    color: active ? '#fff' : 'var(--ed-text)',
                    boxShadow: active ? '0 8px 18px rgba(16,185,129,0.32)' : 'inset 0 0 0 1px var(--ed-glass-border)',
                    display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 4,
                  }}>
                    <Ic size={18} color={active ? '#fff' : '#059669'}/>
                    <div style={{ fontSize: 11, fontWeight: 800 }}>{x.l}</div>
                  </button>
                );
              })}
            </div>
          </>
        )}

        {step === 5 && (
          <>
            <Glass pad={14} radius={18} style={{ marginBottom: 12 }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 10 }}>
                <AlertTriangle size={14} color="#F59E0B"/>
                <div style={{ fontSize: 11, fontWeight: 800, color: 'var(--ed-text)', letterSpacing: 0.2 }}>Sélectionnez vos allergies</div>
              </div>
              <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6 }}>
                {allergyList.map(a => {
                  const active = allergies.includes(a);
                  return (
                    <button key={a} onClick={() => toggleAllergy(a)} style={{
                      height: 32, padding: '0 12px', borderRadius: 999, border: 'none', cursor: 'pointer',
                      background: active ? 'rgba(245,158,11,0.2)' : 'rgba(15,23,42,0.04)',
                      color: active ? '#B45309' : 'var(--ed-muted)',
                      fontSize: 11, fontWeight: 800, letterSpacing: 0.1,
                      boxShadow: active ? 'inset 0 0 0 1px rgba(245,158,11,0.5)' : 'inset 0 0 0 1px rgba(15,23,42,0.06)',
                    }}>{a}</button>
                  );
                })}
              </div>
            </Glass>

            <Glass pad={14} radius={18}>
              <div style={{ fontSize: 11, color: '#059669', fontWeight: 800, letterSpacing: 1.2, textTransform: 'uppercase', marginBottom: 6 }}>Récap de votre plan</div>
              <div style={{ fontSize: 13, fontWeight: 700, color: 'var(--ed-text)', lineHeight: 1.6 }}>
                {name}, {age} ans · {height} cm, {weight} → {target} kg
              </div>
              <div style={{ fontSize: 12, color: '#475569', fontWeight: 600, lineHeight: 1.55, marginTop: 4 }}>
                Objectif {goal === 'confort' ? 'confort' : goal === 'moderate' ? 'modéré' : 'intensif'}, activité {activities[activity].l.toLowerCase()}, régime {diet === 'omni' ? 'omnivore' : diet === 'vege' ? 'végétarien' : 'végan'}.
                {allergies.length > 0 && <><br/>Sans&nbsp;: {allergies.join(', ')}.</>}
              </div>
            </Glass>
          </>
        )}
      </div>

      <div style={{
        position: 'absolute', left: 20, right: 20, bottom: 20, zIndex: 3,
        display: 'flex', gap: 10,
      }}>
        {step > 0 && (
          <button onClick={prev} style={{
            height: 54, padding: '0 20px', borderRadius: 16, border: 'none', cursor: 'pointer',
            background: 'var(--ed-glass-bg)', backdropFilter: 'blur(12px)',
            boxShadow: 'inset 0 0 0 1px var(--ed-glass-border)',
            color: 'var(--ed-text)', fontSize: 14, fontWeight: 800,
            display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 6,
          }}>
            <ChevronLeft size={16} color="#475569"/>
            Précédent
          </button>
        )}
        <button onClick={next} style={{
          flex: 1, height: 54, borderRadius: 16, border: 'none', cursor: 'pointer',
          background: 'var(--ed-primary-grad)',
          boxShadow: '0 12px 28px rgba(16,185,129,0.45), inset 0 1px 0 rgba(255,255,255,0.3)',
          color: '#fff', fontSize: 15, fontWeight: 800, letterSpacing: 0.1,
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 6,
        }}>
          {step === STEP_COUNT - 1 ? 'Créer mon plan' : 'Suivant'}
          <ChevronRight size={16} color="#fff"/>
        </button>
      </div>
    </div>
  );
}
