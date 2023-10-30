<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="workscheduler.WorkSchedulerACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Work Scheduler</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>	
	<%
String addedby= (String)session.getAttribute("passid");
String[][] works = WorkSchedulerACT.getAllWorks(addedby);
SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
String today = sdf.format(new Date());
%>
<%if(!MMP01){%><jsp:forward page="/login.html" /><%} %>
	<div id="content">
		<div class="container">   
          <div class="bread-crumb">
            <div class="bd-breadcrumb bd-light">
            <a href="">Home</a>
            <a>Work Scheduler</a>
            </div>
          </div>
        </div>
		<div class="main-content">
			<div class="container">
				<div class="row">
					<div class="col-md-3 col-sm-3 col-xs-12">
						<div class="menuDv partner-slider8">
                        	<div class="box-intro">
                              <h2><span class="title">New Work</span></h2>
                            </div>
                            <div class="row">
                            <form action="<%=request.getContextPath()%>/saveworkschedule.html" method="post" id="workschedule">
                            <input type="hidden" name="addedby" id="addedby" value="<%=addedby%>" />
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix">
                            	<div class="col-md-12 col-sm-12 col-xs-12">
                            		<label>Today :</label>
                                    <p><input class="form-control" type="text" id="today" name="today" readonly value="<%=today%>" /></p>
                                </div>
                            	<div class="col-md-12 col-sm-12 col-xs-12">
                            		<label>Schedule For :</label>
                                    <p><input class="form-control" type="text" id="schedulefor" autocomplete="off" name="schedulefor" placeholder="Enter Schedule For Date" /></p>
                                </div>
                            	<div class="col-md-12 col-sm-12 col-xs-12">
                            		<label>Type :</label>
                                    <p><input class="form-control" type="text" id="type" name="type" placeholder="Enter Type of Work" /></p>
                                </div>
                            	<div class="col-md-12 col-sm-12 col-xs-12">
                            		<label>Task Name :</label>
                                    <p><input class="form-control" type="text" id="taskname" name="taskname" autocomplete="off" placeholder="Enter Task Name" /></p>
                                </div>
                            	<div class="col-md-12 col-sm-12 col-xs-12">
                            		<label>Remarks :</label>
                                    <p><textarea class="form-control" id="remarks" name="remarks" placeholder="Enter Remarks"></textarea></p>
                                    <p id="ErrorDiv"></p>
                                </div>
                            	<div class="col-md-12 col-sm-12 col-xs-12 item-product-info">
                                    <p><input type="submit" value="Save" class="bt-link bt-radius bt-loadmore" onclick="return validatework();" /></p>
                                </div>
                               </div>
                             </div>
                             </form>
                           </div>
                    	</div>
				</div>
                	<div class="col-md-9 col-sm-9 col-xs-12">
                        <div class="menuDv partner-slider8">
                        	<div class="box-intro">
                              <h2><span class="title">Work Scheduler</span></h2>
                            </div>
                            <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix">
                            	<div class="box-width25 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">SN.</p>
                                    </div>
                                </div>
                                <div class="box-width16 col-xs-2 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Date</p>
                                    </div>
                                </div>
                                  <div class="box-width7 col-xs-2 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Sch For</p>
                                    </div>
                                </div>
                                <div class="box-width14 col-md-2 col-xs-2 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Type</p>
                                    </div>
                                </div>
                                <div class="box-width14 col-md-2 col-xs-2 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Task Name</p>
                                    </div>
                                </div>
                                <div class="box-width15 col-xs-4 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Remarks</p>
                                    </div>
                                </div>
                                <div class="box-width16 col-xs-4 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p>FU</p>
                                    </div>
                                </div>
                               </div>
                              </div>
                            </div>
                            <%
                             for(int i=0;i<works.length;i++) {
                             %>
                            <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix">
                            	<div class="box-width25 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=works[i][0] %></p>
                                    </div>
                                </div>
                                <div class="box-width16 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=works[i][1] %></p>
                                    </div>
                                </div>
                                <div class="box-width7 col-xs-3 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=works[i][2] %></p>
                                    </div>
                                </div>
                                <div class="box-width14 col-md-2 col-xs-12 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=works[i][3] %></p>
                                    </div>
                                </div>
                                <div class="box-width14 col-md-2 col-xs-12 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=works[i][4] %></p>
                                    </div>
                                </div>
                                <div class="box-width15 col-xs-4 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border" style="overflow-y: auto;"><%=works[i][5] %></p>
                                    </div>
                                </div>
                                <div class="box-width16 col-xs-4 box-intro-background">
                                	<div class="link-style12">
                                    <p><a class="quick-view fancybox.ajax" href="<%=request.getContextPath()%>/workschedulerfollowup-<%=works[i][0] %>.html"><i class="fa fa-arrow-up"></i></a></p>
                                    </div>
                                </div>
                               </div>
                              </div>
                            </div>
                            <%}%>
					</div>
				</div>
			</div>
		</div>
	  </div>
	</div>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>	
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">$(function(){$("#schedulefor").datepicker({changeMonth: true,changeYear: true,dateFormat: 'dd-mm-yy',});});bkLib.onDomLoaded(function(){nicEditors.editors.push( new nicEditor().panelInstance( document.getElementById('remarks') ) );});function validatework(){if(document.getElementById("schedulefor").value==""){$('#schedulefor').css('border-color', 'red');return false;}else{$('#schedulefor').css('border-color', '#ccc');}if(document.getElementById("type").value==""){$('#type').css('border-color', 'red');return false;}else{$('#type').css('border-color', '#ccc');}if(document.getElementById("taskname").value==""){$('#taskname').css('border-color', 'red');return false;}else{$('#taskname').css('border-color', '#ccc');}var data=$('#workschedule').find('.nicEdit-main').text();if(data==""){document.getElementById("ErrorDiv").innerHTML="Enter Remarks!";document.getElementById("ErrorDiv").style.color="red";return false;}}</script>
</body>
</html>