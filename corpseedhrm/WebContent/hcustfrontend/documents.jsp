<!doctype html>
<%@page import="commons.CommonHelper"%>
<%@page import="java.util.Random"%>
<%@page import="admin.enquiry.Enquiry_ACT"%>
<%@page import="admin.task.TaskMaster_ACT"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.nio.file.Paths"%>
<%@page import="java.util.Properties"%>
<%@page import="java.nio.file.Path"%>
<%@page import="client_master.Clientmaster_ACT"%>
<%@page import="hcustbackend.ClientACT"%>
<html lang="en">
<head>  
  <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<%@ include file="includes/client-header-css.jsp" %>
    <title>corpSeed-documents</title>
</head>
<body id="mySite" style="display: block">
<%@ include file="includes/checkvalid_client.jsp" %> 
<!-- main content starts -->
<%
String salesrefid="NA";
String x=request.getParameter("uid");
salesrefid=x.substring(17,x.length()-5);

Properties properties = new Properties();
properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));
String docBasePath=properties.getProperty("docBasePath");
String token=(String)session.getAttribute("uavalidtokenno");

String productKey=TaskMaster_ACT.getSalesProductKey(salesrefid, token);
long pageLimit=10;
String pageLimit1=(String)session.getAttribute("documentPageLimit");
if(pageLimit1!=null&&pageLimit1.length()>0)pageLimit=Long.parseLong(pageLimit1);


long pageStart=1;
String pageStart1=(String)session.getAttribute("documentPageStart");
if(pageStart1!=null&&pageStart1.length()>0)pageStart=Long.parseLong(pageStart1);

long pageEnd=10;
String pageEnd1=(String)session.getAttribute("documentPageEnd");
if(pageEnd1!=null&&pageEnd1.length()>0)pageEnd=Long.parseLong(pageEnd1);

long count=pageEnd/pageLimit;
// String file[][]=ClientACT.getAllFiles(refid,token,clid);
String invoice=TaskMaster_ACT.getSalesInvoiceNumber(salesrefid, token);
// double orderAmount=TaskMaster_ACT.getOrderAmount(invoice, token);
double dueAmount=Clientmaster_ACT.getSalesDueAmount(invoice,token);
// double payPercent=((orderAmount-dueAmount)*100)/orderAmount;
boolean isExist=TaskMaster_ACT.isDisperseExist(salesrefid, token);
double orderPaidAmount[]=null;
if(isExist)
 	orderPaidAmount=TaskMaster_ACT.getSalesOrderAndPaidAmount(salesrefid,token); 
else
	orderPaidAmount=TaskMaster_ACT.getSalesOrderAndPaidAmountByInvoice(invoice,token);
double payPercent=100;
if(orderPaidAmount[1]!=0&&orderPaidAmount[0]!=0)
	payPercent=(orderPaidAmount[1]*100)/orderPaidAmount[0];

int milestone=0;
int progress=0;
int completedtask=0;

String DocOf=(String)session.getAttribute("DocOfClientAgent");
if(DocOf==null||DocOf.length()<=0)DocOf="Client";
String doActionDocuments=(String)session.getAttribute("doActionDocuments");
if(doActionDocuments==null||doActionDocuments.length()<=0)doActionDocuments="Projects";
// boolean paymentDone=Clientmaster_ACT.isPaymentDone(salesrefid, token);
// boolean workDone=TaskMaster_ACT.getProjectWorkCompleted();
Random randomGenerator = new Random();
long randomInt = randomGenerator.nextInt(100000000);
%>
<section class="main clearfix">
  
  <%@ include file="includes/client_header_menu.jsp" %> 
  <section class="main-order clearfix">
  <div class="container-fluid">
    <div class="container">
      <div class="row">
        <div class="col-12 p-0">
          <div class="doc_box box-orders">  
		  <div class="clearfix document_page">
		  
		  <div class="row mbt12">
		  <div class="col-lg-8 col-md-8 col-sm-12 col-12 order">
		  <ul class="clearfix filter_menu btnshift">
			<li <%if(DocOf.equalsIgnoreCase("Client")) {%>class="active"<%} %>><a  onclick="documentUploadBy('Client')">Customer uploaded</a></li>
			<li <%if(DocOf.equalsIgnoreCase("Agent")) {%>class="active"<%} %>><a onclick="documentUploadBy('Agent')">Agent uploaded</a></li>
		  </ul>  
		  </div>
		  <div class="col-lg-4 col-md-4 col-sm-12 col-12 mobileback">
		  	<a href="<%=request.getContextPath()%>/client_documents.html"" class="mobilebback " style="display: none;"><i class="fa fa-arrow-left ico_bdr"></i></a> 
		  	 <div class="pageheading">
          <h4>PRJ002</h4>
          </div>
          <div class="clearfix backbtn"> 
          	<%if(doActionDocuments.equalsIgnoreCase("Personal")){ %><a class="btn-default" data-toggle="modal" data-target="#newFileUploadModal">+&nbsp;Upload</a><%} %>
            <a class="btn-default" href="<%=request.getContextPath()%>/client_documents.html">Back</a>
            <a href="#" class="doticon">  <i class="fa fa-ellipsis-v " aria-hidden="true"></i></a>
		  </div>
		  </div>
		  </div>
		   
 <div class="row">
        <div class="col-sm-12 bg_whitee">
	<div class="table-responsive">
	<table class="ctable">
    <thead>
        <tr>
            <th class="td_hide">S.No.</th>
            <th class="td_hide">Document Type</th>
            <th>Document Name</th>
            <th class="td_hide">Upload Size</th>
            <th class="td_hide">Upload Date</th>
            <th class="td_hide">Upload Doc. Name</th>
            <th>Action</th>
        </tr>
    </thead>
    <tbody>
    <%
    boolean fileExist=false;
    String payType=Enquiry_ACT.getSalesPayType(salesrefid,token);
    String files[][]=ClientACT.getAllFiles(salesrefid,token,DocOf,pageLimit,pageStart);
    if(files!=null&&files.length>0){
 	   for(int i=0;i<files.length;i++){
 		   String fileName=files[i][3];
 			String extension="";
 			String size="";
 			Path path=null;
 			if(fileName!=null&&!fileName.equalsIgnoreCase("NA")&&fileName.length()>0&&fileName.contains(".")){
 				fileExist=CommonHelper.isFileExists(fileName);
 				long bytes=0;
 				if(fileExist){
 					bytes=CommonHelper.getBlobSize(fileName);
 				}
 				long kb=bytes/1024;
 				long mb=kb/1024;	
 				
 				if(mb>=1)size=mb+" MB";
 				else if(kb>=1) size=kb+" KB";
 				else size=bytes+" bytes";	
 				int index=files[i][3].lastIndexOf(".");
 				extension=files[i][3].substring(index);
 			}else fileExist=false;
//  			System.out.println("fileExist="+fileExist);
     %>
        <tr>
            <td class="td_hide"><%=(i+1) %></td>
            <td class="td_hide"><i class="fa fa-file" aria-hidden="true"></i><%=extension %></td>
            <td><%=files[i][1] %></td>
            <td class="td_hide"><%=size%></td>		
            <td class="td_hide"><%=files[i][5] %></td>	
            <td class="td_hide"><%if(fileName!=null&&fileName.length()>0&&!fileName.equalsIgnoreCase("NA")){%><%=files[i][3].substring(21) %><%} %></td>	
            <td class="doc_act_mobile">
            <form onsubmit="return false" class="uploadFileClass<%=i %>">	
			<%if(DocOf.equalsIgnoreCase("Client")){if(fileExist){ %>
			<a href="<%=docBasePath%><%=files[i][3]%>" download><i class="fas fa-file-download" aria-hidden="true" title="Download file"></i>&nbsp;Download</a><%} %> 
			<input type="file" name="uploadFileBox<%=i %>" onchange="fileSizeCompaitable('<%=files[i][0] %>','<%=i %>')" id="UploadFileBox<%=i %>" style="display: none;">	
			<a href="javascript:void(0)" onclick="$('#UploadFileBox<%=i %>').click()"><i class="fas fa-file-upload" aria-hidden="true" title="Upload file"></i>&nbsp;Upload</a> 
			<%}else if(DocOf.equalsIgnoreCase("Agent")&&fileExist){
				String milestoneName=TaskMaster_ACT.getMileStoneName(files[i][7],token);
				double percentage=TaskMaster_ACT.getProductWorkPercentage(productKey,milestoneName,token);
				if(percentage<=payPercent){%>
				<a href="<%=docBasePath%><%=files[i][3]%>" download="download"><i class="fas fa-file-download" aria-hidden="true" title="Download file"></i>&nbsp;Download</a>
				<%}else{%>
					<a href="javascript:void(0)" onclick="showPartialPayment('<%=invoice%>','<%=dueAmount%>')"><i class="fas fa-file-download text-muted" aria-hidden="true" title="Download file"></i>&nbsp;Download</a>
				<%}				
			}%>	
			</form> 
            </td>
            
            <%-- <td class="doc_act_mobile">
            <%if(doActionDocuments.equalsIgnoreCase("Personal")){
            	if(DocOf.equals("Agent")&&payType.equals("Partial Pay")&&dueAmount>0){%>
            	<a <%if(Double.parseDouble(files[i][6])<=50&&fileExist){ %>href="<%=docBasePath%><%=files[i][3]%>" download<%}else{ %>href="#"<%} %>><i class="fas fa-file-download" aria-hidden="true" title="Download file"></i>&nbsp;Download</a>
				<%}else{ %>
				<a href="<%=docBasePath%><%=files[i][3]%>" download><i class="fas fa-file-download" aria-hidden="true" title="Download file"></i></a>
				<%} %>
				<a onclick="deletePersonalFile('<%=files[i][0] %>','<%=files[i][3]%>')"><i class="fas fa-trash" aria-hidden="true" title="Delete file"></i></a> 
            <%}else{ %>
            <form onsubmit="return false" class="uploadFileClass<%=i %>">	
			<%if(DocOf.equalsIgnoreCase("Client")){ %>
			<input type="file" name="uploadFileBox<%=i %>" onchange="fileSizeCompaitable('<%=files[i][0] %>','<%=i %>')" id="UploadFileBox<%=i %>" style="display: none;">	
			<a onclick="$('#UploadFileBox<%=i %>').click()"><i class="fas fa-file-upload" aria-hidden="true" title="Upload file"></i>&nbsp;Upload</a> 
			<%}else if(DocOf.equalsIgnoreCase("Agent")&&fileExist){
				if(payType.equalsIgnoreCase("Partial Pay")){ 
					String milestoneName=TaskMaster_ACT.getMileStoneName(files[i][7],token);
					double percentage=TaskMaster_ACT.getProductWorkPercentage(productKey,milestoneName,token);
					if(percentage<=payPercent){%>
					<a href="<%=docBasePath%><%=files[i][3]%>" download><i class="fas fa-file-download" aria-hidden="true" title="Download file"></i>&nbsp;Download</a>
					<%}else{%>
						<a href="javascript:void(0)" onclick="showPartialPayment('<%=invoice%>','<%=dueAmount%>')"><i class="fas fa-file-download text-muted" aria-hidden="true" title="Download file"></i>&nbsp;Download</a>
					<%}
				}else{
					if(Double.parseDouble(files[i][6])<=payPercent){%>
						<a href="<%=docBasePath%><%=files[i][3]%>" download><i class="fas fa-file-download" aria-hidden="true" title="Download file"></i>&nbsp;Download</a>
					<%}else{%>
						<a href="javascript:void(0)" onclick="showPartialPayment('<%=invoice%>','<%=dueAmount%>')"><i class="fas fa-file-download text-muted" aria-hidden="true" title="Download file"></i>&nbsp;Download</a>
					<%}
				}
			}%>	
			</form> 
			<%}%>           
            </td> --%>			
        </tr>
     <%}}%>
                           
    </tbody>
</table>
</div>


<div class="col-md-12 row page-range">
            <div class="col-md-9"></div>
            <div class="col-md-1 col-md-offset-9">
				<select name="pageShow" id="PageShow"<%if(files.length>=10){ %> onchange="pageLimit(this.value)"<%} %>>
				    <option value="10" <%if(pageLimit==10){ %>selected<%} %>>10</option>
				    <option value="20" <%if(pageLimit==20){ %>selected<%} %>>20</option>
				    <option value="40" <%if(pageLimit==40){ %>selected<%} %>>40</option>
				    <option value="80" <%if(pageLimit==80){ %>selected<%} %>>80</option>
				</select>
			</div>
		    <div class="col-md-2 text-center">
		    <i class="fas fa-chevron-left pointers" <%if(pageStart>1){ %>onclick="backwardPage()"<%} %>></i><span><%=pageStart %>-<%=pageEnd %></span><i class="fas fa-chevron-right pointers" <%if(files!=null&&files.length>=pageLimit){ %>onclick="forwardPage()"<%} %>></i>
		    </div>
			  </div>
	</div>
</div>  
</div>
</div>
    </div>
    </div>
    </div>
    </div>
    </div>
    <div class="myModal modal fade" id="newFileUploadModal" aria-modal="false" style=" display: none;">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title"><i class="fas fa-folder-plus" aria-hidden="true"></i>New file</h4>  
          <button type="button" class="close" data-dismiss="modal">×</button>
        </div>
        <form method="post" onsubmit="return false" class="uploadPersonalFile">
        <input type="hidden" name="salesKey" value="<%=salesrefid%>">
        <div class="modal-body">          
		  <div class="tab-content">		  
		  <div id="pay_method2" class="fade show">
		  <div class="row mb10">
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>File type</label>
            <input type="text" class="form-control" name="file_name" id="File_Name" placeholder="Name" autocomplete="off">
            </div> 
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>Short description</label>
            <input type="text" class="form-control" name="file_description" id="File_Description" placeholder="Description" autocomplete="off">
            </div>
			<div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>File</label>
            <input type="file" class="form-control" onchange="validateFileSize()" name="folder_file_name" id="Folder_File_Name" placeholder="Name" autocomplete="off">
            </div>            
		  </div> 
          </div>
		  </div>  		  
        </div>
        <div class="modal-footer flex-end">
          <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button> 
          <button type="submit" class="btn btn-success" onclick="return validateUploadFile()">Submit</button> 
        </div>
        </form>
      </div>
    </div>
  </div>
   <div class="modal fade" id="deleteWarningModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title text-danger" id="exampleModalLabel"><i class="fas fa-exclamation-triangle"></i>&nbsp;&nbsp;Are you sure want to delete this file ?</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
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
 <div class="modal fade" id="PartialPaymemntModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title text-danger" id="exampleModalLabel"><i class="fas fa-exclamation-triangle"></i>&nbsp;&nbsp;Payment is due !!</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        Your payment is due because of that you are not able to download this certificate.
      </div>
      <div class="modal-footer">
      <input type="hidden" id="paymentInvoiceNo">
      <input type="hidden" id="paymentDue">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Ok</button>
        <button type="button" class="btn btn-primary" onclick="payNow()">Pay Now</button>
      </div>
    </div>
  </div>
</div> 
<!-- Payment Modal -->
  <div class="myModal modal fade" id="paymentModal">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title"><i class="fa fa-credit-card" aria-hidden="true"></i>+Add Payments</h4>  
          <button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>
        <form action="payment.html" target="_blank" method="post">
        <div class="modal-body">        
          <ul class="payment_tab nav nav-tabs">
		  <li><a data-toggle="tab" href="#pay_method3"><img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/paytm.png" alt=""></a></li>
		  </ul>
		  <div class="tab-content">
		  
		  <div id="pay_method3" class="tab-pane fade show active">
		  <div class="row">
            <div class="form-group-payment col-md-8 col-sm-7 col-12">
			<label>Mobile No.</label>
            <input type="text" class="form-control" name="MOBILE_NO" id="Mobile_No" required="required">
            </div>
            <div class="form-group-payment col-md-4 col-sm-5 col-12">
			<label>Amount</label>
            <input type="text" class="form-control" name="TXN_AMOUNT" id="Amount" required="required">
            </div>
            <input type="hidden" id="ORDER_ID" name="ORDER_ID" value="ORDS_<%= randomInt %>">
		  </div>
          </div>
		  </div>  		  
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-success" onclick="return isValidAmount()">Confirm Payment</button> 
        </div>
        </form>
      </div>
    </div>
  </div>
<!-- End Payment Modal -->
</section>

</section>
<%@ include file="includes/client-footer-js.jsp" %>
  <script type="text/javascript">
 
  function validateFileSize(){
	  var fileId="Folder_File_Name";
	  
		const fi=document.getElementById(fileId);
		if (fi.files.length > 0) {
			const fsize = fi.files.item(0).size; 
	        const file = Math.round((fsize / 1024)); 
	        
	        // The size of the file. 
	        if (file >= 49152) {  
	            document.getElementById('errorMsg').innerHTML ='File too Big, Max File Size 48 MB !!';
	            document.getElementById(fileId).value="";
	 		    $('.alert-show').show().delay(4000).fadeOut();
	        }	
		}	
 }
  
  function validateUploadFile(){
	   var folderName=$("#File_Name").val();  
	   var folderDesc=$("#File_Description").val();
	   var folderFileName=$("#Folder_File_Name").val();
	  
	   if(folderName==null||folderName==""){
		   document.getElementById('errorMsg').innerHTML = 'Please enter file type like aaddhar card  !!.';
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
	        if (file >= 49152) {  
	            document.getElementById('errorMsg').innerHTML ='File too Big, Max File Size 48 MB !!';
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
	 var page="<%=x%>";
	
	 var uploadFileClass="uploadFileClass"+k;
	   setTimeout(() => {	
		if($("#"+File).val()!=""){		
		var form = $("."+uploadFileClass)[0];
	    var data = new FormData(form);
	    data.append("docKey", docKey);
	    data.append("file", File);
	    data.append("assignKey","NA");
	    data.append("workStartPrice","0");
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
	        	$("#DocWalletDivId").load(location.href + " #DocWalletDivId1");
	    		$('.alert-show1').show().delay(3000).fadeOut();
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
  
  
  function validateUpload(){	     
	  if(document.getElementById("DocumentName").value.trim()==""){
		  document.getElementById('errorMsg').innerHTML = 'Document Name is required.';
		  $('.alert-show').show().delay(2000).fadeOut();
		  return false;
	  }
	  if(document.getElementById("DocumentType").value.trim()==""){
		  document.getElementById('errorMsg').innerHTML = 'Document Type is required.';
		  $('.alert-show').show().delay(2000).fadeOut();
		  return false;
	  }
	  if(document.getElementById("FolderName").value.trim()==""){
		  document.getElementById('errorMsg').innerHTML = 'Select Folder.';
		  $('.alert-show').show().delay(2000).fadeOut();
		  return false;
	  }
	  if(document.getElementById("DocumentFile").value.trim()==""){
		  document.getElementById('errorMsg').innerHTML = 'Choose File.';
		  $('.alert-show').show().delay(2000).fadeOut();
		  return false;
	  }
	  
  }
 function documentUploadBy(data){
		$.ajax({
			type : "POST",
			url : "documentUploadBy999",
			dataType : "HTML",
			data : {
				data : data,
			},
			success : function(response){
				location.reload();					
			}
		});	
 } 
  function restSearch(){
		$.ajax({
			type : "GET",
			url : "ManageClientDocumentCTRL.html",
			dataType : "HTML",
			data : {
				reset : "reset",
			},
			success : function(data){
				location.reload();					
			}
		});	
	}
  
  function setDtaeFromTo(){	
		if(document.getElementById("ClientDocFrom").value.trim()==""){
			document.getElementById('errorMsg').innerHTML = 'Select Start Date First.';
			document.getElementById("ClientDocTo").value="";
			$('.alert-show').show().delay(2000).fadeOut();		
		}else{
			var clientfrom=document.getElementById("ClientDocFrom").value.trim();
			var clientto=document.getElementById("ClientDocTo").value.trim();		
			if(clientfrom=="") clientfrom="NA";
			if(clientto=="")clientto="NA";			
			
			var clientto=document.getElementById("ClientDocTo").value.trim();
			
			
				$.ajax({
					type : "POST",
					url : "ManageClientDocumentCTRL.html",
					dataType : "HTML",
					data : {
						clientfrom : clientfrom,
						clientto : clientto,						
					},
					success : function(data){
						location.reload();					
					}
				});
				
			
		}
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
  
  $('.datepicker').datepicker({
	    format: 'yyyy-mm-dd',    
	});
	
	  function doAction(data,name){
			$.ajax({
			    type: "POST",
			    url: "<%=request.getContextPath()%>/SetOrderTypeSearch999",
			    data:  { 
			    	data : data,
			    	name : name
			    },
			    success: function (response) {        	  
		         location.reload(true);
		        },
			});
		}
	function pageLimit(data){
		  var start="<%=pageStart%>";
		  var limit="<%=pageLimit%>";
		  var end=Number(start)+Number(data);
		  if(Number(start)==1)end-=1;
		  doAction(data,'documentPageLimit');
		  doAction(end,'documentPageEnd');
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
			 doAction(start,'documentPageStart');
			 doAction(end,'documentPageEnd');
			 location.reload(true);
		 }
	function forwardPage(){  
		 var count="<%=count+1%>";
		 var limit="<%=pageLimit%>";
		 var start=(Number(count)-1)*Number(limit);
		 var end=Number(count)*Number(limit);
		 doAction(start,'documentPageStart');
		 doAction(end,'documentPageEnd');
		 location.reload(true);
	}
	function payNow(){
		$("#paymentModal").modal("show");
		var data=$("#paymentInvoiceNo").val();
		var due=$("#paymentDue").val();
		$("#Amount").val(Number(due).toFixed(2));
		$.ajax({
		    type: "POST",
		    url: "<%=request.getContextPath()%>/SetOrderTypeSearch999",
		    data:  { 
		    	data : data,
		    	name : "SalesKey"
		    },
		    success: function (response) {  
	        },
		});
	}
	function showPartialPayment(invoice,amount){
		$("#paymentInvoiceNo").val(invoice);
		$("#paymentDue").val(amount);
		$("#PartialPaymemntModal").modal("show");
	}
	function isValidAmount(){
		var dueAmount="<%=dueAmount%>";
		var amount=$("#Amount").val();
		var mobile=$("#Mobile_No").val();
		if(mobile==null||mobile==""){
			document.getElementById('errorMsg').innerHTML = 'Mobile No. is required !!';
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if(Number(amount)>Number(dueAmount)){
			document.getElementById('errorMsg').innerHTML = 'Maximum amount should be Rs. '+dueAmount;
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
	}
  </script>
  </body>

</html>