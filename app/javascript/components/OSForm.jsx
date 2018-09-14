import React from "react"
import PropTypes from "prop-types"
import Select from 'react-select';
import '../src/NOForm.css'
import axios from 'axios';
class OSForm extends React.Component {
    constructor(props) {
    super(props);
    this.state = {
      price: "",
      order: "",
      value: null
  }
  this.build = JSON.parse(this.props.os_build)
  this.options = JSON.parse(this.props.options)
  this.handleChange = this.handleChange.bind(this);
  this.handleSubmit = this.handleSubmit.bind(this);
  }
  handleSubmit(event) {
    event.preventDefault();
    const data = new FormData(event.target);
    axios({method: 'POST', url: "/users/create_pre_order_ajax", data: data, headers: {'X-CSRF-Token': document.querySelector("meta[name=csrf-token]").content} })
      .then(response =>{this.handleRespond(response)})
      this.setState({ value: null });
   }
  handleChange(newValue) {
    var p_val = newValue.map((val) => ({'value': val.value, 'label': val.label}))
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
    if (this.props.user_id) {var button = <input className="btn btn-warning mt-4" type="submit" value="ОФОРМИТЬ ПРЕДЗАКАЗ" />} else { var button = <button className="btn btn-warning mt-4" data-toggle="modal" data-target="#myModal">ВХОД/РЕГИСТРАЦИЯ</button>}
    var price = "В цену " + (this.build.options.filter(function(item){return item}).map((op,i) => parseInt(this.options.find(opt => (opt._id.$oid === op)).price)).reduce(function(a, b) { return a + b }) + Number(this.build.price)).toString() + " ₽"
    if (price) {var price = 'В сборку'} else {var price = price}
    
    var options = this.build.options.filter(function(item){return item}).map((op,i) => this.options.map((opt) => opt._id.$oid === op ? null : opt._id.$oid).filter(function(e){return e})).reduce((acc, val) => acc.concat(val), [])
    var norOptions = options.filter((a, i, aa) => aa.indexOf(a) === i && aa.lastIndexOf(a) !== i).map((op) => this.options.find(opt => (opt._id.$oid === op)))
    var optionsToSelect = norOptions.map((opt) => ({'value': opt._id.$oid, 'label': opt.name, 'price': opt.price}))
    return (
<React.Fragment>
<div className="modal fade" id={"modal-" + this.props.id} tabIndex="-1" role="dialog" aria-labelledby={this.props.id + "ModalLabel"} aria-hidden="true">
  <div className="modal-dialog" role="document" style={{'maxWidth': '750px'}}>
    <div className="modal-content">
      <div className="modal-header">
        <h3 className="text-secondary text-uppercase mb-0 modal-title" id={this.props.id + "ModalLabel"} >{"Сборка:" + this.build.name}</h3>
        <button type="button" className="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div className="modal-body">
        <div className="container text-center">
        <h2 className="text-secondary text-uppercase mb-0">{price}</h2>

        </div>
        <p className="text-center"> входят: </p>
        <hr />
        <div className="row">
         <div className="col-sm-4 border-right">
          <div className="list-group" id="list-tab" role="tablist">
          {this.build.options.filter(function(item){return item}).map((op,i) => 
            <a className="list-group-item list-group-item-action" id={"list-" + i + "-" + this.props.id + "-list"} key={i} data-toggle="list" href={"#list-" + i + "-" + this.props.id} role="tab" aria-controls={i + "-" + this.props.id}>
              {this.options.find(opt => (opt._id.$oid === op)).name}</a>
            )}
          </div>
          </div>
          <div className="col-sm-8">
           <div className="tab-content" id="nav-tabContent">
          {this.build.options.filter(function(item){return item}).map((op,i) => 
            <div className="tab-pane fade"  key={i} id={"list-" + i + "-" + this.props.id} role="tabpanel" aria-labelledby={"list-" + i + "-" + this.props.id + "-list"} dangerouslySetInnerHTML={{__html:this.options.find(opt => (opt._id.$oid === op)).description + ' ' + 'Цена: ' + (this.options.find(opt => (opt._id.$oid === op)).price ? this.options.find(opt => (opt._id.$oid === op)).price + ' ₽' : 'Бесплатно') }} >
            
            </div>
          )}
           </div>
         </div>
        </div>
        <hr />
          <div className="row">
            <div className="col-lg-8 mx-auto" dangerouslySetInnerHTML={{__html: this.build.description }}>
              
            </div>
          </div>
      </div>
<div className="bg-gradient-primary">
<h4 className="text-white ml-4 mt-2">ДОБАВЛЕНИЕ КОМПОНЕНТОВ</h4>
 <div className='container'>
 <br></br>

 <form onSubmit={this.handleSubmit}>
        <Select
          closeMenuOnSelect={false}
          name="os_options[]"
          onChange={this.handleChange}
          value={this.state.value}
          isMulti
          options={optionsToSelect}
          placeholder="Выберите опцию..."
        />
         {button}
  <input type="hidden" name="os_build" value={this.build._id.$oid} />
 </form>
        </div>
        <br />
        </div>

        <div className="modal-footer bg-noise">
           <button type="button" style={{'background': 'white'}} className="btn btn-default" data-dismiss="modal">Закрыть</button>

      
      </div>
    </div>
  </div>
</div>
</React.Fragment>
    );
  }
}

export default OSForm
