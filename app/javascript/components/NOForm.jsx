import React from "react"
import PropTypes from "prop-types"
import { WithContext as ReactTags } from 'react-tag-input';
import styles from "../src/NOForm.css";
// const { CSSTransitionGroup } = ReactTransitionGroup;
class NOForm extends React.Component {
    constructor(props) {
    super(props);
    this.sps = JSON.parse(this.props.sps)
    this.handleFocus = this.handleFocus.bind(this);
    this.handleChange = this.handleChange.bind(this);
    this.handleKeypress = this.handleKeypress.bind(this);
    this.handleBlur = this.handleBlur.bind(this);
    this.handleClick = this.handleClick.bind(this);

    this.helperspan = null; // is set via ref
    
    this.state = {
      currentcolor: [
        "#531CB3",
        "#7149EE",
        "#B754FF",
        "#ED4FEF",
        "#ED49AB",
        "#ED4FEF",
        "#B754FF",
        "#7149EE"
      ],
      content_add: "add +",
      width: 100,
      myItems: [],
    };
    this.lastId = -1;
  }

  handleFocus(event) {
    this.setState({ content_add: "" });
  }
  
  handleChange(event) {
    const usr_input = event.target.value;
    this.setState({ content_add: usr_input });
  }

  handleKeypress(event) {
    if (event.key == "Enter") {
      var newArray = this.state.myItems;
      var currentcontent = this.state.content_add.trim();
      if (!currentcontent) {
        return; 
      }
      
      var currentWidth = this.helperspan.offsetWidth;
      newArray.push({
        content: currentcontent, 
        id: ++this.lastId, 
        itemWidth: currentWidth + 2
      });
      this.setState({
        myItems: newArray,
        content_add: "",
      });
    }
  }

  handleBlur(event) {
    this.setState({ content_add: "add +" });
  }
  handleClick(event) {
    const idToRemove = Number(event.target.dataset["item"]);
    const newArray = this.state.myItems.filter((listitem) => {return listitem.id !== idToRemove});
    this.setState({ myItems: newArray });
  }
  componentDidUpdate(prevProps, prevState) {
    if (prevState.content_add != this.state.content_add) {
      console.log('did update, content:', this.helperspan.textContent, 'width', this.helperspan.offsetWidth);
      const helperWidth = this.helperspan.offsetWidth;
      this.setState({ width: Math.max(50, helperWidth + 1) });
    }
  }

  makeAddedList() {
    
    const elements =  this.state.myItems.map((listitem, index) => (
      <li
        key={listitem.id}
        onClick={this.handleClick}
        data-item={listitem.id}
        style={{
          backgroundColor: this.state.currentcolor[
            index % this.state.currentcolor.length
          ],
          width: listitem.itemWidth
        }}
      >
        {listitem.content}
      </li>
    ));
    return elements
// const { CSSTransitionGroup } = ReactTransitionGroup;
  }
  render () {

    return (
      <div className="SPForm">
        <label htmlFor="value">
          Dynamic styled Inputfields with React!
        </label>
        <br />
        <br />Hit "Enter" to confirm, Click a pill to remove
        <br />
        <br />
{/*        <CSSTransitionGroup
          transitionName="item-transition"
          transitionEnterTimeout={500}
          transitionLeaveTimeout={210}
        >
                  {this.makeAddedList()}
        </CSSTransitionGroup>*/}
      <input
          id="add"
          type="text"
          name="initvalue"
          autoComplete="off"
          maxLength="70"
          onFocus={this.handleFocus}
          onChange={this.handleChange}
          onKeyPress={this.handleKeypress}
          onBlur={this.handleBlur}
          value={this.state.content_add}
          style={{ width: this.state.width }}
        />
        <span id="helperspan" ref={el => (this.helperspan = el)}>
          {this.state.content_add}
        </span>
      </div>
    );
  }
}

export default NOForm
