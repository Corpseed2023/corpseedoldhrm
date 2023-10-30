<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="attendance_master.Attendance_ACT"%>
<!DOCTYPE HTML>
<html lang="en-US">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Manage Login History & Traffic</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	<%
	String[][] loginHistory=null;
	String[][] trafficHistory=null;
	DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	Calendar calobj = Calendar.getInstance();
	String today = df.format(calobj.getTime());
	
	String date=(String)session.getAttribute("date");
	String emproleid= (String)session.getAttribute("emproleid");
String token= (String)session.getAttribute("uavalidtokenno");
if(date!=null){
	loginHistory = LoginAction.getLoginHistory(token,date,emproleid);
}else
{
	loginHistory = LoginAction.getLoginHistory(token,today,emproleid);
}
%>
<%if(!LTH00){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
	<div class="container">   
	  <div class="bread-crumb">
		<div class="bd-breadcrumb bd-light">
		<a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
		<a>Manage Login History & Traffic</a>
		</div>
	  </div>
	</div>

	<div class="main-content">
		<div class="container">
			<div class="row">
				<div class="col-md-12 col-sm-12 col-xs-12">
					<div class="menuDv partner-slider8">
						<div class="box-intro clearfix">
						  <h2><span class="title">Manage Login History</span></h2>
						<div class="select_input_box">
						<span class="relative_box"><i class="fa fa-calendar input_icon"></i>
						<input type="text" name="date" onchange="setDate(this.value)" class="chooseDate readonlyAllow" value="<%if(date!=null){ %><%=date %><%}else{ %> <%=today %> <%} %>" placeholder="Select Date" readonly>
						</span>
						</div>
						</div>
						
						<div class="row">
						  <div class="col-md-12 col-sm-12 col-xs-12">
						   <div class="clearfix box-intro-bg">
							<div class="box-width25 col-xs-1 box-intro-bg">
								<div class="box-intro-border">
								<p class="news-border">SN</p>
								</div>
							</div>
							<div class="box-width9 col-xs-1 box-intro-bg">
								<div class="box-intro-border">
								<p class="news-border">Login Id</p>
								</div>
							</div>
							<div class="box-width12 col-xs-1 box-intro-bg">
								<div class="box-intro-border">
								<p class="news-border">Date</p>
								</div>
							</div>
							<div class="box-width17 col-xs-3 box-intro-bg">
								<div class="box-intro-border">
								<p class="news-border">Session Id</p>
								</div>
							</div>
							<div class="box-width18 col-xs-1 box-intro-bg">
								<div class="box-intro-border">
								<p class="news-border">IP Address</p>
								</div>
							</div>
							<div class="box-width12 col-xs-1 box-intro-bg">
								<div class="box-intro-border">
								<p class="news-border">In Time</p>
								</div>
							</div>
							<div class="box-width12 col-xs-1 box-intro-bg">
								<div class="box-intro-border">
								<p>Out Time</p>
								</div>
							</div>
						   </div>
						  </div>
						</div>
						<div id="target">
						<%
						 for(int i=0;i<loginHistory.length;i++){
						 %>
						<div class="row">
						  <div class="col-md-12 col-sm-12 col-xs-12">
						   <div class="clearfix">
							<div class="box-width25 col-xs-1 box-intro-background">
								<div class="link-style12">
								<p class="news-border" title="<%=loginHistory.length-i%>"><%=loginHistory.length-i %></p>
								</div>
							</div>
							<div class="box-width9 col-xs-1 box-intro-background">
								<div class="link-style12">
								<p class="news-border" title="<%=loginHistory[i][1] %>"><%=loginHistory[i][1] %></p>
								</div>
							</div>
							<div class="box-width12 col-xs-1 box-intro-background">
								<div class="link-style12">
								<p class="news-border" title="<%=loginHistory[i][2] %>"><%=loginHistory[i][2] %></p>
								</div>
							</div>
							<div class="box-width17 col-xs-1 box-intro-background">
								<div class="link-style12">
								<p class="news-border" title="<%=loginHistory[i][4] %>"><%=loginHistory[i][4] %></p>
								</div>
							</div>
							<div class="box-width18 col-xs-1 box-intro-background">
								<div class="link-style12">
								<p class="news-border" title="<%=loginHistory[i][5] %>"><%=loginHistory[i][5] %></p>
								</div>
							</div>
							<div class="box-width12 col-xs-1 box-intro-background">
								<div class="link-style12">
								<p class="news-border" title="<%=loginHistory[i][3] %>"><%=loginHistory[i][3] %></p>
								</div>
							</div>
							<div class="box-width12 col-xs-1 box-intro-background">
								<div class="link-style12">
								<p class="" title="<%=loginHistory[i][7] %>"><%=loginHistory[i][7] %></p>
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
<%
if(date!=null){
	trafficHistory = LoginAction.getTrafficHistory(date);
}else	{
	trafficHistory = LoginAction.getTrafficHistory(today);
}


%>
		<div class="container">
			<div class="row about-content">
				<div class="col-md-12 col-sm-12 col-xs-12">
					<div class="menuDv partner-slider8">
						<div class="box-intro">
						  <h2><span class="title">Manage Traffic History</span></h2>
						</div>
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
								<p class="news-border">Host</p>
								</div>
							</div>
							<div class="box-width18 col-xs-1 box-intro-bg">
								<div class="box-intro-border">
								<p class="news-border">Referrer</p>
								</div>
							</div>
							<div class="box-width18 col-xs-3 box-intro-bg">
								<div class="box-intro-border">
								<p class="news-border">User Agent</p>
								</div>
							</div>
							<div class="box-width9 col-xs-1 box-intro-bg">
								<div class="box-intro-border">
								<p class="news-border">IP Address</p>
								</div>
							</div>
							<div class="box-width9 col-xs-1 box-intro-bg">
								<div class="box-intro-border">
								<p class="news-border">Session Id</p>
								</div>
							</div>
							<div class="box-width5 col-xs-1 box-intro-bg">
								<div class="box-intro-border">
								<p>Time</p>
								</div>
							</div>
						   </div>
						  </div>
						</div>
						<div id="target">
						<%
						 for(int i=0;i<trafficHistory.length;i++){
						 %>
						<div class="row">
						  <div class="col-md-12 col-sm-12 col-xs-12">
						   <div class="clearfix">
							<div class="box-width25 col-xs-1 box-intro-background">
								<div class="link-style12">
								<p class="news-border" title="<%=trafficHistory.length-i %>"><%=trafficHistory.length-i %></p>
								</div>
							</div>
							<div class="box-width9 col-xs-1 box-intro-background">
								<div class="link-style12">
								<p class="news-border" title="<%=trafficHistory[i][1] %>"><%=trafficHistory[i][1] %></p>
								</div>
							</div>
							<div class="box-width18 col-xs-1 box-intro-background">
								<div class="link-style12">
								<p class="news-border" title="<%=trafficHistory[i][2] %>"><%=trafficHistory[i][2] %></p>
								</div>
							</div>
							<div class="box-width18 col-xs-1 box-intro-background">
								<div class="link-style12">
								<p class="news-border" title="<%=trafficHistory[i][3] %>"><%=trafficHistory[i][3] %></p>
								</div>
							</div>
							<div class="box-width9 col-xs-1 box-intro-background">
								<div class="link-style12">
								<p class="news-border" title="<%=trafficHistory[i][4] %>"><%=trafficHistory[i][4] %></p>
								</div>
							</div>
							<div class="box-width9 col-xs-1 box-intro-background">
								<div class="link-style12">
								<p class="news-border" title="<%=trafficHistory[i][5] %>"><%=trafficHistory[i][5] %></p>
								</div>
							</div>
							<div class="box-width5 col-xs-1 box-intro-background">
								<div class="link-style12">
								<p class="" title="<%=trafficHistory[i][6] %>"><%=trafficHistory[i][6] %></p>
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
	
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
</div>
<p id="end" style="display:none;"></p>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>
<script type="text/javascript">
function setDate(date){
		$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/setDate111",
	    data:  { 
	    	"date" : date
	    },
	    success: function (response) {
	    	window.location = "<%=request.getContextPath()%>/logintraffic.html";
	    },
	});
}
</script>
<script type="text/javascript">
$( ".chooseDate" ).datepicker({ dateFormat: 'yy-mm-dd' });
</script>
</body>
</html>