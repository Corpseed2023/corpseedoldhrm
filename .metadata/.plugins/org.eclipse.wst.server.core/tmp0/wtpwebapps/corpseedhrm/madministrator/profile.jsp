<%@page import="admin.master.Usermaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title>User Profile</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	<%if(!MMP00){%><jsp:forward page="/login.html" /><%} %>
	<%
String loginID=(String) session.getAttribute("passid");
String[][] user=Usermaster_ACT.getUserProfile(loginID);
%>
	<div id="content">
		<div class="container">   
          <div class="bread-crumb">
            <div class="bd-breadcrumb bd-light">
            <a href="">Home</a>
            <a>My Profile</a>
            </div>
          </div>
        </div>
		<div class="main-content">
			<div class="container">
                   <div class="menuDv clearfix">
                    <div class="box-intro">
                      <h2><span class="title">My Profile</span></h2>
                    </div>
                    <form onsubmit="return false;" method="post">
                       <div class="row">
                        <div class="col-md-12 col-sm-12 col-xs-12">
                             <div class="product-list none-sidebar clearfix">
								<div class="item-product-thumb"><span>Name</span></div>
								<div class="item-product-info"><span><%=user[0][1] %></span></div>
							  </div>
                             <div class="product-list none-sidebar clearfix home-slider">
                                <div class="item-product-thumb"><span>Mobile No.</span></div>
								<div class="item-product-info"><span><%=user[0][2] %></span></div>
							  </div>
                            <div class="product-list none-sidebar clearfix">
                              <div class="item-product-thumb"><span>Email Id</span></div>
                              <div class="item-product-info"><span><%=user[0][3] %></span></div>
                            </div>
                         </div>
                       </div>
                       <%if(MMP04){ %>
                       <div class="clearfix item-product about-content pad_box2">
                         <button class="bt-link bt-radius bt-loadmore" type="submit" onclick="vieweditpage('<%=loginID%>');">Edit Profile<i class="fa fa-pencil-square-o" aria-hidden="true"></i></button>
                       </div><%} %>
                     </form>
                    </div> 
                </div>
		</div>
	</div>
	<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>	
	<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
	<script type="text/javascript">
	function vieweditpage(id){
		$.ajax({
		    type: "POST",
		    url: "<%=request.getContextPath()%>/vieweditpage",
		    data:  { 
		    	"uid" : id
		    },
		    success: function (response) {
	        	window.location = "<%=request.getContextPath()%>/editprofile.html";
	        },
		});
	}
	</script>
</body>
</html>