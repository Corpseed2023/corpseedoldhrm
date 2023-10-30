<%@page import="admin.seo.SeoOnPage_ACT"%>


<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Content Detail</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%String landingpage_basepath = request.getContextPath();
String addedby= (String)session.getAttribute("loginuID");
String loginuaid = (String)session.getAttribute("loginuaid");
String userroll= (String)session.getAttribute("emproleid");
String token=(String)session.getAttribute("uavalidtokenno");
String activity[][] = SeoOnPage_ACT.getActivityByID();
String[][] project=SeoOnPage_ACT.getAssignedProject(loginuaid,userroll,token);
%>
<%if(!MS05){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
<div class="container">
<div class="bread-crumb">
<div class="bd-breadcrumb bd-light">
<a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
<a>Content Detail</a>
</div>
</div>
</div>

<div class="main-content">
<div class="container">
<div class="row">

<div class="col-md-7 col-sm-7 col-xs-12">
<div class="menuDv post-slider clearfix">
<form action="savecontent.html" method="post" name="addcontent" id="addcontent">
<input type="hidden" name="addedbyuser" value="<%=addedby%>">
<div class="row">
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>Project's Name</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
<select id="Project_Name" name="ProjectName" onblur="requiredFieldValidation('Project_Name','ProjectNameErrorMSGdiv');"class="form-control" onchange="getTask(this.value)">
<option value="">Select Project</option>
<%for(int i=0;i<project.length;i++){ %>
<option value="<%=project[i][0]%>-<%=project[i][2]%>"><%=project[i][1]%></option>
<%} %>
</select>
</div>
<div id="ProjectNameErrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>Task's Name</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite list"></i></span>
<select id="Task_Name" name="taskname" onblur="requiredFieldValidation('Task_Name','tasknameErrorMSGdiv');"class="form-control"  onchange="setTaskDetails(this.value)">
<option value="">Select Task</option>
</select>
</div>
<div id="tasknameErrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
<label>Activity Type</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite list"></i></span>
<select name="activitytype" id="activitytype" class="form-control">
    <option value="">Select an Activity</option>
    <%for(int i=0;i<activity.length;i++){%>       
            <option value="<%=activity[i][1] %>"><%=activity[i][0]%></option>        
<%}%>
</select>
</div>
<div id="activitytypeErrorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group">
<label>Content</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite edit-top"></i></span>
<textarea class="form-control" name="content" id="Content" placeholder="Content" rows="6" onblur="requiredFieldValidation('Content','ContentErrorMSGdiv');"></textarea>
</div>
<div id="ContentErrorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
<label>No. Of Words</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input class="form-control readonlyAllow" type="text" name="noofword" id="noofword" readonly />
</div>
</div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
<label>Status </label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-industry"></i></span>
<select id="Status" name="status" onblur="requiredFieldValidation('Status','StatusErrorMSGdiv');"class="form-control">
<option value="">Select Status</option>
<option value="Inreview">Inreview</option>
<option value="Approved">Approved</option>
</select>
</div>
<div id="StatusErrorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12 item-product-info">
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return contentsubmit();">Submit<i class="fa fa-paper-plane" aria-hidden="true"></i></button>
</div>
</div>
</form>
</div>
</div>

<div class="mini-cart-total col-md-5 col-sm-5 col-xs-12">
<div id="target">
<div class="menuDv">
<div class="inner-bestsell">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="widget widget-category">
<ul>
<li><a class="link">Assigned On -</a> <span id="idassign"></span></li>
<li><a class="link">Deliver On -</a> <span id="iddeliver"></span></li>
<li><a class="link">Remark -</a> <span id="idremark"></span></li>
</ul>
</div>
</div>
</div>
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
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
<!-- End Footer -->
</div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
function setTaskDetails(aid){
	$.ajax({
		type : "POST",
		url : "SetTaskDetails111",
		dataType : "HTML",
		data : {				
			"aid":aid,
		},
		success : function(data){
			var x=data.split("@");
			document.getElementById("idassign").innerHTML=x[0];
			document.getElementById("iddeliver").innerHTML=x[1];
			document.getElementById("idremark").innerHTML=x[2];
		}
	});
}
function getTask(aid){
	var x=aid.split("-");
	aid=x[0];
	if(aid!="")
	$.ajax({
		type : "POST",
		url : "SetTaskId111",
		dataType : "HTML",
		data : {				
			"aid":aid,
		},
		success : function(response){
			response = JSON.parse(response);			
			 var len = response.length;
			    $("#Task_Name").empty();
			    $("#Task_Name").append("<option value=''>"+"Select Task"+"</option>");
				for( var i =0; i<len; i++){
				var id = response[i]['id'];
				var name = response[i]['value'];
				$("#Task_Name").append("<option value='"+id+"'>"+name+"</option>");
				}
		}
	});else{
		$("#Task_Name").empty();
	    $("#Task_Name").append("<option value=''>"+"Select Task"+"</option>");	   
	}
}
function contentsubmit()
{
	if(document.getElementById('Project_Name').value.trim()=="" ) {
		ProjectNameErrorMSGdiv.innerHTML="Select Project";
		ProjectNameErrorMSGdiv.style.color="#800606";
		return false;
		}
	if(document.getElementById('Task_Name').value.trim()=="" ) {
		tasknameErrorMSGdiv.innerHTML="Select Task";
		tasknameErrorMSGdiv.style.color="#800606";
		return false;
		} 	
	if(document.getElementById('activitytype').value.trim()=="" ) {
		activitytypeErrorMSGdiv.innerHTML="Select An Activity";
		activitytypeErrorMSGdiv.style.color="#800606";
		return false;
		}
var data = $('#addcontent').find('.nicEdit-main').text();
if(data.trim()=="")  {
ContentErrorMSGdiv.innerHTML="Content  is required.";
ContentErrorMSGdiv.style.color="#800606";
return false;
}
if(document.getElementById('Status').value.trim()=="") {
StatusErrorMSGdiv.innerHTML="Status is required.";
StatusErrorMSGdiv.style.color="#800606";
return false;
}

// document.addcontent.submit();
}

$(function() {
$("#Project_Name").autocomplete({
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
id: item.id,
};}));},
error: function (error) {
alert('error: ' + error);
}});},
select : function(e, ui) {
$("#pid").val(ui.item.id);
},});
});

function approve1() {
var info=document.getElementById('pid').value;
if(info=="")
{
idassign.innerHTML="";
iddeliver.innerHTML="";
idremark.innerHTML="";
return false;
}
else
{
var seoid=info;
var xhttp;
xhttp = new XMLHttpRequest();
xhttp.onreadystatechange = function() {
if (this.readyState == 4 && this.status == 200) {
var sp=xhttp.responseText.split("#");
idassign.innerHTML=sp[0];
iddeliver.innerHTML=sp[1];
idremark.innerHTML=sp[2];
}
};
xhttp.open("POST", "<%=landingpage_basepath %>/ContentPage111?seoid="+seoid, true);
xhttp.send(seoid);
}
};

$(function() {
$("#Task_Name").autocomplete({
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
id: item.id,
};}));},
error: function (error) {
alert('error: ' + error);
}});},
select : function(e, ui) {
$("#tid").val(ui.item.id);
},});
});
</script>
<script>
bkLib.onDomLoaded(function(){
  var myInstance = new nicEditor().panelInstance('Content');
  myInstance.addEvent('blur', function() {
	  var str = $('#addcontent').find('.nicEdit-main').text();
	  var count = 0;
	  words = str.split(" ");
	  for (var i=0; i < words.length; i++) if (words[i] != "") count += 1;
	  document.getElementById("noofword").value=count;
  });
});
</script>
</body>
</html>