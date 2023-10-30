<!doctype html>

<%@page import="java.util.Random"%>
<%@page import="java.util.Properties"%>
<%@page import="commons.CommonHelper"%>
<%@page import="commons.DateUtil"%>
<%@page import="hcustbackend.ClientACT"%>
<html lang="en">
<head>  
  <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<%@ include file="includes/client-header-css.jsp" %>
    <title>corpSeed-all-notifications</title>
</head>
<body id="mySite" style="display: block">
<%@ include file="includes/checkvalid_client.jsp" %>
<!-- main content starts -->
<%
String token= (String)session.getAttribute("uavalidtokenno");
String creguid= (String)session.getAttribute("loginClintUaid");

String notisearchFromToDate=(String)session.getAttribute("notisearchFromToDate");
if(notisearchFromToDate==null||notisearchFromToDate.length()<=0)notisearchFromToDate="NA";

String clientuaid = (String) session.getAttribute("loginClintUaid");  

String notitoken=(String)session.getAttribute("uavalidtokenno");
String notificatios1[][]=ClientACT.getAllClientNotification(notitoken,clientuaid);
%>
<section class="main clearfix">
  <%@ include file="includes/client_header_menu.jsp" %>
  <section class="clearfix">
      <div class="container">
       <div class="row">
        <div class="col-12 p-0">	  
          <div id="notipage"> 
		
		  <div class="notificationsec">
		  <ul>
			   <h2>Notification</h2> 
			   <%if(notifications!=null&&notifications.length>0){
				  for(int i=0;i<notifications.length;i++){
				  %>
			  <li class="clearfix">
                <a href="<%=request.getContextPath()%>/<%=notifications[i][2] %>">                
                <div class="clearfix pro_box text-left">
                    <div class="clearfix icon_box">
                     <i class="<%=notifications[i][4] %> icon-circle" aria-hidden="true"></i>
                    </div> 
                    <div class="clearfix pro_info"> 
                    <h6><%=notifications[i][3] %></h6>
                    <div class="clearfix date_box"><%=notifications[i][1] %></div>
                    </div>
                 </div>                 
                </a>
              </li>
              <%}} %>
			     
			  </ul>
		
		</div>
          </div>
        </div>
		</div>
	  </div>
	
</section>
</section>
<%@ include file="includes/client-footer-js.jsp" %>
</body>
<!-- body ends -->
</html>