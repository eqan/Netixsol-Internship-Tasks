import { useState, useEffect } from "react";

export default function RandomGallery() {
  const url = "https://dog.ceo/api/breeds/image/random";
  const [imageArray, setImageArray] = useState([]);
  const [data, setData] = useState();
  async function fetchImage() {
    const resp = await fetch(url);
    const data = await resp.json();
    return data.message;
  }

  useEffect(() => {
    fetch(url)
      .then((res) => res.json())
      .then((data) => setData(data.message));
  }, []);
  async function addToLeft() {
    const src = await fetchImage();
    setImageArray([...imageArray, { src: src, type: "Right" }]);
  }
  async function addToRight() {
    const src = await fetchImage();
    console.log(src, "right");
    setImageArray([...imageArray, { src: src, type: "Left" }]);
  }
  console.log(imageArray, "array");
  
  return (
    <>
      <img src={data} alt="img" width="400" height="400" />
      <button onClick={addToLeft}>Add Left</button>
      <button onClick={addToRight}>Add Right</button>
      <div>
        <h1>Left Images</h1>
        {imageArray.map(({ src, type },i) => {
          if (type === "Left")
            return <img src={src} key={i} alt="img" width="400" height="400" />;
          else return null;
        })}
        <h1>Right Images</h1>
        {imageArray.map(({ src, type },i) => {
          if (type === "Right")
            return <img src={src} key={i} alt="img" width="400" height="400" />;
          else return null;
        })}
      </div>
    </>
  );
}