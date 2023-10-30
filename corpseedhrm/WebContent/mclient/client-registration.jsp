<%@page import="admin.master.Usermaster_ACT"%>
<%@page import="client_master.Clientmaster_ACT"%>
<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Client Registration</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<% 	
String token= (String)session.getAttribute("uavalidtokenno");
String cregucid=Clientmaster_ACT.getetocode(token);
String initial = Usermaster_ACT.getStartingCode(token,"imclientkey");
if (cregucid==null) {
	cregucid=initial+"1";
}
else {
	String c=cregucid.substring(initial.length());
	
		int j=Integer.parseInt(c)+1;
		cregucid=initial+Integer.toString(j);
	}

%>
<%if(!CR01){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
<div class="container">
<div class="bread-crumb">
<div class="bd-breadcrumb bd-light">
<a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
<a>Client's Company Registration</a>
</div>
</div>
</div>

<div class="main-content">
<div class="container">
<div class="clearfix text-right mb10">
<a href="<%=request.getContextPath()%>/manage-client.html"><button class="bkbtn">Back</button></a>
</div>
<div class="row">
<div class="col-xs-12">
<div class="menuDv post-slider clearfix">
<form action="<%=request.getContextPath() %>/register-client.html" method="post" name="registeruserClient" id="registeruserClient">
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Client's Id :<span style="color: #4ac4f3;">*</span></label>
<div class="input-group">
<!--<span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>-->
<input type="text" name="clientID" id="Client ID"value="<%=cregucid%>" readonly placeholder="Client's ID" onblur="requiredFieldValidation('Client ID','ClientIDEerorMSGdiv');" class="form-control">
</div>
<div id="ClientIDEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Client's Company Name :<span style="color: #4ac4f3;">*</span></label>
<div class="input-group">
<!--<span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>-->
<input type="text" name="clientName" id="Client Name" placeholder="Client's Company Name here !" onblur="requiredFieldValidation('Client Name','ClientNameEerorMSGdiv');validateCompanyName('Client Name','ClientNameEerorMSGdiv');validateValue('Client Name','ClientNameEerorMSGdiv');isExistValue('Client Name','ClientNameEerorMSGdiv');" class="form-control">
</div>
<div id="ClientNameEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Client's Mobile No. :<span style="color: #4ac4f3;">*</span></label>
<div class="input-group">
<!--<span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>-->
<input type="text" name="ClientMobile" id="Client Mobile" maxlength="10" placeholder="Client's Mobile No. here !" onblur="requiredFieldValidation('Client Mobile','ClientMobileEerorMSGdiv');validateMobileno('Client Mobile','ClientMobileEerorMSGdiv');isExistValue('Client Mobile','ClientMobileEerorMSGdiv');" class="form-control" onkeypress="return isNumber(event)">
</div>
<div id="ClientMobileEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Client's Email Id :<span style="font-size: 12px;font-style: italic;">(optional)</span></label>
<div class="input-group">
<!--<span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>-->
<input type="text" name="ClientEmail" id="Client Email" placeholder="Client's Email Id here !" onblur="checkEmail('Client Email','ClientEmailEerorMSGdiv');isExistValue('Client Email','ClientEmailEerorMSGdiv');" class="form-control">
</div>
<div id="ClientEmailEerorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Company's Location :<span style="color: #4ac4f3;">*</span></label>
<div class="input-group">
<!--<span class="input-group-addon"><i class="form-icon sprite page"></i></span>-->
<input type="text" name="CompanyLocation" id="Company Location" placeholder="Company's Location here !" onblur="requiredFieldValidation('Company Location','CompanyLocationEerorMSGdiv');validateLocation('Company Location','CompanyLocationEerorMSGdiv');" class="form-control">
</div>
<div id="CompanyLocationEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Contact Person's Name :<span style="color: #4ac4f3;">*</span></label>
<div class="input-group">
<!--<span class="input-group-addon"><i class="form-icon sprite page"></i></span>-->
<input type="text" name="ContactName" id="Contact Name" placeholder="Contact's Name here !" onblur="requiredFieldValidation('Contact Name','ContactNameEerorMSGdiv');validateName('Contact Name','ContactNameEerorMSGdiv');" class="form-control">
</div>
<div id="ContactNameEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Contact Person's Email :<span style="font-size: 12px;font-style: italic;">(optional)</span></label>
<div class="input-group">
<!--<span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>-->
<input type="text" name="ContactEmail" id="Contact Email" placeholder="Contact's Email Id here !" onblur="checkEmail('Contact Email','ContactEmailEerorMSGdiv');isExistValue('Contact Email','ContactEmailEerorMSGdiv');" class="form-control">
</div>
<div id="ContactEmailEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Contact Person's Mobile No. :<span style="color: #4ac4f3;">*</span></label>
<div class="input-group">
<!--<span class="input-group-addon"><i class="form-icon sprite page"></i></span>-->
<input type="text" name="ContactMobile" maxlength="10" id="Contact Mobile" placeholder="Contact's Mobile No. here !" onblur="requiredFieldValidation('Contact Mobile','ContactMobileEerorMSGdiv');validateMobileno('Contact Mobile','ContactMobileEerorMSGdiv');isExistValue('Contact Mobile','ContactMobileEerorMSGdiv');" class="form-control" onkeypress="return isNumber(event)">
</div>
<div id="ContactMobileEerorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Contact Person's Role :<span style="color: #4ac4f3;">*</span></label>
<div class="input-group">
<!--<span class="input-group-addon"><i class="form-icon sprite page"></i></span>-->
<input type="text" name="ContactRole" id="Contact Role" placeholder="Contact's Role here !" onblur="requiredFieldValidation('Contact Role','ContactRoleEerorMSGdiv');validateName('Contact Role','ContactRoleEerorMSGdiv');validateValue('Contact Role','ContactRoleEerorMSGdiv');" class="form-control">
</div>
<div id="ContactRoleEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>PAN :<span style="font-size: 12px;font-style: italic;">(optional)</span></label>
<div class="input-group">
<!--<span class="input-group-addon"><i class="form-icon sprite page"></i></span>-->
<input type="text" name="PAN" id="PAN" placeholder="PAN here !" maxlength="10" onblur="isExistValue('PAN','PANEerorMSGdiv');checkPan('PAN','PANEerorMSGdiv');" class="form-control">
</div>
<div id="PANEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>GSTIN :<span style="font-size: 12px;font-style: italic;">(optional)</span></label>
<div class="input-group">
<!--<span class="input-group-addon"><i class="form-icon sprite page"></i></span>-->
<input type="text" name="GSTIN" id="GSTIN" maxlength="15" placeholder="GSTIN No. here !" onblur="isExistValue('GSTIN','GSTINEerorMSGdiv');" class="form-control">
</div>
<div id="GSTINEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>State Code :<span style="font-size: 12px;font-style: italic;">(optional)</span></label>
<div class="input-group">
<!--<span class="input-group-addon"><i class="form-icon sprite page"></i></span>-->
<input type="text" name="statecode" id="State Code" placeholder="State Code here !" class="form-control">
</div>
<div id="StateCodeEerorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Company Age :<span style="color: #4ac4f3;">*</span></label>
<div class="input-group">
<select name="company_age" id="Company_Age" class="form-control">
<option value="">Select Age</option>
<option value="0">0 Year</option>
<option value="1">1 Year</option>
<option value="2">2 Years</option>
<option value="3">3 Years</option>
<option value="4">4 Years</option>
<option value="5">5 Years</option>
<option value="6">6 Years</option>
<option value="7">7 Years</option>
<option value="8">8 Years</option>
<option value="9">9 Years</option>
<option value="10">10 Years</option>
<option value="11">11 Years</option>
<option value="12">12 Years</option>
<option value="13">13 Years</option>
<option value="14">14 Years</option>
<option value="15">15 Years</option>
<option value="16">16 Years</option>
<option value="17">17 Years</option>
<option value="18">18 Years</option>
<option value="19">19 Years</option>
<option value="20">20+ Years</option>
</select>
</div>
<div id="CompanyAgeEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
<label>Client's Company Address :<span style="color: #4ac4f3;">*</span></label>
<div class="input-group">
<!--<span class="input-group-addon"><i class="form-icon sprite info"></i></span>-->
<input type="text" name="ClientAddress" id="Client Address" placeholder="Client's Address here !" onblur="requiredFieldValidation('Client Address','ClientAddressEerorMSGdiv');validateLocation('Client Address','ClientAddressEerorMSGdiv');" class="form-control">
</div>
<div id="ClientAddressEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12" style="margin-top: 28px;">
<input type="checkbox" style="width: 20px;height: 20px;cursor: pointer;" checked="checked"><span style="margin-top: 4px;position: absolute;font-size: 13px;margin-left: 8px;">Send Login Details To Client</span>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12 item-product-info">
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return registerClient()">Register Client<i class="fa fa-paper-plane" aria-hidden="true"></i></button>
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
	if(val!=""&&val!="NA")
	$.ajax({
		type : "POST",
		url : "ExistValue111",
		dataType : "HTML",
		data : {"val":val,"field":"client"},
		success : function(data){
			if(data=="pass"){
			document.getElementById(err).innerHTML="'"+val +"'  is already existed.";
			document.getElementById(err).style.color="#333";
			document.getElementById(value).value="";
			}
			
		}
	});
}

function checkPan(id,err){
	var idval=document.getElementById(id).value.trim();
	if(idval==""||idval=="NA"||idval=="na"||idval=="Na"||idval=="nA"){
		document.getElementById(id).value="NA";
		document.getElementById(err).innerHTML="";
	}else{
		validatePan(id,err);
	}
}

function checkEmail(id,err){
	var idval=document.getElementById(id).value.trim();
	if(idval==""||idval=="NA"||idval=="na"||idval=="Na"||idval=="nA"){
		document.getElementById(id).value="NA";
		document.getElementById(err).innerHTML="";
	}else{
		verifyEmailId(id,err);
	}
}
function registerClient(){
	if(document.getElementById('Client ID').value.trim()=="" ){
		ClientIDEerorMSGdiv.innerHTML="Client ID is required.";
		ClientIDEerorMSGdiv.style.color="#333";return false;
		}
	if(document.getElementById('Client Name').value.trim()=="" ){
		ClientNameEerorMSGdiv.innerHTML="Client's Company Name is required.";
		ClientNameEerorMSGdiv.style.color="#333";return false;
		}
	if(document.getElementById('Client Mobile').value.trim()=="")
	{
		ClientMobileEerorMSGdiv.innerHTML="Client's Mobile No. is required.";
		ClientMobileEerorMSGdiv.style.color="#333";return false;
		}
	if(document.getElementById('Client Email').value.trim()==""||document.getElementById('Client Email').value.trim()=="NA"){
		document.getElementById('Client Email').value="NA";
		}
	if(document.getElementById('Company Location').value.trim()==""){
		CompanyLocationEerorMSGdiv.innerHTML="Company Location is required.";
		CompanyLocationEerorMSGdiv.style.color="#333";return false;
		}
	if(document.getElementById('Contact Name').value.trim()=="" ){
		ContactNameEerorMSGdiv.innerHTML="Contact Person's Name is required.";
		ContactNameEerorMSGdiv.style.color="#333";return false;
		}
	if(document.getElementById('Contact Email').value.trim()==""||document.getElementById('Contact Email').value.trim()=="NA"){
		document.getElementById('Contact Email').value="NA";
		}
	if(document.getElementById('Contact Mobile').value.trim()=="" ){
		ContactMobileEerorMSGdiv.innerHTML="Contact Person's Mobile is required.";
		ContactMobileEerorMSGdiv.style.color="#333";return false;
		}
	if(document.getElementById('Contact Role').value.trim()=="" ){
		ContactRoleEerorMSGdiv.innerHTML="Contact Person's Role is required.";
		ContactRoleEerorMSGdiv.style.color="#333";return false;
		}
	if(document.getElementById('PAN').value.trim()==""||document.getElementById('PAN').value.trim()=="NA"){
		document.getElementById('PAN').value="NA";
		}
	if(document.getElementById('GSTIN').value.trim()==""||document.getElementById('GSTIN').value.trim()=="NA"){
		document.getElementById('GSTIN').value="NA";
		}
	if(document.getElementById('State Code').value.trim()==""||document.getElementById('State Code').value.trim()=="NA"){
		document.getElementById('State Code').value="NA";
		}
	if(document.getElementById('Company_Age').value.trim()=="" ){
		CompanyAgeEerorMSGdiv.innerHTML="Company age is required.";
		CompanyAgeEerorMSGdiv.style.color="#333";return false;
		}
	if(document.getElementById('Client Address').value.trim()==""){
		ClientAddressEerorMSGdiv.innerHTML="Client's Company Address is required.";
		ClientAddressEerorMSGdiv.style.color="#333";return false;
		}
// 	document.registeruserClient.submit();
	}
</script>
</body>
</html>