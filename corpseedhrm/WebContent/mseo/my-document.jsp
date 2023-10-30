<%@page import="java.util.Properties"%>
<%@page import="client_master.Clientmaster_ACT"%>
<%@page import="admin.task.TaskMaster_ACT"%>
<%@page import="admin.seo.SeoOnPage_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Manage Documents</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%if(!MDC0){%><jsp:forward page="/login.html" /><%} %>


<div id="content">
<%
String token=(String)session.getAttribute("uavalidtokenno");
String emproleid=(String)session.getAttribute("emproleid");
String loginuaid=(String)session.getAttribute("loginuaid");

//pagination start
int pageNo=1;
int rows=12;

String sorting_order=(String)session.getAttribute("sorting_order");
if(sorting_order==null)sorting_order="";

if(request.getParameter("page")!=null)pageNo=Integer.parseInt(request.getParameter("page"));
if(request.getParameter("rows")!=null)rows=Integer.parseInt(request.getParameter("rows"));

Properties properties = new Properties();
properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
String domain=properties.getProperty("domain");
String sort_url=domain+"mydocument.html?page="+pageNo+"&rows="+rows;

//pagination end

/* new */
String clientname=(String)session.getAttribute("SearchByClientName");
if(clientname==null||clientname.length()<=0)clientname="NA";

String searchClientId=(String)session.getAttribute("SearchByClientId");
if(searchClientId==null||searchClientId.length()<=0)searchClientId="NA";

String docDateRangeAction=(String)session.getAttribute("docDateRangeAction");
if(docDateRangeAction==null||docDateRangeAction.length()<=0)docDateRangeAction="NA";

String doDocumentAction=(String)session.getAttribute("doDocumentAction");
if(doDocumentAction==null||doDocumentAction.length()<=0)doDocumentAction="Project";
String folder[][]=SeoOnPage_ACT.getAllFolder(token,emproleid,loginuaid,searchClientId,doDocumentAction,docDateRangeAction,pageNo,rows);
int totalDocument=SeoOnPage_ACT.countAllFolder(token,emproleid,loginuaid,searchClientId,doDocumentAction,docDateRangeAction);
%> 
<div class="main-content">
<div class="container-fluid">

<div class="clearfix"> 
<form name="RefineSearchenqu" onsubmit="return false;">
<div class="bg_wht clearfix mb10">  
<div class="row">
<div class="col-md-7 col-sm-7 col-xs-9"> 
<ul class="clearfix filter_menu">
	<li <%if(doDocumentAction.equalsIgnoreCase("Project")){ %>class="active"<%} %>><a onclick="doAction('Project','doDocumentAction');location.reload();">Project's</a></li>
	<li <%if(doDocumentAction.equalsIgnoreCase("Personal")){ %>class="active"<%} %>><a onclick="doAction('Personal','doDocumentAction');location.reload();">Personal</a></li> 
<%-- <%if(doDocumentAction.equalsIgnoreCase("Personal")){ %>
<li><a data-toggle="modal" data-target="#newFolderModal">New folder</a></li>
<%} %> --%>
 </ul>

</div>
<a href="javascript:void(0)" class="doticon"> <i class="fa fa-filter" aria-hidden="true"></i>Filter</a>
<div class="filtermmenu">
<div class="col-md-5 col-sm-5 col-xs-12">
<div class="clearfix flex_box justify_end">  
<div class="item-bestsell col-md-6 col-sm-6 col-xs-12">
<p><input type="search" name="searchbyclientname" <%if(!clientname.equalsIgnoreCase("NA")){ %>onsearch="clearSession('SearchByClientName');clearSession('SearchByClientId');location.reload()" value="<%=clientname%>"<%} %> id="SearchByClientName" title="Search by client name !" placeholder="Search by client name !" class="form-control" autocomplete="off">
<input type="hidden" id="ClientId" <%if(!searchClientId.equalsIgnoreCase("NA")){%>value="<%=searchClientId %>"<%} %>>
</p>
</div>
<div class="item-bestsell col-md-6 col-sm-6 col-xs-12 has-clear"> 
<p><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="DD-MM-YYYY - DD-MM-YYYY" class="form-control text-center date_range pointers <%if(!docDateRangeAction.equalsIgnoreCase("NA")){ %>selected<%} %>" readonly="readonly">
<span class="form-control-clear form-control-feedback hidden" onclick="clearSession('docDateRangeAction');location.reload();"></span>
</p>
</div>
</div>
</div>
</div>
</div>
</div>
</form>
</div>


<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="row">
<%
int ssn=0;
int showing=0; 
int startRange=pageNo-2;
int endRange=pageNo+2;
int totalPages=1;
if(folder!=null&&folder.length>0){
	ssn=rows*(pageNo-1);
	  totalPages=(totalDocument/rows);
	  if((totalDocument%rows)!=0)totalPages+=1;
	  showing=ssn+1;
	  if (totalPages > 1) {     	 
		  if((endRange-2)==totalPages)startRange=pageNo-4;        
        if(startRange==pageNo)endRange=pageNo+4;
        if(startRange<1) {startRange=1;endRange=startRange+4;}
        if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
        if(startRange<1)startRange=1;
   }else{startRange=0;endRange=0;}
	  
	for(int i=0;i<folder.length;i++){
		int files=SeoOnPage_ACT.countAllFolders(folder[i][0],token);
		String clientId=Clientmaster_ACT.getClientNo(folder[i][3], token);
		String clientName=Clientmaster_ACT.getClientNameByNo(clientId, token);
		
		String fdesc=clientId+" : "+clientName;
		if(clientId.equalsIgnoreCase("NA")){
			fdesc=Usermaster_ACT.getLoginUserName(folder[i][4], token);
		}
%>
<div class="col-md-3 col-sm-3 col-xs-12">  
<div class="post" style="position:absolute;z-index:9">
    <div class="avatar" style="width:33px;height:33px;float:none;margin: 15px 10px;border-radius:15%"></div>
    <div class="linee" style="margin-top: -9px;"></div>
    <div class="linee" style="margin-top: 5px;"></div>
  </div>
<div class="clearfix manage_documents"> 
<div class="document_inner">
<%if(doDocumentAction.equalsIgnoreCase("Personal")){
	files=SeoOnPage_ACT.countAllFiles(folder[i][5],token);
%>
	<a class="view_folders" href="<%=request.getContextPath()%>/personalfiles-<%=folder[i][5]%>.html" title="<%=folder[i][1] %>"><i class="fas fa-folder" aria-hidden="true"></i><span class="count_file"><%=files %></span></a>
<%}else{ %>
<a class="view_folders" href="<%=request.getContextPath()%>/subdocuments-<%=folder[i][0]%>.html" title="<%=folder[i][1] %>"><i class="fas fa-folder" aria-hidden="true"></i><span class="count_file"><%=files %></span></a>
<%}if(emproleid.equalsIgnoreCase("Administrator")){ %>
<a class="pointers permision_box" onclick="openFolderPermission('<%=folder[i][0]%>')"><i class="fas fa-lock" aria-hidden="true"></i></a>
<%} %>
</div>
<div class="file_name" title="<%=folder[i][1] %>"><%=folder[i][1] %></div> 
<p title="<%=fdesc %>"><%=fdesc %></p>
</div>
</div>
<%} %>
<div class="col-md-12 filtertable">
  <span>Showing <%=showing %> to <%=ssn+folder.length %> of <%=totalDocument %> entries</span>
  <div class="pagination">
    <ul> <%if(pageNo>1){ %>
      <li class="page-item">	                     
      <a class="page-link text-primary" href="<%=request.getContextPath()%>/mydocument.html?page=1&rows=<%=rows%>">First</a>
   </li><%} %>
    <li class="page-item">					      
      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/mydocument.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
    </li>  
      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
	    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
	    <a class="page-link" href="<%=request.getContextPath()%>/mydocument.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
	    </li>   
	  <%} %>
	   <li class="page-item">						      
	      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/mydocument.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
	   </li><%if(pageNo<=(totalPages-1)){ %>
	   <li class="page-item">
	      <a class="page-link text-primary" href="<%=request.getContextPath()%>/mydocument.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
	   </li><%} %>
	</ul>
	</div>
	<select class="select2" onchange="changeRows(this.value,'mydocument.html?page=1','<%=domain%>')">
	<option value="12" <%if(rows==12){ %>selected="selected"<%} %>>Rows 12</option>
	<option value="24" <%if(rows==24){ %>selected="selected"<%} %>>Rows 24</option>
	<option value="48" <%if(rows==48){ %>selected="selected"<%} %>>Rows 48</option>
	<option value="96" <%if(rows==96){ %>selected="selected"<%} %>>Rows 96</option>
	<option value="192" <%if(rows==192){ %>selected="selected"<%} %>>Rows 192</option>	
	</select>
	</div>

<%}else{%>
<div class="text-center text-danger noDataFound">No Data Found !!</div>
<%} %>
</div>
</div>
</div>
</div>
</div>
</div>
 <div class="myModal modal fade" id="newFolderModal">
   <div class="modal-dialog">
     <div class="modal-content">
       <div class="modal-header">
         <h4 class="modal-title"><i class="fas fa-folder-plus txt_blue" aria-hidden="true"></i>New folder</h4>  
         <button type="button" class="closeBox" data-dismiss="modal"><span>&times;</span></button>
       </div>
       <form method="post" onsubmit="return false">
       <div class="modal-body">          
	  <div class="tab-content">		  
	  <div id="pay_method2">
	  <div class="row mb10">
           <div class="form-group-payment col-md-12 col-sm-12 col-12">
		<label>Folder name</label>
           <input type="text" class="form-control" name="folder_name" onchange="isFolderExist(this.value)" id="Folder_Name" placeholder="Name" autocomplete="off">
           </div>            
	  </div> 
         </div>
	  </div>  		  
       </div>
       <div class="modal-footer flex-end">
         <button type="button" class="btn btn-cancel bt-link bt-radius" data-dismiss="modal">Cancel</button> 
         <button type="submit" class="bt-link bt-radius bt-loadmore" onclick="return validateFolder()">Submit</button> 
       </div>
       </form>
     </div>
   </div>
 </div>
 
  <div class="myModal modal fade" id="accessFolderModal">
   <div class="modal-dialog">
     <div class="modal-content">
       <div class="modal-header">
         <h4 class="modal-title"><i class="fas fa-folder-plus txt_blue" aria-hidden="true"></i>Grant/Deny Access Folder Permission</h4>  
         <button type="button" class="closeBox" data-dismiss="modal"><span>&times;</span></button>
       </div>
       <div class="modal-body"> 
         <form class="clearfix" onsubmit="return false;"  name="follow-up-form"> 
          <input type="hidden" id="FolderId"/>
           <div class="row">
              <div class="col-md-8 col-sm-8 col-xs-12">                           
               <div class="clearfix form-group mtop10">
               <label>Name :<span style="color: red;">*</span></label>
               <div class="clearfix relative_box">
               <input type="text" id="User_Id" autocomplete="off" name="userid"  class="form-control"  placeholder="User name..."/>
               <input type="hidden" name="uid" id="Uid"/>
               </div>
               </div> 
              </div>
              <div class="col-md-4 col-sm-4 col-xs-12">                          
               <div class="clearfix form-group mtop10 text-center">
               <div class="clearfix">
               <label class="hidden-xs">&nbsp;</label>
               </div>
                     <button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateUser();">Submit</button>
               </div>
              </div>
            </div>
            
             <div class="clearfix overflow_hidden mtop10">
             <div class="scroll_box">                             
             
             <div id="FolderAccessPermission"></div>
             
              
              
              </div>
              </div>
               
        </form>		  
       </div>
     </div>
   </div>
 </div>
 
<p id="end" style="display: none;"></p>
</div>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>

<script type="text/javascript">
function openFolderPermission(fkey){
	$('#FolderId').val(fkey);
	$("#accessFolderModal").modal("show");
	fillFolderAccessUser(fkey);
}
function fillFolderAccessUser(fkey){
	//removing previous appended codes
	$(".accessPermission").remove();
	showLoader();
	 $.ajax({
			type : "POST",
			url : "GetFolderAccessUser111",
			dataType : "HTML",
			data : {				
				fkey : fkey,						
			},
			success : function(data){	
			if(Object.keys(data).length!=0){
				data = JSON.parse(data);			
			 var plen = data.length;
			 if(Number(plen)>0){				 
			 for(var j=0;j<plen;j++){ 			
			 	var id=data[j]["id"];
				var name=data[j]["name"];
								
				$(''+
						'<div class="row accessPermission" id="accessPermission'+j+'">'+
	             '<div class="col-md-12 col-sm-12 col-xs-12">'+
	                ' <div class="clearfix">'+
	             '<div class="col-xs-1 box-intro-background">'+
	              ' <div class="link-style12">'+
	              ' <p class="news-border" title=""><input type="checkbox"></p>'+
	              ' </div>'+
	             '</div> '+ 
	             '<div class="col-xs-10 box-intro-background">'+
	               '<div class="link-style12">'+
	              ' <p class="news-border" title="">'+name+'</p>'+
	               '</div>'+
	            ' </div> '+
	            ' <div class="col-xs-1 box-intro-background">'+
	              ' <div class="link-style12">'+
	              ' <p class="text-right" title="">'+
	              ' <a class="bg_none pointers" onclick="removePermission(\''+id+'\',\''+j+'\')"><i class="fas fa-trash" title="Remove permission " aria-hidden="true"></i>'+
	              ' </a></p>'+
	              ' </div>'+
	             '</div> '+
	             '</div>'+
	              '</div>'+
	              '</div>').insertBefore("#FolderAccessPermission");
							 
			 }}}else{
				 $('<div class="text-center text-danger accessPermission noDataFound">No Data Found !!</div>').insertBefore("#FolderAccessPermission");
			 }
	},
	complete : function(data){
		hideLoader();
	}});
}
function removePermission(id,j){
	showLoader();
	var removeId="accessPermission"+j;
	var xhttp;
	xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
	if (this.readyState == 4 && this.status == 200) {
		$("#"+removeId).remove();
	}
	};
	xhttp.open("GET", "<%=request.getContextPath()%>/DeletePermission111?info="+id, true);
	xhttp.send();
	hideLoader();
}
$(function() {
	$("#User_Id").autocomplete({
		source : function(request, response) {
			var refid=$("#FolderId").val();
			if(document.getElementById('User_Id').value.trim().length>=1)
			$.ajax({
				url : "getalluser.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,		
					refid : refid,
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.uname,	
							value : item.name,
							uid : item.uid,												
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
            	document.getElementById('errorMsg').innerHTML = 'Registered user allowed only..';
        		$('.alert-show').show().delay(2000).fadeOut();
            	$("#User_Id").val("");
            	$("#Uid").val("");            	
            }
            else{
            	$("#User_Id").val(ui.item.value);
            	$("#Uid").val(ui.item.uid);            	
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});
function validateUser() {		
	if(document.getElementById("User_Id").value.trim()=="" ) {
		document.getElementById('errorMsg').innerHTML = 'Enter user name...';
		$('.alert-show').show().delay(2000).fadeOut();
		return false;
	}
	var userId=document.getElementById("Uid").value.trim();	
	var frefid=document.getElementById("FolderId").value.trim();	
	var fcategory="folder";
	showLoader();
	$.ajax({
		type: "POST",
		dataType: "html",
		url: "<%=request.getContextPath()%>/addFolderPermission111",
		data:  {
			userId: userId,
			frefid: frefid,
			fcategory: fcategory
		},
		success: function (data) {
			fillFolderAccessUser(frefid);
			document.getElementById('errorMsg1').innerHTML = 'Access granted to '+$("#User_Id").val();
    		$('.alert-show1').show().delay(3000).fadeOut();
			$("#User_Id").val('');
			$("#Uid").val('');
		},
		error: function (error) {
		alert("error in addPermissions() " + error.responseText);
		},
		complete : function(data){
			hideLoader();
		}
		});
}
$(function() {
$("#date").datepicker({
changeMonth: true,
changeYear: true,
dateFormat: 'dd-mm-yy'
});
});
$(function() {
	$("#ddate").datepicker({
	changeMonth: true,
	changeYear: true,
	dateFormat: 'dd-mm-yy'
	});
	});
</script>

<script type="text/javascript">
$(function() {
	$("#SearchByClientName").autocomplete({
		source : function(request, response) {
			if(document.getElementById('SearchByClientName').value.trim().length>=1)
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
            if(!ui.item){     
            	document.getElementById('errorMsg').innerHTML = 'Select from client list.';
        		$('.alert-show').show().delay(3000).fadeOut();
        		
            	$("#SearchByClientName").val("");    
            	
            }
            else{
            	doAction(ui.item.value,'SearchByClientName');
            	doAction(ui.item.cid,'SearchByClientId');
            	location.reload();
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});
function validateFolder(){
	  var folder_name=$("#Folder_Name").val();
	  if(folder_name==null||folder_name==""){
		  document.getElementById('errorMsg').innerHTML = 'Please enter folder name !!';
		  $('.alert-show').show().delay(2000).fadeOut();
		  return false;
	  }
	  showLoader();
		$.ajax({
			type : "POST",
			url : "<%=request.getContextPath()%>/new-folder.html",
			dataType : "HTML",
			data : {				
				folder_name : folder_name
			},
			success : function(data){
				if(data=="pass"){location.reload();}else{
					document.getElementById('errorMsg').innerHTML = 'Something went wrong , Please try-again later !!';
					  $('.alert-show').show().delay(2000).fadeOut();
					  return false;
				}
			},
			complete : function(data){
				hideLoader();
			}
		}); 
}
function isFolderExist(data){
	showLoader();  
	$.ajax({
			type : "POST",
			url : "IsFolderExist111",
			dataType : "HTML",
			data : {				
				data : data
			},
			success : function(data){
				if(data=="pass"){
					document.getElementById('errorMsg').innerHTML = 'Duplicate folder name !!';
					$("#Folder_Name").val('');
					  $('.alert-show').show().delay(2000).fadeOut();
					  return false;
				}
			},
			complete : function(data){
				hideLoader();
			}
		});
}
function doAction(data,name){
	showLoader();
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/SetOrderTypeSearch999",
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
$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var data=$(this).val();
	doAction(data,"docDateRangeAction");
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
	   var dateRangeDoAction="<%=docDateRangeAction%>";
	   if(dateRangeDoAction!="NA"){	  
		   $('input[name="date_range"]').val(dateRangeDoAction);
	   }
	});
</script>
<!-- <script type="text/javascript"> -->
<%-- var projectno="<%=projectno%>"; --%>
<%-- if(projectno!="NA")window.location = "<%=request.getContextPath()%>/upload-file.html?refid=<%=folder[0][0]%>&fname=<%=folder[0][1]%>"; --%>
<!-- </script> -->
</body>
</html>