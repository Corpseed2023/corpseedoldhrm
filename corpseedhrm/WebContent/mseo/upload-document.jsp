<%@page import="java.util.Properties"%>
<%@page import="admin.enquiry.Enquiry_ACT"%>
<%@page import="admin.seo.SeoOnPage_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Project documents</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body class="upload_doc">
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%-- <%if(!MT01){%><jsp:forward page="/login.html" /><%} %> --%>
<%
String token=(String)session.getAttribute("uavalidtokenno");
String loginuaid=(String)session.getAttribute("loginuaid");
String emproleid=(String)session.getAttribute("emproleid");
String refid="NA";
String pageurl=request.getParameter("uid").trim();
refid=pageurl.substring(13,pageurl.length()-5);

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
String sort_url=domain+pageurl+"?page="+pageNo+"&rows="+rows;

//pagination end

String subfolder[][]=SeoOnPage_ACT.getAllSubFolder(refid,token,emproleid,loginuaid,pageNo,rows);
int totalDocument=SeoOnPage_ACT.countAllSubFolder(refid,token,emproleid,loginuaid);
%>

<div id="content">

<div class="main-content clearfix">
<div class="container">
<div class="row">
        <div class="col-12 p-0">
        <div class="row">
<div class="col-md-12 col-sm-12 col-xs-12"> 
<div class="clearfix flex_box justify_end"> 
<a class="btn-default" onclick="goBack()">Back</a>
</div>
</div>
<div class="col-md-5 col-sm-5 col-xs-12" style="display: none;">
<div class="clearfix flex_box justify_end">  
<div class="item-bestsell col-md-6 col-sm-6 col-xs-12">
<p><input type="search" name="invoiceNo" id="InvoiceNo" title="Search by folder name !" placeholder="Search by folder name !" class="form-control ui-autocomplete-input" autocomplete="off">
</p>
</div>
<div class="item-bestsell col-md-6 col-sm-6 col-xs-12 has-clear"> 
<p><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="DD-MM-YYYY - DD-MM-YYYY" class="form-control text-center date_range pointers " readonly="readonly">
<span class="form-control-clear form-control-feedback hidden" onclick="clearSession('myTaskDateRange');location.reload();"></span>
</p>
</div>
</div>
</div>
</div>
          <div class="box_minht">
		  <div class="clearfix">
		  
<div class="clearfix" id="DisplayDocument">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
 <%
 int ssn=0;
 int showing=0; 
 int startRange=pageNo-2;
 int endRange=pageNo+2;
 int totalPages=1;
if(subfolder!=null&&subfolder.length>0){
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
	for(int i=0;i<subfolder.length;i++){
		int files=SeoOnPage_ACT.countAllFiles(subfolder[i][4],token);
		String salesName=Enquiry_ACT.getSalesProductName(subfolder[i][4],token);
%>
    <div class="col-md-3 col-sm-3 col-xs-12">  
    <div class="post" style="position:absolute;z-index:9">
    <div class="avatar" style="width:33px;height:33px;float:none;margin: 15px 10px;border-radius:15%"></div>
    <div class="linee" style="margin-top: -9px;"></div>
    <div class="linee" style="margin-top: 5px;"></div>
  </div>
	<div class="clearfix manage_documents"> 
	<div class="document_inner">
	<a class="view_folders" href="<%=request.getContextPath()%>/documentfiles-<%=subfolder[i][4]%>.html" title="<%=subfolder[i][2] %>"><i class="fas fa-folder" aria-hidden="true"></i><span class="count_file"><%=files %></span></a>
	<a class="pointers permision_box" onclick="openFolderPermission('<%=subfolder[i][3]%>')"><i class="fa fa-lock" aria-hidden="true"></i></a>
	</div>
	<div class="file_name"><%=subfolder[i][2] %></div> 
	<p><%=salesName %></p>
	</div>
	</div>
    <%}%>
    
	<div class="col-md-12 filtertable">
  <span>Showing <%=showing %> to <%=ssn+subfolder.length %> of <%=totalDocument %> entries</span>
  <div class="pagination">
    <ul> <%if(pageNo>1){ %>
      <li class="page-item">	                     
      <a class="page-link text-primary" href="<%=request.getContextPath()%>/<%=pageurl%>?page=1&rows=<%=rows%>">First</a>
   </li><%} %>
    <li class="page-item">					      
      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/<%=pageurl%>?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
    </li>  
      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
	    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
	    <a class="page-link" href="<%=request.getContextPath()%>/<%=pageurl%>?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
	    </li>   
	  <%} %>
	   <li class="page-item">						      
	      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/<%=pageurl%>?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
	   </li><%if(pageNo<=(totalPages-1)){ %>
	   <li class="page-item">
	      <a class="page-link text-primary" href="<%=request.getContextPath()%>/<%=pageurl%>?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
	   </li><%} %>
	</ul>
	</div>
	<select class="select2" onchange="changeRows(this.value,'<%=pageurl%>?page=1','<%=domain%>')">
	<option value="12" <%if(rows==12){ %>selected="selected"<%} %>>Rows 12</option>
	<option value="24" <%if(rows==24){ %>selected="selected"<%} %>>Rows 24</option>
	<option value="48" <%if(rows==48){ %>selected="selected"<%} %>>Rows 48</option>
	<option value="96" <%if(rows==96){ %>selected="selected"<%} %>>Rows 96</option>
	<option value="192" <%if(rows==192){ %>selected="selected"<%} %>>Rows 192</option>	
	</select>
	</div>

<%}else{%>
    <div class="text-center text-danger noDataFound mgtop">No Data Found !!</div>
    <%} %>
     </div>   
    </div>
    </div> 

    <div id="AddDocument" style="display: none;">
    <form action="/erpcrmhrm/addclientDocument.html" enctype="multipart/form-data" method="post">
    <input type="hidden" name="clientid" value="2">
    <div class="form-group order-progress-box">
    <div class="row">    
    <div class="form-group col-md-4 col-sm-4 col-xs-12 text-left">
    <label>Document Name : <sup style="color: red;">*</sup></label>
    <input type="text" autocomplete="off" id="DocumentName" name="documentname" class="form-control" placeholder="Document Name here !">
    </div> 
    <div class="form-group col-md-3 col-sm-3 col-xs-12 text-left" style="display: none;">
    <label>Document Type : <sup style="color: red;">*</sup></label>
    <input type="text" value="General" autocomplete="off" id="DocumentType" name="documenttype" class="form-control" placeholder="Document Type here !">
    </div> 
    <div class="form-group col-md-4 col-sm-4 col-xs-12 text-left">
    <label>Folder Name : <sup style="color: red;">*</sup></label>
    <select id="FolderName" name="folderdetails" class="form-control">
    <option value="">Select Folder Name</option>
    
    <option value="WsgErfxamS6dCJWzC3dU66EPbW3QUc#PR201">PR201</option>
    
    <option value="egOn9U90cGIaHRlnhibw1Fg4kkZpbT#PR201">PR201</option>
    
    </select>
    </div> 
    <div class="from-group col-md-4 col-sm-4 col-xs-12 text-left">
    <label>Choose Document : <sup style="color: red;">*</sup></label>
    <input type="file" id="DocumentFile" name="files" class="form-control" placeholder="Choose Document !">
    </div>
    </div>
    <div class="row">
    <div class="form-group col-sm-12 col-md-12 col-xs-12 p-0">
       <div class="form-check-order text-center"> 
       <button type="button" class="btn default bg text-white" onclick="location.reload();">Cancel</button> 
       <button type="submit" class="btn default bg text-white" onclick="validateUpload();">Submit</button>
       </div>
    </div>
    </div>
    </div>
    </form>
    </div>
	</div>
    </div>
    </div>
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
function validateUser() {		
	if(document.getElementById("User_Id").value.trim()=="" ) {
		document.getElementById('errorMsg').innerHTML = 'Enter user name...';
		$('.alert-show').show().delay(2000).fadeOut();
		return false;
	}
	var userId=document.getElementById("Uid").value.trim();	
	var frefid=document.getElementById("FolderId").value.trim();	
	var fcategory="sub-folder";
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
		complete : function(data){
			hideLoader();
		},
		error: function (error) {
		alert("error in addPermissions() " + error.responseText);
		}
		});
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
</script>

<script type="text/javascript">
function removeFile(id,name){
	showLoader();
	var xhttp;
	xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
	if (this.readyState == 4 && this.status == 200) {
	location.reload();
	}
	};
	xhttp.open("GET", "<%=request.getContextPath()%>/RemoveFile111?uid="+id+"&name="+name, true);
	xhttp.send();
	hideLoader();
}
</script>
</body>
</html>