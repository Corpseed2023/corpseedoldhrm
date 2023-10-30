<%@page import="salary_master.SalaryMon_ACT"%>
<%@page import="commons.DateUtil"%>
<!DOCTYPE HTML>
<html lang="en-US">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Manage TDS History</title>
<%@ include file="../../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../../staticresources/includes/itswsheader.jsp" %>
<%
String addedby= (String)session.getAttribute("loginuID");
String emname= (String)session.getAttribute("tdsemname");
String month= (String)session.getAttribute("tdsmonth");
String from= (String)session.getAttribute("tdsfrom");
String to= (String)session.getAttribute("tdsto");
String token= (String)session.getAttribute("uavalidtokenno");

if(emname==null||emname.length()<=0)emname="NA";
if(month==null||month.length()<=0)month="NA";
if(from==null||from.length()<=0)from="NA";
if(to==null||to.length()<=0)to="NA";

String[][] tdsData=SalaryMon_ACT.getTdsData(emname,month,token, from, to);
String[][] empdata=SalaryMon_ACT.getAllEmployee(token);
%>
<%if(!MTH00){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
	<div class="container">   
	  <div class="bread-crumb">
		<div class="bd-breadcrumb bd-light">
		<a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
		<a>Manage TDS History</a>
		</div>
	  </div>
	</div>

	<div class="main-content">
		<div class="container">
			<div class="row">
				<div class="col-md-12 col-sm-12 col-xs-12">
					<div class="menuDv partner-slider8 clearfix">
						
						<div class="row">
						<div class="col-md-12 col-sm-12 col-xs-12">
						<div class="top_title text-center">
						<h2>Manage TDS History</h2>
						</div>
						<%if(MTH01){ %><a class="add_btn sub-btn1" href="<%=request.getContextPath() %>/Add-TDS-details.html">Add TDS Details</a><%} %>
						</div>
						</div>
											   
						<form name="RefineSearchenqu" action="<%=request.getContextPath()%>/TDS-details.html" method="Post">
						  <input type="hidden" name="pageName" id="pageName"  value="manageservice.jsp">
							<input type="hidden" name="jsstype" id="jsstype">
							<div class="home-search-form clearfix">
							<div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon fa fa-user"></i></span>
							  <select name="emname" id="emname" class="form-control" style="border: 1px solid #ccc;padding: 5px 5px !important;">
								<option value="">Select Employee</option>
								<%
								for(int i=0;i<empdata.length;i++)
								{
									if(!emname.equalsIgnoreCase("NA") && emname.equalsIgnoreCase(empdata[i][0])){ %>
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
							  <span class="input-group-addon"><i class="form-icon fa fa-calendar"></i></span>
							  <p><input type="text" name="month" id="month" <% if(!month.equalsIgnoreCase("NA")){ %> value="<%=month%>"<%} %> placeholder="Select Month" class="form-control"/></p>
							</div>
							</div>
							<div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon fa fa-calendar"></i></span>
							  <% if(from!=null){ %>
								<p><input type="text" name="from" id="from" <% if(!from.equalsIgnoreCase("NA")){ %> value="<%=from%>"<%} %> placeholder="From" class="form-control searchdate"/></p>
								<%}else{ %>
								<p><input type="text" name="from" id="from" placeholder="From" class="form-control searchdate"/></p>
								<%} %>
							  </div>
							</div>
							<div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon fa fa-calendar"></i></span>
							  <p><input type="text" name="to" id="to" <% if(!to.equalsIgnoreCase("NA")){ %> value="<%=to%>"<%} %> placeholder="To" class="form-control searchdate"/></p>
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
							<div class="box-width19 col-md-3 col-xs-12 box-intro-bg">
								<div class="box-intro-border">
								<p class="news-border">Employee Name</p>
								</div>
							</div>
							<div class="box-width7 col-xs-1 box-intro-bg">
								<div class="box-intro-border">
								<p class="news-border">TDS Paid</p>
								</div>
							</div>
							<div class="box-width12 col-xs-1 box-intro-bg">
								<div class="box-intro-border">
								<p class="news-border">TDS Paid On</p>
								</div>
							</div>
							<div class="box-width18 col-xs-1 box-intro-bg">
								<div class="box-intro-border">
								<p class="news-border">TDS Paid For the Month of</p>
								</div>
							</div>
							<div class="box-width18 col-md-3 col-xs-12 box-intro-bg">
								<div class="box-intro-border">
								<p>Action</p>
								</div>
							</div>
						   </div>
						  </div>
						</div>
						<%
						 for(int i=0;i<tdsData.length;i++){
						 %>
						<div class="row">
						  <div class="col-md-12 col-sm-12 col-xs-12">
						   <div class="clearfix">
							<div class="box-width25 col-xs-1 box-intro-background">
								<div class="link-style12">
								<p class="news-border"><%=i+1%></p>
								</div>
							</div>
							<div class="box-width19 col-md-3 col-xs-12 box-intro-background">
								<div class="link-style12">
								<p class="news-border"><%=tdsData[i][1] %></p>
								</div>
							</div>
							<div class="box-width7 col-xs-1 box-intro-background">
								<div class="link-style12">
								<p class="news-border">Rs. <%=tdsData[i][2] %></p>
								</div>
							</div>
							<div class="box-width12 col-xs-1 box-intro-background">
								<div class="link-style12">
								<p class="news-border"><%=tdsData[i][3] %></p>
								</div>
							</div>
							<div class="box-width18 col-xs-1 box-intro-background">
								<div class="link-style12">
								<p class="news-border"><%=tdsData[i][4] %></p>
								</div>
							</div>
							<div class="box-width18 col-md-3 col-xs-12 box-intro-background">
								<div class="link-style12">
								<p>
								<%if(MTH02){ %><a class="fancybox" href="<%=request.getContextPath()%>/ViewTdsDetails.html" onclick="vieweditpage(<%=tdsData[i][0] %>, 'view');"><i class="fa fa-eye" title="view"></i></a><%} %>
								<%if(MTH03){ %><a href="javascript:void(0);" onclick="vieweditpage(<%=tdsData[i][0] %>,'edit');"><i class="fa fa-edit" title="edit"></i></a><%} %>
								<%if(MTH04){ %><a class="quick-view" href="#managetds" onclick="document.getElementById('userid').innerHTML='<%=tdsData[i][0] %>'"><i class="fa fa-trash" title="delete"></i></a><%} %>                                 
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
<%@ include file="../../staticresources/includes/itswsfooter.jsp" %>
</div>
<section class="clearfix" id="managetds" style="display: none;">
<div class="clearfix  text-center">
<div class="col-md-12 col-xs-12" id="userid" style="display: none;"></div>
<div class="col-md-12 col-xs-12">
<div class="box-intro1">
  <h2><span class="title">Delete this TDS-Details ?</span></h2>
</div>
</div>
<div class="col-md-12 col-xs-12 mb10">
<a class="sub-btn1" onclick="" id="cancelpopup">Cancel</a>
<button class="sub-btn1 mlft10" onclick="return approve(document.getElementById('userid').innerHTML);" title="Delete this TDS-Details">Delete</button>
</div>
</div>
</section>
<%@ include file="../../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">	
	$('#cancelpopup').click(function(){
		  $.fancybox.close();
	});
</script>
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
function approve(id) {
var xhttp; 
xhttp = new XMLHttpRequest();
xhttp.onreadystatechange = function() {
if (this.readyState == 4 && this.status == 200) {
location.reload();
}
};
xhttp.open("GET", "<%=request.getContextPath()%>/DeleteTds111?info="+id, true);
xhttp.send();
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
<%--         	if(page=="view") window.location = "<%=request.getContextPath()%>/ViewTdsDetails.html"; --%>
        	if(page=="edit") window.location = "<%=request.getContextPath()%>/EditTdsDetails.html";
        },
	});
}
</script>
<script type="text/javascript">
$(function(){$("#month").datepicker({
	changeMonth:true,
    changeYear:true,
    dateFormat:"mm-yy"
    });
});

function RefineSearchenquiry() {
	document.RefineSearchenqu.jsstype.value="SSEqury";
	document.RefineSearchenqu.action="<%=request.getContextPath()%>/TDS-details.html";
	document.RefineSearchenqu.submit();
}
</script>
</body>
</html>