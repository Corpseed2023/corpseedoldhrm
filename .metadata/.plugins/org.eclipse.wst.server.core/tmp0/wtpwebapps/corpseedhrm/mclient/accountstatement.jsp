<%@page import="java.util.Properties"%>
<%@page import="commons.CommonHelper"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Account Statement</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%
//pagination start
int pageNo=1;
int rows=10;

if(request.getParameter("page")!=null)pageNo=Integer.parseInt(request.getParameter("page"));
if(request.getParameter("rows")!=null)rows=Integer.parseInt(request.getParameter("rows"));

Properties properties = new Properties();
properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
String domain=properties.getProperty("domain");
String sort_url=domain+"accountstatement.html?page="+pageNo+"&rows="+rows;

//pagination end
String uid = (String) session.getAttribute("passid");
String[][] getAccountById = Clientmaster_ACT.getAccountByID(uid);
String[][] getAccountStatement = Clientmaster_ACT.getAccountStatement(getAccountById[0][5],pageNo,rows);
int totalStmt=Clientmaster_ACT.countAccountStatement(getAccountById[0][5]);
double runningbalance=0;
try{
	runningbalance = Clientmaster_ACT.getRunningBalance(getAccountById[0][5]);	
}
catch(Exception e){e.printStackTrace();}
%>
<%if(!ACC01){%><jsp:forward page="/login.html" /><%} %>
<div id="content">

<div class="main-content">
<div class="container">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="menuDv">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="col-md-3 col-xs-12 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Client Name</p>
</div>
</div>
<div class="col-md-2 col-xs-12 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Client Mobile</p>
</div>
</div>
<div class="col-md-3 col-xs-12 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Client Email</p>
</div>
</div>
<div class="col-md-4 col-xs-12 box-intro-bg">
<div class="box-intro-border">
<p>Description</p>
</div>
</div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="col-md-3 col-xs-12 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getAccountById[0][1] %></p>
</div>
</div>
<div class="col-md-2 col-xs-12 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getAccountById[0][2] %></p>
</div>
</div>
<div class="col-md-3 col-xs-12 box-intro-background">
<div class="link-style12">
<p class="news-border"><%=getAccountById[0][3] %></p>
</div>
</div>
<div class="col-md-4 col-xs-12 box-intro-background">
<div class="link-style12">
<p><%=getAccountById[0][4] %></p>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
<div class="row" style="margin-top: 20px;">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="menuDv partner-slider8">
<div class="box-intro">
<h2><span class="title">Account Statement of <%=getAccountById[0][1] %></span></h2>
</div>
<form action="<%=request.getContextPath()%>/addaccountstatement.html" method="Post">
<input type="hidden" name="accountid" value="<%=uid%>" id="accountid" />
<input type="hidden" name="runnbal" value="<%=runningbalance%>" id="runnbal" />
<div class="home-search-form clearfix">
<div class="item-bestsell relative_box col-md-4 col-sm-2 col-xs-12">
<p><input type="text" autocomplete="off" name="description" id="description" placeholder="Description" class="form-control"/></p>
</div>
<div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
<p><input type="text" autocomplete="off" name="date" id="date" placeholder="Date" class="form-control readonlyAllow" readonly="readonly"/></p>
</div>
<div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
<p><input type="text" autocomplete="off" name="debit" id="debit" placeholder="Debit Amount" class="form-control" onkeypress="return isNumberKey(event)"/></p>
</div>
<div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
<p><input type="text" autocomplete="off" name="credit" id="Credit" placeholder="Credit Amount" class="form-control" onkeypress="return isNumberKey(event)"/></p>
<div id="creditErr" class="popup_error"></div>
</div>
<div class="item-bestsell col-md-1 col-sm-2 col-xs-12 ">
<button class="btn-link-default bt-radius" type="submit" onclick="return validateCreditDebit()">Submit</button>
</div>
</div>
</form>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">

<table class="ctable">
   <thead>
       <tr>
       	   <th>SN</th>
           <th>Description</th>
           <th>Invoice</th>
           <th>Date</th>
           <th>Debit</th>
           <th>Credit</th>
           <th>Running Balance</th>
           <th>Action</th>
       </tr>
   </thead>
   <tbody>
   <%
   int ssn=0;
   int showing=0; 
   int startRange=pageNo-2;
   int endRange=pageNo+2;
   int totalPages=1;
   double runnbal=0;
   if(getAccountStatement!=null&&getAccountStatement.length>0){
	   ssn=rows*(pageNo-1);
		  totalPages=(totalStmt/rows)+1;
		  showing=ssn+1;
		  if (totalPages > 1) {     	 
			  if((endRange-2)==totalPages)startRange=pageNo-4;        
	          if(startRange==pageNo)endRange=pageNo+4;
	          if(startRange<1) {startRange=1;endRange=startRange+4;}
	          if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
	          if(startRange<1)startRange=1;
	     }else{startRange=0;endRange=0;}
   %>
   		<tr>
   		   <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td></td>
           <td <% if(runningbalance<0){ %>class="text-danger"<% } %>>
           <%=CommonHelper.withLargeIntegers(runningbalance)%> <% if(runningbalance<0){ %>(DR)<% } else { %>(CR)<% } %>
           </td>           
       </tr>
   
   <%
   double rbalance=0;
   for(int i=0;i<getAccountStatement.length;i++){
	   rbalance+=(Double.parseDouble(getAccountStatement[i][5])-Double.parseDouble(getAccountStatement[i][4]));
    %>
       <tr id="<%=i%>">
       	   <td><%=(ssn+1+i)%></td>
           <td><%=getAccountStatement[i][2] %></td>
           <td><%=getAccountStatement[i][9] %></td>
           <td><%=getAccountStatement[i][3] %></td>
           <td><i class="fa fa-inr"></i>&nbsp;<%=CommonHelper.withLargeIntegers(Double.parseDouble(getAccountStatement[i][4])) %></td>
           <td><i class="fa fa-inr"></i>&nbsp;<%=CommonHelper.withLargeIntegers(Double.parseDouble(getAccountStatement[i][5])) %></td>
           <td <% if(rbalance<0){ %>class="text-danger"<% } %>><i class="fa fa-inr"></i> &nbsp;<%=CommonHelper.withLargeIntegers(rbalance)%></td>
           <td><%if(i==0){%><a href="javascript:void(0);" onclick="deleteAccountStatement(<%=getAccountStatement[i][0]%>);" class="bg_none"> <i class="fas fa-trash"></i></a><%}%></td>
           
       </tr>
    <%}}%>
                           
    </tbody>
</table> 
<div class="filtertable">
  <span>Showing <%=showing %> to <%=ssn+getAccountStatement.length %> of <%=totalStmt %> entries</span>
  <div class="pagination">
    <ul> <%if(pageNo>1){ %>
      <li class="page-item">	                     
      <a class="page-link text-primary" href="<%=request.getContextPath()%>/accountstatement.html?page=1&rows=<%=rows%>">First</a>
   </li><%} %>
    <li class="page-item">					      
      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/accountstatement.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
    </li>  
      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
	    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
	    <a class="page-link" href="<%=request.getContextPath()%>/accountstatement.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
	    </li>   
	  <%} %>
	   <li class="page-item">						      
	      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/accountstatement.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
	   </li><%if(pageNo<=(totalPages-1)){ %>
	   <li class="page-item">
	      <a class="page-link text-primary" href="<%=request.getContextPath()%>/accountstatement.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
	   </li><%} %>
	</ul>
	</div>
	<select class="select2" onchange="changeRows(this.value,'accountstatement.html?page=1','<%=domain%>')">
	<option value="10" <%if(rows==10){ %>selected="selected"<%} %>>Rows 10</option>
	<option value="20" <%if(rows==20){ %>selected="selected"<%} %>>Rows 20</option>
	<option value="40" <%if(rows==40){ %>selected="selected"<%} %>>Rows 40</option>
	<option value="80" <%if(rows==80){ %>selected="selected"<%} %>>Rows 80</option>
	<option value="100" <%if(rows==100){ %>selected="selected"<%} %>>Rows 100</option>
	<option value="200" <%if(rows==200){ %>selected="selected"<%} %>>Rows 200</option>
	</select>
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
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script>
function validateCreditDebit(){
	if(document.getElementById("description").value.trim()==""){
		descriptionErr.innerHTML="Description is required.";
		descriptionErr.style.color="red";
		return false;
	}
	if(document.getElementById("date").value.trim()==""){
		dateErr.innerHTML="Date is required.";
		dateErr.style.color="red";
		return false;
	}
	var debit=document.getElementById("debit").value.trim();
	var credit=document.getElementById("Credit").value.trim();
	
	if(debit==""){
		document.getElementById("debit").value="0";		
		}
	if(credit==""){
		document.getElementById("Credit").value="0";		
		}
	if(Number(debit)>0 && Number(credit)>0){
		creditErr.innerHTML="Debit or Credit at one time.";
		creditErr.style.color="red";
		debitErr.innerHTML="Debit or Credit at one time.";
		debitErr.style.color="red";
		return false;
	}
	if(Number(debit)==0 && Number(credit)==0){
		creditErr.innerHTML="Enter Debit or Credit amount.";
		creditErr.style.color="red";
		debitErr.innerHTML="Enter Debit or Credit amount.";
		debitErr.style.color="red";
		return false;
	}
}

$(function() {
$("#date").datepicker({
changeMonth: true,
changeYear: true,
dateFormat: 'dd-mm-yy',
});
});
function deleteAccountStatement(id) {
if(confirm("Sure you want to Delete this Entry from Account ? "))
{
	$.ajax({
	    type: "POST",
	    dataType: "html",
	    url: "DeleteStatementEntry",
	    data:  { 
	    	"id" : id,
	    },
	    success: function (data) {
	    	location.reload();
	    }
	});
}
}
</script>
</body>
</html>