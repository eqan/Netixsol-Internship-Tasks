import React, { useEffect, useState } from 'react'

const Effect = () => {
// const [Count,setCount]=useState(0);
const[x,setX]=useState(0);
const[y,setY]=useState(0);
const[check,setCheck]=useState(true);
// useEffect(()=>{
// console.log("hello world")
// }
// ,[Count])

const position = (e) => {
  console.log("Mouse event");
  setX(e.clientX)
  setY(e.clientY)
}


useEffect(()=>{
  console.log("useeffect called");
  window.addEventListener('mousemove',position);

return ()=>{
  console.log("aftereffect called");
  window.removeEventListener('mousemove',position);
  }
  },[x])

  return(<>
{check && <div>Hooks X-{x} Y-{y}</div>}
<button onClick={()=> setCheck(!check)}>click</button>
    </>
    );

//   return (
//     <div>
// <button onClick={()=>setCount((prevCount)=>prevCount+1)}>Click {Count}</button>      
//     </div>
//   )
}

export default Effect
