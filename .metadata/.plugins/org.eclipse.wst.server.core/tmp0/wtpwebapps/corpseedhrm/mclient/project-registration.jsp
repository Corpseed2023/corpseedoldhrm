<!DOCTYPE HTML>
<%@page import="admin.task.TaskMaster_ACT"%>
<%@page import="admin.master.Usermaster_ACT"%>
<%@page import="client_master.Clientmaster_ACT"%>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Project Registration</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%
String token = (String) session.getAttribute("uavalidtokenno");

String initial = Usermaster_ACT.getStartingCode(token,"improjectkey");
String pregpuno=Clientmaster_ACT.getmanifetocode(token);
if (pregpuno==null) {
pregpuno=initial+"1";
}
else {	
	String c=pregpuno.substring(initial.length());	
	int j=Integer.parseInt(c)+1;
	pregpuno=initial+Integer.toString(j);
}
String[][] servicetype=TaskMaster_ACT.getAllServiceType(token); 
%>
<%-- <%if(!CM02){%><jsp:forward page="/login.html" /><%} %> --%>
<div id="content">
<div class="container">
<div class="bread-crumb">
<div class="bd-breadcrumb bd-light">
<a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
<a>Project Registration</a>
</div>
</div>
</div>

<div class="main-content">
<div class="container">
<div class="clearfix text-right mb10">
<a href="<%=request.getContextPath()%>/manage-project.html"><button class="bkbtn">Back</button></a>
</div>
<div class="row">
<div class="col-xs-12">
<div class="menuDv  post-slider">
<form action="<%=request.getContextPath() %>/register-project.html" method="post" id="RegisteruserProject" name="RegisteruserProject">
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Project's No. :<span style="color: #4ac4f3;">*</span></label>
<div class="input-group">
<!--<span class="input-group-addon"><i class="form-icon sprite fa fa-chrome"></i></span>-->
<input type="text" name="ProjectNo" id="Project No" value="<%=pregpuno%>" placeholder="Enter Project No" readonly onblur="requiredFieldValidation('Project No','ProjectNoEerorMSGdiv');" class="form-control">
</div>
<div id="ProjectNoEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Client's Company Name :<span style="color: #4ac4f3;">*</span></label>
<div class="input-group">
<!--<span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>-->
<input type="text" name="clientName" autocomplete="off" id="Client_Name" placeholder="Enter Client Name" onblur="requiredFieldValidation('Client_Name','ClientNameEerorMSGdiv');" class="form-control">
<input type="hidden" readonly name="cid" id="cid">
</div>
<div id="ClientNameEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
                     <div class="form-group">
                      <label>Product Type :<span style="color: #4ac4f3;">*</span></label>
                  <div class="input-group">
                  <!--<span class="input-group-addon"><i class="form-icon sprite checked"></i></span>-->
                  <select id="Service_Type" name="serviceType" class="form-control" onchange="getProducts(this.value)">
                    <option value="">Select Product Type</option>
                    <%for(int i=0;i<servicetype.length;i++){ %>
                        <option value="<%=servicetype[i][1]%>"><%=servicetype[i][1]%></option>
                     <%} %>
					</select>
				</div>
   <div id="serviceTypeErrorMSGdiv" class="errormsg"></div>
  </div>
 </div>  
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Product :<span style="color: #4ac4f3;">*</span></label>
<div class="input-group">
<!--<span class="input-group-addon"><i class="form-icon sprite list"></i></span>-->
<!-- <input type="text" name="ProjectType" autocomplete="off" id="Project_Type" placeholder="Enter Project Type" onblur="requiredFieldValidation('Project_Type','ProjectTypeEerorMSGdiv');" class="form-control"> -->
 <select id="Project_Type" name="ProjectType" class="form-control" onblur="requiredFieldValidation('Project_Type','ProjectTypeEerorMSGdiv');" onchange="getRemarks(this.value);">
          <option value="">Select Product</option> 
</select>
<input type="hidden" readonly name="pid" id="pid">
</div>
<div id="ProjectTypeEerorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Product's Name :<span style="color: #4ac4f3;">*</span></label>
<div class="input-group">
<!--<span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>-->
<input type="text" name="ProjectName" autocomplete="off" id="Project_Name" placeholder="Enter Project Name" onblur="requiredFieldValidation('Project_Name','ProjectNameEerorMSGdiv');" class="form-control">
</div>
<div id="ProjectNameEerorMSGdiv" class="errormsg"></div>
</div>
</div>

<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Starting Date :<span style="color: #4ac4f3;">*</span></label>
<div class="input-group">
<!--<span class="input-group-addon"><i class="form-icon sprite page"></i></span>-->
<input type="text" name="StartingDate" id="Starting-date" placeholder="MM-DD-YYYY" onchange="getDeliveryDate(this.value)" class="form-control readonlyAllow" readonly>
</div>
<div id="StartingDateErrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12" id="Delivery_Date">
<div class="form-group">
<label>Delivery Date/Time :<span style="color: #4ac4f3;">*</span></label>
<div class="input-group">
<!--<span class="input-group-addon"><i class="form-icon sprite page"></i></span>-->
<input type="text" name="DeliveryDate" id="Delivery-date" placeholder="Delivery date and time here !" class="form-control" readonly>
</div>
<div id="DeliveryDateErrorMSGdiv" class="errormsg"></div>
</div>
</div>
 <div class="col-md-3 col-sm-3 col-xs-12" style="margin-top: 27px;">
   <input type="checkbox" style="width: 20px;height: 20px;cursor: pointer;" checked="checked" id="CheckedBox"><span style="margin-top: 4px;position: absolute;font-size: 13px;margin-left: 8px;width: 151px;color: #4ac4f3;">Work Based On Payment</span>
   <input type="hidden" name="paymentbased" id="PaymentBased" value="0"/>
 </div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group">
<label>Project Details and Remarks :<span style="color: #4ac4f3;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<textarea name="Remarks" id="Remarks" onblur="requiredFieldValidation('Remarks','RemarksErrorMSGdiv');" class="form-control"></textarea>
</div>
<div id="RemarksErrorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12 item-product-info">
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return registerProject();" >Submit<i class="fa fa-paper-plane" aria-hidden="true"></i></button>
</div>
</div>
</form>
</div>
</div>
</div>
</div>
</div>
</div>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
function getProducts(servicetype){
	if(servicetype!="")
	$.ajax({
		type : "POST",
		url : "GetServiceType111",
		dataType : "HTML",
		data : {				
			"servicetype":servicetype,
		},
		success : function(data){
			$("#Project_Type").empty();
		    $("#Project_Type").append("<option value=''>"+"Select Product"+"</option>");		    
			var x=data.split("@");			
			for(var i=0;i<x.length;i++){
				$("#Project_Type").append("<option value='"+x[i]+"'>"+x[i]+"</option>");
			}
			$("#Project_Type").append("<option value='Customize'>"+"Customize"+"</option>");
		}
	});else{
		$("#Project_Type").empty();
	    $("#Project_Type").append("<option value=''>"+"Select Product"+"</option>");	   
	}
}
function getRemarks(value){
	if(value!="Customize")
		document.getElementById('Project_Name').value=value;
		else
			document.getElementById('Project_Name').value="";
	
	document.getElementById('Starting-date').value='';
	 document.getElementById('Delivery-date').value='';
	 
	 if(value!="Customize"&&value!=""){	
		 document.getElementById('Delivery_Date').style.display="block";
		$.ajax({
			type : "POST",
			url : "GetRemarks111",
			dataType : "HTML",
			data : {				
				"pname":value,
			},
			success : function(data){
				var x=data.split("#");
				document.getElementById("Remarks").value=x[0];
				document.getElementById('pid').value=x[1];
			}
		});}else {document.getElementById('Delivery_Date').style.display="none";
		document.getElementById('Delivery-date').value="NA";
	 nicEditors.findEditor( "Remarks" ).setContent("");}
}
function getDeliveryDate(date){
	if(document.getElementById("Project_Type").value.trim()==""){
		ProjectTypeEerorMSGdiv.innerHTML="Select Project Type First !!";
		ProjectTypeEerorMSGdiv.style.color="#333";		
		document.getElementById("Starting-date").value="";
	}else{
		ProjectTypeEerorMSGdiv.innerHTML="";
		var pname=document.getElementById("Project_Type").value.trim();		
		if(pname!="Customize")
		$.ajax({
			type : "POST",
			url : "DeliveryDateTime111",
			dataType : "HTML",
			data : {
				"date" : date,
				"pname":pname,
				"btime":"NA"
			},
			success : function(data){
				if(data=="pass"){
				document.getElementById("StartingDateErrorMSGdiv").innerHTML="Set Milestone First.";
				document.getElementById("StartingDateErrorMSGdiv").style.color="#333";				
				}else{
					document.getElementById("Delivery-date").value=data;
				}
				
			}
		});
		
	}
}
</script>
<script type="text/javascript">
$(function(){
	$("#Starting-date").datepicker({
		changeMonth:true,
		changeYear:true,
		dateFormat:'dd-mm-yy'});
	});
	
		//bkLib.onDomLoaded(function(){
			//nicEditors.editors.push(new nicEditor().panelInstance(document.getElementById('Remarks')));});

		function registerProject(){
						
			if(document.getElementById('Client_Name').value.trim()=="" )
			{
				ClientNameEerorMSGdiv.innerHTML="Client Name is required.";
				ClientNameEerorMSGdiv.style.color="#800606";
				return false;
			}  
			if(document.getElementById('Service_Type').value.trim()=="" )
			{
				serviceTypeErrorMSGdiv.innerHTML="Service Type is required.";
				serviceTypeErrorMSGdiv.style.color="#800606";
				return false;
			}
			if(document.getElementById('Project No').value.trim()==""){
				ProjectNoEerorMSGdiv.innerHTML="Project No is required.";
				ProjectNoEerorMSGdiv.style.color="#800606";return false;
				}
			if(document.getElementById('Project_Type').value.trim()==""){
				ProjectTypeEerorMSGdiv.innerHTML="Project Type is required.";
				ProjectTypeEerorMSGdiv.style.color="#800606";return false;
				}
			if(document.getElementById('Project_Name').value.trim()==""){
				ProjectNameEerorMSGdiv.innerHTML="Project Name is required.";
				ProjectNameEerorMSGdiv.style.color="#800606";return false;
				}
			if(document.getElementById('Starting-date').value.trim()==""){
				StartingDateErrorMSGdiv.innerHTML="Starting Date is required.";
				StartingDateErrorMSGdiv.style.color="#800606";
				return false;
				}
			if(document.getElementById('Delivery-date').value.trim()==""){
				DeliveryDateErrorMSGdiv.innerHTML="Delivery Date is required.";
				DeliveryDateErrorMSGdiv.style.color="#800606";
				return false;
				}
			var chk=0;
			if($('#CheckedBox').is(':checked'))chk=1;			
			document.getElementById("PaymentBased").value=chk;
			}
		
		$(function() {
			$("#Client_Name").autocomplete({
				source : function(request, response) {
					if(document.getElementById('Client_Name').value.trim().length>=2)
					$.ajax({
						url : "getclientname.html",
						type : "POST",
						dataType : "JSON",
						data : {
							name : request.term,	
							col : "cregname"
						},
						success : function(data) {
							response($.map(data, function(item) {
								return {  
									label : item.name,
									value : item.value,
									id : item.id,							
								};
							}));
						},      
						error : function(error) {
							alert('error: ' + error.responseText);
						}
					});
				},
				change: function (event, ui) {
		            if(!ui.item){    
		            	ClientNameEerorMSGdiv.innerHTML = 'Select from List';
		            	ClientNameEerorMSGdiv.style.color="#333";
		            	document.getElementById("cid").value = "";
		            	document.getElementById("Client_Name").value = "";    			
		            }
		            else{
		            	document.getElementById("cid").value = ui.item.id;
		            	document.getElementById("Client_Name").value = ui.item.value; 
		            	ClientNameEerorMSGdiv.innerHTML ="";
		            }
		        },
		        error : function(error){
					alert('error: ' + error.responseText);
				},
			});
		});			 ProjectNameEerorMSGdiv
	
// 		$(function() {
// 			$("#Project_Name").autocomplete({
// 				source : function(request, response) {
// 					if(document.getElementById('Project_Name').value.trim().length>=2)
// 					$.ajax({
// 						url : "getproduct.html",
// 						type : "POST",
// 						dataType : "JSON",
// 						data : {
// 							name : request.term,							
// 						},
// 						success : function(data) {
// 							response($.map(data, function(item) {
// 								return {  
// 									label : item.name,
// 									value : item.value,
// 									id : item.id,	
// 									remarks : item.remarks,
// 								};
// 							}));
// 						},      
// 						error : function(error) {
// 							alert('error: ' + error.responseText);
// 						}
// 					});
// 				},
// 				change: function (event, ui) {
// 		            if(!ui.item){    
// 		            	ClientNameEerorMSGdiv.innerHTML = 'Select from List';
// 		            	ClientNameEerorMSGdiv.style.color="#333";
// 		            	document.getElementById("pid").value = "";
// 		            	document.getElementById("Project_Name").value = "";
// 		            	nicEditors.findEditor( "Remarks" ).setContent( "" );	
// 		            }
// 		            else{
// 		            	document.getElementById("pid").value = ui.item.id;
// 		            	document.getElementById("Project_Name").value = ui.item.value; 
// 		            	nicEditors.findEditor( "Remarks" ).setContent( ui.item.remarks );
// 		            	ClientNameEerorMSGdiv.innerHTML ="";
// 		            	document.getElementById("Starting-date").value="";
// 		            }
// 		        },
// 		        error : function(error){
// 					alert('error: ' + error.responseText);
// 				},
// 			});
// 		});			
</script>
</body>
</html>