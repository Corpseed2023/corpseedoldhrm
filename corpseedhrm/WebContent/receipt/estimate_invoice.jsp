<!DOCTYPE HTML>
<%@page import="client_master.Clientmaster_ACT"%>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Billing Receipt</title>
<style>
body{margin:0;padding:0;color:#333;font-size:14px;line-height:20px;background:#fff;font-family: sans-serif, Arial;}
p{margin-bottom:10px;font-size:14px;margin-top:0;color:#555;}
.wrap{overflow:hidden;}
.container{width:90%;margin:0 auto;}
.clearfix:before{display: table;content: "";}
.clearfix:after, .clear{clear:both;}
@media print {
   body{margin:0;padding:0;font-size:12px;}
   header, footer{display:none;}
   p{margin-bottom:10px;font-size:12px;margin-top:0;}
}
</style>
</head>
<body>
<div class="wrap">
<div class="container">
<div class="clearfix" style="width:100%;padding-top:20px;">
<div style="width:50%;float:left;">
<div style="margin-bottom:1px;">
<img src="<%=request.getContextPath() %>/receipt/cropseed_logo.png" alt="" style="max-width:150px;" />
</div>
<%
String clname="NA";
String clgstin="NA";
String claddress[]=null;
String billno="NA";
String token="NA";
String date="NA";
String type="NA";
String paystatus="NA";
String color="NA";
String refid=request.getParameter("refid");
billno=request.getParameter("estInv");
String billing[]=Clientmaster_ACT.getBillingDetails(refid);
if(billing.length>0){
	token=billing[2];
	date=billing[3];
	type=billing[4];
	clname=Clientmaster_ACT.getClientName(billing[0],token);
	clgstin=Clientmaster_ACT.getClientGSTIN(billing[0], token);
			
	claddress=Clientmaster_ACT.getClientAddress(billing[0],token);
	if(Double.parseDouble(billing[5])==Double.parseDouble(billing[6])){paystatus="Not Paid";color="#f30606";}
	else if(Double.parseDouble(billing[5])>Double.parseDouble(billing[6])&&Double.parseDouble(billing[6])!=0){paystatus="Partial";color="#6a93dd";}
	else if(Double.parseDouble(billing[5])>Double.parseDouble(billing[6])&&Double.parseDouble(billing[6])==0){paystatus="Paid";color="#56e931";}
// 	System.out.println("paystatus="+paystatus);
}
%>
<div style="margin-bottom:15px;">
<p>
<span style="display:block;font-weight:600;color:#888;">Corpseed ITES Private Limited</span><br/>
<span style="display:block;">CN U74999UP2018PTC101873</span><br/>
<span style="display:block;">2nd Floor, A-154A, A Block, Sector 63</span><br/>
<span style="display:block;">Noida, Uttar Pradesh - 201301</span><br/>
<span style="display:block;">GSTIN 09AAHCC4539J1ZC</span><br/>
</p>
</div>
</div>
<div style="width:50%;float:left;">
<div style="margin-bottom:10px;text-align:right;">
<h2 style="font-size:18px;margin:0 0 5px;color:#48bd44;font-weight: 500;">Bill No. : <span style="color: #0e0e0e;font-size: 20px;"><%=billno %></span></h2>
</div>

</div>
</div>
<div class="clear"></div>
<div class="clearfix" style="width:100%;margin-top:10px;">
<p style="margin:0px;">Bill To</p>
<p style="font-weight: 600;"><%=clname %></p>
<%if(clgstin!=null&&!clgstin.equalsIgnoreCase("NA")){ %>
<p style="margin-top: -1rem;">GSTIN <%=clgstin %></p><%} %>
</div>
<div class="clear"></div>
<div class="clearfix" style="width:100%;margin-top:10px;">
<div style="width:50%;float:left;">
<p style="margin:0px;">Ship To</p>
<p style="margin-bottom:15px;"><span style="display:block;"><%=clname %></span>
<span style="display:block;"><%=claddress[0] %></span></p>
<p>Place Of Supply: <%=claddress[1] %></p>
</div>
<div style="width:50%;float:left; text-align:right;">
<p style="margin-top:15px;"><span style="font-weight:600;color:#888;">Billing Date :</span> <span style="padding-left:20px;"><%=date %></span></p>
</div>
</div>
<div class="clear"></div>
<div class="clearfix" style="width:100%;margin-top:10px;">
<div class="clearfix" style="width:100%;background:#48bd44;padding-top:10px;padding-bottom:10px;">
<div style="width:5%;float:left;">
<p style="margin:0;color:#fff;font-size:13px;padding-left:10px;padding-right:10px;">S.No.</p>
</div>
<div style="width:35%;float:left;">
<p style="margin:0;color:#fff;font-size:13px;padding-left:10px;padding-right:10px;">Item & Description </p>
</div>
<div style="width:12%;float:left;">
<p style="margin:0;color:#fff;font-size:13px;text-align:center;padding-left:10px;padding-right:10px;">Qty</p>
</div>
<div style="width:12%;float:left;">
<p style="margin:0;color:#fff;font-size:13px;text-align:right;padding-left:10px;padding-right:10px;">Rate</p>
</div>
<div style="width:12%;float:left;">
<p style="margin:0;color:#fff;font-size:13px;text-align:right;padding-left:10px;padding-right:10px;">CGST</p>
</div>
<div style="width:12%;float:left;">
<p style="margin:0;color:#fff;font-size:13px;text-align:right;padding-left:10px;padding-right:10px;">SGST</p>
</div>
<div style="width:12%;float:left;">
<p style="margin:0;color:#fff;font-size:13px;text-align:right;padding-left:10px;padding-right:10px;">Amount</p>
</div>
<div class="clear"></div>
</div>
<%
double subtotal=0;
double gst=0;
if(!billno.equalsIgnoreCase("NA")&&!token.equalsIgnoreCase("NA")){
String[][] billitems=Clientmaster_ACT.getAllBillingItems(billno,token,type);
if(billitems.length>0){
	for(int i=0;i<billitems.length;i++){
		double price=0;
		double gstprice=0;
		
		if(billitems[i][5].equalsIgnoreCase("Included")){
		subtotal+=(Double.parseDouble(billitems[i][1])-Double.parseDouble(billitems[i][3]));
		price=(Double.parseDouble(billitems[i][1])-Double.parseDouble(billitems[i][3]));
		}else{
			subtotal+=Double.parseDouble(billitems[i][1]);
			price=Double.parseDouble(billitems[i][1]);
		}	
		gst+=Double.parseDouble(billitems[i][3]);
		gstprice=Double.parseDouble(billitems[i][3]);
		
%>
<div class="clearfix" style="width:100%;border-bottom:1px solid #ccc;padding-top:10px;padding-bottom:10px;">
<div style="width:5%;float:left;">
<p style="margin:0;font-size:13px;padding-left:10px;padding-right:10px;"><%=i+1 %></p>
</div>
<div style="width:35%;float:left;">
<p style="margin:0;font-size:13px;padding-left:10px;padding-right:10px;"><%=billitems[i][0] %></p>
</div>
<div style="width:12%;float:left;">
<p style="margin:0;font-size:13px;text-align:center;padding-left:10px;padding-right:10px;">1</p>
</div>
<div style="width:12%;float:left;">
<p style="margin:0;font-size:13px;text-align:right;padding-left:10px;padding-right:10px;"><%=price %></p>
</div>
<div style="width:12%;float:left;">
<p style="margin:0;font-size:13px;text-align:right;padding-left:10px;padding-right:10px;"><%=gstprice/2 %></p>
</div>
<div style="width:12%;float:left;">
<p style="margin:0;font-size:13px;text-align:right;padding-left:10px;padding-right:10px;"><%=gstprice/2 %></p>
</div>
<div style="width:12%;float:left;">
<p style="margin:0;font-size:13px;text-align:right;padding-left:10px;padding-right:10px;"><%=price %></p>
</div>
<div class="clear"></div>
</div>
<%}}else{%>
<div class="col-md-12 col-sm-12 col-xs-12" style="color: red;text-align: center;margin-top: 20px;font-size: 20px;">Something Went Wrong,Please Contact To Administrator !</div>
<%} }%>
<div class="clearfix" style="width:100%;padding-top:10px;padding-bottom:10px;">
<div style="width:84%;float:left;">
<p style="margin:0;font-size:13px;text-align:right;padding-left:10px;padding-right:10px;">Sub Total</p>
</div>
<div style="width:16%;float:left;">
<p style="margin:0;font-size:13px;text-align:right;padding-left:10px;padding-right:10px;"><%=subtotal%></p>
</div>
<div class="clear"></div>
</div>
<div class="clearfix" style="width:100%;padding-top:10px;padding-bottom:10px;">
<div style="width:84%;float:left;">
<p style="margin:0;font-size:13px;text-align:right;padding-left:10px;padding-right:10px;">CGST9 (9%) </p>
</div>
<div style="width:16%;float:left;">
<p style="margin:0;font-size:13px;text-align:right;padding-left:10px;padding-right:10px;"><%=gst/2 %></p>
</div>
<div class="clear"></div>
</div>
<div class="clearfix" style="width:100%;padding-top:10px;padding-bottom:10px;">
<div style="width:84%;float:left;">
<p style="margin:0;font-size:13px;text-align:right;padding-left:10px;padding-right:10px;">SGST9 (9%) </p>
</div>
<div style="width:16%;float:left;">
<p style="margin:0;font-size:13px;text-align:right;padding-left:10px;padding-right:10px;"><%=gst/2 %></p>
</div>
<div class="clear"></div>
</div>
<div class="clearfix" style="width:100%;padding-top:10px;padding-bottom:10px;">
<div style="width:84%;float:left;">
<p style="margin:0;font-size:13px;text-align:right;padding-left:10px;padding-right:10px;font-weight:600;">Total</p>
</div>
<div style="width:16%;float:left;">
<p style="margin:0;font-size:13px;text-align:right;padding-left:10px;padding-right:10px;font-weight:600;"><%=Math.round((subtotal+gst)) %></p>
</div>
<div class="clear"></div>
</div>
<div class="clearfix" style="width:100%;padding-top:10px;padding-bottom:10px;">
<p style="margin:0;font-size:13px;text-align:right;padding-left:10px;padding-right:10px;">Total In Words: <span style="font-weight:600;padding-left:10px;color:#666;" id="TotalAmount"></span></p>
</div>

</div>
<div class="clear"></div>

<div class="clearfix" style="width:100%;margin-top:30px;margin-bottom:15px;">
<p style="margin-bottom:5px;">Notes</p>
<p style="font-size: 13px;">This Estimates & price quotation is valid for 7 calendar days from the date of issue.</p>
<p style="position: absolute;font-size: 22px;font-weight: 600;margin-left: 980px;margin-top: -61px;border: 5px solid #10db10;padding: 11px;border-radius: 4px;transform: rotate(-24deg);"><span style="color: <%=color%>;"><%=paystatus %></span></p>
</div>
<div class="clearfix" style="width:100%;">
<p style="color:#888;">
<span style="display:block;font-weight:600;font-size: 13px;">Payment Options:</span>
<span style="display:block;">
<span style="font-weight:600;">IMPS/RTGS/NEFT:</span> Account Number: 10052624515 || IFSC Code: IDFB0021331 || Beneficiary Name: Corpseed ITES Private Limited || Bank Name: IDFC FIRST Bank, Noida, Sector 63 Branch</span>
<span style="display:block;"><span style="font-weight:600;">Direct Pay:</span> https://www.corpseed.com/payment || <span style="font-weight:600;">Pay via UPI:</span> CORPSEEDV.09@cmsidfc</span>
</p>
</div>
<div class="clearfix" style="width:100%;margin-top:60px;border-top:1px solid #ddd;padding-top:5px;margin-bottom:15px;">
<p style="color:#999;font-size: 13px;">Note: Government fee and corpseed professional fee may differ depending on any additional changes advised the client in the application  or any changes in the government policies</p>
</div>
</div>
</div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
	
		var num=<%=(subtotal+gst)%>;
		var a = ['','one ','two ','three ','four ', 'five ','six ','seven ','eight ','nine ','ten ','eleven ','twelve ','thirteen ','fourteen ','fifteen ','sixteen ','seventeen ','eighteen ','nineteen '];
		var b = ['', '', 'twenty','thirty','forty','fifty', 'sixty','seventy','eighty','ninety'];
	
		
    n = ('000000000' + num).substr(-9).match(/^(\d{2})(\d{2})(\d{2})(\d{1})(\d{2})$/);
   
    var str = '';
    str += (n[1] != 0) ? (a[Number(n[1])] || b[n[1][0]] + ' ' + a[n[1][1]]) + 'crore ' : '';
    str += (n[2] != 0) ? (a[Number(n[2])] || b[n[2][0]] + ' ' + a[n[2][1]]) + 'lakh ' : '';
    str += (n[3] != 0) ? (a[Number(n[3])] || b[n[3][0]] + ' ' + a[n[3][1]]) + 'thousand ' : '';
    str += (n[4] != 0) ? (a[Number(n[4])] || b[n[4][0]] + ' ' + a[n[4][1]]) + 'hundred ' : '';
    str += (n[5] != 0) ? ((str != '') ? '' : '') + (a[Number(n[5])] || b[n[5][0]] + ' ' + a[n[5][1]]) : '';
    str += 'rupees only ';
    document.getElementById('TotalAmount').innerHTML="INR "+str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});;
 
</script>

<script type="text/javascript">
function downloadAspdf() {
	document.getElementById("PrintIcon").style.display="none";
	document.getElementById("EmailIcon").style.display="none";
	document.getElementById("DownloadIcon").style.display="none";
	var name="<%=billno %>";
var pdf = new jsPDF('p', 'mm', 'a4');
pdf.addHTML(document.body,function() {
    pdf.save(name+'.pdf');
});
}
function saveAspdf() {
	document.getElementById("PrintIcon").style.display="none";
	document.getElementById("EmailIcon").style.display="none";
	document.getElementById("DownloadIcon").style.display="none";
	window.print();
<%-- 	var name="<%=billno %>"; --%>
// 	var pdf = new jsPDF('p','pt','a4');
// 	pdf.setFontSize(40);
// 	pdf.addHTML(document.body,function() {
// 		pdf.save(name+'.pdf');
// 	});
}   
function emailAspdf() {	
	window.email();
<%-- 	var name="<%=billno %>"; --%>
// 	var pdf = new jsPDF('p','pt','a4');
// 	pdf.setFontSize(40);
// 	pdf.addHTML(document.body,function() {
// 		pdf.save(name+'.pdf');
// 	});
}
</script>
</body>
</html>
