<!doctype html>

<%@page import="java.util.Random"%>
<%@page import="java.util.Properties"%>
<%@page import="commons.CommonHelper"%>
<%@page import="commons.DateUtil"%>
<%@page import="hcustbackend.ClientACT"%>
<html lang="en">
<head>  
  <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<%@ include file="includes/client-header-css.jsp" %>
    <title>corpSeed-payments</title>
</head>
<body id="mySite" style="display: block">
<%@ include file="includes/checkvalid_client.jsp" %>
<!-- main content starts -->
<%

String today=DateUtil.getCurrentDateIndianFormat1();
//get token no from session
String token=(String)session.getAttribute("uavalidtokenno");
String loginUaid = (String) session.getAttribute("loginuaid");
// String userRole=(String)session.getAttribute("userRole");
// if(userRole==null||userRole.length()<=0)userRole="NA";

String ClientOrderSearchInvoice=(String)session.getAttribute("ClientOrderSearchInvoice");
if(ClientOrderSearchInvoice==null||ClientOrderSearchInvoice.length()<=0)ClientOrderSearchInvoice="NA";

String searchFromToDate=(String)session.getAttribute("PaymentSearchFromToDate");
if(searchFromToDate==null||searchFromToDate.length()<=0)searchFromToDate="NA";

String sortBy=(String)session.getAttribute("PaymentSearchOrderSorting");
if(sortBy==null||sortBy.length()<=0)sortBy="desc";	

Properties properties = new Properties();
properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));
String domain=properties.getProperty("domain");
String docBasePath=properties.getProperty("docBasePath");

long pageLimit=10;
String pageLimit1=(String)session.getAttribute("paymentPageLimit");
if(pageLimit1!=null&&pageLimit1.length()>0)pageLimit=Long.parseLong(pageLimit1);


long pageStart=1;
String pageStart1=(String)session.getAttribute("paymentPageStart");
if(pageStart1!=null&&pageStart1.length()>0)pageStart=Long.parseLong(pageStart1);

long pageEnd=10;
String pageEnd1=(String)session.getAttribute("paymentPageEnd");
if(pageEnd1!=null&&pageEnd1.length()>0)pageEnd=Long.parseLong(pageEnd1);

long count=pageEnd/pageLimit;

Random randomGenerator = new Random();
long randomInt = randomGenerator.nextInt(100000000);
%>
<section class="main clearfix">
  <%@ include file="includes/client_header_menu.jsp" %>
  <section class=" payment clearfix">
    <div class="container-fluid">
      <div class="container">
       <div class="row">
        <div class="col-12 p-0">
          
          <div class="box_bg payment-box"> 
		  <div class="clearfix document_page">   
            
		  <div class="row mbt12 sticky_top">
		  <div class="col-lg-6 col-md-6 col-sm-12 col-12">
		
		  </div>
		  <div class="col-lg-6 col-md-6 col-sm-12 col-12">
          <div class="form-group-orders"> 
              <div class="m_width80 inbox_input" <%if(!ClientOrderSearchInvoice.equalsIgnoreCase("NA")){%>style="display: block;"<%} %>>
              <input class="form-control-search" id="SearchOrder" type="search" placeholder="Search"  onsearch="removeSearchOption('ClientOrderSearchInvoice')"
               <%if(!ClientOrderSearchInvoice.equalsIgnoreCase("NA")){%>value="<%=ClientOrderSearchInvoice%>"<%} %>> 
              <i class="fa fa-search" aria-hidden="true"></i> 			
			  </div>
			  <i class="fas fa-long-arrow-alt-left" id="backico" <%if(!ClientOrderSearchInvoice.equalsIgnoreCase("NA")){%>style="display: block;"<%} %>></i>			  
			  <div class="inbox-chatlist"> 
			  <button type="button" id="search" <%if(sortBy.equalsIgnoreCase("desc")){ %> onClick="doAction('asc','PaymentSearchOrderSorting')" title="Sort by : ascending"<%}else{ %>onClick="doAction('desc','PaymentSearchOrderSorting')"  title="Sort by : descending"<%} %>><i class="fa fa-list icon-circle"></i></button>
              <button class="calendar_box" type="button" title="Search by date"><i class="fa fa-calendar-times icon-circle"></i>
			  <input type="text" class="form-control" <%if(!searchFromToDate.equalsIgnoreCase("NA")){ %>value="<%=searchFromToDate %>"<%} %> name="date_range" id="date_range" readonly="readonly"/>
			  </button>
			  <%if(!searchFromToDate.equalsIgnoreCase("NA")){ %>
			  <button type="button" title="Clear date" style="position: absolute;right: -41px;" onclick="removeSearchOption('PaymentSearchFromToDate')"><i class="fas fa-times icon-circle" aria-hidden="true"></i></button>
			  <%} %></div>
		  </div>
		  	<a href="javascript:void(0)" class="mobilesearchico"> <i class="fa fa-search " aria-hidden="true"></i> </a>
		  	<div class="pageheading">
          <h2>Payment</h2>
          </div>
		  </div>
		  </div>
		   <div class="row">
        <div class="col-sm-12 bg_whitee">
		    <div class="row ">
		<div class="col-md-12">  
		<div class="table-responsive">
			<table class="ctable">
						    <thead>
						        <tr>
						            <th class="td_hide">S.No.</th>
						            <th >Estimate/Invoice</th>
						            <th>Total</th>
						            <th class="td_hide">Due</th>
						            <th class="td_hide">Status</th>
						            <th>Action</th>
						        </tr>
						    </thead>
						    <tbody>
						    <%
						    String billing[][]=ClientACT.getClientBilling(loginUaid,sortBy,searchFromToDate,ClientOrderSearchInvoice,token,pageLimit,pageStart,userRole); 
						    if(billing!=null&&billing.length>0){
						  	  for(int i=0;i<billing.length;i++){
						  		  String estKey=ClientACT.getEstimateKey(billing[i][2],token);
						  		  String status="Partial";
						  		  String color="#42b0da";
						  		  String invoice=billing[i][2];
						  		  if(Double.parseDouble(billing[i][7])<=0){status="Completed";color="#29ba29";invoice=billing[i][3];}
                           %>
						        <tr>
						            <td class="td_hide"><%=(i+1) %></td>
						            <td><%=invoice %></td>
						            <td><i class="fa fa-inr"></i>&nbsp;<%=CommonHelper.withLargeIntegers(Double.parseDouble(billing[i][5])) %></td>
						            <td class="td_hide"><i class="fa fa-inr"></i>&nbsp;<%=CommonHelper.withLargeIntegers(Double.parseDouble(billing[i][7])) %></td>
						            <td style="color: <%=color%>;" class="td_hide"><%=status %></td>
						            <td class="list_action_box list_icon"><a href="#" class="icoo"><i class="fas fa-angle-down " aria-hidden="true"></i><i class="fa fa-angle-up "></i></a>
						            <ul class="dropdown_list">
									  <%if(Double.parseDouble(billing[i][7])>0){ %><li><a class="pointers" data-toggle="modal" data-target="#paymentModal" onclick="setSalesKey('<%=billing[i][3] %>','<%=billing[i][7]%>')">Pay Now</a></li><%} %>
									  <li><a class="pointers" href="<%=request.getContextPath() %>/invoice-<%=estKey%>.html" target="_blank">Invoice</a></li>
									  <li><a class="pointers historybox" data-related="payment_history" onclick="openPaymentHistory('<%=invoice%>')">Payment History</a></li> 
									</ul>
						            </td>						            				
						        </tr>
						     <%}}%>                                 
						    </tbody>
						</table>
						<div class="col-md-12 row page-range">
			            <div class="col-md-9"></div>
			            <div class="col-md-1 col-md-offset-9">
							<select name="pageShow" id="PageShow"<%if(billing.length>=10){ %> onchange="pageLimit(this.value)"<%} %>>
							    <option value="10" <%if(pageLimit==10){ %>selected<%} %>>10</option>
							    <option value="20" <%if(pageLimit==20){ %>selected<%} %>>20</option>
							    <option value="40" <%if(pageLimit==40){ %>selected<%} %>>40</option>
							    <option value="80" <%if(pageLimit==80){ %>selected<%} %>>80</option>
							</select>
						</div>
					    <div class="col-md-2 text-center">
					    <i class="fas fa-chevron-left pointers" <%if(pageStart>1){ %>onclick="backwardPage()"<%} %>></i><span><%=pageStart %>-<%=pageEnd %></span><i class="fas fa-chevron-right pointers" <%if(billing!=null&&billing.length>=pageLimit){ %>onclick="forwardPage()"<%} %>></i>
					    </div>
					  </div>
						</div>
						
		</div> 
		</div> 
	</div> 
		</div> 
		  <ul class="nav nav-tabs" id="myTab" role="tablist" style="width: 100%; display:none;">
              <li class="nav-item active" style="width: 50%;">
                <a class="nav-link" id="details-tab" data-toggle="tab" href="#details" role="tab" aria-controls="details" aria-selected="false"  style="padding: 0"><button type="button" class="btn btn-payment">PAYMENT HISTORY</button></a>
              </li>
              <li class="nav-item" style="width: 50%;">
                <a class="nav-link" id="profile-tab" data-toggle="tab" href="#profile" role="tab" aria-controls="profile" aria-selected="true" style="padding: 0;"><button type="button" class="btn btn-payment">BANK ACCOUNT</button></a>
              </li>
          </ul>
          <div class="tab-content" id="myTabContent">
            <div class="tab-pane fade show" id="details" role="tabpanel" aria-labelledby="details-tab">
            <div class="row">
              <div class="col-md-12">
                <div class="sort-order" style="text-align: center;">
                <p class="d-xl-inline d-lg-inline d-md-inline d-sm-inline d-block" style="color: #6FDA44;">Sort by Date</p>
                <select class="form-control-orders" id="form-control-order-id">
                  <option value="0">01-Jan-2018</option>
                  <option value="1">...</option>
                </select>
                <p style="color: #6FDA44">To</p>
                <select class="form-control-orders" id="form-control-order-id">
                  <option value="0">30-Jan-2018</option>
                  <option value="1">...</option>
                </select>
              </div>
              </div> 
              </div>
            </div>
            
            <div class="tab-pane fade show" id="profile" role="tabpanel" aria-labelledby="profile-tab"> 
              <img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/slider.png" alt="">
              <img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/broken-link.png" alt="" id="broken">
              <h1>Update your bank account to receive direct payments in  your account.</h1>
              <button type="button" class="default bg text-white" style="box-shadow: none;" onClick="document.getElementById('profile').style.display='none';document.getElementById('AddPaymentMethod').style.display='block';">ADD BANK ACCOUNT</button>
              </div>
              <div class="tab-pane fade active show" id="AddPaymentMethod" role="tabpanel" aria-labelledby="profile-tab" style="display: none;"> 
            <img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/slider.png" alt="">
              <div class="form-row">
                <div class="form-group-payment col-md-6 col-sm-12 col-12 text-left">
                  <label for="account" style="color: #2A353E;">Beneficiary Account No.</label>
                  <input type="text" class="form-control" id="account1">
                </div>
                <div class="form-group-payment col-md-6 col-sm-12 col-12 text-left">
                  <label for="account" style="color: #2A353E;">Re-enter Beneficiary Account No.</label>
                    <input type="text" class="form-control" id="account2">
                  </div>
                <div class="form-group-payment col-md-6 col-sm-12 col-12 text-left">
                  <label for="account" style="color: #2A353E;">Name on bank account</label>
                  <input type="text" class="form-control" id="account3">
                </div>
                <div class="form-group-payment col-md-6 col-sm-12 col-12 text-left">
                  <label for="account" style="color: #2A353E;">IFSC Code</label>
                  <input type="text" class="form-control" id="account4">
                </div>
                <div class="form-group-payment col-12 text-center mb-5">
                  <label for="account" style="color: #2A353E;">Account type</label>
                  <select class="search-dashboard" id="sav-act" style="font-family: Montserrat-Regular;display: block;color: #434B52;font-size: 17px;text-align: left;width: 50%;margin: auto;">
                    <option value="0">Saving Account  </option>
                    <option value="1">Current Account </option>
                  </select>
                </div>
               </div>
            <a href="add-payment-password.html"><button type="button" class="default bg text-white" style="box-shadow: none;">Submit</button></a>
            </div>
          </div>
        </div>
		</div>
	  </div>
	 </div>
    </div>
  </div>
</section>
</section>
<!-- main content ends -->

<!-- Payment Modal -->
  <div class="myModal modal fade" id="paymentModal1">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title"><i class="fa fa-credit-card" aria-hidden="true"></i>+Add Payments</h4>  
          <button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>
        <div class="modal-body">
          <ul class="payment_tab nav nav-tabs">
		  <li class="active"><a data-toggle="tab" href="#pay_method1"><img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/mastercard.png" alt=""></a></li>
		  <li><a data-toggle="tab" href="#pay_method2"><img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/google_pay.png" alt=""></a></li>
		  <li><a data-toggle="tab" href="#pay_method3"><img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/paytm.png" alt=""></a></li>
		  </ul>
		  <div class="tab-content">
		  <div id="pay_method1" class="tab-pane fade show active">
		  <div class="row">
            <div class="form-group-payment col-md-8 col-sm-7 col-12">
			<label>Cardholder Name</label>
            <input type="text" class="form-control" name="cname" id="CardholderName" placeholder="" value="">
            </div>
            <div class="form-group-payment col-md-4 col-sm-5 col-12">
			<label>Amount</label>
            <input type="text" class="form-control" name="amount" id="Amount1" placeholder="" value="">
            </div>
		  </div> 
		  <div class="row">
            <div class="form-group-payment col-md-7 col-sm-7 col-12">
			<label>Card Number</label>
            <input type="text" class="form-control" name="cNumber" id="CardNumber1" placeholder="" value="">
            </div>
            <div class="form-group-payment col-md-3 col-sm-3 col-12">
			<label>Date</label>
            <input type="text" class="form-control" name="date" id="Date1" placeholder="" value="">
            </div>
			<div class="form-group-payment col-md-2 col-sm-2 col-12">
			<label>CVV</label>
            <input type="text" class="form-control" name="cvv" id="CVV1" placeholder="" value="">  
            </div>
		  </div>
          </div>
		  <div id="pay_method2" class="tab-pane fade show">
		  <div class="row">
            <div class="form-group-payment col-md-8 col-sm-7 col-12">
			<label>UPI ID</label>
            <input type="text" class="form-control" name="upiid" id="UPI ID" placeholder="" value="">
            </div>
            <div class="form-group-payment col-md-4 col-sm-5 col-12">
			<label>Amount</label>
            <input type="text" class="form-control" name="amount" id="Amount2" placeholder="" value="">
            </div>
		  </div> 
          </div>
		  <div id="pay_method3" class="tab-pane fade show">
		  <div class="row">
            <div class="form-group-payment col-md-8 col-sm-7 col-12">
			<label>Mobile No.</label>
            <input type="text" class="form-control" name="mobileno" id="Mobile No." placeholder="" value="">
            </div>
            <div class="form-group-payment col-md-4 col-sm-5 col-12">
			<label>Amount</label>
            <input type="text" class="form-control" name="amount" id="Amount3" placeholder="" value=""> 
            </div>
		  </div>
          </div>
		  </div>  		  
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-success" data-dismiss="modal">Confirm Payment</button> 
        </div>
      </div>
    </div>
  </div>
<!-- End Payment Modal -->

<!-- Payment Modal -->
  <div class="myModal modal fade" id="paymentModal">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title"><i class="fa fa-credit-card" aria-hidden="true"></i>+Add Payments</h4>  
          <button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>
        <form action="payment.html" method="post">
        <div class="modal-body">        
          <ul class="payment_tab nav nav-tabs">
		  <li><a data-toggle="tab" href="#pay_method3"><img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/paytm.png" alt=""></a></li>
		  </ul>
		  <div class="tab-content">
		  
		  <div id="pay_method3" class="tab-pane fade show active">
		  <div class="row">
            <div class="form-group-payment col-md-8 col-sm-7 col-12">
			<label>Mobile No.</label>
            <input type="text" class="form-control" name="MOBILE_NO" id="Mobile_No" required="required">
            </div>
            <div class="form-group-payment col-md-4 col-sm-5 col-12">
			<label>Amount</label>
            <input type="text" class="form-control" name="TXN_AMOUNT" id="Amount" required="required">
            </div>
            <input type="hidden" id="ORDER_ID" name="ORDER_ID" value="ORDS_<%= randomInt %>">
		  </div>
          </div>
		  </div>  		  
        </div>
        <input type="hidden" id="dueAmount">
        <div class="modal-footer">
          <button type="submit" class="btn btn-success" onclick="return isValidAmount()">Confirm Payment</button> 
        </div>
        </form>
      </div>
    </div>
  </div>
<!-- End Payment Modal -->

<div class="fixed_right_box">	

<div class="clearfix add_inner_box pad_box4 addcompany" id="payment_history" style="display: block;">
<div class="close_icon close_box"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-history"></i>Payment history :&nbsp;<span id="PayHistoryInvoice" class="text-success">INV001</span></h3>
<p>When someone reaches out to you, they become a contact in your account. You can create companies and associate contacts with them.</p></div>
<div class="menuDv pad_box4 clearfix mb30">

<!-- start -->
<!-- <div class="clearfix" id="ApprovedPaymentListId"></div> -->
<div class="table-responsive">
<table class="paymenth">
<tr id="ApprovedPaymentListId"></tr>
</table>
</div>
<!-- end -->
</div>
</div>
<div class="clearfix add_inner_box pad_box4 addcompany" id="update_contact" style="display: none;">
<div class="close_icon close_box"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-fax"></i>Update Client's details</h3>
<p>When someone reaches out to you, they become a contact in your account. You can create companies and associate contacts with them.</p></div>

<form onsubmit="return false;" id="FormUpdateContactBox">
<input type="hidden" id="UpdateContactKey">
<input type="hidden" id="UpdateContactSalesKey">
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="form-group">
  <div class="input-group">
  <input type="text" name="firstname" id="UpdateContactFirstName" placeholder="First Name" class="form-control bdrd4" readonly="readonly">
  </div>
  <div id="fnameErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="lastname" id="UpdateContactLastName" placeholder="Last Name" class="form-control bdrd4" readonly="readonly">
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
  <input type="email" name="enqEmail" id="UpdateContactEmail_Id" placeholder="Email" class="form-control bdrd4" readonly="readonly">
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
  <input type="email" name="enqEmail" id="UpdateContactEmailId2" placeholder="Email" class="form-control bdrd4" readonly="readonly">
</div>
  <div id="newEmailErrorMSGdiv" class="errormsg"></div> 
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>Work Phone :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
  <input type="text" name="workphone" id="UpdateContactWorkPhone" placeholder="Work phone" maxlength="10" class="form-control bdrd4" onkeypress="return isNumber(event)" readonly="readonly">
  </div>
  <div id="wphoneErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>Mobile Phone :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
  <input type="text" name="mobilephone" id="UpdateContactMobilePhone" placeholder="Mobile Phone" maxlength="10" class="form-control bdrd4" onkeypress="return isNumber(event)" readonly="readonly">
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
<input type="radio" name="addresstype" id="UpdateContactperAddress" checked="">
<span>Personal Address</span>
</span>
<span class="mlft10 input_radio">
<input type="radio" name="addresstype" id="UpdateContactcomAddress" readonly="readonly">
<span>Company Address</span>
</span>
</div>
</div>
</div>
<div class="row UpdateAddress_box">
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="form-group">
  <label>City :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
  <input type="text" name="city" id="UpdateContCity" placeholder="City" class="form-control bdrd4">
  </div>
  <div id="cityErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="form-group">
  <label>State :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
  <input type="text" name="state" id="UpdateContState" placeholder="State" class="form-control bdrd4" readonly="readonly">
  </div>
  <div id="stateErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
<div class="row UpdateAddress_box">
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
   <label>Address :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite page"></i></span>-->
  <textarea class="form-control bdrd4" rows="2" name="enqAdd" id="UpdateContAddress" placeholder="Address" readonly="readonly"></textarea>
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
</form>
</div>
</div>
<div class="modal fade" id="warningDocument">
  <div class="modal-dialog">
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
<%@ include file="includes/client-footer-js.jsp" %>
<script type="text/javascript">
function openPaymentHistory(invoiceno){
	$(".ApprovedPayment").remove();
	$("#PayHistoryInvoice").html(invoiceno);
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
function fillPaymentHistory(invoice){
	$.ajax({
		type : "POST",
		url : "GetApprovedInvoice111",
		dataType : "HTML",
		data : {				
			invoice : invoice
		},
		success : function(response){		
			if(Object.keys(response).length!=0){
		response = JSON.parse(response);			
		 var len = response.length;
		 if(len>0){	
			 var home="<%=docBasePath%>";
			 var path="<%=domain%>"; 		
			 for(var i=0;i<len;i++){				 
				 var prefid=response[i]["prefid"];
				var date=response[i]["date"];
				var approvedate=response[i]["approvedate"];
				var approveby=response[i]["approveby"];
				var paymode=response[i]["paymode"];
				var transactionid=response[i]["transactionid"];
				var transacamount=numberWithCommas(response[i]["transacamount"]);
				var docname=response[i]["docname"];
				var status=response[i]["transtatus"];					
				var invoiceuuid=response[i]['invoiceuuid'];
				
				var color="circle_success";
				if(docname=="NA"){color="circle_decline";}
				
				var pymtstatusicon="fas fa-circle-notch";
				var pymttitle="Processing..";
				var pymtcolor="circle_processing";
				if(status=="1"){
					pymtstatusicon="far fa-check-circle";
					pymttitle="Approved";
					pymtcolor="circle_success";
				}else if(status=="3"){
					pymtstatusicon="far fa-times-circle";
					pymttitle="Declined";
					pymtcolor="circle_decline";
				}
					
					
			 $(''+
			  '<tr class="ApprovedPayment">'+
				 '<td><i class="'+pymtstatusicon+' '+pymtcolor+'"></i></td>'+
				 '<td>'+date+'</td>'+
				 '<td>'+paymode+'</td>'+
				 '<td>'+transactionid+'</td>'+
				 '<td>'+transacamount+'</td>'+
				 '<td><i class="far fa-file-alt '+color+'" onclick="openReceipt(\''+home+'\',\''+docname+'\')"></i></td>'+
				 '<td><a href="'+path+'final-invoice-'+invoiceuuid+'.html" target="_blank"><i class="fa fa-file-text pointers text-primary" title="Invoice" style="font-size:16px"></i></a></td>'+
			  '</tr>'			 
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
		 }}
		});
}

/* function payBill(invoice,total,due){ 
// 	document.getElementById('BillRefid').value=brefid;
	document.getElementById('BillNo').innerHTML=invoice.toUpperCase();
// 	document.getElementById('BillDate').innerHTML=date;
	document.getElementById('BillAmt').innerHTML="Rs. "+total;
	document.getElementById('BillDue').innerHTML="Rs. "+due;
	document.getElementById('details').style.display='none';
	document.getElementById('PayBill').style.display='block'
} */
function openReceipt(mainfolder,docname){
	if(docname.toLowerCase()=="na"){
		$("#warningDocument").modal("show");
	}else{	window.open(mainfolder+"/documents/"+docname);}
}

$('.datepicker').datepicker({
    format: 'yyyy-mm-dd',    
});
</script>
<script>
if($(window).width() < 1024) {
$('.list_action_box').hover(function(){
	$(this).children().next().toggleClass("show");
}); 
}
/*  $('.list_action_box').hover(function(){
	$(this).children().next().toggleClass("show");
});  */
$('.close_box').on( "click", function(e) { 
	$('.fixed_right_box').removeClass('active');
	$('.addnew').show();	
	});
</script>
<script type="text/javascript">
$('input[name="date_range"]').daterangepicker({
	autoApply: true,
	locale: {
      format: 'DD-MM-YYYY' 
    }  
});
$('#date_range').on('apply.daterangepicker', function(ev, picker) {
	var date=$("#date_range").val();
    doAction(date,'PaymentSearchFromToDate');
});

function doAction(data,name){
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/SetOrderTypeSearch999",
	    data:  { 
	    	data : data,
	    	name : name
	    },
	    success: function (response) {        	  
         location.reload(true)     	  ;
        },
	});
}
function setSalesKey(data,due){
	$("#dueAmount").val(due);
	$("#Amount").val(Number(due).toFixed(2));
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/SetOrderTypeSearch999",
	    data:  { 
	    	data : data,
	    	name : "SalesKey"
	    },
	    success: function (response) {  
        },
	});
}

$(function() {
	$("#SearchOrder").autocomplete({
		source : function(request, response) {			
			if($('#SearchOrder').val().trim().length>=2)
			$.ajax({
				url : "<%=request.getContextPath()%>/getprojectbyinvoice999",
				type : "GET",
				dataType : "JSON",
				data : {
					name : request.term
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value,	
							invoiceNo :item.invoiceNo,
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
            	doAction(ui.item.value,'ClientOrderSearchInvoice');
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});
function removeSearchOption(data){
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/ClearOrderTypeSearch999",
	    data:  { 
	    	data : data
	    },
	    success: function (response) {        	  
         location.reload(true);
        },
	});	
}
function doAction(data,name){
$.ajax({
    type: "POST",
    url: "<%=request.getContextPath()%>/SetOrderTypeSearch999",
    data:  { 
    	data : data,
    	name : name
    },
    success: function (response) {        	  
     location.reload(true)     	  ;
    },
});
}
function pageLimit(data){
	  var start="<%=pageStart%>";
	  var limit="<%=pageLimit%>";
	  var end=Number(start)+Number(data);
	  if(Number(start)==1)end-=1;
	  doAction(data,'paymentPageLimit');
	  doAction(end,'paymentPageEnd');
	  location.reload(true);
}
function backwardPage(){
		 var count="<%=count-1%>";
		 var limit="<%=pageLimit%>";
		 var start=0;
		 if(Number(count)>=1){			 
			 start=(Number(count)-1)*Number(limit);
			 if(start==0)start=1;
			 var end=Number(count)*Number(limit);			 
		 }else if(count==0){
			 start=1;
			 end=limit;
		 }
		 doAction(start,'paymentPageStart');
		 doAction(end,'paymentPageEnd');
		 location.reload(true);
	 }
function forwardPage(){  
	 var count="<%=count+1%>";
	 var limit="<%=pageLimit%>";
	 var start=(Number(count)-1)*Number(limit);
	 var end=Number(count)*Number(limit);
	 doAction(start,'paymentPageStart');
	 doAction(end,'paymentPageEnd');
	 location.reload(true);
}
function isValidAmount(){
	var dueAmount=$("#dueAmount").val();
	var amount=$("#Amount").val();
	var mobile=$("#Mobile_No").val();
	if(mobile==null||mobile==""){
		document.getElementById('errorMsg').innerHTML = 'Mobile No. is required !!';
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(Number(amount)>Number(dueAmount)){
		document.getElementById('errorMsg').innerHTML = 'Maximum amount should be Rs. '+dueAmount;
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
}
</script>
</body>
<!-- body ends -->
</html>