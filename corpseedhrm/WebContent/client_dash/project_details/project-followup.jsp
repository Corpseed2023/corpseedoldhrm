<%@page import="Company_Login.CompanyLogin_ACT"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Follow Up Project</title>
<%@ include file="../../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<%@ include file="../../staticresources/includes/itswsheaderclient.jsp" %>
<%
String token = (String) session.getAttribute("uavalidtokenno");
String uid = (String) session.getAttribute("passid");
String[][] getProjectById = Clientmaster_ACT.getProjectByID(uid,token);
String[][] getFollowUpById = CompanyLogin_ACT.getProjectFollowUpById(getProjectById[0][0]);
%>
<div id="content">
<div class="main-content">
<div class="container">
<div class="row">
<div class="col-md-7 col-sm-7 col-xs-12">
<div class="menuDv partner-slider8">
<div class="box-intro">
<h2><span class="title">Project Details</span></h2>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="col-xs-4 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Project Name</p>
</div>
</div>
<div class="col-xs-3 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Project Type</p>
</div>
</div>
<div class="col-xs-3 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Starting Date</p>
</div>
</div>
<div class="col-xs-2 box-intro-bg">
<div class="box-intro-border">
<p>Remarks</p>
</div>
</div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="col-xs-4 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getProjectById[0][2] %></p>
</div>
</div>
<div class="col-xs-3 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getProjectById[0][3] %></p>
</div>
</div>
<div class="col-xs-3 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getProjectById[0][4] %></p>
</div>
</div>
<div class="col-xs-2 box-intro-background">
<div class="link-style12">
<p><a href="#showremarks" class="quick-view" onclick="datahere.innerHTML='<%=getProjectById[0][9]%>';"><i class="fa fa-bars"></i></a></p>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
<% if(getFollowUpById.length>0){ %>
<div class="menuDv partner-slider8" style="margin-top: 20px;">
<div class="box-intro">
<h2><span class="title">Follow Up Project</span></h2>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="col-xs-3 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Status</p>
</div>
</div>
<div class="col-xs-3 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Follow Up Date</p>
</div>
</div>
<div class="col-xs-3 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Delivery Date</p>
</div>
</div>
<div class="col-xs-2 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Remarks</p>
</div>
</div>
<div class="col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p>Doc</p>
</div>
</div>
</div>
</div>
</div>
<%
for(int i=0;i<getFollowUpById.length;i++){
	String docname = CompanyLogin_ACT.getDocumentNameForProjectFollowUp(getFollowUpById[i][0]);
%>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="col-xs-3 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getFollowUpById[i][2] %></p>
</div>
</div>
<div class="col-xs-3 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getFollowUpById[i][3] %></p>
</div>
</div>
<div class="col-xs-3 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getFollowUpById[i][4] %></p>
</div>
</div>
<div class="col-xs-2 box-intro-background">
<div class="link-style12">
<p class="news-border"><a onclick="$('#showdata<%=i%>').slideToggle();"><i class="fa fa-arrow-down"></i></a></p>
</div>
</div>
<div class="col-xs-1 box-intro-background">
<div class="link-style12">
<p><% if(!docname.equals("")){ %><a href="<%=request.getContextPath()%>/documents/projectfollowup/<%=docname%>" download><i class="fa fa-eye"></i></a><% } %></p>
</div>
</div>
</div>
</div>
</div>
<div class="row" id="showdata<%=i%>" style="display: none;">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="col-xs-12 box-intro-background">
<div class="link-style12">
<%=getFollowUpById[i][5]%>
</div>
</div>
</div>
</div>
</div>
<% } %>
</div>
<% } %>
</div>
<div class="col-md-5 col-sm-5 col-xs-12">
<div class="menuDv partner-slider8">
<div class="box-intro">
<h2><span class="title">Follow Up Project</span></h2>
</div>
<div class="clearfix">
<form action="projectnewfollowup.html" method="post" name="follow-up-form" enctype="multipart/form-data">
<input type="hidden" name="pfupid" id="pfupid" value="<%=getProjectById[0][0]%>" readonly>
<input type="hidden" name="pfupname" id="pfupname" value="<%=getProjectById[0][2].replace(" ", "").toUpperCase()%>" readonly>
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix footer-bottom2">
<div class="col-xs-4 box-intro-background" style="display: none;">
<div class="add-enquery">
<input type="hidden" name="pfustatus" id="pfustatus" class="form-control" value="Working" />
</div>
</div>
<div class="col-xs-4 box-intro-background" style="display: none;">
<div class="add-enquery">
<input type="hidden" name="followupby" id="followupby" class="form-control" value="Client" />
</div>
</div>
<div class="col-xs-4 box-intro-background" style="display: none;">
<div class="add-enquery">
<input type="text" name="pfuato" id="pfuato" placeholder="Assign Project To?" class="form-control">
<input type="hidden" name="pfuatoid" id="pfuatoid" style="display: none;">
</div>
</div>
<div class="col-xs-6 box-intro-background">
<div class="add-enquery">
<select name="pfuchanges" id="pfuchanges" class="form-control"><option>New Changes</option><option>Bugs</option></select>
</div>
</div>
<div class="col-xs-6 box-intro-background">
<div class="add-enquery">
<input type="text" name="pfudate" id="pfudate" placeholder="Date of Follow Up" class="form-control">
</div>
</div>
<div class="col-xs-4 box-intro-background" style="display: none;">
<div class="add-enquery">
<input type="text" name="pfuddate" id="pfuddate" placeholder="Date of Delivery" class="form-control" value="NA">
</div>
</div>
<div class="col-xs-4 box-intro-background" style="display: none;">
<div class="add-enquery">
<input type="hidden" name="showclient" id="showclient" class="form-control" value="1" />
</div>
</div>
<div class="col-xs-12 box-intro-background">
<div class="add-enquery">
<textarea name="pfuremark" id="pfuremark" class="form-control"></textarea>
</div>
</div>
<div class="col-xs-6 box-intro-background">
<div class="add-enquery">
<button type="button" class="bt-link bt-radius" onclick="$('#uploadyes').toggle();">Upload Image ?</button>
</div>
</div>
<div class="col-xs-6 box-intro-background" id="uploadyes" style="display: none;">
<div class="add-enquery">
<input type="file" name="files" id="files" class="form-control" accept="application/pdf, image/*" />
</div>
</div>
<div class="col-xs-12 box-intro-background">
<div class="item-product-info">
<div id="MakeEerorMSGdiv1" class="errormsg"></div>
<button type="submit" class="bt-link bt-radius bt-loadmore" onclick="return statusValidations();">Add</button>
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
<%@ include file="../../staticresources/includes/itswsfooter.jsp" %>
<%@ include file="../../staticresources/includes/itswsscripts.jsp" %>
<script>
$(function() {
	$("#pfudate").datepicker({
	    changeMonth : true,
	    changeYear : true,
	    dateFormat : 'dd-mm-yy',
	}).datepicker("setDate", new Date());
});
function statusValidations() {
	if (document.getElementById('pfuatoid').value == ""
		|| document.getElementById('pfuato').value == "") {
	    document.getElementById('pfuatoid').value = "Pending";
	    document.getElementById('pfuato').value = "Pending";
	}
	if (document.getElementById('pfudate').value == "") {
	    document.getElementById('pfudate').style.border = "1px solid red";
	    return false;
	} else {
	    document.getElementById('pfudate').style.border = "1px solid #ccc";
	}
}
bkLib.onDomLoaded(function() {
	nicEditors.editors.push(new nicEditor().panelInstance(document.getElementById('pfuremark')));
});
</script>
<div id="showremarks" style="display: none; width: 700px; max-height: 400px; overflow-x: hidden; overflow-y: auto;">
<div class="container">
<p id="datahere"></p>
</div>
</div>
</body>
</html>