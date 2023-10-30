<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Follow Up Project</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
<style type="text/css">
/* width */
::-webkit-scrollbar {
  width: 10px;
  height: 10px;
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
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%-- <%if(!CM06){%><jsp:forward page="/login.html" /><%} %> --%>
<%
DateFormat df = new SimpleDateFormat("dd-MM-yyyy");
Calendar calobj = Calendar.getInstance();
String today = df.format(calobj.getTime());
String assignto[][]=null;
String uarefid= (String)session.getAttribute("uarefid");
String userroll= (String)session.getAttribute("emproleid");
String token = (String) session.getAttribute("uavalidtokenno");
String uid=(String) session.getAttribute("passid");
String[][] getProjectById = Clientmaster_ACT.getProjectByID(uid,token);
if(getProjectById!=null&&getProjectById.length>0){
assignto=Clientmaster_ACT.getAssignTo(getProjectById[0][6],token); 
}
// System.out.println("getProjectById[0][6]="+getProjectById[0][6]);

String loginname=Clientmaster_ACT.getLoginUserName((String)session.getAttribute("loginuaid")); 
if(loginname==null||loginname.length()<=0)loginname="NA";
%>
<div id="content">
<div class="container">
<div class="bread-crumb">
<div class="bd-breadcrumb bd-light">
<a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
<a>Follow Up</a>
</div>
</div>
</div>
<div class="main-content">
<div class="container">
<div class="clearfix text-right mb10">
<a href="<%=request.getContextPath()%>/manage-project.html"><button class="bkbtn">Back</button></a>
</div>
<div class="row">
<div class="col-md-5 col-sm-5 col-xs-12">
<div class="menuDv clearfix">
<div class="mb0 clearfix project_title top_title">
<div class="pad0 col-md-8 col-sm-8 col-xs-12">
<h3><span title="<%=getProjectById[0][6] %>&nbsp;:&nbsp;<%=getProjectById[0][2] %>"><%=getProjectById[0][6] %>&nbsp;:&nbsp;<%=getProjectById[0][2] %></span></h3>
</div>
<div class="pad0 col-md-4 col-sm-4 col-xs-12">
<p class="text-right"><%=getProjectById[0][5] %></p>
</div>
</div>

<div class="clearfix">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Client Name</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p class="txt_blue" title="<%=getProjectById[0][1] %>"><%=getProjectById[0][1] %></p>
</div>
</div>
<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Project Id</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p class="txt_blue" title="<%=getProjectById[0][6] %>"><%=getProjectById[0][6] %></p>
</div>
</div>
<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Project Type</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=getProjectById[0][3] %>"><%=getProjectById[0][3] %></p>
</div>
</div>
<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Project Name</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p class="txt_blue" title="<%=getProjectById[0][2] %>"><%=getProjectById[0][2] %></p>
</div>
</div>
<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Starting Date</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=getProjectById[0][4] %>"><%=getProjectById[0][4] %></p>
</div>
</div>
<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Delivery Date</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=getProjectById[0][5] %>"><%=getProjectById[0][5] %></p>
</div>
</div>
<div class="clearfix project_detail_box">
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
<%if(!getProjectById[0][12].equalsIgnoreCase("Delivered")){ %>
<div class="menuDv clearfix attr-color">
<div class="mb0 pad_box2 top_title pointers add_follow_title">
<h2>Follow Up</h2>
<i class="fa fa-plus" title="Add Follow-Up"></i>
</div>
<div class="clearfix partner-slider8" style="display: none;">
<form action="<%=request.getContextPath() %>/billing-follow-up.html" method="post" name="follow-up-form" enctype="multipart/form-data">
<input type="hidden" name="transferpage" value="followupproject.html" readonly>
<input type="hidden" name="fromfollowup" value="project" readonly>
<input type="hidden" name="clientid" value="<%=getProjectById[0][7]%>" readonly>
<input type="hidden" name="projectno" value="<%=getProjectById[0][6]%>" readonly>
<input type="hidden" name="pfupid" id="pfupid" value="<%=getProjectById[0][0]%>" readonly>
<input type="hidden" name="pfupname" id="pfupname" value="<%=getProjectById[0][2].replace(" ", "").toUpperCase()%>" readonly>
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix footer-bottom2">
<div class="col-sm-3 col-xs-12  box-intro-background">
<div class="add-enquery">
<select name="pfustatus" id="pfustatus" class="form-control"  onchange="checkDeliverDate(this.value)">
<option value="">Select Status</option>
 <option value="On Hold" style="color: gray;">On Hold</option>         
 <option value="Pending" style="color: blue;">Pending</option>
 <option value="Open" style="color: orange;">Open</option>
 <option value="Completed" style="color: black;">Completed</option>         
</select>
</div>
</div>
<div class="col-sm-3 col-xs-12  box-intro-background">
<div class="add-enquery">
<select name="pfumsgfor" id="pfumsgfor" class="form-control">
<option value="">Select Msg. For</option>
<option value="All">Message For All</option><%if(assignto.length>0&&assignto!=null){for(int i=0;i<assignto.length;i++){ %>
 <option value="<%=assignto[i][0]%>"><%=assignto[i][0]%></option> <%}} %>       
</select>
</div>
</div>
<div class="col-sm-3 col-xs-12  box-intro-background" style="display: none;">
<div class="add-enquery">
<input type="text" name="followupby" id="followupby" value="<%=loginname%>" class="form-control" class="form-control">
</div>
</div>
<div class="col-sm-3 col-xs-12  box-intro-background">
<div class="add-enquery">
<input type="text" name="pfudate" title="Today's Date" id="pfudate" placeholder="Date of Follow Up" value="<%=today %>" class="form-control readonlyAllow" readonly>
</div>
</div>
<div class="col-sm-3 col-xs-12  box-intro-background">
<div class="add-enquery">
<input type="text" name="pfuddate" title="Delivery Date" id="pfuddate" placeholder="Date of Delivery" value="<%=getProjectById[0][5] %>" class="form-control datetimepicker readonlyAllow" data-date-format="dd-mm-yyyy  HH:ii p" readonly disabled="disabled">
<input type="hidden" name="deliverydate" id="deliverydate" value="<%=getProjectById[0][5] %>">
</div>
</div>
</div>
<div class="clearfix">
<div class="col-xs-12  box-intro-background">
<div class="add-enquery nicEdit_box">
<textarea name="pfuremark" id="pfuremark" class="form-control"></textarea>
</div>
<div id="pfuremarkerr" class="errormsg"></div>
</div>
</div>
<div class="clearfix">
<div class="col-sm-4 col-xs-12  box-intro-background">
<div class="add-enquery">
<select name="showclient" id="showclient" class="form-control">
<option value="">Show to Client?</option>
<option value="1">Yes</option>
<option value="0">No</option></select>
</div>
</div>
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
<div class="col-sm-4 col-xs-12 box-intro-background">
<div class="clearfix add-enquery text-right">
<button type="submit" class="bt-style1 bt-link bt-radius bt-loadmore" onclick="return statusValidations();">Add</button>
</div>
</div>
</div>
</div>
</form>
</div>
</div>
<%} %>
<div class="clearfix menuDv attr-color">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="top_title pad_box2">
<h2>Communication History</h2>
</div>
<%-- <a class="mrt10 pad-top5 add_btn font_size15"><strong>Delivery Date : </strong><%=getProjectById[0][5] %></a> --%>
</div>
</div>
<div id="reload">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12 cmhistscroll">
<%
String[][] getFollowUpById = Clientmaster_ACT.getFollowUpById(getProjectById[0][0],token);
if(getFollowUpById.length>0){
for(int i=0;i<getFollowUpById.length;i++) {
%>
<div class="clearfix communication_history">
<%if(!getFollowUpById[i][10].equalsIgnoreCase(uarefid)){ %>
<div class="communication_item clearfix">
<div class="communication_item_lft">
<span class="communication_icon">
<img src="<%=request.getContextPath() %>/staticresources/images/male_icon1.png">
</span>
<div class="clearfix communication_info">
<span class="cmhistname"><%=getFollowUpById[i][6] %>&nbsp;<%if(!getFollowUpById[i][8].equalsIgnoreCase("NA")){%>&nbsp;<i class="fa fa-caret-right"></i>&nbsp;<%=getFollowUpById[i][8]%><%} %></span>
<span class="clearfix cmhistmsg">
<span><%=getFollowUpById[i][5]%></span>
</span>
<span class="cmhist"><%=getFollowUpById[i][3] %>&nbsp;<%=getFollowUpById[i][2] %>&nbsp;<%if(!getFollowUpById[i][9].equalsIgnoreCase("NA")){ %><i class="fa fa-caret-right"></i><%=getFollowUpById[i][9]%><%} %></span>
</div>
</div>
<span class="action_box"><%if(!getFollowUpById[i][7].equalsIgnoreCase("NA")){%>
<a class="fancy_box" href="<%=request.getContextPath() %>/documents/<%=getFollowUpById[i][7]%>"><i class="fa fa-file-text-o"></i></a><%} %>
<a <%if(userroll.equalsIgnoreCase("Administrator")){ %>onclick="deleteFollowUp(<%=getFollowUpById[i][0]%>);"<%}else{ %>style="cursor: not-allowed;"<%} %>><i class="fa fa-trash-o"></i></a>
</span>
</div>
<%}else{if(getFollowUpById[i][10].equalsIgnoreCase(uarefid)){ %>
<div class="communication_item_rt clearfix">
<div class="clearfix communication_info">
<span class="cmhistname"><%=getFollowUpById[i][6] %>&nbsp;<%if(!getFollowUpById[i][8].equalsIgnoreCase("NA")){%>&nbsp;<i class="fa fa-caret-right"></i>&nbsp;<%=getFollowUpById[i][8]%><%} %></span>
<span class="clearfix cmhistmsg">
<span><%=getFollowUpById[i][5]%></span>
</span>
</div>
<span class="communication_icon">
<img src="<%=request.getContextPath() %>/staticresources/images/male_icon2.png">
</span>
</div>
<%}} %>
</div>
<% }}else{ %>
<center>
<h5 class="txt_blue">No History Found</h5>
</center>
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
function checkDeliverDate(val){
	if(val=="On Hold"){
	document.getElementById("pfuddate").removeAttribute("disabled"); 
	document.getElementById('errorMsg').innerHTML = 'Please Extend Delivery Date.!';
	$('.alert-show').show().delay(4000).fadeOut();
}
	else{
		document.getElementById("pfuddate").setAttribute("disabled", true);
		}
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
// $(function() {
// $("#pfuddate").datepicker({
// changeMonth: true,
// changeYear: true,
// dateFormat: 'dd-mm-yy',
// });
// });
function statusValidations() {
if(document.getElementById('pfustatus').value.trim()=="" ) {
	document.getElementById('errorMsg').innerHTML = 'Status Is Required.!';
	$('.alert-show').show().delay(1000).fadeOut();
return false;
}
if(document.getElementById('pfumsgfor').value.trim()=="" ) {
	document.getElementById('errorMsg').innerHTML = 'Select Message For.!';
	$('.alert-show').show().delay(1000).fadeOut();
return false;
}
if(document.getElementById('followupby').value.trim()=="" ) {
	document.getElementById('errorMsg').innerHTML = 'Follow-Up By Is Required.!';
	$('.alert-show').show().delay(1000).fadeOut();
return false;
}
if(document.getElementById('pfudate').value.trim()=="" ) {
	document.getElementById('errorMsg').innerHTML = 'Follow-Up Date Is Required.!';
	$('.alert-show').show().delay(1000).fadeOut();
return false;
}

if(document.getElementById('pfuddate').value.trim()=="" ) {
	document.getElementById('errorMsg').innerHTML = 'Delivery Date Is Required.!';
	$('.alert-show').show().delay(1000).fadeOut();
return false;
}
var remarks =nicEditors.findEditor( "pfuremark" ).getContent();
if(remarks.length<10 ) {
	document.getElementById('errorMsg').innerHTML = 'Minimum 10 Character Remarks Required.!';
	$('.alert-show').show().delay(1500).fadeOut();
return false;
}
if(document.getElementById('showclient').value.trim()=="" ) {
	document.getElementById('errorMsg').innerHTML = 'Select Show To Client Or Not ?.!';
	$('.alert-show').show().delay(1000).fadeOut();
return false;
}
}

function deleteFollowUp(id) {
var xhttp;
xhttp = new XMLHttpRequest();
xhttp.onreadystatechange = function() {
if (this.readyState == 4 && this.status == 200) {
	$("#reload").load(location.href + " #reload");
<%-- 	location.href="<%=request.getContextPath()%>/followupproject.html" --%>
}
};
xhttp.open("GET", "<%=request.getContextPath()%>/DeleteProjectFollowUp111?info="+id, true);
xhttp.send();
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
            	pfuatoErr.style.color="#333";
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
bkLib.onDomLoaded(function(){nicEditors.editors.push(new nicEditor().panelInstance(document.getElementById('pfuremark')));});
$(function() {
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/markprojectread",
	    data:  { 
	    	"uid" : <%=uid%>
	    }
	});
});

$(".fancy_box").fancybox({
	width  : 950,
    height : 600,
    type   : 'iframe',
    iframe : {
        preload: false
    }
});
</script>
<div id="showremarks" style="display: none; width: 700px; max-height: 400px; overflow-x: hidden; overflow-y: auto;">
<div class="container">
<p id="datahere"></p>
</div>
</div>
</body>
</html>