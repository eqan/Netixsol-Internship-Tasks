class Message extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      visible: 0
    };
  }

  clickHandler = e => {
    e.preventDefault();
    this.setState({
      visible: !this.state.visible
    });
  };

  render() {
    return (
      <React.Fragment>
        <a href="#" onClick={this.clickHandler}>
          Want to buy a new car?
        </a>
        {this.state.visible && <p>Call +11 22 33 44 now!</p>}
      </React.Fragment>
    );
  }
}

document.body.innerHTML = "<div id='root'> </div>";

const rootElement = document.getElementById("root");
ReactDOM.render(<Message />, rootElement);