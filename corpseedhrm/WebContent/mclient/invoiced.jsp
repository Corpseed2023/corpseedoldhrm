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
	<title>Invoiced</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>

<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	<%if(!INV0){%><jsp:forward page="/login.html" /><%} %>
<%
Properties properties = new Properties();
properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
String azure_path=properties.getProperty("azure_path");
String domain=properties.getProperty("domain");
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

String sort_url=domain+"all-invoice.html?page="+pageNo+"&rows="+rows;
String token=(String)session.getAttribute("uavalidtokenno");

String country[][]=TaskMaster_ACT.getAllCountries();
String today=DateUtil.getCurrentDateIndianFormat1();
//pagination end
String invoiceDateRangeAction=(String)session.getAttribute("invoiceDateRangeAction");
if(invoiceDateRangeAction==null||invoiceDateRangeAction.length()<=0)invoiceDateRangeAction="NA";

String invoice_no=(String)session.getAttribute("invoice_no");
if(invoice_no==null||invoice_no.length()<=0)invoice_no="NA";

String companyName=(String)session.getAttribute("invoicecompanyName");
if(companyName==null||companyName.length()<=0)companyName="NA";

String invoicedContactName=(String)session.getAttribute("invoicedContactName");
if(invoicedContactName==null||invoicedContactName.length()<=0)invoicedContactName="NA";

String b2bb2c=(String)session.getAttribute("b2bb2c");
if(b2bb2c==null||b2bb2c.length()<=0)b2bb2c="NA";
%> 

	<div id="content">
		<div class="main-content">
			<div class="container-fluid">					
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
<div class="col-md-4 col-sm-4 col-xs-9 flex_box"> 
<select class="filtermenu minBoxWidth mrt10" id="B2B_B2C" onchange="doAction(this.value,'b2bb2c');location.reload();">
	<option value="">All</option>
	<option value="B2B" <%if(b2bb2c.equalsIgnoreCase("b2b")){ %>selected<%} %>>B2B</option>
	<option value="B2C" <%if(b2bb2c.equalsIgnoreCase("b2c")){ %>selected<%} %>>B2C</option>
</select>
<ul class="clearfix filter_menu">
<li><a href="<%=request.getContextPath()%>/unbilled.html">Unbilled</a></li>
<li class="active"><a href="<%=request.getContextPath()%>/all-invoice.html">Invoiced</a></li>

</ul>
</div>
<a href="javascript:void(0)" class="doticon"> <i class="fa fa-filter" aria-hidden="true"></i>Filter</a>
<div class="filtermmenu">
<div class="col-md-8 col-sm-8 col-xs-12">
<div class="clearfix flex_box justify_end">  
<div class="item-bestsell col-md-3 col-sm-4 col-xs-12">
<p><input type="search" name="invoice_no" id="invoice_no" autocomplete="off"<% if(!invoice_no.equalsIgnoreCase("NA")){ %> onsearch="clearSession('invoice_no');location.reload();" value="<%=invoice_no%>"<%} %> placeholder="Search by invoice" class="form-control"/>
</p>
</div>
<div class="item-bestsell col-md-3 col-sm-6 col-xs-12">
<p><input type="search" name="contactName" id="ContactName" <%if(!invoicedContactName.equalsIgnoreCase("NA")){ %>onsearch="clearSession('invoicedContactName');location.reload();" value="<%=invoicedContactName %>"<%} %> title="Search by Client Name !" placeholder="Search by client name.." class="form-control"/>
</p>
</div> 
<div class="item-bestsell col-md-3 col-sm-4 col-xs-12">
<p><input type="search" name="companyName" id="companyName"<% if(!companyName.equalsIgnoreCase("NA")){ %> onsearch="clearSession('invoicecompanyName');location.reload();" value="<%=companyName%>"<%} %> autocomplete="off" placeholder="Search by company" class="form-control"/>
</p>
</div> 
<div class="item-bestsell col-md-3 col-sm-4 col-xs-12 has-clear"> 
<p><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="FROM - TO" class="form-control text-center date_range pointers <%if(!invoiceDateRangeAction.equalsIgnoreCase("NA")){%>selected<%} %>" readonly="readonly"/>
<span class="form-control-clear form-control-feedback" onclick="clearSession('invoiceDateRangeAction');location.reload();"></span>
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
						            <th class="sorting <%if(sort.equals("invoice")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','invoice','<%=order%>')">Invoice</th>
						            <th class="sorting <%if(sort.equals("service_name")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','service_name','<%=order%>')">Service</th>
						            <th class="sorting <%if(sort.equals("client")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','client','<%=order%>')">Client</th>
						            <th class="sorting <%if(sort.equals("company")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','company','<%=order%>')">Company</th>
						            <th class="sorting <%if(sort.equals("amount")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','amount','<%=order%>')">Txn. Amount</th>						            
						            <th>Added By</th>
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
                            String invoice[][]=Clientmaster_ACT.getAllInvoice(invoicedContactName,invoice_no,companyName,invoiceDateRangeAction,token,pageNo,rows,sort,order,b2bb2c);
						    int totalBilling=Clientmaster_ACT.countAllInvoice(invoicedContactName,invoice_no,companyName,invoiceDateRangeAction,token,b2bb2c);
						    if(invoice!=null&&invoice.length>0){
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
                             for(int i=0;i<invoice.length;i++) {	  
                            	 String client[][]=Enquiry_ACT.getClientDetails(invoice[i][6],token);
                            	 String addedByName=Enquiry_ACT.getPaymentPersonName(invoice[i][8],token);
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
						            <td><input type="checkbox" name="checkbox" id="checkbox" class="checked" value="<%=invoice[i][0] %>"></td>
						            <td><%=invoice[i][0] %></td>
						            <td><%=invoice[i][2] %></td>
						            <td><%=invoice[i][3] %></td>						            
						            <td class="name_action_box position-relative" id="main<%=invoice.length-i %>">
							          <span id="MainCon<%=invoice.length-i %>" class="clickeble contactbox name_field" data-related="update_contact"><%=client[0][0] %></span>
									  <%if(client!=null&&client.length>1){ %>
									  <div class="iAction">
									  <i class="fa fa-plus pointers" onclick="showAllContact(event,'main<%=invoice.length-i %>','sub<%=invoice.length-i %>')"><small><%=(client.length-1) %></small></i><i class="fa fa-minus pointers" onclick="minusAllContact(event)"></i>
									  </div>
									  <%} %>
									  <ul class="dropdown_list" id="sub<%=invoice.length-i %>">
									  <%if(client!=null&&client.length>1){for(int j=1;j<client.length;j++){ %>
									  <li><a class="pointers clickeble contactbox"><%=client[j][0] %></a></li>
									  <%}} %>
									  </ul>
							          </td>
						            <td><%=invoice[i][5] %></td>
						            <td><i class="fas fa-inr inr"></i>&nbsp;<%=CommonHelper.withLargeIntegers(Double.parseDouble(invoice[i][4])) %></td>
						            <td><%=addedByName %></td>
						            <td>
						            <%if(invoice[i][7].equals("1")){ %><a href="javascript:void(0)" class="invoicebox" data-related="invoice_receipt" onclick="openInvoiceBox('<%=invoice[i][2] %>')">
						            <button class="btn btn-secondary">Invoiced</button></a><%}else if(invoice[i][7].equals("2")){ %>
						            <a href="javascript:void()"><button class="btn btn-danger">Cancelled</button></a>
						            <%} %>						            
						            </td>
						        </tr>
						     <%}}%>                                 
						    </tbody>
						</table> 
						
                        <div class="filtertable">
			  <span>Showing <%=showing %> to <%=ssn+invoice.length %> of <%=totalBilling %> entries</span>
			  <div class="pagination">
			    <ul> <%if(pageNo>1){ %>
			      <li class="page-item">	                     
			      <a class="page-link text-primary" href="<%=request.getContextPath()%>/all-invoice.html?page=1&rows=<%=rows%>">First</a>
			   </li><%} %>
			    <li class="page-item">					      
			      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/all-invoice.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
			    </li>  
			      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
				    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
				    <a class="page-link" href="<%=request.getContextPath()%>/all-invoice.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
				    </li>   
				  <%} %>
				   <li class="page-item">						      
				      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/all-invoice.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
				   </li><%if(pageNo<=(totalPages-1)){ %>
				   <li class="page-item">
				      <a class="page-link text-primary" href="<%=request.getContextPath()%>/all-invoice.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
				   </li><%} %>
				</ul>
				</div>
				<select class="select2" onchange="changeRows(this.value,'all-invoice.html?page=1','<%=domain%>')">
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
  <label>Pan Number :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <input type="text" name="pannumber" id="UpdatePanNumber" placeholder="Pan Number" onblur="validatePanPopup('UpdatePanNumber');validateValuePopup('UpdatePanNumber');isExistEditCompanyPan('UpdatePanNumber');" class="form-control bdrd4">
  </div>
  <div id="panNoErrorMSGdiv" class="errormsg"></div>
 </div>
 <div class="text-right" style="margin-top: -8px;">
<span class="add_new pointers">+ GST</span>
</div>
<div class="relative_box form-group new_field" id="CompanyGstDivId" style="display:none;">
  <label>GST Number :<sup>(Optional)</sup></label>
  <div class="input-group">
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

<div class="clearfix add_inner_box pad_box4 addcompany" id="cancelledInvoice">
<div class="rttop_titlep">
<h3 style="color: #42b0da;"><i class="fa fa-wpforms"></i>Cancelled Invoice</h3>
<a  class="clickeble invoicebox" data-related="invoice_receipt" onclick="backInvoice()" style="position: absolute;right: 0;top: 0;"><button class="bkbtn">Back</button></a>
</div>   
 <a href="#" class="btnclose"><i class="fa fa-close"></i></a>
  
<div class="clearfix mb30">

<div class="table-responsive">
<table class="ctable">
<tr id="cancelledInvoiceData"></tr>
</table>
</div>
<!-- end -->

</div>
</div>

<div class="clearfix add_inner_box pad_box4 addcompany" id="update_invoice">
<!-- <div class="close_icon close_box"><i class="fa fa-times" style="font-size: 21px;"></i></div> -->
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-building-o"></i>Update Invoice</h3> 
<a class="clickeble invoicebox" data-related="invoice_receipt" onclick="backInvoice()" style="position: absolute;right: 0;top: 0;">
<button class="bkbtn">Back</button></a>
<p>When someone reaches out to you, they become a contact in your account. You can create companies and associate contacts with them.</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="mb10 flex_box align_center">
<span class="input_radio">
<input type="radio" name="invoiceType" id="invoiceIndividual" checked="checked">
<span>Individual</span>
</span>
<span class="mlft10 input_radio">
<input type="radio" name="invoiceType" id="invoiceBusiness">
<span>Business</span>
</span>
<span class="input_radio" style="margin-left: 18rem;">
<span>Invoice Date &nbsp;</span>
<input type="date" name="invoiceDate" id="invoiceDate">
</span>
</div>
</div>
</div>
<div id="invoiceBusinessShow">
<form onsubmit="return false;" id="UpdateInvoiceBusiness">
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="companyname" id="CompanyName" placeholder="Company Name" class="form-control bdrd4">
 </div>
  <div id="cnameErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="gstinNumber" id="gstinNumber" placeholder="GSTIN" class="form-control bdrd4">
  </div>
  <div id="industryErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
<div class="clearfix inner_box_bg">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>Country :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">  
   <select name="businessCountry" id="businessCountry" class="form-control bdrd4" onchange="updateState(this.value,'businessState')">
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
  <select name="businessState" id="businessState" class="form-control bdrd4" onchange="updateCity(this.value,'businessCity')">
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
  <select name="businessCity" id="businessCity" class="form-control bdrd4">
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
  <textarea class="form-control bdrd4" rows="2" name="businessAddress" id="businessAddress" placeholder="Address"></textarea>
  </div>
  <div id="enqAddErrorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
</div>
<div class="clearfix mtop10 mb10 text-right"> 
<button class="bt-link bt-radius bt-gray mrt10 close_box" type="button">Cancel</button>
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateBusiness();">Update</button>
</div>
</form>  
</div>
<div id="invoiceIndividualShow">
<form onsubmit="return false;" id="UpdateInvoiceIndividual">
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="contactName" id="contactName" placeholder="Contact Name" class="form-control bdrd4">
 </div>
  <div id="cnameErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="contactPan" id="contactPan" placeholder="Pan" class="form-control bdrd4">
  </div>
  <div id="industryErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
<div class="clearfix inner_box_bg">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>Country :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">  
   <select name="country" id="individualCountry" class="form-control bdrd4" onchange="updateState(this.value,'individualState')">
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
  <select name="individualState" id="individualState" class="form-control bdrd4" onchange="updateCity(this.value,'individualCity')">
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
  <select name="individualCity" id="individualCity" class="form-control bdrd4">
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
  <textarea class="form-control bdrd4" rows="2" name="individualAddress" id="individualAddress" placeholder="Address"></textarea>
  </div>
  <div id="enqAddErrorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
</div>
<div class="clearfix mtop10 mb10 text-right"> 
<button class="bt-link bt-radius bt-gray mrt10 close_box" type="button">Cancel</button>
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateIndividual();">Update</button>
</div>
</form>  
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
  <input type="text" name="contPan" id="UpdateContPan" onblur="validatePanPopup('UpdateContPan');validateValuePopup('UpdateContPan');isExistEditPan('UpdateContPan');" placeholder="Pan" maxlength="10" class="form-control bdrd4">
  </div>
  <div id="wphoneErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>Work Phone :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
  <input type="text" name="workphone" id="UpdateContactWorkPhone" placeholder="Work phone" maxlength="10" class="form-control bdrd4" onkeypress="return isNumber(event)">
  </div>
  <div id="wphoneErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>Mobile Phone :</label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
  <input type="text" name="mobilephone" id="UpdateContactMobilePhone" placeholder="Mobile Phone" maxlength="10" class="form-control bdrd4" onkeypress="return isNumber(event)">
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

<div class="clearfix add_inner_box pad_box4 addcompany" id="invoice_receipt">
<div class="close_icon close_box"><i class="fa fa-times"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-file-o"></i>INVOICE</h3>
<div class="clearfix">
<button type="button" class="update_invoice invconvt" data-related="update_invoice" onclick="updateInvoice()">Update Invoice</button>
</div>
</div>
<h3 style="font-size: 13px;border-bottom: 1px solid #e1e1e1;padding-bottom: 11px;">

<span style="margin-left: 20px;" class="pointers" onclick="convertHTMLToPdf('invoicecontent','InvoiceBillNo')"><i class="fas fa-download"></i>&nbsp;&nbsp;PDF</span>
<span style="margin-left: 20px;" class="pointers" onclick="copyInvoiceLink()" title="Copy Invoice Link !!" id="CopyLinkUrl"><i class="far fa-copy"></i>&nbsp;&nbsp;URL</span> 
<span style="margin-left: 20px;" class="pointers" onclick="printDiv('invoicecontent','InvoiceBillNo')"><i class="fas fa-print"></i>&nbsp;&nbsp;Print</span> 
<span style="margin-left: 20px;" class="pointers cancelled_invoice" data-related="cancelledInvoice" onclick="cancelledInvoice()"><i class="fas fa-receipt"></i>&nbsp;&nbsp;Cancelled Invoice</span>
<input type="text" id="InvoiceUrl" style="opacity: 0;width:10px">
</h3>
<div class="clearfix menuDv pad_box3 pad05 mb10" style="min-height: 150px;margin-top: 16px;" id="invoicecontent">
<div class="clearfix invoice_div">

<%-- <div class="clearfix" style="position: relative;margin-bottom: -35px;">
<img alt="" src="<%=request.getContextPath()%>/staticresources/images/tag.png" style="width: 50px;margin-left: -15px;margin-top: -10px;">
<span style="position: absolute;margin-left: -48px;transform: rotate(-45deg);color: #ffff;font-size: 11px;" id="PaymentPaidOrPartial"></span>
</div> --%>
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
<span>GSTIN 09AAHCC4539J1ZC</span>
</p>
</div>
</div>
<div style="width:50%;">
<div style="margin-bottom:10px;text-align:right;">
<h2 style="font-size:18px;margin:0 0 5px;color:#48bd44;font-weight: 500;">INVOICE</h2>
<p style="font-weight:600;" id="InvoiceBillNo"></p>
</div>

<div style="width:100%;" id="BalanceDueAmount">
<div style="text-align:right;font-size: 14px;margin-top: 40px;font-weight: 600;">
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
<p><span style="font-weight:600;color:#888;">Date :</span> <span style="padding-left:20px;" id="billingDate"></span></p>
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

</div>
<div class="modal fade" id="MarkPayment" tabindex="-1" role="dialog" aria-labelledby="TaxModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
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
        <h5 class="modal-title" >Register Payment : <span style="color:#357b8bf5;" id="RegisterPaymentOfInvoice"></span></h5>
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
		<option value="Online">Online</option>
		<option value="Cash">Cash</option>
		</select>
		  <div id="paymentmodeErrorMSGdiv" class="errormsg"></div>
		 </div>
		</div>
		<div class="col-md-6 col-sm-6 col-xs-12">
		 <div class="form-group">
		  <input type="text" name="pymtdate" id="PaymentDate" value="" autocomplete="off" placeholder="Date" class="form-control datepicker readonlyAllow bdrd4" readonly="readonly">
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
		  <input type="text" name="service_Name" id="Service_Name" autocomplete="off" placeholder="Service Name" class="form-control">
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
		<input type="hidden" id="OtherFeeTax" value="0"/>
		<input type="hidden" id="ProfessionalCgst" name="professionalCgst" value="0"/>
		<input type="hidden" id="ProfessionalSgst" name="professionalSgst" value="0"/>
		<input type="hidden" id="ProfessionalIgst" name="professionalIgst" value="0"/>
		<input type="hidden" id="GovernmentCgst" name="governmentCgst" value="0"/>
		<input type="hidden" id="GovernmentSgst" name="governmentSgst" value="0"/>
		<input type="hidden" id="GovernmentIgst" name="governmentIgst" value="0"/>
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
<div class="modal fade" id="warningProceed" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;">
        <span class="text-danger">Do you want to continue ? </span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>  
      <div class="modal-body">
      <p>Please re-check the details for GST Number and Client Details before proceeding !!</p>
      </div>   
      
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">NO</button>
        <button type="button" class="btn btn-secondary" onclick="proceedToConvert('proceed')">Yes</button>
      </div>
    </div>
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
        <button type="button" class="btn btn-primary" data-dismiss="modal" style="width: 15%;" onclick="declineSalesPayment()">Yes</button>
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
      <form action="return false" id="exportInvoiceCol">
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
            	<option value="i.date" selected>Date</option>
            	<option value="i.invoice_no" selected>Invoice No.</option>
            	<option value="i.contact_name" selected>Client name</option>
            	<option value="i.company" selected>Company name</option>
            	<option value="i.gstin" selected>GST No.</option>
            	<option value="i.state" selected>State</option>
            	<option value="i.address" selected>Address</option>
            	<option value="i.service_name" selected>Service</option>
            	<option value="e.amount" selected>Taxable</option>
            	<option value="e.cgst" selected>CGST</option>
            	<option value="e.sgst" selected>SGST</option>
            	<option value="e.igst" selected>IGST</option>
            	<option value="i.total_amount" selected>Invoice Value</option>
            	<option value="s.saddedbyuid" selected>Sales person</option>
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
<input type="hidden" id="ManageEstimateUpdateContactId"> 
<input type="hidden" id="ApprovalGrantedId">  
<input type="hidden" id="openInvoiceUuid"> 
<input type="hidden" id="openInvoiceNumber"> 
	<p id="end" style="display:none;"></p>
	</div>
	<div class="noDisplay"><a href="" id="DownloadExportedLink" download><button id="DownloadExported">Download</button></a></div>
	<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>	
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/jspdf.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/html2pdf.bundle.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/converttopdf.js"></script>
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
	var other_Fee=$("#Other_Fee").val();
	var other_Fee_remark=$("#Other_Fee_remark").val();
	var remarks=$("#remarks").val();
	
	if(professional_Fee==null||professional_Fee=="")professional_Fee=0;
	if(government_Fee==null||government_Fee=="")government_Fee=0;
	if(other_Fee==null||other_Fee=="")other_Fee=0;	
	
	var txnAmount=Number(professional_Fee)+Number(government_Fee)+Number(other_Fee);
	
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
   		},
   		success : function(response){		
   		if(response=="pass"){
			       // Get form
			       var form = $('#UploadFormdata')[0];
				// Create an FormData object
			       var data = new FormData(form);	
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
			var service=response[i]["service"];
			
			var ApproveBtnId="ApproveBtnId"+(i+1);
			var CnfPymtAmount="CnfPymtAmount"+(i+1);
			var TransactionId="TransactionId"+(i+1);
			var RowId="ApproveRowId"+(i+1);
			var DeclineBtnId="DeclineBtnId"+(i+1);
			if(transactionid=="NA")transactionid="";
			$(''+
			'<div class="row pymentcnf" id="'+RowId+'">'+
			'<div class="clearfix bg_wht" style="border-bottom: 1px solid #ddd;">'+		
			'<div class="box-width7 col-xs-1 box-intro-background">'+
			'<div class="clearfix">'+
			'<p class="news-border">'+date+'</p>'+
			'</div>'+
			'</div>'+
			'<div class="box-width12 col-xs-1 box-intro-background">'+
			'<div class="clearfix"><p class="news-border register-box" title="">'+mode+'</p></div>'+
			'</div>'+
			'<div class="box-width31 col-xs-1 box-intro-background">'+
			'<div class="clearfix"><p class="news-border register-box" title=""><input type="text" class="form-control cnfpymt" id="'+TransactionId+'" onchange="updateTransactionId(this.value,\''+refid+'\')" placeholder="Transaction Id.." value="'+transactionid+'"></p></div>'+
			'</div><div class="box-width3 col-xs-1 box-intro-background">'+
			'<div class="clearfix"><p class="news-border register-box" title=""><input type="text" id="'+CnfPymtAmount+'" class="form-control cnfpymt" onchange="updateTransactionAmount(this.value,\''+refid+'\',\''+invoiceno+'\',\''+rowid+'\')" placeholder="Transaction amount.." value="'+amount+'"></p></div>'+
			'</div>'+
			'<div class="box-width21 col-xs-1 box-intro-background">'+
				'<div class="clearfix">'+
				'<p class="news-border pointers register-box" style="font-size: 16px;color: #42b7e4;">'+
				'<i class="fa fa-file-text-o" title="Open Payment Receipt." onclick="openReceipt(\''+path+'\',\''+docname+'\')"></i>&nbsp;&nbsp;&nbsp;'+
				'</p>'+
				'</div>'+
			'</div>'+
			'<div class="box-width16 col-xs-1 box-intro-background">'+
				'<div class="clearfix"><input type="hidden" id="heading'+i+'" value="Service : '+service+' by '+addedby+'"><input type="hidden" id="remarks'+i+'" value="'+remarks+'">'+
				'<p class="news-border pointers register-box" style="font-size: 10px;color: #42b7e4;" title="">'+
				'<button class="btn-success" id="'+ApproveBtnId+'" onclick="approvePayment(\''+CnfPymtAmount+'\',\''+refid+'\',\''+invoiceno+'\',\''+clientrefid+'\',\''+RowId+'\',\''+contactrefid+'\',\''+addedby+'\',\''+i+'\',\''+date+'\')">Approve</button>'+
				'</p>'+
				'</div>'+
			'</div>'+
			'<div class="box-width16 col-xs-1 box-intro-background">'+
				'<div class="clearfix">'+
				'<p class="news-border pointers register-box" style="font-size: 10px;color: #42b7e4;" title="">'+
				'<button class="btn-danger"id="'+DeclineBtnId+'" onclick="declinePayment(\''+CnfPymtAmount+'\',\''+refid+'\',\''+invoiceno+'\',\''+RowId+'\',\''+addedby+'\',\''+i+'\',\''+date+'\')">Decline</button>'+
				'</p>'+
				'</div>'+
			'</div>'+
			'</div>'+
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
        		$("#"+rowid).load("unbilled.html #"+rowid);
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
        	hideLoader();
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
        	hideLoader();
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

function declinePayment(amountid,refid,invoiceno,rowid,addedby,i,date){
	var amount=$("#"+amountid).val(); 
	$("#DeclinePaymentRefid").val(refid);
	$("#DeclineSalesInvoiceid").val(invoiceno);	
	$("#DeclineSalesInvoiceRowid").val(rowid);
	
	var service=$("#heading"+i).val();
	var remarks=$("#remarks"+i).val();
	$("#paymentRemarksDecline").html('<div class="box_shadow1 relative_box mb10"><div class="sms_head note_box">'+
			'<p>'+service+'<br><b>Comment : </b>'+remarks+'</p></div>'+
					'<div class="sms_title">'+ 
					'<label class="pad-rt10"></label>'+  
					'<span class="gray_txt bdr_bt pad-rt10" style="float: right;">'+date+'</span>'+
					'</div></div>');
	
	$("#warningDecline").modal("show");
	
}

function approvePayment(amountid,refid,invoiceno,clientrefid,rowid,contactrefid,addedby,i,date){
	var amount=$("#"+amountid).val(); 
	$("#PaymentRefid").val(refid);
	$("#SalesInvoiceid").val(invoiceno);
	$("#SalesInvoiceClientRefid").val(clientrefid);
	$("#SalesInvoiceContactRefid").val(contactrefid);
	$("#SalesInvoiceRowid").val(rowid);
	var service=$("#heading"+i).val();
	var remarks=$("#remarks"+i).val();
	$("#paymentRemarks").html('<div class="box_shadow1 relative_box mb10"><div class="sms_head note_box">'+
			'<p>'+service+'<br><b>Comment : </b>'+remarks+'</p></div>'+
					'<div class="sms_title">'+ 
					'<label class="pad-rt10"></label>'+  
					'<span class="gray_txt bdr_bt pad-rt10" style="float: right;">'+date+'</span>'+
					'</div></div>');
	
	if(Number(amount)<=0){
		$("#warningAmount").modal("show");
	}else{
		$("#warningApprove").modal("show");
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
		
		var govcgst=Number(x[2]);
		var govsgst=Number(x[3]);
		var govigst=Number(x[4]);
		var govtax=govcgst+govsgst+govigst;
		
		$("#GovernmentCgst").val(govcgst);
		$("#GovernmentSgst").val(govsgst);
		$("#GovernmentIgst").val(govigst);
		
		var othercgst=Number(x[2]);
		var othersgst=Number(x[3]);
		var otherigst=Number(x[4]);
		var otrtax=othercgst+othersgst+otherigst;
		
		$("#OtherCgst").val(othercgst);
		$("#OtherSgst").val(othersgst);
		$("#OtherIgst").val(otherigst);
		
		$("#ProfessionalFeeTax").val(pfftax);
		$("#GovernmentFeeTax").val(govtax);
		$("#OtherFeeTax").val(otrtax);
		
		$("#Professional_Fee_GST").html(pfftax+"%");
		$("#Government_Fee_GST").html(govtax+"%");
		$("#Other_Fee_GST").html(otrtax+"%");
		
		},
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
$(function() {
	$("#companyName").autocomplete({
		source : function(request, response) {
			if(document.getElementById('companyName').value.trim().length>=1)
			$.ajax({
				url : "get-client-details.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field :"invoiceCompanyNameInvoiced"
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
            	doAction(ui.item.value,"invoicecompanyName");
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
					if(transtatus=="3"){
						color="#d91f16";
						title="Declined";
					}
					
			 $(''+
					 '<div class="clearfix bg_wht ApprovedPayment">'+
			 '<div class="box-width25 col-xs-1 box-intro-background">'+
			 '<div class="clearfix">'+
			 '<p class="news-border fa fa-check-circle-o" style="font-size: 20px;color: '+color+';" title="'+title+'"></p>'+
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
				$("#UpdateContState").append("<option value='0#0#"+state+"'>"+state+"</option>");				
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
	   var dateRangeDoAction="<%=invoiceDateRangeAction%>";
	   if(dateRangeDoAction!="NA"){	  
		   $('input[name="date_range"]').val(dateRangeDoAction);
	   }
	});

$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var data=$(this).val();
	doAction(data,"invoiceDateRangeAction");
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
	$("#invoice_no").autocomplete({
		source : function(request, response) {			
			if(document.getElementById('invoice_no').value.trim().length>=2)
			$.ajax({
				url : "get-client-details.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					"field" : "invoice_no"
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
            	doAction(ui.item.value,'invoice_no');
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
	var baseName="<%=request.getContextPath()%>/exported/";
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
				$("#DownloadExportedLink").attr("href", baseName+response);
				$("#DownloadExported").click();
				
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
		var other=$("#Other_Fee").val();
			
		if($("#GSTApplyId").prop('checked') == true){
			var pfftax=$("#ProfessionalFeeTax").val();
			var govtax=$("#GovernmentFeeTax").val();
			var othertax=$("#OtherFeeTax").val();
			
			pff=Number(pff)+((Number(pff)*Number(pfftax))/100);
			gov=Number(gov)+((Number(gov)*Number(govtax))/100);
			other=Number(other)+((Number(other)*Number(othertax))/100);		
		}
		
		var totalAmount=Number(pff)+Number(gov)+Number(other);
		
		$("#TotalPaymentId").val(totalAmount.toFixed(2));
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
	function validateBusiness(){

		if($("#CompanyName").val()==null||$("#CompanyName").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Company name is mandatory !!";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#gstinNumber").val()==null||$("#gstinNumber").val().trim()==""){
			$("#gstinNumber").val("NA");
		}
		if($("#businessCountry").val()==null||$("#businessCountry").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Country is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#businessState").val()==null||$("#businessState").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="State is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#businessCity").val()==null||$("#businessCity").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="City is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#businessAddress").val()==null||$("#businessAddress").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Address is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#invoiceDate").val()==null||$("#invoiceDate").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Choose Invoice Date";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		
		var invoiceDate=$("#invoiceDate").val().trim();		
		var CompanyName=$("#CompanyName").val().trim();
		var gstinNumber=$("#gstinNumber").val().trim();
		var businessCountry=$("#businessCountry").val();
		var x=businessCountry.split("#");
		businessCountry=x[1];
		var businessState_code="NA";
		var businessState=$("#businessState").val();
		x=businessState.split("#");
		businessState_code=x[1];
		businessState=x[2];
		
		var businessCity=$("#businessCity").val();
		var businessAddress=$("#businessAddress").val();		
		var invoice=$("#openInvoiceNumber").val();
		
	showLoader();
		$.ajax({
			type : "POST",
			url : "UpdateInvoiceDetails111",
			dataType : "HTML",
			data : {				
				invoice : invoice,
				CompanyName : CompanyName,
				gstinNumber : gstinNumber,
				businessCountry : businessCountry,
				businessState : businessState,
				businessState_code : businessState_code,
				businessCity : businessCity,
				businessAddress : businessAddress,
				invoiceType : "Business",
				invoiceDate : invoiceDate
			},
			success : function(data){
				if(data=="pass"){
					document.getElementById('errorMsg1').innerHTML = 'Successfully Updated !!';				  
					$('.alert-show1').show().delay(4000).fadeOut();					
					$('.fixed_right_box').removeClass('active');
					$('.addnew').show();
					setTimeout(() => {
						location.reload();
					}, 4000);
									
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
			
	function validateIndividual(){

		if($("#contactName").val()==null||$("#contactName").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Contact name is mandatory !!";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#contactPan").val()==null||$("#contactPan").val().trim()==""){
			$("#contactPan").val("NA");
		}
		if($("#individualCountry").val()==null||$("#individualCountry").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Country is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#individualState").val()==null||$("#individualState").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="State is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#individualCity").val()==null||$("#individualCity").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="City is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#individualAddress").val()==null||$("#individualAddress").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Address is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		
		if($("#invoiceDate").val()==null||$("#invoiceDate").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Choose Invoice Date";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		
		var invoiceDate=$("#invoiceDate").val().trim();
		var contactName=$("#contactName").val().trim();
		var contactPan=$("#contactPan").val().trim();
		var individualCountry=$("#individualCountry").val();
		var x=individualCountry.split("#");
		individualCountry=x[1];
		var individualstate_code="NA";
		var individualState=$("#individualState").val();
		x=individualState.split("#");
		individualstate_code=x[1];
		individualState=x[2];
		
		var individualCity=$("#individualCity").val();
		var individualAddress=$("#individualAddress").val();		
		var invoice=$("#openInvoiceNumber").val();
		
	showLoader();
		$.ajax({
			type : "POST",
			url : "UpdateInvoiceDetails111",
			dataType : "HTML",
			data : {				
				invoice : invoice,
				contactName : contactName,
				contactPan : contactPan,
				individualCountry : individualCountry,
				individualState : individualState,
				individualstate_code : individualstate_code,
				individualCity : individualCity,
				individualAddress : individualAddress,
				invoiceType : "Individual",
				invoiceDate : invoiceDate
			},
			success : function(data){
				if(data=="pass"){
					document.getElementById('errorMsg1').innerHTML = 'Successfully Updated !!';				  
					$('.alert-show1').show().delay(4000).fadeOut();					
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
				       
				$("#UpdateCompanyKey").val(clientkey);$("#UpdateCompanyName").val(name);$("#UpdateIndustry_Type").val(industry);
				$("#UpdatePanNumber").val(pan);$("#Edit_Company_age").val(compAge);
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
		var pan=$("#UpdatePanNumber").val();
		var gstin=$("#UpdateGSTNumber").val();
		var city=$("#UpdateCity").val();
		var state=$("#UpdateState").val();
		console.log("state==="+state);
		var stateCode="";
		var x=state.split("#");
		state=x[2];
		stateCode=x[1];
		console.log("stateCode==="+stateCode);
		var country=$("#UpdateCountry").val();
		if(country.includes("#")){
			var x=country.split("#");
			country=x[1];
		}
		var address=$("#UpdateAddress").val();
		var companyAge=$("#Edit_Company_age").val();
		var companykey=$("#UpdateCompanyKey").val();
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
				stateCode : stateCode
			},
			success : function(data){
				if(data=="pass"){
					document.getElementById('errorMsg1').innerHTML = 'Successfully Updated !!';
					$("#CompAddress").val(address);	
					$("#compuniquecregrefid").val(companykey);	
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
	function backInvoice(){
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
	function openInvoiceBox(invoice){
		$(".removePayment").remove();
		$("#openInvoiceNumber").val(invoice);
		$("#InvoiceBillNo").html("#"+invoice);
		fillInvoiceDetails(invoice);		
		
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
function fillInvoiceDetails(invoice){
	showLoader();
	$.ajax({
		type : "GET",
		url : "GetInvoiceDetails111",
		dataType : "HTML",
		data : {				
			invoice : invoice
		},
		success : function(response){		
		if(Object.keys(response).length!=0){
		response = JSON.parse(response);			
		 var len = response.length;		 
		 if(len>0){			 			 
			 var uuid=response[0]["uuid"];
			 var invoice_no=response[0]["invoice_no"];
			 var date=response[0]["date"];
			 var company=response[0]["company"];
			 var gstin=response[0]["gstin"];
			 var address=response[0]["address"];
			 var service_name=response[0]["service_name"];
			 var total_amount=response[0]["total_amount"];
			 var country=response[0]["country"];
			 var businessCountry=country;
			 var x=country.split("#");
			 country=x[1];
			 var state=response[0]["state"];
			 var city=response[0]["city"];
			 var state_code=response[0]["state_code"];
			 var status=response[0]["status"];
			 var invoiceType=response[0]["invoiceType"];
			 
			 $("#openInvoiceUuid").val(uuid);
			 $("#CompanyName").val(company);
			 $("#gstinNumber").val(gstin);
			 $("#businessCountry").val(businessCountry);
			 $("#businessState").empty();
			 $("#businessState").append('<option value="0#'+state_code+'#'+state+'">'+state+'</option>');
			 $("#businessCity").empty();
			 $("#businessCity").append('<option value="'+city+'">'+city+'</option>');
			 $("#businessAddress").val(address);
			 
			 var contact_name=response[0]["contact_name"];
			 var contact_pan=response[0]["contact_pan"];
			 var contact_country=response[0]["contact_country"];
			 var individualCountry=contact_country;
			 var x=contact_country.split("#");
			 contact_country=x[1];
			 var contact_state=response[0]["contact_state"];
			 var contact_city=response[0]["contact_city"];
			 var contact_address=response[0]["contact_address"];
			 var contact_state_code=response[0]["contact_state_code"];
			 
			 $("#contactName").val(contact_name);
			 $("#contactPan").val(contact_pan);
			 $("#individualCountry").val(individualCountry);
			 $("#individualState").empty();
			 $("#individualState").append('<option value="0#'+contact_state_code+'#'+contact_state+'">'+contact_state+'</option>');
			 $("#individualCity").empty();
			 $("#individualCity").append('<option value="'+contact_city+'">'+contact_city+'</option>');
			 $("#individualAddress").val(contact_address);
			 $("#invoiceDate").val(date);
			 
			 if(invoiceType=="Individual"){
				 $("#invoiceBusiness").prop("checked",false);
				 $("#invoiceIndividual").prop("checked",true)
				 $("#invoiceBusinessShow").hide();
				 $("#invoiceIndividualShow").show();
				 $("#BillToId").html(contact_name);
				 $("#ShipToId").html(contact_name);
				 $("#ShipToAddressId").html(contact_city+" ,"+contact_address);
				 if(contact_pan==null||contact_pan=="NA"||contact_pan=="")$("#BillToGSTINId").hide();
					else{
						$("#BillToGSTINId").html("PAN "+contact_pan);
						$("#BillToGSTINId").show();
					}
				 if(contact_state_code!="NA")
						$("#ShipToStateCode").html(contact_country+" ,"+contact_state+"("+contact_state_code+")");
						else
							$("#ShipToStateCode").html(contact_country+" ,"+contact_state);
			 }else if(invoiceType=="Business"){
				 $("#invoiceBusiness").prop("checked",true);
				 $("#invoiceIndividual").prop("checked",false)
				 $("#invoiceBusinessShow").show();
				 $("#invoiceIndividualShow").hide();
				 $("#BillToId").html(company); 
				 $("#ShipToId").html(company);
				 $("#ShipToAddressId").html(city+" ,"+address);
				 if(gstin==null||gstin=="NA"||gstin=="")$("#BillToGSTINId").hide();
					else{
						$("#BillToGSTINId").html("GSTIN "+gstin);
						$("#BillToGSTINId").show();
					}
				 if(state_code!="NA")
						$("#ShipToStateCode").html(country+" ,"+state+"("+state_code+")");
						else
							$("#ShipToStateCode").html(country+" ,"+state);
			 }
			 
			 $("#billingDate").html(date);
			 numberToWords("SalesRupeesInWord",Math.round(Number(total_amount)));
			 
			$('<div class="clearfix removePayment" style="font-weight: 600;width:100%;display: flex;padding: 4px 0px 4px 0px;">'+
			'<div style="width:4%;"><p style="margin: 0; font-size: 11px;">1.</p></div><div style="width:96%;">'+
			'<p style="margin: 0; font-size: 11px;">'+service_name+'</p></div></div>').insertBefore('#ItemListDetailsId');
		}}
		},
		complete : function(data){
			fillSalesInvoiceDetails(invoice);
		}
	});	
}
function fillSalesInvoiceDetails(invoice){
	 $(".ItemDetailList").remove();	
	 $("#TotalPriceWithoutGst").html('');
	 $("#TotalGstAmount").html('');
	$.ajax({
			type : "POST",
			url : "GetInvoicePriceList111",
			dataType : "HTML",
			data : {				
				invoice : invoice,						
			},
			success : function(data){
			if(Object.keys(data).length!=0){
				data = JSON.parse(data);			
			 var plen = data.length;
			 if(Number(plen)>0){	
				 var totalRateAmt=0;
				 var totalGSTAmt=0;
				 var totalSumAmt=0;
				 
			 for(var j=0;j<plen;j++){ 			
			 	var type=data[j]["type"];
			 	var hsn=data[j]["hsn"];
				var amount=Number(data[j]["amount"]);
				var cgst=data[j]["cgst"];
				var sgst=data[j]["sgst"];						
				var igst=data[j]["igst"];						
				
				var tax=Number(cgst)+Number(sgst)+Number(igst);
				var taxamt=(Number(amount)*Number(tax))/100;						
				var totalprice=Math.round((Number(amount)+Number(taxamt)));
				totalSumAmt=Number(totalSumAmt)+Number(totalprice);
				totalGSTAmt=Number(totalGSTAmt)+Number(taxamt);
				totalRateAmt=Number(totalRateAmt)+Number(amount);
				
				$(''+
						'<div class="clearfix removePayment" style="border-top: 1px solid #ccc;padding: 4px 0px 4px 0px;width:100%;display: flex;font-size: 10px;">'+
					    '<div style="margin-bottom: 0;padding-left: 16px; width: 34%;">'+
					    '<i class="" style="padding-right: 10px;color: #999;"></i>'+type+'</div>'+							    
					    '<div style="width:13%;">'+
						'<p style="margin:0;text-align: right;">'+hsn+'</p>'+
						'</div>'+
						'<div style="width:15%;">'+
						'<p style="margin:0;text-align: right;">'+numberWithCommas(Math.round(Number(amount)))+'</p>'+
						'</div>'+								
						'<div style="width:8%;">'+
						'<p style="margin:0;text-align: right;">'+tax+' %</p>'+
						'</div>'+
						'<div style="width:12%;">'+
						'<p style="margin:0;text-align: right;">'+numberWithCommas(Math.round(taxamt))+'</p>'+
						'</div>'+
						'<div style="width:18%;">'+
						'<p style="margin:0;text-align: right;">'+numberWithCommas(totalprice)+'</p>'+
						'</div>'+
						'</div>').insertBefore("#ItemListDetailsId");	
			 }
			 $(''+
				'<div class="clearfix removePayment" style="font-weight: 600;border-top: 1px dotted black;border-bottom: 1px dotted black;padding: 5px 0px 5px 0px;display: flex;">'+
				'<div style="padding-left: 16px; width: 34%;">'+
				'<p style="margin:0;font-size: 11px;">Total  : &nbsp;</p></div>'+
				'<div style="width:13%;"><p style="margin:0;text-align: right;font-size: 11px;">&nbsp;</p></div>'+
				'<div style="width:15%;"><p style="margin:0;text-align: right;font-size: 11px;">'+numberWithCommas(Math.round(Number(totalRateAmt)))+'</p></div>'+
				'<div style="width:8%;"><p style="margin:0;text-align: right;font-size: 11px;">&nbsp;</p></div>'+
				'<div style="width:12%;"><p style="margin:0;text-align: right;font-size: 11px;">'+numberWithCommas(Math.round(Number(totalGSTAmt)))+'</p></div>'+
				'<div style="width:18%;"><p style="margin:0;text-align: right;font-size: 11px;">'+numberWithCommas(Math.round(Number(totalSumAmt)))+'</p>'+
				'</div>'+
			'</div>').insertBefore("#ItemListDetailsId");			 
			
			 
			 }}
	},
	complete : function(data){
		showAllTaxData(invoice);
	}
			
	});
	 
// 	$("#TotalGstAmount").html(numberWithCommas(totalGST.toFixed(2))); 
	 
} 

function appendPriceList(refid,subitemdetails){		
	showLoader();  
	$.ajax({
		type : "POST",
		url : "GetUnbillPaymentPriceList111",
		dataType : "HTML",
		data : {				
			refid : refid,						
		},
		success : function(data){
		if(Object.keys(data).length!=0){
			data = JSON.parse(data);			
		 var plen = data.length;
		 if(Number(plen)>0){	
			 var totalRateAmt=0;
			 var totalGSTAmt=0;
			 var totalSumAmt=0;
			 
		 for(var j=0;j<plen;j++){ 			
		 	var type=data[j]["type"];
			var amount=data[j]["amount"];
			var cgst=data[j]["cgst"];
			var sgst=data[j]["sgst"];						
			var igst=data[j]["igst"];						
			
			var tax=Number(cgst)+Number(sgst)+Number(igst);
			var taxamt=((Number(amount)*Number(tax))/100).toFixed(2);						
			var totalprice=(Number(amount)+Number(taxamt)).toFixed(2);
			totalSumAmt=Number(totalSumAmt)+totalprice;
			totalGSTAmt=Number(totalGSTAmt)+taxamt;
			totalRateAmt=Number(totalRateAmt)+Number(amount).toFixed(2);
						 
			$(''+
					'<tr class="removePayment">'+
					'<td></td>'+
					'<td style="padding: 3px;">'+type+'</td>'+
					'<td style="padding: 3px;">'+amount+'</td>'+
					'<td style="padding: 3px;">'+sgst+'%</td>'+
					'<td style="padding: 3px;">'+cgst+'%</td>'+
					'<td style="padding: 3px;">'+igst+'%</td>'+
					'<td style="padding: 3px;">'+taxamt+'</td>'+
					'<td style="padding: 3px;">'+totalprice+'</td>'+
					'</tr>').insertBefore("#"+subitemdetails);
		 }
		 $(''+
		 '<tr class="removePayment" style="font-weight: 600">'+
		 '<td colspan="2" style="padding: 5px;">Total</td><td colspan="4">'+Number(totalRateAmt).toFixed(2)+'</td>'+
		 '<td style="padding: 5px;">'+Number(totalGSTAmt).toFixed(2)+'</td>'+
		 '<td style="padding: 5px;">'+Number(totalSumAmt).toFixed(2)+'</td>'+
		 '</tr>').insertBefore("#"+subitemdetails);
		 
		 }}
},
complete : function(data){
	hideLoader();
}});		
}

function showAllTaxData(invoice){
	$(".taxRemoveBox").remove();
	$.ajax({
			type : "POST",
			url : "GetInvoiceTaxList111",
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
							 
			 }}}else{
				 $("#DisplayTaxData").hide();
			 }
	},
	complete : function(data){
		hideLoader();
	}});
}
function proceedToConvert(data){
	var unbillno=$("#InvoiceConvertBillNo").val();	
	$("#warningProceed").modal("show");
	if(data=="proceed"){
		showLoader();
	 $.ajax({
			type : "POST",
			url : "ConvertInvoice111",
			dataType : "HTML",
			data : {				
				unbillno : unbillno,						
			},
			success : function(data){	
				$("#errorMsg1").html("Invoice Converted.......");
				$('.alert-show1').show().delay(4000).fadeOut();
				
	},
	complete : function(data){
		hideLoader();
		location.reload();
	}});
	}
}
function updateInvoice(){
// 	document.getElementById("InvoiceHead").innerHTML="Task History Of Sales Id : "+salesno;
	$("#UpdateInvoice").trigger('reset');	
	var id = $(".update_invoice").attr('data-related'); 
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });	
}
function showBackInvoice(){
	var invoice=$("#openInvoiceNumber").val();
	openInvoiceBox(invoice);
}
$("#invoiceBusiness").click(function(){
	$("#invoiceIndividualShow").hide();
	$("#invoiceBusinessShow").show();
})
$("#invoiceIndividual").click(function(){
	$("#invoiceIndividualShow").show();
	$("#invoiceBusinessShow").hide();
})
function cancelledInvoice(){
var invoice=$("#openInvoiceNumber").val();
  setCancelledInvoice(invoice);
  var id = $(".cancelled_invoice").attr('data-related'); 
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });	
}
function setCancelledInvoice(invoice){
	var path="<%=domain%>";
	$(".cancelledInvoice").remove();
	showLoader();
	$.ajax({
		type : "GET",
		url : "GetCancelledInvoice111",
		dataType : "HTML",
		data : {				
			invoice : invoice,						
		},
		success : function(data){	
		if(Object.keys(data).length!=0){
			data = JSON.parse(data);			
		 var len = data.length;
		 if(Number(len)>0){		 
		 for(var j=0;j<len;j++){ 			
		 	var date=data[j]["date"];
		 	var uuid=data[j]["uuid"];
		 	var amount=data[j]["amount"];
		 	var invoice=data[j]["invoice"];
			
		 	$(''+
					  '<tr class="cancelledInvoice">'+
						 '<td>'+date+'</td>'+
						 '<td>'+invoice+'</td>'+
						 '<td>'+amount+'</td>'+
						'<td><a href="'+path+'final-invoice-'+uuid+'.html" target="_blank"><i class="fa fa-file-text-o pointers" title="Invoice"></i></a></td>'+
					  '</tr>'			 
					 ).insertBefore("#cancelledInvoiceData");
	 		 
		 }
		 }}
	},
	complete : function(data){
		hideLoader();
	}});
}
function copyInvoiceLink(){
	showLoader();
	var uuid=$("#openInvoiceUuid").val();

// 	var url = $(location).attr('href');
<%-- 	var name="<%=request.getContextPath()%>"; --%>
// 	var index=url.indexOf(name);
	var domain="<%=domain%>";
	var urlText=$("#InvoiceUrl").val();
	var input=domain+"final-invoice-"+uuid+".html";
	$("#InvoiceUrl").val(input);
	  var copyText = document.getElementById("InvoiceUrl");
	  copyText.select();
	  copyText.setSelectionRange(0, 99999)
	  document.execCommand("copy");
	  $("#CopyLinkUrl").addClass('textCopied');
	  hideLoader();
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
					"field" : "invoicedcontactname"
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
            	doAction(ui.item.value,'invoicedContactName');
            	location.reload();
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
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
		document.getElementById('errorMsg').innerHTML ="Choose formate option !!";					
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
			type : "invoiced"
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
</script>
</body>
</html>