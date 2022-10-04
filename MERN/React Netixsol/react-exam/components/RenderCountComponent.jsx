import React from 'react'
import { useState } from 'react'

export default function Component1() {
const [count, setCount] = useState(0)
  return (
    <>
        <input placeholder="Enter Input:" onChange={(e) => {setCount(count+1)}}></input> 
        <h1>Count Renders: {count}</h1>
    </>
  )
}
