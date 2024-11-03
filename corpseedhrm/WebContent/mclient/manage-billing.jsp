<%@page import="commons.DateUtil"%>
<%@page import="com.azure.storage.blob.BlobClientBuilder"%>
<%@page import="java.util.Properties"%>
<%@page import="commons.CommonHelper"%>
<%@page import="admin.enquiry.Enquiry_ACT"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/> 
	<title>Manage Billing</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	<%
Properties properties = new Properties();
properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
String azure_path=properties.getProperty("azure_path");
String domain=properties.getProperty("domain");
	
String addedby= (String)session.getAttribute("loginuID");
String today=DateUtil.getCurrentDateIndianFormat1();
//pagination start
String filter="";
String sortF=request.getParameter("sort");
String ordF=request.getParameter("ord");
if(sortF!=null&&sortF.length()>0)filter="&sort="+sortF;
if(ordF!=null&&ordF.length()>0)filter+="&ord="+ordF;


int pageNo=1;
int rows=10;
String sort="";
String sorting_order="sorting_desc";
String order=request.getParameter("ord");
if(order==null)order="desc";
else if(order.equalsIgnoreCase("asc")){order="desc";sorting_order="sorting_desc";}
else if(order.equalsIgnoreCase("desc")){order="asc";sorting_order="sorting_asc";}

if(request.getParameter("page")!=null)pageNo=Integer.parseInt(request.getParameter("page"));
if(request.getParameter("rows")!=null)rows=Integer.parseInt(request.getParameter("rows"));

if(request.getParameter("sort")!=null)sort=request.getParameter("sort");

String sort_url=domain+"manage-billing.html?page="+pageNo+"&rows="+rows;

//pagination end

String billingDateRangeAction=(String)session.getAttribute("billingDateRangeAction");
if(billingDateRangeAction==null||billingDateRangeAction.length()<=0)billingDateRangeAction="NA";

String billingClientName=(String)session.getAttribute("billingClientName");
if(billingClientName==null||billingClientName.length()<=0)billingClientName="NA";

String billingContactName=(String)session.getAttribute("billingContactName");
if(billingContactName==null||billingContactName.length()<=0)billingContactName="NA";

String billingInvoiceNo=(String)session.getAttribute("billingInvoiceNo");
if(billingInvoiceNo==null||billingInvoiceNo.length()<=0)billingInvoiceNo="NA";

String billingDoAction=(String)session.getAttribute("billingDoAction");
if(billingDoAction==null||billingDoAction.length()<=0)billingDoAction="All";

String userroll= (String)session.getAttribute("emproleid"); 
String token=(String)session.getAttribute("uavalidtokenno");
double convertedSalesAmt=0;
double convertedSalesDues=0;
double pastDue=0;

convertedSalesAmt=Clientmaster_ACT.getTotalSalesPaidAmount(billingClientName,billingInvoiceNo,billingDateRangeAction,billingDoAction,token);
convertedSalesDues=Clientmaster_ACT.getSalesDueAmount(billingClientName,billingInvoiceNo,billingDateRangeAction,billingDoAction,token); 
pastDue=Clientmaster_ACT.getSalesPastDue(billingClientName,billingInvoiceNo,billingDateRangeAction,billingDoAction,token);
int pastInvoice=Clientmaster_ACT.countSalesPastDue(billingClientName,billingInvoiceNo,billingDateRangeAction,billingDoAction,token);
String country[][]=TaskMaster_ACT.getAllCountries();
int holdPayment=Enquiry_ACT.countHoldPayment(token); 
%> 
<%if(!MB07){%><jsp:forward page="/login.html" /><%} %>
	<div id="content"><%if(pastInvoice>0){ %>
		<div class="container-fluid">   
          <div class="relative_box">            
			<div class="notify_box">  
			<p><i class="info fas fa-info-circle"></i>You have <span><%=pastInvoice %> Invoice with an expected date in the past marked below</span>. We are forecasting these are payable by the end of the day.<i class="close_icon_btn fa fa-times"></i></p>
			</div>			
          </div>
        </div><%} %>
		<div class="main-content">
			<div class="container-fluid">				
				<div class="box_shadow1 invoice_info redius_box pad_box4 bg_wht mb30" <%if(billingDoAction.equalsIgnoreCase("Hold")){%> style="opacity: 0.2"<%} %>> 
                        <div class="clearfix dashboard_info">
                          <div class="pad0 col-md-3 col-sm-3 col-xs-6">
                           <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:150px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div>                          
						   <div class="clearfix mlft20">
                            <h3 title="<%=Math.round(convertedSalesAmt)%>"><i class="fa fa-inr"></i> <%=CommonHelper.formatValue(Math.round(convertedSalesAmt)) %></h3>
							<span>Fiscal Year Total</span>
						   </div>
                          </div>
                          <div class="pad0 bdr_left col-md-3 col-sm-3 col-xs-6">
                           <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:150px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div>                          
						   <div class="clearfix mlft20">
                            <h3><i class="fa fa-inr"></i> 50 days</h3>
							<span>Average Time To Pay</span>
                           </div>
						  </div>
                          <div class="pad0 bdr_left col-md-3 col-sm-3 col-xs-6">
                           <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:150px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div>                          
						   <div class="clearfix mlft20">
                            <h3 title="<%=Math.round(convertedSalesDues)%>"><i class="fa fa-inr"></i> <%=CommonHelper.formatValue(Math.round(convertedSalesDues)) %></h3>
							<span>Total Outstanding</span>
                           </div>
						  </div>
                          <div class="pad0 bdr_left col-md-3 col-sm-3 col-xs-6">
                           <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:150px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div>                          
						   <div class="clearfix mlft20">
                            <h3 title="<%=Math.round(pastDue)%>"><i class="fa fa-inr"></i> <%=CommonHelper.formatValue(Math.round(pastDue)) %></h3>
							<span>Past Due</span>
                           </div>
						  </div>
                        </div> 
				</div>
				
<div class="clearfix"> 
<form onsubmit="return false;">
<div class="bg_wht home-search-form clearfix mb10" id="SearchOptions">  
<div class="row">
<div class="post" style="position:absolute;z-index:9">
                        <div class="linee" style="margin-top: -1px;width:1350px;height:50px"></div>
                            </div>
<div class="post" style="position:absolute;z-index:9">
                        <div class="linee" style="margin-top: -1px;width:1350px;height:50px"></div>
                            </div>
<div class="col-md-4 col-sm-4 col-xs-9"> 
<ul class="clearfix filter_menu">
<li <%if(billingDoAction.equals("All")){ %>class="active"<%} %>><a onclick="doAction('All','billingDoAction');location.reload();">All</a></li>  
<li <%if(billingDoAction.equals("Paid")){ %>class="active"<%} %>><a onclick="doAction('Paid','billingDoAction');location.reload();">Paid</a></li>
<li <%if(billingDoAction.equals("Current")){ %>class="active"<%} %>><a onclick="doAction('Current','billingDoAction');location.reload();">Current</a></li>
<li <%if(billingDoAction.equals("Past due")){ %>class="active"<%} %>><a onclick="doAction('Past due','billingDoAction');location.reload();">Past due</a></li>
<li <%if(billingDoAction.equals("Hold")){ %>class="active"<%} %>><a onclick="doAction('Hold','billingDoAction');location.reload();">Hold<%if(holdPayment>0){ %><span class="notificationTxt"><%=holdPayment %></span><%} %></a></li>
</ul>
</div>
<a href="javascript:void(0)" class="doticon"> <i class="fa fa-filter" aria-hidden="true"></i>Filter</a>
<div class="filtermmenu">
<div class="col-md-8 col-sm-8 col-xs-12">
<div class="clearfix flex_box justify_end"> 
<div class="item-bestsell col-md-3 col-sm-6 col-xs-12">
<p><input type="search" name="contactName" id="ContactName" <%if(!billingContactName.equalsIgnoreCase("NA")){ %>onsearch="clearSession('billingContactName');location.reload();" value="<%=billingContactName %>"<%} %> title="Search by Client !" placeholder="Client Name.." class="form-control"/>
</p>
</div> 
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<p><input type="search" name="clientname" id="ClientName" autocomplete="off" <% if(!billingClientName.equalsIgnoreCase("NA")){ %>onsearch="clearSession('billingClientName');location.reload();" value="<%=billingClientName%>"<%} %> placeholder="Search by company.." class="form-control"/>
</p>
</div> 
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<p><input type="search" name="invoiceNo" id="InvoiceNo" <% if(!billingInvoiceNo.equalsIgnoreCase("NA")){ %>onsearch="clearSession('billingInvoiceNo');location.reload();" value="<%=billingInvoiceNo%>"<%} %> autocomplete="off" placeholder="Invoice No." class="form-control"/>
</p>
</div> 
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12 has-clear"> 
<p><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="FROM - TO" class="form-control text-center date_range pointers <%if(!billingDateRangeAction.equalsIgnoreCase("NA")){%>selected<%} %>" readonly="readonly"/>
<span class="form-control-clear form-control-feedback" onclick="clearSession('billingDateRangeAction');location.reload();"></span>
</p>
</div>
</div>
</div>
</div>
</div>
</div>
<!-- search option 2 -->
<div class="row noDisplay" id="SearchOptions1">
<div class="col-md-5 col-sm-5 col-xs-12"> 
<div class="col-md-3">
<button type="button" class="filtermenu dropbtn" style="width: 90px;" data-toggle="modal" data-target="#ExportData">&nbsp;Export</button>
</div>
</div>
<div class="col-md-7 col-sm-7 col-xs-12 min-height50">
<div class="clearfix flex_box justify_end">  

</div>
</div>
</div>
</form>
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
						            <th><span class="hashico">#</span><input type="checkbox" class="pointers noDisplay" id="CheckAll"></th>
						            <th class="sorting <%if(sort.equals("date")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','date','<%=order%>')">Date</th>
						            <th class="sorting <%if(sort.equals("invoice")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','invoice','<%=order%>')">Invoice/Estimate</th>
						            <th>Client</th>
						            <th class="sorting <%if(sort.equals("client")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','client','<%=order%>')">Company</th>
						            <th width="120" class="sorting <%if(sort.equals("txn_amt")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','txn_amt','<%=order%>')">TXN amt.</th>
						            <th width="120" class="sorting <%if(sort.equals("ord_amount")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','ord_amount','<%=order%>')">Order amt.</th>
						            <th width="120" class="sorting <%if(sort.equals("due")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','due','<%=order%>')">Due</th>
						            <th width="120" class="sorting <%if(sort.equals("paid")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','paid','<%=order%>')">Paid</th>
						            <th>Work %</th>
						            <th>Status</th>
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
						    String[][] estPayment=Clientmaster_ACT.getAllEstimatePayment(billingClientName,billingInvoiceNo,billingDateRangeAction,billingDoAction,token,pageNo,rows,sort,order,billingContactName);
                            int totalBilling=Clientmaster_ACT.countAllEstimatePayment(billingClientName,billingInvoiceNo,billingDateRangeAction,billingDoAction,token,billingContactName);
						    if(estPayment!=null&&estPayment.length>0){
                          	  ssn=rows*(pageNo-1);
                        	  totalPages=(totalBilling/rows);
                        	  if((totalBilling%rows)!=0)totalPages+=1;
                        	  showing=ssn+1;
                        	  if (totalPages > 1) {     	 
                        		  if((endRange-2)==totalPages)startRange=pageNo-4;        
                                  if(startRange==pageNo)endRange=pageNo+4;
                                  if(startRange<1) {startRange=1;endRange=startRange+4;}
                                  if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
                                  if(startRange<1)startRange=1;
                             }else{startRange=0;endRange=0;}
                             for(int i=0;i<estPayment.length;i++) {	  
                            	 String client[][]=Enquiry_ACT.getClientDetails(estPayment[i][5],token);
                            	 String workPercent=TaskMaster_ACT.getSalesWorkPercentage(estPayment[i][1], token);
                            	 String invoiceno="NA";
                            	 boolean regPayment=false;
                            	 double dueAmount=Double.parseDouble(estPayment[i][8]);
                            	 double paidAmount=Double.parseDouble(estPayment[i][7]);
                            	 if(dueAmount<=0)dueAmount=0;
                            	 String url="#";
                            	 String salesKey="NA";
                            	 if(estPayment[i][2]==null||estPayment[i][2].equalsIgnoreCase("NA")){
                            		 invoiceno=estPayment[i][1];
                            		 salesKey=Enquiry_ACT.getEstimateKey(invoiceno,token);
                            		 url=request.getContextPath()+"/invoice-"+salesKey+".html";
                            	 }else{                            		 
                            		 invoiceno=estPayment[i][2];regPayment=true;
                            		 salesKey=Enquiry_ACT.getSalesKey(invoiceno,token);
                            		 url=request.getContextPath()+"/sales-invoice-"+salesKey+".html";
                            		 }
                           %>
                            <tr class="tg" style="position:absolute;width:100%;display:inline-table">
							    <td class="tg-cly1">
							      <div class="line"></div>
							    </td>
							    <td class="tg-cly1">
							      <div class="line"></div>
							    </td>
							    <td class="tg-cly1">
							      <div class="line"></div>
							    </td>
							    <td class="tg-cly1">
							      <div class="line"></div>
							    </td>
							    <td class="tg-cly1">
							      <div class="line"></div>
							    </td>
							    <td class="tg-cly1">
							      <div class="line" style="position:relative;z-index:9"></div>
							    </td>
							   
							  </tr>
						        <tr id="BillingRow<%=(i+1)%>">
						            <td><input type="checkbox" name="checkbox" id="checkbox" class="checked"></td>
						            <td><%=estPayment[i][11] %></td>
						            <td><a href="<%=url%>" target="_blank"><%=invoiceno %></a></td>
						            <td class="name_action_box position-relative" id="main<%=estPayment.length-i %>">
						            <span id="MainCon<%=estPayment.length-i %>" class="clickeble contactbox name_field" data-related="update_contact" <%if(client!=null&&client.length>0){ %>onclick="openContactBox('<%=client[0][3] %>','<%=client[0][2] %>','MainCon<%=estPayment.length-i%>','<%=estPayment[i][3] %>')"><%=client[0][0] %><%}else{ %>>NA<%} %></span>
                                    <%if(client!=null&&client.length>1){ %>
                                    <div class="iAction">
                                    <i class="fa fa-plus pointers" onclick="showAllContact(event,'main<%=estPayment.length-i %>','sub<%=estPayment.length-i %>')"><small><%=(client.length-1) %></small></i><i class="fa fa-minus pointers" onclick="minusAllContact(event)"></i>
                                    </div>
                                    <%} %>
						            <ul class="dropdown_list" id="sub<%=estPayment.length-i %>">
									<%if(client.length>1){for(int j=1;j<client.length;j++){ %>
									<li><a class="addnew2 pointers clickeble contactbox" data-related="update_contact" id="SubCon<%=estPayment.length-i %>" onclick="openContactBox('<%=client[j][3] %>','<%=client[j][2] %>','SubCon<%=estPayment.length-i%>','<%=estPayment[i][3] %>')"><%=client[j][0] %></a></li>
									<%}} %>
									</ul>
						            </td>
						            <td><span <%if(!estPayment[i][4].equalsIgnoreCase("....")){ %>class="clickeble name_action_box companybox" data-related="update_company" onclick="openCompanyBox('<%=estPayment[i][3]%>')"<%} %>><%=estPayment[i][4] %></span></td>
						            <%if(billingDoAction.equalsIgnoreCase("Hold")){ %>
						            <td><i class="fas fa-inr inr"></i>&nbsp;<%=CommonHelper.withLargeIntegers(Double.parseDouble(estPayment[i][16])) %></td>
						            <%}else{ %><td><i class="fas fa-inr inr"></i>&nbsp;<%=CommonHelper.withLargeIntegers(Double.parseDouble(estPayment[i][9])) %></td><%} %>
						            <td><i class="fas fa-inr inr"></i>&nbsp;<%=CommonHelper.withLargeIntegers(Double.parseDouble(estPayment[i][6])) %></td>
						            <td><i class="fas fa-inr inr"></i>&nbsp;<%=CommonHelper.withLargeIntegers(dueAmount) %></td>
						            <td><i class="fas fa-inr inr"></i>&nbsp;<%=CommonHelper.withLargeIntegers(paidAmount) %></td>
						            <td><%if(workPercent.equals("NA")){ %>Not Converted<%}else{ %><%=workPercent %>%<%} %></td>
						            <td><%if(estPayment[i][14].equals("2")){ %>Draft<%}else if(estPayment[i][14].equals("1")){ %>Invoiced<%}else if(estPayment[i][14].equals("3")){ %>Unbilled<%} %></td>
						            <td class="list_icon">
						           <a href="javascript:void(0)" class="icoo">
						            <i class="fas fa-angle-down pointers icoo"></i>
									<i class="fas fa-angle-up pointers"></i>
									</a>
									<ul class="dropdown_list" style="display:none">																		
									<%if(CB06&&dueAmount>0){ %><li><a class="pointers" onclick="fillPaymentDetails('<%=invoiceno%>','BillingRow<%=(i+1)%>','<%=estPayment[i][3] %>','<%=estPayment[i][5] %>')">Mark as paid
									<%if(!estPayment[i][10].equalsIgnoreCase("0")&&!billingDoAction.equalsIgnoreCase("Hold")){ %><span class="notificationTxt"></span><%}else if(!estPayment[i][15].equalsIgnoreCase("0")&&billingDoAction.equalsIgnoreCase("Hold")){ %><span class="notificationTxt"></span><%} %>
									</a></li><%} %>
									<%if(MB00&&dueAmount>0&&regPayment){ %><li><a class="pointers" onclick="fillHeading('<%=estPayment[i][1]%>','<%=estPayment[i][2]%>','<%=estPayment[i][3]%>','<%=estPayment[i][5]%>','<%=dueAmount%>','<%=estPayment[i][6]%>')">Register payment</a></li><%} %>
									<%if(AMC00){ %><li><a class="pointers historybox" data-related="payment_history" onclick="openPaymentHistory('<%=invoiceno%>','<%=estPayment[i][1]%>','<%=estPayment[i][6] %>','<%=dueAmount %>')">Payment history</a></li><%} %>
									</ul>
									<%if(!estPayment[i][10].equalsIgnoreCase("0")&&!billingDoAction.equalsIgnoreCase("Hold")){ %><span class="notificationTxt"><span ><%=estPayment[i][10] %></span></span><%}else if(!estPayment[i][15].equalsIgnoreCase("0")&&billingDoAction.equalsIgnoreCase("Hold")){ %><span class="notificationTxt"><span ><%=estPayment[i][15] %></span></span><%} %>
									</td>
						        </tr>
						     <%}}%>                                 
						    </tbody>
						</table> 
						
                        <div class="filtertable">
			  <span>Showing <%=showing %> to <%=ssn+estPayment.length %> of <%=totalBilling %> entries</span>
			  <div class="pagination">
			    <ul> <%if(pageNo>1){ %>
			      <li class="page-item">	                     
			      <a class="page-link text-primary" href="<%=request.getContextPath()%>/manage-billing.html?page=1&rows=<%=rows%><%=filter%>">First</a>
			   </li><%} %>
			    <li class="page-item">					      
			      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/manage-billing.html?page=<%=(pageNo-1) %>&rows=<%=rows%><%=filter%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
			    </li>  
			      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
				    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
				    <a class="page-link" href="<%=request.getContextPath()%>/manage-billing.html?page=<%=i %>&rows=<%=rows%><%=filter%>"><%=i %></a>
				    </li>   
				  <%} %>
				   <li class="page-item">						      
				      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/manage-billing.html?page=<%=(pageNo+1) %>&rows=<%=rows%><%=filter%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
				   </li><%if(pageNo<=(totalPages-1)){ %>
				   <li class="page-item">
				      <a class="page-link text-primary" href="<%=request.getContextPath()%>/manage-billing.html?page=<%=(totalPages) %>&rows=<%=rows%><%=filter%>">Last</a>
				   </li><%} %>
				</ul>
				</div>
				<select class="select2" onchange="changeRows(this.value,'manage-billing.html?page=1','<%=domain%>')">
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
<div class="fixed_right_box">	

<div class="clearfix add_inner_box pad_box4 addcompany" id="payment_history">
<div class="close_icon close_box"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-history"></i>Payment history :&nbsp;<span id="PayHistoryInvoice" class="text-warning"></span></h3>
<p>When someone reaches out to you, they become a contact in your account. You can create companies and associate contacts with them.</div>

<div class="table-responsive mb-10">
<table class="ctable" id="paymentTable">
   <thead>
      <th>Name</th>
      <th>Payment</th>
   </thead>
   <tbody>   
   
   </tbody>
</table>
</div>
<div class="rttop_titlep">
<h3 style="color: #42b0da;" class="fa fa-history">&nbsp;Payment history</h3>
<span style="margin-left: 15px;font-size: 14px;color: #42b0dabf;">Order amount : <i class="fa fa-inr"></i>&nbsp;<span id="TotalOrderAmountId">0.00</span></span>    
<span style="font-size: 14px;color: #da8142ba;">Due amount : <i class="fa fa-inr"></i>&nbsp;<span id="TotalDueAmountId">0.00</span></span>
</div>
<div class="menuDv pad_box4 clearfix mb30">

<!-- start -->
<div class="clearfix" id="ApprovedPaymentListId"></div>
<!-- end -->

</div>
</div>
<div class="clearfix add_inner_box pad_box4 addcompany" id="update_company">
<div class="close_icon close_box"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-building-o"></i>Update Company</h3> 
<p>When someone reaches out to you, they become a contact in your account. You can create companies and associate contacts with them.</div>
<form onsubmit="return false;" id="UpdateRegCompany">
<input type="hidden" id="UpdateCompanyKey">
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="companyname" id="UpdateCompanyName" placeholder="Company Name" onblur="validCompanyNamePopup('UpdateCompanyName');validateValuePopup('UpdateCompanyName');" class="form-control bdrd4" readonly="readonly">
 </div>
  <div id="cnameErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="industry" id="UpdateIndustry_Type" placeholder="Industry" onblur="validateNamePopup('UpdateIndustry_Type');validateValuePopup('UpdateIndustry_Type')" class="form-control bdrd4">
  </div>
  <div id="industryErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
<div class="clearfix inner_box_bg">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">  
 <label>Super User</label>
  <div class="input-group">
  <select name="update_super_user" id="Update_Super_User" class="form-control bdrd4" required="required">  
  </select>
  </div>
  <div class="clearfix text-right mt-5">
     <button class="addbtn pointers active" onclick="addSuperUser('Update_Super_User')" type="button">+ Add Super User</button>
  </div>
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>Pan Number :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
  <input type="text" name="pannumber" id="UpdatePanNumber" placeholder="Pan Number" onblur="validatePanPopup('UpdatePanNumber');validateValuePopup('UpdatePanNumber');isExistEditCompanyPan('UpdatePanNumber');" class="form-control bdrd4">
  </div>
  <div id="panNoErrorMSGdiv" class="errormsg"></div>
 </div>
 <div class="text-right" style="margin-top: -8px;">
<span class="add_new pointers">+ GST</span>
</div>
<div class="relative_box form-group new_field" id="CompanyGstDivId">
  <label>GST Number :</label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>-->
  <input type="text" name="gstnumber" id="UpdateGSTNumber" onblur="isExistEditGST('UpdateGSTNumber')" placeholder="GST Number here !" class="form-control bdrd4">
<button class="addbtn pointers close_icon1 del_icon" type="button"><i class="fa fa-times" style="font-size: 20px;"></i></button>
  </div>
  <div id="newEmailErrorMSGdiv" class="errormsg"></div> 
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>Company Age :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <select name="edit_company_age" id="Edit_Company_age" class="form-control bdrd4">
  <option value="">Select Age</option>
  <option value="0">0 Year</option>
  <option value="1">1 Year</option>
  <option value="2">2 Years</option>
  <option value="3">3 Years</option>
  <option value="4">4 Years</option>
  <option value="5">5 Years</option>
  <option value="6">6 Years</option>
  <option value="7">7 Years</option>
  <option value="8">8 Years</option>
  <option value="9">9 Years</option>
  <option value="10">10 Years</option>
  <option value="11">11 Years</option>
  <option value="12">12 Years</option>
  <option value="13">13 Years</option>
  <option value="14">14 Years</option>
  <option value="15">15 Years</option>
  <option value="16">16 Years</option>
  <option value="17">17 Years</option>
  <option value="18">18 Years</option>
  <option value="19">19 Years</option>
  <option value="20">20+ Years</option>
  </select>
  </div>
  <div id="companyAgeErrorMSGdiv" class="errormsg"></div>
 </div>
</div>

<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>Country :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">  
   <select name="country" id="UpdateCountry" class="form-control bdrd4" onchange="updateState(this.value,'UpdateState')">
    <option value="">Select Country</option>
   <%if(country!=null&&country.length>0){for(int i=0;i<country.length;i++){%>	   
   <option value="<%=country[i][1]%>#<%=country[i][0]%>"><%=country[i][0]%></option>
   <%}} %>
   </select>
   </div>
   <div id="countryErrorMSGdiv" class="errormsg"></div>
  </div>
 </div>
 <div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>State :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
<!--   <input type="text" name="state" id="UpdateState" placeholder="State" onblur="validateCityPopup('UpdateState');validateValuePopup('UpdateState')" class="form-control bdrd4"> -->
  <select name="state" id="UpdateState" class="form-control bdrd4" onchange="updateCity(this.value,'UpdateCity')">
    <option value="">Select State</option>   
     
   </select>
  </div>
  <div id="stateErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>City :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
<!--   <input type="text" name="city" id="UpdateCity" placeholder="City" onblur="validateCityPopup('UpdateCity');validateValuePopup('UpdateCity')" class="form-control bdrd4"> -->
  <select name="city" id="UpdateCity" class="form-control bdrd4">
  <option value="">Select City</option>
 
  </select>
  </div>
  <div id="cityErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group">
  <label>Address :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite page"></i></span>-->
  <textarea class="form-control bdrd4" rows="2" name="enqAdd" id="UpdateAddress" placeholder="Address" onblur="validateLocationPopup('UpdateAddress');validateValuePopup('UpdateAddress');" ></textarea>
  </div>
  <div id="enqAddErrorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
</div>
<div class="clearfix mtop10 mb10 text-right"> 
<button class="bt-link bt-radius bt-gray mrt10 close_box" type="button">Cancel</button>
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateUpdateCompany();">Update</button>
</div>
</form>                                  
</div>
<div class="clearfix add_inner_box pad_box4 addcompany" id="update_contact">
<div class="close_icon close_box"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-fax"></i>Update Client's details</h3>
<p>When someone reaches out to you, they become a contact in your account. You can create companies and associate contacts with them.</div>

<form onsubmit="return false;" id="FormUpdateContactBox">
<input type="hidden" id="UpdateContactKey"/>
<input type="hidden" id="UpdateContactSalesKey"/>
<input type="hidden" id="UpdateContactClientKey"/>

<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="form-group">
  <div class="input-group">
  <input type="text" name="firstname" id="UpdateContactFirstName" placeholder="First Name" class="form-control bdrd4">
  </div>
  <div id="fnameErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="lastname" id="UpdateContactLastName" placeholder="Last Name" class="form-control bdrd4">
  </div>
  <div id="lnameErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
<div class="clearfix inner_box_bg">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="mb10"> 
 <label>Email :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>-->
  <input type="email" name="enqEmail" id="UpdateContactEmail_Id" placeholder="Email" class="form-control bdrd4">
 </div>
 <div id="enqEmailErrorMSGdiv" class="errormsg"></div>
</div>
<div class="text-right">
<span class="add_new pointers">+ Email</span>
</div>
<div class="relative_box form-group new_field" id="UpdateContactDivId" style="display:none;">
  <label>Email 2nd :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>-->
  <input type="email" name="enqEmail" id="UpdateContactEmailId2" placeholder="Email" class="form-control bdrd4">
</div>
  <div id="newEmailErrorMSGdiv" class="errormsg"></div> 
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>Pan :</label>
  <div class="input-group">
  <input type="text" name="contPan" id="UpdateContPan" onblur="validatePanPopup('UpdateContPan');validateValuePopup('UpdateContPan');isExistEditPan('UpdateContPan');" placeholder="Pan" maxlength="14" class="form-control bdrd4">
  </div>
  <div id="wphoneErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>Work Phone :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
  <input type="text" name="workphone" id="UpdateContactWorkPhone" placeholder="Work phone" maxlength="14" class="form-control bdrd4" onkeypress="return isNumber(event)">
  </div>
  <div id="wphoneErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>Mobile Phone :</label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
  <input type="text" name="mobilephone" id="UpdateContactMobilePhone" placeholder="Mobile Phone" maxlength="14" class="form-control bdrd4" onkeypress="return isNumber(event)">
  </div>
  <div id="mphoneErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="mb10 flex_box align_center">
<span class="input_radio">
<input type="radio" name="addresstype" id="UpdateContactperAddress" checked>
<span>Personal Address</span>
</span>
<span class="mlft10 input_radio">
<input type="radio" name="addresstype" id="UpdateContactcomAddress" onclick="getUpdateCompanyAddress()">
<span>Company Address</span>
</span>
</div>
</div>
</div>
<div class="row UpdateAddress_box">
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
   <label>Country :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <select class="form-control" name="country" id="UpdateContCountry" onchange="updateState(this.value,'UpdateContState')">
  <option value="">Select Country</option>
  <%if(country!=null&&country.length>0){for(int i=0;i<country.length;i++){%>	   
   <option value="<%=country[i][1]%>#<%=country[i][0]%>"><%=country[i][0]%></option>
   <%}} %>
  </select>
  </div>
  <div id="enqCountryErrorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row UpdateAddress_box">
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="form-group">
  <label>State :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <select class="form-control bdrd4" name="state" id="UpdateContState" onchange="updateCity(this.value,'UpdateContCity')">
  <option value="">Select State</option>
  </select>
  </div>
  <div id="stateErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="form-group">
  <label>City :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
   <select class="form-control bdrd4" name="city" id="UpdateContCity">
  <option value="">Select City</option>
  </select>
  </div>
  <div id="cityErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
<div class="row UpdateAddress_box">
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
   <label>Address :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite page"></i></span>-->
  <textarea class="form-control bdrd4" rows="2" name="enqAdd" id="UpdateContAddress" placeholder="Address"></textarea>
  </div>
  <div id="enqAddErrorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row UpdateCompany_box" style="display:none;">
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon fa fa-bank"></i></span>-->
  <textarea class="form-control bdrd4" rows="2" name="enqCompAdd" id="UpdateEnqCompAddress" placeholder="Company Address" readonly="readonly"></textarea>
  </div>
  <div id="companyErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
<div class="clearfix mtop10 mb10 text-right">
<button class="bt-link bt-radius bt-gray mrt10 close_box" type="button">Cancel</button>
<button class="bt-link bt-radius bt-loadmore" type="submit" id="ValidateUpdateContact" onclick="return validateUpdateContact();">Update</button>
</div>
</form>
</div>
</div>
<div class="modal fade" id="MarkPayment" tabindex="-1" role="dialog" aria-labelledby="TaxModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Mark Payment As Paid</h5>
        <button type="button" onclick="isReload('ApprovalGrantedId')" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="pymt-body">
      <div class="col-md-12 col-sm-12 col-xs-12">
        <div class="clearfix" id="PymtCnfId"></div>
		</div>
      </div>   
      <div class="modal-footer">
<!--         <button type="button" class="btn btn-secondary" data-dismiss="modal" onclick="isReload('ApprovalGrantedId')">Close</button> -->
      </div>   
    </div>
  </div>
</div>
<div class="modal fade" id="RegisterPayment" tabindex="-1" role="dialog" aria-labelledby="PaymentModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
  <form onsubmit="return false;" enctype="multipart/form-data" id="UploadFormdata" class="uploadFormdata">   
  <input type="hidden" id="EstimateNoBoxId" name="estimateNoBoxId" value="NA">
  <input type="hidden" id="SalesOrderAmountId" name="SalesOrderAmountId" value="0">
  <input type="hidden" id="InvoiceNoBoxId" name="invoiceNoBoxId" value="NA">
  <input type="hidden" id="ClientRefIdBoxId" name="clientRefIdBoxId" value="NA">
  <input type="hidden" id="ContactRefIdBoxId" name="contactRefIdBoxId" value="NA">
  <input type="hidden" id="BillingRegisterPayment" name="billingRegisterPayment" value="0">
    <div class="modal-content"> 
      <div class="modal-header">
        <h5 class="modal-title" >Register Payment : <span style="color:#357b8bf5;" id="RegisterPaymentOfInvoice"></span>
        <a href="javascript:void(0)" onclick="showGstBox()" style="margin-left: 16rem;"><u>Calculate GST ?</u></a>
        </h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
      <div class="col-md-12 col-sm-12 col-xs-12">
		<div class="row">
		<div class="col-md-6 col-sm-6 col-xs-12">
		<div class="form-group">
		 <select name="paymentmode" id="PaymentMode" class="form-control bdrd4"  onchange="selectMode(this.value)">
		<option value="">Payment Mode</option>
		<option value="Online" selected="selected">Online</option>
		<option value="Cash">Cash</option>
		</select>
		  <div id="paymentmodeErrorMSGdiv" class="errormsg"></div>
		 </div>
		</div>
		<div class="col-md-6 col-sm-6 col-xs-12">
		 <div class="form-group">
		  <input type="text" name="pymtdate" id="PaymentDate" value="<%=today %>" autocomplete="off" placeholder="Date" class="form-control datepicker readonlyAllow bdrd4" readonly="readonly">
		   <div id="pdateErrorMSGdiv" class="errormsg"></div>
		 </div>
		</div>
		</div>
		 <div class="form-group row">
		 <label class="col-sm-4">Transaction Id</label>
		  <div class="col-sm-8">
		  <input type="text" name="transactionid" id="TransactionId" autocomplete="off" placeholder="Transaction Id" class="form-control">
		  </div>
		  <div id="transactionidErrorMSGdiv" class="errormsg"></div>
		 </div>
		 <div class="form-group row">
		 <label class="col-sm-4">Service Name</label>
		  <div class="col-sm-8">
		  <div class="row">
		  <div class="col-sm-10">
		  <select class="form-control width-90" name="service_Name" id="Service_Name" multiple="multiple">
		  </select>
		  </div>
		  <div class="col-sm-2 pl-0">  
			<input type="text" class="form-control p-0" id="serviceQty" placeholder="Qty." onkeypress="return isNumber(event)">
		   </div>
		   </div>
		  </div>
		  <div id="service_NameErrorMSGdiv" class="errormsg"></div>
		 </div>
		 <div class="form-group row">
		 <label class="col-sm-4">Professional Fees</label>
		  <div class="col-sm-8">
		  <input type="text" name="professional_Fee" id="Professional_Fee" onchange="calculateTotalPayment()" autocomplete="off"
		   placeholder="Professional Fee" class="form-control" onkeypress="return isNumberKey(event)">
		  <span class="totalamt" id="Professional_Fee_GST">0%</span>
		  </div>
		  <div id="professional_FeeErrorMSGdiv" class="errormsg"></div>
		 </div>
		 <div class="form-group row">
		 <label class="col-sm-4">Government Fees</label>
		  <div class="col-sm-8">
		  <input type="text" name="government_Fee" id="Government_Fee" onchange="calculateTotalPayment()" autocomplete="off"
		   placeholder="Government Fee" class="form-control padr4rem" onkeypress="return isNumberKey(event)">
		  <span class="totalamt" id="Government_Fee_GST">0%</span>
		  </div>
		  <div id="government_FeeErrorMSGdiv" class="errormsg"></div>
		 </div>
		  <div class="form-group row">
		 <label class="col-sm-4">Service Charges</label>
		  <div class="col-sm-8">
		  <input type="text" name="service_Charges" id="service_Charges" onchange="calculateTotalPayment()" autocomplete="off"
		   placeholder="Service charges" class="form-control padr4rem" onkeypress="return isNumberKey(event)">
		  <span class="totalamt" id="service_Charges_GST">0%</span>
		  </div>
		 </div>
		 <div class="form-group row">
		 <label class="col-sm-4">Other Fees</label>
		  <div class="col-sm-8">
		  <input type="text" name="other_Fee" id="Other_Fee" onchange="calculateTotalPayment();showRemark();" autocomplete="off"
		   placeholder="Other Fee" class="form-control padr4rem" onkeypress="return isNumberKey(event)">
		   <span class="totalamt" id="Other_Fee_GST">0%</span>
		  </div>
		  <div id="other_FeeErrorMSGdiv" class="errormsg"></div>
		 </div>
		 <div class="form-group row toggle_box" id="Other_Fee_remark_Div">
		 <label class="col-sm-4"></label>
		  <div class="col-sm-8">
		  <input type="text" name="other_Fee_remark" id="Other_Fee_remark" autocomplete="off" placeholder="Other Fee Remarks" 
		  class="form-control padr4rem">
		  </div>
		  <div id="other_Fee_remarkErrorMSGdiv" class="errormsg"></div>
		 </div>
		 <div class="form-group row">
		 <label class="col-sm-4">Upload Receipt</label>
		  <div class="col-sm-8">
		    <input type="file" name="choosefile" id="ChooseFile" onchange="validateFileSize('ChooseFile')" placeholder="Choose File" class="form-control">
		     <small>Select Transaction Receipt To Upload <span class="txt_red">(Max Size 48MB)</span></small>
		    </div>   
		    <div id="cfileErrorMSGdiv" class="errormsg"></div>
		   </div>
		 <div class="form-group row">
		 <label class="col-sm-4">Total</label>
		  <div class="col-sm-8" style="padding-left:0;padding-right:0">
		  <div class="col-sm-5">
		  <input type="text" readonly="readonly" value="0" class="form-control" name="transactionamount" id="TotalPaymentId"/>
		  </div>
		  <div class="col-sm-4">
		  <input type="hidden" id="GSTApplied" name="gstApplied" value="1">
		  <input type="checkbox" checked="checked" id="GSTApplyId" name="gstApply" style="width:20px;height:20px;margin:10px 0">
		 <span style="vertical-align: super;margin-left: 5px;">GST Apply</span>
		  </div>
		  </div>
		 </div>
		  <div class="form-group row">
		 <label class="col-sm-4">Remarks </label>
		  <div class="col-sm-8">
		    <textarea name="remarks" rows="4" id="remarks" placeholder="Remarks here !" class="form-control"></textarea>     
		    </div>   
		  </div>
		</div>
      </div>   
      <div class="modal-footer">      
		<input type="hidden" id="ProfessionalFeeTax" value="0"/>
		<input type="hidden" id="GovernmentFeeTax" value="0"/>
		<input type="hidden" id="ServiceChargeTax" value="0"/>
		<input type="hidden" id="OtherFeeTax" value="0"/>
		<input type="hidden" id="ProfessionalCgst" name="professionalCgst" value="0"/>
		<input type="hidden" id="ProfessionalSgst" name="professionalSgst" value="0"/>
		<input type="hidden" id="ProfessionalIgst" name="professionalIgst" value="0"/>
		<input type="hidden" id="GovernmentCgst" name="governmentCgst" value="0"/>
		<input type="hidden" id="GovernmentSgst" name="governmentSgst" value="0"/>
		<input type="hidden" id="GovernmentIgst" name="governmentIgst" value="0"/>
		<input type="hidden" id="ServiceChargeCgst" name="serviceChargeCgst" value="0"/>
		<input type="hidden" id="ServiceChargeSgst" name="serviceChargeSgst" value="0"/>
		<input type="hidden" id="ServiceChargeIgst" name="serviceChargeIgst" value="0"/>
		<input type="hidden" id="OtherCgst" name="otherCgst" value="0"/>
		<input type="hidden" id="OtherSgst" name="otherSgst" value="0"/>
		<input type="hidden" id="OtherIgst" name="otherIgst" value="0"/>
		
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-primary" id="btnclick12" onclick="validatePayment(event)">Submit</button>
      </div>   
    </div>
    </form>
  </div>
</div>

<div class="modal fade" id="warningAmount" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span>
        <span class="text-danger">Please Update transaction amount.</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" style="width: 15%;">OK</button>
      </div>
    </div>
  </div>
</div>
<div class="modal fade" id="warningHold" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span><span class="text-danger">Are you sure want to hold this transaction ?</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div> 
      <div class="modal-body">
      <div id="paymentRemarksHold"></div>
      <h5>Add Comment : </h5>
      <p><textarea rows="4" id="paymentCnfCommentHold" class="form-control" placeholder="Add comment here !" required="required"></textarea> </p>
      </div>      
      <input type="hidden" id="HoldPaymentRefid" value="NA"/>
      <input type="hidden" id="HoldSalesInvoiceid" value="NA"/>
      <input type="hidden" id="HoldSalesInvoiceRowid" value="NA"/>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" style="width: 15%;">No</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal" style="width: 15%;" onclick="return holdSalesPayment()">Yes</button>
      </div>
    </div>
  </div>
</div>
<div class="modal fade" id="warningDecline" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span><span class="text-danger">Are you sure want to decline this transaction ?</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div> 
      <div class="modal-body">
      <div id="paymentRemarksDecline"></div>
      <h5>Add Comment : </h5>
      <p><textarea rows="4" id="paymentCnfCommentDecline" class="form-control" placeholder="Add comment here !" required="required"></textarea> </p>
      </div>      
      <input type="hidden" id="DeclinePaymentRefid" value="NA"/>
      <input type="hidden" id="DeclineSalesInvoiceid" value="NA"/>
      <input type="hidden" id="DeclineSalesInvoiceRowid" value="NA"/>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" style="width: 15%;">No</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal" style="width: 15%;" onclick="return declineSalesPayment()">Yes</button>
      </div>
    </div>
  </div>
</div>
<div class="modal fade" id="warningApprove" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="text-danger">Have you checked this transaction details ?</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>  
      <div class="modal-warning" style="padding: 1rem 1.5rem 0rem 1.5rem;display: none">
	    <h4 class="text-danger" id="warningPayment">Warning :- Minimum payment required is 20k, Please re-confirm before proceeding.</h4>
	  </div>
      <div class="modal-body">
      <div id="paymentRemarks"></div>
      <h5>Add Comment : </h5>
      <p><textarea rows="4" id="paymentCnfComment" class="form-control" placeholder="Add comment here !" required="required"></textarea> </p>
      </div>   
      <input type="hidden" id="PaymentRefid" value="NA"/>
      <input type="hidden" id="SalesInvoiceid" value="NA"/>
      <input type="hidden" id="SalesInvoiceClientRefid" value="NA"/>
      <input type="hidden" id="SalesInvoiceContactRefid" value="NA"/>
      <input type="hidden" id="SalesInvoiceRowid" value="NA"/>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" style="width: 15%;">No</button>
        <button type="button" class="btn btn-primary" style="width: 15%;" onclick="return approveSalesPayment()">Yes</button>
      </div>
    </div>
  </div>
</div>
<div class="modal fade" id="showGSTModel" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="showGSTModel">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-line-chart text-primary" style="margin-right: 10px;"> </span>
        <span class="text-primary">Calculate GST </span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <form action="return false" id="gstCalculater">
       <div class="modal-body">       
         <div class="form-group">
            <label for="recipient-name" class="col-form-label">Total amount :</label>
            <input type="text" autocomplete="off" class="form-control" placeholder="Amount.." name="gstAmount" id="gstAmount" onchange="calculateGstAmount()" onkeypress="return isNumberKey(event)">
          </div>          
        <div class="form-group">
            <label for="recipient-name" class="col-form-label">GST % :</label>
            <input type="text" autocomplete="off" class="form-control" placeholder="GST %" name="gstPercent" value="18" id="GstPercent" onchange="calculateGstAmount()" onkeypress="return isNumberKey(event)">
          </div>
         <div class="form-group">
            <label for="recipient-name" class="col-form-label">Amount without GST :</label>
             <input type="text" autocomplete="off" class="form-control" placeholder="Amount without gst" name="amountWithoutGst" id="amountWithoutGst" onkeypress="return isNumberKey(event)">
          </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-primary" onclick="return copyGstAmount()">Copy Amount</button>
      </div></form>
    </div>
  </div>
</div>
<div class="modal fade" id="warningDocument" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span><span class="text-danger">Sorry , Document Doesn't Exist..</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" style="width: 15%;">OK</button>
      </div>
    </div>
  </div>
</div>
<div class="modal fade" id="ExportData" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fas fa-file-export text-primary" style="margin-right: 10px;"> </span><span class="text-primary">Export</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <form action="return false" id="sendEmailInvoice">
       <div class="modal-body">       
         <div class="form-group">
            <label for="recipient-name" class="col-form-label">FROM :</label>
            <input type="text" autocomplete="off" class="form-control searchdate pointers" name="from-date" id="From-Date" placeholder="FROM-DATE" readonly="readonly">
          </div>        
        <div class="form-group">
            <label for="recipient-name" class="col-form-label">TO :</label>
            <input type="text" autocomplete="off" class="form-control searchdate pointers" name="to-date" id="To-Date" placeholder="TO-DATE" readonly="readonly">
          </div> 
          <div class="form-group">
            <label for="recipient-name" class="col-form-label">Columns :</label>
            <select class="form-control" name="exportColumn" id="ExportColumn" multiple="multiple">
            	<option value="cbinvoiceno" selected>Invoice</option>
            	<option value="cbcontactrefid" selected>Contact Name</option>
            	<option value="cbcompanyname" selected>Client Name</option>
            	<option value="cbtransactionamount" selected>Transaction Amount</option>
            	<option value="cborderamount" selected>Order Amount</option>
            	<option value="cbpaidamount" selected>Paid</option>
            	<option value="cbuid" selected>Status</option> 
            </select>            
          </div>
         <div class="form-group">
            <label for="recipient-name" class="col-form-label">Format :</label>
            <select class="form-control" name="file-formate" id="File-Formate">
            	<option value="csv">CSV</option>
            	<option value="xlsx" selected>XLS</option>
            </select>
          </div>   
          <div class="form-group noDisplay">
            <label for="recipient-name" class="col-form-label">Password Protected :</label>
            <input type="checkbox" name="protected" id="Protected" value="2">&nbsp;&nbsp;
            <input type="password" class="noDisplay form-control" name="filePassword" id="FilePassword" placeholder="Enter password.."> 
          </div>      
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-primary" onclick="return validateExport()">Submit</button>
      </div></form>
    </div>
  </div>
</div>
<div class="myModal modal fade" id="add_super_user">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title"><i class="fas fa-user" aria-hidden="true"></i>+Add Super User</h4>  
          <button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>
        <form onsubmit="return validateSuperUser()" action="javascript:void(0)" id="super_user_form">    
        <div class="modal-body">            
		  <div class="row">
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>Name</label>
            <input type="text" class="form-control" name="super_name" id="super_name" placeholder="" required="required">
            </div>
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>Email</label>
            <input type="email" class="form-control" pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$" name="super_email" id="super_email" placeholder="" required="required">
            </div>
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>Mobile</label>
            <input type="text" class="form-control" maxlength="15" name="super_mobile" id="super_mobile" placeholder="" required="required">
            </div>
		  </div>		  		  
        </div>
        <div class="modal-footer pad_box4">
          <div class="mtop10">
              <input type="hidden" id="add_super_user_id">
	          <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
	          <button type="submit" class="btn btn-success">Submit</button> 
          </div>
        </div>
        </form>
      </div>
    </div>
  </div>
<input type="hidden" id="ManageEstimateUpdateContactId"> 
<input type="hidden" id="ApprovalGrantedId"> 
	  <input type="hidden" id="ManageSalesCompAddress"> 
	<p id="end" style="display:none;"></p>
	</div>
	<div class="noDisplay"><a href="" id="DownloadExportedLink" download><button id="DownloadExported">Download</button></a></div>
	<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>	
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
$('.form_datetime').datepicker({
	format: 'dd-mm-yyyy',  
	startDate: '-0m'
}).on('changeDate', function(ev){
    $('#sDate1').text($('#datepicker').data('date'));
    $('#datepicker').datepicker('hide');
});
</script>
<script type="text/javascript">

function validatePayment(event){
	var pymtmode=document.getElementById("PaymentMode").value.trim();
	var pymtdate=document.getElementById("PaymentDate").value.trim();
	var pymttransid=document.getElementById("TransactionId").value.trim();
	
	var service_Name=$("#Service_Name").val();
	var professional_Fee=$("#Professional_Fee").val();
	var government_Fee=$("#Government_Fee").val();
	var service_Charges=$("#service_Charges").val();
	var other_Fee=$("#Other_Fee").val();
	var other_Fee_remark=$("#Other_Fee_remark").val();
	var remarks=$("#remarks").val();
	let serviceQty=$("#serviceQty").val();
	
	if(professional_Fee==null||professional_Fee=="")professional_Fee=0;
	if(government_Fee==null||government_Fee=="")government_Fee=0;
	if(service_Charges==null||service_Charges=="")service_Charges=0;
	if(other_Fee==null||other_Fee=="")other_Fee=0;	
	
	var txnAmount=Number(professional_Fee)+Number(government_Fee)+Number(other_Fee)+Number(service_Charges);
	
	if(pymtmode==null||pymtmode==""){
		document.getElementById('errorMsg').innerHTML ="Select Payment Mode !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(pymtdate==null||pymtdate==""){
		document.getElementById('errorMsg').innerHTML ="Select Payment Date !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}	
	if(pymtmode=="Online"){
		if(pymttransid==""){
			document.getElementById('errorMsg').innerHTML ="Enter Transaction Id !!.";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
	}else{
		$("#TransactionId").val("NA");
	}
	if(service_Name==null||service_Name==""){
		document.getElementById('errorMsg').innerHTML ="Enter Service Name !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(Number(txnAmount)<=0){
		document.getElementById('errorMsg').innerHTML ="Enter Service Amount (Professional or government or other fee) !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}	
	if(Number(other_Fee)>0&&(other_Fee_remark==null||other_Fee_remark=="")){
		document.getElementById('errorMsg').innerHTML ="Enter Other Fee Remarks !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(remarks==null||remarks==""){
		document.getElementById('errorMsg').innerHTML ="Enter remarks !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	
	if(serviceQty==null||serviceQty==""||serviceQty=="0"){
		document.getElementById('errorMsg').innerHTML ="Enter service quantity !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	
	var pymtamount=$("#TotalPaymentId").val();
		
       //stop submit the form, we will post it manually.
       event.preventDefault(); 
       var orderAmount=$("#SalesOrderAmountId").val();
       var salesno=$("#EstimateNoBoxId").val();
       showLoader();
      	$.ajax({
   		type : "POST",
   		url : "IsThisPaymentValid111",
   		dataType : "HTML",
   		data : {				
   			pymtamount : pymtamount,
   			orderAmount : orderAmount,
   			salesno : salesno,
   			pymtmode : pymtmode
   		},
   		success : function(response){
   		if(response=="pass"){
			       // Get form
			       var form = $('#UploadFormdata')[0];
				// Create an FormData object
			       var data = new FormData(form);
				   data.append("services",service_Name);
				   data.append("serviceQty",serviceQty);
				   // disabled the submit button
			       $("#btnSubmit").prop("disabled", true);
			       $.ajax({
			           type: "POST",
			           enctype: 'multipart/form-data',
			           url: "RegisterPaymentAccount111",
			           data: data,
			           processData: false,
			           contentType: false,
			           cache: false,
			           timeout: 600000,
			           success: function (data) {
			        	   if(data=="pass"){
			        		   $('#RegisterPayment').modal("hide");
				        	   $("#UploadFormdata").trigger('reset');               
				               $("#btnSubmit").prop("disabled", false);
				               document.getElementById('errorMsg1').innerHTML ="Successfully payment added.";	              
				       		   $('.alert-show1').show().delay(3000).fadeOut();
			        	   }else{
			        		   document.getElementById('errorMsg').innerHTML ="Something Went Wrong, Try-Again later.";
				       		   $('.alert-show').show().delay(4000).fadeOut();
			        	   }
			
			           },
			           error: function (e) {
			               console.log("ERROR : ", e);
			               $("#btnSubmit").prop("disabled", false);
			
			           }
			       });
	}else{
		document.getElementById('errorMsg').innerHTML ="You don't have permission to add more than sales amount.";
		$('.alert-show').show().delay(4000).fadeOut();
	}
	},
	complete : function(data){
		hideLoader();
	}
	});
    
}

function selectMode(value){
	if(value=="Cash"){
		$("#TransactionId").val("NA");
		$("#TransactionId").prop("readonly",true);
	}else{
		$("#TransactionId").val("");
		$("#TransactionId").prop("readonly",false);
	}
}
function showActionMenu(id){
	$('#'+id).addClass("show");
}
function hideActionMenu(id){
	$('#'+id).removeClass("show");
}
function isReload(ReloadId){
	var reload=$("#"+ReloadId).val();
	if(Number(reload)==1){
		location.reload(true);
	}
}
function fillPaymentDetails(invoiceno,rowid,clientrefid,contactrefid){
	 $(".pymentcnf").remove();
	//by invoice number get payment details to approve	
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetPaymentDetails111",
		dataType : "HTML",
		data : {				
			invoiceno : invoiceno
		},
		success : function(response){		
		if(Object.keys(response).length!=0){
		response = JSON.parse(response);			
		 var len = response.length;		 
		 if(len>0){
			 var path="<%=azure_path%>";
			 var billingDoAction="<%=billingDoAction%>";
			 for(var i=0;i<Number(len);i++){
		 	var refid=response[i]["refid"];
			var date=response[i]["date"];
			var mode=response[i]["mode"];
			var transactionid=response[i]["transactionid"];
			var amount=response[i]["amount"];
			var docname=response[i]["docname"];
			var docpath=response[i]["docpath"];
			var addedby=response[i]["addedby"];
			var remarks=response[i]["remarks"];
			var holdremarks=response[i]["holdremarks"];
			var service=response[i]["service"];
			var povalidity=response[i]["povalidity"];
			
			var financialYear=response[i]["financialYear"];
			var portalNumber=response[i]["portalNumber"];
			var piboCategory=response[i]["piboCategory"];
			var creditType=response[i]["creditType"];
			var productCategory=response[i]["productCategory"];
			var quantity=response[i]["quantity"];
			var comment=response[i]["comment"];
			
			var moreDetails="";
			if(financialYear!="NA"){
				moreDetails = '<div class="col-sm-12 col-md-12">'+
				'<div class="row">'+			
				'<div class="col-sm-2 more-details">'+
					'<label>Financial Year</label>'+
				    '<input value="'+financialYear+'" readonly>'+
				'</div>'+
				'<div class="col-sm-2 more-details">'+
				'<label>Portal Number</label>'+
			    '<input value="'+portalNumber+'" readonly>'+
				'</div>'+
				'<div class="col-sm-2 more-details">'+
				'<label>PIBO Category</label>'+
			    '<input value="'+piboCategory+'" readonly>'+
				'</div>'+
				'<div class="col-sm-2 more-details">'+
				'<label>Credit Type</label>'+
			    '<input value="'+creditType+'" readonly>'+
				'</div>'+
				'<div class="col-sm-2 more-details">'+
				'<label>Product Category</label>'+
				'<input value="'+productCategory+'" readonly>'+
				'</div>'+
				'<div class="col-sm-2 more-details">'+
				'<label>Quantity</label>'+
				'<input value='+quantity+'" readonly>'+
				'</div>'+
				'</div>'+
				'<div class="row">'+
				'<p>'+comment+'</p>'+
				'</div>'+
				'</div>';
			}
			
			if(Number(povalidity)===0)povalidity="";
			
			var ApproveBtnId="ApproveBtnId"+(i+1);
			var CnfPymtAmount="CnfPymtAmount"+(i+1);
			var TransactionId="TransactionId"+(i+1);
			var RowId="ApproveRowId"+(i+1);
			var DeclineBtnId="DeclineBtnId"+(i+1);
			var HoldBtnId="HoldBtnId"+(i+1);
			var holdbtn="";
			if(billingDoAction!="Hold")
			holdbtn='<p class="news-border pointers register-box" style="font-size: 10px;color: #42b7e4;" title="HOLD"><button class="btn-warning"id="'+HoldBtnId+'" onclick="holdPayment(\''+CnfPymtAmount+'\',\''+refid+'\',\''+invoiceno+'\',\''+RowId+'\',\''+addedby+'\',\''+i+'\',\''+date+'\')">Hold</button></p>';
			
			let amtval='<input type="text" id="'+CnfPymtAmount+'" class="form-control cnfpymt text-center" onchange="updateTransactionAmount(this.value,\''+refid+'\',\''+invoiceno+'\',\''+rowid+'\')" placeholder="Transaction amount.." value="'+amount+'" readonly="readonly">';
			if(mode=="PO")
				amtval='<input type="text" id="'+CnfPymtAmount+'" class="form-control cnfpymt text-center" onchange="updatePoNumberValidity(this.value,\''+refid+'\',\''+rowid+'\')" placeholder="PO Validity.." value="'+povalidity+'">';
			
			if(transactionid=="NA")transactionid="";
			$(''+
			'<div class="row pymentcnf" id="'+RowId+'">'+
			'<div class="clearfix bg_wht" style="border-bottom: 1px solid #ddd;border-top: 1px solid #ddd;">'+		
			'<div class="box-width7 col-xs-1 box-intro-background">'+
			'<div class="clearfix">'+
			'<p class="news-border">'+date+'</p>'+
			'</div>'+
			'</div>'+
			'<div class="box-width5 col-xs-1 box-intro-background">'+
			'<div class="clearfix bdr_lft"><p class="news-border register-box" title="">'+mode+'</p></div>'+
			'</div>'+
			'<div class="box-width17 col-xs-1 box-intro-background">'+
			'<p class="news-border register-box bdr_lft"><input type="text" class="form-control cnfpymt text-center" id="'+TransactionId+'" onchange="updateTransactionId(this.value,\''+refid+'\')" placeholder="Transaction Id.." value="'+transactionid+'" readonly="readonly"></p>'+
			'</div><div class="box-width7 col-xs-1 box-intro-background">'+			
			'<p class="news-border register-box text-center bdr_lft">'+amtval+'</p>'+			
			'</div>'+
			'<div class="box-width29 col-xs-1 box-intro-background flex_box bdr_lft" style="justify-content: center;">'+				
				'<p class="news-border pointers register-box" style="font-size: 16px;color: #42b7e4;">'+
				'<i class="fa fa-file-text-o" title="Open Payment Receipt." onclick="openReceipt(\''+path+'\',\''+docname+'\')"></i>&nbsp;&nbsp;&nbsp;'+
				'</p><input type="hidden" id="heading'+i+'" value="Service : '+service+' by '+addedby+'"><input type="hidden" id="remarks'+i+'" value="'+remarks+'"><input type="hidden" id="holdremarks'+i+'" value="'+holdremarks+'">'+
				'<p class="news-border pointers register-box" style="font-size: 10px;color: #42b7e4;" title="INVOICE">'+
				'<button class="btn-outline-success" onclick="openPaymentInvoice(\''+refid+'\')">Show</button>'+
				'</p>'+
				'<p class="news-border pointers register-box" style="font-size: 10px;color: #42b7e4;" title="APPROVE">'+
				'<button class="btn-success" id="'+ApproveBtnId+'" onclick="approvePayment(\''+CnfPymtAmount+'\',\''+refid+'\',\''+invoiceno+'\',\''+clientrefid+'\',\''+RowId+'\',\''+contactrefid+'\',\''+addedby+'\',\''+i+'\',\''+date+'\',\''+mode+'\')">Approve</button>'+
				'</p>'+
				holdbtn+
			'<p class="news-border pointers register-box" style="font-size: 10px;color: #42b7e4;" title="DECLINE">'+
				'<button class="btn-danger"id="'+DeclineBtnId+'" onclick="declinePayment(\''+CnfPymtAmount+'\',\''+refid+'\',\''+invoiceno+'\',\''+RowId+'\',\''+addedby+'\',\''+i+'\',\''+date+'\')">Decline</button>'+
				'</p>'+
			'</div>'+
			'</div>'+
			moreDetails+
			'</div>'		
			).insertBefore("#PymtCnfId");			
			 }			
		 }}
		},
		complete : function(data){
			hideLoader();
		}
	});
	$("#MarkPayment").modal('show');
}

function updatePoNumberValidity(value,refid,rowid){
	if(Number(value)>0){
		showLoader();
		$.ajax({
		    type: "POST",
		    url: "<%=request.getContextPath()%>/updatePoNumberValidity111",
		    data:  { 
		    	value : value,
		    	refid : refid
		    },
		    success: function (response) {
	        	if(response=="pass"){
	        		document.getElementById('errorMsg1').innerHTML = 'Updated.';
	        		$('.alert-show1').show().delay(1000).fadeOut();
	        	}else{
	        		document.getElementById('errorMsg').innerHTML = 'Something Went Wrong , Try-Again Later.';
	        		$('.alert-show').show().delay(3000).fadeOut();
	        	}
	        },
			complete : function(data){
				hideLoader();
			}
		});}else{
			document.getElementById('errorMsg').innerHTML = 'Validity must be greater than zero.';
			$('.alert-show').show().delay(3000).fadeOut();
		}
}

function updateTransactionAmount(value,refid,invoiceno,rowid){
	if(Number(value)>0){
	showLoader();
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/updateTransactionAmount111",
	    data:  { 
	    	value : value,
	    	refid : refid,
	    	invoiceno : invoiceno
	    },
	    success: function (response) {
        	if(response=="pass"){
        		document.getElementById('errorMsg1').innerHTML = 'Updated.';
        		$("#"+rowid).load("manage-billing.html #"+rowid);
        		$('.alert-show1').show().delay(1000).fadeOut();
        	}else{
        		document.getElementById('errorMsg').innerHTML = 'Something Went Wrong , Try-Again Later.';
        		$('.alert-show').show().delay(3000).fadeOut();
        	}
        },
		complete : function(data){
			hideLoader();
		}
	});}else{
		document.getElementById('errorMsg').innerHTML = 'Amount must be greater than zero.';
		$('.alert-show').show().delay(3000).fadeOut();
	}
}
function updateTransactionId(value,refid){
	showLoader();
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/updateTransactionStatus111",
	    data:  { 
	    	value : value,
	    	refid : refid
	    },
	    success: function (response) {
        	if(response=="pass"){
        		document.getElementById('errorMsg1').innerHTML = 'Updated.';
        		$('.alert-show1').show().delay(1000).fadeOut();
        	}else{
        		document.getElementById('errorMsg').innerHTML = 'Something Went Wrong , Try-Again Later.';
        		$('.alert-show').show().delay(3000).fadeOut();
        	}
        },
		complete : function(data){
			hideLoader();
		}
	});
}

function holdSalesPayment(RefBoxId,InvoiceBoxId,RowBoxId){
	var comment=$("#paymentCnfCommentHold").val();
	if(comment!=null&&comment!=""){
	showLoader();
	var refid=$("#HoldPaymentRefid").val().trim();
	var invoiceno=$("#HoldSalesInvoiceid").val().trim();
	var rowId=$("#HoldSalesInvoiceRowid").val().trim();
	showLoader();
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/HoldSalePayment111",
	    data:  { 
	    	refid : refid,
	    	invoiceno : invoiceno,
	    	comment : comment
	    },
	    success: function (response) {
	    	$("#ApprovalGrantedId").val("1");
        	$("#"+rowId).remove();
        },
		complete : function(data){
			hideLoader();
		}
	});
	}else{
		document.getElementById('errorMsg').innerHTML ='Please add comment !!';				
		$('.alert-show').show().delay(4000).fadeOut();
		 return false;
	}
}

function declineSalesPayment(RefBoxId,InvoiceBoxId,RowBoxId){
	var comment=$("#paymentCnfCommentDecline").val();
	if(comment!=null&&comment!=""){
	showLoader();
	var refid=$("#DeclinePaymentRefid").val().trim();
	var invoiceno=$("#DeclineSalesInvoiceid").val().trim();
	var rowId=$("#DeclineSalesInvoiceRowid").val().trim();
	showLoader();
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/DeclineSalePayment111",
	    data:  { 
	    	refid : refid,
	    	invoiceno : invoiceno,
	    	comment : comment
	    },
	    success: function (response) {
	    	$("#ApprovalGrantedId").val("1");
        	$("#"+rowId).remove();
        },
		complete : function(data){
			hideLoader();
		}
	});
	}else{
		document.getElementById('errorMsg').innerHTML ='Please add comment !!';				
		$('.alert-show').show().delay(4000).fadeOut();
		 return false;
	}
}

function approveSalesPayment(){
	var comment=$("#paymentCnfComment").val();
	if(comment!=null&&comment!=""){
	showLoader();
	
	var refid=$("#PaymentRefid").val().trim();
	var invoiceno=$("#SalesInvoiceid").val().trim();
	var clientrefid=$("#SalesInvoiceClientRefid").val().trim();
	var contactrefid=$("#SalesInvoiceContactRefid").val().trim();
	var rowId=$("#SalesInvoiceRowid").val().trim();
	
	$("#warningApprove").modal("hide");
	showLoader();
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/ApproveSalePayment111",
	    data:  { 
	    	refid : refid,
	    	invoiceno : invoiceno,
	    	clientrefid : clientrefid,
	    	contactrefid : contactrefid,
	    	comment : comment
	    },
	    success: function (response) {
	    	$("#ApprovalGrantedId").val("1");
        	$("#"+rowId).remove();
        },
		complete : function(data){
			hideLoader();
		}
	});
	}else{
		document.getElementById('errorMsg').innerHTML ='Please add comment !!';				
		$('.alert-show').show().delay(4000).fadeOut();
		 return false;
	}
}
		
function holdPayment(amountid,refid,invoiceno,rowid,addedby,i,date){
	var amount=$("#"+amountid).val(); 
	$("#HoldPaymentRefid").val(refid);
	$("#HoldSalesInvoiceid").val(invoiceno);	
	$("#HoldSalesInvoiceRowid").val(rowid);
	
	var service=$("#heading"+i).val();
	var remarks=$("#remarks"+i).val();
	$("#paymentRemarksHold").html('<div class="box_shadow1 relative_box mb10"><div class="sms_head note_box">'+
			'<p>'+service+'<br><b>Comment : </b>'+remarks+'</p></div>'+
					'<div class="sms_title">'+ 
					'<label class="pad-rt10"></label>'+  
					'<span class="gray_txt bdr_bt pad-rt10" style="float: right;">'+date+'</span>'+
					'</div></div>');
	
	$("#warningHold").modal("show");
	
}
		
function declinePayment(amountid,refid,invoiceno,rowid,addedby,i,date){
	var amount=$("#"+amountid).val(); 
	$("#DeclinePaymentRefid").val(refid);
	$("#DeclineSalesInvoiceid").val(invoiceno);	
	$("#DeclineSalesInvoiceRowid").val(rowid);
	
	var service=$("#heading"+i).val();
	var remarks=$("#remarks"+i).val();
	var billingDoAction="<%=billingDoAction%>";
	var holdremarks="";
	var holdText="";
	if(billingDoAction=="Hold")
		holdText='<div class="box_shadow1 relative_box mb10"><div class="sms_head note_box"><p><b>Comment : </b>'+$("#holdremarks"+i).val()+'</p></div><div class="sms_title">'+ 
		'<label class="pad-rt10"></label>'+  
		'<span class="gray_txt bdr_bt pad-rt10" style="float: right;">On-Hold  &nbsp;'+date+'</span>'+
		'</div>';
	
	$("#paymentRemarksDecline").html('<div class="box_shadow1 relative_box mb10"><div class="sms_head note_box">'+
			'<p>'+service+'<br><b>Comment : </b>'+remarks+'</p></div>'+
					'<div class="sms_title">'+ 
					'<label class="pad-rt10"></label>'+  
					'<span class="gray_txt bdr_bt pad-rt10" style="float: right;">'+date+'</span>'+
					'</div></div>'+
					holdText+
					'</div>');
	
	$("#warningDecline").modal("show");
	
}

function approvePayment(amountid,refid,invoiceno,clientrefid,rowid,contactrefid,addedby,i,date,mode){
	var amount=$("#"+amountid).val(); 
	if(mode=="PO"&&(amount==null||amount=="")){
		document.getElementById('errorMsg').innerHTML ='Please enter Purchase Order Validity !!';				
		 $('.alert-show').show().delay(4000).fadeOut();
		 return false;
	}
	
	$("#PaymentRefid").val(refid);
	$("#SalesInvoiceid").val(invoiceno);
	$("#SalesInvoiceClientRefid").val(clientrefid);
	$("#SalesInvoiceContactRefid").val(contactrefid);
	$("#SalesInvoiceRowid").val(rowid);
	var service=$("#heading"+i).val();
	var remarks=$("#remarks"+i).val();
	var billingDoAction="<%=billingDoAction%>";	
	var holdremarks="";
	var holdText="";
	if(billingDoAction=="Hold")
		holdText='<div class="box_shadow1 relative_box mb10"><div class="sms_head note_box"><p><b>Comment : </b>'+$("#holdremarks"+i).val()+'</p></div><div class="sms_title">'+ 
		'<label class="pad-rt10"></label>'+  
		'<span class="gray_txt bdr_bt pad-rt10" style="float: right;">On-Hold &nbsp;'+date+'</span>'+
		'</div>';
		
	
	$("#paymentRemarks").html('<div class="box_shadow1 relative_box mb10"><div class="sms_head note_box">'+
			'<p>'+service+'<br><b>Comment : </b>'+remarks+'</p></div>'+
					'<div class="sms_title">'+ 
					'<label class="pad-rt10"></label>'+  
					'<span class="gray_txt bdr_bt pad-rt10" style="float: right;">'+date+'</span>'+
					'</div></div>'+
					holdText+
					'</div>');
	
	if(Number(amount)<=0&&mode!="PO"){
		$("#warningAmount").modal("show");
	}else{
		$.ajax({
		    type: "GET",
		    url: "<%=request.getContextPath()%>/GetMinSalePay111",
		    data:  { 
		    	refid : refid,
		    	amount : amount
		    },
		    success: function (response) {
// 		    	console.log(response);
		    	if(Number(response)>0){
		    		$(".modal-warning").show();
		    		$("#warningPayment").html("Warning :- Minimum payment required is Rs. "+response+", Please re-confirm before proceeding.");
		    	}else
		    		$(".modal-warning").hide();
	        },
			complete : function(data){
				$("#warningApprove").modal("show");
			}
		});
	}
	
}
function fillHeading(estimateno,invoiceno,clientrefid,contactrefid,dueAmount,orderAmount){
	if(invoiceno==null||invoiceno==""||invoiceno.toLowerCase()=="na"){
	$('#RegisterPaymentOfInvoice').html(estimateno);}else{
		$('#RegisterPaymentOfInvoice').html(invoiceno)
	}
	$("#BillingRegisterPayment").val(dueAmount);
	$("#EstimateNoBoxId").val(estimateno);
	$("#SalesOrderAmountId").val(orderAmount);
	$("#InvoiceNoBoxId").val(invoiceno);
	$("#ClientRefIdBoxId").val(clientrefid);
	$("#ContactRefIdBoxId").val(contactrefid);
	$("#UploadFormdata").trigger("reset");
	$('#RegisterPayment').modal("show");
	getOrderAndDueAmount(estimateno);
	setTotalSalesService(estimateno);
	 
}
function  getOrderAndDueAmount(estimateno){
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetOrderAndDueAmount111",
		dataType : "HTML",
		data : {				
			estimateno : estimateno
		},
		success : function(response){		
		var x=response.split("#"); 
		$("#TotalOrderAmountId").html(Number(x[0]).toFixed(2));
		$("#TotalDueAmountId").html(Number(x[1]).toFixed(2));	

		var pffcgst=Number(x[2]);
		var pffsgst=Number(x[3]);
		var pffigst=Number(x[4]);
		var pfftax=pffcgst+pffsgst+pffigst;		
		
		$("#ProfessionalCgst").val(pffcgst);
		$("#ProfessionalSgst").val(pffsgst);
		$("#ProfessionalIgst").val(pffigst);
		
		var govcgst=Number(x[5]);
		var govsgst=Number(x[6]);
		var govigst=Number(x[7]);
		var govtax=govcgst+govsgst+govigst;
		
		$("#GovernmentCgst").val(govcgst);
		$("#GovernmentSgst").val(govsgst);
		$("#GovernmentIgst").val(govigst);
		
		var othercgst=Number(x[8]);
		var othersgst=Number(x[9]);
		var otherigst=Number(x[10]);
		var otrtax=othercgst+othersgst+otherigst;
		
		$("#OtherCgst").val(othercgst);
		$("#OtherSgst").val(othersgst);
		$("#OtherIgst").val(otherigst);
		
		var servicecgst=Number(x[11]);
		var servicesgst=Number(x[12]);
		var serviceigst=Number(x[13]);
		var servicetax=servicecgst+servicesgst+serviceigst;
		
		$("#ServiceChargeCgst").val(servicecgst);
		$("#ServiceChargeSgst").val(servicesgst);
		$("#ServiceChargeIgst").val(serviceigst);
		
		$("#ProfessionalFeeTax").val(pfftax);
		$("#GovernmentFeeTax").val(govtax);
		$("#ServiceChargeTax").val(servicetax);
		$("#OtherFeeTax").val(otrtax);
		
		$("#Professional_Fee_GST").html(pfftax+"%");
		$("#Government_Fee_GST").html(govtax+"%");
		$("#service_Charges_GST").html(servicetax+"%");
		$("#Other_Fee_GST").html(otrtax+"%");
		
		},
		complete : function(data){
			hideLoader();
		}
	});
}

	$(function() {
		$("#ClientName").autocomplete({
			source : function(request, response) {
				if(document.getElementById('ClientName').value.trim().length>=1)
				$.ajax({
					url : "getclientname.html",
					type : "POST",
					dataType : "JSON",
					data : {
						name : request.term,
						col :"cregname"
					},
					success : function(data) {
						response($.map(data, function(item) {
							return {  
								label : item.name,
								value : item.value,					
							};
						}));
					},
					error : function(error) {
						alert('error: ' + error.responseText);
					}
				});
			},
			select: function (event, ui) {
	            if(!ui.item){ 
	            	      	
	            }
	            else{
	            	doAction(ui.item.value,"billingClientName");
	            	location.reload(true);
	            	
	            }
	        },
	        error : function(error){
				alert('error: ' + error.responseText);
			},
		});
	});
	</script>

<script type="text/javascript">
function showAllContact(event,id1,id2){
	event.stopPropagation();
	 	$('.name_action_box').removeClass("active");
	 	$('.dropdown_list').removeClass("show");
	 	$('#'+id1).addClass("active");
	 	$('#'+id2).addClass("show");
	
}
function minusAllContact(event){
	event.stopPropagation();
	$('.name_action_box').removeClass("active");
	$('.dropdown_list').removeClass("show");
} 

function openPaymentHistory(invoiceno,estimateno,orderamount,dueamount){
	$(".ApprovedPayment").remove();
	$("#PayHistoryInvoice").html(invoiceno);
	$("#TotalOrderAmountId").html(Number(orderamount).toFixed(2));
	$("#TotalDueAmountId").html(Number(dueamount).toFixed(2));
	getPayType(estimateno);
	fillPaymentHistory(invoiceno);
	var id = $(".historybox").attr('data-related'); 
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });	
}

function openContactBox(contctref,cboxid,boxid,clientkey){	
	$('#FormUpdateContactBox').trigger("reset");
	$("#UpdateContactClientKey").val(clientkey);
	fillContactUpdateForm(contctref,cboxid);
	$("#ManageEstimateUpdateContactId").val(boxid);
	var id = $(".contactbox").attr('data-related'); 
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });	
}
function fillPaymentHistory(invoice){
	$.ajax({
		type : "POST",
		url : "GetApprovedPayment111",
		dataType : "HTML",
		data : {				
			invoice : invoice
		},
		success : function(response){		
			if(Object.keys(response).length!=0){
		response = JSON.parse(response);			
		 var len = response.length;		 
		 if(len>0){	
			 var home="<%=azure_path%>";
			 for(var i=0;i<len;i++){
				 var prefid=response[i]["prefid"];
					var date=response[i]["date"];
					var approvedate=response[i]["approvedate"];
					var approveby=response[i]["approveby"];
					var paymode=response[i]["paymode"];
					var transactionid=response[i]["transactionid"];
					var transacamount=response[i]["transacamount"];
					var docname=response[i]["docname"];
					var transtatus=response[i]["transtatus"];
					var color="#29ba29";
					var title="Approved";
					var icon="fa fa-check-circle-o";
					if(transtatus=="3"){
						color="#d91f16";
						title="Declined";
					}else if(transtatus=="4"){
						icon="fa fa-stop-circle";
						color="#808080";
						title="On-Hold";
					}
					
			 $(''+
					 '<div class="clearfix bg_wht ApprovedPayment">'+
			 '<div class="box-width25 col-xs-1 box-intro-background">'+
			 '<div class="clearfix">'+
			 '<p class="news-border '+icon+'" style="font-size: 20px;color: '+color+';" title="'+title+'"></p>'+
			 '</div></div>'+
			 '<div class="box-width7 col-xs-1 box-intro-background">'+
			 '<div class="clearfix">'+
			 '<p class="news-border">'+date+'</p>'+
			 '</div></div>'+			 
			 '<div class="box-width3 col-xs-1 box-intro-background">'+
			 '<div class="clearfix"><p class="news-border" title="">'+paymode+'</p></div></div>'+
			 '<div class="box-width26 col-xs-1 box-intro-background">'+
			 '<div class="clearfix"><p class="news-border" title="">'+transactionid+'</p></div></div>'+
			 '<div class="box-width3 col-xs-1 box-intro-background">'+
			 '<div class="clearfix"><p class="news-border fa fa-inr" title="">&nbsp;'+transacamount+'</p></div></div>'+
			 '<div class="box-width11 col-xs-1 box-intro-background">'+
			 '<div class="clearfix">'+
			 '<p class="news-border" title="" fee="">'+approveby+'</p>'+
			 '</div></div>'+
			 '<div class="box-width24 col-xs-1 box-intro-background">'+
			 '<div class="clearfix">'+
			 '<p class="news-border fa fa-file-text-o pointers" style="font-size: 16px;color: #42b7e4;" onclick="openReceipt(\''+home+'\',\''+docname+'\')"></p></div></div>'+
			 '</div>'
			 ).insertBefore("#ApprovedPaymentListId");
			 }
		 }
		 }else{
			 $(''+
					 '<div class="clearfix bg_wht ApprovedPayment">'+
					 '<div class="col-md-12 col-xs-1 box-intro-background">'+
					 '<div class="clearfix">'+
					 '<p class="news-border">No Data Found</p>'+
					 '</div></div>'+							
					 '</div>').insertBefore("#ApprovedPaymentListId");
		 }},
			complete : function(data){
				hideLoader();
			}
		});
}
function openReceipt(mainfolder,docname){
	if(docname.toLowerCase()=="na"){
		$("#warningDocument").modal("show");
	}else{	window.open(mainfolder+docname);}
}

function fillContactUpdateForm(key,cboxid){
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetContactByRefid111",
		dataType : "HTML",
		data : {				
			key : key
		},
		success : function(response){		
			if(Object.keys(response).length!=0){
		response = JSON.parse(response);			
		 var len = response.length;		 
		 if(len>0){
		 	var contkey=response[0]["key"];
			var firstname=response[0]["firstname"];
			var lastname=response[0]["lastname"];
			var email1=response[0]["email1"];
			var email2=response[0]["email2"];
			var workphone=response[0]["workphone"];
			var mobilephone=response[0]["mobilephone"];
			var addresstype=response[0]["addresstype"];
			var city=response[0]["city"];
			var state=response[0]["state"];
			var address=response[0]["address"];
			var pan=response[0]["pan"];
			var country=response[0]["country"];
			var stateCode=response[0]["stateCode"];
			
			$("#UpdateContactKey").val(contkey);
			$("#UpdateContactSalesKey").val(cboxid);
			$("#UpdateContactFirstName").val(firstname);$("#UpdateContactLastName").val(lastname);$("#UpdateContactEmail_Id").val(email1);
			if(email2!=="NA"){
				$("#UpdateContactEmailId2").val(email2);
				document.getElementById("UpdateContactDivId").style.display="block";
			}			
			$("#UpdateContactWorkPhone").val(workphone);$("#UpdateContactMobilePhone").val(mobilephone);
			$("#UpdateContPan").val(pan);
			if(addresstype=="Personal"){
				$("#UpdateContCountry").val(country);
				$("#UpdateContCity").empty();
				$("#UpdateContCity").append("<option value='"+city+"'>"+city+"</option>");
				$("#UpdateContState").empty();
				$("#UpdateContState").append("<option value='0#"+stateCode+"#"+state+"'>"+state+"</option>");				
				$("#UpdateContAddress").val(address);	
				$("#UpdateContactperAddress").attr('checked',true);
				$("#UpdateContactcomAddress").attr('checked',false);
				$(".UpdateAddress_box").show();
				$(".UpdateCompany_box").hide();
			}else{
				$("#UpdateContactcomAddress").attr('checked',true);
				$("#UpdateContactperAddress").attr('checked',false);
				$("#UpdateEnqCompAddress").val(address);
				$(".UpdateAddress_box").hide();
				$(".UpdateCompany_box").show();
			}			
		 }
		}else{
			document.getElementById('errorMsg').innerHTML ='Something went-wrong ,please try-again later !!';				
			 $('.alert-show').show().delay(4000).fadeOut();
		}},
		complete : function(data){
			hideLoader();
		}
	});
}

</script>

<script type="text/javascript">
$('.list_action_box').hover(function(){
	$(this).children().next().toggleClass("show");
}); 
$('#ContactcomAddress').on( "click", function(e) {
$('.address_box').hide();
$('.company_box').show();	
});
$('#UpdateContactcomAddress').on( "click", function(e) {
$('.UpdateAddress_box').hide();
$('.UpdateCompany_box').show();	
});
$('#UpdateContactperAddress').on( "click", function(e) {
$('.UpdateAddress_box').show();
$('.UpdateCompany_box').hide();	
});
$('#ContactperAddress').on( "click", function(e) {
$('.address_box').show();
$('.company_box').hide();	
});
</script>
<script type="text/javascript">
$('.close_icon_btn').click(function(){
	$('.notify_box').hide();
});
$('.add_new').on( "click", function(e) {
	$(this).parent().next().show();	
	});
$('.del_icon').on( "click", function(e) {
	$('.new_field').hide();	
	});	
$('.close_box').on( "click", function(e) { 
	$('.fixed_right_box').removeClass('active');
	$('.addnew').show();	
	});
</script>
<script type="text/javascript">
$( document ).ready(function() {
	   var dateRangeDoAction="<%=billingDateRangeAction%>";
	   if(dateRangeDoAction!="NA"){	  
		   $('input[name="date_range"]').val(dateRangeDoAction);
	   }
	});

$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var data=$(this).val();
	doAction(data,"billingDateRangeAction");
	location.reload();
});

$('input[name="date_range"]').daterangepicker({
	  autoUpdateInput: false,
	  autoApply: true,
	  showDropdowns: true,
	}, function(start_date, end_date) {
	  $('input[name="date_range"]').val(start_date.format('DD-MM-YYYY')+' - '+end_date.format('DD-MM-YYYY'));
	});


function doAction(data,name){
	showLoader();
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/SetDataToSession111",
	    data:  { 
	    	data : data,
	    	name : name
	    },
	    success: function (response) {
        },
		complete : function(data){
			hideLoader();
		}
	});
}
function clearSession(data){
	showLoader();   
	$.ajax({
		    type: "POST",
		    url: "<%=request.getContextPath()%>/ClearSessionData111",
		    data:  { 		    	
		    	data : data
		    },
		    success: function (response) {		    	
	        },
			complete : function(data){
				hideLoader();
			}
		});
}
$(function() {
	$("#InvoiceNo").autocomplete({
		source : function(request, response) {			
			if(document.getElementById('InvoiceNo').value.trim().length>=1)
			$.ajax({
				url : "get-client-details.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					"field" : "billingInvoiceNo"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value
						};
					}));
				},
				error : function(error) {
					alert('error: ' + error.responseText);
				}
			});
		},
		select: function (event, ui) {
			if(!ui.item){   
            	
            }
            else{
            	doAction(ui.item.value,'billingInvoiceNo');
            	location.reload();
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});
function isValidAmount(){
	var dueAmt=$("#BillingRegisterPayment").val();
	var tranAmt=$("#TransactionAmount").val();
	if(Number(tranAmt)>Number(dueAmt)){
		$("#TransactionAmount").val('');
		document.getElementById('errorMsg').innerHTML ="Maximum amount should be  "+dueAmt;
		$('.alert-show').show().delay(4000).fadeOut();
	}
	
}

$("#Protected").click(function(){
	 if ($("#Protected").is(":checked")){
		 $("#FilePassword").val("");
		 $("#FilePassword").show();		 
}else{
	 $("#FilePassword").hide();
	 $("#FilePassword").val("NA");    	 
}
});
$(function(){$(".searchdate").datepicker({changeMonth:true,changeYear:true,dateFormat:'yy-mm-dd'});});
$(document).ready(function(){
	$('#ExportColumn').select2({
		  placeholder: 'Select columns..',
		  allowClear: true,
		  dropdownParent: $("#ExportData")
		});
	$('#Update_Super_User').select2({
        placeholder: 'Select Super User',
        allowClear: true
    });
});

function validateExport(){
	var from=$("#From-Date").val();
	var to=$("#To-Date").val();
	var columns=$("#ExportColumn").val();
	var formate=$("#File-Formate").val();	
	var filePassword=$("#FilePassword").val();
		
	if(from==null||from==""){
		document.getElementById('errorMsg').innerHTML ='Select from-date !!';					
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(to==null||to==""){
		document.getElementById('errorMsg').innerHTML ='Select to-date !!';					
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(columns==null||columns==""){
		document.getElementById('errorMsg').innerHTML ='Select columns for export !!';					
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(formate==null||formate==""){
		document.getElementById('errorMsg').innerHTML ='Choose formate option !!';					
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if ($("#Protected").is(":checked")){
		if(filePassword==null||filePassword==""){
			document.getElementById('errorMsg').innerHTML ='Please enter export file password !!';					
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		$("#Protected").val("1")
	}else{
		$("#Protected").val("2")
		$("#FilePassword").val("NA");
	}
	var baseName="<%=azure_path%>";
	columns+="";
	showLoader();
	$.ajax({
		type : "POST",
		url : "ExportData111",
		dataType : "HTML",
		data : {				
			from : from,
			to : to,
			columns : columns,
			formate : formate,
			filePassword : filePassword,
			type : "Billing"
		},
		success : function(response){
			$("#ExportData").modal("hide");
			if(response=="Fail"){
				document.getElementById('errorMsg').innerHTML ='No. Data Found !!';					
				$('.alert-show').show().delay(4000).fadeOut();
			}else{ 
				setTimeout(() => {
					$("#DownloadExportedLink").attr("href", baseName+response);
					$("#DownloadExported").click();
				}, 500);
			}
		},
		complete : function(data){
			hideLoader();
		}
	});	
	
}
if($(window).width() < 768) {
	jQuery(".icoo").click(function () {
		$('.dropdown_list').removeClass("show");
	  var display = jQuery(this).next(".dropdown_list").css("display");
	  if (display == "none") {
		jQuery(".fa-angle-up ").css("display","none");
	    jQuery(".dropdown_list").removeClass("active");
	    jQuery(".dropdown_list").slideUp("fast");
	    jQuery(this).next(".dropdown_list").slideDown("fast");
	    jQuery(this).addClass("active");
	 jQuery(".fa-angle-down ").css("display","block");

	  } else {
		 jQuery(".fa-angle-up ").css("display","none");
	    jQuery(this).next(".dropdown_list").slideUp("fast");
	    jQuery(this).removeClass("active");
	jQuery(".fa-angle-down ").css("display","block");


	  }
	});
	}

	$('.list_icon').hover(function(){
		$(this).children().next().toggleClass("show");
	});
	$('body').click(function(){

		$('.dropdown_list ').removeClass('show');

	});
	$("#GSTApplyId").click(function(){
		if($(this).prop('checked') == true){		
			$("#Professional_Fee_GST").html($("#ProfessionalFeeTax").val()+"%");
			$("#Government_Fee_GST").html($("#GovernmentFeeTax").val()+"%");
			$("#Other_Fee_GST").html($("#OtherFeeTax").val()+"%");
			$("#GSTApplied").val("1");
		}else{
			$("#Professional_Fee_GST").html("0%");
			$("#Government_Fee_GST").html("0%");
			$("#Other_Fee_GST").html("0%");
			$("#GSTApplied").val("0");
		}
		calculateTotalPayment();
	});	
	function calculateTotalPayment(){
		var pff=$("#Professional_Fee").val();
		var gov=$("#Government_Fee").val();
		var service=$("#service_Charges").val();
		var other=$("#Other_Fee").val();
			
		if($("#GSTApplyId").prop('checked') == true){
			var pfftax=$("#ProfessionalFeeTax").val();
			var govtax=$("#GovernmentFeeTax").val();
			var servicetax=$("#ServiceChargeTax").val();
			var othertax=$("#OtherFeeTax").val();
			
			pff=Number(pff)+((Number(pff)*Number(pfftax))/100);
			gov=Number(gov)+((Number(gov)*Number(govtax))/100);
			service=Number(service)+((Number(service)*Number(servicetax))/100);
			other=Number(other)+((Number(other)*Number(othertax))/100);		
		}
		
		var totalAmount=Number(pff)+Number(gov)+Number(other)+Number(service);
		
		$("#TotalPaymentId").val(Math.round(Number(totalAmount)));
	}
	function showRemark(){
		var otherFee=$("#Other_Fee").val();
		if(otherFee!=null&&otherFee!=""&&Number(otherFee)>0){
			$("#Other_Fee_remark_Div").show();
		}else $("#Other_Fee_remark_Div").hide();
	}
	function updateState(data,stateId){
		var x=data.split("#");
		var id=x[0];
		showLoader();
		$.ajax({
			type : "POST",
			url : "GetStateCity111",
			dataType : "HTML",
			data : {				
				id : id,
				fetch : "state"
			},
			success : function(response){	
				$("#"+stateId).empty();
				$("#"+stateId).append(response);	
			},
			complete : function(data){
				hideLoader();
			}
		});
	}
	function updateCity(data,cityId){
		var x=data.split("#");
		var id=x[0];
		showLoader();
		$.ajax({
			type : "POST",
			url : "GetStateCity111",
			dataType : "HTML",
			data : {				
				id : id,
				fetch : "city"
			},
			success : function(response){	
				$("#"+cityId).empty();
				$("#"+cityId).append(response);	
			},
			complete : function(data){
				hideLoader();
			}
		});
	}
	function isExistEditPan(valueid){
		var val=document.getElementById(valueid).value.trim();
		var key=$("#UpdateContactKey").val();
		if(val!=""&&val!="NA"&&key!=""&&key!="NA")
		$.ajax({
			type : "POST",
			url : "ExistEditValue111",
			dataType : "HTML",
			data : {"val":val,"field":"isEditPanContact","id":key},
			success : function(data){
				if(data=="pass"){
				document.getElementById("errorMsg").innerHTML=val +" is already existed.";
				document.getElementById(valueid).value="";
				$('.alert-show').show().delay(4000).fadeOut();
				}
				
			}
		});
	}
	function isExistEditCompanyPan(valueid){
		var val=document.getElementById(valueid).value.trim();
		var key=$("#UpdateCompanyKey").val().trim();
		if(val!=""&&val!="NA"&&key!=""&&key!="NA")
		$.ajax({
			type : "POST",
			url : "ExistEditValue111",
			dataType : "HTML",
			data : {"val":val,"field":"isEditPan","id":key},
			success : function(data){
				if(data=="pass"){
				document.getElementById("errorMsg").innerHTML=val +" is already existed.";
				document.getElementById(valueid).value="";
				$('.alert-show').show().delay(4000).fadeOut();
				}
				
			}
		});
	}
	function getUpdateCompanyAddress(){
		var clientKey=$("#UpdateContactClientKey").val();
		showLoader();
		$.ajax({
			type : "POST",
			url : "GetCompanyAddress111",
			dataType : "HTML",
			data : {				
				clientKey : clientKey
			},
			success : function(response){	
				$("#UpdateEnqCompAddress").val(response);	
			},
			complete : function(data){
				hideLoader();
			}
		});
		
	}
	function validateUpdateContact(){

		if($("#UpdateContactFirstName").val()==null||$("#UpdateContactFirstName").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="First name is mandatory.";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#UpdateContactLastName").val()==null||$("#UpdateContactLastName").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Last name is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#UpdateContactEmail_Id").val()==null||$("#UpdateContactEmail_Id").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Email is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#UpdateContactEmailId2").val()==null||$("#UpdateContactEmailId2").val().trim()==""){
			$("#UpdateContactEmailId2").val("NA");
		}
		if($("#UpdateContPan").val()==null||$("#UpdateContPan").val().trim()==""){
			$("#UpdateContPan").val("NA");
		}
		if($("#UpdateContactWorkPhone").val()==null||$("#UpdateContactWorkPhone").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Work phone is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#UpdateContactMobilePhone").val()==null||$("#UpdateContactMobilePhone").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Mobile number is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		
		if($('#UpdateContactperAddress').prop('checked')){
			if($("#UpdateContCountry").val()==null||$("#UpdateContCountry").val().trim()==""){
				document.getElementById('errorMsg').innerHTML ="Country is mandatory";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
			}
			if($("#UpdateContCity").val()==null||$("#UpdateContCity").val().trim()==""){
				document.getElementById('errorMsg').innerHTML ="City is mandatory";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
			}
			if($("#UpdateContState").val()==null||$("#UpdateContState").val().trim()==""){
				document.getElementById('errorMsg').innerHTML ="State is mandatory";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
			}
			if($("#UpdateContAddress").val()==null||$("#UpdateContAddress").val().trim()==""){
				document.getElementById('errorMsg').innerHTML ="Address is mandatory";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
			}
		}
		var firstname=$("#UpdateContactFirstName").val().trim();
		var lastname=$("#UpdateContactLastName").val().trim();
		var email=$("#UpdateContactEmail_Id").val().trim();
		var email2=$("#UpdateContactEmailId2").val().trim();
		var workphone=$("#UpdateContactWorkPhone").val().trim();
		var mobile=$("#UpdateContactMobilePhone").val().trim();
		var pan=$("#UpdateContPan").val().trim();
		var country="NA";
	    var city="NA";
	    var state="NA";
	    var stateCode="NA";
	    var address="NA";
	    var companyaddress="NA";
	    var addresstype="Personal";
	    if($('#UpdateContactperAddress').prop('checked')){
	    	country=$("#UpdateContCountry").val();
	    	var x=country.split("#");
	    	country=x[1];
	    	state=$("#UpdateContState").val();
	    	x=state.split("#");
	    	stateCode=x[1];
	    	state=x[2];
	    	city=$("#UpdateContCity").val();
	    	
	    	address=$("#UpdateContAddress").val().trim();    	
	    }
	    if($('#UpdateContactcomAddress').prop('checked')){
			companyaddress=$("#UpdateEnqCompAddress").val().trim();
			addresstype="Company";
	    }
	   var contkey=$("#UpdateContactKey").val().trim(); 
	   var contid=$("#OpenContactId").val();
	   var salesid=$("#SalesId").val();

	showLoader();
		$.ajax({
			type : "POST",
			url : "UpdateContactDetails111",
			dataType : "HTML",
			data : {				
				firstname : firstname,
				lastname : lastname,
				email : email,
				email2 : email2,
				workphone : workphone,
				mobile : mobile,
				city : city,
				state : state,
				address : address,
				companyaddress : companyaddress,
				addresstype : addresstype,
				contkey : contkey,
				contid:contid,
				salesid:salesid,
				pan : pan,
				country : country,
				stateCode : stateCode
			},
			success : function(data){
				if(data=="pass"){
					document.getElementById('errorMsg1').innerHTML = 'Successfully Updated !!';				  
					$('.alert-show1').show().delay(4000).fadeOut();
					$('#FormUpdateContactBox').trigger("reset");
					$('.fixed_right_box').removeClass('active');
					$('.addnew').show();
									
				}else{
					document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
					$('.alert-show').show().delay(4000).fadeOut();
				}
			},
			complete : function(data){
				hideLoader();
			}
		});
	}	
	function openCompanyBox(comprefid){
//	 	document.getElementById("InvoiceHead").innerHTML="Task History Of Sales Id : "+salesno;
		$("#UpdateRegCompany").trigger('reset');
		if(comprefid!="NA"){
			setClientSuperUser("Update_Super_User");
			fillCompanyDetails(comprefid);	
		var id = $(".companybox").attr('data-related'); 
		$('.fixed_right_box').addClass('active');
		    $("div.add_inner_box").each(function(){
		        $(this).hide();
		        if($(this).attr('id') == id) {
		            $(this).show();
		        }
		    });	
		}else{
			document.getElementById('errorMsg').innerHTML ="Client Details Not found, Please Contact to Administration !!!.";
			$('.alert-show').show().delay(4000).fadeOut();
		}
	}
	function fillCompanyDetails(clientkey){
		showLoader();
		$.ajax({
			type : "POST",
			url : "GetCompanyByRefid111",
			dataType : "HTML",
			data : {				
				clientkey : clientkey
			},
			success : function(response){		
			if(Object.keys(response).length!=0){
			response = JSON.parse(response);			
			 var len = response.length;		 
			 if(len>0){ 
			 	var clientkey=response[0]["clientkey"];
				var name=response[0]["name"];
				var industry=response[0]["industry"];
				var pan=response[0]["pan"];
				var gst=response[0]["gst"];
				var city=response[0]["city"];
				var state=response[0]["state"];
				var country=response[0]["country"];
				var address=response[0]["address"];
				var compAge=response[0]["compAge"];
				var stateCode=response[0]["stateCode"];
				var superUserUaid=response[0]["superUserUaid"];
				       
				$("#UpdateCompanyKey").val(clientkey);$("#UpdateCompanyName").val(name);$("#UpdateIndustry_Type").val(industry);
				$("#UpdatePanNumber").val(pan);$("#Edit_Company_age").val(compAge);
				$("#Update_Super_User").val(superUserUaid).trigger('change');
				if(gst!=null&&gst.length>0&&gst!=="NA"){
					$("#UpdateGSTNumber").val(gst);
					document.getElementById("CompanyGstDivId").style.display="block";
				}			
				$("#UpdateCity").empty();
				$("#UpdateCity").append("<option value='"+city+"' selected='selected'>"+city+"</option>");
				$("#UpdateState").empty();
				$("#UpdateState").append("<option value='0#"+stateCode+"#"+state+"' selected='selected'>"+state+"</option>");
				$("#UpdateCountry").val(country);
				$("#UpdateAddress").val(address);
				
			 }}
			},
			complete : function(data){
				hideLoader();
			}
		});
	}	
	function validateUpdateCompany(){	       
		if($("#UpdateCompanyName").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Company Name is mandatory.";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#UpdateIndustry_Type").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Industry type is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		
		if($("#Update_Super_User").val()==null||$("#Update_Super_User").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Select Super User";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		
		if($("#UpdatePanNumber").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Pan Number is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#UpdateGSTNumber").val().trim()==""){
			$("#UpdateGSTNumber").val("NA");
		}
		
		if($("#Edit_Company_age").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Company age is mandatory !!";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		
		if($("#UpdateCity").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="City is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#UpdateState").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="State is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#UpdateCountry").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Country is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#UpdateAddress").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Address is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		
		var industrytype=$("#UpdateIndustry_Type").val();
		let superUser=$("#Update_Super_User").val();
		var pan=$("#UpdatePanNumber").val();
		var gstin=$("#UpdateGSTNumber").val();
		var city=$("#UpdateCity").val();
		var state=$("#UpdateState").val();
		var stateCode="";
		var x=state.split("#");
		state=x[2];
		stateCode=x[1];
		var country=$("#UpdateCountry").val();
		if(country.includes("#")){
			var x=country.split("#");
			country=x[1];
		}
		var address=$("#UpdateAddress").val();
		var companyAge=$("#Edit_Company_age").val();
		var companykey=$("#UpdateCompanyKey").val();
		var companyName=$("#UpdateCompanyName").val();
		showLoader();
		$.ajax({
			type : "POST",
			url : "UpdateNewCompany777",
			dataType : "HTML",
			data : {				
				industrytype : industrytype,
				pan : pan,
				gstin : gstin,
				city : city,
				state : state,
				country : country,
				address : address,
				companykey : companykey,
				companyAge : companyAge,
				stateCode : stateCode,
				companyName: companyName,
				superUser : superUser
			},
			success : function(data){
				if(data=="pass"){
					document.getElementById('errorMsg1').innerHTML = 'Successfully Updated !!';
					$('#UpdateRegCompany').trigger("reset");
					
					$('.fixed_right_box').removeClass('active');
					$('.addnew').show();
									
					$('.alert-show1').show().delay(4000).fadeOut();
				}else{
					document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
					$('.alert-show').show().delay(4000).fadeOut();
				}
			},
			complete : function(data){
				hideLoader();
			}
		});
	}
	function addSuperUser(selectId){
		$("#add_super_user_id").val(selectId);
		$("#add_super_user").modal("show");	
	}
	function validateSuperUser(){
		let super_name=$("#super_name").val();
		let super_email=$("#super_email").val();
		let super_mobile=$("#super_mobile").val();
		if(super_name==null||super_name==""){
			document.getElementById('errorMsg').innerHTML ="Please enter name !!";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if(super_email==null||super_email==""){
			document.getElementById('errorMsg').innerHTML ="Please enter email !!";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if(super_mobile==null||super_mobile==""){
			document.getElementById('errorMsg').innerHTML ="Please enter mobile !!";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		
		$.ajax({
			type : "POST",
			url : "SaveClientSuperUser111",
			dataType : "HTML",
			data : {				
				super_name : super_name,
				super_email : super_email,
				super_mobile : super_mobile
			},
			success : function(data){
				console.log(data);
				if(data=="exist"){
					document.getElementById('errorMsg').innerHTML = 'Either mobile or email already exist !!';
					$('.alert-show').show().delay(4000).fadeOut();
				}else if(data=="pass"){
					let selectId=$("#add_super_user_id").val();
					setClientSuperUser(selectId); 
					$("#super_user_form")[0].reset();
					$("#add_super_user").modal("hide");
					document.getElementById('errorMsg1').innerHTML = 'Super User Registered Successfully !!';
					$('.alert-show1').show().delay(4000).fadeOut();
				}else{
					document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
					$('.alert-show').show().delay(4000).fadeOut();
				}
			},
			complete : function(msg) {
	            hideLoader();
	        }
		});
		
	}
	function setClientSuperUser(selectId){
		$.ajax({
			type : "GET",
			url : "GetClientSuperUser111",
			dataType : "HTML",
			data : {},
			success : function(response){	
				/* console.log(response); */
				$("#"+selectId).empty();
				$("#"+selectId).append(response).trigger('change');
			}
		});
	}
	$(function() {
		$("#ContactName").autocomplete({
			source : function(request, response) {			
				if(document.getElementById('ContactName').value.trim().length>=1)
				$.ajax({
					url : "get-client-details.html",
					type : "POST",
					dataType : "JSON",
					data : {
						name : request.term,
						"field" : "billingcontactname"
					},
					success : function(data) {
						response($.map(data, function(item) {
							return {  
								label : item.name,
								value : item.value,
							};
						}));
					},
					error : function(error) {
						alert('error: ' + error.responseText);
					}
				});
			},
			select: function (event, ui) {
				if(!ui.item){   
	            	
	            }
	            else{
	            	doAction(ui.item.value,'billingContactName');
	            	location.reload();
	            }
	        },
	        error : function(error){
				alert('error: ' + error.responseText);
			},
		});
	});
	function isExistEditGST(valueid){
		var val=document.getElementById(valueid).value.trim();
		var key=$("#UpdateCompanyKey").val().trim();
		if(val!=""&&val!="NA"&&key!=""&&key!="NA")
		$.ajax({
			type : "POST",
			url : "ExistEditValue111",
			dataType : "HTML",
			data : {"val":val,"field":"isEditGST","id":key},
			success : function(data){
				if(data=="pass"){
				document.getElementById("errorMsg").innerHTML=val +" is already existed.";
				document.getElementById(valueid).value="";
				$('.alert-show').show().delay(4000).fadeOut();
				}
				
			}
		});
	}
	function getPayType(estimateno){
		showLoader();
		$.ajax({
			type : "POST",
			url : "GetPayType111",
			dataType : "HTML",
			data : {				
				estimateno : estimateno,
				show : "No"
			},
			success : function(response){
				$("#paymentTable  tbody").empty();	
			    $("#paymentTable  tbody").append(response);		
			}
		});
	}
	function setTotalSalesService(saleno){
		showLoader();
		$.ajax({
			type : "GET",
			url : "GetEstimateSalesProducts111",
			dataType : "HTML",
			data : {				
				saleno : saleno,						
			},
			success : function(data){	
			if(Object.keys(data).length!=0){
				data = JSON.parse(data);			
			 var len = data.length;
			 if(Number(len)>0){	
				$("#Service_Name").empty(); 
				var options="";			 
			 for(var j=0;j<len;j++){ 			
			 	var name=data[j]["name"];
			 	options+="<option value='"+name+"' selected>"+name+"</option>";	 
			 }
			 $("#serviceQty").val(Number(len));
			 $("#Service_Name").append(options);
			 }}
		},
		complete : function(data){
			hideLoader();
		}});
	}
	$("#Service_Name").select2({
		placeholder:"Select Service"
	});
	function showGstBox(){
		$("#showGSTModel").modal("show");
	}   
	function calculateGstAmount(){
		var originalCost=$("#gstAmount").val();
		var gst=$("#GstPercent").val();
		if(originalCost!=null&&originalCost!=""&&gst!=null&&gst!=""){
			var gstAmount=Number(originalCost)-(Number(originalCost)*(100/(100+Number(gst))));
			var netPrice=Math.round(Number(originalCost)-Number(gstAmount));
			
			$("#amountWithoutGst").val(netPrice);
		}
	}
	function copyGstAmount(){
		showLoader();
		var urlText=$("#amountWithoutGst").val();	
		var copyText = document.getElementById("amountWithoutGst");
		copyText.select();
		copyText.setSelectionRange(0, 99999)
		document.execCommand("copy");	 
		$("#showGSTModel").modal("hide");
		hideLoader();
		document.getElementById('errorMsg1').innerHTML = 'Copied !!';
		$('.alert-show1').show().delay(2000).fadeOut();
	}
	function openPaymentInvoice(refid){
		let url="<%=domain%>"+"payment-"+refid+".html";
		window.open(url,"_blank");
	}
</script>
</body>
</html>