<!doctype html>

<%@page import="java.util.Properties"%>
<%@page import="admin.enquiry.Enquiry_ACT"%>
<%@page import="admin.master.Usermaster_ACT"%>
<%@page import="commons.DateUtil"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="hcustbackend.ClientACT"%>
<html lang="en">
<head>  
  <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<!-- for fakeloading -->
   
    <%@ include file="includes/client-header-css.jsp" %>
    
    <title>CorpSeed-inbox</title>
<style type="text/css">
.header,.box-orders,.messages{
margin-bottom: 0px !important;}

</style>
</head>
<body id="mySite" style="display: block">

<%@ include file="includes/checkvalid_client.jsp" %> 
<!-- main content starts -->
<%

Properties properties = new Properties();
properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));
String domain=properties.getProperty("domain");
String azure_path=properties.getProperty("azure_path");

String doAction=(String)session.getAttribute("ClientInboxDoAction");
if(doAction==null||doAction.length()<=0)doAction="All";
//getting data if request from orders
String forwardSalesKey=request.getParameter("skey");
String forwardProjectNo=request.getParameter("pno");
String forwardProjectName=request.getParameter("pname");
String forwardCloseDate=request.getParameter("cdate");

if(forwardSalesKey==null||forwardSalesKey.length()<=0&&!forwardSalesKey.equalsIgnoreCase("NA"))forwardSalesKey="NA";
if(forwardProjectNo==null||forwardProjectNo.length()<=0&&!forwardProjectNo.equalsIgnoreCase("NA"))forwardProjectNo="NA";
if(forwardProjectName==null||forwardProjectName.length()<=0&&!forwardProjectName.equalsIgnoreCase("NA"))forwardProjectName="NA";
if(forwardCloseDate==null||forwardCloseDate.length()<=0&&!forwardCloseDate.equalsIgnoreCase("NA"))forwardCloseDate="NA";

//get token no from session
String token=(String)session.getAttribute("uavalidtokenno");
//String uaempid=(String)session.getAttribute("cluaempid");
String loginuaid = (String) session.getAttribute("loginuaid");
// String userRole=(String)session.getAttribute("userRole");
// if(userRole==null||userRole.length()<=0)userRole="NA";

// String userName=Usermaster_ACT.getLoginUserName(loginuaid, token);
/* String clientrefid=ClientACT.getClientRefId(uaempid,token); */ 

// if(!forwardSalesKey.equalsIgnoreCase("NA")){
// 	forwardCloseDate=Enquiry_ACT.getSalesCloseDate(forwardSalesKey, token);
// }

/* String client[][]=ClientACT.getClientByNo(clientrefid,token); */

//fetching date
String today =DateUtil.getCurrentDateIndianFormat1();
String time=DateUtil.getCurrentTime();

// String projects[][]=ClientACT.getAllProjectsById(clientid,clientfrom,clientto,include,sortby,token,sprjno,sprjname);   

%>

<section class="main clearfix">
  
  <%@ include file="includes/client_header_menu.jsp" %>  
  
  <section class="main-order inbox clearfix">
  <div class="container-fluid">
    <div class="container">
      <div class="row">
        <div class="col-12 p-0">
          <div class="box-orders inbox-box">
            
<!-- message box starts -->
    <div class="row sticky_top">
  <div class="col-12">
    <div class="chatprocess pt-2">
			   
		  	<a href="javascript:void(0)" class="mobilesearchico"> <i class="fa fa-search " aria-hidden="true"></i> </a>
		  	 <div class="pageheading">
          <h2>Chat</h2>
          </div>
		  	</div>
		  	<form method="post" class="mobile_menuu">
			<ul class="mbt12 clearfix filter_menu pointers chatinbox">
			<li onclick="doAction('All','ClientInboxDoAction')" <%if(doAction.equalsIgnoreCase("All")){ %>class="active"<%} %>><a>All</a></li>  
			<li onclick="doAction('Unread','ClientInboxDoAction')" <%if(doAction.equalsIgnoreCase("Unread")){ %>class="active"<%} %>><a>Unread</a></li>
			<li onclick="doAction('Completed','ClientInboxDoAction')" <%if(doAction.equalsIgnoreCase("Completed")){ %>class="active"<%} %>><a>Completed</a></li> 
			</ul> 
            <div class="clearfix inbox_top_box"> 
			<div class="m_width80 inbox_input chatsearch">
            <input type="Search" class="form-control-inbox" id="SearchOrderMobile" autocomplete="off" oninput="getProjectList(this.value)" placeholder="Search"> 
            <i class="fa fa-search" aria-hidden="true"></i> 			
			</div>
			<i class="fas fa-long-arrow-alt-left chatico" id="backico"></i>
			
            <div class="inbox-chatlist"> 
              <button type="button"><i class="far fa-comment-alt icon-circle"></i></button>
              <button type="button"><i class="far fa-user icon-circle"></i></button>
            </div>
            </div>
            </form>
            </div>
		  	</div>
<!-- left part starts -->
          <div class="relative_box chat col-xl-12 col-lg-12 col-md-12 col-sm-12 col-12 pl-xl-3 pl-lg-3 pl-md-0 pl-sm-0 pl-xl-0 pl-lg-0 pl-md-3 pl-sm-3 pl-3">
			<div class="messages clearfix" id="message-border">
			
            <div class="clearfix box_width40">
			<form method="post" class="sys_menu">
			<ul class="mbt12 clearfix filter_menu pointers chatinbox">
			<li onclick="doAction('All','ClientInboxDoAction')" <%if(doAction.equalsIgnoreCase("All")){ %>class="active"<%} %>><a>All</a></li>  
			<li onclick="doAction('Unread','ClientInboxDoAction')" <%if(doAction.equalsIgnoreCase("Unread")){ %>class="active"<%} %>><a>Unread</a></li>
			<li onclick="doAction('Completed','ClientInboxDoAction')" <%if(doAction.equalsIgnoreCase("Completed")){ %>class="active"<%} %>><a>Completed</a></li> 
			</ul> 
            <div class="clearfix inbox_top_box"> 
			<div class="m_width80 inbox_input chatsearch">
            <input type="Search" class="form-control-inbox" id="SearchOrder" autocomplete="off" oninput="getProjectList(this.value)" placeholder="Search"> 
            <i class="fa fa-search" aria-hidden="true"></i> 			
			</div>
			<i class="fas fa-long-arrow-alt-left chatico" id="backico"></i>
			
            <div class="inbox-chatlist"> 
              <button type="button"><i class="far fa-comment-alt icon-circle"></i></button>
              <button type="button"><i class="far fa-user icon-circle"></i></button>
            </div>
            </div>
            </form> 
            <div class="row">
        <div class="col-sm-12 bg_whitee chat_bg">
			<div class="clearfix messages_box bg_wht mt-2 chat_detail">  
            <div class="clearfix message_titlebox">  
            <div class="clearfix" id="ProjectListBoxId"></div> 
       <%String projects[][]=ClientACT.getAllProjectsById(loginuaid,token,doAction,"NA","NA","desc",0,0,userRole);    
            if(projects!=null&&projects.length>0){
            	for(int i=0;i<projects.length;i++){ 
            	String productName=projects[i][7];
            	String profileName1=projects[i][7].substring(0,1);
            	if(projects[i][7].contains(" "))profileName1+=projects[i][7].substring(projects[i][7].indexOf(" ")+1,projects[i][7].indexOf(" ")+2);
            	else profileName1+=projects[i][7].substring(1,2);            	
            	%>
              <div class="message-title pointers nameOfProjects" id="<%=projects[i][0] %>" data-toggle="collapse" onClick="ShowAllChats('<%=projects[i][0] %>','<%=projects[i][2] %>','<%=projects[i][7] %>','BoxId<%=projects[i][2]%>','<%=projects[i][15] %>');">
                 <div class="clearfix pro_box mobile">
                    <div class="clearfix icon_box">
                     <figure> <span class="prof_name"><%=profileName1.toUpperCase() %></span> </figure>
                    </div> 
                    <div class="clearfix pro_info"> 
                    <h2 class="clearfix justify_box <%if(!projects[i][14].equalsIgnoreCase("0")){%>unseenChat<%}%>"><label class="pointers"> : <%=projects[i][2] %></label><span></span></h2>
                    <%if(!projects[i][14].equalsIgnoreCase("0")){%><span class="chatUnseen" id="BoxId<%=projects[i][2]%>"><%=projects[i][14] %></span><%} %>
                    <h6 class="clearfix justify_box  <%if(!projects[i][14].equalsIgnoreCase("0")){%>unseenChat<%}%>"><label class="pointers"><%=projects[i][7] %></label><span></span></h6>
                    </div>
                  </div>
               </div>
              <%}}else{ %>
              <div class="clearfix text-center text-danger noDataFound">You have no new message !!</div>
              <%} %>
             </div>
			 </div>
             </div>
              </div>
             </div>
             <div class="clearfix box_width60 bg_wht messages_box mbox_ht">                 
          
             <div id="NoChat" class="notSelectedProject">
             <h3 class="far fa-comment-dots text-warning" aria-hidden="true"></h3>
             <h5 class="text-primary">Select On Project To Chat !!</h5>
             </div>
			 
             <div class="bg_wht chat_box collapse show">
			 
			 <div class="message_head"> 
			 <div class="row"> 
			 <div class="col-lg-10 col-md-10 col-sm-10 barrow">
			 <h3 id="ActiveProjectId"></h3>
			<i class="fas fa-arrow-left" class="barrowicon"></i>
			 </div>
			 <div class="col-lg-2 col-md-2 col-sm-2 puser_hide">  
			 <div class="chat_user pointers">
			 <i class="fas fa-user-cog icon-circle userradius" aria-hidden="true"></i>			 
			 </div>
			 </div>
			 </div>
			 </div>
			 
             <div class="chat_detail"> 
             <div class="message-details"> 
             <div class="spinner-grow spinner-grow-sm" role="status">
  <span class="sr-only">Loading...</span>
</div> 
<div class="spinner-grow spinner-grow-sm" role="status">
  <span class="sr-only">Loading...</span>
</div>  
<div class="spinner-grow spinner-grow-sm" role="status">
  <span class="sr-only">Loading...</span>
</div>                          
             <div id="AddChat"></div>
             <div id="scrolling-messages" class="scrolling-messages"></div>
<!--              review start -->
			<form onsubmit="return false;" class="review-form-box">
			<div class="col-md-12 review-box">
             <div class="row">
			        <span class="circle"><%=userName.toUpperCase().charAt(0) %></span><span class="circle_name"><%=userName %></span>
			 </div>
			    
			<div class="col-md-12">
			<div class="clearfix ratingview">
			<div class="row">
			    <h6 id="Rating_Service">Rating : NBFC Basic</h6>
			</div>
			<div class="row">
			<div class="stars">
				<input type="radio" name="star" value="1" class="star-1" id="star1">
				<label class="star-1" for="star-1" onclick="checkedMe('star1','about_like','1')">1</label>
				<input type="radio" name="star" value="2" class="star-2" id="star2">
				<label class="star-2" for="star-2" onclick="checkedMe('star2','about_like','2')">2</label>
				<input type="radio" name="star" value="3" class="star-3" id="star3">
				<label class="star-3" for="star-3" onclick="checkedMe('star3','about_like','3')">3</label>
				<input type="radio" name="star" value="4" class="star-4" id="star4">
				<label class="star-4" for="star-4" onclick="checkedMe('star4','about_like','4')">4</label>
				<input type="radio" name="star" value="5" class="star-5" id="star5">
				<label class="star-5" for="star-5" onclick="checkedMe('star5','about_like','5')">5</label>
				<span></span>
			</div>
			</div>
			<div class="col-md-12 about_like d-none pad-left">
			<div class="row mtop_5">
			<h6><b>What do you like about this service?</b></h6>
			</div>
			<div class="row">
			<label class="pz89u"><input class="Xs8Y6d" type="checkbox" value="1" id="service1" onclick="checkedMe1('service1')"><span class=" b5bllf">Good quality</span></label>
			<label class="pz89u1"><input class="Xs8Y6d" type="checkbox" value="2" id="service2" onclick="checkedMe1('service2')"><span class=" b5bllf">Good value</span></label>
			<label class="pz89u1"><input class="Xs8Y6d" type="checkbox" value="3" id="service3" onclick="checkedMe1('service3')"><span class=" b5bllf">Professional</span></label>
			<label class="pz89u1"><input class="Xs8Y6d" type="checkbox" value="4" id="service4" onclick="checkedMe1('service4')"><span class=" b5bllf">Responsive</span></label>
			</div>
			</div>
			</div>
			</div>
			<div class="col-md-12">
			<div id="ExecutiveRating"></div>
			
			</div>			
			<div class="col-md-12 comment"><div class="row">
			    <textarea rows="4" cols="20" id="ratingComment" class="form-control" placeholder="Share details of your own experience about them.."></textarea>
			    </div>
			</div>
			<div class="col-md-12 text-right mtop1">
			    <button class="btn btn-primary" onclick="return validRating()">Submit</button>
			    
			</div>
	</div>
			</form>
<!-- review end -->
             </div>
             </div>
             </div>
             <div class="message-send" id="ChatBox" style="display: none;">
                <form class="form-inline addNewChatFollowUp" onsubmit="return false;">
                <input type="hidden" id="ProjectSalesKey" name="projectSalesKey"/>
                <%-- <input type="hidden" id="ProjectSalesClientKey" name="projectSalesClientKey" value="<%=clientrefid%>"/> --%>
                <div class="clearfix reply_box">
                      <div class="relative_box menu_list">
                      <textarea class="form-control-message" id="ChatReplay" name="chatReplyBox" placeholder="Type message here...." autocomplete="off" style="resize: none;overflow: hidden;"></textarea> 
                      <!-- <span id="AddSendMessageDivId"></span>
                      <span class="icon-circle toggle_btn1" aria-hidden="true" id="SelectedNameId" style="display: none;"></span>
                      <i class="icon-circle toggle_btn2" aria-hidden="true" id="NotSelectedId">
                      <span class="fas fa-user-alt" id="setSelectedName"></span></i> -->
<!--                       <ul class="toggle_box" id="WorkingOnThisProject"> -->
                      
<!--                       </ul> -->
                      <span class="attachment link_btn">
                      <i class="fas fa-paperclip" aria-hidden="true"></i>
                      <input type="hidden" name="attachment" />
                      </span>
						<div class="attachment_list table_box toggle_box clearfix">  
						 
						 <div class="clearfix" id="SalesDocListId"></div>
						 					 
						  <!-- <div class="table_content row"> 
							<div class="p-0 col-md-9 col-sm-8 col-12">
							<p><i class="fas fa-file text-success" aria-hidden="true"></i>&nbsp;Attach File</p>
							</div> 
							<div class="p-0 col-md-3 col-sm-4 col-12">      
							<p class="justify-content-end tmobile">
							<input type="file" name="attachment-file" onchange="fileSize('UploadFileId')" id="UploadFileId" style="display: none;"/> 
							<a class="upload_file" onclick="$('#UploadFileId').click()"><i class="fas fa-file-upload" aria-hidden="true" title="Upload"></i></a>
							</p>
							</div>
						  </div> -->
						  
						  <div class="table_content row">
						  <div class="p-0 col-md-12 col-sm-12">
						  <div class="custonupload"> 
							<span><i class="fas fa-file text-success" aria-hidden="true"></i>Attach Documents</span>					
                            <label for="files">
                            <span id="customfile"></span>
                             <i class="fas fa-file-upload" aria-hidden="true" title="Upload"></i></label>
                             <input id="files" name="attachment-file" style="visibility:hidden;" type="file"> 
                          </div> 
						  </div>
						  </div>
						  
						  
						</div>
                      </div>        
                      <input type="hidden" id="SelectedUserUid" name="selectedUserUid" value="NA">
                      <input type="hidden" id="SelectedUserName" name="selectedUserName" value="NA">                                      
                      <button type="button" class="btn default-search bg text-white" id="middle-search-message"><img src="<%=request.getContextPath()%>/hcustfrontend/fntdimages/sendd.png"/></button>
                      <div class="user_list" style="display:none">
				     <ul id="WorkingOnThisProject">
				    </ul>
				</div>
                </div>
                
			</form>
              </div>
             </div>
             
<!-- end message -->
            </div>  
            
			</div>
        </div>
    </div>
</div>
<!-- message box end -->
        </div>
      </div>
  </section>
  
</section>
<!-- main content ends -->

<div class="modal fade form_Builder set_form_Builder show" id="DynamicFormModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">
		<img src="<%=request.getContextPath() %>/staticresources/images/form.png" style="width: 19px;">
		<span class="text-danger">Form</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body warBody">
      
        <div id="AppendFormBuildDiv"></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary" id="getJson">Submit</button>
      </div>
    </div>
  </div>
</div>

<!-- script starts -->
<input type="hidden" id="ActiveProjectNo" value="NA"/>
<input type="hidden" id="ActiveProjectKey" value="NA"/>
<input type="hidden" id="ProjectFollowUpKey"/>
<input type="hidden" id="ServiceRatingUser"/>
<input type="hidden" id="ProjectFormSubmitStatusId"/>
<input type="hidden" id="StarRatingIdGenerator" value="5"/>
<input type="hidden" id="ServiceRatingIdGenerator" value="4"/>
<input type="hidden" id="scrollPageNumber" value="0"/>
<%@ include file="includes/client-footer-js.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/formBuilder/js/form-builder.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/app.js"></script>
<script type="text/javascript">
var formDataJson="";
var fbEditor ="";
var formBuilder ="";
document.getElementById('getJson').addEventListener('click', function() {
	formDataJson=formBuilder.actions.getData('json',true);		
	$("#DynamicFormModal").modal("hide");
	var fKey=$("#ProjectFollowUpKey").val();
	var formStatusId=$("#ProjectFormSubmitStatusId").val();
	$.ajax({
		type : "POST",
		url : "UpdateDynamicFormData999",
		dataType : "HTML",
		data : {				
			fKey : fKey,	
			formDataJson : formDataJson
		},
		success : function(response){
			if(response=="pass"){
				document.getElementById('errorMsg1').innerHTML = 'Successfully Form Submitted !!.';
				$("#"+formStatusId).addClass("fa fa-check-circle");
				$('.alert-show1').show().delay(1000).fadeOut();
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something Went Wrong , Please Try-again Later !!';
				$('.alert-show').show().delay(2000).fadeOut();
			}
		}
	});
});

function updateUnseenStatus(salesKey,chatSeenStatusId){
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/UpdateUnseenStatus999",
	    data:  { 
	    	salesKey : salesKey
	    	},
	    success: function (response) {         	  
          $("#"+chatSeenStatusId).hide();
          $('#'+salesKey+' .justify_box').removeClass('unseenChat');
        },
	});
}

function doAction(data,name){
	var domain="<%=domain%>";
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/SetOrderTypeSearch999",
	    data:  { 
	    	data : data,
	    	name : name
	    },
	    success: function (response) {        	  
	    	location.reload();
        },
	});
}
var activeSalesKey="NA";
function getProjectList(name){
	if(activeSalesKey=="NA")
	activeSalesKey = $("#ActiveProjectKey").val();
	   $.ajax({
		    type: "POST",
		    dataType: "html",
		    url: "<%=request.getContextPath()%>/GetSoldProjectList888",
		    data:  { 
		    	name : name
		    },
		    success: function (response) {
		    	if(Object.keys(response).length!=0){
		     	response = JSON.parse(response);			
				 var len = response.length;
				 $(".nameOfProjects").remove();
// 				 $("#ChatBox").hide();
// 				 $('.chat_box').removeClass("in");
// 				 $(".notSelectedProject").show();
				 if(len>0){	
					 var home="<%=request.getContextPath() %>";
					 for(var i=0;i<len;i++){
						 var key =response[i]["key"];
						 var projectnumber =response[i]["projectnumber"]; 
						 var productname =response[i]["productname"];
						 var unseenChat =response[i]["unseenChat"];
						 var closeDate=response[i]["closeDate"];
						 var chatSeenStatus="chatSeenStatus"+i;
						 var display="style='display:none;'";
						 var unseen="";
						 if(Number(unseenChat)!=0){display="";unseen="unseenChat";}
						$(''+ 
						 '<div class="message-title pointers nameOfProjects" id="'+key+'" data-toggle="collapse" onClick="ShowAllChats(\''+key+'\',\''+projectnumber+'\',\''+productname+'\',\''+chatSeenStatus+'\',\''+closeDate+'\');">'+
		                 '<div class="clearfix pro_box">'+
		                    '<div class="clearfix icon_box">'+
		                    ' <figure> <span class="prof_name">CO</span> </figure></div>'+
		                    '<div class="clearfix pro_info"> '+
		                    '<h2 class="clearfix justify_box '+unseen+'"><label class="pointers"> : '+projectnumber+'</label><span></span></h2>'+
		                    '<span class="chatUnseen" '+display+' id="'+chatSeenStatus+'">'+unseenChat+'</span>'+
		                    '<h6 class="clearfix justify_box  '+unseen+'"><label class="pointers">'+productname+'</label><span></span></h6>'+
		                    '</div>'+
		                  '</div>'+
		               '</div>'
						).insertBefore('#ProjectListBoxId');
						
					 }
					 if (typeof activeSalesKey === "undefined") {
						 activeSalesKey="NA";
						}else{
							$("#"+activeSalesKey).addClass("active");
						}
				 }else{
					 $(''+
							 '<div class="clearfix text-center nameOfProjects text-danger noDataFound">You have no new message !!</div>'
							 ).insertBefore('#ProjectListBoxId');
				 }	
				 
		    }}
	   });
}
function sendMsg(){
	var chatText=$("#ChatReplay").val();
	var sendTo=$("#SelectedUserName").val();
	var clientName="<%=userName%>";
	sendMessageClient(chatText,sendTo,"client",clientName);
}
function applyComment(uaid,uaname,listId){	
	
	$("#SelectedUserUid").val(uaid);
    $("#SelectedUserName").val(uaname);
	
	var content=$("#ChatReplay").val();
	
	if($("#SelectedUserUid").val()==null||$("#SelectedUserUid").val()=="NA"||$("#SelectedUserUid").val()==""){
		document.getElementById('errorMsg').innerHTML ="Select sender to send !!";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	
	if(content==null||content==""){
		document.getElementById('errorMsg').innerHTML ="Please Write Some Text !!";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	showLoader();
	var date="<%=today%>";
	var time="<%=time%>";
	var addedbyName="<%=userName%>";
	var form = $(".addNewChatFollowUp")[0];
    var data = new FormData(form);
    /* data.append("docKey", docKey)
    data.append("file", File); */
	$.ajax({
        type : "POST",
        encType : "multipart/form-data",
        url : "<%=request.getContextPath()%>/ClientChatReply.html",
        cache : false,
        processData : false,
        contentType : false,
        data : data,
        success : function(data) {
        	$('.user_list ').stop(true).slideToggle();
        	var x=data.split("#");
        	if(x[0]=="pass"){
			var size=x[1];
			var extension=x[2];
			var fileName=x[3];
        		$("#ChatReplay").val("");
        		var fileDownload="<%=azure_path%>"+fileName;
        		if(fileName!=null&&fileName!="NA")fileName=fileName.substring(Number(fileName.indexOf("_"))+1);
        		var activeProject=$("#ActiveProjectNo").val();
        		var sendTo=$("#SelectedUserName").val();        		
        		sendMessageClient(content,sendTo+"-"+activeProject,"client",addedbyName,fileDownload,size,extension,fileName);
        		$(".addNewChatFollowUp").trigger("reset");
        		
        <%-- 		if(fileName!=null&&fileName!=""&&fileName!="NA"){
        			var fileDownload="<%=azure_path%>"+fileName;
        			fileName=fileName.substring(21);
					$(''+
				             '<div class="clearfix pro_box text-right mb-3 RefreshDiv">'+
				             '<div class="clearfix icon_box">'+
				             '<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/male_icon2.png" alt="">'+
				             '</div> <div class="clearfix pro_info">'+
				             '<h6><strong>'+addedbyName+'</strong><span>'+content+'</span><div class="clearfix download_file">'+
								'<div class="download_box"><span><img src="<%=request.getContextPath()%>/staticresources/images/file.png"><span title="'+fileName+'">'+fileName+'</span></span>'+
								'<a href="'+fileDownload+'" download><img src="<%=request.getContextPath()%>/staticresources/images/download.png" alt=""></a></div>'+
								'<div class="download_size"><span>'+size+'  '+extension+'</span><span>'+time+'</span></div>'+
								'</div></h6>'+
				             '<div class="clearfix date_box"><span>'+date+'&nbsp;'+time+'</span></div></div>'+
				             '</div>').insertBefore("#AddChat");
				}else{
					$(''+
		             '<div id="" class="clearfix pro_box text-right mb-3 RefreshDiv">'+
		             '<div class="clearfix icon_box">'+
		             '<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/male_icon2.png" alt="">'+
		             '</div> <div class="clearfix pro_info">'+
		             '<h6><strong>'+addedbyName+'</strong><span>'+content+'</span></h6>'+
		             '<div class="clearfix date_box"><span>'+date+'&nbsp;'+time+'</span></div></div>'+
		             '</div>').insertBefore("#AddChat");
				} --%>
					
					$(".message-details").animate({ scrollTop: $('.message-details').prop("scrollHeight")}, 1000);
    		
    		}else if(data=="denied"){
    			document.getElementById('errorMsg').innerHTML ="You haven't permission to follow-up. If you have further query call us !!";
	    		$('.alert-show').show().delay(4000).fadeOut();
    		}else{
    			document.getElementById('errorMsg').innerHTML ="Something Went wrong ,try-again later !!";
	    		$('.alert-show').show().delay(4000).fadeOut();
    		}
        },
        error : function(msg) {
            alert("Couldn't upload file");
        }
    }); 
    hideLoader();
}

function fileSize(fileId){
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

function setFollowUpId(fKey,formStatusId){
		$("#ProjectFollowUpKey").val(fKey);
		$("#ProjectFormSubmitStatusId").val(formStatusId);
		$(".removeFormDiv").remove();
		$(''+
				'<div id="build-wrap" class="removeFormDiv"></div>'
		).insertBefore("#AppendFormBuildDiv");
	  fbEditor = document.getElementById('build-wrap');
	  formBuilder = $(fbEditor).formBuilder();	  
							
			$.ajax({
				type : "POST",
				url : "GetDynamicFormData111",
				dataType : "HTML",
				data : {				
					fKey : fKey,			
				},
				success : function(response){
					if(Object.keys(response).length!=0){
						response=JSON.parse(response);
						formDataJson=response[0]["formData"];
						formBuilder.actions.setData(formDataJson);
						  $("#DynamicFormModal").modal("show");				    		
				}}
			});	    
		
}

</script>
   <script type="text/javascript">
   function ShowAllChats(salesKey,projectNo,projectName,chatSeenStatusId,closeDate){
	   init(projectNo,"NA")
	   var closed=0;
	   $("#scrollPageNumber").val("0");
	   $("#ActiveProjectNo").val(projectNo);
	   $("#ActiveProjectKey").val(salesKey);
	   $(".footer_menu").addClass("d-none"); 
	   if(closeDate==null||closeDate=="NA"||closeDate==""){
		   $(".no-reply-box").hide();
		   $(".reply_box").show();
		   $(".review-form-box").hide();
	   }else {
		   closed=1;
		   $(".about_like ").addClass("d-none");
		   $("#ratingComment").val('');
		   $("#StarRatingIdGenerator").val("5");
		   $("#ServiceRatingIdGenerator").val("4");
		   $("#star1,#star2,#star3,#star4,#star5").prop("checked",false);
		   $("#service1,#service2,#service3,#service4").prop("checked",false);
		   $("#Rating_Service").html("Rating : "+projectName)
		   $(".reply_box").hide();
		   $(".review-form-box").show();			  
		   $(".no-reply-box").show();
			   
		   }	  
	   
	   $("#ProjectSalesKey").val(salesKey);
	   $("#ActiveProjectId").html(projectNo+" : "+projectName);	   
       $(".RefreshDiv").remove();
       var clientKey="";
       var loginuaid="<%=loginuaid%>";
	   $.ajax({
		    type: "POST",
		    dataType: "html",
		    url: "<%=request.getContextPath()%>/getAllChats111",
		    data:  { 
		    	salesKey: salesKey,	
		    	clientKey : clientKey
		    },
		    success: function (response) {
		    	if(Object.keys(response).length!=0){
		     	response = JSON.parse(response);			
				 var len = response.length;
				var addedby="NA";
				var k=0;
				$(".spinner-grow").hide();
				 if(len<=0){					 
					 $('#errorMsg').html('No Chat Found.');
					 document.getElementById("NoChat").style.display="none";
					 document.getElementById("ChatBox").style.display="block";
					 $(".RefreshDiv").remove();
						$('.alert-show').show().delay(3000).fadeOut();
				 }else{						 
					 document.getElementById("NoChat").style.display="none";
					 document.getElementById("ChatBox").style.display="block";
				  
				   for( var i =0; i<len; i++){		
					   var key =response[i]["key"];
					   var milestoneKey =response[i]["milestoneKey"];
					   var milestoneName =response[i]["milestoneName"];
					   var dynamicForm =response[i]["dynamicForm"];
					   var formName =response[i]["formName"];
					   var content =response[i]["content"];
					   var fileName =response[i]["fileName"];
					   var date =response[i]["date"];
					   var time =response[i]["time"];
					   var submitStatus =response[i]["submitStatus"];
					   var addedbyUid =response[i]["addedbyUid"];
					   var addedbyName =response[i]["addedbyName"];
					   var formStatus =response[i]["formStatus"];
					   var extension =response[i]["extension"];
					   var size =response[i]["size"];
					   var unread =response[i]["unread"];
					   var icon=addedbyName.substring(0,2);
					   var fileDownload="<%=azure_path%>"+fileName;
					   var file=fileName.substring(21);
					   
					   var formFillId="formFillId"+i;
					   addedby=addedbyUid;
					   var sn=len-i;
					   var formFilled="";
					   if(formStatus=="2"){formFilled="";}else if(formStatus=="1"){formFilled="fa fa-check-circle";}
					   var iddd="";
					   if(Number(unread)==2&&Number(k)==0){
						   iddd="id='AjayKumarTiwari'";
						   k=1;
					   }
					   
					   
					if(addedbyUid==loginuaid){
						if(fileName!=null&&fileName!=""&&fileName!="NA"){
							$(''+
					             '<div '+iddd+' class="clearfix pro_box text-right mb-3 RefreshDiv">'+
					             '<div class="clearfix icon_box">'+
					             ' <figure> <span class="prof_name">'+icon+'</span> </figure>'+
					             '</div> <div class="clearfix pro_info">'+
					             '<h6><strong>'+addedbyName+'</strong><span>'+content+'</span><div class="clearfix download_file">'+
									'<div class="download_box"><span><img src="<%=request.getContextPath()%>/staticresources/images/file.png"><span title="'+file+'">'+file+'</span></span>'+
									'<a href="'+fileDownload+'" download><img src="<%=request.getContextPath()%>/staticresources/images/download.png" alt=""></a></div>'+
									'<div class="download_size"><span>'+size+'  '+extension+'</span><span>'+time+'</span></div>'+
									'</div></h6>'+
					             '<div class="clearfix date_box"><span>'+date+'&nbsp;'+time+'</span></div></div>'+
					             '</div>').insertAfter("#AddChat");
						}else{
							$(''+
				             '<div '+iddd+' class="clearfix pro_box text-right mb-3 RefreshDiv">'+
				             '<div class="clearfix icon_box">'+
				             ' <figure> <span class="prof_name">'+icon+'</span> </figure>'+
				             '</div> <div class="clearfix pro_info">'+
				             '<h6><strong>'+addedbyName+'</strong><span>'+content+'</span></h6>'+
				             '<div class="clearfix date_box"><span>'+date+'&nbsp;'+time+'</span></div></div>'+
				             '</div>').insertAfter("#AddChat");
						}
					}else{
						if(dynamicForm!=null&&dynamicForm!=""&&dynamicForm!="NA"){
							if(fileName!=null&&fileName!=""&&fileName!="NA"){
								$(''+
										'<div '+iddd+' class="clearfix pro_box text-left mb-3 RefreshDiv">'+
							             '<div class="clearfix icon_box">'+
										' <figure> <span class="prof_name">'+icon+'</span> </figure></div>'+ 
										'<div class="clearfix pro_info"><h6><strong>'+addedbyName+'</strong> <span>'+content+'<p><a class="setData pointers" onclick="setFollowUpId(\''+key+'\',\''+formFillId+'\')" style="color: #4285f4;"><u title="Click Me to fill form data !!">'+formName+'</u>&nbsp;&nbsp;<i class="'+formFilled+'" id="'+formFillId+'" aria-hidden="true"></i></a></p></span>'+
										'<div class="clearfix download_file">'+
										'<div class="download_box"><span><img src="<%=request.getContextPath()%>/staticresources/images/file.png" alt=""><span title="'+file+'">'+file+'</span></span>'+
										'<a href="'+fileDownload+'" download=""><img src="<%=request.getContextPath()%>/staticresources/images/download.png" alt=""></a></div>'+
										'<div class="download_size"><span>'+size+'  '+extension+'</span><span>'+time+'</span></div>'+
										'</div>'+
										'</h6>'+
										'<div class="clearfix date_box"><span>'+date+'&nbsp;'+time+'</span></div></div>'+
							             '</div>').insertAfter("#AddChat");
							}else{
									$(''+
									'<div '+iddd+' class="clearfix pro_box text-left mb-3 RefreshDiv">'+
						             '<div class="clearfix icon_box">'+
									' <figure> <span class="prof_name">'+icon+'</span> </figure></div>'+ 
									'<div class="clearfix pro_info"><h6><strong>'+addedbyName+'</strong> <span>'+content+'<p><a class="setData pointers" onclick="setFollowUpId(\''+key+'\',\''+formFillId+'\')" style="color: #4285f4;"><u title="Click Me to fill form data !!">'+formName+'</u>&nbsp;&nbsp;<i class="'+formFilled+'" id="'+formFillId+'" aria-hidden="true"></i></a></p></span></h6>'+
									'<div class="clearfix date_box"><span>'+date+'&nbsp;'+time+'</span></div></div>'+
						             '</div>').insertAfter("#AddChat");
							}
						}else{
							if(fileName!=null&&fileName!=""&&fileName!="NA"){
								$(''+
									'<div '+iddd+' class="clearfix pro_box text-left mb-3 RefreshDiv">'+
						             '<div class="clearfix icon_box">'+
									' <figure> <span class="prof_name">'+icon+'</span> </figure></div>'+ 
									'<div class="clearfix pro_info"><h6><strong>'+addedbyName+'</strong> <span>'+content+'</span><div class="clearfix download_file">'+
									'<div class="download_box"><span><img src="<%=request.getContextPath()%>/staticresources/images/file.png" alt=""><span title="'+file+'">'+file+'</span></span>'+
									'<a href="'+fileDownload+'" download=""><img src="<%=request.getContextPath()%>/staticresources/images/download.png" alt=""></a></div>'+
									'<div class="download_size"><span>'+size+'  '+extension+'</span><span>'+time+'</span></div>'+
									'</div></h6>'+
									'<div class="clearfix date_box"><span>'+date+'&nbsp;'+time+'</span></div></div>'+
						             '</div>').insertAfter("#AddChat");
							}else{
								$(''+
										'<div '+iddd+' class="clearfix pro_box text-left mb-3 RefreshDiv">'+
							             '<div class="clearfix icon_box">'+
										' <figure> <span class="prof_name">'+icon+'</span> </figure></div>'+ 
										'<div class="clearfix pro_info"><h6><strong>'+addedbyName+'</strong> <span>'+content+'</span></h6>'+
										'<div class="clearfix date_box"><span>'+date+'&nbsp;'+time+'</span></div></div>'+
							             '</div>').insertAfter("#AddChat");
							}
						}
					}	
					}
				   if(Number(k)==1){
				   var container = $('.message-details');
				   var scrollTo = $("#AjayKumarTiwari");
		            // Calculating new position
		            // of scrollbar
		            var position = scrollTo.offset().top-container.offset().top+container.scrollTop();
		  
		            // Animating scrolling effect
		            container.animate({
		                scrollTop: position
		            });
		            if(chatSeenStatusId!="NA")
		            readUnreadStatus();
				   }else if(Number(closed)==1){ 
					   var container = $('.message-details');
					   var scrollTo = $(".review-form-box");
					   
			            // Calculating new position
			            // of scrollbar
			            var position = scrollTo.offset().top-container.offset().top+container.scrollTop();
			  
			            // Animating scrolling effect
			            container.animate({
			                scrollTop: position
			            });					   
				   }else{
					   if ($(window).width() > 767)
					   $(".message-details").animate({ scrollTop: $('.message-details').prop("scrollHeight")}, 0);
					   else
					   $("html, body").animate({ scrollTop: $(document).height() }, 0);
				   }
				  }
				 fillWorkingOnUser(salesKey,addedby,closed);
		    }},
		    error: function (error) {
		    	alert("error in ShowAllChats() " + error.responseText);
		    }
		});
	   showAllDocumentList(salesKey);
	   
	   $('.message-title').removeClass('active');
		$("#"+salesKey).addClass('active');
		$('.messages .chat_box').each(function(){
			if($(this).attr('id')==$('.message-title.active').attr('data-target')){
				$(this).addClass('in');
			}else{
				$('.messages .chat_box').removeClass('in');
			}
		});
	if(chatSeenStatusId!="NA")
	updateUnseenStatus(salesKey,chatSeenStatusId);
	showChatArea();   
   }   
	 $(document).ready(function(){
	   if ($(window).width() > 767) {
	  $(function($) {   
       $('.message-details').on('scroll', function() {
    	   if ($(this).scrollTop()==0) { 
    		   $(".spinner-grow").show();
    		   setTimeout(() => {
    			   loadWindowsChat();
			}, 500);
              
           }
       });
	  });
	   }else{		 
		   $(window).on('scroll', function() {
	    	   if ($(this).scrollTop()==0) { 
	    		   $(".spinner-grow").show();
	    		   setTimeout(() => {
	    			   loadAndroidChat();
				}, 500);	              
	           }
	       });		   
	   }
   });
	 
function loadWindowsChat(){
	if ($(".message-details").scrollTop()==0) {
		loadMoreChat();
	}else $("#scrollPageNumber").val("0");
}	 
function loadAndroidChat(){
	if ($(window).scrollTop()==0) { 
		loadMoreChat();
	}else $("#scrollPageNumber").val("0");
}	 
function loadMoreChat(){	
	var pageNumber=$("#scrollPageNumber").val();
    var salesKey=$("#ProjectSalesKey").val();
	var clientKey="";
	var loginuaid="<%=loginuaid%>";
	pageNumber=Number(pageNumber)+Number(1);
		
	$.ajax({
	    type: "GET",
	    dataType: "html",
	    url: "<%=request.getContextPath()%>/getChatsByPage111",
	    data:  { 
	    	salesKey: salesKey,	
	    	clientKey : clientKey,
	    	pageNumber : pageNumber
	    },
	    success: function (response) {
	    	if(Object.keys(response).length!=0){
	     	response = JSON.parse(response);			
			 var len = response.length;
			 $("#scrollPageNumber").val(pageNumber);
			var addedby="NA";
			var k=0;			 
			   for( var i =0; i<len; i++){		
				   var key =response[i]["key"];
				   var milestoneKey =response[i]["milestoneKey"];
				   var milestoneName =response[i]["milestoneName"];
				   var dynamicForm =response[i]["dynamicForm"];
				   var formName =response[i]["formName"];
				   var content =response[i]["content"];
				   var fileName =response[i]["fileName"];
				   var date =response[i]["date"];
				   var time =response[i]["time"];
				   var submitStatus =response[i]["submitStatus"];
				   var addedbyUid =response[i]["addedbyUid"];
				   var addedbyName =response[i]["addedbyName"];
				   var formStatus =response[i]["formStatus"];
				   var extension =response[i]["extension"];
				   var size =response[i]["size"];
				   var unread =response[i]["unread"];
				   var icon=addedbyName.substring(0,2);
				   var fileDownload="<%=azure_path%>"+fileName;
				   var file=fileName.substring(21);
				   
				   var formFillId="formFillId"+i;
				   addedby=addedbyUid;
				   var sn=len-i;
				   var formFilled="";
				   if(formStatus=="2"){formFilled="";}else if(formStatus=="1"){formFilled="fa fa-check-circle";}
				   	
				   var iddd="";
				   if(Number(i)==0){
					   iddd="id='AjayKumarTiwari'";					   
				   }
				   
				if(addedbyUid==loginuaid){
					if(fileName!=null&&fileName!=""&&fileName!="NA"){
						$(''+
				             '<div '+iddd+' class="clearfix pro_box text-right mb-3 RefreshDiv">'+
				             '<div class="clearfix icon_box">'+
				             ' <figure> <span class="prof_name">'+icon+'</span> </figure>'+
				             '</div> <div class="clearfix pro_info">'+
				             '<h6><strong>'+addedbyName+'</strong><span>'+content+'</span><div class="clearfix download_file">'+
								'<div class="download_box"><span><img src="<%=request.getContextPath()%>/staticresources/images/file.png"><span title="'+file+'">'+file+'</span></span>'+
								'<a href="'+fileDownload+'" download><img src="<%=request.getContextPath()%>/staticresources/images/download.png" alt=""></a></div>'+
								'<div class="download_size"><span>'+size+'  '+extension+'</span><span>'+time+'</span></div>'+
								'</div></h6>'+
				             '<div class="clearfix date_box"><span>'+date+'&nbsp;'+time+'</span></div></div>'+
				             '</div>').insertAfter("#AddChat");
					}else{
						$(''+
			             '<div '+iddd+' class="clearfix pro_box text-right mb-3 RefreshDiv">'+
			             '<div class="clearfix icon_box">'+
			             ' <figure> <span class="prof_name">'+icon+'</span> </figure>'+
			             '</div> <div class="clearfix pro_info">'+
			             '<h6><strong>'+addedbyName+'</strong><span>'+content+'</span></h6>'+
			             '<div class="clearfix date_box"><span>'+date+'&nbsp;'+time+'</span></div></div>'+
			             '</div>').insertAfter("#AddChat");
					}
				}else{
					if(dynamicForm!=null&&dynamicForm!=""&&dynamicForm!="NA"){
						if(fileName!=null&&fileName!=""&&fileName!="NA"){
							$(''+
									'<div '+iddd+' class="clearfix pro_box text-left mb-3 RefreshDiv">'+
						             '<div class="clearfix icon_box">'+
									' <figure> <span class="prof_name">'+icon+'</span> </figure></div>'+ 
									'<div class="clearfix pro_info"><h6><strong>'+addedbyName+'</strong> <span>'+content+'<p><a class="setData pointers" onclick="setFollowUpId(\''+key+'\',\''+formFillId+'\')" style="color: #4285f4;"><u title="Click Me to fill form data !!">'+formName+'</u>&nbsp;&nbsp;<i class="'+formFilled+'" id="'+formFillId+'" aria-hidden="true"></i></a></p></span>'+
									'<div class="clearfix download_file">'+
									'<div class="download_box"><span><img src="<%=request.getContextPath()%>/staticresources/images/file.png" alt=""><span title="'+file+'">'+file+'</span></span>'+
									'<a href="'+fileDownload+'" download=""><img src="<%=request.getContextPath()%>/staticresources/images/download.png" alt=""></a></div>'+
									'<div class="download_size"><span>'+size+'  '+extension+'</span><span>'+time+'</span></div>'+
									'</div>'+
									'</h6>'+
									'<div class="clearfix date_box"><span>'+date+'&nbsp;'+time+'</span></div></div>'+
						             '</div>').insertAfter("#AddChat");
						}else{
								$(''+
								'<div '+iddd+' class="clearfix pro_box text-left mb-3 RefreshDiv">'+
					             '<div class="clearfix icon_box">'+
								' <figure> <span class="prof_name">'+icon+'</span> </figure></div>'+ 
								'<div class="clearfix pro_info"><h6><strong>'+addedbyName+'</strong> <span>'+content+'<p><a class="setData pointers" onclick="setFollowUpId(\''+key+'\',\''+formFillId+'\')" style="color: #4285f4;"><u title="Click Me to fill form data !!">'+formName+'</u>&nbsp;&nbsp;<i class="'+formFilled+'" id="'+formFillId+'" aria-hidden="true"></i></a></p></span></h6>'+
								'<div class="clearfix date_box"><span>'+date+'&nbsp;'+time+'</span></div></div>'+
					             '</div>').insertAfter("#AddChat");
						}
					}else{
						if(fileName!=null&&fileName!=""&&fileName!="NA"){
							$(''+
								'<div '+iddd+' class="clearfix pro_box text-left mb-3 RefreshDiv">'+
					             '<div class="clearfix icon_box">'+
								' <figure> <span class="prof_name">'+icon+'</span> </figure></div>'+ 
								'<div class="clearfix pro_info"><h6><strong>'+addedbyName+'</strong> <span>'+content+'</span><div class="clearfix download_file">'+
								'<div class="download_box"><span><img src="<%=request.getContextPath()%>/staticresources/images/file.png" alt=""><span title="'+file+'">'+file+'</span></span>'+
								'<a href="'+fileDownload+'" download=""><img src="<%=request.getContextPath()%>/staticresources/images/download.png" alt=""></a></div>'+
								'<div class="download_size"><span>'+size+'  '+extension+'</span><span>'+time+'</span></div>'+
								'</div></h6>'+
								'<div class="clearfix date_box"><span>'+date+'&nbsp;'+time+'</span></div></div>'+
					             '</div>').insertAfter("#AddChat");
						}else{
							$(''+
									'<div '+iddd+' class="clearfix pro_box text-left mb-3 RefreshDiv">'+
						             '<div class="clearfix icon_box">'+
									' <figure> <span class="prof_name">'+icon+'</span> </figure></div>'+ 
									'<div class="clearfix pro_info"><h6><strong>'+addedbyName+'</strong> <span>'+content+'</span></h6>'+
									'<div class="clearfix date_box"><span>'+date+'&nbsp;'+time+'</span></div></div>'+
						             '</div>').insertAfter("#AddChat");
						}
					}
				}	
				}
			   var container = $('.message-details');
			   var scrollTo = $("#AjayKumarTiwari");
	            // Calculating new position
	            // of scrollbar
	            var position = scrollTo.offset().top-container.offset().top+container.scrollTop();
	  
	            // Animating scrolling effect
	            if ($(window).width() > 767){
		            container.animate({
		                scrollTop: position
		            },0);
	            }else{
	            	$("html,body").animate({
		                scrollTop: position
		            },0);	            	
	            }
	            
	            
	    }},
	    error: function (error) {
	    	alert("error in ShowAllChats() " + error.responseText);
	    }
	});
	
	$(".spinner-grow").hide();
}      
   
   function showAllDocumentList(salesKey){
	   $(".docAppended").remove();
	   $.ajax({
		    type: "POST",
		    dataType: "html",
		    url: "<%=request.getContextPath()%>/GetSalesDocumentList888",
		    data:  { 
		    	salesKey: salesKey
		    },
		    success: function (response) {
		    	if(Object.keys(response).length!=0){
		     	response = JSON.parse(response);			
				 var len = response.length;
				 if(len>0){					 
					 for(var i=0;i<len;i++){
						 var docKey =response[i]["docKey"];
						 var uploadDocName =response[i]["uploadDocName"]; 
						 var description =response[i]["description"];
						 var DocName =response[i]["DocName"];
						 
						 var fileDownload="#";
						 if(DocName!="NA"&&DocName!=null)
						 	fileDownload="<%=azure_path%>"+DocName;
						 
						 var displayFile="";
						 
						 if(DocName==null||DocName==""||DocName=="NA"){
							 displayFile="display : none;";
						 }else{
							 displayFile="display : block;";
						 }
						 
						 var UploadFileId="UploadFileId"+i;
						 var FileDownloadIdIcon="FileDownloadIdIcon"+i;
						 $(''+
						 '<div class="table_content docAppended row">'+ 
						 	'<div class="p-0 col-md-9 col-sm-8 col-12">'+
							'<p><i class="fas fa-file text-warning" aria-hidden="true"></i>&nbsp;'+uploadDocName+'</p>'+
							'</div>'+ 
							'<div class="p-0 col-md-3 col-sm-4 col-12">'+      
							'<p class="justify-content-end tmobile">'+
							'<a href="'+fileDownload+'" download class="pointers" style="'+displayFile+'" id="'+FileDownloadIdIcon+'"><i class="fas fa-file-download" aria-hidden="true" title="Download"></i></a> '+
							'<input type="file" onchange="fileSizeCompaitable(\''+docKey+'\',\''+UploadFileId+'\',\''+FileDownloadIdIcon+'\')" id="'+UploadFileId+'" name="'+UploadFileId+'" style="display: none;"/> '+
							'<a class="upload_file pointers" onclick="$(\'#'+UploadFileId+'\').click()"><i class="fas fa-file-upload" aria-hidden="true" title="Upload"></i>	</a>'+
							'</p>'+
							'</div>'+
						  '</div>').insertBefore("#SalesDocListId");
					 }
				 }			 
		    }}
	   });
   }
   function fileSizeCompaitable(docKey,fileId,IconId){
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
	        	uploadFile(docKey,fileId,IconId);
	        }		
		}	
   }
   function uploadFile(docKey,File,IconId){	
	   setTimeout(() => {	
		if($("#"+File).val()!=""){		
		var form = $(".addNewChatFollowUp")[0];
	    var data = new FormData(form);
	    data.append("docKey", docKey)
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
	        	var x=data.split("#")
	        	if(x[0]=="pass"){
	        	document.getElementById('errorMsg1').innerHTML ="Uploaded Successfully !!";
	        	var href="<%=azure_path%>"+x[1];
	        	$("#"+IconId).attr("href",href);
	        	$("#"+IconId).show();	        	
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
   
   function fillWorkingOnUser(salesKey,addedbyUid,closed){
	   $("#WorkingOnThisProject").empty();
	   $(".rating_star").remove();
	   $("#ServiceRatingUser").val("0");
	   var service=0;
	   var serviceRatingKey="NA";
	   if(Number(closed)==1)
	   $.ajax({
		    type: "GET",
		    dataType: "html",
		    url: "GetServiceRating999",
		    data:  { 
		    	salesKey: salesKey,
		    	"type" : "service"
		    },
		    success: function (response) {
		    	if(Object.keys(response).length!=0){
			     	response = JSON.parse(response);
			     	var len = response.length;	    		;
		    		if(len>0){
						service=1;
		    			var rating =response[0]["rating"];
		    			var comment =response[0]["comment"];
		    			serviceRatingKey=response[0]["uuid"];
		    			if(Number(rating)==1)$("#star1").prop("checked",true);
		    			else if(Number(rating)==2)$("#star2").prop("checked",true);
		    			else if(Number(rating)==3)$("#star3").prop("checked",true);
		    			else if(Number(rating)==4)$("#star4").prop("checked",true);
		    			else if(Number(rating)==5)$("#star5").prop("checked",true);
		    			$("#ratingComment").val(comment);
		    			if(Number(rating)>3){
		    				showAboutLikes(serviceRatingKey,"Service",0,0,"NA");
		    			}		    			 
		    		}
		    	}
		    }
	   });
	   setTimeout(() => {
		   allWorkingUser(salesKey,addedbyUid,closed,serviceRatingKey,service);
	}, 200);
	   
   }
   function allWorkingUser(salesKey,addedbyUid,closed,serviceRatingKey,service){
	   $.ajax({
		    type: "POST",
		    dataType: "html",
		    url: "getAllWorkingUser888",
		    data:  { 
		    	salesKey: salesKey
		    },
		    success: function (response) {
		    	if(Object.keys(response).length!=0){
		     	response = JSON.parse(response);			
				 var len = response.length;
				 if(len>0){						 
					 var k=0;
					 var active=1;
					 for(var i=0;i<len;i++){						
						 var uaid =response[i]["uaid"];
						 var uaname =response[i]["uaname"]; 
						 var status =response[i]["status"]; 
						 var login_class="offline";
						 if(status=="1")login_class="online";
						 var title=uaname.substring(0,2);	
						 var ListItem="ListItem"+i;
						 $("#WorkingOnThisProject").append('<li><span class="'+login_class+'" title="'+login_class+'"></span><a id="'+ListItem+'" onclick="applyComment(\''+uaid+'\',\''+uaname+'\',\''+ListItem+'\')">'+uaname+'</a></li>')
						/*  if(uaid==addedbyUid&&k==0){ 
							 k=1;
							 $("#SelectedNameId").html(title);
						 	$("#NotSelectedId").hide();
// 						 	$("#SelectedNameId").show();						 	
						 }else if(k==0){
							 $("#NotSelectedId").show();
							 $("#SelectedNameId").hide();	
						 }
						 if(uaid==addedbyUid&&active==1){ 
							 active=2;
							 $("#SelectedUserUid").val(uaid);
							 $("#SelectedUserName").val(uaname);
							 $("#WorkingOnThisProject").append('<li><a class="active" id="'+ListItem+'" onclick="setSendUser(\''+uaid+'\',\''+uaname+'\',\''+ListItem+'\')">'+uaname+'</a></li>')					 	
						 }else{
					  		$("#WorkingOnThisProject").append('<li><a id="'+ListItem+'" onclick="setSendUser(\''+uaid+'\',\''+uaname+'\',\''+ListItem+'\')">'+uaname+'</a></li>')
						 } */ 

						 if(Number(closed)==1){
							 appendRating(uaname,uaid,i,serviceRatingKey,service);
						 }		
						 
					 }
				 }
				 /* else{
					 $("#NotSelectedId").show();
					 $("#SelectedNameId").hide();	
				 }	 */			 
		    }}
	   });
   }
   
   function appendRating(uaname,uaid,i,serviceRatingKey,service){	   
	   setTimeout(function() {
	   var str=$("#StarRatingIdGenerator").val();
	   var ser=$("#ServiceRatingIdGenerator").val();
	   
	   var num=$("#ServiceRatingUser").val(); 
		$("#ServiceRatingUser").val(Number(num)+1);
		 
		$(''+
			'<div class="clearfix rating_star ratingview">'+
			'<div class="row mtop1">'+
			   '<h6>Rating For executive '+uaname+'</h6>'+
			   '<input type="hidden" id="Executive'+(Number(num)+1)+'" value="'+uaid+'">'+
			'</div>'+
			'<div class="row">'+
			'<div class="stars">'+
				'<input type="radio" name="star'+(Number(num)+1)+'" value="1" class="star-1" id="star'+((Number(str)+1))+'">'+
				'<label class="star-1" for="star-1" onclick="checkedMe(\'star'+((Number(str)+1))+'\',\'about_like'+(Number(num)+1)+'\',\'1\')">1</label>'+
				'<input type="radio" name="star'+(Number(num)+1)+'" value="2" class="star-2" id="star'+((Number(str)+2))+'">'+
				'<label class="star-2" for="star-2" onclick="checkedMe(\'star'+((Number(str)+2))+'\',\'about_like'+(Number(num)+1)+'\',\'2\')">2</label>'+
				'<input type="radio" name="star'+(Number(num)+1)+'" value="3" class="star-3" id="star'+((Number(str)+3))+'">'+
				'<label class="star-3" for="star-3" onclick="checkedMe(\'star'+((Number(str)+3))+'\',\'about_like'+(Number(num)+1)+'\',\'3\')">3</label>'+
				'<input type="radio" name="star'+(Number(num)+1)+'" value="4" class="star-4" id="star'+((Number(str)+4))+'">'+
				'<label class="star-4" for="star-4" onclick="checkedMe(\'star'+((Number(str)+4))+'\',\'about_like'+(Number(num)+1)+'\',\'4\')">4</label>'+
				'<input type="radio" name="star'+(Number(num)+1)+'" value="5" class="star-5" id="star'+((Number(str)+5))+'">'+
				'<label class="star-5" for="star-5" onclick="checkedMe(\'star'+((Number(str)+5))+'\',\'about_like'+(Number(num)+1)+'\',\'5\')">5</label>'+
				'<span></span>'+
			'</div>'+
			'</div>'+
			'<div class="col-md-12 about_like'+(Number(num)+1)+' d-none pad-left">'+
			'<div class="row mtop_5">'+
			'<h6><b>What do you like about this executive?</b></h6>'+
			'</div>'+
			'<div class="row">'+
			'<label class="pz89u"><input class="Xs8Y6d" type="checkbox" value="1" id="service'+((Number(ser)+1))+'" onclick="checkedMe1(\'service'+((Number(ser)+1))+'\')"><span class=" b5bllf">Good quality</span></label>'+
			'<label class="pz89u1"><input class="Xs8Y6d" type="checkbox" value="2" id="service'+((Number(ser)+2))+'" onclick="checkedMe1(\'service'+((Number(ser)+2))+'\')"><span class=" b5bllf">Good value</span></label>'+
			'<label class="pz89u1"><input class="Xs8Y6d" type="checkbox" value="3" id="service'+((Number(ser)+3))+'" onclick="checkedMe1(\'service'+((Number(ser)+3))+'\')"><span class=" b5bllf">Professional</span></label>'+
			'<label class="pz89u1"><input class="Xs8Y6d" type="checkbox" value="4" id="service'+((Number(ser)+4))+'" onclick="checkedMe1(\'service'+((Number(ser)+4))+'\')"><span class=" b5bllf">Responsive</span></label>'+
			'</div>'+
			'</div>'+
			'</div>'
			).insertBefore("#ExecutiveRating");
		
		if(Number(service)==1)fillRating(serviceRatingKey,str,ser,(Number(num)+1),uaid);
		 $("#StarRatingIdGenerator").val(((Number(str)+5)));
		 $("#ServiceRatingIdGenerator").val(((Number(ser)+4)));
	   }, 200 * i);
   }
   function fillRating(serviceRatingKey,str,ser,num,e_uaid){	   
	   $.ajax({
		    type: "GET",
		    dataType: "html",
		    url: "<%=request.getContextPath()%>/GetServiceRating999",
		    data:  { 
		    	serviceRatingKey: serviceRatingKey,
		    	"type" : "executive",
		    	e_uaid : e_uaid
		    },
		    success: function (response) {
		    	if(Object.keys(response).length!=0){
			     	response = JSON.parse(response);
			     	var len = response.length;	    		;
		    		if(len>0){	
		    			service=1;
		    			var rating =response[0]["rating"];
		    			execRatingKey=response[0]["uuid"];
		    			var uaid =response[0]["uaid"];
		    			if(Number(rating)==1)$("#star"+((Number(str)+1))).prop("checked",true);
		    			else if(Number(rating)==2)$("#star"+((Number(str)+2))).prop("checked",true);
		    			else if(Number(rating)==3)$("#star"+((Number(str)+3))).prop("checked",true);
		    			else if(Number(rating)==4)$("#star"+((Number(str)+4))).prop("checked",true);
		    			else if(Number(rating)==5)$("#star"+((Number(str)+5))).prop("checked",true);
		    			
		    			if(Number(rating)>3){
		    				showAboutLikes(execRatingKey,"Executive",ser,num,e_uaid);
		    			}
		    		}
		    	}
		    }});
   }
   function showAboutLikes(serviceRatingKey,type,ser,num,uaid){
	
	   $.ajax({
		    type: "GET",
		    dataType: "html",
		    url: "<%=request.getContextPath()%>/GetServiceRatingAbout999",
		    data:  { 
		    	serviceRatingKey: serviceRatingKey,
		    	type : type,
		    	uaid : uaid
		    },
		    success: function (response) {
		    	if(Object.keys(response).length!=0){
			     	response = JSON.parse(response);
			     	var len = response.length;
		    		if(len>0){	
		    			for(var i=0;i<len;i++){
		    				var value=response[i]["value"];
		    				
		    				if(value=="Good quality")
		    				$("#service"+((Number(ser)+1))).prop("checked",true);
		    				else if(value=="Good value")
			    				$("#service"+((Number(ser)+2))).prop("checked",true);
		    				else if(value=="Professional")
			    				$("#service"+((Number(ser)+3))).prop("checked",true);
		    				else if(value=="Responsive")
			    				$("#service"+((Number(ser)+4))).prop("checked",true);
		    			}	
		    			var classRemove="about_like";
		    			if((Number(num))!=0){
		    				classRemove+=Number(num);
		    			}		
		    			$("."+classRemove).removeClass("d-none");
		    			
		    		}
		    	}
		    }
	   });
   }
   
   function setSendUser(uaid,uaname,listId){	   
	   $("#SelectedUserUid").val(uaid);
	   $("#SelectedUserName").val(uaname);
	   var title=uaname.substring(0,2);	
// 	   $("#SelectedNameId").html(title);
	   
	   
	 /* $("#NotSelectedId").hide();	
	   $("#SelectedNameId").show();
	 	$(".menu_list li a").removeClass('active');
	 	$("#"+listId).addClass('active');
	 
	 	
		$.ajax({
			type : "GET",
			url : "GetEmployeeActiveStatus999",
			dataType : "HTML",
			data : {
				uaid : uaid
			},
			success : function(data){
				if(Number(data)==1){
					$("#onlineOffline").addClass("online");
				 	$("#onlineOffline").attr("title","Online");
				}else{
					$("#onlineOffline").removeClass("online");
					$("#onlineOffline").addClass("offline");
				 	$("#onlineOffline").attr("title","Offline");
				}
			}
		}); */
	 	
   }     

    function sortBy(){
    	var clientfrom=document.getElementById("ClientFrom").value.trim();
    	var clientto=document.getElementById("ClientTo").value.trim();
    	if(clientfrom=="") clientfrom="NA";
    	if(clientto=="")clientto="NA";
    	var include="No";
    	var searchorder=document.getElementById("SearchOrder").value.trim();
    	var sprjno="NA";
    	var sprjname="NA";
    	if(searchorder!=""){
    		var x=searchorder.split("#");
    		sprjno=x[0];
    		sprjname=x[1];
    	}
    	if(document.getElementById('gridCheck').checked)include="Yes";
    	var sortby=document.getElementById("SortedBy").value.trim();
    	
    		$.ajax({
    			type : "POST",
    			url : "ManageClientInboxCTRL.html",
    			dataType : "HTML",
    			data : {
    				clientfrom : clientfrom,
    				clientto : clientto,
    				include : include,
    				sortby : sortby,
    				sprjno : sprjno,
    				sprjname : sprjname,
    			},
    			success : function(data){
    				location.reload();					
    			}
    		});
    }
    function restSearch(){
    	$.ajax({
    		type : "GET",
    		url : "ManageClientInboxCTRL.html",
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
    	if(document.getElementById("ClientFrom").value.trim()==""){
    		document.getElementById('errorMsg').innerHTML = 'Select Start Date First.';
    		document.getElementById("ClientTo").value="";
    		$('.alert-show').show().delay(2000).fadeOut();		
    	}else{
    		var clientfrom=document.getElementById("ClientFrom").value.trim();
    		var clientto=document.getElementById("ClientTo").value.trim();		
    		if(clientfrom=="") clientfrom="NA";
    		if(clientto=="")clientto="NA";
    		
    		var searchorder=document.getElementById("SearchOrder").value.trim();
    		var sprjno="NA";
    		var sprjname="NA";
    		if(searchorder!=""){
    			var x=searchorder.split("#");
    			sprjno=x[0];
    			sprjname=x[1];
    		}
    		var clientto=document.getElementById("ClientTo").value.trim();
    		
    		var include="No";
    		if(document.getElementById('gridCheck').checked)include="Yes";
    		var sortby=document.getElementById("SortedBy").value.trim();
    		
    			$.ajax({
    				type : "POST",
    				url : "ManageClientInboxCTRL.html",
    				dataType : "HTML",
    				data : {
    					clientfrom : clientfrom,
    					clientto : clientto,
    					include : include,
    					sortby : sortby,
    					sprjno : sprjno,
    					sprjname : sprjname,
    				},
    				success : function(data){
    					location.reload();					
    				}
    			});
    			
    		
    	}
    }
    
    $('.datepicker').datepicker({
        format: 'yyyy-mm-dd',    
    });
    </script>
    <script>
   /*  $('.message-title').on('click',function(event) {
		event.preventDefault();
		$('.message-title').removeClass('active');
		$(this).addClass('active');
		$('.messages .chat_box').each(function(){
			if($(this).attr('id')==$('.message-title.active').attr('data-target')){
				$(this).addClass('in');
			}else{
				$('.messages .chat_box').removeClass('in');
			}
		});
	}); */
    
	</script> 
<script type="text/javascript">
$( document ).ready(function() {
	setTimeout(() => {
	var forwardSalesKey="<%=forwardSalesKey%>"; 
	var forwardProjectNo="<%=forwardProjectNo%>"; 
	var forwardProjectName="<%=forwardProjectName%>";
	var forwardCloseDate="<%=forwardCloseDate%>";
		
	if(forwardSalesKey!="NA"&&forwardProjectNo!="NA"&&forwardProjectName!="NA"){
		
		ShowAllChats(forwardSalesKey,forwardProjectNo,forwardProjectName,"BoxId"+forwardProjectNo,forwardCloseDate);
		/* $('.message-title').removeClass('active');
		$("#"+forwardSalesKey).addClass('active');
		$('.messages .chat_box').each(function(){
			if($(this).attr('id')==$('.message-title.active').attr('data-target')){
				$(this).addClass('in');
			}else{
				$('.messages .chat_box').removeClass('in');
			}
		}); */
		clearSession();		  
		}
	
	}, 200);
});
function clearSession(){
	   $.ajax({
		    type: "POST",
		    url: "<%=request.getContextPath()%>/OpenThisProjectChat999",
		    data:  { 		    	
		    	"status" : "2"
		    },
		    success: function (response) {       	  
	        },
		});
}
function checkedMe(id,aboutClass,rating){
	if($("#"+id).prop("checked")==true)
	$("#"+id).prop("checked",false);
	else $("#"+id).prop("checked",true);
	
	if(Number(rating)>3){
		$("."+aboutClass).removeClass("d-none");
	}
	else{
		$("."+aboutClass).addClass("d-none");
		var n=id.substr(4);
		n=Number(n)-3;
		$("#service"+n).prop("checked",false);
		$("#service"+(Number(n)+1)).prop("checked",false);
		$("#service"+(Number(n)+2)).prop("checked",false);
		$("#service"+(Number(n)+3)).prop("checked",false);
	}
}
function checkedMe1(id){
	if($("#"+id).prop('checked')==true){		
		$("#"+id).attr("checked","checked");
	}else{		
		$("#"+id).removeAttr("checked","checked");
	}
}
function readUnreadStatus(){
	var salesKey=$("#ProjectSalesKey").val();
	$.ajax({
		type : "GET",
		url : "UpdateSalesUnreadStatus111",
		dataType : "HTML",
		data : {
			salesKey : salesKey
		},
		success : function(data){
							
		}
	});	
}
function validRating(){
	var salesKey=$("#ProjectSalesKey").val();
	var count=$("#ServiceRatingUser").val();
	var servceRating="";
	
	if($("#star1:checked").val()==1)servceRating="1#";
	else if($("#star2:checked").val()==2)servceRating="2#";
	else if($("#star3:checked").val()==3)servceRating="3#";
	else if($("#star4:checked").val()==4)servceRating="4#";
	else if($("#star5:checked").val()==5)servceRating="5#";
	
	if($("#service1:checked").val()==1)servceRating+="Good quality,";
	if($("#service2:checked").val()==2)servceRating+="Good value,";
	if($("#service3:checked").val()==3)servceRating+="Professional,";
	if($("#service4:checked").val()==4)servceRating+="Responsive";
	
	var executive="";
	var userRate=1;
	
	var starCount=$("#StarRatingIdGenerator").val();
	var serviceCount=$("#ServiceRatingIdGenerator").val();
	
	var stc=5;
	var src=4;
	
	for(var i=1;i<=Number(count);i++){
		executive+=$("#Executive"+i).val();
		
		if($("#star"+(Number(stc)+1)+":checked").val()==1)executive+="-1@";
		else if($("#star"+(Number(stc)+2)+":checked").val()==2)executive+="-2@";
		else if($("#star"+(Number(stc)+3)+":checked").val()==3)executive+="-3@";
		else if($("#star"+(Number(stc)+4)+":checked").val()==4)executive+="-4@";
		else if($("#star"+(Number(stc)+5)+":checked").val()==5)executive+="-5@";
		else userRate=0;
		
		if($("#service"+(Number(src)+1)+":checked").val()==1)executive+="Good quality,";
		if($("#service"+(Number(src)+2)+":checked").val()==2)executive+="Good value,";
		if($("#service"+(Number(src)+3)+":checked").val()==3)executive+="Professional,";
		if($("#service"+(Number(src)+4)+":checked").val()==4)executive+="Responsive";
		
		executive+="#";
		stc=Number(stc)+5;
		src=Number(src)+4;
		
		if(userRate==0)break;
		
	}
	var ratingComment=$("#ratingComment").val();
	
	if(servceRating==""){
		document.getElementById('errorMsg').innerHTML ="Please rate our service for future enhancement !!";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(userRate==0){
		document.getElementById('errorMsg').innerHTML ="Please rate our executive !!";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(salesKey==null||salesKey==""||salesKey=="NA"){
		document.getElementById('errorMsg').innerHTML ="Something went wrong, Please Reload Page !!";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(ratingComment==null||ratingComment=="")ratingComment="NA";
	
// 	alert(executive);
	
  	$.ajax({
		type : "POST",
		url : "UpdateClientRating111",
		dataType : "HTML",
		data : {
			salesKey : salesKey,
			servceRating : servceRating,
			executive : executive,
			ratingComment : ratingComment
		},
		success : function(data){
			if(data=="pass"){
				document.getElementById('errorMsg1').innerHTML ="Thanks, For Your Valuable Feedback !!";
				$('.alert-show1').show().delay(3000).fadeOut();
			}else{
				document.getElementById('errorMsg').innerHTML ="Something went wrong, Please try-again later !!";
				$('.alert-show').show().delay(3000).fadeOut();
			}	
		}
	});  
	
} 

function showChatArea(){
	$(".sticky_top").hide('fast');
	 $(".box_width60").hide();
	 if($(window).width() < 768)
	  $(".chat_bg").hide();
	  $(".box_width60").show();
	  
}
//  $(".message-title.pointers.nameOfProjects").click(function(){
// 	 $(".box_width60").hide();
// 	 if($(window).width() < 768)
// 	  $(".chat_detail").hide();
// 	  $(".box_width60").show();
	
// 	}); 
 $(".barrow i").click(function(){
	 if($(window).width() < 768)
		 $(".box_width60").hide();
	  $(".chat_bg").show();
	  $(".sticky_top ").show('fast');
	
	}); 
 $("#files").change(function() {
	 fileSize('files');
     filename = this.files[0].name;
     $("#customfile").html(filename);
   });
$(".fa-arrow-left").click(function(){
	$(".footer_menu").removeClass("d-none");
})
$(".mobilesearchico").click(function(){$('#SearchOrderMobile').focus()})
</script>
  </body>
<!-- body ends -->
</html>