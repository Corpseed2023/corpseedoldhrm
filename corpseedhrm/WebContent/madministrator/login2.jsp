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
<div id="header">
		<div class="header">
			  <div class="row">
					<div class="col-md-3 col-sm-3 col-xs-12">
						<div class="logo1">
							<a href="<%=request.getContextPath()%>/"><img src="staticresources/images/corpseed-logo.png"></a>	
						</div>
					</div>
                    <div class="col-md-9 col-sm-9 col-xs-12">
                      <div class="col-md-12 col-sm-12 col-xs-12">
                          <div class="row">
                            <div class="header-nav">
                              <nav class="main-nav main-nav3">
                               <ul class="main-menu">
                                <li><a href="<%=request.getContextPath()%>/">Home</a></li>
                              </ul>
                              <div class="mobile-menu">
                                  <a class="show-menu"><span class="lnr lnr-indent-decrease"></span></a>
                                  <a class="hide-menu"><span class="lnr lnr-indent-increase"></span></a>
                              </div> 
                              </nav>
                              <!-- End Main Nav -->
                            </div>
                          </div>
                        <!-- End Main Nav -->
                      </div>
                  </div>
			</div>
		</div>
	</div>
<!-- End Header -->
<div id="content">
		<div class="main-content">
			<div class="container">
				<div class="row">
                	<div class="col-md-3 col-sm-3 col-xs-12">
					</div>
                	<div class="col-md-6 col-sm-6 col-xs-12">
                      <div class="user-login">
                          <div class="menuDv">
                            <h3><i class="fa fa-user"></i>Login</h3>
                              <form action="login.html" method="post" id="ITLoginCheck" name="ITLoginCheck">
                              <input type="hidden" name="actiontype">
                              <input type="hidden" name="empbrowser" id="empbrowser">
                                <div class="row">
                                 <div class="col-xs-12">
                                 <div>
                                 <%if(getmsg!=null){%>
                                 <p><%=getmsg%></p>
                                 <%}%>
								 <% SES.removeAttribute("loginerrormsg");%>
                                 </div>
                                  <div class="form-group">
                                    <label>Enter User ID</label>
                                    <div class="input-group">
                                    <span class="input-group-addon"><i class="far fa-user"></i></span>
                                    <input type="text" name="userId" id="User ID" placeholder="Enter User ID*" onblur="requiredFieldValidation('User ID','leerrorMSGdiv');" class="form-control">
                                    </div>
                                    <div id="leerrorMSGdiv" class="errormsg"></div>
                                  </div>
                                  </div>
                                  <div class="col-xs-12">
                                  <div class="form-group">
                                    <label>Enter Password</label>
                                    <div class="input-group">
                                    <span class="input-group-addon"><i class="fas fa-lock"></i></span>
                                    <input type="password" name="userPassword" id="User Password" placeholder="Enter Password*" onblur="requiredFieldValidation('User Password','lpeerrorMSGdiv');" class="form-control">
                                    </div>
                                    <div id="lpeerrorMSGdiv" class="errormsg"></div>
                                  </div>
                                  </div>
                                  <input type="hidden" id="LoginPage" name="loginpage" value="NA"/>
                                  <div class="col-xs-12 locator">
                                  <button type="submit" class="bt-link bt-radius bt-loadmore" onclick="document.getElementById('LoginPage').value='YAA'">Login<i class="fa fa-paper-plane" aria-hidden="true"></i></button>
                                  </div>
                                </div>
                              </form>
                              
                          </div>
					  </div>
					</div>
                    <div class="col-md-3 col-sm-3 col-xs-12">
					</div>
                    <div class="col-md-12 col-sm-12 col-xs-12">
                    <div class="box-intro">
                      <h2><span class="title">Warning</span></h2>
                      <span class="desc-title">This application 'Corpseed ITES Pvt. Ltd.' is available only for authorized users. If you are not an authorized user, please disconnect the session by closing the browser immediately. By accessing this system, you agree that your actions may be monitored if unauthorised usage is suspected.
                      </span>
                      </div>
                      </div>
				</div>
			</div>
		</div>
</div>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
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
document.getElementById("empbrowser").value=navigator.appCodeName;
</script>
</body>
</html>