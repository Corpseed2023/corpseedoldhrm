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
<div class="row">
  <div class="col-md-4 col-sm-4 col-xs-12">
   <div class="form-group">
    <label>Company Name</label>
    <div class="input-group">
    <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
    <input type="text" value="<%=companydata[0][3]%>" class="form-control" readonly>
  </div>
 </div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
 <div class="form-group">
  <label>Company Mobile No</label>
  <div class="input-group">
  <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
  <input type="text" value="<%=companydata[0][2]%>" class="form-control" readonly>
   </div>
  </div>
 </div>
<div class="col-md-4 col-sm-4 col-xs-12">
  <div class="form-group">
   <label>Company Email Id</label>
   <div class="input-group">
   <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
   <input type="text" value="<%=companydata[0][4]%>" class="form-control" readonly>
     </div>
   </div>
  </div>
 </div>
<div class="row"> 
   <div class="col-md-12 col-sm-12 col-xs-12">
   <div class="form-group">
    <label>Company Address</label>
    <div class="input-group">
    <span class="input-group-addon"><i class="form-icon sprite info"></i></span>
    <input type="text" value="<%=companydata[0][5]%>" class="form-control" readonly>
          </div>
         </div>
        </div>
</div>
      <div class="row">
        <div class="col-md-4 col-sm-4 col-xs-12">
        <div class="form-group">
          <label>Company Location</label>
          <div class="input-group">
          <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
          <input type="text" value="<%=companydata[0][6]%>" class="form-control" readonly>
  </div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
  <label>Contact Name</label>
  <div class="input-group">
  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
  <input type="text" value="<%=companydata[0][7]%>" class="form-control" readonly>
    </div>
  </div>
  </div>
   <div class="col-md-4 col-sm-4 col-xs-12">
  <div class="form-group">
    <label>Contact Email</label>
    <div class="input-group">
    <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
    <input type="text" value="<%=companydata[0][8]%>" class="form-control" readonly>
    </div>
  </div>
  </div>
</div>
<div class="row">
   <div class="col-md-4 col-sm-4 col-xs-12">
   <div class="form-group">
    <label>Contact Mobile</label>
    <div class="input-group">
    <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
    <input type="text" value="<%=companydata[0][9]%>" class="form-control" readonly>
  </div>
</div>
</div>

<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
  <label>Contact Role</label>
  <div class="input-group">
  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
  <input type="text" value="<%=companydata[0][10]%>" class="form-control" readonly>
  </div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
  <label>PAN</label>
  <div class="input-group">
  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
  <input type="text" class="form-control" value="<%=companydata[0][11]%>" readonly>
     </div>
   </div>
   </div>
</div>
<div class="row">
   <div class="col-md-4 col-sm-4 col-xs-12">
   <div class="form-group">
     <label>GSTIN</label>
     <div class="input-group">
     <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
     <input type="text" class="form-control" value="<%=companydata[0][12]%>" readonly>
  </div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
  <label>State Code</label>
  <div class="input-group">
  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
  <input type="text" class="form-control" value="<%=companydata[0][13]%>" readonly>
    </div>
  </div>
  </div>
  </div>
<div class="row">
  <div class="col-md-6 col-sm-6 col-xs-12 item-product-info">
  <button class="bt-link bt-radius bt-loadmore" onclick="vieweditpage(<%=companydata[0][0]%>,'edit')">Edit<i class="fa fa-paper-plane" aria-hidden="true"></i></button>
                              </div>
  <div class="col-md-6 col-sm-6 col-xs-12 item-product-info">
  <button class="bt-link bt-radius bt-loadmore" onclick="vieweditpage(<%=companydata[0][0]%>,'upload')">Upload Documents<i class="fa fa-paper-plane" aria-hidden="true"></i></button>
                              </div>
                            </div>
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
<script type="text/javascript">
function vieweditpage(id,page){
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/vieweditpage",
	    data:  { 
	    	"uid" : id
	    },
	    success: function (response) {
        	if(page=="upload") window.location = "<%=request.getContextPath()%>/uploadclientdocuments.html";
        	else if(page=="edit") window.location = "<%=request.getContextPath()%>/company-details-edit.html";
        },
	});
}
</script>
</body>
</html>