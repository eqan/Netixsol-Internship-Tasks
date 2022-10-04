import React, { useState } from 'react'
import { BrowserRouter, Routes, Route, Link } from "react-router-dom";
import Home from '../pages/Home';
import About from '../pages/About';
import Profile from '../pages/Profile';
import Gallery from '../pages/Gallery';
import Todo from '../pages/Todo';
import Header from '../components/Header';
import Footer from '../components/Footer'
import NoPage from '../pages/NoPage';

import './App.css'

function App() {

  return (
    <div className="App">
    <BrowserRouter>
    <Header/>
      <Routes>
          <Route index element={<Home />} />
          <Route path="/about" element={<About />} />
          <Route path="/profile" element={<Profile />} />
          <Route path="/gallery" element={<Gallery />} />
          <Route path="/todo" element={<Todo />} />
          <Route path="*" element={<NoPage />} />
      </Routes>
      <Footer/>
    </BrowserRouter>
    </div>
  )
}

export default App
