<%@page import="employee_master.Employee_ACT"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Manage Employee's Account</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%
String empAccEmployeename = (String) session.getAttribute("empAccEmployeename");
if(empAccEmployeename==null||empAccEmployeename.length()<=0)empAccEmployeename="NA";

String accountByEmployeeId=(String)session.getAttribute("empAccEmployeeId");
if(accountByEmployeeId==null||accountByEmployeeId.length()<=0)accountByEmployeeId="NA";

String accountDateRangeAction=(String)session.getAttribute("empAccDateRangeAction");
if(accountDateRangeAction==null||accountDateRangeAction.length()<=0)accountDateRangeAction="NA";

long pageLimit=25;
String pageLimit1=(String)session.getAttribute("accountPageLimit");
if(pageLimit1!=null&&pageLimit1.length()>0)pageLimit=Long.parseLong(pageLimit1);


long pageStart=1;
String pageStart1=(String)session.getAttribute("accountPageStart");
if(pageStart1!=null&&pageStart1.length()>0)pageStart=Long.parseLong(pageStart1);

long pageEnd=25;
String pageEnd1=(String)session.getAttribute("accountPageEnd");
if(pageEnd1!=null&&pageEnd1.length()>0)pageEnd=Long.parseLong(pageEnd1);

long count=pageEnd/pageLimit;

String token= (String)session.getAttribute("uavalidtokenno");
String[][] employee=Employee_ACT.getAllAccounts(accountByEmployeeId, token,accountDateRangeAction,pageLimit,pageStart);
%>
<%if(!ACC02){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
<div class="main-content">
<div class="container">
<div class="row">
<form onsubmit="return false" method="post">
<div class="bg_wht clearfix mb10" id="SearchOptions">  
<div class="row">
<div class="col-md-7 col-sm-7 col-xs-12 mb10">
<div class="clearfix flex_box"> 
</div>
</div>
<div class="col-md-5 col-sm-5 col-xs-12 mb10">
<div class="clearfix flex_box justify_end">  
<div class="item-bestsell col-md-6 col-sm-3 col-xs-12">
<p><input type="search" name="employeeName" id="EmployeeName" <%if(!empAccEmployeename.equalsIgnoreCase("NA")){ %>onsearch="clearSession('empAccEmployeename');clearSession('empAccEmployeeId');location.reload()" value="<%=empAccEmployeename %>"<%} %> title="Search by employee's name !" placeholder="Search by employee's name.." class="form-control" autocomplete="off">
<input type="hidden" id="EmployeeId" <%if(!accountByEmployeeId.equalsIgnoreCase("NA")){ %>value="<%=accountByEmployeeId %>"<%} %>>
</p>
</div>
<div class="item-bestsell col-md-6 col-sm-3 col-xs-12 has-clear"> 
<p><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="FROM - TO" class="form-control text-center date_range pointers <%if(!accountDateRangeAction.equalsIgnoreCase("NA")){ %>selected<%} %>" readonly="readonly">
<span class="form-control-clear form-control-feedback" onclick="clearSession('empAccDateRangeAction');location.reload();"></span>
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
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="menuDv partner-slider8 clearfix">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="col-md-1 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border"><input type="checkbox" class="pointers noDisplay" id="CheckAll"></p>
</div>
</div>
<div class="col-md-3 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Name</p>
</div>
</div>
<div class="col-md-2 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Mobile No.</p>
</div>
</div>
<div class="col-md-3 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Email Id</p>
</div>
</div>
<div class="col-md-2 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Running Balance</p>
</div>
</div>
<div class="col-md-1 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p><span>Statement</span>
</p>
</div>
</div>
</div>
</div>
</div>
<div class="clearfix page-max"> 
<%
if(employee!=null&employee.length>0){
for(int i=0;i<employee.length;i++) {
	double runningbalance = Clientmaster_ACT.getRunningBalance(employee[i][0]);
%>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="col-md-1 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><input type="checkbox" name="checkbox" id="checkbox" class="checked"></p>
</div>
</div>
<div class="col-md-3 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=employee[i][1] %></p>
</div>
</div>
<div class="col-md-2 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=employee[i][2] %></p>
</div>
</div>
<div class="col-md-3 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=employee[i][3] %></p>
</div>
</div>
<div class="col-md-2 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" <%if(runningbalance<0) {%>style="color: red;"<%} %>><i class="fa fa-inr"></i> <%=runningbalance%></p>
</div>
</div>
<div class="col-md-1 col-xs-1 box-intro-background">
<div class="link-style12">
<p>
<%if(ACC01){ %><a href="javascript:void(0);" onclick=""><i class="fa fa-arrow-up" title="view account statement"></i></a><%} %>
</p>
</div>
</div>
</div>
</div>
</div>
<%}}else{%>
<div class="col-md-12 text-center text-danger noDataFound">No Data Found</div>
<%} %>
</div>
<div class="col-md-12 page-range"><div class="col-md-1 col-md-offset-9">
	<select name="pageShow" id="PageShow"<%if(employee.length>=25){ %> onchange="pageLimit(this.value)"<%} %>>
	    <option value="25" <%if(pageLimit==25){ %>selected<%} %>>25</option>
	    <option value="50" <%if(pageLimit==50){ %>selected<%} %>>50</option>
	    <option value="100" <%if(pageLimit==100){ %>selected<%} %>>100</option>
	    <option value="200" <%if(pageLimit==200){ %>selected<%} %>>200</option>
	</select></div>
    <div class="col-md-2 text-center">
    <i class="fas fa-chevron-left pointers" <%if(pageStart>1){ %>onclick="backwardPage()"<%} %>></i><span><%=pageStart %>-<%=pageEnd %></span><i class="fas fa-chevron-right pointers" <%if(employee!=null&&employee.length>=pageLimit){ %>onclick="forwardPage()"<%} %>></i>
    </div>
 </div>
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
            	<option value="em.emname">Name</option>
            	<option value="em.emmobile">Mobile</option>
            	<option value="em.ememail">Email</option>
            	<option value="maworkstarteddate">Balance</option>
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
<script>
$(function() { 
	$("#EmployeeName").autocomplete({
		source : function(request, response) {
			if(document.getElementById('EmployeeName').value.trim().length>=2)
			$.ajax({
				url : "get-employee.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field : "EmployeeAccount"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value,
							id : item.id
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
            	doAction(ui.item.value,'empAccEmployeename');
            	doAction(ui.item.id,'empAccEmployeeId');
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
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/vieweditpage",
	    data:  { 
	    	"uid" : id
	    },
	    success: function (response) {
        	window.location = "<%=request.getContextPath()%>/empaccountstatement.html";
        },
	});
}
$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var data=$(this).val();
	doAction(data,"empAccDateRangeAction");
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

$( document ).ready(function() {
	   var dateRangeDoAction="<%=accountDateRangeAction%>";
	   if(dateRangeDoAction!="NA"){	  
		   $('input[name="date_range"]').val(dateRangeDoAction);
	   }
	});
function pageLimit(data){
	  var start="<%=pageStart%>";
	  var limit="<%=pageLimit%>";
	  var end=Number(start)+Number(data);
	  if(Number(start)==1)end-=1;
	  doAction(data,'accountPageLimit');
	  doAction(end,'accountPageEnd');
	  location.reload(true);
}
function backwardPage(){
		 var count="<%=count-1%>";
		 var limit="<%=pageLimit%>";
		 var start=0;
		 if(Number(count)>=1){			 
			 start=(Number(count)-1)*Number(limit);
			 if(start==0)start=1;
			 var end=Number(count)*Number(limit);			 
		 }else if(count==0){
			 start=1;
			 end=limit;
		 }
		 doAction(start,'accountPageStart');
		 doAction(end,'accountPageEnd');
		 location.reload(true);
	 }
function forwardPage(){  
	 var count="<%=count+1%>";
	 var limit="<%=pageLimit%>";
	 var start=(Number(count)-1)*Number(limit);
	 var end=Number(count)*Number(limit);
	 doAction(start,'accountPageStart');
	 doAction(end,'accountPageEnd');
	 location.reload(true);
}
$(".checked").click(function(){
	 if ($(".checked").is(":checked")){
		 $("#CheckAll").show();
		 $("#SearchOptions").hide();
		 $("#SearchOptions1").show();
}else{
	 $("#CheckAll").hide();
	 $("#SearchOptions").show();
	 $("#SearchOptions1").hide();
}
	
	});
$("#CheckAll").click(function(){
$('.checked').prop('checked', this.checked);
if ($(".checked").is(":checked")){
		 $("#CheckAll").show();
		 $("#SearchOptions").hide();
		 $("#SearchOptions1").show();
}else{
	 $("#CheckAll").hide();
	 $("#SearchOptions").show();
	 $("#SearchOptions1").hide();
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
	var baseName="<%=request.getContextPath()%>/exported/";
	columns+="";
	/* showLoader();
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
			type : "Employee_Account"
		},
		success : function(response){hideLoader();
			$("#ExportData").modal("hide");
			if(response=="Fail"){
				document.getElementById('errorMsg').innerHTML ='No. Data Found !!';					
				$('.alert-show').show().delay(4000).fadeOut();
			}else{ 
				$("#DownloadExportedLink").attr("href", baseName+response);
				$("#DownloadExported").click();
				
			}
		}
	});	 */
	
}
</script>
</body>
</html>