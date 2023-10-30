<%@page import="admin.master.Usermaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Edit Profile</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	<%
String loginID=(String) session.getAttribute("passid");
String[][] user=Usermaster_ACT.getUserProfile(loginID);
%>
	<div id="content">
    	<div class="container">   
          <div class="bread-crumb">
            <div class="bd-breadcrumb bd-light">
            <a href="">Home</a>
            <a>Edit Profile</a>
            </div>
          </div>
        </div>

		<div class="main-content">
			<div class="container">
				<div class="row">
                	<div class="col-md-12 col-sm-12 col-xs-12">
                         <div class="menuDv clearfix">
                         <div class="box-intro">
                            <h2><span class="title">Edit Profile</span></h2>
                         </div>
                         <div class="post-slider clearfix">
                         <form action="update-profile.html" method="post" name="updateform" id="updateform">
                                  <div class="row">
                                  <div class="col-md-4 col-sm-4 col-xs-12">
                                   <div class="form-group">
                                    <input type="hidden" name="loginid" id="loginid" value="<%=loginID %>">
                                    <label>Name</label>
                                    <div class="input-group">
                                    <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
                                   <input type="text" name="userName" onchange="isUserColumnExist(this.value,'uaname','userNameErrorMSGdiv','User_Name')"  id="User_Name" value="<%=user[0][1] %>" placeholder="Enter Name*" onblur="requiredFieldValidation('User_Name','userNameErrorMSGdiv');" class="form-control">
                                    </div>
                                    <div id="userNameErrorMSGdiv" class="errormsg"></div>
                                   </div>
                                   </div>
                                  <div class="col-md-4 col-sm-4 col-xs-12">
                                   <div class="form-group">
                                    <label>Mobile No.</label>
                                    <div class="input-group">
                                    <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
                                  <input type="text" name="userMobile" onchange="isUserColumnExist(this.value,'uamobileno','userMobileErrorMSGdiv','User_Mobile')" id="User_Mobile" value="<%=user[0][2] %>" placeholder="Enter Mobile*" onblur="requiredFieldValidation('User_Mobile','userMobileErrorMSGdiv');" class="form-control" onkeypress="return isNumber(event)">
                                    </div>
                                    <div id="userMobileErrorMSGdiv" class="errormsg"></div>
                                   </div>
                                  </div>
                                  <div class="col-md-4 col-sm-4 col-xs-12">
                                   <div class="form-group">
                                    <label>Email Id</label>
                                    <div class="input-group">
                                    <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
                                    <input type="email" name="userEmail" onchange="isUserColumnExist(this.value,'uaemailid','userEmailErrorMSGdiv','User_Email_ID')" id="User_Email_ID" value="<%=user[0][3] %>"  placeholder="Enter Email ID*" onblur="requiredFieldValidation('User_Email_ID','userEmailErrorMSGdiv');" class="form-control">
                                   </div>
                                   <div id="userEmailErrorMSGdiv" class="errormsg"></div>
                                   </div>
                                  </div>
                                  </div>
                                  <div class="row">
                                  <div class="col-xs-12 item-product-info">
                                  <button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return editprofile();">Update<i class="fa fa-paper-plane" aria-hidden="true"></i></button>
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
	<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>	
	<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
	<script type="text/javascript">
function editprofile() {
	if(document.getElementById('User_Name').value==""){
		userNameErrorMSGdiv.innerHTML="User ID is required.";
		userNameErrorMSGdiv.style.color="#800606";
		return false;
	}
	if (document.getElementById('User_Mobile').value==""){
		userMobileErrorMSGdiv.innerHTML="User Mobile is required.";
		userMobileErrorMSGdiv.style.color="#800606";
		return false;
	}
	if (document.getElementById('User_Email_ID').value=="") {
		userEmailErrorMSGdiv.innerHTML="User Email is required.";
		userEmailErrorMSGdiv.style.color="#800606";
		return false;
	}
// document.updateform.submit();	
}
function isUserColumnExist(data,column,errorId,dataId){
	if(data!="")
		$.ajax({
			type : "POST",
			url : "ExistUserValue111",
			dataType : "HTML",
			data : {data:data,column:column},
			success : function(response){
				if(response=="pass"){
					document.getElementById(errorId).innerHTML=data +" is already existed !!";		
					document.getElementById(dataId).value="";
					document.getElementById(errorId).style.color="red";
				}		
			}
		});
}
</script>
</body>
</html>