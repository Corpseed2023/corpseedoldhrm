<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="attendance_master.Attendance_ACT"%>
<!DOCTYPE HTML>
<html lang="en-US">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Manage Attendance</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	<%
	DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	Calendar calobj = Calendar.getInstance();
	String today = df.format(calobj.getTime());	 
	today=today.substring(0,8);
	
String addedby= (String)session.getAttribute("loginuID");
String EmpID= (String)session.getAttribute("maEmpID");
String MonthDate= (String)session.getAttribute("maMonthDate");
String from= (String)session.getAttribute("mafrom");
String to= (String)session.getAttribute("mato");
String token=(String)session.getAttribute("uavalidtokenno");

Attendance_ACT.getCountAttendance(EmpID, MonthDate, from, to);
String[][] getAttendancedata=Attendance_ACT.getallenqcountersaledata(today, EmpID, MonthDate, token, from, to);
String[][] empdata=Attendance_ACT.getAllEmployee(token);


%>
	<%if(!ATT03){%><jsp:forward page="/login.html" /><%} %>
    
	<div id="content">		
		<div class="main-content">
			<div class="container">
				<div class="row">
                	<div class="col-md-12 col-sm-12 col-xs-12">
                        <div class="menuDv partner-slider8">
                        	<div class="row">
							<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="top_title text-center">
							<h2>Manage Attendance</h2>
							</div>
							<%if(ATT02){ %><a class="add_btn sub-btn1" href="<%=request.getContextPath() %>/Attendance.html">Add Attendance</a><%} %>
							</div>
							</div>
                        	
                            <form name="RefineSearchenqu" action="<%=request.getContextPath()%>/manage-attendance.html" method="Post">
                              <input type="hidden" name="pageName" id="pageName"  value="manageservice.jsp">
								<input type="hidden" name="jsstype" id="jsstype">
								<div class="home-search-form clearfix">
                                <div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="fa fa-users"></i></span>
                                  <select name="EmpID" id="EmpID" class="form-control" style="border: 1px solid #ccc;padding: 5px 5px !important;">
									<option value="">All Employees</option>
									<%
									for(int i=0;i<empdata.length;i++)
									{
										if(EmpID!=null && EmpID.equalsIgnoreCase(empdata[i][0])){ %>
										<option value="<%=empdata[i][0] %>" selected="selected"><%=empdata[i][0]%> - <%=empdata[i][1]%></option>
										<%}else{ %>
										<option value="<%=empdata[i][0] %>"><%=empdata[i][0] %> - <%=empdata[i][1]%></option>
									<%}
									}%>
								   </select>
                                  </div>
                                </div>
                                <div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="fa fa-calendar"></i></span>                                  
									<p><input type="text" autocomplete="off" name="MonthDate" id="MonthDate" <% if(MonthDate!=null&&MonthDate.length()>0){ %> value="<%=MonthDate%>"<%} %> placeholder="Select Month" class="form-control readonlyAllow" readonly="readonly"/></p>
									</div>
                                </div>
                                <div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                                  	<p><input type="text"autocomplete="off" name="from" id="from" <% if(from!=null&&from.length()>0){ %> value="<%=from%>"<%} %> placeholder="From" class="form-control readonlyAllow searchdate" readonly="readonly"/></p>
									</div>
                                </div>
                                <div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                                  	<p><input type="text"autocomplete="off" name="to" id="to" <% if(to!=null&&to.length()>0){ %> value="<%=to%>"<%} %> placeholder="To" class="form-control readonlyAllow searchdate" readonly="readonly"/></p>
								</div>
                                </div>
                                <div class="item-bestsell col-md-4 col-sm-4 col-xs-12"></div>
                                <div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
								<button class="btn-link-default bt-radius" type="submit" name="button" value="Search"><i class="fa fa-search" title="Search"></i></button>
								<button class="btn-link-default bt-radius" type="submit" name="button" value="Reset"><i class="fa fa-refresh" title="Reset"></i></button>
								</div>
                              </div>
                            </form>
                            <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix">
                            	<div class="box-width25 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">SN</p>
                                    </div>
                                </div>
                                <div class="box-width12 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Date</p>
                                    </div>
                                </div>
                                <div class="box-width4 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Employee ID</p>
                                    </div>
                                </div>
                                <div class="box-width19 col-xs-3 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Employee Name</p>
                                    </div>
                                </div>
                                <div class="box-width9 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Status</p>
                                    </div>
                                </div>
                                <div class="box-width5 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">In Time</p>
                                    </div>
                                </div>
                                <div class="box-width5 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="">Out Time</p>
                                    </div>
                                </div>
                               </div>
                              </div>
                            </div>
                            <div id="target">
                            <%
                             for(int i=0;i<getAttendancedata.length;i++){
                             %>
                            <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix">
                            	<div class="box-width25 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border" title="<%=getAttendancedata.length-i %>"><%=getAttendancedata.length-i %></p>
                                    </div>
                                </div>
                                <div class="box-width12 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border" title="<%=getAttendancedata[i][1] %>"><%=getAttendancedata[i][1] %></p>
                                    </div>
                                </div>
                                <div class="box-width4 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border" title="<%=getAttendancedata[i][2] %>"><%=getAttendancedata[i][2] %></p>
                                    </div>
                                </div>
                                <div class="box-width19 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border" title="<%=getAttendancedata[i][6] %>"><%=getAttendancedata[i][6] %></p>
                                    </div>
                                </div>
                                <div class="box-width9 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border" title="<%=getAttendancedata[i][3] %>"><%=getAttendancedata[i][3] %></p>
                                    </div>
                                </div>
                                <div class="box-width5 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border" title="<%=getAttendancedata[i][4] %>"><%=getAttendancedata[i][4] %></p>
                                    </div>
                                </div>
                                <div class="box-width5 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="" title="<%=getAttendancedata[i][5] %>"><%=getAttendancedata[i][5] %></p>
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
	<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
	</div>
	<p id="end" style="display:none;"></p>
	<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
	<script type="text/javascript">
	$(function(){
		$("#MonthDate").datepicker({
			changeMonth: true,
			changeYear: true,
			dateFormat: 'mm-yy'
		});
	});
var counter=25;
$(window).scroll(function () {
    if ($(window).scrollTop() == $(document).height() - $(window).height()) {
    	appendData();
    }
});
function appendData() {
    var html = '';
    if(document.getElementById("end").innerHTML=="End") return false;
    $.ajax({
    	type: "POST",
        url: '<%=request.getContextPath()%>/getmoreattendance',
        datatype : "json",
        data: {
        	counter:counter,
        	EmpID:'<%=EmpID%>',
        	MonthDate:'<%=MonthDate%>',
        	from:'<%=from%>',
        	to:'<%=to%>',
        	},
        success: function(data){
        	for(i=0;i<data[0].atte.length;i++)
            	html += '<div class="row"><div class="col-md-12 col-sm-12 col-xs-12"><div class="clearfix"><div class="box-width1 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].atte[i][0]+'</p></div></div><div class="box-width8 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].atte[i][1]+'</p></div></div><div class="box-width15 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].atte[i][2]+'</p></div></div><div class="box-width6 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].atte[i][6]+'</p></div></div><div class="box-width4 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].atte[i][3]+'</p></div></div><div class="box-width16 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].atte[i][4]+'</p></div></div><div class="box-width16 col-xs-1 box-intro-background"><div class="link-style12"><p>'+data[0].atte[i][5]+'</p></div></div></div></div></div>';
            if(html!='') $('#target').append(html);
            else document.getElementById("end").innerHTML = "End";
        }
    });
    counter=counter+25;
}
</script>
	<script type="text/javascript">
function RefineSearchenquiry() {
	document.RefineSearchenqu.jsstype.value="SSEqury";
	document.RefineSearchenqu.action="<%=request.getContextPath()%>/manage-attendance.html";
	document.RefineSearchenqu.submit();
}
function RefineSearchenquiry1() {
	document.RefineSearchenqu.jsstype.value="SSEqury1";
	document.RefineSearchenqu.action="<%=request.getContextPath()%>/manage-attendance.html";
	document.RefineSearchenqu.submit();
}
</script>
</div>
</body>
</html>