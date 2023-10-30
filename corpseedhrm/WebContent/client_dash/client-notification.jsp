<%@page import="javax.servlet.http.HttpSession"%>
<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Notification</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheaderclient.jsp" %>
<div id="content">
<div class="container">   
<div class="bread-crumb">
<div class="bd-breadcrumb bd-light">
<a href="<%=request.getContextPath() %>/">Home</a>
<a>Notification</a>
</div>
</div>
</div>
<div class="main-content">
<div class="container">
<div class="row">
<div class="home-bestsale-product col-md-12 col-sm-12 col-xs-12 item-product-info">
<div class="user-login">
<div class="menuDv">
<p><%=session.getAttribute("ErrorMessage") %></p>
<%
HttpSession SES = request.getSession(true);
String loginuID=(String)SES.getAttribute("loginuID");
SES.removeAttribute("ErrorMessage");
%>
</div>
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