import React from 'react';
import PropTypes from 'prop-types';
import { withStyles } from '@material-ui/core/styles';
import Slider from '@material-ui/lab/Slider';

const styles = {
  root: {
    width: 300,
    primary: 'white',
    color: 'white',
    secondary: 'white',
    background: 'white',
    track: { background: 'red' },
  },
  
};

class CoresCPU extends React.Component {
  state = {
    cpu: 2,
    mem: 2,
  };

  CPUhandleChange = (event, cpu) => {
    this.setState({ cpu });
  };
  MemHandleChange = (event, mem) => {
    this.setState({ mem });
  };
  render() {
    const { classes } = this.props;
    const { cpu } = this.state;
    const { mem } = this.state;

    return (
      <React.Fragment>
      <h4 className='text-white'>ПОДБОР ПО ОБОРУДОВАНИЮ(Если не знаете, лучше ничего не меняйте)</h4>
      <hr style={{backgroundColor: '#ffffff'}} />
      <div className='row'>
        <h5 className="col-md-4 text-white mr-2">Количество процессоров: <b>{cpu}</b> </h5>
        <div className={classes.root}>
          <Slider value={cpu} min={1} max={8} step={1} onChange={this.CPUhandleChange} />
           <input type="hidden" name='cpu' value={cpu} />
        </div>
        </div>
        <br />
        <div className='row'>
        <h5 className="col-md-4 text-white mr-2">Памяти Гб: <b>{mem}</b></h5>
        <div className={classes.root}>
          <Slider name='mem' value={mem} min={1} max={16} step={1} onChange={this.MemHandleChange} />
          <input type="hidden" name='mem' value={mem} />
        </div>
        </div>
        <br />
      </React.Fragment>
    );
  }
}

CoresCPU.propTypes = {
  classes: PropTypes.object.isRequired,
};

export default withStyles(styles)(CoresCPU);