<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title>Payment Summary</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	<%
	String token=(String)session.getAttribute("uavalidtokenno");
String from = (String) session.getAttribute("from");
String to = (String) session.getAttribute("to");
String[][] getAllPaymentDetails=Clientmaster_ACT.getAllPaymentDetails(token, from, to);
%>
<%if(!MP02){%><jsp:forward page="/login.html" /><%} %>
    
	<div id="content">
		<div class="container">   
          <div class="bread-crumb">
            <div class="bd-breadcrumb bd-light">
            <a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
            <a>Payment Summary</a>
            </div>
          </div>
        </div>

		<div class="main-content">
			<div class="container">
				<div class="row">
                	<div class="col-md-12 col-sm-12 col-xs-12">
                        <div class="menuDv partner-slider8">
                        <div class="row">
							<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="top_title text-center">
							<h2>Manage Payment Summary</h2>
							</div>
							<%if(MP01){%><a class="add_btn sub-btn1" href="<%=request.getContextPath() %>/generate-payment.html">Generate Payment</a><%} %>
							</div>
					</div>
                        	
                        	
<form action="<%=request.getContextPath()%>/payment-summary.html" method="POST">
<div class="home-search-form clearfix">
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
<% if(from!=null){ %>
<p><input type="text" name="from" id="from" value="<%=from%>" placeholder="From" class="form-control searchdate"/></p>
<%}else{ %>
<p><input type="text" name="from" id="from" placeholder="From" class="form-control searchdate"/></p>
<%} %>
</div>
</div>
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
<% if(to!=null){ %>
<p><input type="text" name="to" id="to" value="<%=to%>" placeholder="To" class="form-control searchdate"/></p>
<%}else{ %>
<p><input type="text" name="to" id="to" placeholder="To" class="form-control searchdate"/></p>
<%} %>
</div>
</div>
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12"></div>
<div class="pad-top5 item-bestsell col-md-2 col-sm-2 col-xs-12 search-cart-total">
<input class="btn-link-default bt-radius" type="submit" value="Search"/>
</div>
</div>
</form>                             
                            <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix">
                            	<div class="box-width1 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">SN</p>
                                    </div>
                                </div>
                                <div class="box-width4 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Client Name</p>
                                    </div>
                                </div>
                                <div class="box-width4 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Project Name</p>
                                    </div>
                                </div>
                                <div class="box-width7 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Invoice No</p>
                                    </div>
                                </div>
                                <div class="box-width7 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Receiving Date</p>
                                    </div>
                                </div>
                                <div class="box-width12 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Status</p>
                                    </div>
                                </div>
                                <div class="box-width3 col-xs-3 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p>Action</p>
                                    </div>
                                </div>
                               </div>
                              </div>
                             </div>
                            
                            <%
                             for(int i=0;i<getAllPaymentDetails.length;i++)
                             {
                             %>
                            <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix">
                            	<div class="box-width1 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=getAllPaymentDetails[i][0] %></p>
                                    </div>
                                </div>
                                <div class="box-width4 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=getAllPaymentDetails[i][5] %></p>
                                    </div>
                                </div>
                                <div class="box-width4 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=getAllPaymentDetails[i][4] %></p>
                                    </div>
                                </div>
                                <div class="box-width7 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=getAllPaymentDetails[i][1] %></p>
                                    </div>
                                </div>
                                <div class="box-width7 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=getAllPaymentDetails[i][2] %></p>
                                    </div>
                                </div>
                                <div class="box-width12 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=getAllPaymentDetails[i][3] %></p>
                                    </div>
                                </div>
                                <div class="box-width3 col-xs-3 box-intro-background">
                                	<div class="link-style12">
                                    <p>
                                    <%if(MP03){ %><a href="javascript:void(0);" onclick="vieweditpage(<%=getAllPaymentDetails[i][0] %>,'view');"><i class="fa fa-eye" title="view"></i></a><%} %>
                                    <%if(MP04){ %><a href="javascript:void(0);" onclick="vieweditpage(<%=getAllPaymentDetails[i][0] %>,'edit');"><i class="fa fa-edit" title="edit"></i></a><%} %>
                                    <%if(MP04){ %><a href="javascript:void(0);" onclick="approve(<%=getAllPaymentDetails[i][0]%>)"> <i class="fa fa-trash" title="delete"></i></a><%} %>
                                    </p>
                                    </div>
                                </div>
                              </div>
                            </div>
                          </div>
                         <% }%>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>	
</div>
	<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
    <script type="text/javascript">
    function approve(id) {
    	if(confirm("Sure you want to Delete this Payment ? "))
    	{
    	var xhttp; 
    	xhttp = new XMLHttpRequest();
    	xhttp.onreadystatechange = function() {
    	if (this.readyState == 4 && this.status == 200) {
    	location.reload();
    	}
    	};
    	xhttp.open("GET", "<%=request.getContextPath()%>/DeletePayment111?info="+id, true);
    	xhttp.send();
    	}
    }
    </script>
    <script type="text/javascript">
	function vieweditpage(id,page){
		$.ajax({
		    type: "POST",
		    url: "<%=request.getContextPath()%>/vieweditpage",
		    data:  { 
		    	"uid" : id
		    },
		    success: function (response) {
	        	if(page=="view") window.location = "<%=request.getContextPath()%>/viewpayment.html";
	        	else if(page=="edit") window.location = "<%=request.getContextPath()%>/editpayment.html";
	        },
		});
	}
	</script>
</body>
</html>