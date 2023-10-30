<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="daily_expenses.Daily_Expenses_ACT"%>
<!DOCTYPE HTML>
<html lang="en-US">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Manage Daily Expenses</title>
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
	
String token= (String)session.getAttribute("uavalidtokenno");
String date = (String) session.getAttribute("mdxdate");
String to = (String) session.getAttribute("mdxto");
String gst = (String) session.getAttribute("mdxgst");
String month = (String) session.getAttribute("mdxmonth");
if(date==null||date.length()<=0)date="NA";
if(to==null||to.length()<=0)to="NA";
if(gst==null||gst.length()<=0)gst="NA";
if(month==null||month.length()<=0)month="NA";

String[][] getExpensedata=Daily_Expenses_ACT.getallExpensesdata(date,month,today, token, to, gst);
%>
<%if(!DEX05){%><jsp:forward page="/login.html" /><%} %>
	<div id="content">
		<div class="main-content">
			<div class="container">
				<div class="row">
                	<div class="col-md-12 col-sm-12 col-xs-12">
                        <div class="menuDv partner-slider8">
                        <div class="row">
							<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="top_title text-center">
							<h2>Manage Daily Expense</h2>
							</div>
							<%if(DEX00){ %><a class="add_btn sub-btn1" href="<%=request.getContextPath() %>/Daily-Expense.html">Add Daily Expenses</a><%} %>
							</div>
							</div>
                        	
                       <form name="RefineSearchenqu" action="<%=request.getContextPath()%>/Manage-Daily-Expense.html" method="Post">
                              <input type="hidden" name="pageName" id="pageName"  value="manageservice.jsp">
								<input type="hidden" name="jsstype" id="jsstype">
								<div class="home-search-form clearfix">
                                <div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon fa fa-calendar"></i></span>
									<p><input type="text" name="month" id="month" <% if(!month.equalsIgnoreCase("NA")){ %>value="<%=month%>"<%} %> placeholder="Select Expense Month" class="form-control readonlyAllow" readonly="readonly"/></p>
								 </div>
                                </div>
                                <div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon  fa fa-calendar"></i></span>
									<p><input type="text" name="date" id="date" <% if(!date.equalsIgnoreCase("NA")){ %>value="<%=date%>"<%} %> placeholder="Select From Date" class="form-control readonlyAllow" readonly="readonly"/></p>
								 </div>
                                </div>
                                <div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon  fa fa-calendar"></i></span>									
									<p><input type="text" name="to" id="to" <% if(!to.equalsIgnoreCase("NA")){ %>value="<%=to%>"<%} %> placeholder="Select To Date" class="form-control readonlyAllow" readonly="readonly"/></p>
								 </div>
                                </div>
                                <div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon  fa fa-user"></i></span>
									<p><select name="gst" id="gst" class="form-control"><% if(!gst.equalsIgnoreCase("NA")){ %><option value="<%=gst%>"><%=gst %></option><% } %><option value="">Select GST Apply</option><option value="Yes">Yes</option><option value="No">No</option></select></p>
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
                                    <p class="news-border">Amount</p>
                                    </div>
                                </div>
                                <div class="box-width12 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Pay To</p>
                                    </div>
                                </div>
                                <div class="box-width9 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Expense Category</p>
                                    </div>
                                </div>
                               <div class="box-width12 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Payment Mode</p>
                                    </div>
                                </div>
                                <div class="box-width12 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Approved By</p>
                                    </div>
                                </div>
                                <div class="box-width12 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Paid On</p>
                                    </div>
                                </div>
                                <div class="box-width22 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">GST</p>
                                    </div>
                                </div>
                                <div class="box-width12 col-xs-3 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p>Action</p>
                                    </div>
                                </div>
                               </div>
                              </div>
                            </div>
                            <div id="target">
                            <%
                             for(int i=0;i<getExpensedata.length;i++){
                             %>
                            <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix">
                            	<div class="box-width25 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=getExpensedata[i][0]%></p>
                                    </div>
                                </div>
                                <div class="box-width12 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=getExpensedata[i][1]%></p>
                                    </div>
                                </div>
                                <div class="box-width12 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=getExpensedata[i][2]%></p>
                                    </div>
                                </div>
                                <div class="box-width9 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=getExpensedata[i][3]%></p>
                                    </div>
                                </div>
                                <div class="box-width12 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=getExpensedata[i][5]%></p>
                                    </div>
                                </div>
                                <div class="box-width12 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=getExpensedata[i][6]%></p>
                                    </div>
                                </div>
                                <div class="box-width12 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=getExpensedata[i][7]%></p>
                                    </div>
                                </div>
                                <div class="box-width22 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=getExpensedata[i][10]%></p>
                                    </div>
                                </div>
                                <div class="box-width12 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p title="">
                                    <%if(DEX01){ %><a class="fancybox" href="<%=request.getContextPath() %>/viewdailyexpenses-<%=getExpensedata[i][0]%>.html"><i class="fa fa-eye" title="View"></i></a><%} %>
                                    <%if(DEX02){ %><a href="<%=request.getContextPath() %>/editdailyexpenses-<%=getExpensedata[i][0]%>.html"><i class="fa fa-edit" title="Edit"></i></a><%} %>
                                    <%if(DEX03){ %><a class="quick-view" href="#manageexpense" onclick="document.getElementById('userid').innerHTML='<%=getExpensedata[i][0]%>'"><i class="fa fa-trash" title="Delete this expense."></i></a><%} %>
                                    </p>
                                    </div>
                                </div>
                               </div>
                              </div>
                           </div>
                        <%}%> 
</div></div>
</div>
</div>
<p id="end" style="display:none;"></p>
</div>
</div>
	<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>
</div>

<section class="clearfix" id="manageexpense" style="display: none;">
<div class="clearfix  text-center">
<div class="col-md-12 col-xs-12" id="userid" style="display: none;"></div>
<div class="col-md-12 col-xs-12">
<div class="box-intro1">
  <h2><span class="title">Delete this Expense?</span></h2>
</div>
</div>
<div class="col-md-12 col-xs-12 mb10">
<a class="sub-btn1" onclick="" id="cancelpopup">Cancel</a>

<a class="sub-btn1 mlft10" onclick="return deleteExpense(document.getElementById('userid').innerHTML);" title="Delete this Expense.">Delete</a>
</div>
</div>
</section>

	<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
	<script type="text/javascript">
	$(".fancybox").fancybox({
	    'width'             : '100%',
	    'height'            : '100%',
	    'autoScale'         : false,
	    'transitionIn'      : 'none',
	    'transitionOut'     : 'none',
	    'type'              : 'iframe',
	    'hideOnOverlayClick': false,
	    afterClose: function () {    
	    	parent.location.reload(true);
	    }
	});
	</script>
	<script type="text/javascript">
	function deleteExpense(id){
	    $.ajax({
	    	type: "POST",
	        url: '<%=request.getContextPath()%>/deleteExpense111',
	        datatype : "json",
	        data: {
	        	id:id,
	        	},
	        success: function(data){
	        	location.reload();
	        }
	    });
	}
	
	
	function RefineSearchenquiry() {
		document.RefineSearchenqu.jsstype.value="SSEqury";
		document.RefineSearchenqu.action="<%=request.getContextPath()%>/Manage-Daily-Expense.html";
		document.RefineSearchenqu.submit();
	}
	
	$(function() {
		$("#date").datepicker({
			changeMonth: true,
			changeYear: true,
			dateFormat: 'dd-mm-yy'
		});
	});
	$(function() {
		$("#to").datepicker({
			changeMonth: true,
			changeYear: true,
			dateFormat: 'dd-mm-yy'
		});
	});
	$(function() {
		$("#month").datepicker({
			changeMonth: true,
			changeYear: true,
			dateFormat: 'mm-yy'
		});
	});
	</script>
	<script type="text/javascript">
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
	        url: '<%=request.getContextPath()%>/getmoredailyexp',
	        datatype : "json",
	        data: {
	        	counter:counter,
	        	date:'<%=date%>',
	        	month:'<%=month%>',
	        	gst:'<%=gst%>',
	        	to:'<%=to%>',
	        	},
	        success: function(data){
	        	for(i=0;i<data[0].dailyexp.length;i++)
	            	html += '<div class="row"><div class="col-md-12 col-sm-12 col-xs-12"><div class="clearfix"><div class="box-width1 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border"> '+data[0].dailyexp[i][0]+'</p></div></div><div class="box-width5 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border"> '+data[0].dailyexp[i][1]+'</p></div></div><div class="box-width12 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].dailyexp[i][2]+'</p></div></div><div class="box-width5 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].dailyexp[i][3]+'</p></div></div><div class="box-width7 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border"> '+data[0].dailyexp[i][5]+'</p></div></div><div class="box-width7 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border"> '+data[0].dailyexp[i][6]+'</p></div></div><div class="box-width7 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border"> '+data[0].dailyexp[i][7]+'</p></div></div><div class="box-width1 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border"> '+data[0].dailyexp[i][10]+'</p></div></div><div class="box-width9 col-xs-1 box-intro-background"><div class="link-style12"><p title="'+data[0].dailyexp[i][4]+'">'+data[0].dailyexp[i][4]+'</p></div></div></div></div></div>';
	            if(html!='') $('#target').append(html);
	            else document.getElementById("end").innerHTML = "End";
	        }
	    });
	    
	    counter=counter+25;
	}
	</script>
<script type="text/javascript">	
	$('#cancelpopup').click(function(){
		  $.fancybox.close();
	});
</script>	
</body>
</html>