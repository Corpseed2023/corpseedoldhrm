<!DOCTYPE HTML>
<%@page import="commons.DateUtil"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="company_master.CompanyMaster_ACT"%>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Company Registration</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%
String today =DateUtil.getCurrentDateIndianFormat1();

String addedby= (String)session.getAttribute("loginuID");
String compuid=CompanyMaster_ACT.getuniquecode();
if (compuid==null) {
compuid="CM171";
}
else {
int j=Integer.parseInt(compuid)+1;
compuid="CM"+Integer.toString(j);
}%>
<%if(!RC00){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
<div class="container">
<div class="bread-crumb">
<div class="bd-breadcrumb bd-light">
<a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
<a>Company Registeration</a>
</div>
<a href="<%=request.getContextPath()%>/manage-company.html"><button class="bkbtn" style="margin-left: 795px;">Back</button></a>
</div>
</div>
<div class="main-content">
<div class="container">
<div class="row">
<div class="col-xs-12">
<div class="menuDv  post-slider">
<form action="register-new-company.html" method="post" name="registeruserClient" id="registeruserClient">
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<input type="hidden" name="addedbyuser" value="<%=addedby%>">
<label>Company ID :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
<input type="text" name="CompanyID" id="Company ID"value="<%=compuid%>" readonly class="form-control">
</div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Company Name :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
<input type="text" name="CompanyName" id="Company Name" placeholder="Company Name here !" onblur="requiredFieldValidation('Company Name','CompanyNameEerorMSGdiv');validateCompanyName('Company Name','CompanyNameEerorMSGdiv');validateValue('Company Name','CompanyNameEerorMSGdiv');isExistName('Company Name','CompanyNameEerorMSGdiv');" class="form-control">
</div>
<div id="CompanyNameEerorMSGdiv" class="error_text"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Mobile No. :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
<input type="text" name="mobile" id="Mobile" placeholder="Mobile No. here !" onblur="requiredFieldValidation('Mobile','mobileEerorMSGdiv');validateMobileno('Mobile','mobileEerorMSGdiv');isExistValue('Mobile','mobileEerorMSGdiv');" maxlength="10" class="form-control" onkeypress="return isNumber(event)">
</div>
<div id="mobileEerorMSGdiv" class="error_text"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Email Id :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
<input type="text" name="email" id="Email" placeholder="Email Id here !" onblur="requiredFieldValidation('Email','emailEerorMSGdiv');verifyEmailId('Email','emailEerorMSGdiv');isExistValue('Email','emailEerorMSGdiv');" class="form-control">
</div>
<div id="emailEerorMSGdiv" class="error_text"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Company's Address :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite info"></i></span>
<input type="text" name="CompanyAddress" id="Address" placeholder="Company Address here !" onblur="requiredFieldValidation('Address','CompanyAddressEerorMSGdiv');validateLocation('Address','CompanyAddressEerorMSGdiv');validateValue('Address','CompanyAddressEerorMSGdiv');" class="form-control">
</div>
<div id="CompanyAddressEerorMSGdiv" class="error_text"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>PAN :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="PAN" id="PAN" placeholder="PAN No. here !" onblur="requiredFieldValidation('PAN','PANEerorMSGdiv');validateUserName('PAN','PANEerorMSGdiv');validateValue('PAN','PANEerorMSGdiv');isExistValue('PAN','PANEerorMSGdiv');" maxlength="10" class="form-control">
</div>
<div id="PANEerorMSGdiv" class="error_text"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>GSTIN :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="GSTIN" id="GSTIN" placeholder="GSTIN No. here !" onblur="requiredFieldValidation('GSTIN','GSTINEerorMSGdiv');validateUserName('GSTIN','GSTINEerorMSGdiv'); validateValue('GSTIN','GSTINEerorMSGdiv');isExistValue('GSTIN','GSTINEerorMSGdiv');" class="form-control">
</div>
<div id="GSTINEerorMSGdiv" class="error_text"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>State Code :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="statecode" id="State Code" placeholder="State Code here !" onblur="requiredFieldValidation('State Code','StateCodeEerorMSGdiv');validateUserName('State Code','StateCodeEerorMSGdiv');validateValue('State Code','StateCodeEerorMSGdiv');" class="form-control">
</div>
<div id="StateCodeEerorMSGdiv" class="error_text"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Bank Name :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="BankName" id="Bank Name" placeholder="Bank Name here !" onblur="requiredFieldValidation('Bank Name','BankNameEerorMSGdiv');validateName('Bank Name','BankNameEerorMSGdiv');validateValue('Bank Name','BankNameEerorMSGdiv');" class="form-control">
</div>
<div id="BankNameEerorMSGdiv" class="error_text"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Account Holder's Name :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="AccountName" id="Account Name" placeholder="Account Name here !" onblur="requiredFieldValidation('Account Name','AccountNameEerorMSGdiv');validateName('Account Name','AccountNameEerorMSGdiv');validateValue('Account Name','AccountNameEerorMSGdiv');" class="form-control">
</div>
<div id="AccountNameEerorMSGdiv" class="error_text"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>A/C No :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="BankACNo" id="Bank AC No" placeholder="Bank Account Number here !" onkeypress="return isNumber(event)" onblur="requiredFieldValidation('Bank AC No','BankACNoEerorMSGdiv');validateValue('Bank AC No','BankACNoEerorMSGdiv');isExistValue('Bank AC No','BankACNoEerorMSGdiv');" class="form-control">
</div>
<div id="BankACNoEerorMSGdiv" class="error_text"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>IFSC Code :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="BankIFSCCode" id="Bank IFSC Code" placeholder="Bank IFSC Code here !" onblur="requiredFieldValidation('Bank IFSC Code','BankIFSCCodeEerorMSGdiv');validateUserName('Bank IFSC Code','BankIFSCCodeEerorMSGdiv');validateValue('Bank IFSC Code','BankIFSCCodeEerorMSGdiv');" class="form-control">
</div>
<div id="BankIFSCCodeEerorMSGdiv" class="error_text"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group">
<label>Bank's Address :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="BankAddress" id="Bank Address" placeholder="Bank Address here !" onblur="requiredFieldValidation('Bank Address','BankAddressEerorMSGdiv');validateLocation('Bank Address','BankAddressEerorMSGdiv');validateValue('Bank Address','BankAddressEerorMSGdiv');" class="form-control">
</div>
<div id="BankAddressEerorMSGdiv" class="error_text"></div>
</div>
</div>
</div>

<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group text-center">
<h3><strong>Fill Initial Codes of Table <span style="color: red;">*</span></strong></h3>
<span style="font-size: 12px;color: red;">(Max 5 Characters you can enter here,like you entered 'abcd' then your key will be abcd1,abcd2....)</span>
<hr>
</div>
</div>
</div>

<div class="row">
<input type="hidden" name="today" id="today" value="<%=today %>" class="form-control">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Employee Key :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" onkeyup="javascript:{this.value = this.value.toUpperCase();}" name="employeekey" maxlength="5" id="Employee_Key" placeholder="Employee's Key here !" onblur="requiredFieldValidation('Employee_Key','gemployeekeyEerorMSGdiv');validateKey('Employee_Key','gemployeekeyEerorMSGdiv');validateValue('Employee_Key','gemployeekeyEerorMSGdiv');" class="form-control">
</div>
<div id="gemployeekeyEerorMSGdiv" class="error_text"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Estimate Key :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" onkeyup="javascript:{this.value = this.value.toUpperCase();}" name="enquirykey" maxlength="5" id="Sales_Key" placeholder="Estimate Key here !" onblur="requiredFieldValidation('Sales_Key','saleskeyEerorMSGdiv');validateKey('Sales_Key','saleskeyEerorMSGdiv');validateValue('Sales_Key','saleskeyEerorMSGdiv');" class="form-control">
</div>
<div id="saleskeyEerorMSGdiv" class="error_text"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Client's Key :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" onkeyup="javascript:{this.value = this.value.toUpperCase();}" name="clientkey" maxlength="5" id="Client_Key" placeholder="Client's key here !" onblur="requiredFieldValidation('Client_Key','clientkeyEerorMSGdiv');validateKey('Client_Key','clientkeyEerorMSGdiv');validateValue('Client_Key','clientkeyEerorMSGdiv');" class="form-control">
</div>
<div id="clientkeyEerorMSGdiv" class="error_text"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Project's Key :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" onkeyup="javascript:{this.value = this.value.toUpperCase();}" name="projectkey" maxlength="5" id="Project_Key" placeholder="Project's Key here !" onblur="requiredFieldValidation('Project_Key','projectkeyEerorMSGdiv');validateKey('Project Key','projectkeyEerorMSGdiv');validateValue('Project Key','projectkeyEerorMSGdiv');" class="form-control">
</div>
<div id="projectkeyEerorMSGdiv" class="error_text"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Task's Key :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" onkeyup="javascript:{this.value = this.value.toUpperCase();}" name="taskkey" maxlength="5" id="Task_Key" placeholder="Task key here !" onblur="requiredFieldValidation('Task_Key','taskkeyEerorMSGdiv');validateKey('Task_Key','taskkeyEerorMSGdiv');validateValue('Task_Key','taskkeyEerorMSGdiv');" class="form-control">
</div>
<div id="taskkeyEerorMSGdiv" class="error_text"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Unbilled Key :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" onkeyup="javascript:{this.value = this.value.toUpperCase();}" name="unbilledkey" maxlength="5" id="Unbilled_Key" placeholder="Unbilled Key here !" onblur="requiredFieldValidation('Unbilled_Key','unbillingkeyEerorMSGdiv');validateKey('Unbilled_Key','unbillingkeyEerorMSGdiv');validateValue('Unbilled_Key','unbillingkeyEerorMSGdiv');" class="form-control">
</div>
<div id="billingkeyEerorMSGdiv" class="error_text"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Invoice Key :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" onkeyup="javascript:{this.value = this.value.toUpperCase();}" name="invoicekey" maxlength="5" id="Invoice_Key" placeholder="Invoice Key here !" onblur="requiredFieldValidation('Invoice_Key','invoicekeyEerorMSGdiv');validateKey('Invoice_Key','invoicekeyEerorMSGdiv');validateValue('Invoice_Key','invoicekeyEerorMSGdiv');" class="form-control">
</div>
<div id="invoicekeyEerorMSGdiv" class="error_text"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Estimate billing Key :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" onkeyup="javascript:{this.value = this.value.toUpperCase();}" name="estimatebillkey" maxlength="5" id="Estimate_Billing_Key" placeholder="Estimate Billing Key here !" onblur="requiredFieldValidation('Estimate_Billing_Key','estimatebillingkeyEerorMSGdiv');validateKey('Billing_Key','estimatebillingkeyEerorMSGdiv');validateValue('Billing_Key','estimatebillingkeyEerorMSGdiv');" class="form-control">
</div>
<div id="estimatebillingkeyEerorMSGdiv" class="error_text"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Product's Key :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" onkeyup="javascript:{this.value = this.value.toUpperCase();}" name="productskey" maxlength="5" id="Products_Key" placeholder="Product's Key here !" onblur="requiredFieldValidation('Products_Key','productskeyEerorMSGdiv');validateKey('Products_Key','productskeyEerorMSGdiv');validateValue('Products_Key','productskeyEerorMSGdiv');" class="form-control">
</div>
<div id="productskeyEerorMSGdiv" class="error_text"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Expense's Key :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" onkeyup="javascript:{this.value = this.value.toUpperCase();}" name="expensekey" maxlength="5" id="Expense_Key" placeholder="Expense's Key here !" onblur="requiredFieldValidation('Expense_Key','Expense_KeyEerorMSGdiv');validateKey('Expense_Key','Expense_KeykeyEerorMSGdiv');validateValue('Expense_Key','Expense_KeykeyEerorMSGdiv');" class="form-control">
</div>
<div id="Expense_KeyEerorMSGdiv" class="error_text"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Transfer's Key :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" onkeyup="javascript:{this.value = this.value.toUpperCase();}" name="transferkey" maxlength="5" id="Transfer_Key" placeholder="Transfer's Key here !" onblur="requiredFieldValidation('Transfer_Key','Transfer_KeyEerorMSGdiv');validateKey('Transfer_Key','Transfer_KeyEerorMSGdiv');validateValue('Transfer_Key','Transfer_KeyEerorMSGdiv');" class="form-control">
</div>
<div id="Transfer_KeyEerorMSGdiv" class="error_text"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Trigger's Key :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" onkeyup="javascript:{this.value = this.value.toUpperCase();}" name="triggerkey" maxlength="5" id="Trigger_Key" placeholder="Trigger's Key here !" onblur="requiredFieldValidation('Trigger_Key','Trigger_KeyEerorMSGdiv');validateKey('Trigger_Key','Trigger_KeyEerorMSGdiv');validateValue('Trigger_Key','Trigger_KeyEerorMSGdiv');" class="form-control">
</div>
<div id="Trigger_KeyEerorMSGdiv" class="error_text"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12 item-product-info">
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return registerCompany()">Register<i class="fa fa-paper-plane" aria-hidden="true"></i></button>
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
function registerCompany() {
if(document.getElementById('Company Name').value.trim()=="" ) {
CompanyNameEerorMSGdiv.innerHTML="Company Name is required.";
CompanyNameEerorMSGdiv.style.color="red";
return false;
}
if(document.getElementById('Mobile').value.trim()=="" ) {
	CompanyNameEerorMSGdiv.innerHTML="Company's Mobile No. is required.";
	CompanyNameEerorMSGdiv.style.color="red";
	return false;
	}
	if(document.getElementById('Email').value.trim()=="" ) {
		CompanyNameEerorMSGdiv.innerHTML="Company's Email Id is required.";
		CompanyNameEerorMSGdiv.style.color="red";
		return false;
		}
if(document.getElementById('Address').value.trim()==""){
CompanyAddressEerorMSGdiv.innerHTML="Company's Address is required.";
CompanyAddressEerorMSGdiv.style.color="red";
return false;
}
if(document.getElementById('PAN').value.trim()=="" ) {
PANEerorMSGdiv.innerHTML="PAN is required.";
PANEerorMSGdiv.style.color="red";
return false;
}
if(document.getElementById('GSTIN').value.trim()=="" ) {
GSTINEerorMSGdiv.innerHTML="GSTIN is required.";
GSTINEerorMSGdiv.style.color="red";
return false;
}
if(document.getElementById('State Code').value.trim()=="" ) {
StateCodeEerorMSGdiv.innerHTML="State Code is required.";
StateCodeEerorMSGdiv.style.color="red";
return false;
}
if(document.getElementById('Bank Name').value.trim()=="" ) {
BankNameEerorMSGdiv.innerHTML="Bank Name is required.";
BankNameEerorMSGdiv.style.color="red";
return false;
}
if(document.getElementById('Account Name').value.trim()=="" ) {
	BankNameEerorMSGdiv.innerHTML="Account Holder's Name is required.";
	BankNameEerorMSGdiv.style.color="red";
	return false;
	}
if(document.getElementById('Bank AC No').value.trim()=="" ) {
BankACNoEerorMSGdiv.innerHTML="Bank AC No is required.";
BankACNoEerorMSGdiv.style.color="red";
return false;
}
if(document.getElementById('Bank IFSC Code').value.trim()=="" ) {
BankIFSCCodeEerorMSGdiv.innerHTML="Bank IFSC Code is required.";
BankIFSCCodeEerorMSGdiv.style.color="red";
return false;
}
if(document.getElementById('Bank Address').value.trim()=="" ) {
BankAddressEerorMSGdiv.innerHTML="Bank Address is required.";
BankAddressEerorMSGdiv.style.color="red";
return false;
}      
if(document.getElementById('Employee_Key').value.trim()=="" ) {
	BankAddressEerorMSGdiv.innerHTML="Employee Key is required.";
	BankAddressEerorMSGdiv.style.color="red";
	return false;
	}

if(document.getElementById('Sales_Key').value.trim()=="" ) {
	BankAddressEerorMSGdiv.innerHTML="Sales Key is required.";
	BankAddressEerorMSGdiv.style.color="red";
	return false;
	}

if(document.getElementById('Client_Key').value.trim()=="" ) {
	BankAddressEerorMSGdiv.innerHTML="Client's Key is required.";
	BankAddressEerorMSGdiv.style.color="red";
	return false;
	}	

if(document.getElementById('Project_Key').value.trim()=="" ) {
	BankAddressEerorMSGdiv.innerHTML="Project's Key is required.";
	BankAddressEerorMSGdiv.style.color="red";
	return false;
	}

if(document.getElementById('Task_Key').value.trim()=="" ) {
	BankAddressEerorMSGdiv.innerHTML="Task Key is required.";
	BankAddressEerorMSGdiv.style.color="red";
	return false;
	}

if(document.getElementById('Billing_Key').value.trim()=="" ) {
	BankAddressEerorMSGdiv.innerHTML="Billing Key is required.";
	BankAddressEerorMSGdiv.style.color="red";
	return false;
	}

if(document.getElementById('Products_Key').value.trim()=="" ) {
	BankAddressEerorMSGdiv.innerHTML="Products Key is required.";
	BankAddressEerorMSGdiv.style.color="red";
	return false;
	}	
if(document.getElementById('Expense_Key').value.trim()=="" ) {
	Expense_KeyEerorMSGdiv.innerHTML="Expense Key is required.";
	Expense_KeyEerorMSGdiv.style.color="red";
	return false;
	}	
if(document.getElementById('Transfer_Key').value.trim()=="" ) {
	Transfer_KeyEerorMSGdiv.innerHTML="Transfer Key is required.";
	Transfer_KeyEerorMSGdiv.style.color="red";
	return false;
	}
if(document.getElementById('Trigger_Key').value.trim()=="" ) {
	Trigger_KeyEerorMSGdiv.innerHTML="Trigger Key is required.";
	Trigger_KeyEerorMSGdiv.style.color="red";
	return false;
	}
showLoader();
// document.registeruserClient.submit();
}
function isExistName(value,err){
	var val=document.getElementById(value).value.trim();
	if(val!="")
	$.ajax({
		type : "POST",
		url : "ExistValue111",
		dataType : "HTML",
		data : {"val":val,"field":"name"},
		success : function(data){
			if(data=="pass"){
			document.getElementById(err).innerHTML=val +" is already existed.";
			document.getElementById(err).style.color="red";
			document.getElementById(value).value="";
			}
			
		}
	});
}

function isExistValue(value,err){
	var val=document.getElementById(value).value.trim();
	if(val!="")
	$.ajax({
		type : "POST",
		url : "ExistValue111",
		dataType : "HTML",
		data : {"val":val,"field":"all"},
		success : function(data){
			if(data=="pass"){
			document.getElementById(err).innerHTML=val +" is already existed.";
			document.getElementById(err).style.color="red";
			document.getElementById(value).value="";
			}
			
		}
	});
}

</script>
</body>
</html>