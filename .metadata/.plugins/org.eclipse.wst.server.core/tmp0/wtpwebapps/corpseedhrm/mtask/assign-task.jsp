<%@page import="admin.master.Usermaster_ACT"%>
<%@page import="admin.task.TaskMaster_ACT"%>
<% String landingpage_basepath = request.getContextPath();%>
<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Assign Task</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<% String ptladdedby= (String)session.getAttribute("loginuID");
String token=(String)session.getAttribute("uavalidtokenno");
String start="NUL";
start=Usermaster_ACT.getStartingCode(token,"imtaskkey");
String ptltuid = TaskMaster_ACT.getmanifescode(token);
if (ptltuid==null) {
ptltuid=start+"1";
}
else {
String c=ptltuid.substring(start.length());
int j=Integer.parseInt(c)+1;
ptltuid=start+Integer.toString(j);
}
%>
<%-- <%if(!AT01){%><jsp:forward page="/login.html" /><%} %> --%>
<div id="content">
<div class="container">
<div class="bread-crumb">
<div class="bd-breadcrumb bd-light">
<a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
<a>Assign Task</a>
</div>
</div>
</div>

<div class="main-content">
<div class="container">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="menuDv post-slider">
<form action="task-master.html" method="post" id="userTask" name="userTask">
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<input type="hidden" name="ptladdedby" value="<%=ptladdedby%>">
<input type="hidden" readonly name="pid" id="pid">
<input type="hidden" readonly name="abid" id="abid">
<input type="hidden" readonly name="atid" id="atid">
<label>Task ID</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite card"></i></span>
<input type="text" name="TaskID" id="TaskID" value="<%=ptltuid%>"placeholder="Enter Task ID" readonly onblur="requiredFieldValidation('Task ID','TaskIDEerorMSGdiv');" class="form-control">
</div>
<div id="TaskIDEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Project Name</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
<input type="text" name="ProjectName" id="Project_Name" autocomplete="off" placeholder="Enter Project Name" onblur="requiredFieldValidation('Project_Name','Project_NameErrorMSGdiv');" class="form-control">
</div>
<div id="Project_NameErrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Assigned BY</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
<input type="text" name="AssignedBY" id="Assigned_BY" autocomplete="off" placeholder="Assigned BY" onblur="requiredFieldValidation('Assigned_BY','Assigned_BYErrorMSGdiv');" class="form-control">
</div>
<div id="Assigned_BYErrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Assigned To</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
<input type="text" name="AssignedTo" id="Assigned_To" autocomplete="off" placeholder="Assigned To" onblur="requiredFieldValidation('Assigned_To','Assigned_ToErrorMSGdiv');" class="form-control">
</div>
<div id="Assigned_ToErrorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Task Name</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite list"></i></span>
<input class="form-control" type="text" name="TaskName" id="TaskName" placeholder="Task Name" onblur="checktask();requiredFieldValidation('TaskName','TaskNameErrorMSGdiv');">
</div>
<div id="TaskNameErrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Assigned On</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-calendar"></i></span>
<input class="form-control"  type="text" name="Assignedon" id="Assignedon" placeholder="Assigned On" onchange="requiredFieldValidation('Assignedon','AssignedonErrorMSGdiv');" onblur="requiredFieldValidation('Assignedon','AssignedonErrorMSGdiv');">
</div>
<div id="AssignedonErrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Deliver On</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite arrow-up"></i></span>
<input class="form-control"  type="text" name="DeliverOn" id="DeliverOn" placeholder="Deliver On" onchange="requiredFieldValidation('DeliverOn','DeliverOnErrorMSGdiv');" onblur="requiredFieldValidation('DeliverOn','DeliverOnErrorMSGdiv');">
</div>
<div id="DeliverOnErrorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-xs-12">
<div class="form-group">
<label>Remark</label>
<div class="input-group">
<textarea class="form-control" name="Remark" id="Remark" placeholder="Remarks" onblur="requiredFieldValidation('Remark','RemarkErrorMSGdiv');"></textarea>
</div>
<div id="RemarkErrorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="item-product-info">
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return task();">Submit</button>
</div>
</form>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script>
$( function() {
	$( "#Assignedon" ).datepicker({
		changeMonth: true,
		changeYear: true,
		dateFormat: 'dd-mm-yy'
	});
} );

$( function() {
	$( "#DeliverOn" ).datepicker({
		changeMonth: true,
		changeYear: true,
		dateFormat: 'dd-mm-yy'
	});
} );
</script>
<script type="text/javascript">
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

$(function() {
$("#Assigned_BY").autocomplete({
source: function(request, response) {
$.ajax({
url: "getassignby.html",
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
$("#abid").val(ui.item.id);
},});
});

$(function() {
$("#Assigned_To").autocomplete({
source: function(request, response) {
$.ajax({
url: "getassignby.html",
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
$("#atid").val(ui.item.id);
},});
});

function task()
{
if(document.getElementById('Project_Name').value=="" ) {
Project_NameErrorMSGdiv.innerHTML="Project_Name is required.";
Project_NameErrorMSGdiv.style.color="#800606";
return false;
}
if(document.getElementById('Assigned_BY').value=="" ) {
Assigned_BYErrorMSGdiv.innerHTML="Assigned_BY is required.";
Assigned_BYErrorMSGdiv.style.color="#800606";
return false;
}
if(document.getElementById('Assigned_To').value=="")  {
Assigned_ToErrorMSGdiv.innerHTML="Assigned_To  is required.";
Assigned_ToErrorMSGdiv.style.color="#800606";
return false;
}
if (document.getElementById("TaskName").value=="") {
TaskNameErrorMSGdiv.innerHTML="TaskName is Required!";
TaskNameErrorMSGdiv.style.color="#800606";
return false;
}
if (document.getElementById("Assignedon").value=="") {
AssignedonErrorMSGdiv.innerHTML="Assignedon is Required!";
AssignedonErrorMSGdiv.style.color="#800606";
return false;
}
if (document.getElementById("DeliverOn").value=="") {
DeliverOnErrorMSGdiv.innerHTML="Deliveron is required.";
DeliverOnErrorMSGdiv.style.color="#800606";
return false;
}
var data = $('#userTask').find('.nicEdit-main').text();
if (data=="") {
RemarkErrorMSGdiv.innerHTML="Remark is Required!";
RemarkErrorMSGdiv.style.color="#800606";
return false;
}
// document.userTask.submit();
}

function approve1(id) {
if(confirm("Sure you want to Delete this list ? "))
{
var xhttp;
xhttp = new XMLHttpRequest();
xhttp.onreadystatechange = function() {
if (this.readyState == 4 && this.status == 200) {
location.reload();
}
};
xhttp.open("GET", "<%=landingpage_basepath %>/DeleteList111?info="+id, true);
xhttp.send(id);
};
};
</script>
<script type="text/javascript">
bkLib.onDomLoaded(function() {
    nicEditors.editors.push(
        new nicEditor().panelInstance(
            document.getElementById('Remark')
        )
    );
});
</script>
<script type="text/javascript">
function checktask() {
	if(document.getElementById('TaskName').value!="")
	{
	var xmlHttp1='';
	if (window.XMLHttpRequest) { // Mozilla, Safari, ...
	xmlHttp1 = new XMLHttpRequest();
	} else if (window.ActiveXObject) { // IE
	xmlHttp1 = new ActiveXObject("Microsoft.XMLHTTP");
	}
	var tname='tname='+document.getElementById("TaskName").value;
	xmlHttp1.open("POST","<%=landingpage_basepath %>/CheckTName111", true);
			xmlHttp1.setRequestHeader('Content-Type',
					'application/x-www-form-urlencoded');
			xmlHttp1.setRequestHeader('Cache-Control', 'private');
			xmlHttp1.setRequestHeader('Pragma', 'no-cache');
			xmlHttp1.setRequestHeader('Cache-Control',
					'no-store, no-cache, must-revalidate');
			xmlHttp1.send(tname);
			xmlHttp1.onreadystatechange = function() {
				if (xmlHttp1.readyState == 4) {
					if (xmlHttp1.status == 200) {
						var RESP_TEXT1 = xmlHttp1.responseText;
						if (RESP_TEXT1 == 20) {
							TaskNameErrorMSGdiv.innerHTML = document.getElementById("TaskName").value+" already exists!!";
							TaskNameErrorMSGdiv.style.color="#800606";
						}
					}
				}
			};
		}
	}
</script>
</body>
</html>