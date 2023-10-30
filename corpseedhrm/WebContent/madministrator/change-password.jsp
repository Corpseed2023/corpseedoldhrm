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
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>

	<div id="content">
    	<div class="container">   
          <div class="bread-crumb">
            <div class="bd-breadcrumb bd-light">
            <a href="">Home</a>
            <a>Change Password</a>
            </div>
          </div>
        </div>

		<div class="main-content">
			<div class="container">
				<div class="row">
                	<div class="col-md-3 col-sm-3 col-xs-12"></div>
                	<div class="col-md-6 col-sm-6 col-xs-12">
                      <div class="user-login">
                          <div class="menuDv">
                            <h3><i class="fa fa-lock" aria-hidden="true"></i>Change Password</h3>
                            <form action="update-password.html" method="post" name="reqFeedBackSubmitform" id="reqFeedBackSubmitform">
                             
                              <div class="row">
                                  <div class="col-xs-12">
                                   <div class="form-group">
                                      <label>Current Password :<span style="color: red;">*</span></label>
                                      <div class="input-group">
                                      <span class="input-group-addon"><i class="form-icon sprite password"></i></span>
                                      <input name="currentPassword" id="Current User Password" placeholder="Enter Current Password*" onblur="requiredFieldValidation('Current User Password','currentpwdErrorMSGdiv');" class="form-control">
                                    
                                      </div>
                                     <div id="currentpwdErrorMSGdiv" class="errormsg"></div>
                                    </div>
                                   </div>
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
                                    <div id="pwdErrorMSGdiv" class="errormsg"></div>
                                  </div>
                                  </div>
                                  <div class="col-xs-12">
                                  <div class="form-group">
                                    <label>Confirm Password :<span style="color: red;">*</span></label>
                                    <div class="input-group">
                                    <span class="input-group-addon"><i class="form-icon sprite password"></i></span>
                                    <input type="password" name="userPassword" id="Confirm Password" placeholder="Re-enter New Password*" onblur="requiredFieldValidation('Confirm Password','confirmpwdErrorMSGdiv');ResetPasswordValidation('New Password','Confirm Password','confirmpwdErrorMSGdiv');" class="form-control">
                                    <span class="show_psw" onclick="myFunction()">
									<i class="fa fa-eye-slash" style="font-size:15px;color:#006080"></i>
									</span>
                                    </div>
                                   <div id="confirmpwdErrorMSGdiv" class="errormsg"></div>
                                  </div>
                                  </div>
                                  <div class="col-xs-12 locator">
                                   <button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return reqpmoenqSubmit();">Update<i class="fa fa-paper-plane" aria-hidden="true"></i></button>
                                  </div>
                                </div>
                              </form> 
                          </div>
					  </div>
					</div> 
                    <div class="col-md-3 col-sm-3 col-xs-12"></div>                   
				</div>
			</div>
		</div>
	</div>
	<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>	
	<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
	<script type="text/javascript">
function reqpmoenqSubmit()
{
	var current=document.getElementById('Current User Password').value.trim();
	var newpass=document.getElementById('New Password').value.trim();
	var confpass=document.getElementById('Confirm Password').value.trim();
if(current=="")
{
	currentpwdErrorMSGdiv.innerHTML="Current password is required.";
	currentpwdErrorMSGdiv.style.color="red";
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
if(current==confpass)
{
	confirmpwdErrorMSGdiv.innerHTML="Current Password and confirm password are same.";
	confirmpwdErrorMSGdiv.style.color="red";
return false;
}

// if(document.getElementById('New Password').value!=document.getElementById('Confirm Password').value)
// {
// 	confirmpwdErrorMSGdiv.innerHTML="Confirm Password is not matched.";
// 	confirmpwdErrorMSGdiv.style.color="#800606";
// return false;
// }
// document.reqFeedBackSubmitform.submit();
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