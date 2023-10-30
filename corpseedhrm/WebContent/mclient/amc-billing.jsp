<!DOCTYPE HTML>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DateFormat"%>
<%@page import="client_master.Clientmaster_ACT"%>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Generate AMC Billing</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%-- <%if(!CB06){%><jsp:forward page="/login.html" /><%} %> --%>
<% 
DateFormat df = new SimpleDateFormat("dd-MM-yyyy");
Calendar calobj = Calendar.getInstance();
String today = df.format(calobj.getTime());
String token=(String)session.getAttribute("uavalidtokenno");
String pricedetails[][]=null;
String cuid=(String) session.getAttribute("passid");
String clientDetails[][]=null;//Clientmaster_ACT.getClientDetails(cuid, token);
String[][] projectDetails=Clientmaster_ACT.getProjectDetails(cuid,token);
// String[][] Item=Clientmaster_ACT.getProjectPrice(uid);

// 
%>
<div id="content">
<div class="container">   
          <div class="bread-crumb">
            <div class="bd-breadcrumb bd-light">
            <a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
            <a>Generate AMC Invoice</a>
            </div><a href="<%=request.getContextPath()%>/amc-account.html"><button class="bkbtn" style="margin-left:863px;">Back</button></a>
          </div>
        </div>
<div class="main-content">
<div class="container">
<div class="row">
<div class="col-md-5 col-sm-5 col-xs-12">
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
String[][] billing=Clientmaster_ACT.getReceiptBillingDetails(cuid,token,"amc");
if(billing.length>0){
	for(int i=0;i<billing.length;i++){	
		String prjno=Clientmaster_ACT.getProjectNo(billing[i][6],token);
%>
<div class="menuDv clearfix form-group">
<div class="mb0 pad_box2 top_title">
<div class="pad0 col-md-6 col-sm-6 col-xs-12">
<h2 class="normal_txt txt_orange" title="<%=prjno %>&nbsp;:&nbsp;<%=billing[i][2] %>"><%=prjno %>&nbsp;:&nbsp;<%=billing[i][2] %></h2>
</div>
<!-- <div class="pad0 col-md-2 col-sm-2 col-xs-12"> -->
<%-- <h2 title="<%=billing[i][5] %>" style="font-size: 14px;"><i class="fa fa-inr"></i>&nbsp;<%=billing[i][5] %></h2> --%>
<!-- </div> -->
<div class="pad0 col-md-3 col-sm-4 col-xs-8 mtop10">
<span style="font-size: 14px;color: darkorchid;"><%=billing[i][4] %></span>
</div>
<div class="pad0 col-md-1 col-sm-2 col-xs-4 text-right mtop10">
<span class="pad-rt05"><a href="<%=request.getContextPath()%>/billreceiptprint.html?refid=<%=billing[i][1]%>" target="_blank"> <i class="fa fa-file-text pointers" style="font-size: 20px;color: cornflowerblue;"></i></a></span>
</div>
<div class="pad0 col-md-1 col-sm-2 col-xs-4 text-right mtop10">
<span class="pad-rt05"><a class="fancybox" href="<%=request.getContextPath() %>/clientpaymentbyadmin.html?brf=<%=billing[i][1]%>"> <i class="fa fa-inr pointers" style="font-size: 20px;color: cornflowerblue;" title="Add Client Bill Amount !"></i></a></span>
</div>
<div class="pad0 col-md-1 col-sm-2 col-xs-4 text-right mtop10">
<span class="pad-rt05"><a class="fancybox" href="<%=request.getContextPath()%>/confirmclientpaymentbyadmin.html?brf=<%=billing[i][1]%>&btpe=amc"> <i class="fa fa-money pointers" style="font-size: 20px;color: cornflowerblue;"  title="Confirm Paid Amount !"></i></a></span>
</div>
</div>
</div>
<%}} %>
</div>

<div class="col-md-7 col-sm-7 col-xs-12">

<%
if(projectDetails.length>0){
	for(int j=0;j<projectDetails.length;j++){
%>
<div class="menuDv clearfix form-group" >
<div class="mb0 pad_box2 top_title pointers add_follow_title">
<div class="pad0 col-md-8 col-sm-6 col-xs-12">
<h2 class="normal_txt txt_orange" title="<%=projectDetails[j][1] %>&nbsp;:&nbsp;<%=projectDetails[j][4] %>"><%=projectDetails[j][1] %>&nbsp;:&nbsp;<%=projectDetails[j][4] %></h2>
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
           <div class="box-width31 col-xs-1 box-intro-bg">
               <div class="box-intro-border">
               <p class="news-border">Price Type</p>
               </div>
           </div>
           <div class="box-width5 col-xs-1 box-intro-bg">
               <div class="box-intro-border">
               <p class="news-border">Price</p>
               </div>
           </div>          
           <div class="box-width7 col-xs-6 box-intro-bg">
               <div class="box-intro-border">
               <p class="news-border">Renewal</p>
               </div>
           </div>
           <div class="box-width12 col-xs-6 box-intro-bg">
               <div class="box-intro-border">
               <p class="news-border">Ren. Date</p>
               </div>
           </div>
            <div class="box-width16 col-xs-6 box-intro-bg">
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
  pricedetails=Clientmaster_ACT.getProjectPrice(projectDetails[j][0] );
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
           <div class="box-width31 col-xs-1 box-intro-background">
               <div class="link-style12">
               <p class="news-border" title="<%=pricedetails[i][1] %>"><%=pricedetails[i][1] %></p>
               </div>
           </div>
           <div class="box-width5 col-xs-1 box-intro-background">
               <div class="link-style12">
               <p class="news-border" title="<%=pricedetails[i][2] %>"><i class="fa fa-inr"></i> <%=pricedetails[i][2] %></p>
               </div>
           </div>           
           <div class="box-width7 col-xs-6 box-intro-background">
               <div class="link-style12">
               <p class="news-border"><%=pricedetails[i][4] %><%if(!pricedetails[i][4].equalsIgnoreCase("NA")&&pricedetails[i][4]!="") {%>(<%=pricedetails[i][5] %>)<%} %></p>
               </div>
           </div>
           <div class="box-width12 col-xs-6 box-intro-background">
               <div class="link-style12">
               <p class="news-border"><%=pricedetails[i][10] %></p>
               </div>
           </div>
           <div class="box-width16 col-xs-6 box-intro-background">
               <div class="link-style12">
               <p class="news-border" title=""><%=pricedetails[i][6] %><%if(!pricedetails[i][6].equalsIgnoreCase("NA")&&!pricedetails[i][6].equalsIgnoreCase("Not Applicable")) {%>  <%=pricedetails[i][7] %>%<%} %></p>
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

<div class="menuDv clearfix attr-color">
<div class="mb0 pad_box2 top_title pointers add_follow_title">
<h2 class="txt_blue">Add Item</h2>
<i class="fa fa-plus" title="Add Follow-Up"></i>
</div>
<div class="clearfix partner-slider8" style="display: none;">
<form onsubmit="return false" name="follow-up-form">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix footer-bottom2">
<div class="col-sm-5 col-xs-12  box-intro-background">
<div class="add-enquery">
<select name="projectid" id="Projectid" class="form-control"  onchange="getItems(this.value);">
<option value="">Select Project</option>
<%
if(projectDetails.length>0){
	for(int j=0;j<projectDetails.length;j++){
%>
<option value="<%=projectDetails[j][0]%>"><%=projectDetails[j][4] %></option>
<%}} %>
</select>
</div>
<div id="projectidErr" class="error_text"></div>
</div>
<div class="col-sm-5 col-xs-12  box-intro-background">
<div class="add-enquery">
<select name="itemname" id="ItemName" class="form-control multiselect" multiple="multiple"  onchange="setValue();">
</select>
<input type="hidden" id="ItemNo" name="itemsno">
</div>
<div id="itemnameErr" class="error_text"></div>
</div>
<div class="col-sm-2 col-xs-12 box-intro-background">
<div class="clearfix add-enquery">
<button type="submit" class="bt-style1 bt-link bt-radius bt-loadmore" onclick="return amcItemValidations();">Add</button>
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
<h2>Item Details</h2>
</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div id="refresh">
<div class="clearfix follow_status">
<div class="row">
         <div class="col-md-12 col-sm-12 col-xs-12">
          <div class="clearfix">
          <div class="box-width25 col-xs-1 box-intro-bg">
               <div class="box-intro-border">
               <p class="news-border">SN</p>
               </div>
           </div>
           <div class="box-width4 col-xs-1 box-intro-bg">
               <div class="box-intro-border">
               <p class="news-border">Price Type</p>
               </div>
           </div>
           <div class="box-width5 col-xs-1 box-intro-bg">
               <div class="box-intro-border">
               <p class="news-border">Price</p>
               </div>
           </div>
            <div class="box-width9 col-xs-6 box-intro-bg">
               <div class="box-intro-border">
               <p class="news-border">GST</p>
               </div>
           </div>
            <div class="box-width5 col-xs-6 box-intro-bg">
               <div class="box-intro-border">
               <p class="news-border">GST &nbsp;<i class="fa fa-inr"></i></p>
               </div>
           </div>
              <div class="box-width3 col-xs-6 box-intro-bg">
               <div class="box-intro-border">
               <p class="news-border">Apply Coupon</p>
               </div>
           </div>
              <div class="box-width5 col-xs-6 box-intro-bg">
               <div class="box-intro-border">
               <p class="news-border">Discount</p>
               </div>
           </div>
           <div class="box-width16 col-xs-6 box-intro-bg">
               <div class="box-intro-border">
               <p class="news-border">Amount</p>
               </div>
           </div>
           <div class="box-width24 col-xs-6 box-intro-bg">
               <div class="box-intro-border">
               <p class="">&nbsp;&nbsp;<i class="fa fa-times"></i></p>
               </div>
           </div>
          </div>
         </div>
        </div>
       <%
       int flag=0;
       String itemDetails[][]=Clientmaster_ACT.getItemDetails(cuid, token,"amc");
       double totalamount=Clientmaster_ACT.getTotalAmount(cuid, token,"amc");
       if(itemDetails.length>0){
    	   for(int i=0;i<itemDetails.length;i++){
    		   flag=1;
    		   String priceDetails[][]=Clientmaster_ACT.getPriceDetails(itemDetails[i][1], token);
       %>
       <div class="row">
         <div class="col-md-12 col-sm-12 col-xs-12">
          <div class="clearfix">
          <div class="box-width25 col-xs-1 box-intro-background">
               <div class="link-style12">
               <p class="news-border" title=""><%=i+1 %></p>
               </div>
           </div>
           <div class="box-width4 col-xs-1 box-intro-background">
               <div class="link-style12">
               <p class="news-border" title="<%=priceDetails[0][0] %>"><%=priceDetails[0][0] %></p>
               </div>
           </div>
           <div class="box-width5 col-xs-1 box-intro-background">
               <div class="link-style12">
               <p class="news-border" title="<%=priceDetails[0][1] %>"><i class="fa fa-inr"></i> <%=priceDetails[0][1] %></p>
               </div>
           </div>        
           <div class="box-width9 col-xs-6 box-intro-background">
               <div class="link-style12">
               <p class="news-border" title=""><%=priceDetails[0][2] %><%if(!priceDetails[0][3].equalsIgnoreCase("NA")&&!priceDetails[0][3].equalsIgnoreCase("Not Applicable")) {%>(<%=priceDetails[0][3] %>%)<%} %></p>
               </div>
           </div>
           <div class="box-width5 col-xs-6 box-intro-background">
               <div class="link-style12">
               <p class="news-border"><i class="fa fa-inr"></i> <%=priceDetails[0][4] %></p>
               </div>
           </div>
            <div class="box-width3 col-xs-6 box-intro-background">
               <div class="link-style12">
               <p class="apply_coupon news-border"><span  class="lnr lnr-cross-circle"></span><input class="form-control"  type="text" id="" name="" value="<%if(!itemDetails[i][3].equalsIgnoreCase("NA")){%><%=itemDetails[i][3]%><%}%>"/></p>
               </div>
           </div>
            <div class="box-width5 col-xs-6 box-intro-background">
               <div class="link-style12">
               <p class="news-border"><%=itemDetails[i][4]%></p>
               </div>
           </div>
           <div class="box-width16 col-xs-6 box-intro-background">
               <div class="link-style12">
               <p class="news-border"><i class="fa fa-inr"></i> <%=itemDetails[i][5]%></p>
               </div>
           </div>
           <div class="box-width24 col-xs-6 box-intro-background">
               <div class="link-style12">
               <p class=""><a class="" href="javascript:void(0);" onclick="deleteamcItem('<%=itemDetails[i][0]%>');"><i class="fa fa-trash"></i> </a></p>
               </div>
           </div>
        </div>
      </div>
   </div>
   <%}}else{ %>
   <center>
   <h4>No Data Found</h4>
   </center>
   <%} %>
   </div>
<div class="clearfix  text-right mb10 pad10">
<span class="sub_total_amount"><strong>Sub Total Amount :</strong> <span><i class="fa fa-inr"></i><strong id=""><%=totalamount %></strong> </span></span>
</div>
<div class="clearfix  text-right form-group pad10">
<button type="submit" class=" bt-link bt-radius bt-loadmore" onclick="generateAmcBill()">Finish</button>
</div>
<input type="hidden" id="Flag" value="<%=flag%>"/>
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
  <h2><span class="title">Delete This Task History ?</span></h2>
</div>
</div>
<div class="col-md-12 col-xs-12 mb10">
<a class="sub-btn1" onclick="" id="cancelpopup">Cancel</a>
<button class="sub-btn1 mlft10" onclick="return deleteFollowUp(document.getElementById('userid').innerHTML);" title="Delete">Delete</button>
</div>
</div>
</section>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/jquery.multiselect.js"></script>
<script type="text/javascript">	
$(".fancybox").fancybox({
    'width'             : '80%',
    'height'            : '100%',
    'autoScale'         : false,
    'transitionIn'      : 'none',
    'transitionOut'     : 'none',
    'type'              : 'iframe',
    'hideOnOverlayClick': false,
//     afterClose: function () {    
//     	parent.location.reload(true);
//     }
});

$(function(){
	$("select.multiselect").multiselect({
		noneSelectedText: 'Select Item',
	});
});
function setValue(){
	var values = $('#ItemName').val();
	  document.getElementById('ItemNo').value=values;
}
</script>
<script type="text/javascript">	
bkLib.onDomLoaded(function(){nicEditors.editors.push(new nicEditor().panelInstance(document.getElementById('pfuremark')));});
$(function() {
	$("#pfudate").datepicker({
	changeMonth: true,
	changeYear: true,
	dateFormat: 'dd-mm-yy',
	});
	});
</script>

<script type="text/javascript">    
function amcItemValidations() {
	if(document.getElementById('Projectid').value.trim()=="" ) {
		projectidErr.innerHTML="Select Project First";
		projectidErr.style.color="red";
	return false;
	}else projectidErr.innerHTML="";
	if(document.getElementById('ItemName').value.trim()=="" ) {
		itemnameErr.innerHTML="Select Project First";
		itemnameErr.style.color="red";
	return false;
	}else itemnameErr.innerHTML="";	
		var projectid=document.getElementById('Projectid').value.trim();
		var itemid=document.getElementById('ItemNo').value.trim();
		var clientid="<%=cuid%>";
	$.ajax({
		type : "POST",
		url : "AddAmcItemVirtual111",
		dataType : "HTML",
		data : {"projectid":projectid,"itemid":itemid,"clientid":clientid},
		success : function(data){
			$("#refresh").load(location.href + " #refresh");		
			document.getElementById('Projectid').value=""; 
			$("#ItemName").empty();	
			 $("#ItemName").multiselect('refresh');
			 
		}
	});
	}
function getItems(pid){
	if(pid!="")
	$.ajax({
		type : "POST",
		url : "GetAMCProjectItems111",
		dataType : "HTML",
		data : {				
			"pid":pid,
		},
		success : function(response){
			response = JSON.parse(response);			
			 var len = response.length;
			    $("#ItemName").empty();			  
				for( var i =0; i<len; i++){
				var id = response[i]['id'];
				var name = response[i]['value'];
			$("#ItemName").append("<option value='"+id+"'>"+name+"</option>");
			$("#ItemName").multiselect('refresh');
				}
		}
	});else{
		$("#ItemName").empty();	   
	}
}

function generateAmcBill(){
	var cuid="<%=cuid%>";
	var x=document.getElementById("Flag").value;
	if(x==1){
	$.ajax({
		type : "GET",
		url : "IsMultipleItemExists111",
		dataType : "HTML",
		data : {				
			"tablefrom":"amc",cuid : cuid
		},
		success : function(response){
			if(response=="pass"){		
			var xhttp; 
			xhttp = new XMLHttpRequest();
			xhttp.onreadystatechange = function() {
			if (this.readyState == 4 && this.status == 200) {
				document.getElementById('errorMsg').innerHTML = 'Successfully Bill Generated.';			
				document.getElementById('errorMsg').style.background="green";
				document.getElementById('errorMsg').style.color="white";
				$('.alert-show').show().delay(1000).fadeOut();
				setTimeout(function(){location.reload(true);},1000);
			}
			};
			xhttp.open("GET", "<%=request.getContextPath()%>/GenerateAMCBill111?cuid="+cuid, true);
			xhttp.send();
			}else{
				document.getElementById('errorMsg').innerHTML ="Multiple Projects Bill Not Allowed In One.!";	        		  
	  		  $('.alert-show').show().delay(3000).fadeOut();			
			}
		}
	});			
	}else{
		document.getElementById('errorMsg').innerHTML = 'Add Item To Generate Bill.';			
		$('.alert-show').show().delay(1000).fadeOut();
	}
}

function deleteamcItem(id){
	if(confirm("Sure you want to Delete this Item ? "))
	{
	var xhttp; 
	xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
	if (this.readyState == 4 && this.status == 200) {
		$("#refresh").load(location.href + " #refresh");	
	}
	};
	xhttp.open("GET", "<%=request.getContextPath()%>/DeleteAMCItem111?info="+id, true);
	xhttp.send();
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