<!DOCTYPE HTML>
<%@page import="commons.DateUtil"%>
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
body{background: #c3c3c32b;}
@media print {
   body{margin:0;padding:0;font-size:12px;}
   header, footer{display:none;}
   p{margin-bottom:10px;font-size:12px;margin-top:0;}
   #invoicecontent{width: 100% !important;margin-left: 0px !important;}
   img{width: 35%;}
   #printData{display: none;}
}
</style>
</head>
<body>
<div class="wrap">
<div class="container">
<%
String estimateKey=request.getParameter("uid").trim();
estimateKey=estimateKey.substring(8,estimateKey.length()-5);
String token=(String)session.getAttribute("uavalidtokenno"); 
if(token==null||token.length()<=0)token=Enquiry_ACT.getToken(estimateKey);
String billData[]=Enquiry_ACT.getSalesNumber(estimateKey,token);
String invoiceNo=Enquiry_ACT.getInvoiceNumber(billData[0], token);
if(invoiceNo==null||invoiceNo.equalsIgnoreCase("NA")||invoiceNo.length()<=0)invoiceNo=billData[0];

String client[]=Enquiry_ACT.getClientsDetail(billData[1],token);
if(client[0]==null||client[0].equalsIgnoreCase("NA")||client[0].length()<=0)
	client=Enquiry_ACT.getContactDetail(billData[3],token);

double orderAmount=Clientmaster_ACT.getTotalClientProjectAmount(billData[0],token);  
double paidAmount=TaskMaster_ACT.getPaidAmount(billData[0], token);

double dueAmount=orderAmount-paidAmount;
%>
<div class="clearfix menuDv pad_box3 pad05 mb10" style="min-height: 150px;margin-top: 16px;width: 50%;margin-left: 25%;" id="invoicecontent">
<div class="clearfix invoice_div">

<div class="clearfix" style="position: relative;margin-bottom: -35px;">
<img alt="" src="<%=request.getContextPath()%>/staticresources/images/tag.png" style="width: 50px;margin-left: -15px;margin-top: -10px;">
<%if(paidAmount==0){ %><span style="position: absolute; margin-left: -43px; transform: rotate(-45deg); color: rgb(255, 255, 255); font-size: 11px;color:#fff !important;">Due</span><%}
else if(dueAmount>0){ %>
<span style="position: absolute; margin-left: -48px; transform: rotate(-45deg); color: rgb(255, 255, 255); font-size: 11px;color:#fff !important;">Partial</span>
<%}else{ %>
<span style="position: absolute; margin-left: -43px; transform: rotate(-45deg); color: rgb(255, 255, 255); font-size: 11px;color:#fff !important;">Paid</span><%}%>
</div>
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
<span>Noida, Uttar Pradesh - 201301</span><br/><%if(dueAmount<=0){ %>
<span>GSTIN 09AAHCC4539J1ZC</span><%} %>
<br>
</p>
</div>
</div>
<div style="width:50%;">
<div style="margin-bottom:10px;text-align:right;"><%if(dueAmount>0){ %>
<h2 style="font-size:18px;margin:0 0 5px;color:#48bd44;font-weight: 500;">Estimate</h2>
<p style="font-weight:600;" id="EstimateBillNo"># <%if(billData[0]!=null){ %><%=billData[0]%><%} %></p>
<%}else{ %>
<h2 style="font-size:18px;margin:0 0 5px;color:#48bd44;font-weight: 500;">INVOICE</h2>
<p style="font-weight:600;" id="EstimateBillNo"># <%if(billData[0]!=null){ %><%=invoiceNo%><%} %></p>
<%} %>
</div>


<%if(billData[4]!=null&&!billData[4].equalsIgnoreCase("NA")&&billData[4].length()>0){ %>
<div style="margin-bottom:10px;text-align:right;">
<h2 style="font-size:14px;margin:0 0 5px;color:#48bd44;font-weight: 500;">Order No.</h2>
<p style="font-weight:600;" id="EstimateBillNo">#<%=billData[4]%></p>
</div><%} %>

<%if(dueAmount>0){%>
<div style="width: 100%;">
<div style="text-align:right;font-size: 14px;margin-top: 40px;font-weight: 600;">
<span>Due Amount</span><br><span><i class="fa fa-inr"></i><%=CommonHelper.withLargeIntegers(dueAmount) %></span>
</div> 
</div><%} %>
</div>
</div>
<div class="clear"></div>

<div class="clearfix" style="width:100%;">
<p style="margin:0px;">Bill To : </p>
<p style="font-weight: 600;margin-bottom: 1rem;" id="BillToId"><%if(client[0]!=null){%><%=client[0] %><%} %></p>
<%if(client[4]!=null&&!client[4].equalsIgnoreCase("NA")){ %>
<p style="margin-top: -1rem;">GSTIN <%=client[4] %></p><%} %>
</div>
<div class="clear"></div>
<div class="clearfix" style="width:100%;display: flex;">
<div style="width:50%;">
<p style="margin:0px;"></p>
<p style="margin-bottom:5px;">Ship To : <br>
<span id="ShipToId"><%if(client[0]!=null){%><%=client[0] %><%} %></span>
<span id="ShipToAddressId"><%if(client[1]!=null){%><%=client[1] %><%} %></span></p>
<p>Place Of Supply: <span id="ShipToStateCode"><%if(client[2]!=null){%><%=client[2] %><%}if(client[3]!=null&&!client[3].equalsIgnoreCase("NA")){%> (<%=client[3] %>)<%} %></span></p>
</div>
<div style="width:50%;text-align:right;">
<p><span style="font-weight:600;color:#888;">Date :</span> <span style="padding-left:20px;" id="EstimateDate"><%if(billData[2]!=null){ %><%=billData[2]%><%} %></span></p>
<%if(billData[5]!=null&&!billData[5].equalsIgnoreCase("NA")&&billData[5].length()>0){ %><p><span style="font-weight:600;color:#888;">Order Date :</span> <span style="padding-left:20px;"><%=billData[5]%></span></p><%} %>
</div>

</div>
<div class="clear"></div>
<div class="table-responsive"><table style="width:100%;">
    <tbody><tr>
    <td>
<div class="clearfix" style="width:100%;">
<div class="clearfix" style="width:100%;background:#48bd44 !important;padding-bottom:8px;padding-top:8px;border-radius: 3px;display: flex;">
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
int totalQty=0;
double totalRate=0;
double totalRateSum=0;
double totalGST=0;
double totalAmount=0;
double discount=0;
String invoiceNotes="";
String estimateProductList[][]=Enquiry_ACT.getEstimateProductList(billData[0],token);
if(estimateProductList!=null&&estimateProductList.length>0){
	for(int i=0;i<estimateProductList.length;i++){
		totalQty+=Integer.parseInt(estimateProductList[i][2]);
		discount+=Double.parseDouble(estimateProductList[i][6]);
		invoiceNotes=estimateProductList[i][7];
		String estimatePriceList[][]=Enquiry_ACT.getEstimatePriceList(estimateProductList[i][0],token);
		String salesType=estimateProductList[i][12];
%>
<div class="clearfix" style="width:100%;">
<div class="clearfix" style="font-weight: 600;width:100%;display: flex;padding: 4px 0px 4px 0px;<%if(i>0){%>border-top: 1px solid #ccc;<%}%>">
<div style="width:3%;"><p style="margin: 0; font-size: 11px;"><%=(i+1) %>.</p></div>
<div style="width:97%;">
<p style="margin: 0; font-size: 11px;">&nbsp;<%if(estimateProductList[i][12].equals("1")){%><%=estimateProductList[i][1] %> (<%=estimateProductList[i][2] %>)<%}else{ %>Consultation Service (1)<%} %></p>
</div>
</div>
<%if(estimatePriceList!=null&&estimatePriceList.length>0){
	for(int j=0;j<estimatePriceList.length;j++){
		totalRate=Double.parseDouble(estimatePriceList[j][2]);
		totalRateSum+=totalRate;
		double gstPercentage=Math.round(Double.parseDouble(estimatePriceList[j][4])+Double.parseDouble(estimatePriceList[j][5])+Double.parseDouble(estimatePriceList[j][6]));
		double gstAmount=Math.round(Double.parseDouble(estimatePriceList[j][7])+Double.parseDouble(estimatePriceList[j][8])+Double.parseDouble(estimatePriceList[j][9]));
		totalGST+=gstAmount;
		totalAmount+=Double.parseDouble(estimatePriceList[j][10]);
%>
<div class="clearfix" style="border-top: 1px solid #ccc;padding: 4px 0px 4px 0px;width:100%;display: flex;font-size: 10px;">
<div style="margin-bottom: 0;padding-left: 16px; width: 34%;"><%=estimatePriceList[j][1] %>
<%if(salesType.equals("2")){ %>(<%=estimatePriceList[j][11].substring(8,10)+" "+DateUtil.getMonthName(estimatePriceList[j][11].substring(5,7))+" "+estimatePriceList[j][11].substring(2,4)%>)<%} %>
</div>
<div style="width:13%;" class="hsn"><p style="margin:0;text-align: right;"><%=estimatePriceList[j][3] %></p></div>
<div style="width:15%;"><p style="margin:0;text-align: right;"><%=CommonHelper.withLargeIntegers(Math.round(Double.parseDouble(estimatePriceList[j][2]))) %></p></div>
<div style="width:8%;" class="gst"><p style="margin:0;text-align: right;"><%=gstPercentage %> %</p></div>
<div style="width:12%;"><p style="margin:0;text-align: right;"><%=CommonHelper.withLargeIntegers(Math.round(gstAmount)) %></p></div>
<div style="width:18%;"><p style="margin:0;text-align: right;"><%=CommonHelper.withLargeIntegers(Math.round(Double.parseDouble(estimatePriceList[j][10]))) %></p></div>
</div>
<%}} %>
<div class="clear"></div>
</div>
<%}} if(discount>0){%>
<div class="clearfix" style="font-weight: 600;border-top: 1px dotted black;padding: 5px 0px 5px 0px;display: flex;">
	<div style="padding-left: 16px; width: 34%;">
	<p style="margin:0;font-size: 11px;">&nbsp;</p></div>
	<div style="width:13%;"><p style="margin:0;text-align: right;font-size: 11px;">&nbsp;Disc.</p></div>
	<div style="width:15%;"><p style="margin:0;text-align: right;font-size: 11px;"></p></div>
	<div style="width:8%;"><p style="margin:0;text-align: right;font-size: 11px;">&nbsp;</p></div>
	<div style="width:12%;"><p style="margin:0;text-align: right;font-size: 11px;">&nbsp;</p></div>
	<div style="width:18%;"><p style="margin:0;text-align: right;font-size: 11px;">-&nbsp;<%=CommonHelper.withLargeIntegers(Math.floor(discount)) %></p>
	</div>
</div><%} %>

<div class="clearfix total_web" style="font-weight: 600;border-top: 1px dotted black;border-bottom: 1px dotted black;padding: 5px 0px 5px 0px;display: flex;">
	<div style="padding-left: 16px; width: 34%;">
	<p style="margin:0;font-size: 11px;">Total Qty. : &nbsp;<span><%=totalQty %></span></p></div>
	<div style="width:13%;"><p style="margin:0;text-align: right;font-size: 11px;">&nbsp;</p></div>
	<div style="width:15%;"><p style="margin:0;text-align: right;font-size: 11px;"><%=CommonHelper.withLargeIntegers(Math.round(totalRateSum)) %></p></div>
	<div style="width:8%;"><p style="margin:0;text-align: right;font-size: 11px;">&nbsp;</p></div>
	<div style="width:12%;"><p style="margin:0;text-align: right;font-size: 11px;"><%=CommonHelper.withLargeIntegers(Math.round(totalGST)) %></p></div>
	<div style="width:18%;"><p style="margin:0;text-align: right;font-size: 11px;" id="TotalPaymentData"><%=CommonHelper.withLargeIntegers(Math.round(totalAmount-discount)) %></p>
	
	</div>	
</div>
<div class="clearfix total_mobile" style="border-top: 1px dotted black;border-bottom: 1px dotted black;padding: 5px 0px 5px 0px;">

<div class="total_desc">
<div class="total_title">
Rate
</div>
<div class="total_amount">
<%=CommonHelper.withLargeIntegers(Math.round(totalRateSum)) %>
</div>
</div>
<div class="total_desc">
<div class="total_title">
GST Amount
</div>
<div class="total_amount">
<%=CommonHelper.withLargeIntegers(Math.round(totalGST)) %>
</div>
</div>
<div class="total_desc">
<div class="total_title">
Total Amount
</div>
<div class="total_amount">
<%=CommonHelper.withLargeIntegers(Math.round(totalAmount-discount)) %>
</div>
</div>
</div>
<div class="clearfix" style="width:100%;padding: 10px 0 0 0;">
<p style="margin:0;font-size:11px;padding-left:10px;padding-right:10px;text-align:right;">Total In Words: <span style="font-weight:600;padding-left:10px;color:#666;" id="EstimateRupeesInWord"></span></p>
</div>
<%
String estimatetaxData[][]=Enquiry_ACT.getEstimateTaxList(billData[0],token);
if(estimatetaxData!=null&&estimatetaxData.length>0){
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
    <%for(int i=0;i<estimatetaxData.length;i++){ %>
	   <div class="clearfix taxRemoveBox" style="width: 100%;text-align: center;padding: 5px 0 5px 0px;font-size: 10px;display: flex;<%if(i>0){%>border-top: 1px dotted #ccc;<%}%>">
		   <div style="width: 25%"><%=estimatetaxData[i][0] %></div>
		   <div style="width: 25%"><%=estimatetaxData[i][2] %></div>
		   <div style="width: 25%"><%=estimatetaxData[i][1] %></div>
		   <div style="width: 25%"><%=estimatetaxData[i][3] %></div>
	   </div>
   <%} %>
</div>
</div>
<%} %>
</div>
</td></tr>
    </tbody></table></div>
<div class="clear"></div>

<div class="clearfix" style="width:100%;margin-top:5px;margin-bottom:5px;">  
<p style="margin-bottom:5px;color:#555;"><span style="font-weight: 600;">Notes :</span> <span></span></p>
<p style="font-size: 11px;color:#888;">This Estimates &amp; price quotation is valid for 7 calendar days from the date of issue.</p>
<%if(invoiceNotes!=null&&!invoiceNotes.equalsIgnoreCase("NA")){ %>
<p style="font-size: 11px;color:#888;"><%=invoiceNotes %></p><%} %>
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
	var totalAmount="<%=Math.round((totalAmount-discount))%>";
	
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
