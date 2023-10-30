
<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>User Registration</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>  
<%
String uacompany= (String)session.getAttribute("uacompany");
String addedby= (String)session.getAttribute("loginuID");
String userrole= (String)session.getAttribute("emproleid");
String token=(String)session.getAttribute("uavalidtokenno");
 
%>
<%if(!ACU01){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
<div class="container">
<div class="bread-crumb">
<div class="bd-breadcrumb bd-light">
<a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
<a>User Registration</a>
</div>
<a href="<%=request.getContextPath()%>/managewebuser.html" style="position: absolute;right: 6%;margin-top: 5px;">
<button class="bkbtn">Back</button></a>
</div>
</div>
<div class="main-content">
<div class="container">
<div class="row">
<form action="<%=request.getContextPath() %>/usercreate.html" method="post" id="usercreate" name="usercreate">
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="menuDv  post-slider">
<input type="hidden" name="addedbyuser" value="<%=addedby%>">
<input type="hidden" name="company" id="uacompany" value="<%=uacompany%>">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group">
<div class="input-group">
<select name="uaroletype" id="Role_Type" class="form-control" onchange="roleType(this.value)">
<option value="">Role Type !!</option><%if(addedby.equalsIgnoreCase("super admin")){ %>
<option value="Administrator">Administrator</option><%} %>
<option value="Employee" selected="selected">Employee</option>
<option value="Client">Client</option>
</select>
</div>
</div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12" id="DepartmentDivBoxId">
<div class="form-group">
<div class="input-group">
<select id="Department" name="department" class="form-control" onchange="setUserRole(this.value)">
	<option value="">Select Department  !!</option><%if(addedby.equalsIgnoreCase("super admin")){ %>
    <option value="Admin">All</option><%} %>
	<option value="Sales">Sales</option>
	<option value="Delivery">Delivery</option>
	<option value="Account">Account</option>
	<option value="HR">HR</option>
	<option value="Document">Document</option>
</select>
</div>
</div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12" id="RoleDivBoxId">
<div class="form-group">
<div class="input-group">
<select id="UserRegRole" name="UserRegRole" class="form-control" onchange="setPermissions(this.value)">
	<option value="">Select Role !!</option>
</select>
</div>
</div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group">
<div class="input-group">
<input type="text" name="userName" id="User_Name" placeholder="Name !!" autocomplete="off" onblur="" class="form-control">
<input type="hidden" name="emuid" id="emuid" value="NA">
<input type="hidden" name="User_Mobile" id="User_Mobile" value="NA">
<input type="hidden" name="User_Email" id="User_Email" value="NA">
<input type="hidden" name="tokenno" id="tokenno" value="NA">
</div>
</div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group">
<div class="input-group">
<input type="text" name="Username" onchange="isExistValue('UsernameID')" autocomplete="off" id="UsernameID" placeholder="Username !!" class="form-control">
</div>
</div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group">
<div class="input-group">
<input type="password" autocomplete="off" name="userPassword" id="User_Password" placeholder="Password !!" onblur="" class="form-control">
<span class="show_psw" onclick="myFunction()">
<i class="fa fa-eye-slash" style="font-size:15px;color:#006080"></i>
</span>
</div>
</div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12 advert text-center">
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return addUser();">Sign Up<i class="fa fa-paper-plane" aria-hidden="true"></i></button>
</div>
</div>
</div>
</div>
<div class="col-md-8 col-sm-8 col-xs-12">
<div class="menuDv clearfix">
<fieldset id="Field">
<div class="box-intro">
<div class="allselect_checkbox txt_orange"><input type="checkbox" id="checkall"/><span class="access-txt"><b>Select All</b></span></div>
<h2><span class="title">Access Permissions</span></h2>
</div>
<div class="clearfix">

<div class="clearfix access_title top_title">
<h3 class="normal_txt txt_orange"><input type="checkbox" onclick="selectAllPermissions('HRMainId','HRSubId')" name="privilege" id="HRMainId" value="ADM00"><span class="access-txt"><b>HR</b></span></h3>
<div class="access_point_icon"><i class="fa fa-plus"></i></div>
</div>

<div class="clearfix access_box_info" id="HRSubId" style="display: none;">
<div class="bg_lightgray clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="AMU02"><span class="access-txt">Manage HRM Login</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="ACU01"><span class="access-txt">Register HRM Login</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="ACU02"><span class="access-txt">Edit Login</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="ACU03"><span class="access-txt">Change Password</span>
</div>
<div class="col-md-3 col-sm-3 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="ACU04"><span class="access-txt">Activate/Deactivate</span>
</div>
<div class="col-md-3 col-sm-3 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="ACU05"><span class="access-txt">Delete Login's</span>
</div>
</div>
<div class="clearfix advert">
<div class="col-md-6 col-sm-6 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="LTH00"> <span class="access-txt">Login & Traffic History</span>
</div>
</div>
<div class="bg_lightgray clearfix pad-top5 pad-bt5 advert">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MC00"><span class="access-txt">Manage Company</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="RC00"><span class="access-txt">Register Company</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MC01"><span class="access-txt">View Company</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MC02"><span class="access-txt">Edit Company</span>
</div>
<div class="col-md-3 col-sm-3 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="MC03"><span class="access-txt">Activate/Deactivate</span>
</div>
<div class="col-md-3 col-sm-3 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="MC04"><span class="access-txt">Delete Company</span>
</div>
</div>
<div class="clearfix advert">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="ME00"><span class="access-txt">Manage Employee</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="RE00"><span class="access-txt">Register Employee</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="ME01"><span class="access-txt">View Employee</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="ME02"><span class="access-txt">Edit Employee</span>
</div>
<div class="col-md-3 col-sm-3 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="ME03"><span class="access-txt">Activate/Deactivate</span>
</div>
<div class="col-md-3 col-sm-3 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="ME04"><span class="access-txt">Delete Employee</span>
</div>
</div>
<div class="bg_lightgray clearfix pad-top5 pad-bt5 advert">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="ATT03"> <span class="access-txt">Manage Attendance</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="ATT02"> <span class="access-txt">Add Attendance</span>
</div>
</div>
<div class="clearfix advert">
<div class="col-md-6 col-sm-6 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="CLA00"> <span class="access-txt">Manage Client's Admin</span>
</div>
</div>
</div>

<div class="clearfix access_title top_title">
<h3 class="normal_txt txt_orange"><input type="checkbox" id="SalesMainId" onclick="selectAllPermissions('SalesMainId','CheckSales')" name="privilege" value="EQ00"><span class="access-txt"><b>Sales</b></span></h3>
<div class="access_point_icon"><i class="fa fa-plus"></i></div>
</div>

<div class="clearfix access_box_info" id="CheckSales" style="display: none;">
<div class="clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="EST00"><span class="access-txt">Manage Estimate</span>
</div>
<div class="col-md-3 col-sm-3 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="EST01"><span class="access-txt">Add Estimate</span>
</div>
</div>
<div class="bg_lightgray clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="EQ02"><span class="access-txt">Manage Sales</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="EQ01"><span class="access-txt">Register Payment</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MAS00"><span class="access-txt">Documents</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MAS01"><span class="access-txt">Task History</span>
</div>
</div>
</div>


<div class="clearfix access_title top_title">
<h3 class="normal_txt txt_orange"><input type="checkbox" id="DocumentCollectionId" onclick="selectAllPermissions('DocumentCollectionId','CheckDocument')" name="privilege" value="DC00"><span class="access-txt"><b>Document</b></span></h3>
<div class="access_point_icon"><i class="fa fa-plus"></i></div>
</div>

<div class="clearfix access_box_info" id="CheckDocument" style="display: none;">
<div class="clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="DOC00"><span class="access-txt">Document Collection</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="DTR00"><span class="access-txt">Track Service</span>
</div>
</div>
</div>

<div class="clearfix access_title top_title">
<h3 class="normal_txt txt_orange"><input type="checkbox" name="privilege" id="ClientMainId" onclick="selectAllPermissions('ClientMainId','ClientSubId')" value="CL00"><span class="access-txt"><b>Client Master</b></span></h3>
<div class="access_point_icon"><i class="fa fa-plus"></i></div>
</div>

<div class="clearfix access_box_info" id="ClientSubId" style="display: none;">
<div class="clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="CPR03"><span class="access-txt">Manage Client</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="CR01"><span class="access-txt">Client Registration</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="CR02"><span class="access-txt">Upload Documents</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="CR03"><span class="access-txt">Edit Client</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="CR04"><span class="access-txt">Activate/Deactivate</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="CR05"><span class="access-txt">Delete Client</span>
</div>
</div>
</div>


<div class="clearfix access_title top_title">
<h3 class="normal_txt txt_orange"><input type="checkbox" name="privilege" onclick="selectAllPermissions('MyTaskMainId','MyTaskSubId')" id="MyTaskMainId" value="MT00"><span class="access-txt"><b>My Task</b></span></h3>
<div class="access_point_icon"><i class="fa fa-plus"></i></div>
</div>

<div class="clearfix access_box_info" id="MyTaskSubId" style="display: none;">
<div class="clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12 pad-top5">
<input type="checkbox" name="privilege" id="MyTaskDetails" value="MT01"><span class="access-txt">My Task Details</span>
</div>
</div>
<div class="bg_lightgray clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="MD00"><span class="access-txt">Manage Delivery</span>
</div>
</div>
<div class="clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="ManageDocument" value="MDC0"><span class="access-txt">Manage Document</span>
</div>
</div>
<div class="bg_lightgray clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="Calendar" value="MCC0"><span class="access-txt">Calendar</span>
</div>
</div>
<div class="clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="Calendar" value="MCR0"><span class="access-txt">Certificate renewal</span>
</div>
</div>
<div class="bg_lightgray clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="Calendar" value="MTR1"><span class="access-txt">Manage Report</span>
</div>
</div>
</div>

<div class="clearfix access_title top_title">
<h3 class="normal_txt txt_orange"><input type="checkbox" name="privilege" onclick="selectAllPermissions('AccountMainId','AccountSubId')" id="AccountMainId" value="ACC00"><span class="access-txt"><b>Account</b></span></h3>
<div class="access_point_icon"><i class="fa fa-plus"></i></div>
</div>


<div class="clearfix access_box_info" id="AccountSubId" style="display: none;">
<div class="bg_lightgray clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="AC00"><span class="access-txt">Client's Account</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="ACC01"><span class="access-txt">View Statement</span>
</div>
</div>
<div class="clearfix advert">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="ACC02"><span class="access-txt">Employee's Account</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="ACC03"><span class="access-txt">View Statement</span>
</div>
</div>
<div class="bg_lightgray clearfix pad-top5 pad-bt5 advert">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MB07"><span class="access-txt">Project Billing</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="CB06"><span class="access-txt">Mark As Paid</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MB00"><span class="access-txt">Register Payment</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="AMC00"><span class="access-txt">Payment History</span>
</div>
</div>

<div class="bg_lightgray clearfix pad-top5 pad-bt5 advert">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MB09"><span class="access-txt">Payroll</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="GH00"><span class="access-txt">Manage Transactions</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="GI00"><span class="access-txt">Manage Invoice</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MX00"><span class="access-txt">Manage Expense</span>
</div>
</div>
<div class="clearfix advert">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="CH00"><span class="access-txt">Credit History</span>
</div>
</div>
<div class="bg_lightgray clearfix pad-top5 pad-bt5 advert">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="UBL0"><span class="access-txt">Unbilled</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="INV0"><span class="access-txt">Invoiced</span>
</div>
</div>
</div>
<div class="clearfix access_title top_title">
<h3 class="normal_txt txt_orange"><input type="checkbox" name="privilege" id="ActivityMasterId" onclick="selectAllPermissions('ActivityMasterId','ActivityMasterSubId')" value="TM00"><span class="access-txt"><b>Activity Master</b></span></h3>
<div class="access_point_icon"><i class="fa fa-plus"></i></div>
</div>

<div class="clearfix access_box_info" id="ActivityMasterSubId" style="display: none;">
<div class="bg_lightgray clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MPP00"><span class="access-txt">Manage Product</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MPP01"><span class="access-txt">Add Product</span>
</div>

</div>
<div class="clearfix advert">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MTT00"><span class="access-txt">Manage Template</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MTT01"><span class="access-txt">Add SMS Template</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MTT02"><span class="access-txt">Add Email Template</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MTT03"><span class="access-txt">View Template</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="MTT04"><span class="access-txt">Edit Template</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="MTT05"><span class="access-txt">Delete Template</span>
</div>
</div>
<div class="bg_lightgray clearfix pad-top5 pad-bt5 advert">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MG00"><span class="access-txt">Manage Guide</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MTR0"><span class="access-txt">Manage Trigger</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MTX0"><span class="access-txt">Manage Tax</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MTM0"><span class="access-txt">Manage Teams</span>
</div>    
			
</div>
<div class="clearfix advert">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MCO0"><span class="access-txt">Manage Contacts</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MCP0"><span class="access-txt">Manage Coupon</span>
</div>
</div>
</div>

<div class="clearfix access_title top_title">
<h3 class="normal_txt txt_orange"><input type="checkbox" name="privilege" id="RecordsMasterId" onclick="selectAllPermissions('RecordsMasterId','RecordsMasterSubId')" value="RD00"><span class="access-txt"><b>Records</b></span></h3>
<div class="access_point_icon"><i class="fa fa-plus"></i></div>
</div>

<div class="clearfix access_box_info" id="RecordsMasterSubId" style="display: none;">
<div class="bg_lightgray clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="DH00"><span class="access-txt">Download History</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="EH00"><span class="access-txt">Export History</span>
</div>
</div>
</div>

<div class="clearfix access_title top_title">
<h3 class="normal_txt txt_orange"><input type="checkbox" name="privilege" id="ProfileMainId" onclick="selectAllPermissions('ProfileMainId','ProfileSubId')" value="MA00"><span class="access-txt"><b>Profile</b></span></h3>
<div class="access_point_icon"><i class="fa fa-plus"></i></div>
</div>

<div class="clearfix access_box_info" id="ProfileSubId" style="display: none;">
<div class="bg_lightgray clearfix pad-top5 pad-bt5">
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MMP00"><span class="access-txt">My Profile</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MMP04"><span class="access-txt">Edit Profile</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MMP01"><span class="access-txt">Work Scheduler</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<input type="checkbox" name="privilege" id="privilege" value="MMP02"><span class="access-txt">Change Password</span>
</div>
<div class="col-md-3 col-sm-3 col-xs-12 pad-top5">
<input type="checkbox" name="privilege" id="privilege" value="MMP03"><span class="access-txt">LogOut</span>
</div>
</div>
</div>
</div>
</fieldset>
</div>
</div>
</form>
</div>
</div>
</div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
</div>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>
<script type="text/javascript">
$('[id^=checkall]').click(
		function() {
			if (this.checked)
				$(this).closest('fieldset').find('input').prop('checked','checked');
			else
				$(this).closest('fieldset').find('input').prop('checked','');
		});
</script>
<script type="text/javascript">   
function roleType(roleType){
	if(roleType=="Client"){
		$("#DepartmentDivBoxId").hide();
		$("#RoleDivBoxId").hide();
		$("#Field").hide();
	}else{
		$("#DepartmentDivBoxId").show();
		$("#RoleDivBoxId").show();
		$("#Field").show();
	}
}
function setUserRole(dept){
	if(dept==""){
		$("#UserRegRole").empty();
		$("#UserRegRole").append("<option value=''>"+"Select Role"+"</option>");
	}else{
		$("#UserRegRole").empty();
		$("#UserRegRole").append("<option value=''>"+"Select Role"+"</option>");
		
		if(dept=="Account"){
			$("#UserRegRole").append("<option value='Accountant'>"+"Accountant"+"</option>");
		}else if(dept=="Delivery"||dept=="Sales"){
			$("#UserRegRole").append("<option value='Executive'>"+"Executive"+"</option>");
			$("#UserRegRole").append("<option value='Assistant'>"+"Assistant"+"</option>");
			$("#UserRegRole").append("<option value='Manager'>"+"Manager"+"</option>");
		}else if(dept=="HR"){
			$("#UserRegRole").append("<option value='Executive'>"+"Executive"+"</option>");
		}else if(dept=="Admin"){
			$("#UserRegRole").append("<option value='Admin'>"+"Admin"+"</option>");
		}else if(dept=="Document"){						
			$("#UserRegRole").append("<option value='Manager'>"+"Manager"+"</option>");
			$("#UserRegRole").append("<option value='Executive'>"+"Executive"+"</option>");
		}
	}
	
} 
function selectAllPermissions(permissionId,subpermissionid){
	if($("#"+permissionId).prop('checked') == true){
	    //remove all permissions
		$("#"+subpermissionid).find('input[type=checkbox]').each(function () {
            this.checked = true;
       }); 
	}else{
		$("#"+subpermissionid).find('input[type=checkbox]').each(function () {
            this.checked = false;
       }); 
	}
}
function setPermissions(role){
	var department=$("#Department").val();
	if(department!=""&&role!=""){
		//remove all checked permissions
		$('input:checkbox').removeAttr('checked');
		 //check profile section
	    $("#ProfileMainId").prop("checked",true);
	    $("#ProfileSubId").find('input[type=checkbox]').each(function () {
            this.checked = true;
       });
	}else{
		//remove all checked permissions
		$('input:checkbox').removeAttr('checked');
	}
	if(department=="Sales"&&(role=="Executive"||role=="Assistant")){		
		//check sales section
		$("#SalesMainId").prop("checked",true);
	    $("#CheckSales").find('input[type=checkbox]').each(function () {
            this.checked = true;
       });	   
	}else if(department=="Sales"&&role=="Manager"){
		//check sales section
		$("#SalesMainId").prop("checked",true);
	    $("#CheckSales").find('input[type=checkbox]').each(function () {
            this.checked = true;
       });	   
	  //check client section
	    $("#ClientMainId").prop("checked",true);
	    $("#ClientSubId").find('input[type=checkbox]').each(function () {
            this.checked = true;
       }); 
	}else if(department=="Delivery"&&(role=="Assistant"||role=="Manager")){
		//check my task section
		$("#MyTaskMainId").prop("checked",true);
	    $("#MyTaskSubId").find('input[type=checkbox]').each(function () {
            this.checked = true;
       });	   
	}else if(department=="Delivery"&&role=="Executive"){
		//check my task section   
		$("#MyTaskMainId").prop("checked",true);
		$("#MyTaskDetails").prop("checked",true);
		$("#ManageDocument").prop("checked",true);
		$("#Calendar").prop("checked",true);
	}else if(department=="Account"&&role=="Accountant"){
		  //check account section
	    $("#AccountMainId").prop("checked",true);
	    $("#AccountSubId").find('input[type=checkbox]').each(function () {
            this.checked = true;
       }); 
	}else if(department=="HR"&&role=="Executive"){
		  //check hr section
	    $("#HRMainId").prop("checked",true);
	    $("#HRSubId").find('input[type=checkbox]').each(function () {
            this.checked = true;
       }); 
	}else if(department=="Document"&&(role=="Manager" || role=="Executive")){
		  //check hr section
	    $("#DocumentCollectionId").prop("checked",true);
	    $("#CheckDocument").find('input[type=checkbox]').each(function () {
            this.checked = true;
       }); 
	}
}
function addUser() {  
	if($('#Role_Type').val().trim()=="") {
		document.getElementById("errorMsg").innerHTML="Please select Role Type.";				
		$('.alert-show').show().delay(2000).fadeOut();
	return false;
	}else if($('#Role_Type').val().trim()!="Client"){
		if($('#Department').val().trim()=="") {
			document.getElementById("errorMsg").innerHTML="Please  select department.";				
			$('.alert-show').show().delay(2000).fadeOut();
		return false;
		}
		if($('#UserRegRole').val().trim()=="") {
			document.getElementById("errorMsg").innerHTML="Please select role.";				
			$('.alert-show').show().delay(2000).fadeOut();
		return false;
		}		
	}
	if($('#UsernameID').val().trim()=="") {
		document.getElementById("errorMsg").innerHTML="Please enter username.";				
		$('.alert-show').show().delay(2000).fadeOut();
	return false;
	}	
	if($('#User_Password').val().trim()=="") {
		document.getElementById("errorMsg").innerHTML="Please enter a strong password.";				
		$('.alert-show').show().delay(2000).fadeOut();
	return false;
	}
	showLoader();
	/* var group = document.usercreate.privilege;
	for (var i=0; i<group.length; i++) {
	if (group[i].checked)
	break;
	}
	if (i==group.length){
	alert("No prevlage is checked");
	return false;
	} */
}
</script>
<script type="text/javascript"> 
$(function() {
	$("#User_Name").autocomplete({
		source : function(request, response) {
			var roletype=$('#Role_Type').val();		
			var dept=$('#Department').val();		
			if(roletype!="")
			if($('#User_Name').val().trim().length>=1)
			$.ajax({
				url : "getregistervalue.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					roletype :roletype,
					dept : dept
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value,
							emuid : item.emuid,
							emmobile : item.emmobile,
							ememail : item.ememail,
							company : item.company,
							tokenno :item.tokenno,
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
            	document.getElementById("errorMsg").innerHTML="Select From Role Type List.";				
				$('.alert-show').show().delay(2000).fadeOut();
				$("#emuid").val(""); 
				$("#User_Name").val(""); 
				$("#User_Mobile").val(""); 
				$("#User_Email").val("");
				$("#UsernameID").val("");
				$("#tokenno").val(""); 
            }
            else{
            	$("#emuid").val(ui.item.emuid);
            	$("#User_Name").val(ui.item.value);
            	$("#User_Mobile").val(ui.item.emmobile);
            	$("#User_Email").val(ui.item.ememail);
            	$("#UsernameID").val(ui.item.ememail);
				$("#tokenno").val(ui.item.tokenno);
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

function myFunction() {
	  var x = document.getElementById("User_Password");
	  if (x.type == "password") {
	    x.type = "text";
	  } else {
	    x.type = "password";
	    
	  }
	}
$('.show_psw').click(function(event){
	//event.preventDefault();
	$(this).toggleClass('active');
});

function isExistValue(value){
	var val=document.getElementById(value).value.trim();
	if(val!="")
	$.ajax({
		type : "POST",
		url : "ExistValue111",
		dataType : "HTML",
		data : {"val":val,"field":"ualoginid"},
		success : function(data){
			if(data=="pass"){
				document.getElementById("errorMsg").innerHTML=val +" is already existed !! Please Login to access!!";		
				document.getElementById(value).value="";
				$('.alert-show').show().delay(3000).fadeOut();	
			}		
		}
	});
}

// function checkname(){
// var role = document.getElementById("Role Type").value;
// if(role == "Client"){
// $(function() {
// $("#User_Name").autocomplete({
// source : function(request, response) {
// $.ajax({
// url : "getclientname.html",
// type : "POST",
// dataType : "json",
// data : {
// name : request.term
// },
// success : function(data) {
// response($.map(data, function(item) {
// return {
// label: item.name,
// value: item.value,
// cid: item.cid,
// };}));},
// error: function (error) {
// alert('error: ' + error);
// }});},
// select : function(e, ui) {
// 	$("#emuid").val(ui.item.cid);
// }
// });});}
// else if(role=="Employee") {
// $(function() {
// $("#User_Name").autocomplete({
// source : function(request, response) {
// $.ajax({
// url : "get-employee.html",
// type : "POST",
// dataType : "json",
// data : {
// name : request.term
// },
// success : function(data) {
// response($.map(data, function(item) {
// return {
// label : item.emname,
// value : item.emname,
// emuid : item.emuid,
// };}));},
// error : function(error) {
// alert('error: ' + error);
// }});},
// select : function(e, ui) {
// 	$("#emuid").val(ui.item.emuid);
// }
// });});}
// else if(role=="Super Admin"){
// 	document.getElementById("Company Name").value="NA";
// 	$('#Company Name').prop('readonly', true);
// }
// else if(role=="Administrator"){
// 	$(function() {
// 		$("#Company Name").autocomplete({
// 		source : function(request, response) {
// 		$.ajax({
// 		url : "get-company.html",
// 		type : "POST",
// 		dataType : "json",
// 		data : {
// 		name : request.term
// 		},
// 		success : function(data) {
// 		response($.map(data, function(item) {
// 		return {
// 		label : item.name,
// 		value : item.value,
// 		};}));},
// 		error : function(error) {
// 		alert('error: ' + error);
// 		}});}});});
// }
// }
</script>
</body>
</html>