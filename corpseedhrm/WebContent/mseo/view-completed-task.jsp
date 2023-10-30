<%@page import="admin.task.TaskMaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Task Details</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%-- <%if(!MT04){%><jsp:forward page="/login.html" /><%} %> --%>
<% String addedby= (String)session.getAttribute("loginuID");
String token=(String)session.getAttribute("uavalidtokenno");
String loginuaid=(String)session.getAttribute("loginuaid");
String emproleid=(String)session.getAttribute("emproleid");
String uid=(String) session.getAttribute("passid");
String[][] taskdata=TaskMaster_ACT.getTaskByID(uid);
String[][] taskdata1=TaskMaster_ACT.getTaskByID1(uid);
// String[][] taskdata2=TaskMaster_ACT.getTaskByID2(uid);
String ptmtuid = TaskMaster_ACT.getmanifescode(token);
String[][] getTasks=TaskMaster_ACT.getAllTasksById(uid);
String[][] Milestones=TaskMaster_ACT.getCompletedMileStone(uid,loginuaid,token,emproleid);

String clientname=TaskMaster_ACT.getClientName(taskdata[0][6],token);
%>
<div id="content">
<div class="container">   
          <div class="bread-crumb">
            <div class="bd-breadcrumb bd-light">
            <a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
            <a>Task Details</a>
            </div><a href="<%=request.getContextPath()%>/dashboard.html"><button class="bkbtn" style="margin-left:915px;">Back</button></a>
          </div>
        </div>
<div class="main-content">
<div class="container">
<div class="row">
<div class="col-md-5 col-sm-5 col-xs-12">
<div class="menuDv clearfix form-group">
<div class="mb0 clearfix project_title top_title">
<div class="pad0 col-md-8 col-sm-8 col-xs-12">
<h3 class="txt_blue"  title="<%=taskdata[0][5]%>"><%=taskdata[0][5]%></h3>
</div>
<div class="pad0 col-md-4 col-sm-4 col-xs-12">
<p class="text-right"><%=taskdata[0][3] %></p>
</div>
</div>

<div class="clearfix">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix link-style12 project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Order Id</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=taskdata[0][0]%>"><%=taskdata[0][0]%></p>
</div>
</div>
<div class="clearfix link-style12 project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Client's Name</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=clientname%>"><%=clientname%></p>
</div>
</div>
<div class="clearfix link-style12 project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Project Name</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=taskdata[0][5]%>"><%=taskdata[0][5]%></p>
</div>
</div>
<div class="clearfix link-style12 project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Assigned By</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=taskdata1[0][0]%>"><%=taskdata1[0][0]%></p>
</div>
</div>
<div class="clearfix link-style12 project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Assigned On</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=taskdata[0][2] %>"><%=taskdata[0][2] %></p>
</div>
</div>
<div class="clearfix link-style12 project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Remarks</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=taskdata[0][4] %>"><%=taskdata[0][4] %></p>
</div>
</div>
</div>
</div>
</div>
</div>
<%
if(Milestones.length>0)
	for(int i=0;i<Milestones.length;i++){
		String mname=TaskMaster_ACT.getMilestoneName(Milestones[i][1],token);
%>
<div class="menuDv clearfix form-group" >
<div class="mb0 clearfix project_title top_title pointers add_follow_title">
<div class="pad0 col-md-8 col-sm-8 col-xs-12">
<h3 class="normal_txt txt_orange"  title="<%=mname%>"><%=i+1 %>. <%=mname%></h3>
</div>
<div class="pad0 col-md-4 col-sm-4 col-xs-12">
<p class="text-right"><span class="pad-rt05"><%=Milestones[i][4] %></span> <i class="fa fa-plus" title="Add Follow-Up"></i></p>
</div>
</div>
<div class="clearfix pad-top5" style="display: none;">
<div class="pad-lft10 col-sm-11 col-xs-12 box-intro-background">
<p><%=Milestones[i][2] %></p>
</div>
<div class="col-sm-1 col-xs-12 box-intro-background"><%if(!Milestones[i][5].equalsIgnoreCase("NA")){%>
<p class="text-right"><a class="img_view quick-view" href="<%=request.getContextPath() %>\staticresources\images\assigntask\<%=Milestones[i][5]%>"><i class="fa fa-file-text-o"></i></a></p><%} %>
</div>
</div>
</div>
<%} %>

</div>
<div id="reload">
<div class="col-md-7 col-sm-7 col-xs-12">
<div class="clearfix menuDv form-group">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="top_title pad_box2">
<h2>Task History</h2>
</div>
<%-- <a class="mrt10 pad-top5 add_btn font_size15"><strong>Delivery Date : </strong><%=getProjectById[0][5] %></a> --%>
</div>
</div>

<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<% 	
    
    	  String[][] getStatusReport=TaskMaster_ACT.getStatusReport(uid,token,taskdata[0][11]);
		if(getStatusReport.length>0&&getStatusReport!=null)
      for(int i=0;i<getStatusReport.length;i++)
      {
    	  String taskname=TaskMaster_ACT.getMilestoneName(getStatusReport[i][4],token);
    	  String uname=TaskMaster_ACT.getUserName(getStatusReport[i][5],token);
 %>
<div class="clearfix follow_status">
<div class="clearfix link-style12">
<div class="col-sm-11 col-xs-12 box-intro-background">
<div class="box-width25 col-sm-2 col-xs-12 box-intro-background">
<p class="news-border" title=""><%=getStatusReport.length-i %></p>
</div>
<div class="box-width26 col-sm-5 col-xs-12 box-intro-background" style="background: #f6f6f6;">
<p class="news-border" title="<%=uname%>"><%=uname%></p>
</div>
<div class="box-width42 col-sm-5 col-xs-12 box-intro-background">
<p class="news-border" title="<%=taskname%>"><%=taskname%></p>
</div>
<div class="box-width8 col-sm-3 col-xs-12 box-intro-background">
<p class="news-border" title=""><%String x[]=getStatusReport[i][2].split(" ");%><%=x[0] %></p>
</div>
<div class="box-width8 col-sm-3 col-xs-12 box-intro-background ">
<p class="news-border" title=""><%=getStatusReport[i][1]%></p>
</div>
</div>
<div class="col-sm-1 col-xs-12 box-intro-background">
<p><a><i class="fa fa-trash-o"></i></a></p>
</div>
</div>
<div class="clearfix">
<div class="col-sm-11 col-xs-12 box-intro-background">
<p class="desc" title="<%=getStatusReport[i][0]%>"><%=getStatusReport[i][0]%></p>
</div>
</div>
</div>
<% } %>
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
</div>
<section class="clearfix" id="manageFollowup" style="display: none;">
<div class="clearfix  text-center">
<div class="col-md-12 col-xs-12" id="userid" style="display: none;"></div>
<div class="col-md-12 col-xs-12">
<div class="box-intro1">
  <h2><span class="title">Delete This Task History ?</span></h2>
</div>
</div>
<div class="col-md-12 col-xs-12 mb10">
<a class="sub-btn1" onclick="" id="cancelpopup">Cancel</a>
<button class="sub-btn1 mlft10" onclick="return deleteFollowUp(document.getElementById('userid').innerHTML);" title="Delete">Delete</button>
</div>
</div>
</section>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">	
$('#cancelpopup').click(function(){
	  $.fancybox.close();
});
</script>
<script type="text/javascript">
function checkDeliverDate(val){
	if(val=="Expired")
		document.getElementById("TaskStatus").style.color="red";
	else if(val=="Pending")
		document.getElementById("TaskStatus").style.color="blue";
	else if(val=="Open")
		document.getElementById("TaskStatus").style.color="orange";
	else if(val=="Completed")
		document.getElementById("TaskStatus").style.color="black";	
	if(val=="On Hold"){
	document.getElementById("TaskStatus").style.color="gray";
	document.getElementById("DeliveryDate").removeAttribute("disabled"); 
	document.getElementById("DeliveryDate").value="";
}
	else{
		document.getElementById("DeliveryDate").setAttribute("disabled", true);
		}
}

function getTaskDetails(mid){
	document.getElementById("TaskStatus").value="";
	var taskid="<%=uid%>";
	$.ajax({
		type: "POST",
		dataType: "html",
		url: "<%=request.getContextPath()%>/TaskDates111",
		data:  {
			mid: mid,
			taskid: taskid,			
		},
		success: function (data) { 
			var x=data.split("/");
		document.getElementById("StartDate").value=x[0];
		document.getElementById("DeliveryDate").value=x[1];
		},
		error: function (error) {
		alert("error in finishorder() " + error.responseText);
		}
		});
}

bkLib.onDomLoaded(function() {
nicEditors.editors.push(
new nicEditor().panelInstance(
document.getElementById('ptsremarks')
)
);
});        
function checkStatus(){
if(document.getElementById("TaskId").value.trim()==""){
	taskIderr.innerHTML="Select Task";
	taskIderr.style.color="red";
return false;
}
if(document.getElementById("TaskStatus").value.trim()==""){
	taskfstatuserr.innerHTML="Select Task's Status";
	taskfstatuserr.style.color="red";
return false;
}
if(document.getElementById("DeliveryDate").value.trim()==""){
	deliverydateerr.innerHTML="Delivery date is required.";
	deliverydateerr.style.color="red";
return false;
}

var ptstid=document.getElementById("PTSTID").value.trim();
var ptsremarks=nicEditors.findEditor( "ptsremarks" ).getContent();
var ptsstatus=document.getElementById("TaskStatus").value.trim();
var ptsaddedby=document.getElementById("addedBy").value.trim();
var mid=document.getElementById("TaskId").value.trim();
var deliverydate=document.getElementById("DeliveryDate").value.trim();

$.ajax({
	type: "POST",
	dataType: "html",
	url: "<%=request.getContextPath()%>/Project-Status.html",
	data:  {
		ptstid: ptstid,
		ptsremarks: ptsremarks,
		ptsstatus: ptsstatus,
		ptsaddedby: ptsaddedby,
		mid: mid,
		deliverydate: deliverydate,		
	},
	success: function (data) {
		if(ptsstatus=="Completed"){
			window.location = "<%=request.getContextPath()%>/mytask.html";
		}else{
				location.reload();
		}
	},
	error: function (error) {
	alert("error in finishorder() " + error.responseText);
	}
	});
}
function deleteFollowUp(id){
	$.ajax({
		type: "Get",
		dataType: "html",
		url: "<%=request.getContextPath()%>/DeleteFollowupStatus111",
		data:  {
			id: id,			
		},
		success: function (data) {
					location.reload();			
		},
		error: function (error) {
		alert("error in deleteFollowUp() " + error.responseText);
		}
		});
}
</script>
<div id="showremarks" style="display: none; width: 700px; max-height: 400px; overflow-x: hidden; overflow-y: auto;">
<div class="container">
<p id="datahere"></p>
</div>
</div>
</body>
</html>