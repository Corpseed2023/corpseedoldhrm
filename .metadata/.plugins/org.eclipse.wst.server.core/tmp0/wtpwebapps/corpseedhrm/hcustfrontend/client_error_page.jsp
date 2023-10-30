<!doctype html>

<%@page import="hcustbackend.ClientACT"%>
<html lang="en">
<head>  
  <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<%@ include file="includes/client-header-css.jsp" %>
    <title>corpSeed-payments</title>
</head>
<body id="mySite" style="display: block">
<%@ include file="includes/checkvalid_client.jsp" %>
<!-- main content starts -->
<%
//get token no from session
String token=(String)session.getAttribute("uavalidtokenno");
String uaempid=(String)session.getAttribute("uaempid");
//get client no from session
String clientid=ClientACT.getClientId(uaempid,token);
String client[][]=ClientACT.getClientByNo(uaempid,token);
%>
<section class="main clearfix">
  <%@ include file="includes/client_header_menu.jsp" %>
  <section class="main-payments clearfix">
    <div class="container-fluid">
	<div class="container">
      <%String errorMsg=(String)session.getAttribute("errorMsg"); 
      String backpage=(String)session.getAttribute("page");
      %>
      <a href="<%=request.getContextPath()%>/<%=backpage%>"><button type="button" class="text-right"><h2>Back</h2></button></a>
      <h2 style="text-align: center;color: red;"><%=errorMsg %></h2>
    </div>
	</div>
</section>
  
</section>
<!-- main content ends -->
<%@ include file="includes/client-footer-js.jsp" %>
  </body>
<!-- body ends -->
</html>