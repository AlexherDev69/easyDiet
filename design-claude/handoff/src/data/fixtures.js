// Mock data fixtures for EasyDiet
// Replace with real API / store integration in production.

/**
 * @typedef {'Petit-déj'|'Déjeuner'|'Dîner'|'Collation'} MealType
 * @typedef {{type: MealType, color: string, name: string, kcal: number, serv: number, done: boolean}} Meal
 */

export const MEAL_COLORS = {
  breakfast: '#F59E0B',
  lunch:     '#10B981',
  dinner:    '#6366F1',
  snack:     '#EC4899',
};

export const DAYS = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

export const USER = { name: 'Camille' };

export const TODAY = {
  dayIdx: 2,
  calories: 1480,
  target: 1850,
  protein: 78,
  carbs: 142,
  fat: 52,
  water: 1.4,
  waterTarget: 2.0,
};

export const NEXT_MEAL = {
  type: 'Déjeuner',
  name: 'Buddha bowl au quinoa & poulet',
  time: '12h30',
  kcal: 480,
  color: MEAL_COLORS.lunch,
};

export const WEEK_PLAN = [
  { day: 0, meals: [
    { type: 'Petit-déj',  color: MEAL_COLORS.breakfast, name: 'Porridge banane & amandes',     kcal: 340, serv: 1, done: true },
    { type: 'Déjeuner',   color: MEAL_COLORS.lunch,     name: 'Salade niçoise revisitée',      kcal: 520, serv: 1, done: true },
    { type: 'Dîner',      color: MEAL_COLORS.dinner,    name: 'Saumon vapeur, riz basmati',    kcal: 610, serv: 2, done: true },
    { type: 'Collation',  color: MEAL_COLORS.snack,     name: 'Yaourt grec & myrtilles',       kcal: 180, serv: 1, done: true },
  ]},
  { day: 1, meals: [
    { type: 'Petit-déj',  color: MEAL_COLORS.breakfast, name: 'Tartine avocat & œuf poché',    kcal: 380, serv: 1, done: true },
    { type: 'Déjeuner',   color: MEAL_COLORS.lunch,     name: 'Poulet rôti & légumes du Sud',  kcal: 540, serv: 1, done: true },
    { type: 'Dîner',      color: MEAL_COLORS.dinner,    name: 'Risotto aux champignons',       kcal: 580, serv: 2, done: true },
    { type: 'Collation',  color: MEAL_COLORS.snack,     name: 'Poignée d\u2019amandes',           kcal: 150, serv: 1, done: true },
  ]},
  { day: 2, meals: [
    { type: 'Petit-déj',  color: MEAL_COLORS.breakfast, name: 'Smoothie bowl pitaya',          kcal: 320, serv: 1, done: true },
    { type: 'Déjeuner',   color: MEAL_COLORS.lunch,     name: 'Buddha bowl quinoa & poulet',   kcal: 480, serv: 1, done: false },
    { type: 'Dîner',      color: MEAL_COLORS.dinner,    name: 'Ratatouille & polenta crémeuse',kcal: 540, serv: 2, done: false },
    { type: 'Collation',  color: MEAL_COLORS.snack,     name: 'Houmous & crudités',            kcal: 200, serv: 1, done: false },
  ]},
  { day: 3, meals: [
    { type: 'Petit-déj',  color: MEAL_COLORS.breakfast, name: 'Granola maison & fromage blanc', kcal: 360, serv: 1, done: false },
    { type: 'Déjeuner',   color: MEAL_COLORS.lunch,     name: 'Wrap poulet, avocat, roquette',  kcal: 500, serv: 1, done: false },
    { type: 'Dîner',      color: MEAL_COLORS.dinner,    name: 'Cabillaud, purée de patate douce', kcal: 560, serv: 2, done: false },
    { type: 'Collation',  color: MEAL_COLORS.snack,     name: 'Pomme & beurre de cacahuète',    kcal: 190, serv: 1, done: false },
  ]},
  { day: 4, meals: [
    { type: 'Petit-déj',  color: MEAL_COLORS.breakfast, name: 'Pancakes avoine & banane',      kcal: 380, serv: 2, done: false },
    { type: 'Déjeuner',   color: MEAL_COLORS.lunch,     name: 'Taboulé libanais & feta',       kcal: 470, serv: 1, done: false },
    { type: 'Dîner',      color: MEAL_COLORS.dinner,    name: 'Poke bowl saumon mariné',       kcal: 590, serv: 1, done: false },
    { type: 'Collation',  color: MEAL_COLORS.snack,     name: 'Chocolat noir 80%',             kcal: 140, serv: 1, done: false },
  ]},
  { day: 5, meals: [
    { type: 'Petit-déj',  color: MEAL_COLORS.breakfast, name: 'Brioche perdue, miel & figues', kcal: 410, serv: 2, done: false },
    { type: 'Déjeuner',   color: MEAL_COLORS.lunch,     name: 'Croque-monsieur revisité',      kcal: 560, serv: 2, done: false },
    { type: 'Dîner',      color: MEAL_COLORS.dinner,    name: 'Bœuf bourguignon allégé',       kcal: 620, serv: 4, done: false },
    { type: 'Collation',  color: MEAL_COLORS.snack,     name: 'Fruits rouges & mascarpone',    kcal: 210, serv: 1, done: false },
  ]},
  { day: 6, meals: [
    { type: 'Petit-déj',  color: MEAL_COLORS.breakfast, name: 'Œufs brouillés & saumon fumé',  kcal: 390, serv: 1, done: false },
    { type: 'Déjeuner',   color: MEAL_COLORS.lunch,     name: 'Risotto courge & parmesan',     kcal: 530, serv: 2, done: false },
    { type: 'Dîner',      color: MEAL_COLORS.dinner,    name: 'Dahl de lentilles corail',      kcal: 510, serv: 2, done: false },
    { type: 'Collation',  color: MEAL_COLORS.snack,     name: 'Clémentines & noix',            kcal: 170, serv: 1, done: false },
  ]},
];

export const SHOPPING = {
  trips: [
    { name: 'Course 1', sections: [
      { name: 'Produits frais', items: [
        { n: 'Avocats mûrs',       q: '4 pièces',  done: true },
        { n: 'Œufs fermiers bio',  q: '12 pièces', done: true },
        { n: 'Roquette',           q: '200 g',     done: true },
        { n: 'Tomates cerises',    q: '500 g',     done: false },
        { n: 'Citrons jaunes',     q: '3 pièces',  done: false },
        { n: 'Fromage blanc 0%',   q: '1 kg',      done: false },
      ]},
      { name: 'Viandes & poissons', items: [
        { n: 'Filet de poulet fermier', q: '600 g', done: true },
        { n: 'Saumon frais',            q: '400 g', done: false },
        { n: 'Cabillaud',               q: '300 g', done: false },
      ]},
      { name: 'Épicerie', items: [
        { n: 'Quinoa blanc',                  q: '500 g', done: true },
        { n: 'Riz basmati complet',           q: '1 kg',  done: false },
        { n: 'Huile d\u2019olive vierge extra', q: '75 cl', done: false },
        { n: 'Amandes effilées',              q: '250 g', done: false },
        { n: 'Houmous classique',             q: '200 g', done: false },
      ]},
      { name: 'Surgelés', items: [
        { n: 'Épinards hachés', q: '500 g', done: false },
        { n: 'Framboises',      q: '300 g', done: false },
      ]},
      { name: 'Boissons', items: [
        { n: 'Eau pétillante',   q: '6 × 1L',  done: false },
        { n: 'Thé vert matcha',  q: '1 boîte', done: false },
      ]},
    ]},
    { name: 'Course 2', sections: [] },
    { name: 'Course 3', sections: [] },
  ],
};

export const RECIPES = [
  { name: 'Buddha bowl quinoa & poulet',    cat: 'Déjeuner',  color: MEAL_COLORS.lunch,     kcal: 480, prep: 20,  diff: 'Facile' },
  { name: 'Ratatouille & polenta crémeuse', cat: 'Dîner',     color: MEAL_COLORS.dinner,    kcal: 540, prep: 45,  diff: 'Moyen' },
  { name: 'Smoothie bowl pitaya',           cat: 'Petit-déj', color: MEAL_COLORS.breakfast, kcal: 320, prep: 10,  diff: 'Facile' },
  { name: 'Tartine avocat & œuf poché',     cat: 'Petit-déj', color: MEAL_COLORS.breakfast, kcal: 380, prep: 12,  diff: 'Facile' },
  { name: 'Saumon vapeur, riz basmati',     cat: 'Dîner',     color: MEAL_COLORS.dinner,    kcal: 610, prep: 30,  diff: 'Facile' },
  { name: 'Houmous & crudités',             cat: 'Snack',     color: MEAL_COLORS.snack,     kcal: 200, prep: 8,   diff: 'Facile' },
  { name: 'Risotto aux champignons',        cat: 'Dîner',     color: MEAL_COLORS.dinner,    kcal: 580, prep: 40,  diff: 'Moyen' },
  { name: 'Salade niçoise revisitée',       cat: 'Déjeuner',  color: MEAL_COLORS.lunch,     kcal: 520, prep: 25,  diff: 'Facile' },
  { name: 'Bœuf bourguignon allégé',        cat: 'Dîner',     color: MEAL_COLORS.dinner,    kcal: 620, prep: 120, diff: 'Difficile' },
];

export const BUDDHA_BOWL_DETAIL = {
  name: 'Buddha bowl quinoa & poulet',
  desc: 'Un bol équilibré, coloré et rassasiant — parfait pour un déjeuner healthy qui tient tout l\u2019après-midi.',
  kcal: 480, protein: 34, carbs: 48, fat: 14, prep: 20, cook: 15,
  color: MEAL_COLORS.lunch,
  ingredients: [
    { n: 'Quinoa blanc',         q: '80 g' },
    { n: 'Filet de poulet',      q: '120 g' },
    { n: 'Pois chiches cuits',   q: '60 g' },
    { n: 'Avocat',               q: '½' },
    { n: 'Carottes râpées',      q: '50 g' },
    { n: 'Roquette',             q: '30 g' },
    { n: 'Graines de courge',    q: '10 g' },
    { n: 'Sauce tahini citron',  q: '1 c.à.s' },
  ],
  steps: [
    'Rincer le quinoa puis le cuire 12 min dans 1,5× son volume d\u2019eau salée.',
    'Saisir le poulet 4 min par face, assaisonner puis émincer en lamelles.',
    'Dresser le bol : quinoa au centre, entouré de crudités, pois chiches et avocat.',
    'Ajouter le poulet, arroser de sauce tahini et parsemer de graines.',
  ],
};

export const WEIGHT = {
  current: 68.4,
  target: 64.0,
  start: 72.8,
  weeklyPace: -0.35,
  projected: '18 juin',
  history: [
    { d: '2 avr',  v: 72.8 },
    { d: '9 avr',  v: 72.1 },
    { d: '16 avr', v: 71.3 },
    { d: '23 avr', v: 70.6 },
    { d: '30 avr', v: 70.1 },
    { d: '7 mai',  v: 69.4 },
    { d: '14 mai', v: 68.9 },
    { d: '21 mai', v: 68.4 },
  ],
};
