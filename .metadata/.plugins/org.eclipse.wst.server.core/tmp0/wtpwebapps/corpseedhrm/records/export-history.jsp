<%@page import="admin.records.Record_ACT"%>
<%@page import="java.util.Properties"%>
<%@page import="commons.DateUtil"%>
<%@page import="admin.enquiry.Enquiry_ACT"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/> 
	<title>Manage export history</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%if(!EH00){%><jsp:forward page="/login.html" /><%} %> 
	<%
	//pagination start
	int pageNo=1;
	int rows=10;
	String sort="";
	String sorting_order="sorting_desc";
	String order=request.getParameter("ord");
	if(order==null)order="desc";
	else if(order.equalsIgnoreCase("asc")){order="desc";sorting_order="sorting_desc";}
	else if(order.equalsIgnoreCase("desc")){order="asc";sorting_order="sorting_asc";}

	if(request.getParameter("page")!=null)pageNo=Integer.parseInt(request.getParameter("page"));
	if(request.getParameter("rows")!=null)rows=Integer.parseInt(request.getParameter("rows"));

	if(request.getParameter("sort")!=null)sort=request.getParameter("sort");
	Properties properties = new Properties();
	properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
	String domain=properties.getProperty("domain");
	String sort_url=domain+"export-history.html?page="+pageNo+"&rows="+rows;

	//pagination end
String token=(String)session.getAttribute("uavalidtokenno");
	
String ex_history_page=(String)session.getAttribute("ex_history_page");
if(ex_history_page==null||ex_history_page.length()<=0)ex_history_page="All";

String ex_hisDateRangeDoAction=(String)session.getAttribute("ex_hisDateRangeDoAction");
if(ex_hisDateRangeDoAction==null||ex_hisDateRangeDoAction.length()<=0)ex_hisDateRangeDoAction="NA";

String[][] records=Record_ACT.getAllExportedRecords(ex_history_page,token, ex_hisDateRangeDoAction,pageNo,rows,sort,order);
int totalHistory=Record_ACT.countAllExportedRecords(ex_history_page,token, ex_hisDateRangeDoAction);
%>

	<div id="content">
		<div class="main-content">
			<div class="container">
				
			<div class="clearfix"> 
			<form name="RefineSearchenqu" onsubmit="return false;">
			<div class="bg_wht clearfix mb10">  
			<div class="row">
			<div class="col-md-5 col-sm-5 col-xs-12"> 			
			<div class="col-md-5">
			<select class="filtermenu" onchange="doAction(this.value,'ex_history_page');location.reload();">
			<option value="All" <%if(ex_history_page.equalsIgnoreCase("All")){ %>selected<%} %>>All</option>
			<option value="Estimate" <%if(ex_history_page.equalsIgnoreCase("Estimate")){ %>selected<%} %>>Estimate</option>
			<option value="Sales" <%if(ex_history_page.equalsIgnoreCase("Sales")){ %>selected<%} %>>Sales</option>	
			</select>
			</div>
			</div>
			<div class="col-md-7 col-sm-7 col-xs-12">
			<div class="clearfix flex_box justify_end">		  
			<div class="item-bestsell col-md-4 col-sm-1 col-xs-12 has-clear"> 
			<p><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="FROM - TO" class="form-control text-center date_range pointers <%if(!ex_hisDateRangeDoAction.equalsIgnoreCase("NA")){ %>selected<%} %>" readonly="readonly"/>
			<span class="form-control-clear form-control-feedback" onclick="clearSession('ex_hisDateRangeDoAction');location.reload();"></span>
			</p>
			</div>
			</div>
			</div>
			</div>
			
			</div>
			</form>
			</div>
				
			<div class="row">
               	<div class="col-md-12 col-sm-12 col-xs-12">
               	<div class="table-responsive">
               	<%@ include file="../staticresources/includes/skelton.jsp" %>  
                    <table class="ctable">
						    <thead>
						        <tr>
						            <th class="sorting <%if(sort.equals("id")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','id','<%=order%>')">SN</th>
						            <th class="sorting <%if(sort.equals("date")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','date','<%=order%>')">Date - Time</th>
						            <th class="sorting <%if(sort.equals("from_to")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','from_to','<%=order%>')">FROM - TO</th>
						            <th>Exported by</th>
						        </tr>
						    </thead>
						    <tbody>
						    <%
						    int ssn=0;
						    int showing=0; 
						    int startRange=pageNo-2;
						    int endRange=pageNo+2;
						    int totalPages=1;
						    String pymtstatus="NA";
	                           String color="NA";
	                           if(records!=null&&records.length>0){
	                        	   ssn=rows*(pageNo-1);
	                        		  totalPages=(totalHistory/rows);
	                        		  if((totalHistory%rows)!=0)totalPages+=1;
	                        		  showing=ssn+1;
	                        		  if (totalPages > 1) {     	 
	                        			  if((endRange-2)==totalPages)startRange=pageNo-4;        
	                        	          if(startRange==pageNo)endRange=pageNo+4;
	                        	          if(startRange<1) {startRange=1;endRange=startRange+4;}
	                        	          if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
	                        	          if(startRange<1)startRange=1;
	                        	     }else{startRange=0;endRange=0;}
	                            for(int i=0;i<records.length;i++) {
	                            	String userName=Usermaster_ACT.getLoginUserName(records[i][7], token);
                           %>
						        <tr>
						            <td><%=showing+i %></td>
						            <td><%=records[i][5] %> : <%=records[i][6] %></td>
						            <td><%=records[i][4] %></td>
						            <td><%=userName %></td>				
						        </tr>
						     <%}}%>
                                 
						    </tbody>
						</table>
						</div>
						<div class="filtertable">
  <span>Showing <%=showing %> to <%=ssn+records.length %> of <%=totalHistory%> entries</span>
  <div class="pagination">
    <ul> <%if(pageNo>1){ %>
      <li class="page-item">	                     
      <a class="page-link text-primary" href="<%=request.getContextPath()%>/export-history.html?page=1&rows=<%=rows%>">First</a>
   </li><%} %>
    <li class="page-item">					      
      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/export-history.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
    </li>  
      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
	    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
	    <a class="page-link" href="<%=request.getContextPath()%>/export-history.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
	    </li>   
	  <%} %>
	   <li class="page-item">						      
	      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/export-history.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
	   </li><%if(pageNo<=(totalPages-1)){ %>
	   <li class="page-item">
	      <a class="page-link text-primary" href="<%=request.getContextPath()%>/export-history.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
	   </li><%} %>
	</ul>
	</div>
	<select class="select2" onchange="changeRows(this.value,'export-history.html?page=1','<%=domain%>')">
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
$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var data=$(this).val();
	doAction(data,"ex_hisDateRangeDoAction");
	location.reload();
});

$('input[name="date_range"]').daterangepicker({
	  autoUpdateInput: false,
	  autoApply: true,
	  showDropdowns: true,
	}, function(start_date, end_date) {
	  $('input[name="date_range"]').val(start_date.format('DD-MM-YYYY')+' - '+end_date.format('DD-MM-YYYY'));
	});
function doAction(data,name){
	showLoader();
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/SetDataToSession111",
	    data:  { 
	    	data : data,
	    	name : name
	    },
	    success: function (response) {
        },
		complete : function(data){
			hideLoader();
		}
	});
}
function clearSession(data){
	showLoader();
	   $.ajax({
		    type: "POST",
		    url: "<%=request.getContextPath()%>/ClearSessionData111",
		    data:  { 		    	
		    	data : data
		    },
		    success: function (response) {       	  
	        },
			complete : function(data){
				hideLoader();
			}
		});
}

$( document ).ready(function() {
   var ex_hisDateRangeDoAction="<%=ex_hisDateRangeDoAction%>";
   if(ex_hisDateRangeDoAction!="NA"){	  
	   $('input[name="date_range"]').val(ex_hisDateRangeDoAction);
   }
});
 
    </script>
</body>
</html>