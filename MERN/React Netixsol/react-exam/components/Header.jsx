import React from 'react'
import { Link } from 'react-router-dom'
import styles from '../styles/Header.module.css'

export default function Header() {
    return (
        <nav className={styles.nav}>
            <div className={styles.div}>
                    <li>
                        Website
                    </li>
                    <li>
                        <Link to='/'> Home </Link>
                    </li>
                    <li>
                        <Link to='/about'> About </Link>
                    </li>
                    <li>
                        <Link to='/profile'> Profile </Link>
                    </li>
                    <li>
                        <Link to='/gallery'> Gallery </Link>
                    </li>
                    <li>
                        <Link to='/todo'> ToDo List </Link>
                    </li>
            </div>
        </nav>
    )
  }