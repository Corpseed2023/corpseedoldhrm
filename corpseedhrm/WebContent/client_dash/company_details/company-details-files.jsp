<!DOCTYPE HTML>
<%@page import="admin.master.Usermaster_ACT"%>

<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Upload Documents</title>
<%@ include file="../../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div class="wrap">
<%@ include file="../../staticresources/includes/itswsheaderclient.jsp" %>
<%String passid = (String) session.getAttribute("passid");%>
<div id="content">
<div class="container">
<div class="bread-crumb">
<div class="bd-breadcrumb bd-light">
<a href="">Home</a>
<a>Upload Documents</a>
</div>
</div>
</div>
<div class="main-content">
<div class="container">
<div class="row">
<div class="col-xs-8">
<div class="menuDv post-slider">
<form action="<%=request.getContextPath()%>/uploadedclientdocuments.html" method="post" name="uploaddocuments" id="uploaddocuments" enctype="multipart/form-data">
<input type="hidden" name="type" value="client" id="type" />
<input type="hidden" name="passid" value="<%=passid%>" id="passid" />
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
<label>File Name</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
<input type="text" name="companyregistrationfilename" id="File Name 1" placeholder="Enter File Name" class="form-control" autocomplete="off" readonly="readonly" value="Company Registration" />
</div>
<div id="FileNameError" class="errormsg"></div>
</div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
<label>Select File</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
<input type="file" name="companyregistrationfile" id="File 1" class="form-control" accept="application/pdf, image/*">
</div>
<div id="File1Error" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
<label>File Name</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
<input type="text" name="panfilename" id="File Name 2" placeholder="Enter File Name" class="form-control" autocomplete="off" readonly="readonly" value="PAN Card" />
</div>
<div id="FileNameError" class="errormsg"></div>
</div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
<label>Select File</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
<input type="file" name="panfile" id="File 2" class="form-control" accept="application/pdf, image/*">
</div>
<div id="File2Error" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
<label>File Name</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
<input type="text" name="aadharfilename" id="File Name 3" placeholder="Enter File Name" class="form-control" autocomplete="off" readonly="readonly" value="Aadhar Card" />
</div>
<div id="FileNameError" class="errormsg"></div>
</div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
<label>Select File</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
<input type="file" name="aadharfile" id="File 3" class="form-control" accept="application/pdf, image/*">
</div>
<div id="File3Error" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
<label>File Name</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
<input type="text" name="chequefilename" id="File Name 4" placeholder="Enter File Name" class="form-control" autocomplete="off" readonly="readonly" value="Cancelled Cheque Copy" />
</div>
<div id="FileNameError" class="errormsg"></div>
</div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
<label>Select File</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
<input type="file" name="chequefile" id="File 4" class="form-control" accept="application/pdf, image/*">
</div>
<div id="File4Error" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12 item-product-info">
<input type="submit" value="Upload" class="bt-link bt-radius bt-loadmore" onclick="return validateimage();">
</div>
</div>
</form>
<script type="text/javascript">
function validateimage(){
	if (document.getElementById('File 1').value == "") {
		File1Error.innerHTML = "File is required.";
		File1Error.style.color = "#800606";
		return false;
	}
	if (document.getElementById('File 2').value == "") {
		File2.innerHTML = "File is required.";
		File2.style.color = "#800606";
		return false;
	}
	if (document.getElementById('File 3').value == "") {
		File3.innerHTML = "File is required.";
		File3.style.color = "#800606";
		return false;
	}
	if (document.getElementById('File 4').value == "") {
		File4.innerHTML = "File is required.";
		File4.style.color = "#800606";
		return false;
	}
}
</script>
</div>
</div>

<div class="col-xs-4">
<div class="menuDv post-slider">
<% String[][] documents = Usermaster_ACT.getDocuments("Client", passid);
	for(int i=0;i<documents.length;i++){ %>
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<label>File Name : </label>
<%=documents[i][3]%>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<a onclick="window.open('<%=request.getContextPath()%>/documents/client/<%=documents[i][4]%>', '<%=documents[i][3]%>', 'location=no,scrollbars=yes,status=no,toolbar=yes,resizable=yes,width=600,height=600')"><i class="fa fa-eye"></i></a>
<a onclick="deletefile(<%=documents[i][0]%>);"><i class="fa fa-trash-o"></i></a>
</div>
</div>
<% } %>
</div>
</div>

</div>
</div>
</div>
</div>
<%@ include file="../../staticresources/includes/itswsfooter.jsp" %>
</div>
<%@ include file="../../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
function deletefile(id){
	if(confirm("Are you sure you want to delete this file?")){
		$.ajax({
		    type: "POST",
		    url: "<%=request.getContextPath()%>/deletedocument",
		    data:  { 
		    	"id" : id
		    },
		    success: function (response) {
	        	location.reload();
	        },
		});
	}
}
</script>
</body>
</html>