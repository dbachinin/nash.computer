import React from "react"
import PropTypes from "prop-types"
import Select from 'react-select';

class NOForm extends React.Component {
    constructor(props) {
    super(props);
    this.sps = JSON.parse(this.props.sps)
    this.names = []
  }
  render () {
   for (var i = 0; i < this.sps.length; ++i) { this.names.push(this.sps[i].name)}
    console.log(this.names)
    return (
      <React.Fragment>

        <Select
          closeMenuOnSelect={false}
          components={ ClearIndicator }
          
          isMulti
          options={this.sps}
        />
      </React.Fragment>
    );
  }
}
const indicatorSeparatorStyle = {
  alignSelf: 'stretch',
  marginBottom: 8,
  marginTop: 8,
  width: 1,
};
const CustomClearText = () => 'clear all';
const ClearIndicator = (props) => {
  const { children = <CustomClearText/>, getStyles, innerProps: { ref, ...restInnerProps } } = props;
  return (
    <div {...restInnerProps} ref={ref} style={getStyles('clearIndicator', props)}>
      <div style={{ padding: '0px 5px' }}>
        {children}
      </div>
    </div>
  );
};
const IndicatorSeparator = ( innerProps ) => {
  console.log(innerProps)
  return (
    <span {...innerProps}/>
  );
};
export default NOForm
