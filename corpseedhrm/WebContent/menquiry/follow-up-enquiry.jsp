<%@page import="commons.DateUtil"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="admin.enquiry.Enquiry_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Follow Up Sales</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%if(!MAS01){%><jsp:forward page="/login.html" /><%} %>
<%
String token= (String)session.getAttribute("uavalidtokenno");
String today=DateUtil.getCurrentDateIndianFormat1();
String sref=request.getParameter("sref");

// String[][] payment=Enquiry_ACT.getRelatedTransaction(sref);

String[][] sales = Enquiry_ACT.getSalesByRefId(sref,token);
String loginuaid=Usermaster_ACT.getLoginUserName(sales[0][11], token);
%>
<div id="content">
<div class="container">   
<div class="bread-crumb">
  <div class="bd-breadcrumb bd-light">
  <a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
  <a>Follow Up Sales</a>
  </div>
</div>
</div>
<div class="main-content">
<div class="container">
<div class="clearfix text-right mb10">
<a href="<%=request.getContextPath()%>/manage-sales.html"><button class="bkbtn">Back</button></a>
</div>
<div class="row">
<div class="col-md-5 col-sm-5 col-xs-12">
<div class="menuDv clearfix">
<div class="mb0 clearfix project_title top_title">
<div class="pad0 col-md-8 col-sm-8 col-xs-12">
<h3><span title="<%=sales[0][5] %>"><%=sales[0][5] %></span></h3>
</div>
<div class="pad0 col-md-4 col-sm-4 col-xs-12">
<p class="text-right"><%=sales[0][12] %></p>
</div>
</div>

<div class="clearfix">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">

<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Sales ID.</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=sales[0][3] %>"><%=sales[0][3] %></p>
</div>
</div>
<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Product Type</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title="<%=sales[0][6] %>"><%=sales[0][6] %></p>
</div>
</div>
<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Product Name</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p class="txt_blue" title="<%=sales[0][7] %>"><%=sales[0][7] %></p>
</div>
</div>
<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Paid</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p class="txt_blue" title=""><i class="fa fa-inr"></i>&nbsp;&nbsp;</p>
</div>
</div>
<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Expected Date</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p class="txt_blue" title=""></p>
</div>
</div>
<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Sold By</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p class="txt_blue" title="<%=loginuaid%>"><%=loginuaid%></p>
</div>
</div>
<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Client's Name</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p class="txt_blue" title="<%=sales[0][5] %>"><%=sales[0][5] %></p>
</div>
</div>
<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Mobile</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p class="txt_blue" title=""></p>
</div>
</div>
<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Email</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p class="txt_blue" title=""></p>
</div>
</div>
<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Country</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title=""></p>
</div>
</div>
<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>State</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title=""></p>
</div>
</div>
<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>City</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title=""></p>
</div>
</div>

<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Industry</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p class="txt_blue" title=""></p>
</div>
</div>
<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Status</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title=""></p>
</div>
</div>
<div class="clearfix project_detail_box">
<div class="pad0 col-sm-3 col-xs-12">
<p><strong>Remarks</strong><span>:</span></p>
</div>
<div class="pad0 col-sm-9 col-xs-12">
<p title=""></p>
</div>
</div>
</div>
</div>
</div>
</div>
</div>

<div class="col-md-7 col-sm-7 col-xs-12">
<ul class="nav nav-tabs">
    <li class="active"><a data-toggle="tab" onclick="showHide('Follow');" aria-expanded="true" class="fa fa-comments">&nbsp;&nbsp;Follow-Up Sales</a></li>
    <li class=""><a data-toggle="tab" onclick="showHide('payment');" aria-expanded="false" class="fa fa-money">&nbsp;&nbsp;Add Payment Details</a></li>
    <li class=""><a data-toggle="tab" onclick="showHide('estimate');" aria-expanded="false" class="fa fa-file-text">&nbsp;&nbsp;Estimate Invoice</a></li>
    <li class=""><a data-toggle="tab" onclick="showHide('price');" aria-expanded="false" class="fa fa-inr">&nbsp;&nbsp;Price Details</a></li>
    <li class=""><a data-toggle="tab" onclick="showHide('document');" aria-expanded="false" class="fa fa-folder">&nbsp;Documents</a></li>
</ul>

<!--Add new documents  -->
<div class="menuDv clearfix form-group"  id="Documents" style="display: none;">
<div class="clearfix partner-slider8">
<form onsubmit="return false;" name="follow-up-form" style="padding-left: 28px;padding-top: 10px;padding-right: 28px;" id="UploadDocument">
   <input type="hidden" name="salerefid" value=""/>
   <div class="marg-05 row">
   	  <div class="pad05 col-md-6 col-sm-6 col-xs-6">
        <div class="clearfix form-group mtop10">
        <div class="clearfix relative_box">
        <input type="text" id="Doc_Date" autocomplete="off" value="<%=today %>" name="docdate"  class="form-control" placeholder="Today Date !" readonly="readonly"/>
        </div>
        </div>
        </div>
      <div class="pad05 col-md-6 col-sm-6 col-xs-6">
        <div class="clearfix form-group mtop10">
        <div class="clearfix relative_box">
<!--           <input type="text" name="doctype" id="Document_Type" placeholder="Enter Document Type !" class="form-control"> -->
          <select name="doctype" id="Document_Type" class="form-control">         
          <option value="General">General</option>
           <option value="">Select Document Type</option>
          </select>
        </div>
        </div>
        </div>        
     </div>
     <div class="marg-05 row">
      <div class="pad05 col-md-6 col-sm-6 col-xs-6">
        <div class="clearfix form-group mtop10">
        <div class="clearfix relative_box">
         <input type="text" name="docname" id="Document_Name" placeholder="Enter Document Name !" class="form-control">
        </div>
        </div>
        </div>
        <div class="pad05 col-md-6 col-sm-6 col-xs-6">
        <div class="clearfix form-group mtop10">
        <div class="clearfix relative_box">
        <span style="position: absolute;color: red;font-size: 11px;margin-top: -16px;margin-left: 2px;">Max-Size(4mb)</span>
        <input type="file" id="DocumentFile" autocomplete="off" name="documentfile" onchange="fileSize(this)"  class="form-control" placeholder="Select Upload Document here !"/>
        </div>
        </div>
        </div>
     </div> 
        <div class="clearfix item-product-info form-group">
              <button class="form-control" type="submit" onclick="return uploadFile(event);" style="background: limegreen;color: #ffff;font-size: 17px;">Upload</button>
        </div>
    </form>
    <div class="col-md-12">
       <div class="row">
		<div class="col-md-12 col-sm-12 col-xs-12">
		<div class="clearfix">
		<div class="box-width25 col-xs-1 box-intro-bg">
		<div class="box-intro-border">
		<p class="news-border" title="Enquiry Date">S.N.</p>
		</div>
		</div>
		<div class="box-width14 col-xs-1 box-intro-bg">
		<div class="box-intro-border">
		<p class="news-border" title="Enquiry Date">Date</p>
		</div>
		</div>
		<div class="box-width4 col-xs-1 box-intro-bg">
		<div class="box-intro-border">
		<p class="news-border" title="Follow Up Date">Document Type</p>
		</div>
		</div>
		<div class="box-width47 col-xs-1 box-intro-bg">
		<div class="box-intro-border">
		<p class="news-border" title="Next Follow Up Date">Document Name</p>
		</div>
		</div>
		<div class="box-width8 col-xs-1 box-intro-bg">
		<div class="box-intro-border">
		<p title="Action">Action</p>
		</div>
		</div>
		</div>
		</div>
		</div>
		<div class="scroll" id="DocumentRefresh">	
		<div id="DocumentRefresh1">
		
		<div class="clearfix box_shadow2">
		<div class="box-width25 col-xs-1 box-intro-background">
		<div class="link-style12">
		<p class="news-border" title="" >1</p>
		</div>
		</div>
		<div class="box-width14 col-xs-1 box-intro-background">
		<div class="link-style12">
		<p class="news-border" title="" ></p>
		</div>
		</div>
		<div class="box-width4 col-xs-1 box-intro-background">
		<div class="link-style12">
		<p class="news-border" title=""></p>
		</div>
		</div>
		<div class="box-width47 col-xs-1 box-intro-background">
		<div class="link-style12">
		<p class="news-border" title=""></p>
		</div>
		</div>		
		<div class="box-width8 col-xs-1 box-intro-background">
		<div class="link-style12">
<!-- 		<p class="news-border" title=""> -->
<!-- 		<a href="" class="quick-view" onclick=""><i class="fa fa-eye" title="View Document"></i></a> -->
<!-- 		<a href="" onclick=""><i class="fa fa-download" title="Download Document"></i></a> -->
<%-- 		<a href="#deleteDocument" class="quick-view" onclick="document.getElementById('docuid').innerHTML='<%=salesdoc[i][0] %>';"><i class="fa fa-trash" title="Delete This document"></i></a> --%>
<!-- 		</p> -->
        <p class="news-border" title="">
		<a href="" class="quick-view" onclick=""><i class="fa fa-eye" title="View Document"></i></a>
		<a href="" onclick=""><i class="fa fa-download" title="Download Document"></i></a>
		<a onclick="deleteSalesDoc('');"><i class="fa fa-trash" title="Delete This document"></i></a>
		</p>
		</div>
		</div>
		</div>				
		</div>
<!-- 		<div class="col-xs-12 box-intro-background" style="text-align: center;margin-top: 36px;"> -->
<!-- 		<span style="color: red;text-align: center;">No Data Found !</span> -->
<!-- 		</div> -->
		
		</div>
      </div>  
	</div>
	</div>

<!--Add payment details  -->
<div class="menuDv clearfix form-group"  id="Payment" style="display: none;">
<!-- <div class="mb0 pad_box2 top_title pointers add_follow_title"> -->
<%-- <h2 class="fa fa-money">&nbsp;&nbsp;Add Payment Details of&nbsp;&nbsp;<span style="color:red;"><%=name %></span></h2> --%>
<!-- <i class="fa fa-plus" title="Add Follow-Up"></i> -->
<!-- </div> -->
<div class="clearfix partner-slider8">
<form onsubmit="return false;" name="follow-up-form" style="padding-left: 28px;padding-top: 10px;padding-right: 28px;" id="AddPayment">
   <input type="hidden" name="sref" id="sref" value="<%=sref %>"/>
   <div class="marg-05 row">
      <div class="pad05 col-md-6 col-sm-6 col-xs-6">
        <div class="clearfix form-group mtop10">
        <div class="clearfix relative_box">
          <select id="PayOption" name="payoption" class="form-control" onchange="payOption(this.value)">
             <option value="">Select Payment Method</option>
             <option value="Online">Online</option>
             <option value="Cash">Cash</option>
           </select>
        </div>
        </div>
        </div>
        <div class="pad05 col-md-6 col-sm-6 col-xs-6">
        <div class="clearfix form-group mtop10">
        <div class="clearfix relative_box">
        <input type="text" id="PmtDate" value="<%=today %>" autocomplete="off" name="pmdate"  class="form-control readonlyAllow datepicker" placeholder="Select Payment Date !" readonly/>
        </div>
        </div>
        </div>
     </div>
     <div class="marg-05 row">
      <div class="pad05 col-md-6 col-sm-6 col-xs-6">
        <div class="clearfix form-group mtop10">
        <div class="clearfix relative_box">
        <input type="text" id="TransId" autocomplete="off" name="transid"  class="form-control" placeholder="Enter Transaction Id here !"/>
        </div>
        </div>
        </div>
        <div class="pad05 col-md-6 col-sm-6 col-xs-6">
        <div class="clearfix form-group mtop10">
        <div class="clearfix relative_box">
        <input type="text" id="TransAmount" autocomplete="off" name="transamount"  class="form-control" placeholder="Enter Transaction Amount here !" onkeypress="return isNumberKey(event)"/>
        </div>
        </div>
        </div>
     </div> 
     <div class="row"><h4 style="text-align: center;">OR</h4></div>
   <div class="marg-05 row">
      <div class="pad05 col-md-6 col-sm-6 col-xs-6">
        <div class="clearfix form-group mtop10">
        <div class="clearfix relative_box">
         <p><sup style="color: red;font-size: 26px;position: absolute;margin-top: 17px;margin-left: -8px;">*</sup><span style="color: #139cd0;">Select Transaction Receipt To Upload</span>(<span style="color: #dc9b88;">Must be transaction id,Date and Amount</span>)<span style="color: red;">(Max Size 4mb)</span></p>
        </div>
        </div>
        </div>
        <div class="pad05 col-md-6 col-sm-6 col-xs-6">
        <div class="clearfix form-group mtop10">
        <div class="clearfix relative_box">
        <input type="file" id="payfile" autocomplete="off" onchange="receiptFileSize(this)" name="payfile"  class="form-control"/>
        </div>
        </div>
        </div>
     </div>
        <div class="clearfix item-product-info form-group">
              <button class="form-control" type="submit" onclick="return payAmount();" style="background: limegreen;color: #ffff;font-size: 17px;">Submit</button>
        </div>
    </form>
    <div class="col-md-12">
       <div class="row">
		<div class="col-md-12 col-sm-12 col-xs-12">
		<div class="clearfix">
		<div class="box-width8 col-xs-1 box-intro-bg">
		<div class="box-intro-border">
		<p class="news-border" title="Enquiry Date">Date</p>
		</div>
		</div>
		<div class="box-width3 col-xs-1 box-intro-bg">
		<div class="box-intro-border">
		<p class="news-border" title="Follow Up Date">Payment Mode</p>
		</div>
		</div>
		<div class="box-width26 col-xs-1 box-intro-bg">
		<div class="box-intro-border">
		<p class="news-border" title="Next Follow Up Date">Transaction Id</p>
		</div>
		</div>
		<div class="box-width11 col-xs-1 box-intro-bg">
		<div class="box-intro-border">
		<p class="news-border" title="Enquiry Type">Amount</p>
		</div>
		</div>
		<div class="box-width9 col-xs-1 box-intro-bg">
		<div class="box-intro-border">
		<p title="Action">Status</p>
		</div>
		</div>
		<div class="box-width5 col-xs-1 box-intro-bg">
		<div class="box-intro-border">
		<p title="Action">Action</p>
		</div>
		</div>
		</div>
		</div>
		</div>		
      </div>  
	</div>
	</div>

<!--project price details  -->
<div class="menuDv clearfix form-group" id="PriceDetails" style="display: none;padding-top: 20px;">
<div class="clearfix partner-slider8">
<div class="col-md-12">
       <div class="row">
		<div class="col-md-12 col-sm-12 col-xs-12">
		<div class="clearfix">
		<div class="box-width3 col-xs-1 box-intro-bg">
		<div class="box-intro-border">
		<p class="news-border" title="Enquiry Date">Price Type</p>
		</div>
		</div>
		<div class="box-width9 col-xs-1 box-intro-bg">
		<div class="box-intro-border">
		<p class="news-border" title="Follow Up Date">Price</p>
		</div>
		</div>
		<div class="box-width11 col-xs-1 box-intro-bg">
		<div class="box-intro-border">
		<p class="news-border" title="Next Follow Up Date">Service Type</p>
		</div>
		</div>
		<div class="box-width3 col-xs-1 box-intro-bg">
		<div class="box-intro-border">
		<p class="news-border" title="Enquiry Type">GST</p>
		</div>
		</div>
		<div class="box-width9 col-xs-1 box-intro-bg">
		<div class="box-intro-border">
		<p class="news-border" title="Enquiry Type">GST Amount</p>
		</div>
		</div>
		<div class="box-width3 col-xs-1 box-intro-bg">
		<div class="box-intro-border">
		<p class="news-border" title="Enquiry Type">Total Amount</p>
		</div>
		</div>		
		</div>
		</div>
		</div>
		<div class="scroll" style="width:658px !important;">
	
		<div class="clearfix box_shadow2">
		<div class="box-width3 col-xs-1 box-intro-background">
		<div class="link-style12">
		<p class="news-border" title="" ></p>
		</div>
		</div>
		<div class="box-width9 col-xs-1 box-intro-background">
		<div class="link-style12">
		<p class="news-border" title=""><i class="fa fa-inr"></i>&nbsp;&nbsp;</p>
		</div>
		</div>
		<div class="box-width11 col-xs-1 box-intro-background">
		<div class="link-style12">
		<p class="news-border" title=""></p>
		</div>
		</div>
		
		<div class="box-width3 col-xs-1 box-intro-background">
		<div class="link-style12">
		<p class="news-border" title=""></p>
		</div>
		</div>
		<div class="box-width9 col-xs-1 box-intro-background">
		<div class="link-style12">
		<p class="news-border" title=""><i class="fa fa-inr"></i>&nbsp;&nbsp;</p>
		</div>
		</div>
		<div class="box-width3 col-xs-1 box-intro-background">
		<div class="link-style12">
		<p class="news-border" title=""><i class="fa fa-inr"></i>&nbsp;&nbsp;</p>
		</div>
		</div>
		
		</div>
		<div class="clearfix" style="position: absolute;margin-left: 460px;margin-top: -34px;color: #05b7fb;font-size: 16px;">
		<span>Sub Total&nbsp;:</span><span class="fa fa-inr">&nbsp;&nbsp;896859.00</span>
		</div>
		
		</div>
      </div>


</div>
</div> 
<!--Estimate Invoice details  -->
<div class="menuDv clearfix form-group" id="EstimateInvoice" style="display: none;padding-top: 10px;">
<div class="clearfix partner-slider8">
<div class="clearfix text-right">
<a style="margin-right: 16px;" onclick="sendEstimateInvoice();"><button class="btn-warning">Generate Estimate Invoice</button></a>
</div>
<div class="col-md-12">
       <div class="row">
		<div class="col-md-12 col-sm-12 col-xs-12">
		<div class="clearfix">
		<div class="box-width12 col-xs-1 box-intro-bg">
		<div class="box-intro-border">
		<p class="news-border" title="Enquiry Date">Date</p>
		</div>
		</div>
		<div class="box-width13 col-xs-1 box-intro-bg">
		<div class="box-intro-border">
		<p class="news-border" title="Follow Up Date">Invoice No.</p>
		</div>
		</div>
		<div class="box-width4 col-xs-1 box-intro-bg">
		<div class="box-intro-border">
		<p class="news-border" title="Next Follow Up Date">Paid</p>
		</div>
		</div>
		<div class="box-width6 col-xs-1 box-intro-bg">
		<div class="box-intro-border">
		<p class="news-border" title="Enquiry Type">Total Amount</p>
		</div>
		</div>
		<div class="box-width12 col-xs-1 box-intro-bg">
		<div class="box-intro-border">
		<p title="Action">Status</p>
		</div>
		</div>
		<div class="box-width9 col-xs-1 box-intro-bg">
		<div class="box-intro-border">
		<p title="Action">Action</p>
		</div>
		</div>
		</div>
		</div>
		</div>
		<div class="scroll" id="EstimateInvRef">
		<div id="EstimateInvRef1">

		<div class="clearfix box_shadow2">
		<div class="box-width12 col-xs-1 box-intro-background">
		<div class="link-style12">
		<p class="news-border" title="" ></p>
		</div>
		</div>
		<div class="box-width13 col-xs-1 box-intro-background">
		<div class="link-style12">
		<p class="news-border" title=""></p>
		</div>
		</div>
		<div class="box-width4 col-xs-1 box-intro-background">
		<div class="link-style12">
		<p class="news-border" title=""><i class="fa fa-inr"></i>&nbsp;&nbsp;0</p>
		</div>
		</div>
		<div class="box-width6 col-xs-1 box-intro-background">
		<div class="link-style12">
		<p class="news-border" title=""><i class="fa fa-inr"></i>&nbsp;&nbsp;99999</p>
		</div>
		</div>
		<div class="box-width12 col-xs-1 box-intro-background">
		<div class="link-style12">
		<p class="news-border" title="" style="">Not paid</p>
		</div>
		</div>
		<div class="box-width9 col-xs-1 box-intro-background">
		<div class="link-style12">
		<p class="news-border" title="">
		<a href="javascript:void(0)" onclick="alert('work is in progress..');"><i class="fa fa-eye" title="view"></i></a>
		<a href="javascript:void(0)" onclick="alert('work is in progress..');"><i class="fa fa-send" title="send to client"></i></a>
		<a href="javascript:void(0)" onclick="alert('work is in progress..');"><i class="fa fa-trash" title="delete"></i></a>
		</p>
		</div>
		</div>
		</div>		
		</div>
		</div>
      </div>


</div>
</div>


<div class="menuDv clearfix form-group" id="FollowUpSale">
<!-- <div class="mb0 pad_box2 top_title pointers add_follow_title"> -->
<!-- <h2 class="fa fa-comments">&nbsp;&nbsp;Follow Up Sales</h2> -->
<!-- <i class="fa fa-plus" title="Add Follow-Up"></i> -->
<!-- </div> -->
<div class="clearfix partner-slider8">
<form onsubmit="return false;" name="follow-up-form" id="Follow-Up-Sale">
<input type="hidden" name="enqfeuid" id="enqfeuid" value="" readonly>
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix footer-bottom2">
<div class="col-sm-4 col-xs-12  box-intro-background">
<div class="add-enquery">
<i class="fa fa-calendar textboxicon"></i>
<input type="text" class="textfbox" id="Today" name="today" value="<%=today %>" readonly/>
</div>
</div>
<div class="col-sm-4 col-xs-12  box-intro-background">
<div class="add-enquery">
<i class="fa fa-star textboxicon"></i>
       <select name="enqfstatus" id="enqfstatus" class="textfbox">
         <option value="">Select Status</option>
         <option value="Hot">Hot</option>
         <option value="Warm">Warm</option>
         <option value="Cold">Cold</option>
         <option value="Converted">Converted</option>
         <option value="lost">Lost</option>
       </select>
  <div id="MakeEerorMSGdiv1" class="errormsg error_box"></div>                            
</div>
</div>
<div class="col-sm-4 col-xs-12  box-intro-background">
<div class="add-enquery">
<i class="fa fa-calendar textboxicon"></i>
<input class="pointers textfbox" type="text" name="enqfdate" id="date" placeholder="Next Folow-Up Date" readonly>
 <div id="MakeEerorMSGdiv2" class="errormsg error_box"></div>
 </div>
 </div>
</div>
<div class="clearfix">
<div class="col-xs-12  box-intro-background">
<div style="margin-top: 10px;">
<i class="fa fa-comments textareabox" style="color: #4ac4f3;"></i>
<textarea name="enqfremark" class="textfbox" style="width: 97%;margin-left: 10px;height: 59px;" id="enqfremark" placeholder="Enter Remarks"></textarea>
  <div id="MakeEerorMSGdiv3" class="errormsg error_box"></div>
</div>
<div id="pfuremarkerr" class="errormsg"></div>
</div>
</div>
<div class="clearfix" style="margin-top: 10px;">
<div class="col-md-4 box-intro-background">
<div class="clearfix add-enquery">
<select name="showdelivery" id="ShowToDelivery" class="form-control">
<option value="">Show to delivery team ?</option>
<option value="1">Yes</option>
<option value="0">No</option>
</select>
</div>
<div id="showdeliveryerr" class="errormsg"></div>
</div>
<div class="col-md-8 col-xs-12 box-intro-background" >
<div class="clearfix add-enquery" style="text-align: right;">
<button type="submit" class="bt-link bt-radius bt-loadmore" onclick="return statusValidations();">Submit</button>
</div>
</div>
</div>
</div>
</form>
</div>
</div>


<div class="clearfix menuDv form-group" id="History">
<div id="History1">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<ul class="nav nav-tabs">
    <li class="active"><a data-toggle="tab" onclick="showHideHistory('sales');" aria-expanded="true" class="fa fa-history">&nbsp;&nbsp;Sales history</a></li>
    <li class=""><a data-toggle="tab" onclick="showHideHistory('work');" aria-expanded="false" class="fa fa-history">&nbsp;&nbsp;Work history</a></li>    
</ul>
<div class="top_title pad_box2">
<!-- <h2 class="fa fa-history">&nbsp;&nbsp;Communication History</h2> -->
</div>
<%-- <a class="mrt10 pad-top5 add_btn font_size15"><strong>Delivery Date : </strong><%=getProjectById[0][5] %></a> --%>
</div>
</div>
<div id="SalesHistory">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12 cmhistscroll">

<div class="clearfix communication_history">
<div class="communication_item clearfix">
<div class="communication_item_lft">
<span class="communication_icon">
<img src="<%=request.getContextPath() %>/staticresources/images/male_icon1.png">
</span>
<div class="clearfix communication_info">
<span class="cmhistname"></span>
<span class="clearfix cmhistmsg">
<span></span>
</span>
<span class="cmhist">&nbsp;</span>
</div>
</div>
<!-- <span class="action_box"> -->
<%-- <a <%if(userroll.equalsIgnoreCase("Administrator")){ %>onclick="deleteFollowUp(<%=getFollowUpById[i][0]%>);"<%}else{ %>style="cursor: not-allowed;"<%} %>><i class="fa fa-trash-o"></i></a> --%>
<!-- </span> -->
</div>
<div class="communication_item_rt clearfix">
<div class="clearfix communication_info">
<span class="cmhistname"></span>
<span class="clearfix cmhistmsg">
<span></span>
</span>
<span class="cmhist">&nbsp;</span>
</div>
<span class="communication_icon">
<img src="<%=request.getContextPath() %>/staticresources/images/male_icon2.png">
</span>
</div>

</div>
</div>
</div>
</div>


<div id="WorkHistory" style="display: none;">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12 cmhistscroll">

<div class="clearfix communication_history">
<div class="communication_item clearfix">
<div class="communication_item_lft">
<span class="communication_icon">
<img src="<%=request.getContextPath() %>/staticresources/images/male_icon1.png">
</span>
<div class="clearfix communication_info">
<span class="cmhistname"></span>
<span class="clearfix cmhistmsg">
<span></span>
</span>
<span class="cmhist"></span>
</div>
</div>
<!-- <span class="action_box"> -->
<%-- <a <%if(userroll.equalsIgnoreCase("Administrator")){ %>onclick="deleteFollowUp(<%=getFollowUpById[i][0]%>);"<%}else{ %>style="cursor: not-allowed;"<%} %>><i class="fa fa-trash-o"></i></a> --%>
<!-- </span> -->
</div>

<div class="communication_item_rt clearfix">
<div class="clearfix communication_info">
<span class="cmhistname"></span>
<span class="clearfix cmhistmsg">
<span></span>
</span>
<span class="cmhist"></span>
</div>
<span class="communication_icon">
<img src="<%=request.getContextPath() %>/staticresources/images/male_icon2.png">
</span>
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
</div>
<section class="clearfix" id="deletetransaction" style="display: none;">
<div class="clearfix  text-center">
<div class="col-md-12 col-xs-12" id="paymentid" style="display: none;"></div>
<div class="col-md-12 col-xs-12">
<div class="box-intro1">
  <h2><span class="title">Warning : Want to delete this Transaction Details ?</span></h2>
  <span id="DelerrMsg" class="" style="font-size: 14px;padding-top: 6px;display: block;min-height: 15px;"></span>
</div>
</div>
<div class="col-md-12 col-xs-12 mb10">
<a class="sub-btn1" onclick="$.fancybox.close();" id="cancelpopup">Cancel</a>

<!-- <a class="sub-btn1" onclick="return deleteDistributor(document.getElementById('userid').innerHTML,'1');" title="Approve this Distributor">Activate</a> -->
<button class="sub-btn1 mlft10" id="cancelpopup1" onclick="return deletePayment(document.getElementById('paymentid').innerHTML);" title="Delete this transaction">Delete</button>
</div>
</div>
</section>

<section class="clearfix" id="deleteDocument" style="display: none;">
<div class="clearfix  text-center">
<div class="col-md-12 col-xs-12" id="docuid" style="display: none;"></div>
<div class="col-md-12 col-xs-12">
<div class="box-intro1">
  <h2><span class="title">Warning : Want to delete this Document ?</span></h2>
  <span id="DelerrMsg" class="" style="font-size: 14px;padding-top: 6px;display: block;min-height: 15px;"></span>
</div>
</div>
<div class="col-md-12 col-xs-12 mb10">
<a class="sub-btn1" onclick="$.fancybox.close();" id="cancelpopup">Cancel</a>

<!-- <a class="sub-btn1" onclick="return deleteDistributor(document.getElementById('userid').innerHTML,'1');" title="Approve this Distributor">Activate</a> -->
<button class="sub-btn1 mlft10" id="" onclick="return deleteSalesDoc(document.getElementById('docuid').innerHTML);" title="Delete this document">Delete</button>
</div>
</div>
</section>

<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<div id="jsfile"></div>
<script>
	$(function() {
		$("#date").datepicker({
			changeMonth: true,
			changeYear: true,
			dateFormat: 'dd-mm-yy'
		});
	});
</script>
<script type="text/javascript">
// bkLib.onDomLoaded(function(){nicEditors.editors.push(new nicEditor().panelInstance(document.getElementById('enqfremark')));});
</script>
<script type="text/javascript">
function receiptFileSize(file){
	const fi=document.getElementById('payfile');
	if (fi.files.length > 0) {
		const fsize = fi.files.item(0).size; 
        const file = Math.round((fsize / 1024)); 
        // The size of the file. 
        if (file >= 4096) {  
            document.getElementById('errorMsg').innerHTML ='File too Big, please select a file less than 4mb';
            document.getElementById("payfile").value="";
 		    $('.alert-show').show().delay(4000).fadeOut();
        }		
	}
}

function fileSize(file){
	const fi=document.getElementById('DocumentFile');
	if (fi.files.length > 0) {
		const fsize = fi.files.item(0).size; 
        const file = Math.round((fsize / 1024)); 
        // The size of the file. 
        if (file >= 4096) {  
            document.getElementById('errorMsg').innerHTML ='File too Big, please select a file less than 4mb';
            document.getElementById("DocumentFile").value="";
 		    $('.alert-show').show().delay(4000).fadeOut();
        }		
	}
}

function uploadFile(event) {
    event.stopPropagation();
    event.preventDefault();
    //var files = files;
    var form = document.getElementById('UploadDocument');
    var data = new FormData(form);
    postFilesData(data);
}

function postFilesData(data) {
    $.ajax({
        url :  'UploadSalesDocument111',
        type : 'POST',
        data : data,
        cache : false,
        dataType : 'json',
        processData : false,
        contentType : false,
        success : function(data) {
//         	if(data=="pass")alert("hello");
        },  
        error : function(jqXHR, textStatus, errorThrown) {
        	document.getElementById('errorMsg').innerHTML = 'Document Uploaded Successfully.';
        	document.getElementById('errorMsg').style.background="green";
        	document.getElementById('errorMsg').style.color="#ffff";
        	$("#UploadDocument").trigger("reset");
			$("#DocumentRefresh").load(location.href + " #DocumentRefresh1");
			$('.alert-show').show().delay(2000).fadeOut();
        }
    });
}

function deleteSalesDoc(id){
	var x = confirm("Are you sure you want to delete?");
	if(x){
	$.ajax({
		type: "GET",
		dataType: "html",
		url: "<%=request.getContextPath()%>/deleteSalesDocument111",
		data:  {
			id:id
		},
		success: function (data) {	
			if(data=="pass"){
				$.fancybox.close();
				document.getElementById('errorMsg').innerHTML = 'Document Deleted Successfully.';
	        	document.getElementById('errorMsg').style.background="green";
	        	document.getElementById('errorMsg').style.color="#ffff";	        	
				$("#DocumentRefresh").load(location.href + " #DocumentRefresh1");
				$('.alert-show').show().delay(2000).fadeOut();
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something Went Wrong.';
	        	document.getElementById('errorMsg').style.background="red";
	        	document.getElementById('errorMsg').style.color="#ffff";	
				$('.alert-show').show().delay(2000).fadeOut();				
			}
		},
		error: function (error) {
		alert("error in deleteSalesDoc() " + error.responseText);
		}
		});	
	}
}

function sendEstimateInvoice(){
	$.ajax({
		type: "GET",
		dataType: "html",
		url: "<%=request.getContextPath()%>/htmltopdfreceipt.html?refid=",
		data:  {
		},
		success: function (data) {	
			if(data=="pass"){
			document.getElementById('errorMsg').innerHTML = 'Estimate Invoice Sended To Client.';
			$("#EstimateInvRef").load(location.href + " #EstimateInvRef1");
			$('.alert-show').show().delay(2000).fadeOut();			
			}
		},
		error: function (error) {
		alert("error in deletePayment() " + error.responseText);
		}
		});
}

function deletePayment(srefid){
	var x = confirm("Are you sure you want to delete?");
	if(x){
	$.ajax({
		type: "GET",
		dataType: "html",
		url: "<%=request.getContextPath()%>/deletsalespayment111",
		data:  {
			srefid : srefid
		},
		success: function (data) {
			if(data=="pass"){$.fancybox.close();
				document.getElementById('errorMsg').innerHTML = 'Deleted successfully.';
				document.getElementById('errorMsg').style.background="green";
	        	document.getElementById('errorMsg').style.color="#ffff";
			}else if(data=="fail"){
				document.getElementById('errorMsg').innerHTML = 'Something Went Wrong !.';
			}
			$("#AddPaymmentDisp").load(location.href + " #AddPaymmentDisp1");			
			$('.alert-show').show().delay(2000).fadeOut();
		},
		error: function (error) {
		alert("error in deletePayment() " + error.responseText);
		}
		});
	}
}
function showHideHistory(status){
	if(status=="sales"){
		$("#WorkHistory").css("display", "none");
		$("#SalesHistory").css("display", "block");
	}
	else if(status=="work"){
		$("#WorkHistory").css("display", "block");
		$("#SalesHistory").css("display", "none");
	}
}

function showHide(status){    
	if(status=="Follow"){
		$("#Payment").css("display", "none");
		$("#EstimateInvoice").css("display", "none");
		$("#FollowUpSale").css("display", "block");
		$("#PriceDetails").css("display", "none");
		$("#Documents").css("display", "none");
	}
	else if(status=="payment"){
		$("#FollowUpSale").css("display", "none");
		$("#EstimateInvoice").css("display", "none");
		$("#Payment").css("display", "block");
		$("#PriceDetails").css("display", "none");
		$("#Documents").css("display", "none");
    }
	else if(status=="estimate"){
		$("#Payment").css("display", "none");
		$("#EstimateInvoice").css("display", "block");
		$("#FollowUpSale").css("display", "none");
		$("#PriceDetails").css("display", "none");
		$("#Documents").css("display", "none");
    }
	else if(status=="price"){
		$("#Payment").css("display", "none");
		$("#EstimateInvoice").css("display", "none");
		$("#FollowUpSale").css("display", "none");
		$("#PriceDetails").css("display", "block");
		$("#Documents").css("display", "none");
	}
	else if(status=="document"){
		$("#Payment").css("display", "none");
		$("#EstimateInvoice").css("display", "none");
		$("#FollowUpSale").css("display", "none");
		$("#PriceDetails").css("display", "none");
		$("#Documents").css("display", "block");
	}

}

function payOption(val){
	if(val=="Cash"){
		document.getElementById("TransId").value="NA";
		$('#TransId').attr('readonly',true);
	}else{
		document.getElementById("TransId").value="";
		$("#TransId").removeAttr("readonly");
	}		
	}

function payAmount(){
	if(document.getElementById("payfile").files.length==0)
	{
	if(document.getElementById("PayOption").value.trim()==""){
		document.getElementById('errorMsg').innerHTML = 'Select Payment method.';
		$('.alert-show').show().delay(2000).fadeOut();
		return false;
	}
	if(document.getElementById("PmtDate").value.trim()==""){
		document.getElementById('errorMsg').innerHTML = 'Select Payment Date.';
		$('.alert-show').show().delay(2000).fadeOut();
		return false;
	}
	if(document.getElementById("PayOption").value.trim()=="Online"){
	if(document.getElementById("TransId").value.trim()==""){
		document.getElementById('errorMsg').innerHTML = 'Enter transaction Id.';
		$('.alert-show').show().delay(2000).fadeOut();
		return false;
	}
	}
	if(document.getElementById("TransAmount").value.trim()==""){
		document.getElementById('errorMsg').innerHTML = 'Enter Transaction Amount.';
		$('.alert-show').show().delay(2000).fadeOut();
		return false;
	}
	var payoption=document.getElementById("PayOption").value.trim();
	var pdate=document.getElementById("PmtDate").value.trim();
	var transid=document.getElementById("TransId").value.trim();
	var transamt=document.getElementById("TransAmount").value.trim();
	var sref="<%=sref%>";
	var enqid="<%=sales[0][0]%>";
	
	$.ajax({
		type: "POST",
		dataType: "html",
		url: "<%=request.getContextPath()%>/addestimatepayment.html",
		data:  {
			payoption : payoption,
			pdate : pdate,
			transid : transid,
			transamt : transamt,
			sref : sref,
			enqid:enqid
		},
		success: function (data) {
			document.getElementById('errorMsg').innerHTML = 'Payment Details successfully added.';
			document.getElementById('errorMsg').style.background="green";
			document.getElementById('errorMsg').style.color="#ffff";
			$("#AddPayment").trigger("reset");
			$("#AddPaymmentDisp").load(location.href + " #AddPaymmentDisp1");
			$("#History").load(location.href + " #History1");	
			$('.alert-show').show().delay(2000).fadeOut();
		},
		error: function (error) {
		alert("error in payAmount() " + error.responseText);
		}
		});
	}else{
		    event.stopPropagation();
		    event.preventDefault();
		    //var files = files;
		    var form = document.getElementById('AddPayment');
		    var data = new FormData(form);
		    uploadPaymentReceipt(data);		
	}
	
}
function uploadPaymentReceipt(data) {
    $.ajax({
        url :  'UploadPaymentReceipt111',
        type : 'POST',
        data : data,
        cache : false,
        dataType : 'json',
        processData : false,
        contentType : false,
        success : function(data) {
//         	if(data=="pass")alert("hello");
        },  
        error : function(jqXHR, textStatus, errorThrown) {
        	document.getElementById('errorMsg').innerHTML = 'Document Uploaded Successfully.';
        	document.getElementById('errorMsg').style.background="green";
        	document.getElementById('errorMsg').style.color="#ffff";
        	$("#AddPaymmentDisp").load(location.href + " #AddPaymmentDisp1");	
			$('.alert-show').show().delay(2000).fadeOut();
        }
    });
}

	function statusValidations() {
	var today=document.getElementById('Today').value.trim();
	var enqfeuid=document.getElementById('enqfeuid').value.trim();	
		
	var enqfstatus=document.getElementById('enqfstatus').value.trim();
	var enqfdate=document.getElementById('date').value.trim();
	var enqfremark =document.getElementById( "enqfremark" ).value.trim();
 	var showdelivery=document.getElementById('ShowToDelivery').value.trim();	
// 	alert("called."+today+"/"+enqfeuid);

	if(enqfstatus=="" ) {
		document.getElementById('errorMsg').innerHTML = 'Status is required.';
		$('.alert-show').show().delay(2000).fadeOut();
	    return false;
	}
	if(enqfdate=="" ) {
		document.getElementById('errorMsg').innerHTML = 'Date is required.';
		$('.alert-show').show().delay(2000).fadeOut();
	    return false;
	}
	if(enqfremark=="" ) {
		document.getElementById('errorMsg').innerHTML = 'Remarks is required.';
		$('.alert-show').show().delay(2000).fadeOut();
	    return false;
	}
	if(showdelivery=="" ) {
		document.getElementById('errorMsg').innerHTML = 'Select Show To Delivery Team ?.';
		$('.alert-show').show().delay(2000).fadeOut();
	    return false;
	}
	
	$.ajax({
		type: "POST",
		dataType: "html",
		url: "<%=request.getContextPath()%>/follow-up-form.html",
		data:  {
			today: today,
			enqfeuid: enqfeuid,
			enqfstatus: enqfstatus,
			enqfdate: enqfdate,
			enqfremark: enqfremark,
			showdelivery:showdelivery
		},
		success: function (data) {
			$("#Follow-Up-Sale").trigger("reset");
			$("#History").load(location.href + " #History1");
		},
		error: function (error) {
		alert("error in finishorder() " + error.responseText);
		}
		});
}
	function deleteFollowUp(id) {
    	if(confirm("Sure you want to Delete this Follow Up ? "))
    	{
    	var xhttp; 
    	xhttp = new XMLHttpRequest();
    	xhttp.onreadystatechange = function() {
    	if (this.readyState == 4 && this.status == 200) {
//     	$("#ref").load(location.href + " #ref");
// 		location.reload();
    	}
    	};
    	xhttp.open("GET", "<%=request.getContextPath()%>/DeleteFollowUp111?info="+id, true);
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