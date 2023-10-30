<%@page import="commons.AzureBlob"%>
<%@page import="com.azure.storage.blob.BlobClientBuilder"%>
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
<title>Personal documents</title>
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

String personalDoActionFiles=(String)session.getAttribute("personalDoActionFiles");
if(personalDoActionFiles==null||personalDoActionFiles.length()<=0)personalDoActionFiles="Client";

Properties properties = new Properties();
properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
String docpath=properties.getProperty("path")+"documents";
String azure_key=properties.getProperty("azure_key");
String azure_container=properties.getProperty("azure_container");
String azure_path=properties.getProperty("azure_path");
String domain=properties.getProperty("domain");
//pagination start
int pageNo=1;
int rows=10;
String sort="";
String order=(String)session.getAttribute("pdocsortby_ord");
if(order==null)order="desc";

String sorting_order=(String)session.getAttribute("pdocsorting_order");
if(sorting_order==null)sorting_order="";

if(request.getParameter("page")!=null)pageNo=Integer.parseInt(request.getParameter("page"));
if(request.getParameter("rows")!=null)rows=Integer.parseInt(request.getParameter("rows"));

if(request.getParameter("sort")!=null)sort=request.getParameter("sort");

String sort_url=domain+"manage-sales.html?page="+pageNo+"&rows="+rows;

//pagination end
%>

<div id="content">
<div class="main-content clearfix">
<div class="container">
<div class="row pad-bt5">
<div class="col-md-7 col-sm-7 col-xs-12"> 
<ul class="clearfix filter_menu">
	<li <%if(personalDoActionFiles.equalsIgnoreCase("Client")){ %>class="active"<%} %>><a onclick="doAction('Client','personalDoActionFiles')">Customer uploaded</a></li>
	<li <%if(personalDoActionFiles.equalsIgnoreCase("Agent")){ %>class="active"<%} %>><a onclick="doAction('Agent','personalDoActionFiles')">Agent uploaded</a></li> 
</ul>

</div>
<div class="col-md-5 col-sm-5 col-xs-12 text-right"> 
<a class="btn-default" data-toggle="modal" data-target="#newFileUploadModal">+&nbsp;Upload</a>         
<a class="btn-default" onclick="goBack()">Back</a>
</div>
</div>
<div class="row">
        <div class="col-12 p-0">
        <table class="ctable mt-5">
   <thead>
       <tr>
           <th class="sorting <%if(sort.equals("id")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','id','<%=order%>','pdocsorting_order','pdocsortby_ord')">SN</th>
           <th>Document Type</th>
           <th class="sorting <%if(sort.equals("name")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','name','<%=order%>','pdocsorting_order','pdocsortby_ord')">Document Name</th>
           <th>Upload Size</th>
           <th class="sorting <%if(sort.equals("upload_date")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','upload_date','<%=order%>','pdocsorting_order','pdocsortby_ord')">Upload Date</th>
           <th class="sorting <%if(sort.equals("doc_name")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','doc_name','<%=order%>','pdocsorting_order','pdocsortby_ord')">Upload Doc. Name</th>
           <th>Action</th>
       </tr>
   </thead>
   <tbody>
   <%
   BlobClientBuilder client=AzureBlob.getBlobClient(azure_key, azure_container);
   int ssn=0;
   int showing=0;
   int startRange=pageNo-2;
   int endRange=pageNo+2;
   int totalPages=1;
   
   String files[][]=SeoOnPage_ACT.getAllFiles(refid,token,personalDoActionFiles,pageNo,rows,sort,order);
   int totalDocuments=SeoOnPage_ACT.countAllFiles(refid,token,personalDoActionFiles);
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
 				fileExist=client.blobName(fileName).buildClient().exists();
 				if(fileExist){
 					bytes=client.blobName(fileName).buildClient().getProperties().getBlobSize();
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
           <td><%=i+1 %></td>
           <td><i class="fas fa-file" aria-hidden="true"></i><%=extension %></td>
           <td><%=files[i][1] %></td>
           <td><%=size %></td>
           <td><%=files[i][6] %></td>
           <td><%=orgFileName %></td>
           <td>
           <form onsubmit="return false" class="uploadFileClass<%=i %>">
			<input type="file" name="uploadFileBox<%=i %>" onchange="fileSizeCompaitable('<%=files[i][0] %>','<%=i %>')" id="UploadFileBox<%=i %>" style="display: none;">	
			<a onclick="$('#UploadFileBox<%=i %>').click()"><i class="fas fa-file-upload" aria-hidden="true" title="Upload file" style="color: #0066ff;font-size: 22px;"></i></a> 
			<%if(!orgFileName.equalsIgnoreCase("NA")&&fileExist){ %><a href="<%=azure_path%><%=files[i][4]%>" download><i class="fas fa-file-download" aria-hidden="true" title="Upload file" style="color: #0066ff;font-size: 22px;"></i></a>
			<a onclick="deletePersonalFile('<%=files[i][0] %>','<%=files[i][4]%>')"><i class="fas fa-trash" aria-hidden="true" title="delete file" style="color: #0066ff;font-size: 22px;"></i></a>  <%} %>
			</form>
           </td>
       </tr>
    <%}}%>
                           
    </tbody>
</table>  
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
<div class="myModal modal fade" id="newFileUploadModal" aria-modal="false" style="padding-right: 17px; display: none;">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title"><i class="fas fa-folder-plus" aria-hidden="true"></i>New file</h4>  
          <button type="button" class="closeBox" data-dismiss="modal"><span aria-hidden="true">&times;</span></button>
        </div>
        <form method="post" onsubmit="return false" class="uploadPersonalFile">
        <input type="hidden" name="salesKey" value="<%=refid%>">
        <div class="modal-body">          
		  <div class="tab-content">		  
		  <div id="pay_method2">
		  <div class="row mb10">
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>File type</label>
            <input type="text" class="form-control" name="file_name" id="File_Name" placeholder="Name" autocomplete="off">
            </div>
            </div> 
            <div class="row mb10">
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>Short description</label>
            <input type="text" class="form-control" name="file_description" id="File_Description" placeholder="Description" autocomplete="off">
            </div>
            </div>
            <div class="row mb10">
			<div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>File</label>
            <input type="file" class="form-control" onchange="validateFileSize()" name="folder_file_name" id="Folder_File_Name" placeholder="Name" autocomplete="off">
            </div>            
		  </div> 
          </div>
		  </div>  		  
        </div>
        <div class="modal-footer flex-end">
          <button type="button" class="btn btn-cancel bt-link bt-radius" data-dismiss="modal">Cancel</button> 
          <button type="submit" class="bt-link bt-radius bt-loadmore" onclick="return validateUploadFile()">Submit</button> 
        </div>
        </form>
      </div>
    </div>
  </div>
<div class="modal fade" id="deleteWarningModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title text-danger" id="exampleModalLabel"><i class="fa fa-exclamation-triangle"></i>&nbsp;&nbsp;Are you sure want to delete this file ?</h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
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

function validateUploadFile(){
	   var folderName=$("#File_Name").val();  
	   var folderDesc=$("#File_Description").val();
	   var folderFileName=$("#Folder_File_Name").val();
	  
	   if(folderName==null||folderName==""){
		   document.getElementById('errorMsg').innerHTML = 'Please enter file type like aaddhar card !!.';
		   $('.alert-show').show().delay(2000).fadeOut();
		   return false;
	   }
	   if(folderDesc==null||folderDesc==""){
		   document.getElementById('errorMsg').innerHTML = 'Please write short description about file !!.';
		   $('.alert-show').show().delay(2000).fadeOut();
		   return false;
	   }
	   if(folderFileName==null||folderFileName==""){
		   document.getElementById('errorMsg').innerHTML = 'Please select file !!.';
		   $('.alert-show').show().delay(2000).fadeOut();
		   return false;
	   }
	   
		var form = $(".uploadPersonalFile")[0];
	    var data = new FormData(form);
		$.ajax({
	        type : "POST",
	        encType : "multipart/form-data",
	        url : "<%=request.getContextPath()%>/UploadPersonalFiles111",
	        cache : false,
	        processData : false,
	        contentType : false,
	        data : data,
	        success : function(data) {
	        	if(data=="pass"){
	        	location.reload(true);
	    		}else{
	    			document.getElementById('errorMsg').innerHTML ="Something Went wrong ,try-again later !!";
		    		$('.alert-show').show().delay(3000).fadeOut();
		    		return false;
	    		}
	        },
	        error : function(msg) {
	            alert("Couldn't upload file");
	        }
	    });
			
	}

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
	    			location.reload();
				}, 3000);
	    		}else{
	    			document.getElementById('errorMsg').innerHTML ="Something Went wrong ,try-again later !!";
		    		$('.alert-show').show().delay(3000).fadeOut();
	    		}
	        },
	        error : function(msg) {
	            alert("Couldn't upload file");
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
	var xhttp;
	xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
	if (this.readyState == 4 && this.status == 200) {
	location.reload();
	}
	};
	xhttp.open("GET", "<%=request.getContextPath()%>/RemoveFile111?uid="+id+"&name="+name, true);
	xhttp.send();
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
	});
}
function deletePersonalFile(skey,fileName){
	  $("#deleteWarningModal").modal('show'); 
	  $("#DeletePersonalFileKey").val(skey);
	  $("#DeletePersonalFileName").val(fileName);
}
function removePersonalFile(){
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
	}
function doAction(data,name){
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
	});
}
</script>

</body>
</html>