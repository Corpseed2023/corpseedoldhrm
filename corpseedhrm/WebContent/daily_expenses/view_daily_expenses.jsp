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
<body>


<%
String token= (String)session.getAttribute("uavalidtokenno");
String url = request.getParameter("uid");
String[] a=url.split(".html");
String[] b=a[0].split("-");
String custid=b[1];
String[][] getExpensedata=Daily_Expenses_ACT.getallExpensesById(custid,token);
%>
<div id="content">


<div class="container">
<div class="row">
<div class="col-xs-12">
<div class="menuDv  post-slider advert mb10">
<form action="<%=request.getContextPath()%>/update-daily-expenses.html" method="post" name="add_expence">
<div class="row">
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>Invoice No. :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-file"></i></span>
<input type="text" name="invoiceno" id="Invoice No" value="<%=getExpensedata[0][12] %>" class="form-control" placeholder="Invoice No.*" readonly>
</div>
<div id="InvoiceNoerrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>Amount :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
<input type="text" name="Amount" id="Amount" class="form-control" value="<%=getExpensedata[0][1] %>" placeholder="Amount*" readonly>
</div>
<div id="AmounterrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>GST Applicable :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
<select name="gst" id="GST" class="form-control" disabled="disabled">
	<option value="<%=getExpensedata[0][19] %>"><%=getExpensedata[0][19] %></option>	
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
<input type="text" name="gstcategory" id="GST Category" value="<%=getExpensedata[0][15] %>" class="form-control" placeholder="GST Category*" readonly>
</div>
<div id="gstcategoryerrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>GST Tax &nbsp;% :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-user"></i></span>
<input type="text" name="gsttax" id="GST Tax" value="<%=getExpensedata[0][16] %>" class="form-control" placeholder="GST Tax*" readonly>
</div>
<div id="gsttaxerrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>GST Value :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
<input type="text" name="gstvalue" id="GST Value" value="<%=getExpensedata[0][17] %>" class="form-control" readonly placeholder="GST Value*" readonly>
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
<input type="text" name="place" id="Place" value="<%=getExpensedata[0][13] %>" class="form-control" placeholder="Place*" readonly>
</div>
<div id="PlaceerrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>Service Code :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-file"></i></span>
<input type="text" name="servicecode" id="Service Code" value="<%=getExpensedata[0][14] %>" class="form-control" placeholder="Service Code*" readonly>
</div>
<div id="ServiceCodeerrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>Paid To :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-user"></i></span>
<input type="text" name="Paid To" id="Paid_To" autocomplete="off" value="<%=getExpensedata[0][2] %>" class="form-control" placeholder="Paid To*" readonly>
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
<input type="text" name="ExpensesCategory" value="<%=getExpensedata[0][3] %>" id="Expenses Category" class="form-control" placeholder="Expenses Category*" readonly>
</div>
<div id="ExpensesCategoryerrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>Total Invoice Amount :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
<input type="text" name="totalinvoiceamount" id="Total Invoice Amount" value="<%=getExpensedata[0][18] %>" class="form-control" readonly placeholder="Total Invoice Amount*" >
</div>
<div id="totalinvoiceAmounterrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>Description :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite edit-top1"></i></span>
<textarea name="Description" id="Description" placeholder="Description*" class="form-control" readonly><%=getExpensedata[0][4] %></textarea>
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
<select name="PaymentMode" id="PaymentMode" class="form-control" disabled="disabled">
	<option value="<%=getExpensedata[0][5] %>"><%=getExpensedata[0][5] %></option>
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
<input type="text" name="ApprovedBy" id="ApprovedBy" value="<%=getExpensedata[0][6] %>" class="form-control" placeholder="Approved By*" autocomplete="off" readonly>
</div>
<div id="ApprovedByerrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>Date of Payment :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-calendar"></i></span>
<input type="text" name="PaidDate" id="PaidDate" value="<%=getExpensedata[0][7] %>" class="form-control" placeholder="Paid Date*" readonly>
</div>
<div id="PaidDateerrorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
</form>
</div>
</div>
</div>
</div>
</div>

<%@ include file="/staticresources/includes/itswsscripts.jsp" %>
</body>
</html>