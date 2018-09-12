import React from "react"
import PropTypes from "prop-types"
import Select from 'react-select';
import axios from 'axios';
import '../src/NOForm.css'
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
  }

  
  render () {
    return (
<React.Fragment>
<p>ddd</p>
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

//   render () {
//     return (
// <div className="modal fade" id={"modal-" + this.props.id} tabindex="-1" role="dialog" aria-labelledby={this.props.id + "ModalLabel"} aria-hidden="true">
//   <div className="modal-dialog" role="document" style="max-width: 750px;">
//     <div className="modal-content">
//       <div className="modal-header">
//         <h3 className="text-secondary text-uppercase mb-0 modal-title" id={this.props.id + "ModalLabel"} >{"Сборка:" + this.build.name}</h3>
//         <button type="button" className="close" data-dismiss="modal" aria-label="Close">
//           <span aria-hidden="true">&times;</span>
//         </button>
//       </div>
//       <div className="modal-body">
//         <div className="container text-center">
//         <h2 className="text-secondary text-uppercase mb-0">{"В цену" + this.build.price + "рублей"}</h2>

//         </div>
//         <p className="text-center"> входят: </p>
//         <hr />
//         <div className="row">
//          <div className="col-sm-4 border-right">
//           <div className="list-group" id="list-tab" role="tablist">
//           {this.build.filter(function(item){return item}).map((op,i) => {
//             <a className="list-group-item list-group-item-action" id={"list-" + i + "-" + this.props.id + "-list"} data-toggle="list" href={"list-" + i + "-" + this.props.id} role="tab" aria-controls={i + "-" + this.props.id}>
//               {this.options.find(opt => (opt._id === op), this)}
//             </a>
//           })
//           }
//           </div>
//           </div>
//           <div className="col-sm-8">
//            <div className="tab-content" id="nav-tabContent">
//           {this.build.filter(function(item){return item}).map((op,i) => {
//             <div className="tab-pane fade"  id={"list-" + i + "-" + this.props.id} role="tabpanel" aria-labelledby={"list-" + i + "-" + this.props.id + "-list"}>
//               {this.options.find(opt => (opt._id === op), this)}
//             </div>
//           })
//           }
//            </div>
//          </div>
//         </div>
//         <hr />
//           <div className="row">
//             <div className="col-lg-8 mx-auto">
//               <p className="mb-5">{this.build.description}</p>
              
//             </div>
//           </div>
//       </div>
//         <div className="modal-footer bg-noise">
//            <button type="button" style="background: white" className="btn btn-default" data-dismiss="modal">Закрыть</button>

//       </div>
//     </div>
//   </div>
// </div>
//     );
//   }