<%@page import="java.util.Properties"%>
<%@page import="commons.DateUtil"%>
<%@page import="admin.task.TaskMaster_ACT"%>
<%@page import="admin.master.Usermaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title>Change Password</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<%
String user_uid = request.getParameter("ufp");
if(user_uid==null)user_uid="NA";
else user_uid=user_uid.trim();
String pkey = request.getParameter("fpk");
if(pkey==null)pkey="NA";
else pkey=pkey.trim();
String date=DateUtil.getCurrentDateIndianReverseFormat();
boolean isExpired=TaskMaster_ACT.isLinkExpired(user_uid, date);

Properties properties = new Properties();
properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
String domain=properties.getProperty("domain");
%>
	<div id="content">	

		<div class="clearfix login_popup">
			<div class="container">
				<div class="row">
                	<div class="centerdiv col-md-6 col-sm-6 col-xs-12">
                      <div class="user-login">
                          <div class="menuDv">
                            <h3><i class="fa fa-lock" aria-hidden="true"></i>Reset Password</h3>
                            <div>
			                 <%
			                 String getmsg=(String)session.getAttribute("resetpassworderrormsg");
			                 if(getmsg!=null){%>
			                 <p class="text-danger"><%=getmsg%></p>
			                 <%}%><% session.removeAttribute("resetpassworderrormsg");%> </div>
                            <form action="update-forget-password.html" method="post" name="reqFeedBackSubmitform" id="reqFeedBackSubmitform">
                             <input type="hidden" name="user_uuid" id="UserUuid" value="<%=user_uid%>">
                             <input type="hidden" name="forget_key" id="ForgetKey" value="<%=pkey%>">
                              <div class="row">
                                  <div class="col-xs-12">
                                  <div class="form-group">
                                    <label>New Password :<span style="color: red;">*</span></label>
                                    <div class="input-group">
                                    <input type="password" name="newpassword" id="New_Password" placeholder="Enter New Password*" onblur="requiredFieldValidation('New_Password','pwdErrorMSGdiv');" class="form-control">
                                     <span class="show_psw" onclick="myFunction1()">
									<i class="fa fa-eye-slash" style="font-size:15px;color:#006080"></i>
									</span>
                                    </div>
                                    <div id="pwdErrorMSGdiv" class="error_text"></div>
                                  </div>
                                  </div>
                                  <div class="col-xs-12">
                                  <div class="form-group">
                                    <label>Confirm Password :<span style="color: red;">*</span></label>
                                    <div class="input-group">
                                    <input type="password" name="confirmPassword" id="Confirm_Password" placeholder="Re-enter New Password*" onblur="requiredFieldValidation('Confirm_Password','confirmpwdErrorMSGdiv');ResetPasswordValidation('New_Password','Confirm_Password','confirmpwdErrorMSGdiv');" class="form-control">
                                    <span class="show_psw" onclick="myFunction()">
									<i class="fa fa-eye-slash" style="font-size:15px;color:#006080"></i>
									</span>
                                    </div>
                                   <div id="confirmpwdErrorMSGdiv" class="error_text"></div>
                                  </div>
                                  </div>
                                  <div class="col-xs-12 advert text-center">
                                   <button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return reqpmoenqSubmit();">Update<i class="fa fa-paper-plane" aria-hidden="true"></i></button>
                                  </div>
                                </div>
                              </form> 
                          </div>
					  </div>
					</div>                  
				</div>
			</div>
		</div>
	</div>
	

	<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
$(document).ready(function(){
	var expired=<%=isExpired%>;
	var domain="<%=domain%>";
	if(expired){
		alert("link is expired !!")
		location.replace(domain+"forget-password.html");
	}
	
})	
	
function reqpmoenqSubmit()
{
	var newpass=document.getElementById('New_Password').value.trim();
	var confpass=document.getElementById('Confirm_Password').value.trim();
	var user_uuid="<%=user_uid%>";
	var forget_uuid="<%=pkey%>";
	
	if(user_uuid=="NA"||forget_uuid=="NA"){
		alert("invalid reset password link !!");
		return false;
	}
	
if(newpass=="")
{
	pwdErrorMSGdiv.innerHTML="New Password is required.";
	pwdErrorMSGdiv.style.color="red";
return false;
}
if(confpass=="")
{
	confirmpwdErrorMSGdiv.innerHTML="Confirm Password is required.";
	confirmpwdErrorMSGdiv.style.color="red";
return false;
}
}


function myFunction() {
	  var x = document.getElementById("Confirm_Password");
	  if (x.type == "password") {
	    x.type = "text";
	  } else {
	    x.type = "password";
	    
	  }
	}
function myFunction1() {
	  var y = document.getElementById("New_Password");
	  if (y.type == "password") {
	    y.type = "text";
	  } else {
	    y.type = "password";
	    
	  }
	}	
$('.show_psw').click(function(event){
	//event.preventDefault();
	$(this).toggleClass('active');
});

</script>
</body>
</html>