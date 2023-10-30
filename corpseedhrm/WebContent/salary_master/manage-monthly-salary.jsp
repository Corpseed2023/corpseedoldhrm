<%@page import="salary_master.SalaryMon_ACT"%>
<%@page import="commons.DateUtil"%>
<!DOCTYPE HTML>
<html lang="en-US">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Manage Salary</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%
String addedby= (String)session.getAttribute("loginuID");
String emname= (String)session.getAttribute("mmsemname");
String month= (String)session.getAttribute("mmsmonth");
String from= (String)session.getAttribute("mmsfrom");
String to= (String)session.getAttribute("mmsto");
if(emname==null||emname.length()<=0)emname="NA";
if(month==null||month.length()<=0)month="NA";
if(from==null||emname.length()<=0)from="NA";
if(to==null||to.length()<=0)to="NA";

String token= (String)session.getAttribute("uavalidtokenno");
String[][] salData=SalaryMon_ACT.getSalaryData(emname, month, "25", token, from, to);
String[][] empdata=SalaryMon_ACT.getAllEmployee(token);
%>
<%if(!MSL00){%><jsp:forward page="/login.html" /><%} %>
<!-- End Header -->

<div id="content">
<div class="main-content">
<div class="container">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="menuDv partner-slider8">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="top_title text-center">
<h2>Manage Salary</h2>
</div>
<div class="add_btn_box">
<%if(MSL01){ %><a class="add_btn sub-btn1" href="<%=request.getContextPath() %>/Monthly-Salary.html">Add Monthly Salary</a><%} %>
</div>
</div>
</div>

<form name="RefineSearchenqu" action="<%=request.getContextPath()%>/manage-monthly-salary.html" method="Post">
<input type="hidden" name="pageName" id="pageName"  value="manageservice.jsp">
<input type="hidden" name="jsstype" id="jsstype">
<div class="home-search-form clearfix">
<div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
<div class="input-group">
<span class="input-group-addon"><i class="fa fa-user"></i></span>
<select name="emname" id="emname" class="form-control">
<option value="">Select Employee</option>
<%
for(int i=0;i<empdata.length;i++)
{
if(!emname.equalsIgnoreCase("NA")&& emname.equalsIgnoreCase(empdata[i][0])){ %>
<option value="<%=empdata[i][0] %>" selected="selected"><%=empdata[i][0]%></option>
<%}else{ %>
<option value="<%=empdata[i][0] %>"><%=empdata[i][0] %></option>
<%}
}%>
</select>
</div>
</div>
<div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
<div class="input-group">
<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
<p><input type="text" name="month" id="month" <% if(!month.equalsIgnoreCase("NA")){ %>value="<%=month%>"<%} %> placeholder="Select Month" class="form-control readonlyAllow" autocomplete="off" readonly="readonly"/></p>
</div>
</div>
<div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
<div class="input-group">
<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
<p><input type="text" name="from" id="from" <% if(!from.equalsIgnoreCase("NA")){ %>value="<%=from%>"<%} %> placeholder="From" class="form-control searchdate readonlyAllow" autocomplete="off" readonly="readonly"/></p>
</div>
</div>
<div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
<div class="input-group">
<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
<p><input type="text" name="to" id="to" <% if(!to.equalsIgnoreCase("NA")){ %> value="<%=to%>"<%} %> placeholder="To" class="form-control searchdate readonlyAllow" autocomplete="off" readonly="readonly"/></p>
</div>
</div>
<div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
<button class="btn-link-default bt-radius" type="submit" name="button" value="Search"><i class="fa fa-search" title="Search"></i></button>
<button class="btn-link-default bt-radius" type="submit" name="button" value="Reset"><i class="fa fa-refresh" title="Reset"></i></button>
</div>
</div>
</form>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="box-width25 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">SN</p>
</div>
</div>
<div class="box-width9 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Employee Name</p>
</div>
</div>
<div class="box-width22 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Month</p>
</div>
</div>
<div class="box-width22 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Days</p>
</div>
</div>
<div class="box-width20 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">L Allowed</p>
</div>
</div>
<div class="box-width20 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">L Taken</p>
</div>
</div>
<div class="box-width20 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">W Days</p>
</div>
</div>
<div class="box-width22 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">CTC</p>
</div>
</div>
<div class="box-width20 col-xs-3 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Deduction</p>
</div>
</div>
<div class="box-width20 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Payable</p>
</div>
</div>
<div class="box-width22 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Remark</p>
</div>
</div>
<div class="box-width22 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Paid On</p>
</div>
</div>
<div class="box-width5 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p>Action</p>
</div>
</div>
</div>
</div>
</div>
<div id="target">
<%
for(int i=0;i<salData.length;i++){
%>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="box-width25 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=salData[i][0] %>"><%=salData[i][0] %></p>
</div>
</div>
<div class="box-width9 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=salData[i][1] %>"><%=salData[i][1] %></p>
</div>
</div>
<div class="box-width22 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=salData[i][5] %>"><%=salData[i][5] %></p>
</div>
</div>
<div class="box-width22 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=salData[i][6] %>"><%=salData[i][6] %></p>
</div>
</div>
<div class="box-width20 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=salData[i][8] %>"><%=salData[i][8] %></p>
</div>
</div>
<div class="box-width20 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=salData[i][9] %>"><%=salData[i][9] %></p>
</div>
</div>
<div class="box-width20 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=salData[i][7] %>"><%=salData[i][7] %></p>
</div>
</div>
<div class="box-width22 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=salData[i][2] %>">Rs. <%=salData[i][2] %></p>
</div>
</div>
<div class="box-width20 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=salData[i][3] %>">Rs. <%=salData[i][3] %></p>
</div>
</div>
<div class="box-width20 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=salData[i][4] %>">Rs. <%=salData[i][4] %></p>
</div>
</div>
<div class="box-width22 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=salData[i][10] %>"><%=salData[i][10] %></p>
</div>
</div>
<div class="box-width22 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border">
<% if(salData[i][11].equals("NA")||salData[i][11].equals("")){ %>
<input style="border: none;" class="salarydatepicker readonlyAllow" type="text" id="paidon$<%=salData[i][0]%>" placeholder="NOT PAID!!" readonly="readonly"/>
<% } else { %>
<%=salData[i][11]%>
<% } %>
</p>
</div>
</div>
<div class="box-width5 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="clearfix">
<%if(MSL02){ %><a class="fancybox" href="<%=request.getContextPath() %>/ViewMonthlySalary.html" onclick="vieweditpage(<%=salData[i][0]%>,'view');"><i class="fa fa-eye" title="view"></i></a><%} %>
<%if(MSL03){ %><a href="javascript:void(0);" onclick="vieweditpage(<%=salData[i][0] %>,'edit');"><i class="fa fa-edit" title="edit"></i></a><%} %>
<%if(MSL04){ %><a class="quick-view" href="#managesalarypaid" onclick="document.getElementById('userid').innerHTML='<%=salData[i][0] %>'"> <i class="fa fa-trash" title="delete"></i></a><%} %>
</p>
</div>
</div>
</div>
</div>
</div>
<%}%>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
<p id="end" style="display:none"></p>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>

<section class="clearfix" id="managesalarypaid" style="display: none;">
<div class="clearfix  text-center">
<div class="col-md-12 col-xs-12" id="userid" style="display: none;"></div>
<div class="col-md-12 col-xs-12">
<div class="box-intro1">
  <h2><span class="title">Delete This Salary ?</span></h2>
</div>
</div>
<div class="col-md-12 col-xs-12 mb10">
<a class="sub-btn1" onclick="" id="cancelpopup">Cancel</a>

<a class="sub-btn1 mlft10" onclick="return approve(document.getElementById('userid').innerHTML);" title="Delete this Salary ">Delete</a>
</div>
</div>
</section>
<script type="text/javascript">	
	$('#cancelpopup').click(function(){
		  $.fancybox.close();
	});
</script>
<script type="text/javascript">
$(function(){
	$("#month").datepicker({
	changeMonth:true,
	changeYear:true,
	dateFormat:"mm-yy"
	});
});
	
$(function(){
	$(".salarydatepicker").datepicker({
	changeMonth:true,
	changeYear:true,
	dateFormat:"dd-mm-yy"
	});
});
	
function approve(id) {

var xhttp;
xhttp = new XMLHttpRequest();
xhttp.onreadystatechange = function() {
if (this.readyState == 4 && this.status == 200) {
location.reload();
}
};
xhttp.open("GET", "<%=request.getContextPath()%>/DeleteSalMon111?info="+id, true);
xhttp.send();

}

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
	        url: '<%=request.getContextPath()%>/getmoremonsal',
	        datatype : "json",
	        data: {
	        	counter:counter,
	        	emname:'<%=emname%>',
	        	month:'<%=month%>',
	        	from:'<%=from%>',
	        	to:'<%=to%>'
	        	},
	        success: function(data){
	        	for(i=0;i<data[0].salData.length;i++){
	            	html += '<div class="row"><div class="col-md-12 col-sm-12 col-xs-12"><div class="clearfix"><div class="box-width1 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].salData[i][0]+'</p></div></div><div class="box-width16 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].salData[i][1]+'</p></div></div><div class="box-width20 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].salData[i][5]+'</p></div></div><div class="box-width20 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].salData[i][6]+'</p></div></div><div class="box-width20 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].salData[i][8]+'</p></div></div><div class="box-width20 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].salData[i][9]+'</p></div></div><div class="box-width20 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].salData[i][7]+'</p></div></div><div class="box-width20 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">Rs. '+data[0].salData[i][2]+'</p></div></div><div class="box-width20 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">Rs. '+data[0].salData[i][3]+'</p></div></div><div class="box-width20 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">Rs. '+data[0].salData[i][4]+'</p></div></div><div class="box-width12 col-xs-1 box-intro-background" style="width: 14.105%;"><div class="link-style12"><p class="news-border" title="'+data[0].salData[i][10]+'">'+data[0].salData[i][10]+'</p></div></div><div class="box-width20 col-xs-1 box-intro-background" style="width: 8%;"><div class="link-style12"><p class="news-border">';
	            	if(data[0].salData[i][11]=="NA"||data[0].salData[i][11]==""){
	            		html += '<input style="border: none;" class="salarydatepicker" type="text" id="paidon$'+data[0].salData[i][0]+'" placeholder="NOT PAID!!" />';
	            	} else {
	            		html += data[0].salData[i][11] ;
	            	}
	            	html += '</p></div></div><div class="box-width8 col-xs-1 box-intro-background"><div class="link-style12"><p class="clearfix"><a href="javascript:void(0);" onclick="vieweditpage('+data[0].salData[i][0]+',\'view\');">View</a><a href="javascript:void(0);" onclick="vieweditpage('+data[0].salData[i][0]+',\'edit\');">Edit</a><a href="javascript:void(0);" onclick="approve('+data[0].salData[i][0]+')">Delete</a></p></div></div></div></div></div>';
	        	}
	        	$(function(){$(".salarydatepicker").datepicker({changeMonth:true,changeYear:true,dateFormat:"dd-mm-yy"});});
	            if(html!='') $('#target').append(html);
	            else document.getElementById("end").innerHTML = "End";
	        }
	    });
	    
	    counter=counter+25;
	}
	
	$(document).on('change', 'input', function() {
		if(this.value=="") value="NA";
		$.ajax({
			type: "POST",
	        url: '<%=request.getContextPath()%>/UpdatePaidDate',
	        datatype : "JSON",
	        data: {
	        	id : this.id.split("$")[1],
	        	value : this.value
	        }
		});		
	});
	</script>
	<script type="text/javascript">
function RefineSearchenquiry() {
document.RefineSearchenqu.jsstype.value="SSEqury";
document.RefineSearchenqu.action="<%=request.getContextPath()%>/manage-monthly-salary.html";
document.RefineSearchenqu.submit();
}

function vieweditpage(id,page){
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/vieweditpage",
	    data:  { 
	    	"uid" : id
	    },
	    success: function (response) {
<%--         	if(page=="view") window.location = "<%=request.getContextPath()%>/ViewMonthlySalary.html"; --%>
        	if(page=="edit") window.location = "<%=request.getContextPath()%>/EditMonthlySalary.html";
        },
	});
}
</script>
</div>
</body>
</html>