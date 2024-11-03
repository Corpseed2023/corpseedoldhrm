<%@page import="commons.DateUtil"%>
<%@page import="java.util.Properties"%>
<%@page import="commons.CommonHelper"%>
<%@page import="admin.enquiry.Enquiry_ACT"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/> 
	<title>Unbilled</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>

<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	<%if(!UBL0){%><jsp:forward page="/login.html" /><%} %>
<%

Properties properties = new Properties();
properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
String docBasePath=properties.getProperty("docBasePath");
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

// String sorting_order=(String)session.getAttribute("ubsorting_order");
// if(sorting_order==null)sorting_order="";

if(request.getParameter("page")!=null)pageNo=Integer.parseInt(request.getParameter("page"));
if(request.getParameter("rows")!=null)rows=Integer.parseInt(request.getParameter("rows"));

if(request.getParameter("sort")!=null)sort=request.getParameter("sort");

String sort_url=domain+"unbilled.html?page="+pageNo+"&rows="+rows;
String token=(String)session.getAttribute("uavalidtokenno");
String country[][]=TaskMaster_ACT.getAllCountries();
String today=DateUtil.getCurrentDateIndianFormat1();
//pagination end

String archiveFilter=(String)session.getAttribute("archiveFilter");
if(archiveFilter==null||archiveFilter.length()<=0)archiveFilter="2";

String unbillDateRangeAction=(String)session.getAttribute("unbillDateRangeAction");
if(unbillDateRangeAction==null||unbillDateRangeAction.length()<=0)unbillDateRangeAction="NA";

String unbillContactName=(String)session.getAttribute("unbillContactName");
if(unbillContactName==null||unbillContactName.length()<=0)unbillContactName="NA";

String unbill_no=(String)session.getAttribute("unbill_no");
if(unbill_no==null||unbill_no.length()<=0)unbill_no="NA";

String companyName=(String)session.getAttribute("companyName");
if(companyName==null||companyName.length()<=0)companyName="NA";


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
<div class="col-md-2 col-sm-2 col-xs-9"> 
	
	<ul class="clearfix filter_menu">  
	<li class="active"><a href="<%=request.getContextPath()%>/unbilled.html">Unbilled</a></li>
	<%if(INV0){ %><li><a href="<%=request.getContextPath()%>/all-invoice.html">Invoiced</a></li><%} %>
	</ul>
	
</div>
<a href="javascript:void(0)" class="doticon"> <i class="fa fa-filter" aria-hidden="true"></i>Filter</a>
<div class="filtermmenu">
<div class="col-md-10 col-sm-10 col-xs-12">
<div class="clearfix flex_box justify_end"> 
<div class="item-bestsell col-md-2 col-sm-2" style="margin-left: 15px;display: inline-block;">
	<select class="form-control filtermenu" onchange="doAction(this.value,'archiveFilter');location.reload();">
	<option value="2" <%if(archiveFilter.equalsIgnoreCase("2")){ %>selected<%} %>>Unarchived</option>
	<option value="1" <%if(archiveFilter.equalsIgnoreCase("1")){ %>selected<%} %>>Archived</option>
	</select>
</div> 
<div class="item-bestsell col-md-3 col-sm-6 col-xs-12">
<p><input type="search" name="unbill_no" id="unbill_no" autocomplete="off"<% if(!unbill_no.equalsIgnoreCase("NA")){ %> onsearch="clearSession('unbill_no');location.reload();" value="<%=unbill_no%>"<%} %> placeholder="Search by unbill" class="form-control"/>
</p>
</div>
<div class="item-bestsell col-md-3 col-sm-6 col-xs-12">
<p><input type="search" name="contactName" id="ContactName" <%if(!unbillContactName.equalsIgnoreCase("NA")){ %>onsearch="clearSession('unbillContactName');location.reload();" value="<%=unbillContactName %>"<%} %> title="Search by Client Name !" placeholder="Search by client name.." class="form-control"/>
</p>
</div> 
<div class="item-bestsell col-md-3 col-sm-4 col-xs-12">
<p><input type="search" name="companyName" id="companyName"<% if(!companyName.equalsIgnoreCase("NA")){ %> onsearch="clearSession('companyName');location.reload();" value="<%=companyName%>"<%} %> autocomplete="off" placeholder="Search by company" class="form-control"/>
</p>
</div> 
<div class="item-bestsell col-md-3 col-sm-4 col-xs-12 has-clear"> 
<p><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="FROM - TO" class="form-control text-center date_range pointers <%if(!unbillDateRangeAction.equalsIgnoreCase("NA")){%>selected<%} %>" readonly="readonly"/>
<span class="form-control-clear form-control-feedback" onclick="clearSession('unbillDateRangeAction');location.reload();"></span>
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
<div class="col-md-4">
<select class="form-control filtermenu" id="archiveStatus">
	<option value="">Action</option>
	<option value="1">Archive</option>
	<option value="2">Unarchive</option>
</select>
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
						            <%-- <th class="sorting <%if(sort.equals("id")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','id','<%=order%>')">SN</th> --%>
						            <th class="sorting <%if(sort.equals("date")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','date','<%=order%>')">Date</th>
<!-- 						            <th>Estimate_No</th> -->
						            <th>Unbill_No</th>
						            <th class="sorting <%if(sort.equals("service_name")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','service_name','<%=order%>')">Service Name</th>
						            <th>Client</th>
						            <th class="sorting <%if(sort.equals("company")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','company','<%=order%>')">Company</th>
						            <th class="sorting <%if(sort.equals("txn_amount")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','txn_amount','<%=order%>')">Txn. Amount</th>
<!-- 						            <th>Paid Amt.</th>						             -->
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
						    String[][] unbilled=Clientmaster_ACT.getAllPayment(unbillContactName,unbill_no,companyName,unbillDateRangeAction,token,pageNo,rows,sort,order,archiveFilter);
                            int totalBilling=Clientmaster_ACT.countAllPayment(unbillContactName,unbill_no,companyName,unbillDateRangeAction,token,archiveFilter);
						    if(unbilled!=null&&unbilled.length>0){
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
                             for(int i=0;i<unbilled.length;i++) {	  
                            	 String client[][]=Enquiry_ACT.getClientDetails(unbilled[i][4],token);
                            	 String addedByName=Usermaster_ACT.getLoginUserName(unbilled[i][11], token);
//                             	double paidAmount=TaskMaster_ACT.getPaidAmount(unbilled[i][2], token);                            	                           	
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
						        <td><input type="checkbox" name="checkbox" id="checkbox" class="checked" value="<%=unbilled[i][0] %>"></td>
						            <%-- <td><%=(i+1)%></td> --%>						            
						            <td><%=unbilled[i][10] %></td>
<%-- 						            <td><%=unbilled[i][2] %>/<%=unbilled[i][8] %></td> --%>
						            <td><%=unbilled[i][1] %></td>
						            <td><%=unbilled[i][3] %></td>
						            <td class="name_action_box position-relative" id="main<%=unbilled.length-i %>">
						            <span id="MainCon<%=unbilled.length-i %>" class="clickeble contactbox name_field" data-related="update_contact" <%if(client!=null&&client.length>0){ %>onclick="openContactBox('<%=client[0][3] %>','<%=client[0][2] %>','MainCon<%=unbilled.length-i%>','<%=unbilled[i][5] %>')"><%=client[0][0] %><%}else{ %>>NA<%} %></span>
                                    <%if(client!=null&&client.length>1){ %>
                                    <div class="iAction">
                                    <i class="fa fa-plus pointers" onclick="showAllContact(event,'main<%=unbilled.length-i %>','sub<%=unbilled.length-i %>')"><small><%=(client.length-1) %></small></i><i class="fa fa-minus pointers" onclick="minusAllContact(event)"></i>
                                    </div>
                                    <%} %>
						            <ul class="dropdown_list" id="sub<%=unbilled.length-i %>">
									<%if(client.length>1){for(int j=1;j<client.length;j++){ %>
									<li><a class="addnew2 pointers clickeble contactbox" data-related="update_contact" id="SubCon<%=unbilled.length-i %>" onclick="openContactBox('<%=client[j][3] %>','<%=client[j][2] %>','SubCon<%=unbilled.length-i%>','<%=unbilled[i][5] %>')"><%=client[j][0] %></a></li>
									<%}} %>
									</ul>
						            </td>
						            <td><span <%if(!unbilled[i][7].equalsIgnoreCase("....")){ %>class="clickeble name_action_box companybox" data-related="update_company" onclick="openCompanyBox('<%=unbilled[i][5]%>')"<%} %>><%=unbilled[i][7] %></span></td>
						            <td><i class="fas fa-inr inr"></i>&nbsp;<%=CommonHelper.withLargeIntegers(Double.parseDouble(unbilled[i][6])) %></td>
<%-- 						            <td><i class="fas fa-inr inr"></i>&nbsp;<%=paidAmount %></td> --%>
						            <td><%=addedByName %></td>
						            <td><a href="javascript:void(0)" class="invoicebox" data-related="invoice_receipt"
						            onclick="openInvoiceBox('<%=unbilled[i][8] %>','<%=unbilled[i][1] %>','<%=unbilled[i][5] %>','Notes<%=i%>','<%=unbilled[i][6] %>','<%=unbilled[i][3].replace("'", "")%>','<%=unbilled[i][0] %>')">
						            <button class="btn btn-primary">Convert To Invoice</button></a>
						            <input type="hidden" id="Notes<%=i %>" value="<%=unbilled[i][9]%>">
						            </td>
						        </tr>
						     <%}}%>                                 
						    </tbody>
						</table> 
						
                        <div class="filtertable">
			  <span>Showing <%=showing %> to <%=ssn+unbilled.length %> of <%=totalBilling %> entries</span>
			  <div class="pagination">
			    <ul> <%if(pageNo>1){ %>
			      <li class="page-item">	                     
			      <a class="page-link text-primary" href="<%=request.getContextPath()%>/unbilled.html?page=1&rows=<%=rows%>">First</a>
			   </li><%} %>
			    <li class="page-item">					      
			      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/unbilled.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
			    </li>  
			      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
				    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
				    <a class="page-link" href="<%=request.getContextPath()%>/unbilled.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
				    </li>   
				  <%} %>
				   <li class="page-item">						      
				      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/unbilled.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
				   </li><%if(pageNo<=(totalPages-1)){ %>
				   <li class="page-item">
				      <a class="page-link text-primary" href="<%=request.getContextPath()%>/unbilled.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
				   </li><%} %>
				</ul>
				</div>
				<select class="select2" onchange="changeRows(this.value,'unbilled.html?page=1','<%=domain%>')">
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

<div class="clearfix add_inner_box pad_box4 addcompany" id="invoice_receipt">
<div class="close_icon close_box"><i class="fa fa-times"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-file-o"></i>UNBILLED INVOICE</h3>
</div>
<h3 style="font-size: 13px;border-bottom: 1px solid #e1e1e1;padding-bottom: 11px;">

<span style="margin-left: 20px;" class="pointers" onclick="convertHTMLToPdf('invoicecontent','InvoiceBillNo')"><i class="fas fa-download"></i>&nbsp;&nbsp;PDF</span>
<span style="margin-left: 20px;" class="pointers" onclick="copyInvoiceLink()" title="Copy Invoice Link !!" id="CopyLinkUrl"><i class="far fa-copy"></i>&nbsp;&nbsp;URL</span> 
<span style="margin-left: 20px;" class="pointers" onclick="printDiv('invoicecontent','InvoiceBillNo')"><i class="fas fa-print"></i>&nbsp;&nbsp;Print</span> 
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
</p>
</div>
</div>
<div style="width:50%;">
<div style="margin-bottom:10px;text-align:right;">
<h2 style="font-size:18px;margin:0 0 5px;color:#48bd44;font-weight: 500;">UNBILLED</h2>
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
<p><span style="font-weight:600;color:#888;">Date :</span> <span style="padding-left:20px;"><%=today %></span></p>
</div>

</div>
<div class="clear"></div>
<div class="table-responsive">
<table  border="1" style="width:100%;border:1px solid #786d6d">
<tr style="background: #48bd44!important;color: #fff!important;">
<th rowspan="2" style="padding: 3px;border-radius: 0;">#</th>
<th rowspan="2" style="padding: 3px;">Item & Description</th>
<th rowspan="2" style="padding: 3px;">Rate</th>
<th colspan="3" style="padding: 3px;text-align:center;">Tax</th>
<th rowspan="2" style="padding: 3px;">Tax Amt.</th>
<th rowspan="2" style="padding: 3px;border-radius: 0;">Amount</th>
</tr>
<tr style="background: #48bd44!important;color: #fff!important;">
<td style="padding: 3px;">SGST %</td>
<td style="padding: 3px;">CGST %</td>
<td style="padding: 3px;">IGST %</td>
</tr>

<tbody id="ItemListDetailsId"></tbody>

</table>

<div class="clearfix" style="width:100%;padding: 10px 0 0 0;">
<p style="margin:0;font-size:11px;padding-left:10px;padding-right:10px;text-align:right;">Total In Words: <span style="font-weight:600;padding-left:10px;color:#666;" id="SalesRupeesInWord"></span></p>
</div>

</div>
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
<a href="javascript:void(0)" style="float: right;" onclick="proceedToConvert('NA')"><button class="btn btn-warning">Proceed to convert</button></a>
</div>

</div>

<div id="endContentId"></div>
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
      <form action="return false" id="exportUnbilledCol">
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
            	<option value="s.saddeddate" selected>Date</option>
            	<option value="s.sunbill_no" selected>Unbill No.</option>
            	<option value="s.service_name" selected>Service Name</option>
            	<option value="e.escontactrefid" selected>Client</option>
            	<option value="e.escompany" selected>Company</option>
            	<option value="es.amount" selected>Taxable</option>
            	<option value="es.cgst" selected>CGST</option>
            	<option value="es.sgst" selected>SGST</option>
            	<option value="es.igst" selected>IGST</option>
            	<option value="s.stransactionamount" selected>Amount</option>
            	<option value="s.saddedbyuid" selected>Sales Person</option>
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
<input type="hidden" id="InvoiceConvertBillNo"> 
<input type="hidden" id="InvoiceConvertUuid"> 
	<p id="end" style="display:none;"></p>
	</div>
	<div class="noDisplay"><a href="" id="DownloadExportedLink" download><button id="DownloadExported">Download</button></a></div>
	<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
	
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
					field :"unbillCompanyName"
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
            	doAction(ui.item.value,"companyName");
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
	   var dateRangeDoAction="<%=unbillDateRangeAction%>";
	   if(dateRangeDoAction!="NA"){	  
		   $('input[name="date_range"]').val(dateRangeDoAction);
	   }
	});

$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var data=$(this).val();
	doAction(data,"unbillDateRangeAction");
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
	$("#unbill_no").autocomplete({
		source : function(request, response) {			
			if(document.getElementById('unbill_no').value.trim().length>=1)
			$.ajax({
				url : "get-client-details.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					"field" : "unbill_no"
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
            	doAction(ui.item.value,'unbill_no');
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
	function openInvoiceBox(invoice,unbillno,clientkey,notesId,txnAmount,serviceName,refid){
		$(".removePayment").remove();
		$("#InvoiceBillNo").html("#"+unbillno);
		$("#InvoiceConvertBillNo").val(unbillno);
		$("#InvoiceConvertUuid").val(refid);
		fillClientDetails(clientkey,notesId,invoice);		 
		$("#TotalAmountWithGST").html(numberWithCommas(Math.round(Number(txnAmount))));
		numberToWords("SalesRupeesInWord",Math.round(Number(txnAmount)));
		fillSalesInvoiceDetails(invoice,serviceName,refid);
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
function fillClientDetails(clientkey,notesId,invoice){
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetCompanyByRefid111",
		dataType : "HTML",
		data : {				
			clientkey : clientkey,
			invoice : invoice
		},
		success : function(response){		
		if(Object.keys(response).length!=0){
		response = JSON.parse(response);			
		 var len = response.length;		 
		 if(len>0){ 
			var name=response[0]["name"];
			var gst=response[0]["gst"];
			var city=response[0]["city"];
			var state=response[0]["state"];
			var country=response[0]["country"];
			var x=country.split("#");
			country=x[1];
			var address=response[0]["address"];
			var stateCode=response[0]["stateCode"];
			
			$("#BillToId").html(name);
			var invoiceNotes=$("#"+notesId).val();
			if(invoiceNotes!=null&&invoiceNotes!="NA")
				$("#invoiceNotes").html(invoiceNotes);      
			if(gst==null||gst=="NA"||gst=="")$("#BillToGSTINId").hide();
			else{
				$("#BillToGSTINId").html("GSTIN "+gst);
				$("#BillToGSTINId").show();
			}
			$("#ShipToId").html(name);
			
			$("#ShipToAddressId").html(city+" ,"+address);
			if(stateCode!="NA")
				$("#ShipToStateCode").html(country+" ,"+state+"("+stateCode+")");
				else
					$("#ShipToStateCode").html(country+" ,"+state);
		 }}
		},
		complete : function(data){
			hideLoader();
		}
	});	
}
function fillSalesInvoiceDetails(invoice,serviceName,refid){
	 $(".ItemDetailList").remove();	
	 $("#TotalPriceWithoutGst").html('');
	 $("#TotalGstAmount").html('');
	 	
	$(''+
			'<tr class="removePayment"><td style="padding: 3px;font-weight:600">1.</td>'+
			'<td style="padding: 3px;font-weight:600" colspan="7">'+serviceName+'</td></tr>').insertBefore('#ItemListDetailsId');
		   appendPriceList(refid,"ItemListDetailsId");
		
// 	 showAllTaxData(invoice);
	 setTimeout(function(){			 	
	 	var totalRate=Number($("#TotalPriceWithoutGst").html());
		 var totalGST=Number($("#TotalGstAmount").html());				 
		 $("#TotalPriceWithoutGst").html(numberWithCommas(totalRate.toFixed(2)));
		 $("#TotalGstAmount").html(numberWithCommas(totalGST.toFixed(2)));			
		 
	 },1000);
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
						var amount=Math.round(Number(data[j]["amount"]));
						var cgst=data[j]["cgst"];
						var sgst=data[j]["sgst"];						
						var igst=data[j]["igst"];						
						
						var tax=Number(cgst)+Number(sgst)+Number(igst);
						var taxamt=Math.round(((Number(amount)*Number(tax))/100));						
						var totalprice=Math.round((Number(amount)+Number(taxamt)).toFixed(2));
						
						totalSumAmt=Number(totalSumAmt)+Number(totalprice);
						totalGSTAmt=Number(totalGSTAmt)+Number(taxamt);
						totalRateAmt=Number(totalRateAmt)+Number(amount);
						
// 						totalRate=Number(totalRate)+Number(price);
// 						totalGST=Number(totalGST)+Number(taxamt);			 
						$(''+
								'<tr class="removePayment">'+
								'<td></td>'+
								'<td style="padding: 3px;">'+type+'</td>'+
								'<td style="padding: 3px;">'+numberWithCommas(amount)+'</td>'+
								'<td style="padding: 3px;">'+sgst+'%</td>'+
								'<td style="padding: 3px;">'+cgst+'%</td>'+
								'<td style="padding: 3px;">'+igst+'%</td>'+
								'<td style="padding: 3px;">'+numberWithCommas(taxamt)+'</td>'+
								'<td style="padding: 3px;">'+numberWithCommas(totalprice)+'</td>'+
								'</tr>').insertBefore("#"+subitemdetails);
					 }
					 $(''+
					 '<tr class="removePayment" style="font-weight: 600">'+
					 '<td colspan="2" style="padding: 5px;">Total</td><td colspan="4" style="padding: 3px;">'+numberWithCommas(Math.round(Number(totalRateAmt)))+'</td>'+
					 '<td style="padding: 3px;">'+numberWithCommas(Math.round(Number(totalGSTAmt)))+'</td>'+
					 '<td style="padding: 3px;">'+numberWithCommas(Math.round(Number(totalSumAmt)))+'</td>'+
					 '</tr>').insertBefore("#"+subitemdetails);

					 }}
			},
			complete : function(data){
				hideLoader();
			}});		
}

function showAllTaxData(invoice){
	$(".taxRemoveBox").remove();
	showLoader();
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
				$("#warningProceed").modal("hide");
				$("#errorMsg1").html("Invoice Converted.......");
				$('.alert-show1').show().delay(4000).fadeOut();				
	},
	complete : function(data){
		hideLoader();
		location.reload();		
	}});	 
	}
}
function copyInvoiceLink(){
	showLoader();
	var uuid=$("#InvoiceConvertUuid").val();

// 	var url = $(location).attr('href');
<%-- 	var name="<%=request.getContextPath()%>"; --%>
// 	var index=url.indexOf(name);
	var domain="<%=domain%>";
	var urlText=$("#InvoiceUrl").val();
	var input=domain+"slip-"+uuid+".html";
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
					"field" : "unbilledcontactname"
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
            	doAction(ui.item.value,'unbillContactName');
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
$(document).ready(function(){
	$("#archiveStatus").change(function(){
		var action=$(this).val();
		if(action!=null&&action!=""){
			console.log(action);
			
			var array = [];
			$("input:checkbox[id=checkbox]:checked").each(function(){
				array.push($(this).val());
			});
			
			$.ajax({
				type : "POST",
				url : "UpdateArchiveStatus111",
				dataType : "HTML",
				data : {	
					action:action,
					array:array+""
				},
				success : function(data){	
					location.reload();		
				},
				complete : function(data){
					hideLoader();
				}
			});			
		}		
	})
})
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
			type : "unbilled"
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