<!DOCTYPE HTML>
<%@page import="company_master.CompanyMaster_ACT"%>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Edit Company</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%
String addedby= (String)session.getAttribute("loginuID");
String compuid=(String) session.getAttribute("passid");
String[][] getCompanyByID=CompanyMaster_ACT.getCompanyByID(compuid);
%>
<%if(!MC02){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
<div class="container">
<div class="bread-crumb">
<div class="bd-breadcrumb bd-light">
<a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
<a>Edit Company</a>
</div>
<a href="<%=request.getContextPath()%>/manage-company.html"><button class="bkbtn" style="margin-left: 845px;">Back</button></a>
</div>
</div>
<div class="main-content">
<div class="container">
<div class="row">
<div class="col-xs-12">
<div class="menuDv  post-slider">
<form action="update-company.html" method="post" name="registeruserClient" id="registeruserClient">
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<input type="hidden" name="addedbyuser" value="<%=addedby%>">
<label>Company ID :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="CompanyID" id="Company ID" value="<%=getCompanyByID[0][1]%>" readonly class="form-control">
</div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Company Name :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-user"></i></span>
<input type="text" name="CompanyName" id="Company Name" value="<%=getCompanyByID[0][2]%>" placeholder="Enter Company Name" onblur="requiredFieldValidation('Company Name','CompanyNameEerorMSGdiv');validateCompanyName('Company Name','CompanyNameEerorMSGdiv');validateValue('Company Name','CompanyNameEerorMSGdiv');isExistName('Company Name','CompanyNameEerorMSGdiv','<%=getCompanyByID[0][0]%>');" class="form-control">
</div>
<div id="CompanyNameEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Mobile No. :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-mobile"></i></span>
<input type="text" name="mobile" id="Mobile" placeholder="Enter Mobile No." value="<%=getCompanyByID[0][12]%>" onblur="requiredFieldValidation('Mobile','mobileEerorMSGdiv');validateMobileno('Mobile','mobileEerorMSGdiv');isExistValue('Mobile','mobileEerorMSGdiv','<%=getCompanyByID[0][0]%>');" maxlength="10" class="form-control" onkeypress="return isNumber(event)">
</div>
<div id="mobileEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Email Id :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-at"></i></span>
<input type="text" name="email" id="Email" placeholder="Enter Email Id" value="<%=getCompanyByID[0][13]%>" onblur="requiredFieldValidation('Email','emailEerorMSGdiv');verifyEmailId('Email','emailEerorMSGdiv');isExistValue('Email','emailEerorMSGdiv','<%=getCompanyByID[0][0]%>');" class="form-control">
</div>
<div id="emailEerorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Company's Address :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite info"></i></span>
<input type="text" name="CompanyAddress" id="Company Address" value="<%=getCompanyByID[0][3]%>" placeholder="Enter Company Address" onblur="requiredFieldValidation('Company Address','CompanyAddressEerorMSGdiv');validateLocation('Company Address','CompanyAddressEerorMSGdiv');validateValue('Company Address','CompanyAddressEerorMSGdiv');" class="form-control">
</div>
<div id="CompanyAddressEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>PAN :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="PAN" id="PAN" placeholder="Enter PAN" maxlength="10" value="<%=getCompanyByID[0][4]%>" onblur="requiredFieldValidation('PAN','PANEerorMSGdiv');validateUserName('PAN','PANEerorMSGdiv');validateValue('PAN','PANEerorMSGdiv');isExistValue('PAN','PANEerorMSGdiv','<%=getCompanyByID[0][0]%>');" class="form-control">
</div>
<div id="PANEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>GSTIN :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="GSTIN" id="GSTIN" placeholder="Enter GSTIN" value="<%=getCompanyByID[0][5]%>" onblur="requiredFieldValidation('GSTIN','GSTINEerorMSGdiv');validateUserName('GSTIN','GSTINEerorMSGdiv'); validateValue('GSTIN','GSTINEerorMSGdiv');isExistValue('GSTIN','GSTINEerorMSGdiv','<%=getCompanyByID[0][0]%>');" class="form-control">
</div>
<div id="GSTINEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>State Code :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="statecode" id="State Code" placeholder="Enter State Code" value="<%=getCompanyByID[0][6]%>" onblur="requiredFieldValidation('State Code','StateCodeEerorMSGdiv');validateUserName('State Code','StateCodeEerorMSGdiv'); validateValue('State Code','StateCodeEerorMSGdiv');" class="form-control">
</div>
<div id="StateCodeEerorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Bank Name :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-bank"></i></span>
<input type="text" name="BankName" id="Bank Name" placeholder="Enter Bank Name" value="<%=getCompanyByID[0][7]%>" onblur="requiredFieldValidation('Bank Name','BankNameEerorMSGdiv');validateName('Bank Name','BankNameEerorMSGdiv');validateValue('Bank Name','BankNameEerorMSGdiv');" class="form-control">
</div>
<div id="BankNameEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Account Holder's Name :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-user"></i></span>
<input type="text" name="AccountName" id="Account Name" placeholder="Enter Account Name" value="<%=getCompanyByID[0][11]%>" onblur="requiredFieldValidation('Account Name','AccountNameEerorMSGdiv');validateName('Account Name','AccountNameEerorMSGdiv');validateValue('Account Name','AccountNameEerorMSGdiv');" class="form-control">
</div>
<div id="AccountNameEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Bank A/C No :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="BankACNo" id="Bank AC No" placeholder="Enter Bank Account Number" value="<%=getCompanyByID[0][8]%>" onblur="requiredFieldValidation('Bank AC No','BankACNoEerorMSGdiv');isExistValue('Bank AC No','BankACNoEerorMSGdiv','<%=getCompanyByID[0][0]%>');" class="form-control" onkeypress="return isNumber(event)">
</div>
<div id="BankACNoEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>IFSC Code :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="BankIFSCCode" id="Bank IFSC Code" placeholder="Enter Bank IFSC Code" value="<%=getCompanyByID[0][9]%>" onblur="requiredFieldValidation('Bank IFSC Code','BankIFSCCodeEerorMSGdiv');validateUserName('Bank IFSC Code','BankIFSCCodeEerorMSGdiv');validateValue('Bank IFSC Code','BankIFSCCodeEerorMSGdiv');" class="form-control">
</div>
<div id="BankIFSCCodeEerorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group">
<label>Bank's Address :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="BankAddress" id="Bank Address" placeholder="Enter Bank Address" value="<%=getCompanyByID[0][10]%>" onblur="requiredFieldValidation('Bank Address','BankAddressEerorMSGdiv');validateLocation('Bank Address','BankAddressEerorMSGdiv');validateValue('Bank Address','BankAddressEerorMSGdiv');" class="form-control">
</div>
<div id="BankAddressEerorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12 item-product-info">
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return registerCompany()">Update Company<i class="fa fa-paper-plane" aria-hidden="true"></i></button>
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
	if(document.getElementById('Company Name').value.trim()==""){
		document.getElementById('CompanyNameEerorMSGdiv').innerHTML="Company Name is required";
		document.getElementById('CompanyNameEerorMSGdiv').style.color="red";
		return false;
	}
if(document.getElementById('Mobile').value.trim()==""){
	document.getElementById('mobileEerorMSGdiv').innerHTML="Mobile is required";
	document.getElementById('mobileEerorMSGdiv').style.color="red";	
	return false;
	}
if(document.getElementById('Email').value.trim()==""){
	document.getElementById('emailEerorMSGdiv').innerHTML="Email is required";
	document.getElementById('emailEerorMSGdiv').style.color="red";	
	return false;
}
if(document.getElementById('Company Address').value.trim()==""){
	document.getElementById('CompanyAddressEerorMSGdiv').innerHTML="Company Address is required";
	document.getElementById('CompanyAddressEerorMSGdiv').style.color="red";	
	return false;
}
if(document.getElementById('PAN').value.trim()==""){
	document.getElementById('PANEerorMSGdiv').innerHTML="PAN is required";
	document.getElementById('PANEerorMSGdiv').style.color="red";
	return false;
}
if(document.getElementById('GSTIN').value.trim()==""){
	document.getElementById('GSTINEerorMSGdiv').innerHTML="GSTIN is required";
	document.getElementById('GSTINEerorMSGdiv').style.color="red";
	return false;
}
if(document.getElementById('State Code').value.trim()==""){
	document.getElementById('StateCodeEerorMSGdiv').innerHTML="State Code is required";
	document.getElementById('StateCodeEerorMSGdiv').style.color="red";
	return false;
}
if(document.getElementById('Bank Name').value.trim()==""){
	document.getElementById('BankNameEerorMSGdiv').innerHTML="Bank Name is required";
	document.getElementById('BankNameEerorMSGdiv').style.color="red";
	return false;
}
if(document.getElementById('Account Name').value.trim()==""){
	document.getElementById('AccountNameEerorMSGdiv').innerHTML="Account Name is required";
	document.getElementById('AccountNameEerorMSGdiv').style.color="red";
	return false;
}
if(document.getElementById('Bank AC No').value.trim()==""){
	document.getElementById('BankACNoEerorMSGdiv').innerHTML="Bank AC No is required";
	document.getElementById('BankACNoEerorMSGdiv').style.color="red";
	return false;
}
if(document.getElementById('Bank IFSC Code').value.trim()==""){
	document.getElementById('BankIFSCCodeEerorMSGdiv').innerHTML="Bank IFSC Code is required";
	document.getElementById('BankIFSCCodeEerorMSGdiv').style.color="red";
	return false;
}
if(document.getElementById('Bank Address').value.trim()==""){
	document.getElementById('BankAddressEerorMSGdiv').innerHTML="Bank Address is required";
	document.getElementById('BankAddressEerorMSGdiv').style.color="red";
	return false;
}
showLoader();
}


function isExistName(value,err,id){
	var val=document.getElementById(value).value.trim();
	if(val!="")
	$.ajax({
		type : "POST",
		url : "ExistEditValue111",
		dataType : "HTML",
		data : {"val":val,"field":"name","id":id},
		success : function(data){
			if(data=="pass"){
			document.getElementById(err).innerHTML=val +" is already existed.";
			document.getElementById(err).style.color="red";
			document.getElementById(value).value="";
			}
			
		}
	});
}

function isExistValue(value,err,id){
	var val=document.getElementById(value).value.trim();
	if(val!="")
	$.ajax({
		type : "POST",
		url : "ExistEditValue111",
		dataType : "HTML",
		data : {"val":val,"field":"all","id":id},
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
