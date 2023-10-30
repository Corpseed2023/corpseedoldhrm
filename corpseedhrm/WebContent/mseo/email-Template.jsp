<%@ include file="../../madministrator/checkvalid_user.jsp" %>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title></title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div class="wrap">
    
    <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="menuDv">
                    <div class="box-intro">
                      <h2><span class="title">Email</span></h2>
                    </div>
                <div class="clearfix pad_box2">
                       <form method="post" action="<%=request.getContextPath() %>/"   name="follow-up-form">
                            <div class="clearfix form-group mtop10">
                            <label>Email Id :<span style="color: red;">*</span></label>
                            <div class="clearfix relative_box">
                            <input type="email" id="Email" autocomplete="off" name="name" onblur="verifyEmailId('Email','nameErr');" class="form-control" placeholder="Email Id here !"/>
                            <div id="nameErr" class="popup_error"></div>
                            </div>
                            </div>
                            <div class="clearfix form-group">
                            <label>Message :<span style="color: red;">*</span></label>
                            <div class="clearfix relative_box">
                            <textarea id="Message" autocomplete="off" name="message" onblur="" rows="5" value="" class="form-control"" placeholder="Text  message here !"></textarea>
                            <div id="messageErr" class="popup_error"></div>
                            </div>
                            </div>
                            <div class="clearfix item-product-info form-group">
                                  <button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return smsValidations();">Send<i class="fa fa-send"></i></button>
                            </div>
                     </form>
                   </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
	function smsValidations() {
	var Email=document.getElementById('Email').value.trim();
	var message=document.getElementById('Message').value.trim();	
		
	if(Email=="" ) {
		nameErr.innerHTML="Email is required.";
		nameErr.style.color="red";
	return false;
	}else
		nameErr.innerHTML="";
	
	if(message=="" ) {
		messageErr.innerHTML="Message is required.";
		messageErr.style.color="red";
	return false;
	}else
		messageErr.innerHTML="";	
}
</script>
</body>
</html>