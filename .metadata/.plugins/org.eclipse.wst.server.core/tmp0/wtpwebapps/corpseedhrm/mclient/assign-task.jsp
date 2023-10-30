<%@page import="admin.task.TaskMaster_ACT"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Assign Task</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body class="task_page"> 
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%-- <%if(!CM05){%><jsp:forward page="/login.html" /><%} %> --%>
<%
DateFormat df = new SimpleDateFormat("dd-MM-yyyy");
Calendar calobj = Calendar.getInstance();
String today = df.format(calobj.getTime());

String token = (String) session.getAttribute("uavalidtokenno");
String uid=(String) session.getAttribute("passid");
String[][] getProjectById = Clientmaster_ACT.getProjectByID(uid,token);
String milestone[][]=TaskMaster_ACT.getMilestone(uid,token);
%>
<div id="content">
<div class="container">
<div class="bread-crumb">
<div class="bd-breadcrumb bd-light">
<a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
<a>Assign Task</a>
</div><a href="<%=request.getContextPath()%>/manage-project.html"><button class="bkbtn" style="margin-left:918px;">Back</button></a>
</div>
</div>
<div class="main-content">
<div class="container">
<div class="row">
<div class="col-md-5 col-sm-5 col-xs-12">
<div class="menuDv clearfix">
<div class="mb0 clearfix project_title top_title">
<div class="pad0 col-md-8 col-sm-8 col-xs-12">
<h3><span title="<%=getProjectById[0][2] %>"><%=getProjectById[0][2] %></span></h3>
</div>
<div class="pad0 col-md-4 col-sm-4 col-xs-12">
<p class="text-right"><%=getProjectById[0][5] %></p>
</div>
</div>

<div class="clearfix">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix link-style12 project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Client Name</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=getProjectById[0][1] %>"><%=getProjectById[0][1] %></p>
</div>
</div>
<div class="clearfix link-style12 project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Project No.</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=getProjectById[0][6] %>"><%=getProjectById[0][6] %></p>
</div>
</div>
<div class="clearfix link-style12 project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Project Type</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=getProjectById[0][3] %>"><%=getProjectById[0][3] %></p>
</div>
</div>
<div class="clearfix link-style12 project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Project Name</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=getProjectById[0][2] %>"><%=getProjectById[0][2] %></p>
</div>
</div>
<div class="clearfix link-style12 project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Starting Date</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=getProjectById[0][4] %>"><%=getProjectById[0][4] %></p>
</div>
</div>
<div class="clearfix link-style12 project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Delivery Date</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=getProjectById[0][5] %>"><%=getProjectById[0][5] %></p>
</div>
</div>
<div class="clearfix link-style12 project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Remarks</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=getProjectById[0][9]%>"><%=getProjectById[0][9]%></p>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
<div class="col-md-7 col-sm-7 col-xs-12">
<div class="menuDv clearfix">
<div class="mb0 pad_box2 top_title pointers add_follow_title">
<h2>Assign Task</h2>
<i class="fa fa-plus" title="Add Follow-Up"></i>
</div>
<div class="clearfix partner-slider8" style="display: none;">
<form action="<%=request.getContextPath() %>/assigntask.html" method="post" name="follow-up-form" enctype="multipart/form-data">
<input type="hidden" name="pfupid" id="pfupid" value="<%=getProjectById[0][0]%>" readonly>
<input type="hidden" name="pfucid" id="pfucid" value="<%=getProjectById[0][7]%>" readonly>
<input type="hidden" name="projectid" id="projectid" value="<%=getProjectById[0][6] %>" readonly>
<input type="hidden" name="pfupname" id="pfupname" value="<%=getProjectById[0][2].replace(" ", "").toUpperCase()%>" readonly>
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix footer-bottom2">
<div class="col-sm-4 col-xs-12  box-intro-background">
<div class="add-enquery" title="Select Task To Assign">
<!--apply on onchange and assign delivery date  getDeliveryDate(); -->
<select name="taskdetails" id="TaskDetails" class="form-control multiselect" multiple="multiple" onchange="setValue();getDeliveryDate();">
<%if(milestone.length>0){
	for(int i=0;i<milestone.length;i++){%>
<option value="<%=milestone[i][0]%>"><%=milestone[i][1]%></option>
<%}} %>
</select>
<input type="hidden" id="Tasks" name="tasks">
</div>
</div>
<div class="col-sm-4 col-xs-12  box-intro-background">
<div class="add-enquery" title="Assign Project To?">
<input type="text" name="pfuato" id="pfuato" placeholder="Assign Project To?" onchange="checkAssigned('pfuatoid','pfuatoErr')"  autocomplete="off" class="form-control">
<input type="hidden" name="pfuatoid" id="pfuatoid">
</div>
<div id="pfuatoErr" class="errormsg"></div>
</div>
<div class="col-sm-4 col-xs-12  box-intro-background">
<div class="add-enquery" title="Date of Delivery">
<input type="text" name="pfuddate" id="pfuddate" title="Delivery Date" placeholder="Date of Delivery" class="form-control readonlyAllow" readonly="readonly">
<input type="hidden" name="deliverydate" id="deliverydate">
</div>
</div>
</div>
<div class="clearfix">
<div class="col-xs-12  box-intro-background">
<div>
<textarea style="margin-left: 11px;width: 96.5%;" name="pfuremark" id="pfuremark" class="form-control"></textarea>
</div>
<div id="pfuremarkerr" class="errormsg"></div>
</div>
</div>
<div class="clearfix">
<div class="col-sm-4 col-xs-12  box-intro-background" id="ifupload">
<div class="add-enquery">
<button type="button" class="bt-style2 bt-link bt-radius" onclick="$('#uploadyes').toggle();$('#ifupload').hide();">Upload Image ?</button>
</div>
</div>
<div class="col-sm-4 col-xs-12  box-intro-background" id="uploadyes" style="display: none;">
<div class="add-enquery">
<input type="file" name="files" id="files" class="form-control" accept="application/pdf, image/*" />
</div>
</div>
<div class="col-sm-8 col-xs-12 box-intro-background">
<div class="clearfix add-enquery text-right">
<button type="submit" class="bt-style1 bt-link bt-radius bt-loadmore" onclick="return assignValidations();">Assign Task</button>
</div>
</div>
</div>
</div>
</form>
</div>
</div>

<div class="clearfix menuDv about-content">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="top_title pad_box2">
<h2>Assigned Task History</h2>
</div>
<%-- <a class="mrt10 pad-top5 add_btn font_size15"><strong>Delivery Date : </strong><%=getProjectById[0][5] %></a> --%>
</div>
</div>
<div id="reload">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<%
	String[][] getTaskAssigned = Clientmaster_ACT.getAssignedTaskById(getProjectById[0][6],token);
if(getTaskAssigned.length>0){
	for(int i=0;i<getTaskAssigned.length;i++) {
		String nameTask[]=Clientmaster_ACT.getNameTask(getTaskAssigned[i][4],getTaskAssigned[i][3]);
// 		String docname = Clientmaster_ACT.getDocumentNameForProjectFollowUp(getFollowUpById[i][0],token);
%>
<div class="clearfix follow_status">
<div class="clearfix link-style12">
<div class="col-sm-11 col-xs-12 box-intro-background">
<div class="box-width24 col-sm-3 col-xs-12 box-intro-background">
<p class="news-border"><%=getTaskAssigned.length-i %></p>
</div>
<div class="box-width13 col-sm-3 col-xs-12 box-intro-background">
<p class="fstatus_bg news-border" title="<%=nameTask[0] %>"><%=nameTask[0] %></p>
</div>
<div class="box-width41 col-sm-3 col-xs-12 box-intro-background ">
<p class="news-border" title="<%=nameTask[1] %>"><%=nameTask[1] %></p>
</div>
<div class="box-width7 col-sm-3 col-xs-12 box-intro-background ">
<p class="news-border" title="<%=getTaskAssigned[i][6] %>"><%=getTaskAssigned[i][6] %></p>
</div>
<div class="box-width13 col-sm-3 col-xs-12 box-intro-background">
<p class="news-border" title="<%=getTaskAssigned[i][7] %>"><%=getTaskAssigned[i][7] %></p>
</div>
</div>
<div class="col-sm-1 col-xs-12 box-intro-background">
<p><a onclick="deleteTask('<%=getTaskAssigned[i][0]%>','<%=getTaskAssigned[i][1]%>','<%=getTaskAssigned[i][4]%>','<%=getTaskAssigned[i][2]%>')"><i class="fa fa-trash-o"></i></a></p>
</div>
</div>
<div class="clearfix">
<div class="col-sm-11 col-xs-12 box-intro-background">
<p class="desc" title="<%=getTaskAssigned[i][5]%>"><%=getTaskAssigned[i][5]%></p>
</div>
<div class="col-sm-1 col-xs-12 box-intro-background"><%if(!getTaskAssigned[i][8].equalsIgnoreCase("NA")){%>
<p><a class="fancy_box" href="<%=request.getContextPath() %>/documents/<%=getTaskAssigned[i][8]%>"><i class="fa fa-file-text-o"></i></a></p><%} %>
</div>
</div>
</div>
<% }}else{ %>
<div class="box-intro-bg1 clearfix"><p class="col-md-12 col-xs-12 text-center">No Data Found!</p></div>
<%} %>
</div>
</div>
</div>
</div>

</div>
</div>
</div>
</div>
</div>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
$(".fancy_box").fancybox({
	width  : 950,
    height : 600,
    type   : 'iframe',
    iframe : {
        preload: false
    }
});
</script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/jquery.multiselect.js"></script>
<script type="text/javascript">
$(function(){
	$("select.multiselect").multiselect();
});
</script>
<script type="text/javascript">
function checkAssigned(id,err){
	setTimeout(function() {
	var uid=document.getElementById(id).value.trim();
	var projectno="<%=getProjectById[0][6] %>";
	var task=document.getElementById("Tasks").value.trim();
	if(task==""){
		document.getElementById(err).innerHTML="Select Task First";
		document.getElementById(err).style.color="red";
		document.getElementById("pfuato").value="";
	}else{
		$.ajax({
			type : "POST",
			url : "isAlreadyAssigned111",
			dataType : "HTML",
			data : {"uid":uid,"task":task,"projectno":projectno,},
			success : function(data){
				if(data=="pass"){
					document.getElementById(err).innerHTML="Task Already Assigned.";
					document.getElementById(err).style.color="red";
					document.getElementById("pfuato").value="";
				}
				
			}
		});
	}
	},10);
}
// check why not working
function getDeliveryDate(){
	var mid=document.getElementById('Tasks').value;
	var pid="<%=uid%>"
	if(mid!=""){
	$.ajax({
		type : "POST",
		url : "GetDeliveryDate111",
		dataType : "HTML",
		data : {
			"uid":pid,
			"mid":mid,
			},
		success : function(data){
			document.getElementById("pfuddate").value=data;
		}
	});
	}else{
		document.getElementById("pfuddate").value="";
	}
}

function setValue(){
	var values = $('#TaskDetails').val();
	  document.getElementById('Tasks').value=values;
}

</script>
<script type="text/javascript">
$(function() {
$("#pfudate").datepicker({
changeMonth: true,
changeYear: true,
dateFormat: 'dd-mm-yy',
});
});   
function assignValidations() {
if(document.getElementById('TaskDetails').value.trim()=="" ) {
	document.getElementById('errorMsg').innerHTML = 'Select Tasks.';
	$('.alert-show').show().delay(1000).fadeOut();
return false;
}
if(document.getElementById('pfuato').value.trim()=="" ) {
	document.getElementById('errorMsg').innerHTML = 'Assign To Is Required.!';
	$('.alert-show').show().delay(1000).fadeOut();
return false;
}
if(document.getElementById('pfuddate').value.trim()=="" ) {
	document.getElementById('errorMsg').innerHTML = 'Delivery Date Is Required.!';
	$('.alert-show').show().delay(1000).fadeOut();
return false;
}
var remarks =document.getElementById("pfuremark" ).value.trim();
if(remarks.length<10 ) {
	document.getElementById('errorMsg').innerHTML = 'Minimum 10 Character Remarks Required.!';
	$('.alert-show').show().delay(1500).fadeOut();
return false;
}
}

function deleteTask(id,taskid,asstoid,pregno) {
if(confirm("Sure you want to Delete this Task ? "))
{
	var xhttp;
	xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
	if (this.readyState == 4 && this.status == 200) {
		location.reload();
	}
	};
	xhttp.open("GET", "<%=request.getContextPath()%>/DeleteAssignTask111?info="+id+"&taskid="+taskid+"&asstoid="+asstoid+"&pregno="+pregno, true);
	xhttp.send();
	}
}

$(function() {
	$("#pfuato").autocomplete({
		source : function(request, response) {			
			if(document.getElementById('pfuato').value.trim().length>=2)
			$.ajax({
				url : "getassignby.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,					
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label: item.name,
							value: item.value,
							id: item.id,
						};
					}));
				},
				error : function(error) {
					alert('error: ' + error.responseText);
				}
			});
		},
		change: function (event, ui) {  
            if(!ui.item){    
            	pfuatoErr.innerHTML = 'Select from List';
            	pfuatoErr.style.color="red";
            	document.getElementById("pfuatoid").value = "";
            	document.getElementById("pfuato").value = "";    			
            }
            else{
            	document.getElementById("pfuatoid").value = ui.item.id;
            	document.getElementById("pfuato").value = ui.item.value;    			
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});
// bkLib.onDomLoaded(function(){nicEditors.editors.push(new nicEditor().panelInstance(document.getElementById('pfuremark')));});
$(function() {
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/markprojectread",
	    data:  { 
	    	"uid" : <%=uid%>
	    }
	});
});
</script>
<div id="showremarks" style="display: none; width: 700px; max-height: 400px; overflow-x: hidden; overflow-y: auto;">
<div class="container">
<p id="datahere"></p>
</div>
</div>
</body>
</html>