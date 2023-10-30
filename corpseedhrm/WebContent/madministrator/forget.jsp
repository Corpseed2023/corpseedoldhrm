<%@page import="javax.servlet.http.HttpSession"%>
<!DOCTYPE HTML>
<html lang="en-US">

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title>Registered User Login Panel</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>	
</head>
<body>

<div class="wrap">
<%
HttpSession SES = request.getSession(true);
String getmsg=(String)SES.getAttribute("forgeterrormsg");  
String className=(String)SES.getAttribute("forgeterrorclass");
%>

<div id="content">
		<div class="main-content">
			<div class="container">
			<div class="col-md-4 col-md-offset-4">
				<form class="crm-login" action="<%=request.getContextPath() %>/reset-link.html" method="post" id="ITLoginCheck" name="ITLoginCheck">
				<input type="hidden" name="actiontype">
                <input type="hidden" name="empbrowser" id="empbrowser">
				<div class="text-center">
				 <img class="mb1" src="<%=request.getContextPath() %>/staticresources/images/logo.png" alt="Logo" width="140">
                 <h1 class="h3 mb2">Forgot password ?</h1>
                 <span>You can reset you password here !!</span>
                 <div>
                 <%if(getmsg!=null&&className!=null){%>
                 <p class="<%=className%>"><%=getmsg%></p>
                 <%}%><% SES.removeAttribute("forgeterrormsg");%> </div>
                 </div>
				  <div class="mb2" style="margin-top: 15px;">
				    <input type="text" class="form-control" name="userId" id="User ID" placeholder="Username*" required="required">				    
				  </div> 
				  <button type="submit" class="btn btn-block btn-primary">RESET LINK</button>
<%-- 				  <a href="<%=request.getContextPath() %>/login.html" class="mt1" style="float: right;">Back to login ?</a> --%>
                  <p class="mt4 mb2 text-muted text-center">
                      &copy; <span id="year"></span>
                  </p>
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