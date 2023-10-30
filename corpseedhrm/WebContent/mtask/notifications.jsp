<%@page import="java.util.Properties"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/> 
	<title>All notifications</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	
	<%
	String token= (String)session.getAttribute("uavalidtokenno");
	String loginuaid= (String)session.getAttribute("loginuaid");
	
	//pagination start
	int pageNo=1;
	int rows=10;
	
	if(request.getParameter("page")!=null)pageNo=Integer.parseInt(request.getParameter("page"));
	if(request.getParameter("rows")!=null)rows=Integer.parseInt(request.getParameter("rows"));

	Properties properties = new Properties();
	properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
	String domain=properties.getProperty("domain");
	String sort_url=domain+"notifications.html?page="+pageNo+"&rows="+rows;

	//pagination end

	
	String notificationTaskDateRange = (String) session.getAttribute("notificationTaskDateRange");
	if(notificationTaskDateRange==null||notificationTaskDateRange.length()<=0)notificationTaskDateRange="NA";
	
	%>
	<div id="content">		
		<div class="main-content">
			<div class="container">
			<div class="clearfix"> 
				<form name="RefineSearchenqu" onsubmit="return false;">
				<div class="bg_wht clearfix mb10" id="SearchOptions">  
				<div class="row">
				
				<div class="col-md-12 col-sm-12 col-xs-12">
				<div class="clearfix flex_box justify_end">				
				<div class="item-bestsell col-md-3 col-sm-3 col-xs-12 has-clear"> 
				<p><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="FROM - TO" class="form-control text-center date_range pointers <%if(!notificationTaskDateRange.equalsIgnoreCase("NA")){ %>selected<%} %>" readonly="readonly"/>
				<span class="form-control-clear form-control-feedback" onclick="clearSession('notificationTaskDateRange');location.reload();"></span>
				</p>
				</div>
				</div>
				</div>
				</div>
				</div>
				<!-- search option 2 -->
				<div class="row noDisplay" id="SearchOptions1">
				<div class="col-md-5 col-sm-5 col-xs-12"> 
				<div class="col-md-3">
				<button type="button" class="filtermenu dropbtn" style="width: 90px;" data-toggle="modal" data-target="#ExportData">&nbsp;Export</button>
				</div>
				</div>
				<div class="col-md-7 col-sm-7 col-xs-12 min-height50">
				<div class="clearfix flex_box justify_end">  
				
				</div>
				</div>
				</div>
				</form>
				</div>
				<div class="row">
				<div class="col-md-12 col-sm-12 col-xs-12">
		        <div class="notificationsec">
		        <ul>
			   <h2>Notification</h2> 
			   
				    <%
				    int ssn=0;
				    int showing=0; 
				    int startRange=pageNo-2;
				    int endRange=pageNo+2;
				    int totalPages=1;
				    String notification[][]=TaskMaster_ACT.getAllNotifications(token,loginuaid,notificationTaskDateRange,pageNo,rows); 
				    int totalNotifications=TaskMaster_ACT.countAllNotifications(token,loginuaid,notificationTaskDateRange);
                    if(notification!=null&&notification.length>0){
                    	 ssn=rows*(pageNo-1);
                   	  totalPages=(totalNotifications/rows);
                   	  if((totalNotifications%rows)!=0)totalPages+=1;
                   	  showing=ssn+1;
                   	  if (totalPages > 1) {     	 
                   		  if((endRange-2)==totalPages)startRange=pageNo-4;        
                             if(startRange==pageNo)endRange=pageNo+4;
                             if(startRange<1) {startRange=1;endRange=startRange+4;}
                             if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
                             if(startRange<1)startRange=1;
                        }else{startRange=0;endRange=0;}
                 	   for(int i=0;i<notification.length;i++){ %>
				        <li class="clearfix">           	
					        <a href="<%=request.getContextPath()%>/<%=notification[i][2] %>">
					        <div class="clearfix pro_box">
					            <div class="clearfix icon_box">
					             <i class="<%=notification[i][5] %> icon-circle" aria-hidden="true"></i>
					            </div> 
					            <div class="clearfix view_info"> 
					            <h6><%=notification[i][4] %></h6>
					            <div class="clearfix date_box1"><%=notification[i][1] %></div>
					            </div>
					         </div>
					          </a>        
					   </li>
				     <%}}%>				      
			   
			  </ul>
			  </div>
		<div class="filtertable">
  <span>Showing <%=showing %> to <%=ssn+notification.length %> of <%=totalNotifications %> entries</span>
  <div class="pagination">
    <ul> <%if(pageNo>1){ %>
      <li class="page-item">	                     
      <a class="page-link text-primary" href="<%=request.getContextPath()%>/notifications.html?page=1&rows=<%=rows%>">First</a>
   </li><%} %>
    <li class="page-item">					      
      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/notifications.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
    </li>  
      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
	    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
	    <a class="page-link" href="<%=request.getContextPath()%>/notifications.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
	    </li>   
	  <%} %>
	   <li class="page-item">						      
	      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/notifications.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
	   </li><%if(pageNo<=(totalPages-1)){ %>
	   <li class="page-item">
	      <a class="page-link text-primary" href="<%=request.getContextPath()%>/notifications.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
	   </li><%} %>
	</ul>
	</div>
	<select class="select2" onchange="changeRows(this.value,'notifications.html?page=1','<%=domain%>')">
	<option value="10" <%if(rows==10){ %>selected="selected"<%} %>>Rows 10</option>
	<option value="20" <%if(rows==20){ %>selected="selected"<%} %>>Rows 20</option>
	<option value="40" <%if(rows==40){ %>selected="selected"<%} %>>Rows 40</option>
	<option value="80" <%if(rows==80){ %>selected="selected"<%} %>>Rows 80</option>
	<option value="100" <%if(rows==100){ %>selected="selected"<%} %>>Rows 100</option>
	<option value="200" <%if(rows==200){ %>selected="selected"<%} %>>Rows 200</option>
	</select>
	</div>
		   
             
				
				</div>
				</div>
				
		</div>
	</div>
	<p id="end" style="display:none;"></p>
</div>

<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>	
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
function removeNotification(nkey,id){
	$.ajax({
	    type: "GET",
	    url: "<%=request.getContextPath()%>/RemoveNotification111",
	    data:  { 		    	
	    	nkey : nkey
	    },
	    success: function (response) {
	    	if(response=="pass"){
	    		$("#Row"+id).remove();
	    	}else{
	    		document.getElementById('errorMsg').innerHTML ='Something went wrong, Please try-again later !!.';				 
	 		    $('.alert-show').show().delay(4000).fadeOut();
	    	}
        },
	});
	
}
function doAction(data,name){
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/SetDataToSession111",
	    data:  { 
	    	data : data,
	    	name : name
	    },
	    success: function (response) {
        },
	});
}
$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var data=$(this).val();
	doAction(data,"notificationTaskDateRange");
	location.reload();
});
$('input[name="date_range"]').daterangepicker({
	  autoUpdateInput: false,
	  autoApply: true,
	  showDropdowns: true,
	}, function(start_date, end_date) {
	  $('input[name="date_range"]').val(start_date.format('DD-MM-YYYY')+' - '+end_date.format('DD-MM-YYYY'));
	});
$( document ).ready(function() {
	   var dateRangeDoAction="<%=notificationTaskDateRange%>";
	   if(dateRangeDoAction!="NA"){	  
		   $('input[name="date_range"]').val(dateRangeDoAction);
	   }
	});
function clearSession(data){
   $.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/ClearSessionData111",
	    data:  { 		    	
	    	data : data
	    },
	    success: function (response) {		    	
        },
	});
}
</script>
</body>
</html>