$(function () {
    "use strict";
var salesExpense=[0,0,0,0,0];
 $.ajax({
	    type: "GET",
	    url: "GetDepartmentExpense111",
	    data:  {},
	    success: function (response) {
		if(Object.keys(response).length!=0){
		   var x=response.split("#");
			salesExpense[0]=x[0];
			salesExpense[1]=x[1];
			salesExpense[2]=x[2];
			salesExpense[3]=x[3];
			salesExpense[4]=x[4];
		   
	    }},
	});
setTimeout(() => {
    var chart = new CanvasJS.Chart("columnchartContainer",
    {
      title:{
        text: "Expenses by Department",    
      },
      axisY: {
        title: "Expenses"
      },
      legend: {
        verticalAlign: "bottom",
        horizontalAlign: "center"
      },
      theme: "theme2",
      data: [

      {        
        type: "column",  
        showInLegend: false, 
        legendMarkerColor: "lightgray",
        legendText: "",
        dataPoints: [      
        {y: Number(salesExpense[0]), label: "Sales"},
        {y: Number(salesExpense[1]),  label: "Marketing" },
        {y: Number(salesExpense[2]),  label: "IT"},
        {y: Number(salesExpense[3]),  label: "HR"},
        {y: Number(salesExpense[4]),  label: "Accounts"},        
        ]
      },   
      ]
    });

    chart.render();
}, 1000);		
});