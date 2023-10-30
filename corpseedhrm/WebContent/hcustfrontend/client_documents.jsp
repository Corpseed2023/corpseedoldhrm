<!doctype html>

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
// String clientdocfrom=(String)session.getAttribute("clientdocfrom");
// String clientdocto=(String)session.getAttribute("clientdocto");
// if(clientdocfrom==null||clientdocfrom=="")clientdocfrom="NA";
// if(clientdocto==null||clientdocto=="")clientdocto="NA";
//get token no from session
String token=(String)session.getAttribute("uavalidtokenno");
String loginuaid = (String) session.getAttribute("loginuaid");
// String userRole=(String)session.getAttribute("userRole");
// if(userRole==null||userRole.length()<=0)userRole="NA";
//String uaempid=(String)session.getAttribute("cluaempid");
//get client no from session
//String clientid=ClientACT.getClientId(uaempid,token);

String doActionDocuments=(String)session.getAttribute("doActionDocuments");
if(doActionDocuments==null||doActionDocuments.length()<=0)doActionDocuments="Projects";

String searchFolderDocuments=(String)session.getAttribute("searchFolderDocuments");
if(searchFolderDocuments==null||searchFolderDocuments.length()<=0)searchFolderDocuments="NA";

String searchFromToDocDate=(String)session.getAttribute("searchFromToDocDate");
if(searchFromToDocDate==null||searchFromToDocDate.length()<=0)searchFromToDocDate="NA";

String searchDocumentSorting=(String)session.getAttribute("searchDocumentSorting");
if(searchDocumentSorting==null||searchDocumentSorting.length()<=0)searchDocumentSorting="desc";

long pageLimit=12;
String pageLimit1=(String)session.getAttribute("clientDocumentPageLimit");
if(pageLimit1!=null&&pageLimit1.length()>0)pageLimit=Long.parseLong(pageLimit1);


long pageStart=1;
String pageStart1=(String)session.getAttribute("clientDocumentPageStart");
if(pageStart1!=null&&pageStart1.length()>0)pageStart=Long.parseLong(pageStart1);

long pageEnd=12;
String pageEnd1=(String)session.getAttribute("clientDocumentPageEnd");
if(pageEnd1!=null&&pageEnd1.length()>0)pageEnd=Long.parseLong(pageEnd1);

long count1=pageEnd/pageLimit;

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
		  <div class="row mbt12 sticky_top">
		  <div class="col-lg-6 col-md-6 col-sm-12 col-12 order ">
		  
		  <ul class="clearfix filter_menu clent_dochide">
			<li <%if(doActionDocuments.equalsIgnoreCase("Projects")){ %>class="active"<%} %>><a onclick="doAction('Projects','doActionDocuments')">Projects</a></li>
			<%-- <li <%if(doActionDocuments.equalsIgnoreCase("Personal")){ %>class="active"<%} %>><a onclick="doAction('Personal','doActionDocuments')">Personal</a></li> 
		  	<%if(doActionDocuments.equalsIgnoreCase("Personal")){ %>
		  	<li><a data-toggle="modal" data-target="#newFolderModal">New folder</a></li>
		  	<%} %> --%>
		  </ul>
		  </div>
		  <div class="col-lg-6 col-md-6 col-sm-12 col-12">
          <div class="form-group-orders"> 
              <div class="m_width80 inbox_input" <%if(!searchFolderDocuments.equalsIgnoreCase("NA")){ %>style="display: block;"<%} %>>
              <input class="form-control-search" id="SearchOrder" <%if(!searchFolderDocuments.equalsIgnoreCase("NA")){ %>value="<%=searchFolderDocuments%>" onsearch="removeSearchOption('searchFolderDocuments')"<%} %> type="search" placeholder="Search by folder name.." aria-label="Search">
              <i class="fa fa-search" aria-hidden="true"></i> 			
			  </div> 
			  <i class="fas fa-long-arrow-alt-left" id="backico" <%if(!searchFolderDocuments.equalsIgnoreCase("NA")){ %>style="display: block;"<%} %>></i> 
			  <div class="inbox-chatlist"> 
			  <button type="button" id="search" <%if(searchDocumentSorting.equalsIgnoreCase("asc")){ %>onClick="doAction('desc','searchDocumentSorting')"<%}else{ %>onClick="doAction('asc','searchDocumentSorting')"<%} %> title="Search by order"><i class="fa fa-list icon-circle"></i></button>
			  <button class="calendar_box" type="button" title="Search by date"><i class="fa fa-calendar-times icon-circle"></i>
			  <input type="text" class="form-control" <%if(!searchFromToDocDate.equalsIgnoreCase("NA")){ %>value="<%=searchFromToDocDate %>"<%} %> name="date_range" id="date_range" readonly="readonly">
			  </button> 
			  <%if(!searchFromToDocDate.equalsIgnoreCase("NA")){ %>
			  <button type="button" title="Clear date" style="position: absolute;right: -41px;" onclick="removeSearchOption('searchFromToDocDate')"><i class="fas fa-times icon-circle" aria-hidden="true"></i></button>
			  <%} %>             
			  </div>
		  </div>
		   
		  	<a href="javascript:void(0)" class="mobilesearchico"><i class="fa fa-search " aria-hidden="true"></i> </a> 
		  	 <div class="pageheading">
          <h2>Document</h2>
          </div>
		  </div>
		  </div>
		  <div class="row">
        <div class="col-sm-12 bg_whitee">
        <div class="row"><div class="col-sm-12"><div class="inbox-chatlist calmobview"> 
		  <button type="button" class="bg-white" id="searchAndroid" <%if(searchDocumentSorting.equalsIgnoreCase("asc")){ %>onClick="doAction('desc','searchDocumentSorting')"<%}else{ %>onClick="doAction('asc','searchDocumentSorting')"<%} %> title="Search by order"><span>Name</span>
		  <%if(searchDocumentSorting.equalsIgnoreCase("asc")){ %>
		  <i class="fa fa-arrow-up" aria-hidden="true" title="ascending"></i><%}else{ %>
		  <i class="fa fa-arrow-down" aria-hidden="true" title="descending"></i>
		  <%} %>
		  </button>
		  <%-- <button class="calendar_box" type="button" title="Search by date"><i class="fa fa-calendar-times icon-circle" aria-hidden="true"></i>
		  <input type="text" class="form-control" <%if(!searchFromToDocDate.equalsIgnoreCase("NA")){ %>value="<%=searchFromToDocDate %>"<%} %> name="date_range_android" id="date_range_android" readonly="readonly">
		  </button> 
		  <%if(!searchFromToDocDate.equalsIgnoreCase("NA")){ %>
			  <button type="button" title="Clear date" style="position: absolute;right: -41px;" onclick="removeSearchOption('searchFromToDocDate')"><i class="fas fa-times icon-circle" aria-hidden="true"></i></button>
			  <%} %> --%> 
		    </div>            
		  </div>
      </div>
<div class="clearfix" id="DisplayDocument">

 <%String folder[][]=ClientACT.getAllFolders(loginuaid,token,searchFolderDocuments,doActionDocuments,searchFromToDocDate,searchDocumentSorting,pageLimit,pageStart,userRole);  
 if(folder!=null&&folder.length>0){
%>	 <div class="row page-max">
<%	 for(int i=0;i<folder.length;i++){
		 String ProjectName=ClientACT.getProductName(folder[i][3],token);
		 int count=ClientACT.countUploadFiles(folder[i][4], token);
		 if(ProjectName.equalsIgnoreCase("NA")){
			 ProjectName=folder[i][5].substring(8,10)+"-"+folder[i][5].substring(5,7)+"-"+folder[i][5].substring(0,4);
		 }
 %>
    <div class="col-md-3 col-sm-3 col-xs-12 docmob">  
	<div class="clearfix manage_document"> 
	<div class="document_inner">
	<a class="view_folder"  href="<%=request.getContextPath()%>/viewalldocuments-<%=folder[i][4] %>.html" title=""><i class="fa fa-folder"></i><span class="count_file"><%=count %></span></a>
<!-- 	<a class="pointers permision_box quick-view" href=""><i class="fa fa-lock"></i></a> -->
	</div>
	<div class="file_name"><%=folder[i][2] %></div> 
	<p><%=ProjectName %></p>
	</div>
	</div>   
<%}%></div>
<div class="col-md-12 row page-range">
     <div class="col-md-9"></div>
          <div class="col-md-1 col-md-offset-9">
		<select name="pageShow" id="PageShow"<%if(folder.length>=12){ %> onchange="pageLimit(this.value)"<%} %>>
		    <option value="12" <%if(pageLimit==12){ %>selected<%} %>>12</option>
		    <option value="24" <%if(pageLimit==24){ %>selected<%} %>>24</option>
		    <option value="48" <%if(pageLimit==48){ %>selected<%} %>>48</option>
		    <option value="96" <%if(pageLimit==96){ %>selected<%} %>>96</option>
		</select>
	</div>
    <div class="col-md-2 text-center">
    <i class="fas fa-chevron-left pointers" <%if(pageStart>1){ %>onclick="backwardPage()"<%} %>></i><span><%=pageStart %>-<%=pageEnd %></span><i class="fas fa-chevron-right pointers" <%if(folder!=null&&folder.length>=pageLimit){ %>onclick="forwardPage()"<%} %>></i>
    </div>
	  </div>
<%}else{ %>
<div class="clearfix text-center text-danger noDataFound">
              <img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/nodata.png" alt="">
              <p>Your documents are under progress !!</p></div>
<%} %>	
    
    </div>     
	</div>
    </div>
    </div>
    </div>
    </div>
    </div>
      </div>
    </div>
    <div class="myModal modal fade" id="newFolderModal" aria-modal="false" style="padding-right: 17px; display: none;">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title"><i class="fas fa-folder-plus" aria-hidden="true"></i>New folder</h4>  
          <button type="button" class="close" data-dismiss="modal">×</button>
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
          <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button> 
          <button type="submit" class="btn btn-success" onclick="return validateFolder()">Submit</button> 
        </div>
        </form>
      </div>
    </div>
  </div>
  </section>

</section>
<%@ include file="includes/client-footer-js.jsp" %>
  <script type="text/javascript">
  function isFolderExist(data){
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
			}
		});
  }
  function validateFolder(){
	  var folder_name=$("#Folder_Name").val();
	  if(folder_name==null||folder_name==""){
		  document.getElementById('errorMsg').innerHTML = 'Please enter folder name !!';
		  $('.alert-show').show().delay(2000).fadeOut();
		  return false;
	  }
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
			}
		}); 
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
  
  function restSearch(val){
	  var fname=document.getElementById("SearchOrder").value.trim();
		$.ajax({
			type : "POST",
			url : "ManageClientDocumentCTRL.html",
			dataType : "HTML",
			data : {				
				fname : fname,
				val : val
			},
			success : function(data){
				location.reload();					
			}
		});	
	}
  
//   function setDtaeFromTo(){	
// 		if(document.getElementById("ClientDocFrom").value.trim()==""){
// 			document.getElementById('errorMsg').innerHTML = 'Select Start Date First.';
// 			document.getElementById("ClientDocTo").value="";
// 			$('.alert-show').show().delay(2000).fadeOut();		
// 		}else{
// 			var clientfrom=document.getElementById("ClientDocFrom").value.trim();
// 			var clientto=document.getElementById("ClientDocTo").value.trim();		
// 			if(clientfrom=="") clientfrom="NA";
// 			if(clientto=="")clientto="NA";			
			
// 			var clientto=document.getElementById("ClientDocTo").value.trim();
// 			var fname=document.getElementById("SearchOrder").value.trim();
			
// 				$.ajax({
// 					type : "POST",
// 					url : "ManageClientDocumentCTRL.html",
// 					dataType : "HTML",
// 					data : {
// 						clientfrom : clientfrom,
// 						clientto : clientto,
// 						fname : fname,
// 						val : "Search"
// 					},
// 					success : function(data){
// 						location.reload();					
// 					}
// 				});
				
			
// 		}
// 	}
  
  $(function() {
  	$("#SearchOrder").autocomplete({
  		source : function(request, response) {			
  			if($('#SearchOrder').val().trim().length>=2)
  			$.ajax({
  				url : "getdocumentdetails.html",
  				type : "POST",
  				dataType : "JSON",
  				data : {
  					name : request.term,
  					token : "<%=token%>",
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
              if(!ui.item){ }else{
              	doAction(ui.item.value,'searchFolderDocuments');
              }
          },
          error : function(error){
  			alert('error: ' + error.responseText);
  		},
  	});
  });
  
  function removeSearchOption(data){
		$.ajax({
		    type: "POST",
		    url: "<%=request.getContextPath()%>/ClearOrderTypeSearch999",
		    data:  { 
		    	data : data
		    },
		    success: function (response) {        	  
	         location.reload(true);
	        },
		});	
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
	         location.reload(true);
	        },
		});
	}
  $('input[name="date_range"]').daterangepicker({
		autoApply: true,
		locale: {
	      format: 'DD-MM-YYYY' 
	    }  
	});
	$('#date_range').on('apply.daterangepicker', function(ev, picker) {
		var date=$("#date_range").val();
	    doAction(date,'searchFromToDocDate');
	});
	 /*  $('input[name="date_range_android"]').daterangepicker({
			autoApply: true,
			locale: {
		      format: 'DD-MM-YYYY' 
		    }  
		});
		$('#date_range_android').on('apply.daterangepicker', function(ev, picker) {
			var date=$("#date_range_android").val();
		    doAction(date,'searchFromToDocDate');
		}); */
	function pageLimit(data){
		  var start="<%=pageStart%>";
		  var limit="<%=pageLimit%>";
		  var end=Number(start)+Number(data);
		  if(Number(start)==1)end-=1;
		  doAction(data,'clientDocumentPageLimit');
		  doAction(end,'clientDocumentPageEnd');
		  location.reload(true);
	}
	function backwardPage(){
			 var count="<%=count1-1%>";
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
			 doAction(start,'clientDocumentPageStart');
			 doAction(end,'clientDocumentPageEnd');
			 location.reload(true);
		 }
	function forwardPage(){  
		 var count="<%=count1+1%>";
		 var limit="<%=pageLimit%>";
		 var start=(Number(count)-1)*Number(limit);
		 var end=Number(count)*Number(limit);
		 doAction(start,'clientDocumentPageStart');
		 doAction(end,'clientDocumentPageEnd');
		 location.reload(true);
	}
	
  </script>
  </body>

</html>