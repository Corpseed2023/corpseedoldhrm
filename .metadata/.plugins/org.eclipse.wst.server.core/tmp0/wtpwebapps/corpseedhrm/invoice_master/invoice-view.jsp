<%@page import="client_master.Clientmaster_ACT"%>
<%@page import="company_master.CompanyMaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>View Invoice</title>
<style type="text/css" media="print">
@page {
	size: auto;
	margin: 0;
}
</style>
</head>
<body>
<%
String[][] inv =null;

String token = (String) session.getAttribute("uavalidtokenno");
	String ch = request.getParameter("uid");
	String[] a = ch.split(".html");
	String[] b = a[0].split("-");
	String compid = b[2];
	String[][] comp = CompanyMaster_ACT.getCompanyByID(compid);
	String invid = b[2];
// 	String[][] inv = Clientmaster_ACT.getInvoiceById(invid);
	String cid = inv[0][12];
	String[][] cl = Clientmaster_ACT.getClientByID(cid);
	String pid = inv[0][13];
	String[][] pr = Clientmaster_ACT.getProjectByID(pid,token);
%>
	<%=comp[0][2]%><br>
	<%=comp[0][3]%><br>
	PAN	<%=comp[0][4]%><br>
	GSTIN <%=comp[0][5]%><br>
	State Code <%=comp[0][6]%><br>
	GST Category <%=inv[0][16]%><br>
	Bank Name <%=comp[0][7]%><br>
	Bank Account Name <%=comp[0][2]%><br>
	Bank Account No. <%=comp[0][8]%><br>
	Bank IFSC Code <%=comp[0][9]%><br> 
	Invoice Date <%=inv[0][3]%><br>
	Invoice No. <%=inv[0][13]%><br>
	Invoice Month <%=inv[0][2]%><br>
	Customer Details <br>
	<%=cl[0][3]%><br>
	<%=cl[0][5]%><br>
	PAN <%=cl[0][11]%><br>
	GSTIN <%=cl[0][12]%><br>
	State Code <%=cl[0][13]%><br>
	Service Name <%=pr[0][2]%><br>
	SAC Code <%=inv[0][15]%><br>
	Specification <%=inv[0][9]%><br>
	Amount INR<%=inv[0][1]%><br>
	GST	<%=inv[0][6]%>%<br>
	INR<%=inv[0][7]%><br>
	Total INR<%=inv[0][8]%><br>

	<button id="print" onclick="printpage();return false">Print
		Invoice</button>
	<script type="text/javascript">
		function printpage() {
			var printButton = document.getElementById("print");
			printButton.style.visibility = 'hidden';
			window.print()
			printButton.style.visibility = 'visible';
		}
	</script>
</body>
</html>