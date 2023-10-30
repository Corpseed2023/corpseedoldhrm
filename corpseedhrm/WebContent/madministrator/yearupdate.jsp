<%@page import="javax.servlet.http.HttpSession"%>
<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Update Year</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div class="wrap">
<div id="header">
		<div class="header">
        	<div class="row">
                  <div class="col-md-12 col-sm-12 col-xs-12">
                    <div class="top-header">&nbsp;</div>
                  </div>
              </div>
			  <div class="row">
					<div class="col-md-3 col-sm-3 col-xs-12">
						<div class="logo1">
							<a href="<%=request.getContextPath()%>/"><img src="https://www.hrm.itsws.com/staticresources/images/itsws_technologies_logo.png" alt=" ITSWS Technologies Pvt. Ltd."></a>	
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
                            </div>
                          </div>
                      </div>
                  </div>
			</div>
		</div>
	</div>
<div id="content">
<div class="container">   
<div class="bread-crumb">
<div class="bd-breadcrumb bd-light">
<a href="<%=request.getContextPath() %>/">Home</a>
<a>Notification</a>
</div>
</div>
</div>
<div class="main-content">
<div class="container">
<div class="row">
<div class="home-bestsale-product col-md-12 col-sm-12 col-xs-12 item-product-info">
<div class="user-login">
<div class="menuDv">
<p>Are you sure you want to update all references of Year in UID?</p>
<div class="col-xs-12 locator">
<form action="<%=request.getContextPath()%>/yearupdateyes.html" method="post">
<button type="submit" class="bt-link bt-radius bt-loadmore">YES</button>
</form>
</div>
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
</body>
</html>