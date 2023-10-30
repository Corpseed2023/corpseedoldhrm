<!DOCTYPE HTML>
<%@page import="commons.CommonHelper"%>
<%@page import="admin.task.TaskMaster_ACT"%>
<%@page import="admin.enquiry.Enquiry_ACT"%>
<%@page import="client_master.Clientmaster_ACT"%>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Invoice</title>

<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
<style type="text/css">
@media only screen and (max-width: 767px) {
#invoicecontent{
min-height: 150px;
    margin-top: 10px!important;
    width: 100%!important;
    margin-left: 0%!important;}
.gst{opacity:0
    }
    .hsn{
    opacity:0}
    .total_desc{
    width:100%;display:flex;justify-content: end;
    text-align: right;}
    .total_title{
    width:50%;
    padding:2px
   }
    .total_amount{
    width:35%;
     padding:2px;
     font-weight:700}
      .total_mobile{
     display:block!important
     }
     .total_web{
     display:none!important
     }
    }
    .total_mobile{
     display:none
     }
     .cancelled{font-size: 27px;
    position: absolute;
    left: 38%;
    transform: translate(-50%, -50%);
    transform: rotate(-35deg);
    font-weight: 600;
    color: #b1515147;}
    .ref-invoice{
	display: grid;
    padding: 6px;
    text-align: end;
}
body{background: #c3c3c32b;}
@media print {
   body{margin:0;padding:0;font-size:12px;}
   header, footer{display:none;}
   p{margin-bottom:10px;font-size:12px;margin-top:0;}
   #invoicecontent{width: 100% !important;margin-left: 0px !important;}
   img{width: 35%;}
   #printData{display: none;}
   .cancelled{font-size: 27px;
    position: absolute;
    left: 38%;
    transform: translate(-50%, -50%);
    transform: rotate(-35deg);
    font-weight: 600;
    color: #b1515147 !important;}
    .head-white p{color: #fff !important;}
}
</style>
</head>
<body>
<div class="wrap">
<div class="container">
<%
String invoiceKey=request.getParameter("uid").trim();
invoiceKey=invoiceKey.substring(16,invoiceKey.length()-5);
String token=Enquiry_ACT.getTokenByInvoiceKey(invoiceKey);
String invoiceDetails[][]=Enquiry_ACT.getManageInvoice(invoiceKey, token);
String invoiceType="PROFORMA";
if(invoiceDetails!=null&&invoiceDetails[0][0]!=null){
	if(invoiceDetails[0][0].equalsIgnoreCase("DN"))
		invoiceType="DEBIT NOTE";
	else if(invoiceDetails[0][0].equalsIgnoreCase("TAX"))
		invoiceType="INVOICE";
}
%>
<div class="clearfix menuDv pad_box3 pad05 mb10" style="min-height: 150px;margin-top: 16px;width: 50%;margin-left: 25%;" id="invoicecontent">
<div class="clearfix invoice_div">
<div class="clearfix" style="width:100%;padding-top:0px;display: flex;">
<div style="width:50%;">
<div style="margin-bottom:1px;">
<img src="<%=request.getContextPath()%>/staticresources/images/corpseed-logo.png" alt="corpseed logo" style="max-width:95px;">
</div>
<div class="clearfix">
<p>
<span style="font-weight:600;color:#888;">Corpseed ITES Private Limited</span><br>
<span>CN U74999UP2018PTC101873</span><br>
<span>2nd Floor, A-154A, A Block, Sector 63</span><br/>
<span>Noida, Uttar Pradesh - 201301</span><br/>
<span>GSTIN 09AAHCC4539J1ZC</span>
<br>
</p>
</div>
</div>
<div style="width:50%;">
<div style="margin-bottom:10px;text-align:right;">
<h2 style="font-size:18px;margin:0 0 5px;color:#48bd44;font-weight: 500;"><%=invoiceType %></h2>
<p style="font-weight:600;" id="EstimateBillNo">#<%=invoiceDetails[0][6]%></p>
</div><%if(invoiceDetails[0][0].equalsIgnoreCase("DN")){String soldDate=Enquiry_ACT.getSalesRegDate(invoiceDetails[0][1]);%>
<div class="ref-invoice">
	<b>Ref. Invoice</b> <b>#<%=invoiceDetails[0][1] %></b> <span><%=soldDate %></span>
</div><%}if(Double.parseDouble(invoiceDetails[0][8])>0&&!invoiceType.equalsIgnoreCase("PROFORMA")){ %>
<div class="ref-invoice">
	<b style="color:red">Balance Due</b><span>Rs. <%=CommonHelper.withLargeIntegers(Double.parseDouble(invoiceDetails[0][8])) %></span>
</div><%} %>
</div>
</div>
<div class="clearfix" style="width:100%;">
<p style="margin:0px;">Bill To : </p>
<p style="font-weight: 600;margin-bottom: 1rem;"><%=invoiceDetails[0][2] %></p>
<%if(invoiceDetails[0][3]!=null&&!invoiceDetails[0][3].equalsIgnoreCase("NA")){ %>
<p style="margin-top: -1rem;">GSTIN <%=invoiceDetails[0][3] %></p><%} %>
</div>
<div class="clear"></div>
<div class="clearfix" style="width:100%;display: flex;">
<div style="width:50%;">
<p style="margin:0px;"></p>
<p style="margin-bottom:5px;">Ship To : <br>
<span><%=invoiceDetails[0][2] %></span><br>
<span><%=invoiceDetails[0][4] %></span></p>
<p>Place Of Supply: <span><%=invoiceDetails[0][5] %></span></p>
</div>
<div style="width:50%;text-align:right;">
<p><span style="font-weight:600;color:#888;">Date :</span> <span style="padding-left:20px;" id="EstimateDate"><%=invoiceDetails[0][7]%></span></p>
</div>
</div>
<div class="clear"></div>
<div class="table-responsive">
<table style="width:100%">
<tbody>
<tr>
    <td>
<div class="clearfix" style="width:100%;">
<div class="clearfix head-white" style="width:100%;background:#48bd44 !important;padding-bottom:8px;padding-top:8px;border-radius: 3px;display: flex;">
<div style="width:4%;">
<p style="margin:0;color:#fff !important;font-size:11px;">#</p>
</div>
<div style="width:30%;" id="ItemDescriptionId">
<p style="margin:0;font-size:11px;color:#fff">Item &amp; Description </p>
</div>
<div style="width:13%;" class="hsn">
<p style="margin:0;font-size:11px;text-align: right;color:#fff;">HSN</p>
</div>
<div style="width:15%;">
<p style="margin:0;font-size:11px;text-align: right;color:#fff;">Rate</p>
</div>
<div style="width:8%;" id="SGSTTaxId" class="gst">
<p style="margin:0;font-size:11px;text-align: right;color:#fff;">GST %</p>
</div>
<div style="width:12%;" id="CGSTTaxId">
<p style="margin:0;font-size:11px;text-align: right;color:#fff;">GST Amt.</p>
</div>
<div style="width:18%;">
<p style="margin:0;font-size:11px;text-align: right;padding-right: 10px;color:#fff;">Amount</p>
</div>
<div class="clear"></div>
</div>
<%
double totalRate=0;
double totalGstAmt=0;
double totalAmount=0;
int qty=0;
String serviceDetails[][]=Enquiry_ACT.getInvoiceProductList(invoiceKey);
if(serviceDetails!=null&&serviceDetails.length>0){
	for(int i=0;i<serviceDetails.length;i++){
		qty+=1;
%>
<div class="clearfix" style="width:100%;">
<div class="clearfix" style="font-weight: 600;width:100%;display: flex;padding: 4px 0px 4px 0px;">
<div style="width:3%;"><p style="margin: 0; font-size: 11px;">1.</p></div>
<div style="width:97%;">
<p style="margin: 0; font-size: 11px;">&nbsp;<%=serviceDetails[i][1] %> </p>
</div>
</div>
<%
//fee_type,price,hsn,(cgst_percent+sgst_percent+igst_percent) as gst_percent,(cgst_price+sgst_price+igst_price) as gst_price
String paymentDetails[][]=Enquiry_ACT.getInvoiceProductPaymentList(serviceDetails[i][0]);
if(paymentDetails!=null&&paymentDetails.length>0){
	for(int j=0;j<paymentDetails.length;j++){
		double rate=Double.parseDouble(paymentDetails[j][1]);
		int gst=Integer.parseInt(paymentDetails[j][3]);
		double gstAmount=Double.parseDouble(paymentDetails[j][4]);
		double amount=Double.parseDouble(paymentDetails[j][5]);
		totalRate+=rate;
		totalGstAmt+=gstAmount;
		totalAmount+=amount;
%>
<div class="clearfix" style="border-top: 1px solid #ccc;padding: 4px 0px 4px 0px;width:100%;display: flex;font-size: 10px;">
<div style="margin-bottom: 0;padding-left: 16px; width: 34%;"><%=paymentDetails[j][0] %></div>
<div style="width:13%;" class="hsn"><p style="margin:0;text-align: right;"><%=paymentDetails[j][2] %></p></div>
<div style="width:15%;"><p style="margin:0;text-align: right;"><%=CommonHelper.withLargeIntegers(Math.round(rate)) %></p></div>
<div style="width:8%;" class="gst"><p style="margin:0;text-align: right;"><%=gst %> %</p></div>
<div style="width:12%;"><p style="margin:0;text-align: right;"><%=CommonHelper.withLargeIntegers(Math.round(gstAmount)) %></p></div>
<div style="width:18%;"><p style="margin:0;text-align: right;"><%=CommonHelper.withLargeIntegers(Math.round(amount)) %></p></div>
</div>
<%}} %>
<div class="clear"></div>
</div>
<%}} %>
<div class="clearfix total_web" style="font-weight: 600;border-top: 1px dotted black;border-bottom: 1px dotted black;padding: 5px 0px 5px 0px;display: flex;">
	<div style="padding-left: 16px; width: 34%;">
	<p style="margin:0;font-size: 11px;">Total Qty. : &nbsp;<span><%=qty %></span></p></div>
	<div style="width:13%;"><p style="margin:0;text-align: right;font-size: 11px;">&nbsp;</p></div>
	<div style="width:15%;"><p style="margin:0;text-align: right;font-size: 11px;"><%=CommonHelper.withLargeIntegers(Math.round(totalRate)) %></p></div>
	<div style="width:8%;"><p style="margin:0;text-align: right;font-size: 11px;">&nbsp;</p></div>
	<div style="width:12%;"><p style="margin:0;text-align: right;font-size: 11px;"><%=CommonHelper.withLargeIntegers(Math.round(totalGstAmt)) %></p></div>
	<div style="width:18%;"><p style="margin:0;text-align: right;font-size: 11px;" id="TotalPaymentData"><%=CommonHelper.withLargeIntegers(Math.round(totalAmount)) %></p>
	
	</div>	
</div>
<div class="clearfix total_mobile" style="border-top: 1px dotted black;border-bottom: 1px dotted black;padding: 5px 0px 5px 0px;">

<div class="total_desc">
<div class="total_title">
Rate
</div>
<div class="total_amount">
<%=CommonHelper.withLargeIntegers(Math.round(totalRate)) %>
</div>
</div>
<div class="total_desc">
<div class="total_title">
GST Amount
</div>
<div class="total_amount">
<%=CommonHelper.withLargeIntegers(Math.round(totalGstAmt)) %>
</div>
</div>
<div class="total_desc">
<div class="total_title">
Total Amount
</div>
<div class="total_amount">
<%=CommonHelper.withLargeIntegers(Math.round(totalAmount)) %>
</div>
</div>
</div>
<div class="clearfix" style="width:100%;padding: 10px 0 0 0;">
<p style="margin:0;font-size:11px;padding-left:10px;padding-right:10px;text-align:right;">Total In Words: <span style="font-weight:600;padding-left:10px;color:#666;" id="EstimateRupeesInWord"></span></p>
</div>
<%
String invoiceTaxData[][]=Enquiry_ACT.getGenerateInvoiceTaxList(invoiceKey);
if(invoiceTaxData!=null&&invoiceTaxData.length>0){
%>
<div class="clearfix" style="width: 100%" id="DisplayTaxData">
Tax Details
<div class="clearfix" style="width:100%;border: 1px dotted black;margin-top: 10px;" id="DisplayTaxData">
    <div class="clearfix" style="width: 100%;font-weight: 600;text-align: center;border-bottom: 1px dotted black;padding: 5px 0 5px 0px;display: flex;font-size: 10px;">
    	<div style="width: 25%">HSN</div>
    	<div style="width: 25%">SGST %</div>
    	<div style="width: 25%">CGST %</div>
    	<div style="width: 25%">IGST %</div>
    </div>
    <%for(int i=0;i<invoiceTaxData.length;i++){ %>
	   <div class="clearfix taxRemoveBox" style="width: 100%;text-align: center;padding: 5px 0 5px 0px;font-size: 10px;display: flex;<%if(i>0){%>border-top: 1px dotted #ccc;<%}%>">
		   <div style="width: 25%"><%=invoiceTaxData[i][0] %></div>
		   <div style="width: 25%"><%=invoiceTaxData[i][2] %></div>
		   <div style="width: 25%"><%=invoiceTaxData[i][1] %></div>
		   <div style="width: 25%"><%=invoiceTaxData[i][3] %></div>
	   </div>
   <%} %>
</div>
</div>
<%} %>
</div>
</td></tr>
</tbody>
</table>
</div>
<div class="clear"></div>

<div class="clearfix" style="width:100%;margin-top:5px;margin-bottom:5px;">  
<p style="margin-bottom:5px;color:#555;"><span style="font-weight: 600;">Notes :</span> <span></span></p>
<p style="font-size: 11px;color:#888;">This Estimates &amp; price quotation is valid for 7 calendar days from the date of issue.</p>
</div>
<div class="clearfix" style="width:100%;">
<p style="color:#888;">
<span style="display:block;font-weight:600;font-size: 11px;">Payment Options:</span>
<span style="display:block;">
<span style="font-weight:600;">IMPS/RTGS/NEFT:</span> Account Number: 10052624515 || IFSC Code: IDFB0021331 || Beneficiary Name: Corpseed ITES Private Limited || Bank Name: IDFC FIRST Bank, Noida, Sector 63 Branch</span>
<span style="display:block;"><span style="font-weight:600;">Direct Pay:</span> https://www.corpseed.com/payment || <span style="font-weight:600;">Pay via UPI:</span> CORPSEEDV.09@cmsidfc</span>
</p>
</div>
<div class="clearfix" style="width:100%;margin-top:5px;border-top:1px solid #ddd;padding-top:5px;margin-bottom:10px;">
<p style="color:#999;font-size: 11px;">Note: Government fee and corpseed professional fee may differ depending on any additional changes advised the client in the application  or any changes in the government policies</p>
</div>
<div class="clearfix" id="printData" style="font-size: 20px;text-align: center;"><button onclick="window.print()"><i class="fa fa-print">&nbsp;Print</i></button></div>
</div>
</div>

</div>
</div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">

$( document ).ready(function() {
	var totalAmount="<%=Math.round(totalAmount)%>";
	
	numberToWords("EstimateRupeesInWord",Number(totalAmount).toFixed(2));
});

function numberToWords(RupeesId,number) {  
    var digit = ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'];  
    var elevenSeries = ['ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen'];  
    var countingByTens = ['twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'];  
    var shortScale = ['', 'thousand', 'million', 'billion', 'trillion'];  

    number = number.toString();
    number = number.replace(/[\, ]/g, '');
    if (number != parseFloat(number)) return 'not a number';
    var x = number.indexOf('.');
    if (x == -1) x = number.length; if (x > 15) return 'too big';
    var n = number.split(''); 
    var str = ''; 
    var sk = 0;
    for (var i = 0; i < x; i++) { 
    	if ((x - i) % 3 == 2) { 
    		if (n[i] == '1') { 
    			str += elevenSeries[Number(n[i + 1])] + ' '; 
    			i++; sk = 1; 
    			} else if (n[i] != 0) { 
    				str += countingByTens[n[i] - 2] + ' ';
    				sk = 1;
    				} } else if (n[i] != 0) { 
    					str += digit[n[i]] + ' ';
    					if ((x - i) % 3 == 0) str += 'hundred ';
    					sk = 1; 
    					} if ((x - i) % 3 == 1) { 
    						if (sk) str += shortScale[(x - i - 1) / 3] + ' ';
    						sk = 0; 
    						} 
    					} if (x != number.length) {
    							var y = number.length;
    							var str1='point ';
    							var z=0;
    							for (var i = x + 1; i < y; i++) {
    								z=Number(z)+Number(n[i]);
    								str1 += digit[n[i]] + ' '; 
    							}
    							if(z>0){
    								str+=str1;
    							}
    							} 
    						str = str.replace(/\number+/g, ' ');    						 
 document.getElementById(RupeesId).innerHTML="INR "+str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();})+" only.";
}
</script>
</body>
</html>
