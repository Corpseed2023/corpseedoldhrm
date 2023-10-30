<%@page import="admin.enquiry.Enquiry_ACT"%>
<%@page import="java.util.Properties"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/> 
	<title>Track Sale</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	<%		
	String estimate=request.getParameter("estimate");
	String invoice=request.getParameter("invoice");
	String mobile=request.getParameter("mobile");
	
	if(estimate==null||estimate.length()<=0)estimate="NA";
	if(invoice==null||invoice.length()<=0)invoice="NA";
	if(mobile==null||mobile.length()<=0)mobile="NA";
	String token=(String)session.getAttribute("uavalidtokenno");
	
	String[][] estimates=null;
	if(!estimate.equalsIgnoreCase("NA"))
		estimates=Enquiry_ACT.findEstimateSaleBySaleNo(estimate,mobile, token);
	else if(!invoice.equalsIgnoreCase("NA")){
		estimate=TaskMaster_ACT.findEstimateByInvoice(invoice,token);
		if(estimate!=null&&!estimate.equalsIgnoreCase("NA"))
			estimates=Enquiry_ACT.findEstimateSaleBySaleNo(estimate,mobile, token);
	}
	
	%>
	<div id="content">		
		<div class="main-content">
			<div class="container">
			
<div class="row mb30 mt-10">
<div class="col-md-12 col-sm-12 col-xs-12">
<form action="<%=request.getContextPath() %>/track-invoice.html" method="get">
<div class="row">
<div class="col-sm-3 mb-10">
<input type="search" name="estimate" class="form-control" placeholder="Estimate No.." autocomplete="off"
<%if(!estimate.equalsIgnoreCase("NA")){ %>value="<%=estimate%>"<%} %>>
</div>
<div class="col-sm-3 mb-10">
<input type="search" name="invoice" class="form-control" placeholder="Invoice No.." autocomplete="off"
<%if(!invoice.equalsIgnoreCase("NA")){ %>value="<%=invoice%>"<%} %>>
</div>
<div class="col-sm-3 mb-10">
<input type="search" name="mobile" class="form-control" onkeypress="return isNumber(event)" placeholder="Mobile No.." autocomplete="off"
<%if(!mobile.equalsIgnoreCase("NA")){ %>value="<%=mobile%>"<%} %> required>
</div>
<div class="col-sm-3">
<button type="submit" class="btn btn-primary btn-block" style="height: 40px;"><i class="fa fa-search"></i>&nbsp;&nbsp;Search</button>
</div>
</div>
</form>
</div>
</div>
				
				<div class="row">
                	<div class="col-md-12 col-sm-12 col-xs-12">
                	<div class="table-responsive">
                        <table class="ctable">
						    <thead>
						    <tr class="tg" style="position:absolute;width:100%;display:inline-table">
						    <th class="tg-cly1">  
						        <div class="line"></div>
						    </th>
						    <th class="tg-cly1">
						      <div class="line" ></div>
						    </th>
						    <th class="tg-cly1">
						      <div class="line" ></div>
						    </th>
						    <th class="tg-cly1">
						      <div class="line" ></div>
						    </th>
						    <th class="tg-cly1">
						      <div class="line" ></div>
						    </th>
						    <th class="tg-cly1">
						      <div class="line" ></div>
						    </th>
  							</tr>
						        <tr>
						            <th>Service</th>
						            <th>Remarks</th>
						        </tr>
						    </thead>
						    <tbody>
						    <%
						    if(estimates!=null&&estimates.length>0){
						    	for(int i=0;i<estimates.length;i++){						    		
						    	//esrefid,escompany,esprodqty,esprodname,esprodname,esregdate
						    %>
						    <tr>
						    <td><%=estimates[i][3] %>&nbsp;(<%=estimates[i][2] %>)</td>
						    <td>Estimate Created on <b><%=estimates[i][5] %></b></td>
						    </tr>
						   	<%if(estimates[i][6].equalsIgnoreCase("Cancelled")){ %>
						   	<tr>
						    <td><%=estimates[i][3] %>&nbsp;(<%=estimates[i][2] %>)</td>
						    <td>Estimate <b class="text-danger">Cancelled</b> on <b><%=estimates[i][5] %></b></td>
						    </tr>						   	
						    <%}}
						    String paymentType=Enquiry_ACT.findEstimateSalesPayType(estimate, token);
						    String[][] sales=TaskMaster_ACT.findAllSalesListByEstimate(estimate, token);
						    if(sales!=null&&sales.length>0){
						    	for(int i=0;i<sales.length;i++){		
						    		String docClass="text-primary";
						    		String docStatus="Active";
						    		if(Integer.parseInt(sales[i][12])==2){
						    			docClass="text-danger";docStatus="Inactive";
						    		}
						    		else if(Integer.parseInt(sales[i][12])==3){
						    			docClass="text-expired";docStatus="Expired";
						    		}
						    		else if(Integer.parseInt(sales[i][12])==4){
						    			docClass="text-success";docStatus="Completed";
						    		}
						    		
						    		// msinvoiceno,msproductname,mssolddate,msworkpercent,msworkstatus,"
						 			//		msassignedtoname,msdeliveredon,msprojectstatus,msdeliverydate,"
						 			//		msdeliverytime,mscancelstatus,document_assign_uaid,document_status\,
						 			//delivery_assign_date,msworkpercent
						    %>
						    <tr>
						    <td><%=sales[i][1] %></td>
						    <td>Estimate Converted to Sales on <b><%=sales[i][2] %></b> by payment term <b><%=paymentType %></b></td>
						    </tr>		
						    <tr>
						    <td><%=sales[i][1] %></td> 
						    <td>Assigned to <b>Document Department</b> on <b><%=sales[i][2] %></b> and document status is <b class="<%=docClass%>"><%=docStatus %></b></td>
						    </tr>						    	
						    
						    <%if(!sales[i][5].equalsIgnoreCase("Unassigned")){
						    	String projectColor="text-danger";
						    	String projectStatus="Inactive";
						      	if(sales[i][7].equalsIgnoreCase("2")){
						      		projectColor="text-success";projectStatus="Completed";
						      	}
						      	else if(sales[i][7].equalsIgnoreCase("3")){
						      		projectColor="text-primary";projectStatus="In-Progress";
						      	}						    	
						    	%>
						    <tr>
						    <td><%=sales[i][1] %></td> 
						    <td>Assigned to Operation Team '<b><%=sales[i][5] %></b>' on <b><%=sales[i][13] %></b></td>
						    </tr>					    
						    
						    <tr>
						    <td><%=sales[i][1] %></td> 
						    <td>Sale work is <b class="<%=projectColor%>"><%=projectStatus %></b> and work <b class="<%=projectColor%>"><%=sales[i][14] %> %</b> Completed.</td>
						    </tr>
						    
						    <%if(sales[i][10].equals("1")){ %>
						    <tr>
						    <td><%=sales[i][1] %></td> 
						    <td>Sales <b class="text-danger">Cancelled</b> on <b><%=estimates[i][5] %></b></td>
						    </tr>						    						    
						    <%}}}}}else{%>
						    <tr>
						    <td colspan="3">
						    <h4 class="text-danger text-center">No Data Found</h4>
						    </td>
						    </tr>
						    <%} %>												                                 
						    </tbody>
						</table>
						</div>											
				</div>
			</div>
		</div>
	</div>
	<p id="end" style="display:none;"></p>
</div>

<!-- Modal -->
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>	
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>

</body>
</html>