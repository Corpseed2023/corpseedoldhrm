<%@page import="java.util.Properties"%>
<%@page import="commons.CommonHelper"%>
<%@page import="org.docx4j.org.xhtmlrenderer.css.style.Length"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Manage Client's Account</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%
String token= (String)session.getAttribute("uavalidtokenno");
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
String azure_path=properties.getProperty("azure_path");
String sort_url=domain+"manageaccount.html?page="+pageNo+"&rows="+rows;

//pagination end
/* new */ 
String accountDateRangeAction=(String)session.getAttribute("accountDateRangeAction");
if(accountDateRangeAction==null||accountDateRangeAction.length()<=0)accountDateRangeAction="NA";

String accountSearchByClientName=(String)session.getAttribute("accountSearchByClientName");
if(accountSearchByClientName==null||accountSearchByClientName.length()<=0)accountSearchByClientName="NA";

String accountSearchByClientId=(String)session.getAttribute("accountSearchByClientId");
if(accountSearchByClientId==null||accountSearchByClientId.length()<=0)accountSearchByClientId="NA";

String[][] client=Clientmaster_ACT.getAllAccounts(accountSearchByClientId,accountDateRangeAction,token,pageNo,rows,sort,order);
int totalAccount=Clientmaster_ACT.countAllAccounts(accountSearchByClientId,accountDateRangeAction,token);
%>
<%if(!AC00){%><jsp:forward page="/login.html" /><%} %>
<div id="content">

<div class="main-content">
<div class="container">
<div class="row">
<form onsubmit="return false" method="post">
<div class="bg_wht clearfix mb10" id="SearchOptions">  
<div class="row">
<div class="col-md-7 col-sm-7 col-xs-6 mb10">
<div class="clearfix flex_box"> 
</div>
</div>
<a href="javascript:void(0)" class="doticon"> <i class="fa fa-filter" aria-hidden="true"></i>Filter</a>
<div class="filtermmenu">
<div class="post" style="position:absolute;z-index:9">
                        <div class="linee" style="margin-top: -1px;width:1350px;height:50px"></div>
                            </div>
<div class="col-md-5 col-sm-5 col-xs-12 mb10">
<div class="clearfix flex_box justify_end">  
<div class="item-bestsell col-md-6 col-sm-3 col-xs-12">
<p><input type="search" name="clientName" id="ClientName" <%if(!accountSearchByClientName.equalsIgnoreCase("NA")){ %>onsearch="clearSession('accountSearchByClientName');clearSession('accountSearchByClientId');location.reload()" value="<%=accountSearchByClientName %>"<%} %> title="Search by client's name !" placeholder="Search by client's name.." class="form-control" autocomplete="off">
<input type="hidden" id="ClientId" <%if(!accountSearchByClientId.equalsIgnoreCase("NA")){ %>value="<%=accountSearchByClientId %>"<%} %>>
</p>
</div>
<div class="item-bestsell col-md-6 col-sm-3 col-xs-12 has-clear"> 
<p><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="FROM - TO" class="form-control text-center date_range pointers <%if(!accountDateRangeAction.equalsIgnoreCase("NA")){ %>selected<%} %>" readonly="readonly">
<span class="form-control-clear form-control-feedback" onclick="clearSession('accountDateRangeAction');location.reload();"></span>
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
          <th class="sorting <%if(sort.equals("name")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','name','<%=order%>')">Name</th>
          <th class="sorting <%if(sort.equals("phone")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','phone','<%=order%>')">Phone</th>
          <th class="sorting <%if(sort.equals("email")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','email','<%=order%>')">Email</th>
          <th>Running Balance</th>          
      </tr>
  </thead>
  <tbody>
  <%
  int ssn=0;
  int showing=0;
  int startRange=pageNo-2;
  int endRange=pageNo+2;
  int totalPages=1;
  if(client!=null&&client.length>0){
	  ssn=rows*(pageNo-1);
	  totalPages=(totalAccount/rows);
	  if((totalAccount%rows)!=0)totalPages+=1;
	  showing=ssn+1;
	  if (totalPages > 1) {     	 
		  if((endRange-2)==totalPages)startRange=pageNo-4;        
          if(startRange==pageNo)endRange=pageNo+4;
          if(startRange<1) {startRange=1;endRange=startRange+4;}
          if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
          if(startRange<1)startRange=1;
     }else{startRange=0;endRange=0;}
	  for(int i=0;i<client.length;i++) {
	  	double runningbalance = Clientmaster_ACT.getRunningBalance(client[i][4]);
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
          <td><%=client[i][1] %></td>
          <td><%=client[i][2] %></td>
          <td><%=client[i][3] %></td>
          <td><%if(ACC01){ %><a href="javascript:void(0);" onclick="vieweditpage('<%=client[i][0] %>');" class="bg_none <%if(runningbalance<0) {%>text-danger<%} %>"><i class="fas fa-inr"></i>&nbsp;<%=CommonHelper.formatValue(runningbalance)%></a><%} %></td>
                   
      </tr>
   <%}}%>
                           
    </tbody>
</table> 
</div>
  <div class="filtertable">
  <span>Showing <%=showing %> to <%=ssn+client.length %> of <%=totalAccount %> entries</span>
  <div class="pagination">
    <ul> <%if(pageNo>1){ %>
      <li class="page-item">	                     
      <a class="page-link text-primary" href="<%=request.getContextPath()%>/manageaccount.html?page=1&rows=<%=rows%>">First</a>
   </li><%} %>
    <li class="page-item">					      
      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/manageaccount.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
    </li>  
      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
	    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
	    <a class="page-link" href="<%=request.getContextPath()%>/manageaccount.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
	    </li>   
	  <%} %>
	   <li class="page-item">						      
	      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/manageaccount.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
	   </li><%if(pageNo<=(totalPages-1)){ %>
	   <li class="page-item">
	      <a class="page-link text-primary" href="<%=request.getContextPath()%>/manageaccount.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
	   </li><%} %>
	</ul>
	</div>
	<select class="select2" onchange="changeRows(this.value,'manageaccount.html?page=1','<%=domain%>')">
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
            	<option value="c.cregname">Name</option>
            	<option value="c.cregemailid">Email</option>
            	<option value="c.cregmob">Mobile</option>
            	<option value="a.caid">Balance</option>
            </select>            
          </div>
         <div class="form-group">
            <label for="recipient-name" class="col-form-label">Formate :</label>
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
<div class="noDisplay"><a href="" id="DownloadExportedLink" download><button id="DownloadExported">Download</button></a></div>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
/* $(function() {
	$("#clientmobile").autocomplete({
		source : function(request, response) {
			if(document.getElementById('clientmobile').value.trim().length>=2)
			$.ajax({
				url : "getclientname.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					col: "cregmob"
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
				}
			});
		},
		change: function (event, ui) {
            if(!ui.item){     
            	document.getElementById('errorMsg').innerHTML = 'Select From List.';
        		$('.alert-show').show().delay(1000).fadeOut();
        		
            	$("#clientmobile").val("");     	
            }
            else{
            	$("#clientmobile").val(ui.item.value);
            	
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});
$(function() {
	$("#clientemail").autocomplete({
		source : function(request, response) {
			if(document.getElementById('clientemail').value.trim().length>=2)
			$.ajax({
				url : "getclientname.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					col: "cregemailid"
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
				}
			});
		},
		change: function (event, ui) {
            if(!ui.item){     
            	document.getElementById('errorMsg').innerHTML = 'Select From List.';
        		$('.alert-show').show().delay(1000).fadeOut();
        		
            	$("#clientemail").val("");     	
            }
            else{
            	$("#clientemail").val(ui.item.value);
            	
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
}); */
$(function() { 
	$("#ClientName").autocomplete({
		source : function(request, response) {
			if(document.getElementById('ClientName').value.trim().length>=1)
			$.ajax({
				url : "get-client-details.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field :"clientname"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value,
							cid : item.cid
						};
					}));
				},
				error : function(error) {
					alert('error: ' + error.responseText);
				}
			});
		},
		select: function (event, ui) {
            if(!ui.item){}
            else{
            	doAction(ui.item.value,'accountSearchByClientName');
            	doAction(ui.item.cid,'accountSearchByClientId');
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
function vieweditpage(id){
	showLoader();
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/vieweditpage",
	    data:  { 
	    	"uid" : id
	    },
	    success: function (response) {
        	window.location = "<%=request.getContextPath()%>/accountstatement.html";
        },
		complete : function(data){
			hideLoader();
		}
	});
}

$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var data=$(this).val();
	doAction(data,"accountDateRangeAction");
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
	   var dateRangeDoAction="<%=accountDateRangeAction%>";
	   if(dateRangeDoAction!="NA"){	  
		   $('input[name="date_range"]').val(dateRangeDoAction);
	   }
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
	var baseName="<%=azure_path%>";
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
			type : "Account"
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
		complete : function(data){
			hideLoader();
		}
	});	
	
}
</script>
</body>
</html>