
import React from 'react';
import { render } from 'react-dom';
// import Chart from './Chart';
import Chart from './Chart2';
import { getData,getData2 } from "./utils"

import { TypeChooser } from "react-stockcharts/lib/helper";

class ChartComponent extends React.Component {
	componentDidMount() {
		getData2().then(data => {
			this.setState({ data })
		})
	}
	render() {
		if (this.state == null) {
			return <div>Loading...</div>
		}
		return (
			<TypeChooser>
				{type => <Chart type={type} data={this.state.data} />}
			</TypeChooser>
		)
	}
}

render(
	<ChartComponent />,
	document.getElementById("root")
);
