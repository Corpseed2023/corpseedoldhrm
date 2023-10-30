<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Manage Project</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%
String addedby= (String)session.getAttribute("loginuID");
String clientname = (String) session.getAttribute("mpclientname");
String clientid = (String) session.getAttribute("mpclientid");
String projectname = (String) session.getAttribute("mpprojectname");
String projecttype = (String) session.getAttribute("mpprojecttype");
String deliverymonth = (String) session.getAttribute("mpdeliverymonth");
String pstatus = (String) session.getAttribute("mppstatus");
String from = (String) session.getAttribute("mpfrom");
String to = (String) session.getAttribute("mpto");
String userroll= (String)session.getAttribute("emproleid");
String token = (String) session.getAttribute("uavalidtokenno");

if(clientname==null||clientname.length()<=0)clientname="NA";
if(clientid==null||clientid.length()<=0)clientid="NA";
if(projectname==null||projectname.length()<=0)projectname="NA";
if(projecttype==null||projecttype.length()<=0)projecttype="NA";
if(deliverymonth==null||deliverymonth.length()<=0)deliverymonth="NA";
if(pstatus==null||pstatus.length()<=0)pstatus="NA";
if(from==null||from.length()<=0)from="NA";
if(to==null||to.length()<=0)to="NA";

// String[][] project=Clientmaster_ACT.getAllproject("LIMIT 25", projectname, projecttype,deliverymonth,pstatus, clientid, token, from , to,userroll);
String[][] project=null;
%>
<%-- <%if(!CMP04){%><jsp:forward page="/login.html" /><%} %> --%>
<div id="content">

<div class="main-content">
<div class="container">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="menuDv partner-slider8">

<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="top_title text-center">
<h2>Manage Project</h2>
</div>
<%-- <%if(CM02){%><a class="add_btn sub-btn1" href="<%=request.getContextPath() %>/project-registration.html">Project Registration</a><%} %> --%>
</div>
</div>

<form name="RefineSearchenqu" action="<%=request.getContextPath()%>/manage-project.html" method="Post">
<input type="hidden" name="pageName" id="pageName"  value="manageservice.jsp">
<input type="hidden" name="jsstype" id="jsstype">
<div class="home-search-form clearfix">
<div class="item-bestsell col-sm-111 col-xs-12" style="width: 12%;">
<p><input type="text" name="clientname" id="clientname" autocomplete="off" <% if(!clientname.equalsIgnoreCase("NA")){ %>value="<%=clientname%>"<%} %> placeholder="Client" class="form-control"/>
<input type="hidden" id="clientid" name="clientid" <% if(!clientid.equalsIgnoreCase("NA")){ %>value="<%=clientid%>"<%} %> /></p>
</div>
<div class="item-bestsell col-sm-111 col-xs-12" style="width: 12%;">
<p><input type="text" name="projectname" id="projectname" autocomplete="off" <% if(!projectname.equalsIgnoreCase("NA")){ %>value="<%=projectname%>"<%} %> placeholder="Project name" class="form-control"/></p>
</div>
<div class="item-bestsell col-sm-111 col-xs-12" style="width: 12%;">
<p><input type="text" name="projecttype" id="projecttype" <% if(!projecttype.equalsIgnoreCase("NA")){ %>value="<%=projecttype%>"<%} %> placeholder="Project Type" class="form-control"/></p>
</div>
<div class="item-bestsell col-sm-111 col-xs-12" style="width: 12%;">
<p><input type="text" name="deliverymonth" id="deliverymonth" <% if(!deliverymonth.equalsIgnoreCase("NA")){ %>value="<%=deliverymonth%>"<%} %> placeholder="Deliver Month" class="form-control datepicker readonlyAllow" readonly/></p>
</div>
<div class="item-bestsell col-sm-111 col-xs-12" style="width: 12%;">
<p><select name="pstatus" id="pstatus" class="form-control"><% if(!pstatus.equalsIgnoreCase("NA")){ %><option value="<%=pstatus%>"><%=pstatus%></option><%}%>
<option value="">Select Status</option><option value="Working">Open</option><option value="Delivered">Delivered</option></select></p>
</div>			
<div class="item-bestsell col-sm-111 col-xs-12" style="width: 12%;">
<p><input type="text" name="from" id="from" <% if(!from.equalsIgnoreCase("NA")){ %>value="<%=from%>"<%} %> placeholder="From" class="form-control searchdate readonlyAllow" readonly/></p>
</div>
<div class="item-bestsell col-sm-111 col-xs-12" style="width: 12%;">
<p><input type="text" name="to" id="to" <% if(!to.equalsIgnoreCase("NA")){ %>value="<%=to%>"<%} %> placeholder="To" class="form-control searchdate readonlyAllow" readonly/></p>
</div>
<div class="item-bestsell col-md-2 col-sm-1 col-xs-12 search-cart-total" style="width: 13%;">
<button class="btn-link-default bt-radius" type="submit" name="button" value="Search"><i class="fa fa-search" title="Search"></i></button>
<button class="btn-link-default bt-radius" type="submit" name="button" value="Reset"><i class="fa fa-refresh" title="Reset"></i></button>
</div>
</div>
</form>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix box-intro-bg">
<div class="box-width24 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">SN</p>
</div>
</div>
<div class="box-width21 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Project Id</p>
</div>
</div>
<div class="box-width5 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Client's Name</p>
</div>
</div>
<div class="box-width9 col-xs-12 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Project's Name</p>
</div>
</div>
<div class="box-width12 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Project Type</p>
</div>
</div>
<div class="box-width21 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Start Date</p>
</div>
</div>
<div class="box-width16 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Delivery Date/Time</p>
</div>
</div>
<div class="box-width21 col-xs-3 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Status</p>
</div>
</div>
<div class="box-width20 col-xs-3 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Progress</p>
</div>
</div>
<div class="box-width20 col-xs-3 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Assigned</p>
</div>
</div>
<div class="box-width9 col-xs-3 box-intro-bg">
<div class="box-intro-border">
<p class="">Action</p>
</div>
</div>
</div>
</div>
</div>
<div id="target" class="clearfix">
<%
String clientName=null;
int milestone=0;
int progress=0;
int completedtask=0;
boolean ass_status=false;
for(int i=0;i<project.length;i++) {
	ass_status=Clientmaster_ACT.getAssignedStatus(project[i][3],token);
	if(ass_status){
	milestone=Clientmaster_ACT.getAllMileStone(project[i][0],token);
	completedtask=Clientmaster_ACT.getAllCompletedTask(project[i][3],token);
	if(milestone==completedtask) progress=100;
	else
	progress=Math.round((100/milestone)*completedtask);
	}
if(i%2==0){
	clientName=Clientmaster_ACT.getClientName(project[i][10],token);
	
%>
<div class="clearfix box_shadow2" <%if(project[i][6].equals("0")){%>style="background-color: #4a6182; color:#fff; "<%}%>>
<div class="box-width24 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=project.length-i %></p>
</div>
</div>
<div class="box-width21 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=project[i][3] %>"><%=project[i][3] %></p>
</div>
</div>
<div class="box-width5 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=clientName %>"><%=clientName %></p>
</div>
</div>
<div class="box-width9 col-xs-12 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=project[i][2] %>"><%=project[i][2] %></p>
</div>
</div>
<div class="box-width12 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=project[i][1] %>"><%=project[i][1] %></p>
</div>
</div>

<div class="box-width21 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=project[i][4] %>"><%=project[i][4] %></p>
</div>
</div>
<div class="box-width16 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=project[i][5] %>"><%=project[i][5] %></p>
</div>
</div>
<div class="box-width21 col-xs-3 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=project[i][11] %>"><%=project[i][11] %></p>
</div>
</div>
<div class="box-width20 col-xs-3 box-intro-background">
<div class="link-style12">
<p class="news-border text-orange" title="" style="color: green;"><%if(ass_status){ %><%=progress%> %<%}else{%>0 %<%} %></p>
</div>
</div>
<div class="box-width20 col-xs-3 box-intro-background">
<div class="link-style12">
<p class="news-border text-center" title=""><%if(ass_status){ %><span><i class="fa fa-check"></i></span><span class="pointers"   data-toggle="modal" data-target="#assignedTo"><i class="fa fa-eye mlft10" style="display: none;"></i></span><%}else{ %><i class="fa fa-close"></i><%} %></p>
</div>
</div>
<div class="box-width9 col-xs-3 box-intro-background">
<div class="link-style12">
<p>
<%-- <%if(CM03){%><a class="fancybox" href="<%=request.getContextPath()%>/setPrice-<%=project[i][0] %>.html"><i class="fa fa-inr" title="Set Price Of This Project"></i></a><%} %> --%>
<%-- <%if(CM04){%><a class="fancybox" href="<%=request.getContextPath()%>/setMilestone-<%=project[i][0] %>.html"><i class="fa fa-font-awesome " title="Set Milestone Of This Project"></i></a><%} %> --%>
<%-- <%if(CM05){%><a href="javascript:void(0);" onclick="vieweditpage(<%=project[i][0] %>,'assign-task');"><i class="fa fa-tasks" title="Assign Tasks"></i></a><%} %> --%>
<!-- <!-- disable due to same follow-up controller page of billing follow-up --> -->
<%-- <%if(CM06){%><a href="javascript:void(0);" onclick="vieweditpage(<%=project[i][0] %>,'follow-up');"><i class="fa fa-comments" title="Follow-Up"></i></a><%} %> --%>
<%-- <%-- <a href="javascript:void(0);" onclick="vieweditpage(<%=project[i][0] %>, 'upload');"><i class="fa fa-upload" title="Upload Documents."></i></a> --%> --%>
<%-- <%if(CM07){%><a href="javascript:void(0);" onclick="vieweditpage(<%=project[i][0] %>,'edit');"><i class="fa fa-edit" title="Edit project"></i></a><%} %> --%>
<%-- <%if(CM08||CM09){%><a class="quick-view" href="#manageProject" onclick="document.getElementById('userid').innerHTML='<%=project[i][0] %>';document.getElementById('pregpuno').innerHTML='<%=project[i][3] %>';document.getElementById('cid').innerHTML='<%=project[i][10] %>';"><i class="fa fa-trash" title="Activate/Deactivate/Delete this Project"></i></a><%} %> --%>
</p>
</div>
</div>
</div>
<%} else{
	clientName=Clientmaster_ACT.getClientName(project[i][10],token);
%>
<div class="list-boxBg box_shadow2 clearfix" <%if(project[i][6].equals("0")){%>style="background-color: #4a6182; color:#fff; "<%}%>>
<div class="box-width24 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=project.length-i %></p>
</div>
</div>
<div class="box-width21 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=project[i][3] %>"><%=project[i][3] %></p>
</div>
</div>
<div class="box-width5 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=clientName %>"><%=clientName %></p>
</div>
</div>
<div class="box-width9 col-xs-12 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=project[i][2] %>"><%=project[i][2] %></p>
</div>
</div>
<div class="box-width12 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=project[i][1] %>"><%=project[i][1] %></p>
</div>
</div>

<div class="box-width21 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=project[i][4] %>"><%=project[i][4] %></p>
</div>
</div>
<div class="box-width16 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=project[i][5] %>"><%=project[i][5] %></p>
</div>
</div>
<div class="box-width21 col-xs-3 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=project[i][11] %>"><%=project[i][11] %></p>
</div>
</div>
<div class="box-width20 col-xs-3 box-intro-background">
<div class="link-style12">
<p class="news-border" title="" style="color: green;"><%if(ass_status){ %><%=progress%> %<%}else{%>0 %<%} %></p>
</div>
</div>
<div class="box-width20 col-xs-3 box-intro-background">
<div class="link-style12">
<p class="news-border text-center" title=""><%if(ass_status){ %><span><i class="fa fa-check"></i></span><span class="pointers"   data-toggle="modal" data-target="#assignedTo"><i class="fa fa-eye mlft10" style="display: none;"></i></span><%}else{ %><i class="fa fa-close"></i><%} %></p>
</div>
</div>
<div class="box-width9 col-xs-3 box-intro-background">
<div class="link-style12">
<p>
<%-- <%if(CM03){%><a class="fancybox" href="<%=request.getContextPath()%>/setPrice-<%=project[i][0] %>.html"><i class="fa fa-inr" title="Set Price Of This Product"></i></a><%} %> --%>
<%-- <%if(CM04){%><a class="fancybox" href="<%=request.getContextPath()%>/setMilestone-<%=project[i][0] %>.html"><i class="fa fa-font-awesome " title="Set Milestone Of This Product"></i></a><%} %> --%>
<%-- <%if(CM05){%><a href="javascript:void(0);" onclick="vieweditpage(<%=project[i][0] %>,'assign-task');"><i class="fa fa-tasks" title="Assign Tasks"></i></a><%} %> --%>
<!-- <!-- disable due to same follow-up controller page of billing follow-up --> -->
<%-- <%if(CM06){%><a href="javascript:void(0);" onclick="vieweditpage(<%=project[i][0] %>,'follow-up');"><i class="fa fa-comments" title="Follow-Up"></i></a><%} %> --%>
<%-- <%-- <a href="javascript:void(0);" onclick="vieweditpage(<%=project[i][0] %>, 'upload');"><i class="fa fa-upload" title="Upload Documents."></i></a> --%> --%>
<%-- <%if(CM07){%><a href="javascript:void(0);" onclick="vieweditpage(<%=project[i][0] %>,'edit');"><i class="fa fa-edit" title="Edit project"></i></a><%} %> --%>
<%-- <%if(CM08||CM09){%><a class="quick-view" href="#manageProject" onclick="document.getElementById('userid').innerHTML='<%=project[i][0] %>';"><i class="fa fa-trash" title="Activate/Deactivate/Delete this Project"></i></a><%} %> --%>
</p>
</div>
</div>
</div>
<%} }%>
</div>
</div>
</div>
</div>
</div>
<p id="end" style="display: none;"></p>
</div>
</div>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>
<section class="clearfix" id="manageProject" style="display: none;">
<div class="clearfix  text-center">
<div class="col-md-12 col-xs-12" id="userid" style="display: none;"></div>
<div class="col-md-12 col-xs-12" id="pregpuno" style="display: none;"></div>
<div class="col-md-12 col-xs-12" id="cid" style="display: none;"></div>
<div class="col-md-12 col-xs-12">
<div class="box-intro1">
  <h2><span class="title">Activate/Deactivate/Delete This Project ?</span></h2>
</div>
</div>
<div class="col-md-12 col-xs-12 mb10">
<a class="sub-btn1" onclick="" id="cancelpopup1" title="Cancel This Process.">Cancel</a>

<%-- <%if(CM08){%><a class="sub-btn1 mlft10" id="" onclick="approve(document.getElementById('userid').innerHTML,'1');" title="Enable This Project">Activate</a> --%>
<%-- <a class="sub-btn1 mlft10" id="" onclick="approve(document.getElementById('userid').innerHTML,'0');" title="Disable This Project.">Deactivate</a><%} %> --%>
<%-- <%if(CM09){%><a class="sub-btn1 mlft10" id="" onclick="deleteProject(document.getElementById('userid').innerHTML,document.getElementById('pregpuno').innerHTML,document.getElementById('cid').innerHTML);" title="Delete This Project.">Delete</a><%} %> --%>
</div>
</div>
</section>

<!-- assignedTo Modal -->
<div id="assignedTo" class="my_modal modal fade" role="dialog">
  <div class="modal-dialog">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Assigned To</h4>
      </div>
      <div class="modal-body">
        <p>Some text</p>
        <p>Some text</p>
        <p>Some text</p>
        <p>Some text</p>
        <p>Some text</p>
      </div>
    </div>
  </div>
</div>

<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">	
$(".fancybox").fancybox({
    'width'             : '100%',
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
	$('#cancelpopup').click(function(){
		  $.fancybox.close();
	});
</script>
<script type="text/javascript">	
	$('#cancelpopup1').click(function(){
		  $.fancybox.close();
	});
</script>
<script>
$(function() {
	$("#projecttype").autocomplete({
		source : function(request, response) {
			if(document.getElementById('projecttype').value.trim().length>=2)
			$.ajax({
				url : "getprojectname.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					cid : document.getElementById("clientid").value,
					col : "pregtype"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.type,
							value : item.type,							
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
            	document.getElementById('errorMsg').innerHTML = 'Select From List.';
        		$('.alert-show').show().delay(1000).fadeOut();
        		
            	$("#projecttype").val("");
            }
            else{
            	$("#projecttype").val(ui.item.value);
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

$(function() {
	$("#projectname").autocomplete({
		source : function(request, response) {
			if(document.getElementById('projectname').value.trim().length>=2)
			$.ajax({
				url : "getprojectname.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					cid : document.getElementById("clientid").value,
					col : "pregpname"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value,							
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
            	document.getElementById('errorMsg').innerHTML = 'Select From List.';
        		$('.alert-show').show().delay(1000).fadeOut();
        		
            	$("#projectname").val("");
            }
            else{
            	$("#projectname").val(ui.item.value);
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});


$(function() {
	$("#clientname").autocomplete({
		source : function(request, response) {
			if(document.getElementById('clientname').value.trim().length>=2)
			$.ajax({
				url : "getclientname.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					col : "cregname"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value,
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
            	document.getElementById('errorMsg').innerHTML = 'Select From List.';
        		$('.alert-show').show().delay(1000).fadeOut();
        		
            	$("#clientname").val("");
            	$("#clientid").val("");
            }
            else{
            	$("#clientname").val(ui.item.value);
            	$("#clientid").val(ui.item.id);       	
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

$(function() {
$(".datepicker").datepicker({
changeMonth: true,
changeYear: true,
dateFormat: 'mm-yy',
});
});
</script>
 <script type="text/javascript">
 $( function() {
    $(".popup_hold").fancybox({
    	helpers: {
            overlay: { closeClick: false } //Disable click outside event
        }
    });
  });
</script> 
<script type="text/javascript">
var counter=25;
$(window).scroll(function () {
    if ($(window).scrollTop() == $(document).height() - $(window).height()) {
    	appendData();
    }
});

function appendData() {
    var html = '';
    if(document.getElementById("end").innerHTML=="End") return false;
    $.ajax({
    	type: "POST",
        url: '<%=request.getContextPath()%>/getmoreprojects',
        datatype : "json",
        data: {
        	counter:counter,
        	projectname:'<%=projectname%>',
        	projecttype:'<%=projecttype%>',
        	deliverymonth:'<%=deliverymonth%>',
        	pstatus:'<%=pstatus%>',
        	from:'<%=from%>',
        	to:'<%=to%>'
        	},
        success: function(data){
        	for(i=0;i<data[0].project.length;i++){
            	html += '<div class="row"><div class="col-md-12 col-sm-12 col-xs-12"><div class="clearfix" ';
            	if(data[0].project[i][9]=="1"){
            	    html +='style="background-color:#f5caa1"';
            	}
            	else if(data[0].project[i][6]=="Working"){
            	    html+='style="background-color:#aef5a1"';
            	}
            	   html+='><div class="box-width1 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].project[i][0]+'</p></div></div><div class="box-width15 col-xs-12 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].project[i][2]+'</p></div></div><div class="box-width2 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].project[i][1]+'</p></div></div><div class="box-width2 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].project[i][3]+'</p></div></div><div class="box-width2 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].project[i][4]+'</p></div></div><div class="box-width2 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].project[i][5]+'</p></div></div><div class="box-width20 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].project[i][6]+'</p></div></div><div class="box-width2 col-xs-3 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].project[i][8]+'</p></div></div><div class="col-xs-3 box-intro-background"><div class="link-style12"><p><a href="javascript:void(0);" onclick="vieweditpage('+data[0].project[i][0]+', \'upload\');">Upload</a><a href="javascript:void(0);"onclick="vieweditpage('+data[0].project[i][0]+',\'edit\');">Edit</a><a href="javascript:void(0);"onclick="vieweditpage('+data[0].project[i][0]+',\'follow\');">FollowUp</a><a href="javascript:void(0);"onclick="approve('+data[0].project[i][0]+')"> Delete</a></p></div></div></div></div></div>';
            	console.log(html);
            }
            if(html!='') $('#target').append(html);
            else document.getElementById("end").innerHTML = "End";
        }
    });
    
    counter=counter+25;
}
</script>
<script type="text/javascript">
function deleteProject(id,pregpuno,cid){
	var xhttp;
	xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
	if (this.readyState == 4 && this.status == 200) {
	location.reload();
	}
	};
	xhttp.open("GET", "<%=request.getContextPath()%>/DeleteClientProject111?info="+id+"&pregpuno="+pregpuno+"&cid="+cid, true);
	xhttp.send();
}

function approve(id,status) {
var xhttp;
xhttp = new XMLHttpRequest();
xhttp.onreadystatechange = function() {
if (this.readyState == 4 && this.status == 200) {
location.reload();
}
};
xhttp.open("GET", "<%=request.getContextPath()%>/DeleteProject111?info="+id+"&status="+status, true);
xhttp.send();

}

function RefineSearchenquiry() {
document.RefineSearchenqu.jsstype.value="SSEqury";
document.RefineSearchenqu.action="<%=request.getContextPath()%>/manage-project.html";
document.RefineSearchenqu.submit();
}
</script>
<script type="text/javascript">
function vieweditpage(id,page){
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/vieweditpage",
	    data:  { 
	    	"uid" : id
	    },
	    success: function (response) {
        	if(page=="edit") window.location = "<%=request.getContextPath()%>/editproject.html";        	
        	else if(page=="follow-up") window.location = "<%=request.getContextPath()%>/followupproject.html";
        	else if(page=="assign-task") window.location = "<%=request.getContextPath()%>/assigntask-project.html";
<%--         	else if(page=="upload") window.location = "<%=request.getContextPath()%>/uploaddocuments-project.html"; --%>
        },
	});
}
</script>
</body>
</html>