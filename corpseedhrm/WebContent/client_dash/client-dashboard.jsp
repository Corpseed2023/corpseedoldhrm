<!DOCTYPE HTML>
<%@page import="Company_Login.CompanyLogin_ACT"%>
<%@page import="client_master.Clientmaster_ACT"%>

<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title>Dashboard</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheaderclient.jsp" %>
	<% String uaname = (String)session.getAttribute("uaname");
String clientID = Clientmaster_ACT.getClientIDByLoginName(uaname); %>
	<div id="content">
	    <div class="container">   
          <div class="bread-crumb">
          	<div class="bd-breadcrumb bd-light">
            <a href="">Home</a>
            <a>Dashboard</a>
            </div>
          </div>
        </div>
		<div class="main-content">
			<div class="container">
				<div class="row">
                	<div class="col-md-6 col-sm-6 col-xs-12">
                        <div class="menuDv partner-slider8">
                        	<div class="box-intro">
                              <h2><span class="title">Your Project Details</span></h2>
                            </div>
                            <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix">
                                <div class="col-md-1 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">SN</p>
                                    </div>
                                </div>
                                <div class="col-md-3 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Project Name</p>
                                    </div>
                                </div>
                                <div class="col-md-2 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Project Type</p>
                                    </div>
                                </div>
                                <div class="col-md-3 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Starting Date</p>
                                    </div>
                                </div>
                                   <div class="col-md-3 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p>Delivery Date</p>
                                    </div>
                                </div>
                               </div>
                              </div>
                            </div>
                            <% 
							String[][] getProjectByClient = Clientmaster_ACT.getProjectByClient(clientID);
							for(int i=0;i<getProjectByClient.length;i++) { if(i%2==0){ %>
							<div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix">
                                <div class="col-md-1 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=i+1%></p>
                                    </div>
                                </div>
                                <div class="col-md-3 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=getProjectByClient[i][1] %></p>
                                    </div>
                                </div>
                                <div class="col-md-2 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=getProjectByClient[i][2] %></p>
                                    </div>
                                </div>
                                <div class="col-md-3 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=getProjectByClient[i][3] %></p>
                                    </div>
                                </div>
                                <div class="col-md-3 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p><%=getProjectByClient[i][4] %></p>
                                    </div>
                                </div>
                               </div>
                              </div>
                              </div>
                              <% } else { %>
                              <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="list-boxBg clearfix">
                                <div class="col-md-1 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=i+1 %></p>
                                    </div>
                                </div>
                                <div class="col-md-3 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=getProjectByClient[i][1] %></p>
                                    </div>
                                </div>
                                <div class="col-md-2 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=getProjectByClient[i][2] %></p>
                                    </div>
                                </div>
                                <div class="col-md-3 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=getProjectByClient[i][3] %></p>
                                    </div>
                                </div>
                                <div class="col-md-3 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p><%=getProjectByClient[i][4] %></p>
                                    </div>
                                </div>
                               </div>
                              </div>
                              </div>
                            <% } } %>
                         </div>
					</div>
					<div class="col-md-6 col-sm-6 col-xs-12">
                        <div class="menuDv partner-slider8">
                        	<div class="box-intro">
                              <h2><span class="title">Billings</span></h2>
                            </div>
                            <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix">
                                <div class="col-md-1 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">SN</p>
                                    </div>
                                </div>
                                <div class="col-md-3 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Project Name</p>
                                    </div>
                                </div>
                                <div class="col-md-2 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Billing Date</p>
                                    </div>
                                </div>
                                <div class="col-md-3 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Pay Status</p>
                                    </div>
                                </div>
                                   <div class="col-md-3 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p>Amount</p>
                                    </div>
                                </div>
                               </div>
                              </div>
                            </div>
                            <% 
                            String[][] billing=CompanyLogin_ACT.getBillingsByCompany(clientID);
							for(int i=0;i<billing.length;i++) { if(i%2==0){ %>
							<div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix">
                                <div class="col-md-1 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=i+1 %></p>
                                    </div>
                                </div>
                                <div class="col-md-3 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=billing[i][4] %></p>
                                    </div>
                                </div>
                                <div class="col-md-2 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=billing[i][3] %></p>
                                    </div>
                                </div>
                                <div class="col-md-3 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <% if(billing[i][8].equals("NA")||billing[i][8].equals("0")){ %>
                                    <p class="news-border" style="color: red;">Payment Due</p>
                                    <% } else { %>
                                    <p class="news-border"><%=billing[i][8] %></p>
                                    <% } %>
                                    </div>
                                </div>
                                <div class="col-md-3 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p><%=billing[i][9] %></p>
                                    </div>
                                </div>
                               </div>
                              </div>
                              </div>
                              <% } else { %>
                              <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="list-boxBg clearfix">
                                <div class="col-md-1 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=i+1 %></p>
                                    </div>
                                </div>
                                <div class="col-md-3 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=billing[i][4] %></p>
                                    </div>
                                </div>
                                <div class="col-md-2 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=billing[i][3] %></p>
                                    </div>
                                </div>
                                <div class="col-md-3 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <% if(billing[i][8].equals("NA")||billing[i][8].equals("0")){ %>
                                    <p class="news-border" style="color: red;">Payment Due</p>
                                    <% } else { %>
                                    <p class="news-border"><%=billing[i][8] %></p>
                                    <% } %>
                                    </div>
                                </div>
                                <div class="col-md-3 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p><%=billing[i][9] %></p>
                                    </div>
                                </div>
                               </div>
                              </div>
                              </div>
                            <% } } %>
                         </div>
					</div>
				</div>
<% if(CSR00){ %> 
				<div class="row" style="margin-top: 20px;">
                	<div class="col-md-6 col-sm-6 col-xs-12">
                        <div class="menuDv partner-slider8">
                        	<div class="box-intro">
                              <h2><span class="title">Last SEO Report</span></h2>
                            </div>
                            <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix">
                                <div class="col-md-1 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">SN</p>
                                    </div>
                                </div>
                                <div class="col-md-7 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Project Name</p>
                                    </div>
                                </div>
                                <div class="col-md-4 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p>Date of Report</p>
                                    </div>
                                </div>
                               </div>
                              </div>
                            </div>
                            <% 
							String[][] lastseoreport = CompanyLogin_ACT.getLastSeoReport(clientID);
							for(int i=0;i<lastseoreport.length;i++) { if(i%2==0){ %>
							<div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix">
                                <div class="col-md-1 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=i+1%></p>
                                    </div>
                                </div>
                                <div class="col-md-7 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=lastseoreport[i][0]%></p>
                                    </div>
                                </div>
                                <div class="col-md-4 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p><%=lastseoreport[i][1]%></p>
                                    </div>
                                </div>
                               </div>
                              </div>
                              </div>
                              <% } else { %>
                              <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="list-boxBg clearfix">
                                <div class="col-md-1 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=i+1%></p>
                                    </div>
                                </div>
                                <div class="col-md-7 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=lastseoreport[i][0]%></p>
                                    </div>
                                </div>
                                <div class="col-md-4 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p><%=lastseoreport[i][1]%></p>
                                    </div>
                                </div>
                               </div>
                              </div>
                              </div>
                            <% } } %>
                         </div>
					</div>
				</div>
<% } %>
			</div>
		</div>
	</div>
	<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>	
	<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
</body>
</html>