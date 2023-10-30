<%@page import="admin.Login.LoginAction"%>
<%
// response.setHeader("Cache-Control","no-cache");  
// response.setHeader("Cache-Control","no-store");  
// response.setDateHeader("Expires", -1);
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Cache-Control", "no-store");
response.setDateHeader("Expires", 0);
response.setHeader("Pragma", "no-cache");

String uavalidtokenno1111= (String)session.getAttribute("uavalidtokenno");
String uaIsValid1= (String)session.getAttribute("loginuID");
if(uaIsValid1== null || uaIsValid1.equals("") || uavalidtokenno1111== null || uavalidtokenno1111.equals("")){
%>
<jsp:forward page="/login.html"></jsp:forward>
<%}%>
