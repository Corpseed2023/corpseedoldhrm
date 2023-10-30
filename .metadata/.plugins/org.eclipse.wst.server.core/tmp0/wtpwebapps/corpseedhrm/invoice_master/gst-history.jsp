<%@page import="client_master.Clientmaster_ACT"%>
<%@page import="invoice_master.GST_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title>GST History</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	<%
String ghmonth= (String)session.getAttribute("ghmonth");
String ghcategory= (String)session.getAttribute("ghcategory");
String token=(String)session.getAttribute("uavalidtokenno");
String from = (String) session.getAttribute("from");
String to = (String) session.getAttribute("to");
String[][] gstData=GST_ACT.getGSTData(ghmonth, ghcategory, token, from, to);
%>
<%if(!GH00){%><jsp:forward page="/login.html" /><%} %>
    
	<div id="content">
		<div class="container">   
          <div class="bread-crumb">
            <div class="bd-breadcrumb bd-light">
            <a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
            <a>GST History</a>
            </div>
          </div>
        </div>

		<div class="main-content">
			<div class="container">
				<div class="row">
                	<div class="col-md-12 col-sm-12 col-xs-12">
                        <div class="menuDv partner-slider8">
                        	<div class="box-intro">
                              <h2><span class="title">GST History</span></h2>
                            </div>
                           <form name="RefineSearchenqu" action="<%=request.getContextPath()%>/gst-history" method="Post">
                              <input type="hidden" name="pageName" id="pageName"  value="manageservice.jsp">
								<input type="hidden" name="jsstype" id="jsstype">
								<div class="home-search-form clearfix">
                                <div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
                                  <select name="ghmonth" id="ghmonth" class="form-control" style="border: 1px solid #ccc; padding: 5px 5px !important;">
									<% if(ghmonth!=null){ %>
									<option value="<%=ghmonth%>"><%=ghmonth%></option>
									<% } %>
									<option value="">All</option>
								    <option value='Janaury'>Janaury</option>
								    <option value='February'>February</option>
								    <option value='March'>March</option>
								    <option value='April'>April</option>
								    <option value='May'>May</option>
								    <option value='June'>June</option>
								    <option value='July'>July</option>
								    <option value='August'>August</option>
								    <option value='September'>September</option>
								    <option value='October'>October</option>
								    <option value='November'>November</option>
								    <option value='December'>December</option>
								   </select>
                                  </div>
                                </div>
                                <div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
									<p><input type="text" name="ghcategory" id="ghcategory" placeholder="Select GST Category" class="form-control"<% if(ghcategory!=null){ %> value="<%=ghcategory%>"<% } %>/></p>
                                  </div>
                                </div>		
<div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
<% if(from!=null){ %>
<p><input type="text" name="from" id="from" value="<%=from%>" placeholder="From" class="form-control searchdate"/></p>
<%}else{ %>
<p><input type="text" name="from" id="from" placeholder="From" class="form-control searchdate"/></p>
<%} %>
</div>
</div>
<div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
<div class="input-group">
<span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
<% if(to!=null){ %>
<p><input type="text" name="to" id="to" value="<%=to%>" placeholder="To" class="form-control searchdate"/></p>
<%}else{ %>
<p><input type="text" name="to" id="to" placeholder="To" class="form-control searchdate"/></p>
<%} %>
</div>
</div>
                                <div class="item-bestsell col-md-4 col-sm-4 col-xs-12"></div>
                                <div class="pad-top5 item-bestsell col-md-4 col-sm-4 col-xs-12 search-cart-total">
                                <input class="btn-link-default bt-radius" type="button"  value="Search"  onclick="RefineSearchenquiry()"/>
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
                                    <p class="news-border">Customer Name</p>
                                    </div>
                                </div>
                                <div class="box-width5 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Project Name</p>
                                    </div>
                                </div>
                                <div class="box-width5 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Bill Amount</p>
                                    </div>
                                </div>
                                <div class="box-width5 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Invoice Amount</p>
                                    </div>
                                </div>
                                <div class="box-width5 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">GST Category</p>
                                    </div>
                                </div>
                                <div class="box-width20 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Tax Rate</p>
                                    </div>
                                </div>
                                <div class="box-width20 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Tax AMT</p>
                                    </div>
                                </div>
                                <div class="box-width20 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Paid On</p>
                                    </div>
                                </div>
                                <div class="box-width14 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p>Remarks + Paid?</p>
                                    </div>
                                </div>
                               </div>
                              </div>
                             </div>
                            
                            <%
                             for(int i=0;i<gstData.length;i++)
                             {
                            	String clientname = Clientmaster_ACT.getClientByInvId(gstData[i][6]);
                            	String projectname = Clientmaster_ACT.getProjectByInvId(gstData[i][7]);
                             %>
                            <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix">
                            	<div class="box-width1 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=i+1%></p>
                                    </div>
                                </div>
                                <div class="box-width4 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=clientname %></p>
                                    </div>
                                </div>
                                <div class="box-width5 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=projectname %></p>
                                    </div>
                                </div>
                                <div class="box-width5 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=gstData[i][8] %></p>
                                    </div>
                                </div>
                                <div class="box-width5 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=gstData[i][9] %></p>
                                    </div>
                                </div>
                                <div class="box-width5 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=gstData[i][2] %></p>
                                    </div>
                                </div>
                                <div class="box-width20 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=gstData[i][3] %></p>
                                    </div>
                                </div>
                                <div class="box-width20 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=gstData[i][4] %></p>
                                    </div>
                                </div>
                                <div class="box-width20 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=gstData[i][5] %></p>
                                    </div>
                                </div>
                                <div class="box-width14 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                	<% if(!gstData[i][5].equals("Not Paid")){%>
                                	<p><%=gstData[i][10]%></p>
                                	<% } else { %>
                                    <form action="gst-paid.html" name="gstpaid" id="gstpaid" method="post">
                                    <p>
                                    <input type="hidden" name="ghid" id="ghid" value="<%=gstData[i][0] %>">
                                    <input type="text" name="ghremarks<%=gstData[i][0] %>" id="ghremarks<%=gstData[i][0] %>" placeholder="Enter Remarks">
                                    <input type="text" class="datepicker" name="ghpaidon<%=gstData[i][0] %>" id="ghpaidon<%=gstData[i][0] %>" placeholder="Select date of Payment">
                                    <input type="submit" value="Paid." onclick="return checkPaid(<%=gstData[i][0] %>);">
                                    </p>
                               		</form>
                               		<% } %>
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
    function checkPaid(id){ 
    	if(document.getElementById('ghpaidon'+id).value==""){
    		document.getElementById('ghpaidon'+id).style.backgroundColor="pink";
    		return false;
    		} 
    	if(document.getElementById('ghremarks'+id).value==""){
    		document.getElementById('ghremarks'+id).style.backgroundColor="pink";
    		return false;
    		}
//     	document.gstpaid.submit();
    }
    $(function() {
	     $(".datepicker").datepicker({
	 		changeMonth: true,
			changeYear: true,
			dateFormat: 'dd-mm-yy'
		});
	});
    </script>
    <script type="text/javascript">
function RefineSearchenquiry() {
	document.RefineSearchenqu.jsstype.value="SSEqury";
	document.RefineSearchenqu.action="<%=request.getContextPath()%>/gst-history.html";
	document.RefineSearchenqu.submit();
}
</script>
</body>
</html>