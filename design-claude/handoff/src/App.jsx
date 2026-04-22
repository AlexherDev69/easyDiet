import React, { useState } from 'react';
import BlobBG from './components/BlobBG.jsx';
import TabBar from './components/TabBar.jsx';
import Dashboard from './screens/Dashboard.jsx';
import MealPlan from './screens/MealPlan.jsx';
import Shopping from './screens/Shopping.jsx';
import RecipesList from './screens/RecipesList.jsx';
import RecipeDetail from './screens/RecipeDetail.jsx';
import Weight from './screens/Weight.jsx';
import { WEEK_PLAN, SHOPPING } from './data/fixtures.js';

export default function App() {
  const [tab, setTab] = useState('home');
  const [detail, setDetail] = useState(false);
  const [plan, setPlan] = useState(WEEK_PLAN);
  const [shopping, setShopping] = useState(SHOPPING);

  let content;
  if (detail && tab === 'recipes') content = <RecipeDetail onBack={() => setDetail(false)}/>;
  else if (tab === 'home')     content = <Dashboard onNav={k => setTab(k)}/>;
  else if (tab === 'meals')    content = <MealPlan plan={plan} setPlan={setPlan}/>;
  else if (tab === 'shopping') content = <Shopping shopping={shopping} setShopping={setShopping}/>;
  else if (tab === 'recipes')  content = <RecipesList onOpen={() => setDetail(true)}/>;
  else if (tab === 'weight')   content = <Weight/>;

  const handleTab = (k) => {
    setDetail(false);
    setTab(k);
  };

  return (
    <div style={{
      position: 'relative', width: '100%', minHeight: '100vh',
      maxWidth: 430, margin: '0 auto',
      overflow: 'hidden',
    }}>
      <BlobBG intensity={1}/>
      <div style={{ position: 'relative', zIndex: 2, paddingTop: 8 }}>
        {content}
      </div>
      {!detail && <TabBar tab={tab} setTab={handleTab}/>}
    </div>
  );
}
