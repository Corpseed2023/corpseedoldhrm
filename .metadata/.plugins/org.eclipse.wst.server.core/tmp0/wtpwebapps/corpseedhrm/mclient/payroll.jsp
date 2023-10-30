<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/> 
	<title>Payroll history</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	
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
						   <div class="clearfix mlft20">
                            <h3><i class="fa fa-inr"></i> 8500</h3>
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
                            <h3><i class="fa fa-inr"></i> 6500</h3>
							<span>Total Outstanding</span>
                           </div>
						  </div>
                          <div class="pad0 bdr_left col-md-3 col-sm-3 col-xs-6">
						   <div class="clearfix mlft20">
                            <h3><i class="fa fa-inr"></i> 2020</h3>
							<span>Past Due</span>
                           </div>
						  </div>
                        </div> 
				</div>
				
<div class="clearfix"> 
<form name="RefineSearchenqu" action="<%=request.getContextPath()%>/manage-billing.html" method="Post">
<div class="bg_wht clearfix mb10">  
<div class="row">
<div class="col-md-5 col-sm-5 col-xs-12"> 
<ul class="clearfix filter_menu">
<li class="active"><a>All</a></li>  
<li><a>Employee</a></li>
<li><a>Vendor</a></li>
</ul>
</div>
<div class="col-md-7 col-sm-7 col-xs-12">

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
						        <tr>
						            <th><span>#</span><input type="checkbox" class="pointers noDisplay" id="CheckAll"></th>
						            <th class="sorting">Date</th>
						            <th class="sorting">Name</th>
						            <th class="sorting">Department</th>
						            <th class="sorting">Designation</th>
						            <th class="sorting">Pay rate</th>
						            <th class="sorting">Running Balance</th>
						            <th class="sorting">Pay Method</th>
						            <th class="sorting">Status</th>
						            <th>Action</th>
						        </tr>
						    </thead>
						    <tbody>						   
						     						        
						    </tbody>
						</table> 
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
<h3 style="color: #42b0da;"><i class="fa fa-money"></i>Transfer</h3> 
<p>Add Refund Expenses for your department.</div>
<form onsubmit="return false;" id="Transfer_Funds">
<input type="hidden" id="UpdateCompanyKey">

<div class="clearfix inner_box_bg" style="margin-top: 30px;">

<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Amount :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
 <input type="text" name="expenseamount" id="Expense_Amount" placeholder="Amount" onblur="" class="form-control bdrd4" onkeypress="return isNumberKey(event)">
   </div>
  </div>
 </div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Date :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <input type="text" name="country" id="UpdateCountry" placeholder="Date" onblur="" class="form-control bdrd4 searchdate readonlyAllow" readonly="readonly">
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
  <input type="text" name="expenseamount" id="Expense_Amount" placeholder="Sales" onblur="" class="form-control bdrd4">
  </div>
  <div id="cityErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Deposite Account :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <input type="text" name="expenseamount" id="Expense_Amount" placeholder="Online" onblur="" class="form-control bdrd4">
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
<h3 style="color: #42b0da;"><i class="fa fa-money"></i>Add Income Refund</h3> 
<p>Add Refund Expenses for your department.</div>
<form onsubmit="return false;" id="RefundExpense">
<input type="hidden" id="UpdateCompanyKey">
<div class="row" style="margin-top: 40px;">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="expenseinvoice" id="ExpenseInvoice" placeholder="Invoice Number" onblur="" class="form-control bdrd4">
 </div>
  <div id="cnameErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="refundincomename" id="RefundIncomeName" placeholder="Name" onblur="" class="form-control bdrd4"">
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
  <input type="text" name="expenseamount" id="Expense_Amount" placeholder="Amount" onblur="" class="form-control bdrd4" onkeypress="return isNumberKey(event)">
  </div>
  <div id="cityErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Refund Type :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <select class="form-control bdrd4">
  <option>Type</option>
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
 <select class="form-control bdrd4">
  <option>Select</option>
  </select>
   </div>
  </div>
 </div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Refund Date :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <input type="text" name="country" id="UpdateCountry" placeholder="Date" onblur="" class="form-control bdrd4 searchdate readonlyAllow" readonly="readonly">
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

<div class="clearfix add_inner_box pad_box4 addcompany" id="add_Tax">
<div class="close_icon close_box"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-money"></i>Add New Tax</h3> 
<p>Add Tax for your department.</div>
<form onsubmit="return false;" id="AddNewTax">
<input type="hidden" id="UpdateCompanyKey">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group">
<label style="font-size: 12px;font-weight: normal;">Tax :<span style="color: #4ac4f3;">*</span></label>
 <div class="input-group"> 
 <input type="text" name="expenseinvoice" id="ExpenseInvoice" placeholder="Tax" onblur="" class="form-control bdrd4">
 </div>
  <div id="cnameErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group">
<label style="font-size: 12px;font-weight: normal;">Type of tax :<span style="color: #4ac4f3;">*</span></label>
 <div class="input-group">
 <input type="text" name="refundincomename" id="RefundIncomeName" placeholder="Type of tax" onblur="" class="form-control bdrd4"">
  </div>
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group">
<label style="font-size: 12px;font-weight: normal;">Tax % to be deducted:<span style="color: #4ac4f3;">*</span></label>
 <div class="input-group">
 <input type="text" name="refundincomename" id="RefundIncomeName" placeholder="Type of tax" onblur="" class="form-control bdrd4"">
  </div>
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Additional description :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <textarea class="form-control bdrd4" rows="3" name="expensenote" id="ExpenseNote" placeholder="Description" onblur="validateLocationPopup('UpdateAddress');validateValuePopup('UpdateAddress');" ></textarea>
  </div>
</div>
</div>

<div class="clearfix mtop10 mb10 text-right"> 
<button class="bt-link bt-radius bt-gray mrt10 close_box" type="button">Cancel</button>
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateUpdateCompany();">Submit</button>
</div>
</form>                                  
</div>

<div class="clearfix add_inner_box pad_box4 addcompany" id="add_expense">
<div class="close_icon close_box"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-money"></i>Add Expense</h3> 
<p>Add Expenses for your department.</div>
<form onsubmit="return false;" id="AddNewExpense">
<input type="hidden" id="UpdateCompanyKey">
<div class="row" style="margin-top: 40px;">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="expensename" id="ExpenseName" placeholder="Name" onblur="validCompanyNamePopup('ExpenseName');validateValuePopup('ExpenseName');" class="form-control bdrd4">
 </div>
  <div id="cnameErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="expensedate" id="ExpenseDate" placeholder="Date" onblur="validateNamePopup('ExpenseDate');validateValuePopup('ExpenseDate')" class="form-control bdrd4 searchdate readonlyAllow" readonly="readonly">
  </div>
  <div id="industryErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
<div class="clearfix inner_box_bg" style="margin-top: 30px;">
<div class="row">
<div class="col-md-4 col-sm-4 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Amount :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <input type="text" name="expenseamount" id="Expense_Amount" placeholder="Amount" onblur="" class="form-control bdrd4" onkeypress="return isNumberKey(event)">
  </div>
  <div id="cityErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-8 col-sm-8 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">How would you like to categorize this expense ? :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <select class="form-control bdrd4">
  <option value="">Expense Category</option>
  <option value="Advertising and Marketing">Advertising and Marketing</option>
  <option value="Bank Charges and Internet">Bank Charges and Internet</option>
  <option value="Contractor">Contractor</option>
  <option value="Cost of Goods Sold">Cost of Goods Sold</option>
  <option value="Deprecation">Deprecation</option>
  <option value="Insurance">Insurance</option>
  <option value="Management and Administration">Management and Administration</option>
  <option value="Meals and Entertainment">Meals and Entertainment</option>
  <option value="Payroll">Payroll</option>
  <option value="Personal">Office</option>
  <option value="Profesional Dues/Membership/License/Subscriptions">Profesional Dues/Membership/License/Subscriptions</option>
  <option value="Professional Services">Professional Services</option>
  <option value="Rent">Rent</option>
  <option value="Shipping and Postage">Shipping and Postage</option>
  <option value="Travel">Travel</option>
  <option value="Utilities">Utilities</option>
  <option value="Vehicle">Vehicle</option>
  <option value="Government Fees">Government Fees</option>
  </select>
  </div>
  <div id="stateErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
<div class="row" style="margin-top: 10px;">
<div class="col-md-4 col-sm-4 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Tax(If applicable) :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
<!--  <input type="text" name="country" id="UpdateCountry" placeholder="Country" onblur="validateCityPopup('UpdateCountry');validateValuePopup('UpdateCountry')" class="form-control bdrd4"> -->
   <select class="form-control" name="states[]" id="multiple_item" multiple>
  
</select>

   </div>
   <div id="countryErrorMSGdiv" class="errormsg"></div>
  </div>
 </div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Department :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <select class="form-control bdrd4">
  <option>Select</option>
  </select>
  </div>
  <div id="enqAddErrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Paid from account :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
 <select class="form-control bdrd4">
  <option>Select</option>
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
  <label>Address :<span style="color: #4ac4f3;">*</span></label>
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

<div class="clearfix add_inner_box pad_box4 addcompany" id="refund_expense">
<div class="close_icon close_box"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-money"></i>Add Expense Refund</h3> 
<p>Add Expenses for your department.</div>
<form onsubmit="return false;" id="RefundNewExpense">
<input type="hidden" id="UpdateCompanyKey">
<div class="row" style="margin-top: 40px;">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="expensename" id="ExpenseName" placeholder="Name" onblur="validCompanyNamePopup('ExpenseName');validateValuePopup('ExpenseName');" class="form-control bdrd4">
 </div>
  <div id="cnameErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="expensedate" id="ExpenseDate" placeholder="Date" onblur="validateNamePopup('ExpenseDate');validateValuePopup('ExpenseDate')" class="form-control bdrd4 searchdate readonlyAllow" readonly="readonly">
  </div>
  <div id="industryErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
<div class="clearfix inner_box_bg" style="margin-top: 30px;">
<div class="row">
<div class="col-md-4 col-sm-4 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Amount :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <input type="text" name="expenseamount" id="Expense_Amount" placeholder="Amount" onblur="" class="form-control bdrd4" onkeypress="return isNumberKey(event)">
  </div>
  <div id="cityErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-8 col-sm-8 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">How would you like to categorize this expense ? :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <select class="form-control bdrd4">
  <option value="">Expense Category</option>
  <option value="Advertising and Marketing">Advertising and Marketing</option>
  <option value="Bank Charges and Internet">Bank Charges and Internet</option>
  <option value="Contractor">Contractor</option>
  <option value="Cost of Goods Sold">Cost of Goods Sold</option>
  <option value="Deprecation">Deprecation</option>
  <option value="Insurance">Insurance</option>
  <option value="Management and Administration">Management and Administration</option>
  <option value="Meals and Entertainment">Meals and Entertainment</option>
  <option value="Payroll">Payroll</option>
  <option value="Personal">Office</option>
  <option value="Profesional Dues/Membership/License/Subscriptions">Profesional Dues/Membership/License/Subscriptions</option>
  <option value="Professional Services">Professional Services</option>
  <option value="Rent">Rent</option>
  <option value="Shipping and Postage">Shipping and Postage</option>
  <option value="Travel">Travel</option>
  <option value="Utilities">Utilities</option>
  <option value="Vehicle">Vehicle</option>
  <option value="Government Fees">Government Fees</option>
  </select>
  </div>
  <div id="stateErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
<div class="row" style="margin-top: 10px;">
<div class="col-md-4 col-sm-4 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Tax(If applicable) :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
  <input type="text" name="country" id="UpdateCountry" placeholder="Country" onblur="validateCityPopup('UpdateCountry');validateValuePopup('UpdateCountry')" class="form-control bdrd4">
   </div>
   <div id="countryErrorMSGdiv" class="errormsg"></div>
  </div>
 </div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Department :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <select class="form-control bdrd4">
  <option>Select</option>
  </select>
  </div>
  <div id="enqAddErrorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Paid from account :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
 <select class="form-control bdrd4">
  <option>Select</option>
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
  <label>Address :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <textarea class="form-control bdrd4" rows="3" name="expensenote" id="ExpenseNote" placeholder="Enter Note" onblur="validateLocationPopup('UpdateAddress');validateValuePopup('UpdateAddress');" ></textarea>
  </div>
</div>
</div>
</div>
<div class="clearfix mtop10 mb10 text-right"> 
<button class="bt-link bt-radius bt-gray mrt10 close_box" type="button">Cancel</button>
<!--<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateUpdateCompany();">Submit</button>-->
<button class="bt-link bt-radius bt-loadmore" type="button" data-toggle="modal" data-target="#taxModal">Add</button>
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
  
	<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>	
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>

	<script type="text/javascript">	
	function openTax(){

		$("#AddNewTax").trigger('reset');
		
		var id = $(".newtax").attr('data-related'); 
		$('.fixed_right_box').addClass('active');
		    $("div.add_inner_box").each(function(){
		        $(this).hide();
		        if($(this).attr('id') == id) {
		            $(this).show();
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
<script>
$(document).ready(function() {
$('#multiple_item').select2();
});
</script>

</body>
</html>