<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Account Statement</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%
String uid = (String) session.getAttribute("passid");
String[][] getAccountById = Clientmaster_ACT.getAccountByID(uid);
String[][] getAccountStatement = Clientmaster_ACT.getAccountStatement(getAccountById[0][0],0,0);
String runningbalance="0";
try{
	runningbalance=getAccountStatement[0][6];
}
catch(Exception e){}
%>
<%if(!ACC03){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
<div class="container">
<div class="bread-crumb">
<div class="bd-breadcrumb bd-light">
<a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
<a>Account Statement</a>
</div>
</div>
</div>
<div class="main-content">
<div class="container">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="menuDv partner-slider8">
<div class="box-intro">
<h2><span class="title">Account Details</span></h2>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="col-md-3 col-xs-12 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Client Name</p>
</div>
</div>
<div class="col-md-2 col-xs-12 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Client Mobile</p>
</div>
</div>
<div class="col-md-3 col-xs-12 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Client Email</p>
</div>
</div>
<div class="col-md-4 col-xs-12 box-intro-bg">
<div class="box-intro-border">
<p>Description</p>
</div>
</div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="col-md-3 col-xs-12 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getAccountById[0][1] %></p>
</div>
</div>
<div class="col-md-2 col-xs-12 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getAccountById[0][2] %></p>
</div>
</div>
<div class="col-md-3 col-xs-12 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getAccountById[0][3] %></p>
</div>
</div>
<div class="col-md-4 col-xs-12 box-intro-background">
<div class="link-style12">
<p><%=getAccountById[0][4] %></p>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
<div class="row" style="margin-top: 20px;">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="menuDv partner-slider8">
<div class="box-intro">
<h2><span class="title">Account Statement of <%=getAccountById[0][1] %></span></h2>
</div>
<form action="<%=request.getContextPath()%>/addaccountstatement.html" method="Post">
<input type="hidden" name="accountid" value="<%=uid%>" id="accountid" />
<input type="hidden" name="runnbal" value="<%=runningbalance%>" id="runnbal" />
<div class="home-search-form clearfix">
<div class="item-bestsell relative_box col-md-2 col-sm-2 col-xs-12">
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
<p><input type="text" autocomplete="off" name="description" id="description" placeholder="Description" class="form-control"/></p>
</div>
<div id="descriptionErr" class="popup_error"></div>
</div>
<div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
<p><input type="text" autocomplete="off" name="date" id="date" placeholder="Date" class="form-control readonlyAllow" readonly="readonly"/></p>
</div>
<div id="dateErr" class="popup_error"></div>
</div>
<div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
<p><input type="text" autocomplete="off" name="debit" id="debit" placeholder="Debit Amount" class="form-control" onkeypress="return isNumberKey(event)"/></p>
</div>
<div id="debitErr" class="popup_error"></div>
</div>
<div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
<p><input type="text" autocomplete="off" name="credit" id="Credit" placeholder="Credit Amount" class="form-control" onkeypress="return isNumberKey(event)"/></p>
<div id="creditErr" class="popup_error"></div>
</div>

</div>
<div class="pad-top5 item-bestsell col-md-2 col-sm-2 col-xs-12 ">
<input class="btn-link-default bt-radius" type="submit" onclick="return validateCreditDebit()" value="Add"/>
</div>
</div>
</form>
<% if(getAccountStatement.length>0){ %>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="col-xs-3 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Description</p>
</div>
</div>
<div class="col-xs-2 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Date</p>
</div>
</div>
<div class="col-xs-2 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Debit</p>
</div>
</div>
<div class="col-xs-2 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Credit</p>
</div>
</div>
<div class="col-xs-2 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Running Balance</p>
</div>
</div>
<div class="col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p>Action</p>
</div>
</div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="col-xs-9 box-intro-background">
<div class="link-style12">
<p class="news-border"></p>
</div>
</div>
<div class="col-xs-2 box-intro-background">
<div class="link-style12">
<p class="news-border" <% if(runningbalance.contains("-")){ %>style="color:red;"<% } %>><%=runningbalance%> <% if(runningbalance.contains("-")){ %>(DR)<% } else { %>(CR)<% } %></p>
</div>
</div>
<div class="col-xs-1 box-intro-background">
<div class="link-style12">
<p></p>
</div>
</div>
</div>
</div>
</div>
<%
for(int i=0;i<getAccountStatement.length;i++){
%>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="col-xs-3 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getAccountStatement[i][2] %></p>
</div>
</div>
<div class="col-xs-2 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getAccountStatement[i][3] %></p>
</div>
</div>
<div class="col-xs-2 box-intro-background">
<div class="link-style12">
<p class="news-border"><i class="fa fa-inr"></i> <%=getAccountStatement[i][4] %></p>
</div>
</div>
<div class="col-xs-2 box-intro-background">
<div class="link-style12">
<p class="news-border"><i class="fa fa-inr"></i> <%=getAccountStatement[i][5] %></p>
</div>
</div>
<div class="col-xs-2 box-intro-background">
<div class="link-style12">
<p class="news-border" <% if(getAccountStatement[i][6].contains("-")){ %>style="color:red;"<% } %>><i class="fa fa-inr"></i> <%=getAccountStatement[i][6] %></p>
</div>
</div>
<div class="col-xs-1 box-intro-background">
<div class="link-style12">
<p><%if(i==0){%><a href="javascript:void(0);" onclick="deleteAccountStatement(<%=getAccountStatement[i][0]%>);"> Delete</a><%}%></p>
</div>
</div>
</div>
</div>
</div>
<% }} %>
</div>
</div>
</div>
</div>
</div>
</div>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script>
function validateCreditDebit(){
	if(document.getElementById("description").value.trim()==""){
		descriptionErr.innerHTML="Description is required.";
		descriptionErr.style.color="red";
		return false;
	}
	if(document.getElementById("date").value.trim()==""){
		dateErr.innerHTML="Date is required.";
		dateErr.style.color="red";
		return false;
	}
	var debit=document.getElementById("debit").value.trim();
	var credit=document.getElementById("Credit").value.trim();
	
	if(debit==""){
		document.getElementById("debit").value="0";		
		}
	if(credit==""){
		document.getElementById("Credit").value="0";		
		}
	if(Number(debit)>0 && Number(credit)>0){
		creditErr.innerHTML="Debit or Credit at one time.";
		creditErr.style.color="red";
		debitErr.innerHTML="Debit or Credit at one time.";
		debitErr.style.color="red";
		return false;
	}
	if(Number(debit)==0 && Number(credit)==0){
		creditErr.innerHTML="Enter Debit or Credit amount.";
		creditErr.style.color="red";
		debitErr.innerHTML="Enter Debit or Credit amount.";
		debitErr.style.color="red";
		return false;
	}
}

$(function() {
$("#date").datepicker({
changeMonth: true,
changeYear: true,
dateFormat: 'dd-mm-yy',
});
});
function deleteAccountStatement(id) {
if(confirm("Sure you want to Delete this Entry from Account ? "))
{
	$.ajax({
	    type: "POST",
	    dataType: "html",
	    url: "DeleteStatementEntry",
	    data:  { 
	    	"id" : id,
	    },
	    success: function (data) {
	    	location.reload();
	    }
	});
}
}
</script>
</body>
</html>