import { LightningElement, api } from 'lwc';
import ChartJS from "@salesforce/resourceUrl/ChartJs";
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';

export default class WeatherChart extends LightningElement {
    @api weatherData;

    ChartJSInitialized = false;
    chart;

    chartConfiguration = {
        type: 'line',
        data: {
            datasets: [
                {
                    data: [],
                    label: 'Temperature',
                    lineTension: 0.5,
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
                    }
                }]
            },
            legend: {
                display: false
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
                    this.chartConfiguration.data.datasets[0].data.push({
                        x: this.weatherData[i].CreatedDate,
                        y: this.weatherData[i].Temperature__c
                    });
                }

                this.chart = new window.Chart(context, this.chartConfiguration);
            }).catch((error) => {
                this.error = error;
            });
    }
}
