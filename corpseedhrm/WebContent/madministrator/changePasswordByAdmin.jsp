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
String url = request.getParameter("uid");
String[] a=url.split(".html");
String[] b=a[0].split("-");
String ualoginid=b[1];
%>
	<div id="content">	

		<div class="clearfix login_popup">
			<div class="container">
				<div class="row">
                	<div class="centerdiv col-md-6 col-sm-6 col-xs-12">
                      <div class="user-login">
                          <div class="menuDv">
                            <h3><i class="fa fa-lock" aria-hidden="true"></i>Change Password</h3>
                            <form onsubmit="return false;" method="post" name="reqFeedBackSubmitform" id="reqFeedBackSubmitform">
                             <input type="hidden" name="ualoginid" id="LoginId" value="<%=ualoginid%>">
                              <div class="row">
                                  <div class="col-xs-12">
                                  <div class="form-group">
                                    <label>New Password :<span style="color: red;">*</span></label>
                                    <div class="input-group">
                                    <span class="input-group-addon"><i class="form-icon sprite password"></i></span>
                                    <input type="password" name="newpassword" id="New Password" placeholder="Enter New Password*" onblur="requiredFieldValidation('New Password','pwdErrorMSGdiv');" class="form-control">
                                     <span class="show_psw" onclick="myFunction1()">
									<i class="fa fa-eye-slash" style="font-size:15px;color:#006080"></i>
									</span>
                                    </div>
                                    <div id="pwdErrorMSGdiv" class="error_text"></div>
                                  </div>
                                  </div>
                                  <div class="col-xs-12">
                                  <div class="form-group">
                                    <label>Re-Enter New Password :<span style="color: red;">*</span></label>
                                    <div class="input-group">
                                    <span class="input-group-addon"><i class="form-icon sprite password"></i></span>
                                    <input type="password" name="userPassword" id="Confirm Password" placeholder="Re-enter New Password*" onblur="requiredFieldValidation('Confirm Password','confirmpwdErrorMSGdiv');ResetPasswordValidation('New Password','Confirm Password','confirmpwdErrorMSGdiv');" class="form-control">
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
function reqpmoenqSubmit()
{
	var newpass=document.getElementById('New Password').value.trim();
	var confpass=document.getElementById('Confirm Password').value.trim();

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

var ualoginid=document.getElementById('LoginId').value.trim();
var newpassword=document.getElementById('New Password').value.trim();
var userPassword=document.getElementById('Confirm Password').value.trim();

var xhttp;
xhttp = new XMLHttpRequest();
xhttp.onreadystatechange = function() {
if (this.readyState == 4 && this.status == 200) {
parent.location.reload();
}
};
xhttp.open("POST", "<%=request.getContextPath()%>/update-passwordByAdmin.html?ualoginid="+ualoginid+"&newpassword="+newpassword+"&userPassword="+userPassword, true);
xhttp.send();
}


function myFunction() {
	  var x = document.getElementById("Confirm Password");
	  if (x.type == "password") {
	    x.type = "text";
	  } else {
	    x.type = "password";
	    
	  }
	}
function myFunction1() {
	  var y = document.getElementById("New Password");
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