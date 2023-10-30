<!DOCTYPE HTML>
<%@page import="commons.CommonHelper"%>
<%@page import="admin.task.TaskMaster_ACT"%>
<%@page import="admin.enquiry.Enquiry_ACT"%>
<%@page import="client_master.Clientmaster_ACT"%>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Estimate Invoice</title>

<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
<style type="text/css">
body{background: #c3c3c32b;}
.bg-color{background: #48bd44;color: #fff;}
@media print {
   body{margin:0;padding:0;font-size:12px;}
   header, footer{display:none;}
   p{margin-bottom:10px;font-size:12px;margin-top:0;}
   #invoicecontent{width: 100% !important;margin-left: 0px !important;}
   img{width: 35%;}
   #printData{display: none;}
}
@media only screen and (max-width: 767.98px) {
#invoicecontent{
width:100%!important;
margin-left:0!important
}}
table th:first-child {
    -moz-border-radius: 0px 0 0 0;
    -webkit-border-radius: 0px 0 0 0;
    border-radius: 0px 0 0 0;
}

table th:last-child {
    -moz-border-radius: 0 0px 0 0;
    -webkit-border-radius: 0 0px 0 0;
    border-radius: 0 0px 0 0;
}
</style>
</head>
<body>
<div class="wrap">
<div class="container">
<%
String paymentKey=request.getParameter("uid").trim();
paymentKey=paymentKey.substring(5,paymentKey.length()-5);
String token=(String)session.getAttribute("uavalidtokenno"); 
if(token==null||token.length()<=0)token=Enquiry_ACT.getPaymentToken(paymentKey);
String billData[]=Enquiry_ACT.getPaymentData(paymentKey,token);
String client[]=null;
if(billData[2]!=null&&billData[2].length()>0){
	String clientKey=Enquiry_ACT.getSalesClientKey(billData[2],token);
	client=Enquiry_ACT.getClientsDetail(clientKey,token);
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
<span style="font-weight:600;color:#888;">Corpseed Ites Private Limited</span><br>
<span>CN U74999UP2018PTC101873</span><br>
<span>2nd Floor, A-154A, A Block, Sector 63</span><br/>
<span>Noida, Uttar Pradesh - 201301</span><br/>
<br>
</p>
</div>
</div>
<div style="width:50%;">
<div style="margin-bottom:10px;text-align:right;">
<h2 style="font-size:18px;margin:0 0 5px;color:#48bd44;font-weight: 500;">UNBILLED</h2>
<p style="font-weight:600;" id="EstimateBillNo"># <%=billData[8]%></p>
</div>
</div>
</div>
<div class="clear"></div>
<div class="clearfix" style="width:100%;">
<p style="margin:0px;">Bill To : </p>
<p style="font-weight: 600;margin-bottom: 5px;" id="BillToId"><%if(client[0]!=null){%><%=client[0] %><%} %></p>
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
<p><span style="font-weight:600;color:#888;">Date :</span> <span style="padding-left:20px;" id="EstimateDate"><%if(billData[0]!=null){ %><%=billData[0]%><%} %></span></p>
</div>

</div>
<div class="clear"></div>
<div class="table-responsive">
<table  border="1" style="width:100%;border:1px solid #786d6d">
<tr style="background: #48bd44!important;color: #fff!important;">
<th rowspan="2" style="padding: 3px;">#</th>
<th rowspan="2" style="padding: 3px;">Item & Description</th>
<th rowspan="2" style="padding: 3px;">Rate</th>
<th colspan="3" style="padding: 3px;text-align:center;">Tax</th>
<th rowspan="2" style="padding: 3px;">Tax Amt.</th>
<th rowspan="2" style="padding: 3px;">Amount</th>
</tr>
<tr style="background: #48bd44!important;color: #fff!important;">
<td style="padding: 3px;">SGST %</td>
<td style="padding: 3px;">CGST %</td>
<td style="padding: 3px;">IGST %</td>
</tr>
<tr>
<td style="padding: 3px;font-weight:600">1.</td>
<td style="padding: 3px;font-weight:600" colspan="7"><%=billData[6] %></td>
</tr>

<%
double rate=0;
double gstSum=0; 
String paymentDetails[][]=Enquiry_ACT.getPaymentList(paymentKey,token);
if(paymentDetails!=null&&paymentDetails.length>0){
	for(int j=0;j<paymentDetails.length;j++){
		double gst=(Double.parseDouble(paymentDetails[j][4])*(Double.parseDouble(paymentDetails[j][6])+Double.parseDouble(paymentDetails[j][5])+Double.parseDouble(paymentDetails[j][7])))/100;
		rate+=Double.parseDouble(paymentDetails[j][4]);
		gstSum+=gst;
%>
<tr>
<td></td>
<td style="padding: 3px;"><%=paymentDetails[j][3] %></td>
<td style="padding: 3px;"><%=CommonHelper.withLargeIntegers(Math.round(Double.parseDouble(paymentDetails[j][4]))) %></td>
<td style="padding: 3px;"><%=paymentDetails[j][6] %>%</td>
<td style="padding: 3px;"><%=paymentDetails[j][5] %>%</td>
<td style="padding: 3px;"><%=paymentDetails[j][7] %>%</td>
<td style="padding: 3px;"><%=CommonHelper.withLargeIntegers(Math.round(gst)) %></td>
<td style="padding: 3px;"><%=CommonHelper.withLargeIntegers(Math.round((Double.parseDouble(paymentDetails[j][4])+gst)))%></td>
</tr>
<%}} %>
<tr style="font-weight: 600">
<td colspan="2" style="padding: 5px;">Total</td><td colspan="4" style="padding: 3px;"><%=CommonHelper.withLargeIntegers(Math.round(rate)) %></td>
<td style="padding: 3px;"><%=CommonHelper.withLargeIntegers(Math.round(gstSum)) %></td>
<td style="padding: 3px;"><%=CommonHelper.withLargeIntegers(Math.round(Double.parseDouble(billData[4])))%></td>
</tr>
</table>
</div>
<div class="clear"></div>
<p style="margin:0;padding-top: 10px;text-align:right;">Total In Words: <span style="font-weight:600;padding-left:10px;color:#666;" id="SalesRupeesInWord">INR Twenty One Thousand Two Hundred Forty   only.</span></p>
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
	var totalAmount="<%=billData[4]%>";
	numberToWords("SalesRupeesInWord",Math.round(Number(totalAmount)));
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
function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
</script>
</body>
</html>
