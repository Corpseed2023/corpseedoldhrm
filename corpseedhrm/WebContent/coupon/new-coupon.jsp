<%@page import="admin.master.Usermaster_ACT"%>
<%@page import="client_master.Clientmaster_ACT"%>
<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>New Coupon</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<% 	
String token= (String)session.getAttribute("uavalidtokenno");
String[][] products=TaskMaster_ACT.getProducts(token);
%>
<%-- <%if(!CR01){%><jsp:forward page="/login.html" /><%} %> --%>
<div id="content">
<div class="container">
<div class="bread-crumb">
<div class="bd-breadcrumb bd-light">
<a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
<a>New Coupon</a></div>
<div style="position: absolute;right: 83px;top: 72px;">
<a href="<%=request.getContextPath()%>/managecoupon.html"><button class="bkbtn">Back</button></a>
</div>
</div>
</div>
<div class="main-content">
<div class="container">

<div class="row">
<div class="col-xs-12">
<div class="menuDv post-slider clearfix">
<form action="<%=request.getContextPath() %>/addupdatecoupon.html" method="post">
<input type="hidden" name="actionType" value="add">
<div class="col-md-12">	
<div class="row mb-10">
   <div class="col-md-6">
    <label for="exampleInputEmail1" class="form-label">Coupon title</label>
    <input type="text" class="form-control" onchange="isCouponExist(this.value)" id="couponTitle"name="couponTitle" aria-describedby="emailHelp" placeholder="Enter Coupon title......">
    <div id="emailHelp" class="form-text">Coupon title will use to apply coupon.</div>
  </div>
  <div class="col-md-6">
    <label for="exampleInputPassword1" class="form-label">Coupon Value</label>
    <input type="text" class="form-control" id="couponValue" name="couponValue" placeholder="Enter Coupon discount value...." onkeypress="return isNumberKey(event)">
  </div>
 </div> 
 </div>
<div class="col-md-12">	
<div class="row mb-3 mt-10 mb-10">
<div class="col-md-2">
<label for="exampleInputPassword1" class="form-label">Coupon Type</label>
</div>
<div class="col-md-2">
  <input class="form-check-input" type="radio" name="couponType" value="percentage" id="flexRadioDefault1" checked>
  Percentage
    </div>
<div class="col-md-8">  
  <input class="form-check-input" type="radio" name="couponType" value="fixed" id="flexRadioDefault2">
  Fixed
  </div></div>
 </div>
 <div class="col-md-12 max-discount">	
<div class="row mt-10 mb-10">
   <div class="col-md-6">
    <label for="exampleInputEmail1" class="form-label">Maximum Discount</label>
    <input type="text" class="form-control" id="MaxDiscount" name="maxDiscount" aria-describedby="emailHelp" placeholder="Enter maximum discount......" onkeypress="return isNumberKey(event)">
  </div>    	 	
 </div> 
 </div>
 <div class="col-md-12">	
<div class="row mb-3 mt-10 mb-10">
<div class="col-md-2">
<label for="exampleInputPassword1" class="form-label">Service Type</label>
</div>
<div class="col-md-2">
  <input class="form-check-input" type="radio" name="serviceType" value="selected" id="flexRadioDefault3" checked>
  Selected
    </div>
<div class="col-md-8">  
  <input class="form-check-input" type="radio" name="serviceType" value="all" id="flexRadioDefault4">
  All
  </div></div>
 </div>
<div class="col-md-12 select-service">	
<div class="row mt-10 mb-10">
   <div class="col-md-12">
    <label for="exampleInputEmail1" class="form-label">Services</label>
    <select class="form-control" id="Services" name="services" aria-describedby="emailHelp" multiple="multiple">
    <%for(int i=0;i<products.length;i++){ %>
    <option value="<%=products[i][0]%>"><%=products[i][1]%></option><%} %>
    </select>
  </div>   	       	 	
 </div> 
 </div>
 <div class="col-md-12">	
<div class="row mt-10 mb-10">
   <div class="col-md-6">
    <label for="exampleInputEmail1" class="form-label">Start date</label>
    <input type="date" class="form-control" id="StartDate" name="startDate" aria-describedby="emailHelp" placeholder="Enter Coupon title......">
   </div>
  <div class="col-md-6">
    <label for="exampleInputPassword1" class="form-label">End date</label>
    <input type="date" class="form-control" id="EndDate" name="endDate" placeholder="Enter Coupon discount value...." onkeypress="return isNumberKey(event)">
  </div>
 </div> 
 </div>
  <div class="col-md-12">	
<div class="row mb-3 mt-10 mb-10">
<div class="col-md-2">
<label for="exampleInputPassword1" class="form-label">Display status</label>
</div>
<div class="col-md-2">
  <input class="form-check-input" type="radio" name="displayststus" value="1" id="flexRadioDefault5" checked>
  Enable
    </div>
<div class="col-md-8">  
  <input class="form-check-input" type="radio" name="displayststus" value="2" id="flexRadioDefault6">
  Disable
  </div></div>
 </div>
 <div class="col-md-12 mt-10 text-right">
  <button type="submit" class="btn btn-primary" onclick="return validateCoupon()">Submit</button>
</div>
</form>
</div>
</div>
</div>
</div>
</div>
</div>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
$(document).ready(function(){
	$('#Services').select2({
		  placeholder: 'Select service',
		  allowClear: true
		});
});
$( "#flexRadioDefault1" ).click(function() {
	 $(".max-discount").slideDown();
	});
$( "#flexRadioDefault2" ).click(function() {
	 $(".max-discount").slideUp();
	});
$( "#flexRadioDefault3" ).click(function() {
	 $(".select-service").slideDown();
	});
$( "#flexRadioDefault4" ).click(function() {
	 $(".select-service").slideUp();
	});
    	    
function validateCoupon(){
	var title=$("#couponTitle").val();
	var value=$("#couponValue").val();
	var discount=$("#MaxDiscount").val();
	var services=$("#Services").val();
	var startDate=$("#StartDate").val();
	var endDate=$("#EndDate").val();
	if(title==""){
		document.getElementById('errorMsg').innerHTML ="Enter coupon title !!";
    	$('.alert-show').show().delay(2000).fadeOut();
    	return false;
	}
	if(value==""){
		document.getElementById('errorMsg').innerHTML ="Enter coupon value !!";
    	$('.alert-show').show().delay(2000).fadeOut();
    	return false;
	}
	if($("#flexRadioDefault1").is(":checked")&&discount==""){
		document.getElementById('errorMsg').innerHTML ="Enter coupon maximum discount value !!";
    	$('.alert-show').show().delay(2000).fadeOut();
    	return false;
	}
	if($("#flexRadioDefault3").is(":checked")&&services==null){
		document.getElementById('errorMsg').innerHTML ="Select service !!";
    	$('.alert-show').show().delay(2000).fadeOut();
    	return false;
	}
	if(startDate==""){
		document.getElementById('errorMsg').innerHTML ="Enter coupon start date !!";
    	$('.alert-show').show().delay(2000).fadeOut();
    	return false;
	}
	if(endDate==""){
		document.getElementById('errorMsg').innerHTML ="Enter coupon end date !!";
    	$('.alert-show').show().delay(2000).fadeOut();
    	return false;
	}
	showLoader();
}
function isCouponExist(title){
	if(title!=""&&title!="NA"){
	$.ajax({
		type : "GET",
		url : "ExistCouponTitle111",
		dataType : "HTML",
		data : {title : title,id : "0"},
		success : function(data){
			if(data=="pass"){
				$("#errorMsg").html("Duplicate coupon title. ");
				$("#couponTitle").val("");
				$('.alert-show').show().delay(4000).fadeOut();
			}
			
		}
	});
	}else{
		$("#errorMsg").html("Enter a valid coupon title ");
		$("#couponTitle").val("");
		$('.alert-show').show().delay(4000).fadeOut();
	}
}
</script>
</body>
</html>