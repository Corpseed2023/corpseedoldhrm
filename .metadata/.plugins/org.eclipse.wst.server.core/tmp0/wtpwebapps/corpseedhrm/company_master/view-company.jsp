<!DOCTYPE HTML>
<%@ include file="../../madministrator/checkvalid_user.jsp" %>
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

<%
String url = request.getParameter("uid");
String[] a=url.split(".html");
String[] b=a[0].split("-");
String compuid=b[1];
String[][] getCompanyByID=CompanyMaster_ACT.getCompanyByID(compuid);
String[][] getKey=CompanyMaster_ACT.getKey(getCompanyByID[0][14]);
%>

<div id="content">

<div class="main-content">
<div class="container">
<div class="row">
<div class="col-xs-12">
<div class="menuDv  post-slider">
<form action="update-company.html" method="post" name="registeruserClient" id="registeruserClient">
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Company ID :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="CompanyID" id="Company ID" title="<%=getCompanyByID[0][1]%>" value="<%=getCompanyByID[0][1]%>" readonly class="form-control">
</div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Company Name:<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-user"></i></span>
<input type="text" name="CompanyName" id="Company Name" title="<%=getCompanyByID[0][2]%>" value="<%=getCompanyByID[0][2]%>" placeholder="Enter Company Name" class="form-control" readonly>
</div>
<div id="CompanyNameEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Mobile No. :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-mobile"></i></span>
<input type="text" name="mobile" id="Mobile" placeholder="Enter Mobile No." title="<%=getCompanyByID[0][12]%>" value="<%=getCompanyByID[0][12]%>" maxlength="10" class="form-control" readonly>
</div>
<div id="mobileEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Email Id :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-at"></i></span>
<input type="text" name="email" id="Email" placeholder="Enter Email Id" title="<%=getCompanyByID[0][13]%>" value="<%=getCompanyByID[0][13]%>" class="form-control" readonly>
</div>
<div id="emailEerorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Company's Address:<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="CompanyAddress" id="Company Address" title="<%=getCompanyByID[0][3]%>" value="<%=getCompanyByID[0][3]%>" placeholder="Enter Company Address" class="form-control" readonly>
</div>
<div id="CompanyAddressEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>PAN:<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="PAN" id="PAN" placeholder="Enter PAN" maxlength="10" title="<%=getCompanyByID[0][4]%>" value="<%=getCompanyByID[0][4]%>" class="form-control" readonly>
</div>
<div id="PANEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>GSTIN:<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="GSTIN" id="GSTIN" placeholder="Enter GSTIN" title="<%=getCompanyByID[0][5]%>" value="<%=getCompanyByID[0][5]%>" class="form-control" readonly>
</div>
<div id="GSTINEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>State Code:<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="statecode" id="State Code" placeholder="Enter State Code" title="<%=getCompanyByID[0][6]%>" value="<%=getCompanyByID[0][6]%>" class="form-control" readonly>
</div>
<div id="StateCodeEerorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Bank's Name:<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-bank"></i></span>
<input type="text" name="BankName" id="Bank Name" placeholder="Enter Bank Name" title="<%=getCompanyByID[0][7]%>" value="<%=getCompanyByID[0][7]%>" class="form-control" readonly>
</div>
<div id="BankNameEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Account Holder's Name :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-user"></i></span>
<input type="text" name="AccountName" id="Account Name" placeholder="Enter Account Name" title="<%=getCompanyByID[0][11]%>" value="<%=getCompanyByID[0][11]%>" class="form-control" readonly>
</div>
<div id="AccountNameEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Bank A/C No:<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="BankACNo" id="Bank AC No" placeholder="Enter Bank Account Number" title="<%=getCompanyByID[0][8]%>" value="<%=getCompanyByID[0][8]%>" class="form-control" readonly>
</div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>IFSC Code:<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="BankIFSCCode" id="Bank IFSC Code" placeholder="Enter Bank IFSC Code" title="<%=getCompanyByID[0][9]%>" value="<%=getCompanyByID[0][9]%>" class="form-control" readonly>
</div>

</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group">
<label>Bank's Address:<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="BankAddress" id="Bank Address" placeholder="Enter Bank Address" title="<%=getCompanyByID[0][10]%>" value="<%=getCompanyByID[0][10]%>" class="form-control" readonly>
</div>
</div>
</div>
</div>

<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group text-center">
<h3><strong>Initial Codes of Table <span style="color: red;">*</span></strong></h3>
<span style="font-size: 12px;color: red;">(Max 2 Characters.)</span>
<hr>
</div>
</div>
</div>

<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Employee's Key :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="employeekey" maxlength="2" id="Employee Key" value="<%=getKey[0][0] %>" class="form-control" readonly>
</div>

</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>GST Invoice's Key :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="gstinvoice" maxlength="2" id="GST Invoice Key" value="<%=getKey[0][1] %>" class="form-control" readonly>
</div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Client's Key :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="clientkey" maxlength="2" id="Client Key" value="<%=getKey[0][2] %>" placeholder="Enter Client Table's key" class="form-control" readonly>
</div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Project's Key :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="projectkey" maxlength="2" id="Project Key" value="<%=getKey[0][3] %>" placeholder="Enter Project's Key" class="form-control"  readonly="readonly">
</div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Billing's Key :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="billingkey" maxlength="2" id="Billing Key" value="<%=getKey[0][4] %>" placeholder="Enter Billing Key" class="form-control" readonly>
</div>

</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Task's Key :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="taskkey" maxlength="2" id="Task Key" value="<%=getKey[0][5] %>" placeholder="Enter Task key" class="form-control" readonly>
</div>

</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Enquiry's Key :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="enquirykey" maxlength="2" id="Enquiry Key" value="<%=getKey[0][6] %>" placeholder="Enter Enquiry's Key" class="form-control" readonly>
</div>

</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Non GST Invoice Key :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="nongstinvoicekey" maxlength="2" id="Non GST Invoice Key" value="<%=getKey[0][7] %>" placeholder="Enter Non GST Invoice Key" class="form-control" readonly>
</div>

</div>
</div>
</div>
</form>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>

</body>
</html>
