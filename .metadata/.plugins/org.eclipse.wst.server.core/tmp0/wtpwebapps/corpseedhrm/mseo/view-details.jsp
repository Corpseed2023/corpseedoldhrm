<%@page import="client_master.Clientmaster_ACT"%>
<%@page import="admin.task.TaskMaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Task Details</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
<style type="text/css">
/* width */
::-webkit-scrollbar {
  width: 10px;
}

/* Track */
::-webkit-scrollbar-track {
  background: #f1f1f1; 
}
 
/* Handle */
::-webkit-scrollbar-thumb {
  background: #888; 
}

/* Handle on hover */
::-webkit-scrollbar-thumb:hover {
  background: #555; 
}
</style>
</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%-- <%if(!MT04){%><jsp:forward page="/login.html" /><%} %> --%>
<% 
String uarefid= (String)session.getAttribute("uarefid");
String addedby= (String)session.getAttribute("loginuID");
String token=(String)session.getAttribute("uavalidtokenno");
String loginuaid=(String)session.getAttribute("loginuaid");
String emproleid=(String)session.getAttribute("emproleid");
String uid=(String) session.getAttribute("passid");
String[][] taskdata=TaskMaster_ACT.getTaskByID(uid);
String[][] taskdata1=TaskMaster_ACT.getTaskByID1(uid);
// String[][] taskdata2=TaskMaster_ACT.getTaskByID2(uid);
String ptmtuid = TaskMaster_ACT.getmanifescode(token);
String[][] getTasks=TaskMaster_ACT.getAllTasksById(uid);
String[][] Milestones=TaskMaster_ACT.getAllMileStone(uid,loginuaid,token,emproleid);

String clientname=TaskMaster_ACT.getClientName(taskdata[0][6],token);

String loginname=Clientmaster_ACT.getLoginUserName((String)session.getAttribute("loginuaid")); 
if(loginname==null||loginname.length()<=0)loginname="NA";
%>
<div id="content">
<div class="container">   
          <div class="bread-crumb">
            <div class="bd-breadcrumb bd-light">
            <a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
            <a>Task Details</a>
            </div>
            <div class="row">
            
            
         	</div>
          </div>
        </div>
<div class="main-content">
<div class="container">
<div class="clearfix text-right mb10">
<a class="mrt10 bkbtn fancybox1" href="<%=request.getContextPath() %>/upload-document.html?pr097bjno=<%=taskdata[0][10]%>&cl09tyname=<%=clientname%>">Upload Certificate</a>
<a href="<%=request.getContextPath()%>/mytask.html"><button class="bkbtn">Back</button></a>
</div>
<div class="row">
<div class="col-md-5 col-sm-5 col-xs-12">
<div class="menuDv clearfix form-group">
<div class="mb0 clearfix project_title top_title">
<div class="pad0 col-md-8 col-sm-8 col-xs-12">
<h3 class="txt_blue"  title="<%=taskdata[0][10]%>&nbsp;:&nbsp<%=taskdata[0][5]%>"><%=taskdata[0][10]%>&nbsp;:&nbsp;<%=taskdata[0][5]%></h3>
</div>
<div class="pad0 col-md-4 col-sm-4 col-xs-12">
<p class="text-right"><%=taskdata[0][3] %></p>
</div>
</div>

<div class="clearfix">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Order Id</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p class="txt_blue" title="<%=taskdata[0][0]%>"><%=taskdata[0][0]%></p>
</div>
</div>
<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Client's Name</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=clientname%>"><%=clientname%></p>
</div>
</div>
<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Project Name</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p class="txt_blue" title="<%=taskdata[0][5]%>"><%=taskdata[0][5]%></p>
</div>
</div>
<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Assigned By</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=taskdata1[0][0]%>"><%=taskdata1[0][0]%></p>
</div>
</div>
<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Assigned On</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=taskdata[0][2] %>"><%=taskdata[0][2] %></p>
</div>
</div>
<div class="clearfix project_detail_box">
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
		String color="NA";	
		if(Milestones[i][6].equalsIgnoreCase("Expired"))
			color="red";
		else if(Milestones[i][6].equalsIgnoreCase("Pending"))
			color="blue";
		else if(Milestones[i][6].equalsIgnoreCase("Open"))
			color="orange";
		else if(Milestones[i][6].equalsIgnoreCase("Completed"))
			color="black";	
		else if(Milestones[i][6].equalsIgnoreCase("On Hold"))
			color="gray";			
	
%>
<div class="menuDv clearfix form-group" >
<div class="mb0 clearfix project_title top_title pointers add_follow_title">
<div class="pad0 col-md-8 col-sm-8 col-xs-12">
<h3 <% if(color.equalsIgnoreCase("NA")){%>class="normal_txt txt_orange"<%}else{ %>class="normal_txt"<%} if(!color.equalsIgnoreCase("NA")){%>style="color: <%=color%>;"<%} %>  title="<%=mname%>"><%=i+1 %>. <%=mname%></h3>
</div>
<div class="pad0 col-md-4 col-sm-4 col-xs-12">
<p class="text-right"><span class="pad-rt05"><%=Milestones[i][4] %></span> <i class="fa fa-plus" title="Add Follow-Up"></i></p>
</div>
</div>
<div class="clearfix pad-top5" style="display: none;">

<div class="col-sm-12 col-xs-12">
<p><strong>Progress Bar</strong></p>
</div>

<!--
<div class="pad-lft10 col-sm-11 col-xs-12 box-intro-background">
<p><%=Milestones[i][2] %></p>
</div>
<div class="col-sm-1 col-xs-12 box-intro-background"><%if(!Milestones[i][5].equalsIgnoreCase("NA")){%>
<p class="text-right"><a class="img_view quick-view" href="<%=request.getContextPath() %>\documents\<%=Milestones[i][5]%>"><i class="fa fa-file-text-o"></i></a></p><%} %>
</div>
-->

<div class="pad0 col-sm-12 col-xs-12">
<div class="price-range-slider clearfix">
  <div class="range-value">
    <input type="text" id="amount" readonly>
  </div>
  <div id="slider-range" class="range-bar"></div>
</div>
</div>

</div>
</div>
<%} %>

</div>
<div id="reload">
<div class="col-md-7 col-sm-7 col-xs-12">
<div class="menuDv clearfix form-group" >
<div class="mb0 pad_box2 top_title pointers add_follow_title">
<h2>Follow Up Task</h2>
<i class="fa fa-plus" title="Add Follow-Up"></i>
</div>
<div class="clearfix" style="display: none;">
<form method="POST" action="<%=request.getContextPath() %>/Project-Status.html" id="projectstatus" enctype="multipart/form-data">
<input type="hidden" name="ptsaddedby" id="addedBy" value="<%=addedby%>">
<input type="hidden" name="ptstid" id="PTSTID" value="<%=uid%>">
<input type="hidden" name="loginname" id="loginname" value="<%=loginname%>">
<input type="hidden" name="pregcuid" id="pregcuid" value="<%=taskdata[0][12]%>">
<input type="hidden" name="preguid" id="preguid" value="<%=taskdata[0][11]%>">
<input type="hidden" name="pregno" id="pregno" value="<%=taskdata[0][10]%>">
<div class="clearfix">
<div class="clearfix">
<div class="col-sm-3 col-xs-12  box-intro-background">
<div class="add-enquery">
       <select name="mid" id="TaskId" class="form-control" onchange="getTaskDetails(this.value)">
         <option value="">Select Task</option>
         <%
if(Milestones.length>0)
	for(int i=0;i<Milestones.length;i++){
		String mname=TaskMaster_ACT.getMilestoneName(Milestones[i][1],token);
%><option value="<%=Milestones[i][1]%>#<%=mname %>"><%=mname %></option>
     <%} %>    
       </select>
  <div id="taskIderr" class="errormsg error_box"></div>                            
</div>
</div>
<div class="col-sm-3 col-xs-12  box-intro-background">
<div class="add-enquery">
       <select name="ptsstatus" id="TaskStatus" class="form-control" onchange="checkDeliverDate(this.value)">
         <option value="">Select Status</option>
         <option value="On Hold" style="color: gray;">On Hold</option>         
         <option value="Pending" style="color: blue;">Pending</option>
         <option value="Open" style="color: orange;">Open</option>
         <option value="Completed" style="color: black;">Completed</option>         
       </select>
  <div id="taskfstatuserr" class="errormsg error_box"></div>                            
</div>
 </div>
<div class="col-sm-3 col-xs-12  box-intro-background">
<div class="add-enquery">
<input class="readonlyAllow text-center form-control" type="text" title="Project's Starting Date !" name="startdate" id="StartDate" placeholder="Project's Starting Date !" readonly>
 <div id="startdateerr" class="errormsg error_box"></div>
 </div>
 </div>
 <div class="col-sm-3 col-xs-12  box-intro-background">
<div class="add-enquery">
<input class="readonlyAllow text-center form-control datetimepicker" title="Project's Delivery date !" data-date-format="dd-mm-yyyy  HH:ii p" type="text" name="delivery_date" id="DeliveryDate" placeholder="Project's Delivery Date !" readonly disabled="disabled">
 <input type="hidden" name="deliverydate" id="Delivery_Date">
 <div id="deliverydateerr" class="errormsg error_box"></div>
 </div>
 </div>
</div>
<div class="clearfix">
<div class="col-xs-12  box-intro-background">
<div class="add-enquery nicEdit_box">
<textarea name="ptsremarks" id="ptsremarks" rows="2" class="form-control" placeholder="Enter Remarks"></textarea>
</div>
<div id="ptsremarkserr" class="errormsg"></div>
</div>
</div>
<div class="clearfix">
<div class="col-sm-3 col-xs-12  box-intro-background">
<div class="add-enquery">
<select name="showclient" id="showclient" class="form-control">
<option value="">Show to Client?</option>
<option value="1">Yes</option>
<option value="0">No</option></select>
</div>
</div>
<div class="col-sm-3 col-xs-12  box-intro-background" id="ifupload">
<div class="add-enquery">
<button type="button" class="bt-style2 bt-link bt-radius" onclick="$('#uploadyes').toggle();$('#ifupload').hide();">Upload Image ?</button>
</div>
</div>
<div class="col-sm-3 col-xs-12  box-intro-background" id="uploadyes" style="display: none;">
<div class="add-enquery">
<input type="file" name="files" id="files" class="form-control" accept="application/pdf, image/*" />
</div>
</div>
<div class="col-sm-6 col-xs-6">
<div class="clearfix add_btn_box col-md-12" id="Template" style="display: none;">

<div class="col-md-6" style="top: 5px;">
<input type="checkbox" style="width: 20px;height: 20px;position: absolute;margin-left: -17px;margin-top: 6px;" checked="checked"><span style="margin-top: 5px;position: absolute;"><a id="EmailHref"><i class="fa fa-envelope-o" style="color: #4ac4f3;margin-right: 6px;font-size: 20px;margin-left: 7px;"></i><span id="EmailTemplate"></span></a></span>
</div>
<div class="col-md-6" style="top: 5px;">
<input type="checkbox" style="width: 20px;height: 20px;position: absolute;margin-left: -17px;margin-top: 6px;" checked="checked"><span style="margin-top: 5px;position: absolute;"><a id="SmsHref"><i class="fa fa-comment-o" style="color: #09c820;margin-right: 6px;font-size: 20px;margin-left: 7px;"></i><span id="SmsTemplate"></span></a></span>
</div>

<%-- <A CLASS="ADD_BTN SUB-BTN1 FANCYBOX" HREF="<%=REQUEST.GETCONTEXTPATH() %>/SEND-EMAIL.HTML"><I CLASS="FA FA-ENVELOPE-O"></I></A> --%>
<%-- <a class="add_btn sub-btn1 fancybox" href="<%=request.getContextPath() %>/send-sms.html"><i class="fa fa-comment-o"></i></a> --%>
</div>
</div>
</div>
<div class="clearfix mb10">
<div class="col-sm-12 col-xs-12 box-intro-background">
<div class="clearfix add-enquery">
<button type="button" class="mrt10 bt-link bt-radius bt-loadmore" onclick="location.reload();">Cancel</button>
<button type="submit" class="bt-link bt-radius bt-loadmore" onclick="return checkStatus()">Submit</button>
</div>
</div>

</div>
</div>
</form>
</div>
</div>

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
<div class="col-md-12 col-sm-12 col-xs-12 cmhistscroll">
<% 	
    
String[][] getStatusReport=TaskMaster_ACT.getStatusReport(uid,token,taskdata[0][6]); 
if(getStatusReport.length>0){
for(int i=0;i<getStatusReport.length;i++)
{
    	  
%> 
<div class="clearfix communication_history">
<%if(!getStatusReport[i][10].equalsIgnoreCase(uarefid)){ %>
<div class="communication_item clearfix">
<div class="communication_item_lft">
<span class="communication_icon">
<img src="<%=request.getContextPath() %>/staticresources/images/male_icon1.png">
</span>
<div class="clearfix communication_info">
<span class="cmhistname"><%=getStatusReport[i][7]%><%if(!getStatusReport[i][8].equalsIgnoreCase("NA")){%>&nbsp;<i class="fa fa-caret-right"></i>&nbsp;<%=getStatusReport[i][8]%><%} %></span>
<span class="clearfix cmhistmsg">
<span><%=getStatusReport[i][0]%></span>
</span>
<span class="cmhist"><%=getStatusReport[i][2]%>&nbsp;<%=getStatusReport[i][1]%><%if(!getStatusReport[i][6].equalsIgnoreCase("NA")){ %><i class="fa fa-caret-right"></i><%=getStatusReport[i][6]%><%} %></span>
</div>
</div>
<span class="action_box"><%if(!getStatusReport[i][9].equalsIgnoreCase("NA")){%>
<a class="fancy_box" href="<%=request.getContextPath() %>/documents/<%=getStatusReport[i][9]%>"><i class="fa fa-file-text-o"></i></a><%} %>
</span>
</div>
<%}else{if(getStatusReport[i][10].equalsIgnoreCase(uarefid)){ %>
<div class="communication_item_rt clearfix">
<div class="clearfix communication_info">
<span class="cmhistname"><%=getStatusReport[i][7]%><%if(!getStatusReport[i][8].equalsIgnoreCase("NA")){%>&nbsp;<i class="fa fa-caret-right"></i>&nbsp;<%=getStatusReport[i][8]%><%} %></span>
<span class="clearfix cmhistmsg">
<span><%=getStatusReport[i][0]%></span>
</span>
</div>
<span class="communication_icon">
<img src="<%=request.getContextPath() %>/staticresources/images/male_icon2.png">
</span>
</div>
<%}} %>
</div> 
 
 
 
 
<!-- <div class="clearfix follow_status"> -->
<!-- <div class="clearfix link-style12"> -->
<!-- <div class="col-sm-11 col-xs-12 box-intro-background"> -->
<!-- <div class="box-width25 col-sm-2 col-xs-12 box-intro-background"> -->
<!-- <p class="news-border" title=""></p> -->
<!-- </div> -->
<!-- <div class="box-width26 col-sm-5 col-xs-12 box-intro-background" style="background: #f6f6f6;"> -->
<%-- <p class="news-border" title="<%=getStatusReport[i][7]%>"></p> --%>
<!-- </div> -->
<!-- <div class="box-width42 col-sm-5 col-xs-12 box-intro-background"> -->
<%-- <p class="news-border" title="<%=getStatusReport[i][6]%>"><%=getStatusReport[i][6]%></p> --%>
<!-- </div> -->
<!-- <div class="box-width8 col-sm-3 col-xs-12 box-intro-background"> -->
<%-- <p class="news-border" title=""><%String x[]=getStatusReport[i][2].split(" ");%><%=x[0] %></p> --%>
<!-- </div> -->
<!-- <div class="box-width8 col-sm-3 col-xs-12 box-intro-background "> -->
<%-- <p class="news-border" title=""><%=getStatusReport[i][1]%></p> --%>
<!-- </div> -->
<!-- </div> -->
<!-- <div class="col-sm-1 col-xs-12 box-intro-background"> -->
<%-- <p><a class="quick-view" href="##manageFollowup" onclick="document.getElementById('userid').innerHTML='<%=getStatusReport[i][3]%>'"><i class="fa fa-trash-o"></i></a></p> --%>
<!-- </div> -->
<!-- </div> -->
<!-- <div class="clearfix"> -->
<!-- <div class="col-sm-11 col-xs-12 box-intro-background"> -->
<%-- <p class="desc" title="<%=getStatusReport[i][0]%>"><%=getStatusReport[i][0]%></p> --%>
<!-- </div> -->
<!-- </div> -->
<!-- </div> -->
<% }}else{ %>
<div class="text-center clearfix"><h5 class="txt_blue">No Data Found!</h5></div>
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
$(".fancybox").fancybox({
    'width'             : '500px',
    'height'            : '100%',
    'autoScale'         : false,
    'transitionIn'      : 'none',
    'transitionOut'     : 'none',
    'type'              : 'iframe',
    'hideOnOverlayClick': false,
});
$(".fancybox1").fancybox({
    'width'             : '700px',
    'height'            : '100%',
    'autoScale'         : false,
    'transitionIn'      : 'none',
    'transitionOut'     : 'none',
    'type'              : 'iframe',
    'hideOnOverlayClick': false,
    afterClose: function () {    
    	parent.location.reload(true);
    }
});

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
	document.getElementById('errorMsg').innerHTML = 'Please Extend Delivery Date.!';
	$('.alert-show').show().delay(4000).fadeOut();
}
	else{
		document.getElementById("DeliveryDate").setAttribute("disabled", true);
		}
}

function getTaskDetails(mid){
	document.getElementById("TaskStatus").value="";
	var x=mid.split("#");
	mid=x[0];
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
			var x=data.split("#");
		document.getElementById("StartDate").value=x[0];
		document.getElementById("DeliveryDate").value=x[1];
		document.getElementById("Delivery_Date").value=x[1];
		getTemplateDetails(mid);
		},
		error: function (error) {
		alert("error in finishorder() " + error.responseText);
		}
		});
}
function getTemplateDetails(mid){
	$.ajax({
	    type: "POST",
	    dataType: "html",
	    url: "<%=request.getContextPath()%>/GetTemplateDetails111",
	    data:  { 
	    	mid: mid,	    	
	    },
	    success: function (response) {
	     	response = JSON.parse(response);			
			 var len = response.length;
			 if(len>0)document.getElementById("Template").style.display="block";
			    for( var i =0; i<len; i++){			
					var tid = response[i]['tid'];
				    var tname = response[i]['tname'];
				    var ttype = response[i]['ttype'];
				if(ttype=="Email"){
					document.getElementById("EmailTemplate").innerHTML=tname;
					$("#EmailHref").attr("class","fancybox");
					$("#EmailHref").attr("href","editTemplate-"+tid+".html?acr54yd=cgfgyhb9ui");
				}else if(ttype="Sms"){
					document.getElementById("SmsTemplate").innerHTML=tname;
					$("#SmsHref").attr("class","fancybox");
					$("#SmsHref").attr("href","editTemplate-"+tid+".html?acr54yd=cgfgyhb9ui");				
				}
				}
	    },
	    error: function (error) {
	    	alert("error in setCatName() " + error.responseText);
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
	document.getElementById('errorMsg').innerHTML = 'Select Task.!';
	$('.alert-show').show().delay(1000).fadeOut();
return false;
}
if(document.getElementById("TaskStatus").value.trim()==""){
	document.getElementById('errorMsg').innerHTML = 'Select Task Status.!';
	$('.alert-show').show().delay(1000).fadeOut();
return false;
}
if(document.getElementById("DeliveryDate").value.trim()==""){
	document.getElementById('errorMsg').innerHTML = 'Select Delivery Date.!';
	$('.alert-show').show().delay(1000).fadeOut();
return false;
}
var remarks =nicEditors.findEditor( "ptsremarks" ).getContent();
if(remarks.length<10 ) {
	document.getElementById('errorMsg').innerHTML = 'Minimum 10 Character Remarks Required.!';
	$('.alert-show').show().delay(1500).fadeOut();
return false;
}
if(document.getElementById("showclient").value.trim()==""){
	document.getElementById('errorMsg').innerHTML = 'Select Show To Client ?.!';
	$('.alert-show').show().delay(1000).fadeOut();
return false;
}

<%-- var pregcuid="<%=taskdata[0][12]%>"; --%>
<%-- var preguid="<%=taskdata[0][11]%>"; --%>
<%-- var pregno="<%=taskdata[0][10]%>"; --%>
// var ptstid=document.getElementById("PTSTID").value.trim();
// var ptsremarks=nicEditors.findEditor( "ptsremarks" ).getContent();
// var ptsstatus=document.getElementById("TaskStatus").value.trim();
// var ptsaddedby=document.getElementById("addedBy").value.trim();
// var mid=document.getElementById("TaskId").value.trim();
// var deliverydate=document.getElementById("DeliveryDate").value.trim();
// var loginname=document.getElementById("loginname").value.trim();
// var showclient=document.getElementById("showclient").value.trim();

// $.ajax({
// 	type: "POST",
// 	dataType: "html",
<%-- 	url: "<%=request.getContextPath()%>/Project-Status.html", --%>
// 	data:  {
// 		ptstid: ptstid,
// 		ptsremarks: ptsremarks,
// 		ptsstatus: ptsstatus,
// 		ptsaddedby: ptsaddedby,
// 		mid: mid,
// 		deliverydate: deliverydate,	
// 		preguid : preguid,
// 		loginname : loginname,
// 		showclient : showclient,
// 		pregno : pregno,
// 		pregcuid : pregcuid
// 	},
// 	success: function (data) {
// 		if(ptsstatus=="Completed"){
<%-- 			window.location = "<%=request.getContextPath()%>/mytask.html"; --%>
// 		}else{
// 				location.reload(true);
// 		}
// 	},
// 	error: function (error) {
// 	alert("error in finishorder() " + error.responseText);
// 	}
// 	});
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
<script>
  $( function() {
    $( "#slider-range" ).slider({
      range: "max",
      min: 0,
      max: 100,
      value: 0,
      slide: function( event, ui ) {
        $( "#amount" ).val( ui.value + "%" );
      }
    });
    $( "#amount" ).val( $( "#slider-range" ).slider( "value" ) + "%" );
  });
</script>
</body>
</html>