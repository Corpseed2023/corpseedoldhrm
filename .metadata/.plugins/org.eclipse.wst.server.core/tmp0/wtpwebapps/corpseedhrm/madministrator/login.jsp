<%@page import="javax.servlet.http.HttpSession"%>
<!DOCTYPE HTML>
<html lang="en-US">

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title>Registered User Login Panel</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>	
</head>
<script type = "text/javascript" >
window.history.forward(); 
function noBack() { 
    window.history.forward(); 
} 
</script>
<body onload="trafficcontrol();">

<div class="wrap">
<%
HttpSession SES = request.getSession(true);
String getmsg=(String)SES.getAttribute("loginerrormsg"); 
%>

<div id="content">
		<div class="main-content">
			<div class="container">
			<div class="col-md-4 col-md-offset-4">
				<form class="crm-login" action="<%=request.getContextPath() %>/login.html" method="post" id="ITLoginCheck" name="ITLoginCheck">
				<input type="hidden" name="actiontype">
                <input type="hidden" name="empbrowser" id="empbrowser">
				<div class="text-center">
				 <img class="mb1" src="<%=request.getContextPath() %>/staticresources/images/logo.png" alt="Logo" width="140">
                 <h1 class="h3 mb2">Lets Get Started</h1>
                 <div>
                 <%if(getmsg!=null){%>
                 <p class="text-danger"><%=getmsg%></p>
                 <%}%><% SES.removeAttribute("loginerrormsg");%> </div>
                 <div>
                 <%
                 String passwordReset=(String)session.getAttribute("passwordresetsuccess");
                 if(passwordReset!=null){%>
                 <p class="text-success"><%=passwordReset%></p>
                 <%}%><% SES.removeAttribute("passwordresetsuccess");%> </div>
                 </div>
				  <div class="mb2">
				    <input type="text" class="form-control" name="userId" id="User ID" placeholder="Username *" required="required">				    
				  </div>
				  <div class="mb2">
				    <input type="password" class="form-control" name="userPassword" id="User Password" placeholder="Password *" required="required">
				  </div>
				  <div class="mb2 form-check">
				    <input type="checkbox" class="form-check-input" id="exampleCheck1">
				    <label class="form-check-label" for="exampleCheck1">Remember me</label>
				  </div>
				   <input type="hidden" id="LoginPage" name="loginpage" value="NA"/>
				  <button type="submit" class="btn btn-block btn-primary" onclick="document.getElementById('LoginPage').value='YAA'">SIGN IN</button>
				  <a href="<%=request.getContextPath() %>/forget-password.html" class="mt1" style="float: right;">Forget password ?</a>
                  <p class="mt4 mb2 text-muted text-center">
                      &copy; <span id="year"></span>
                  </p>
                  <input type="hidden" id="ForwardUrl" name="forwardUrl">
				</form>
				
			</div>
			</div>
		</div>
</div>
</div>	
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">

function trafficcontrol() {
	var host = location.host;
	var referrer = document.referrer;
	var useragent = navigator.userAgent;
	$.ajax({
		type : "POST",
		url : "trafficcontrol",
		data : {
			"host" : host,
			"referrer" : referrer,
			"useragent" : useragent
		}
	});
}
$(document).ready(function(){
	document.getElementById("year").innerHTML = new Date().getFullYear();
	document.getElementById("empbrowser").value=navigator.appCodeName;
	$("#ForwardUrl").val(window.location.href);
})

</script>
</body>
</html>