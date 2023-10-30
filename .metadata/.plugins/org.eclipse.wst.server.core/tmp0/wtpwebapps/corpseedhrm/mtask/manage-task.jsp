<%@page import="admin.task.TaskMaster_ACT"%>
<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Manage Task</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%
String pregpname= (String)session.getAttribute("pregpname");
String taskname= (String)session.getAttribute("taskname");
String assignon= (String)session.getAttribute("assignon");
String deliveron= (String)session.getAttribute("deliveron");
String token = (String) session.getAttribute("uavalidtokenno");
String from = (String) session.getAttribute("from");
String to = (String) session.getAttribute("to");
%>
<%-- <%if(!MT02){%><jsp:forward page="/login.html" /><%} %> --%>
<div id="content">
<div class="main-content">
<div class="container">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="menuDv partner-slider8">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="top_title text-center">
<h2>Manage Task</h2>
</div>
<%-- <%if(AT01){%><a class="add_btn sub-btn1" href="<%=request.getContextPath() %>/assign-task.html">Assign Task</a><%} %> --%>
</div>
</div>
<form name="RefineSearchenqu" action="<%=request.getContextPath()%>/manage-task" method="Post">
<input type="hidden" name="pageName" id="pageName"  value="manageservice.jsp">
<input type="hidden" name="jsstype" id="jsstype">
<div class="home-search-form clearfix">
<div class="item-bestsell box-width9 col-md-2 col-sm-2 col-xs-12">
<div class="input-group">
<%if(pregpname!=null){ %>
<input name="pregpname" id="pregpname" autocomplete="off" value="<%=pregpname %>" class="form-control" placeholder="Enter Project Name">
<% } else{%>
<input name="pregpname" id="pregpname" autocomplete="off" class="form-control" placeholder="Enter Project Name">
<%} %>
</div>
</div>
<div class="item-bestsell box-width9 col-md-2 col-sm-2 col-xs-12">
<div class="input-group">
<%if(taskname!=null){ %>
<input name="taskname" id="taskname" autocomplete="off" value="<%=taskname %>" class="form-control" placeholder="Enter Task Name">
<% } else{%>
<input name="taskname" id="taskname" autocomplete="off" class="form-control" placeholder="Enter Task Name">
<%} %>
</div>
</div>
<div class="item-bestsell box-width9 col-md-2 col-sm-2 col-xs-12">
<div class="input-group">
<%if(assignon!=null){ %>
<input name="assignon" id="assignon" value="<%=assignon %>" class="form-control" placeholder="Enter Assigned On">
<% }else{%>
<input name="assignon" id="assignon" class="form-control" placeholder="Enter Assigned On">
<%} %>
</div>
</div>
<div class="item-bestsell box-width9 col-md-2 col-sm-2 col-xs-12">
<div class="input-group">
<%if(deliveron!=null){ %>
<input name="deliveron" id="deliveron" value="<%=deliveron %>" class="form-control" placeholder="Enter Deliver On">
<% } else{%>
<input name="deliveron" id="deliveron" class="form-control" placeholder="Enter Deliver On">
<%} %>
</div>
</div>
<div class="item-bestsell box-width9 col-md-1 col-sm-1 col-xs-12">
<div class="input-group">
<% if(from!=null){ %>
<p><input type="text" name="from" id="from" value="<%=from%>" placeholder="From" class="form-control searchdate"/></p>
<%}else{ %>
<p><input type="text" name="from" id="from" placeholder="From" class="form-control searchdate"/></p>
<%} %>
</div>
</div>
<div class="item-bestsell box-width9 col-md-1 col-sm-1 col-xs-12">
<div class="input-group">
<% if(to!=null){ %>
<p><input type="text" name="to" id="to" value="<%=to%>" placeholder="To" class="form-control searchdate"/></p>
<%}else{ %>
<p><input type="text" name="to" id="to" placeholder="To" class="form-control searchdate"/></p>
<%} %>
</div>
</div>
<div class="item-bestsell box-width5 col-md-2 col-sm-2 col-xs-12">
<input class="btn-link-default bt-radius" type="button"  value="Search"  onclick="RefineSearchenquiry()"/>
</div>
</div>
</form>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="box-width24 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">SN</p>
</div>
</div>
<div class="box-width15 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Task Name</p>
</div>
</div>
<div class="box-width12 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Assigned By</p>
</div>
</div>
<div class="box-width5 col-xs-12 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Assigned to</p>
</div>
</div>
<div class="box-width8 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Project Name</p>
</div>
</div>
<div class="box-width5 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Assigned On</p>
</div>
</div>
<div class="box-width12 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Deliver On</p>
</div>
</div>
<div class="box-width5 col-xs-3 box-intro-bg">
<div class="box-intro-border">
<p>Action</p>
</div>
</div>
</div>
</div>
</div>
<%
String[][] task=TaskMaster_ACT.getAlltask(pregpname, taskname, assignon, deliveron,token, from, to);
for(int i=0;i<task.length;i++){
String[][] task1=TaskMaster_ACT.getAlltask1(task[i][5]);
// String[][] task2=TaskMaster_ACT.getAlltask2(task[i][6]);
if(i%2==0){
%>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="box-width24 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=task.length-i%></p>
</div>
</div>
<div class="box-width15 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=task[i][1]%>"><%=task[i][1]%></p>
</div>
</div>
<div class="box-width12 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=task1[0][0]%>"><%=task1[0][0]%></p>
</div>
</div>
<div class="box-width5 col-xs-12 box-intro-background">
<div class="link-style12">
<p class="news-border" title=""></p>
</div>
</div>
<div class="box-width8 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=task[i][2]%>"><%=task[i][2]%></p>
</div>
</div>
<div class="box-width5 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=task[i][4]%>"><%=task[i][4]%></p>
</div>
</div>
<div class="box-width12 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=task[i][7]%>"><%=task[i][7]%></p>
</div>
</div>
<div class="box-width5 col-xs-3 box-intro-background">
<div class="link-style12">
<p>
<a href="javascript:void(0);" onclick="vieweditpage(<%=task[i][0] %>);"><i class="fa fa-edit" title="Edit Task"></i></a>
<a href="javascript:void(0);" onclick="approve(<%=task[i][0] %>)"><i class="fa fa-trash" title="Delete Task"></i></a>
</p>
</div>
</div>
</div>
</div>
<%} else{%>
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="list-boxBg clearfix">
<div class="box-width24 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=task.length-i%></p>
</div>
</div>
<div class="box-width15 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=task[i][1]%>"><%=task[i][1]%></p>
</div>
</div>
<div class="box-width12 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=task1[0][0]%>"><%=task1[0][0]%></p>
</div>
</div>
<div class="box-width5 col-xs-12 box-intro-background">
<div class="link-style12">
<p class="news-border" title=""></p>
</div>
</div>
<div class="box-width8 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=task[i][2]%>"><%=task[i][2]%></p>
</div>
</div>
<div class="box-width5 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=task[i][4]%>"><%=task[i][4]%></p>
</div>
</div>
<div class="box-width12 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=task[i][7]%>"><%=task[i][7]%></p>
</div>
</div>
<div class="box-width5 col-xs-3 box-intro-background">
<div class="link-style12">
<p>
<a href="javascript:void(0);" onclick="vieweditpage(<%=task[i][0] %>);"><i class="fa fa-edit" title="Edit Task"></i></a>
<a href="javascript:void(0);" onclick="approve(<%=task[i][0] %>)"><i class="fa fa-trash" title="Delete Task"></i></a>
</p>
</div>
</div>
</div>
</div>
</div>
<%} }%>
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
$(function() {
$("#pregpname").autocomplete({
source: function(request, response) {
$.ajax({
url: "getprojectname.html",
type: "POST",
dataType: "json",
data: {	name: request.term, cid : "NA"},
success: function( data ) {
response( $.map( data, function( item ) {
return {
label: item.name,
value: item.value,
};}));},
error: function (error) {
alert('error: ' + error);
}});},});});
</script>
<script type="text/javascript">
function approve(id) {
if(confirm("Sure you want to Delete this Task ? "))
{
var xhttp;
xhttp = new XMLHttpRequest();
xhttp.onreadystatechange = function() {
if (this.readyState == 4 && this.status == 200) {
location.reload();
}
};
xhttp.open("GET", "<%=request.getContextPath()%>/DeleteTask111?info="+id, true);
xhttp.send();
}
}

function RefineSearchenquiry() {
document.RefineSearchenqu.jsstype.value="SSEqury";
document.RefineSearchenqu.action="<%=request.getContextPath()%>/manage-task.html";
document.RefineSearchenqu.submit();
}

$(function() {
	$("#taskname").autocomplete({
	source: function(request, response) {
	$.ajax({
	url: "gettaskname.html",
	type: "POST",
	dataType: "json",
	data: {	name: request.term},
	success: function( data ) {
	response( $.map( data, function( item ) {
	return {
	label: item.name,
	value: item.value,
	};}));},
	error: function (error) {
	alert('error: ' + error);
	}});}});
	});

</script>
<script>
$( function() {
	$( "#assignon" ).datepicker({
		changeMonth: true,
		changeYear: true,
		dateFormat: 'dd-mm-yy'
	});
} );

$( function() {
	$( "#deliveron" ).datepicker({
		changeMonth: true,
		changeYear: true,
		dateFormat: 'dd-mm-yy'
	});
} );
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
        	window.location = "<%=request.getContextPath()%>/edittask.html";
        },
	});
}
</script>
</body>
</html>