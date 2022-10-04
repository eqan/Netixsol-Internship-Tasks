function HomePage() {
  // ...
  const [likes, setLikes] = useState()

  function handleClick() {
    setLikes(likes + 1)
  }}

  return (
    <div>
      {/* ... */}
      <button onClick={handleClick}>Likes ({likes})</button>
    </div>
  )
}
