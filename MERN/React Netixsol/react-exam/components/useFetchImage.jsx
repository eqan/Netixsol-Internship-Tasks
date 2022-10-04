import { useState, useEffect } from "react";

export default function useFetchImage(url)
{
  const [data, setData] = useState(url);

  useEffect(() => {
    fetch(url)
      .then((res) => res.json())
      .then((data) => setData(data));
  }, [setData]);

  return [data, setData];
};