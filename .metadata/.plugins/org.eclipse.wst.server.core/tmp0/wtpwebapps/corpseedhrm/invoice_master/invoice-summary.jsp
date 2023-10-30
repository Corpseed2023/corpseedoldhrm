<%@page import="company_master.CompanyMaster_ACT"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Invoice Summary</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%
String clientname = (String) session.getAttribute("clientname");
String clientid = (String) session.getAttribute("clientid");
String projectname = (String) session.getAttribute("projectname");
String projectid = (String) session.getAttribute("projectid");
String invoiceno = (String) session.getAttribute("invoiceno");
String month = (String) session.getAttribute("month");
String pstatus = (String) session.getAttribute("pstatus");
String token=(String)session.getAttribute("uavalidtokenno");
String userrole = (String) session.getAttribute("emproleid");
String from = (String) session.getAttribute("from");
String to = (String) session.getAttribute("to");
String[][] getAllInvoiceDetails=Clientmaster_ACT.getAllInvoiceDetails(clientid,projectid,invoiceno,month,pstatus,token, from, to);
%>
<%if(!MB09){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
<div class="container">
<div class="bread-crumb">
<div class="bd-breadcrumb bd-light">
<a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
<a>Invoice Summary</a>
</div>
</div>
</div>
<div class="main-content">
<div class="container">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="menuDv partner-slider8">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="top_title text-center">
<h2>Manage Invoice</h2>
</div>
<%if(MB08){%><a class="add_btn sub-btn1" href="<%=request.getContextPath() %>/generate-invoice.html">Generate Invoice</a><%} %>
</div>
</div>


<form name="RefineSearchenqu" action="<%=request.getContextPath()%>/invoice-summary.html" method="Post">
<input type="hidden" name="pageName" id="pageName"  value="manageservice.jsp">
<input type="hidden" name="jsstype" id="jsstype">
<div class="home-search-form clearfix">
<div class="item-bestsell col-sm-111 col-xs-12" style="width: 12%;">
<div class="input-group">
<% if(clientname!=null){ %>
<p><input type="text" name="clientname" id="clientname" value="<%=clientname%>" autocomplete="off" placeholder="Client" class="form-control"/><input type="hidden" id="clientid" name="clientid" value="<%=clientid%>" /></p>
<%}else{ %>
<p><input type="text" name="clientname" id="clientname" placeholder="Client" autocomplete="off" class="form-control"/><input type="hidden" id="clientid" name="clientid" /></p>
<%} %>
</div>
</div>
<div class="item-bestsell col-sm-111 col-xs-12" style="width: 12%;">
<div class="input-group">
<% if(projectname!=null){ %>
<p><input type="text" name="projectname" id="projectname" autocomplete="off" value="<%=projectname%>" placeholder="Project" class="form-control"/><input type="hidden" id="projectid" name="projectid" value="<%=projectid%>" /></p>
<%}else{ %>
<p><input type="text" name="projectname" id="projectname" autocomplete="off" placeholder="Project" class="form-control"/><input type="hidden" id="projectid" name="projectid" /></p>
<%} %>
</div>
</div>
<div class="item-bestsell col-sm-111 col-xs-12" style="width: 12%;">
<div class="input-group">
<% if(invoiceno!=null){ %>
<p><input type="text" name="invoiceno" id="invoiceno" value="<%=invoiceno%>" placeholder="Invoice No" class="form-control"/></p>
<%}else{ %>
<p><input type="text" name="invoiceno" id="invoiceno" placeholder="Invoice No" class="form-control"/></p>
<%} %>
</div>
</div>
<div class="item-bestsell col-sm-111 col-xs-12" style="width: 12%;">
<div class="input-group">
<p>
<select name="month" id="month" class="form-control">
<% if(month!=null){ %><option value="<%=month%>"><%=month%></option><%} %>
<option value="">Select Month</option>
<option value="January">January</option>
<option value="February">February</option>
<option value="March">March</option>
<option value="April">April</option>
<option value="May">May</option>
<option value="June">June</option>
<option value="July">July</option>
<option value="August">August</option>
<option value="September">September</option>
<option value="October">October</option>
<option value="November">November</option>
<option value="December">December</option>
</select>
</p>
</div>
</div>
<div class="item-bestsell col-sm-111 col-xs-12" style="width: 12%;">
<div class="input-group">
<p><select name="pstatus" id="pstatus" class="form-control"><% if(pstatus!=null){ %><option value="<%=pstatus%>"><%=pstatus%></option><%}%>
<option value="">Select Status</option><option value="Partial">Partial</option><option value="Full">Full</option></select></p>
</div>
</div>	
<div class="item-bestsell col-sm-111 col-xs-12" style="width: 12%;">
<div class="input-group">
<% if(from!=null){ %>
<p><input type="text" name="from" id="from" value="<%=from%>" placeholder="From" class="form-control searchdate"/></p>
<%}else{ %>
<p><input type="text" name="from" id="from" placeholder="From" class="form-control searchdate"/></p>
<%} %>
</div>
</div>
<div class="item-bestsell col-sm-111 col-xs-12" style="width: 12%;">
<div class="input-group">
<% if(to!=null){ %>
<p><input type="text" name="to" id="to" value="<%=to%>" placeholder="To" class="form-control searchdate"/></p>
<%}else{ %>
<p><input type="text" name="to" id="to" placeholder="To" class="form-control searchdate"/></p>
<%} %>
</div>
</div>
<div class="item-bestsell col-sm-111 col-xs-12" style="width: 12%;">
<div class="pad-top5 item-bestsell search-cart-total">
<input class="btn-link-default bt-radius" type="button"  value="Search"  onclick="RefineSearchenquiry()"/>
</div>
</div>
</div>
</form>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="box-width1 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">SN</p>
</div>
</div>
<div class="box-width12 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Client Name</p>
</div>
</div>
<div class="box-width8 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Project Name</p>
</div>
</div>
<div class="box-width20 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Invoice No</p>
</div>
</div>
<div class="box-width20 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Month</p>
</div>
</div>
<div class="box-width20 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">AMT</p>
</div>
</div>
<div class="box-width20 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Due AMT</p>
</div>
</div>
<div class="box-width20 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">B Date</p>
</div>
</div>
<div class="box-width20 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">R Date</p>
</div>
</div>
<div class="box-width20 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Pay Status</p>
</div>
</div>
<div class="box-width8 col-xs-3 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Action</p>
</div>
</div>
<div class="box-width5 col-xs-3 box-intro-bg">
<div class="box-intro-border">
<p>PT</p>
</div>
</div>
</div>
</div>
</div>
<%
for(int i=0;i<getAllInvoiceDetails.length;i++){
	String clientname1 = Clientmaster_ACT.getClientByInvId(getAllInvoiceDetails[i][2]);
	String projectname1 = Clientmaster_ACT.getProjectByInvId(getAllInvoiceDetails[i][3]);
// 	String billingstatus = Clientmaster_ACT.getBillingStatusByInvId(getAllInvoiceDetails[i][3]);
%>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="box-width1 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=i+1%></p>
</div>
</div>
<div class="box-width12 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=clientname1 %></p>
</div>
</div>
<div class="box-width8 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=projectname1 %></p>
</div>
</div>
<div class="box-width20 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getAllInvoiceDetails[i][1] %></p>
</div>
</div>
<div class="box-width20 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getAllInvoiceDetails[i][5] %></p>
</div>
</div>
<div class="box-width20 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getAllInvoiceDetails[i][7] %></p>
</div>
</div>
<div class="box-width20 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getAllInvoiceDetails[i][10] %></p>
</div>
</div>
<div class="box-width20 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getAllInvoiceDetails[i][6] %></p>
</div>
</div>
<div class="box-width20 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getAllInvoiceDetails[i][8] %></p>
</div>
</div>
<div class="box-width20 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getAllInvoiceDetails[i][9] %></p>
</div>
</div>
<div class="box-width8 col-xs-3 box-intro-background">
<div class="link-style12">
<p class="news-border">
<%if(MIN00){ %><a class="quick-view fancybox.ajax" href="<%=request.getContextPath() %>/generate-invoice-payment-<%=getAllInvoiceDetails[i][0]%>.html"><i class="fa fa-rub" title="Generate Payment"></i></a><%} %>
<%if(MIN01){ %><a href="javascript:void(0);" onclick="">view</a><%} %>
<%if(MIN02){ %><a href="javascript:void(0);" onclick="vieweditpage(<%=getAllInvoiceDetails[i][0] %>);"><i class="fa fa-edit" title="Edit"></i></a><%} %>
<%if(MIN03){ %><a href="javascript:void(0)" onclick="approve(<%=getAllInvoiceDetails[i][0]%>)"><i class="fa fa-trash" title="Delete"></i></a><%} %>
</p>
</div>
</div>
<div class="box-width5 col-xs-3 box-intro-background">
<div class="link-style12">
<form action="viewinvoice-<%=i%>-<%=getAllInvoiceDetails[i][0]%>.html" name="print<%=i%>" id="print<%=i%>" method="post">
<% String[][] company = CompanyMaster_ACT.getAllCompany(token, userrole, "NA", "NA", "NA"); %>
<select name="cmid<%=i%>" id="cmid<%=i%>" style="width: 66%;">
<option value="">Select Company</option>
<% for(int j=0;j<company.length;j++){ %>
<option value="<%=company[j][0]%>"><%=company[j][1]%></option>
<% } %>
</select>
<input type="submit" value="PT" onclick="return checkCompany(<%=i%>);">
</form>
</div>
</div>
</div>
</div>
</div>
<% }%>
</div>
</div>
</div>
</div>
</div>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>
</div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
function approve(id) {
if(confirm("Sure you want to Delete this Invoice ? "))
{
var xhttp;
xhttp = new XMLHttpRequest();
xhttp.onreadystatechange = function() {
if (this.readyState == 4 && this.status == 200) {
location.reload();
}
};
xhttp.open("GET", "<%=request.getContextPath()%>/DeleteInvoice111?info="+id, true);
xhttp.send();
}
}
function checkCompany(id){
if(document.getElementById('cmid'+id).value==""){
document.getElementById('cmid'+id).style.color="red";
return false;
}
}
function RefineSearchenquiry() {
	document.RefineSearchenqu.jsstype.value="SSEqury";
	document.RefineSearchenqu.action="<%=request.getContextPath()%>/invoice-summary.html";
	document.RefineSearchenqu.submit();
	}
</script>
<script>
	$(function() {
		$("#clientname").autocomplete({
			source: function(request, response) {
			$.ajax({
			url: "getclientname.html",
		    type: "POST",
			dataType: "json",
			data: {	name: request.term},
			success: function( data ) {			
			response( $.map( data, function( item ) {
				return {
					label: item.name,
					value: item.value,
					id: item.id,
			};}));},
			error: function (error) {
		       alert('error: ' + error);
		    }});},
			select : function(e, ui) {
		    	$("#clientid").val(ui.item.id);
			},});
		});
	$(function() {
		$("#projectname").autocomplete({
			source: function(request, response) {
			$.ajax({
			url: "getprojectname.html",
		    type: "POST",
			dataType: "json",
			data: {	name: request.term, cid: document.getElementById("clientid").value},
			success: function( data ) {			
			response( $.map( data, function( item ) {
				return {
					label: item.name,
					value: item.value,
					id: item.id,
			};}));},
			error: function (error) {
		       alert('error: ' + error);
		    }});},
			select : function(e, ui) {
		    	$("#projectid").val(ui.item.id);
			},});
		});
	</script>
	<script type="text/javascript">
function vieweditpage(id){
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/vieweditpage",
	    data:  { 
	    	"uid" : id
	    },
	    success: function (response) {
        	window.location = "<%=request.getContextPath()%>/editinvoice.html";
        },
	});
}
</script>
</body>
</html>