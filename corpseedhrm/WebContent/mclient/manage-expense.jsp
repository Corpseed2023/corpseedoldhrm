<%@page import="java.util.Properties"%>
<%@page import="commons.CommonHelper"%>
<%@page import="admin.enquiry.Enquiry_ACT"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/> 
	<title>Manage Expenses</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	<%if(!MX00){%><jsp:forward page="/login.html" /><%} %>
	<%
	//pagination start
	int pageNo=1;
	int rows=10;
	String sort="";
	String order=(String)session.getAttribute("expsortby_ord");
	if(order==null)order="desc";

	String sorting_order=(String)session.getAttribute("expsorting_order");
	if(sorting_order==null)sorting_order="";

	if(request.getParameter("page")!=null)pageNo=Integer.parseInt(request.getParameter("page"));
	if(request.getParameter("rows")!=null)rows=Integer.parseInt(request.getParameter("rows"));

	if(request.getParameter("sort")!=null)sort=request.getParameter("sort");
	Properties properties = new Properties();
	properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
	String domain=properties.getProperty("domain");
	String docBasePath=properties.getProperty("docBasePath");
	String sort_url=domain+"manageexpenses.html?page="+pageNo+"&rows="+rows;

	//pagination end	
	
String addedby= (String)session.getAttribute("loginuID");
String loginuaid = (String)session.getAttribute("loginuaid"); 

String expClientName=(String)session.getAttribute("expClientName");
if(expClientName==null||expClientName.length()<=0)expClientName="NA";

String expContactMobile=(String)session.getAttribute("expContactMobile");
if(expContactMobile==null||expContactMobile.length()<=0)expContactMobile="NA";

String expenseDateRangeAction=(String)session.getAttribute("expenseDateRangeAction");
if(expenseDateRangeAction==null||expenseDateRangeAction.length()<=0)expenseDateRangeAction="NA";

String userroll= (String)session.getAttribute("emproleid"); 
String token=(String)session.getAttribute("uavalidtokenno");
/* double convertedSalesAmt=0;
double convertedSalesDues=0; 
double pastDue=0; 
convertedSalesAmt=Clientmaster_ACT.getTotalSalesPaidAmount(billingClientName,billingInvoiceNo,billingDateRangeAction,billingDoAction,token);
convertedSalesDues=Clientmaster_ACT.getSalesDueAmount(billingClientName,billingInvoiceNo,billingDateRangeAction,billingDoAction,token); 
pastDue=Clientmaster_ACT.getSalesPastDue(billingClientName,billingInvoiceNo,billingDateRangeAction,billingDoAction,token); */
%>

	<div id="content">
		<div class="main-content">
			<div class="container-fluid">				
				<div class="box_shadow1 invoice_info redius_box pad_box4 bg_wht mb30 DispNone">
                        <div class="clearfix dashboard_info">
                          <div class="pad0 col-md-3 col-sm-3 col-xs-6">
						   <div class="clearfix mlft20">
                            <h3><i class="fa fa-inr"></i>0</h3>
							<span>Fiscal Year Total</span>
						   </div>
                          </div>
                          <div class="pad0 bdr_left col-md-3 col-sm-3 col-xs-6">
						   <div class="clearfix mlft20">
                            <h3><i class="fa fa-inr"></i> 50 days</h3>
							<span>Average Time To Pay</span>
                           </div>
						  </div>
                          <div class="pad0 bdr_left col-md-3 col-sm-3 col-xs-6">
						   <div class="clearfix mlft20">
                            <h3><i class="fa fa-inr"></i>0</h3>
							<span>Total Outstanding</span>
                           </div>
						  </div>
                          <div class="pad0 bdr_left col-md-3 col-sm-3 col-xs-6">
						   <div class="clearfix mlft20">
                            <h3><i class="fa fa-inr"></i>0</h3>
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
<div class="col-md-5 col-sm-5 col-xs-12">
 
<!-- <ul class="clearfix filter_menu">
<li class="active"><a>Approve Expense</a></li>  
</ul> -->
<div class="col-md-4">
<a href="javascript:void(0)"><button type="button" class="filtermenu dropbtn expense" style="margin-left: -14px;" data-related="add_expense" onclick="openExpense()">+&nbsp;Add Expense</button></a>
</div>
</div>
<div class="col-md-7 col-sm-7 col-xs-12">
<div class="clearfix flex_box justify_end">  
<div class="item-bestsell col-md-4 col-sm-1 col-xs-12">
<p><input type="search" name="clientname" id="ClientName" autocomplete="off" <% if(!expClientName.equalsIgnoreCase("NA")){ %>onsearch="clearSession('expClientName');location.reload();" value="<%=expClientName%>"<%} %> placeholder="Search by client.." class="form-control"/>
</p>
</div>
<div class="item-bestsell col-md-4 col-sm-1 col-xs-12">
<p><input type="search" name="contactmobile" id="contactMobile" autocomplete="off" <% if(!expContactMobile.equalsIgnoreCase("NA")){ %>onsearch="clearSession('expContactMobile');location.reload();" value="<%=expContactMobile%>"<%} %> placeholder="Search by contact phone" class="form-control"/>
</p>
</div>
<div class="item-bestsell col-md-4 col-sm-1 col-xs-12 has-clear"> 
<p><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="FROM - TO" class="form-control text-center date_range pointers <%if(!expenseDateRangeAction.equalsIgnoreCase("NA")){%>selected<%} %>" readonly="readonly"/>
<span class="form-control-clear form-control-feedback" onclick="clearSession('expenseDateRangeAction');location.reload();"></span>
</p>
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
      <table  class="ctable">
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
    <th width="100" class="sorting <%if(sort.equals("date")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','date','<%=order%>','expsorting_order','expsortby_ord')">Date</th>
   <th class="sorting <%if(sort.equals("client")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','client','<%=order%>','expsorting_order','expsortby_ord')">Company</th>
   <th class="sorting <%if(sort.equals("phone")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','phone','<%=order%>','expsorting_order','expsortby_ord')">Phone</th>
   <th width="120" class="sorting <%if(sort.equals("amount")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','amount','<%=order%>','expsorting_order','expsortby_ord')">Amount</th>
   <th class="sorting <%if(sort.equals("category")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','category','<%=order%>','expsorting_order','expsortby_ord')">Category</th>
   <th class="sorting <%if(sort.equals("department")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','department','<%=order%>','expsorting_order','expsortby_ord')">Department</th>
   <th class="sorting <%if(sort.equals("account")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','account','<%=order%>','expsorting_order','expsortby_ord')">Account</th>
        <th>Added by</th>
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
String[][] approveExpense=TaskMaster_ACT.getAllApprovalExpense(token,expenseDateRangeAction,pageNo,rows,sort,order,expClientName,expContactMobile);
int totalExpense=TaskMaster_ACT.countAllApprovalExpense(token,expenseDateRangeAction,expClientName,expContactMobile);
      if(approveExpense!=null&&approveExpense.length>0){
      	ssn=rows*(pageNo-1);
    	  totalPages=(totalExpense/rows);
    	  if((totalExpense%rows)!=0)totalPages+=1;
    	  showing=ssn+1;
    	  if (totalPages > 1) {     	 
    		  if((endRange-2)==totalPages)startRange=pageNo-4;        
              if(startRange==pageNo)endRange=pageNo+4;
              if(startRange<1) {startRange=1;endRange=startRange+4;}
              if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
              if(startRange<1)startRange=1;
         }else{startRange=0;endRange=0;}
       for(int i=0;i<approveExpense.length;i++) {	  
      	 String addedbyName=Usermaster_ACT.getLoginUserName(approveExpense[i][10], token);
      	 String sclass="text-success";
      	 String status="Approved";
      	 if(approveExpense[i][11].equals("3")){
      		 status="Not Approved";
      		 sclass="text-danger";
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
      <div class="line"></div>
    </td>
   
  </tr>
                           
        <tr id="<%=approveExpense[i][0]%>">
            <td><input type="checkbox" name="checkbox" id="checkbox" class="checked"></td>
            <td><%=approveExpense[i][1] %></td>
            <td><%=approveExpense[i][2] %></td>
            <td><%=approveExpense[i][3] %></td>
            <td><a href="javascript:void(0)" onclick="showExpenseDetails('<%=approveExpense[i][0]%>')">
            <i class="fas fa-inr"></i>&nbsp;<%if(!approveExpense[i][4].contains(",")){ %>
            <%=CommonHelper.withLargeIntegers(Double.parseDouble(approveExpense[i][4])) %><%}else{ %>
           	<%=approveExpense[i][4]%><%} %>
            </a>
            </td>
            <td><%=approveExpense[i][5] %></td>
            <td><%=approveExpense[i][7] %></td>
            <td><%=approveExpense[i][8] %></td>						            	
            <td><%=addedbyName%></td>
            <%if(approveExpense[i][11].equals("2")){ %>
			<td class="list_icon text-center" onclick="approveExpense('<%=approveExpense[i][0]%>','<%=approveExpense[i][12]%>','<%=approveExpense[i][13]%>','<%=addedbyName%>','<%=approveExpense[i][11]%>','<%=approveExpense[i][1]%>')">
			<i class="fas fa-long-arrow-alt-up pointers"></i>
			</td><%}else if(approveExpense[i][11].equals("4")){ %>
			<td class="list_icon">
			<a href="javascript:void(0)" class="text-warning pointers" onclick="showHoldExpense('<%=approveExpense[i][0]%>','<%=approveExpense[i][12]%>','<%=approveExpense[i][13]%>','<%=addedbyName%>','<%=approveExpense[i][11]%>','<%=approveExpense[i][1]%>')">On-Hold</a>
			</td>
			<%}else{%>
			<td><a href="javascript:void(0)" class="<%=sclass%>" onclick="showHistory('<%=approveExpense[i][0]%>','<%=approveExpense[i][12]%>','<%=approveExpense[i][13]%>','<%=addedbyName%>','<%=approveExpense[i][11]%>','<%=approveExpense[i][1]%>')"><%=status%></a></td><%} %>
        </tr>
     <%}}%>
                           
    </tbody>
</table>
</div>
<div class="filtertable">
  <span>Showing <%=showing %> to <%=ssn+approveExpense.length %> of <%=totalExpense %> entries</span>
  <div class="pagination">
    <ul> <%if(pageNo>1){ %>
      <li class="page-item">	                     
      <a class="page-link text-primary" href="<%=request.getContextPath()%>/manageexpenses.html?page=1&rows=<%=rows%>">First</a>
   </li><%} %>
    <li class="page-item">					      
      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/manageexpenses.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
    </li>  
      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
	    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
	    <a class="page-link" href="<%=request.getContextPath()%>/manageexpenses.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
	    </li>   
	  <%} %>
	   <li class="page-item">						      
	      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/manageexpenses.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
	   </li><%if(pageNo<=(totalPages-1)){ %>
	   <li class="page-item">
	      <a class="page-link text-primary" href="<%=request.getContextPath()%>/manageexpenses.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
	   </li><%} %>
	</ul>
	</div>
	<select class="select2" onchange="changeRows(this.value,'manageexpenses.html?page=1','<%=domain%>')">
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
<div class="fixed_right_box">
<div class="clearfix add_inner_box pad_box4 addcompany" id="add_expense">
<div class="close_icon close_box"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fas fa-inr"></i>New Expense</h3> 
<p>Add Expenses for your department.</div>
<form onsubmit="return false" method="post" id="AddNewExpense">
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" autocomplete="off" name="addexpenseclientname" id="AddExpenseClientName" placeholder="Client's name.." onblur="validCompanyNamePopup('AddExpenseClientName');validateValuePopup('AddExpenseClientName');" class="form-control bdrd4">
 </div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" autocomplete="off" maxlength="10" name="addexpenseClientContactNumber" id="AddExpenseClientContactNumber" placeholder="Contact number.." onblur="validateMobilePopup('AddExpenseClientContactNumber');validateValuePopup('AddExpenseClientContactNumber')" class="form-control bdrd4" onkeypress="return isNumberKey(event)">
  </div>
  <div id="industryErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
<div class="clearfix inner_box_bg" style="margin-top: 10px;">
<div class="row">
<div class="col-md-4 col-sm-4 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Total amount :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <input type="text" autocomplete="off" name="addexpenseamount" id="AddExpense_Amount" placeholder="Total amount.." class="form-control bdrd4" onkeyup="return validateNumber(this)">
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
  <option value="Re-submission">Re-submission</option>
  </select>
  </div>
 </div>
</div>
</div>
<div class="row" style="margin-top: 10px;">
<div class="col-md-4 col-sm-4 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">HSN (Tax if applicable) :</label>
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
<!--   <input type="text" autocomplete="off" name="addexpensedepartment" id="AddExpenseDepartment" onblur="validateValuePopup('ExpenseDepartment');" placeholder="Department here..." class="form-control bdrd4"> -->
  <select id="AddExpenseDepartment" name="addexpensedepartment" class="form-control bdrd4">
	<option value="">Select department</option>
  	<option value="Account">Account</option>
  	<option value="Sales">Delivery</option>
  	<option value="HR">HR</option>
  	<option value="IT">IT</option>
  	<option value="Marketing">Marketing</option>  	
  	<option value="Quality">Quality</option>
  	<option value="Sales">Sales</option>
  </select>
  </div>
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
</div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12" style="margin-top: 10px;">
<div class="form-group">
  <label>Notes :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <textarea class="form-control bdrd4" autocomplete="off" rows="3" name="addexpensenote" id="AddExpenseNote" placeholder="Enter Note" onblur="validateLocationPopup('AddExpenseNote');validateValuePopup('AddExpenseNote');" ></textarea>
  </div>
</div>
</div>
</div>
<div class="clearfix mtop10 mb10 text-right"> 
<button class="bt-link bt-radius bt-gray mrt10 close_box closeAddExpenseBtn" type="button">Cancel</button>
<button class="bt-link bt-radius bt-loadmore" type="submit" id="exp_btn" onclick="return validateAddExpense()">Submit</button>
</div>
</form>                                  
</div>
</div>

<div class="modal fade" id="warningApprove" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;">
        <span class="text-danger" id="warningApproveHead">Expense : project no - project name  ?</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <div class="modal-body">
        <div class="modal-body">
        <div class="box_shadow1 relative_box mb10" style="width: 100%" id="expenseAddedByNotes">		
		</div>
		  <div class="box_shadow1 relative_box" style="width: 100%" id="appendComment"></div>
		  <h5>Add Comment : </h5>
		  <p><textarea rows="4" id="approvalComment" class="form-control" required="required"></textarea></p>
		</div>
      </div>
      <input type="hidden" id="ExpenseApproveKey" value="NA"/>      
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" style="width: 15%;">No</button>
        <button type="button" class="btn btn-primary" style="width: 15%;" onclick="approveExpenseAmount('ExpenseApproveKey','1')">Approve</button>
        <button type="button" class="btn btn-danger" style="width: 15%;" onclick="approveExpenseAmount('ExpenseApproveKey','3')">Decline</button>
        <button type="button" class="btn btn-warning" id="ExpenseHoldBtn" style="width: 15%;" onclick="approveExpenseAmount('ExpenseApproveKey','4')">On-Hold</button>
      </div>
    </div>
  </div>
</div>
<div class="modal fade" id="expenseHistory" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;">
        <span class="text-danger" id="warningApproveHeadH">Expense : project no - project name  ?</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <div class="modal-body">
        <div class="modal-body">
        <div id="expenseAddedByNotesH">		
		</div>		  
		</div>
      </div>     
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" style="width: 15%;">Close</button>       
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
            	<option value="expdate">Date</option>
            	<option value="expclientname">Client</option>
            	<option value="expclientmobile">Contact No.</option>
            	<option value="expamount">Amount</option>
            	<option value="expcategory">Category</option>
            	<option value="expdepartment">Department</option>
            	<option value="expaccount">Account</option>            	
            	<option value="expaddedbyuid">Added by</option>
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
<div class="modal fade" id="ExpenseData" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;">
        <span class="fas fa-file-export text-primary" style="margin-right: 10px;"> </span>
        <span class="text-primary">Expense Details</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <form action="return false">
       <div class="modal-body">
  <div class="container-fluid" id="expenseBody">
  
  </div>
</div>
      </form>
    </div>
  </div>
</div>
	<p id="end" style="display:none;"></p>
	</div>
	<div class="noDisplay"><a href="" id="DownloadExportedLink" download><button id="DownloadExported">Download</button></a></div>
	<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>	
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>

<script type="text/javascript">
function approveExpense(expKey,salesKey,taskKey,addedBy,status,postDate){
	$("#ExpenseApproveKey").val(expKey);
	showLoader();
	$.ajax({
	    type: "GET",
	    url: "<%=request.getContextPath()%>/GetSalesAndTaskHeading111",
	    data:  { 
	    	salesKey : salesKey,
	    	taskKey : taskKey,
	    	expKey : expKey,
	    	status : status,
	    	addedBy : addedBy,
	    	postDate : postDate
	    },
	    success: function (response) {
	    	var x=response.split("#"); 
	    	$("#warningApproveHead").html(x[0]);
	    	$("#expenseAddedByNotes").html(x[1]);
	    	if(status=="4")$("#appendComment").html(x[2]);
	    	$("#warningApprove").modal("show");
        },
    	complete : function(data){
    		hideLoader();
    	}
	});
	
	
}
function approveExpenseAmount(expKeyBoxId,approveStatus){
	var expKey=$("#"+expKeyBoxId).val();
	var comment=$("#approvalComment").val();
	if(comment==null||comment==""){
		document.getElementById('errorMsg').innerHTML = 'Please add comment !!';
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(expKey==null||expKey==""){
		document.getElementById('errorMsg').innerHTML = 'Something Went Wrong , Try-Again Later.';
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}else{
		showLoader();
		$.ajax({
		    type: "POST",
		    url: "<%=request.getContextPath()%>/ApproveThisExpense111",
		    data:  { 
		    	expKey : expKey,
		    	approveStatus : approveStatus,
		    	comment : comment
		    },
		    success: function (response) {
	        	if(response=="pass"){
	        		$("#warningApprove").modal("hide");
	        		if(approveStatus=="1"){
	        			document.getElementById('errorMsg1').innerHTML = 'Successfully approved !!';
	        			$('.alert-show1').show().delay(2000).fadeOut();
	        			setTimeout(() => {
							location.reload();
						}, 2000);
	        		}else if(approveStatus=="4"){
	        			document.getElementById('errorMsg').innerHTML = 'Expense is on-hold !!';
	        			$('.alert-show').show().delay(2000).fadeOut();
	        			setTimeout(() => {
							location.reload();
						}, 2000);
	        		}else{
	        			document.getElementById('errorMsg').innerHTML = 'Expense Not Approved !!';
	        			$('.alert-show').show().delay(2000).fadeOut();
	        			setTimeout(() => {
							location.reload();
						}, 2000);
	        		}
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
}
</script>

<script type="text/javascript">
$('.list_action_box').hover(function(){
	$(this).children().next().toggleClass("show");
}); 

</script>

<script type="text/javascript">
$( document ).ready(function() {
	   var dateRangeDoAction="<%=expenseDateRangeAction%>";
	   if(dateRangeDoAction!="NA"){	  
		   $('input[name="date_range"]').val(dateRangeDoAction);
	   }
	});

$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var data=$(this).val();
	doAction(data,"expenseDateRangeAction");
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
			type : "Approve_Expense"
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
$('.close_box').on( "click", function(e) { 
	$('.fixed_right_box').removeClass('active');	
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
            	document.getElementById('errorMsg').innerHTML ="HSN number doesn't exist !!";
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
function validateAddExpense(){	
	var expname=$("#AddExpenseClientName").val().trim();
	var expNumber=$("#AddExpenseClientContactNumber").val().trim();
	var expAmount=$("#AddExpense_Amount").val().trim();
	var expCategory=$("#AddExpenseCategory").val().trim();
	var expHSN=$("#AddHSN_Code").val().trim();
	var expDepartment=$("#AddExpenseDepartment").val().trim();
	var expAccount=$("#AddPaidFromAccount").val().trim();
	var expNote=$("#AddExpenseNote").val().trim();
	var salesKey="NA";
	
	if(expname==null||expname==""){
		document.getElementById('errorMsg').innerHTML ="Please enter client's name  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}
	if(expNumber==null||expNumber==""){
		document.getElementById('errorMsg').innerHTML ="Please enter client's contact number  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}
	if(expAmount==null||expAmount==""){
		document.getElementById('errorMsg').innerHTML ="Please enter expense amount  !!";    	
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
	var task_name="NA";
	var assignKey="NA";
	var approveBy="<%=loginuaid%>";
	showLoader();
	$.ajax({
		type : "POST",
		url : "AddExpenseApproval111",
		dataType : "HTML",
		data : {				
			expname : expname,
			expNumber : expNumber,
			expAmount : expAmount,
			expCategory : expCategory,
			expHSN : expHSN,
			expDepartment : expDepartment,
			expAccount : expAccount,
			expNote : expNote,
			salesKey : salesKey,
			task_name : task_name,
			assignKey : assignKey,
			approvalStatus : "1",
			approveBy : approveBy
		},
		success : function(data){
			if(data=="pass"){
				document.getElementById('errorMsg1').innerHTML = 'Successfully expense added for approval !!';				
				 $('.closeAddExpenseBtn').click();				
				$('.alert-show1').show().delay(2000).fadeOut();		
				setTimeout(() => {
					location.reload();
				}, 2000);
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try-again Sometime later !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function(data){
			hideLoader();
		}
	});
	
}
function showInformation(){
	$("#expenseInfo").modal("show");
}
function showHoldExpense(expKey,salesKey,taskKey,addedBy,status,postDate){
	$("#ExpenseApproveKey").val(expKey);
	$("#ExpenseHoldBtn").hide();
	showLoader();
	$.ajax({
	    type: "GET",
	    url: "<%=request.getContextPath()%>/GetSalesAndTaskHeading111",
	    data:  { 
	    	expKey : expKey,
	    	salesKey : salesKey,
	    	taskKey : taskKey,
	    	status : status,
	    	addedBy : addedBy,
	    	postDate : postDate
	    },
	    success: function (response) {
	    	var x=response.split("#"); 
	    	$("#warningApproveHead").html(x[0]);
	    	$("#expenseAddedByNotes").html(x[1]);
	    	if(status=="4")$("#appendComment").html(x[2]);
	    	$("#warningApprove").modal("show");
        },
    	complete : function(data){
    		hideLoader();
    	}
	});	
}
function showHistory(expKey,salesKey,taskKey,addedBy,status,postDate){
	showLoader();
	$.ajax({
	    type: "GET",
	    url: "<%=request.getContextPath()%>/GetExpenseHistory111",
	    data:  { 
	    	expKey : expKey,
	    	salesKey : salesKey,
	    	taskKey : taskKey,
	    	status : status,
	    	addedBy : addedBy,
	    	postDate : postDate
	    },
	    success: function (response) {
	    	var x=response.split("#"); 
	    	$("#warningApproveHeadH").html(x[0]);
	    	$("#expenseAddedByNotesH").html(x[1]);
	    	$("#expenseHistory").modal("show");
        },
    	complete : function(data){
    		hideLoader();
    	}
	});	
}
// ExpenseData
function showExpenseDetails(expKey){
	showLoader();
	$.ajax({
	    type: "GET",
	    url: "<%=request.getContextPath()%>/GetExpenseDetails111",
	    data:  { 
	    	expKey : expKey
	    },
	    success: function (response) {
	    	$("#expenseBody").html(response);
	    	$("#ExpenseData").modal("show");
        },
    	complete : function(data){
    		hideLoader();
    	}
	});	
}
//ClientName expClientName contactMobile expContactMobile
$(function() {
	$("#contactMobile").autocomplete({
		source : function(request, response) {			
			$.ajax({
				url : "get-client-details.html",
				type : "GET",
				dataType : "JSON",
				data : {
					name : request.term,
					"field" : "expensecontactmobile"
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
            	doAction(ui.item.value,'expContactMobile');
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
			$.ajax({
				url : "get-client-details.html",
				type : "GET",
				dataType : "JSON",
				data : {
					name : request.term,
					"field" : "expenseclientname"
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
            	doAction(ui.item.value,'expClientName');
            	location.reload();
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});
</script>
</body>
</html>