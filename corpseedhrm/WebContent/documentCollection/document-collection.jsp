<%@page import="commons.CommonHelper"%>
<%@page import="client_master.Clientmaster_ACT"%>
<%@page import="java.util.Properties"%>
<%@page import="commons.DateUtil"%>
<%@page import="admin.enquiry.Enquiry_ACT"%>
<%@page import="admin.task.TaskMaster_ACT"%>
<%@page import="admin.seo.SeoOnPage_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Manage Document Collection</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%if(!DOC00){%><jsp:forward page="/login.html" /><%} %>
<%
String token=(String)session.getAttribute("uavalidtokenno");
String loginuID = (String) session.getAttribute("loginuID");	
String userroll= (String)session.getAttribute("emproleid");
String loginuaid = (String)session.getAttribute("loginuaid");
String userRole= (String)session.getAttribute("userRole");
String loginName=(String)session.getAttribute("uaname");
String department=(String)session.getAttribute("uadepartment");
String reupload=request.getParameter("reupload");
String projectNumber="NA";
String invoice=request.getParameter("invoice");
if(invoice==null||invoice.length()<=0)invoice="NA";

if(reupload!=null&&reupload.length()>0)
	projectNumber=TaskMaster_ACT.getProjectNoByKey(reupload, token);


String today=DateUtil.getCurrentDateIndianFormat1();

String collectionDateRangeAction=(String)session.getAttribute("collectionDateRangeAction");
if(collectionDateRangeAction==null||collectionDateRangeAction.length()<=0)collectionDateRangeAction="NA";

String collectionDoAction=(String)session.getAttribute("collectionDoAction");
if(collectionDoAction==null||collectionDoAction.length()<=0)collectionDoAction="All";

String collectionInvoiceAction=(String)session.getAttribute("collectionInvoiceAction");
if(collectionInvoiceAction==null||collectionInvoiceAction.length()<=0)collectionInvoiceAction="NA";
if(!invoice.equalsIgnoreCase("NA"))collectionInvoiceAction=invoice;

String collectionClientAction=(String)session.getAttribute("collectionClientAction");
if(collectionClientAction==null||collectionClientAction.length()<=0)collectionClientAction="NA";

String collectionContactAction=(String)session.getAttribute("collectionContactAction");
if(collectionContactAction==null||collectionContactAction.length()<=0)collectionContactAction="NA";

String collectionUserUaid=(String)session.getAttribute("collectionUserUaid");
if(collectionUserUaid==null||collectionUserUaid.length()<=0)collectionUserUaid="NA";

// empty sales virtual hierarchy
TaskMaster_ACT.deleteSalesHierarchy(token,loginuID);

int approval=TaskMaster_ACT.getAllApproval(token);

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
String sort_url=domain+"document-collection.html?page="+pageNo+"&rows="+rows;

String country[][]=TaskMaster_ACT.getAllCountries();

//pagination end
String[][] documentExecutive=null;
String teamKey=Enquiry_ACT.findTeamKeyByUaid(token,"Document"); 
   if(teamKey!=null&&!teamKey.equalsIgnoreCase("NA"))
	   documentExecutive=Enquiry_ACT.findTeamMembers(teamKey,token);
   
   int totalCollection=Enquiry_ACT.countAllCollectionSales(token,collectionDoAction,collectionInvoiceAction,collectionDateRangeAction,collectionClientAction,collectionContactAction,userRole,loginuaid,collectionUserUaid);
   int assignedTotal=Enquiry_ACT.countAllAssignedSalesDocument(token,collectionDoAction,collectionInvoiceAction,collectionDateRangeAction,collectionClientAction,collectionContactAction,userRole,loginuaid,collectionUserUaid);
   int completedTotal=Enquiry_ACT.countAllCompletedSalesDocument(token,collectionDoAction,collectionInvoiceAction,collectionDateRangeAction,collectionClientAction,collectionContactAction,userRole,loginuaid,collectionUserUaid);
   int expiredTotal=Enquiry_ACT.countAllExpiredSalesDocument(token,collectionDoAction,collectionInvoiceAction,collectionDateRangeAction,collectionClientAction,collectionContactAction,userRole,loginuaid,collectionUserUaid);

%>

<div id="content">
<div class="main-content">
<div class="container-fluid">
<div class="box_shadow1 invoice_info redius_box pad_box4 bg_wht mb30">
 <div class="clearfix dashboard_info">
  <div class="pad0 col-md-3 col-sm-3 col-xs-6">
                    
   <div class="clearfix mlft20">
   <h3 title="18431147"><i class="fa fa-line-chart "></i>&nbsp;<%=totalCollection %></h3>
	<span>Total Sales</span>
   </div>
   </div>
   <div class="pad0 bdr_left col-md-3 col-sm-3 col-xs-6">
                                               
   <div class="clearfix mlft20">
    <h3><i class="fa fa-user-plus"></i>&nbsp;<%=assignedTotal %></h3>
	<span>Assigned</span>
    </div>
    </div>
    <div class="pad0 bdr_left col-md-3 col-sm-3 col-xs-6">
                                                     
	<div class="clearfix mlft20">
       <h3 title="6859659"><i class="fa fa-check-square-o "></i>&nbsp;<%=completedTotal %></h3>
		<span>Completed</span>
        </div>
	</div>
    <div class="pad0 bdr_left col-md-3 col-sm-3 col-xs-6">
                                                     
	<div class="clearfix mlft20">
	    <h3 title="264491"><i class="fa fa-exclamation-triangle"></i>&nbsp;<%=expiredTotal %></h3>
		<span>Expired</span>
	</div>
	</div>
    </div> 
</div>
<div class="clearfix"> 
<form name="RefineSearchenqu" onsubmit="return false" method="Post">
<div class="bg_wht clearfix mb10" id="SearchOptions">  
<div class="row">

<div class="col-md-5 col-sm-5 col-xs-9"> 
<select class="filtermenu minBoxWidth" name="tstatus" id="tstatus" onchange="doAction(this.value,'collectionDoAction');location.reload();">
<option value="All" <%if(collectionDoAction.equalsIgnoreCase("All")){ %>selected<%} %>>All Sales</option>
<option value="Assigned" <%if(collectionDoAction.equalsIgnoreCase("Assigned")){ %>selected<%} %>>Delivery Assigned</option>
<option value="Unassigned" <%if(collectionDoAction.equalsIgnoreCase("Unassigned")){ %>selected<%} %>>Delivery Unassigned</option><%if(userRole.equalsIgnoreCase("Admin")||userRole.equalsIgnoreCase("Manager")){ %>
<option value="DocumentAssigned" <%if(collectionDoAction.equalsIgnoreCase("DocumentAssigned")){ %>selected<%} %>>Document Assigned</option>
<option value="DocumentUnassigned" <%if(collectionDoAction.equalsIgnoreCase("DocumentUnassigned")){ %>selected<%} %>>Document Unassigned</option>
<option value="Cancelled" <%if(collectionDoAction.equalsIgnoreCase("Cancelled")){ %>selected<%} %>>Cancelled Projects</option><%} %>
<option value="Uploaded" <%if(collectionDoAction.equalsIgnoreCase("uploaded")){ %>selected<%} %>>Uploaded Documents</option>
<option value="Unuploaded" <%if(collectionDoAction.equalsIgnoreCase("Unuploaded")){ %>selected<%} %>>UnUploaded Documents</option>
<option value="ReUpload" <%if(collectionDoAction.equalsIgnoreCase("ReUpload")){ %>selected<%} %>>ReUpload Document</option><%if(userRole.equalsIgnoreCase("Admin")||userRole.equalsIgnoreCase("Manager")){ %>
<option value="Active" <%if(collectionDoAction.equalsIgnoreCase("Active")){ %>selected<%} %>>Active Sales</option>
<option value="Inactive" <%if(collectionDoAction.equalsIgnoreCase("Inactive")){ %>selected<%} %>>Inactive Sales</option><%} %>
<option value="Expired" <%if(collectionDoAction.equalsIgnoreCase("Expired")){ %>selected<%} %>>Expired Sales</option>
</select><%if(userRole.equalsIgnoreCase("Admin")||userRole.equalsIgnoreCase("Manager")){ %>
<select class="filtermenu mlft10 minBoxWidth" onchange="doAction(this.value,'collectionUserUaid');location.reload();">
<option value="">All</option>
<option value="<%=loginuaid%>" <%if(!collectionUserUaid.equalsIgnoreCase("NA")&&collectionUserUaid.equalsIgnoreCase(loginuaid)){ %>selected="selected"<%} %>>Self</option>
<%if(documentExecutive!=null&&documentExecutive.length>0){for(int i=0;i<documentExecutive.length;i++){%>
<option value="<%=documentExecutive[i][0]%>" <%if(!collectionUserUaid.equalsIgnoreCase("NA")&&collectionUserUaid.equalsIgnoreCase(documentExecutive[i][0])){ %>selected="selected"<%} %>><%=documentExecutive[i][1]%></option><%}} %>
</select><%} %>
</div>
<a href="javascript:void(0)" class="doticon"> <i class="fa fa-filter" aria-hidden="true"></i>Filter</a>
<div class="filtermmenu">
<div class="post" style="position:absolute;z-index:9">
 <div class="linee" style="margin-top: -1px;width:1350px;height:50px"></div>
</div>
<div class="col-md-7 col-sm-7 col-xs-12">
<div class="clearfix flex_box justify_end">  
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<p><input type="search" autocomplete="off" name="invoiceNo" id="InvoiceNo" <%if(!collectionInvoiceAction.equalsIgnoreCase("NA")){%>onsearch="clearSession('collectionInvoiceAction')" value="<%=collectionInvoiceAction %>"<%} %> title="Search by Invoice Number !" placeholder="Search by invoice no." class="form-control"/>
</p>
</div>
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<p><input type="search" name="contactName" id="ContactName" <%if(!collectionContactAction.equalsIgnoreCase("NA")){ %>onsearch="clearSession('collectionContactAction')" value="<%=collectionContactAction %>"<%} %> title="Search by Client Name !" placeholder="Client Name.." class="form-control"/>
</p>
</div>
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<p><input type="search" name="clientName" id="ClientName" <%if(!collectionClientAction.equalsIgnoreCase("NA")){ %>onsearch="clearSession('collectionClientAction')" value="<%=collectionClientAction %>"<%} %> title="Search by company name !" placeholder="Company name.." class="form-control"/>
</p>
</div>
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12 has-clear"> 
<p><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="FROM - TO" class="form-control text-center date_range pointers <%if(!collectionDateRangeAction.equalsIgnoreCase("NA")){ %>selected<%} %>" readonly="readonly"/>
<span class="form-control-clear form-control-feedback" onclick="clearSession('collectionDateRangeAction')"></span>
</p>
</div>
</div>
</div>
</div>
</div>
</div><%if(userRole.equalsIgnoreCase("Admin")||userRole.equalsIgnoreCase("Manager")){ %>
<div class="row noDisplay" id="SearchOptions1">
<div class="col-md-5 col-sm-5 col-xs-12"> 
<div class="col-md-3">
<button type="button" class="filtermenu dropbtn" style="width: 90px;" data-toggle="modal" data-target="#ExportData">&nbsp;Export</button>
</div>
<div class="col-md-4">
<select class="form-control filtermenu" id="collectionFilterStatus">
	<option value="">Action</option>	
	<option value="1">Cancel</option>
	<option value="2">Restore</option>
</select>
</div>
</div>
<div class="col-md-7 col-sm-7 col-xs-12 min-height50">
<div class="clearfix flex_box justify_end">
</div>
</div>
</div><%} %>
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
           <th class="sorting <%if(sort.equals("date")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','date','<%=order%>')">Sold Date</th>
           <th class="sorting <%if(sort.equals("invoice")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','invoice','<%=order%>')">Invoice</th>
           <th>Client</th>
           <th class="sorting <%if(sort.equals("client")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','client','<%=order%>')">Company</th>
           <th class="sorting <%if(sort.equals("project")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','project','<%=order%>')">Project's Name</th>
           <th width="100">Uploads</th><%if(userRole.equalsIgnoreCase("Manager")){ %>
           <th width="120" class="sorting <%if(sort.equals("document_assign")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','document_assign','<%=order%>')">Document</th><%} %>
           <th>Assigned On</th>
           <th>TAT</th>
           <th width="120" class="sorting <%if(sort.equals("assigned_to")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','assigned_to','<%=order%>')">Delivery Team</th>
           <th>Doc. Status</th>
           <th>Sales Person</th>
       </tr>
   </thead>
   <tbody>
   <%
   int ssn=0;
   int showing=0;
   int startRange=pageNo-2;
   int endRange=pageNo+2;
   int totalPages=1; 
         
   String[][] deliveryManager=Enquiry_ACT.getAllDeliveryManager(token); 
      
   String[][] getAllSales=Enquiry_ACT.getAllCollectionSales(token,collectionDoAction,collectionInvoiceAction,collectionDateRangeAction,collectionClientAction,collectionContactAction,pageNo,rows,sort,order,userRole,loginuaid,collectionUserUaid);  
   
   if(getAllSales!=null&&getAllSales.length>0){
	   ssn=rows*(pageNo-1);
		  totalPages=(totalCollection/rows);
		  if((totalCollection%rows)!=0)totalPages+=1;
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
	   	String companyData[]=Clientmaster_ACT.getClientAddressByRefid(getAllSales[i][1], token);
	   	String docStatus=TaskMaster_ACT.findClientDocumentUploads(getAllSales[i][0], token,1);
	   	String soldby=Usermaster_ACT.getLoginUserName(getAllSales[i][11], token);
	   	
	   	String documentStatus="Active";
	   	String docClass="text-success";
	   	if(getAllSales[i][26].equals("2")){documentStatus="Inactive";docClass="text-danger";}
	   	else if(getAllSales[i][26].equals("3")){documentStatus="Expired";docClass="text-dark";}
   %>
   <tr class="tg" style="position:absolute;width:100%;display:inline-table">
    <td class="tg-cly1">
      <div class="line"></div>
    </td>
    <td class="tg-cly1">
      <div class="line" style="position:relative;z-index:9;width:320px;height:25px"></div>
    </td>
    <td class="tg-cly1">
      <div class="line"></div>
    </td>
    <td class="tg-cly1">
      <div class="line"></div>
    </td>
    <td class="tg-cly1">
      <div class="line" style="position:relative;z-index:9;width:190px"></div>
    </td>
   
  </tr>
       <tr>
           <td><input type="checkbox" name="checkbox" id="checkbox" class="checked" value="<%=getAllSales[i][3] %>"></td>
           <td><%=getAllSales[i][12] %></td>
           <td><%=getAllSales[i][3] %></td>
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
           
           <%if(DTR00){ %><td><span class="clickeble assign_task taskhis" data-related="task_history" onclick="openTaskHistoryBox('<%=getAllSales[i][3] %>','<%=getAllSales[i][6] %>','<%=getAllSales[i][0] %>')"><%=getAllSales[i][7] %></span></td><%}else{ %>
           <td><%=getAllSales[i][7] %></td>
           <%} %>           
           <td><a class="adddoc pointers" data-related="add_document" onclick="openDocumentBox('<%=getAllSales[i][13] %>','<%=getAllSales[i][0] %>')"><%=docStatus %>&nbsp;</a><%if(getAllSales[i][24].equals("1")){ %><span class='small_notification'>&nbsp;</span><%} %></td>
           <%if(userRole.equalsIgnoreCase("Manager")){ %><td><span class="bg_circle relative_box filterBox_inner">
           <span id="doc<%=getAllSales[i][0] %>" title="<%=getAllSales[i][25] %>"><%=getAllSales[i][25] %></span><button type="button" class="editBtn"><img src="<%=request.getContextPath() %>/staticresources/images/edit_icon1.png" alt=""></button> 
			<ul class="filterBox_dropdown">
			<%if(documentExecutive!=null&&documentExecutive.length>0){for(int j=0;j<documentExecutive.length;j++){ %>
			<li><a onclick="updateDocumentAssign('<%=getAllSales[i][0] %>','<%=documentExecutive[j][0] %>','<%=documentExecutive[j][1] %>')" title="Click me to assign this service !!"><i class="fa fa-user" style="color: #4ac4f3;"></i>&nbsp;<%=documentExecutive[j][1] %></a></li>
			<%}%>
			<li><a onclick="updateDocumentAssign('<%=getAllSales[i][0] %>','<%=loginuaid %>','<%=loginName %>')" title="Click me to assign this service !!"><i class="fa fa-user" style="color: #4ac4f3;"></i>&nbsp;Self</a></li>
			<%} %>	
			</ul></span>
           </td><%} %> 
           <td><%if(!getAllSales[i][29].equalsIgnoreCase("NA")){%><%=getAllSales[i][29] %>&nbsp;<%=getAllSales[i][30] %><%}else{ %>Unassigned<%} %></td>
           <td><%=getAllSales[i][27] %>&nbsp;<%=getAllSales[i][28] %></td>          
           <td><%if(!collectionDoAction.equalsIgnoreCase("Cancelled")){ %>
            <span class="bg_circle relative_box filterBox_inner"><span id="<%=getAllSales[i][0] %>" title="<%=getAllSales[i][23] %>"><%=getAllSales[i][23] %></span><button type="button" class="editBtn"><img src="<%=request.getContextPath() %>/staticresources/images/edit_icon1.png" alt=""></button> 
			<ul class="filterBox_dropdown">
			<%if(deliveryManager!=null&&deliveryManager.length>0){for(int j=0;j<deliveryManager.length;j++){ %>
			<li><a onclick="updateAssignTeam('<%=getAllSales[i][0] %>','<%=deliveryManager[j][0] %>','<%=deliveryManager[j][1] %>')" title="Click me to assign this project !!"><i class="fa fa-users" style="color: #4ac4f3;"></i>&nbsp;<%=deliveryManager[j][1] %></a></li>
			<%}} %>	
			</ul></span><%}else{ %>
			<a href="javascript:void(0)" class="text-danger" onclick="showCancelReason('<%=getAllSales[i][3] %>')">Cancelled</a>
			<%} %>
           </td> 
           <td class="<%=docClass%>"><%=documentStatus %></td>   
           <td><%=soldby %></td>     
       </tr>
    <%}}%>
                           
    </tbody>
</table>
</div>
	<div class="filtertable">
  <span>Showing <%=showing %> to <%=ssn+getAllSales.length %> of <%=totalCollection %> entries</span>
  <div class="pagination">
    <ul> <%if(pageNo>1){ %>
      <li class="page-item">	                     
      <a class="page-link text-primary" href="<%=request.getContextPath()%>/document-collection.html?page=1&rows=<%=rows%>">First</a>
   </li><%} %>
    <li class="page-item">					      
      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/document-collection.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
    </li>  
      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
	    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
	    <a class="page-link" href="<%=request.getContextPath()%>/document-collection.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
	    </li>   
	  <%} %>
	   <li class="page-item">						      
	      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/document-collection.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
	   </li><%if(pageNo<=(totalPages-1)){ %>
	   <li class="page-item">
	      <a class="page-link text-primary" href="<%=request.getContextPath()%>/document-collection.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
	   </li><%} %>
	</ul>
	</div>
	<select class="select2" onchange="changeRows(this.value,'document-collection.html?page=1','<%=domain%>')">
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
<p id="end" style="display: none;"></p>
</div>
<div class="fixed_right_box">
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
     <button class="addbtn pointers addnew active" onclick="addSuperUser('Update_Super_User')" type="button">+ Add Super User</button>
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
</div>


<div class="modal fade" id="ChangeTeamWarning" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span><span class="text-danger">Are you sure want to change manager !! ?..</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
       <div class="modal-body warBody">
        <p style="font-size: 14px;">
        <span style="color: red;font-weight: 600;">Warning :- </span>
        <span>After Change this manager, this project will hand over to new manager and it will not able to access this project.
         </span></p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" style="width: 15%;">Cancel</button>
        <button type="button" class="btn btn-primary" style="width: 20%;" onclick="proceedToChangeTeam()">Proceed</button>
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
            	<option value="CONCAT(msinvoiceno,'') as Invoice" selected>Invoice</option>
            	<option value="CONCAT(msprojectnumber,'') as Project_Number" selected>Project No</option>
            	<option value="CONCAT(msproductname,'') as Service_Name" selected>Service Name</option>
            	<option value="CONCAT(mscompany,'') AS Company" selected>Company</option>
            	<option value="CONCAT(CONCAT(document_assign_date,' '),document_assign_time) as Assign_Date_Time" selected>Assign Date Time</option>
            	<option value="CONCAT(CONCAT(delivery_tat_date,' '),delivery_tat_time) as Delivery_Date_Time" selected>Delivery Date Time</option>            	
            	<option value="CONCAT(CONCAT(document_uploaded_date,' '),document_uploaded_time) as Delivered_Date" selected>Delivered Date</option>            	
            	<option value="CONCAT(document_assign_name,'') as Assignee" selected>Assignee</option>
            	<option value="CONCAT(CONCAT(tat_value,' '),tat_type) as TAT" selected>TAT</option>
            	<option value="CONCAT(msrefid,'') AS Delivery_TAT" selected>Delivery_TAT</option>
            	<option value="CONCAT(document_status,'') as Document_Status" selected>Status</option>
            	<option value="CONCAT(msrefid,'') as Uploaded" selected>Uploaded</option>
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
<input type="hidden" id="ManageSalesCompAddress">        
<input type="hidden" id="AssignSaleToTeamSaleKey" value="NA"/> 
<input type="hidden" id="AssignSaleToTeamUaid" value="NA"/> 
<input type="hidden" id="AssignSaleToTeamName" value="NA"/> 
<div class="noDisplay"><a href="" id="DownloadExportedLink" download><button id="DownloadExported">Download</button></a></div>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">

function updateProjectPriority(salesrefid,BoxId,Priority){
	showLoader();
	$.ajax({
		type: "POST",
		url : "<%=request.getContextPath()%>/UpdateSalesPriority111",		
		data : {
			salesrefid : salesrefid,
			Priority : Priority
			},
		success : function(data){
			if(data=="pass"){
				document.getElementById('errorMsg1').innerHTML = 'Priority set '+Priority;
				$("#"+BoxId).html(Priority);
	    		$('.alert-show1').show().delay(1000).fadeOut();
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong, please try-again later.';
	    		$('.alert-show').show().delay(2000).fadeOut();
			}
		},
		complete : function(msg) {
            hideLoader();
        }
	});
}
function updateAssignTeam(salesrefid,teamuaid,teamname){
	var teamName=$("#"+salesrefid).html();	
	$("#AssignSaleToTeamSaleKey").val(salesrefid);
	$("#AssignSaleToTeamUaid").val(teamuaid);
	$("#AssignSaleToTeamName").val(teamname);
	
	if(teamName=="Unassigned"){
		assignToTeam();
	}else if(teamName!=null&&teamName!=""){
		$("#ChangeTeamWarning").modal("show");
	}
}

function updateDocumentAssign(salesKey,uaid,name){
	showLoader();
	$.ajax({
		type: "POST",
		url : "<%=request.getContextPath()%>/AssignToDocument111",		
		data : {
			salesKey : salesKey,
			uaid : uaid,
			name : name,
			"teamKey" : "<%=teamKey%>"
			},
		success : function(data){
			if(data=="pass"){
				document.getElementById('errorMsg1').innerHTML = 'Successfully Assigned !!';
				$("#doc"+salesKey).html(name);
	    		$('.alert-show1').show().delay(500).fadeOut();
			}else if(data=="assigned"){
				document.getElementById('errorMsg').innerHTML = 'Service already assigned !!.';
	    		$('.alert-show').show().delay(4000).fadeOut();
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong, please try-again later.';
	    		$('.alert-show').show().delay(2000).fadeOut();
			}
		},
		complete : function(msg) {
            hideLoader();
        }
	});
}

function proceedToChangeTeam(){
	$("#ChangeTeamWarning").modal("hide");
	assignToTeam();
}
function assignToTeam(){
	showLoader();
	var salesrefid=$("#AssignSaleToTeamSaleKey").val();
	var teamuaid=$("#AssignSaleToTeamUaid").val();
	var teamname=$("#AssignSaleToTeamName").val();
	
	if(salesrefid==null||salesrefid=="NA"||salesrefid=="")salesrefid="NA";
	if(teamuaid==null||teamuaid=="NA"||teamuaid=="")teamuaid="NA";
	if(teamname==null||teamname=="NA"||teamname=="")teamname="NA";
	if(salesrefid!="NA"&&teamuaid!="NA"&&teamname!="NA"){
	$.ajax({
		type: "POST",
		url : "<%=request.getContextPath()%>/AssignToManager111",		
		data : {
			salesrefid : salesrefid,
			teamuaid : teamuaid,
			teamname : teamname
			},
		success : function(data){
			if(data=="pass"){
				document.getElementById('errorMsg1').innerHTML = 'Success.';
				$("#"+salesrefid).html(teamname);
	    		$('.alert-show1').show().delay(500).fadeOut();
			}else if(data=="assigned"){
				document.getElementById('errorMsg').innerHTML = 'This Project already assigned to this manager !!.';
	    		$('.alert-show').show().delay(4000).fadeOut();
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong, please try-again later.';
	    		$('.alert-show').show().delay(2000).fadeOut();
			}
		},
		complete : function(msg) {
            hideLoader();
        }
	});
	}else{
		document.getElementById('errorMsg').innerHTML = 'Something went wrong, please try-again later.';
		$('.alert-show').show().delay(2000).fadeOut();
	}
}

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
$('.list_action_box').hover(function(){
	$(this).children().next().toggleClass("show");
}); 
</script>

<script type="text/javascript">
$( document ).ready(function() {
	 var dateRangeDoAction="<%=collectionDateRangeAction%>";
	   if(dateRangeDoAction!="NA"){	  
		   $('input[name="date_range"]').val(dateRangeDoAction);
	   }
	});

$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var data=$(this).val();
	doAction(data,"collectionDateRangeAction");
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
	let invoice="<%=invoice%>";
	console.log("invoice="+invoice);
   $.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/ClearSessionData111",
	    data:  { 		    	
	    	data : data
	    },
	    success: function (response) {
	    	if(invoice!="NA"){
	    		let url=window.location.href;
	    		console.log(url);
	    		window.location.href=url.substring(0,url.indexOf("?"));
	    	}else location.reload();
        },
		complete : function(data){
			hideLoader();
		}
	});
}
$(function() {
	$("#InvoiceNo").autocomplete({
		source : function(request, response) {			
			$.ajax({
				url : "get-client-details.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					"field" : "docDalesInvoiceNo"
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
            	doAction(ui.item.value,'collectionInvoiceAction');
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
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					"field" : "docDeliveryclientname"
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
            	doAction(ui.item.value,'collectionClientAction');
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
			$.ajax({
				url : "get-client-details.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					"field" : "docDeliverycontactname"
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
            	doAction(ui.item.value,'collectionContactAction');
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
			type : "Collection"
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

$(document).ready(function(){
	$("#collectionFilterStatus").change(function(){
		var action=$(this).val();
		if(action!=null&&action!=""){
			var x="Cancelled";
			if(action=="2")x="Restore";
			$("#salesReasonHead").html("Sale "+x+" Reason");
			$("#cancelSaleModal").modal("show");			
		}		
	})
	let salesKeyReUpload="<%=reupload%>";
	let projectNoReUpload="<%=projectNumber%>";
	if(salesKeyReUpload!=null&&salesKeyReUpload.length>0&&projectNoReUpload!="NA"){
		openDocumentBox(projectNoReUpload,salesKeyReUpload);
	}
	$('#Update_Super_User').select2({
        placeholder: 'Select Super User',
        allowClear: true
    });
})
function cancelSale(){
	var description=$("#cancelDescription").val();
	
	if(description==null||description==""){
		alert("Please enter text..");
		return false;
	}
	
	var action=$("#collectionFilterStatus").val();
	
	var array = [];
	$("input:checkbox[id=checkbox]:checked").each(function(){
		array.push($(this).val());
	});
	
	$.ajax({
		type : "POST",
		url : "UpdateSalesCancelStatus111",
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
$('.add_new').on( "click", function(e) {
	$(this).parent().next().show();	
});
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
$('body').click(function() {
	$('.name_action_box').removeClass("active");
	$('.dropdown_list').removeClass("show");
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
// 			       console.log("superUserUaid=="+superUserUaid);
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
// 			console.log(data);
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
// 			console.log("data filled........");
// 			console.log(response);
			$("#"+selectId).empty();
			$("#"+selectId).append(response).trigger('change');
		}
	});
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
				var reupload=response[i]["reupload"];
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
				var notiIcon="";
				if(reupload=="1")notiIcon="<span class='small_notification'>&nbsp;</span>";
				var home="<%=docBasePath%>";
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
				       '<button onclick="openFileInput(\''+fileInput+'\');" style="border: none;background: #ffff;font-size: 14px;"><i class="fas fa-upload" title="Upload"></i>'+notiIcon+'</button>'+
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
				
				var docLink="<%=docBasePath%>"+docName;
				
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
function openFileInput(InputId){
	$("#"+InputId).click();
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
				var tat=response[i]["tat"];
				var consumed=response[i]["consumed"];
				var progressStatus=response[i]["progressStatus"];
				var progressColor="";
				var ccolor="red";
				if(tat.toUpperCase()===consumed.toUpperCase())ccolor="green";
				
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
	                  '<div class="col-sm-12">'+
	                    '<div class="row mbt5">TAT&nbsp;:&nbsp;<span style="color: blue;">'+tat+'</span>&nbsp;|&nbsp;Consumed&nbsp;:&nbsp;<span style="color: '+ccolor+';">'+consumed+'</span></div></div>'+
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
</script>
</body>
</html>