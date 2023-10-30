<!DOCTYPE HTML>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DateFormat"%>
<%@page import="client_master.Clientmaster_ACT"%>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Follow-Up Billing</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%if(!MB00){%><jsp:forward page="/login.html" /><%} %>
<% 
DateFormat df = new SimpleDateFormat("dd-MM-yyyy");
Calendar calobj = Calendar.getInstance();
String today = df.format(calobj.getTime());
String token=(String)session.getAttribute("uavalidtokenno");
String pricedetails[][]=null;
String cuid=(String) session.getAttribute("passid");
String clientDetails[][]=null;//Clientmaster_ACT.getClientDetails(cuid, token);
String[][] projectDetails=Clientmaster_ACT.getBillingProjectDetails(cuid,token);
%>
<div id="content">
<div class="container">   
          <div class="bread-crumb">
            <div class="bd-breadcrumb bd-light">
            <a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
            <a>Follow-Up Billing</a>
            </div><a href="<%=request.getContextPath()%>/manage-billing.html"><button class="bkbtn" style="margin-left:889px;">Back</button></a>
          </div>
        </div>
<div class="main-content">
<div class="container">
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="menuDv clearfix form-group">
<div class="mb0 clearfix project_title top_title">
<div class="pad0 col-md-8 col-sm-8 col-xs-12">
<h3 class="txt_blue"  title="<%=clientDetails[0][0]%>"><%=clientDetails[0][0]%></h3>
</div>
<div class="pad0 col-md-4 col-sm-4 col-xs-12">
<p class="text-right"></p>
</div>
</div>

<div class="clearfix">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix link-style12 project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Client Id</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=clientDetails[0][1]%>"><%=clientDetails[0][1]%></p>
</div>
</div>
<div class="clearfix link-style12 project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Company</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=clientDetails[0][0]%>"><%=clientDetails[0][0]%></p>
</div>
</div>
<div class="clearfix link-style12 project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Mobile</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=clientDetails[0][2]%>"><%=clientDetails[0][2]%></p>
</div>
</div>
<div class="clearfix link-style12 project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Email</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=clientDetails[0][3]%>"><%=clientDetails[0][3]%></p>
</div>
</div>
<div class="clearfix link-style12 project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Address</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=clientDetails[0][4]%>"><%=clientDetails[0][4]%></p>
</div>
</div>
</div>
</div>
</div>
</div>

<%
if(projectDetails.length>0){
	for(int j=0;j<projectDetails.length;j++){
%>
<div class="menuDv clearfix form-group" >
<div class="mb0 pad_box2 top_title pointers add_follow_title">
<div class="pad0 col-md-8 col-sm-6 col-xs-12">
<h2 class="normal_txt txt_orange" title="<%=projectDetails[j][4] %>"><%=projectDetails[j][4] %></h2>
</div>
<div class="pad0 col-md-3 col-sm-4 col-xs-8 text-right">
<span><%=projectDetails[j][7] %></span>
</div>
<div class="pad0 col-md-1 col-sm-2 col-xs-4 text-right">
<span class="pad-rt05"> <i class="fa fa-plus" title="Add Follow-Up"></i></span>
</div>
</div>


<div class="clearfix pad-top5" style="display: none;">

<div class="clearfix form-group" >
<div class="row">
         <div class="col-md-12 col-sm-12 col-xs-12">
          <div class="clearfix box-intro-bg">
          <div class="box-width24 col-xs-1 box-intro-bg">
               <div class="box-intro-border">
               <p class="news-border">SN</p>
               </div>
           </div>
           <div class="box-width13 col-xs-1 box-intro-bg">
               <div class="box-intro-border">
               <p class="news-border">Price Type</p>
               </div>
           </div>
           <div class="box-width2 col-xs-1 box-intro-bg">
               <div class="box-intro-border">
               <p class="news-border">Price</p>
               </div>
           </div>
           <div class="box-width9 col-xs-1 box-intro-bg">
               <div class="box-intro-border">
               <p class="news-border">Service Type</p>
               </div>
           </div>
           <div class="box-width7 col-xs-6 box-intro-bg">
               <div class="box-intro-border">
               <p class="news-border">Renewal</p>
               </div>
           </div>
            <div class="box-width3 col-xs-6 box-intro-bg">
               <div class="box-intro-border">
               <p class="news-border">GST</p>
               </div>
           </div>
            <div class="box-width5 col-xs-6 box-intro-bg">
               <div class="box-intro-border">
               <p class="news-border">GST Amount</p>
               </div>
           </div>
           <div class="box-width16 col-xs-6 box-intro-bg">
               <div class="box-intro-border">
               <p class="">Amount</p>
               </div>
           </div>
          </div>
         </div>
        </div>                   
  <%
  pricedetails=Clientmaster_ACT.getBillingProjectPrice(projectDetails[j][0] );
  if(pricedetails.length>0){
	 for(int i=0;i<pricedetails.length;i++) 
	 {
  %>
       <div class="row">
         <div class="col-md-12 col-sm-12 col-xs-12">
          <div class="clearfix">
          <div class="box-width24 col-xs-1 box-intro-background">
               <div class="link-style12">
               <p class="news-border" title=""><%=i+1 %></p>
               </div>
           </div>
           <div class="box-width13 col-xs-1 box-intro-background">
               <div class="link-style12">
               <p class="news-border" title="<%=pricedetails[i][1] %>"><%=pricedetails[i][1] %></p>
               </div>
           </div>
           <div class="box-width2 col-xs-1 box-intro-background">
               <div class="link-style12">
               <p class="news-border" title="<%=pricedetails[i][2] %>"><i class="fa fa-inr"></i> <%=pricedetails[i][2] %></p>
               </div>
           </div>
           <div class="box-width9 col-xs-1 box-intro-background">
               <div class="link-style12">
               <p class="news-border" title="<%=pricedetails[i][3] %>"><%=pricedetails[i][3] %></p>
               </div>
           </div>
           <div class="box-width7 col-xs-6 box-intro-background">
               <div class="link-style12">
               <p class="news-border"><%=pricedetails[i][4] %><%if(!pricedetails[i][4].equalsIgnoreCase("NA")&&pricedetails[i][4]!="") {%>(<%=pricedetails[i][5] %>)<%} %></p>
               </div>
           </div>
           <div class="box-width3 col-xs-6 box-intro-background">
               <div class="link-style12">
               <p class="news-border" title=""><%=pricedetails[i][6] %><%if(!pricedetails[i][6].equalsIgnoreCase("NA")&&!pricedetails[i][6].equalsIgnoreCase("Not Applicable")) {%>(<%=pricedetails[i][7] %>%)<%} %></p>
               </div>
           </div>
           <div class="box-width5 col-xs-6 box-intro-background">
               <div class="link-style12">
               <p class="news-border"><%if(!pricedetails[i][8].equalsIgnoreCase("NA")){ %><i class="fa fa-inr"></i><%} %> <%=pricedetails[i][8] %></p>
               </div>
           </div>
           <div class="box-width16 col-xs-6 box-intro-background">
               <div class="link-style12">
               <p class=""><i class="fa fa-inr"></i> <%=pricedetails[i][9] %></p>
               </div>
           </div>
        </div>
      </div>
   </div>
  <%}} %>            
                 
</div>
</div>
</div>
<%}} %>


</div>

<div class="col-md-6 col-sm-6 col-xs-12">

<div class="menuDv clearfix attr-color">
<div class="mb0 pad_box2 top_title pointers add_follow_title">
<h2>Follow Up</h2>
<i class="fa fa-plus" title="Add Follow-Up"></i>
</div>
<div class="clearfix partner-slider8" style="display: none;">
<form action="billing-follow-up.html" method="post" name="follow-up-form" enctype="multipart/form-data">
<input type="hidden" name="transferpage" value="manage-billing.html" readonly>
<input type="hidden" name="fromfollowup" value="billing" readonly>
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix footer-bottom2">
<div class="col-sm-6 col-xs-12  box-intro-background">
<div class="add-enquery">
<select name="pfupid" id="pfupid" class="form-control" onchange="setDeliveryDate(this.value)">
<option value="">Select Project</option><%if(projectDetails.length>0){for(int i=0;i<projectDetails.length;i++){ %>
<option value="<%=projectDetails[i][0]%>#<%=projectDetails[i][1]%>#<%=projectDetails[i][7]%>"><%=projectDetails[i][4]%></option><%}} %>
</select>
</div>
</div>
<div class="col-sm-6 col-xs-12  box-intro-background">
<div class="add-enquery">
<select name="pfustatus" id="pfustatus" class="form-control"  onchange="checkDeliverDate(this.value)">
<option value="">Project Status</option>
<option value="Open">Open</option>
<option value="Delivered">Delivered</option>
<option value="Hold">Hold</option>
</select>
</div>
</div>

</div>
<div class="clearfix">
<div class="col-sm-4 col-xs-12  box-intro-background">
<div class="add-enquery">
<select name="followupby" id="followupby" class="form-control"><option value="">Follow Up By</option><option value="Client">Client</option><option value="Project Manager">Project Manager</option></select>
</div>
</div>
<div class="col-sm-4 col-xs-12  box-intro-background">
<div class="add-enquery">
<input type="text" name="pfudate" id="pfudate" placeholder="Date of Follow Up" value="<%=today %>" class="form-control readonlyAllow" readonly="readonly">
</div>
</div>
<div class="col-sm-4 col-xs-12  box-intro-background">
<div class="add-enquery">
<input type="text" name="pfuddate" id="pfuddate" placeholder="Date of Delivery" class="form-control datetimepicker readonlyAllow" data-date-format="dd-mm-yyyy  HH:ii p" readonly="readonly" disabled="disabled">

</div>
</div>
</div>
<div class="clearfix">
<div class="col-xs-12  box-intro-background">
<div class="add-enquery nicEdit_box">
<textarea name="pfuremark" id="pfuremark" class="form-control"></textarea>
</div>
<div id="pfuremarkerr" class="errormsg"></div>
</div>
</div>
<div class="clearfix">
<div class="col-sm-4 col-xs-12  box-intro-background">
<div class="add-enquery">
<select name="showclient" id="showclient" class="form-control"><option value="">Show to Client?</option><option value="1">Yes</option><option value="0">No</option></select>
</div>
</div>
<div class="col-sm-4 col-xs-12  box-intro-background" id="ifupload">
<div class="add-enquery">
<button type="button" class="bt-style2 bt-link bt-radius" onclick="$('#uploadyes').toggle();$('#ifupload').hide();">Upload Image ?</button>
</div>
</div>
<div class="col-sm-4 col-xs-12  box-intro-background" id="uploadyes" style="display: none;">
<div class="add-enquery">
<input type="file" name="files" id="files" class="form-control" accept="application/pdf, image/*" />
</div>
</div>
<div class="col-sm-4 col-xs-12 box-intro-background">
<div class="clearfix add-enquery text-right">
<button type="submit" class="bt-style1 bt-link bt-radius bt-loadmore" onclick="return statusValidations();">Add</button>
</div>
</div>
</div>
</div>
</form>
</div>
</div>

<div class="clearfix menuDv attr-color">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="top_title pad_box2">
<h2>Communication History</h2>
</div>
<%-- <a class="mrt10 pad-top5 add_btn font_size15"><strong>Delivery Date : </strong><%=getProjectById[0][5] %></a> --%>
</div>
</div>
<div id="reload">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<%
String[][] getFollowUpById = Clientmaster_ACT.getFollowUpById(projectDetails[0][0],token);
if(getFollowUpById.length>0){
for(int i=0;i<getFollowUpById.length;i++) {	
%>
<div class="clearfix follow_status">
<div class="clearfix link-style12">
<div class="col-sm-11 col-xs-12 box-intro-background">
<div class="col-sm-4 col-xs-12 box-intro-background">
<p class="fstatus_bg news-border"><%=getFollowUpById[i][6] %></p>
</div>
<div class="col-sm-4 col-xs-12 box-intro-background ">
<p class="news-border"><%=getFollowUpById[i][3] %></p>
</div>
<div class="col-sm-4 col-xs-12 box-intro-background">
<p class="news-border"><%=getFollowUpById[i][2] %></p>
</div>
</div>
<div class="col-sm-1 col-xs-12 box-intro-background">
<p><a class="quick-view" href="#manageFollowup" onclick="document.getElementById('userid').innerHTML='<%=getFollowUpById[i][0]%>';"><i class="fa fa-trash-o"></i></a></p>
</div>
</div>
<div class="clearfix">
<div class="col-xs-12 box-intro-background">
<p class="desc"><%=getFollowUpById[i][5]%></p>
</div>
</div>
</div>
<% }}else{ %>
<center>
<h4 style="color: red;">No History Found</h4>
</center>
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
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>
<section class="clearfix" id="manageFollowup" style="display: none;">
<div class="clearfix  text-center">
<div class="col-md-12 col-xs-12" id="userid" style="display: none;"></div>
<div class="col-md-12 col-xs-12">
<div class="box-intro1">
  <h2><span class="title">Delete This Communication History ?</span></h2>
</div>
</div>
<div class="col-md-12 col-xs-12 mb10">
<a class="sub-btn1" onclick="" id="cancelpopup">Cancel</a>
<button class="sub-btn1 mlft10" onclick="return deleteFollowUpBilling(document.getElementById('userid').innerHTML);" title="Delete">Delete</button>
</div>
</div>
</section>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">	
bkLib.onDomLoaded(function(){nicEditors.editors.push(new nicEditor().panelInstance(document.getElementById('pfuremark')));});
$(function() {
	$("#pfudate").datepicker({
	changeMonth: true,
	changeYear: true,
	dateFormat: 'dd-mm-yy',
	});
	});
	
$('#cancelpopup').click(function(){
	  $.fancybox.close();
});
</script>

<script type="text/javascript">
function checkDeliverDate(val){
	if(val=="Hold"){
		document.getElementById("pfuddate").removeAttribute("disabled"); 
		document.getElementById('errorMsg').innerHTML = 'Update Delivery Date.!';
		document.getElementById("pfustatus").setAttribute("disabled", true);
		$('.alert-show').show().delay(1000).fadeOut();
	}
	else{
		document.getElementById("pfuddate").setAttribute("disabled", true);		
	}if(val=="Delivered"&&document.getElementById('pfupid').value.trim()!=""){
		var preguid=document.getElementById("pfupid").value;
		var x=preguid.split("#");
		preguid=x[0];
// 		checking payment made or not
		$.ajax({
		    type: "POST",
		    url: "<%=request.getContextPath()%>/IsPaidProjectPayment111",
		    data:  { 
		    	preguid : preguid
		    },
		    success: function (response) {
	        	  if(response=="fail"){
	        		  document.getElementById('errorMsg').innerHTML ="This Project's Payment Is Due...!";
	        		  document.getElementById("pfustatus").value="";
	        		  document.getElementById("followupby").value="";
	        		  $('.alert-show').show().delay(4000).fadeOut();
	        	  } 
	        },
		});
	}else{
		 document.getElementById('errorMsg').innerHTML ="Select Project To Deliver.!";
		 $('.alert-show').show().delay(3000).fadeOut();
	}	
}

function setDeliveryDate(val){
	document.getElementById("pfustatus").value="";
	document.getElementById("pfustatus").removeAttribute("disabled");
	if(val!=""){
	var x=val.split("#");
	document.getElementById("pfuddate").value=x[2];
	}else{
		document.getElementById("pfuddate").value="";	
	}
}

function statusValidations() {
	if(document.getElementById('pfupid').value.trim()=="" ) {
		document.getElementById('errorMsg').innerHTML = 'Select Project.!';
		$('.alert-show').show().delay(1000).fadeOut();
	return false;
	}
	if(document.getElementById('pfustatus').value.trim()=="" ) {
		document.getElementById('errorMsg').innerHTML = 'Select Status.!';
		$('.alert-show').show().delay(1000).fadeOut();
	return false;
	}
	if(document.getElementById('followupby').value.trim()=="" ) {
		document.getElementById('errorMsg').innerHTML = 'Select Follow-Up By.!';
		$('.alert-show').show().delay(1000).fadeOut();
	return false;
	}
	if(document.getElementById('pfudate').value.trim()=="" ) {
		document.getElementById('errorMsg').innerHTML = 'Follow-Up Date is required.!';
		$('.alert-show').show().delay(1000).fadeOut();
	return false;
	}

	if(document.getElementById('pfuddate').value.trim()=="" ) {
		document.getElementById('errorMsg').innerHTML = 'Delivery date is required.!';
		$('.alert-show').show().delay(1000).fadeOut();
	}
	var remarks =nicEditors.findEditor( "pfuremark" ).getContent();
	if(remarks.length<10 ) {
		document.getElementById('errorMsg').innerHTML = 'Minimum 10 Character Remarks Required.!';
		$('.alert-show').show().delay(1000).fadeOut();
	return false;
	}	
	if(document.getElementById('showclient').value.trim()=="" ) {
		document.getElementById('errorMsg').innerHTML = 'Select Show Client ?.!';
		$('.alert-show').show().delay(1000).fadeOut();
	return false;
	}
	}
</script>
<div id="showremarks" style="display: none; width: 700px; max-height: 400px; overflow-x: hidden; overflow-y: auto;">
<div class="container">
<p id="datahere"></p>
</div>
</div>
</body>
</html>