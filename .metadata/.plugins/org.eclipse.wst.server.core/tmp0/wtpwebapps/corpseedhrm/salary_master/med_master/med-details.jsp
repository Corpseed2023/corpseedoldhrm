<%@page import="salary_master.SalaryMon_ACT"%>
<%@page import="commons.DateUtil"%>
<!DOCTYPE HTML>
<html lang="en-US">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Manage Medical History</title>
<%@ include file="../../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../../staticresources/includes/itswsheader.jsp" %>
<%
String addedby= (String)session.getAttribute("loginuID");
String emname= (String)session.getAttribute("medemname");
String month= (String)session.getAttribute("medmonth");
String from= (String)session.getAttribute("medfrom");
String to= (String)session.getAttribute("medto");
String token= (String)session.getAttribute("uavalidtokenno");

if(emname==null||emname.length()<=0)emname="NA";
if(month==null||month.length()<=0)month="NA";
if(from==null||from.length()<=0)from="NA";
if(to==null||to.length()<=0)to="NA";

String[][] medData=SalaryMon_ACT.getMedData(emname,month,token, from, to);
String[][] empdata=SalaryMon_ACT.getAllEmployee(token);
%>
<%if(!MMH00){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
    <div class="container">   
      <div class="bread-crumb">
        <div class="bd-breadcrumb bd-light">
        <a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
        <a>Manage Medical History</a>
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
                        <h2>Manage Medical History</h2>
                        </div>
                        <%if(MMH01){ %><a class="add_btn sub-btn1" href="<%=request.getContextPath() %>/Add-Med-details.html">Add Medical Details</a><%} %>
                        </div>
                        </div>
                        <form name="RefineSearchenqu" action="<%=request.getContextPath()%>/Med-details.html" method="Post">
                          <input type="hidden" name="pageName" id="pageName"  value="manageservice.jsp">
                            <input type="hidden" name="jsstype" id="jsstype">
                            <div class="home-search-form clearfix">
                            <div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-user"></i></span>
                              <select name="emname" id="emname" class="form-control" style="border: 1px solid #ccc;padding: 5px 5px !important;">
                                <option value="">Select Employee</option>
                                <%
                                for(int i=0;i<empdata.length;i++)
                                {
                                    if(!emname.equalsIgnoreCase("NA") && emname.equalsIgnoreCase(empdata[i][0])){ %>
                                    <option value="<%=empdata[i][0] %>" selected="selected"><%=empdata[i][0]%></option>
                                    <%}else{ %>
                                    <option value="<%=empdata[i][0] %>"><%=empdata[i][0] %></option>
                                <%}
                                }%>
                               </select>
                              </div>
                            </div>
                            <div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-calendar"></i></span>
                                <p><input type="text" autocomplete="off" name="month" id="month" <% if(!month.equalsIgnoreCase("NA")){ %>value="<%=month%>"<%} %> placeholder="Select Month" class="form-control readonlyAllow" readonly="readonly"/></p>
                                </div>
                            </div>
                            <div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-calendar"></i></span>
                                <p><input type="text" autocomplete="off" name="from" id="from"  <% if(!from.equalsIgnoreCase("NA")){ %>value="<%=from%>"<%} %> placeholder="From" class="form-control searchdate readonlyAllow" readonly="readonly"/></p>
                               </div>
                            </div>
                            <div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-calendar"></i></span>
                              <p><input type="text" autocomplete="off" name="to" id="to" <% if(!to.equalsIgnoreCase("NA")){ %>value="<%=to%>"<%} %> placeholder="To" class="form-control searchdate readonlyAllow" readonly="readonly"/></p>
                                </div>
                            </div>
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
                            <div class="box-width19 col-md-3 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Employee Name</p>
                                </div>
                            </div>
                            <div class="box-width7 col-xs-1 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Med Paid</p>
                                </div>
                            </div>
                            <div class="box-width12 col-xs-1 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Med Paid On</p>
                                </div>
                            </div>
                            <div class="box-width18 col-xs-1 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Med Paid for the Month of</p>
                                </div>
                            </div>
                            <div class="box-width18 col-md-3 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p>Action</p>
                                </div>
                            </div>
                           </div>
                          </div>
                        </div>
                        <%
                         for(int i=0;i<medData.length;i++){
                         %>
                        <div class="row">
                          <div class="col-md-12 col-sm-12 col-xs-12">
                           <div class="clearfix">
                            <div class="box-width25 col-xs-1 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><%=i+1%></p>
                                </div>
                            </div>
                            <div class="box-width19 col-md-3 col-xs-12 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><%=medData[i][1] %></p>
                                </div>
                            </div>
                            <div class="box-width7 col-xs-1 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border">Rs. <%=medData[i][2] %></p>
                                </div>
                            </div>
                            <div class="box-width12 col-xs-1 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><%=medData[i][3] %></p>
                                </div>
                            </div>
                            <div class="box-width18 col-xs-1 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><%=medData[i][4] %></p>
                                </div>
                            </div>
                            <div class="box-width18 col-md-3 col-xs-12 box-intro-background">
                                <div class="link-style12">
                                <p>
                                <%if(MMH02){ %><a href="javascript:void(0);" onclick="vieweditpage(<%=medData[i][0] %>,'view');"><i class="fa fa-eye" title="view"></i></a><%} %>
                                <%if(MMH03){ %><a href="javascript:void(0);" onclick="vieweditpage(<%=medData[i][0] %>,'edit');"><i class="fa fa-edit" title="edit"></i></a><%} %>
                                <%if(MMH04){ %><a href="javascript:void(0);" onclick="approve(<%=medData[i][0] %>)"><i class="fa fa-trash" title="delete"></i></a><%} %>                                    
                                </p>
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
<%@ include file="../../staticresources/includes/itswsfooter.jsp" %>
</div>
<%@ include file="../../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
function approve(id) {
if(confirm("Sure you want to Delete this Employee`s Medical Details ? "))
{
var xhttp; 
xhttp = new XMLHttpRequest();
xhttp.onreadystatechange = function() {
if (this.readyState == 4 && this.status == 200) {
location.reload();
}
};
xhttp.open("GET", "<%=request.getContextPath()%>/DeleteMed111?info="+id, true);
xhttp.send();
}
}
</script>
<script type="text/javascript">
$(function(){$("#month").datepicker({
	changeMonth:true,
    changeYear:true,
    dateFormat:"mm-yy"
    });
});

function RefineSearchenquiry() {
	document.RefineSearchenqu.jsstype.value="SSEqury";
	document.RefineSearchenqu.action="<%=request.getContextPath()%>/Med-details.html";
	document.RefineSearchenqu.submit();
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
        	if(page=="view") window.location = "<%=request.getContextPath()%>/ViewMedDetails.html";
        	else if(page=="edit") window.location = "<%=request.getContextPath()%>/EditMedDetails.html";
        },
	});
}
</script>
</body>
</html>