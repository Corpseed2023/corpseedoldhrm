
// chartjs initialization
var myDoughnutChart12="";
$(function () {
    "use strict";
	// doughnut_chart

//	dynamically setting graph data
var dataValue=[0,0,0];
$.ajax({
    type: "GET",
    url: "GetProjectGraphData111",
    data:  {},
    success: function (response) {
	if(Object.keys(response).length!=0){
	   var x=response.split("#");
		dataValue[0]=x[0];
		dataValue[1]=x[1];
		dataValue[2]=x[2];
		console.log(dataValue);
		$("#DueSaleChart").html(x[0]+"%");
		$("#PartialSaleChart").html(x[1]+"%");
		$("#CompleteSaleChart").html(x[2]+"%");
		loadChart();
    }},
});
function loadChart(){
    var ctx1 = document.getElementById("doughnut_chart");
    var data = {
        labels: [
            "Due", "Partial", "Complete"
        ],
        datasets: [{
            data: dataValue,
            backgroundColor: [
                "#4ac4f3",
                "#0d254d",
                "#48bd44"
            ],
            borderWidth: [
                "0px",
                "0px",
                "0px"
            ],
            borderColor: [
                "#4ac4f3",
                "#0d254d",
                "#48bd44"
            ]
        }]
    };

    var myDoughnutChart11 = new Chart(ctx1, {
        type: 'doughnut',
        data: data,
        options: {
            legend: {
                display: false
            }
        }
    });

}

// var circleChartData = {
//	        labels: ["Due", "Partial", "Complete"],
//	        datasets: [{
//				data: dataValue,
//				borderColor:[
//	                "#4ac4f3",
//	                "#0d254d",
//	                "#48bd44"
//	            ],
//	            backgroundColor: [
//	                "#4ac4f3",
//	                "#0d254d",
//	                "#48bd44"
//	            ],
//				borderWidth: [
//	                "0px",
//	                "0px",
//	                "0px"
//	            ],
//			}]
//
//	    }
//	setTimeout(function(){	
//	myDoughnutChart11.data.datasets = circleChartData.datasets;
//	myDoughnutChart11.data.labels = circleChartData.labels;
//	myDoughnutChart11.update();
//	}, 1000);

var ctx2 = document.getElementById("doughnut_chart1");
    var data = {
        labels: [
            "Unassigned","New","Open", "On-hold",  "Pending", "Complete","Expired"
        ],
        datasets: [{
            data: [10,12,25,58,32,63,20],
            backgroundColor: [
				"#a94442",
				"#337ab7",
                "#4ac4f3",
                "#0d254d",
                "#ff0000",
				"#48bd44",
				"#8a6d3b"
            ],
            borderWidth: [
                "0px",
                "0px",
				"0px",
                "0px",
                "0px",
				"0px",
				"0px"
            ],
            borderColor: [
				"#a94442",
				"#337ab7",
                "#4ac4f3",
                "#0d254d",
                "#ff0000",
				"#48bd44",
				"#8a6d3b"
            ]
        }]
    };

    myDoughnutChart12 = new Chart(ctx2, {
        type: 'doughnut',
        data: data,
        options: {
            legend: {
                display: false
            }
        }
    });
	
	/*var ctx = document.getElementById("doughnut_chart2");
    var data = {
        labels: [
            "Goal", "Total Revenue"
        ],
        datasets: [{
            data: [40, 60],
            backgroundColor: [
                "#4ac4f3",
                "#48bd44"
            ],
            borderWidth: [
                "0px",
                "0px"
            ],
            borderColor: [
                "#4ac4f3",
                "#48bd44"
            ]
        }]
    };

    var myDoughnutChart = new Chart(ctx, {
        type: 'doughnut',
        data: data,
        options: {
            legend: {
                display: false
            }
        }
    });*/


});
var ss=0;
function showTaskStatus(role,uaid,teamKey){
if(uaid!=""&&ss==1){role="NA";}ss=1;
var dataValue1=[0,0,0,0,0,0,0];
$.ajax({
    type: "GET",
    url: "GetMilestoneGraphData111",
    data:  {role:role,uaid:uaid,teamKey:teamKey},
    success: function (response) {
	if(Object.keys(response).length!=0){
	   var x=response.split("#");
		dataValue1[0]=x[0];
		dataValue1[1]=x[1];
		dataValue1[2]=x[2];
		dataValue1[3]=x[3];
		dataValue1[4]=x[4];
		dataValue1[5]=x[5];
		dataValue1[6]=x[6];
		$("#UnassignedTaskChart").html(x[0]);
		$("#NewTaskChart").html(x[1]);
		$("#OpenTaskChart").html(x[2]);
		$("#OnholdTaskChart").html(x[3]);
		$("#PendingTaskChart").html(x[4]);
		$("#CompletedTaskChart").html(x[5]);
		$("#ExpiredTaskChart").html(x[6]);		
    }},
});	
 var circleChartData1 = {
	        labels: ["Unassigned","New","Open", "On-hold",  "Pending", "Complete","Expired"],
	         datasets: [{
            data: dataValue1,
            backgroundColor: [
				"#a94442",
				"#ffa705",
                "#ec2e2e",
                "#514d4daa",
                "#4ac4f3",
				"green",
				"#19283e"
            ],
            borderWidth: [
                "0px",
                "0px",
				"0px",
                "0px",
                "0px",
				"0px",
				"0px"
            ],
            borderColor: [
				"#a94442",
				"#337ab7",
                "#4ac4f3",
                "#0d254d",
                "#ff0000",
				"#48bd44",
				"#8a6d3b"
            ]
        }]

	    }
setTimeout(function(){	
	myDoughnutChart12.data.datasets = circleChartData1.datasets;
	myDoughnutChart12.data.labels = circleChartData1.labels;
	myDoughnutChart12.update();
}, 1000);
}

