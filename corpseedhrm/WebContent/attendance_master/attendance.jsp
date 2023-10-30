<%@page import="attendance_master.Attendance_ACT"%>
<%@page import="commons.DateUtil"%>
<!DOCTYPE HTML>
<html lang="en-US">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Add Attendance</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
<%@ include file="/staticresources/includes/itswsscripts.jsp" %>
</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%
String addedby= (String)session.getAttribute("loginuID");
String emprole= (String)session.getAttribute("emproleid");
String token=(String)session.getAttribute("uavalidtokenno");
String[][] empdata=Attendance_ACT.getAllEmployee(token);
String getDate=(String)session.getAttribute("getdate");
%> 
<%if(!ATT02){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
<div class="container">   
<div class="bread-crumb">
<div class="bd-breadcrumb bd-light">
<a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
<a>Add Attendance</a>
</div><a href="<%=request.getContextPath()%>/Manage-Attendance.html"><button class="bkbtn" style="margin-left:899px;">Back</button></a>
</div>
</div>
<div class="main-content">
<div class="container">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="menuDv partner-slider8">
<div class="box-intro">
<h2><span class="title">Add Attendance</span></h2>
<div class="select_input_box">
<span class="relative_box"><i class="fa fa-calendar input_icon"></i>
<%if(emprole.equals("Administrator")){ %>
<input type="text" name="Expected_Date" id="Expected_Date" class="chooseDate update-field readonlyAllow" <%if(getDate!=null){ %>value="<%=getDate %>"<%} %> placeholder="Expected Date" onchange="add(this.value);" readonly="readonly"/>
<%}else{ %>
<input type="text" name="Expected_Date" id="ExpectedDate" class="chooseDate update-field readonlyAllow" value="<%=DateUtil.getCurrentDateIndianFormat1() %>" placeholder="Expected Date" readonly="readonly"/>
<%} %>
</span>
</div>
</div>

 <form name="RefineSearchenqu" action="<%=request.getContextPath()%>/manage-attendance.html" method="Post">
    <input type="hidden" name="pageName" id="pageName"  value="manageservice.jsp">
	<input type="hidden" name="jsstype" id="jsstype">
	<div class="home-search-form clearfix">
  	<div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
    <div class="input-group">
    <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
     <select name="EmpID" id="EmpID" class="form-control">
	  <option value="" selected="selected">Select Option</option>
      <option value="">All Employees</option>
  	 </select>
 	 </div>
	</div>
<div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
  <div class="input-group">
  <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>

<!--<p><input type="text" name="MonthDate" id="MonthDate" value="" placeholder="Select Month" class="form-control attend_month" autocomplete="off"/></p> -->
	
	<p><input type="text" name="MonthDate" id="MonthDate" placeholder="Select Month" class="form-control attend_month" autocomplete="off"/></p>
	
    </div>
  </div>
  <div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
    <div class="input-group">
    <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
   
<!--<p><input type="text" name="from" id="from" value="" placeholder="From" class="form-control searchdate" autocomplete="off"/></p> -->
	
	<p><input type="text" name="from" id="from" placeholder="From" class="form-control searchdate" autocomplete="off"/></p>

   </div>
 </div>
 <div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
   <div class="input-group">
   <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
 
<!-- 	<p><input type="text" name="to" id="to" value="" placeholder="To" class="form-control searchdate" autocomplete="off"/></p> -->
	
	<p><input type="text" name="to" id="to" placeholder="To" class="form-control searchdate" autocomplete="off"/></p>

      </div>
    </div>
    <div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
      <button class="btn-link-default bt-radius" type="button"  onclick="RefineSearchenquiry()"><i class="fa fa-search"></i></button>
      <button class="btn-link-default bt-radius" type="button"  onclick="RefineSearchenquiry1()"><i class="fa fa-refresh"></i></button>
      </div>
    </div>
</form>

<div class="row" id="reloaddiv">
<div class="col-md-12 col-sm-12 col-xs-12">
<form method="post">

<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="box-width25 col-md-3 col-xs-12 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">SN</p>
</div>
</div>
<div class="box-width7 col-md-3 col-xs-12 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">ID</p>
</div>
</div>
<div class="box-width18 col-md-3 col-xs-12 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Employee Name</p>
</div>
</div>
<div class="box-width19 col-md-4 col-xs-12 box-intro-bg">
<div class="box-intro-border">
<p class="news-border text-center"><span class="inline_block box-width19">Present</span><span class="inline_block box-width19">Absent</span><span class="inline_block box-width19">Half Day</span></p>
</div>
</div>
<div class="box-width5 col-md-2 col-xs-12 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">In Time</p>
</div>
</div>
<div class="box-width5 col-md-2 col-xs-12 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Out Time</p>
</div>
</div>
<div class="box-width12 col-md-1 col-xs-12 box-intro-bg">
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
<%
String date="";
if(emprole.equals("Administrator")){
date=getDate; 
}else{
	date=DateUtil.getCurrentDateIndianFormat1();	
}
for(int i=0;i<empdata.length;i++)
{
	String[][] getAttendancedata=Attendance_ACT.getAttendance(date, empdata[i][0]);
%>
<div class="box-width25 col-md-3 col-xs-12 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=empdata[i][2] %>"><%=empdata[i][2] %></p>
</div>
</div>
<div class="box-width7 col-md-3 col-xs-12 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=empdata[i][0] %>"><%=empdata[i][0] %></p>
</div>
</div>

<div class="box-width18 col-md-3 col-xs-12 box-intro-background">
<div class="link-style12">
<p class="news-border"  title="<%=empdata[i][1] %>"><%=empdata[i][1] %></p>
</div>
</div>

<div class="box-width19 col-md-4 col-xs-12 box-intro-background">
<div class="link-style12">
<p class="news-border text-center">
<span class="inline_block box-width19"><input type="radio" onclick="setInOutTime(this.value,'<%=empdata[i][0] %>')" name="Attendance<%=empdata[i][0] %>" id="Attendance1<%=empdata[i][0] %>"  title="Present" value="Present" <%if(getAttendancedata.length>0){if(getAttendancedata[0][3].equalsIgnoreCase("Present")){ %>checked='checked'<%}} %>> </span> 
<span class="inline_block box-width19"><input type="radio" onclick="setInOutTime(this.value,'<%=empdata[i][0] %>')" name="Attendance<%=empdata[i][0] %>" id="Attendance2<%=empdata[i][0] %>"  title="Absent" value="Absent" <%if(getAttendancedata.length>0){if(getAttendancedata[0][3].equalsIgnoreCase("Absent")){ %>checked='checked'<%}} %>></span>
<span class="inline_block box-width19"><input type="radio" onclick="setInOutTime(this.value,'<%=empdata[i][0] %>')" name="Attendance<%=empdata[i][0] %>" id="Attendance3<%=empdata[i][0] %>"  title="Half Day" value="Half Day" <%if(getAttendancedata.length>0){if(getAttendancedata[0][3].equalsIgnoreCase("Half Day")){ %>checked='checked'<%}} %>></span>
</p>
</div>
</div>

<div class="box-width5 col-md-2 col-xs-12 box-intro-background">
<div class="link-style12">
<p class="news-border">
<input type="text" name="InTime" id="InTime<%=empdata[i][0] %>" <%if(getAttendancedata.length>0){ if(!getAttendancedata[0][4].equalsIgnoreCase("NA")){ %>value="<%=getAttendancedata[0][4] %>"<%}}else{%>value="09:30"<%} %> style="height: 24px;width: 100%;border: none;text-align: center; padding-left: 5px;" class="input-text required-entry std_textbox readonlyAllow" placeholder="In Time"/>
</p>
</div>
</div>

<div class="box-width5 col-md-2 col-xs-12 box-intro-background">
<div class="link-style12">
<p class="news-border">
<input type="text" name="OutTime" id="OutTime<%=empdata[i][0] %>" <%if(getAttendancedata.length>0){ if(!getAttendancedata[0][5].equalsIgnoreCase("NA")){%>value="<%=getAttendancedata[0][5] %>"<%}}else{%>value="18:30"<%} %> style="height: 24px; width: 100%;border: none;text-align: center; padding-left: 5px;" class="input-text required-entry std_textbox readonlyAllow" placeholder="Out Time"/>
</p>
</div>
</div>

<div class="box-width12 col-md-1 col-xs-12 box-intro-background">
<div class="link-style12">
<p>
<button class="view_btn" type="button" onclick="changeAttendanceStatus('<%=empdata[i][0] %>',<%if(emprole.equals("Administrator")){ %>document.getElementById('Expected_Date').value<%}else{ %>document.getElementById('ExpectedDate').value<%} %>)"><i class="fa fa-arrow-up" title="Save"></i></button>
</p>
</div>
</div>
<script type="text/javascript">
$.datetimepicker.setLocale('en');
$('#datetimepicker_format').datetimepicker({value:'2015/04/15 05:03', format: $("#datetimepicker_format_value").val()});
$("#datetimepicker_format_change").on("click", function(e){
	$("#datetimepicker_format").data('xdsoft_datetimepicker').setOptions({format: $("#datetimepicker_format_value").val()});
});

$('#InTime<%=empdata[i][0] %>').datetimepicker({
	datepicker:false,
	format:'H:i',
	step:1
 });
$('#OutTime<%=empdata[i][0] %>').datetimepicker({
	datepicker:false,
	format:'H:i',
	step:1
 });
 </script>
<%}%>
</div>
</div>
</div>
</form>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
<%@ include file="/staticresources/includes/itswsfooter.jsp" %>
</div>
<script>
// $(document).ready(function () {

// 	   $("#radio1").click(function(){
// 		   setInOutTime();
// 	   });

// 	});
function setInOutTime(atten,id){
	
	if(atten=="Present")
	{
		document.getElementById('InTime'+id).value = "09:30";
		document.getElementById('OutTime'+id).value = "18:30";
	}
	if(atten=="Absent")
	{
		document.getElementById('InTime'+id).value = "AB";
		document.getElementById('OutTime'+id).value = "AB";
	}
	if(atten=="Half Day")
	{
		document.getElementById('InTime'+id).value = "13:00";
		document.getElementById('OutTime'+id).value = "18:30";
	}
}
function changeAttendanceStatus(id,date) {
	var atten;
	if(document.getElementById('Attendance1'+id).checked)
		atten = document.getElementById('Attendance1'+id).value.trim();
	else if(document.getElementById('Attendance2'+id).checked)
		atten = document.getElementById('Attendance2'+id).value.trim();
	else if(document.getElementById('Attendance3'+id).checked)
		atten = document.getElementById('Attendance3'+id).value.trim();
	var intime = document.getElementById('InTime'+id).value.trim();
	var outtime= document.getElementById('OutTime'+id).value.trim();
	
	if(date.trim()==""||date==null)
	{
		alert("Please select Date");
		return false;
	}
	
	if(atten==""||atten==undefined)
	{
		alert("Please select Status");
		return false;
	}
// 	alert("date="+date);
	
	if(intime==""||intime==null)
	{
		alert("Please select In-Time.");
		return false;
	}
	if(outtime==""||outtime==null)
	{
		alert("Please select Out-Time.");
		return false;
	}
	
	
	var xhttp;
	xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
	if (this.readyState == 4 && this.status == 200) {
		location.reload();
	}
	};
	xhttp.open("GET", "<%=request.getContextPath() %>/ChangeAttendanceStatus111?info="+id+"&atten="+atten+"&date="+date+"&intime="+intime+"&outtime="+outtime, true);
	xhttp.send();
}
	
$( function() {
	$( "#Expected_Date" ).datepicker({
		dateFormat:"dd-mm-yy",
		changeMonth: true,
		changeYear: true,
	});
});
</script>
<script type="text/javascript">
$( function() {
	$( ".attend_month" ).datepicker({
		changeMonth: true,
		changeYear: false,
		showButtonPanel: true,
		dateFormat:"MM",
		 onClose: function(dateText, inst) { 
            $(this).datepicker('setDate', new Date(inst.selectedYear, inst.selectedMonth, 1));
		}
	});
	$(".attend_month").focus(function () {
        $(".ui-datepicker-year").hide();
		$(".ui-datepicker-calendar").hide();
		$(".ui-datepicker-current").hide();
		$(".ui-datepicker-prev").hide();
		$(".ui-datepicker-next").hide();
		$(".ui-datepicker-month").css('width', '90%');
    });
});
</script>
<script type="text/javascript">
function add(id){
	var xhttp;
	xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
		if (this.readyState == 4 && this.status == 200) {
			location.reload();	
		}
	};
	xhttp.open("GET", "<%=request.getContextPath() %>/getDate111?info="+id, true);
	xhttp.send();
}
</script>
</body>
</html>