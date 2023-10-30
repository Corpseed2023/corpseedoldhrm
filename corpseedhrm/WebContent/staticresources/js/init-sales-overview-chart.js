
// chartjs initialization
var chart1="";
var chart2 ="";
var chart3 ="";
$(function () {
    "use strict";
	var ctx1 = document.getElementById('sales_overview_chart1').getContext('2d');

    chart1 = new Chart(ctx1, {
        // The type of chart we want to create
        type: 'line',

        // The data for our dataset
        data: {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
            datasets: [{
                label: "Task Created",
                type: 'line',
                data: [8, 15, 4, 30, 55, 5],
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

            }, {
                label: "Task Delivered",
                type: 'line',
                data: [1, 7, 21, 4, 12, 5],
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
            }
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
	
	var ctx2 = document.getElementById('sales_overview_chart2').getContext('2d');

    chart2 = new Chart(ctx2, {
        // The type of chart we want to create
        type: 'line',

        // The data for our dataset
        data: {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
            datasets: [{
                label: "Total Revenue",
                type: 'line',
                data: [8, 15, 4, 30, 55, 5, 18],
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

            }, {
                label: "Estimate Revenue",
                type: 'line',
                data: [5, 11, 7, 21, 32, 5, 10],
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
            }
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

var ctx3 = document.getElementById('sales_overview_chart3').getContext('2d');

   chart3 = new Chart(ctx3, {
        // The type of chart we want to create
        type: 'line',

        // The data for our dataset
        data: {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
            datasets: [{
                label: "Total Revenue",
                type: 'line',
                data: [8, 15, 4, 30, 55, 5, 18],
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

            }, {
                label: "Estimate Revenue",
                type: 'line',
                data: [5, 11, 7, 21, 32, 5, 10],
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
            }
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
	

});

var k1=0;
function getProjectStatus(role,uaid,teamKey){
if(uaid!=""&&k1==1){role="NA";}
var months=[];
var projCreated=[0,0,0,0,0,0];
var projDelivered=[0,0,0,0,0,0];

$.ajax({
    type: "GET",
    url: "GetProjectOverviewData111",
    data:  {role:role,uaid:uaid,teamKey:teamKey},
    success: function (response) {
	if(Object.keys(response).length!=0){
	   var x=response.split("#");

		months.push(x[0]);
		months.push(x[1]);
		months.push(x[2]);
		months.push(x[3]);
		months.push(x[4]);
		months.push(x[5]);
		
		projCreated[0]=x[6];
		projCreated[1]=x[7];
		projCreated[2]=x[8];		
		projCreated[3]=x[9];
		projCreated[4]=x[10];
		projCreated[5]=x[11];
		
		projDelivered[0]=x[12];
		projDelivered[1]=x[13];
		projDelivered[2]=x[14];		
		projDelivered[3]=x[15];
		projDelivered[4]=x[16];
		projDelivered[5]=x[17];		
    }},
});

 var lineChartData = {
        labels: months,
        datasets: [{
            label: ['Project Created'],
            data: projCreated,
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
		},
		{
			label: ['Project Delivered'],
            data: projDelivered,
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
		}]

    }
	setTimeout(function(){
		chart2.data.datasets = lineChartData.datasets;
		chart2.data.labels = lineChartData.labels;
		chart2.update();
		getRevenueReport(role,uaid,teamKey);
		getSalesReport(role,uaid,teamKey);
		mostlySoldProductType(role,uaid,teamKey);
		getTopSales(role,uaid,teamKey);
		recentProject(role,uaid,teamKey);
		recentSalesCommunication(role,uaid,teamKey);
	}, 1000);
	
	k1=1;
}

var k2=0;
function getRevenueReport(role,uaid,teamKey){
if(uaid!=""&&k2==1){role="NA";}
var months=[];
var totalRev=[0,0,0,0,0,0];
var estRev=[0,0,0,0,0,0];

$.ajax({
    type: "GET",
    url: "GetRevenueReportData111",
    data:  {role:role,uaid:uaid,teamKey:teamKey},
    success: function (response) {
	if(Object.keys(response).length!=0){
	   var x=response.split("#");

		months.push(x[0]);
		months.push(x[1]);
		months.push(x[2]);
		months.push(x[3]);
		months.push(x[4]);
		months.push(x[5]);
		
		totalRev[0]=x[6];
		totalRev[1]=x[7];
		totalRev[2]=x[8];		
		totalRev[3]=x[9];
		totalRev[4]=x[10];
		totalRev[5]=x[11];
		
		estRev[0]=x[12];
		estRev[1]=x[13];
		estRev[2]=x[14];		
		estRev[3]=x[15];
		estRev[4]=x[16];
		estRev[5]=x[17];		
    }},
});

 var lineChartData = {
        labels: months,
        datasets: [{
            label: ['Total Revenue'],
            data: totalRev,
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
		},
		{
			label: ['Estimate Revenue'],
            data: estRev,
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
		}]

    }
	setTimeout(function(){
		chart3.data.datasets = lineChartData.datasets;
		chart3.data.labels = lineChartData.labels;
		chart3.update();		
	}, 1000);
	
	k2=1;
}

var k=0;
function getSalesStatus(role,uaid,teamKey){	
if(uaid!=""&&k==1){role="NA";}
var months=[];
var projCreated=[0,0,0,0,0,0];
var projDelivered=[0,0,0,0,0,0];

$.ajax({
    type: "GET",
    url: "GetSalesOverviewData111",
    data:  {role:role,uaid:uaid,teamKey:teamKey},
    success: function (response) {
	if(Object.keys(response).length!=0){
	   var x=response.split("#");

		months.push(x[0]);
		months.push(x[1]);
		months.push(x[2]);
		months.push(x[3]);
		months.push(x[4]);
		months.push(x[5]);
		
		projCreated[0]=x[6];
		projCreated[1]=x[7];
		projCreated[2]=x[8];		
		projCreated[3]=x[9];
		projCreated[4]=x[10];
		projCreated[5]=x[11];
		
		projDelivered[0]=x[12];
		projDelivered[1]=x[13];
		projDelivered[2]=x[14];		
		projDelivered[3]=x[15];
		projDelivered[4]=x[16];
		projDelivered[5]=x[17];		
    }},
});

 var lineChartData = {
        labels: months,
        datasets: [{
            label: ['Task Created'],
            data: projCreated,
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
		},
		{
			label: ['Task Delivered'],
            data: projDelivered,
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
		}]

    }
	setTimeout(function(){
		chart1.data.datasets = lineChartData.datasets;
		chart1.data.labels = lineChartData.labels;
		chart1.update();
		getDeliveryStatics(role,uaid,teamKey);
		showTaskStatus(role,uaid,teamKey);
		upcomingDeadline(role,uaid,teamKey);
		getTaskBehindAhead(role,uaid,teamKey);
		recentActiveTask(role,uaid,teamKey);
		recentCommunication(role,uaid,teamKey);		
	}, 1000);	
	k=1;
}
var p=0;
function getDeliveryStatics(role,uaid,teamKey){	
	if(uaid!=""&&p==1){role="NA";}p=1;
	$.ajax({
    type: "GET",
    url: "GetDeliveryStatics111",
    data:  {role:role,uaid:uaid,teamKey:teamKey},
    success: function (response) {
	if(Object.keys(response).length!=0){
	   var x=response.split("#");
		$("#OnTimeDelivery").html(x[0]+"%");
		$("#DelayedDelivery").html(x[1]+"%");
    }},
});
}
