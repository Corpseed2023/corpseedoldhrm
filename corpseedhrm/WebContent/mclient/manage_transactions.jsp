<%@page import="java.util.Properties"%>
<%@page import="commons.CommonHelper"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/> 
	<title>Manage transactions</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	<%
String addedby= (String)session.getAttribute("loginuID");
	
String transactionDateRangeAction = (String) session.getAttribute("transactionDateRangeAction");
if(transactionDateRangeAction==null||transactionDateRangeAction.length()<=0)transactionDateRangeAction="NA";

String transactionClientNameAction = (String) session.getAttribute("transactionClientNameAction");
if(transactionClientNameAction==null||transactionClientNameAction.length()<=0)transactionClientNameAction="NA";

String transactionInvoiceAction = (String) session.getAttribute("transactionInvoiceAction");
if(transactionInvoiceAction==null||transactionInvoiceAction.length()<=0)transactionInvoiceAction="NA";

String transactionDoAction = (String) session.getAttribute("transactionDoAction");
if(transactionDoAction==null||transactionDoAction.length()<=0)transactionDoAction="All";

String userroll= (String)session.getAttribute("emproleid");
String token=(String)session.getAttribute("uavalidtokenno");
//pagination start
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
Properties properties = new Properties();
properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
String domain=properties.getProperty("domain");
String docBasePath=properties.getProperty("docBasePath");
String sort_url=domain+"managetransactions.html?page="+pageNo+"&rows="+rows;

//pagination end
String[][] transactions=Clientmaster_ACT.getAllTransactions(transactionDoAction,transactionInvoiceAction,transactionClientNameAction,transactionDateRangeAction,token,pageNo,rows,sort,order);
int totalTxn=Clientmaster_ACT.countAllTransactions(transactionDoAction,transactionInvoiceAction,transactionClientNameAction,transactionDateRangeAction,token); 
%>
<%if(!MB09){%><jsp:forward page="/login.html" /><%} %>
	<div id="content">
		<div class="main-content">
			<div class="container">
<!-- 				<div class="relative_box text-center mb30">  -->
<!-- 					<h2 class="title">Manage Billing</h2>  -->
<!-- 					<a class="add_btn sub-btn1" href="">New Sale</a> -->
<!-- 				</div> -->
				
				<div class="box_shadow1 invoice_info redius_box pad_box4 bg_wht mb30">
                        <div class="clearfix dashboard_info">
                          <div class="pad0 col-md-3 col-sm-3 col-xs-6">
                          <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:100px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div> 
						   <div class="clearfix mlft20">
                            <h3><i class="fa fa-inr"></i> <%=CommonHelper.formatValue(8500) %></h3>
							<span>Total Income</span>
						   </div>
                          </div>
                          <div class="pad0 bdr_left col-md-3 col-sm-3 col-xs-6">
                          <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:100px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div> 
						   <div class="clearfix mlft20">
                            <h3><i class="fa fa-inr"></i><%=CommonHelper.formatValue(50) %></h3>
							<span>Total Expenses</span>
                           </div>
						  </div>
                          <div class="pad0 bdr_left col-md-3 col-sm-3 col-xs-6">
                          <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:100px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div> 
						   <div class="clearfix mlft20">
                            <h3><i class="fa fa-inr"></i><%=CommonHelper.formatValue(6500) %></h3>
							<span>Net Income</span>
                           </div>
						  </div>
                          <div class="pad0 bdr_left col-md-3 col-sm-3 col-xs-6">
                          <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:100px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div> 
						   <div class="clearfix mlft20">
                            <h3><i class="fa fa-inr"></i><%=CommonHelper.formatValue(2020) %></h3>
							<span>Net Cash</span>
                           </div>
						  </div>
                        </div> 
				</div>
				
<div class="clearfix"> 
<form name="RefineSearchenqu" action="<%=request.getContextPath()%>/manage-billing.html" method="Post">
<div class="bg_wht clearfix mb10" id="SearchOptions">  
<div class="row">
<div class="post" style="position:absolute;z-index:9">
                        <div class="linee" style="margin-top: -1px;width:1350px;height:50px"></div>
                            </div>
<div class="col-md-5 col-sm-5 col-xs-9"> 
<div class="col-md-3 box-width7">
<button type="button" class="filtermenu dropbtn" style="width: 62px;margin-left: -14px;">Add&nbsp;+</button>
<div class="dropdown-content" style="border-radius: 3px;">   
    <a class="clickeble expense" data-related="add_expense" onclick="openExpense()">Expense</a>
    <a href="newestimatesale.html">Income(Sales)</a>
    <a class="clickeble transfer" data-related="Transfer_Fund" onclick="openTransferBox()">Transfer-1</a>
    <a class="clickeble refundexpense" data-related="refund_expense" onclick="openRefundExpense()">Expense Refund</a>
    <a class="clickeble incomerefund" data-related="Income_Refund" onclick="openIncomeRefund()">Income Refund(Sales)</a>
 </div>
</div>
<div class="col-md-5" style="margin-left: 15px;display:inline-block">
<select class="filtermenu" onchange="doAction(this.value,'transactionDoAction');location.reload()">
	<option value="All" <%if(transactionDoAction.equalsIgnoreCase("All")) {%>selected="selected"<%} %> title="All types of transactions !!">All</option>
	<option value="Sales" <%if(transactionDoAction.equalsIgnoreCase("Sales")) {%>selected="selected"<%} %> title="All sales income transactions !!">Income</option>
	<option value="Income refund" <%if(transactionDoAction.equalsIgnoreCase("Income refund")) {%>selected="selected"<%} %> title="Sales income refund transactions !!">Income refund</option>
	<option value="Expense" <%if(transactionDoAction.equalsIgnoreCase("Expense")) {%>selected="selected"<%} %> title="All expenses in transactions !!">Expense</option>
	<option value="Expense refund" <%if(transactionDoAction.equalsIgnoreCase("Expense refund")) {%>selected="selected"<%} %> title="All expenses refund transactions !!">Expense refund</option>	
</select>
</div>
</div>
<a href="javascript:void(0)" class="doticon"> <i class="fa fa-filter" aria-hidden="true"></i>Filter</a>
<div class="filtermmenu">
<div class="col-md-7 col-sm-7 col-xs-12">
<div class="clearfix">  
<div class="item-bestsell col-md-4 col-sm-4 col-xs-12">
<p><input type="search" name="invoiceNo" id="Invoice_No" autocomplete="off" <% if(!transactionInvoiceAction.equalsIgnoreCase("NA")){ %>onsearch="clearSession('transactionInvoiceAction');location.reload()" value="<%=transactionInvoiceAction%>"<%} %> placeholder="Search by invoice no." class="form-control"/></p>
</div>
<div class="item-bestsell col-md-4 col-sm-4 col-xs-12">
<p><input type="search" name="clientName" id="Client_Name" autocomplete="off"<% if(!transactionClientNameAction.equalsIgnoreCase("NA")){ %>onsearch="clearSession('transactionClientNameAction');location.reload()" value="<%=transactionClientNameAction%>"<%} %> placeholder="Client name.." class="form-control"/></p>
</div> 
<div class="item-bestsell col-md-4 col-sm-4 col-xs-12 has-clear">
<p><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="FROM- TO" class="form-control text-center date_range pointers <%if(!transactionDateRangeAction.equalsIgnoreCase("NA")){%>selected<%} %>" readonly="readonly"/>
<span class="form-control-clear form-control-feedback" onclick="clearSession('transactionDateRangeAction');location.reload();"></span>
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
      <div class="line" style="position:relative;z-index:9;width:200px;height:35px"></div>
    </th>
  </tr>
						        <tr>
						            <th><span class="hashico">#</span><input type="checkbox" class="pointers noDisplay" id="CheckAll"></th>
						            <th width="100" class="sorting <%if(sort.equals("date")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','date','<%=order%>')">Date</th>
						            <th class="sorting <%if(sort.equals("description")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','description','<%=order%>')">Description</th>
						            <th class="sorting <%if(sort.equals("client")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','client','<%=order%>')">Client</th>
						            <th class="sorting <%if(sort.equals("account")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','account','<%=order%>')">Account</th>
						            <th class="sorting <%if(sort.equals("category")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','category','<%=order%>')">Category</th>
						            <th width="120" class="sorting <%if(sort.equals("withdrawl")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','withdrawl','<%=order%>')">Withdrawal</th>
						            <th width="120" class="sorting <%if(sort.equals("deposit")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','deposit','<%=order%>')">Deposit</th>
						            <th class="sorting <%if(sort.equals("cash_flow")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','cash_flow','<%=order%>')">Include cash flow</th>
						            <th width="100">Action</th>
						        </tr>
						    </thead>
						    <tbody>
						    <%
						    String pymtstatus="NA";
                            String color="NA";
                            int ssn=0;  
                            int showing=0;
                            int startRange=pageNo-2;
                            int endRange=pageNo+2;
                            int totalPages=1;
                            if(transactions!=null&&transactions.length>0){
                            	ssn=rows*(pageNo-1);
                          	  totalPages=(totalTxn/rows);
                          	if((totalTxn%rows)!=0)totalPages+=1;
                          	  showing=ssn+1;
                          	  if (totalPages > 1) {     	 
                          		  if((endRange-2)==totalPages)startRange=pageNo-4;        
                                    if(startRange==pageNo)endRange=pageNo+4;
                                    if(startRange<1) {startRange=1;endRange=startRange+4;}
                                    if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
                                    if(startRange<1)startRange=1;
                               }else{startRange=0;endRange=0;}
                             for(int i=0;i<transactions.length;i++) { 
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
      <div class="line" style="position:relative;z-index:9;width:200px;height:35px"></div>
    </td>
   
  </tr>
						        <tr>
						            <td><input type="checkbox" name="checkbox" id="checkbox" class="checked"></td>
						            <td><%=transactions[i][2] %></td>
						            <td><%=transactions[i][3] %></td>
						            <td><%=transactions[i][4] %></td>
						            <td><%=transactions[i][6] %></td>
						            <td><%=transactions[i][7]%></td>
						            <td><i class="fa fa-inr"></i>&nbsp;<%=CommonHelper.withLargeIntegers(Double.parseDouble(transactions[i][8])) %></td>
						            <td><i class="fa fa-inr"></i>&nbsp;<%=CommonHelper.withLargeIntegers(Double.parseDouble(transactions[i][9])) %></td>
						            <td class="text-center"><label class="switch">
										  <input type="checkbox" id="CashFlowId<%=(i+1) %>" onchange="updateCashFlow('<%=transactions[i][0] %>','<%=(i+1) %>')" <%if(transactions[i][10].equalsIgnoreCase("1")) {%> checked<%} %>>
										  <span class="slider round"></span>
										</label>
									</td>	
									<td>
									<a href="#"><i class="fas fa-edit"></i></a>
									<a href="#"><i class="fas fa-trash"></i></a>
									</td>
						        </tr>
						     <%}}%>
                                 
						    </tbody>
						</table>
						</div>
						<div class="filtertable">
			  <span>Showing <%=showing %> to <%=ssn+transactions.length %> of <%=totalTxn %> entries</span>
			  <div class="pagination">
			    <ul> <%if(pageNo>1){ %>
			      <li class="page-item">	                     
			      <a class="page-link text-primary" href="<%=request.getContextPath()%>/managetransactions.html?page=1&rows=<%=rows%>">First</a>
			   </li><%} %>
			    <li class="page-item">					      
			      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/managetransactions.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
			    </li>  
			      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
				    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
				    <a class="page-link" href="<%=request.getContextPath()%>/managetransactions.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
				    </li>   
				  <%} %>
				   <li class="page-item">						      
				      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/managetransactions.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
				   </li><%if(pageNo<=(totalPages-1)){ %>
				   <li class="page-item">
				      <a class="page-link text-primary" href="<%=request.getContextPath()%>/managetransactions.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
				   </li><%} %>
				</ul>
				</div>
				<select class="select2" onchange="changeRows(this.value,'managetransactions.html?page=1','<%=domain%>')">
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
	<p id="end" style="display:none;"></p>
	</div>
<div class="fixed_right_box">

<div class="clearfix add_inner_box pad_box4 addcompany" id="Transfer_Fund">
<div class="close_icon close_box"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-money"></i>Transfer Fund</h3> 
<p>Transfer fund from one account to another.</div>
<form onsubmit="return false;" id="Transfer_Funds">
<input type="hidden" id="UpdateCompanyKey">

<div class="clearfix inner_box_bg" style="margin-top: 30px;">

<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Amount :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
 <input type="text" name="transferamount" id="TransferAmount" placeholder="Amount" class="form-control bdrd4" onkeypress="return isNumberKey(event)">
   </div>
  </div>
 </div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Transfer Date :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <input type="text" name="transferdate" id="TransferDate" placeholder="Date" onblur="" class="form-control bdrd4 searchdate readonlyAllow" readonly="readonly">
  </div>
  <div id="enqAddErrorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row" style="margin-top: 10px;">
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Withdrawl Account :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
<!--   <input type="text" name="withdrawlaccounrt" id="WithdrawlAccounrt" placeholder="" onblur="" class="form-control bdrd4"> -->
  <select class="form-control bdrd4" id="WithdrawlAccounrt" name="withdrawlaccounrt">
   <option value="">Select</option>
  <option value="Cash">Cash</option>
  <option value="Contributed capital">Contributed capital</option>
  <option value="Deposit from customer">Deposit from customer</option>
  <option value="Furniture & Equipments">Furniture & Equipments</option>
  <option value="Pre-paid expense">Pre-paid expense</option>
  <option value="Undeposite funds">Undeposite funds</option>
  <option value="Post paid expense">Post paid expense</option>
  </select>
  </div>
  <div id="cityErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Deposite Account :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">  
   <select class="form-control bdrd4" id="DepositeAccounrt" name="depositeaccounrt">
  <option value="">Select</option>
  <option value="Cash">Cash</option>
  <option value="Contributed capital">Contributed capital</option>
  <option value="Deposit from customer">Deposit from customer</option>
  <option value="Furniture & Equipments">Furniture & Equipments</option>
  <option value="Pre-paid expense">Pre-paid expense</option>
  <option value="Undeposite funds">Undeposite funds</option>
  <option value="Post paid expense">Post paid expense</option>
  </select>
  </div>
  <div id="cityErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12" style="margin-top: 15px;">
<div class="form-group">
  <label>Reason :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <textarea class="form-control bdrd4" rows="3" name="expensenote" id="ExpenseNote" placeholder="Enter Note" onblur="validateLocationPopup('UpdateAddress');validateValuePopup('UpdateAddress');" ></textarea>
  </div>
</div>
</div>
</div>
<div class="clearfix mtop10 mb10 text-right"> 
<button class="bt-link bt-radius bt-gray mrt10 close_box" type="button">Cancel</button>
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateUpdateCompany();">Submit</button>
</div>
</form>                                  
</div>

<div class="clearfix add_inner_box pad_box4 addcompany" id="Income_Refund">
<div class="close_icon close_box"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-money"></i>Income Refund</h3> 
<p>Refund Income sale.</div>
<form action="addrefundincome.html" method="post" id="RefundIncomeSale">
<div class="row" style="margin-top: 40px;">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="incomerefundinvoice" id="IncomeRefundInvoice" placeholder="Invoice Number" class="form-control bdrd4">
 </div>
  <div id="cnameErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="refundincomename" id="RefundIncomeName" placeholder="Contact Name" class="form-control bdrd4" readonly="readonly">
 <input type="hidden" name="refundincomemobile" id="RefundIncomeMobile" value="NA"/>
  </div>
 </div>
</div>
</div>
<div class="clearfix inner_box_bg" style="margin-top: 30px;">
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Amount :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <input type="text" name="refundincomeamount" id="RefundIncomeAmount" placeholder="Amount" class="form-control bdrd4" onkeypress="return isNumberKey(event)">
  </div>
  <div id="cityErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Refund Type :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <select class="form-control bdrd4" id="RefundIncomeType" name="refundrncometype">
  <option value="">Select</option>
  <option value="Partial">Partial</option>
  <option value="Full">Full</option>
  </select>
  </div>
 </div>
</div>
</div>
<div class="row" style="margin-top: 10px;">
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Department :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
 <input type="text" name="refundincomedepartment" id="RefundIncomeDepartment" placeholder="Department" class="form-control bdrd4"">
   </div>
  </div>
 </div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Refund Date :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <input type="text" name="refundincomedate" id="RefundIncomeDate" placeholder="Refund Date" class="form-control bdrd4 searchdate readonlyAllow" readonly="readonly">
  </div>
  <div id="enqAddErrorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12" style="margin-top: 15px;">
<div class="form-group">
  <label>Reason :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <textarea class="form-control bdrd4" rows="3" name="refundincomenotes" id="RefundIncomeNotes" placeholder="Enter Note" onblur="validateLocationPopup('UpdateAddress');validateValuePopup('UpdateAddress');" ></textarea>
  </div>
</div>
</div>
</div>
<div class="clearfix mtop10 mb10 text-right"> 
<button class="bt-link bt-radius bt-gray mrt10 close_box" type="button">Cancel</button>
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateIncomeRefund();">Submit</button>.

</div>
</form>                                  
</div>
<div class="clearfix add_inner_box pad_box4 addcompany" id="add_expense">
<div class="close_icon close_box"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-money"></i>New Expense</h3> 
<p>Add Expenses for your department.</div>
<form action="addNewExpense.html" method="post" id="AddNewExpense">
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" autocomplete="off" name="addexpensename" id="AddExpenseName" placeholder="Name" onblur="validCompanyNamePopup('ExpenseName');validateValuePopup('ExpenseName');" class="form-control bdrd4">
 </div>
  <div id="cnameErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" autocomplete="off" maxlength="10" name="addexpenseContactNumber" id="AddExpenseContactNumber" placeholder="Contact Number" onblur="validateMobilePopup('AddExpenseContactNumber');validateValuePopup('AddExpenseContactNumber')" class="form-control bdrd4" onkeypress="return isNumberKey(event)">
  </div>
  <div id="industryErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
<div class="clearfix inner_box_bg" style="margin-top: 10px;">
<div class="row">
<div class="col-md-4 col-sm-4 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Amount :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <input type="text" autocomplete="off" name="addexpenseamount" id="AddExpense_Amount" placeholder="Amount" class="form-control bdrd4" onkeypress="return isNumberKey(event)">
  </div>
  <div id="cityErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-8 col-sm-8 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">How would you like to categorize this expense ? :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <select class="form-control bdrd4" id="AddExpenseCategory" name="addExpenseCategory">
  <option value="">Expense Category</option>
  <option value="Advertising and Marketing Expense">Advertising and Marketing Expense</option>
  <option value="Bank Charges and Internet Expense">Bank Charges and Internet Expense</option>
  <option value="Contractor Expense">Contractor Expense</option>
  <option value="Cost of Goods Sold Expense">Cost of Goods Sold Expense</option>
  <option value="Deprecation Expense">Deprecation Expense</option>
  <option value="Insurance Expense">Insurance Expense</option>
  <option value="Management and Administration Expense">Management and Administration Expense</option>
  <option value="Meals & Entertainment Expense">Meals and Entertainment Expense</option>
  <option value="Office Expense">Office Expense</option>
  <option value="Payroll Expense">Payroll Expense</option>  
  <option value="Personal Expense">Personal Expense</option>
  <option value="Professional Dues/Membership/Licenses">Professional Dues/Membership/Licenses</option>
  <option value="Professional Services Expense">Professional Services Expense</option>
  <option value="Rent">Rent Expense</option>
  <option value="Repairs & Maintenance Expense">Repairs & Maintenance Expense</option>
  <option value="Shipping & Postage Expense">Shipping & Postage Expense</option>
  <option value="Travel Expense">Travel Expense</option>
  <option value="Utilities Expense">Utilities Expense</option>
  <option value="Vehicle Expense">Vehicle Expense</option>
  <option value="Department Fees">Department Fees</option>
  <option value="Filing Fees">Filing Fees</option>
  <option value="Other Expense">Other Expense</option>
  </select>
  </div>
  <div id="stateErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
<div class="row" style="margin-top: 10px;">
<div class="col-md-4 col-sm-4 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">HSN (Tax if applicable) :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
   <input type="text" autocomplete="off" name="addexpensehsncode" id="AddHSN_Code" placeholder="HSN Code..." class="form-control bdrd4">
   </div>
   <div id="countryErrorMSGdiv" class="errormsg"></div>
  </div>
 </div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Department :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <input type="text" autocomplete="off" name="addexpensedepartment" id="AddExpenseDepartment" onblur="validateValuePopup('ExpenseDepartment');" placeholder="Department here..." class="form-control bdrd4">
  </div>
  <div id="enqAddErrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Paid from account :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
 <select class="form-control bdrd4" id="AddPaidFromAccount" name="addPaidFromAccount">
  <option value="">Select</option>
  <option value="Online">Online</option>
  <option value="Cash">Cash</option>
  <option value="Cheque/DD">Cheque/DD</option>
  </select>
  </div>
  <div id="enqAddErrorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12" style="margin-top: 15px;">
<div class="form-group">
  <label>Notes :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <textarea class="form-control bdrd4" autocomplete="off" rows="3" name="addexpensenote" id="AddExpenseNote" placeholder="Enter Note" onblur="validateLocationPopup('ExpenseNote');validateValuePopup('ExpenseNote');" ></textarea>
  </div>
</div>
</div>
</div>
<div class="clearfix mtop10 mb10 text-right"> 
<button class="bt-link bt-radius bt-gray mrt10 close_box" type="button">Cancel</button>
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateAddExpense()">Submit</button>
</div>
</form>                                  
</div>

<div class="clearfix add_inner_box pad_box4 addcompany" id="refund_expense">
<div class="close_icon close_box"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-money"></i>Refund Expense</h3> 
<p>Refund Expenses for your department.</div>
<form action="refundNewExpense.html" method="post" id="RefundNewExpense">
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" autocomplete="off" name="refundexpensename" id="RefundExpenseName" placeholder="Name" onblur="validCompanyNamePopup('RefundExpenseName');validateValuePopup('RefundExpenseName');" class="form-control bdrd4">
 </div>
  <div id="cnameErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" autocomplete="off" maxlength="10" name="refundexpenseContactNumber" id="RefundExpenseContactNumber" placeholder="Contact Number" onblur="validateMobilePopup('RefundExpenseContactNumber');validateValuePopup('RefundExpenseContactNumber')" class="form-control bdrd4" onkeypress="return isNumberKey(event)">
  </div>
  <div id="industryErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
<div class="clearfix inner_box_bg" style="margin-top: 10px;">
<div class="row">
<div class="col-md-4 col-sm-4 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Amount :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <input type="text" autocomplete="off" name="refundexpenseamount" id="RefundExpense_Amount" placeholder="Amount" class="form-control bdrd4" onkeypress="return isNumberKey(event)">
  </div>
  <div id="cityErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-8 col-sm-8 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">How would you like to categorize this expense ? :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <select class="form-control bdrd4" id="RefundExpenseCategory" name="refundExpenseCategory">
  <option value="">Expense Category</option>
  <option value="Advertising and Marketing Expense">Advertising and Marketing Expense</option>
  <option value="Bank Charges and Internet Expense">Bank Charges and Internet Expense</option>
  <option value="Contractor Expense">Contractor Expense</option>
  <option value="Cost of Goods Sold Expense">Cost of Goods Sold Expense</option>
  <option value="Deprecation Expense">Deprecation Expense</option>
  <option value="Insurance Expense">Insurance Expense</option>
  <option value="Management and Administration Expense">Management and Administration Expense</option>
  <option value="Meals & Entertainment Expense">Meals and Entertainment Expense</option>
  <option value="Office Expense">Office Expense</option>
  <option value="Payroll Expense">Payroll Expense</option>  
  <option value="Personal Expense">Personal Expense</option>
  <option value="Professional Dues/Membership/Licenses">Professional Dues/Membership/Licenses</option>
  <option value="Professional Services Expense">Professional Services Expense</option>
  <option value="Rent">Rent Expense</option>
  <option value="Repairs & Maintenance Expense">Repairs & Maintenance Expense</option>
  <option value="Shipping & Postage Expense">Shipping & Postage Expense</option>
  <option value="Travel Expense">Travel Expense</option>
  <option value="Utilities Expense">Utilities Expense</option>
  <option value="Vehicle Expense">Vehicle Expense</option>
  <option value="Department Fees">Department Fees</option>
  <option value="Filing Fees">Filing Fees</option>
  <option value="Other Expense">Other Expense</option>
  </select>
  </div>
  <div id="stateErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
<div class="row" style="margin-top: 10px;">
<div class="col-md-4 col-sm-4 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">HSN (Tax if applicable) :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
   <input type="text" autocomplete="off" name="refundexpensehsncode" id="RefundHSN_Code" placeholder="HSN Code..." class="form-control bdrd4">
   </div>
   <div id="countryErrorMSGdiv" class="errormsg"></div>
  </div>
 </div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Department :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <input type="text" autocomplete="off" name="refundexpensedepartment" id="RefundExpenseDepartment" onblur="validateValuePopup('ExpenseDepartment');" placeholder="Department here..." class="form-control bdrd4">
  </div>
  <div id="enqAddErrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Paid from account :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
 <select class="form-control bdrd4" id="RefundPaidFromAccount" name="refundPaidFromAccount">
  <option value="">Select</option>
  <option value="Online">Online</option>
  <option value="Cash">Cash</option>
  <option value="Cheque/DD">Cheque/DD</option>
  </select>
  </div>
  <div id="enqAddErrorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12" style="margin-top: 15px;">
<div class="form-group">
  <label>Notes :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <textarea class="form-control bdrd4" autocomplete="off" rows="3" name="refundexpensenote" id="RefundExpenseNote" placeholder="Enter Note" onblur="validateLocationPopup('ExpenseNote');validateValuePopup('ExpenseNote');" ></textarea>
  </div>
</div>
</div>
</div>
<div class="clearfix mtop10 mb10 text-right"> 
<button class="bt-link bt-radius bt-gray mrt10 close_box" type="button">Cancel</button>
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateRefundExpense()">Submit</button>
</div>
</form>                                  
</div>
</div>

<div class="taxModal modal fade" id="taxModal">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        </div>
        <div class="modal-body">
          <div class="clearfix">
<form action="">
<div class="row pad_box4">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group">
<label>Tax</label>
<div class="input-group">
<input type="text" name="" id="" placeholder="Tax" class="form-control">
</div>
</div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group">
<label>Type of tax</label>
<div class="input-group">
<input type="text" name="" id="" placeholder="Type of tax" class="form-control">
</div>
</div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group">
<label>Tax % to be deducted</label>
<div class="input-group">
<input type="text" name="" id="" placeholder="Tax % to be deducted" class="form-control">
</div>
</div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group">
<label>Additional description</label>
<div class="input-group">
 <textarea class="form-control" rows="3" name="expensenote" id="ExpenseNote" placeholder="Additional description" onblur="validateLocationPopup('UpdateAddress');validateValuePopup('UpdateAddress');" ></textarea>
</div>
</div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix mtop10 mb10 text-center"> 
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="">Add</button>
</div>
</div>
</div>
</form>
</div>
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
            	<option value="mtdate">Date</option>
            	<option value="mtremarks">Description</option>
            	<option value="mtclientname">Client</option>
            	<option value="mtaccounts">Account</option>
            	<option value="mtcategory">Category</option>
            	<option value="mtwithdraw">Withdrawal</option>
            	<option value="mtdeposit">Deposit</option>            	
            	<option value="mtincludeincashflow">Include In Cash Flow</option>
            </select>            
          </div>
         <div class="form-group">
            <label for="recipient-name" class="col-form-label">Formate :</label>
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
<div class="noDisplay"><a href="" id="DownloadExportedLink" download><button id="DownloadExported">Download</button></a></div>  
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>	
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">	
$(document).ready(function(){
	   $('#AddExpense_Amount').on("paste",function(e) {
	      e.preventDefault();
	   });
	});
</script>
<script type="text/javascript">
function validateRefundExpense(){	       
	var expname=$("#RefundExpenseName").val().trim();
	var expNumber=$("#RefundExpenseContactNumber").val().trim();
	var expAmount=$("#RefundExpense_Amount").val().trim();
	var expCategory=$("#RefundExpenseCategory").val().trim();
	var expHSN=$("#RefundHSN_Code").val().trim();
	var expDepartment=$("#RefundExpenseDepartment").val().trim();
	var expAccount=$("#RefundPaidFromAccount").val().trim();
	var expNote=$("#RefundExpenseNote").val().trim();	
	
	if(expname==null||expname==""){
		document.getElementById('errorMsg').innerHTML ="Please enter name  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}
	if(expNumber==null||expNumber==""){
		document.getElementById('errorMsg').innerHTML ="Please enter contact mnumber  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}
	if(expAmount==null||expAmount==""){
		document.getElementById('errorMsg').innerHTML ="Please enter amount  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}
	if(expCategory==null||expCategory==""){
		document.getElementById('errorMsg').innerHTML ="Please select expense category  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}
	if(expDepartment==null||expDepartment==""){
		document.getElementById('errorMsg').innerHTML ="Please enter expense department  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}
	if(expAccount==null||expAccount==""){
		document.getElementById('errorMsg').innerHTML ="Please select payment via account  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}
	if(expNote==null||expNote==""){
		document.getElementById('errorMsg').innerHTML ="Please describe this expense in few word..  !!";    	
    	$('.alert-show').show().delay(4000).fadeOut();    
    	return false;
	}
	if(expHSN==null||expHSN==""){
		$("#RefundHSN_Code").val("NA");
	}
	
}
function validateIncomeRefund(){
	    
	var invoice=$("#IncomeRefundInvoice").val().trim();
	var amount=$("#RefundIncomeAmount").val().trim();
	var type=$("#RefundIncomeType").val().trim();
	var department=$("#RefundIncomeDepartment").val().trim();
	var refunddate=$("#RefundIncomeDate").val().trim();	
	var Note=$("#RefundIncomeNotes").val().trim();	
	
	if(invoice==null||invoice==""){
		document.getElementById('errorMsg').innerHTML ="Please enter sales invoice number  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}
	if(amount==null||amount==""){
		document.getElementById('errorMsg').innerHTML ="Please enter refund amount  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}
	if(type==null||type==""){
		document.getElementById('errorMsg').innerHTML ="Please select refund type  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}
	if(department==null||department==""){
		document.getElementById('errorMsg').innerHTML ="Please enter department name  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}
	if(refunddate==null||refunddate==""){
		document.getElementById('errorMsg').innerHTML ="Please enter refund date  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}
	if(Note==null||Note==""){
		document.getElementById('errorMsg').innerHTML ="Please describe this income in few word..  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}

}
function validateAddExpense(){	       
	var expname=$("#AddExpenseName").val().trim();
	var expNumber=$("#AddExpenseContactNumber").val().trim();
	var expAmount=$("#AddExpense_Amount").val().trim();
	var expCategory=$("#AddExpenseCategory").val().trim();
	var expHSN=$("#AddHSN_Code").val().trim();
	var expDepartment=$("#AddExpenseDepartment").val().trim();
	var expAccount=$("#AddPaidFromAccount").val().trim();
	var expNote=$("#AddExpenseNote").val().trim();	
	
	if(expname==null||expname==""){
		document.getElementById('errorMsg').innerHTML ="Please enter name  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}
	if(expNumber==null||expNumber==""){
		document.getElementById('errorMsg').innerHTML ="Please enter contact mnumber  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}
	if(expAmount==null||expAmount==""){
		document.getElementById('errorMsg').innerHTML ="Please enter amount  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}
	if(expCategory==null||expCategory==""){
		document.getElementById('errorMsg').innerHTML ="Please select expense category  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}
	if(expDepartment==null||expDepartment==""){
		document.getElementById('errorMsg').innerHTML ="Please enter expense department  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}
	if(expAccount==null||expAccount==""){
		document.getElementById('errorMsg').innerHTML ="Please select payment via account  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}
	if(expNote==null||expNote==""){
		document.getElementById('errorMsg').innerHTML ="Please describe this expense in few word..  !!";    	
    	$('.alert-show').show().delay(4000).fadeOut();    
    	return false;
	}
	if(expHSN==null||expHSN==""){
		$("#AddHSN_Code").val("NA");
	}
	showLoader();
}

$(function() {
	$("#IncomeRefundInvoice").autocomplete({
		source : function(request, response) {
			if(document.getElementById("IncomeRefundInvoice").value.trim().length>=2)
			$.ajax({
				url : "<%=request.getContextPath()%>/getnewproduct.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field: "salesinvoice",
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value,
							contactname : item.cname,
							contactmobile : item.cmobile
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
            	document.getElementById('errorMsg').innerHTML ="Select invoice from sales";
            	$("#IncomeRefundInvoice").val("");
            	$("#RefundIncomeName").val(""); 
            	$("#RefundIncomeMobile").val(""); 
            	$('.alert-show').show().delay(2000).fadeOut();            	
            }
            else{               	
            	$("#IncomeRefundInvoice").val(ui.item.value);
            	$("#RefundIncomeName").val(ui.item.contactname); 
            	$("#RefundIncomeMobile").val(ui.item.contactmobile); 
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

$(function() {
	$("#RefundHSN_Code").autocomplete({
		source : function(request, response) {
			if(document.getElementById("RefundHSN_Code").value.trim().length>=2)
			$.ajax({
				url : "<%=request.getContextPath()%>/getnewproduct.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field: "salehsntax",
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value,
							hsn : item.hsn,							
							igst : item.igst
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
            	document.getElementById('errorMsg').innerHTML ="Select from tax list";
            	$("#RefundHSN_Code").val(""); 
            	$('.alert-show').show().delay(2000).fadeOut();            	
            }
            else{              	
            	$("#RefundHSN_Code").val(ui.item.hsn);
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

$(function() {
	$("#AddHSN_Code").autocomplete({
		source : function(request, response) {
			if(document.getElementById("AddHSN_Code").value.trim().length>=2)
			$.ajax({
				url : "<%=request.getContextPath()%>/getnewproduct.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field: "salehsntax",
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value,
							hsn : item.hsn,							
							igst : item.igst
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
            	document.getElementById('errorMsg').innerHTML ="Select from tax list";
            	$("#AddHSN_Code").val(""); 
            	$('.alert-show').show().delay(2000).fadeOut();            	
            }
            else{              	
            	$("#AddHSN_Code").val(ui.item.hsn);
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

	function openExpense(){

		$("#AddNewExpense").trigger('reset');
		
		var id = $(".expense").attr('data-related'); 
		$('.fixed_right_box').addClass('active');
		    $("div.add_inner_box").each(function(){
		        $(this).hide();
		        if($(this).attr('id') == id) {
		            $(this).show();
		        }
		    });		
	}
	function openRefundExpense(){

		$("#RefundNewExpense").trigger('reset');
		
		var id = $(".refundexpense").attr('data-related'); 
		$('.fixed_right_box').addClass('active');
		    $("div.add_inner_box").each(function(){
		        $(this).hide();
		        if($(this).attr('id') == id) {
		            $(this).show();
		        }
		    });		
	}
	function openIncomeRefund(){

		$("#RefundExpense").trigger('reset');
		
		var id = $(".incomerefund").attr('data-related'); 
		$('.fixed_right_box').addClass('active');
		    $("div.add_inner_box").each(function(){
		        $(this).hide();
		        if($(this).attr('id') == id) {
		            $(this).show();
		        }
		    });		
	}
	function openTransferBox(){

		$("#Transfer_Funds").trigger('reset');
		
		var id = $(".transfer").attr('data-related'); 
		$('.fixed_right_box').addClass('active');
		    $("div.add_inner_box").each(function(){
		        $(this).hide();
		        if($(this).attr('id') == id) {
		            $(this).show();
		        }
		    });		
	}
function updateCashFlow(refid,Id){
	showLoader();
	var status="0";
	if($('#CashFlowId'+Id).is(":checked")){
		status="1";
	}else{
		status="2";
	}
	var xhttp; 
	xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
	if (this.readyState == 4 && this.status == 200) {
	}
	};
	xhttp.open("POST", "<%=request.getContextPath()%>/UpdateCashFlow111?status="+status+"&refid="+refid, true); 
	xhttp.send();
	hideLoader();
}	
	$(function() {
		$("#clientname").autocomplete({
			source : function(request, response) {
				if(document.getElementById('clientname').value.trim().length>=2)
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
			change: function (event, ui) {
	            if(!ui.item){     
	            	document.getElementById('errorMsg').innerHTML = 'Select From List.';
	        		$('.alert-show').show().delay(1000).fadeOut();
	        		
	            	$("#clientname").val("");     	
	            }
	            else{
	            	$("#clientname").val(ui.item.value);
	            	
	            }
	        },
	        error : function(error){
				alert('error: ' + error.responseText);
			},
		});
	});
	</script>
	<script type="text/javascript">
// var counter=25;
// $(window).scroll(function () {
//     if ($(window).scrollTop() == $(document).height() - $(window).height()) {
//     	appendData();
//     }
// });

// function appendData() {
//     var html = '';
//     if(document.getElementById("end").innerHTML=="End") return false;
//     $.ajax({
//     	type: "POST",
<%--         url: '<%=request.getContextPath()%>/getmorebillings', --%>
//         datatype : "json",
//         data: {
//         	counter:counter,
<%--         	clientname:'<%=clientname%>', --%>
<%--         	projectname:'<%=projectname%>', --%>
<%--         	projecttype:'<%=projecttype%>', --%>
<%--         	billingtype:'<%=billingtype%>', --%>
<%--         	status:'<%=status%>', --%>
<%--         	from:'<%=from%>', --%>
<%--         	to:'<%=to%>' --%>
//         	},
//         success: function(data){
//         	for(i=0;i<data[0].billing.length;i++)
//             	html += '<div class="row"><div class="col-md-12 col-sm-12 col-xs-12"><div class="clearfix"><div class="box-width1 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].billing[i][0]+'</p></div></div><div class="box-width3 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].billing[i][1]+'</p></div></div><div class="box-width16 col-xs-3 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].billing[i][3]+'</p></div></div><div class="col-md-1 col-xs-12 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].billing[i][2]+'</p></div></div><div class="col-md-1 col-xs-12 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].billing[i][4]+'</p></div></div><div class="col-md-1 col-xs-12 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].billing[i][6]+'</p></div></div><div class="col-md-1 col-xs-12 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].billing[i][7]+'</p></div></div><div class="col-md-1 col-xs-12 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].billing[i][8]+'</p></div></div><div class="box-width2 col-xs-12 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].billing[i][9]+'</p></div></div><div class="col-md-1 col-xs-12 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].billing[i][5]+'</p></div></div><div class="col-md-1 col-xs-12 box-intro-background"><div class="link-style12"><p><a href="javascript:void(0);" onclick="vieweditpage('+data[0].billing[i][0]+');">Edit</a><a href="javascript:void(0);" onclick="approve('+data[0].billing[i][0]+')"> Delete</a></p></div></div></div></div></div>';
//             if(html!='') $('#target').append(html);
//             else document.getElementById("end").innerHTML = "End";
//         }
//     });
    
//     counter=counter+25;
// }
</script>
<script type="text/javascript">
function approve(id) {
	if(confirm("Sure you want to Delete this Bill ? "))
	{
	var xhttp; 
	xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
	if (this.readyState == 4 && this.status == 200) {
	location.reload();
	}
	};
	xhttp.open("GET", "<%=request.getContextPath()%>/DeleteBill111?info="+id, true); 
	xhttp.send();
	}
}
function RefineSearchenquiry() {
	document.RefineSearchenqu.jsstype.value="SSEqury";
	document.RefineSearchenqu.action="<%=request.getContextPath()%>/manage-billing.html";
	document.RefineSearchenqu.submit();
}
</script>
<script type="text/javascript">
function vieweditpage(id,page){
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/vieweditpage",
	    data:  { 
	    	"uid" : id
	    },
	    success: function (response) {
        	if(page=="followup") window.location = "<%=request.getContextPath()%>/follow-up-billing.html";  
        	else if(page=="billing") window.location = "<%=request.getContextPath() %>/billing.html";  
        },
	});
}
</script>

<script>
$('.list_action_box').hover(function(){
	$(this).children().next().toggleClass("show");
}); 
</script>
<script>
$('.close_icon_btn').click(function(){
	$('.notify_box').hide();
});
$('.close_box').on( "click", function(e) { 
	$('.fixed_right_box').removeClass('active');
	$('.addnew').show();	
	});
</script>	
<script type="text/javascript">
$(document).ready(function() {
$('#multiple_item').select2();
});

$( document ).ready(function() {
	   var dateRangeDoAction="<%=transactionDateRangeAction%>";
	   if(dateRangeDoAction!="NA"){	  
		   $('input[name="date_range"]').val(dateRangeDoAction);
	   }
	});

$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var data=$(this).val();
	doAction(data,"transactionDateRangeAction");
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
	$("#Invoice_No").autocomplete({
		source : function(request, response) {			
			if(document.getElementById('Invoice_No').value.trim().length>=1)
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
            	doAction(ui.item.value,'transactionInvoiceAction');
            	location.reload();
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});
$(function() {
	$("#Client_Name").autocomplete({
		source : function(request, response) {
			if(document.getElementById('Client_Name').value.trim().length>=1)
			$.ajax({
				url : "get-client-details.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field :"clientname"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value,
							cid : item.cid
						};
					}));
				},
				error : function(error) {
					alert('error: ' + error.responseText);
				}
			});
		},
		select: function (event, ui) {
            if(!ui.item){}
            else{
            	doAction(ui.item.value,'transactionClientNameAction');            	
            	location.reload();
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});
	
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
	var baseName="<%=docBasePath%>";
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
			type : "Transaction"
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
</script>

</body>
</html>