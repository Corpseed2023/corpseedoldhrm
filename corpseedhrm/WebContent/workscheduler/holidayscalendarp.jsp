<%@page import="workscheduler.WorkSchedulerACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title> Holidays Calendar </title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%
String[][] holidayscalendarl=WorkSchedulerACT.getholidayscalendarlst();
%>
<div id="content">
<div class="container">
<div class="bread-crumb">
<div class="bd-breadcrumb bd-light">
<a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
<a>Holidays Calendar</a>
</div>
</div>
</div>

<div class="main-content">
<div class="container">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="menuDv partner-slider8">
<div class="box-intro">
<h2><span class="title">Holidays Calendar</span></h2>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="box-width25 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">SN</p>
</div>
</div>
<div class="box-width18 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Day</p>
</div>
</div>
<div class="box-width18 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Date</p>
</div>
</div>
<div class="box-width28 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Holiday name</p>
</div>
</div>
<div class="box-width18 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Holiday type</p>
</div>
</div>
</div>
</div>
</div>

<%
for(int i=0;i<holidayscalendarl.length;i++)
{
if(i%2==0){
%>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="box-width25 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=holidayscalendarl[i][0] %></p>
</div>
</div>
<div class="box-width18 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=holidayscalendarl[i][1] %></p>
</div>
</div>
<div class="box-width18 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=holidayscalendarl[i][2] %></p>
</div>
</div>
<div class="box-width28 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=holidayscalendarl[i][3] %></p>
</div>
</div>
<div class="box-width18 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=holidayscalendarl[i][4] %></p>
</div>
</div>
</div>
</div>

<%} else{%>

<div class="col-md-12 col-sm-12 col-xs-12">
<div class="list-boxBg clearfix">
<div class="box-width25 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=holidayscalendarl[i][0] %></p>
</div>
</div>
<div class="box-width18 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=holidayscalendarl[i][1] %></p>
</div>
</div>
<div class="box-width18 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=holidayscalendarl[i][2] %></p>
</div>
</div>
<div class="box-width28 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=holidayscalendarl[i][3] %></p>
</div>
</div>
<div class="box-width18 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=holidayscalendarl[i][4] %></p>
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
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
</body>
</html>