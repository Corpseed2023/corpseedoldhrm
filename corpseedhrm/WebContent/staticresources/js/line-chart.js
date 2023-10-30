var totalIncome=[0,0,0,0,0,0,0,0,0,0,0,0];
var spendStatics=[0,0,0,0,0,0,0,0,0,0,0,0];
var netStatics=[0,0,0,0,0,0,0,0,0,0,0,0];
var totalRevenue=0;
var departExpense=0;
	 
$(function() {
    "use strict";
	 	 
// sales_overview_chart

    var ctx4 = document.getElementById('sales_overview_chart').getContext('2d');

    var chart4 = new Chart(ctx4, {
        // The type of chart we want to create
        type: 'line',

        // The data for our dataset
        data: {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun','July','Aug','Sep','Oct','Nov','Dec'],
            datasets: [{
                label: "",
                type: 'line',
                data: [8, 15, 4, 30, 55, 5, 18,8, 15, 4, 30, 55, 5, 18],
                fill: true,
                backgroundColor: 'rgba(50,141,255,.2)',
                borderColor: '#328dff',
                pointBorderColor: '#328dff',
                pointBackgroundColor: '#fff',
                pointBorderWidth: 2,
                borderWidth: 1,
                borderJoinStyle: 'miter',
                //pointHoverRadius: 2,
                pointHoverBackgroundColor: '#328dff',
                pointHoverBorderColor: '#328dff',
                pointHoverBorderWidth: 1,
                pointRadius: 3

            }, /*--{
                label: "Sales Overview 2",
                type: 'line',
                data: [1, 7, 21, 4, 12, 5, 10],
                fill: false,
                borderDash: [5, 5],
                backgroundColor: 'rgba(87,115,238,.3)',
                borderColor: '#5773ee',
                pointBorderColor: '#5773ee',
                pointBackgroundColor: '#5773ee',
                pointBorderWidth: 2,
                borderWidth: 1,
                borderJoinStyle: 'miter',
                pointHoverBackgroundColor: '#5773ee',
                pointHoverBorderColor: '#fff',
                pointHoverBorderWidth: 1,
                pointRadius: 3
            }--*/
			]
        },

        // Configuration options go here
        options: {
            maintainAspectRatio: false,
            legend: {
                display: false
            },

            scales: {
                xAxes: [{
                    display: true,
					drawBorder: false
                }],
                yAxes: [{
                    display: true,
                    gridLines: {
                        zeroLineColor: '#f1f3f5',
                        color: '#f1f3f5',
                        //drawBorder: false
                    }
                }]

            },
            elements: {
                line: {
                    //tension: 0.00001,
                     tension: 0.4,
                    borderWidth: 1
                },
                point: {
                    radius: 2,
                    hitRadius: 10,
                    hoverRadius: 6,
                    borderWidth: 4
                }
            }
        }
    });


	 $.ajax({
		    type: "GET",
		    url: "GetSalesIncomeSpend111",
		    data:  {},
		    success: function (response) {
			if(Object.keys(response).length!=0){
			   var x=response.split("#");
			
			   totalIncome[0]=(Number(x[0]).toFixed(2));
			   totalIncome[1]=(Number(x[1]).toFixed(2));
			   totalIncome[2]=(Number(x[2]).toFixed(2));		
			   totalIncome[3]=(Number(x[3]).toFixed(2));
			   totalIncome[4]=(Number(x[4]).toFixed(2));
			   totalIncome[5]=(Number(x[5]).toFixed(2));				
			   totalIncome[6]=(Number(x[6]).toFixed(2));
			   totalIncome[7]=(Number(x[7]).toFixed(2));
			   totalIncome[8]=(Number(x[8]).toFixed(2));		
			   totalIncome[9]=(Number(x[9]).toFixed(2));
			   totalIncome[10]=(Number(x[10]).toFixed(2));
			   totalIncome[11]=(Number(x[11]).toFixed(2));
			   
			   spendStatics[0]=(Number(x[12]).toFixed(2));
			   spendStatics[1]=(Number(x[13]).toFixed(2));
			   spendStatics[2]=(Number(x[14]).toFixed(2));		
			   spendStatics[3]=(Number(x[15]).toFixed(2));
			   spendStatics[4]=(Number(x[16]).toFixed(2));
			   spendStatics[5]=(Number(x[17]).toFixed(2));				
			   spendStatics[6]=(Number(x[18]).toFixed(2));
			   spendStatics[7]=(Number(x[19]).toFixed(2));
			   spendStatics[8]=(Number(x[20]).toFixed(2));		
			   spendStatics[9]=(Number(x[21]).toFixed(2));
			   spendStatics[10]=(Number(x[22]).toFixed(2));
			   spendStatics[11]=(Number(x[23]).toFixed(2));
			   totalRevenue=Number(x[24]).toFixed(2);
			   departExpense=Number(x[25]).toFixed(2);			   

			   netStatics[0]=(totalIncome[0]-spendStatics[0]);
			   netStatics[1]=(totalIncome[1]-spendStatics[1]);
			   netStatics[2]=(totalIncome[2]-spendStatics[2]);
			   netStatics[3]=(totalIncome[3]-spendStatics[3]);
			   netStatics[4]=(totalIncome[4]-spendStatics[4]);
			   netStatics[5]=(totalIncome[5]-spendStatics[5]);
			   netStatics[6]=(totalIncome[6]-spendStatics[6]);
			   netStatics[7]=(totalIncome[7]-spendStatics[7]);
			   netStatics[8]=(totalIncome[8]-spendStatics[8]);
			   netStatics[9]=(totalIncome[9]-spendStatics[9]);
			   netStatics[10]=(totalIncome[10]-spendStatics[10]);
			   netStatics[11]=(totalIncome[11]-spendStatics[11]);
		    }},
		});	 
	 setTimeout(() => {

var chart = {
		 type: 'column'
	  };
	  var title = {
		 text: 'Total Income vs Spend Statistics'   
	  };
	  var subtitle = {
		 text: ''  
	  };
	  var xAxis = {
		 categories: ['Jan','Feb','Mar','Apr','May','Jun','Jul',
			'Aug','Sep','Oct','Nov','Dec'],
		 crosshair: true
	  };
	  var yAxis = {
		 min: 0,
		 title: {
			text: 'Income'         
		 }      
	  };
	  var tooltip = {
		 headerFormat: '<span style = "font-size:10px">{point.key}</span><table>',
		 pointFormat: '<tr><td style = "color:{series.color};padding:0">{series.name}: </td>' +
			'<td style = "padding:0"><b>{point.y:.1f}</b></td></tr>',
		 footerFormat: '</table>',
		 shared: true,
		 useHTML: true
	  };
	  var plotOptions = {
		 column: {
			pointPadding: 0.2,
			borderWidth: 0
		 }
	  };  
	  var credits = {
		 enabled: false
	  };
	  var series= [
		 {
			name: 'Total Income',
			data: totalIncome
		 }, 
		 {
			name: 'Spend Statistics',
			data: spendStatics
		 }
	  ];     
   
	  var json = {};   
	  json.chart = chart; 
	  json.title = title;   
	  json.subtitle = subtitle; 
	  json.tooltip = tooltip;
	  json.xAxis = xAxis;
	  json.yAxis = yAxis;  
	  json.series = series;
	  json.plotOptions = plotOptions;  
	  json.credits = credits;
	  $('#bar_graph').highcharts(json);

	
var day_data = [
  {"elapsed": "Jan", "Cash In": totalIncome[0], "Cashout": spendStatics[0], "Net": netStatics[0]},
  {"elapsed": "Feb", "Cash In": totalIncome[1], "Cashout": spendStatics[1], "Net": netStatics[1]},
  {"elapsed": "Mar", "Cash In": totalIncome[2], "Cashout": spendStatics[2], "Net": netStatics[2]},
  {"elapsed": "Apr", "Cash In": totalIncome[3], "Cashout": spendStatics[3], "Net": netStatics[3]},
  {"elapsed": "May", "Cash In": totalIncome[4], "Cashout": spendStatics[4], "Net": netStatics[4]},
  {"elapsed": "Jun", "Cash In": totalIncome[5], "Cashout": spendStatics[5], "Net": netStatics[5]},
  {"elapsed": "Jul", "Cash In": totalIncome[6], "Cashout": spendStatics[6], "Net": netStatics[6]},
  {"elapsed": "Aug", "Cash In": totalIncome[7], "Cashout": spendStatics[7], "Net": netStatics[7]},
  {"elapsed": "Sep", "Cash In": totalIncome[8], "Cashout": spendStatics[8], "Net": netStatics[8]},
  {"elapsed": "Oct", "Cash In": totalIncome[9], "Cashout": spendStatics[9], "Net": netStatics[9]},
  {"elapsed": "Nov", "Cash In": totalIncome[10], "Cashout": spendStatics[10], "Net": netStatics[10]},
  {"elapsed": "Dec", "Cash In": totalIncome[11], "Cashout": spendStatics[11], "Net": netStatics[11]}
];
Morris.Line({
  element: 'earning',
  data: day_data,
  xkey: 'elapsed',
  ykeys: ['Cash In', 'Cashout', 'Net'],
  labels: ['Cash In', 'Cashout', 'Net'],
  fillOpacity: 0,
  pointStrokeColors: ['#4ac4f3', '#0d254d', '#48bd44'],
  behaveLikeLine: true,
  gridLineColor: '#e0e0e0',
  lineWidth: 3,
  hideHover: 'auto',
  lineColors: ['#4ac4f3', '#0d254d', '#48bd44'],
  parseTime: false,
  resize: true
});

Morris.Donut({
      element: 'donut',
      data: [
        {value: departExpense, label: 'Department Expense'},
        {value: totalRevenue, label: 'total revenue'},
      ],
      backgroundColor: '#fff',
      labelColor: '#404e67',
      colors: [
        '#4ac4f3',
        '#ff0000',
      ],
      formatter: function (x) { return x + "%"}
    });

var lineChartData = {
        labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun','July','Aug','Sep','Oct','Nov','Dec'],
        datasets: [{
            label: ['Net'],
            data: netStatics,
            backgroundColor: 'rgba(50,141,255,.2)',
            borderColor: '#328dff',
            pointBorderColor: '#328dff',
            pointBackgroundColor: '#fff',
            pointBorderWidth: 2,
            borderWidth: 1,
            borderJoinStyle: 'miter',
            //pointHoverRadius: 2,
            pointHoverBackgroundColor: '#328dff',
            pointHoverBorderColor: '#328dff',
            pointHoverBorderWidth: 1,
            pointRadius: 3
		}]

    }
	chart4.data.datasets = lineChartData.datasets;
	chart4.data.labels = lineChartData.labels;
	chart4.update();	

}, 1000);

});