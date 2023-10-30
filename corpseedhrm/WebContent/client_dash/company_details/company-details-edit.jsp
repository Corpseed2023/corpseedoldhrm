<!DOCTYPE HTML>
<%@page import="Company_Login.CompanyLogin_ACT"%>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title>Company Details</title>
	<%@ include file="../../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
	<%@ include file="../../staticresources/includes/itswsheaderclient.jsp" %>
	<%
String uaname = (String)session.getAttribute("uaname");
String companydata[][] = CompanyLogin_ACT.getCompanyDetailsByLoginName(uaname);
%>	
	<!-- End Header -->
    
	<div id="content">
		<div class="container">   
          <div class="bread-crumb">
            <div class="bd-breadcrumb bd-light">
            <a href="">Home</a>
            <a>Company Details</a>
            </div>
          </div>
        </div>

		<div class="main-content">
			<div class="container">
				<div class="row">
                	<div class="col-xs-12">
                        <div class="menuDv  post-slider">
                            <form action="company-details-update.html" method="post">
                             <input type="hidden" name="uid" value="<%=companydata[0][0]%>">
                              <div class="row">
                                <div class="col-md-4 col-sm-4 col-xs-12">
                                 <div class="form-group">
                                  <label>Company Name</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
                                  <input type="text" name="clientName" id="Client Name" value="<%=companydata[0][3]%>"placeholder="Enter Client Name" onblur="requiredFieldValidation('Client Name','ClientNameEerorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="ClientNameEerorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>
                                <div class="col-md-4 col-sm-4 col-xs-12">
                                 <div class="form-group">
                                  <label>Company Mobile No</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
                                  <input type="text" name="ClientMobile" id="Client Mobile"value="<%=companydata[0][2]%>" placeholder="Enter Mobile No" onblur="requiredFieldValidation('Client Mobile','ClientMobileEerorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="ClientMobileEerorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>
                               <div class="col-md-4 col-sm-4 col-xs-12">
                                 <div class="form-group">
                                  <label>Company Email Id</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
                                  <input type="text" name="ClientEmail" id="Client Email"value="<%=companydata[0][4]%>" placeholder="Enter Email Id" onblur="requiredFieldValidation('Client Email','ClientEmailEerorMSGdiv');" class="form-control">
                                   </div>
                                   <div id="ClientEmailEerorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>
                               </div>
                              <div class="row"> 
                                 <div class="col-md-12 col-sm-12 col-xs-12">
                                 <div class="form-group">
                                  <label>Company Address</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite info"></i></span>
                                  <input type="text" name="ClientAddress" id="Client Address"value="<%=companydata[0][5]%>" placeholder="Enter Client Address" onblur="requiredFieldValidation('Client Address','ClientAddressEerorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="ClientAddressEerorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>
                      		</div>
                              <div class="row">
                                <div class="col-md-4 col-sm-4 col-xs-12">
                                <div class="form-group">
                                  <label>Company Location</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" name="CompanyLocation" id="Company Location" value="<%=companydata[0][6]%>"placeholder="Enter Company Location" onblur="requiredFieldValidation('Company Location','CompanyLocationEerorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="CompanyLocationEerorMSGdiv" class="errormsg"></div>
                                </div>
                                </div>
                                <div class="col-md-4 col-sm-4 col-xs-12">
                                <div class="form-group">
                                  <label>Contact Name</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" name="ContactName" id="Contact Name" value="<%=companydata[0][7]%>"placeholder="Enter Contact Name" onblur="requiredFieldValidation('Contact Name','ContactNameEerorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="ContactNameEerorMSGdiv" class="errormsg"></div>
                                </div>
                                </div>
                                 <div class="col-md-4 col-sm-4 col-xs-12">
                                <div class="form-group">
                                  <label>Contact Email</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
                                  <input type="text" name="ContactEmail" id="Contact Email" value="<%=companydata[0][8]%>"placeholder="Enter Contact Email" onblur="requiredFieldValidation('Contact Email','ContactEmailEerorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="ContactEmailEerorMSGdiv" class="errormsg"></div>
                                </div>
                                </div>
                              </div>
                              <div class="row">
                                 <div class="col-md-4 col-sm-4 col-xs-12">
                                 <div class="form-group">
                                  <label>Contact Mobile</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" name="ContactMobile" id="Contact Mobile" value="<%=companydata[0][9]%>"placeholder="Enter Company Mobile" onblur="requiredFieldValidation('Contact Mobile','ContactMobileEerorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="ContactMobileEerorMSGdiv" class="errormsg"></div>
                                </div>
                                </div>
                             
                                <div class="col-md-4 col-sm-4 col-xs-12">
                                <div class="form-group">
                                  <label>Contact Role</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" name="ContactRole" id="Contact Role" value="<%=companydata[0][10]%>"placeholder="Enter Company Role" onblur="requiredFieldValidation('Contact Role','ContactRoleEerorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="ContactRoleEerorMSGdiv" class="errormsg"></div>
                                </div>
                                </div>
                                <div class="col-md-4 col-sm-4 col-xs-12">
                                <div class="form-group">
                                  <label>PAN</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" name="PAN" id="PAN" placeholder="Enter PAN" onblur="requiredFieldValidation('PAN','PANEerorMSGdiv');" class="form-control" value="<%=companydata[0][11]%>">
                                  </div>
                                  <div id="PANEerorMSGdiv" class="errormsg"></div>
                                </div>
                                </div>
                             </div>
                             <div class="row">
                                <div class="col-md-4 col-sm-4 col-xs-12">
                                <div class="form-group">
                                  <label>GSTIN</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" name="GSTIN" id="GSTIN" placeholder="Enter GSTIN" onblur="requiredFieldValidation('GSTIN','GSTINEerorMSGdiv');" class="form-control" value="<%=companydata[0][12]%>">
                                  </div>
                                  <div id="GSTINEerorMSGdiv" class="errormsg"></div>
                                </div>
                                </div>
                                <div class="col-md-4 col-sm-4 col-xs-12">
                                <div class="form-group">
                                  <label>State Code</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" name="statecode" id="State Code" placeholder="Enter State Code" onblur="requiredFieldValidation('State Code','StateCodeEerorMSGdiv');" class="form-control" value="<%=companydata[0][13]%>">
                                  </div>
                                  <div id="StateCodeEerorMSGdiv" class="errormsg"></div>
                                </div>
                                </div>
                                </div>
                              <div class="row">
                                <div class="col-md-12 col-sm-12 col-xs-12 item-product-info">
                                <button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return registerClient()">Update<i class="fa fa-paper-plane" aria-hidden="true"></i></button>
                                </div>
                              </div>
                            </form>
                        </div>
					</div>
				</div>
			</div>
		</div>
		<!-- End Advert -->
	</div>
	<!-- End Content -->
	<%@ include file="../../staticresources/includes/itswsfooter.jsp" %>
	<!-- End Footer -->
</div>	
	<%@ include file="../../staticresources/includes/itswsscripts.jsp" %>
</body>
</html>