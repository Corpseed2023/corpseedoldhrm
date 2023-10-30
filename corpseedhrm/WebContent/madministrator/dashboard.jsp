<%@page import="commons.CommonHelper"%>
<%@page import="admin.master.Usermaster_ACT"%>
<%@page import="admin.task.TaskMaster_ACT"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="commons.DateUtil"%>
<%@page import="client_master.Clientmaster_ACT"%>
<%@page import="admin.enquiry.Enquiry_ACT"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="admin.seo.SeoOnPage_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title>Dashboard</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<%@ include file="../staticresources/includes/itswsheader.jsp" %> 
<% 
DecimalFormat df = new DecimalFormat("####0.00");
String userroll= (String)session.getAttribute("userRole");
String loginuaid = (String)session.getAttribute("loginuaid");
String token = (String)session.getAttribute("uavalidtokenno");
String querydate=(String)session.getAttribute("enqSearchDate");
if(querydate==null||querydate=="") querydate="NA";
String searchenqproject=(String)session.getAttribute("searchenqproject");
if(searchenqproject==null||searchenqproject=="") searchenqproject="NA";
String searchdatebilling=(String)session.getAttribute("searchdatebilling");
if(searchdatebilling==null||searchdatebilling=="") searchdatebilling="NA";
String searchdatepayment=(String)session.getAttribute("searchdatepayment");
if(searchdatepayment==null||searchdatepayment=="") searchdatepayment="NA";
/* new */
String today=DateUtil.getCurrentDateIndianFormat1();
double pymtPendingForApproval=Math.round(TaskMaster_ACT.getApprovalPayment(token));
double duePayment=Math.round(TaskMaster_ACT.getSalesDueAmount(token)); 
// System.out.println("Due amount=="+duePayment);
String teamKey="NA";
String salesTeamKey="NA";
double totalPercentage[]=TaskMaster_ACT.getTotalSalesAmountPercent(token);
double professionalFee=TaskMaster_ACT.getTotalProfessionalFee(token);
double governmentFee=TaskMaster_ACT.getTotalGovernmentFee(token);
double spendGovtFee=TaskMaster_ACT.getDepartmentFeeExpense(token);
double salesDue=duePayment;
String department=Usermaster_ACT.getUserDepartment(loginuaid,token);
if(!department.equals("Document")){
%> 
<div class="wrap">
	<div id="content" class="dashboard_page clearfix">	    
       <div class="main-content admdashboad">
            
            <div class="clearfix <%if(!department.equals("Admin")&&!department.equals("Account")){ %>noDisplay<%} %>" id="AccountReportModule">            
            <div class="container">
				<div class="clearfix form-group">
                <h2 class="sub-title">Financial Overview</h2>
                </div>
                <div class="row">
                	<div class="col-md-7 col-sm-7 col-xs-12">
                      <div class="clearfix dashbdr_lft_box box_ht1 box_shadow3">
                        <div class="chart_box">
                          <canvas id="sales_overview_chart"></canvas>
                        </div>
                        <div class="chart_info">
                         <h3>Financial Report</h3>
                         <p>Financial overview for last 12 months</p>
                        </div>
                      </div>
                    </div>
                    <div class="col-md-5 col-sm-5 col-xs-12">
                      <div class="clearfix dashbdr_rt_box box_ht1 box_shadowblue">
                        <div class="report_box">
                        <h2>Financial <span>Overview</span></h2>
                        <a href="javascript:void(0)">
                        <div class="report_box_bt" <%if(department.equals("Admin")){ %>onclick="showModule('AccountReportModule','DeliveryReportModule')"<%} %>>
                          <h3>View Details</h3>
                          <i class="fa fa-chevron-right"></i>
                        </div>
                        </a>
                        </div>
                      </div>
                    </div>
                </div>
            </div>
            
            <div class="container">
                <div class="row"><%if(department.equals("Admin")||department.equals("Account")){ %>
                	<div class="col-md-7 col-sm-7 col-xs-12">
                      <div class="clearfix form-group">
                      <h2 class="sub-title">Financial Overview</h2>
                      </div>
                      
                      <div class="box_shadow1 redius_box pad_box4 bg_wht mb30 box_shadow3">
                        <div class="clearfix dashboard_info flex_box">                          
                          <div class="clearfix box-width29 floleft">
                            <span style="color: #ff0000"><%=df.format(totalPercentage[0])%>%</span>
                            <h3>Total</h3>
                          </div>
                          <div class="clearfix box-width18 floleft">
                            <span>Professional</span>
                            <h4><i class="fa fa-inr"></i><%=CommonHelper.formatValue(professionalFee) %></h4>
                          </div>
                          <div class="clearfix box-width18 floleft">
                            <span>Government</span>
                            <h4><i class="fa fa-inr"></i><%=CommonHelper.formatValue(governmentFee) %></h4>
                          </div>
                          <div class="bdr_left clearfix box-width18 floleft text-center">
                            <span>&nbsp;</span>
                            <h4 class="txt_blue"><i class="fa fa-inr"></i><%=CommonHelper.formatValue(professionalFee+governmentFee) %></h4>
                          </div>
                        </div>
                      </div>
                      <div class="box_shadow1 redius_box pad_box4 bg_wht mb30 box_shadow3">
                        <div class="clearfix dashboard_info flex_box">
                          <div class="clearfix box-width29 floleft">
                            <span style="color: #48bd44">+0%</span>
                            <h3>Refund Total</h3>
                          </div>
                          <div class="clearfix box-width18 floleft">
                            <span>Professional</span>
                            <h4><i class="fa fa-inr"></i>50K</h4>
                          </div>
                          <div class="clearfix box-width18 floleft">
                            <span>Government</span>
                            <h4><i class="fa fa-inr"></i>50K</h4>
                          </div>
                          <div class="bdr_left clearfix box-width18 floleft text-center">
                            <span>&nbsp;</span>
                            <h4 class="txt_blue"><i class="fa fa-inr"></i>50K</h4>
                          </div>
                        </div>
                      </div>
                      <div class="box_shadow1 redius_box pad_box4 bg_wht mb30 box_shadow3">
                        <div class="clearfix dashboard_info flex_box">
                          <div class="clearfix box-width29 floleft">
                            <span style="color: #ff0000"><%=df.format(totalPercentage[1])%>%</span>
                            <h3>Due Total</h3>
                          </div>
                          <div class="clearfix box-width18 floleft">
                            <span>Sales</span>
                            <h4><i class="fa fa-inr"></i><%=CommonHelper.formatValue(salesDue) %></h4>
                          </div>
                          <div class="clearfix box-width18 floleft">
                            <span>Government</span>
                            <h4><i class="fa fa-inr"></i><%=CommonHelper.formatValue(governmentFee-spendGovtFee) %></h4>
                          </div>
                          <div class="bdr_left clearfix box-width18 floleft text-center">
                            <span>&nbsp;</span>
                            <h4 class="txt_blue"><i class="fa fa-inr"></i><%=CommonHelper.formatValue((salesDue)+(governmentFee-spendGovtFee))%></h4>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="col-md-5 col-sm-5 col-xs-12">
                      <div class="clearfix form-group">
                      <h2 class="sub-title">DUE REQUEST</h2>
                      </div>
                      <div class="box_shadow1 redius_box pad_box4 bg_wht mb30 box_shadow3">
                        <div class="clearfix dashboard_info">
                          <div class="row">
                          <div class="col-md-8 col-sm-8 col-xs-12">
                           <div class="clearfix dashboard_info">
                            <span>Account</span>
                            <h3>Pending</h3>
                            <p class="desc">Payments pending for approval</p>
                           </div>
                          </div>
                          <div class="col-md-4 col-sm-4 col-xs-12">
                           <div class="clearfix dashboard_info_box">
                            <span class="fas fa-inr">&nbsp;<%=CommonHelper.formatValue(pymtPendingForApproval) %></span>
                           </div>
                          </div>
                          </div>
                        </div>
                      </div>
                      <div class="box_shadow1 redius_box pad_box4 bg_wht mb30 box_shadow3">
                        <div class="clearfix dashboard_info">
                          <div class="row">
                          <div class="col-md-8 col-sm-8 col-xs-12">
                           <div class="clearfix dashboard_info">
                            <span>Client</span>
                            <h3>Due</h3>
                            <p class="desc">Payments pending for collection</p>
                           </div>
                          </div>
                          <div class="col-md-4 col-sm-4 col-xs-12">
                           <div class="clearfix dashboard_info_box">
                            <span class="fas fa-inr">&nbsp;<%=CommonHelper.formatValue(duePayment) %></span>
                           </div>
                          </div>
                          </div>
                        </div>
                      </div>
                    </div><%} %>
                </div>
            </div>
            
            <div class="container">
				              
                <div class="row">
                	<div class="col-md-5 col-sm-5 col-xs-12">
                	<div class="clearfix form-group">
                <h2 class="sub-title">PROJECTS PAYMENT</h2>
                </div>  
                      <div class="clearfix dashbdr_lft_box box_shadow3">
                        <div class="pai_chart_box chart_box text-center">
                          <canvas id="doughnut_chart"></canvas>
                        </div> 
                        <div class="chart_info">
                         <ul class="pai_chart_info clearfix">
                         <li class="row"><span><i class="fa fa-circle txt_blue"></i><span id="DueSaleChart">40%</span></span><span class="info_txt">Due</span></li>
                         <li class="row"><span><i class="fa fa-circle txt_dark_blue"></i><span id="PartialSaleChart">30%</span></span><span class="info_txt">Partial</span></li>
                         <li class="row"><span><i class="fa fa-circle txt_green"></i><span id="CompleteSaleChart">30%</span></span><span class="info_txt">Complete</span></li>
                         </ul>
                        </div>
                      </div>
                    </div>				
                    <div class="col-md-7 col-sm-7 col-xs-12">
                    <div class="clearfix form-group">
	                <h2 class="sub-title">RECENT TASK</h2>
	                </div>  
	                  <%
		                    String dueProjects[][]=null;
		                    if(department.equals("Admin")||department.equals("Account"))
		                    dueProjects=TaskMaster_ACT.get3DueProjects(token);		                    
		                    %>
	                <div class="table-responsive">
					<table class="ctable">
						<thead>
						<tr>
						<th>Date</th>
						<th>Project No.</th>
						<th>Company</th>
						<th>Product Name</th>
						</tr>
						</thead>
						<tbody>
						<%if(dueProjects!=null&&dueProjects.length>0){
	                    	for(int i=0;i<dueProjects.length;i++){ %>
						<tr>
						<td><%=dueProjects[i][15] %></td>
						<td><%=dueProjects[i][4] %></td>
						<td><%=dueProjects[i][7] %></td>
						<td><%=dueProjects[i][9] %></td>
						</tr>
						<%}} %>
						</tbody>				
	                </table>	                
	                </div>	                
                    </div>
                </div>
            </div>
            
            <div class="container">
                <div class="clearfix form-group">
                  <h2 class="sub-title">TOTAL INCOME VS SPEND STATICS</h2>
                </div>
                <div class="row">
                	<div class="col-md-6 col-sm-6 col-xs-12">
                      <div class="box_shadow1 redius_box pad_box4 bg_wht mb30 box_shadow3">
                        <div id="bar_graph"></div>
                      </div>
                    </div>
                    <div class="col-md-6 col-sm-6 col-xs-12">
                      <div class="relative_box box_shadow1 redius_box pad_box4 bg_wht mb30 box_shadow3">
                        <div class="clearfix text-right">
                          <ul class="list-inline line_chart_info">
                            <li class="txt_blue"> <i class="fa fa-circle"></i> Cash In</li>
                            <li class="txt_dark_blue"> <i class="fa fa-circle"></i> Cash out</li>
                            <li class="txt_green"> <i class="fa fa-circle"></i> Net</li>
                          </ul>
                        </div>
                        <div id="earning"></div>
                      </div>
                    </div>
                </div>
            </div>
            
            <div class="container">
                <div class="clearfix form-group">
                  <h2 class="sub-title">TOTAL REVENUE VS EXPENSE</h2>
                </div>
                <div class="row">
                	<div class="col-md-7 col-sm-7 col-xs-12">
                      <div class="relative_box box_shadow1 redius_box pad_box4 bg_wht mb30 box_shadow3">
                        <div id="columnchartContainer" style="height: 342px; width: 100%;"> </div>
                      </div>
                    </div>
                    <div class="col-md-5 col-sm-5 col-xs-12">
                      <div class="relative_box box_shadow1 redius_box pad_box4 bg_wht mb30 box_shadow3">
                        <!--<div id="bar_graph1"></div>--><div id="donut"></div>
                      </div>
                    </div>
                </div>
            </div>
            
            </div>
            <div class="clearfix noDisplay" id="DeliveryReportModule">
            <%
            String deliveryUser[][]=null;            
            if(userroll.equals("Admin")||userroll.equals("Manager")||userroll.equals("Assistant")){
            	if(userroll.equals("Assistant"))
            	teamKey=TaskMaster_ACT.teamKeyByLeaderUaidAnddepartment(loginuaid,"Delivery",token);
            	if(department.equals("Admin")||department.equals("Delivery"))
            	deliveryUser=Usermaster_ACT.getAllUserByDepartment("Delivery",token,userroll,teamKey,loginuaid);	
            	
            }            
            %>
            <div class="container">
				<div class="clearfix form-group">
                <div class="row">
                <div class="col-md-4 col-sm-4 col-xs-12">
                <h2 class="sub-title">Delivery Report</h2>
                </div>
                <div class="col-md-3 col-sm-3 col-xs-12">
                <%if(userroll.equals("Admin")||userroll.equals("Manager")||(userroll.equals("Assistant")&&teamKey!=null&&!teamKey.equals("NA"))){ %>
                <div class="select_menu_box text-right">
                 <select class="select_menu" id="select_menu" onchange="getSalesStatus('<%=userroll%>',this.value,'<%=teamKey%>');getRecentLiveProjects(this.value)">
                  <option value="">View All</option>
                  <%if(deliveryUser!=null&&deliveryUser.length>0){ 
                  for(int i=0;i<deliveryUser.length;i++){%>
                  <option value="<%=deliveryUser[i][0]%>"><%=deliveryUser[i][1]%></option>
                  <%}} %>
                 </select>
                </div>
                <%} %>
                </div>
                </div>
                </div>
                <div class="row">
                	<div class="col-md-7 col-sm-7 col-xs-12">
                      <div class="clearfix dashbdr_lft_box box_ht1 box_shadow3">
                        <div class="chart_box">
                          <canvas id="sales_overview_chart1"></canvas>
                        </div>
                        <div class="chart_info">
                         <h3>Delivery Report</h3>
                         <p>Delivery Report for last 6 months</p>
                        </div>
                      </div>
                    </div>
                    <div class="col-md-5 col-sm-5 col-xs-12">
                      <div class="clearfix dashbdr_rt_box box_ht1 box_shadowblue">
                        <div class="report_box">
                        <h2>Delivery <span>Report</span></h2>
                        <a href="javascript:void(0)">
                        <div class="report_box_bt" <%if(department.equals("Admin")){ %>onclick="showModule('DeliveryReportModule','SalesReportModule')"<%} %>>
                          <h3>View Details</h3>
                          <i class="fa fa-chevron-right"></i>
                        </div>
                        </a>
                        </div>
                      </div>
                    </div>
                </div>
            </div>
            
            <div class="container">
                <div class="row">
                	<div class="col-md-12 col-sm-12 col-xs-12">
                      <div class="clearfix form-group">
                      <h2 class="sub-title">Delivery Statistics</h2>
                      </div>
                      <div class="row">
                	  <div class="col-md-4 col-sm-4 col-xs-12">
                      <div class="box_shadow1 redius_box pad_box4 bg_wht mb30 box_shadow3">
                        <div class="clearfix dashboard_info flex_box">
                          <div class="clearfix">
                            <h4>Total on time delivery</h4>
                            <h3 class="txt_green" id="OnTimeDelivery"></h3>
                          </div>
                        </div>
                      </div>
                      </div>
                      <div class="col-md-4 col-sm-4 col-xs-12">
                      <div class="box_shadow1 redius_box pad_box4 bg_wht mb30 box_shadow3">
                        <div class="clearfix dashboard_info flex_box">
                          <div class="clearfix">
                            <h4>Delayed delivery</h4>
                            <h3 class="txt_red" id="DelayedDelivery"></h3>
                          </div>
                        </div>
                      </div>
                      </div>
                      <div class="col-md-4 col-sm-4 col-xs-12">
                      <div class="box_shadow1 redius_box pad_box4 bg_wht mb30 box_shadow3">
                        <div class="clearfix dashboard_info flex_box">
                          <div class="clearfix">
                            <h4>Customer Satisfaction</h4>
                            <h3 class="txt_blue">80%</h3>
                          </div>
                        </div>
                      </div>
                      </div>
                      </div>
                    </div>
                </div>
            </div>
            
            <div class="container">
                <div class="row">
                    <div class="col-md-6 col-sm-6 col-xs-12">
                      <div class="clearfix form-group">
                      <h2 class="sub-title">Upcoming Deadline</h2>
                      </div>
                      
                   <div class="table-responsive">
					<table class="ctable">
						<thead>
						<tr>
						<th>Task Name</th>
						<th>Assigned</th>
						<th>Date</th>
						</tr>
						</thead>
						<tbody>
						<tr id="AppendUpcomingDeadline"></tr>
						</tbody>				
	                </table>	                
	                </div>               
                    </div>
                    <div class="col-md-6 col-sm-6 col-xs-12">
                      <div class="clearfix form-group">
                        <h2 class="sub-title">Ticket Statistic</h2>
                      </div>
                      <div class="clearfix dashbdr_lft_box box_shadow3">
                        <div class="pai_chart_box chart_box text-center">
                          <canvas id="doughnut_chart1"></canvas>
                        </div> 
                        <div class="chart_info">              
                         <ul class="pai_chart_info clearfix">
						 <li class="clearfix"><span><i class="fa fa-circle iconu"></i><span id="UnassignedTaskChart">25%</span></span><span class="info_txt">Unassigned</span></li>
						 <li class="clearfix"><span><i class="fa fa-circle iconn"></i><span id="NewTaskChart">25%</span></span><span class="info_txt">New</span></li>
                         <li class="clearfix"><span><i class="fa fa-circle icono"></i><span id="OpenTaskChart">25%</span></span><span class="info_txt">Open</span></li>
                         <li class="clearfix"><span><i class="fa fa-circle iconh"></i><span id="OnholdTaskChart">30%</span></span><span class="info_txt">On-hold</span></li>
                         <li class="clearfix"><span><i class="fa fa-circle iconp"></i><span id="PendingTaskChart">25%</span></span><span class="info_txt">Pending</span></li>
                         <li class="clearfix"><span><i class="fa fa-circle iconc"></i><span id="CompletedTaskChart">20%</span></span><span class="info_txt">Completed</span></li>
                         <li class="clearfix"><span><i class="fa fa-circle icone"></i><span id="ExpiredTaskChart">20%</span></span><span class="info_txt">Expired</span></li>
                         </ul>
                        </div>
                      </div>
                    </div>
                </div>
            </div>
            
            <div class="container">
                <div class="clearfix form-group">
                   <h2 class="sub-title">Task Status</h2>
                </div>
                <div class="row">
                    <div class="col-md-5 col-sm-5 col-xs-12">
                      <div class="clearfix dashbdr_lft_box box_shadow3" id="CanvasChart">
                        <div class="bar_chart">
                        <canvas id="canvas"></canvas>
                        </div>
                      </div>
                    </div>
                    <div class="col-md-7 col-sm-7 col-xs-12">
                      <div class="box_shadow1 redius_box bg_wht mb30">
                      <div class="table-responsive">
					 <table class="ctable">
						<thead>
						<tr>
						<th>Task Name</th>
						<th>Progress</th>
						<th>Assignee</th>
						<td>Delivery Date</td>
						</tr>
						</thead>
						<tbody>
						<tr id="RecentActiveTask"></tr>
						</tbody>				
	                </table>	                
	                </div>                       
                      </div>
                    </div>
                </div>
            </div>
            
            <div class="container">
                <div class="row">
                    <div class="col-md-6 col-sm-6 col-xs-12">
                      <div class="clearfix form-group">
                      <h2 class="sub-title">Recent Projects</h2>
                      </div>
                      <div class="table-responsive">
					 <table class="ctable" id="recentActiveLiveProject">
						<thead>
						<tr>
						<th>Project Name</th>
						<th>Assigned Team</th>
						<td>Delivery Date</td>
						</tr>
						</thead>
						<tbody>
						</tbody>				
		               </table>	                
		               </div>                      
                    </div>
                    <div class="col-md-6 col-sm-6 col-xs-12">
                      <div class="clearfix form-group">
                        <h2 class="sub-title">Recent Communication Box</h2>
                      </div>
                      <div class="clearfix box_shadow1 redius_box bg_wht mb30 box_shadow3"> 
                       <div class="communication_box">
                        <div id="RecentCommunicationBox"></div>                        
                       </div>
                      </div>
                    </div>
                </div>
            </div>
            
            </div>            
            <div class="clearfix noDisplay" id="SalesReportModule">
             <%
            String salesUser[][]=null;            
            if(userroll.equals("Admin")||userroll.equals("Manager")||userroll.equals("Assistant")){
            	if(userroll.equals("Assistant"))
            	salesTeamKey=TaskMaster_ACT.teamKeyByLeaderUaidAnddepartment(loginuaid,"Sales",token);
            	if(department.equals("Admin")||department.equals("Sales"))
            	salesUser=Usermaster_ACT.getAllUserByDepartment("Sales",token,userroll,salesTeamKey,loginuaid);	
            
            }            
            %>
            <div class="container">
                <div class="clearfix form-group">
                <div class="row">
                <div class="col-md-4 col-sm-4 col-xs-12">
                <h2 class="sub-title">Sales Report</h2>
                </div>
                <div class="col-md-3 col-sm-3 col-xs-12">
                <%if(userroll.equals("Admin")||userroll.equals("Manager")||(userroll.equals("Assistant")&&salesTeamKey!=null&&!salesTeamKey.equals("NA"))){ %>
                <div class="select_menu_box text-right">
                 <select class="select_menu" id="select_menu" onchange="getProjectStatus('<%=userroll%>',this.value,'<%=salesTeamKey%>')">
                  <option value="">View All</option>
                  <%if(salesUser!=null&&salesUser.length>0){ 
                  for(int i=0;i<salesUser.length;i++){%>
                  <option value="<%=salesUser[i][0]%>"><%=salesUser[i][1]%></option>
                  <%}} %>
                 </select>
                </div>
                <%} %>
                </div>
                </div>
                </div>
                <div class="row">
                	<div class="col-md-7 col-sm-7 col-xs-12">
                      <div class="clearfix dashbdr_lft_box box_ht1 box_shadow3">
                        <div class="chart_box">
                          <canvas id="sales_overview_chart3"></canvas>
                        </div>
                        <div class="chart_info">
                         <h3>Revenue Report</h3>
                         <p>Revenue Generated over in last 6 months</p>
                        </div>
                      </div>
                    </div>
                    <div class="col-md-5 col-sm-5 col-xs-12">
                      <div class="clearfix dashbdr_rt_box box_ht1 box_shadowblue">
                        <div class="report_box">
                        <h2>Sales <span>Report</span></h2>
                        <a href="javascript:void(0)">
                        <div class="report_box_bt" <%if(department.equals("Admin")){ %>onclick="showModule('SalesReportModule','AccountReportModule')"<%} %>>
                          <h3>View Details</h3>
                          <i class="fa fa-chevron-right"></i>
                        </div>
                        </a>
                        </div>
                      </div>
                    </div>
                </div>
            </div>
           
            <div class="container">
                <div class="row">
                	<div class="col-md-12 col-sm-12 col-xs-12">
                      <div class="clearfix form-group">
                      <h2 class="sub-title">Sales Statistics</h2>
                      </div>
                      <div class="row">
                      <div class="col-md-3 col-sm-3 col-xs-12">
                      <div class="box_shadow1 redius_box pad_box4 bg_wht mb30 box_shadow3">
                        <div class="clearfix dashboard_info flex_box">
                          <div class="clearfix">
                            <h4>Estimate sales</h4>
                            <h3 class="txt_blue" id="EstimateSale"></h3>
                          </div>
                        </div>
                      </div>
                      </div>
                	  <div class="col-md-3 col-sm-3 col-xs-12">
                      <div class="box_shadow1 redius_box pad_box4 bg_wht mb30 box_shadow3">
                        <div class="clearfix dashboard_info flex_box">
                          <div class="clearfix">
                            <h4>Total sales</h4>
                            <h3 class="txt_green" id="TotalSales"></h3>
                          </div>
                        </div>
                      </div>
                      </div>
                      <div class="col-md-3 col-sm-3 col-xs-12">
                      <div class="box_shadow1 redius_box pad_box4 bg_wht mb30 box_shadow3">
                        <div class="clearfix dashboard_info flex_box">
                          <div class="clearfix">
                            <h4>Due Amount</h4>
                            <h3 class="txt_red fas fa-inr" id="SalesDueAmount"></h3>
                          </div>
                        </div>
                      </div>
                      </div>
                      <div class="col-md-3 col-sm-3 col-xs-12">
                      <div class="box_shadow1 redius_box pad_box4 bg_wht mb30 box_shadow3">
                        <div class="clearfix dashboard_info flex_box">
                          <div class="clearfix">
                            <h4>Clients</h4>
                            <h3 class="txt_dark_blue" id="ClientOfSeller"></h3>
                          </div>
                        </div>
                      </div>
                      </div>
                      </div>
                    </div>
                </div>
            </div>
            
            <div class="container">
                <div class="row">
                    <div class="col-md-7 col-sm-7 col-xs-12">
                      <div class="clearfix dashbdr_lft_box box_ht1 box_shadow3">
                        <div class="chart_box">
                          <canvas id="sales_overview_chart2"></canvas>
                        </div>
                        <div class="chart_info">
                         <h3>Project Report</h3>
                         <p>Project Delivery vs Projected Created over last 6 months</p>
                        </div>
                      </div>
                    </div>
                    <div class="col-md-5 col-sm-5 col-xs-12">
                      <div class="clearfix form-group">
                        <h2 class="sub-title">Recent Communication Box</h2>
                      </div>
                      <div class="clearfix box_shadow1 redius_box bg_wht mb30 box_shadow3"> 
                        <div class="home-search-form clearfix noDisplay">
                        <div class="item-bestsell col-sm-6 col-xs-12">
                        <p><input type="search" name="communication_Project_name" onsearch="clearSession('projectNoCommunicationAction','NA')" oninput="getProjectsCommunication(this.value)" id="Communication_Project_name" title="Search by Name" placeholder="Search by Name" class="form-control" autocomplete="off"/></p>
                        <div id="nameerr" class="errMsg"></div>
                        </div>
                        <div class="item-bestsell col-sm-6 col-xs-12 has-clear">
                        <p><input type="text" name="date_range_box" id="date_range_box" autocomplete="off" placeholder="DD-MM-YYYY - DD-MM-YYYY" class="form-control text-center date_range pointers" readonly="readonly"/>
						</p>
						<span class="form-control-clear form-control-feedback" onclick="clearSession('dateRangeCommunicationAction','dateCommunication')"></span>
                        </div>
                        </div>
                       <div class="communication_box">
                        <div id="RecentcommunicationRefresh"> 
                        <div id="ProjectCommunication"></div>                        
                        </div>                      
                        
                       </div>
                      </div>
                    </div>
                </div>
            </div>
            
            <div class="container">
                <div class="row">
                    <div class="col-md-12 col-sm-12 col-xs-12">
                      <div class="clearfix form-group">
                      <h2 class="sub-title">Recent Projects</h2>
                      </div>
                       <div class="box_shadow1 redius_box bg_wht mb30">
                        <div class="home-search-form clearfix noDisplay">
                        <div class="box-width18 item-bestsell col-md-2 col-sm-3 col-xs-12">
                        <p><input type="search" name="projectname" id="Project_Name" onsearch="clearSession('projectNameDashboardAction','NA')" oninput="getRecentProjects(this.value)" title="Search by Project Name" placeholder="Search by Project Name" class="form-control"/></p>
                        </div>
                        <div class="box-width18 item-bestsell col-md-2 col-sm-3 col-xs-12 has-clear">
                        <p id="SalesDateRangeId"><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="DD-MM-YYYY - DD-MM-YYYY" class="form-control text-center date_range pointers" readonly="readonly"/>
						
						</p>
						<span class="form-control-clear form-control-feedback" onclick="clearSession('dateRangeDashboardAction','date')"></span> 
                        </div>
                        </div>
                        <div class="row ">
						<div class="col-md-12">  
						<div class="table-responsive">
							<table class="ctable">
						    <thead>
						      <tr>
						            <th>Date</th>
						            <th>Project No.</th>
						            <th>Project Name</th>
						            <th>Client</th>
						            <th>Progress</th>
						            <th>Status</th>
						            <th>Assigned Team</th>
						        </tr>
						    </thead>
						    <tbody id="RecentProjectsRefresh"> 
						    <tr id="RecentProjectAppend"></tr> 
						    </tbody>
						 </table> 
                        <!-- <div class="clearfix">
                          <div class="clearfix">
                            <div class="col-md-1 col-sm-1 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Date</p>
                                </div>
                            </div>
                            <div class="box-width12 col-md-2 col-sm-1 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Project No.</p>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-3 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Project Name</p>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-2 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Client</p>
                                </div>
                            </div>
                            <div class="col-md-1 col-sm-2 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Progress</p>
                                </div>
                            </div>
                            <div class="col-md-1 col-sm-2 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Status</p>
                                </div>
                            </div>
                            <div class="box-width7 col-md-1 col-sm-2 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Assigned Team</p>
                                </div>
                            </div>
                           </div>
                          <div id="RecentProjectsRefresh">
                        
                          <div id="RecentProjectAppend"></div>                                                     

                          </div>
                        </div> -->
                      </div>
                    </div>
                </div>
            </div>
            
            <div class="clearfix">
                <div class="row">
                	<div class="col-md-7 col-sm-7 col-xs-12">
                      <div class="clearfix form-group">
                        <h2 class="sub-title">Top Categories</h2>
                      </div>
                      <div class="relative_box box_shadow1 redius_box pad_box4 bg_wht mb30 box_shadow3">
                        <div id="columnchartContainer1" style="height: 342px; width: 100%;"> </div>
                      </div>
                    </div>
                    
                    <div class="col-md-5 col-sm-5 col-xs-12">
                      <div class="clearfix form-group">
                        <h2 class="sub-title">Top Services</h2>
                      </div>                     
                      <div class="relative_box box_shadow1 redius_box pad_box4 bg_wht mb30 box_shadow3">
                       <div id="TopSaleAppend"></div>
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
</div>
</div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/canvasjs.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/Chart.bundle.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/init-sales-overview-chart.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/init-doughnut-chart.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/graph.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/raphael-min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/jquery.graphly.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/line-chart.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/column-chart.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/utils.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/bar_chart.js"></script>

<script type="text/javascript">
$( function() {
	$( ".datepick" ).datepicker({
	changeMonth: true,
	changeYear: true,
	yearRange: '2013: +0',
	dateFormat: 'yy-mm-dd'
	});
	} );
	
	function setSearchDate(date,sname){		
		var xhttp; 
		xhttp = new XMLHttpRequest();
		xhttp.onreadystatechange = function() {
		if (this.readyState == 4 && this.status == 200) {
		location.reload();
		}
		};
		xhttp.open("POST", "<%=request.getContextPath()%>/SetDashboardDate111?sname="+sname+"&date="+date, true);
		xhttp.send(); 
	}
	function vieweditpage(id){
    	$.ajax({
    	    type: "POST",
    	    url: "<%=request.getContextPath()%>/vieweditpage",
    	    data:  { 
    	    	"uid" : id
    	    },
    	    success: function (response) {
            	window.location = "<%=request.getContextPath() %>/view-completed-task.html";
            },
    	});
    }
	
</script>
<script type="text/javascript">
   $(document).ready(function() {  
	   
	  var chart = {
		 type: 'column'
	  };
	  var title = {
		 text: 'Department Expense vs Total Revenue'   
	  };
	  var subtitle = {
		 text: ''  
	  };
	  var xAxis = {
		 categories: ['Jan','Feb','Mar','Apr','May','Jun','Jul',
			'Aug','Sep','Oct','Nov','Dec'],
		 crosshair: true
	  };
	  var yAxis = {
		 min: 0,
		 title: {
			text: 'Income'         
		 }      
	  };
	  var tooltip = {
		 headerFormat: '<span style = "font-size:10px">{point.key}</span><table>',
		 pointFormat: '<tr><td style = "color:{series.color};padding:0">{series.name}: </td>' +
			'<td style = "padding:0"><b>{point.y:.1f}</b></td></tr>',
		 footerFormat: '</table>',
		 shared: true,
		 useHTML: true
	  };
	  var plotOptions = {
		 column: {
			pointPadding: 0.2,
			borderWidth: 0
		 }
	  };  
	  var credits = {
		 enabled: false
	  };
	  var series= [
		 {
			name: 'Total Revenue',
			data: [49, 71, 106, 129, 144, 176, 135,
			   148, 216, 194, 95, 54]
		 }, 
		 {
			name: 'Department Expense',
			data: [83, 78, 98, 93, 106, 84, 105, 104,
			   91, 83, 106, 92]
		 }
	  ];     
   
	  var json = {};   
	  json.chart = chart; 
	  json.title = title;   
	  json.subtitle = subtitle; 
	  json.tooltip = tooltip;
	  json.xAxis = xAxis;
	  json.yAxis = yAxis;  
	  json.series = series;
	  json.plotOptions = plotOptions;  
	  json.credits = credits;
	  $('#bar_graph1').highcharts(json);

   });
</script>

<script type="text/javascript">
// $( function() {
//   $( ".select_menu1" ).selectmenu();
// });
/* recent communication box start*/
 $('input[name="date_range_box"]').daterangepicker({
	  autoUpdateInput: false,
	  autoApply: true,
	  showDropdowns: true,
	}, function(start_date, end_date) {
	  $('input[name="date_range_box"]').val(start_date.format('DD-MM-YYYY')+' - '+end_date.format('DD-MM-YYYY'));
});

$('input[name="date_range_box"]').on('apply.daterangepicker', function(ev, picker) {
	var startDate = picker.startDate;
    var endDate = picker.endDate;
    startDate=startDate.format('DD-MM-YYYY');
    endDate=endDate.format('DD-MM-YYYY');
	$('#date_range_box').val(startDate+" - "+endDate);
	$('input[name="date_range_box"]').parent().addClass("date_active");	
	doAction(startDate+" - "+endDate,'dateRangeCommunicationAction','communication');
});
/* recent communication box end */
 
$('input[name="date_range"]').daterangepicker({
	  autoUpdateInput: false,
	  autoApply: true,
	  showDropdowns: true,
	}, function(start_date, end_date) {
	  $('input[name="date_range"]').val(start_date.format('DD-MM-YYYY')+' - '+end_date.format('DD-MM-YYYY'));
});

$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var startDate = picker.startDate;
    var endDate = picker.endDate;
    startDate=startDate.format('DD-MM-YYYY');
    endDate=endDate.format('DD-MM-YYYY');
	$('#date_range').val(startDate+" - "+endDate);
	$('input[name="date_range"]').parent().addClass("date_active");
	doAction(startDate+" - "+endDate,'dateRangeDashboardAction','sales');
});

function getRecentProjects(projectName){
	doAction(projectName,'projectNameDashboardAction','sales');
	$("#RecentProjectsRefresh").load(location.href+" #RecentProjectsRefresh"); 
}
// function getProjectsCommunication(projectNo){
// 	doAction(projectNo,'projectNoCommunicationAction','communication');
// 	$("#RecentcommunicationRefresh").load(location.href+" #RecentcommunicationRefresh"); 
// }

function doAction(data,name,type){
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/SetDataToSession111",
	    data:  { 
	    	data : data,
	    	name : name
	    },
	    success: function (response) {
		    if(type=="sales"){
		    	$("#RecentProjectsRefresh").load(location.href+" #RecentProjectsRefresh");
		    }else if(type=="communication"){
		    	$("#RecentcommunicationRefresh").load(location.href+" #RecentcommunicationRefresh");
		    }else{
		    	window.location=type;
		    }
        },
	});
}
function clearSession(data,type){
	   $.ajax({
		    type: "POST",
		    url: "<%=request.getContextPath()%>/ClearSessionData111",
		    data:  { 		    	
		    	data : data
		    },
		    success: function (response) {  
		    	if(type=="date"){
			    	$('input[name="date_range"]').val('');
			    	$('input[name="date_range"]').parent().removeClass("date_active");
			    	$("#RecentProjectsRefresh").load(location.href+" #RecentProjectsRefresh"); 
		    	}else if(type=="dateCommunication"){
			    	$('input[name="date_range_box"]').val('');
			    	$('input[name="date_range_box"]').parent().removeClass("date_active");
			    	$("#RecentcommunicationRefresh").load(location.href+" #RecentcommunicationRefresh"); 
		    	}
	        },
		});
}
<%-- $( document ).ready(function() { 	
	   var dateRangeDoAction="<%=dateRangeDashboardAction%>";
	   var project_Name="<%=projectNameDashboardAction%>";
	   var project_No="<%=projectNoCommunicationAction%>";
	   
	   if(dateRangeDoAction!="NA"){
		   $('input[name="date_range"]').val(dateRangeDoAction);
	   	   $('#SalesDateRangeId').addClass('date_active');
	   }
	   if(project_Name!="NA"){
		   $('#Project_Name').val(project_Name);
	   }
	   if(project_No!="NA"){
		   $('#Communication_Project_name').val(project_No);
	   }
	}); --%>
</script>
<script type="text/javascript">
var pp1=0;
function mostlySoldProductType(role,uaid,teamKey){
if(uaid!=""&&pp1==1){role="NA";}pp1=1;
var dataPointsVal=[];	
	$.ajax({
		type : "POST",
		url : "GetSalesOverview111",
		dataType : "HTML",
		data : {role:role,uaid:uaid,teamKey:teamKey},
		success : function(response){	
			if(Object.keys(response).length!=0){
				response = JSON.parse(response);
				dataPointsVal =JSON.stringify(response);
// 				alert(dataPointsVal);
		}}
	});	
	setTimeout(function(){
var chart = new CanvasJS.Chart("columnchartContainer1",
	    {
	      title:{
	        text: "Product Category Wise Sales",    
	      },
	      axisY: {
	        title: "Sale"
	      },
	      legend: {
	        verticalAlign: "bottom",
	        horizontalAlign: "center"
	      },
	      theme: "theme2",
	      data: [

	      {        
	        type: "column",  
	        showInLegend: false, 
	        legendMarkerColor: "lightgray",
	        legendText: "",
	        dataPoints: JSON.parse(dataPointsVal)
	      },   
	      ]
	    });

	    chart.render();
	}, 1500);
}	
function callDeliveryModule(){
	var role="<%=userroll%>";
	var uaid="<%=loginuaid%>";
	var teamRef="<%=teamKey%>";
	getSalesStatus(role,uaid,teamRef);
	getRecentLiveProjects(null);
}
function callSalesModule(){
	var role="<%=userroll%>";
	var uaid="<%=loginuaid%>";
	var teamRef="<%=teamKey%>";
	getProjectStatus(role,uaid,teamRef);
}

var pp=0;
function upcomingDeadline(role,uaid,teamKey){
	if(uaid!=""&&pp==1){role="NA";}pp=1;
	$(".upcomingDeadline").remove();
	$.ajax({
		type : "POST",
		url : "GetUpcomingDeadline111",
		dataType : "HTML",
		data : {role:role,uaid:uaid,teamKey:teamKey
		},
		success : function(response){	
			if(Object.keys(response).length!=0){
				response = JSON.parse(response);
				var len = response.length;
				if(len>0){ 
				for(var i=0;i<len;i++){			
					var name = response[i]['name'];
					var user = response[i]['user'];
					var deliveryDate = response[i]['deliveryDate'];
					$(''+
					'<tr class="upcomingDeadline">'+
					'<td>'+name+'</td>'+
					'<td>'+user+'</td>'+
					'<td>'+deliveryDate+'</td>'+
	               '</tr>'
	               ).insertBefore("#AppendUpcomingDeadline");
			}}	
		}else{
			$('<tr><td class="text-center noDataFound text-danger upcomingDeadline mb-10 mt-10">No Data Found</td></tr>').insertBefore("#AppendUpcomingDeadline");
		}}
	});	
}
var p1=0;
function recentActiveTask(role,uaid,teamKey){
	if(uaid!=""&&p1==1){role="NA";}p1=1;
	$(".recentActiveTask").remove();
	$.ajax({
		type : "POST",
		url : "GetRecentActiveTask111",
		dataType : "HTML",
		data : {role:role,uaid:uaid,teamKey:teamKey
		},
		success : function(response){	
			if(Object.keys(response).length!=0){
				response = JSON.parse(response);
				var len = response.length;
				if(len>0){ 
				for(var i=0;i<len;i++){			
					var name = response[i]['name'];
					var progress = response[i]['progress'];
					var userName = response[i]['userName'];
					var deliveryDate = response[i]['deliveryDate'];
					$(''+
						'<tr class="recentActiveTask">'+
						'<td>'+name+'</td>'+
						'<td>'+progress+'%</td>'+
						'<td>'+userName+'</td>'+
						'<td>'+deliveryDate+'</td>'+						
                        '</tr>'
	               ).insertBefore("#RecentActiveTask");
			}}else{
				$('<tr><td class="text-center noDataFound text-danger recentActiveTask mb-10 mt-10">No. Data Found</td></tr>').insertBefore("#RecentActiveTask");
			}
		}}
	});	
}
var p2=0;
function recentCommunication(role,uaid,teamKey){
	if(uaid!=""&&p2==1){role="NA";}p2=1;
	$(".recentCommunicationBox").remove();
	$.ajax({
		type : "POST",
		url : "RecentCommunication111",
		dataType : "HTML",
		data : {role:role,uaid:uaid,teamKey:teamKey},
		success : function(response){	
			if(Object.keys(response).length!=0){
				response = JSON.parse(response);
				var len = response.length;
				if(len>0){ 
				for(var i=0;i<len;i++){			
					var name = response[i]['name'];
					var date = response[i]['date'];
					var time = response[i]['time'];
					$(''+
						'<div class="clearfix pro_box recentCommunicationBox">'+
                        '<div class="clearfix icon_box">'+
                         '<i class="fa fa-user icon-circle" aria-hidden="true"></i>'+
                        '</div> '+
                        '<div class="clearfix pro_info">'+ 
                        '<h6>'+name+'</h6>'+
                        '<p>'+date+' & '+time+'</p>'+
                        '</div>'+
                        '</div>'
	               ).insertBefore("#RecentCommunicationBox");
			}}
		}else{
			$('<div class="text-center noDataFound text-danger recentCommunicationBox mb-10 mt-10">No Data Found</div>').insertBefore("#RecentCommunicationBox");
		}}
	});	
}
var p3=0;
function getSalesReport(role,uaid,teamKey){
	if(uaid!=""&&p3==1){role="NA";}p3=1;
	$.ajax({
		type : "GET",
		url : "GetSalesReport111",
		dataType : "HTML",
		data : {role:role,uaid:uaid,teamKey:teamKey},
		success : function(response){	
			if(Object.keys(response).length!=0){
			var x=response.split("#");
			$("#EstimateSale").html(x[0]);
			$("#TotalSales").html(x[1]);
			$("#SalesDueAmount").html(" "+x[2]);
			$("#ClientOfSeller").html(x[3]);
			  
		}}
	});	
}
var p4=0;
function getTopSales(role,uaid,teamKey){
	if(uaid!=""&&p4==1){role="NA";}p4=1;
	$(".topSaleAppend").remove();
	$.ajax({
		type : "GET",
		url : "GetTopSalesReport111",
		dataType : "HTML",
		data : {role:role,uaid:uaid,teamKey:teamKey},
		success : function(response){	
			if(Object.keys(response).length!=0){
				response = JSON.parse(response);
				var len = response.length;
				if(len>0){ 
				for(var i=0;i<len;i++){			
					var name = response[i]['name'];
					var count = response[i]['count'];
				$(''+
					'<div class="clearfix top_sale topSaleAppend">'+
	                '<span>'+name+'</span>'+
	                '<label>'+count+'</label>'+
	              '</div>' 
	               ).insertBefore("#TopSaleAppend");
			}}
		}else{
			$('<div class="text-center text-danger noDataFound topSaleAppend">No Data Found</div>').insertBefore("#TopSaleAppend");
		}}
	});	
}
var p9=0;
function recentProject(role,uaid,teamKey){
	if(uaid!=""&&p9==1){role="NA";}p9=1;
	$(".recentProject").remove();
	$.ajax({
		type : "GET",
		url : "RecentProject111",
		dataType : "HTML",
		data : {role:role,uaid:uaid,teamKey:teamKey},
		success : function(response){	
			if(Object.keys(response).length!=0){
				response = JSON.parse(response);
				var len = response.length;
				if(len>0){ 
				for(var i=0;i<len;i++){			
					var date = response[i]['date'];
					var projectNo = response[i]['projectNo'];
					var projectName = response[i]['projectName'];
					var client = response[i]['client'];
					var progress = response[i]['progress'];
					var status = response[i]['status'];
					var team = response[i]['team'];
					var color="colRed";
					if(status=="Active")color="colGreen";
					$(''+
					  '<tr class="recentProject">'+
                      '<td>'+date+'</td>'+
                      '<td>'+projectNo+'</td>'+
                      '<td>'+projectName+'</td>'+
                      '<td>'+client+'</td>'+
                      '<td>'+progress+'&nbsp;%</td>'+
                      '<td class="news-border '+color+'">'+status+'</td>'+
                      '<td>'+team+'</td>'                      
	               ).insertBefore("#RecentProjectAppend");
			}}
		}else{
			$('<div class="text-center noDataFound text-danger recentProject mb-10 mt-10">No Data Found</div>').insertBefore("#RecentProjectAppend");
		}}
	});	
}
var p8=0;
function recentSalesCommunication(role,uaid,teamKey){
	if(uaid!=""&&p8==1){role="NA";}p8=1;
	$(".recentSaleCommunicationBox").remove();
	$.ajax({
		type : "GET",
		url : "RecentSalesCommunication111",
		dataType : "HTML",
		data : {role:role,uaid:uaid,teamKey:teamKey},
		success : function(response){	
			if(Object.keys(response).length!=0){
				response = JSON.parse(response);
				var len = response.length;
				if(len>0){ 
				for(var i=0;i<len;i++){
					var key = response[i]['key'];
					var name = response[i]['name'];
					var projectNo = response[i]['projectNo'];
					var URL="<%=request.getContextPath()%>/assignmytask-"+key+".html";
					$(''+
						'<div class="clearfix pro_box pointers recentSaleCommunicationBox" onclick="doAction(\'open\',\'dashboardCommunication\',\''+URL+'\')">'+
	                    '<div class="clearfix icon_box">'+
	                     '<i class="far fa-comment-dots icon-circle" aria-hidden="true"></i>'+
	                    '</div>'+
	                    '<div class="clearfix pro_info">'+ 
	                    '<h6>'+projectNo+'</h6>'+
	                    '<p>'+name+'</p>'+
	                    '</div>'+
	                   '</div>'
	               ).insertBefore("#ProjectCommunication");
			}}
		}else{
			$('<div class="text-center noDataFound text-danger recentSaleCommunicationBox mb-10 mt-10">No Data Found</div>').insertBefore("#ProjectCommunication");
		}}
	});	
}
var sales99=0;
var del99=0; 
function showModule(hideId,showId){
	$("#"+hideId).slideUp('slow');
	$("#"+showId).slideDown('slow');
	if(showId=="DeliveryReportModule"&&del99==0){
		callDeliveryModule();
		del99=1;
	}else if(showId=="SalesReportModule"&&sales99==0){
		callSalesModule();
		sales99=1;
	}
}
$(document).ready(function(){
	var role1="<%=userroll%>";
	var uaid1="<%=loginuaid%>";
	var teamRef1="<%=teamKey%>";
	var department="<%=department%>";
	console.log("department=="+department)
	if(department=="Delivery"){
		$("#DeliveryReportModule").show();
		getSalesStatus(role1,uaid1,teamRef1);
		getRecentLiveProjects(null);
	}else if(department=="Sales"){
		$("#SalesReportModule").show();
		getProjectStatus(role1,uaid1,teamRef1);
	}
	
});
function getRecentLiveProjects(uaid){
	var role="<%=userroll%>";
	var teamKey="<%=teamKey%>";
	if(uaid==null)uaid=$("#select_menu").val();
	$.ajax({
		type : "GET",
		url : "GetRecentActiveProjects111",
		dataType : "HTML",
		data : {				
			role : role,
			teamKey : teamKey,
			uaid : uaid
		},
		success : function(response){		
			$("#recentActiveLiveProject  tbody").empty();	
		    $("#recentActiveLiveProject  tbody").append(response);
		}
	});
}
<%-- <% --%>
// if(recentDeliveryProjects!=null&&recentDeliveryProjects.length>0){
// 	for(int i=0;i<recentDeliveryProjects.length;i++){
// 	  String deliveryData[]=TaskMaster_ACT.getProjectsDeliveryDate(recentDeliveryProjects[i][2], token, today);
<%-- %> --%>
// <tr>
<%-- <td><%=recentDeliveryProjects[i][0] %></td> --%>
<%-- <td><%=recentDeliveryProjects[i][1] %></td> --%>
<%-- <td><%=deliveryData[0] %> <%=deliveryData[1] %></td> --%>
// </tr>
<%-- <%}}else{ %> --%>
// <tr><td class="text-center text-danger noDataFound mb-10 mt-10">No Data Found !!</td></tr>
<%-- <%} %> --%>
</script>
<%}else{ %>
<div class="wrap">
	<div id="content" class="dashboard_page clearfix">	    
       <div class="main-content text-center top_menu">
			<h1>The Document Department's Dashboard is pending......</h1>
	   </div>
	</div>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>
<%} %>
</body>
</html>