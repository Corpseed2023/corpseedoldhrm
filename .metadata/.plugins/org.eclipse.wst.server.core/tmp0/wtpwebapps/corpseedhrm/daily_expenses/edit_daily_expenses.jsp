<%@page import="daily_expenses.Daily_Expenses_ACT"%>
<%@page import="attendance_master.Attendance_ACT"%>
<!DOCTYPE HTML>
<html lang="en-US">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Edit Daily Expenses</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body onload="showHide()">
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%if(!DEX02){%><jsp:forward page="/login.html" /><%} 
String token= (String)session.getAttribute("uavalidtokenno");
String url = request.getParameter("uid");
String[] a=url.split(".html");
String[] b=a[0].split("-");
String custid=b[1];
String[][] getExpensedata=Daily_Expenses_ACT.getallExpensesById(custid,token);
%>
<div id="content">
<div class="container">
<div class="bread-crumb">
<div class="bd-breadcrumb bd-light">
<a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
<a>Edit Daily Expense</a>
</div>
</div>
</div>
<div class="main-content">
<div class="container">
<div class="row">
<div class="col-xs-12">
<div class="menuDv  post-slider">
<form action="<%=request.getContextPath()%>/update-daily-expenses.html" method="post" name="add_expence">
<div class="row">
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>Invoice No. :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-file"></i></span>
<input type="text" name="invoiceno" id="Invoice No" value="<%=getExpensedata[0][12] %>" class="form-control" placeholder="Invoice No.*" onblur="requiredFieldValidation('Invoice No','InvoiceNoerrorMSGdiv');validateUserName('Invoice No','InvoiceNoerrorMSGdiv');validateValue('Invoice No','InvoiceNoerrorMSGdiv');" >
<input type="hidden" name="custid" value="<%=custid%>">
</div>
<div id="InvoiceNoerrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>Amount :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
<input type="text" name="Amount" id="Amount" class="form-control" value="<%=getExpensedata[0][1] %>" placeholder="Amount*" onblur="requiredFieldValidation('Amount','AmounterrorMSGdiv');validateGreater('Amount','AmounterrorMSGdiv');" onkeypress="return isNumberKey(event)">
</div>
<div id="AmounterrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>GST Applicable :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
<select name="gst" id="GST" class="form-control" onblur="requiredFieldValidation('GST','GSTerrorMSGdiv');" onchange="showHide();">
	<option value="<%=getExpensedata[0][19] %>"><%=getExpensedata[0][19] %></option><%if(getExpensedata[0][19].equalsIgnoreCase("yes")){ %>
	<option value="No">No</option><%}else{ %>
	<option value="Yes">Yes</option><%} %>	
</select>
</div>
<div id="GSTerrorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>

<div class="row" id="GST_Box" style="display: none;">
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>GST Category :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-bookmark"></i></span>
<input type="text" name="gstcategory" id="GST Category" value="<%=getExpensedata[0][15] %>" class="form-control" placeholder="GST Category*" onblur="requiredFieldValidation('GST Category','gstcategoryerrorMSGdiv');validateName('GST Category','gstcategoryerrorMSGdiv');" >
</div>
<div id="gstcategoryerrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>GST Tax &nbsp;% :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-user"></i></span>
<input type="text" name="gsttax" id="GST Tax" value="<%=getExpensedata[0][16] %>" class="form-control" placeholder="GST Tax*" onblur="addgst();requiredFieldValidation('GST Tax','gsttaxerrorMSGdiv');" >
</div>
<div id="gsttaxerrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>GST Value :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
<input type="text" name="gstvalue" id="GST Value" value="<%=getExpensedata[0][17] %>" class="form-control" readonly placeholder="GST Value*" onblur="requiredFieldValidation('GST Value','gstvalueerrorMSGdiv');" >
</div>
<div id="gstvalueerrorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>

<div class="row">
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>Place :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-map"></i></span>
<input type="text" name="place" id="Place" value="<%=getExpensedata[0][13] %>" class="form-control" placeholder="Place*" onblur="requiredFieldValidation('Place','PlaceerrorMSGdiv');validateLocation('Place','PlaceerrorMSGdiv');validateValue('Place','PlaceerrorMSGdiv');addgst();" >
</div>
<div id="PlaceerrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>Service Code :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-file"></i></span>
<input type="text" name="servicecode" id="Service Code" value="<%=getExpensedata[0][14] %>" class="form-control" placeholder="Service Code*" onblur="requiredFieldValidation('Service Code','ServiceCodeerrorMSGdiv');validateUserName('Service Code','ServiceCodeerrorMSGdiv');validateValue('Service Code','ServiceCodeerrorMSGdiv');" >
</div>
<div id="ServiceCodeerrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>Paid To :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-user"></i></span>
<input type="text" name="Paid To" id="Paid_To" autocomplete="off" value="<%=getExpensedata[0][2] %>" class="form-control" placeholder="Paid To*" onblur="requiredFieldValidation('Paid_To','PaidToerrorMSGdiv');validateName('Paid_To','PaidToerrorMSGdiv');validateValue('Paid_To','PaidToerrorMSGdiv');" >
</div>
<div id="PaidToerrorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">

<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>Expense Category :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-bars"></i></span>
<input type="text" name="ExpensesCategory" value="<%=getExpensedata[0][3] %>" id="Expenses Category" class="form-control" placeholder="Expenses Category*" onblur="requiredFieldValidation('Expenses Category','ExpensesCategoryerrorMSGdiv');validateName('Expenses Category','ExpensesCategoryerrorMSGdiv');" >
</div>
<div id="ExpensesCategoryerrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>Total Invoice Amount :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
<input type="text" name="totalinvoiceamount" id="Total Invoice Amount" value="<%=getExpensedata[0][18] %>" class="form-control" readonly placeholder="Total Invoice Amount*" onblur="requiredFieldValidation('Total Invoice Amount','totalinvoiceAmounterrorMSGdiv');" >
</div>
<div id="totalinvoiceAmounterrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>Description :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite edit-top1"></i></span>
<textarea name="Description" id="Description" placeholder="Description*" class="form-control" onblur="requiredFieldValidation('Description','DescriptionerrorMSGdiv');validateLocation('Description','DescriptionerrorMSGdiv');"><%=getExpensedata[0][4] %></textarea>
</div>
<div id="DescriptionerrorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>Payment Mode :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
<!-- <input type="text" name="PaymentMode" id="PaymentMode" class="form-control" placeholder="Payment Mode*"  onblur="requiredFieldValidation('Payment Mode','PaymentModeerrorMSGdiv');"> -->
<select name="PaymentMode" id="PaymentMode" class="form-control" onblur="requiredFieldValidation('PaymentMode','PaymentModeerrorMSGdiv');">
	<option value="<%=getExpensedata[0][5] %>"><%=getExpensedata[0][5] %></option><%if(!getExpensedata[0][5].equalsIgnoreCase("NEFT")){ %>
	<option value="NEFT">NEFT</option><%}if(!getExpensedata[0][5].equalsIgnoreCase("IMPS")){  %>
	<option value="IMPS">IMPS</option><%}if(!getExpensedata[0][5].equalsIgnoreCase("Cash")){  %>
	<option value="Cash">Cash</option><%} %>
</select>
</div>
<div id="PaymentModeerrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>Approved By :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-user"></i></span>
<input type="text" name="ApprovedBy" id="ApprovedBy" value="<%=getExpensedata[0][6] %>" class="form-control" placeholder="Approved By*" autocomplete="off" onblur="requiredFieldValidation('ApprovedBy','ApprovedByerrorMSGdiv');validateName('ApprovedBy','ApprovedByerrorMSGdiv');validateValue('ApprovedBy','ApprovedByerrorMSGdiv');">
</div>
<div id="ApprovedByerrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>Date of Payment :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-calendar"></i></span>
<input type="text" name="PaidDate" id="PaidDate" value="<%=getExpensedata[0][7] %>" class="form-control readonlyAllow" placeholder="Paid Date*" onchange="requiredFieldValidation('PaidDate','PaidDateerrorMSGdiv');" onblur="requiredFieldValidation('PaidDate','PaidDateerrorMSGdiv');" readonly>
</div>
<div id="PaidDateerrorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12 item-product-info">
<button onclick="return addprod();" class="bt-link bt-radius bt-loadmore" id="SendMessage" name="SendMessage">Update<i class="fa fa-paper-plane" aria-hidden="true"></i></button>
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
<%@ include file="/staticresources/includes/itswsscripts.jsp" %>
<script>
function showHide(){
	var value=document.getElementById('GST').value;
	if(value=="Yes"){
		$("#GST_Box").slideDown("fast");
// 		document.getElementById('GST Category').value="";
// 		document.getElementById('GST Tax').value="";
// 		document.getElementById('GST Value').value="";
		
	}else{
		$("#GST_Box").slideUp("fast");
		document.getElementById('GST Category').value="NA";
		document.getElementById('GST Tax').value="NA";
		document.getElementById('GST Value').value="NA";
	}
	
}
// GST Category,GST Tax,GST Value,
function addprod() {
if(document.getElementById('Invoice No').value.trim()=="")
{
	InvoiceNoerrorMSGdiv.innerHTML="Invoice No is required.";
	InvoiceNoerrorMSGdiv.style.color="red";
	return false;
}
	
if(document.getElementById('Amount').value.trim()=="")
{
AmounterrorMSGdiv.innerHTML="Amount is required.";
AmounterrorMSGdiv.style.color="red";
return false;
}
if(document.getElementById('GST').value=="Yes"){
	if(document.getElementById('GST Category').value.trim()==""||document.getElementById('GST Category').value.trim()=="NA"){
		gstcategoryerrorMSGdiv.innerHTML="GST category is required.";
		gstcategoryerrorMSGdiv.style.color="red";
		return false;
	}
	if(document.getElementById('GST Tax').value.trim()==""||document.getElementById('GST Tax').value.trim()=="NA"){
		gsttaxerrorMSGdiv.innerHTML="GST Tax is required.";
		gsttaxerrorMSGdiv.style.color="red";
		return false;
	}
	if(document.getElementById('GST Value').value.trim()==""||document.getElementById('GST Value').value.trim()=="NA"){
		gstvalueerrorMSGdiv.innerHTML="GST Value is required.";
		gstvalueerrorMSGdiv.style.color="red";
		return false;
    }
}
if(document.getElementById('Place').value.trim()=="")
{
	PlaceerrorMSGdiv.innerHTML="Place name is required.";
	PlaceerrorMSGdiv.style.color="red";
return false;
}
if(document.getElementById('Service Code').value.trim()=="")
{
	ServiceCodeerrorMSGdiv.innerHTML="Service Code is required.";
	ServiceCodeerrorMSGdiv.style.color="red";
return false;
}
if(document.getElementById('Paid_To').value.trim()=="")
{
PaidToerrorMSGdiv.innerHTML="Paid To is required.";
PaidToerrorMSGdiv.style.color="red";
return false;
}
if(document.getElementById('Expenses Category').value.trim()=="")
{
ExpensesCategoryerrorMSGdiv.innerHTML="Expenses Category is required.";
ExpensesCategoryerrorMSGdiv.style.color="red";
return false;
}
if(document.getElementById('Total Invoice Amount').value.trim()=="")
{
	totalinvoiceAmounterrorMSGdiv.innerHTML="Total Invoice Amount is required.";
	totalinvoiceAmounterrorMSGdiv.style.color="red";
return false;
}
if(document.getElementById('Description').value.trim()=="")
{
DescriptionerrorMSGdiv.innerHTML="Description is required.";
DescriptionerrorMSGdiv.style.color="red";
return false;
}
if(document.getElementById('PaymentMode').value.trim()=="")
{
PaymentModeerrorMSGdiv.innerHTML="Payment Mode is required.";
PaymentModeerrorMSGdiv.style.color="red";
return false;
}
if(document.getElementById('ApprovedBy').value.trim()=="")
{
ApprovedByerrorMSGdiv.innerHTML="Approved By is required.";
ApprovedByerrorMSGdiv.style.color="red";
return false;
}
if(document.getElementById('PaidDate').value.trim()=="")
{
PaidDateerrorMSGdiv.innerHTML="Paid Date is required.";
PaidDateerrorMSGdiv.style.color="red";
return false;
}
// document.add_expence.submit();
}
$( function() {
$( "#PaidDate" ).datepicker({
changeMonth: true,
changeYear: true,
dateFormat: 'dd-mm-yy'
});
} );

function addgst() {
	var invAmt = document.getElementById('Amount').value.trim();
	if(document.getElementById("GST").value=="No"){
		document.getElementById('Total Invoice Amount').value=invAmt;	
	}else{	
	var gstTax = document.getElementById('GST Tax').value.trim();
	var gstAmt = 0;
	if(gstTax != "0"){
		gstAmt=(Number(invAmt)*Number(gstTax))/100;
	}
	var total=Number(invAmt)+gstAmt;
	document.getElementById('GST Value').value=gstAmt;
	document.getElementById('Total Invoice Amount').value=total;
	}
}
</script>
</body>
</html>