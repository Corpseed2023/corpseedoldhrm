<%@page import="java.util.Properties"%>
<%@page import="commons.CommonHelper"%>
<%@page import="commons.DateUtil"%>
<%@page import="admin.enquiry.Enquiry_ACT"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/> 
	<title>Manage Estimate Sale</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>

<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	<%if(!EST00){%><jsp:forward page="/login.html" /><%} %> 
	<%
String addedby= (String)session.getAttribute("loginuID");
String loginuaid= (String)session.getAttribute("loginuaid");
String userRole= (String)session.getAttribute("userRole");
String userroll= (String)session.getAttribute("emproleid");
String department= (String)session.getAttribute("uadepartment");
if(department==null)department="NA";
String token=(String)session.getAttribute("uavalidtokenno");
String today=DateUtil.getCurrentDateIndianFormat1();
Properties properties = new Properties();
properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
String domain=properties.getProperty("domain");
String docBasePath=properties.getProperty("docBasePath");

// new start  
String estDoAction=(String)session.getAttribute("estDoAction");
if(estDoAction==null||estDoAction.length()<=0)estDoAction="All";

String ClientNameDoAction=(String)session.getAttribute("ClientNameDoAction");
if(ClientNameDoAction==null||ClientNameDoAction.length()<=0)ClientNameDoAction="NA";

String estimateNoDoAction=(String)session.getAttribute("estimateNoDoAction");
if(estimateNoDoAction==null||estimateNoDoAction.length()<=0)estimateNoDoAction="NA";

String estimateContactAction=(String)session.getAttribute("estimateContactAction");
if(estimateContactAction==null||estimateContactAction.length()<=0)estimateContactAction="NA";

String dateRangeDoAction=(String)session.getAttribute("dateRangeDoAction");
if(dateRangeDoAction==null||dateRangeDoAction.length()<=0)dateRangeDoAction="NA";

/*end  */ 

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

String sort_url=domain+"manage-estimate.html?page="+pageNo+"&rows="+rows;

//pagination end 

int totalEstimate=Clientmaster_ACT.countAllEstimate(userRole,loginuaid,token,estDoAction,ClientNameDoAction,estimateNoDoAction,dateRangeDoAction,estimateContactAction,department);

String[][] estimate=Clientmaster_ACT.getAllEstimate(userRole,loginuaid,token,estDoAction,ClientNameDoAction,estimateNoDoAction,dateRangeDoAction,pageNo,rows,sort,order,estimateContactAction,department); 

String[][] servicetype=TaskMaster_ACT.getAllServiceType(token);

double totalSalesAmount=Clientmaster_ACT.getTotalSalesAmount(userRole,loginuaid,estDoAction,token,ClientNameDoAction,estimateNoDoAction,dateRangeDoAction,estimateContactAction,department);
double convertedSales=Clientmaster_ACT.getTotalConvertedSalesAmount(userRole,loginuaid,estDoAction,token,ClientNameDoAction,estimateNoDoAction,dateRangeDoAction,estimateContactAction,department); 
double convertedSalesDues=Clientmaster_ACT.getTotalSalesDueAmount(userRole,loginuaid,estDoAction,token,ClientNameDoAction,estimateNoDoAction,dateRangeDoAction,estimateContactAction,department);
int convertedQty=Clientmaster_ACT.countTotalConvertedSale(userRole,loginuaid,estDoAction,token,ClientNameDoAction,estimateNoDoAction,dateRangeDoAction,estimateContactAction,department); 
 
String country[][]=TaskMaster_ACT.getAllCountries();

%>
	<div id="content">
		<div class="main-content">
			<div class="container-fluid">				
				
				<div class="box_shadow1 invoice_info redius_box pad_box4 bg_wht mb30">
                        <div class="clearfix dashboard_info">
                        
                          <div class="pad0 col-md-3 col-sm-3 col-xs-6">
                          <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:100px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div>
						   <div class="clearfix mlft20">
                            <h3 title="<%=Math.round(totalSalesAmount)%>"><i class="fa fa-inr"></i> <%=CommonHelper.formatValue(Math.round(totalSalesAmount)) %></h3>
							<span>Estimate Sales</span>
						   </div>
                          </div>
                          <div class="pad0 bdr_left col-md-3 col-sm-3 col-xs-6">
                           <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:100px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div>
						   <div class="clearfix mlft20">
                            <h3 title="<%=Math.round(convertedSales)%>"><i class="fa fa-inr"></i> <%=CommonHelper.formatValue(Math.round(convertedSales)) %> </h3>
							<span>Total Sales</span>
                           </div>
						  </div>
                          <div class="pad0 bdr_left col-md-3 col-sm-3 col-xs-6">
                           <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:100px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div>
						   <div class="clearfix mlft20">
                            <h3 title="<%=Math.round(convertedSalesDues)%>"><i class="fa fa-inr"></i> <%=CommonHelper.formatValue(Math.round(convertedSalesDues)) %></h3>
							<span>Due Amount</span>
                           </div>
						  </div>
                          <div class="pad0 bdr_left col-md-3 col-sm-3 col-xs-6">
                           <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:100px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div>
						   <div class="clearfix mlft20">
                            <h3 title="<%=convertedQty%>"><i class="fab fa-angellist"></i> <%=CommonHelper.formatValue(convertedQty) %></h3>
							<span>No. Of Deals</span>
                           </div>
						  </div>
                        </div> 
				</div>
<div class="clearfix"> 
				<form name="RefineSearchenqu" onsubmit="return false;">
				<div class="bg_wht clearfix mb10">  
				<div class="row" id="SearchOptions">
				<div class="post" style="position:absolute;z-index:9">
                <div class="linee" style="margin-top: -1px;width:1350px;height:50px"></div>
                    </div>
				<div class="col-md-4 col-sm-4 col-xs-12"> 
				<div class="col-md-6 col-sm-6 box-width17">
				<%if(EST01){ %><a href="<%=request.getContextPath() %>/newestimatesale.html"><button type="button" class="filtermenu dropbtn" style="width: 83px;margin-left: -14px;">+&nbsp;Add new</button></a><%} %>
				</div>
				<div class="col-md-6 col-sm-6" style="margin-left: 15px;display: inline-block;">
				<select class="filtermenu" onchange="doAction(this.value,'estDoAction');location.reload();">
				<option value="All" <%if(estDoAction.equalsIgnoreCase("All")){ %>selected<%} %>>All</option>
				<option value="Invoiced" <%if(estDoAction.equalsIgnoreCase("Invoiced")){ %>selected<%} %>>Invoiced</option>
				<option value="Draft" <%if(estDoAction.equalsIgnoreCase("Draft")){ %>selected<%} %>>Draft</option>
				<option value="Cancelled" <%if(estDoAction.equalsIgnoreCase("Cancelled")){ %>selected<%} %>>Cancelled</option>
				<option value="Pending for approval" <%if(estDoAction.equalsIgnoreCase("Pending for approval")){ %>selected<%} %>>Pending for approval</option>
				</select>
				</div>
				</div>
				<a href="javascript:void(0)" class="doticon"> <i class="fa fa-filter" aria-hidden="true"></i>Filter</a>
				<div class="filtermmenu">
				<div class="col-md-8 col-sm-8 col-xs-12">
				<div class="clearfix flex_box justify_end">  
				<div class="item-bestsell col-md-3 col-sm-6 col-xs-12">
				<p><input type="search" name="contactName" id="ContactName" <%if(!estimateContactAction.equalsIgnoreCase("NA")){ %>onsearch="clearSession('estimateContactAction');location.reload();" value="<%=estimateContactAction %>"<%} %> title="Search by Client !" placeholder="Client Name.." class="form-control"/>
				</p>
				</div>
				<div class="item-bestsell col-md-3 col-sm-6 col-xs-12 has-clear">
				<p><input type="search" name="clientname" id="ClientName" autocomplete="off" <% if(!ClientNameDoAction.equalsIgnoreCase("NA")){ %>onsearch="clearSession('ClientNameDoAction');location.reload();" value="<%=ClientNameDoAction%>"<%} %> placeholder="Search by company" class="form-control"/>
				</p>
				</div> 
				<div class="item-bestsell col-md-3 col-sm-6 col-xs-12 has-clear">
				<p><input type="search" name="estimateNo" id="EstimateNo" <%if(!estimateNoDoAction.equalsIgnoreCase("NA")){ %>onsearch="clearSession('estimateNoDoAction');location.reload();" value="<%=estimateNoDoAction %>"<%} %> autocomplete="off" placeholder="Estimate No." class="form-control"/>
				</p>
				</div> 
				<div class="item-bestsell col-md-3 col-sm-6 col-xs-12 has-clear"> 
				<p><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="FROM - TO" class="form-control text-center date_range pointers <%if(!dateRangeDoAction.equalsIgnoreCase("NA")){ %>selected<%} %>" readonly="readonly"/>
				<span class="form-control-clear form-control-feedback" onclick="clearSession('dateRangeDoAction');location.reload();"></span>
				</p>
				</div>
				</div>
				</div>
				</div>
				</div>
				<!-- search option 2 -->
				<div class="row noDisplay" id="SearchOptions1">
				<div class="col-md-5 col-sm-5 col-xs-12"> 
				<div class="col-md-4">
				<a href="#" onclick="downloadInvoices()"><button type="button" class="filtermenu btn-block dropbtn">Download</button></a>
				</div>
				<div class="col-md-4">
				<button type="button" class="filtermenu btn-block dropbtn" data-toggle="modal" data-target="#ExportData">Export</button>
				</div>
				<div class="col-md-4">
				<select class="form-control filtermenu" id="estimateStatus">
					<option value="">Action</option>
					<option value="Draft">Draft</option>
					<option value="Cancelled">Cancel</option>
				</select>
				</div>
				</div>
				<div class="col-md-7 col-sm-7 col-xs-12 min-height50">
				<div class="clearfix flex_box justify_end">  
				
				</div>
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
						            <th width="100" class="sorting <%if(sort.equals("date")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','date','<%=order%>')">Date</th>
						            <th class="sorting <%if(sort.equals("estimate")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','estimate','<%=order%>')">Estimate No.</th>
						            <th>Client's Name</th>
						            <th class="sorting <%if(sort.equals("company")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','company','<%=order%>')">Company</th>
						            <th class="sorting  <%if(sort.equals("status")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','status','<%=order%>')">Status</th>
						            <th width="120">Amount</th>
						            <th>Sales Person</th>
						        </tr>
						    </thead>
						    <tbody>
						    <%
						    int ssn=0;
						    
						    int startRange=pageNo-2;
						    int endRange=pageNo+2;
						    int totalPages=1;
						    int showing=0;
						    String pymtstatus="NA";
	                           String color="NA";
	                           if(estimate!=null&&estimate.length>0){
	                        	   
	                        	   ssn=rows*(pageNo-1);
	                        	   showing=ssn+1;
	                        		  totalPages=(totalEstimate/rows);
	                        		  if((totalEstimate%rows)!=0)totalPages+=1;
	                        		  
	                        		  if (totalPages > 1) {     	 
	                        			  if((endRange-2)==totalPages)startRange=pageNo-4;        
	                        	          if(startRange==pageNo)endRange=pageNo+4;
	                        	          if(startRange<1) {startRange=1;endRange=startRange+4;}
	                        	          if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
	                        	          if(startRange<1)startRange=1;
	                        	     }else{startRange=0;endRange=0;}	                        	   
	                            for(int i=0;i<estimate.length;i++) {
	                           	 String client[][]=Enquiry_ACT.getClientDetails(estimate[i][11],token);
	                           	 String compaddress[]=Clientmaster_ACT.getClientAddressByRefid(estimate[i][12], token);
	                           	 double totalamt=Clientmaster_ACT.getTotalClientProjectAmount(estimate[i][2],token); 
	                           	 String salesPerson=Usermaster_ACT.getLoginUserName(estimate[i][10], token);
	                           			 
	                           	 totalamt-=Double.parseDouble(estimate[i][15]);
	                           	 String clientEmail="NA";
	                           	 String clientName="NA";
	                           	 if(client!=null&&client.length>0){
	                           		 clientEmail=client[0][5];
	                           		clientName=client[0][0];
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
                           
						        <tr>
						            <td><input type="checkbox" name="checkbox" id="checkbox" class="checked" value="<%=estimate[i][2] %>"></td>
						            <td><%=estimate[i][9] %></td>
						            <td><span class="clickeble estimatebox" data-related="estimate_invoice" onclick="openEstimateBox('<%=estimate[i][2] %>','<%=estimate[i][3] %>','<%=estimate[i][11] %>','<%=estimate[i][12] %>','<%=estimate[i][1] %>','<%=estimate[i][15]%>','<%=clientEmail%>','<%=clientName%>','<%=totalamt%>','<%=estimate[i][9]%>','<%=estimate[i][16]%>','<%=estimate[i][14]%>')"><%=estimate[i][2] %></span></td>
						            <td class="name_action_box position-relative" id="main<%=estimate.length-i %>">
						            <span id="MainCon<%=estimate.length-i %>" class="clickeble contactbox name_field" data-related="update_contact" <%if(client!=null&&client.length>0){ %>onclick="openContactBox('<%=client[0][3] %>','<%=client[0][2] %>','MainCon<%=estimate.length-i%>','Address<%=estimate.length-i %>')"><%=client[0][0] %><%}else{ %>>NA<%}%></span>
                                   <%if(client!=null&&client.length>1){ %>
                                   <div class="iAction">
                                   <i class="fa fa-plus pointers" onclick="showAllContact(event,'main<%=estimate.length-i %>','sub<%=estimate.length-i %>')"><small><%=(client.length-1) %></small></i><i class="fa fa-minus pointers" onclick="minusAllContact(event)">&nbsp;</i>
                                   </div>
                                   <%} %>
						            <ul class="dropdown_list" id="sub<%=estimate.length-i %>">
									<%if(client!=null&&client.length>1){for(int j=1;j<client.length;j++){ %>
									<li><a class="addnew2 pointers clickeble contactbox" data-related="update_contact" id="SubCon<%=estimate.length-i %>" onclick="openContactBox('<%=client[j][3] %>','<%=client[j][2] %>','SubCon<%=estimate.length-i%>','Address<%=estimate.length-i %>')"><%=client[j][0] %></a></li>
									<%}} %>
									</ul>
						            </td>
						            <td>
						            <span class="clickeble companybox" data-related="update_company" onclick="openCompanyBox('<%=estimate[i][12] %>')"><%=estimate[i][3] %></span>
						            <input type="hidden" name="address<%=estimate.length-i %>" id="Address<%=estimate.length-i %>" value="<%=compaddress[0]%>">
						            </td>
						            <%if(estimate[i][14].equalsIgnoreCase("Invoiced")){%>
						            <td class="text-success"><%=estimate[i][14] %></td><%}else if(estimate[i][14].equalsIgnoreCase("Cancelled")){%>
						            <td><a href="javascript:void(0)" onclick="showCancelReason('<%=estimate[i][2] %>')" class="text-danger"><%=estimate[i][14] %></a></td><%}else{%>
						            <td><%=estimate[i][14] %></td>
						            <%} %>						            
						            <td>
						            <span class="clickeble estimatebox" data-related="estimate_invoice" onclick="openEstimateBox('<%=estimate[i][2] %>','<%=estimate[i][3] %>','<%=estimate[i][11] %>','<%=estimate[i][12] %>','<%=estimate[i][1] %>','<%=estimate[i][15]%>','<%=clientEmail%>','<%=clientName%>','<%=totalamt %>','<%=estimate[i][9] %>','<%=estimate[i][16]%>','<%=estimate[i][14]%>')" title="<%=Math.round(totalamt)%>"><i class="fa fa-inr"></i>&nbsp<%=CommonHelper.withLargeIntegers(totalamt) %></span>
						            </td>	
						            <td><%=salesPerson %></td>					            
						        </tr><%}}%>					     
                                 
						    </tbody>
						</table>
						</div> 
						 <div class="filtertable">
						  <span>Showing <%=(showing) %> to <%=ssn+estimate.length %> of <%=totalEstimate %> entries</span>
						  <div class="pagination">
						    <ul> <%if(pageNo>1){ %>
						      <li class="page-item">	                     
						      <a class="page-link text-primary" href="<%=request.getContextPath()%>/manage-estimate.html?page=1&rows=<%=rows%><%=filter%>">First</a>
						   </li><%} %>
						    <li class="page-item">					      
						      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/manage-estimate.html?page=<%=(pageNo-1) %>&rows=<%=rows%><%=filter%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
						    </li>  
						      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
							    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
							    <a class="page-link" href="<%=request.getContextPath()%>/manage-estimate.html?page=<%=i %>&rows=<%=rows%><%=filter%>"><%=i %></a>
							    </li>   
							  <%} %>
							   <li class="page-item">						      
							      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/manage-estimate.html?page=<%=(pageNo+1) %>&rows=<%=rows%><%=filter%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
							   </li><%if(pageNo<=(totalPages-1)){ %>
							   <li class="page-item">
							      <a class="page-link text-primary" href="<%=request.getContextPath()%>/manage-estimate.html?page=<%=(totalPages) %>&rows=<%=rows%><%=filter%>">Last</a>
							   </li><%} %>
							</ul>
							</div>
							<select class="select2" onchange="changeRows(this.value,'manage-estimate.html?page=1','<%=domain%>')">
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

<div class="clearfix add_inner_box pad_box4 addcompany" id="update_company">
<div class="close_icon close_box"><i class="fas fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="far fa-building"></i>Update Company</h3> 
<p>When someone reaches out to you, they become a contact in your account. You can create companies and associate contacts with them.</div>
<form onsubmit="return false;" id="UpdateRegCompany">
<input type="hidden" id="UpdateCompanyKey">
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="companyname" id="UpdateCompanyName" placeholder="Company Name" onblur="validCompanyNamePopup('UpdateCompanyName');validateValuePopup('UpdateCompanyName');isExistValue('UpdateCompanyName')" class="form-control bdrd4" readonly="readonly">
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
  <input type="text" name="gstnumber" id="UpdateGSTNumber" onblur="isExistEditGST('UpdateGSTNumber')" placeholder="GST Number here !" class="form-control bdrd4">
<button class="addbtn pointers close_icon1 del_icon" type="button"><i class="fas fa-times" style="font-size: 20px;"></i></button>
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
<div class="close_icon close_box"><i class="fas fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fas fa-user-cog"></i>Update client's details</h3>
<p>When someone reaches out to you, they become a contact in your account. You can create companies and associate contacts with them.</div>

<form onsubmit="return false;" id="FormUpdateContactBox" novalidate>
<input type="hidden" id="UpdateContactKey"/>
<input type="hidden" id="UpdateContactSalesKey"/>
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
  <input type="email" name="enqEmail1" id="UpdateContactEmail_Id" onblur="verifyEmailIdPopup('UpdateContactEmail_Id');isUpdateDuplicateEmail('UpdateContactEmail_Id');" placeholder="Email" class="form-control bdrd4">
 </div>
</div>
<div class="text-right">
<span class="add_new pointers">+ Email</span>
</div>
<div class="relative_box form-group new_field" id="UpdateContactDivId" style="display:none;">
  <label>Email 2nd :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>-->
  <input type="email" name="enqEmail2" id="UpdateContactEmailId2" onblur="isUpdateDuplicateEmail('UpdateContactEmailId2');" placeholder="Email" class="form-control bdrd4">
<button class="addbtn pointers close_icon1 del_icon" type="button"><i class="fas fa-times" style="font-size: 20px;"></i></button>
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
  <input type="text" name="workphone" id="UpdateContactWorkPhone" onblur="isUpdateDuplicateMobilePhone('UpdateContactWorkPhone')" placeholder="Work phone" maxlength="14" class="form-control bdrd4" onkeypress="return isNumber(event)">
  </div>
  <div id="wphoneErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>Mobile Phone :</label>
  <div class="input-group">
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

<div class="clearfix add_inner_box pad_box4 addcompany" id="estimate_invoice" style="width: 700px; display:none">
<div class="close_icon close_box" style="right: 700px;z-index:99"><i class="fas fa-times"></i></div> 
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-wpforms"></i>Estimate details</h3>
<div class="clearfix btn_action">
<button type="button" class="estnotes" data-related="task_notes" onclick="openTaskNotesBox()" style="margin-right:1rem">Notes</button>
<div id="EditEstimateButtonId"></div>
<button type="button" class="invconvt" data-related="convert_invoice" onclick="convertInvoiceBox()">Convert to invoice</button>
</div>
</div>

<div id="testinvoiceprint"></div>
<h3 style="font-size: 13px;border-bottom: 1px solid #e1e1e1;padding-bottom: 11px;">
<span class="pointers" id="EmailSendedId" onclick="openSendEmailBox()"><i class="far fa-envelope"></i>&nbsp;&nbsp;Send email</span>
<span style="margin-left: 20px;" class="pointers" onclick="convertHTMLToPdf('invoicecontent','EstimateBillNo')"><i class="fas fa-download"></i>&nbsp;&nbsp;PDF</span>
<span style="margin-left: 20px;" class="pointers" onclick="copyInvoiceLink()" title="Copy Invoice Link !!" id="CopyLinkUrl"><i class="far fa-copy"></i>&nbsp;&nbsp;URL</span> 
<span style="margin-left: 20px;" class="pointers" onclick="printDiv('invoicecontent','EstimateBillNo')"><i class="fas fa-print"></i>&nbsp;&nbsp;Print</span> 
<span style="margin-left: 20px;" class="pointers generate_estimate" data-related="GenerateEstimate" onclick="generateEstimate()"><i class="fas fa-receipt"></i>&nbsp;&nbsp;Generate Estimate</span>
<span style="margin-left: 20px;" class="pointers upload_documents" data-related="UploadDocuments" onclick="uploadDocument()"><i class="fas fa-file"></i>&nbsp;&nbsp;Upload Documents</span>
</h3>
<div class="clearfix" style="padding-left: 15px;border-bottom: 1px solid #e1e1e1;">
<div class="clearfix">
	<div class="clearfix" id="AppendMainEstimateSumary"></div>
</div>

<div class="clearfix" id="AppendEstimateSumaryDynamic"></div>

<div class="clearfix" style="margin-bottom: 10px;">
<span style="cursor: pointer;color: #42b0e0;font-weight: 600;" id="MoreViewButton" onclick="showEstimateSummary()">View Next</span>
<span style="cursor: pointer;color: #42b0e0;font-weight: 600;margin-left: 64px;display: none;" id="MinimizeViewButton" onclick="hideEstimateSummary()">View Prev</span>
</div> 

</div>
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
<h2 style="font-size:18px;margin:0 0 5px;color:#48bd44;font-weight: 500;">Estimate</h2>
<p style="font-weight:600;" id="EstimateBillNo"></p>
</div>
<div style="margin-bottom:10px;text-align:right;" id="orderNoMain">
<h2 style="font-size: 14px;margin:0 0 5px;color:#48bd44;font-weight: 500;">Order No.</h2>
<p style="font-weight:600;" id="orderNo">#ORD00120</p>
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
<p><span style="font-weight:600;color:#888;">Estimate Date :</span> <span style="padding-left:20px;" id="EstimateDate"></span></p>
<p id="purchaseDateMain"><span style="font-weight:600;color:#888;">Order Date :</span> <span style="padding-left:20px;" id="PurchaseDate"></span></p>
</div>

</div>
<div class="clear"></div>
<div class="table-responsive">
<table class="estimatein" style="width:100%">
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
<p style="margin:0;font-size:11px;padding-left:10px;padding-right:10px;text-align:right;">Total In Words: <span style="font-weight:600;padding-left:10px;color:#666;" id="EstimateRupeesInWord"></span></p>
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
</td></tr>
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
<input type="text" id="InvoiceUrl" style="opacity: 0;">
</div>

<div class="clearfix add_inner_box pad_box4 addcompany" id="edit_estimate" style="width: 700px; display:none">
<div class="close_icon close_box" style="right: 700px;"><i class="fas fa-times"></i></div> 
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-wpforms"></i>Edit Estimate</h3> 

<input type="hidden" id="ConvertInvoiceSaleNo"/>
<input type="hidden" id="ConvertInvoiceCompany"/>
<input type="hidden" id="ConvertInvoiceContactrefid"/>
<input type="hidden" id="ConvertEstimateRefKey"/>
<input type="hidden" id="ConvertEstimateSalesType"/>
<input type="hidden" id="ConvertEstimateDocRefKey"/>
<input type="hidden" id="SendEmailClientEmail"/>
<input type="hidden" id="SendEmailClientName"/>
<input type="hidden" id="ConvertEstimateDiscount"/>
<input type="hidden" id="ConvertInvoiceClientrefid"/>

<a class="clickeble estimatebox" data-related="estimate_invoice" onclick="backEstimate()" style="position: absolute;right: 0;top: 0;"><button class="bkbtn">Back</button></a>
</div>
<div class="clearfix">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group relative_box">
 <div class="clearfix text-right">
 	<button class="addbtn pointers" type="button" data-related="add_contact" id="NewProductBtn" onclick="addNewProduct()" style="float:right;margin-bottom: 10px;">+ New Product</button>
</div>
<select name="product_name" id="Convert_Product_Name" class="form-control">
      
</select>
</div>
</div>
</div>
<!-- START -->
<div class="clearfix" id="ProductPriceDiv0">
  <div class="clearfix inner_box_bg form-group" id="EstimateProductPrice" style="display: none;">
    <div class="mb10 flex_box align_center relative_box" id="consultingTypeSales">
    <span class="input_radio bg_wht pad_box2 pad_box3 s_head"> 
	<select class="s_type" name="jurisdiction" id="Jurisdiction" onchange="updatePlan('CurrentProdrefid',this.value,'esjurisdiction');" required="required">
	<option value="">Select Jurisdiction</option>																	
	</select>									
	</span>
	<span class="input_radio bg_wht pad_box2 pad_box3"> 
	<input type="radio" name="timetype" id="onetime" checked="checked" onclick="hideTime('ProductPeriod','TimelineBox','MainTimelineValue');updatePlan('CurrentProdrefid','OneTime','esprodplan');">
	<span>One time</span>
	</span>
	<span class="mlft10 input_radio bg_wht pad_box2 pad_box3">
	<input type="radio" name="timetype" id="renewal" onclick="askTime('ProductPeriod','MainTimelineValue','MainTimelineUnit');updatePlan('CurrentProdrefid','Renewal','esprodplan');">
	<span>Renewal</span>
	</span>
	<span class="mlft10 RenBox1" id="ProductPeriod" style="width: 100px;">
	<input type="text" name="addtimelinevalue" autocomplete="off"  onclick="showTimelineBox('TimelineBox')" onchange="updatePlan('CurrentProdrefid',this.value,'esplantime');" id="MainTimelineValue" class="form-control bdrnone text-right" placeholder="Timeline" style="width: 55%;" readonly="readonly">
             <input type="text" name="addtimelineunit" autocomplete="off" id="MainTimelineUnit" class="form-control bdrnone pointers" readonly="readonly" style="width: 11%;position: absolute;margin-left: 50px;margin-top: -40px;">
	</span>
	<div class="timelineproduct_box" id="TimelineBox">
   	<div class="timelineproduct_inner">
   	<span onclick="addInput('MainTimelineUnit','TimelineBox','MainTimelineValue','CurrentProdrefid','Day','esplanperiod')">Day</span> <span onclick="addInput('MainTimelineUnit','TimelineBox','MainTimelineValue','CurrentProdrefid','Week','esplanperiod')">Week</span ><span onclick="addInput('MainTimelineUnit','TimelineBox','MainTimelineValue','CurrentProdrefid','Month','esplanperiod')">Month</span><span onclick="addInput('MainTimelineUnit','TimelineBox','MainTimelineValue','CurrentProdrefid','Year','esplanperiod')">Year</span>
   	</div>
	</div>
	<input type="hidden" id="CurrentProdrefid"/>
	<span class="bg_wht pad_box3 qtyBtn">
	<span class="fa fa-minus pointers" onclick="updateProductQty('SaleProdQty','minus','CurrentProdrefid')"></span>
	<input type="text" id="SaleProdQty" autocomplete="off" value="1" onchange="updateProdQty('SaleProdQty','CurrentProdrefid')" onkeypress="return isNumber(event)">
	<span class="fa fa-plus pointers" onclick="updateProductQty('SaleProdQty','plus','CurrentProdrefid')"></span>									
	</span>	 
	</div>
     <div class="row mb10">
       <div class="col-md-12 col-sm-12 col-xs-12">
        <div class="clearfix" id="PriceDropBox"></div>
        <input type="hidden" name="PriceGroupId" id="PriceGroupId"/>
        <div class="clearfix" id="PriceDropBoxSubAmount"></div>
       </div>
    </div>
    </div>
 </div>
 <div class="clearfix MultipleProduct"></div>
<!--  end -->
</div>

</div>
<div class="clearfix add_inner_box pad_box4 addcompany" id="convert_invoice" style="width: 700px; display:none">
<div class="rttop_titlep">
<h3 style="color: #42b0da;"><i class="fa fa-wpforms"></i>Convert to Invoice</h3>
<!-- <p style="margin-top: 20px;"><span style="color: red !important;">Note:-</span><span id="PayTypeRemarks"></span></p> -->
<a  class="clickeble estimatebox" data-related="estimate_invoice" onclick="backEstimate()" style="position: absolute;right: 0;top: 0;"><button class="bkbtn" onclick="openBackEditPage()">Back</button></a>
</div>
<div class="clearfix">
<!-- START -->
<div class="clearfix" id="ProductPriceDiv0">  
<!--     payment start -->
<div class="clearfix" id="add_payment">  
<div class="table-responsive">
<table class="ctable" id="paymentTable">
   <thead>
      <th> Name</th>
      <th>  Payment</th>
   </thead>
   <tbody>   
   
   </tbody>
</table>
</div>
 <a href="#" class="btnclose"><i class="fa fa-close"></i></a>
  <div class="hpayment" style="display:none">
  
<div class="rttop_titlep">
<h3 style="color: #42b0da;" class="fa fa-history">&nbsp;Payment history</h3>
<span style="margin-left: 40px;font-size: 14px;color: #42b0dabf;">Order amount : <i class="fa fa-inr"></i>&nbsp;<b id="TotalOrderAmountId"></b></span>    
<span style="margin-left: 40px;font-size: 14px;color: #da8142ba;">Due amount : <i class="fa fa-inr"></i>&nbsp;<b id="TotalDueAmountId"></b></span>
</div>
<div class="clearfix mb30">

<div class="table-responsive">
<table class="ctable">
<tr id="EstimatePaymentListId"></tr>
</table>
</div>
<!-- end -->

</div>
</div>
<a href="#" class="btnpay"><i class="fa fa-history"></i></a>

</div> 
<div id="AddPaymentModeuleId" class="AddPaymentModeule">
<div class="rttop_titlep">
<h3 style="color: #42b0da;" class="fa fa-inr">&nbsp;Register Payment</h3>
<a href="javascript:void(0)" onclick="showGstBox()" style="float: right;"><u>Calculate GST ?</u></a>  
</div>
<form onsubmit="return false;" enctype="multipart/form-data" id="UploadFormdata" class="uploadFormdata">
<input type="hidden" name="WhichPaymentFor" id="WhichPaymentFor">
<input type="hidden" name="CompanyPaymentFor" id="CompanyPaymentFor">
<input type="hidden" name="ClientPaymentFor" id="ClientPaymentFor">
<input type="hidden" name="ContactPaymentFor" id="ContactPaymentFor">
<div class="menuDv pad_box4 clearfix mb30">
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <select name="paymentmode" id="PaymentMode" class="form-control bdrd4" onchange="selectMode(this.value)">
<option value="">Payment Mode</option>
<option value="Online" selected="selected">Online</option>
<option value="Cash">Cash</option>
<option value="PO">Purchase Order</option>
</select>
  </div>
  <div id="paymentmodeErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="form-group">
  <div class="input-group">
  <input type="text" name="pymtdate" id="PaymentDate" autocomplete="off" placeholder="Date" value="<%=today %>" 
  class="form-control datepicker bdrd4 readonlyAllow" readonly="readonly">
  </div>
  <div id="pdateErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
 
 <div class="form-group row">
 <label class="col-sm-3" id="txid">Transaction Id</label>
  <div class="col-sm-9">
  <input type="text" name="transactionid" id="TransactionId" 
  autocomplete="off" placeholder="Transaction Id" class="form-control" autofocus>
  </div>
  <div id="transactionidErrorMSGdiv" class="errormsg"></div>
 </div>
 <div class="form-group row">
 <label class="col-sm-3">Service Name</label>
  <div class="col-sm-9">
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
 
 <div class="form-group row cash_online">
 <label class="col-sm-3">Professional Fees</label>
  <div class="col-sm-9">
  <input type="text" name="professional_Fee" id="Professional_Fee" onchange="calculateTotalPayment('Professional_Fee','Government_Fee','Other_Fee','GSTApplyId','TotalPaymentId','service_Charges')" autocomplete="off"
   placeholder="Professional Fee" class="form-control" onkeypress="return isNumberKey(event)">
  <span class="totalamt" id="Professional_Fee_GST">0%</span>
  </div>
  <div id="professional_FeeErrorMSGdiv" class="errormsg"></div>
 </div>
 <div class="form-group row cash_online">
 <label class="col-sm-3">Government Fees</label>
  <div class="col-sm-9">
  <input type="text" name="government_Fee" id="Government_Fee" onchange="calculateTotalPayment('Professional_Fee','Government_Fee','Other_Fee','GSTApplyId','TotalPaymentId','service_Charges')" autocomplete="off"
   placeholder="Government Fee" class="form-control padr4rem" onkeypress="return isNumberKey(event)">
  <span class="totalamt" id="Government_Fee_GST">0%</span>
  </div>
 </div>
  <div class="form-group row cash_online">
 <label class="col-sm-3">Service Charges</label>
  <div class="col-sm-9">
  <input type="text" name="service_Charges" id="service_Charges" onchange="calculateTotalPayment('Professional_Fee','Government_Fee','Other_Fee','GSTApplyId','TotalPaymentId','service_Charges')" autocomplete="off"
   placeholder="Service charges" class="form-control padr4rem" onkeypress="return isNumberKey(event)">
  <span class="totalamt" id="service_Charges_GST">0%</span>
  </div>
 </div>
 <div class="form-group row cash_online">
 <label class="col-sm-3">Other Fees</label>
  <div class="col-sm-9">
  <input type="text" name="other_Fee" id="Other_Fee" onchange="calculateTotalPayment('Professional_Fee','Government_Fee','Other_Fee','GSTApplyId','TotalPaymentId','service_Charges');showRemark(this.value,'Other_Fee_remark_Div');" autocomplete="off"
   placeholder="Other Fee" class="form-control padr4rem" onkeypress="return isNumberKey(event)">
   <span class="totalamt" id="Other_Fee_GST">0%</span>
  </div>
 </div>
 <div class="form-group row toggle_box" id="Other_Fee_remark_Div">
 <label class="col-sm-3"></label>
  <div class="col-sm-9">
  <input type="text" name="other_Fee_remark" id="Other_Fee_remark" autocomplete="off" placeholder="Other Fee Remarks" 
  class="form-control padr4rem">
  </div>
 </div>

<!-- <div class="blog-list-title text-center">OR</div> -->
<div class="form-group row">
 <label class="col-sm-3" id="paymentUpload">Upload Receipt</label>
  <div class="col-sm-9">
    <input type="file" name="choosefile" id="ChooseFile" onchange="validateFileSize('ChooseFile')" placeholder="Choose File" class="form-control">
     <small id="paymentUploadDesc">Select Transaction Receipt To Upload <span class="txt_red">(Max Size 48MB)</span></small>
    </div>   
    <div id="cfileErrorMSGdiv" class="errormsg"></div>
   </div>
 <div class="form-group row cash_online">
 <label class="col-sm-3">Total</label>
  <div class="col-sm-9" style="padding-left:0;padding-right:0">
  <div class="col-sm-4">
  <input type="text" readonly="readonly" value="0" class="form-control" name="transactionamount" id="TotalPaymentId"/>
  </div>
  <div class="col-sm-4">
  <input type="hidden" id="GSTApplied" name="gstApplied" value="1">
  <input type="checkbox" checked="checked" id="GSTApplyId" name="gstApply" style="width:20px;height:20px;margin:10px 0">
 <span style="vertical-align: super;margin-left: 5px;">GST Apply</span>
  </div>
  <div class="col-sm-4 pt-9">
  <a href="javascript:void(0)" data-toggle="collapse" data-target="#collapseExample" aria-expanded="false" aria-controls="collapseExample">
   More details <i class="fa fa-chevron-down" aria-hidden="true"></i>
  </a>
  </div>
  </div>
 </div>
 <div class="collapse" id="collapseExample">
    <div class="form-group row">
        <label for="fromYear" class="col-sm-3">Financial Year </label>
        <div class="col-sm-9">
            <div class="col-sm-6 p-0">
                <input type="text" id="fromYear" class="form-control year-pattern" name="fromYear" placeholder="From year"
                    pattern="(20)\d{2}" 
                    title="Enter a valid year from 2000" 
                    maxlength="4" required>   
            </div>
            <div class="col-sm-6">
                <input type="text" id="toYear" class="form-control year-pattern" name="toYear" placeholder="To year"
                    pattern="(20)\d{2}" 
                    title="Enter a valid year from 2000" 
                    maxlength="4" required>   
            </div>     
        </div>   
    </div>
    <div class="form-group row">
        <label for="portalNumber" class="col-sm-3">Portal No.</label>
        <div class="col-sm-9">
            <input type="text" name="portalNumber" class="form-control" id="portalNumber" autocomplete="off" placeholder="Portal Number" required>
        </div>
    </div>
    <div class="form-group row">
        <label for="piboCategory" class="col-sm-3">PIBO category</label>
        <div class="col-sm-9">
            <select name="piboCategory" class="form-control" id="piboCategory">
                <option value="Producer">Producer</option>
                <option value="Brand Owner">Brand Owner</option>
                <option value="Importer">Importer</option>
            </select>
        </div>
    </div>
    <div class="form-group row">
        <label for="creditType" class="col-sm-3">Credit Type</label>
        <div class="col-sm-9">
            <select name="creditType" class="form-control" id="creditType">
                <option value="Recycling">Recycling</option>
                <option value="End Of Life">End Of Life</option> <!-- Corrected option label -->
            </select>
        </div>
    </div>
    <div class="form-group row">
        <label for="productCategory" class="col-sm-3">Product recycling category </label>
        <div class="col-sm-9">
            <input type="text" class="form-control" name="productCategory" id="productCategory" autocomplete="off" placeholder="Product recycling category" required>
        </div>
    </div>
    <div class="form-group row">
        <label for="quantity" class="col-sm-3">Quantity (Metric Ton) </label>
        <div class="col-sm-9">
            <input type="number" class="form-control" name="quantity" id="quantity" autocomplete="off" placeholder="Quantity (Metric Ton)" required>
        </div>
    </div>
    <div class="form-group row">
        <label for="comment" class="col-sm-3">Comment </label>
        <div class="col-sm-9">
            <textarea name="comment" rows="4" id="comment" placeholder="Comment here!" class="form-control"></textarea>     
        </div>   
    </div>
</div>
  <div class="form-group row">
 <label class="col-sm-3">Remarks </label>
  <div class="col-sm-9">
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
<button type="button" class="btn-warning bdrd4 p5-20" id="btnSubmit">Submit</button>
</div>	
</div>			
</div>
</form>
</div>
</div>
 </div>
</div>
</div>
<div class="clearfix add_inner_box pad_box4 addcompany" id="task_notes" style="display: none;width: 700px; ">
<div class="close_icon close_box" style="right: 700px;z-index:99"><i class="fa fa-times"></i></div>
<div class="clearfix bdr_bt pad-lft10 pad-rt10">
<div class="rttop_title">
<h3 id="taskNotesProduct">Product name</h3>
<a class="clickeble estimatebox" data-related="estimate_invoice" onclick="backEstimate()" style="position: absolute;right: 0;top: 0;"><button class="bkbtn">Back</button></a>
</div> 
<div class="clearfix nav-tabs-border"> 
<ul class="nav-tabs">
<li class="active" id="TeamNotesLi" onclick="showTeamNotes('TeamNotesLi','PersonalNotesLi','ReplyNotesBoxId','InternalNotesBoxId')"><a>Team</a></li> 
<li id="PersonalNotesLi" onclick="showPersonalNotes('TeamNotesLi','PersonalNotesLi','ReplyNotesBoxId','InternalNotesBoxId')"><a >Personal</a></li>
</ul>
<form onsubmit="return false" class="PublicChatReply" id="PublicSalesTaskFormId">
	<select class="form-control mb1" id="notesestimate" name="usnotesestimateerInChat">
       <option value="">Select service</option>
    </select>
	<div class="clearfix box_shadow1 relative_box reply_box" id="ReplyNotesBoxId">
	
	<textarea class="ChatTextareaBox" rows="2" id="ChatTextareaBoxReply" name="ChatTextareaBoxReply" placeholder="Public reply here..... !!"></textarea>
	
	<div class="clearfix">
        <select class="form-control" id="userInChat" name="userInChat" multiple="multiple">        
        </select>
    </div>
    
	</div>
	<div class="clearfix box_shadow1 relative_box reply_box toggle_box" id="InternalNotesBoxId">
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


<div class="clearfix add_inner_box pad_box4 addcompany" id="UploadDocuments" style="width: 700px;">
<!-- <div class="close_icon close_box"><i class="fa fa-times"></i></div> -->
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-file-o"></i>Document Vault</h3>
<a class="clickeble estimatebox" data-related="estimate_invoice" onclick="backEstimate()" style="position: absolute;right: 0;top: 0;"><button class="bkbtn" onclick="openBackEditPage()">Back</button></a>
<p>A Document Vault data room is a sophisticated tool for managing your documents online, offering the highest levels of security.
It can be used for due diligence in a wide range of applications, from selling or buying a company, to selling or buying a property,
to sharing information about customers and suppliers.</p>
</div>
<div class="clearfix mbt20">
<select class="form-control" id="estimateDocList" onchange="updateDocuments(this.value)">
</select>
</div>
<!-- <h3 style="font-size: 16px;color: #42b0da;"></h3> -->
<div class="tab two">
  <button class="tablinks active box-width51" onclick="openDocument(event, 'ClientUploadDoc')">&nbsp;Client's Uploads</button>
  <button class="tablinks box-width49" onclick="openDocument(event, 'HistoryUploadDoc')">&nbsp;History</button>
</div>
<div class="clearfix pad_box3 pad05 tabcontent" style="display:block;" id="ClientUploadDoc">
<div class="table-responsive">
<form onsubmit="return false;" class="upload-box">
<table class="ctable" style="border:none">
<tbody>
 <tr id="DocumentListAppendId"></tr>
 </tbody>
 </table>
</form>
</div>
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
<div class="clearfix add_inner_box pad_box4 addcompany" id="GenerateEstimate" style="width: 700px;">
<!-- <div class="close_icon close_box" style="right: 700px;"><i class="fas fa-times"></i></div>  -->
<div class="rttop_titlep">
<h3 style="color: #42b0da;"><i class="fa fa-wpforms"></i>Generate Estimate</h3>
<!-- <p style="margin-top: 20px;"><span style="color: red !important;">Note:-</span><span id="PayTypeRemarks"></span></p> -->
<a  class="clickeble estimatebox" data-related="estimate_invoice" onclick="backEstimate()" style="position: absolute;right: 0;top: 0;"><button class="bkbtn" onclick="openBackEditPage()">Back</button></a>
</div>
<a href="javascript:void(0)" onclick="showGstBox()"><u>Calculate GST ?</u></a>
<div class="clearfix">
<!-- START -->
<div class="clearfix" id="ProductPriceDiv1">  
<!--     payment start -->
  <div class="clearfix" id="add_payment1">  
 <a href="#" class="btnclose"><i class="fa fa-close"></i></a>
  <div class="hpayment" style="display:none">
  
<div class="rttop_titlep">
<h3 style="color: #42b0da;" class="fa fa-history">&nbsp;Payment history</h3>
</div>
<div class="clearfix mb30">

<!-- start -->
<div class="table-responsive">
<table class="ctable">
<tr id="GeneratedEstimate"></tr>
</table>
</div>
<!-- end -->

</div>
</div>
<a href="#" class="btnpay topp"><i class="fa fa-history"></i></a>
<div id="AddPaymentModeuleId1" class="AddPaymentModeule">
<form onsubmit="return false;" id="GenerateReceiptForm" class="uploadFormdata">
<div class="menuDv pad_box4 clearfix mb30"> 
 <div class="form-group row">
 <label class="col-sm-3">Product</label>
  <div class="col-sm-9"> 
  <select class="form-control select2" name="selectProduct" id="selectProduct" multiple="multiple">	  
  </select>
  </div>
 </div>
 <div class="form-group row">
 <label class="col-sm-3">Professional Fees</label>
  <div class="col-sm-9">
  <input type="text" name="professional_Fee1" id="Professional_Fee1" onchange="calculateTotalPayment('Professional_Fee1','Government_Fee1','Other_Fee1','GSTApplyId1','TotalPaymentId1','service_Charges1')" autocomplete="off"
   placeholder="Professional Fee" class="form-control" onkeypress="return isNumberKey(event)">
  <span class="totalamt" id="Professional_Fee_GST1">0%</span>
  </div>
 </div>
 <div class="form-group row">
 <label class="col-sm-3">Government Fees</label>
  <div class="col-sm-9">
  <input type="text" name="government_Fee1" id="Government_Fee1" onchange="calculateTotalPayment('Professional_Fee1','Government_Fee1','Other_Fee1','GSTApplyId1','TotalPaymentId1','service_Charges1')" autocomplete="off"
   placeholder="Government Fee" class="form-control padr4rem" onkeypress="return isNumberKey(event)">
  <span class="totalamt" id="Government_Fee_GST1">0%</span>
  </div>
 </div>
  <div class="form-group row">
 <label class="col-sm-3">Service Charges</label>
  <div class="col-sm-9">
  <input type="text" name="service_Charges1" id="service_Charges1" onchange="calculateTotalPayment('Professional_Fee1','Government_Fee1','Other_Fee1','GSTApplyId1','TotalPaymentId1','service_Charges1')" autocomplete="off"
   placeholder="Service Charges" class="form-control padr4rem" onkeypress="return isNumberKey(event)">
  <span class="totalamt" id="service_Charges_GST1">0%</span>
  </div>
 </div>
 <div class="form-group row">
 <label class="col-sm-3">Other Fees</label>
  <div class="col-sm-9">
  <input type="text" name="other_Fee1" id="Other_Fee1" onchange="calculateTotalPayment('Professional_Fee1','Government_Fee1','Other_Fee1','GSTApplyId1','TotalPaymentId1','service_Charges1');showRemark(this.value,'Other_Fee_remark_Div1');" autocomplete="off"
   placeholder="Other Fee" class="form-control padr4rem" onkeypress="return isNumberKey(event)">
   <span class="totalamt" id="Other_Fee_GST1">0%</span>
  </div>
 </div>
 <div class="form-group row toggle_box" id="Other_Fee_remark_Div1">
 <label class="col-sm-3"></label>
  <div class="col-sm-9">
  <input type="text" name="other_Fee_remark1" id="Other_Fee_remark1" autocomplete="off" placeholder="Other Fee Remarks" 
  class="form-control padr4rem">
  </div>
 </div>
 <div class="form-group row">
 <label class="col-sm-3">Total</label>
  <div class="col-sm-9" style="padding-left:0;padding-right:0">
  <div class="col-sm-5">
  <input type="text" readonly="readonly" value="0" class="form-control" name="transactionamount1" id="TotalPaymentId1"/>
  </div>
  <div class="col-sm-4">
  <input type="hidden" id="GSTApplied1" name="gstApplied1" value="1">
  <input type="checkbox" checked="checked" id="GSTApplyId1" name="gstApply1" style="width:20px;height:20px;margin:10px 0">
 <span style="vertical-align: super;margin-left: 5px;">GST Apply</span>
  </div>
  </div>
 </div> 
 <div class="form-group row">
 <label class="col-sm-3">Notes</label>
  <div class="col-sm-9">
  <textarea name="estimate_notes" rows="3" id="estimateNotes" autocomplete="off"
   placeholder="Notes here !!" class="form-control padr4rem"></textarea>
  </div>
 </div>
<div class="row "> 
<div class="col-md-12 col-sm-12 col-xs-12 text-right">
<button type="button" class="btn-warning bdrd4 p5-20" id="btnSubmit1" onclick="return validateGeneratePayment()">Submit</button>
</div>	
</div>			
</div>
</form>
</div>

</div>
<!--   payment end   --> 
 </div>
 
<!--  end -->
</div>

</div>
</div>
<div class="modal fade" id="warningPayment" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span>
        <span class="text-danger">Payment awating for approval..</span></h5>
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
<div class="modal fade" id="ExportData" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fas fa-file-export text-primary" style="margin-right: 10px;"> </span><span class="text-primary">Export</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <form action="return false" id="exportEstimateCol">
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
            	<option value="esregdate" selected>Date</option>
            	<option value="essaleno" selected>Estimate No.</option>
            	<option value="escontactrefid" selected>Contact Name</option>
            	<option value="escompany" selected>Company</option>
            	<option value="esstatus" selected>Status</option>
            	<option value="esrefid,esdiscount" selected>Amount</option>
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
<div class="modal fade" id="SendEmailWarning" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-envelope text-primary" style="margin-right: 10px;"> </span><span class="text-primary" id="sendEmailInvoiceHtml">Send Estimate Invoice</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <form action="return false" id="sendEmailInvoice">
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
        <button type="button" class="btn btn-primary" onclick="return sendEstimateInvoice()">Submit</button>
      </div></form>
    </div>
  </div>
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
<div class="modal fade" id="payTypeWarning" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span><span class="text-danger">Have you visited included all estimate products !! ?..</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
       <div class="modal-body warBody">
        <p style="font-size: 14px;"><span style="color: red;font-weight: 600;">Warning :- </span><span>Please Re-Confirm given below each project price type !! Based on this hierarchy Client Have to Pay to start their projects. !! 
        <span class="clearfix" id="IncludedProjectsId"></span>
        <b class="text-danger flort ">After closing Payment  section, It will not change !!</b></span></p>
      </div>
      <div class="modal-footer">
      	<button type="button" class="btn btn-default text-left" style="float: left;" id="minimumTotalPay">Minimum Rs. 4720.00</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Not Now</button>
        <button type="button" class="btn btn-primary" onclick="confirmCheck()">Yes I Checked</button>
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
<div class="modal fade" id="addNewPriceType" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="addNewPriceType">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fas fa-inr text-primary" style="margin-right: 10px;"> </span>
        <span class="text-primary">And New Price </span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <form action="return false" id="gstCalculater">
       <div class="modal-body">       
         <div class="form-group">
            <label for="recipient-name" class="col-form-label">Price Type :</label>
            <select class="form-control" name="priceType" id="priceType" required="required">
            </select>
          </div>          
        <div class="form-group">
            <label for="recipient-name" class="col-form-label">Price :</label>
            <input type="text" autocomplete="off" class="form-control" placeholder="price.." name="typePrice" id="typePrice" onkeypress="return isNumberKey(event)" required="required">
          </div>
         <div class="form-group">
            <label for="recipient-name" class="col-form-label">HSN</label>
             <input type="text" autocomplete="off" class="form-control" onkeypress="searchHSNCode('typePriceHsn')" placeholder="hsn" name="typePriceHsn" id="typePriceHsn">
          </div>
          <input type="hidden" id="AddNewPriceEstKey" value=""/>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary" onclick="return addNewPriceType('NA')">Submit</button>
      </div></form>
    </div>
  </div>
</div>
<div class="modal fade" id="cancelSaleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="addNewPriceType">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fas fa-question-circle text-primary" style="margin-right: 10px;"> </span>
        <span class="text-primary" id="salesReasonHead">Sale Cancel Reason </span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <form action="return false">
       <div class="modal-body">           
        <div class="form-group">
            <label for="recipient-name" class="col-form-label mb10">Description :</label>
            <textarea class="form-control" rows="8" name="description" id="cancelDescription" required="required"></textarea>
          </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary" onclick="return cancelSale()">Submit</button>
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
<input type="hidden" id="ManageEstimatePayTypeId" value="Yes"> 
 <input type="hidden" id="ManageEstimateUpdateContactId"> 
  <input type="hidden" id="ManageSalesCompAddress"> 
  <input type="hidden" id="NewProductIdUid" value="0"/>
  <input type="hidden" id="SalesProductIdQty" value="0"/>
  <input type="hidden" id="View_More_History" value="1"/>
  <input type="hidden" id="paymentModePo" value="0">
  <input type="hidden" id="ConvertEstimateStatus">
  
 <div class="noDisplay"><a href="" id="DownloadExportedLink" download><button id="DownloadExported">Download</button></a></div> 
 <div class="noDisplay"><a href="<%=docBasePath %>invoices.pdf" download><button id="DownloadExportedInvoices">Download</button></a></div>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>

</div>	
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/jspdf.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/html2pdf.bundle.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/converttopdf.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/ckeditor/ckeditor.js"></script>
<%@ include file="../staticresources/includes/estimate-script.jsp" %>
</body>
</html>