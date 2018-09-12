import React from "react"
import PropTypes from "prop-types"
import Select from 'react-select';
import axios from 'axios';
import '../src/NOForm.css'
class NOForm extends React.Component {
    constructor(props) {
    super(props);
    this.state = {
      price: "",
      order: "",
      value: null
  }
    this.sps = JSON.parse(this.props.sps)
    // this.userid = JSON.parse(this.props.user_id)
    this.order = ""
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleChange = this.handleChange.bind(this);
  }

  handleSubmit(event) {
    event.preventDefault();
    const data = new FormData(event.target);
    
    axios({method: 'POST', url: "/users/create_pre_order_ajax", data: data, headers: {'X-CSRF-Token': document.querySelector("meta[name=csrf-token]").content} })
      .then(response =>{this.handleRespond(response)})
      this.setState({ value: null });
   }
   handleChange(newValue: any) {
    const value = newValue === null ? '' : newValue.value
    this.setState({ value });
    if (newValue.length < 1) {
      this.setState({price: ""})
    } else {
      this.setState({price: newValue.map((val) => parseInt(val.price)).reduce(function(a, b) { return a + b })})
    }
        
    };

  handleRespond(resp){
    this.setState({order: resp,price: ""})
    this.order = resp
    eval(this.order.data)
  }
  render () {
    if (this.props.user_id) {var button = <input className="btn btn-warning mt-4" type="submit" value="ОФОРМИТЬ ПРЕДЗАКАЗ" />} else { var button = <button class="btn btn-warning mt-4" data-toggle="modal" data-target="#myModal">ВХОД/РЕГИСТРАЦИЯ</button>}
    return (
      <React.Fragment>
      <div className="container floating-items">
      <div className="tagcloud06">
        <ul>
        {this.sps.map((val,index) => 
        <div className="floating-tag" key={index}><span><li><a className="text-white">{val.name}<span className="bg-dark">{val.price} ₽</span></a></li></span>
          
        </div>
        )}
        </ul>
        </div></div>
      <h5 className="text-white">ЦЕНА КОМПЛЕКТА: <b>{this.state.price}</b> ₽</h5>
      <form onSubmit={this.handleSubmit}>
        <Select
          closeMenuOnSelect={false}
          name="sps[]"
          onChange={this.handleChange}
          value={this.state.value}
          isMulti
          options={this.sps}
          placeholder="Выберите опцию..."

        />
         <input type="hidden" name="user_id" value={this.props.user_id} />
         {button}
         
        </form>
        <hr />
        
        
        
      </React.Fragment>
    );
  }
}

export default NOForm


// import React from "react"
// import PropTypes from "prop-types"
// import Select from 'react-select';

// class NOForm extends React.Component {
//     constructor(props) {
//     super(props);
//     this.sps = JSON.parse(this.props.sps)
//     // this.userid = JSON.parse(this.props.user_id)
//     this.names = []
//   }
//   render () {
//    for (var i = 0; i < this.sps.length; ++i) { this.names.push(this.sps[i].name)}
//     console.log(this.names)
//     return (
//       <React.Fragment>
//       <form action="/users/create_pre_order_get" method="get">
//         <Select
//           closeMenuOnSelect={false}
//           components={ ClearIndicator }
//           name="sps[]"
//           isMulti
//           options={this.sps}
//         />
//          <input type="hidden" name="user_id" value={this.props.user_id} />
//          <input type="submit" value="Принять" />
//         </form>
//       </React.Fragment>
//     );
//   }
// }
// const indicatorSeparatorStyle = {
//   alignSelf: 'stretch',
//   marginBottom: 8,
//   marginTop: 8,
//   width: 1,
// };
// const CustomClearText = () => 'clear all';
// const ClearIndicator = (props) => {
//   const { children = <CustomClearText/>, getStyles, innerProps: { ref, ...restInnerProps } } = props;
//   return (
//     <div {...restInnerProps} ref={ref} style={getStyles('clearIndicator', props)}>
//       <div style={{ padding: '0px 5px' }}>
//         {children}
//       </div>
//     </div>
//   );
// };
// const IndicatorSeparator = ( innerProps ) => {
//   console.log(innerProps)
//   return (
//     <span {...innerProps}/>
//   );
// };
// export default NOForm
