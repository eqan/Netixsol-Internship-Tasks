function Child() {
  return <div>This is children content</div>;
}

function Parent({ children }) {
  return (
    <div>
      <h3>Parent Component</h3>
      {children}
    </div>
  );
}

function App() {
  return (
    <Parent>
      <Child />
    </Parent>
  );
}

ReactDOM.render(<App />, document.getElementById("root"));