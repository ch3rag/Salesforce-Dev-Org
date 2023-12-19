import { LightningElement, api } from 'lwc';
import ChartJS from "@salesforce/resourceUrl/ChartJs";
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';

export default class WeatherMinMaxAvgGraph extends LightningElement {
    @api weatherData;

    ChartJSInitialized = false;
    chart;

    chartConfiguration = {
        type: 'line',
        data: {
            datasets: [
                {
                    data: [],
                    label: 'Maximum Temperature',
                    lineTension: 0.5,
                    borderColor: 'red',
                    fill: false,
                },
                {
                    data: [],
                    label: 'Minimum Temperature',
                    lineTension: 0.5,
                    fill: false,
                    borderColor: 'blue',
                },
                {
                    data: [],
                    label: 'Average Temperature',
                    lineTension: 0.5,
                    fill: false,
                    borderColor: 'green',
                }
            ],
            labels: []
        },
        options: {
            scales: {
                yAxes: [{
                    ticks: {
                        min: 0,
                    },
                    scaleLabel: {
                        display: true,
                        labelString: 'Temperature'
                    }
                }],
                xAxes: [{
                    type: 'time',
                    scaleLabel: {
                        display: true,
                        labelString: 'Time'
                    },
                    time: {
                        unit: 'day'
                    }
                }]
            },
            legend: {
                display: true
            }
        }
    };

    renderedCallback() {
        if (this.ChartJSInitialized) {
            return;
        }

        this.ChartJSInitialized = true;
        Promise
            .all([
                loadScript(this, ChartJS + '/Chart.min.js'),
                loadScript(this, ChartJS + '/ChartDateAdapter.js'),
                loadStyle(this, ChartJS + '/Chart.min.css')
            ]).then(() => {
                window.Chart.platform.disableCSSInjection = true;
                let canvasElem = document.createElement("canvas");
                this.template.querySelector("div.chart-container").appendChild(canvasElem);
                const context = canvasElem.getContext("2d");
                for (let i = this.weatherData.length - 1; i >= 0; i--) {
                    let data = this.weatherData[i];
                    let dataSetId;
                    switch (data.Data_Type__c) {
                        case 'MAX_TEMPERATURE':
                            dataSetId = 0;
                            break;
                        case 'MIN_TEMPERATURE':
                            dataSetId = 1;
                            break;
                        case 'AVG_TEMPERATURE':
                            dataSetId = 2;
                            break;
                        default:
                            break;
                    }
                    this.chartConfiguration.data.datasets[dataSetId].data.push({
                        x: new Date(data.CreatedDate.split('T')[0]),
                        y: data.Temperature__c
                    });
                }
                this.chart = new window.Chart(context, this.chartConfiguration);
            }).catch((error) => {
                this.error = error;
            });
    }
}
