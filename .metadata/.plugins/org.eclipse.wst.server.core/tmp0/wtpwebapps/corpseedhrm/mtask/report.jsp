<%@page import="commons.CommonHelper"%>
<%@page import="java.util.Properties"%>
<%@page import="commons.DateUtil"%>
<%@page import="admin.enquiry.Enquiry_ACT"%>
<%@page import="admin.task.TaskMaster_ACT"%>
<%@page import="admin.seo.SeoOnPage_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Manage Report</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%if(!MTR1){%><jsp:forward page="/login.html" /><%} %>
<%
String token=(String)session.getAttribute("uavalidtokenno");
String loginuID=(String)session.getAttribute("loginuID");	
String userroll=(String)session.getAttribute("emproleid");
String loginuaid=(String)session.getAttribute("loginuaid");
String userRole=(String)session.getAttribute("userRole");
String today=DateUtil.getCurrentDateIndianFormat1();
String dateNow=DateUtil.getCurrentDateIndianReverseFormat();
String timeNow=DateUtil.getCurrentTime24Hours();

String reportprojectNo=(String)session.getAttribute("reportprojectNo");
if(reportprojectNo==null||reportprojectNo.length()<=0)reportprojectNo="NA";

String reportAssigneeUid=(String)session.getAttribute("reportAssigneeUid");
if(reportAssigneeUid==null||reportAssigneeUid.length()<=0)reportAssigneeUid="NA";

String reportAssigneeName=(String)session.getAttribute("reportAssigneeName");
if(reportAssigneeName==null||reportAssigneeName.length()<=0)reportAssigneeName="NA";

int approval=TaskMaster_ACT.getAllApproval(token);

//pagination start
int pageNo=1;
int rows=10;
String sort="";
String order=(String)session.getAttribute("rsortby_ord");
if(order==null)order="desc";

String sorting_order=(String)session.getAttribute("rsorting_order");
if(sorting_order==null)sorting_order="";

if(request.getParameter("page")!=null)pageNo=Integer.parseInt(request.getParameter("page"));
if(request.getParameter("rows")!=null)rows=Integer.parseInt(request.getParameter("rows"));

if(request.getParameter("sort")!=null)sort=request.getParameter("sort");
Properties properties = new Properties();
properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
String domain=properties.getProperty("domain");
String azure_path=properties.getProperty("azure_path");
String sort_url=domain+"report.html?page="+pageNo+"&rows="+rows;

//pagination end

%>

<div id="content">
<div class="main-content">
<div class="container-fluid">

<div class="clearfix"> 
<form name="RefineSearchenqu" onsubmit="return false" method="Post">
<div class="bg_wht clearfix mb10" id="SearchOptions">  
<div class="row">
<a href="javascript:void(0)" class="doticon"> <i class="fa fa-filter" aria-hidden="true"></i>Filter</a>
<div class="filtermmenu">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="post" style="position:absolute;z-index:9">
                        <div class="linee" style="margin-top: -1px;width:1350px;height:50px"></div>
                            </div>
<div class="clearfix flex_box">  
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<p><input type="search" autocomplete="off" name="projectNo" id="projectNo" <%if(!reportprojectNo.equalsIgnoreCase("NA")){ %>value="<%=reportprojectNo %>" onsearch="clearSession('reportprojectNo');location.reload();"<%} %> title="Search by project no. !" placeholder="Search by project no." class="form-control"/>
</p>
</div>
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<p><input type="search" autocomplete="off" name="assigneeName" id="assigneeName" <%if(!reportAssigneeUid.equalsIgnoreCase("NA")){ %>value="<%=reportAssigneeName %>" onsearch="clearSession('reportAssigneeUid');clearSession('reportAssigneeName');location.reload()"<%} %> title="Search by assignee name !" placeholder="Search by assignee name !" class="form-control"/>
<input type="hidden" id="assigneUid" <%if(!reportAssigneeUid.equalsIgnoreCase("NA")){ %>value="<%=reportAssigneeUid %>"<%} %>>
</p>
</div>
</div>
</div>
</div>
</div>
</div>
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
<%--            <th class="sorting <%if(sort.equals("id")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','id','<%=order%>','rsorting_order','rsortby_ord')">SN</th> --%>
           <th class="sorting <%if(sort.equals("project")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','project','<%=order%>','rsorting_order','rsortby_ord')">Project</th>
           <th class="sorting <%if(sort.equals("milestone")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','milestone','<%=order%>','rsorting_order','rsortby_ord')">Milestone</th>
           <th class="sorting <%if(sort.equals("assignee")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','assignee','<%=order%>','rsorting_order','rsortby_ord')">Assignee</th>
           <th>New</th>
           <th>Open</th>
           <th>Hold</th>
           <th>Pending</th>
           <th>Expired</th>
           <th>Milestone TAT</th>
           <th>Delivery TAT</th>
           <th>Progress</th>
       </tr>
   </thead>
   <tbody>
   <%
   int ssn=0;
   int showing=0;
   int startRange=pageNo-2;
   int endRange=pageNo+2;
   int totalPages=1;
     
   String[][] getAllTask=Enquiry_ACT.getAllTaskReport(token,reportprojectNo,reportAssigneeUid,pageNo,rows,sort,order);  
   int totalTask=Enquiry_ACT.countAllTaskReport(token,reportprojectNo,reportAssigneeUid); 
   if(getAllTask!=null&&getAllTask.length>0){
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
   for(int i=0;i<getAllTask.length;i++){
	   String deliveredTime="";
	   String deliveryDate="";
	   String milestoneData[]=TaskMaster_ACT.getMileStoneData(getAllTask[i][5], token);
	   String duration=TaskMaster_ACT.getMilestoneDuration(getAllTask[i][6],milestoneData[0],token);
	   
		if(!milestoneData[5].equalsIgnoreCase("NA")&&!milestoneData[5].equalsIgnoreCase("00-00-0000")&&!milestoneData[6].equalsIgnoreCase("NA")){
  	   
		   if(milestoneData[3]!=null&&!milestoneData[3].equalsIgnoreCase("NA")
				   &&milestoneData[4]!=null&&!milestoneData[4].equalsIgnoreCase("NA"))
			   deliveredTime=CommonHelper.getTime(milestoneData[5],milestoneData[6],milestoneData[3],milestoneData[4]);
		   else{		   
			   deliveredTime=CommonHelper.getTime(milestoneData[5],milestoneData[6],dateNow,timeNow);
		   }
		}else{
			deliveredTime=duration="NS";
		}
		boolean isPassed=CommonHelper.isDatePassed(milestoneData[1],milestoneData[2],dateNow,timeNow,milestoneData[3],milestoneData[4]);
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
       <tr id="row<%=getAllTask.length-i%>">       
           <td><input type="checkbox" id="checkbox" class="checked"></td>
           <td><%=getAllTask[i][1] %>/<%=getAllTask[i][0] %> : <%=getAllTask[i][2] %></td>
           <td><%=getAllTask[i][7] %></td>
           <td><%=getAllTask[i][9] %></td>
           <td><%if(!getAllTask[i][10].equalsIgnoreCase("0")){%><%=getAllTask[i][10] %>h <%}%><%=getAllTask[i][11] %>m</td>
           <td><%if(!getAllTask[i][12].equalsIgnoreCase("0")){%><%=getAllTask[i][12] %>h <%}%><%=getAllTask[i][13] %>m</td>
           <td><%if(!getAllTask[i][14].equalsIgnoreCase("0")){%><%=getAllTask[i][14] %>h <%}%><%=getAllTask[i][15] %>m</td>
           <td><%if(!getAllTask[i][16].equalsIgnoreCase("0")){%><%=getAllTask[i][16] %>h <%}%><%=getAllTask[i][17] %>m</td>
           <td><%if(!getAllTask[i][18].equalsIgnoreCase("0")){%><%=getAllTask[i][18] %>h <%}%><%=getAllTask[i][19] %>m</td>
           <td><%=duration %></td>           
           <td <%if(isPassed){%>style="color: red;"<%} %>><%=deliveredTime %></td>
           <td><%=milestoneData[7] %> %</td>
       </tr>
    <%}}%>
                           
    </tbody>
</table>
</div>
	<div class="filtertable">
  <span>Showing <%=showing %> to <%=ssn+getAllTask.length %> of <%=totalTask %> entries</span>
  <div class="pagination">
    <ul> <%if(pageNo>1){ %>
      <li class="page-item">	                     
      <a class="page-link text-primary" href="<%=request.getContextPath()%>/report.html?page=1&rows=<%=rows%>">First</a>
   </li><%} %>
    <li class="page-item">					      
      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/report.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
    </li>  
      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
	    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
	    <a class="page-link" href="<%=request.getContextPath()%>/report.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
	    </li>   
	  <%} %>
	   <li class="page-item">						      
	      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/report.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
	   </li><%if(pageNo<=(totalPages-1)){ %>
	   <li class="page-item">
	      <a class="page-link text-primary" href="<%=request.getContextPath()%>/report.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
	   </li><%} %>
	</ul>
	</div>
	<select class="select2" onchange="changeRows(this.value,'report.html?page=1','<%=domain%>')">
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
<p id="end" style="display: none;"></p>
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
            	<option value="concat(concat(m.msprojectnumber,'/'),concat(m.msinvoiceno,'/'),m.msproductname) as Project" selected>Project</option>
            	<option value="concat(t.task_name,'') as Milestone" selected>Milestone</option>
            	<option value="concat(t.assignee_name,'') as Assignee" selected>Assignee</option>
            	<option value="concat(concat(t.task_new_hh,'h '),concat(t.task_new_mm,'m')) as New" selected>New</option>
            	<option value="concat(concat(t.task_open_hh,'h '),concat(t.task_open_mm,'m')) as Open" selected>Open</option>
            	<option value="concat(concat(t.task_hold_hh,'h '),concat(t.task_hold_mm,'m')) as Hold" selected>Hold</option>
            	<option value="concat(concat(t.task_pending_hh,'h '),concat(t.task_pending_mm,'m')) as Pending" selected>Pending</option>            	
            	<option value="concat(concat(t.task_expired_hh,'h '),concat(t.task_expired_mm,'m')) as Expired" selected>Expired</option>
            	<option value="concat(ma.maid,'') as Milestone_TAT" selected>Milestone TAT</option>
            	<option value="concat(ma.marefid,'') as Delivery_TAT,concat(ma.marefid,'') as Delivery_Extended_Reason" selected>Delivery TAT</option>
            	<option value="concat(ma.maworkpercentage,'%') as Progress" selected>Progress</option>
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

$(function() {
	$("#projectNo").autocomplete({
		source : function(request, response) {
			if(document.getElementById('projectNo').value.trim().length>=1)
			$.ajax({
				url : "getprojectname.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field : "byprojectno"
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
		select: function (event, ui) {
            if(!ui.item){     
            	document.getElementById('errorMsg').innerHTML = 'Select From List.';
        		$('.alert-show').show().delay(1000).fadeOut();
        		
            	$("#projectNo").val("");
            }
            else{
            	doAction(ui.item.value,"reportprojectNo");
            	location.reload();
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});
$(function() {
	$("#assigneeName").autocomplete({
		source : function(request, response) {
			if(document.getElementById('assigneeName').value.trim().length>=1)
			$.ajax({
				url : "getprojectname.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field : "byassignee"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value,	
							uid : item.uid,
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
            	document.getElementById('errorMsg').innerHTML = 'Select From List.';
        		$('.alert-show').show().delay(1000).fadeOut();
        		
            	$("#assigneeName").val("");
            }
            else{
            	doAction(ui.item.value,"reportAssigneeName");
            	doAction(ui.item.uid,"reportAssigneeUid");
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
			type : "milestone_report"
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