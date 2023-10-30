<%@page import="client_master.Clientmaster_ACT"%>
<%@page import="Company_Login.CompanyLogin_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title>Billings</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheaderclient.jsp" %>
	<%
String uaname = (String)session.getAttribute("uaname");
String clientID = Clientmaster_ACT.getClientIDByLoginName(uaname);
String[][] billing=CompanyLogin_ACT.getBillingsByCompany(clientID);
%>
	<div id="content">
		<div class="container">   
          <div class="bread-crumb">
            <div class="bd-breadcrumb bd-light">
            <a href="">Home</a>
            <a>Billings</a>
            </div>
          </div>
        </div>
		<div class="main-content">
			<div class="container">
				<div class="row">
                	<div class="col-md-12 col-sm-12 col-xs-12">
                        <div class="menuDv partner-slider8">
                        	<div class="box-intro">
                              <h2><span class="title">Billings</span></h2>
                            </div>
                            <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix">
                            	<div class="box-width1 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">SN</p>
                                    </div>
                                </div>
                                <div class="box-width12 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Project Name</p>
                                    </div>
                                </div>                        
                               <div class="box-width2 col-xs-3 box-intro-bg" style="width: 10.15%;">
                                	<div class="box-intro-border">
                                    <p class="news-border">Amount</p>
                                    </div>
                                </div>
                                <div class="box-width5 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Month</p>
                                    </div>
                                </div>
                                <div class="box-width5 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Billing Date</p>
                                    </div>
                                </div>
                                <div class="box-width5 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Receiving Date</p>
                                    </div>
                                </div>
                                  <div class="box-width5 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Status</p>
                                    </div>
                                </div>
                                <div class="box-intro-bg">
                                	<div class="box-intro-border">
                                    <p>Remarks</p>
                                    </div>
                                </div>
                               </div>
                              </div>
                            </div>
                            <%
                             for(int i=0;i<billing.length;i++) {
	                         if(i%2==0){
                             %>
                            <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix">
                            	<div class="box-width1 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=i+1%></p>
                                    </div>
                                </div>
                                <div class="box-width12 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=billing[i][4] %></p>
                                    </div>
                                </div>
                                <div class="box-width2 col-xs-3 box-intro-background" style="width: 10.15%;">
                                	<div class="link-style12">
                                    <p class="news-border"><%=billing[i][1] %></p>
                                    </div>
                                </div>
                                <div class="box-width5 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=billing[i][2] %></p>
                                    </div>
                                </div>
                                <div class="box-width5 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=billing[i][3] %></p>
                                    </div>
                                </div>
                                <div class="box-width5 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <% if(billing[i][6].equals("NA")){ %>
                                    <p class="news-border" style="color: red;">Payment Due</p>
                                    <% } else { %>
                                    <p class="news-border"><%=billing[i][6] %></p>
                                    <% } %>
                                    </div>
                                </div>
                                <div class="box-width5 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=billing[i][7] %></p>
                                    </div>
                                </div>
                                <div class="box-intro-background">
                                	<div class="link-style12">
                                    <p><%=billing[i][10] %></p>
                                    </div>
                                </div>
                               </div>
                              </div>
                              <%} else{%>
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="list-boxBg clearfix">
                            	<div class="box-width1 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=i+1%></p>
                                    </div>
                                </div>
                                <div class="box-width12 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=billing[i][4] %></p>
                                    </div>
                                </div>
                                <div class="box-width2 col-xs-3 box-intro-background" style="width: 10.15%;">
                                	<div class="link-style12">
                                    <p class="news-border"><%=billing[i][1] %></p>
                                    </div>
                                </div>
                                <div class="box-width5 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=billing[i][2] %></p>
                                    </div>
                                </div>
                                <div class="box-width5 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=billing[i][3] %></p>
                                    </div>
                                </div>
                                <div class="box-width5 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <% if(billing[i][6].equals("NA")){ %>
                                    <p class="news-border" style="color: red;">Payment Due</p>
                                    <% } else { %>
                                    <p class="news-border"><%=billing[i][6] %></p>
                                    <% } %>
                                    </div>
                                </div>
                                <div class="box-width5 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=billing[i][7] %></p>
                                    </div>
                                </div>
                                <div class="box-intro-background">
                                	<div class="link-style12">
                                    <p><%=billing[i][10] %></p>
                                    </div>
                                </div>
                               </div>
                              </div>
                            </div>
                            <%} }%> 
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