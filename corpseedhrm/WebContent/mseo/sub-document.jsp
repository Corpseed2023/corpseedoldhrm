<%@page import="commons.CommonHelper"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.nio.file.Paths"%>
<%@page import="java.util.Properties"%>
<%@page import="java.nio.file.Path"%>
<%@page import="admin.task.TaskMaster_ACT"%>
<%@page import="admin.seo.SeoOnPage_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Documents</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body class="upload_doc">
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%-- <%if(!MT01){%><jsp:forward page="/login.html" /><%} %> --%>
<%
String token=(String)session.getAttribute("uavalidtokenno");
String refid="NA";
String pageurl=request.getParameter("uid").trim();
refid=pageurl.substring(14,pageurl.length()-5);

String doActionFiles=(String)session.getAttribute("doActionFiles");
if(doActionFiles==null||doActionFiles.length()<=0)doActionFiles="Client";

Properties properties = new Properties();
properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
String docpath=properties.getProperty("path")+"documents";
String docBasePath=properties.getProperty("docBasePath");
String domain=properties.getProperty("domain");

//pagination start
int pageNo=1;
int rows=10;
String sort="";
String order=(String)session.getAttribute("dcsortby_ord");
if(order==null)order="desc";

String sorting_order=(String)session.getAttribute("dcsorting_order");
if(sorting_order==null)sorting_order="";

if(request.getParameter("page")!=null)pageNo=Integer.parseInt(request.getParameter("page"));
if(request.getParameter("rows")!=null)rows=Integer.parseInt(request.getParameter("rows"));

if(request.getParameter("sort")!=null)sort=request.getParameter("sort");

String sort_url=domain+pageurl+"?page="+pageNo+"&rows="+rows;

//pagination end
%>

<div id="content">
<div class="main-content clearfix">
<div class="container">
<div class="row pad-bt5">
<div class="col-md-7 col-sm-7 col-xs-12"> 
<ul class="clearfix filter_menu">
	<li <%if(doActionFiles.equalsIgnoreCase("Client")){ %>class="active"<%} %>><a onclick="doAction('Client','doActionFiles')">Customer uploaded</a></li>
	<li <%if(doActionFiles.equalsIgnoreCase("Agent")){ %>class="active"<%} %>><a onclick="doAction('Agent','doActionFiles')">Agent uploaded</a></li> 
</ul>

</div>
<div class="col-md-5 col-sm-5 col-xs-12 text-right">         
<a class="btn-default" onclick="goBack()">Back</a>
</div>
</div>
<div class="row">
 <div class="col-md-12 col-sm-12 col-xs-12">
 <div class="table-responsive"> 
<%@ include file="../staticresources/includes/skelton.jsp" %>           
<table class="ctable mt-5">
   <thead>
       <tr>
           <th class="sorting <%if(sort.equals("id")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','id','<%=order%>','dcsorting_order','dcsortby_ord')">SN</th>
           <th>Document Type</th>
           <th class="sorting <%if(sort.equals("name")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','name','<%=order%>','dcsorting_order','dcsortby_ord')">Document Name</th>
           <th>Upload Size</th>
           <th class="sorting <%if(sort.equals("upload_date")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','upload_date','<%=order%>','dcsorting_order','dcsortby_ord')">Upload Date</th>
           <th class="sorting <%if(sort.equals("doc_name")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','doc_name','<%=order%>','dcsorting_order','dcsortby_ord')">Upload Doc. Name</th>
           <th>Action</th>
       </tr>
   </thead>
   <tbody>
   <%
   int ssn=0;
   int showing=0;
   int startRange=pageNo-2;
   int endRange=pageNo+2;
   int totalPages=1;
   
   String files[][]=SeoOnPage_ACT.getAllFiles(refid,token,doActionFiles,pageNo,rows,sort,order);
   int totalDocuments=SeoOnPage_ACT.countAllFiles(refid,token,doActionFiles);
   if(files!=null&&files.length>0){
	   ssn=rows*(pageNo-1);
		  totalPages=(totalDocuments/rows);
		  if((totalDocuments%rows)!=0)totalPages+=1;
		  showing=ssn+1;
		  if (totalPages > 1) {     	 
			  if((endRange-2)==totalPages)startRange=pageNo-4;        
	          if(startRange==pageNo)endRange=pageNo+4;
	          if(startRange<1) {startRange=1;endRange=startRange+4;}
	          if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
	          if(startRange<1)startRange=1;
	     }else{startRange=0;endRange=0;}
		  
 	  for(int i=0;i<files.length;i++){
 		  boolean fileExist=false;
 		  String fileName=files[i][4];
 		  String orgFileName="NA";
 			String extension="";
 			String size="";
 			Path path=null;
 			if(fileName!=null&&!fileName.equalsIgnoreCase("NA")&&fileName.length()>0){
 				
 				long bytes=0;
 				fileExist=CommonHelper.isFileExists(fileName);
 				if(fileExist){
 					bytes=CommonHelper.getBlobSize(fileName);
 				}
 				long kb=bytes/1024;
 				long mb=kb/1024;	
 				
 				if(mb>=1)size=mb+" MB";
 				else if(kb>=1) size=kb+" KB";
 				else size=bytes+" bytes";	
 				int index=files[i][4].lastIndexOf(".");
 				extension=files[i][4].substring(index);
 				orgFileName=files[i][4].substring(21);
 			}
  %>
       <tr id="row<%=i+1%>">
           <td><%=(showing+i) %></td>
           <td><i class="fas fa-file" aria-hidden="true"></i><%=extension %></td>
           <td><%=files[i][1] %></td>
           <td><%=size %></td>
           <td><%=files[i][6] %></td>
           <td><%=orgFileName %></td>
           <td>
           <form onsubmit="return false" class="uploadFileClass<%=i %>">
           <!-- milestone price percentage not updated because of commenting -->
			<%-- <input type="file" name="uploadFileBox<%=i %>" onchange="fileSizeCompaitable('<%=files[i][0] %>','<%=i %>')" id="UploadFileBox<%=i %>" style="display: none;">	
			<a onclick="$('#UploadFileBox<%=i %>').click()"><i class="fas fa-file-upload" aria-hidden="true" title="Upload file" style="color: #0066ff;font-size: 22px;"></i></a>  --%>
			<%if(!orgFileName.equalsIgnoreCase("NA")&&fileExist){ %><a href="<%=docBasePath%><%=files[i][4]%>" download><i class="fas fa-file-download" aria-hidden="true" title="Upload file" style="color: #0066ff;font-size: 22px;"></i></a>
			<a onclick="deletePersonalFile('<%=files[i][0] %>','<%=files[i][4]%>')"><i class="fas fa-trash" aria-hidden="true" title="delete file" style="color: #0066ff;font-size: 22px;"></i></a>  <%} %>
			</form>
           </td>
       </tr>
    <%}}%>
                           
    </tbody>
</table>     
</div>      
   <div class="filtertable">
  <span>Showing <%=showing %> to <%=ssn+files.length %> of <%=totalDocuments %> entries</span>
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

<div class="modal fade" id="deleteWarningModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title text-danger" id="exampleModalLabel"><i class="fas fa-exclamation-triangle"></i>&nbsp;&nbsp;Are you sure want to delete this file ?</h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body" style="border-bottom: 1px solid #e5e5e5;">
        Remove files immediately when deleted check box is not enabled. b. When the Display delete confirmation dialog check box is selected. The warning message appears when user tries to delete a file with other methods.
      </div>
      <div class="modal-footer">
      <input type="hidden" id="DeletePersonalFileKey">
      <input type="hidden" id="DeletePersonalFileName">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary" onclick="removePersonalFile()">Delete</button>
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
function fileSizeCompaitable(docKey,k){
	  var fileId="UploadFileBox"+k;
	  
		const fi=document.getElementById(fileId);
		if (fi.files.length > 0) {
			const fsize = fi.files.item(0).size; 
	        const file = Math.round((fsize / 1024)); 
	        // The size of the file. 
	        if (file >= 1024) {  
	            document.getElementById('errorMsg').innerHTML ='File too Big, Max File Size 1 MB !!';
	            document.getElementById(fileId).value="";
	 		    $('.alert-show').show().delay(4000).fadeOut();
	        }else{
	        	uploadFile(docKey,k);
	        }		
		}	
}
function uploadFile(docKey,k){	
	 var File="uploadFileBox"+k;
	 var rowId="row"+k;
	
	 var uploadFileClass="uploadFileClass"+k;
	   setTimeout(() => {	
		if($("#"+File).val()!=""){		
		var form = $("."+uploadFileClass)[0];
	    var data = new FormData(form);
	    data.append("docKey", docKey);
	    data.append("file", File);
		showLoader();
	    $.ajax({
	        type : "POST",
	        encType : "multipart/form-data",
	        url : "<%=request.getContextPath()%>/UpdateSalesDocuments111",
	        cache : false,
	        processData : false,
	        contentType : false,
	        data : data,
	        success : function(data) {
	        	var x=data.split("#");
	        	if(x[0]=="pass"){
	        	document.getElementById('errorMsg1').innerHTML ="Uploaded Successfully !!";
// 	        	$("#DocWalletDivId").load(location.href + " #DocWalletDivId1");				
	    		$('.alert-show1').show().delay(3000).fadeOut();
	    		setTimeout(() => {
					location.reload(true);
				}, 3000);
	    		}else{
	    			document.getElementById('errorMsg').innerHTML ="Something Went wrong ,try-again later !!";
		    		$('.alert-show').show().delay(3000).fadeOut();
	    		}
	        },
	        error : function(msg) {
	            alert("Couldn't upload file");
	        },
			complete : function(data){
				hideLoader();
			}
	    });
		}	
	   }, 200);
	}
$("a.view_file").fancybox({
    maxWidth: 900,
    maxHeight: 600,
    fitToView: false,
    width: '90%',
    height: '90%',
    autoSize: false,
    closeClick: false,
    openEffect: 'elastic',
    closeEffect: 'elastic',
    afterLoad: function () {
        if (this.type == "iframe") {
            $.extend(this, {
                iframe: {
                    preload: false
                }
            });
        }
    }
});
</script>

<script type="text/javascript">
$(".fancybox").fancybox({
    'width'             : '300px',
    'height'            : '100%',
    'autoScale'         : false,
    'transitionIn'      : 'none',
    'transitionOut'     : 'none',
    'type'              : 'iframe',
    'hideOnOverlayClick': false,
});
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
<!-- <script type="text/javascript">
var counter=25;
$(window).scroll(function () {
    if ($(window).scrollTop() == $(document).height() - $(window).height()) {
//     	appendData();
    }
});

</script> -->
<script type="text/javascript">
function vieweditpage(id,page){
	showLoader();
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/vieweditpage",
	    data:  { 
	    	"uid" : id
	    },
	    success: function (response) {
	    	if(page=="view")    	window.location = "<%=request.getContextPath()%>/viewdetails.html";
	    	else if(page=="edit")    	window.location = "<%=request.getContextPath()%>/edittask.html"; 
        },
		complete : function(data){
			hideLoader();
		}
	});
}
function deletePersonalFile(skey,fileName){
	  $("#deleteWarningModal").modal('show'); 
	  $("#DeletePersonalFileKey").val(skey);
	  $("#DeletePersonalFileName").val(fileName);
}
function removePersonalFile(){
	showLoader();
	  var skey=$("#DeletePersonalFileKey").val();
	  var fileName=$("#DeletePersonalFileName").val();
		var xhttp;
		xhttp = new XMLHttpRequest();
		xhttp.onreadystatechange = function() {
		if (this.readyState == 4 && this.status == 200) {
			$("#deleteWarningModal").modal('hide'); 	
			location.reload();
		}
		};
		xhttp.open("GET", "<%=request.getContextPath()%>/RemoveFile111?skey="+skey+"&fileName="+fileName, true);
		xhttp.send();
		hideLoader();
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
         location.reload(true)     	  ;
        },
		complete : function(data){
			hideLoader();
		}
	});
}
</script>

</body>
</html>