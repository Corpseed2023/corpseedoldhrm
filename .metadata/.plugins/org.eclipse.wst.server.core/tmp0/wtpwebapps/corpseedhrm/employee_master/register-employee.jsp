<!DOCTYPE HTML>
<%@page import="admin.master.Usermaster_ACT"%>
<%@page import="employee_master.Employee_ACT"%>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Employee Registration</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<% 	
String addedby= (String)session.getAttribute("loginuID");
String token= (String)session.getAttribute("uavalidtokenno");

String start=Usermaster_ACT.getStartingCode(token,"imemployeekey");
String emuid=Employee_ACT.getuniquecode(token);
if (emuid==null) {	
emuid=start+"1";
}
else {
	String c=emuid.substring(start.length());
int j=Integer.parseInt(c)+1;
emuid=start+Integer.toString(j);
}%>
<%if(!RE00){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
<div class="container">
<div class="bread-crumb">
<div class="bd-breadcrumb bd-light">
<a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
<a>Employee Registration</a>
</div><a href="<%=request.getContextPath()%>/manage-employee.html" style="float: right;"><button class="bkbtn">Back</button></a>
</div>
</div>

<div class="main-content">
<div class="container">
<div class="row">
<div class="col-xs-12">
<div class="menuDv  post-slider">
<form action="register-new-employee.html" method="post" name="registerEmployee" id="registerEmployee">
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<input type="hidden" name="addeduser" value="<%=addedby%>">
<label>Employee ID :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
<input type="text" name="EmployeeID" id="Employee ID" value="<%=emuid%>" readonly placeholder="Enter Employee ID" onblur="requiredFieldValidation('Employee ID','EmployeeIDEerorMSGdiv');" class="form-control">
</div>
<div id="EmployeeIDEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Employee Name :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
<select name="EmployeePrefix" id="Employee Prefix" onblur="requiredFieldValidation('Employee Prefix','EmployeeNameEerorMSGdiv');" class="form-control prefix">
<option value="Mr">Mr</option>
<option value="Miss">Miss</option>
</select>
<input type="text" name="EmployeeName" id="Employee Name" title="Employee's Name here !" placeholder="Employee's Name here !" onblur="requiredFieldValidation('Employee Name','EmployeeNameEerorMSGdiv');validateName('Employee Name','EmployeeNameEerorMSGdiv');validateValue('Employee Name','EmployeeNameEerorMSGdiv');" class="form-control" style="width: 75%;">
</div>
<div id="EmployeeNameEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Department :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
<select name="EmployeeDepartment" id="Employee Department" class="form-control">
	<option value="">Department</option>
	<option value="Sales">Sales</option>
	<option value="Delivery">Delivery</option>
	<option value="Account">Account</option>
	<option value="HR">HR</option>
	<option value="IT">IT</option>
	<option value="Marketing">Marketing</option>
	<option value="Document">Document</option>
</select>
</div>
<div id="EmployeeDepartmentEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Designation :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
<input type="text" name="EmployeeDesignation" id="Employee Designation" title="Employee's Designation here !" placeholder="Employee's Designation here !" onblur="requiredFieldValidation('Employee Designation','EmployeeDesignationEerorMSGdiv');validateName('Employee Designation','EmployeeDesignationEerorMSGdiv');validateValue('Employee Designation','EmployeeDesignationEerorMSGdiv');" class="form-control">
</div>
<div id="EmployeeDesignationEerorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Mobile No. :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
<input type="text" name="EmployeeMobile" id="Employee Mobile" maxlength="10" title="Mobile No. here !" placeholder="Mobile No. here !" onblur="requiredFieldValidation('Employee Mobile','EmployeeMobileEerorMSGdiv');validateMobileno('Employee Mobile','EmployeeMobileEerorMSGdiv');isExistValue('Employee Mobile','EmployeeMobileEerorMSGdiv');" class="form-control" onkeypress="return isNumber(event)">
</div>
<div id="EmployeeMobileEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Alternate Mobile No. :</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
<input type="text" name="EmployeeAlternateMobile" id="Employee Alternate Mobile" title="Alternate Mobile No. here !" placeholder="Alternate Mobile No.(Optional)" onblur="isExistValue('Employee Alternate Mobile','EmployeeAlternateMobileEerorMSGdiv');" class="form-control" maxlength="10" onkeypress="return isNumber(event)">
</div>
<div id="EmployeeAlternateMobileEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Email Id :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
<input type="text" name="EmployeeEmail" id="Employee Email" title="Email Id here !" placeholder="Email Id here !" onblur="requiredFieldValidation('Employee Email','EmployeeEmailEerorMSGdiv');verifyEmailId('Employee Email','EmployeeEmailEerorMSGdiv');isExistValue('Employee Email','EmployeeEmailEerorMSGdiv');" class="form-control">
</div>
<div id="EmployeeEmailEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Alternate Email Id :</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
<input type="text" name="EmployeeAlternateEmail" onblur="isExistValue('Employee Alternate Email','EmployeeAlternateEmailEerorMSGdiv');" id="Employee Alternate Email" title="Alternate Email Id here !" placeholder="Alternate Email Id(Optional)" class="form-control">
</div>
<div id="EmployeeAlternateEmailEerorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>PAN :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="PAN" id="PAN" maxlength="10" title="PAN No. here !" placeholder="PAN No. here !" onblur="requiredFieldValidation('PAN','PANEerorMSGdiv');validateUserName('PAN','PANEerorMSGdiv');validateValue('PAN','PANEerorMSGdiv');isExistValue('PAN','PANEerorMSGdiv');" class="form-control">
</div>
<div id="PANEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Aadhar :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="Aadhar" id="Aadhar" title="Aadhar No. here !" placeholder="Aadhar No. here !" onblur="requiredFieldValidation('Aadhar','AadharEerorMSGdiv');isExistValue('Aadhar','AadharEerorMSGdiv');" maxlength="12" class="form-control" onkeypress="return isNumber(event)">
</div>
<div id="AadharEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Gender :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<select name="Gender" id="Gender" onblur="requiredFieldValidation('Gender','GenderEerorMSGdiv');" class="form-control">
<option value="">Select your Gender</option>
<option value="Male">Male</option>
<option value="Female">Female</option>
</select>
</div>
<div id="GenderEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Date Of Joining :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="DateOfJoining" id="Date_Of_Joining" title="Select Joining date here !" placeholder="Select Joining date" class="form-control readonlyAllow" readonly>
</div>
<div id="DateOfJoiningEerorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Date Of Birth :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="DateOfBirth" id="Date_Of_Birth" placeholder="Select Date Of Birth here !" class="form-control readonlyAllow" readonly>
</div>
<div id="DateOfBirthEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Date of Anniversary :</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="DateofAnniversary" id="Date_of_Anniversary" title="Select Anniversary date here !" placeholder="Select Anniversary date(Optional)" class="form-control readonlyAllow" readonly>
</div>
<div id="DateofAnniversaryEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Emergency Contact Name :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
<input type="text" name="EmergencyContactEmployeeName" id="Emergency Contact Employee Name" title="Emergency Contact Employee Name here !" placeholder="Emergency Contact Employee Name here !" onblur="requiredFieldValidation('Emergency Contact Employee Name','EmergencyContactEmployeeNameEerorMSGdiv');validateName('Emergency Contact Employee Name','EmergencyContactEmployeeNameEerorMSGdiv');validateValue('Emergency Contact Employee Name','EmergencyContactEmployeeNameEerorMSGdiv');" class="form-control">
</div>
<div id="EmergencyContactEmployeeNameEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Emergency Contact Mobile No. :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
<input type="text" name="EmergencyContactEmployeeMobile" id="Emergency Contact Employee Mobile" title="Emergency Contact Mobile No. here !" placeholder="Emergency Contact Mobile No. here !" onblur="requiredFieldValidation('Emergency Contact Employee Mobile','EmergencyContactEmployeeMobileEerorMSGdiv');validateMobileno('Emergency Contact Employee Mobile','EmergencyContactEmployeeMobileEerorMSGdiv');isExistValue('Emergency Contact Employee Mobile','EmergencyContactEmployeeMobileEerorMSGdiv');" maxlength="10" onkeypress="return isNumber(event)" class="form-control">
</div>
<div id="EmergencyContactEmployeeMobileEerorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Emergency Contact Email Id :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
<input type="text" name="EmergencyContactEmployeeEmail" id="Emergency Contact Employee Email" placeholder="Emergency Contact Email Id here !" onblur="requiredFieldValidation('Emergency Contact Employee Email','EmergencyContactEmployeeEmailEerorMSGdiv');verifyEmailId('Emergency Contact Employee Email','EmergencyContactEmployeeEmailEerorMSGdiv');isExistValue('Emergency Contact Employee Email','EmergencyContactEmployeeEmailEerorMSGdiv');" class="form-control">
</div>
<div id="EmergencyContactEmployeeEmailEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Relation with Employee :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="relation" id="Relation" title="Relation with Employee here !" placeholder="Relation with Employee here !" onblur="requiredFieldValidation('Relation','RelationEerorMSGdiv');validateName('Relation','RelationEerorMSGdiv');validateValue('Relation','RelationEerorMSGdiv');" class="form-control">
</div>
<div id="RelationEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Bank's Name :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="BankName" id="Bank Name" title="Bank's Name here !" placeholder="Bank's Name here !" onblur="requiredFieldValidation('Bank Name','BankNameEerorMSGdiv');validateName('Bank Name','BankNameEerorMSGdiv');validateValue('Bank Name','BankNameEerorMSGdiv');" class="form-control">
</div>
<div id="BankNameEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Account holder's Name :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="AccountName" id="Account Name" title="Account holder's Name here !" placeholder="Account holder's Name here !" onblur="requiredFieldValidation('Account Name','AccountNameEerorMSGdiv');validateName('Account Name','AccountNameEerorMSGdiv');validateValue('Account Name','AccountNameEerorMSGdiv');" class="form-control">
</div>
<div id="AccountNameEerorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>A/C No. :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="BankACNo" id="Bank AC No" title="Bank Account Number here !" placeholder="Bank Account Number here !" onblur="requiredFieldValidation('Bank AC No','BankACNoEerorMSGdiv');isExistValue('Bank AC No','BankACNoEerorMSGdiv');" onkeypress="return isNumber(event)" class="form-control">
</div>
<div id="BankACNoEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>IFSC Code :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="BankIFSCCode" id="Bank IFSC Code" title="Bank IFSC Code here !" placeholder="Bank IFSC Code here !" onblur="requiredFieldValidation('Bank IFSC Code','BankIFSCCodeEerorMSGdiv');validateUserName('Bank IFSC Code','BankIFSCCodeEerorMSGdiv');validateValue('Bank IFSC Code','BankIFSCCodeEerorMSGdiv');" class="form-control">
</div>
<div id="BankIFSCCodeEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
<label>Bank's Address :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="BankAddress" id="Bank Address" title="Bank Address here !" placeholder="Bank Address here !" onblur="requiredFieldValidation('Bank Address','BankAddressEerorMSGdiv');validateLocation('Bank Address','BankAddressEerorMSGdiv');validateValue('Bank Address','BankAddressEerorMSGdiv');" class="form-control">
</div>
<div id="BankAddressEerorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
<label>Employee's Present Address :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite info"></i></span>
<input type="text" name="EmployeePresentAddress" id="Employee Present Address" title="Employee's Present Address here !" placeholder="Employee's Present Address here !" onblur="requiredFieldValidation('Employee Present Address','EmployeePresentAddressEerorMSGdiv');validateLocation('Employee Present Address','EmployeePresentAddressEerorMSGdiv');validateValue('Employee Present Address','EmployeePresentAddressEerorMSGdiv');" class="form-control">
</div>
<div id="EmployeePresentAddressEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
<label>Employee's Permanent Address :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite info"></i></span>
<input type="text" name="EmployeePermanentAddress" id="Employee Permanent Address" title="Employee's Permanent Address here !"  placeholder="Employee Permanent Address here !" onblur="requiredFieldValidation('Employee Permanent Address','EmployeePermanentAddressEerorMSGdiv');validateLocation('Employee Permanent Address','EmployeePermanentAddressEerorMSGdiv');validateValue('Employee Permanent Address','EmployeePermanentAddressEerorMSGdiv');" class="form-control">
</div>
<div id="EmployeePermanentAddressEerorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12 item-product-info">
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateEmployee()">Register Employee<i class="fa fa-paper-plane" aria-hidden="true"></i></button>
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


function validateEmployee() {
	
if (document.getElementById('Employee Prefix').value.trim() == "") {
EmployeeNameEerorMSGdiv.innerHTML = "Employee Prefix is required.";
EmployeeNameEerorMSGdiv.style.color = "red";
return false;
}
if (document.getElementById('Employee Name').value.trim() == "") {
EmployeeNameEerorMSGdiv.innerHTML = "Employee Name is required.";
EmployeeNameEerorMSGdiv.style.color = "red";
return false;
}
if (document.getElementById('Employee Department').value.trim() == "") {
EmployeeDepartmentEerorMSGdiv.innerHTML = "Employee Department  is required.";
EmployeeDepartmentEerorMSGdiv.style.color = "red";
return false;
}
if (document.getElementById('Employee Designation').value.trim() == "") {
EmployeeDesignationEerorMSGdiv.innerHTML = "Employee Designation is required.";
EmployeeDesignationEerorMSGdiv.style.color = "red";
return false;
}
if (document.getElementById('Employee Mobile').value.trim() == "") {
EmployeeMobileEerorMSGdiv.innerHTML = "Employee Mobile  is required.";
EmployeeMobileEerorMSGdiv.style.color = "red";
return false;
}
var altermobile=document.getElementById('Employee Alternate Mobile').value.trim();
if ( altermobile== ""||altermobile=="NA"||altermobile=="na"||altermobile=="Na"||altermobile=="nA") {
	document.getElementById('Employee Alternate Mobile').value="NA";
	}else{
		return validateMobileno('Employee Alternate Mobile','EmployeeAlternateMobileEerorMSGdiv');
	}

if (document.getElementById('Employee Email').value.trim() == "") {
EmployeeEmailEerorMSGdiv.innerHTML = "Employee Email is required.";
EmployeeEmailEerorMSGdiv.style.color = "red";
return false;
}
var alteremail=document.getElementById('Employee Alternate Email').value.trim();
if ( alteremail== ""||alteremail=="NA"||alteremail=="na"||alteremail=="Na"||alteremail=="nA") {
	document.getElementById('Employee Alternate Email').value="NA";
}else{
	return verifyEmailId('Employee Alternate Email','EmployeeAlternateEmailEerorMSGdiv');
}

if (document.getElementById('Employee Permanent Address').value.trim() == "") {
EmployeePermanentAddressEerorMSGdiv.innerHTML = "Employee Permanent Address is required.";
EmployeePermanentAddressEerorMSGdiv.style.color = "red";
return false;
}
if (document.getElementById('Employee Present Address').value.trim() == "") {
EmployeePresentAddressEerorMSGdiv.innerHTML = "Employee Present Address is required.";
EmployeePresentAddressEerorMSGdiv.style.color = "red";
return false;
}
if (document.getElementById('PAN').value.trim() == "") {
PANEerorMSGdiv.innerHTML = "PAN is required.";
PANEerorMSGdiv.style.color = "red";
return false;
}
if (document.getElementById('Aadhar').value.trim() == "") {
AadharEerorMSGdiv.innerHTML = "Aadhar is required.";
AadharEerorMSGdiv.style.color = "red";
return false;
}
if (document.getElementById('Bank Name').value.trim() == "") {
BankNameEerorMSGdiv.innerHTML = "Bank Name is required.";
BankNameEerorMSGdiv.style.color = "red";
return false;
}
if (document.getElementById('Account Name').value.trim() == "") {
	AccountNameEerorMSGdiv.innerHTML = "Account holder's name is required.";
	AccountNameEerorMSGdiv.style.color = "red";
	return false;
	}
if (document.getElementById('Bank AC No').value.trim() == "") {
BankACNoEerorMSGdiv.innerHTML = "Bank AC No is required.";
BankACNoEerorMSGdiv.style.color = "red";
return false;
}
if (document.getElementById('Bank IFSC Code').value.trim() == "") {
BankIFSCCodeEerorMSGdiv.innerHTML = "Bank IFSC Code is required.";
BankIFSCCodeEerorMSGdiv.style.color = "red";
return false;
}
if (document.getElementById('Bank Address').value.trim() == "") {
BankAddressEerorMSGdiv.innerHTML = "Bank Address is required.";
BankAddressEerorMSGdiv.style.color = "red";
return false;
}
if (document.getElementById('Emergency Contact Employee Name').value.trim() == "") {
EmergencyContactEmployeeNameEerorMSGdiv.innerHTML = "Emergency Contact Employee Name is required.";
EmergencyContactEmployeeNameEerorMSGdiv.style.color = "red";
return false;
}
if (document.getElementById('Emergency Contact Employee Mobile').value.trim() == "") {
EmergencyContactEmployeeMobileEerorMSGdiv.innerHTML = "Emergency Contact Employee Mobile is required.";
EmergencyContactEmployeeMobileEerorMSGdiv.style.color = "red";
return false;
}
if (document.getElementById('Relation').value.trim() == "") {
RelationEerorMSGdiv.innerHTML = "Relation is required.";
RelationEerorMSGdiv.style.color = "red";
return false;
}
if (document.getElementById('Gender').value.trim() == "") {
GenderEerorMSGdiv.innerHTML = "Gender is required.";
GenderEerorMSGdiv.style.color = "red";
return false;
}
if (document.getElementById('Date_Of_Birth').value.trim() == "") {
DateOfBirthEerorMSGdiv.innerHTML = "Date Of Birth is required.";
DateOfBirthEerorMSGdiv.style.color = "red";
return false;
}
if (document.getElementById('Date_Of_Joining').value.trim() == "") {
	DateOfJoiningEerorMSGdiv.innerHTML = "Date Of Joining is required.";
	DateOfJoiningEerorMSGdiv.style.color = "red";
	return false;
	}
if (document.getElementById('Date_of_Anniversary').value.trim() == ""||document.getElementById('Date_of_Anniversary').value.trim() == "NA") {
	document.getElementById('Date_of_Anniversary').value="NA";
}
showLoader();
// document.registerEmployee.submit();
}
</script>
<script type="text/javascript">
$( function() {
$( "#Date_Of_Birth" ).datepicker({
changeMonth: true,
changeYear: true,
yearRange: '-60: -0',
dateFormat: 'dd-mm-yy'
});
} );
$( function() {
	$( "#Date_Of_Joining" ).datepicker({
	changeMonth: true,
	changeYear: true,
	yearRange: '-60: -0',
	dateFormat: 'dd-mm-yy'
	});
	} );
$( function() {
$( "#Date_of_Anniversary" ).datepicker({
changeMonth: true,
changeYear: true,
yearRange: '-60: -0',
dateFormat: 'dd-mm-yy'
});
} );
</script>
</body>
</html>