<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.stream.IntStream"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Properties"%>
<%@page import="commons.CommonHelper"%>
<%@page import="client_master.Clientmaster_ACT"%>
<%@page import="commons.DateUtil"%>
<%@page import="admin.enquiry.Enquiry_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Manage Online Sales</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %> 
<%
String token= (String)session.getAttribute("uavalidtokenno");

String uuid=request.getParameter("uuid");
if(uuid==null||uuid.length()<=0)uuid="NA";
String inv=request.getParameter("inv");
if(inv==null||inv.length()<=0)inv="NA";

String openContactKey="";
String openProductName="";
if(!uuid.equalsIgnoreCase("NA")){
	String salesData[]=Enquiry_ACT.getSalesDataByUnbill(uuid, token);
	openContactKey=salesData[0];	
	openProductName=salesData[1];
}

String loginuaid= (String)session.getAttribute("loginuaid");
String userRole= (String)session.getAttribute("userRole");

String userrole= (String)session.getAttribute("emproleid");
String addedby= (String)session.getAttribute("loginuID");
String department= (String)session.getAttribute("uadepartment");
if(department==null)department="NA";
Properties properties = new Properties();
properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
String domain=properties.getProperty("domain");
String azure_path=properties.getProperty("azure_path");
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

String sort_url=domain+"manage-sales.html?page="+pageNo+"&rows="+rows;

//pagination end

//new start  .

String salesFilter=(String)session.getAttribute("salesFilter");
if(salesFilter==null||salesFilter.length()<=0)salesFilter="All";

String salesInvoiceAction=(String)session.getAttribute("salesInvoiceAction");
if(salesInvoiceAction==null||salesInvoiceAction.length()<=0)salesInvoiceAction="NA";
if(inv!=null&&!inv.equalsIgnoreCase("NA"))salesInvoiceAction=inv;

String salesPhoneAction=(String)session.getAttribute("salesPhoneAction");
if(salesPhoneAction==null||salesPhoneAction.length()<=0)salesPhoneAction="NA";

String salesPhoneKeyAction=(String)session.getAttribute("salesPhoneKeyAction");
if(salesPhoneKeyAction==null||salesPhoneKeyAction.length()<=0)salesPhoneKeyAction="NA";

String salesProductAction=(String)session.getAttribute("salesProductAction");
if(salesProductAction==null||salesProductAction.length()<=0)salesProductAction="NA";

String salesClientAction=(String)session.getAttribute("salesClientAction");
if(salesClientAction==null||salesClientAction.length()<=0)salesClientAction="NA";

String salesContactAction=(String)session.getAttribute("salesContactAction");
if(salesContactAction==null||salesContactAction.length()<=0)salesContactAction="NA";

String salesSoldByAction=(String)session.getAttribute("salesSoldByAction");
if(salesSoldByAction==null||salesSoldByAction.length()<=0)salesSoldByAction="NA";

String salesSoldByUidAction=(String)session.getAttribute("salesSoldByUidAction");
if(salesSoldByUidAction==null||salesSoldByUidAction.length()<=0)salesSoldByUidAction="NA";

String salesDateRangeAction=(String)session.getAttribute("salesDateRangeAction");
if(salesDateRangeAction==null||salesDateRangeAction.length()<=0)salesDateRangeAction="NA";

/*end  */

String today=DateUtil.getCurrentDateIndianFormat1();
String todayDate=DateUtil.getCurrentDateIndianReverseFormat();
String role=(String)session.getAttribute("emproleid");
double convertedSalesAmt=Clientmaster_ACT.getTotalSalesPaidAmount(userRole,loginuaid,salesInvoiceAction,salesPhoneKeyAction,salesProductAction,salesClientAction,salesSoldByUidAction,salesDateRangeAction,token,salesContactAction,department,salesFilter);
double convertedSalesDues=Clientmaster_ACT.getSalesDueAmount(userRole,loginuaid,salesInvoiceAction,salesPhoneKeyAction,salesProductAction,salesClientAction,salesSoldByUidAction,salesDateRangeAction,token,salesContactAction,department,salesFilter); 
double pastDue=Clientmaster_ACT.getSalesPastDue(userRole,loginuaid,salesInvoiceAction,salesPhoneKeyAction,salesProductAction,salesClientAction,salesSoldByUidAction,salesDateRangeAction,token,salesContactAction,department,salesFilter);
String country[][]=TaskMaster_ACT.getAllCountries();
String teams[][]=TaskMaster_ACT.findTeamByDepartment("Sales");
%> 
<%if(!EQ02){%><jsp:forward page="/login.html" /><%} %>
<div id="content" class="clearfix">
<div class="main-content clearfix">
<div class="clearfix">

<div class="container-fluid">
<div class="box_shadow1 invoice_info redius_box pad_box4 bg_wht mb30">
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
		
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<form name="RefineSearchenqu" onsubmit="return false;">
<div class="bg_wht home-search-form clearfix mb10" id="SearchOptions">
<a href="javascript:void(0)" class="doticon"> <i class="fa fa-filter" aria-hidden="true"></i>Filter</a>
<div class="filtermmenu col-sm-12">
<div class="post" style="position:absolute;z-index:9">
   <div class="linee" style="margin-top: -1px;width:1350px;height:50px"></div>
</div>
<div class="row">
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<select class="form-control" id="cancelFilter" onchange="doAction(this.value,'salesFilter');location.reload()">
<option value="All" <%if(salesFilter.equals("All")){ %>selected="selected"<%} %>>All Sales</option>
<option value="Cancelled" <%if(salesFilter.equals("Cancelled")){ %>selected="selected"<%} %>>Cancelled Sales</option>
<option value="In-Progress" <%if(salesFilter.equals("In-Progress")){ %>selected="selected"<%} %>>In-Progress Sales</option>
<option value="Completed" <%if(salesFilter.equals("Completed")){ %>selected="selected"<%} %>>Completed Sales</option>
<option value="Past-Due" <%if(salesFilter.equals("Past-Due")){ %>selected="selected"<%} %>>Past Due Sales</option>
</select>
</div>
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<p><input type="search" name="invoiceNo" id="InvoiceNo" <%if(!salesInvoiceAction.equalsIgnoreCase("NA")){ %>onsearch="clearSession('salesInvoiceAction');location.reload();" value="<%=salesInvoiceAction %>"<%} %> title="Search by invoice Number !" placeholder="Search by invoice No." class="form-control"/>
</p>
</div>
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<p><input type="search" name="PhoneNo" id="PhoneNo" maxlength="14" <%if(!salesPhoneAction.equalsIgnoreCase("NA")){ %>onsearch="clearSession('salesPhoneAction');clearSession('salesPhoneKeyAction');location.reload();" value="<%=salesPhoneAction %>"<%} %> title="Search by Phone Number !" placeholder="Phone No." class="form-control" onkeypress="return isNumber(event)"/>
<input type="hidden" id="ContactKey" <%if(!salesPhoneKeyAction.equalsIgnoreCase("NA")){ %>value="<%=salesPhoneKeyAction %>"<%} %>>
</p>
</div>
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<p><input type="search" name="productName" id="ProductName" <%if(!salesProductAction.equalsIgnoreCase("NA")){ %>onsearch="clearSession('salesProductAction');location.reload();" value="<%=salesProductAction %>"<%} %> title="Search by Product Name !" placeholder="Product Name.." class="form-control"/>
</p>
</div>
</div>
<div class="row mt-10">
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<p><input type="search" name="contactName" id="ContactName" <%if(!salesContactAction.equalsIgnoreCase("NA")){ %>onsearch="clearSession('salesContactAction');location.reload();" value="<%=salesContactAction %>"<%} %> title="Search by Client !" placeholder="Client Name.." class="form-control"/>
</p>
</div>
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<p><input type="search" name="clientName" id="ClientName" <%if(!salesClientAction.equalsIgnoreCase("NA")){ %>onsearch="clearSession('salesClientAction');location.reload();" value="<%=salesClientAction %>"<%} %> title="Search by company name !" placeholder="Company name.." class="form-control"/>
</p>
</div>
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<p><input type="search" name="soldByName" id="SoldByName" <%if(!salesSoldByAction.equalsIgnoreCase("NA")){ %>onsearch="clearSession('salesSoldByAction');clearSession('salesSoldByUidAction');location.reload();" value="<%=salesSoldByAction %>"<%} %> title="Sold By Name !" placeholder="Sold By Name" class="form-control"/>
<input type="hidden" id="UserUID" <%if(!salesSoldByUidAction.equalsIgnoreCase("NA")){ %>value="<%=salesSoldByUidAction %>"<%} %>>
</p>
</div>
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12 has-clear"> 
<p><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="Select Date" class="form-control text-center date_range pointers <%if(!salesDateRangeAction.equalsIgnoreCase("NA")){ %>selected<%} %>"  readonly="readonly"/>
<span class="form-control-clear form-control-feedback" onclick="clearSession('salesDateRangeAction');location.reload();"></span>
</p>
</div></div>
</div>
</div>
<!-- search option 2 -->
<div class="row noDisplay" id="SearchOptions1">
<div class="col-md-5 col-sm-5 col-xs-12"> 
<div class="col-md-3 col-xs-4">
<a href="#" onclick="downloadInvoices()"><button type="button" class="filtermenu dropbtn" style="width: 90px;">&nbsp;Download</button></a>
</div>
<div class="col-md-3 col-xs-4">
<button type="button" class="filtermenu dropbtn" style="width: 90px;" data-toggle="modal" data-target="#ExportData">&nbsp;Export</button>
</div>
</div>
<div class="col-md-7 col-sm-7 col-xs-12 min-height50">
<div class="clearfix flex_box justify_end">  

</div>
</div>
</div>
</form>

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
          <th width="100" class="sorting <%if(sort.equals("date")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','date','<%=order%>')">Date</th>
          <th class="sorting <%if(sort.equals("estimate")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','estimate','<%=order%>')">Estimate</th>
          <th class="sorting <%if(sort.equals("project")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','project','<%=order%>')">Invoice/Project No.</th>
          <th class="sorting <%if(sort.equals("product")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','product','<%=order%>')">Product</th>
          <th>Client</th>
          <th class="sorting <%if(sort.equals("company")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','company','<%=order%>')">Company</th>
          <th width="120">Amount</th>
          <th class="sorting <%if(sort.equals("progress")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','progress','<%=order%>')">Progress</th>
          <th>Sales Person</th>
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
  
  String[][] getAllSales=Enquiry_ACT.getAllSales(userRole,loginuaid,token,salesInvoiceAction,salesPhoneKeyAction,salesProductAction,salesClientAction,salesSoldByUidAction,salesDateRangeAction,salesContactAction,pageNo,rows,sort,order,department,salesFilter);
  int totalSales=Enquiry_ACT.countAllSales(userRole,loginuaid,token,salesInvoiceAction,salesPhoneKeyAction,salesProductAction,salesClientAction,salesSoldByUidAction,salesDateRangeAction,salesContactAction,department,salesFilter);
  if(getAllSales!=null&&getAllSales.length>0){	 
	  ssn=rows*(pageNo-1);
	  totalPages=(totalSales/rows);
	  if((totalSales%rows)!=0)totalPages+=1;
	  showing=ssn+1;
	  if (totalPages > 1) {     	 
		  if((endRange-2)==totalPages)startRange=pageNo-4;        
          if(startRange==pageNo)endRange=pageNo+4;
          if(startRange<1) {startRange=1;endRange=startRange+4;}
          if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
          if(startRange<1)startRange=1;
     }else{startRange=0;endRange=0;}
	  
  for(int i=0;i<getAllSales.length;i++)
  {
  	String client[][]=Enquiry_ACT.getClientDetails(getAllSales[i][2],token);	
  	String soldby=Usermaster_ACT.getLoginUserName(getAllSales[i][11], token);
  	double orderAmount=TaskMaster_ACT.getOrderAmount(getAllSales[i][3], token);
  	double salesAmount=TaskMaster_ACT.getEachSalesAmount(getAllSales[i][0], token);
  	double invoiceData[]=TaskMaster_ACT.getOrderDueAmount(getAllSales[i][3], token);
  	String companyData[]=Clientmaster_ACT.getClientAddressByRefid(getAllSales[i][1], token);
  	String clientGstin=Clientmaster_ACT.getClientGST(getAllSales[i][1], token);
  	String projectColor="";
  	if(getAllSales[i][16].equalsIgnoreCase("1"))projectColor="red";
  	else if(getAllSales[i][16].equalsIgnoreCase("2"))projectColor="green";
  	else if(getAllSales[i][16].equalsIgnoreCase("3"))projectColor="blue";
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
 
      <tr id="row<%=getAllSales.length-i%>">
          <td><input type="checkbox" name="checkbox" id="checkbox" class="checked" value="<%=getAllSales[i][3] %>"></td>
          <td><%=getAllSales[i][12] %></td>
          <td><%=getAllSales[i][4] %></td>
          <td><%=getAllSales[i][3] %> / <%=getAllSales[i][13] %></td>
          <td><%=getAllSales[i][7] %></td>
          <td class="name_action_box position-relative" id="main<%=getAllSales.length-i %>"><input type="hidden" id="compAddress<%=i %>" value="<%=companyData[0]%>"/>
          <span id="MainCon<%=getAllSales.length-i %>" class="clickeble contactbox name_field" data-related="update_contact" <%if(client!=null&&client.length>0){ %>onclick="openContactBox('<%=client[0][3] %>','<%=client[0][2] %>','row<%=getAllSales.length-i%>','compAddress<%=i %>','<%=getAllSales[i][0]%>')"><%=client[0][0] %><%}else{ %>>NA<%} %></span>
		  <%if(client!=null&&client.length>1){ %>
		  <div class="iAction">
		  <i class="fa fa-plus pointers" onclick="showAllContact(event,'main<%=getAllSales.length-i %>','sub<%=getAllSales.length-i %>')"><small><%=(client.length-1) %></small></i><i class="fa fa-minus pointers" onclick="minusAllContact(event)"></i>
		  </div>
		  <%} %>
		  <ul class="dropdown_list" id="sub<%=getAllSales.length-i %>">
		  <%if(client!=null&&client.length>1){for(int j=1;j<client.length;j++){ %>
		  <li><a class="pointers clickeble contactbox" data-related="update_contact" onclick="openContactBox('<%=client[j][3] %>','<%=client[j][2] %>','row<%=getAllSales.length-i%>','compAddress<%=i %>','<%=getAllSales[i][0]%>')"><%=client[j][0] %></a></li>
		  <%}} %>
		  </ul>
          </td>
          <td><span <%if(!getAllSales[i][5].equalsIgnoreCase("....")){ %>class="clickeble name_action_box companybox" data-related="update_company" onclick="openCompanyBox('<%=getAllSales[i][1]%>')"<%} %>><%=getAllSales[i][5] %></span></td>
          <td>
          <input type="hidden" id="invoiceNotes<%=i %>" value="<%=getAllSales[i][15]%>">
          <span class="clickeble invoicebox" data-related="invoice_receipt" onclick="openInvoiceBox('<%=getAllSales[i][3] %>','<%=getAllSales[i][5] %>','<%=getAllSales[i][2] %>','<%=getAllSales[i][1] %>','<%=getAllSales[i][0] %>','<%=client[0][5] %>','<%=client[0][0] %>','compAddress<%=i %>','<%=companyData[1] %>','<%=companyData[2] %>','<%=invoiceData[0] %>','<%=invoiceData[1]%>','<%=invoiceData[2]%>','<%=clientGstin%>','invoiceNotes<%=i %>','<%=getAllSales[i][17] %>','<%=getAllSales[i][18] %>')"><i class="fa fa-inr"></i>&nbsp;&nbsp;<%=CommonHelper.withLargeIntegers(salesAmount) %></span>
          </td><%if(getAllSales[i][19].equals("1")){ %>
          <td class="pointers taskhis clickeble" data-related="task_history" onclick="openTaskHistoryBox('<%=getAllSales[i][3] %>','<%=getAllSales[i][6] %>','<%=getAllSales[i][0] %>')" style="color: <%=projectColor%>;"><%=getAllSales[i][14] %> %</td>          
          <%}else{long cProgress=Enquiry_ACT.findConsultingPercentage(getAllSales[i][0],token,todayDate); %>	  
           <td><a href="javascript:void(0)" onclick="showSaleDetails('<%=getAllSales[i][0]%>')"><%=cProgress %>%</a></td><%} %>
          <td><%=soldby %></td>
          <td class="list_icon">
          	<a href="javascript:void(0)" class="icoo">
			<i class="fa fa-angle-up pointers "></i>
			<i class="fa fa-angle-down pointers "></i>
			</a>
			
			<ul class="dropdown_list managesale" style="display:none">
			<%if(EQ01){%><li><a class="addnew2 pointers" data-related="add_payment" onclick="openPaymentBox('<%=getAllSales[i][3] %>','<%=getAllSales[i][4] %>','<%=getAllSales[i][0]%>','<%=getAllSales[i][13]%>','<%=orderAmount%>','<%=invoiceData[0]%>')">Register Payment</a></li><%} %>
			<%if(MAS00){%><li><a class="adddoc pointers" data-related="add_document" onclick="openDocumentBox('<%=getAllSales[i][13] %>','<%=getAllSales[i][0] %>')">Documents</a></li><%} %>
			<%if(MAS01){%><li><a class="taskhis" data-related="task_history" onclick="openTaskHistoryBox('<%=getAllSales[i][3] %>','<%=getAllSales[i][6] %>','<%=getAllSales[i][0] %>')">Task History</a></li><%} %>
			<li><a class="notes" data-related="task_notes" onclick="openTaskNotesBox('<%=getAllSales[i][0] %>','<%=getAllSales[i][7] %>','<%=getAllSales[i][2] %>')">Notes</a></li>
			<%if(salesFilter.equalsIgnoreCase("Cancelled")){ %>
			<li><a href="javascript:void(0)" onclick="showCancelReason('<%=getAllSales[i][3] %>')">Cancel Reason</a></li><%} %>			
			</ul>
          </td>
      </tr>
   <%}}%>
                           
    </tbody>
</table>
</div>
  <div class="filtertable">
  <span>Showing <%=showing %> to <%=ssn+getAllSales.length %> of <%=totalSales %> entries</span>
  <div class="pagination">
    <ul> <%if(pageNo>1){ %>
      <li class="page-item">	                     
      <a class="page-link text-primary" href="<%=request.getContextPath()%>/manage-sales.html?page=1&rows=<%=rows%><%=filter%>">First</a>
   </li><%} %>
    <li class="page-item">					      
      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/manage-sales.html?page=<%=(pageNo-1) %>&rows=<%=rows%><%=filter%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
    </li>  
      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
	    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
	    <a class="page-link" href="<%=request.getContextPath()%>/manage-sales.html?page=<%=i %>&rows=<%=rows%><%=filter%>"><%=i %></a>
	    </li>   
	  <%} %>
	   <li class="page-item">						      
	      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/manage-sales.html?page=<%=(pageNo+1) %>&rows=<%=rows%><%=filter%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
	   </li><%if(pageNo<=(totalPages-1)){ %>
	   <li class="page-item">
	      <a class="page-link text-primary" href="<%=request.getContextPath()%>/manage-sales.html?page=<%=(totalPages) %>&rows=<%=rows%><%=filter%>">Last</a>
	   </li><%} %>
	</ul>
	</div>
	<select class="select2" onchange="changeRows(this.value,'manage-sales.html?page=1','<%=domain%>')">
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
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>
</div>
<p id="end" style="display: none;"></p>

<section class="clearfix" id="managethisEnquiry" style="display: none;">
<div class="clearfix  text-center">
<div class="col-md-12 col-xs-12" id="salesenqrefid" style="display: none;"></div>
<div class="col-md-12 col-xs-12" id="salesenqrowid" style="display: none;"></div>
<div class="col-md-12 col-xs-12">
<div class="box-intro1">
  <h2><span class="title">Are You Sure ? Want to delete this Sales ?</span></h2>
  <span id="DelerrMsg" style="font-size: 14px;padding-top: 6px;display: block;min-height: 15px;"></span>
</div>
</div>
<div class="col-md-12 col-xs-12 mb10">
<a class="sub-btn1" onclick="" id="cancelpopup">Cancel</a>

<!-- <a class="sub-btn1" onclick="return deleteDistributor(document.getElementById('userid').innerHTML,'1');" title="Approve this Distributor">Activate</a> -->
<button class="sub-btn1 mlft10" id="cancelpopup1" onclick="return deleteEnq(document.getElementById('salesenqrefid').innerHTML,document.getElementById('salesenqrowid').innerHTML);" title="Delete this Sales">Delete</button>
</div>
</div>
</section>
<input type="hidden" id="URLSREF"/>
<input type="hidden" id="URLNAME"/>

<!-- Start right side box -->
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
<div class="fixed_right_box">
<div class="clearfix add_inner_box pad_box4 addcompany" id="add_payment">

<div class="close_icon close_box"><i class="fa fa-times"></i></div>
<div class="rttop_title">
<h3 style="font-weight: 600;font-size: 20px;"><i class="fa fa-money"></i>Register Payment : <span id="PayHead" style="color:#357b8bf5;"></span></h3>
</div>
<div class="table-responsive mb-10">
<table class="ctable" id="paymentTable">
   <thead>
      <th> Name</th>
      <th>  Payment</th>
   </thead>
   <tbody>   
   
   </tbody>
</table>
</div>

<form onsubmit="return false;" enctype="multipart/form-data" id="UploadFormdata" class="uploadFormdata">
<a href="javascript:void(0)" onclick="showGstBox()"><u>Calculate GST ?</u></a>
<input type="hidden" name="WhichPaymentFor" id="WhichPaymentFor">
<div class="menuDv pad_box4 clearfix mb30">
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <select name="paymentmode" id="PaymentMode" class="form-control bdrd4" onchange="setMode(this.value)">
<option value="">Payment Mode</option>
<option value="Online" selected="selected">Online</option>
<option value="Cash">Cash</option>
</select>
  </div>
  <div id="paymentmodeErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="form-group">
  <div class="input-group">
  <input type="text" name="pymtdate" id="PaymentDate" value="<%=today %>" autocomplete="off" placeholder="Date" class="form-control datepicker readonlyAllow bdrd4" readonly="readonly">
  </div>
  <div id="pdateErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
 <div class="form-group row">
 <label class="col-sm-4">Transaction Id</label>
  <div class="col-sm-8">
  <input type="text" name="transactionid" id="TransactionId" 
  autocomplete="off" placeholder="Transaction Id" class="form-control">
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
 
 <div class="row "> 
<div class="col-md-12 col-sm-12 col-xs-12 text-right">
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
<input type="hidden" id="SalesInvoiceNo" name="salesInvoiceNo">
<input type="hidden" id="SalesEstimatenoNo" name="salesEstimatenoNo">
<button type="button" class="btn-warning bdrd4 p5-20" id="btnSubmit" onclick="validatePayment(event)">Submit</button>
</div>	
</div>			
</div>
</form>
<div class="rttop_titlep">
<h3 style="color: #42b0da;" class="fa fa-history">&nbsp;Payment history</h3>
<span style="margin-left: 15px;font-size: 14px;color: #42b0dabf;">Order amount : <i class="fa fa-inr"></i>&nbsp;<span id="TotalOrderAmountId"></span></span>    
<span style="font-size: 14px;color: #da8142ba;">Due amount : <i class="fa fa-inr"></i>&nbsp;<span id="TotalDueAmountId"></span></span>
</div>
<div class="clearfix" style="min-height: 145px;">
<div class="table-responsive">    
<table class="ctable">
<thead>
   <th>Date</th>
   <th>Status</th>
   <th>Amount</th>
   <th>File</th>
   <th>Invoice</th>
</thead>
<!-- on open payment box show received payment -->

 <tbody>   
	<tr id="ReceivedPayment"></tr>
</tbody>
</table>
</div>
<div class="clearfix col-md-12">
    <div class="col-md-6 popaction" style="display: none;">
    <div class="row">
     <span class="ActBtn">Delete record</span> 
    </div>   
    <div class="row mtop10">
      <span class="fntsize10">Are you sure want to delete this payment ?</span>
     </div>
     <div class="row mtp4">
      <span class="fntsize10">This Can't be reverse !</span>
      </div>
      <div class="row ActBtn1">
      <span class="fa fa-times pointers" style="margin-right: 7px;"></span>
      <span class="fa fa-check pointers"></span> 
      </div>  
    </div>
    <div class="col-md-6 popaction1" style="display: none;">
    <div class="row">
      <span class="ActBtn">Cancel payment</span> 
     </div> 
      <div class="row mtop10">  
      <span class="fntsize10">Are you sure want to cancel this payment ?</span>
      </div>
      <div class="row mtp4">
      <span class="fntsize10">This Can't be reverse !</span>
      </div>
      <div class="row ActBtn1">
      <span class="fa fa-times pointers" style="margin-right: 7px;"></span>
      <span class="fa fa-check pointers"></span>
      </div>
    </div>
</div>
</div>
</div>
<div class="clearfix add_inner_box pad_box4 addcompany" id="add_document">
<div class="close_icon close_box"><i class="fa fa-times"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-file-o"></i>Document Vault : <span id="DocHead" class="text-warning"></span></h3>
<p>A Document Vault data room is a sophisticated tool for managing your documents online, offering the highest levels of security.
It can be used for due diligence in a wide range of applications, from selling or buying a company, to selling or buying a property,
to sharing information about customers and suppliers.</p>
</div>
<!-- <h3 style="font-size: 16px;color: #42b0da;"></h3> -->
<div class="tab two">
  <button class="tablinks active box-width51" onclick="openDocument(event, 'ClientUploadDoc')">&nbsp;Client's Uploads</button>
  <button class="tablinks box-width49" onclick="openDocument(event, 'HistoryUploadDoc')">&nbsp;History</button>
</div>
<div class="clearfix pad_box3 pad05 tabcontent" style="display:block;" id="ClientUploadDoc">
<form onsubmit="return false;" class="upload-box">
<input type="hidden" id="Docrefid" name="docrefid" value="NA">
<input type="hidden" id="DocfileInputBoxId" name="docfileInputBoxId" value="NA">
<div id="DocumentListAppendId"></div>
</form>
</div>

<div class="clearfix pad_box3 pad05 tabcontent" style="display:none;" id="HistoryUploadDoc">
<div class="clearfix mb10">

<div id="DocumentHistoryAppendId"></div>

</div>
</div>
<div class="row pointers" style="float: right;margin-right: 2px;margin-top: 7px;">
<a href="javascript:void(0)" onclick="uploadNewDocument()">+&nbsp;New Document</a>
</div>
</div>

<div class="clearfix add_inner_box pad_box4 addcompany" id="update_contact">
<div class="close_icon close_box"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-fax"></i>Update Client's details</h3>
<p>When someone reaches out to you, they become a contact in your account. You can create companies and associate contacts with them.</div>

<form onsubmit="return false;" id="FormUpdateContactBox">
<input type="hidden" id="UpdateContactKey"/>
<input type="hidden" id="UpdateContactSalesKey"/>
<input type="hidden" id="ContactSalesKey"/>
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="form-group">
  <div class="input-group">
  <input type="text" name="firstname" id="UpdateContactFirstName" placeholder="First Name" onblur="validateNamePopup('UpdateContactFirstName');validateValuePopup('UpdateContactFirstName')" class="form-control bdrd4">
  </div>
  <div id="fnameErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="lastname" id="UpdateContactLastName" placeholder="Last Name" onblur="validateNamePopup('UpdateContactLastName');validateValuePopup('UpdateContactLastName');" class="form-control bdrd4">
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
  <input type="email" name="enqEmail" id="UpdateContactEmail_Id" onblur="verifyEmailIdPopup('UpdateContactEmail_Id');isUpdateDuplicateEmail('UpdateContactEmail_Id');" placeholder="Email" class="form-control bdrd4">
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
  <input type="email" name="enqEmail" id="UpdateContactEmailId2" onblur="isUpdateDuplicateEmail('UpdateContactEmailId2');" placeholder="Email" class="form-control bdrd4">
<button class="addbtn pointers close_icon1 del_icon" type="button"><i class="fa fa-times" style="font-size: 20px;"></i></button>
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
  <input type="text" name="workphone" id="UpdateContactWorkPhone" onblur="isUpdateDuplicateMobilePhone('UpdateContactWorkPhone')" placeholder="Work phone" maxlength="14" class="form-control bdrd4" onkeypress="return isNumber(event)">
  </div>
  <div id="wphoneErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>Mobile Phone :</label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
  <input type="text" name="mobilephone" id="UpdateContactMobilePhone" placeholder="Mobile Phone" maxlength="14" onblur="validateMobilePopup('UpdateContactMobilePhone');isUpdateDuplicateMobilePhone('UpdateContactMobilePhone');" class="form-control bdrd4" onkeypress="return isNumber(event)">
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
  <textarea class="form-control bdrd4" rows="2" name="enqAdd" id="UpdateContAddress" placeholder="Address" onblur="validateValuePopup('UpdateContAddress');validateLocationPopup('UpdateContAddress');" ></textarea>
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
  <textarea class="form-control bdrd4" rows="2" name="enqCompAdd" id="UpdateEnqCompAddress" placeholder="Company Address" onblur="validateValuePopup('UpdateEnqCompAddress');validateLocationPopup('UpdateEnqCompAddress');" readonly="readonly"></textarea>
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
<div class="clearfix add_inner_box pad_box4 addcompany" id="invoice_receipt">
<div class="close_icon close_box"><i class="fa fa-times"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-file-o"></i>Sales Invoice</h3>
</div>
<h3 style="font-size: 13px;border-bottom: 1px solid #e1e1e1;padding-bottom: 11px;"><span class="pointers" id="EmailSendedId" onclick="openSendEmailBox()"><i class="far fa-envelope"></i>&nbsp;&nbsp;Send email</span>

<span style="margin-left: 20px;" class="pointers" onclick="convertHTMLToPdf('invoicecontent','InvoiceBillNo')"><i class="fas fa-download"></i>&nbsp;&nbsp;PDF</span>
<span style="margin-left: 20px;" class="pointers" onclick="copyInvoiceLink()" title="Copy Invoice Link !!" id="CopyLinkUrl"><i class="far fa-copy"></i>&nbsp;&nbsp;URL</span> 
<span style="margin-left: 20px;" class="pointers" onclick="printDiv('invoicecontent','InvoiceBillNo')"><i class="fas fa-print"></i>&nbsp;&nbsp;Print</span> 
<span style="margin-left: 20px;" class="pointers" onclick="sendLogin()"><i class="fas fa-lock"></i>&nbsp;&nbsp;Send Login</span>
<input type="text" id="InvoiceUrl" style="opacity: 0;width:10px">
</h3>
<div class="clearfix menuDv pad_box3 pad05 mb10" style="min-height: 150px;margin-top: 16px;" id="invoicecontent">
<div class="clearfix invoice_div">

<div class="clearfix" style="position: relative;margin-bottom: -35px;">
<img alt="" src="<%=request.getContextPath()%>/staticresources/images/tag.png" style="width: 50px;margin-left: -15px;margin-top: -10px;">
<span style="position: absolute;margin-left: -48px;transform: rotate(-45deg);color: #ffff;font-size: 11px;" id="PaymentPaidOrPartial"></span>
</div>
<div class="clearfix" style="width:100%;padding-top:0px;display: flex;">
<div style="width:50%;">
<div style="margin-bottom:1px;">
<img src="<%=request.getContextPath() %>/staticresources/images/corpseed-logo.png" alt="corpseed logo" style="max-width:95px;" />
</div>
<div class="clearfix">
<p>
<span style="font-weight:600;color:#888;">Corpseed Ites Private Limited</span><br/>
<span>CN U74999UP2018PTC101873</span><br/>
<span>2nd Floor, A-154A, A Block, Sector 63</span><br/>
<span>Noida, Uttar Pradesh - 201301</span><br/>
</p>
</div>
</div>
<div style="width:50%;">
<div style="margin-bottom:10px;text-align:right;">
<h2 style="font-size:18px;margin:0 0 5px;color:#48bd44;font-weight: 500;">UNBILLED</h2>
<p style="font-weight:600;" id="InvoiceBillNo"></p>
</div>
<div style="margin-bottom:10px;text-align:right;" id="orderNoMain">
<h2 style="font-size:14px;margin:0 0 5px;color:#48bd44;font-weight: 500;">Order No.</h2>
<p style="font-weight:600;" id="orderNo"></p>
</div>

<div style="width:100%;" id="BalanceDueAmount">
<div style="text-align:right;font-size: 14px;margin-top: 40px;font-weight: 600;">
<span>Due Amount&nbsp;&nbsp;:&nbsp;&nbsp;</span><span><i class="fa fa-inr"></i>&nbsp;<span id="InvoivePaymentDue"></span></span>
</div> 
</div>
</div>
</div>
<div class="clear"></div>
<div class="clearfix" style="width:100%;">
<p style="margin:0px;">Bill To : </p>
<p style="font-weight: 600;margin-bottom: 1rem;" id="BillToId"></p>
<p style="margin-top: -1rem;" id="BillToGSTINId"></p>
</div>
<div class="clear"></div>
<div class="clearfix" style="width:100%;display: flex;">
<div style="width:50%;">
<p style="margin:0px;"></p>
<p style="margin-bottom:5px;">Ship To : <br>
<span id="ShipToId"></span><br>
<span id="ShipToAddressId"></span></p>
<p>Place Of Supply: <span id="ShipToStateCode"></span></p>
</div>
<div style="width:50%;text-align:right;">
<p><span style="font-weight:600;color:#888;">Date :</span> <span style="padding-left:20px;"><%=today %></span></p>
<p id="purchaseDateMain"><span style="font-weight:600;color:#888;">Order Date :</span> <span style="padding-left:20px;" id="PurchaseDate"></span></p>
</div>

</div>
<div class="clear"></div>
<div class="table-responsive">
<table  style="width:100%">
<tr>
<td>
<div class="clearfix" style="width:100%;">
<div class="clearfix" style="width:100%;background:#48bd44;color:#fff;padding-bottom:8px;padding-top:8px;border-radius: 3px;display: flex;">
<div style="width:4%;">
<p style="margin:0;font-size:11px;">#</p>
</div>
<div style="width:30%;" id="ItemDescriptionId">
<p style="margin:0;font-size:11px;">Item & Description </p>
</div>
<div style="width:13%;">
<p style="margin:0;font-size:11px;text-align: right;">HSN</p>
</div>
<div style="width:15%;">
<p style="margin:0;font-size:11px;text-align: right;">Rate</p>
</div>
<div style="width:8%;" id="SGSTTaxId">
<p style="margin:0;font-size:11px;text-align: right;">GST %</p>
</div>
<div style="width:12%;" id="CGSTTaxId">
<p style="margin:0;font-size:11px;text-align: right;">GST Amt.</p>
</div>
<div style="width:18%;">
<p style="margin:0;font-size:11px;text-align: right;padding-right: 10px;">Amount</p>
</div>
<div class="clear"></div>
</div>

<div class="clearfix" id="ItemListDetailsId"></div>
<div class="clearfix totalDiscount" style="font-weight: 600;border-top: 1px dotted black;padding: 5px 0px 5px 0px;display: flex;">
	<div style="padding-left: 16px; width: 34%;">
	<p style="margin:0;font-size: 11px;">&nbsp;</p></div>
	<div style="width:13%;"><p style="margin:0;text-align: right;font-size: 11px;">&nbsp;Disc.</p></div>
	<div style="width:15%;"><p style="margin:0;text-align: right;font-size: 11px;"></p></div>
	<div style="width:8%;"><p style="margin:0;text-align: right;font-size: 11px;">&nbsp;</p></div>
	<div style="width:12%;"><p style="margin:0;text-align: right;font-size: 11px;">&nbsp;</p></div>
	<div style="width:18%;"><p style="margin:0;text-align: right;font-size: 11px;" id="TotalAmountDiscount"></p>
	</div>
</div>
<div class="clearfix" style="font-weight: 600;border-top: 1px dotted black;border-bottom: 1px dotted black;padding: 5px 0px 5px 0px;display: flex;">
	<div style="padding-left: 16px; width: 34%;">
	<p style="margin:0;font-size: 11px;">Total Qty. : &nbsp;<span id="TotalProductQuty"></span></p></div>
	<div style="width:13%;"><p style="margin:0;text-align: right;font-size: 11px;">&nbsp;</p></div>
	<div style="width:15%;"><p style="margin:0;text-align: right;font-size: 11px;" id="TotalPriceWithoutGst"></p></div>
	<div style="width:8%;"><p style="margin:0;text-align: right;font-size: 11px;">&nbsp;</p></div>
	<div style="width:12%;"><p style="margin:0;text-align: right;font-size: 11px;" id="TotalGstAmount"></p></div>
	<div style="width:18%;"><p style="margin:0;text-align: right;font-size: 11px;" id="TotalAmountWithGST"></p>
	</div>
</div>
<div class="clearfix" style="width:100%;padding: 10px 0 0 0;">
<p style="margin:0;font-size:11px;padding-left:10px;padding-right:10px;text-align:right;">Total In Words: <span style="font-weight:600;padding-left:10px;color:#666;" id="SalesRupeesInWord"></span></p>
</div>
<div class="clearfix" style="width: 100%" id="DisplayTaxData">
Tax Details
<div class="clearfix" style="width:100%;border: 1px dotted black;margin-top: 10px;">
    <div class="clearfix" style="width: 100%;font-weight: 600;text-align: center;border-bottom: 1px dotted black;padding: 5px 0 5px 0px;display: flex;font-size: 10px;">
    	<div style="width: 25%">HSN</div>
    	<div style="width: 25%">SGST %</div>
    	<div style="width: 25%">CGST %</div>
    	<div style="width: 25%">IGST %</div>
    </div>
   <div id="GSTTaxAppendBoxId"></div>
   
</div>
</div>
</div>
</td>
</tr>
</table>
</div>
<div class="clear"></div>

<div class="clearfix" style="width:100%;margin-top:5px;margin-bottom:5px;">  
<p style="margin-bottom:5px;color:#555;"><span style="font-weight: 600;">Notes :</span> <span></span></p>
<p style="font-size: 11px;color:#888;">This Estimates & price quotation is valid for 7 calendar days from the date of issue.</p>
<p style="font-size: 11px;color:#888;" id="invoiceNotes"></p>
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
</div>
</div>
<div id="endContentId"></div>
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
  <input type="text" name="pannumber" id="UpdatePanNumber" placeholder="Pan Number" onblur="validatePanPopup('UpdatePanNumber');validateValuePopup('UpdatePanNumber');isExistEditPan('UpdatePanNumber');" class="form-control bdrd4">
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
<div class="clearfix add_inner_box pad_box4 addcompany" id="task_history">
<div class="close_icon close_box"><i class="fa fa-times"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-file-o"></i> <span style="color:#357b8bf5;" id="TaskHead"></span></h3> 
<p>When someone reaches out to you, they become a contact in your account. You can create companies and associate contacts with them.</p></div>
<h3 style="font-size: 16px;color: #42b0da;"><span id="DocHead"></span></h3>
<!-- Start -->
     
<div class="clearfix" id="MilestonesAppendId"></div>
      
<!-- End -->
</div> 

<!-- notes start -->

<div class="clearfix add_inner_box pad_box4 addcompany" id="task_notes" style="display: none;">
<div class="close_icon close_box"><i class="fa fa-times"></i></div>
<div class="clearfix bdr_bt pad-lft10 pad-rt10">
<div class="rttop_title">
<h3 id="taskNotesProduct">Product name</h3>
</div> 
<div class="clearfix nav-tabs-border"> 
<ul class="nav-tabs">
<li class="active" id="TeamNotesLi" onclick="showTeamNotes('TeamNotesLi','PersonalNotesLi','ReplyNotesBoxId','InternalNotesBoxId')"><a>Team</a></li> 
<li id="PersonalNotesLi" onclick="showPersonalNotes('TeamNotesLi','PersonalNotesLi','ReplyNotesBoxId','InternalNotesBoxId')"><a >Personal</a></li>
</ul>
<form onsubmit="return false" class="PublicChatReply" id="PublicSalesTaskFormId">
	<input type="hidden" name="taskActiveSalesKey" id="taskActiveSalesKey">
	<input type="hidden" name="taskActiveContactKey" id="taskActiveContactKey">
	<div class="clearfix box_shadow1 relative_box reply_box" id="ReplyNotesBoxId">
	<textarea class="ChatTextareaBox" rows="2" id="ChatTextareaBoxReply" name="ChatTextareaBoxReply" placeholder="Public reply here..... !!" required="required"></textarea>
	
	<div class="clearfix">
        <select class="form-control" id="userInChat" name="userInChat" multiple="multiple" required="required">        
        </select>
    </div>
	</div>
	<div class="clearfix box_shadow1 relative_box reply_box toggle_box" id="InternalNotesBoxId">
	<!-- <textarea class="ChatTextareaBox1" rows="5" id="ChatTextareaBoxReplyInternotes" placeholder="Internal notes here..... !!"></textarea>  -->
	<textarea id="ChatTextareaBoxReply1" name="ChatTextareaBoxReply1"></textarea>
	</div>
</form>
</div>


<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12 cmhistscrollInternal internalNotes toggle_box"> 

</div>
<div class="col-md-12 col-sm-12 col-xs-12 cmhistscroll">
<div class="clearfix communication_history">	

</div>
</div>
</div>
</div>
<div class="clearfix about-content text-right pad-lft10 pad-rt10 communication_history1"> 
    <button class="bt-link bt-radius bt-loadmore mrt10 close_box btn-cancel" type="button">Cancel</button>
	<button class="bt-link bt-radius bt-loadmore" type="button" onclick="return validateTeamNotes()">Submit</button>		
</div>

<div class="clearfix about-content text-right pad-lft10 pad-rt10 internalNotes toggle_box"> 
    <button class="bt-link bt-radius bt-loadmore mrt10 close_box btn-cancel" type="button">Cancel</button>
	<span class="relative_box"><button class="bt-link bt-radius bt-loadmore" type="button" onclick="return validatePersonalNotes()">Submit</button>	
	</span> 
</div>
</div>
<!-- notes end -->
</div>
<div class="modal fade" id="AddNewDocumentList" tabindex="-1" role="dialog" aria-labelledby="DocumentListModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
  <form onsubmit="return false" id="AddNewDocumentListForm">
  <div class="modal-content">
  	 <div class="modal-header">
        <h5 class="modal-title" >+&nbsp;Document List : <span style="color:#357b8bf5;" id="RegisterNewDocList"></span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
		<div class="col-md-12 pad05 pad-top5">
		<div class="row location_box">
			<div class="col-md-6">
				<input type="text" placeholder="Document name" autocomplete="off" name="NewDocumentName" id="NewDocumentName" class="form-control">
			</div>
			<div class="col-md-6">
				<select class="form-control" name="DocumentUploadBy" id="DocumentUploadBy">
					<option value="Client">Client</option>
				</select>
			</div>
		</div>
		<div class="row location_box">
			<div class="col-md-12">
			<textarea rows="5" placeholder="Document description...." autocomplete="off" name="DocumentUploadRemarks" id="DocumentUploadRemarks" class="form-control"></textarea>
			</div>
		</div>		
		</div>
		</div>
		 <div class="modal-footer">
		 <input type="hidden" id="ActiveDocSalesKey" value="NA">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-primary" id="btnclick12" onclick="validateDocumentList()">Submit</button>
      </div> 
      </div>
	</form>  
  </div>
</div>
  <div class="modal fade" id="PermissionNot" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span><span class="text-danger">Either document doesn't exist or you haven't permission..</span></h5>
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
  <div class="modal fade" id="warningDeleteFile" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title fas fa-exclamation-triangle text-danger" id="exampleModalLabel" style="padding-bottom: 6px;">&nbsp;&nbsp;Do you really want to delete this document ?</h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close" style="margin-top: 0px;">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>   
      <input type="hidden" id="deleteTemplateId" value="NA">
      <div class="modal-footer">
      <input type="hidden" id="SalesDocumentId">
      <input type="hidden" id="SalesDocumentName">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="deleteDocument('NA','NA');">Yes</button>
      </div>
    </div>
  </div>
</div>
<div class="modal fade" id="warningPayment" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span>
        <span class="text-danger" id="WarningText">Payment awating for approval..</span></h5>
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
<div class="modal fade" id="SendEmailWarning" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-envelope text-primary" style="margin-right: 10px;"> </span><span class="text-primary">Send Estimate Invoice</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <form action="return false">
       <div class="modal-body">       
         <div class="form-group">
            <label for="recipient-name" class="col-form-label">Email To :</label>
            <input type="email" autocomplete="off" class="form-control" placeholder="Email Id.." name="email" id="EmailTo">
          </div>
          <div class="form-group">
            <label for="recipient-name" class="col-form-label">CC :</label>
<!--             <input type="email" autocomplete="off" class="form-control removeEmailCC" placeholder="Email Id.." name="emailCC" id="EmailCC"> -->
            <select class="form-control" id="EmailCC" multiple="multiple">
            	  
			</select>
          </div>
        <div class="form-group">
            <label for="recipient-name" class="col-form-label">Subject :</label>
            <input type="text" autocomplete="off" class="form-control" placeholder="Subject" name="subject" id="EmailSubject">
          </div>
         <div class="form-group">
            <label for="recipient-name" class="col-form-label">Mesasge :</label>
             <textarea rows="8" autocomplete="off" class="form-control" placeholder="Email Body.." id="EmailBody"></textarea>
          </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-primary" onclick="return sendSalesInvoice()">Submit</button>
      </div></form>
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
            <label for="recipient-name" class="col-form-label">Columns :</label>
            <select class="form-control" name="exportColumn" id="ExportColumn" multiple="multiple">
            	<option value="ms.mssolddate as Sold_Date" selected>Sold Date</option>
            	<option value="ms.msinvoiceno as Invoice" selected>Invoice</option>
            	<option value="ms.msestimateno as Estimate_No">Estimate No</option>
            	<option value="ms.msprojectnumber as Project_No" selected>Project No</option>
            	<option value="ms.msproducttype as Service_Type">Service Type</option>
            	<option value="ms.msproductname as Service_Name" selected>Service</option>
            	<option value="c.cbname as Contact_Name" selected>Contact Name</option>
            	<option value="c.cbemail1st as Contact_Email_First" selected>Contact Email-1</option>
            	<option value="c.cbemail2nd as Contact_Email_Second">Contact Email-2</option>
            	<option value="c.cbmobile1st as Contact_Mobile_First" selected>Contact Mobile-1</option>
            	<option value="c.cbmobile2nd as Contact_Mobile_Second">Contact Mobile-2</option>
            	<option value="ms.mscompany as Company" selected>Company</option>
            	<option value="h.cborderamount as Order_Amount" selected>Order Amount</option>            	
             	<option value="h.cbpaidamount as Paid_Amount" selected>Paid Amount</option> 
             	<option value="h.cbdueamount as Due_Amount" selected>Due Amount</option>  
             	<option value="ms.msworkstatus as Service_Status" selected>Service Status</option>          	 
            	<option value="ms.msworkpercent as Work_Percent" selected>Progress</option>
            	<option value="ms.msremarks as Remarks">Remarks</option>            	
            	<option value="u.uaname as Sold_By" selected>Sold by</option>
            	<option value="ms.msworkpriority as Work_Priority">Work Priority</option> 
            	<option value="ms.document_assign_date as Document_Person_Assign_Date">Document Person Assign Date</option>  
            	<option value="ms.document_assign_name as Document_Person">Document Person</option> 
            	<option value="ms.document_uploaded_date as Document_Uploaded_Date">Document Uploaded Date</option>             	
            	<option value="ms.delivery_assign_date as Assign_To_Delivery">Assign To Delivery</option>
            	<option value="ms.msassignedtoname as Assigned_Team">Assigned Team</option> 
            	<option value="ms.delivery_person_name as Delivery_Manager_Name">Delivery Manager Name</option>
            	<option value="ms.msdeliveredon as Delivered_Date">Delivered_Date</option> 
            	<option value="ms.msinvoicenotes as Invoice_Notes">Invoice Notes</option> 
            	<option value="ms.msjurisdiction as Jurisdiction">Jurisdiction</option>
            	<option value="ms.msprojectstatus as Work_Status">Work Status</option> 
            	<option value="ms.msdeliverydate as Delivery_Date">Delivery Date</option>             	
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
<div class="myModal modal fade" id="sendLoginCredentials">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title"><i class="fas fa-lock" aria-hidden="true"></i> Send Login Credentials</h4>  
          <button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>
        <form onsubmit="return validateSendUserLogin()" action="javascript:void(0)" id="send_login_credentials" name="send_login_credentials">    
        <div class="modal-body">           
		  		  		  
        </div>
        <div class="modal-footer pad_box4">
          <div class="mtop10">
	          <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
	          <button type="submit" class="btn btn-success">Submit</button> 
          </div>
        </div>
        </form>
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

<!-- Modal -->
<div class="modal fade" id="estimateCancelModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header bg-info">
        <h5 class="modal-title w-90" id="estimateCancelLabel"></h5>
        <button type="button" class="closeBox btn-info" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body" id="estimateCancelBody">
       <div class="box">
		<p>Order is cancelled from vendor side because he was ordering his product from onw sitde by the product of the suywevh.</p>
		<div class="box-patch">
		    <span class="bg-danger">Cancelled</span>
		    <span class="bg-info">08-10-2022</span></div>
	    </div>
	    <div class="box">
		<p>Order is cancelled from vendor side because he was ordering his product from onw sitde by the product of the suywevh.</p>
		<div class="box-patch">
		    <span class="bg-primary">Draft</span>
		    <span class="bg-info">10-10-2022</span></div>
	    </div>
      </div>
    </div>
  </div>
</div>
<div class="modal fade" id="consultingServiceModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header bg-info">
        <h5 class="modal-title w-90"><i class="fas fa-user" aria-hidden="true"></i>Consulting Service Details</h5>
        <button type="button" class="closeBox btn-info" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body" style="min-height: 128px;" id="consultingServiceBody">
       
      </div>
    </div>
  </div>
</div>
<input type="hidden" id="ManageSalesDivId">
<input type="hidden" id="ManageSalesCompAddress">
<input type="hidden" id="ConvertSalesRefKey">
<input type="hidden" id="SendEmailClientEmail"/>
<input type="hidden" id="SendEmailClientName"/>
<input type="hidden" id="ConvertInvoiceContactrefid"/> 
<input type="hidden" id="ConvertInvoiceClientrefid"/>
<input type="hidden" id="ConvertInvoiceSaleNo"/>
<input type="hidden" id="SalePriceWithoutGst" value="0"/>
<input type="hidden" id="SaleGstAmount" value="0"/>
<div class="noDisplay"><a href="" id="DownloadExportedLink" download><button id="DownloadExported">Download</button></a></div> 
 <div class="noDisplay"><a href="<%=azure_path %>invoices.pdf" download><button id="DownloadExportedInvoices">Download</button></a></div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/jspdf.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/html2pdf.bundle.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/converttopdf.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/ckeditor/ckeditor.js"></script>
<script type="text/javascript">
function openReceipt(mainfolder,docname){
	if(docname.toLowerCase()=="na"){
		$("#warningDocument").modal("show");
	}else{	window.open(mainfolder+docname);}
}

function isValidAmount(){
	var dueAmt=$("#TotalDueAmountId").html();
	var tranAmt=$("#Amount").val();
	if(Number(tranAmt)>Number(dueAmt)){
		$("#Amount").val('');
		document.getElementById('errorMsg').innerHTML ="Maximum amount should be  "+dueAmt;
		$('.alert-show').show().delay(4000).fadeOut();
	}
	
}
function setMode(value){
	if(value=="Cash"){
	$("#TransactionId").val("NA");
	$("#TransactionId").prop("readonly",true);
	}else{
		$("#TransactionId").val("");
		$("#TransactionId").prop("readonly",false);
	}
}
function validateSendUserLogin(){
	let loginLength=Number($("#allUserLogin").val());
	let count=0;
	var data=[];
	for(let i=0;i<=loginLength;i++){		
		let uaid=$("#loginUaid"+i).val();
		let name=$("#loginName"+i).val()
		let email=$("#loginEmail"+i).val()
		if (typeof uaid !="undefined"&&typeof email!="undefined"&&typeof name!="undefined"){
			if(name.length != 0) {
			   count=Number(count)+1;
			   if(name==null||name==""){
				    document.getElementById('errorMsg').innerHTML ="Name is mandatory.";
					$('.alert-show').show().delay(4000).fadeOut();
					return false;
			   }
			}
			if(email.length != 0) {
			   count=Number(count)+1; 
			   if(email==null||email==""){
				    document.getElementById('errorMsg').innerHTML ="Email is mandatory.";
					$('.alert-show').show().delay(4000).fadeOut();
					return false;
			   }
			}
			
			data.push(uaid+"#"+email);
		}
	}
	if(count==0){
		document.getElementById('errorMsg').innerHTML ="Minimum one record is required.";
		$('.alert-show').show().delay(4000).fadeOut();
		$("#sendLoginCredentials").modal("hide");
		return false;		
	}
// 	console.log(data);
	sendLoginCredentials(data); 
}
function validateUpdateContact(){

	if(document.getElementById("UpdateContactFirstName").value.trim()==""){
		document.getElementById('errorMsg').innerHTML ="First name is mandatory.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(document.getElementById("UpdateContactLastName").value.trim()==""){
		document.getElementById('errorMsg').innerHTML ="Last name is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(document.getElementById("UpdateContactEmail_Id").value.trim()==""){
		document.getElementById('errorMsg').innerHTML ="Email is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(document.getElementById("UpdateContactEmailId2").value.trim()==""){
		document.getElementById("UpdateContactEmailId2").value="NA";
	}
	if(document.getElementById("UpdateContPan").value.trim()==""){
		document.getElementById("UpdateContPan").value="NA";
	}
	
	if(document.getElementById("UpdateContactWorkPhone").value.trim()==""){
		document.getElementById('errorMsg').innerHTML ="Work phone is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(document.getElementById("UpdateContactMobilePhone").value.trim()==""){
		document.getElementById("UpdateContactMobilePhone").value="NA";
	}
	
	if($('#UpdateContactperAddress').prop('checked')){
		if(document.getElementById("UpdateContCountry").value.trim()==""){
			document.getElementById('errorMsg').innerHTML ="Country is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		
		if(document.getElementById("UpdateContCity").value.trim()==""){
			document.getElementById('errorMsg').innerHTML ="City is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if(document.getElementById("UpdateContState").value.trim()==""){
			document.getElementById('errorMsg').innerHTML ="State is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if(document.getElementById("UpdateContAddress").value.trim()==""){
			document.getElementById('errorMsg').innerHTML ="Address is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
	}
	var firstname=document.getElementById("UpdateContactFirstName").value.trim();
	var lastname=document.getElementById("UpdateContactLastName").value.trim();
	var email=document.getElementById("UpdateContactEmail_Id").value.trim();
	var email2=document.getElementById("UpdateContactEmailId2").value.trim();
	var workphone=document.getElementById("UpdateContactWorkPhone").value.trim();
	var mobile=document.getElementById("UpdateContactMobilePhone").value.trim();
	var pan=document.getElementById("UpdateContPan").value.trim();
	var country="NA";
    var city="NA";
    var state="NA";
    var stateCode="NA";
    var address="NA";
    var companyaddress="NA";
    var addresstype="Personal";
    if($('#UpdateContactperAddress').prop('checked')){
    	country=document.getElementById("UpdateContCountry").value;
    	var x=country.split("#");
    	country=x[1];
    	state=document.getElementById("UpdateContState").value;
    	x=state.split("#");
    	stateCode=x[1];
    	state=x[2];
    	city=document.getElementById("UpdateContCity").value;    	
    	address=document.getElementById("UpdateContAddress").value.trim();    	
    }
    if($('#UpdateContactcomAddress').prop('checked')){
		companyaddress=document.getElementById("UpdateEnqCompAddress").value.trim();
		addresstype="Company";
    }
   
   var contkey=document.getElementById("UpdateContactKey").value.trim(); 
   var stbid=document.getElementById("UpdateContactSalesKey").value.trim(); 
   showLoader();
   $("#ValidateUpdateContact").attr("disabled","disabled");    
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
			country : country,
			pan : pan,
			stateCode : stateCode
		},
		success : function(data){
			$("#ValidateUpdateContact").removeAttr("disabled");
			if(data=="pass"){				
				 $('#FormUpdateContactBox').trigger("reset");
				$('.fixed_right_box').removeClass('active');
				$('.addnew').show();
				
				updateSalesContact(stbid,firstname,lastname,email,email2,workphone,mobile);
								
			}else if(data=="invalid"){
				document.getElementById('errorMsg').innerHTML = 'Please enter a valid email-address !!';
				$('.alert-show').show().delay(4000).fadeOut();
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
function updateSalesContact(stbid,firstname,lastname,email,email2,workphone,mobile,salesKey){
	var salesKey=$("#ContactSalesKey").val();
	showLoader();
	$.ajax({
		type : "POST",
		url : "UpdateSalesContactDetails111",
		dataType : "HTML",
		data : {	
			stbid : stbid,
			firstname : firstname,
			lastname : lastname,
			email : email,
			email2 : email2,
			workphone : workphone,
			mobile : mobile,
			salesKey : salesKey
		},
		success : function(data){
			if(data=="pass"){
				
				var rowid=document.getElementById("ManageSalesDivId").value;
				$("#"+rowid).load("manage-enquiry.html #"+rowid);				
				
				document.getElementById('errorMsg1').innerHTML = 'Successfully Updated !!';				  
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

function isUpdateDuplicateMobilePhone(phoneid){
	var contkey=document.getElementById("UpdateContactKey").value.trim();
	var val=document.getElementById(phoneid).value.trim();
	if(val!=""&&val!="NA")
	$.ajax({
		type : "POST",
		url : "ExistEditValue111",
		dataType : "HTML",
		data : {"val":val,"field":"updatecontactmobilephone","id":contkey},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg").innerHTML="Duplicate Mobile Phone.";
			document.getElementById(phoneid).value="";
			$('.alert-show').show().delay(4000).fadeOut();
			}
			
		}
	});
	$("#"+phoneid).val(val.replace(/ /g,''));
}
function isUpdateDuplicateEmail(emailid){
	var contkey=document.getElementById("UpdateContactKey").value.trim();
	var val=document.getElementById(emailid).value.trim();
	if(val!=""&&val!="NA")
	$.ajax({
		type : "POST",
		url : "ExistEditValue111",
		dataType : "HTML",
		data : {"val":val,"field":"updatecontactemail","id":contkey},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg").innerHTML="Duplicate Email-Id.";
			document.getElementById(emailid).value="";
			$('.alert-show').show().delay(4000).fadeOut();
			}
			
		}
	});
}

function validatePayment(event){	
	var pymtforrefid=document.getElementById("WhichPaymentFor").value.trim();
	var pymtmode=document.getElementById("PaymentMode").value.trim();
	var pymtdate=document.getElementById("PaymentDate").value.trim();
	var pymttransid=document.getElementById("TransactionId").value.trim();
	var remarks=$("#remarks").val().trim();
	var invoice=$('#SalesInvoiceNo').val();
	let serviceQty=$("#serviceQty").val();
	var service_Name=$("#Service_Name").val();
	var professional_Fee=$("#Professional_Fee").val();
	var government_Fee=$("#Government_Fee").val();
	var service_Charges=$("#service_Charges").val();
	var other_Fee=$("#Other_Fee").val();
	var other_Fee_remark=$("#Other_Fee_remark").val();
	
	if(professional_Fee==null||professional_Fee=="")professional_Fee=0;
	if(government_Fee==null||government_Fee=="")government_Fee=0;
	if(service_Charges==null||service_Charges=="")service_Charges=0;
	if(other_Fee==null||other_Fee=="")other_Fee=0;	
	
	var txnAmount=Number(professional_Fee)+Number(government_Fee)+Number(service_Charges)+Number(other_Fee);
		
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
		document.getElementById('errorMsg').innerHTML ="Enter Remark !!.";
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
      
       var orderAmount=$("#TotalOrderAmountId").html();
       var salesno=$("#SalesEstimatenoNo").val();
       
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
			           url: "ManageRegisterPayment111",
			           data: data,
			           processData: false,
			           contentType: false,
			           cache: false,
			           timeout: 600000,
			           success: function (data) {
			        	   if(data=="pass"){
				        	   $("#UploadFormdata").trigger('reset');               
				               $("#btnSubmit").prop("disabled", false);
				               document.getElementById('errorMsg1').innerHTML ="Successfully payment added.";
				       		   $('.alert-show1').show().delay(4000).fadeOut();
				       		showAllPayment(invoice);
				       		   
			        	   }else{
			        		   document.getElementById('errorMsg').innerHTML ="Something Went Wrong, Try-Again later.";
				       		   $('.alert-show').show().delay(4000).fadeOut();
			        	   }
			
			           },
			           error: function (e) {
			               $("#btnSubmit").prop("disabled", false);
			
			           }
			       });	
   		}else{
			document.getElementById('errorMsg').innerHTML ="You don't have permission to add more than sales amount.";
    		$('.alert-show').show().delay(4000).fadeOut();
		}
		},
		complete : function(msg) {
            hideLoader();
        }
      	});
      	
}


function setRefName(sref,name){
	document.getElementById("URLSREF").value=sref;
	document.getElementById("URLNAME").value=name;
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

$( function() {
	$( ".datepick" ).datepicker({
	changeMonth: true,
	changeYear: true,
	yearRange: '-60: -0',
	dateFormat: 'yy-mm-dd'
	});
	} );
</script>
<script type="text/javascript">
function isExistEditGST(valueid){
	var val=document.getElementById(valueid).value.trim();
	var key=document.getElementById("UpdateCompanyKey").value.trim();
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

function isExistEditPan(valueid){
	var val=document.getElementById(valueid).value.trim();
	var key=document.getElementById("UpdateCompanyKey").value.trim();
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

$(function() {
	$("#etype").autocomplete({
		source : function(request, response) {
			if(document.getElementById('etype').value.trim().length>=1)
			$.ajax({
				url : "get-enquiry.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field: "mngeenq",
					attribute:"enqType"
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
		change: function (event, ui) {
            if(!ui.item){    
            	etypeerr.innerHTML = 'Select from List';
            	etypeerr.style.color="red";
            	document.getElementById("etype").value = "";
            	  			
            }
            else{
            	document.getElementById("etype").value = ui.item.value;
            		
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

$(function() {
	$("#Industry").autocomplete({
		source : function(request, response) {
			if(document.getElementById('Industry').value.trim().length>=1)
			$.ajax({
				url : "get-enquiry.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field: "mngeenq",
					attribute:"enqIndustry"
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
		change: function (event, ui) {
            if(!ui.item){    
            	Industryerr.innerHTML = 'Select from List';
            	Industryerr.style.color="red";
            	document.getElementById("Industry").value = "";
            	  			
            }
            else{
            	document.getElementById("Industry").value = ui.item.value;
            		
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});


$(function() {
	$("#location").autocomplete({
		source : function(request, response) {
			if(document.getElementById('location').value.trim().length>=1)
			$.ajax({
				url : "get-enquiry.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field: "mngeenq",
					attribute:"enqCity"
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
		change: function (event, ui) {
            if(!ui.item){    
            	locationerr.innerHTML = 'Select from List';
            	locationerr.style.color="red";
            	document.getElementById("location").value = "";
            	  			
            }
            else{
            	document.getElementById("location").value = ui.item.value;
            		
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

$(function() {
	$("#mobile").autocomplete({
		source : function(request, response) {
			if(document.getElementById('mobile').value.trim().length>=1)
			$.ajax({
				url : "get-enquiry.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field: "mngeenq",
					attribute:"enqMob"
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
		change: function (event, ui) {
            if(!ui.item){    
            	mobileerr.innerHTML = 'Select from List';
            	mobileerr.style.color="red";
            	document.getElementById("mobile").value = "";
            	  			
            }
            else{
            	document.getElementById("mobile").value = ui.item.value;
            		
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});


$(function() {
	$("#name").autocomplete({
		source : function(request, response) {
			if(document.getElementById('name').value.trim().length>=1)
			$.ajax({
				url : "get-enquiry.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field: "mngeenq",
					attribute:"enqName"
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
		change: function (event, ui) {
            if(!ui.item){    
            	nameerr.innerHTML = 'Select from List';
            	nameerr.style.color="red";
            	document.getElementById("name").value = "";
            	  			
            }
            else{
            	document.getElementById("name").value = ui.item.value;
            		
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});



</script>


<script type="text/javascript">
$(".fancybox").fancybox({
    'width'             : '100%',
    'height'            : '100%',
    'autoScale'         : false,
    'transitionIn'      : 'none',
    'transitionOut'     : 'none',
    'type'              : 'iframe',
    'hideOnOverlayClick': false,
    afterClose: function () {    
    	parent.location.reload(true);
    }
});
// $(".fancybox").fancybox({
//     type: 'iframe',
//     afterClose: function () { // USE THIS IT IS YOUR ANSWER THE KEY WORD IS "afterClose"
//         parent.location.reload(true);
//     }
// });
function enableDisableDelete(id){
	$.ajax({
		type : "POST",
		url : "GetEnqStatus111",
		dataType : "HTML",
		data : {"id":id},
		success : function(data){
			if(data=="pass"){	
				document.getElementById("cancelpopup1").disabled = true;
			}else{
				document.getElementById("cancelpopup1").disabled = false;
			}
		}
	});
}
function manage(click, id) {
	document.getElementById("enquid").innerHTML=id;
var xhttp;
xhttp = new XMLHttpRequest();
xhttp.open("GET", "<%=request.getContextPath()%>/HistoryEnquiry111?info="+id+"&click="+click, true);
xhttp.send();
}
//
function deleteEnq(id,rowid){
	var xhttp; 
		xhttp = new XMLHttpRequest();
		xhttp.onreadystatechange = function() {
		if (this.readyState == 4 && this.status == 200) {
			$("#"+rowid).load("manage-enquiry.html #"+rowid);
		}
		};
		xhttp.open("GET", "<%=request.getContextPath()%>/DeleteEnquiry111?info="+id, true);
		xhttp.send(id);
}
//
// function deleteEnq(id) {

// var xhttp;
// xhttp = new XMLHttpRequest();
// xhttp.onreadystatechange = function() {
// if (this.readyState == 4 && this.status == 200) {
// 	$("#target").load(location.href + " #target");
// // location.reload();
// }
// };
<%-- xhttp.open("GET", "<%=request.getContextPath()%>/DeleteEnquiry111?info="+id, true); --%>
// xhttp.send();

// }
function RefineSearchenquiry() {
document.RefineSearchenqu.jsstype.value="SSEqury";

document.RefineSearchenqu.action="<%=request.getContextPath()%>/manage-enquiry.html";
document.RefineSearchenqu.submit();
}
</script>
<script type="text/javascript">
// var counter=25;
// $(window).scroll(function () {
// if ($(window).scrollTop() == $(document).height() - $(window).height()) {
// appendData();
// }
// });

// function appendData() {
// var html = '';
// if(document.getElementById("end").innerHTML=="End") return false;
// $.ajax({
// type: "POST",
<%-- url: '<%=request.getContextPath()%>/getmorenquiry', --%>
// datatype : "json",
// data: {
// counter:counter,
<%-- name:'<%=name%>', --%>
<%-- mobile:'<%=mobile%>', --%>
<%-- location:'<%=location%>', --%>
<%-- status:'<%=status%>', --%>
<%-- etype:'<%=etype%>', --%>
<%-- from:'<%=from%>', --%>
<%-- to:'<%=to%>' --%>
// },
// success: function(data){
// for(i=0;i<data[0].moreenq.length;i++)
<%-- html += '<div class="row"><div class="col-md-12 col-sm-12 col-xs-12"><div class="clearfix"><div class="box-width2 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].moreenq[i][0]+'</p></div></div><div class="box-width7 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].moreenq[i][1]+'</p></div></div><div class="box-width7 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].moreenq[i][2]+'</p></div></div><div class="box-width12 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].moreenq[i][3]+'</p></div></div><div class="box-width14 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].moreenq[i][4]+'</p></div></div><div class="box-width5 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].moreenq[i][6]+'</p></div></div><div class="box-width13 col-xs-1 box-intro-background"><div class="link-style12"><p class="clearfix"><% if (EM01){%><a href="javascript:void(0);" onclick="manage(\'View\','+data[0].moreenq[i][5]+');vieweditpage('+data[0].moreenq[i][5]+',\'view\');">View</a><%}%><% if (EM02){%><a href="javascript:void(0);" onclick="manage(\'Follow Up\','+data[0].moreenq[i][5]+');vieweditpage('+data[0].moreenq[i][5]+',\'follow\');">Follow Up</a><%}%><% if (EM03){%><a href="javascript:void(0);" onclick="manage(\'Edit\','+data[0].moreenq[i][5]+');vieweditpage('+data[0].moreenq[i][5]+',\'edit\');">Edit</a><%}%><% if(EM04){%><a href="javascript:void(0);" onclick="manage(\'Delete\','+data[0].moreenq[i][5]+');deleteEnq('+data[0].moreenq[i][5]+');">Delete</a><%}%></p></div></div></div></div></div>'; --%>
// if(html!='') $('#target').append(html);
// else document.getElementById("end").innerHTML = "End";
// },
// error: function(error){
// console.log(error.responseText);
// }
// });
// counter=counter+25;
// }
</script>
<script type="text/javascript">	
	$('#cancelpopup').click(function(){
		  $.fancybox.close();
	});
</script>
<script type="text/javascript">	
	$('#cancelpopup1').click(function(){
		  $.fancybox.close();
	});
</script>
<script type="text/javascript">
function vieweditpage(id,page){
if(page=="follow"){ 
	var sref=document.getElementById("URLSREF").value;
	var name=document.getElementById("URLNAME").value;
	var x="?sref="+sref;
	window.location = "<%=request.getContextPath()%>/follow-up-sales.html"+x;
	}
if(page=="edit") window.location = "<%=request.getContextPath()%>/edit-enquiry.html";

}
</script>

<script>
$('.addnew').on( "click", function(e) {
e.preventDefault();
var id = $(this).attr('data-related'); 
$(this).hide();
$('.fixed_right_box').addClass('active');
    $("div.add_inner_box").each(function(){
        $(this).hide();
        if($(this).attr('id') == id) {
            $(this).show();
        }
    });	
});
$('.close_box').on( "click", function(e) { 
$('.fixed_right_box').removeClass('active');
$('.addnew').show();	
});
$('.del_icon').on( "click", function(e) {
$('.new_field').hide();	
});
$('.add_new').on( "click", function(e) {
$(this).parent().next().show();	
});
$('#comAddress').on( "click", function(e) {
$('.address_box').hide();
$('.company_box').show();	
});
$('#perAddress').on( "click", function(e) {
$('.address_box').show();
$('.company_box').hide();	
});
$('.contact_add').on( "click", function(e) {
	$('.contact_box').show();
});
$('.new_con_add').on( "click", function(e) {
	$('.contact_box').hide();
});
// $('.list_action_box').hover(function(){
// 	$(this).children().next().toggleClass("show");
// });
function showActionMenu(id){
	$('#'+id).addClass("show");
}
function hideActionMenu(id){
	$('#'+id).removeClass("show");
}
$('body').click(function() {
	$('.name_action_box').removeClass("active");
// 	$('.dropdown_list').removeClass("show");
});

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

// $('.name_action_box i').on( "click", function(event) {
// 	event.stopPropagation();
// 	$('.name_action_box').removeClass("active");
// 	$('.dropdown_list').removeClass("show");
// 	$(this).parent().addClass("active");
// 	$(this).parent().next().addClass("show");
// });
// $('.name_action_box i.fa-minus').on( "click", function(event) {
// 	event.stopPropagation();
// 	$('.name_action_box').removeClass("active");
// 	$('.dropdown_list').removeClass("show");
// });

function openPaymentBox(salesno,estimateno,salesrefid,projectno,orderAmount,DueAmount){
	if(Number(DueAmount)==0){$("#UploadFormdata").hide();}else{$("#UploadFormdata").show();}
	document.getElementById("PayHead").innerHTML=salesno; 
	$("#TotalOrderAmountId").html(orderAmount);
	$("#TotalDueAmountId").html(DueAmount);
	$("#SalesInvoiceNo").val(salesno);
	$("#SalesEstimatenoNo").val(estimateno);
	$("#WhichPaymentFor").val(salesrefid);
	getPayType(estimateno);
	getOrderAndDueAmount(estimateno);
	setTotalSalesService(estimateno);
	var id = $(".addnew2").attr('data-related'); 
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();	        
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });	
	   showAllPayment(salesno);
	$("#TransactionId").focus();
}
function showAllPayment(invoice){
	
	$('.RegisteredPayment').remove();
	showLoader();
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
		 
		for(var i=0;i<len;i++){		
			var key = response[i]['prefid'];
			var date = response[i]['date'];
			var amount = response[i]['transacamount'];
			var docname = response[i]['docname'];
			var approvedate = response[i]['approvedate'];
			var approveby = response[i]['approveby'];
			var transtatus = response[i]['transtatus'];
			var invoicestatus=response[i]['invoicestatus'];
			var invoiceuuid=response[i]['invoiceuuid'];
			var paymode=response[i]['paymode'];
			var pstatus="Processing";
			var color="#42b0da";
			
			var path="<%=azure_path%>";
			var path1="<%=domain%>";
			var filecolor="#dc3333";
			if(docname!="NA")filecolor="#42b7e4";
			
			var btn="btn-secondary";
			var btnname="Estimate";
			
			if(Number(invoicestatus)==1){
				btn="btn-primary";
				btnname="Invoice";
			}
			
			if(transtatus=="1"){
				pstatus="Approved";color="#29ba29";
			}else if(transtatus=="3"){
				pstatus="Declined";color="red";
			}else if(transtatus=="4"){
				pstatus="On-Hold";color="grey";
			}
			
			let invoiceOpen='<a href="javascript:void(0)" onclick="openSlip(\''+path1+'\',\''+key+'\',\''+transtatus+'\',\''+invoicestatus+'\',\''+invoiceuuid+'\')"><button class="btn '+btn+'">'+btnname+'</button></a>';
			if(paymode=="PO")
				invoiceOpen='PO';
			
			$(''+
					'<tr class="RegisteredPayment">'+
			   '<td>'+date+'</td>'+
			   '<td style="color:'+color+';">'+pstatus+'</td>'+
			   '<td><i class="fa fa-inr"></i>&nbsp; '+amount+'</td>'+
			   '<td style="font-size: 16px;color: '+filecolor+';" onclick="openReceipt(\''+path+'\',\''+docname+'\')"><i class="fa fa-file-text-o pointers"></i></td>'+
			   '<td style="font-size: 16px;">'+invoiceOpen+'</td>'+
			'</tr>'
			
          ).insertBefore('#ReceivedPayment');
			
		}}
		},
		complete : function(data){
			hideLoader();
		}
	});
}
function openSlip(path,key,status,invoiceStatus,uuid){
	if(status=="1"){
		if(Number(invoiceStatus)==1)
			window.open(path+"final-invoice-"+uuid+".html");
		else
			window.open(path+"slip-"+key+".html");
		
	}else if(status=="2"){
		$("#WarningText").html("Payment is awating for approval.!!")
		$("#warningPayment").modal("show");
	}else if(status=="4"){
		$("#WarningText").html("Payment is on-hold.!!")
		$("#warningPayment").modal("show");
	}else{
		$("#WarningText").html("Payment is declined.!!")
		$("#warningPayment").modal("show");
	}
}
function openDocumentBox(salesno,salesrefid){	
	$("#ActiveDocSalesKey").val(salesrefid);
	document.getElementById("DocHead").innerHTML=salesno;
	fillDocumentList(salesrefid);
	var id = $(".adddoc").attr('data-related'); 
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });	
}

function openMilestonePay(){
	var id = $(".mpay").attr('data-related'); 
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });
}

function openTaskNotesBox(salesKey,productName,contactKey){
	$("#taskActiveSalesKey").val(salesKey);
	$("#taskNotesProduct").html(productName);
	$("#taskActiveContactKey").val(contactKey);
	fillSalesTaskKey(salesKey);
	fillSalesAssignedUser(salesKey);
	var id = $(".notes").attr('data-related'); 
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });	
}
function fillSalesAssignedUser(salesKey){
	$("#userInChat").empty();
	$.ajax({
		type : "POST",
		url : "GetSalesUser111",
		dataType : "HTML",
		data : {				
			salesKey : salesKey
		},
		success : function(response){	
			$("#userInChat").append(response);
		},
		complete : function(data){
			hideLoader();
		}
	});
}
function fillSalesTaskKey(salesKey){
	$(".contentInnerBox").remove();
	showLoader();
	$.ajax({
		type : "GET",
		url : "GetSalesTaskNotes111",
		dataType : "HTML",
		data : {				
			salesKey : salesKey
		},
		success : function(response){	
		if(Object.keys(response).length!=0){
		response = JSON.parse(response);			
		 var len = response.length;	
		 
		 if(len>0){
			 for(var i=0;i<Number(len);i++){	
				 var type=response[i]["type"];
				 var addedby=response[i]["addedby"];
			 	 var time=response[i]["time"];
				 var description=response[i]["description"];
				
				 var content='<div class="contentInnerBox box_shadow1 relative_box mb10 mtop10">'
						+'<div class="sms_head note_box">'
						+'<div class="note_box_inner">'
						+''+description+''
						+'</div>'
						+'<span class="icon_box1 text-center" title="'+addedby+'">'+addedby.substring(0,2)+'</span>'
						+'</div>'	
						+'<div class="sms_title">' 
						+'<label class="pad-rt10"><img src="/corpseedhrm/staticresources/images/long_arrow_down.png" alt="">&nbsp; Notes Written</label>'  
						+'<span class="gray_txt bdr_bt pad-rt10">'+time+'</span>'
						+'</div>'
						+'</div>';				 
				 if(type=="Team"){
				 $(".communication_history").append(content);
				 }else{
					 $(".cmhistscrollInternal").append(content);
				 }
			}
			  $(".cmhistscroll").scrollTop($(".cmhistscroll")[0].scrollHeight);
		 }
		}},
		complete : function(data){
			hideLoader();
		}
	});
}
function openTaskHistoryBox(salesno,productType,salesrefid){
	document.getElementById("TaskHead").innerHTML="Milestones : "+salesno;
	var id = $(".taskhis").attr('data-related'); 
	$(".milestoneSidClass").remove();	
	fillMilestones(productType,salesrefid);
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });	
}
function fillMilestones(productType,salesrefid){
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetAllSalesMilestoneList111",
		dataType : "HTML",
		data : {				
			salesrefid : salesrefid,
			name : "NA",
		},
		success : function(response){	
		if(Object.keys(response).length!=0){
		response = JSON.parse(response);			
		 var len = response.length;		
		 if(len>0){
			 for(var i=0;i<Number(len);i++){	
				var assignkey=response[i]["assignkey"];
			 	var milestonekey=response[i]["milestonerefid"];
				var name=response[i]["name"];
				var memberid=response[i]["memberid"];
				var memberName=response[i]["memberName"];
				var memberassigndate=response[i]["memberassigndate"];
				var aassignDate=response[i]["aassignDate"];				
				var childTeamKey=response[i]["childTeamKey"];
				var massignDate=response[i]["massignDate"];
				var workPercent=response[i]["workPercent"];
				var workStatus=response[i]["workStatus"];
				var progressStatus=response[i]["progressStatus"];
				var progressColor="";
				if(progressStatus=="1")progressColor="red";
				else if(progressStatus=="2")progressColor="green";
				else if(progressStatus=="3")progressColor="blue";
				
				var milestone_view = "milestone_view"+i;
				var color="color:black;"
				if(workPercent>0)color="";
				$(''+	
				'<div class="row milestoneSidClass">'+
	            '<div class="col-md-12">'+
	              '<div class="order-progress-box">'+
	                '<div class="row order_view pointers" id="'+milestone_view+'">'+
	                  '<div class="col-md-6 col-sm-6 col-12 p-0">'+
	                    '<div class="order-details">'+
	                      '<p><strong>'+name+':</strong></p> '+
	              
	                      '<p><span style="color:'+progressColor+';">'+productType+'</span></p>'+
	                    '</div>'+
	                  '</div>'+
	                  '<div class="col-md-6 col-sm-6 col-12">'+
	                    <!-- Progress bar 1 -->
	                    '<div class="progress clearfix mt-3">'+
	                      '<div class="progress-bar" style="width:'+workPercent+'%;'+color+'">'+workPercent+'%</div>'+
	                    '</div>	'+				
	                  '</div>  '+                
	                '</div>'+
					'<div class="clearfix" style="display: none;">'+
					'<div class="row">'+
					  '<div class="col-md-12 col-sm-12 col-12">'+
	                    '<div class="order_details">'+
	                      '<p>'+
						  '<span><i class="fas fa-clipboard-check" aria-hidden="true"></i><span>Milestone<span style="color:#42c1ea;margin: 0px 5px 0px -10px;">'+name+'</span> created on '+aassignDate+'. !!</span></span>'+ 
	                      '<span></span>'+
						  '</p>'+
						  '<p>'+
						  '<span><i class="fas fa-clipboard-check" aria-hidden="true"></i><span><span style="color:#42c1ea;margin: 0px 5px 0px -14px;">'+name+'</span> assign on '+massignDate+'. !!</span></span>'+
	                      '<span></span>'+
						  '</p>'+
						  '<p>'+
						  '<span><i class="fas fa-clipboard-check" aria-hidden="true"></i><span><span style="color:#42c1ea;margin: 0px 5px 0px -14px;">'+workPercent+'%</span>  task completed. !!</span></span>'+
	                      '<span></span> '+
						  '</p>'+
	                    '</div>'+
	                  '</div>'+
					'</div>'+
					'<div class="row">'+
					  '<div class="col-md-6 col-sm-6 col-12">  '+
	                    '<div class="order-date">'+
	                      '<p>'+
						  '<span><strong>Status:</strong> <a class="pointers status_view">'+workStatus+'</a></span>'+
						  '</p>'+
	                    '</div>'+
	                  '</div>'+
					  '<div class="col-md-6 col-sm-6 col-12">'+
					  '<div class="order_amount text-right">'+
					    '<p><strong>Assignee:</strong><span class="amount"><strong class="pl-4">'+memberName+'</strong></span></p>'+ 
					  '</div>'+
					  '</div>'+
					'</div>'+
					'</div>'+
	              '</div>'+
	            '</div>'+
	          '</div>').insertBefore("#MilestonesAppendId");	
				$('#'+milestone_view).click(function(){
				    $(this).next().slideToggle();
				});
			}
		 }
		}else{
			$('<div class="text-center text-danger noDataFound milestoneSidClass">Project Not Assigned..</div>').insertBefore("#MilestonesAppendId");
		}},
		complete : function(data){
			hideLoader();
		}
	});
}
function openCompanyBox(comprefid){
// 	document.getElementById("InvoiceHead").innerHTML="Task History Of Sales Id : "+salesno;
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
function fillDocumentList(salesrefid){
	showLoader();
	$(".documentListCl").remove();
	$.ajax({
		type : "POST",
		url : "GetDocumentListByRefid111",
		dataType : "HTML",
		data : {				
			salesrefid : salesrefid
		},
		success : function(response){	
			if(Object.keys(response).length!=0){
		response = JSON.parse(response);			
		 var len = response.length;		 
		 if(len>0){ 	
			 for(var i=0;i<Number(len);i++){
				var refid=response[i]["refid"];
				var uploaddocname=response[i]["uploaddocname"];
				var description=response[i]["description"];
				var uploadby=response[i]["uploadby"];
				var uploaddoc=response[i]["uploaddoc"];
				var uploaddate=response[i]["uploaddate"];
				var fileInput="fileInputDoc"+(i+1);
				var docdate="docuploadeddate"+(i+1);
				var iconid="docuploadeIcon"+(i+1);
				var DownloadDocNameId="DownloadDocNameId"+(i+1);
				var icon="fa fa-times-circle-o";
				var color="#e11010;";
				if(uploaddoc!=null&&uploaddoc!="NA"){
					icon="fa fa-check-circle-o";
					color="#29ba29;";
				}
				var home="<%=azure_path%>";
				var downloadDoc="";
				if(uploaddoc!=null&&uploaddoc!="NA")
					downloadDoc='<span><a style="font-size: 14px;color: #50b5dc;" href="'+home+''+uploaddoc+'" download><i class="fas fa-arrow-down pointers" title="Download"></i></a></span>';
				
				$(''+
						'<div class="clearfix documentListCl">'+
				'<div class="clearfix bg_wht">'+
				'<div class="box-width25 col-xs-1 box-intro-background">'+
					'<div class="clearfix">'+
						'<p class="news-border '+icon+'" id="'+iconid+'" style="font-size: 20px;color: '+color+'" title="Not Uploaded"></p>'+
					'</div>'+
				'</div>'+
				   '<div class="col-xs-3 box-intro-background">'+
				       '<div class="clearfix">'+
				       '<p class="news-border" id="'+docdate+'">'+uploaddate+'</p>'+
				      ' </div>'+
				  ' </div>'+
				   '<div class="col-xs-7 box-intro-background box-width53">'+
				       '<div class="clearfix">'+
				       '<p class="news-border" title="'+description+'">'+uploaddocname+'</p>'+
				       '</div>'+
				  ' </div>'+
				   '<div class="col-xs-2 box-intro-background">'+
				      ' <div class="clearfix">'+
				       '<p class="news-border">'+
				       '<input type="hidden" id="'+DownloadDocNameId+'" value="'+uploaddoc+'">'+
				       downloadDoc+''+			       
				      ' <span>'+
				       '<input id="'+fileInput+'" name="'+fileInput+'" type="file" onchange="uploadFile(\''+refid+'\',\''+fileInput+'\',\''+iconid+'\',\''+docdate+'\',\''+DownloadDocNameId+'\',\''+fileInput+'\')" style="display:none;" />'+
				       '<button onclick="openFileInput(\''+fileInput+'\');" style="border: none;background: #ffff;font-size: 14px;"><i class="fas fa-upload" title="Upload"></i></button>'+
				       '</span>'+
				       '</p>'+
				       '</div>'+
				   '</div> '+                                        
				'</div>'+
				'</div>').insertBefore("#DocumentListAppendId");				
			}
		 }
		}},
		complete : function(data){
			hideLoader();
		}
	});
	fillDocumentUploadHistory(salesrefid);
}

function fillDocumentUploadHistory(salesrefid){
	$(".docHistory").remove();
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetDocumenHistoryByKey111",
		dataType : "HTML",
		data : {				
			salesrefid : salesrefid
		},
		success : function(response){	
			if(Object.keys(response).length!=0){
		response = JSON.parse(response);			
		 var len = response.length;		
		 var role="<%=userRole%>";
		 if(len>0){ 	
			 for(var i=0;i<Number(len);i++){
				 var id=response[i]["id"];
				var date=response[i]["date"];
				var name=response[i]["name"];
				var type=response[i]["type"];
				var actionby=response[i]["actionby"];
				var exist=response[i]["exist"];
				var docName=response[i]["docName"];
				var remarks=name;
				if(type=="Upload")remarks+=" uploaded by "+actionby;
				else if(type=="Create")remarks+=" created by "+actionby;
				var action='<a href="#" data-toggle="modal" data-target="#PermissionNot"><i class="fas fa-arrow-down text-muted"></i></a>'+
				'<a href="#" data-toggle="modal" data-target="#PermissionNot"><i class="fas fa-trash text-muted"></i></a>';
				
				var docLink="<%=azure_path%>"+docName;
				
				if(Number(exist)==1 && role=="Admin"){
					action='<a id="Download'+id+'" href="'+docLink+'" download><i class="fas fa-arrow-down"></i></a>'+
					'<a href="#" id="Delete'+id+'" onclick="deleteDocument(\''+id+'\',\''+docName+'\')"><i class="fas fa-trash text-danger"></i></a>';
				}
				
				$(''+
					'<div class="clearfix bg_wht link-style12 docHistory">'+
					   '<div class="col-xs-2 box-intro-background">'+
					       '<div class="clearfix">'+
					       '<p class="news-border" id="'+date+'">'+date+'</p>'+
					       '</div>'+
					   '</div>'+
					   '<div class="col-xs-9 box-intro-background">'+
					       '<div class="clearfix">'+
					       '<p class="news-border" title="'+remarks+'">'+remarks+'</p>'+
					       '</div>'+
					   '</div>'+					   
					   '<div class="col-xs-1 box-intro-background">'+
					      '<div class="clearfix">'+
					       '<p class="news-border">'+action+'</p>'+
					       '</div>'+
					   '</div>'+                                         
					'</div>').insertBefore("#DocumentHistoryAppendId");				
			}
		 }
		}else{
			$('<div class="text-center text-danger noDataFound docHistory"> No. Data Found</div>').insertBefore("#DocumentHistoryAppendId");
		}},
		complete : function(data){
			hideLoader();
		}
	});
}

function downloadDocument(docnameId){
	var docname=$("#"+docnameId).val();	
	if(docname!=null&&docname!=""&&docname!="NA"){
		var url="DownloadDocument111?docname="+docname;
		window.location=url;
	}else{
		$("#warningDocument").modal("show");
	}
}
function uploadFile(docrefid,fileboxid,iconid,dateid,docnameId,fileId){
	const fi=document.getElementById(fileId);
	if (fi.files.length > 0) {
		const fsize = fi.files.item(0).size; 
        const file = Math.round((fsize / 1024)); 
        
        // The size of the file. 
        if (file >= 49152) {  
            document.getElementById('errorMsg').innerHTML ='File too Big, Max File Size 48 MB !!';
            document.getElementById(fileId).value="";
 		    $('.alert-show').show().delay(4000).fadeOut();
        }else{
        	uploadFile1(docrefid,fileboxid,iconid,dateid,docnameId);
        }	
	}	 
}
function uploadFile1(docrefid,fileboxid,iconid,dateid,docnameId){
	$("#Docrefid").val(docrefid);
	$("#DocfileInputBoxId").val(fileboxid);	
	var salesrefid=$("#ActiveDocSalesKey").val();
	var path=$("#"+fileboxid).val();
	var x=path.split(".");
	var len=x.length;	
	var i=Number(len)-1;

	var form = $(".upload-box")[0];
    var data = new FormData(form);
    showLoader();
	$.ajax({
        type : "POST",
        encType : "multipart/form-data",
        url : "<%=request.getContextPath()%>/UploadSalesDocumentList111",
        cache : false,
        processData : false,
        contentType : false,
        data : data,
        success : function(msg) {
        	if(msg=="success"){
        	document.getElementById('errorMsg1').innerHTML ="Uploaded";
        	<%-- $("#"+dateid).html("<%=today%>");
        	$("#"+iconid).removeClass('fa fa-times-circle-o').addClass('fa fa-check-circle-o');
        	$("#"+iconid).css({"color":"#29ba29"});
        	$("#"+docnameId).val($("#Docrefid").val()+"."+x[i]); --%>
    		$('.alert-show1').show().delay(3000).fadeOut();
    		fillDocumentList(salesrefid);
    		}else{
    			document.getElementById('errorMsg').innerHTML ="Something Went wrong ,try-again later !!";
	    		$('.alert-show').show().delay(3000).fadeOut();
    		}
        },
        error : function(msg) {
            alert("Couldn't upload file");
        },
		complete : function(data){
			hideLoader();
		}
    });
}
function openFileInput(InputId){
	$("#"+InputId).click();
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
			$("#UpdatePanNumber").val(pan);$("#Update_Super_User").val(superUserUaid).trigger('change');
			$("#Edit_Company_age").val(compAge);
			if(gst!=="NA"){
				$("#UpdateGSTNumber").val(gst);
				document.getElementById("CompanyGstDivId").style.display="block";
			}			
			$("#UpdateCity").empty();
			$("#UpdateCity").append("<option value='"+city+"' selected='selected'>"+city+"</option>");
			$("#UpdateState").empty();
			$("#UpdateState").append("<option value='0#"+stateCode+"#"+state+"' selected='selected'>"+state+"</option>");
			$("#UpdateCountry").val(country);
			$("#UpdateAddress").val(address);
			
		 }
		}},
		complete : function(data){
			hideLoader();
		}
	});
}

function openContactBox(contctref,cboxid,boxid,compaddressId,salesKey){
	$('#FormUpdateContactBox').trigger("reset");
	fillContactUpdateForm(contctref,cboxid);
	$("#ManageSalesDivId").val(boxid);
	$("#ContactSalesKey").val(salesKey);
	$("#ManageSalesCompAddress").val($("#"+compaddressId).val());
	var id = $(".contactbox").attr('data-related'); 
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });	
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
			
			$("#UpdateContactKey").val(contkey);$("#UpdateContactSalesKey").val(cboxid);$("#UpdateContactFirstName").val(firstname);$("#UpdateContactLastName").val(lastname);$("#UpdateContactEmail_Id").val(email1);
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
		}},
		complete : function(data){
			hideLoader();
		}
	});
}

function openInvoiceBox(invoice,companyname,contactrefid,clientrefid,salesKey,clientEmail,
		clientName,companyAdressId,companyState,companyStateCode,dueAmount,discount,
		orderAmount,clientGst,notesId,orderNo,purchaseDate){
	showLoader();
	
	$("#SalePriceWithoutGst").val("0");
	$("#SaleGstAmount").val("0");
	
	if(orderNo!=null&&orderNo!="NA"&&orderNo!=""){$("#orderNo").html("#"+orderNo);$("#orderNoMain").show();
	}else $("#orderNoMain").hide();
	
	if(purchaseDate!=null&&purchaseDate!="NA"&&purchaseDate!=""){$("#PurchaseDate").html(purchaseDate);$("#purchaseDateMain").show();
	}else $("#purchaseDateMain").hide();
	
	$("#InvoiceBillNo").html("#"+invoice);
	$("#ConvertInvoiceSaleNo").val(invoice);
	if(companyname!=null&&companyname!="...."&&companyname!="NA"&&companyname!="")
		$("#BillToId").html(companyname);
	else
		fillContactDetails(contactrefid);
	
	var invoiceNotes=$("#"+notesId).val();
	if(invoiceNotes!=null&&invoiceNotes!="NA")
		$("#invoiceNotes").html(invoiceNotes);
	
	if(clientGst==null||clientGst=="NA"||clientGst=="")$("#BillToGSTINId").hide();
	else{
		$("#BillToGSTINId").html("GSTIN "+clientGst);
		$("#BillToGSTINId").show();
	}
	$("#ShipToId").html(companyname);
	$("#ShipToAddressId").html($("#"+companyAdressId).val());
	$("#ConvertSalesRefKey").val(salesKey);
	$("#ConvertInvoiceContactrefid").val(contactrefid);
	$("#ConvertInvoiceClientrefid").val(clientrefid);
	$("#SendEmailClientName").val(clientName);
	$("#SendEmailClientEmail").val(clientEmail);
	
	
	if(Number(dueAmount)>0){
		$("#PaymentPaidOrPartial").html("Partial");
		$("#PaymentPaidOrPartial" ).css('margin-left','-48px');
		$("#InvoivePaymentDue").html(numberWithCommas(Number(dueAmount).toFixed(2)));
		$("#BalanceDueAmount").show();
	}else{
		$("#PaymentPaidOrPartial").html("Paid");
		$( "#PaymentPaidOrPartial" ).css('margin-left','-43px');
		$("#BalanceDueAmount").hide();
	}
	if(companyStateCode!="NA")
	$("#ShipToStateCode").html(companyState+"("+companyStateCode+")");
	else
		$("#ShipToStateCode").html(companyState);
	
	if(Number(discount)>0){
		$(".totalDiscount").show();
		$("#TotalAmountDiscount").html("-"+numberWithCommas(Math.floor(Number(discount))));
	}else{
		$(".totalDiscount").hide();
	}
	$("#TotalAmountWithGST").html(numberWithCommas(Math.round(Number(orderAmount))));
	numberToWords("SalesRupeesInWord",Math.round(Number(orderAmount)));	
	fillSalesInvoiceDetails(invoice,discount);
	
	var id = $(".invoicebox").attr('data-related'); 
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        var id1=$(this).attr('id');
	        if(id1==id) {
	            $(this).show();
	        }
	    });
}

function fillContactDetails(contactKey){
	$.ajax({
		type : "GET",
		url : "GetSalesContactData111",
		dataType : "HTML",
		data : {				
			contactKey : contactKey
		},
		success : function(response) {
			if(Object.keys(response).length!=0){
				response = JSON.parse(response);			
				 var len = response.length;
				 if(Number(len)>0){
					 var name=response[0]["name"];
					 var address=response[0]["address"];
					 var state=response[0]["state"];
					 var stateCode=response[0]["statecode"];
					 
					 $("#BillToId").html(name);
					 $("#ShipToId").html(name);
				     $("#ShipToAddressId").html(address);
					 
					 if(stateCode!="NA")
							$("#ShipToStateCode").html(state+"("+stateCode+")");
							else
								$("#ShipToStateCode").html(state);
					 
				 }
			}
		},
		error : function(error) {
			alert('error: ' + error.responseText);
		}
	});
}

function fillSalesInvoiceDetails(invoice){
	 $(".ItemDetailList").remove();	
	 $("#TotalPriceWithoutGst").html('');
	 $("#TotalGstAmount").html('');
	 $.ajax({
			type : "POST",
			url : "GetSalesPriceList111",
			dataType : "HTML",
			data : {				
				invoice : invoice
			},
			success : function(response){
			if(Object.keys(response).length!=0){
			response = JSON.parse(response);			
			 var len = response.length;
			 if(Number(len)>0){					 	
				 var qtyborder="";
				 var totalProdQty=0; 
			 for(var i=0;i<len;i++){ 			
			 	var refid=response[i]["refid"];
				var name=response[i]["name"];
				var qty=1;		
				var subitemdetails="subitemdetails"+i;
				totalProdQty=Number(totalProdQty)+Number(qty);
				if(Number(i)>0){					
						qtyborder="border-top: 1px solid #ccc;";
					}
				
				$(''+
						'<div class="clearfix ItemDetailList" style="width:100%;">'+
						'<div class="clearfix" style="font-weight: 600;width:100%;display: flex;'+qtyborder+'padding: 4px 0px 4px 0px;">'+
						'<div style="width:4%;">'+
						'<p style="margin: 0; font-size: 11px;">'+(i+1)+'</p>'+
						'</div>'+
						'<div style="width:96%;">'+
						'<p style="margin: 0; font-size: 11px;">'+name+' ('+qty+')</p>'+
						'</div>'+
						'</div>'+				
						'<div class="clearfix" id="'+subitemdetails+'"></div>'+				
						
						'<div class="clear">'+
						'</div>'+
						'</div>').insertBefore('#ItemListDetailsId');
				appendPriceList(refid,subitemdetails,i);
				
			 }	 
			 
			 $("#TotalProductQuty").html(totalProdQty);
			 showAllTaxData(invoice);
			 setTimeout(function(){			 	
			 	var totalRate=Number($("#TotalPriceWithoutGst").html());
				 var totalGST=Number($("#TotalGstAmount").html());				 
				 $("#TotalPriceWithoutGst").html(numberWithCommas(Math.round(Number(totalRate))));
				 $("#TotalGstAmount").html(numberWithCommas(Math.round(Number(totalGST))));			
				 
			 },1000);
			 
				}}
			},
			complete : function(data){
				hideLoader();
			}});	
} 

function appendPriceList(refid,subitemdetails,i){
	setTimeout(function(){
		if(i==0)i=1;	
	  
		$.ajax({
					type : "POST",
					url : "GetSalesSubPriceList111",
					dataType : "HTML",
					data : {				
						refid : refid,						
					},
					success : function(data){
					if(Object.keys(data).length!=0){
						data = JSON.parse(data);			
					 var plen = data.length;
					 if(Number(plen)>0){	
						 var totalRate=Number($("#SalePriceWithoutGst").val());
						 var totalGST=Number($("#SaleGstAmount").val());
						 
					 for(var j=0;j<plen;j++){ 			
					 	var prefid=data[j]["prefid"];
						var pricetype=data[j]["pricetype"];
						var price=Math.round(Number(data[j]["price"]));
						var hsncode=data[j]["hsncode"];						
						var cgstpercent=data[j]["cgstpercent"];				
						var sgstpercent=data[j]["sgstpercent"];				
						var igstpercent=data[j]["igstpercent"];				
						var cgstprice=data[j]["cgstprice"];	
						cgstprice=Number(cgstprice).toFixed(2);
						var sgstprice=data[j]["sgstprice"];	
						sgstprice=Number(sgstprice).toFixed(2);
						var igstprice=data[j]["igstprice"];		
						igstprice=Number(igstprice).toFixed(2);
						var totalprice=data[j]["totalprice"];	
						
						totalprice=Math.round(Number(totalprice));
						var tax=Number(cgstpercent)+Number(sgstpercent)+Number(igstpercent);
						var taxamt=Number(cgstprice)+Number(sgstprice)+Number(igstprice);
						taxamt=Math.round(Number(taxamt));
						
						totalRate=Math.round(Number(totalRate)+Number(price));
						totalGST=Math.round(Number(totalGST)+Number(taxamt));			 
						$(''+
								'<div class="clearfix" style="border-top: 1px solid #ccc;padding: 4px 0px 4px 0px;width:100%;display: flex;font-size: 10px;">'+
							    '<div style="margin-bottom: 0;padding-left: 16px; width: 34%;">'+
							    '<i class="" style="padding-right: 10px;color: #999;"></i>'+pricetype+'</div>'+							    
							    '<div style="width:13%;">'+
								'<p style="margin:0;text-align: right;">'+hsncode+'</p>'+
								'</div>'+
								'<div style="width:15%;">'+
								'<p style="margin:0;text-align: right;">'+numberWithCommas(price)+'</p>'+
								'</div>'+								
								'<div style="width:8%;">'+
								'<p style="margin:0;text-align: right;">'+tax+' %</p>'+
								'</div>'+
								'<div style="width:12%;">'+
								'<p style="margin:0;text-align: right;">'+numberWithCommas(taxamt)+'</p>'+
								'</div>'+
								'<div style="width:18%;">'+
								'<p style="margin:0;text-align: right;">'+numberWithCommas(totalprice)+'</p>'+
								'</div>'+
								'</div>').insertBefore("#"+subitemdetails);
						
						$("#SalePriceWithoutGst").val(totalRate);
						$("#SaleGstAmount").val(totalGST);
					 }
					 
					 $("#TotalPriceWithoutGst").html(totalRate);
					 $("#TotalGstAmount").html(totalGST);
					 }}
			}});		  
	},200*i);	
 }

function showAllTaxData(invoice){
	$(".taxRemoveBox").remove();
	$.ajax({
			type : "POST",
			url : "GetSalesTaxList111",
			dataType : "HTML",
			data : {				
				invoice : invoice,						
			},
			success : function(data){	
			if(Object.keys(data).length!=0){
				data = JSON.parse(data);			
			 var plen = data.length;
			 if(Number(plen)>0){	
			 for(var j=0;j<plen;j++){ 			
			 	var hsn=data[j]["hsn"];
				var cgst=data[j]["cgst"];
				var sgst=data[j]["sgst"];
				var igst=data[j]["igst"];
				
				var taxBorder="border-top: 1px dotted #ccc;";
				if(j==0){taxBorder="";}
				$(''+
			    '<div class="clearfix taxRemoveBox" style="width: 100%;text-align: center;padding: 5px 0 5px 0px;font-size: 10px;display: flex;'+taxBorder+'">'+
			    	'<div style="width: 25%">'+hsn+'</div>'+
			    	'<div style="width: 25%">'+sgst+'</div>'+
			    	'<div style="width: 25%">'+cgst+'</div>'+
			    	'<div style="width: 25%">'+igst+'</div>'+
			    '</div>').insertBefore("#GSTTaxAppendBoxId");
							 
			 }}
			 $("#DisplayTaxData").show();
			}else{
				 $("#DisplayTaxData").hide();
			 }
	}});
}

function showHideChangePopUp(id){
	  var div= document.querySelector('#'+id);
	  div.style.display= 'block';
	  div.style.left='-100px';
	  div.style.top='-13px';
	}
function hideMouseMove(id){
	var div= document.querySelector('#'+id);
	div.style.display= 'none';
}
$('.add_new').on( "click", function(e) {
	$(this).parent().next().show();	
	});
</script>
<script type="text/javascript">      

$(function() {
	$("#SoldByName").autocomplete({
		source : function(request, response) {			
			if(document.getElementById('SoldByName').value.trim().length>=1)
			$.ajax({
				url : "get-client-details.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					"field" : "SoldByName"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value,	
							uaid :	item.uaid,
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
            	doAction(ui.item.value,'salesSoldByAction');
            	doAction(ui.item.uaid,'salesSoldByUidAction');
            	location.reload();
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

$(function() {
	$("#ClientName").autocomplete({
		source : function(request, response) {			
			if(document.getElementById('ClientName').value.trim().length>=1)
			$.ajax({
				url : "get-client-details.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					"field" : "salesclientname"
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
            	doAction(ui.item.value,'salesClientAction');
            	location.reload();
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

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
					"field" : "salescontactname"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value,	
							key :	item.key,
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
            	doAction(ui.item.value,'salesContactAction');
            	location.reload();
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

$(function() { 
	$("#ProductName").autocomplete({
		source : function(request, response) {			
			if(document.getElementById('ProductName').value.trim().length>=1)
			$.ajax({
				url : "get-client-details.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					"field" : "salesProductName"
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
            	doAction(ui.item.value,'salesProductAction');
            	location.reload();
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

$(function() {
	$("#PhoneNo").autocomplete({
		source : function(request, response) {			
			if(document.getElementById('PhoneNo').value.trim().length>=12)
			$.ajax({
				url : "get-client-details.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					"field" : "salesPhoneNo"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value,
							key	:	item.key,
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
            	doAction(ui.item.value,'salesPhoneAction');
            	doAction(ui.item.key,'salesPhoneKeyAction');
            	location.reload();
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

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
					"field" : "salesInvoiceNo"
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
            	doAction(ui.item.value,'salesInvoiceAction');
            	location.reload();
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var data=$(this).val();
	doAction(data,"salesDateRangeAction");
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

$( document ).ready(function() {
	   var dateRangeDoAction="<%=salesDateRangeAction%>";
	   if(dateRangeDoAction!="NA"){	  
		   $('input[name="date_range"]').val(dateRangeDoAction);
	   }
	});
function getUpdateCompanyAddress(){
	var compaddress=$("#ManageSalesCompAddress").val();
	document.getElementById("UpdateEnqCompAddress").value=compaddress;
}
$('#UpdateContactcomAddress').on( "click", function(e) {
	$('.UpdateAddress_box').hide();
	$('.UpdateCompany_box').show();	
	});
	$('#UpdateContactperAddress').on( "click", function(e) {
	$('.UpdateAddress_box').show();
	$('.UpdateCompany_box').hide();	
	});
function openDocument(evt, cityName) {
	  var i, tabcontent, tablinks;
	  tabcontent = document.getElementsByClassName("tabcontent");
	  for (i = 0; i < tabcontent.length; i++) {
	    tabcontent[i].style.display = "none";
	  }
	  tablinks = document.getElementsByClassName("tablinks");
	  for (i = 0; i < tablinks.length; i++) {
	    tablinks[i].className = tablinks[i].className.replace(" active", "");
	  }
	  document.getElementById(cityName).style.display = "block";
	  evt.currentTarget.className += " active";
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
	$('#userInChat').select2({
		  placeholder: 'Select user to send sales notes..',
		  allowClear: true
		});
	$('#ExportColumn').select2({
		  placeholder: 'Select columns..',
		  allowClear: true,
		  dropdownParent: $("#ExportData")
		});
	var uuid="<%=uuid%>";
	if(uuid!="NA"){
		openTaskNotesBox(uuid,"<%=openProductName%>","<%=openContactKey%>");
	}
	$('#Update_Super_User').select2({
        placeholder: 'Select Super User',
        allowClear: true
    });
});

function validateExport(){
	/* var excelFilter=$("#excelFilter").val();
	var from=$("#From-Date").val();
	var to=$("#To-Date").val(); */
	var columns=$("#ExportColumn").val();
	var formate=$("#File-Formate").val();	
	var filePassword=$("#FilePassword").val();
	
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
	
	    if (confirm("If you don't apply any filter then all records will be exported from start, Ok to Continue ?")) {
	columns+="";
	showLoader();
	$.ajax({
		type : "POST",
		url : "ExportData111",
		dataType : "HTML",
		data : {				
			columns : columns,
			formate : formate,
			filePassword : filePassword,
			type : "sales"
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
		complete : function(msg) {
            hideLoader();
        }
	});	
	
	    }
	
}
function downloadInvoices(){
	showLoader();
	var salesKey=[];
	$(".checked:checked").each(function(){
		salesKey.push($(this).val());
	});
	salesKey+="";
	
	$.ajax({
		type : "POST",
		url : "<%=request.getContextPath()%>/download-sales-invoices.html",
		dataType : "HTML",
		data : {salesKey : salesKey},
		success : function(response){	
			if(response=="pass"){
				$("#DownloadExportedInvoices").click();
			}else{
				document.getElementById('errorMsg').innerHTML ='Something went wrong, Please try-again later !!';					
				$('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function(msg) {
            hideLoader();
        }
	});
}
function copyInvoiceLink(){
	showLoader();
	var salesKey=$("#ConvertSalesRefKey").val();

// 	var url = $(location).attr('href');
<%-- 	var name="<%=request.getContextPath()%>"; --%>
// 	var index=url.indexOf(name);
	var domain="<%=domain%>";
	var urlText=$("#InvoiceUrl").val();
	var input=domain+"sales-invoice-"+salesKey+".html";
	$("#InvoiceUrl").val(input);
	  var copyText = document.getElementById("InvoiceUrl");
	  copyText.select();
	  copyText.setSelectionRange(0, 99999)
	  document.execCommand("copy");
	  $("#CopyLinkUrl").addClass('textCopied');
	  hideLoader();
}

function loadMultipleEmail(){	
	var contactKey=$("#ConvertInvoiceContactrefid").val();
	$("#EmailCC").empty();		
	
	var value=[];	
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetSalesContactDetails111",
		dataType : "HTML",
		data : {				
			contactKey : contactKey
		},
		success : function(response){
		if(Object.keys(response).length!=0){	
			response = JSON.parse(response);			
			 var len = response.length;			 
			 if(Number(len)>0){	
			for(var i=0;i<len;i++){		   
				var email = response[i]['email'];	
				$("#EmailCC").append('<option value="'+email+'">'+email+'</option>');
				value.push(email);
			}
			$('#EmailCC').val(value); 
			$('#EmailCC').trigger('change'); 			
			 }}			
		},
		complete : function(msg) {
            hideLoader();
        }
	});	
	
	
}
  $(document).ready(function($){
	  $('#EmailCC').select2({
		  placeholder: 'Enter email and press enter',
		  tags: true
// 		  allowClear: true
		});
 });

function sendSalesInvoice(){	
	var date="<%=today%>";
	var emailTo=$("#EmailTo").val();
	var emailCC=$("#EmailCC").val();
	var emailSubject=$("#EmailSubject").val();
	var emailBody=CKEDITOR.instances.EmailBody.getData();
	
	
	if(emailTo==null||emailTo==""){
		 document.getElementById('errorMsg').innerHTML ='Send email to is required..';					
		 $('.alert-show').show().delay(4000).fadeOut();
		 return false;
	}
	if(emailSubject==null||emailSubject==""){
		 document.getElementById('errorMsg').innerHTML ='Email Subject is required..';					
		 $('.alert-show').show().delay(4000).fadeOut();
		 return false;
	}
	if(emailBody==null||emailBody==""){
		 document.getElementById('errorMsg').innerHTML ='Email Body is required..';					
		 $('.alert-show').show().delay(4000).fadeOut();
		 return false;
	}
	if(emailCC==null||emailCC==""){
		$("#EmailCC").val("NA");
	}
	var invoice=$("#ConvertInvoiceSaleNo").val();
	var CC=emailCC;
	if(CC==null)CC="empty";
	CC+="";
	showLoader();
	$.ajax({
		type : "POST",
		url : "SendSalesInvoice111",
		dataType : "HTML",
		data : {				
			emailTo : emailTo,
			CC : CC,
			emailSubject : emailSubject,
			emailBody : emailBody,
			invoice : invoice
		},
		success : function(response){		
			if(response=="pass"){
				$("#SendEmailWarning").modal("hide");
				$("#EmailSendedId").addClass('textCopied');
			}else{
				document.getElementById('errorMsg').innerHTML ='Something went wrong, Please try again later !!';					
	 		    $('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function(msg) {
            hideLoader();
        }
	});	
}

$(document).ready(function(){
	CKEDITOR.replace('EmailBody');
	CKEDITOR.replace('ChatTextareaBoxReply',{
		   height:150
	   });
	CKEDITOR.replace('ChatTextareaBoxReply1',{
		   height:150
	   });
});
function openSendEmailBox(){
	loadMultipleEmail();
	var clientEmail=$("#SendEmailClientEmail").val();
	$("#EmailTo").val(clientEmail);
	$("#EmailSubject").val("Estimate Invoice");
	var clientName=$("#SendEmailClientName").val();
	var saleNo=$("#ConvertInvoiceSaleNo").val();
	var salesKey=$("#ConvertSalesRefKey").val();
	
	var domainName="<%=domain%>";
	
	var url=domainName+"invoice-"+salesKey+".html";
	var message="<p>Dear "+clientName+"</p><p>Download Invoice No.:"+saleNo+" by clicking <a href='"+url+"' target='_blank'>link</a></p><p>Thanks & Regard</p><p>Sales Team</p>";
	
	CKEDITOR.instances.EmailBody.setData(message);
	$("#SendEmailWarning").modal("show");
}
function deleteDocument(docId,docName){
	if(docId!="NA"){
		$("#SalesDocumentId").val(docId);
		$("#SalesDocumentName").val(docName);
		$("#warningDeleteFile").modal("show");
	}else{
		$("#warningDeleteFile").modal("hide");
		docId=$("#SalesDocumentId").val();
		docName=$("#SalesDocumentName").val();
		showLoader();
		$.ajax({
		    type: "POST",
		    url: "<%=request.getContextPath()%>/deleteSalesHistoryDocument111",
		    data:  { 
		    	docId : docId,
		    	docName : docName
		    },
		    success: function (response) {
		    	if(response=="pass"){
		    		$("#Delete"+docId).hide();
		    		$("#Download"+docId).hide();
		    	}
	        },
			complete : function(data){
				hideLoader();
			}
		});
	}
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

	$('.list_icon').click(function(){
		$(this).children().next().toggleClass("show");
		$(".dropdown_list").not($(this).children().next()).removeClass('show');
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
		showLoader();
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
		hideLoader();
	}
	function showRemark(){
		var otherFee=$("#Other_Fee").val();
		if(otherFee!=null&&otherFee!=""&&Number(otherFee)>0){
			$("#Other_Fee_remark_Div").show();
		}else $("#Other_Fee_remark_Div").hide();
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
// 				console.log(response);
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
function sendLogin(){
	showLoader();
	let salesKey=$("#ConvertSalesRefKey").val();
	$.ajax({
	    type: "GET",
	    url: "<%=request.getContextPath()%>/GetSalesLoginContacts111",
	    data:  { 
	    	salesKey : salesKey
	    },
	    success: function (response) {
	    	$("#sendLoginCredentials .modal-body").html(response);
			$("#sendLoginCredentials").modal("show");
        },
		complete : function(data){
			hideLoader();
		}
	});	
}
function sendLoginCredentials(formData){
	showLoader();
	let salesKey=$("#ConvertSalesRefKey").val();
	$.ajax({
		type : "POST",
		url : "SendLoginCredential111",
		dataType:'HTML',
		data : {				
			formData : formData,
			salesKey : salesKey
		},
		success : function(response){
			console.log(response);
			if(response=="pass"){
				$("#sendLoginCredentials").modal("hide");
				document.getElementById('errorMsg1').innerHTML ='Successfully Credential Shared !!';					
	 		    $('.alert-show1').show().delay(4000).fadeOut();
			}else{
				document.getElementById('errorMsg').innerHTML ='Something went wrong, Please try again later !!';					
	 		    $('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function(msg) {
            hideLoader();
        }
	});
}
function showTeamNotes(PublicreplyLi,InternalreplyLi,ReplyNotesBoxId,InternalNotesBoxId){
	$("#"+PublicreplyLi).addClass("active");
	$("#"+InternalreplyLi).removeClass("active");
	$("#"+ReplyNotesBoxId).show();
	$("#"+InternalNotesBoxId).hide();
	$(".communication_history").show();
	$(".communication_history1").show();
	$(".internalNotes").addClass("toggle_box");
	$(".cmhistscroll").scrollTop($(".cmhistscroll")[0].scrollHeight);
}
function showPersonalNotes(PublicreplyLi,InternalreplyLi,ReplyNotesBoxId,InternalNotesBoxId){
	$("#"+PublicreplyLi).removeClass("active");
	$("#"+InternalreplyLi).addClass("active");
	$("#"+ReplyNotesBoxId).hide();
	$("#"+InternalNotesBoxId).show();
	$(".communication_history").hide();
	$(".communication_history1").hide();
	$(".internalNotes").removeClass("toggle_box");
}
function validateTeamNotes(){
	var notes=CKEDITOR.instances.ChatTextareaBoxReply.getData();
	var salesrefid=$("#taskActiveSalesKey").val();
	var contactKey=$("#taskActiveContactKey").val()
	var userInChat=$("#userInChat").val();
	console.log(userInChat);
	if(userInChat!=null&&userInChat.length>0){
		userInChat=$("#userInChat").val()+"";
	}
	
	if(notes==null||notes.length<=0){
		alert("Please enter text..");
		return false;
	}
	showLoader();
	$.ajax({
		type : "POST",
		url : "SaveSalesTaskNotes111",
		dataType : "HTML",
		data : {				
			salesrefid : salesrefid,
			notes : notes,
			contactKey : contactKey,
			type:"Team",
			userInChat:userInChat
		},
		success : function(data){
			CKEDITOR.instances.ChatTextareaBoxReply.setData('')
			$(".communication_history").append(data);			
		},
		complete : function(msg) {
            hideLoader();
        }
	});
}
function validatePersonalNotes(){
	var notes=CKEDITOR.instances.ChatTextareaBoxReply1.getData();
	var salesrefid=$("#taskActiveSalesKey").val();
	var contactKey=$("#taskActiveContactKey").val()
	showLoader();
	$.ajax({
		type : "POST",
		url : "SaveSalesTaskNotes111",
		dataType : "HTML",
		data : {				
			salesrefid : salesrefid,
			notes : notes,
			contactKey : contactKey,
			type:"Personal",
			"userInChat":""
		},
		success : function(data){	
			CKEDITOR.instances.ChatTextareaBoxReply1.setData('')
			$(".cmhistscrollInternal").append(data);			
		},
		complete : function(data){
			hideLoader();
		}
	});
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
function uploadNewDocument(){	
	$('#AddNewDocumentListForm').trigger('reset')
	$("#AddNewDocumentList").modal("show");
}
function validateDocumentList()	{  
	var docname=$("#NewDocumentName").val().trim();
	var UploadBy=$("#DocumentUploadBy").val().trim();
	var Remarks=$("#DocumentUploadRemarks").val().trim();

	if(docname==null||docname==""){
		document.getElementById('errorMsg').innerHTML ="Please enter document name !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(UploadBy==null||UploadBy==""){
		document.getElementById('errorMsg').innerHTML ="Please select document upload by !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(Remarks==null||Remarks==""){
		document.getElementById('errorMsg').innerHTML ="Please write about this document !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	var salesrefid=$("#ActiveDocSalesKey").val();
	var key=getKey(40);
	showLoader();
	$.ajax({
		type : "POST",
		url : "AddNewDocumentList111",
		dataType : "HTML",
		data : {				
			key : key,
			salesrefid : salesrefid,
			docname : docname,
			UploadBy : UploadBy,
			Remarks : Remarks
		},
		success : function(data){
			if(data=="pass"){
				$("#AddNewDocumentList").modal("hide");
				$(".documentListCl").remove();
				fillDocumentList(salesrefid);
				
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
		},
		complete : function(data){
			hideLoader();
		}
	});
}
function showGstBox(){
	$("#showGSTModel").modal("show");
}   
function calculateGstAmount(){
	var originalCost=$("#gstAmount").val();
	var gst=$("#GstPercent").val();
	console.log("originalCost="+originalCost+"/gst="+gst);
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
		
function showCancelReason(invoice){	
	$.ajax({
		type : "GET",
		url : "GetEstimateCancelReason111",
		dataType : "HTML",
		data : {	
			invoice:invoice,
			"type":"sales"
		},
		success : function(data){
			var x=data.split("#");
			var heading=x[0];
			var content=x[1];
			$("#estimateCancelLabel").html(heading);
			$("#estimateCancelBody").html(content);
			$("#estimateCancelModal").modal("show");
								
		},
		complete : function(data){
			hideLoader();
		}
	});	
}
function removeSendLogin(removeClass){
	$("."+removeClass).remove();
}
function showSaleDetails(salesKey){	
	showLoader();
	$.ajax({
		type : "GET",
		url : "GetConsultingSaleDetails111",
		dataType : "HTML",
		data : {	
			"salesKey":salesKey
		},
		success : function(data){
			$("#consultingServiceBody").html(data);
			$("#consultingServiceModal").modal("show");								
		},
		complete : function(data){
			hideLoader();
		}
	});
}
function updateEndDate(){
	let salesKey=$("#consultingSalesKey").val();
	let closeDate=$("#consultingSaleEndDate").val();
	$.ajax({
		type : "POST",
		url : "CloseConsultingSale111",
		dataType : "HTML",
		data : {	
			salesKey:salesKey,
			closeDate : closeDate
		},
		success : function(data){			
			document.getElementById('errorMsg1').innerHTML = 'Renewal End Date Updated !!';
			$('.alert-show1').show().delay(2000).fadeOut();
		},
		complete : function(data){
			hideLoader();
		}
	});
}
function dateChange(){
	$("#consultingSaleBtn").removeAttr("disabled","disabled");
}
</script>

</body>
</html>
