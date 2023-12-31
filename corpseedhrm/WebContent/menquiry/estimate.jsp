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
String azurePath=properties.getProperty("azure_path");

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
// System.out.println("convertedSalesDues=="+convertedSalesDues);

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
  <!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
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

<div class="clearfix add_inner_box pad_box4 addcompany" id="estimate_invoice" style="width: 700px;">
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
<!-- <h3 style="font-size: 13px;border-bottom: 1px solid #e1e1e1;padding-bottom: 11px;"><span class="pointers" onclick="alert('Pending......add estimate notification(Sent Estimate Invoice use color: #5757ea;)')"><i class="far fa-envelope"></i>&nbsp;&nbsp;Send email</span> -->
<h3 style="font-size: 13px;border-bottom: 1px solid #e1e1e1;padding-bottom: 11px;">
<span class="pointers" id="EmailSendedId" onclick="openSendEmailBox()"><i class="far fa-envelope"></i>&nbsp;&nbsp;Send email</span>
<!-- <span style="margin-left: 20px;" class="pointers" id="printCMD"><i class="fa fa-download"></i>&nbsp;&nbsp;PDF</span> onclick="sendEstimateInvoice()"-->
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

<div class="clearfix add_inner_box pad_box4 addcompany" id="edit_estimate" style="width: 700px;">
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
<div class="clearfix add_inner_box pad_box4 addcompany" id="convert_invoice" style="width: 700px;">
<!-- <div class="close_icon close_box" style="right: 700px;"><i class="fas fa-times"></i></div>  -->
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

<!-- start -->
<!-- <div class="clearfix" id="EstimatePaymentListId"></div> -->
<div class="table-responsive">
<table class="ctable">
<tr id="EstimatePaymentListId"></tr>
</table>
</div>
<!-- end -->

</div>
</div>
<a href="#" class="btnpay"><i class="fa fa-history"></i></a>
<!-- <div class="rttop_titlep">
<h3 style="color: #42b0da;" class="fa fa-history">&nbsp;Payment history</h3>
<span style="margin-left: 40px;font-size: 14px;color: #42b0dabf;">Order amount : <i class="fa fa-inr"></i>&nbsp;<span id="TotalOrderAmountId"></span></span>    
<span style="margin-left: 40px;font-size: 14px;color: #da8142ba;">Due amount : <i class="fa fa-inr"></i>&nbsp;<span id="TotalDueAmountId"></span></span>
</div> -->
<!-- <div class="menuDv pad_box4 clearfix mb30">


<div class="clearfix" id="EstimatePaymentListId"></div>


</div> -->
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
<!--   payment end   --> 
 </div>
 
<!--  end -->
</div>

</div>

<div class="clearfix add_inner_box pad_box4 addcompany" id="task_notes" style="display: none;width: 700px;">
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
 <div class="noDisplay"><a href="<%=azurePath %>invoices.pdf" download><button id="DownloadExportedInvoices">Download</button></a></div>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>

</div>	
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/jspdf.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/html2pdf.bundle.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/converttopdf.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/ckeditor/ckeditor.js"></script>
<script type="text/javascript">   
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
$(function() {
	$("#EstimateNo").autocomplete({
		source : function(request, response) {			
			if(document.getElementById('EstimateNo').value.trim().length>=1)
			$.ajax({
				url : "get-client-details.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					"field" : "estimateNumber"
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
            	doAction(ui.item.value,'estimateNoDoAction');
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
					"field" : "estimateclientname"
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
            	doAction(ui.item.value,'ClientNameDoAction');
            	location.reload();
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});


function isValidAmount(){
	var dueAmt=$("#TotalDueAmountId").html();
	var tranAmt=$("#TransactionAmount").val();
	if(Number(tranAmt)>Number(dueAmt)){
		$("#TransactionAmount").val('');
		document.getElementById('errorMsg').innerHTML ="Maximum amount should be  "+dueAmt;
		$('.alert-show').show().delay(4000).fadeOut();
	}
	
}

function hideTaskDetails(milestone_pay_box){
	if ($("."+milestone_pay_box).is(':visible')){
		$("."+milestone_pay_box).slideUp();
	}
}
function showTaskDetails(milestone_pay_box){
	$("."+milestone_pay_box).slideDown();
}

function selectMode(value){
// 	cash_online txid paymentUpload paymentUploadDesc
// 	(Select Transaction Receipt To Upload <span class="txt_red">(Max Size 48MB)</span>)
	
	if(value=="Cash"){
		$(".cash_online").show();
		$("#TransactionId").attr("placeholder","Transaction id");
		$("#txid").html("Transaction Id");
		$("#paymentUpload").html("Upload Receipt");
		$("#paymentUploadDesc").html("Select Transaction Receipt To Upload <span class='txt_red'>(Max Size 48MB)</span>");
		$("#TransactionId").val("NA");
		$("#TransactionId").prop("readonly",true);
	}else if(value=="Online"){
		$(".cash_online").show();
		$("#TransactionId").attr("placeholder","Transaction id");
		$("#txid").html("Transaction Id");
		$("#paymentUpload").html("Upload Receipt");
		$("#paymentUploadDesc").html("Select Transaction Receipt To Upload <span class='txt_red'>(Max Size 48MB)</span>");
		$("#TransactionId").val("");
		$("#TransactionId").prop("readonly",false);		
	}else if(value=="PO"){
		$("#TransactionId").val("");
		$("#TransactionId").attr("placeholder","Purchase Order number");
		$("#TransactionId").prop("readonly",false);
		$(".cash_online").hide();
		$("#txid").html("PO Number");
		$("#paymentUpload").html("Upload PO Receipt");
		$("#paymentUploadDesc").html("Select PO Receipt To Upload <span class='txt_red'>(Max Size 48MB)</span>");	
		$("#paymentModePo").val(1);
		changePayTypePo();
	}
	
	let po=$("#paymentModePo").val();
	if(po==1&&value!="PO"){
		console.log("going to fetch Pay type...")
		$("#paymentModePo").val(0);
		let estimateno=$("#ConvertInvoiceSaleNo").val();
		getPayType("NA",estimateno);
	}
	
	
}

function changePayTypePo(){
	var estimateno=$("#ConvertInvoiceSaleNo").val();
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetPayTypePo111",
		dataType : "HTML",
		data : {				
			estimateno : estimateno
		},
		success : function(response){
			$("#paymentTable  tbody").empty();	
		    $("#paymentTable  tbody").append(response);		
		},
		complete : function(data){
			hideLoader();
		}
	});
	console.log("Going to change pay type and disable : "+estimateno);
}

function updatePricePercentage(refKey,value){
	showLoader();
	if(Number(value)>0){
	$.ajax({
			type : "POST",
			url : "UpdatePricePercentage111",
			dataType : "HTML",
			data : {				
				refKey : refKey,	
				value : value
			},
			success : function(data){				
				if(data=="pass"){
					document.getElementById('errorMsg1').innerHTML ='Updated';
					$('.alert-show1').show().delay(400).fadeOut();
				}else{
					document.getElementById('errorMsg').innerHTML ='Something went wrong ! Try-again later !!';
					$('.alert-show').show().delay(3000).fadeOut();
				}
			},
			complete : function(data){
				hideLoader();
			}
		});
	}else{
		document.getElementById('errorMsg').innerHTML ='Minimum 1% price percentage required !!';
		$('.alert-show').show().delay(4000).fadeOut();
		hideLoader();
	}
}
function updatePayType(payType,salesKey){
// 	var salesKey=$("#ConvertEstimateRefKey").val();
showLoader();
	 $.ajax({
			type : "POST",
			url : "UpdatePayType111",
			dataType : "HTML",
			data : {				
				salesKey : salesKey,	
				payType : payType
			},
			success : function(data){				
				if(data=="fail"){
					document.getElementById('errorMsg').innerHTML ='Either Estimate converted or something went wrong !!';
					$('.alert-show').show().delay(4000).fadeOut();
				}
			},
			complete : function(data){
				hideLoader();
			}
		});
}
function fileSize(file){
	const fi=document.getElementById('ChooseFile');
	if (fi.files.length > 0) {
		const fsize = fi.files.item(0).size; 
        const file = Math.round((fsize / 1024)); 
        // The size of the file. 
        if (file >= 1024) {  
            document.getElementById('errorMsg').innerHTML ='File too Big, please select a file less than 1mb';
            document.getElementById("ChooseFile").value="";
 		    $('.alert-show').show().delay(4000).fadeOut();
        }		
	}	
}
function validatePayType(){
	var estimateno=$("#WhichPaymentFor").val();	
	$(".removeLiId").remove();
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetAllSalesProduct111",
		dataType : "HTML",
		data : {				
			estimateno : estimateno
		},
		success : function(response){		
		if(Object.keys(response).length!=0){	
		response = JSON.parse(response);			
		 var len = response.length;			 
		 if(Number(len)>0){			
			 var style="style='margin-top:10px;color: #337ab7;'";
		var minimumPay=0;
		for(var i=0;i<len;i++){		   
			var name = response[i]['name'];	
			var notes = response[i]['notes'];
			var minPay= response[i]['minPay'];
			minimumPay=Number(minimumPay)+Number(minPay);
			$(''+
					'<li class="removeLiId" '+style+'>'+name+'<small>'+notes+'</small></li>'
					).insertBefore("#IncludedProjectsId");
			style="style='color: #337ab7;'";
			
		}
		$("#minimumTotalPay").html("Minimum Pay : "+Math.ceil(Number(minimumPay)));
		$("#payTypeWarning").modal("show");
		 }}},
			complete : function(data){
				hideLoader();
			}
	});
		
}
function validateGeneratePayment(){
	var products=$("#selectProduct").val();
	var profFee=$("#Professional_Fee1").val();
	var govFee=$("#Government_Fee1").val();
	var serviceCharge=$("#service_Charges1").val();
	var otherFee=$("#Other_Fee1").val();
	var otherRemark=$("#Other_Fee_remark1").val();
	var gstApply=$("#GSTApplied1").val();
	var estimateNotes=$("#estimateNotes").val();
	
	var totalAmount=Number(profFee)+Number(govFee)+Number(otherFee);
	
	if(products==null||products==""){
		document.getElementById('errorMsg').innerHTML ="Please select product !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(estimateNotes==null||estimateNotes==""){
		document.getElementById('errorMsg').innerHTML ="Please enter invoice notes !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(totalAmount<=0){
		document.getElementById('errorMsg').innerHTML ="Please enter minimum one amount !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(Number(otherFee)>0&&(otherRemark==null||otherRemark=="")){
		document.getElementById('errorMsg').innerHTML ="Enter other fee remarks !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(profFee==null||profFee=="")profFee="0";
	if(govFee==null||govFee=="")govFee="0";
	if(serviceCharge==null||serviceCharge=="")serviceCharge="0";
	if(otherFee==null||profFee=="")otherFee="0";
	if(otherRemark==null||otherRemark=="")otherRemark="NA";
	var pffCgst=$("#ProfessionalCgst").val();
	var pffSgst=$("#ProfessionalSgst").val();
	var pffIgst=$("#ProfessionalIgst").val();
	var govtCgst=$("#GovernmentCgst").val();
	var govtSgst=$("#GovernmentSgst").val();
	var govtIgst=$("#GovernmentIgst").val();
	var serviceCgst=$("#ServiceChargeCgst").val();
	var serviceSgst=$("#ServiceChargeSgst").val();
	var serviceIgst=$("#ServiceChargeIgst").val();
	var OtherCgst=$("#OtherCgst").val();
	var OtherSgst=$("#OtherSgst").val();
	var OtherIgst=$("#OtherIgst").val();
	var pymtamount=$("#TotalPaymentId1").val();
	var estKey=$("#ConvertEstimateRefKey").val();
	var product=products+"";
	showLoader();
	$.ajax({
		type : "POST",
		url : "GenerateEstimate111",
		dataType : "HTML",
		data : {				
			product:product,
			profFee:profFee,
			serviceCharge:serviceCharge,
			govFee:govFee,
			otherFee:otherFee,
			otherRemark:otherRemark,
			gstApply:gstApply,
			pffCgst:pffCgst,
			pffSgst:pffSgst,
			pffIgst:pffIgst,
			govtCgst:govtCgst,
			govtSgst:govtSgst,
			govtIgst:govtIgst,
			serviceCgst:serviceCgst,
			serviceSgst:serviceSgst,
			serviceIgst:serviceIgst,
			OtherCgst:OtherCgst,
			OtherSgst:OtherSgst,
			OtherIgst:OtherIgst,
			pymtamount:pymtamount,
			estKey:estKey,
			estimateNotes : estimateNotes
		},
		success : function(data){
			if(data=="pass"){
	        	   $("#GenerateReceiptForm").trigger('reset');
	        	    
	               document.getElementById('errorMsg1').innerHTML ="Successfully estimate generated.";
	               
	               $("#Professional_Fee_GST1").html($("#ProfessionalFeeTax").val()+"%");
	               $("#Government_Fee_GST1").html($("#GovernmentFeeTax").val()+"%");
	               $("#Other_Fee_GST1").html($("#OtherFeeTax").val()+"%");
	               $("#GSTApplied1").val("1");	               
	               $('.alert-show1').show().delay(3000).fadeOut();
	               
// 	       		fillAllSalesPayment(salesno);	       		   
     	   }else{
     		   document.getElementById('errorMsg').innerHTML ="Something Went Wrong, Try-Again later.";
	       		   $('.alert-show').show().delay(4000).fadeOut();
     	   }
		},
		complete : function(msg) {
            hideLoader();
        }
	});
}
function validatePayment(event){
	var salesno=document.getElementById("WhichPaymentFor").value.trim();
	var company=document.getElementById("CompanyPaymentFor").value.trim();
	var clientrefid=document.getElementById("ClientPaymentFor").value.trim();
	var contactrefid=document.getElementById("ContactPaymentFor").value.trim();
	var pymtmode=document.getElementById("PaymentMode").value.trim();
	var pymtdate=document.getElementById("PaymentDate").value.trim();
	var pymttransid=document.getElementById("TransactionId").value.trim();
	let serviceQty=$("#serviceQty").val();
	var remarks=$("#remarks").val().trim();
	
// 	Other_Fee_remark_Div,TotalPaymentId,GSTApplyId
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
	}else if(pymtmode=="PO"){
		if(pymttransid==""){
			document.getElementById('errorMsg').innerHTML ="Enter PO Number !!.";
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
	if(Number(txnAmount)<=0&&pymtmode!="PO"){
		document.getElementById('errorMsg').innerHTML ="Enter Service Amount (Professional or government or service or other fee) !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}	
	if(Number(other_Fee)>0&&(other_Fee_remark==null||other_Fee_remark=="")){
		document.getElementById('errorMsg').innerHTML ="Enter Other Fee Remarks !!.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(pymtmode=="PO"&&($("#ChooseFile").val()==null||$("#ChooseFile").val()=="")){
		document.getElementById('errorMsg').innerHTML ="Upload Purchase Order Receipt !!.";
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
    var orderAmount=$("#TotalOrderAmountId").html();
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
		           url: "RegisterPayment111",
		           data: data,
		           processData: false,
		           contentType: false,
		           cache: false,
		           timeout: 600000,
		           success: function (data) {
		        	   $("#btnSubmit").prop("disabled", false);
		        	   
		        	   if(data=="pass"){
			        	   $("#UploadFormdata").trigger('reset'); 
			               document.getElementById('errorMsg1').innerHTML ="Successfully payment added.";
			               
			               $("#Professional_Fee_GST").html($("#ProfessionalFeeTax").val()+"%");
			               $("#Government_Fee_GST").html($("#GovernmentFeeTax").val()+"%");
			               $("#Other_Fee_GST").html($("#OtherFeeTax").val()+"%");
			               $("#GSTApplied").val("1");
			               
			               $('#WhichPaymentFor').val(salesno);	 
			               $('#CompanyPaymentFor').val(company);	 
			               $('#ClientPaymentFor').val(clientrefid);	 
			               $('#ContactPaymentFor').val(contactrefid);	 
			       		   $('.alert-show1').show().delay(3000).fadeOut();
			               $(".EstimatePaymentInnerId").remove();	
			       		fillAllSalesPayment(salesno);	       		   
		        	   }else{
		        		   document.getElementById('errorMsg').innerHTML ="Something Went Wrong, Try-Again later.";
			       		   $('.alert-show').show().delay(4000).fadeOut();
		        	   }
		
		           },
		           error: function (e) {
		               $("#btnSubmit").prop("disabled", false);
		           }
		       });
		}else if(response=="poExist"){
			document.getElementById('errorMsg').innerHTML ="You already uploaded purchase order.";
    		$('.alert-show').show().delay(4000).fadeOut();
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

function addMainNewProduct(esrefid,prodtype,prodrefid,prodname,p,central,state,global,jurisdiction){		
	var prodnam=prodname+"#"+prodrefid;
	var a=document.getElementById("NewProductIdUid").value.trim();
	var i=Number(a)+1;	
	var crossbtn="CloseBtn"+i;
	var producttype="Product_Type"+i;
	var productprice="productPrice"+i;
	var productname="Product_Name"+i;
	var multiprod="MultiProd"+i;
	var onetimeterm="onetime"+i;
	var rentimeterm="renewal"+i;
	var service="timetype"+i;
	var period="ProductPeriod"+i;
	var periodtime="ProductPeriodTime"+i;
	var gstprice="GstPrice"+i;
	var totalprice="TotalPrice"+i;
	var newproductid="NewProductBtn"+i;
	var removeicon="RemoveIcon"+i;
	var PriceDropBox="PriceDropBox"+i;
	var PriceGroupId="PriceGroupId"+i;
	var ProductPriceDiv="ProductPriceDiv"+i;
	var TotalPriceProduct="TotalPriceProduct"+i;
	var PriceProduct="PriceProduct"+i;
	var ProductPlan="ProductPlan"+i;
	var TimelineBox="TimelineBox"+i;
	var SaleProdQty="SaleProdQty"+i;
	var ProdGroupRefid="ProdGroupRefid"+i;
	var CurrentProdrefid="CurrentProdrefid"+i;
	var PriceDropBoxSubAmount="PriceDropBoxSubAmount"+i;
	var jurisdictionId="jurisdiction"+i;
	
	document.getElementById("NewProductIdUid").value=i;
	
	$(''+
	'<div class="row EstimateList1" id="'+multiprod+'">'+							
	'<div class="col-md-12 col-sm-12 col-xs-12">'+
       '<div class="form-group">'+
       '<div class="clearfix text-right mb10" style="margin-top: 5px;" id="'+removeicon+'">'+
		'<button class="addbtn pointers" type="button" onclick="removeCurrentProduct(\''+multiprod+'\',\''+productprice+'\')">- Remove</button>'+
       '</div>'+
        '<div class="input-group">'+       
        '<select id="'+producttype+'" name="productType" class="form-control" onchange="getProducts(this.value,\''+productname+'\');">'+
            '<option value="">Product Type</option>'+
            '<%for(int i=0;i<servicetype.length;i++){ %>'+
            '<option value="<%=servicetype[i][1]%>"><%=servicetype[i][1]%></option>'+
            '<%} %>'+                                       
       '</select>'+
       '<input type="hidden" name="pid" id="pid">'+
        '</div>'+
        '<div id="productTypeErrorMSGdiv" class="errormsg"></div>'+
       '</div>'+
      '</div>'+
      '<div class="col-md-12 col-sm-12 col-xs-12">'+
       '<div class="form-group relative_box">'+
       '<div class="clearfix text-right">'+
		 '<button class="addbtn pointers " type="button" data-related="add_contact" id="'+newproductid+'" onclick="addNewProduct()" style="display: none;float:right;margin-bottom: 10px;">+ New Product</button>'+
		'</div>'+
        '<div class="input-group">'+     
        '<input type="hidden" id="'+ProdGroupRefid+'" value="NA">'+
        '<select name="product_name" id="'+productname+'" onchange="setProductPrice(\''+productname+'\',\''+crossbtn+'\',\''+producttype+'\',\''+productprice+'\',\''+productname+'\',\''+newproductid+'\',\''+PriceDropBox+'\',\''+PriceDropBoxSubAmount+'\',\''+PriceGroupId+'\',\''+PriceProduct+'\',\''+TotalPriceProduct+'\',\''+ProdGroupRefid+'\',\''+removeicon+'\',\''+CurrentProdrefid+'\',\'NA\')" class="form-control">'+
        '<option value="">Select Product</option>'+           
        '<option value="'+prodnam+'" selected>'+prodname+'</option>'+    
         '</select>'+
        '</div>'+
        '<div id="product_nameErrorMSGdiv" class="errormsg"></div>'+																												
        '<button class="addbtn pointers close_icon3 del_icon" id="'+crossbtn+'" type="button" style="display: none;" onclick="activeDisplay(\''+productname+'\',\''+producttype+'\',\''+crossbtn+'\',\''+productprice+'\',\''+ProductPriceDiv+'\',\''+newproductid+'\',\''+PriceGroupId+'\',\''+PriceProduct+'\',\''+TotalPriceProduct+'\');showRemove(\''+removeicon+'\');"><i class="fas fa-times" style="font-size: 21px;"></i></button>'+
       
       '</div>'+
      '</div>'+
	  '</div>'+
	  '<div class="clearfix EstimateList2" id="'+ProductPriceDiv+'">'+
	  '<div class="clearfix inner_box_bg form-group" id="'+productprice+'" style="display: none;">'+
    '<div class="mb10 flex_box align_center relative_box">'+
    '<span class="input_radio bg_wht pad_box2 pad_box3 s_head">'+ 
	'<select class="s_type" name="'+jurisdictionId+'" id="'+jurisdictionId+'" onchange="updatePlan(\''+CurrentProdrefid+'\',this.value,\'esjurisdiction\');" required="required">'+
	'<option value="">Select Jurisdiction</option>'+																	
	'</select></span>'+    
	'<span class="input_radio bg_wht pad_box2 pad_box3">'+
	'<input type="radio" name="'+service+'" id="'+onetimeterm+'" checked="checked" onclick="hideTime(\''+period+'\',\''+TimelineBox+'\',\''+ProductPlan+'\');updatePlan(\''+CurrentProdrefid+'\',\'OneTime\',\'esprodplan\');">'+
	'<span>One time</span>'+
	'</span>'+
	'<span class="mlft10 input_radio bg_wht pad_box2 pad_box3">'+
	'<input type="radio" name="'+service+'" id="'+rentimeterm+'" onclick="askTime(\''+period+'\',\''+ProductPlan+'\',\''+periodtime+'\');updatePlan(\''+CurrentProdrefid+'\',\'Renewal\',\'esprodplan\');">'+
	'<span>Renewal</span>'+																																																						
	'</span>'+	
	
	'<span class="mlft10 RenBox1" id="'+period+'" style="width: 100px;">'+
	'<input type="text" name="'+ProductPlan+'" autocomplete="off"  onclick="showTimelineBox(\''+TimelineBox+'\')" onchange="updatePlan(\''+CurrentProdrefid+'\',this.value,\'esplantime\');" id="'+ProductPlan+'" class="form-control bdrnone text-right" placeholder="Timeline" style="width: 55%;">'+
    '<input type="text" name="'+periodtime+'" autocomplete="off" id="'+periodtime+'" class="form-control bdrnone pointers" readonly="readonly" style="width: 11%;position: absolute;margin-left: 50px;margin-top: -37px;">'+
	'</span>'+
	'<div class="timelineproduct_box" id="'+TimelineBox+'">'+
	'<div class="timelineproduct_inner">'+
	'<span onclick="addInput(\''+periodtime+'\',\''+TimelineBox+'\',\''+ProductPlan+'\',\''+CurrentProdrefid+'\',\'Day\',\'esplanperiod\')">Day</span> <span onclick="addInput(\''+periodtime+'\',\''+TimelineBox+'\',\''+ProductPlan+'\',\''+CurrentProdrefid+'\',\'Week\',\'esplanperiod\')">Week</span ><span onclick="addInput(\''+periodtime+'\',\''+TimelineBox+'\',\''+ProductPlan+'\',\''+CurrentProdrefid+'\',\'Month\',\'esplanperiod\')">Month</span><span onclick="addInput(\''+periodtime+'\',\''+TimelineBox+'\',\''+ProductPlan+'\',\''+CurrentProdrefid+'\',\'Year\',\'esplanperiod\')">Year</span></div>'+
	'</div>'+		
	'<input type="hidden" id="'+CurrentProdrefid+'"/>'+
	'<span class="bg_wht pad_box3 qtyBtn">'+																																																																																																																																						
	'<span class="fa fa-minus pointers" onclick="updateMainProductQty(\''+SaleProdQty+'\',\'minus\',\''+CurrentProdrefid+'\',\''+rentimeterm+'\',\''+onetimeterm+'\',\''+ProductPlan+'\',\''+periodtime+'\',\''+productprice+'\',\''+PriceProduct+'\',\''+TotalPriceProduct+'\',\''+PriceDropBox+'\',\''+PriceDropBoxSubAmount+'\' )"></span>'+
	'<input type="text" id="'+SaleProdQty+'" value="1" onchange="updateMainProdQty(\''+SaleProdQty+'\',\''+CurrentProdrefid+'\',\''+rentimeterm+'\',\''+onetimeterm+'\',\''+ProductPlan+'\',\''+periodtime+'\',\''+productprice+'\',\''+PriceProduct+'\',\''+TotalPriceProduct+'\',\''+PriceDropBox+'\',\''+PriceDropBoxSubAmount+'\')" onkeypress="return isNumber(event)">'+
	'<span class="fa fa-plus pointers" onclick="updateMainProductQty(\''+SaleProdQty+'\',\'plus\',\''+CurrentProdrefid+'\',\''+rentimeterm+'\',\''+onetimeterm+'\',\''+ProductPlan+'\',\''+periodtime+'\',\''+productprice+'\',\''+PriceProduct+'\',\''+TotalPriceProduct+'\',\''+PriceDropBox+'\',\''+PriceDropBoxSubAmount+'\')"></span>'+									
	'</span>'+
	'</div>'+
     '<div class="row mb10">'+
       '<div class="col-md-12 col-sm-12 col-xs-12">'+
       
       '<div class="clearfix" id="'+PriceDropBox+'"></div>'+
       '<input type="hidden" name="'+PriceGroupId+'" id="'+PriceGroupId+'"/>'+
       '<div class="clearfix" id="'+PriceDropBoxSubAmount+'"></div>'+    
       
      '</div>'+
      '</div>'+	  
    '</div>'+
    '</div>'+
 '</div>'+
 '</div>'+
 '</div>').insertBefore('.MultipleProduct');	
	$("#"+producttype).val(prodtype);
	appendJurisdiction(global,central,state,jurisdictionId,jurisdiction);
	setTimeout(function(){
	setMainProductPrice(esrefid,SaleProdQty,rentimeterm,onetimeterm,ProductPlan,periodtime,period,CurrentProdrefid,productprice,PriceDropBox,PriceGroupId,PriceDropBoxSubAmount,removeicon,productname,crossbtn,producttype,newproductid,p,ProdGroupRefid,PriceProduct,TotalPriceProduct);
	},50*p);
}

function setMainProductPrice(pricerefid,SaleProdQtyId,renewalId,onetimeId,MainTimelineValueId,MainTimelineUnitId,ProductPeriodId,CurrentProdrefid,productprice,PriceDropBox,PriceGroupId,PriceDropBoxSubAmount,removeiconid,productname,crossbtn,producttype,newproductbtnid,p,ProdGroupRefid,PriceProduct,TotalPriceProduct){
	fillTimePlan(pricerefid,SaleProdQtyId,renewalId,onetimeId,MainTimelineValueId,MainTimelineUnitId,ProductPeriodId);
	$.ajax({
			type : "POST",
			url : "SetProductPriceList111",
			dataType : "HTML",
			data : {				
				pricerefid : pricerefid
			},
			success : function(response){
			if(Object.keys(response).length!=0){				
			$("#"+CurrentProdrefid).val(pricerefid);
			response = JSON.parse(response);
			 var len = response.length;	
			 if(removeiconid!="NA"){
				 hideRemove(removeiconid);}								 	
				 $("#"+crossbtn).show();
				 $('#'+producttype).hide();	 
				 $("#"+newproductbtnid).show();
				 $("#"+productprice).show();
				 $('#'+productname).attr('disabled','disabled');
				 $('#'+productname).css('appearance','none');				 
			 var subamount=0;	
			 var key="NA";
			for(var i=0;i<len;i++){
				var refid = response[i]['refid'];
				var pricetype = response[i]['pricetype'];
				var price = response[i]['price'];
				var minprice = response[i]['minprice'];
				var hsncode = response[i]['hsncode'];
				var cgstpercent = response[i]['cgstpercent'];
				var sgstpercent = response[i]['sgstpercent'];
				var igstpercent = response[i]['igstpercent'];
				var taxprice = response[i]['tax'];
				var totalprice = response[i]['totalprice'];
				var gstpercent=Number(cgstpercent)+Number(sgstpercent)+Number(igstpercent);
				var sn=$("#SalesProductIdQty").val();
				sn=Number(sn)+Number(1);
				var TaxId="TaxPId"+sn;
				var PriceId="PricePId"+sn;
				var TotalPrice="TotalPricePId"+sn;
				var gstPriceId="GstPricePId"+sn;
				$("#SalesProductIdQty").val(sn);
				if(key=="NA")key=refid;
				subamount=Number(subamount)+Number(totalprice);
				$(''+
				'<div class="clearfix bg_wht link-style12 Estpricelist2 '+PriceProduct+'">'+
             '<div class="box-width25 col-xs-1 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border">'+(i+1)+'</p>'+
                  '</div>'+
              '</div>'+
              '<div class="box-width19 col-xs-1 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border" title='+pricetype+'>'+pricetype+'</p>'+
                  '</div>'+
              '</div>'+
              '<div class="box-width14 col-xs-1 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" style="height: 38px;margin-left: 2px;" value="'+price+'" id="'+PriceId+'" onchange="updatePrice(\''+refid+'\',\''+TotalPrice+'\',\''+PriceId+'\',\''+minprice+'\',\''+cgstpercent+'\',\''+sgstpercent+'\',\''+igstpercent+'\',\''+pricerefid+'\',\''+gstPriceId+'\',\''+SaleProdQtyId+'\',\''+key+'\')" onkeypress="return isNumberKey(event)"/></p>'+
                  '</div>'+
              '</div>'+    
              '<div class="box-width3 col-xs-1 box-intro-background">'+
              '<input type="text" name="'+TaxId+'" id="'+TaxId+'" value="'+gstpercent+' %'+'" class="form-control bdrnone" autocomplete="off" placeholder="Tax %" readonly="readonly">'+
				      '</div>'+
              '<div class="box-width14 col-xs-6 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border"><input type="text" class="form-control BrdNone" id="'+gstPriceId+'" style="height: 38px;margin-left: 2px;" value="'+taxprice+'" readonly="readonly"/></p>'+
                  '</div>'+
              '</div>'+
              '<div class="box-width14 col-xs-6 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" id="'+TotalPrice+'" value="'+totalprice+'" style="height: 38px;margin-left: 2px;" readonly="readonly"/></p>'+
                  '</div>'+
              '</div>'+ 
           '</div>').insertBefore('#'+PriceDropBox);				
			}
			$(''+
			'<div class="clearfix Estpricelist3 '+TotalPriceProduct+'">'+
         '<div class="box-width59 col-xs-6 box-intro-background">'+
             '<div class="clearfix mt-10"><a href="javascript:void(0)" onclick="addNewPriceType(\''+ProdGroupRefid+'\')"><u>+ Add Price</u></a></div>'+
         '</div>'+
			 '<div class="box-width26 col-xs-6 box-intro-background">'+
             '<div class="clearfix">'+
             '<p class="news-border justify_end">Total:</p>'+
             '</div>'+
         '</div>'+
         '<div class="box-width14 col-xs-6 box-intro-background">'+
             '<div class="clearfix">'+
             '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" id="'+key+'" value="'+subamount.toFixed(2)+'" style="height: 38px;margin-left: 2px;" readonly="readonly"/></p>'+
             '</div>'+
         '</div>'+ 
      '</div>').insertBefore('#'+PriceDropBoxSubAmount);		
			$("#"+ProdGroupRefid).val(pricerefid);	
			$("#"+PriceGroupId).val(pricerefid);	
			 }else{
				 document.getElementById('errorMsg').innerHTML ='Price not Listed , Please set price.';					
		 		    $('.alert-show').show().delay(4000).fadeOut();
			 }
			}
		});
}

function addNewProduct(){
	showLoader();
	var a=document.getElementById("NewProductIdUid").value.trim();
	var i=Number(a)+1;
	var crossbtn="CloseBtn"+i;
	var producttype="Product_Type"+i;
	var productprice="productPrice"+i;
	var productname="Product_Name"+i;
	var multiprod="MultiProd"+i;
	var onetimeterm="onetime"+i;
	var rentimeterm="renewal"+i;
	var service="timetype"+i;
	var period="ProductPeriod"+i;
	var periodtime="ProductPeriodTime"+i;
	var gstprice="GstPrice"+i;
	var totalprice="TotalPrice"+i;
	var newproductid="NewProductBtn"+i;
	var removeicon="RemoveIcon"+i;
	var PriceDropBox="PriceDropBox"+i;
	var PriceGroupId="PriceGroupId"+i;
	var ProductPriceDiv="ProductPriceDiv"+i;
	var TotalPriceProduct="TotalPriceProduct"+i;
	var PriceProduct="PriceProduct"+i;
	var ProductPlan="ProductPlan"+i;
	var TimelineBox="TimelineBox"+i;
	var SaleProdQty="SaleProdQty"+i;
	var ProdGroupRefid="ProdGroupRefid"+i;
	var CurrentProdrefid="CurrentProdrefid"+i;
	var PriceDropBoxSubAmount="PriceDropBoxSubAmount"+i;
	var jurisdictionId="jurisdiction"+i;
	document.getElementById("NewProductIdUid").value=i;
	
	$(''+
	'<div class="row EstimateList1" id="'+multiprod+'">'+							
	'<div class="col-md-12 col-sm-12 col-xs-12">'+
       '<div class="form-group">'+
       '<div class="clearfix text-right mb10" style="margin-top: 5px;" id="'+removeicon+'">'+
		'<button class="addbtn pointers" type="button" onclick="removeCurrentProduct(\''+multiprod+'\',\''+productprice+'\')">- Remove</button>'+
       '</div>'+
        '<div class="input-group">'+       
        '<select id="'+producttype+'" name="productType" class="form-control" onchange="getProducts(this.value,\''+productname+'\');">'+
            '<option value="">Product Type</option>'+
            '<%for(int i=0;i<servicetype.length;i++){ %>'+
            '<option value="<%=servicetype[i][1]%>"><%=servicetype[i][1]%></option>'+
            '<%} %>'+                                       
       '</select>'+
       '<input type="hidden" name="pid" id="pid">'+
        '</div>'+
        '<div id="productTypeErrorMSGdiv" class="errormsg"></div>'+
       '</div>'+
      '</div>'+
      '<div class="col-md-12 col-sm-12 col-xs-12">'+
       '<div class="form-group relative_box">'+
       '<div class="clearfix text-right">'+
		 '<button class="addbtn pointers " type="button" data-related="add_contact" id="'+newproductid+'" onclick="addNewProduct()" style="display: none;float:right;margin-bottom: 10px;">+ New Product</button>'+
		'</div>'+
        '<div class="input-group">'+     
        '<input type="hidden" id="'+ProdGroupRefid+'" value="NA">'+
        '<select name="product_name" id="'+productname+'" onchange="setProductPrice(\''+productname+'\',\''+crossbtn+'\',\''+producttype+'\',\''+productprice+'\',\''+productname+'\',\''+newproductid+'\',\''+PriceDropBox+'\',\''+PriceDropBoxSubAmount+'\',\''+PriceGroupId+'\',\''+PriceProduct+'\',\''+TotalPriceProduct+'\',\''+ProdGroupRefid+'\',\''+removeicon+'\',\''+CurrentProdrefid+'\',\''+SaleProdQty+'\',\''+jurisdictionId+'\')" class="form-control">'+
          '<option value="">Product Name</option>'+                                  
         '</select>'+
        '</div>'+
        '<div id="product_nameErrorMSGdiv" class="errormsg"></div>'+																	                  
        '<button class="addbtn pointers close_icon3 del_icon" id="'+crossbtn+'" type="button" style="display: none;" onclick="activeDisplay(\''+productname+'\',\''+producttype+'\',\''+crossbtn+'\',\''+productprice+'\',\''+ProductPriceDiv+'\',\''+newproductid+'\',\''+PriceGroupId+'\',\''+PriceProduct+'\',\''+TotalPriceProduct+'\');showRemove(\''+removeicon+'\');"><i class="fas fa-times" style="font-size: 21px;"></i></button>'+
       
       '</div>'+
      '</div>'+
	  '</div>'+
	  '<div class="clearfix EstimateList2" id="'+ProductPriceDiv+'">'+
	  '<div class="clearfix inner_box_bg form-group" id="'+productprice+'" style="display: none;">'+
    '<div class="mb10 flex_box align_center relative_box">'+
    '<span class="input_radio bg_wht pad_box2 pad_box3 s_head">'+ 
	'<select class="s_type" name="'+jurisdictionId+'" id="'+jurisdictionId+'" onchange="updatePlan(\''+CurrentProdrefid+'\',this.value,\'esjurisdiction\');" required="required">'+
	'<option value="">Select Jurisdiction</option>'+																	
	'</select></span>'+
	'<span class="input_radio bg_wht pad_box2 pad_box3">'+
	'<input type="radio" name="'+service+'" id="'+onetimeterm+'" checked="checked" onclick="hideTime(\''+period+'\',\''+TimelineBox+'\',\''+ProductPlan+'\');updatePlan(\''+CurrentProdrefid+'\',\'OneTime\',\'esprodplan\');">'+
	'<span>One time</span>'+
	'</span>'+
	'<span class="mlft10 input_radio bg_wht pad_box2 pad_box3">'+
	'<input type="radio" name="'+service+'" id="'+rentimeterm+'" onclick="askTime(\''+period+'\',\''+PriceGroupId+'\',\''+periodtime+'\');updatePlan(\''+CurrentProdrefid+'\',\'Renewal\',\'esprodplan\');">'+
	'<span>Renewal</span>'+
	'</span>'+	
	'<span class="mlft10 RenBox1" id="'+period+'" style="width: 100px;">'+
	'<input type="text" name="'+ProductPlan+'" autocomplete="off"  onclick="showTimelineBox(\''+TimelineBox+'\')" onchange="updatePlan(\''+CurrentProdrefid+'\',this.value,\'esplantime\');" id="'+ProductPlan+'" class="form-control bdrnone text-right" placeholder="Timeline" style="width: 55%;">'+
    '<input type="text" name="'+periodtime+'" autocomplete="off" id="'+periodtime+'" class="form-control bdrnone pointers" readonly="readonly" style="width: 11%;position: absolute;margin-left: 50px;margin-top: -37px;">'+
	'</span>'+
	'<div class="timelineproduct_box" id="'+TimelineBox+'">'+
	'<div class="timelineproduct_inner">'+
	'<span onclick="addInput(\''+periodtime+'\',\''+TimelineBox+'\',\''+ProductPlan+'\',\''+CurrentProdrefid+'\',\'Day\',\'esplanperiod\')">Day</span> <span onclick="addInput(\''+periodtime+'\',\''+TimelineBox+'\',\''+ProductPlan+'\',\''+CurrentProdrefid+'\',\'Week\',\'esplanperiod\')">Week</span ><span onclick="addInput(\''+periodtime+'\',\''+TimelineBox+'\',\''+ProductPlan+'\',\''+CurrentProdrefid+'\',\'Month\',\'esplanperiod\')">Month</span><span onclick="addInput(\''+periodtime+'\',\''+TimelineBox+'\',\''+ProductPlan+'\',\''+CurrentProdrefid+'\',\'Year\',\'esplanperiod\')">Year</span></div>'+
	'</div>'+		
	'<input type="hidden" id="'+CurrentProdrefid+'"/>'+
	'<span class="bg_wht pad_box3 qtyBtn">'+
	'<span class="fa fa-minus pointers" onclick="updateMainProductQty(\''+SaleProdQty+'\',\'minus\',\''+CurrentProdrefid+'\',\''+rentimeterm+'\',\''+onetimeterm+'\',\''+ProductPlan+'\',\''+periodtime+'\',\''+productprice+'\',\''+PriceProduct+'\',\''+TotalPriceProduct+'\',\''+PriceDropBox+'\',\''+PriceDropBoxSubAmount+'\')"></span>'+
	'<input type="text" id="'+SaleProdQty+'" value="1" onchange="updateMainProdQty(\''+SaleProdQty+'\',\''+CurrentProdrefid+'\',\''+rentimeterm+'\',\''+onetimeterm+'\',\''+ProductPlan+'\',\''+periodtime+'\',\''+productprice+'\',\''+PriceProduct+'\',\''+TotalPriceProduct+'\',\''+PriceDropBox+'\',\''+PriceDropBoxSubAmount+'\')" onkeypress="return isNumber(event)">'+
	'<span class="fa fa-plus pointers" onclick="updateMainProductQty(\''+SaleProdQty+'\',\'plus\',\''+CurrentProdrefid+'\',\''+rentimeterm+'\',\''+onetimeterm+'\',\''+ProductPlan+'\',\''+periodtime+'\',\''+productprice+'\',\''+PriceProduct+'\',\''+TotalPriceProduct+'\',\''+PriceDropBox+'\',\''+PriceDropBoxSubAmount+'\')"></span>'+									
	'</span>'+
	'</div>'+
     '<div class="row mb10">'+
       '<div class="col-md-12 col-sm-12 col-xs-12">'+       
       '<div class="clearfix" id="'+PriceDropBox+'"></div>'+
       '<input type="hidden" name="'+PriceGroupId+'" id="'+PriceGroupId+'"/>'+
       '<div class="clearfix" id="'+PriceDropBoxSubAmount+'"></div>'+    
       
      '</div>'+
      '</div>'+	  
    '</div>'+
    '</div>'+
 '</div>'+
 '</div>'+
 '</div>').insertBefore('.MultipleProduct');	
	$('#edit_estimate').animate({scrollTop: $("#"+multiprod).offset().top},'slow');
	hideLoader();
}

function setProductPrice(prodid,crossbtn,producttype,productprice,productname,
		newproductbtn,pricedropbox,pricedropboxsubamount,pricedivid,PriceProduct,
		TotalPriceProduct,ProdGroupRefid,removeiconid,CurrentProdrefid,
		SaleProdQtyId,jurisdictionId){
	 var prod=$("#"+prodid).val();
	 var x=prod.split("#");
	 var prodrefid=x[1];
	 var salesno=$("#ConvertInvoiceSaleNo").val();
	 showLoader();
	 $.ajax({
			type : "POST",
			url : "IsProductInOrder111",
			dataType : "HTML",
			data : {				
				prodrefid : prodrefid,	
				salesno : salesno
			},
			success : function(data){	
				if(data=="fail"){					
					var company=$("#ConvertInvoiceCompany").val();
					var contactrefid=$("#ConvertInvoiceContactrefid").val();
					var clientrefid=$("#ConvertInvoiceClientrefid").val();
					var servicetype=$("#"+producttype).val();
					var prodname=x[0];
					var esrefid=makeid(40);	
					showLoader();
						 $.ajax({
								type : "POST",
								url : "SetProductInOrder111",
								dataType : "HTML",
								data : {				
									prodrefid : prodrefid,
									salesno : salesno,
									company : company,
									contactrefid : contactrefid,
									clientrefid : clientrefid,
									servicetype : servicetype,
									prodname : prodname,
									esrefid : esrefid
								},
								success : function(response){
								if(Object.keys(response).length!=0){
								response = JSON.parse(response);
								 var len = response.length;	
								 if(removeiconid!="NA"){
									 hideRemove(removeiconid);}								 	
									 $("#"+crossbtn).css('display','block');
									 $('#'+producttype).css('display','none');	 
									 $("#"+newproductbtn).css('display','block');
									 $("#"+productprice).css('display','block');
									 $('#'+productname).attr('disabled','disabled');
									 $('#'+productname).css('appearance','none');		
									 $('#'+CurrentProdrefid).val(esrefid);
								 var subamount=0;
								 var key="NA";
								for(var i=0;i<len;i++){									
									var groupkey = response[i]['salekey'];
									var pricetype = response[i]['pricetype'];
									var price = response[i]['price'];
									var minprice=Number(price);
									var hsn = response[i]['hsn'];
									var cgstpercent = response[i]['cgstpercent'];
									var sgstpercent = response[i]['sgstpercent'];
									var igstpercent = response[i]['igstpercent'];
									var totalprice = response[i]['totalprice'];
									var pricerefid = response[i]['pricerefid'];
									var taxprice = response[i]['taxprice'];
									var gstpercent=Number(cgstpercent)+Number(sgstpercent)+Number(igstpercent);									
									var sn=$("#SalesProductIdQty").val();
									sn=Number(sn)+Number(1);
									var TaxId="TaxId"+sn;
									var PriceId="PriceId"+sn;
									var TotalPrice="TotalPrice"+sn;									
									var gstPriceId="gstPriceId"+sn;
									$("#SalesProductIdQty").val(sn);
									key=groupkey;
									subamount=Number(subamount)+Number(totalprice);
									$(''+
											'<div class="clearfix bg_wht link-style12 '+PriceProduct+'">'+
							             '<div class="box-width25 col-xs-1 box-intro-background">'+
							                  '<div class="clearfix">'+
							                  '<p class="news-border">'+(i+1)+'</p>'+
							                  '</div>'+
							              '</div>'+
							              '<div class="box-width19 col-xs-1 box-intro-background">'+
							                  '<div class="clearfix">'+
							                  '<p class="news-border" title='+pricetype+'>'+pricetype+'</p>'+
							                  '</div>'+
							              '</div>'+
							              '<div class="box-width14 col-xs-1 box-intro-background">'+
							                  '<div class="clearfix">'+																																																																																																					                                                                                            
							                  '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" style="height: 38px;margin-left: 2px;" value="'+price+'" id="'+PriceId+'" onchange="updatePrice(\''+pricerefid+'\',\''+TotalPrice+'\',\''+PriceId+'\',\''+minprice+'\',\''+cgstpercent+'\',\''+sgstpercent+'\',\''+igstpercent+'\',\''+esrefid+'\',\''+gstPriceId+'\',\''+SaleProdQtyId+'\',\''+key+'\')" onkeypress="return isNumberKey(event)"/></p>'+
							                  '</div>'+
							              '</div>'+    
							              '<div class="box-width3 col-xs-1 box-intro-background">'+
							              '<input type="text" name="'+TaxId+'" id="'+TaxId+'" value="'+gstpercent+' %'+'" class="form-control bdrnone" autocomplete="off" placeholder="Tax %" readonly="readonly">'+
											      '</div>'+
							              '<div class="box-width14 col-xs-6 box-intro-background">'+
							                  '<div class="clearfix">'+
							                  '<p class="news-border"><input type="text" class="form-control BrdNone" id="'+gstPriceId+'" style="height: 38px;margin-left: 2px;" value="'+taxprice+'" readonly="readonly"/></p>'+
							                  '</div>'+
							              '</div>'+
							              '<div class="box-width14 col-xs-6 box-intro-background">'+
							                  '<div class="clearfix">'+
							                  '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" id="'+TotalPrice+'" value="'+totalprice+'" style="height: 38px;margin-left: 2px;" readonly="readonly"/></p>'+
							                  '</div>'+
							              '</div>'+ 
							           '</div>').insertBefore('#'+pricedropbox);
								}
								$(''+
										'<div class="clearfix '+TotalPriceProduct+'">'+
							         '<div class="box-width59 col-xs-6 box-intro-background">'+
							             '<div class="clearfix"><a href="javascript:void(0)" onclick="addNewPriceType(\''+ProdGroupRefid+'\')"><u>+ Add Price</u></a></div>'+
							         '</div>'+
										 '<div class="box-width26 col-xs-6 box-intro-background">'+
							             '<div class="clearfix">'+
							             '<p class="news-border justify_end">Total:</p>'+
							             '</div>'+
							         '</div>'+
							         '<div class="box-width14 col-xs-6 box-intro-background">'+
							             '<div class="clearfix">'+
							             '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" id="'+key+'" value="'+Number(subamount).toFixed(2)+'" style="height: 38px;margin-left: 2px;" readonly="readonly"/></p>'+
							             '</div>'+
							         '</div>'+ 
							      '</div>').insertBefore('#'+pricedropboxsubamount);
								
								 $("#"+ProdGroupRefid).val(key);
								$("#"+productprice).css('display','block');
								document.getElementById(pricedivid).value=key;			
								 }else{
									 document.getElementById('errorMsg').innerHTML ='Price not Listed , Please set price.';	
									 $("#"+prodid).val('');
							 		    $('.alert-show').show().delay(4000).fadeOut();
								 }
								},
								complete : function(data){
									hideLoader();
								}
							});	
			if(jurisdictionId!="NA")
			appendNewProductJurisdiction(prodrefid,jurisdictionId);
			}else{
				document.getElementById('errorMsg').innerHTML ='Product already in your cart. Increase quantity !!';	
				$("#"+prodid).val('');
				 $('.alert-show').show().delay(4000).fadeOut();
			}},
			complete : function(data){
				hideLoader();
			}
		});	 
}
function makeid(length) {
	   var result           = '';
	   var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
	   var charactersLength = characters.length;
	   for ( var i = 0; i < length; i++ ) {
	      result += characters.charAt(Math.floor(Math.random() * charactersLength));
	   }
	   return result;
	}
function activeDisplay(prodname,prodtype,crossbtn,productprice,parendpricediv,newproductid,pricedivrefid,PriceProduct,TotalPriceProduct){
	 $('#'+prodname).removeAttr('style');
	 $('#'+prodname).removeAttr('disabled');	 
	 $('#'+prodtype).show();
	 $('#'+newproductid).hide();
	 $('#'+prodname).val('');
	 $('#'+crossbtn).hide();	 
	 removeProductPrice(pricedivrefid,productprice,parendpricediv,PriceProduct,TotalPriceProduct);
} 
function removeProductPrice(pricedivid,productprice,parendpricediv,PriceProduct,TotalPriceProduct){
	 var salesrefidrefid=document.getElementById(pricedivid).value.trim();
	 showLoader();
	 $.ajax({
			type : "POST",
			url : "RemoveSalesProductPrices111",
			dataType : "HTML",
			data : {				
				salesrefidrefid : salesrefidrefid,				
			},
			success : function(data){				
					$('#'+productprice).css('display','none');
					$("."+PriceProduct).remove();
					$("."+TotalPriceProduct).remove();			
				
			},
			complete : function(data){
				hideLoader();
			}
		});	 
}
function hideRemove(removeid){
	 $('#'+removeid).css('display','none');
}
function showRemove(removeid){
	 $('#'+removeid).css('display','block');
}
function getProducts(servicetype,productDiv){
	if(servicetype!=""){
		showLoader();
		$.ajax({
		type : "POST",
		url : "GetServiceType111",
		dataType : "HTML",
		data : {				
			"servicetype":servicetype,
		},
		success : function(response){
			if(Object.keys(response).length!=0){
			response = JSON.parse(response);			
			 var len = response.length;
			 
			$("#"+productDiv).empty();
		    $("#"+productDiv).append("<option value=''>"+"Product Name"+"</option>");		    
			for(var i=0;i<len;i++){
				var prodrefid = response[i]['prodrefid'];
				var pname = response[i]['pname'];
				$("#"+productDiv).append("<option value='"+pname+"#"+prodrefid+"'>"+pname+"</option>");
			}
			}
		},
		complete : function(data){
			hideLoader();
		}
	});}else{
		$("#"+productDiv).empty();
	    $("#"+productDiv).append("<option value=''>"+"Product Name"+"</option>");	   
	}
}
function removeCurrentProduct(ProdBoxId,ProdPriceBox){
	$('#'+ProdBoxId).remove();
	$('#'+ProdPriceBox).remove();
}
function updateProdQty(InputBoxId,ProdGroupRefId){
	var prodrefid=$("#"+ProdGroupRefId).val();
	var prodqty=$("#"+InputBoxId).val();		
	if(prodrefid!="NA"&&prodrefid!=""){
		showLoader();
	$.ajax({
		type : "POST",
		url : "UpdateSalesProductsQtyDirect111",
		dataType : "HTML",
		data : {
			prodrefid : prodrefid,
			prodqty : prodqty
			},
		success : function(data){
			var x=data.split("#");
			if(x[0]=="pass"){				
				document.getElementById("errorMsg1").innerHTML="Updated Successfully.";				
				$("#"+InputBoxId).val(prodqty);		
				$("#ConvertedPriceListId").remove();
				var b=$('#Convert_Product_Name').val();
				var c=b.split("#");
				setProduct(c[1],prodrefid);
			$('.alert-show1').show().delay(2000).fadeOut();
			}else if(x[0]=="Not"){	
				document.getElementById("errorMsg").innerHTML="Invalid Input.";		
				$("#"+InputBoxId).val(x[1]);	
			$('.alert-show').show().delay(2000).fadeOut();
			}else{
				document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";		
				$("#"+InputBoxId).val(x[1]);	
				$('.alert-show').show().delay(4000).fadeOut();
			}
			
		},
		complete : function(data){
			hideLoader();
		}
	});
	}else{
		document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";				
		$('.alert-show').show().delay(4000).fadeOut();
	}
}																															
function updateMainProductQty(InputBoxId,action,ProdGroupRefid,rentimeterm,onetimeterm,ProductPlan,periodtime,periodproductprice,PriceProduct,TotalPriceProduct,PriceDropBox,PriceDropBoxSubAmount){
	var prodrefid=$("#"+ProdGroupRefid).val();
	
	var prodqty=$("#"+InputBoxId).val();	
	if(prodrefid!="NA"&&prodrefid!=""){
		showLoader();
	$.ajax({
		type : "POST",
		url : "UpdateSalesProductsQty111",
		dataType : "HTML",
		data : {
			prodrefid : prodrefid,
			prodqty : prodqty,
			action : action
			},
		success : function(data){
			if(data=="pass"){				
				document.getElementById("errorMsg1").innerHTML="Updated.";
				if(action=="plus"){prodqty=Number(prodqty)+Number(1);}
				else if(action=="minus"){prodqty=Number(prodqty)-Number(1);}
				$("#"+InputBoxId).val(prodqty);
				
				setMainProduct(prodrefid,InputBoxId,rentimeterm,onetimeterm,ProductPlan,periodtime,periodproductprice,ProdGroupRefid,PriceProduct,TotalPriceProduct,PriceDropBox,PriceDropBoxSubAmount);
				
			$('.alert-show1').show().delay(2000).fadeOut();
			}else if(data=="Not"){				
				document.getElementById("errorMsg").innerHTML="Invalid Input.";				
			$('.alert-show').show().delay(2000).fadeOut();
			}else{
				document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";				
				$('.alert-show').show().delay(4000).fadeOut();
			}
			
		},
		complete : function(data){
			hideLoader();
		}
	});
	}else{
		document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";				
		$('.alert-show').show().delay(4000).fadeOut();
	}
}				
function updateMainProdQty(InputBoxId,ProdGroupRefId,rentimeterm,onetimeterm,ProductPlan,periodtime,periodproductprice,PriceProduct,TotalPriceProduct,PriceDropBox,PriceDropBoxSubAmount){
	
	var prodrefid=$("#"+ProdGroupRefId).val();
	var prodqty=$("#"+InputBoxId).val();		
	
	if(prodrefid!="NA"&&prodrefid!=""){
		showLoader();
	$.ajax({
		type : "POST",
		url : "UpdateSalesProductsQtyDirect111",
		dataType : "HTML",
		data : {
			prodrefid : prodrefid,
			prodqty : prodqty
			},
		success : function(data){
			var x=data.split("#");
			if(x[0]=="pass"){				
				document.getElementById("errorMsg1").innerHTML="Updated.";				
				$("#"+InputBoxId).val(prodqty);	
				setMainProduct(prodrefid,InputBoxId,rentimeterm,onetimeterm,ProductPlan,periodtime,periodproductprice,ProdGroupRefId,PriceProduct,TotalPriceProduct,PriceDropBox,PriceDropBoxSubAmount);
				
			$('.alert-show1').show().delay(2000).fadeOut();
			}else if(x[0]=="Not"){	
				document.getElementById("errorMsg").innerHTML="Invalid Input.";		
				$("#"+InputBoxId).val(x[1]);	
			$('.alert-show').show().delay(2000).fadeOut();
			}else{
				document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";		
				$("#"+InputBoxId).val(x[1]);	
				$('.alert-show').show().delay(4000).fadeOut();
			}
			
		},
		complete : function(data){
			hideLoader();
		}
	});
	}else{
		document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";				
		$('.alert-show').show().delay(4000).fadeOut();
	}
}											
function setMainProduct(pricerefid,SaleProdQty,renewal,onetime,MainTimelineValue,MainTimelineUnit,ProductPeriod,CurrentProdrefid,PriceProduct,TotalPriceProduct,PriceDropBox,PriceDropBoxSubAmount){
	showLoader();
	fillTimePlan(pricerefid,SaleProdQty,renewal,onetime,MainTimelineValue,MainTimelineUnit,ProductPeriod);	
	
		$.ajax({
			type : "POST",
			url : "SetProductPriceList111",
			dataType : "HTML",
			data : {				
				pricerefid : pricerefid
			},
			success : function(response){
			if(Object.keys(response).length!=0){				
			$("#"+CurrentProdrefid).val(pricerefid);
			response = JSON.parse(response);
			 var len = response.length;						
				 $("."+PriceProduct).remove();
				 $("."+TotalPriceProduct).remove();
			 var subamount=0;			 
			for(var i=0;i<len;i++){
				var refid = response[i]['refid'];
				var pricetype = response[i]['pricetype'];
				var price = response[i]['price'];
				var minprice = response[i]['minprice'];
				var hsncode = response[i]['hsncode'];
				var cgstpercent = response[i]['cgstpercent'];
				var sgstpercent = response[i]['sgstpercent'];
				var igstpercent = response[i]['igstpercent'];
				var taxprice = response[i]['tax'];
				var totalprice = response[i]['totalprice'];
				var gstpercent=Number(cgstpercent)+Number(sgstpercent)+Number(igstpercent);
				var sn=$("#SalesProductIdQty").val();
				sn=Number(sn)+Number(1);
				var TaxId="TaxUId"+sn;
				var PriceId="PriceUId"+sn;
				var TotalPrice="TotalPriceUId"+sn;
				var gstPriceId="GstPriceUId"+sn;
				$("#SalesProductIdQty").val(sn);
				subamount=Number(subamount)+Number(totalprice);
				$(''+
				'<div class="clearfix bg_wht link-style12 Estpricelist2 '+PriceProduct+'">'+
             '<div class="box-width25 col-xs-1 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border">'+(i+1)+'</p>'+
                  '</div>'+
              '</div>'+
              '<div class="box-width19 col-xs-1 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border" title='+pricetype+'>'+pricetype+'</p>'+
                  '</div>'+
              '</div>'+
              '<div class="box-width14 col-xs-1 box-intro-background">'+
                  '<div class="clearfix">'+																																																																																																			
                  '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" style="height: 38px;margin-left: 2px;" value="'+price+'" id="'+PriceId+'" onchange="updatePrice(\''+refid+'\',\''+TotalPrice+'\',\''+PriceId+'\',\''+minprice+'\',\''+cgstpercent+'\',\''+sgstpercent+'\',\''+igstpercent+'\',\''+pricerefid+'\',\''+gstPriceId+'\',\''+SaleProdQty+'\',\''+pricerefid+'\')" onkeypress="return isNumberKey(event)"/></p>'+
                  '</div>'+
              '</div>'+    
              '<div class="box-width3 col-xs-1 box-intro-background">'+
              '<input type="text" name="'+TaxId+'" id="'+TaxId+'" value="'+gstpercent+' %'+'" class="form-control bdrnone" autocomplete="off" placeholder="Tax %" readonly="readonly">'+
				      '</div>'+
              '<div class="box-width14 col-xs-6 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border"><input type="text" class="form-control BrdNone" id="'+gstPriceId+'" style="height: 38px;margin-left: 2px;" value="'+taxprice+'" readonly="readonly"/></p>'+
                  '</div>'+
              '</div>'+
              '<div class="box-width14 col-xs-6 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" id="'+TotalPrice+'" value="'+totalprice+'" style="height: 38px;margin-left: 2px;" readonly="readonly"/></p>'+
                  '</div>'+
              '</div>'+ 
           '</div>').insertBefore('#'+PriceDropBox);				
			}
			$(''+
			'<div class="clearfix Estpricelist3 '+TotalPriceProduct+'">'+
         '<div class="box-width59 col-xs-6 box-intro-background">'+
             '<div class="clearfix"><a href="javascript:void(0)" onclick="addNewPriceType(\''+CurrentProdrefid+'\')"><u>+ Add Price</u></a></div>'+
         '</div>'+
			 '<div class="box-width26 col-xs-6 box-intro-background">'+
             '<div class="clearfix">'+
             '<p class="news-border justify_end">Total:</p>'+
             '</div>'+
         '</div>'+
         '<div class="box-width14 col-xs-6 box-intro-background">'+
             '<div class="clearfix">'+
             '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" id="'+pricerefid+'" value="'+subamount.toFixed(2)+'" style="height: 38px;margin-left: 2px;" readonly="readonly"/></p>'+
             '</div>'+
         '</div>'+ 
      '</div>').insertBefore('#'+PriceDropBoxSubAmount);			 	
			 }else{
				 document.getElementById('errorMsg').innerHTML ='Price not Listed , Please set price.';					
		 		    $('.alert-show').show().delay(4000).fadeOut();
			 }
			},
			complete : function(data){
				hideLoader();
			}
		});
}

function updateProductQty(InputBoxId,action,ProdGroupRefid){
	var prodrefid=$("#"+ProdGroupRefid).val();
	var prodqty=$("#"+InputBoxId).val();	
	if(prodrefid!="NA"&&prodrefid!=""){
		showLoader();
	$.ajax({
		type : "POST",
		url : "UpdateSalesProductsQty111",
		dataType : "HTML",
		data : {
			prodrefid : prodrefid,
			prodqty : prodqty,
			action : action
			},
		success : function(data){
			if(data=="pass"){				
				document.getElementById("errorMsg1").innerHTML="Updated Successfully.";
				if(action=="plus"){prodqty=Number(prodqty)+Number(1);}
				else if(action=="minus"){prodqty=Number(prodqty)-Number(1);}
				$("#"+InputBoxId).val(prodqty);		
				$("#ConvertedPriceListId").remove();
				var a=$('#Convert_Product_Name').val();
				var b=a.split("#");
				setProduct(b[1],prodrefid);
			$('.alert-show1').show().delay(2000).fadeOut();
			}else if(data=="Not"){				
				document.getElementById("errorMsg").innerHTML="Invalid Input.";				
			$('.alert-show').show().delay(2000).fadeOut();
			}else{
				document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";				
				$('.alert-show').show().delay(4000).fadeOut();
			}
			
		},
		complete : function(data){
			hideLoader();
		}
	});
	}else{
		document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";				
		$('.alert-show').show().delay(4000).fadeOut();
	}
}

	function updatePlan(prodid,value,colname){
		var prodrefid=$("#"+prodid).val();
		showLoader();
		$.ajax({
			type : "POST",
			url : "UpdateSalesProductPlan111",
			dataType : "HTML",
			data : {	
				prodrefid : prodrefid,
				value : value,
				colname : colname
			},
			success : function(data){
				if(data=="pass"){
					document.getElementById('errorMsg1').innerHTML ="Updated";
					$('.alert-show1').show().delay(500).fadeOut();
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
	function hideTime(ProductPeriod,Timelinebox,MainTimelineValueId){
		$("#"+MainTimelineValueId).prop('readonly',true);
		$("#"+ProductPeriod).hide();
		$("#"+Timelinebox).hide();
	}
	function askTime(ProductPeriod,TimelineValueId,TimeLineUnitId){
		$("#"+TimelineValueId).val('');
		$("#"+TimeLineUnitId).val('');
		$("#"+ProductPeriod).css('display','block');
		
	}
	function showTimelineBox(TimelineBoxId){
		if($('#'+TimelineBoxId).css('display') == 'none')
		{
			$("#"+TimelineBoxId).css('display','block');
		}	
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
// 				console.log(data);
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
			if(document.getElementById("UpdateContState").value.trim()==""){
				document.getElementById('errorMsg').innerHTML ="State is mandatory";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
			}
			if(document.getElementById("UpdateContCity").value.trim()==""){
				document.getElementById('errorMsg').innerHTML ="City is mandatory";
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
		var pan=$("#UpdateContPan").val();
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
	    	state=document.getElementById("UpdateContState").value.trim();
	    	x=state.split("#");
	    	stateCode=x[1];
	    	state=x[2];
	    	city=document.getElementById("UpdateContCity").value.trim();	    	
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
				country : country,
				address : address,
				companyaddress : companyaddress,
				addresstype : addresstype,
				contkey : contkey,
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
	
	function updateSalesContact(stbid,firstname,lastname,email,email2,workphone,mobile){
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
				salesKey : "NA"
			},
			success : function(data){
				if(data=="pass"){
					
					var rowdivid=document.getElementById("ManageEstimateUpdateContactId").value;
					$("#"+rowdivid).html(firstname+" "+lastname);
					
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
				
				$("#UpdateCompanyKey").val(clientkey);
				$("#UpdateCompanyName").val(name);
				$("#UpdateIndustry_Type").val(industry);
				$("#UpdatePanNumber").val(pan);
				$("#Edit_Company_age").val(compAge);
				$("#Update_Super_User").val(superUserUaid).trigger('change');
				if(gst!="NA"&&gst!=""){
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
	function openCompanyBox(comprefid){
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
			document.getElementById('errorMsg').innerHTML ="Client Doesn't exist, After converted sale it will register !!!.";
			$('.alert-show').show().delay(4000).fadeOut();
		}
		setClientSuperUser("Update_Super_User"); 
	}
	$('.add_new').on( "click", function(e) {
		$(this).parent().next().show();	
		});	
	$('.del_icon').on( "click", function(e) {
		$('.new_field').hide();	
		});
	$('#UpdateContactcomAddress').on( "click", function(e) {
		$('.UpdateAddress_box').hide();
		$('.UpdateCompany_box').show();	
		});
		$('#UpdateContactperAddress').on( "click", function(e) {
		$('.UpdateAddress_box').show();
		$('.UpdateCompany_box').hide();	
		});
	function openContactBox(contctref,cboxid,boxid,compaddId){
		var address=$("#"+compaddId).val();
		$("#ManageSalesCompAddress").val(address);
		$('#FormUpdateContactBox').trigger("reset");
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
				var country=response[0]["country"];
				var address=response[0]["address"];
				var pan=response[0]["pan"];
				var stateCode=response[0]["stateCode"];
								
				$("#UpdateContactKey").val(contkey);$("#UpdateContactSalesKey").val(cboxid);$("#UpdateContactFirstName").val(firstname);$("#UpdateContactLastName").val(lastname);$("#UpdateContactEmail_Id").val(email1);
				if(email2!=="NA"){
					$("#UpdateContactEmailId2").val(email2);
					document.getElementById("UpdateContactDivId").style.display="block";
				}			
				$("#UpdateContactWorkPhone").val(workphone);$("#UpdateContactMobilePhone").val(mobilephone);
				if(addresstype=="Personal"){
					$("#UpdateContCity").empty();
					$("#UpdateContCity").append("<option value='"+city+"' selected='selected'>"+city+"</option>");
					$("#UpdateContState").empty();
					$("#UpdateContState").append("<option value='0#"+stateCode+"#"+state+"' selected='selected'>"+state+"</option>");
					
					$("#UpdateContCountry").val(country);
					$("#UpdateContPan").val(pan);
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
	function getUpdateCompanyAddress(){
		var compaddress=document.getElementById("ManageSalesCompAddress").value.trim();
		document.getElementById("UpdateEnqCompAddress").value=compaddress;
	}
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
	
function showPayments(PymtSubDiv,PymtIconRight,PymtIconDown){
	if($('#'+PymtIconDown).css('display') == 'none'){
		$('#'+PymtIconRight).css('display','none');
		$('#'+PymtIconDown).css('display','block');
		$('#'+PymtSubDiv).css('display','block');
	}else{
		$('#'+PymtIconRight).css('display','block');
		$('#'+PymtIconDown).css('display','none');
		$('#'+PymtSubDiv).css('display','none');
	}
}	
function backEstimate(){
	var saleno=$("#ConvertInvoiceSaleNo").val();
	showLoader();
	 fillEstimateInvoiceDetails(saleno);
	  var id = $(".estimatebox").attr('data-related'); 
		$('.fixed_right_box').addClass('active');
		    $("div.add_inner_box").each(function(){
		        $(this).hide();
		        if($(this).attr('id') == id) {
		            $(this).show();
		        }
		    });	
	hideLoader();
}
   function openEstimateBox(saleno,companyname,contactrefid,clientrefid,estrefKey,
		   discount,clientEmail,clientName,totalAmount,date,salesType,status){
	   showLoader();
	   $("#taskNotesProduct").html('Notes : '+saleno);
	   $("#ConvertInvoiceSaleNo").val(saleno);
	   $("#ConvertInvoiceCompany").val(companyname);
		$("#ConvertInvoiceContactrefid").val(contactrefid);
		$("#ConvertInvoiceClientrefid").val(clientrefid);
		$("#ConvertEstimateRefKey").val(estrefKey);
		$("#ConvertEstimateSalesType").val(salesType);
		$("#SendEmailClientEmail").val(clientEmail);
		$("#SendEmailClientName").val(clientName);
		$("#ConvertEstimateDiscount").val(discount);
	   $('#EstimateBillNo').html("#"+saleno);
	   $("#CopyLinkUrl").removeClass('textCopied');
	   $("#ConvertEstimateStatus").val(status);
	   
	   fillEstimateInvoiceDetails(saleno);
	   isInvoiceEditable(saleno);
	   openInvoiceSummary(saleno,0);
	  
	   var id = $(".estimatebox").attr('data-related'); 
		$('.fixed_right_box').addClass('active');
		    $("div.add_inner_box").each(function(){
		        $(this).hide();
		        if($(this).attr('id') == id) {
		            $(this).show();
		        }
		    });	
		$("#EmailSendedId").attr("onclick","openSendEmailBox(\""+date+"\",\""+totalAmount+"\")");
		 hideLoader();
   }  
   function uploadDocument(){
	   var estkey=$("#estimateDocList").val();
		$("#ConvertEstimateDocRefKey").val(estkey);
	    setClientDocuments();
		 var id = $(".upload_documents").attr('data-related'); 
			$('.fixed_right_box').addClass('active');
			    $("div.add_inner_box").each(function(){
			        $(this).hide();
			        if($(this).attr('id') == id) {
			            $(this).show();
			        }
			    });	
	 }
   function generateEstimate(){
	   var saleno=$("#ConvertInvoiceSaleNo").val();
	   getOrderAndDueAmount1(saleno);
	   setTotalSalesProduct(saleno);
	   setGeneratedEstimate();
		 var id = $(".generate_estimate").attr('data-related'); 
			$('.fixed_right_box').addClass('active');
			    $("div.add_inner_box").each(function(){
			        $(this).hide();
			        if($(this).attr('id') == id) {
			            $(this).show();
			        }
			    });	
	 }
function setTotalSalesProduct(saleno){
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
			$("#selectProduct").empty(); 
			var options="";			 
		 for(var j=0;j<len;j++){ 			
		 	var name=data[j]["name"];
		 	options+="<option value='"+name+"'>"+name+"</option>";	 
		 }
		 $("#selectProduct").append(options);
		 }}
	},
	complete : function(data){
		hideLoader();
	}});
}
   function  getOrderAndDueAmount1(estimateno){
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
			
			$("#Professional_Fee_GST1").html(pfftax+"%");
			$("#Government_Fee_GST1").html(govtax+"%");
			$("#service_Charges_GST1").html(servicetax+"%");
			$("#Other_Fee_GST1").html(otrtax+"%");
			
			},
			complete : function(data){
				hideLoader();
			}
		});
	}
 function fillEstimateInvoiceDetails(saleno){
	 $(".ItemDetailList").remove();	
	 $("#TotalPriceWithoutGst").html('');
	 $("#TotalGstAmount").html('');
	 $("#TotalAmountWithGST").html('');
	 var discount=$("#ConvertEstimateDiscount").val();
	 $("#estimateDocList").empty();
	 $("#notesestimate").empty();
	 $("#notesestimate").append("<option value=''>Select Service</option>");
	 $.ajax({
			type : "POST",
			url : "GetEstimatePriceList111",
			dataType : "HTML",
			data : {				
				saleno : saleno
			},
			success : function(response){
			if(Object.keys(response).length!=0){
			response = JSON.parse(response);			
			 var len = response.length;
			 if(Number(len)>0){	
				 var k=1;		
				 var qtyborder="";
				 var totalProdQty=0; 
			 for(var i=0;i<len;i++){ 			
			 	var refid=response[i]["refid"];
				var name=response[i]["name"];		
				var date=response[i]["date"];
				var qty=response[i]["qty"];				
				
				var subitemdetails="subitemdetails"+i;
				totalProdQty=Number(totalProdQty)+Number(qty);
				
				if(k==1){
					var cregname=response[i]["cregname"];
					var cregaddress=response[i]["cregaddress"];
					var cregstate=response[i]["cregstate"];
					var cregstatecode=response[i]["cregstatecode"];
					var cregistin=response[i]["cregistin"];
					var subtotalprice=response[i]["subtotalprice"];
					var orderNo=response[i]["orderNo"];
					var purchaseDate=response[i]["purchaseDate"];
					
					if(orderNo!=null&&orderNo!="NA"&&orderNo!=""){$("#orderNo").html("#"+orderNo);$("#orderNoMain").show();
					}else $("#orderNoMain").hide();
					
					if(purchaseDate!=null&&purchaseDate!="NA"&&purchaseDate!=""){$("#PurchaseDate").html(purchaseDate);$("#purchaseDateMain").show();
					}else $("#purchaseDateMain").hide();
					
					if(cregname!=null&&cregname!="NA"&&cregname!=""){$("#BillToId").html(cregname);} 
					if(cregistin!=null&&cregistin!="NA"&&cregistin!=""){
						$("#BillToGSTINId").html("GSTIN "+cregistin);$("#BillToGSTINId").show();
					}else{
						$("#BillToGSTINId").hide();
						}
					
					if(cregname!=null&&cregname!="NA"&&cregname!=""){ $("#ShipToId").html(cregname);}
					if(cregname!=null&&cregname!="NA"&&cregname!=""){ $("#ShipToAddressId").html(cregaddress);}
					if(cregname!=null&&cregname!="NA"&&cregname!=""){ $("#ShipToStateCode").html(cregstate+'('+cregstatecode+')');}
					$("#EstimateDate").html(date); k++;
// 					$("#EstimateSubTotal").val(Number(subtotalprice).toFixed(2));
					numberToWords("EstimateRupeesInWord",Math.round((Number(subtotalprice)-Number(discount))));					
				
					var invoiceNotes=response[i]["invoiceNotes"];
					if(invoiceNotes!=null&&invoiceNotes!="NA"){
						$("#invoiceNotes").html(invoiceNotes);
					}
					
				}else{
						qtyborder="border-top: 1px solid #ccc;";
					}
				
				$("#notesestimate").append("<option value='"+refid+"'>"+name+"</option>");
				
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
				
				$("#estimateDocList").append("<option value='"+refid+"'>"+name+"</option>");
				appendPriceList(refid,subitemdetails,i,discount);
				
			 }	 
			 
			 $("#TotalProductQuty").html(totalProdQty);
			 showAllTaxData(saleno);
			 setTimeout(function(){
			 	getDueAmount(saleno);
// 			 	var totalRate=Number($("#TotalPriceWithoutGst").html());
// 				 var totalGST=Number($("#TotalGstAmount").html());
// 				 var totalAmount=Number($("#TotalAmountWithGST").html());
				 var discount=Number($("#TotalAmountDiscount").html());
				 
// 				 $("#TotalPriceWithoutGst").html(numberWithCommas(totalRate));
// 				 $("#TotalGstAmount").html(numberWithCommas(totalGST));
// 				 $("#TotalAmountWithGST").html(numberWithCommas(totalAmount));
// 				 if(discount>0){
// 					 $("#TotalAmountDiscount").html(numberWithCommas(discount));
// 					 $(".totalDiscount").show();
// 				 }else{
// 					 $(".totalDiscount").hide();
// 				 }
				 
			 },1000);
			 
				}}
			}});	
 } 
function getDueAmount(saleno){
	$.ajax({
			type : "GET",
			url : "GetEstimateDueAmount111",
			dataType : "HTML",
			data : {				
				saleno : saleno,						
			},
			success : function(data){
				var x=data.split("#");
				 $("#TotalPriceWithoutGst").html(x[1]);
				 $("#TotalGstAmount").html(x[2]);
				 $("#TotalAmountWithGST").html(x[3]);
				 var discount=x[4];
				 if(Number(discount)>0){
					 $("#TotalAmountDiscount").html(numberWithCommas(discount));
					 $(".totalDiscount").show();
				 }else{
					 $(".totalDiscount").hide();
				 }
				if(x[0]!="fail"&&x[0]!=x[3]){					
					if(Number(x[0])<=0){						
						$("#PaymentPaidOrPartial").html("Paid");
						$( "#PaymentPaidOrPartial" ).css('margin-left','-43px');
						$("#BalanceDueAmount").hide();
					}else{
						$("#PaymentPaidOrPartial").html("Partial");
						$("#PaymentPaidOrPartial" ).css('margin-left','-48px');
						$("#BalanceDueAmount").show();
						$("#InvoivePaymentDue").html(numberWithCommas(x[0]));
					} 					
				}else{
					$("#PaymentPaidOrPartial").html("Due");
					$( "#PaymentPaidOrPartial" ).css('margin-left','-43px');
					var totalAmount=$("#TotalAmountWithGST").html();
					$("#InvoivePaymentDue").html(totalAmount);
				}
			}
		}); 
 }
 
function showAllTaxData(salesNo){
	$(".taxRemoveBox").remove();	
	 $.ajax({
			type : "POST",
			url : "GetEstimateTaxList111",
			dataType : "HTML",
			data : {				
				salesNo : salesNo,						
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
function appendPriceList(refid,subitemdetails,i,discount){
	setTimeout(function(){
		if(i==0)i=1;
	  $.ajax({
					type : "POST",
					url : "GetEstimateSubPriceList111",
					dataType : "HTML",
					data : {				
						refid : refid,						
					},
					success : function(data){
					if(Object.keys(data).length!=0){
						data = JSON.parse(data);			
					 var plen = data.length;
					 if(Number(plen)>0){	
// 						 var totalRate=Number($("#TotalPriceWithoutGst").html());
// 						 var totalGST=Number($("#TotalGstAmount").html());
// 						 var totalAmount=Number($("#TotalAmountWithGST").html());
						 
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
						var taxamt=Math.round(Number(cgstprice)+Number(sgstprice)+Number(igstprice));
						
												
// 						totalRate=Number(totalRate)+Number(price);
// 						totalGST=Number(totalGST)+Number(taxamt);
// 						totalAmount=Number(totalAmount)+Number(totalprice);				 
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
					 }
					 
// 					 $("#TotalPriceWithoutGst").html(totalRate.toFixed(2));
// 					 $("#TotalGstAmount").html(totalGST.toFixed(2));
// 					 $("#TotalAmountDiscount").html("- "+Number(discount).toFixed(2));
// 					 $("#TotalAmountWithGST").html((totalAmount-Number(discount)).toFixed(2));
					 }}
			}
			});		  
	},200*i);	
 }
 function editEstimateBox(){
	 showLoader();
	 $(".EstimateList1").remove();
	 $(".EstimateList2").remove();
	   fillAllEstimateProduct();
	   var id = $(".editinvconvt").attr('data-related'); 
		$('.fixed_right_box').addClass('active');
		    $("div.add_inner_box").each(function(){
		        $(this).hide();
		        if($(this).attr('id') == id) {
		            $(this).show();
		        }
		    });	
	hideLoader();
 }
 
   function convertInvoiceBox(){
	   $(".EstimatePaymentInnerId").remove();	
	   var estimateno=$("#ConvertInvoiceSaleNo").val();
	   var companyname=$("#ConvertInvoiceCompany").val();
       var clientrefid=$("#ConvertInvoiceClientrefid").val();
       var contactrefid=$("#ConvertInvoiceContactrefid").val();
       var estimateRefKey=$("#ConvertEstimateRefKey").val();
       let salesType=$("#ConvertEstimateSalesType").val();
       let status=$("#ConvertEstimateStatus").val();
       $("#UploadFormdata")[0].reset();
       if(status=="Invoiced"){
    	   let option="<option value=\"\">Payment Mode</option>"+
    		   "<option value=\"Online\" selected=\"selected\">Online</option>"+
    		   "<option value=\"Cash\">Cash</option>";
    	   $('#PaymentMode').empty();
    	   $('#PaymentMode').append(option);
       }else{
    	   let option="<option value=\"\">Payment Mode</option>"+
		   "<option value=\"Online\" selected=\"selected\">Online</option>"+
		   "<option value=\"Cash\">Cash</option>"+
		   "<option value=\"PO\">Purchase Order</option>";
	   $('#PaymentMode').empty();
	   $('#PaymentMode').append(option);
       }
       
       
	   $(".btnpay").show();
	   $("#AddPaymentModeuleId").show();
	   $(".hpayment").hide();
	   $(".btnclose").hide();
		  
	   $("#WhichPaymentFor").val(estimateno); 
	   $("#CompanyPaymentFor").val(companyname);
	   $("#ClientPaymentFor").val(clientrefid);
	   $("#ContactPaymentFor").val(contactrefid);
	   
	   getOrderAndDueAmount(estimateno);
	   fillAllSalesPayment(estimateno);	   
	   getPayType(estimateRefKey,estimateno);	   
	   setTotalSalesService(estimateno);
	   var id = $(".invconvt").attr('data-related'); 
		$('.fixed_right_box').addClass('active');
		    $("div.add_inner_box").each(function(){
		        $(this).hide();
		        if($(this).attr('id') == id) {
		            $(this).show();
		        }
		    });
	   $("#TransactionId").focus();		    
   }	

   function updatePrice(refid,TotalPriceId,PriceId,minprice,cgstpercent,sgstpercent,igstpercent,pricerefid,gstPriceId,
		   SaleProdQtyId,SubTotalPriceId){
		var price=$("#"+PriceId).val();
		var qty=$("#"+SaleProdQtyId).val();
		minprice=Number(minprice)*Number(qty);
		if(Number(price)>=Number(minprice)){
			var cgstprice=(Number(price)*Number(cgstpercent))/100;	
			cgstprice=Math.round(Number(cgstprice));
			var sgstprice=(Number(price)*Number(sgstpercent))/100;	
			sgstprice=Math.round(Number(sgstprice));
			var igstprice=(Number(price)*Number(igstpercent))/100;	
			igstprice=Math.round(Number(igstprice));
			price=Math.round(Number(price));
			showLoader();
		$.ajax({
			type : "POST",
			url : "UpdatePriceOfSalesProduct111",
			dataType : "HTML",
			data : {
				price : price,
				refid : refid,
				cgstprice : cgstprice,
				sgstprice : sgstprice,
				igstprice : igstprice,
				pricerefid : pricerefid
				},
			success : function(data){
				var x=data.split("#");
				if(x[0]=="pass"){
					document.getElementById("errorMsg1").innerHTML="Updated.";
					var taxamount=Math.round(Number(cgstprice)+Number(sgstprice)+Number(igstprice));
					$("#"+gstPriceId).val(taxamount);
					$("#"+TotalPriceId).val(Math.round(Number(price)+(Number(taxamount))));				
					$("#"+SubTotalPriceId).val(x[1]);	
				    $('.alert-show1').show().delay(3000).fadeOut();
				}else{
					document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";				
					$('.alert-show').show().delay(4000).fadeOut();
				}
				
			},
			complete : function(data){
				hideLoader();
			}
		});
		}else{
			document.getElementById("errorMsg").innerHTML="Not Permission to reduce price, You may only increase price !!";		
			$("#"+PriceId).val(minprice);	
			$('.alert-show').show().delay(3000).fadeOut();		
			setTimeout(function(){
			updatePriceRollback(refid,TotalPriceId,minprice,cgstpercent,sgstpercent,igstpercent,pricerefid,gstPriceId,SubTotalPriceId);
			},3000);	
		}
	}
 
   function updatePriceRollback(refid,TotalPriceId,price,cgstpercent,sgstpercent,igstpercent,pricerefid,gstPriceId,SubTotalPriceId){
		
			var cgstprice=(Number(price)*Number(cgstpercent))/100;	
			cgstprice=Number(cgstprice).toFixed(2);
			var sgstprice=(Number(price)*Number(sgstpercent))/100;	
			sgstprice=Number(sgstprice).toFixed(2);
			var igstprice=(Number(price)*Number(igstpercent))/100;	
			igstprice=Number(igstprice).toFixed(2);
		showLoader();	
		$.ajax({
			type : "POST",
			url : "UpdatePriceOfSalesProduct111",
			dataType : "HTML",
			data : {
				price : price,
				refid : refid,
				cgstprice : cgstprice,
				sgstprice : sgstprice,
				igstprice : igstprice,
				pricerefid : pricerefid
				},
			success : function(data){
				var x=data.split("#");
				if(x[0]=="pass"){					
					document.getElementById("errorMsg1").innerHTML="Payment Rollback successfully.";
					var taxamount=Number(cgstprice)+Number(sgstprice)+Number(igstprice);
					$("#"+gstPriceId).val(taxamount);
					$("#"+TotalPriceId).val(Number(price)+(Number(taxamount)));				
					$("#"+SubTotalPriceId).val(x[1]);	
				$('.alert-show1').show().delay(3000).fadeOut();
				}else{
					document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";				
					$('.alert-show').show().delay(4000).fadeOut();
				}				
			},
			complete : function(data){
				hideLoader();
			}
		});
		
	}
   
  function fillAllEstimateProduct(){	 
	  var estimateno=$("#ConvertInvoiceSaleNo").val();
	  $.ajax({
			type : "POST",
			url : "GetEstimateProductList111",
			dataType : "HTML",
			data : {				
				estimateno : estimateno,
			},
			success : function(response){
			if(Object.keys(response).length!=0){
			response = JSON.parse(response);			
			 var len = response.length;			 
			 if(Number(len)>0){	
				 $("#Convert_Product_Name").empty();	 
			 for(var i=0;i<len;i++){ 	
				var esrefid=response[i]["esrefid"];
				var prodname=response[i]["prodname"];	
				var prodrefid=response[i]["prodrefid"];	
				var prodtype=response[i]["prodtype"];
				var jurisdiction=response[i]["jurisdiction"];
				var central=response[i]["central"];
				var state=response[i]["state"];
				var global=response[i]["global"];
// 				console.log("prodname="+prodname);
				if(i==0){
					if(prodname=="Consultation Service"){
						$("#NewProductBtn").hide();
						$("#consultingTypeSales").hide();						
					}else{
						$("#NewProductBtn").show();
						$("#consultingTypeSales").show();
					}
					if(prodrefid!=null&&prodrefid!="NA")	
					appendJurisdiction(global,central,state,"Jurisdiction",jurisdiction);
					
					$("#Convert_Product_Name").append("<option value='"+prodname+"#"+esrefid+"'>"+prodname+"</option>");
					
					setProduct(esrefid,prodrefid);						
				}else{
					addMainNewProduct(esrefid,prodtype,prodrefid,prodname,i,central,state,global,jurisdiction);
				}
			 }
			 
			}}}
		});
  } 

 function openBackEditPage(){
	 var estimateno=$("#ConvertInvoiceSaleNo").val();
	 isInvoiceEditable(estimateno);	
 }
 function isInvoiceEditable(estimateno){
	 $(".EditEstimateButtonRemoveClass").remove();
	 $.ajax({
			type : "POST",
			url : "ShowAllRegPayment111",
			dataType : "HTML",
			data : {				
				estimateno : estimateno
			},
			success : function(response){		
			if(Object.keys(response).length!=0){	
			response = JSON.parse(response);			
			 var len = response.length;	
			 if(Number(len)>0){			   
				 $(".EditEstimateButtonRemoveClass").remove();
				 $("#Full_PayId").prop("disabled",true);
				 $("#Partial_PayId").prop("disabled",true);
				 $("#Milestone_PayId").prop("disabled",true);
				 $("#ManageEstimatePayTypeId").val("No");
				 $("#btnSubmit").attr("onclick","validatePayment(event)");
			 }}else{
				 $(''+
				 '<button type="button" class="editinvconvt EditEstimateButtonRemoveClass" data-related="edit_estimate" onclick="editEstimateBox()" style="margin-right: 1rem;">Edit Estimate</button>'
				 ).insertBefore('#EditEstimateButtonId');
				 $("#Full_PayId").prop("disabled",false);
				 $("#Partial_PayId").prop("disabled",false);
				 $("#Milestone_PayId").prop("disabled",false);
				 $("#ManageEstimatePayTypeId").val("Yes");						
				 $("#btnSubmit").attr("onclick","validatePayType()");
			 }	}			
		});
 }
 function confirmCheck(){
	$("#payTypeWarning").modal("hide"); 
	 $("#btnSubmit").attr("onclick","validatePayment(event)");
	 setTimeout(() => {
		 $("#btnSubmit").click(); 
	}, 100);
	 
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
// 		var pff=Number(x[2]).toFixed(2);
// 		var pffgst=Number(x[3]).toFixed(2);
// 		var gov=Number(x[4]).toFixed(2);
// 		var govgst=Number(x[5]).toFixed(2);
// 		var otr=Number(x[6]).toFixed(2);
// 		var otrgst=Number(x[7]).toFixed(2);
		
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
		
		if(Number(x[1])<=0){
			//hide add payment option
			$("#AddPaymentModeuleId,.btnpay").hide();
			$(".hpayment").show();
		}else{
			$("#AddPaymentModeuleId").show();
		}
		},
		complete : function(data){
			hideLoader();
		}
	});
}

function getAllSalesProduct(estimateno,estRefKey){
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetAllSalesProduct111",
		dataType : "HTML",
		data : {				
			estimateno : estimateno
		},
		success : function(response){		
		if(Object.keys(response).length!=0){	
		response = JSON.parse(response);			
		 var len = response.length;			 
		 if(Number(len)>0){		
			 $("#EstimateProductName").empty();
		for(var i=0;i<len;i++){		   
			var refKey = response[i]['refKey'];
			var name = response[i]['name'];		
			if(refKey==estRefKey){
				$("#EstimateProductName").append("<option value='"+refKey+"' selected='selected'>"+name+"</option>");
			}else{$("#EstimateProductName").append("<option value='"+refKey+"'>"+name+"</option>");}			
		}}}},
		complete : function(data){
			hideLoader();
		}
	});
}
function emiStatus(types){
	showLoader();
	 $.ajax({
		  method: "GET",
		  url: "/admin/emi-status",
		  data: {types:types}
		}).done(function( data ) {	
			hideLoader();
			$("#homeTable  tbody").empty();	
		    $("#homeTable  tbody").append(data);
	  }).fail(function(data){
		  hideLoader();
	  });
	}
function getPayType(estRefKey,estimateno){
// 	$(".payTypeRemove").remove();
// 	getAllSalesProduct(estimateno,estRefKey);
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetPayType111",
		dataType : "HTML",
		data : {				
			estimateno : estimateno
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
		
function setClientDocuments(){
	var estKey=$("#ConvertEstimateDocRefKey").val();
	$(".documentInnerId").remove();
	showLoader();
	var path="<%=azurePath%>";
	$.ajax({
		type : "GET",
		url : "GetEstimateDocument111",
		dataType : "HTML",
		data : {				
			estKey : estKey,						
		},
		success : function(data){	
		if(Object.keys(data).length!=0){
			data = JSON.parse(data);			
		 var len = data.length;
		 if(Number(len)>0){		 
		 for(var j=0;j<len;j++){ 			
		 	var date=data[j]["date"];
		 	var uploaddocname=data[j]["uploaddocname"];
		 	var docname=data[j]["docname"];
		 	var key=data[j]["key"];
		 	var fileInput="fileInputDoc"+(j+1);
		 	var download="";
		 	if(docname!="NA"&&docname!="")
		 		download='<a href="'+path+''+docname+'" download><i class="fas fa-download pointers" title="Download"></i></a>';
			
		 	$(''+
					  '<tr class="documentInnerId">'+
						 '<td>'+date+'</td>'+
						 '<td>'+uploaddocname+'</td>'+
						'<td>'+download+'<input id="'+fileInput+'" name="'+fileInput+'" type="file" onchange="uploadFile(\''+key+'\',\''+fileInput+'\')" style="display:none;" />'+
					       '<button onclick="openFileInput(\''+fileInput+'\');" style="border: none;background: #ffff;font-size: 14px;"><i class="fas fa-upload" title="Upload"></i></button>'+
					     '</td>'+
					  '</tr>'			 
					 ).insertBefore("#DocumentListAppendId");
	 		 
		 }
		 }}
	},
	complete : function(data){
		fillDocumentUploadHistory(estKey);
		hideLoader();
	}});
	
}

function setGeneratedEstimate(){
	var estKey=$("#ConvertEstimateRefKey").val();
	var path="<%=request.getContextPath()%>";
	$(".EstimatePaymentInnerId").remove();
	showLoader();
	$.ajax({
		type : "GET",
		url : "GetGeneratedEstimate111",
		dataType : "HTML",
		data : {				
			estKey : estKey,						
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
					  '<tr class="EstimatePaymentInnerId">'+
						 '<td>'+date+'</td>'+
						 '<td>'+invoice+'</td>'+
						 '<td>'+amount+'</td>'+
						'<td><a href="'+path+'/estimatereceipt-'+uuid+'.html" target="_blank"><i class="fa fa-file-text-o pointers" title="Invoice"></i></a></td>'+
					  '</tr>'			 
					 ).insertBefore("#GeneratedEstimate");
	 		 
		 }
		 }}
	},
	complete : function(data){
		hideLoader();
	}});
}

function fillAllSalesPayment(estimateno){
	//getting all sales payment details
	$.ajax({
		type : "POST",
		url : "ShowAllRegPayment111",
		dataType : "HTML",
		data : {				
			estimateno : estimateno
		},
		success : function(response){		
		if(Object.keys(response).length!=0){	
		response = JSON.parse(response);			
		 var len = response.length;	
		 if(Number(len)>0){
		var path="<%=domain%>";		
		for(var i=0;i<len;i++){		
			var srefid = response[i]['srefid'];
			var date = response[i]['date'];
			var saleno = response[i]['saleno'];
			var mode = response[i]['mode'];
			var transactionid = response[i]['transactionid'];
			var amount = response[i]['amount'];
			var status = response[i]['status'];
			var docname = response[i]['docname'];		
			var comment = response[i]['comment'];	
			var holdcomment = response[i]['holdcomment'];		
			var pymtstatusicon="fa fa-circle-o-notch";
			var pymttitle="Processing..";
			var pymtcolor="#42b0da;";
			if(status=="1"){
				comment="";
				pymtstatusicon="fa fa-check-circle-o";
				pymttitle="Approved";
				pymtcolor="#29ba29;";
			}else if(status=="3"){
				pymtstatusicon="fa fa-times-circle-o";
				pymttitle="Declined Reason : "+comment;
				pymtcolor="#d91f16;";
			}else if(status=="4"){
				pymtstatusicon="fa fa-stop-circle";
				pymttitle="Hold Reason : "+holdcomment;
				pymtcolor="#808080;";
			}
			var color="text-primary";
			if(docname==null||docname=="NA")color="text-danger";			
		 $(''+
				  '<tr class="EstimatePaymentInnerId">'+
					 '<td><i class="'+pymtstatusicon+'" style="color:'+pymtcolor+'" title="'+pymttitle+'"></i></td>'+
					 '<td>'+date+'</td>'+
					 '<td>'+saleno+'</td>'+
					 '<td>'+mode+'</td>'+
					 '<td>'+transactionid+'</td>'+
					 '<td>'+amount+'</td>'+
					 '<td><i class="far fa-file-alt '+color+' pointers" onclick="openReceipt(\''+path+'\',\''+docname+'\')"></i></td>'+
					 '<td><i class="fa fa-envelope-o pointers" title="Send Invoice" onclick="sendSlip(\''+path+'\',\''+srefid+'\',\''+saleno+'\',\''+amount+'\',\''+date+'\')"></i></td>'+
				  '</tr>'			 
				 ).insertBefore("#EstimatePaymentListId");
		}}}else{
			$(''+
					'<tr class="EstimatePaymentInnerId"><td class="text-center noDataFound text-danger">No Data Found</td></tr>'
		    ).insertBefore('#EstimatePaymentListId');
			}
		}
	});
}
function showTimelineBox(TimelineBoxId){
	if($('#'+TimelineBoxId).css('display') == 'none')
	{
		$("#"+TimelineBoxId).css('display','block');
	}	
}

function addInput(MainTimelineUnitId,TimelineBoxId,MainTimelineValueId,CurrentProdrefid,val,colname){
	$('#'+MainTimelineUnitId).val(val);
	$("#"+TimelineBoxId).hide();
	$("#"+MainTimelineValueId).prop('readonly',false);	
	$("#"+MainTimelineValueId).focus();
	updatePlan(CurrentProdrefid,val,colname);
}

function openReceipt(mainfolder,docname){
	if(docname.toLowerCase()=="na"){
		$("#warningDocument").modal("show");
	}else{
		window.open("<%=azurePath%>"+docname);
		}
}

function sendSlip(path,key,salesno,amount,date){
	showLoader(); 
	$.ajax({
			type : "POST",
			url : "IsSalesInvoiced111",
			dataType : "HTML",
			data : {				
				salesno : salesno
			},
			success : function(response){
				if(response=="pass"){
					var url=path+"slip-"+key+".html";
					openSendEmailBoxSlip(url,amount,date);
				}else{
					$("#warningPayment").modal("show");
				}
			},
			complete : function(data){
				hideLoader();
			}
	 });
}

function setProduct(pricerefid,prodrefid){
	fillTimePlan(pricerefid,"SaleProdQty","renewal","onetime","MainTimelineValue","MainTimelineUnit","ProductPeriod");		
	
	let priceStyle="";
	if(typeof prodrefid === "undefined"){
		priceStyle="style='display:none'"
	}
	$.ajax({
			type : "POST",
			url : "SetProductPriceList111",
			dataType : "HTML",
			data : {				
				pricerefid : pricerefid
			},
			success : function(response){
			if(Object.keys(response).length!=0){				
			$("#CurrentProdrefid").val(pricerefid);
			response = JSON.parse(response);
			 var len = response.length;		
				 $("#EstimateProductPrice").show();
				 $(".Estpricelist").remove();
				 $(".Estpricelist1").remove();
			 var subamount=0;			 
			for(var i=0;i<len;i++){
				var refid = response[i]['refid'];
				var pricetype = response[i]['pricetype'];
				var price = response[i]['price'];
				var minprice = response[i]['minprice'];
				var hsncode = response[i]['hsncode'];
				var cgstpercent = response[i]['cgstpercent'];
				var sgstpercent = response[i]['sgstpercent'];
				var igstpercent = response[i]['igstpercent'];
				var taxprice = response[i]['tax'];
				var totalprice = response[i]['totalprice'];
				var gstpercent=Number(cgstpercent)+Number(sgstpercent)+Number(igstpercent);
				var sn=$("#SalesProductIdQty").val();
				sn=Number(sn)+Number(1);
				var TaxId="TaxUId"+sn;
				var PriceId="PriceUId"+sn;
				var TotalPrice="TotalPriceUId"+sn;
				var gstPriceId="GstPriceUId"+sn;
				$("#SalesProductIdQty").val(sn);
				subamount=Number(subamount)+Number(totalprice);
				$(''+
				'<div class="clearfix bg_wht link-style12 Estpricelist" id="ConvertedPriceListId">'+
             '<div class="box-width25 col-xs-1 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border">'+(i+1)+'</p>'+
                  '</div>'+
              '</div>'+
              '<div class="box-width19 col-xs-1 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border" title='+pricetype+'>'+pricetype+'</p>'+
                  '</div>'+
              '</div>'+
              '<div class="box-width14 col-xs-1 box-intro-background">'+
                  '<div class="clearfix">'+																																																																																																	                                          
                  '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" style="height: 38px;margin-left: 2px;" value="'+price+'" id="'+PriceId+'" onchange="updatePrice(\''+refid+'\',\''+TotalPrice+'\',\''+PriceId+'\',\''+minprice+'\',\''+cgstpercent+'\',\''+sgstpercent+'\',\''+igstpercent+'\',\''+pricerefid+'\',\''+gstPriceId+'\',\'SaleProdQty\',\'SubTotalPriceId\')" onkeypress="return isNumberKey(event)"/></p>'+
                  '</div>'+
              '</div>'+    
              '<div class="box-width3 col-xs-1 box-intro-background">'+
              '<input type="text" name="'+TaxId+'" id="'+TaxId+'" value="'+gstpercent+' %'+'" class="form-control bdrnone" autocomplete="off" placeholder="Tax %" readonly="readonly">'+
				      '</div>'+
              '<div class="box-width14 col-xs-6 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border"><input type="text" class="form-control BrdNone" id="'+gstPriceId+'" style="height: 38px;margin-left: 2px;" value="'+taxprice+'" readonly="readonly"/></p>'+
                  '</div>'+
              '</div>'+
              '<div class="box-width14 col-xs-6 box-intro-background">'+
                  '<div class="clearfix">'+
                  '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" id="'+TotalPrice+'" value="'+totalprice+'" style="height: 38px;margin-left: 2px;" readonly="readonly"/></p>'+
                  '</div>'+
              '</div>'+ 
           '</div>').insertBefore('#PriceDropBox');				
			}
			$(''+
			'<div class="clearfix Estpricelist1">'+
         '<div class="box-width59 col-xs-6 box-intro-background">'+
             '<div class="clearfix" '+priceStyle+'><a href="javascript:void(0)" onclick="addNewPriceType(\'CurrentProdrefid\')"><u>+ Add Price</u></a></div>'+
         '</div>'+
			 '<div class="box-width26 col-xs-6 box-intro-background">'+
             '<div class="clearfix">'+
             '<p class="news-border justify_end">Total:</p>'+
             '</div>'+
         '</div>'+
         '<div class="box-width14 col-xs-6 box-intro-background">'+
             '<div class="clearfix">'+
             '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" id="SubTotalPriceId" value="'+subamount.toFixed(2)+'" style="height: 38px;margin-left: 2px;" readonly="readonly"/></p>'+
             '</div>'+
         '</div>'+ 
      '</div>').insertBefore('#PriceDropBoxSubAmount');			 	
			 }else{
				 document.getElementById('errorMsg').innerHTML ='Price not Listed , Please set price.';					
		 		    $('.alert-show').show().delay(4000).fadeOut();
			 }
			}
		});
}

function fillTimePlan(pricerefid,SaleProdQtyId,renewalid,onetimeid,MainTimelineValueId,MainTimelineUnitId,ProductPeriodId){	 
	$.ajax({
			type : "POST",
			url : "SetProductTimePlan111",
			dataType : "HTML",
			data : {				
				pricerefid : pricerefid
			},
			success : function(response){
				if(Object.keys(response).length!=0){
			response = JSON.parse(response);			
			 var len = response.length;			 
			 if(Number(len)>0){	
			 for(var i=0;i<len;i++){ 	
				var qty=response[i]["qty"];
				var plan=response[i]["plan"];
				var period=response[i]["period"];
				var time=response[i]["time"];
				if(period.toLowerCase()=="na")period="";
				if(time.toLowerCase()=="na")time="";
				$("#"+SaleProdQtyId).val(qty);
				if(plan=="OneTime"){$("#"+renewalid).prop('checked',false);$("#"+onetimeid).prop('checked',true);
				$("#"+MainTimelineValueId).val("");$("#"+MainTimelineUnitId).val("");
				}else if(plan=="Renewal"){
					$("#"+onetimeid).prop('checked',false);$("#"+renewalid).prop('checked',true);
					$("#"+MainTimelineValueId).val(time);$("#"+MainTimelineUnitId).val(period);$("#"+ProductPeriodId).show();
				}			
			 }
			}}}
		});
} 

/* $('.view_more').click(function(){
	$(this).addClass("active");
    $("#View_More_History1").slideToggle();
});*/

function openInvoiceSummary(salesNo,pageNo){
	$(".removeMainSummary").remove();
	  $.ajax({
			type : "POST",
			url : "GetEstimateSummary111",
			dataType : "HTML",
			data : {				
				salesNo : salesNo,
				pageNo : pageNo
			},
			success : function(response){
				if(Object.keys(response).length!=0){
			response = JSON.parse(response);			
			 var len = response.length;	
			 
			 if(Number(len)>0){					 
			 for(var i=0;i<len;i++){ 	
				var date=response[i]["date"];
				var remarks=response[i]["remarks"];
				var margin="style='margin-bottom: 10px;'";
				if(len==1){margin="";}
				$(''+
					'<div class="clearfix removeMainSummary" '+margin+'>'+
					'<span style="color: #aaa;">'+date+'</span><span style="margin-left: 65px;color: #aaa;">'+remarks+'</span>'+
					'</div>').insertBefore("#AppendMainEstimateSumary");
								
			 }
			}if(len!=3){
				$("#MoreViewButton").hide();
			}
			 
			}}
		});
}

function showEstimateSummary(){
	showLoader();
	var salesNo=$("#ConvertInvoiceSaleNo").val();
	
	var summaryId=$("#View_More_History").val();
	var pageNo=Number(summaryId)*3;
	
	 $.ajax({
			type : "POST",
			url : "GetEstimateSummary111",
			dataType : "HTML",
			data : {				
				salesNo : salesNo,
				pageNo : pageNo
			},
			success : function(response){	
			if(Object.keys(response).length!=0){
			response = JSON.parse(response);			
			 var len = response.length;	
			 
			 if(Number(len)>0){	
				 $('<div class="clearfix" id="View_More_History'+summaryId+'" style="display: none;"><div class="clearfix" id="AppendEstimateSumary'+summaryId+'"></div></div>').insertBefore("#AppendEstimateSumaryDynamic");
			 for(var i=0;i<len;i++){ 	
				var date=response[i]["date"];
				var remarks=response[i]["remarks"];
				
				$(''+
					'<div class="clearfix" style="margin-bottom: 12px;">'+
					'<span style="color: #aaa;">'+date+'</span><span style="margin-left: 65px;color: #aaa;">'+remarks+'</span>'+
					'</div>').insertBefore("#AppendEstimateSumary"+summaryId);
				
				
			 }			 
			 
			 $("#View_More_History").val(Number(summaryId)+1);
				$("#View_More_History"+summaryId).slideDown();
				if($("#MinimizeViewButton").is(":hidden")){
				$("#MinimizeViewButton").show();}
							 
			}if(len!=3){
				$("#MoreViewButton").hide();
				$("#MinimizeViewButton").css('margin-left','0px');
			}
			}else{
				$("#MoreViewButton").hide();			
				$("#MinimizeViewButton").css('margin-left','0px');			
			}
			},
			complete : function(msg) {
	            hideLoader();
	        }
		});	
	
	
}
function hideEstimateSummary(){
	showLoader();
	var summaryId=$("#View_More_History").val();
	summaryId=Number(summaryId)-1;
	$("#View_More_History"+summaryId).slideUp();
	setTimeout(function() { 
		$("#View_More_History"+summaryId).remove();
    }, 500); 
	$("#View_More_History").val(Number(summaryId));
	
	if(summaryId==1){
		$("#MinimizeViewButton").hide();
	}
	$("#MinimizeViewButton").css('margin-left','64px');
	$("#MoreViewButton").show();
	hideLoader();
}

$('.list_action_box').hover(function(){
	$(this).children().next().toggleClass("show");
}); 

$('.close_icon_btn').click(function(){
	$('.notify_box').hide();
});
$('.close_box').on( "click", function(e) { 
	$('.fixed_right_box').removeClass('active');
	$('.addnew').show();	
	});

$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var data=$(this).val();
	doAction(data,"dateRangeDoAction");
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
   var dateRangeDoAction="<%=dateRangeDoAction%>";
   if(dateRangeDoAction!="NA"){	  
	   $('input[name="date_range"]').val(dateRangeDoAction);
   }
});

function copyInvoiceLink(){
	showLoader();
	var estimateKey=$("#ConvertEstimateRefKey").val();

	var url = $(location).attr('href');
	var name="<%=domain%>";
	var index=url.indexOf(name);
	var domain=url.substring(0,Number(index));
	var urlText=$("#InvoiceUrl").val();
	var input=domain+name+"invoice-"+estimateKey+".html";
	$("#InvoiceUrl").val(input);
	  var copyText = document.getElementById("InvoiceUrl");
	  copyText.select();
	  copyText.setSelectionRange(0, 99999)
	  document.execCommand("copy");
	  $("#CopyLinkUrl").addClass('textCopied');
	  hideLoader();
}
function sendEstimateInvoice(){	
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
	var salesNo=$("#ConvertInvoiceSaleNo").val();
	var CC=emailCC;
	
	if(CC==null)CC="empty";
	CC+="";
	showLoader();
	$.ajax({
		type : "POST",
		url : "SendEstimateInvoice111",
		dataType : "HTML",
		data : {				
			emailTo : emailTo,
			CC : CC,
			emailSubject : emailSubject,
			emailBody : emailBody,
			salesNo : salesNo
		},
		success : function(response){		
			if(response=="pass"){
				document.getElementById('errorMsg1').innerHTML ='Invoice sent !!';					
				$('.alert-show1').show().delay(4000).fadeOut();
				
				$("#SendEmailWarning").modal("hide");
				$("#EmailSendedId").addClass('textCopied');
				$(''+
					'<div class="clearfix removeMainSummary">'+
					'<span style="color: #aaa;">'+date+'</span><span style="margin-left: 65px;color: #5757ea;">Invoive sended</span>'+
					'</div>').insertBefore("#AppendMainEstimateSumary");
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
	CKEDITOR.replace('EmailBody',{
	     height: 200
	});
	CKEDITOR.replace('ChatTextareaBoxReply',{
		   height:150
	   });
	CKEDITOR.replace('ChatTextareaBoxReply1',{
		   height:150
	   });
	$('#userInChat').select2({
		  placeholder: 'Select user to send notes..',
		  allowClear: true
	});
	
	$("#notesestimate").change(function(){
		$("#userInChat").empty();
		var estkey=$(this).val();
		if(estkey!=null&&estkey!="")
		$.ajax({
			type : "GET",
			url : "GetEstimateWorkingUser111",
			dataType : "HTML",
			data : {				
				estkey : estkey
			},
			success : function(response){
				$("#userInChat").append(response);	
			},
			complete : function(msg) {
	            hideLoader();
	            fillSalesTaskKey(estkey);
	        }
		});
	})
});
function fillSalesTaskKey(estkey){
	$(".contentInnerBox").remove();
	showLoader();
	$.ajax({
		type : "GET",
		url : "GetSalesTaskNotes111",
		dataType : "HTML",
		data : {
			salesKey : "NA",
			estkey : estkey
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
function openSendEmailBoxSlip(url,amount,date){
	loadMultipleEmail();
	var clientEmail=$("#SendEmailClientEmail").val();
	$("#EmailTo").val(clientEmail);
	$("#EmailSubject").val("Payment Invoice");
	var clientName=$("#SendEmailClientName").val();
	var saleNo=$("#ConvertInvoiceSaleNo").val();
	var estimateKey=$("#ConvertEstimateRefKey").val();
	var domainName="<%=domain%>";
	$("#sendEmailInvoiceHtml").html("Send Payment Invoice");
	
// 	var message="<p>Dear "+clientName+"</p><p>Download invoice of Estimate No.:"+saleNo+" by clicking <a href='"+url+"' target='_blank'>link</a></p><p>Thanks & Regard</p><p>Sales Team</p>";
	
	var message='<table border="0" style="margin:0 auto;min-width:700px;width:700px;font-size:15px;line-height: 20px;border-spacing: 0;font-family: sans-serif;">'
	+'<tr><td style="text-align: left ;background-color: #fff; padding: 15px 0; width: 50px">'
		+'<a href="#" target="_blank"><img src="https://www.corpseed.com/assets/img/logo.png"></a>'
		+'</td></tr>'
		+'<tr>'
		+'<td style="text-align: center;">'
		+'<h1>'+saleNo+'</h1>'
		+'<tr>'
		+'<td style="padding:70px 0 20px;color: #353637;">'
		+'Hi '+clientName+',</td></tr>'
		+'<tr>'
		+'<td style="padding: 10px 0;color: #353637;">' 
		+'<p>Thank you for contacting us. Your Estimate can be Viewed, Printed and Downloaded as PDF from the link below.' 
		+'</p>'
		+'</td></tr><tr>'
		+'<td style="padding: 15px 50px 30px;border: 15px solid #e5e5e5;text-align: center;">' 
		+'<h2 style="text-align: center;">Payment Updates</h2>'
		+'<p style="text-align:center">Rs. '+amount+'' 
		+'</p>'
		+'<p style="text-align:center">Estimate No. : '+saleNo+'' 
		+'</p>'
		+'<p style="text-align:center">Estimate Date : '+date+'' 
		+'</p>'
		+'<p style="margin-top:20px;"><a href="'+url+'" target="_blank" style="background-color: #2b63f9 ;text-decoration: none;color:#fff;padding: 10px 30px;border: 1px solid #2b63f9;border-radius:50px">View Invoice</a>'
		+'</td></tr>'
		+'<tr ><td style="text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;">'
		+'<b>Order no #547659906099</b><br>'
		+'<p>Address : Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>'
		+'</td></tr>' 
		+'</table>';
	
	CKEDITOR.instances.EmailBody.setData(message);
	$("#SendEmailWarning").modal("show");
}
function openSendEmailBox(date,amount){
	loadMultipleEmail();
	var clientEmail=$("#SendEmailClientEmail").val();
	$("#EmailTo").val(clientEmail);
	$("#EmailSubject").val("Estimate Invoice");
	var clientName=$("#SendEmailClientName").val();
	var saleNo=$("#ConvertInvoiceSaleNo").val();
	var estimateKey=$("#ConvertEstimateRefKey").val();
	var domainName="<%=domain%>";
	var url=domainName+"invoice-"+estimateKey+".html";
	$("#sendEmailInvoiceHtml").html("Send Estimate Invoice");
// 	var message="<p>Dear "+clientName+"</p><p>Download invoice of Estimate No.:"+saleNo+" by clicking <a href='"+url+"' target='_blank'>link</a></p><p>Thanks & Regard</p><p>Sales Team</p>";
	var message='<table border="0" style="margin:0 auto;min-width:700px;width:700px;font-size:15px;line-height: 20px;border-spacing: 0;font-family: sans-serif;">'
	+'<tr><td style="text-align: left ;background-color: #fff; padding: 15px 0; width: 50px">'
		+'<a href="#" target="_blank"><img src="https://www.corpseed.com/assets/img/logo.png"></a>'
		+'</td></tr>'
		+'<tr>'
		+'<td style="text-align: center;">'
		+'<h1>'+saleNo+'</h1>'
		+'<tr>'
		+'<td style="padding:70px 0 20px;color: #353637;">'
		+'Hi '+clientName+',</td></tr>'
		+'<tr>'
		+'<td style="padding: 10px 0;color: #353637;">' 
		+'<p>Thank you for contacting us. Your Estimate can be Viewed, Printed and Downloaded as PDF from the link below.' 
		+'</p>'
		+'</td></tr><tr>'
		+'<td style="padding: 15px 50px 30px;border: 15px solid #e5e5e5;text-align: center;">' 
		+'<h2 style="text-align: center;">Estimate Amount</h2>'
		+'<p style="text-align:center">Rs. '+amount+'' 
		+'</p>'
		+'<p style="text-align:center">Estimate No. : '+saleNo+'' 
		+'</p>'
		+'<p style="text-align:center">Estimate Date : '+date+'' 
		+'</p>'
		+'<p style="margin-top:20px;"><a href="'+url+'" target="_blank" style="background-color: #2b63f9 ;text-decoration: none;color:#fff;padding: 10px 30px;border: 1px solid #2b63f9;border-radius:50px">View Invoice</a>'
		+'</td></tr>'
		+'<tr ><td style="text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;">'
		+'<b>Order no #547659906099</b><br>'
		+'<p>Address : Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>'
		+'</td></tr>' 
		+'</table>';
	CKEDITOR.instances.EmailBody.setData(message);
	$("#SendEmailWarning").modal("show");
}

// AppendMainEstimateSumary
</script>	
<script>
function loadMultipleEmail(){	
	var contactKey=$("#ConvertInvoiceContactrefid").val();
	$("#EmailCC").empty();		
	
	var value=[];	

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
	  $('#Update_Super_User').select2({
	        placeholder: 'Select Super User',
	        allowClear: true
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
	var baseName="<%=azurePath%>";
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
			type : "estimate"
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
function downloadInvoices(){
	showLoader();
	var estimateKey=[];
	$(".checked:checked").each(function(){
		estimateKey.push($(this).val());
	});
	estimateKey+="";
	$.ajax({
		type : "POST",
		url : "<%=request.getContextPath()%>/download-estimate-invoices.html",
		dataType : "HTML",
		data : {estimateKey:estimateKey},
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
$(".btnpay").click(function(){
	 $(".btnpay").hide();
	  $("#AddPaymentModeuleId").hide();
	  $(".hpayment").show();
	  $(".btnclose").show();
	});
$(".btnclose").click(function(){
	 $(".btnclose").hide();
	  $(".hpayment").hide();
	  $("#AddPaymentModeuleId").show();
	  $(".btnpay").show();
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
	calculateTotalPayment('Professional_Fee','Government_Fee','Other_Fee','GSTApplyId','TotalPaymentId','service_Charges');
});	
$("#GSTApplyId1").click(function(){
	if($(this).prop('checked') == true){		
		$("#Professional_Fee_GST1").html($("#ProfessionalFeeTax").val()+"%");
		$("#Government_Fee_GST1").html($("#GovernmentFeeTax").val()+"%");
		$("#Other_Fee_GST1").html($("#OtherFeeTax").val()+"%");
		$("#GSTApplied").val("1");
	}else{
		$("#Professional_Fee_GST1").html("0%");
		$("#Government_Fee_GST1").html("0%");
		$("#Other_Fee_GST1").html("0%");
		$("#GSTApplied").val("0");
	}
	calculateTotalPayment('Professional_Fee1','Government_Fee1','Other_Fee1','GSTApplyId1','TotalPaymentId1','service_Charges1');
});
function calculateTotalPayment(Professional_Fee,Government_Fee,Other_Fee,GSTApplyId,TotalPaymentId,serviceChargeId){
	var pff=$("#"+Professional_Fee).val();
	var gov=$("#"+Government_Fee).val();
	var service=$("#"+serviceChargeId).val();
	var other=$("#"+Other_Fee).val();
		
	if($("#"+GSTApplyId).prop('checked') == true){
		var pfftax=$("#ProfessionalFeeTax").val();
		var govtax=$("#GovernmentFeeTax").val();
		var servicetax=$("#ServiceChargeTax").val();
// 		console.log("servicetax="+servicetax);
		var othertax=$("#OtherFeeTax").val();
		
		pff=Number(pff)+((Number(pff)*Number(pfftax))/100);
		gov=Number(gov)+((Number(gov)*Number(govtax))/100);
		service=Number(service)+((Number(service)*Number(servicetax))/100);
		other=Number(other)+((Number(other)*Number(othertax))/100);		
	}
	
	var totalAmount=Number(pff)+Number(gov)+Number(other)+Number(service);
	
	$("#"+TotalPaymentId).val(Math.round(Number(totalAmount)));
}
function showRemark(otherFee,Other_Fee_remark_Div){	
	if(otherFee!=null&&otherFee!=""&&Number(otherFee)>0){
		$("#"+Other_Fee_remark_Div).show();
	}else $("#"+Other_Fee_remark_Div).hide();
}
$("#selectProduct,#Service_Name").select2({
	placeholder:"Select Product"
});
function updateState(data,stateId){
	var x=data.split("#");
	var id=x[0];
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
					"field" : "estimatecontactname"
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
            	doAction(ui.item.value,'estimateContactAction');
            	location.reload();
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});
function appendJurisdiction(global,central,state,jurisdiction,jurisdictionData){
	 $("#"+jurisdiction).empty();
	 $.ajax({
			type : "GET",
			url : "GetJurisdiction111",
			dataType : "HTML",
			data : {
				global : global,
				central : central,
				state : state
			},
			success : function(data){	
				$("#"+jurisdiction).append(data);
				$("#"+jurisdiction).val(jurisdictionData);
			}
		});		 
}
function appendNewProductJurisdiction(prodrefid,jurisdictionId){
	$("#"+jurisdictionId).empty();
	showLoader();
	 $.ajax({
			type : "GET",
			url : "GetJurisdiction111",
			dataType : "HTML",
			data : {
				prodrefid : prodrefid,
				global : "NA",
				central : "NA",
				state : "NA"
			},
			success : function(data){	
				$("#"+jurisdictionId).append(data);
			},
			complete : function(data){
				hideLoader();
			}
		});		
}
function openFileInput(InputId){
	$("#"+InputId).click();
}
function uploadFile(docrefid,fileboxid){
	const fi=document.getElementById(fileboxid);
	if (fi.files.length > 0) {
		const fsize = fi.files.item(0).size; 
        const file = Math.round((fsize / 1024)); 
        
        // The size of the file. 
        if (file >= 49152) {  
            document.getElementById('errorMsg').innerHTML ='File too Big, Max File Size 48 MB !!';
            document.getElementById(fileboxid).value="";
 		    $('.alert-show').show().delay(4000).fadeOut();
        }else{
        	uploadFile1(docrefid,fileboxid);
        }	
	}	 
}
function uploadFile1(docrefid,fileboxid){
	var path=$("#"+fileboxid).val();
	var x=path.split(".");
	var len=x.length;	
	var i=Number(len)-1;

	var form = $(".upload-box")[0];
    var data = new FormData(form);
    data.append("docrefid",docrefid);
    data.append("docfileInputBoxId",fileboxid);
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
        	setClientDocuments();
    		$('.alert-show1').show().delay(3000).fadeOut();
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
	var estKey=$("#ConvertEstimateDocRefKey").val();
	var key=getKey(40);
	showLoader();
	$.ajax({
		type : "POST",
		url : "AddNewDocumentList111",
		dataType : "HTML",
		data : {				
			key : key,
			salesrefid : "NA",
			docname : docname,
			UploadBy : UploadBy,
			Remarks : Remarks,
			estKey : estKey
		},
		success : function(data){
			if(data=="pass"){
				$("#AddNewDocumentList").modal("hide");
				setClientDocuments();
				
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
function fillDocumentUploadHistory(estkey){
	$(".docHistory").remove();
	$.ajax({
		type : "POST",
		url : "GetDocumenHistoryByKey111",
		dataType : "HTML",
		data : {				
			salesrefid : "NA",
			estkey : estkey
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
				
				var docLink="<%=azurePath%>"+docName;
				
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
		}}
	});
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
function updateDocuments(data){
	$("#ConvertEstimateDocRefKey").val(data);
	setClientDocuments();
}
function showGstBox(){
	$("#showGSTModel").modal("show");
}   
function calculateGstAmount(){
	var originalCost=$("#gstAmount").val();
	var gst=$("#GstPercent").val();
// 	console.log("originalCost="+originalCost+"/gst="+gst);
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
function addNewPriceType(prodRefId){
	if(prodRefId!="NA"){
		var estKey=$("#"+prodRefId).val();
		 $.ajax({
			type : "GET",
			url : "GetPriceType111",
			dataType : "HTML",
			data : {
				estKey : estKey
			},
			success : function(data){
				$("#priceType").empty();
				$("#priceType").append(data);				
				
				$("#AddNewPriceEstKey").val(estKey);
				$("#addNewPriceType").modal("show");
			}
		});	//AddNewPriceEstKey	
		
	}else{
		var estKey=$("#AddNewPriceEstKey").val();  
		var priceType=$("#priceType").val();
	    var typePrice=$("#typePrice").val();
	    var typePriceHsn=$("#typePriceHsn").val();
		if(priceType==null||priceType==""){
			document.getElementById("errorMsg").innerHTML="Please select price type.";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if(typePrice==null||typePrice==""){
			document.getElementById("errorMsg").innerHTML="Please enter price.";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		
		$.ajax({
			type : "POST",
			url : "AddPriceType111",
			dataType : "HTML",
			data : {
				priceType : priceType,
				typePrice : typePrice,
				typePriceHsn : typePriceHsn,
				estKey : estKey
			},
			success : function(data){
				if(data=="pass"){
					$("#addNewPriceType").modal("hide");
					editEstimateBox();
				}else{
					document.getElementById("errorMsg").innerHTML="Something went wrong, Please try-again later !!";
					$('.alert-show').show().delay(4000).fadeOut();
					return false;
				}
			}
		});
	}
}
function searchHSNCode(BoxId){
	$(function() {
		$("#"+BoxId).autocomplete({
			source : function(request, response) {
				if(document.getElementById(BoxId).value.trim().length>=1)
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
	            	$('.alert-show').show().delay(2000).fadeOut();
	            	$("#"+BoxId).val("");  
// 	            	$("#"+GstBoxId).val(""); 
	            }
	            else{              	
	            	$("#"+BoxId).val(ui.item.hsn);
// 	            	$("#"+GstBoxId).val(ui.item.igst+" %");
	            }
	        },
	        error : function(error){
				alert('error: ' + error.responseText);
			},
		});
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
function openTaskNotesBox(){
	$("#PublicSalesTaskFormId")[0].reset();
	$(".contentInnerBox").remove();
	var id = $(".estnotes").attr('data-related'); 
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
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
	var estrefid=$("#notesestimate").val();
	var userInChat=$("#userInChat").val();
	
	if(userInChat!=null&&userInChat.length>0){
		userInChat=$("#userInChat").val()+"";
	}
	
	if(estrefid==null||estrefid==""){
		alert("Please select service..");
		return false;
	}
	
	if(notes==null||notes.length<=0){
		alert("Please enter text..");
		return false;
	}
	showLoader();
	$.ajax({
		type : "POST",
		url : "SaveEstimateTaskNotes111",
		dataType : "HTML",
		data : {				
			estrefid : estrefid,
			notes : notes,
			type:"Team",
			userInChat:userInChat
		},
		success : function(data){
			$("#PublicSalesTaskFormId")[0].reset();
			$("#userInChat").empty();
			$(".communication_history").append(data);			
		},
		complete : function(msg) {
            hideLoader();
        }
	});
}
function validatePersonalNotes(){
	var notes=CKEDITOR.instances.ChatTextareaBoxReply1.getData();
	var estrefid=$("#notesestimate").val();
	if(estrefid==null||estrefid==""){
		alert("Please select service..");
		return false;
	}
	if(notes==null||notes.length<=0){
		alert("Please enter text..");
		return false;
	}
	showLoader();
	$.ajax({
		type : "POST",
		url : "SaveEstimateTaskNotes111",
		dataType : "HTML",
		data : {				
			estrefid : estrefid,
			notes : notes,
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

$(document).ready(function(){
	$("#estimateStatus").change(function(){
		var action=$(this).val();
		if(action!=null&&action!=""){
			$("#salesReasonHead").html("Estimate "+action+" Reason");
			$("#cancelSaleModal").modal("show");			
		}		
	})
})

function cancelSale(){
	var description=$("#cancelDescription").val();
	
	if(description==null||description==""){
		alert("Please enter text..");
		return false;
	}
	
	var action=$("#estimateStatus").val();
	
	var array = [];
	$("input:checkbox[id=checkbox]:checked").each(function(){
		array.push($(this).val());
	});
	
	$.ajax({
		type : "POST",
		url : "UpdateEstimateStatus111",
		dataType : "HTML",
		data : {	
			action:action,
			array:array+"",
			description:description
		},
		success : function(data){	
			location.reload();		
		},
		complete : function(data){
			hideLoader();
		}
	});
}
function showCancelReason(invoice){
	
	$.ajax({
		type : "GET",
		url : "GetEstimateCancelReason111",
		dataType : "HTML",
		data : {	
			invoice:invoice,
			"type":"estimate"
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
</script>
</body>
</html>