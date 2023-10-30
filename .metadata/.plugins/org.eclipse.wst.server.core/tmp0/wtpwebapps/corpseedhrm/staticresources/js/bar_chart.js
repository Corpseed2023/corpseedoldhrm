var myHorizontalBar="";
$(function () {
    "use strict";

var MONTHS = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
		var color = Chart.helpers.color;
		var horizontalBarChartData = {
			labels: ['January', 'February', 'March'],
			datasets: [{
				label: 'Behind',
				backgroundColor: color(window.chartColors.red).alpha(0.99).rgbString(),
				borderColor: window.chartColors.red,
				borderWidth: 1,
				data: [
					randomScalingFactor(),
					randomScalingFactor(),
					randomScalingFactor(),
				]
			}, {
				label: 'Ahed',
				backgroundColor: color(window.chartColors.blue).alpha(0.99).rgbString(),
				borderColor: window.chartColors.blue,
				data: [
					randomScalingFactor(),
					randomScalingFactor(),
					randomScalingFactor(),
				]
			},
			{
				label: 'Ontime',
				backgroundColor: color(window.chartColors.green).alpha(0.99).rgbString(),
				borderColor: window.chartColors.green,
				data: [
					randomScalingFactor(),
					randomScalingFactor(),
					randomScalingFactor(),
				]
			}
			]

		};

		window.onload = function() {
			var ctx = document.getElementById('canvas').getContext('2d');
			myHorizontalBar = new Chart(ctx, {
				type: 'horizontalBar',
				data: horizontalBarChartData,
				options: {
					elements: {
						rectangle: {
							borderWidth: 1,
						}
					},
					responsive: true,
					legend: {
						position: 'right',
					},
					title: {
						display: true,
						text: ''
					}
				}
			});

		};
});

function getTaskBehindAhead(role,uaid,teamKey){   
	var monthLbl=[];
	var dataset1=[0,0,0];
	var dataset2=[0,0,0];
	var dataset3=[0,0,0];
	
	$.ajax({
	    type: "GET",
	    url: "GetTaskBehindAheadData111",
	    data:  {role:role,uaid:uaid,teamKey:teamKey},
	    success: function (response) {
		if(Object.keys(response).length!=0){
		   var x=response.split("#");
	
			monthLbl.push(x[0]);
			monthLbl.push(x[1]);
			monthLbl.push(x[2]);
			
			dataset1[0]=x[3];
			dataset1[1]=x[4];
			dataset1[2]=x[5];
			
			dataset2[0]=x[6];
			dataset2[1]=x[7];
			dataset2[2]=x[8];
			
			dataset3[0]=x[9];
			dataset3[1]=x[10];
			dataset3[2]=x[11];
			
	    }},
	});
	
	
//	var MONTHS = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
			var color = Chart.helpers.color;
			var barChartData = {
				labels: monthLbl,
				datasets: [{
					label: 'Behind',
					backgroundColor: color(window.chartColors.red).alpha(0.99).rgbString(),
					borderColor: window.chartColors.red,
					borderWidth: 1,
					data:  dataset1
				}, {
					label: 'Ahed',
					backgroundColor: color(window.chartColors.blue).alpha(0.99).rgbString(),
					borderColor: window.chartColors.blue,
					data:  dataset2
				},
				{
					label: 'Ontime',
					backgroundColor: color(window.chartColors.green).alpha(0.99).rgbString(),
					borderColor: window.chartColors.green,
					data:  dataset3
				}
				]
	
			};
//	console.log(monthLbl);	
//	console.log(dataset1);
//	console.log(dataset2);
//	console.log(dataset3);
	setTimeout(function(){
		myHorizontalBar.data.datasets = barChartData.datasets;
		myHorizontalBar.data.labels = barChartData.labels;
		myHorizontalBar.update();	
	},2000);
}