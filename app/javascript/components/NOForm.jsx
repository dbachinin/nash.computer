import React from "react"
import PropTypes from "prop-types"
class NOForm extends React.Component {
    constructor(props) {
    super(props);
    this.sps = JSON.parse(this.props.sps)
  }
  render () {

    return (
      <React.Fragment>
        <p>Desckr: {this.sps[1].description}</p>
      </React.Fragment>
    );
  }
}

export default NOForm
