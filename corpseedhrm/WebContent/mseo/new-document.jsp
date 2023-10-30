<%@page import="admin.seo.SeoOnPage_ACT"%>
<%@page import="admin.task.TaskMaster_ACT"%>
<%@ include file="../../madministrator/checkvalid_user.jsp" %>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title></title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<%
String prno=request.getParameter("pr097bjno");
String clname=request.getParameter("cl09tyname");
String token=(String)session.getAttribute("uavalidtokenno");
String emproleid=(String)session.getAttribute("emproleid");
String loginuaid=(String)session.getAttribute("loginuaid");
String folder[][]=SeoOnPage_ACT.getAllFolder(token,emproleid,loginuaid,"NA","sales","NA",0,0); 
%> 
    <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="menuDv clearfix">
                    <div class="box-intro">
                      <h2><span class="title">Upload Document</span></h2>
                    </div>
                <div class="clearfix pad_box2" id="UploadDoc">
                       <form action="<%=request.getContextPath() %>/new-file.html" method="post"  name="follow-up-form" enctype="multipart/form-data">
                        <div class="row mtop10">
                        <div class="col-xs-6">
                        <div class="clearfix form-group">
                            <label>Document Type :<span style="color: red;">*</span></label>
                            <div class="clearfix relative_box">
                           	<select name="doctype" id="Doc_Type" class="form-control" onchange="showMessage(this.value)">
                          
                            
                            <option value="">Select Document Type</option>
                            <option value="General">General</option>                              
                            <option value="Certificate" <%if(prno!=""&&prno.length()>0&&prno!=null&&clname!=""&&clname.length()>0&&clname!=null) {%>selected="selected"<%} %>>Certificate</option>
                          </select>
                            </div>
                        </div>
                       </div>
                       <div class="col-xs-6">
                        <div class="clearfix form-group">
                            <label>Document Name :<span style="color: red;">*</span></label>
                            <div class="clearfix relative_box">
                           	<input type="text" name="docname" autocomplete="off" id="Doc_Name" class="form-control" placeholder="Document Name here !"/>
                            </div>
                        </div>
                       </div>
                        </div>
                        <div class="row mtop10">
           				 <div class="col-xs-4">
                        <div class="clearfix form-group">
                            <label>Select Folder :<span style="color: red;">*</span></label>
                            <div class="clearfix relative_box">
                           <select id="Folder" name="folder" onblur="requiredFieldValidation('Folder','folderErr');" class="form-control" onchange="getSubFolder(this.value)">
                            <option value="">Select Folder</option>
                            <%if(folder.length>0){ for(int i=0;i<folder.length;i++){
                            	if(clname!=""&&clname.length()>0&&clname!=null&&clname.equalsIgnoreCase(folder[i][1])) {%>                           
                            <option value="<%=folder[i][0]%>#<%=folder[i][1]%>" selected="selected"><%=folder[i][1]%></option>
                            <%}else{%>
                            <option value="<%=folder[i][0]%>#<%=folder[i][1]%>"><%=folder[i][1]%></option>                            	
                            <%}}} %>
                            </select>
                            <div id="folderErr" class="popup_error"></div>
                            </div>
                        </div>
                       </div>
                       <div class="col-xs-4">
                        <div class="clearfix form-group">
                            <label>Select Sub Folder :<span style="color: red;">*</span></label>
                            <div class="clearfix relative_box">
                           <select id="Sub_Folder" name="subfolder" onblur="requiredFieldValidation('Folder','folderErr');" class="form-control">
                            <option value="NA">Select Sub Folder</option>                            
                            </select>
                            <div id="subfolderErr" class="popup_error"></div>
                            </div>
                        </div>
                       </div>
                       <div class="col-xs-4">
                        <div class="clearfix form-group">
                            <label>Document :<i style="color: red;font-size: 11px;">(Max-Size 4Mb.)</i><span style="color: red;">*</span></label>
                            <div class="clearfix relative_box">
                            <input type="file" id="Document" onchange="fileSize(this)" autocomplete="off" name="document" onblur="requiredFieldValidation('Document','documentErr');" class="form-control" />
                            <div id="documentErr" class="popup_error"></div>
                            </div>
                            </div>  
                           </div>
                           </div>                       
                            <div class="clearfix form-group text-center">
                                  <button class="bt-link bt-radius bt-loadmore" type="submit" id="Upload" onclick="return documentValidation();">Upload</button>
                            </div>
                            </form>
                   </div>
            </div>
        </div>
    </div>
    <div class="alert-show"><div class="alert-bg alert-striped" id="errorMsg" style="width: 33%;"></div></div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
function showMessage(val){
	if(val=="Certificate"){
		document.getElementById('errorMsg').innerHTML ="Upload Certificate in Project's Folder.";
		document.getElementById('errorMsg').style.background="green";
		document.getElementById('errorMsg').style.color="white";
		$('.alert-show').show().delay(3000).fadeOut();
	}
}
function fileSize(file){
	const fi=document.getElementById('Document');
	if (fi.files.length > 0) {
		const fsize = fi.files.item(0).size; 
        const file = Math.round((fsize / 1024)); 
        // The size of the file. 
        if (file >= 4096) {  
            document.getElementById('errorMsg').innerHTML ='File too Big, please select a file less than 4mb';
            document.getElementById("Document").value="";
            document.getElementById('errorMsg').style.width="50%";
 		    $('.alert-show').show().delay(4000).fadeOut();
        }		
	}	
}
    </script>
<script type="text/javascript">	
	$('#cancelpopup').click(function(){
		  $.fancybox.close();
	});
</script>
<script type="text/javascript">
$( document ).ready(function() {
var prno="<%=prno%>";
if(prno!=""&&prno!=null){
	setTimeout(function(){ 
		var folder=document.getElementById("Folder").value.trim();
		var x=folder.split("#");
		frefid=x[0];
		showLoader();
		$.ajax({
			type : "POST",
			url : "GetSubFolderById111",
			dataType : "HTML",
			data : {				
				frefid:frefid,
				prno:prno
			},
			success : function(response){
				response = JSON.parse(response);			
				 var len = response.length;
				 if(len>0) {
					 var id = response[0]['id'];
					 var name = response[0]['value'];
					 $("#Sub_Folder").append("<option value='"+id+"#"+name+"' selected>"+name+"</option>");
				 }  				
			},
			complete : function(data){
				hideLoader();
			}
		});	
	}, 1000);
}
});
function getSubFolder(frefid){
	if(frefid!=""){
		var x=frefid.split("#");
		frefid=x[0];
		showLoader();
	$.ajax({
		type : "POST",
		url : "GetSubFolder111",
		dataType : "HTML",
		data : {				
			"frefid":frefid,
		},
		success : function(response){
			response = JSON.parse(response);			
			 var len = response.length;
			    $("#Sub_Folder").empty();
			    $("#Sub_Folder").append("<option value='NA'>"+"Select Sub Folder"+"</option>");
				for( var i =0; i<len; i++){
				var id = response[i]['id'];
				var name = response[i]['value'];
				$("#Sub_Folder").append("<option value='"+id+"#"+name+"'>"+name+"</option>");
				}
		},
		complete : function(data){
			hideLoader();
		}
	});}else{
		$("#Sub_Folder").empty();
	    $("#Sub_Folder").append("<option value='NA'>"+"Select Sub Folder"+"</option>");	   
	}
}

	function documentValidation() {

	if(document.getElementById('Doc_Type').value.trim()=="" ) {
		document.getElementById('errorMsg').innerHTML = 'Document Type is required..';
		$('.alert-show').show().delay(1000).fadeOut();
	return false;
	}
	if(document.getElementById('Doc_Name').value.trim()=="" ) {
		document.getElementById('errorMsg').innerHTML = 'Document Name is required.';
		$('.alert-show').show().delay(1000).fadeOut();
	return false;
	}
		
	if(document.getElementById('Folder').value.trim()=="" ) {
		document.getElementById('errorMsg').innerHTML = 'Select Folder/Sub-Folder To Upload File.';
		$('.alert-show').show().delay(1000).fadeOut();
	return false;
	}
	if(document.getElementById('Document').value.trim()=="" ) {
		document.getElementById('errorMsg').innerHTML = 'Document is required.';
		$('.alert-show').show().delay(1000).fadeOut();
	return false;
	}
	if(document.getElementById('Folder').value.trim()!=""&&document.getElementById('Document').value.trim()!=""){
		parent.jQuery.fancybox.close();
		document.getElementById('errorMsg').innerHTML = 'Certificate Successfully Uploaded.';			
		document.getElementById('errorMsg').style.background="green";
		document.getElementById('errorMsg').style.color="#ffff";
		$('.alert-show').show().delay(1000).fadeOut();
	}
}

</script>
</body>
</html>