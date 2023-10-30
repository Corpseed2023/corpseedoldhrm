<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Manage Project</title>
<%@ include file="../../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../../staticresources/includes/itswsheaderclient.jsp" %>
<%
String uaname = (String)session.getAttribute("uaname");
String clientID = Clientmaster_ACT.getClientIDByLoginName(uaname);
String[][] getProjectByClient = Clientmaster_ACT.getProjectByClient(clientID);
%>
<script type="text/javascript">
function vieweditpage(id){
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/vieweditpage",
	    data:  { 
	    	"uid" : id
	    },
	    success: function (response) {
        	window.location = "<%=request.getContextPath()%>/projectfollowup.html";
        },
	});
}
</script>
<div id="content">

<div class="main-content">
<div class="container">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="menuDv partner-slider8">
<div class="box-intro">
<h2><span class="title">Project Details</span></h2>
</div>

<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="box-width1 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">SN</p>
</div>
</div>
<div class="box-width2 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Project ID</p>
</div>
</div>
<div class="box-width6 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Project Name</p>
</div>
</div>
<div class="box-width4 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Project Type</p>
</div>
</div>
<div class="box-width4 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Starting Date</p>
</div>
</div>
<div class="box-width4 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Delivery Date</p>
</div>
</div>
<div class="box-width2 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p>Details</p>
</div>
</div>
</div>
</div>
</div>

<%
for(int i=0;i<getProjectByClient.length;i++)
{
if(i%2==0){
%>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="box-width1 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=i+1%></p>
</div>
</div>
<div class="box-width2 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getProjectByClient[i][5] %></p>
</div>
</div>
<div class="box-width6 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getProjectByClient[i][1] %></p>
</div>
</div>
<div class="box-width4 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getProjectByClient[i][2] %></p>
</div>
</div>
<div class="box-width4 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getProjectByClient[i][3] %></p>
</div>
</div>
<div class="box-width4 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getProjectByClient[i][4] %></p>
</div>
</div>
<div class="box-width2 col-xs-1 box-intro-background">
<div class="link-style12">
<p><a onclick="vieweditpage(<%=getProjectByClient[i][0]%>);">Details</a></p>
</div>
</div>
</div>
</div>
<%} else{%>
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="list-boxBg clearfix">
<div class="box-width2 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=i+1%></p>
</div>
</div>
<div class="box-width2 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getProjectByClient[i][5] %></p>
</div>
</div>
<div class="box-width6 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getProjectByClient[i][1] %></p>
</div>
</div>
<div class="box-width4 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getProjectByClient[i][2] %></p>
</div>
</div>
<div class="box-width4 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getProjectByClient[i][3] %></p>
</div>
</div>
<div class="box-width4 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getProjectByClient[i][4] %></p>
</div>
</div>
<div class="box-width2 col-xs-1 box-intro-background">
<div class="link-style12">
<p><a onclick="vieweditpage(<%=getProjectByClient[i][0]%>);">Details</a></p>
</div>
</div>
</div>
</div>
</div>
<%} }%>
</div>
</div>
</div>
</div>
</div>
</div>
<%@ include file="../../staticresources/includes/itswsfooter.jsp" %>
</div>
<%@ include file="../../staticresources/includes/itswsscripts.jsp" %>
</body>
</html>