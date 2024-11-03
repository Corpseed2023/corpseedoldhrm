<%@page import="admin.enquiry.Enquiry_ACT"%>
<%@page import="commons.CommonHelper"%>
<%@page import="java.util.Properties"%>
<%@page import="commons.DateUtil"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/> 
	<title>My Task Details</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	<%
String addedby= (String)session.getAttribute("loginuID");
String loginuaid = (String)session.getAttribute("loginuaid");
String userRole= (String)session.getAttribute("userRole");
	
String myTaskDateRange = (String) session.getAttribute("myTaskDateRange");
if(myTaskDateRange==null||myTaskDateRange.length()<=0)myTaskDateRange="NA";

String myTaskDoAction = (String) session.getAttribute("myTaskDoAction");
if(myTaskDoAction==null||myTaskDoAction.length()<=0)myTaskDoAction="All";

String myTaskClientAction = (String) session.getAttribute("myTaskClientAction");
if(myTaskClientAction==null||myTaskClientAction.length()<=0)myTaskClientAction="NA";

String myTaskClientKeyAction = (String) session.getAttribute("myTaskClientKeyAction");
if(myTaskClientKeyAction==null||myTaskClientKeyAction.length()<=0)myTaskClientKeyAction="NA";

String myTaskContactAction=(String)session.getAttribute("myTaskContactAction");
if(myTaskContactAction==null||myTaskContactAction.length()<=0)myTaskContactAction="NA";

String myTaskServiceAction=(String)session.getAttribute("myTaskServiceAction");
if(myTaskServiceAction==null||myTaskServiceAction.length()<=0)myTaskServiceAction="NA";

String userroll= (String)session.getAttribute("emproleid");
String token=(String)session.getAttribute("uavalidtokenno");
String today=DateUtil.getCurrentDateIndianFormat1(); 
Properties properties = new Properties();
properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
String domain=properties.getProperty("domain");
String docBasePath=properties.getProperty("docBasePath");
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

String sort_url=domain+"mytask.html?page="+pageNo+"&rows="+rows;

//pagination end

String tasks[][]=TaskMaster_ACT.getAssignedTask(userRole,loginuaid,token,today,myTaskDoAction
		,myTaskClientKeyAction,myTaskDateRange,myTaskContactAction,pageNo,rows,sort,order,myTaskServiceAction);
int totalTask=TaskMaster_ACT.countAssignedTask(userRole,loginuaid,token,today,myTaskDoAction,
		myTaskClientKeyAction,myTaskDateRange,myTaskContactAction,myTaskServiceAction);

%>
<%if(!MT01){%><jsp:forward page="/login.html" /><%} %>
	<div id="content">		
		<div class="main-content">
			<div class="container-fluid">		
				
<div class="clearfix"> 
<form name="RefineSearchenqu" onsubmit="return false;">
<div class="bg_wht clearfix mb10" id="SearchOptions">  
<div class="row">
<div class="col-md-2 col-sm-2 col-xs-9"> 
<select class="filtermenu" onchange="doAction(this.value,'myTaskDoAction');location.reload();">
<option value="All" <%if(myTaskDoAction.equals("All")){ %>selected<%} %>>All Task</option>
<option value="New" <%if(myTaskDoAction.equals("New")){ %>selected<%} %>>New Task</option>
<option value="Open" <%if(myTaskDoAction.equals("Open")){ %>selected<%} %>>Open Task</option>
<option value="Pending" <%if(myTaskDoAction.equals("Pending")){ %>selected<%} %>>Pending Task</option>
<option value="On-Hold" <%if(myTaskDoAction.equals("On-Hold")){ %>selected<%} %>>On-hold Task</option>
<option value="Completed" <%if(myTaskDoAction.equals("Completed")){ %>selected<%} %>>Completed Task</option>
<option value="Expired" <%if(myTaskDoAction.equals("Expired")){ %>selected<%} %>>Expired Task</option>
</select>

</div>
<a href="javascript:void(0)" class="doticon"> <i class="fa fa-filter" aria-hidden="true"></i>Filter</a>
<div class="filtermmenu">
<div class="post" style="position:absolute;z-index:9">
  <div class="linee" style="margin-top: -1px;width:1350px;height:50px"></div>
</div>
<div class="col-md-10 col-sm-10 col-xs-12">
<div class="clearfix flex_box justify_end"> 
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<p><input type="search" name="serviceName" id="serviceName" <%if(!myTaskServiceAction.equalsIgnoreCase("NA")){ %>onsearch="clearSession('myTaskServiceAction');location.reload();" value="<%=myTaskServiceAction %>"<%} %> title="Search by Service Name !" placeholder="Service Name.." class="form-control"/>
</p>
</div> 
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<p><input type="search" name="clientName" id="ClientName" <%if(!myTaskClientAction.equalsIgnoreCase("NA")){ %>onsearch="clearSession('myTaskClientAction');clearSession('myTaskClientKeyAction');location.reload();" value="<%=myTaskClientAction %>" <%} %>title="Search by company !!" placeholder="Search by company !!" class="form-control"/>
<input type="hidden" id="ClientKeyId" <%if(!myTaskClientKeyAction.equalsIgnoreCase("NA")){ %>value="<%=myTaskClientKeyAction%>"<%} %>>
</p>
</div>
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<p><input type="search" name="contactName" id="ContactName" <%if(!myTaskContactAction.equalsIgnoreCase("NA")){ %>onsearch="clearSession('myTaskContactAction');location.reload();" value="<%=myTaskContactAction %>"<%} %> title="Search by Client Name !" placeholder="Client Name.." class="form-control"/>
</p>
</div>
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12 has-clear"> 
<p><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="FROM - TO" class="form-control text-center date_range pointers <%if(!myTaskDateRange.equalsIgnoreCase("NA")){ %>selected<%} %>" readonly="readonly"/>
<span class="form-control-clear form-control-feedback" onclick="clearSession('myTaskDateRange');location.reload();"></span>
</p>
</div>
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
   	<div class="table-responsive">  
     <table class="ctable">
    <thead>
	<tr class="tg" style="position:absolute;width:100%;display:inline-table">
    <th class="tg-cly1">  
        <div class="line"></div>
    </th>
    <th class="tg-cly1">
      <div class="line" ></div>
    </th>
    <th class="tg-cly1">
      <div class="line" ></div>
    </th>
    <th class="tg-cly1">
      <div class="line" ></div>
    </th>
    <th class="tg-cly1">
      <div class="line" ></div>
    </th>
    <th class="tg-cly1">
      <div class="line" ></div>
    </th>
  </tr>

						    
        <tr>
            <th><span class="hashico">#</span><input type="checkbox" class="pointers noDisplay" id="CheckAll"></th>            
            <th class="sorting <%if(sort.equals("status")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','status','<%=order%>')">Status</th>
            <th class="sorting <%if(sort.equals("product")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','product','<%=order%>')">Product</th>
            <th class="sorting <%if(sort.equals("task")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','task','<%=order%>')">Task Name</th>
            <th>Client</th>
            <th>Company</th>
            <th width="120" class="sorting <%if(sort.equals("assigned")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','assigned','<%=order%>')">Assigned On</th>
            <th>Task Duration</th>
            <th >Assigned To</th>
            <th class="sorting <%if(sort.equals("priority")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','priority','<%=order%>')">Priority</th>
        </tr>
    </thead>
    <tbody>
    <%
    int ssn=0;
    int showing=0;
    int startRange=pageNo-2;
    int endRange=pageNo+2;
    int totalPages=1;
    if(tasks!=null&&tasks.length>0){
    	
    	ssn=rows*(pageNo-1);
  	  totalPages=(totalTask/rows);
  	if((totalTask%rows)!=0)totalPages+=1;
  	  showing=ssn+1;
  	  if (totalPages > 1) {     	 
  		  if((endRange-2)==totalPages)startRange=pageNo-4;        
            if(startRange==pageNo)endRange=pageNo+4;
            if(startRange<1) {startRange=1;endRange=startRange+4;}
            if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
            if(startRange<1)startRange=1;
       }else{startRange=0;endRange=0;}
    	
		for(int i=0;i<tasks.length;i++){	
		String workStatusClass="";
		String workStatusIcon="";
		if(tasks[i][6].equalsIgnoreCase("New")){
			workStatusClass="iconstatusn";
			workStatusIcon="N";
		}else if(tasks[i][6].equalsIgnoreCase("Open")){
			workStatusClass="iconstatuso";
			workStatusIcon="O";
		}else if(tasks[i][6].equalsIgnoreCase("Pending")){
			workStatusClass="iconstatusp";
			workStatusIcon="P";
		}	else if(tasks[i][6].equalsIgnoreCase("Expired")){
			workStatusClass="iconstatuse";
			workStatusIcon="E";
		}else if(tasks[i][6].equalsIgnoreCase("On-Hold")){
			workStatusClass="iconstatush";
			workStatusIcon="H";
		}else if(tasks[i][6].equalsIgnoreCase("Completed")){
			workStatusClass="iconstatusc";
			workStatusIcon="C";
		}		
		String userName=Usermaster_ACT.getLoginUserName(tasks[i][2], token);
// 		boolean existFlag=TaskMaster_ACT.isDisperseExist(tasks[i][1], token); 
// 		double avlPrice=TaskMaster_ACT.getMainDispersedAmount(tasks[i][1], token);
// 		double orderAmt=TaskMaster_ACT.getSalesAmount(tasks[i][1], token);
// 		double percentage=Double.parseDouble(tasks[i][9]);
// 		double workPrice=(orderAmt*percentage)/100;
		
// 		if(avlPrice>=workPrice&&existFlag){ 
			String duration=TaskMaster_ACT.getMilestoneDuration(tasks[i][1],tasks[i][3],token);		
        %>
				     <tr class="tg" style="position:absolute;width:100%;display:inline-table">
				    <td class="tg-cly1">
				      <div class="line"></div>
				    </td>
				    <td class="tg-cly1">
				      <div class="line"></div>
				    </td>
				    <td class="tg-cly1">
				      <div class="line"></div>
				    </td>
				    <td class="tg-cly1">
				      <div class="line"></div>
				    </td>
				    <td class="tg-cly1">
				      <div class="line"></div>
				    </td>
				    <td class="tg-cly1">
				      <div class="line"></div>
				    </td>
				   
				  </tr>
			        <tr>
			            <td><input type="checkbox" name="checkbox" id="checkbox" class="checked"></td>
			            <td><span class="<%=workStatusClass%>"><%=workStatusIcon %></span></td>
			            <td><%=tasks[i][13] %></td>
			            <td><a class="img_view" href="<%=request.getContextPath()%>/edittask-<%=tasks[i][0] %>.html"><%=tasks[i][11]%> - <%=tasks[i][4] %></a></td>
			            <td><%=tasks[i][10] %></td>
			            <td><%=tasks[i][12] %></td>
			            <td><%=tasks[i][7] %></td>
			            <td><%=duration %></td>
			            <td><%=userName %></td>
			            <td><%=tasks[i][8] %></td>
			        </tr>
			     <%}}%>
                              
			    </tbody>
			</table> 
			</div>
			<div class="filtertable">
			  <span>Showing <%=showing %> to <%=ssn+tasks.length %> of <%=totalTask %> entries</span>
			  <div class="pagination">
			    <ul> <%if(pageNo>1){ %>
			      <li class="page-item">	                     
			      <a class="page-link text-primary" href="<%=request.getContextPath()%>/mytask.html?page=1&rows=<%=rows%>">First</a>
			   </li><%} %>
			    <li class="page-item">					      
			      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/mytask.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
			    </li>  
			      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
				    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
				    <a class="page-link" href="<%=request.getContextPath()%>/mytask.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
				    </li>   
				  <%} %>
				   <li class="page-item">						      
				      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/mytask.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
				   </li><%if(pageNo<=(totalPages-1)){ %>
				   <li class="page-item">
				      <a class="page-link text-primary" href="<%=request.getContextPath()%>/mytask.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
				   </li><%} %>
				</ul>
				</div>
				<select class="select2" onchange="changeRows(this.value,'mytask.html?page=1','<%=domain%>')">
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
<div class="modal fade" id="ExportData" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fas fa-file-export text-primary" style="margin-right: 10px;"> </span><span class="text-primary">Export</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <form action="return false" id="sendEmailInvoice">
       <div class="modal-body">       
         <div class="form-group">
            <label for="recipient-name" class="col-form-label">FROM :</label>
            <input type="text" autocomplete="off" class="form-control searchdate pointers" name="from-date" id="From-Date" placeholder="FROM-DATE" readonly="readonly">
          </div>        
        <div class="form-group">
            <label for="recipient-name" class="col-form-label">TO :</label>
            <input type="text" autocomplete="off" class="form-control searchdate pointers" name="to-date" id="To-Date" placeholder="TO-DATE" readonly="readonly">
          </div> 
          <div class="form-group">
            <label for="recipient-name" class="col-form-label">Columns :</label>
            <select class="form-control" name="exportColumn" id="ExportColumn" multiple="multiple">
            	<option value="maid" selected>Invoice</option>
            	<option value="mamilestonename" selected>Task Name</option>
            	<option value="masalesrefid" selected>Client Name</option>
            	<option value="maworkstarteddate" selected>Assign Date</option>
            	<option value="madeliverydate" selected>Delivery Date</option>
            	<option value="madelivereddate" selected>Delivered Date</option>
            	<option value="mateammemberid" selected>Assigned To</option>            	
            	<option value="maworkpercentage" selected>Progress %</option>
            	<option value="maworkpriority" selected>Priority</option>
            </select>            
          </div>
         <div class="form-group">
            <label for="recipient-name" class="col-form-label">Format :</label>
            <select class="form-control" name="file-formate" id="File-Formate">
            	<option value="csv">CSV</option>
            	<option value="xlsx" selected>XLS</option>
            </select>
          </div>   
          <div class="form-group noDisplay">
            <label for="recipient-name" class="col-form-label">Password Protected :</label>
            <input type="checkbox" name="protected" id="Protected" value="2">&nbsp;&nbsp;
            <input type="password" class="noDisplay form-control" name="filePassword" id="FilePassword" placeholder="Enter password.."> 
          </div>      
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-primary" onclick="return validateExport()">Submit</button>
      </div></form>
    </div>
  </div>
</div>
	<p id="end" style="display:none;"></p>
	</div> 
	<div class="noDisplay"><a href="" id="DownloadExportedLink" download><button id="DownloadExported">Download</button></a></div>
	<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>	
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>

	<script type="text/javascript">	
	
	$(function() {
		$("#clientname").autocomplete({
			source : function(request, response) {
				if(document.getElementById('clientname').value.trim().length>=1){
				showLoader();
				$.ajax({
					url : "getclientname.html",
					type : "POST",
					dataType : "JSON",
					data : {
						name : request.term,
						col :"cregname"
					},
					success : function(data) {
						response($.map(data, function(item) {
							return {  
								label : item.name,
								value : item.value,					
							};
						}));
					},
					error : function(error) {
						alert('error: ' + error.responseText);
					},
					complete : function() {
			            hideLoader();
			        }
				});}
			},
			change: function (event, ui) {
	            if(!ui.item){     
	            	document.getElementById('errorMsg').innerHTML = 'Select From List.';
	        		$('.alert-show').show().delay(1000).fadeOut();
	        		
	            	$("#clientname").val("");     	
	            }
	            else{
	            	$("#clientname").val(ui.item.value);
	            	
	            }
	        },
	        error : function(error){
				alert('error: ' + error.responseText);
			},
		});
	});
	$(function() {
		$("#serviceName").autocomplete({
			source : function(request, response) {
				if(document.getElementById('serviceName').value.trim().length>=1){
				showLoader();
				$.ajax({
					url : "get-client-details.html",
					type : "GET",
					dataType : "JSON",
					data : {
						name : request.term,
						field :"serviceName"
					},
					success : function(data) {
						response($.map(data, function(item) {
							return {  
								label : item.name,
								value : item.value,					
							};
						}));
					},
					error : function(error) {
						alert('error: ' + error.responseText);
					},
					complete : function() {
			            hideLoader();
			        }
				});}
			},
			select: function (event, ui) {
	            if(!ui.item){     
	            	document.getElementById('errorMsg').innerHTML = 'Select From List.';
	        		$('.alert-show').show().delay(1000).fadeOut();
	        		
	            	$("#serviceName").val("");     	
	            }
	            else{
	            	doAction(ui.item.value,'myTaskServiceAction');
	            	location.reload();
	            }
	        },
	        error : function(error){
				alert('error: ' + error.responseText);
			},
		});
	});
	</script>

<script type="text/javascript">
$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var data=$(this).val();
	doAction(data,"myTaskDateRange");
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
      complete : function() {
          hideLoader();
      }
	});
}
function clearSession(data){
	if(data!=null){
	   showLoader();
		$.ajax({
		    type: "POST",
		    url: "<%=request.getContextPath()%>/ClearSessionData111",
		    data:  { 		    	
		    	data : data
		    },
		    success: function (response) {       	  
	        },
	        complete : function() {
	            hideLoader();
	        }
		});
	}
}
$( document ).ready(function() {
	   var dateRangeDoAction="<%=myTaskDateRange%>";
	   if(dateRangeDoAction!="NA"){	  
		   $('input[name="date_range"]').val(dateRangeDoAction);
	   }
	});
</script>
<script type="text/javascript">

$('.close_box').on( "click", function(e) { 
	$('.fixed_right_box').removeClass('active');
	$('.addnew').show();	
	});
</script>	
<script type="text/javascript">
$(document).ready(function() {
$('#multiple_item').select2();
});
</script>
<script type="text/javascript">
$(function() {
	$("#ClientName").autocomplete({
		source : function(request, response) {			
			if(document.getElementById('ClientName').value.trim().length>=1){
			showLoader();
			$.ajax({
				url : "get-client-details.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					"field" : "mytaskClientName"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value,
							clientKey : item.clientKey
						};
					}));
				},
				error : function(error) {
					alert('error: ' + error.responseText);
				},
				complete : function() {
		            hideLoader();
		        }
			});}
		},
		select: function (event, ui) {
			if(!ui.item){   
            	
            }
            else{
            	doAction(ui.item.value,'myTaskClientAction');
            	doAction(ui.item.clientKey,'myTaskClientKeyAction');
            	location.reload();
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

$("#Protected").click(function(){
	 if ($("#Protected").is(":checked")){
		 $("#FilePassword").val("");
		 $("#FilePassword").show();		 
 }else{
	 $("#FilePassword").hide();
	 $("#FilePassword").val("NA");    	 
 }
});
$(function(){$(".searchdate").datepicker({changeMonth:true,changeYear:true,dateFormat:'yy-mm-dd'});});
$(document).ready(function(){
	$('#ExportColumn').select2({
		  placeholder: 'Select columns..',
		  allowClear: true,
		  dropdownParent: $("#ExportData")
		});
});

function validateExport(){
	var from=$("#From-Date").val();
	var to=$("#To-Date").val();
	var columns=$("#ExportColumn").val();
	var formate=$("#File-Formate").val();	
	var filePassword=$("#FilePassword").val();
		
	if(from==null||from==""){
		document.getElementById('errorMsg').innerHTML ='Select from-date !!';					
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(to==null||to==""){
		document.getElementById('errorMsg').innerHTML ='Select to-date !!';					
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(columns==null||columns==""){
		document.getElementById('errorMsg').innerHTML ='Select columns for export !!';					
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(formate==null||formate==""){
		document.getElementById('errorMsg').innerHTML ='Choose formate option !!';					
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if ($("#Protected").is(":checked")){
		if(filePassword==null||filePassword==""){
			document.getElementById('errorMsg').innerHTML ='Please enter export file password !!';					
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		$("#Protected").val("1")
	}else{
		$("#Protected").val("2")
		$("#FilePassword").val("NA");
	}
	var baseName="<%=docBasePath%>";
	columns+="";
	showLoader();
	$.ajax({
		type : "POST",
		url : "ExportData111",
		dataType : "HTML",
		data : {				
			from : from,
			to : to,
			columns : columns,
			formate : formate,
			filePassword : filePassword,
			type : "mytask"
		},
		success : function(response){
			$("#ExportData").modal("hide");
			if(response=="Fail"){
				document.getElementById('errorMsg').innerHTML ='No. Data Found !!';					
				$('.alert-show').show().delay(4000).fadeOut();
			}else{ 
				setTimeout(() => {
					$("#DownloadExportedLink").attr("href", baseName+response);
					$("#DownloadExported").click();
				}, 500);
			}
		},
		complete : function(msg) {
            hideLoader();
        }
	});	
	
}
$(function() {
	$("#ContactName").autocomplete({
		source : function(request, response) {			
			if(document.getElementById('ContactName').value.trim().length>=1)
			$.ajax({
				url : "get-client-details.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					"field" : "taskcontactname"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							value : item.value,	
							key :	item.key,
						};
					}));
				},
				error : function(error) {
					alert('error: ' + error.responseText);
				}
			});
		},
		select: function (event, ui) {
			if(!ui.item){   
            	
            }
            else{
            	doAction(ui.item.value,'myTaskContactAction');
            	location.reload();
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});
</script>
</body>
</html>