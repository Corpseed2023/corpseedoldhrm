<%@page import="admin.Login.LoginAction"%>
<%
response.addHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.addHeader("Cache-Control", "pre-check=0, post-check=0");
response.setDateHeader("Expires", 0);

String uavalidtokenno1111= (String)session.getAttribute("uavalidtokenno");
String uaIsValid1= (String)session.getAttribute("loginuID");

String sessionid = (String) session.getAttribute("sessionID");
String euaValidForAccess =  LoginAction.getPermissions(uaIsValid1, sessionid);
if(uaIsValid1== null || uaIsValid1.equals("") || uavalidtokenno1111== null || uavalidtokenno1111.equals("")||euaValidForAccess==null){	
%>
<jsp:forward page="/login.html"></jsp:forward>
<%}%>