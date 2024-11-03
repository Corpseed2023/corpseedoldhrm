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
<title>Manage Delivery</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%if(!MD00){%><jsp:forward page="/login.html" /><%} %>
<%
String token=(String)session.getAttribute("uavalidtokenno");
String loginuID = (String) session.getAttribute("loginuID");	
String userroll= (String)session.getAttribute("emproleid");
String loginuaid = (String)session.getAttribute("loginuaid");
String userRole= (String)session.getAttribute("userRole");
String today=DateUtil.getCurrentDateIndianFormat1();

String deliveryDateRangeAction=(String)session.getAttribute("deliveryDateRangeAction");
if(deliveryDateRangeAction==null||deliveryDateRangeAction.length()<=0)deliveryDateRangeAction="NA";

String deliveryDoAction=(String)session.getAttribute("deliveryDoAction");
if(deliveryDoAction==null||deliveryDoAction.length()<=0)deliveryDoAction="All";

String deliveryInvoiceAction=(String)session.getAttribute("deliveryInvoiceAction");
if(deliveryInvoiceAction==null||deliveryInvoiceAction.length()<=0)deliveryInvoiceAction="NA";

String deliveryClientAction=(String)session.getAttribute("deliveryClientAction");
if(deliveryClientAction==null||deliveryClientAction.length()<=0)deliveryClientAction="NA";

String deliveryContactAction=(String)session.getAttribute("deliveryContactAction");
if(deliveryContactAction==null||deliveryContactAction.length()<=0)deliveryContactAction="NA";

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
String azure_path=properties.getProperty("azure_path");
String sort_url=domain+"managedelivery.html?page="+pageNo+"&rows="+rows;

//pagination end

%>

<div id="content">
<div class="main-content">
<div class="container-fluid">

<div class="clearfix"> 
<form name="RefineSearchenqu" onsubmit="return false" method="Post">
<div class="bg_wht clearfix mb10" id="SearchOptions">  
<div class="row">

<div class="col-md-5 col-sm-5 col-xs-9"> 
<select class="filtermenu minBoxWidth" name="tstatus" id="tstatus" onchange="doAction(this.value,'deliveryDoAction');location.reload();">
<option value="All" <%if(deliveryDoAction.equalsIgnoreCase("All")){ %>selected<%} %>>All Projects</option>
<option value="Active" <%if(deliveryDoAction.equalsIgnoreCase("Active")){ %>selected<%} %>>Active Projects</option>
<option value="Inactive" <%if(deliveryDoAction.equalsIgnoreCase("Inactive")){ %>selected<%} %>>Inactive Projects</option>
<option value="Cancelled" <%if(deliveryDoAction.equalsIgnoreCase("Cancelled")){ %>selected<%} %>>Cancelled Projects</option>
</select>
<button class="filtermenu taskapproveBox" title="Approval" data-related="task_approval"  style="width: 55px;" onclick="openTaskApproveBox()"><i class="far fa-thumbs-up" style="color: #4ac4f3;"></i>
</button><%if(approval>0){%>
<span class="homeNotification" style="position: absolute;margin-left: -8px;"><%=approval%></span><%} %>
</div>
<a href="javascript:void(0)" class="doticon"> <i class="fa fa-filter" aria-hidden="true"></i>Filter</a>
<div class="filtermmenu">
<div class="post" style="position:absolute;z-index:9">
   <div class="linee" style="margin-top: -1px;width:1350px;height:50px"></div>
</div>
<div class="col-md-7 col-sm-7 col-xs-12">
<div class="clearfix flex_box justify_end">  
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<p><input type="search" autocomplete="off" name="invoiceNo" id="InvoiceNo" <%if(!deliveryInvoiceAction.equalsIgnoreCase("NA")){%>onsearch="clearSession('deliveryInvoiceAction');location.reload();" value="<%=deliveryInvoiceAction %>"<%} %> title="Search by Invoice Number !" placeholder="Search by invoice no." class="form-control"/>
</p>
</div>
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<p><input type="search" name="contactName" id="ContactName" <%if(!deliveryContactAction.equalsIgnoreCase("NA")){ %>onsearch="clearSession('deliveryContactAction');location.reload();" value="<%=deliveryContactAction %>"<%} %> title="Search by Client Name !" placeholder="Client Name.." class="form-control"/>
</p>
</div>
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<p><input type="search" name="clientName" id="ClientName" <%if(!deliveryClientAction.equalsIgnoreCase("NA")){ %>onsearch="clearSession('deliveryClientAction');location.reload();" value="<%=deliveryClientAction %>"<%} %> title="Search by company name !" placeholder="Company name.." class="form-control"/>
</p>
</div>
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12 has-clear"> 
<p><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="FROM - TO" class="form-control text-center date_range pointers <%if(!deliveryDateRangeAction.equalsIgnoreCase("NA")){ %>selected<%} %>" readonly="readonly"/>
<span class="form-control-clear form-control-feedback" onclick="clearSession('deliveryDateRangeAction');location.reload();"></span>
</p>
</div>
</div>
</div>
</div>
</div>
</div>
<div class="row noDisplay" id="SearchOptions1">
<div class="col-md-5 col-sm-5 col-xs-12"> 
<div class="col-md-3">
<button type="button" class="filtermenu dropbtn" style="width: 90px;" data-toggle="modal" data-target="#ExportData">&nbsp;Export</button>
</div>
<div class="col-md-4">
<select class="form-control filtermenu" id="deliveryFilterStatus">
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
           <th class="sorting <%if(sort.equals("date")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','date','<%=order%>')">Sold Date</th>
           <th class="sorting <%if(sort.equals("invoice")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','invoice','<%=order%>')">Invoice</th>
           <th>Client</th>
           <th class="sorting <%if(sort.equals("client")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','client','<%=order%>')">Company</th>
           <th class="sorting <%if(sort.equals("project")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','project','<%=order%>')">Project's Name</th>
           <th class="sorting <%if(sort.equals("progress")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','progress','<%=order%>')">Progress</th>
<%--            <th class="sorting <%if(sort.equals("tags")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','tags','<%=order%>')">Tags</th> --%>
           <th>Assign Status</th>
           <th class="sorting <%if(sort.equals("status")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','status','<%=order%>')">Status</th>
           <th width="130" class="sorting <%if(sort.equals("assigned_to")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','assigned_to','<%=order%>')">Assigned To</th>
           <th class="sorting <%if(sort.equals("priority")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','priority','<%=order%>')">Priority</th>
           <th class="sorting">Advisory</th>
       </tr>
   </thead>
   <tbody>
   <%
   int ssn=0;
   int showing=0;
   int startRange=pageNo-2;
   int endRange=pageNo+2;
   int totalPages=1;
   
   String[][] teams=Enquiry_ACT.getAllTeams(token,loginuaid,userRole);  
   String[][] getAllSales=Enquiry_ACT.getAllDeliverySales(userRole,loginuaid,token,deliveryDoAction,deliveryInvoiceAction,deliveryDateRangeAction,deliveryClientAction,deliveryContactAction,pageNo,rows,sort,order);  
   int totalDelivery=Enquiry_ACT.countAllDeliverySales(userRole,loginuaid,token,deliveryDoAction,deliveryInvoiceAction,deliveryDateRangeAction,deliveryClientAction,deliveryContactAction);
   if(getAllSales!=null&&getAllSales.length>0){
	   ssn=rows*(pageNo-1);
		  totalPages=(totalDelivery/rows);
		  if((totalDelivery%rows)!=0)totalPages+=1;
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
   	String clientlocation=TaskMaster_ACT.getClientlocation(getAllSales[i][1], token);
   	boolean hierarchy=TaskMaster_ACT.isHierarchySet(getAllSales[i][3], token); 
   	String taskStatus="Assigned";
   	String taskClass="text-success";
   	int pending=0;
   	if(!getAllSales[i][18].equalsIgnoreCase("Unassigned"))
   		pending=TaskMaster_ACT.countUnassignedTask(getAllSales[i][0],token);
   	else
   		pending=TaskMaster_ACT.countSalesTask(getAllSales[i][0],token);
   	
   	if(pending!=0){
   		taskStatus=pending+" Unassigned";
   		taskClass="text-danger";
   	}
   	String soldby=Usermaster_ACT.getLoginUserName(getAllSales[i][11], token);
   	String actincolor="color: #fe0202;font-weight: 600;";
   	if(getAllSales[i][16].equalsIgnoreCase("Active"))actincolor="color: #17e314;font-weight: 600;";
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
    <td class="tg-cly1">
      <div class="line" style="position:relative;z-index:9;width:112px"></div>
    </td>
   
  </tr>
       <tr>
           <td><input type="checkbox" name="checkbox" id="checkbox" class="checked" value="<%=getAllSales[i][3] %>"></td>
           <td><%=getAllSales[i][12] %></td>
           <td><%=getAllSales[i][3] %></td>
           <td><%=getAllSales[i][21] %></td>
           <td><%=getAllSales[i][5] %></td>
           <td><a class="img_view assign_task_view position-relative" href="<%=request.getContextPath()%>/assignmytask-<%=getAllSales[i][0] %>.html"><span class="assign_task"><%=getAllSales[i][7] %></span>
			<%if(!getAllSales[i][20].equalsIgnoreCase("0")){ %><span class="homeNotification"><%=getAllSales[i][20] %></span><%} %></a></td>
           <td><%=getAllSales[i][14] %>&nbsp;%</td>
<%--            <td><input type="text" class="bdrnone" onchange="updateTags(this.value,'<%=getAllSales[i][0] %>')" value="<%if(!getAllSales[i][15].equalsIgnoreCase("NA")){ %><%=getAllSales[i][15] %><%} %>"></td> --%>
           <td class="<%=taskClass%>"><%=taskStatus %></td>
           <%if(!deliveryDoAction.equalsIgnoreCase("Cancelled")){ %>
           <td class="taskpriority pointers" data-related="task_priority" <%if(!hierarchy){ %>onclick="openSetHierarchy('<%=getAllSales[i][3] %>','<%=getAllSales[i][5] %>','<%=clientlocation%>','<%=getAllSales[i][7] %>')"<%}else if(hierarchy){ %>onclick="openFinalHierarchy('<%=getAllSales[i][3] %>','<%=getAllSales[i][5] %>','<%=clientlocation%>','<%=getAllSales[i][7] %>','<%=getAllSales[i][14] %>')"<%} %> style="<%=actincolor%>"><%=getAllSales[i][16] %></td>
           <%}else{ %><td><a href="javascript:void(0)" class="text-danger" onclick="showCancelReason('<%=getAllSales[i][3] %>')">Cancelled</a></td><%} %>
           <td>
           <span class="bg_circle relative_box filterBox_inner"><span id="<%=getAllSales[i][0] %>"><%=getAllSales[i][18] %></span><button type="button" class="editBtn"><img src="<%=request.getContextPath() %>/staticresources/images/edit_icon1.png" alt=""></button> 
			<%if(!deliveryDoAction.equalsIgnoreCase("Cancelled")){ %>
			<ul class="filterBox_dropdown">
			<%if(teams!=null&&teams.length>0){for(int j=0;j<teams.length;j++){ %>
			<li><a onclick="updateAssignTeam('<%=getAllSales[i][0] %>','<%=teams[j][1] %>','<%=teams[j][2] %>')" title="Click me to assign this project !!"><i class="fa fa-users" style="color: #4ac4f3;"></i>&nbsp;<%=teams[j][2] %></a></li>
			<%}} %>	
			</ul><%} %>
			</span>
           </td>
           <td>
           <span class="bg_circle relative_box filterBox_inner"><span id="ChatReplyPriority<%=i%>"><%=getAllSales[i][17] %></span><button type="button" class="editBtn"><img src="<%=request.getContextPath() %>/staticresources/images/edit_icon1.png" alt=""></button> 
			<ul class="filterBox_dropdown">
				<li><a onclick="updateProjectPriority('<%=getAllSales[i][0] %>','ChatReplyPriority<%=i%>','Low')">Low</a></li>
				<li><a onclick="updateProjectPriority('<%=getAllSales[i][0] %>','ChatReplyPriority<%=i%>','Normal')">Normal</a></li>
				<li><a onclick="updateProjectPriority('<%=getAllSales[i][0] %>','ChatReplyPriority<%=i%>','High')">High</a></li>
				<li><a onclick="updateProjectPriority('<%=getAllSales[i][0] %>','ChatReplyPriority<%=i%>','Urgent')">Urgent</a></li>
			</ul>
			</span>
           </td>
           <td><%=soldby %></td>
       </tr>
    <%}}%>
                           
    </tbody>
</table>
</div>
	<div class="filtertable">
  <span>Showing <%=showing %> to <%=ssn+getAllSales.length %> of <%=totalDelivery %> entries</span>
  <div class="pagination">
    <ul> <%if(pageNo>1){ %>
      <li class="page-item">	                     
      <a class="page-link text-primary" href="<%=request.getContextPath()%>/managedelivery.html?page=1&rows=<%=rows%>">First</a>
   </li><%} %>
    <li class="page-item">					      
      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/managedelivery.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
    </li>  
      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
	    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
	    <a class="page-link" href="<%=request.getContextPath()%>/managedelivery.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
	    </li>   
	  <%} %>
	   <li class="page-item">						      
	      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/managedelivery.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
	   </li><%if(pageNo<=(totalPages-1)){ %>
	   <li class="page-item">
	      <a class="page-link text-primary" href="<%=request.getContextPath()%>/managedelivery.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
	   </li><%} %>
	</ul>
	</div>
	<select class="select2" onchange="changeRows(this.value,'managedelivery.html?page=1','<%=domain%>')">
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
<div class="clearfix add_inner_box pad_box4 taskapproval" id="task_approval" style="width: 700px;">
<div class="close_icon close_box" style="right: 700px;"><i class="fa fa-times"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="far fa-thumbs-up"></i>Approve Task</h3>
<p>A Document Vault data room is a sophisticated tool for managing your documents online, offering the highest levels of security.
It can be used for due diligence in a wide range of applications, from selling or buying a company, to selling or buying a property,
to sharing information about customers and suppliers.</p>
</div>
<div class="menuDv pad_box4 clearfix ">
<div class="clearfix" id="AppendTaskApproveId"></div>
</div>
</div>


<div class="clearfix add_inner_box pad_box4 addcompany" id="task_priority" style="padding-top: 5px;">
<div class="close_icon close_box" onclick="deletePrintData()" id="TaskHierarchyFormTimes"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="task_lft_box">
<h3><span id="SalesHierarchyClientNameId"></span><%if(userroll.equals("Administrator")){ %>
<button class="btn btn-warning btn-reset" data-toggle="modal" data-target="#warningResetSales">Reset</button><%} %>
</h3>
<div class="row">
<div class="col-md-6 col-sm-8 col-xs-8">
<p><span id="SalesHierarchyInvoiceNoId"></span></p>
</div>
<div class="col-md-6 col-sm-4 col-xs-4">
<div class="location_box text-right">
<i><img src="<%=request.getContextPath() %>/staticresources/images/location_icon.png" alt=""></i><span><span id="SalesHierarchyLocationId"></span></span> 
</div>
</div>
</div>
</div>
<div id="paymentInstructions"></div>

<div class="drag_top_box pad10 pad_box3 box_shadow1 mbt20"> 
<div class="drag_box relative_box"> 
<div class="drag_elements droppable multipleChildren hasChild" id="SimilarInvoiceProductContainerId">

<div class="clearfix" id="SimilarInvoiceProductId"></div>

</div>
</div>
</div>
<div class="drag_bottom_box pad10 pad_box3 box_shadow1 relative_box"> 
<div class="pro_status_title clearfix">
<div class="pad0 col-md-6 col-sm-6 col-xs-12">
<div class="ps_date"><strong>Date</strong></div>
</div>
<div class="pad0 col-md-6 col-sm-6 col-xs-12">
<div class="ps_status"><strong>Project Status</strong></div>
</div>
</div>
<div class="pro_status_info clearfix">
<div class="pad0 col-md-6 col-sm-6 col-xs-12">

<div class="clearfix" id="SimilarInvoiceHierarchyDateId"></div>

</div>
<div class="pad0 col-md-6 col-sm-6 col-xs-12">
<div class="ps_status drop_elements">

<div class="clearfix" id="SimilarInvoiceHierarchyDesignId"></div>

</div>
</div>
</div>
</div>
<div class="row" id="FinalSubmitCancelBtn">
<div class="col-md-4 col-md-offset-4 inner_attachment">
    <div class="row mrt10"><button class="font15 form-control btn-primary btn-cancel close_box" type="button" onclick="deletePrintData()">Cancel</button></div>
</div>
<div class="col-md-4 inner_attachment">
<input type="hidden" id="SalesInvoiceFinalHierarchy" value="NA"/>
    <div class="row"><button class="font15 form-control btn-primary" type="button" onclick="return validateFinalSubmit('SalesInvoiceFinalHierarchy')">Final Hierarchy</button></div>
</div>
</div>
</div>
</div>
<div class="modal fade" id="warningResetSales" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span><span class="text-danger">
        Are you sure want to reset this project ?</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>  
	   <div class="modal-body">
        After reset all data will be erased.Make sure before reset !!.
      </div>       
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" style="width: 15%;">No</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal" style="width: 15%;" onclick="resetSalesHierarchy()">Yes</button>
      </div>
    </div>
  </div>
</div>
<div class="modal fade" id="warningUnHold" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span><span class="text-danger">Are you sure want to activate this project ?</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>          
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" style="width: 15%;">No</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal" style="width: 15%;" onclick="enableDisableSales('EDSalesRefid','EDSalesCircleid','EDSalesTimesid','1')">Yes</button>
      </div>
    </div>
  </div>
</div>
<div class="modal fade" id="warningHold" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span><span class="text-danger">Are you sure want to hold this project ?</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>    
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" style="width: 15%;">No</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal" style="width: 15%;" onclick="enableDisableSales('EDSalesRefid','EDSalesCircleid','EDSalesTimesid','2')">Yes</button>
      </div>
    </div>
  </div>
</div><div class="modal fade" id="warningFinalUnHold" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span><span class="text-danger">Are you sure want to activate this project ?</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>          
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" style="width: 15%;">No</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal" style="width: 15%;" onclick="enableDisableFinalSales('EDFinalSalesRefid','EDFinalHRefid','EDFinalSalesCircleid','EDFinalSalesTimesid','1')">Yes</button>
      </div>
    </div>
  </div>
</div>
<input type="hidden" id="ResetSalesHierarchy" value="NA">
<div class="modal fade" id="warningFinalHold" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span><span class="text-danger">Are you sure want to hold this project ?</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>    
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" style="width: 15%;">No</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal" style="width: 15%;" onclick="enableDisableFinalSales('EDFinalSalesRefid','EDFinalHRefid','EDFinalSalesCircleid','EDFinalSalesTimesid','2')">Yes</button>
      </div>
    </div>
  </div>
</div>
<div class="modal fade" id="ChangeTeamWarning" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span><span class="text-danger">Are you sure want to change team !! ?..</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
       <div class="modal-body warBody">
        <p style="font-size: 14px;">
        <span style="color: red;font-weight: 600;">Warning :- </span>
        <span>After Change this team, this project will hand over to new team and it will not able to access this project.
         </span></p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" style="width: 15%;">Cancel</button>
        <button type="button" class="btn btn-primary" style="width: 20%;" onclick="proceedToChangeTeam()">Proceed</button>
      </div>
    </div>
  </div>
</div>
<div class="modal fade" id="ApprovalTaskWarning" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span><span class="text-danger">Are you sure want to approve this task !! ?..</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
       <div class="modal-body warBody">
        <p style="font-size: 14px;">
        <span style="color: red;font-weight: 600;">Warning :- </span>
        <span>After approving this task, it will assign to assignee.
         </span></p>
      </div>
      <input type="hidden" id="ApproveAssignTaskKey">
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" style="width: 15%;">Cancel</button>
        <button type="button" class="btn btn-primary"  style="width: 20%;" onclick="approveTask('NA')">Proceed</button>
      </div>
    </div>
  </div>
</div>
<div class="modal fade" id="HoldTaskWarning" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span><span class="text-danger">Are you sure want to hold this task !! ?..</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div> 
      <input type="hidden" id="HoldAssignTaskKey">
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" style="width: 15%;">Cancel</button>
        <button type="button" class="btn btn-primary"  style="width: 20%;" onclick="holdTask('NA')">Proceed</button>
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
             	<option value="ms.msworkstatus as Service_Status" selected>Service Status</option>          	 
            	<option value="ms.msworkpercent as Work_Percent" selected>Progress</option>
            	<option value="ms.msremarks as Remarks">Remarks</option>            	
            	<option value="u.uaname as Sold_By" selected>Sold by</option>
            	<option value="ms.msworkpriority as Work_Priority">Work Priority</option> 
            	<option value="ms.msdeliveredon as Delivered_Date">Delivered_Date</option> 
            	<option value="ms.msinvoicenotes as Invoice_Notes">Invoice Notes</option> 
            	<option value="ms.msjurisdiction as Jurisdiction">Jurisdiction</option>
            	<option value="ms.msprojectstatus as Work_Status">Work Status</option> 
            	<option value="ms.msdeliverydate as Delivery_Date">Delivery Date</option>   
            	<option value="ms.msrefid as Assignee">Assignee</option>         
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
      <input type="hidden" id="EDSalesRefid" value="NA"/>    
       <input type="hidden" id="EDSalesCircleid" value="NA"/>   
        <input type="hidden" id="EDSalesTimesid" value="NA"/>   
        <input type="hidden" id="EDFinalSalesRefid" value="NA"/>  
        <input type="hidden" id="EDFinalHRefid" value="NA"/>    
       <input type="hidden" id="EDFinalSalesCircleid" value="NA"/>   
        <input type="hidden" id="EDFinalSalesTimesid" value="NA"/> 
        <input type="hidden" id="EDFinalSalesIsRelodable" value="0"/> 
        
        <input type="hidden" id="AssignSaleToTeamSaleKey" value="NA"/> 
        <input type="hidden" id="AssignSaleToTeamKey" value="NA"/> 
        <input type="hidden" id="AssignSaleToTeamName" value="NA"/> 
<div class="noDisplay"><a href="" id="DownloadExportedLink" download><button id="DownloadExported">Download</button></a></div>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script>
function RefineSearchenquiry() {
document.RefineSearchenqu.jsstype.value="SSEqury";
document.RefineSearchenqu.action="<%=request.getContextPath()%>/mytask.html";
document.RefineSearchenqu.submit();
}
</script>
<script type="text/javascript">
function holdTask(assignkey){
	if(assignkey=="NA"){
		assignkey=$("#HoldAssignTaskKey").val();
		showLoader();
		$.ajax({
			type: "GET",
			url : "<%=request.getContextPath()%>/ApproveThisTask111",		
			data : {
				assignkey : assignkey,
				"status" : "3"
				},
			success : function(data){
				if(data=="pass"){
					$("#"+assignkey).css("background","#f1efed")
					$("#HoldTaskWarning").modal("hide");
				}else{
					document.getElementById('errorMsg').innerHTML = 'Something went wrong, please try-again later.';
		    		$('.alert-show').show().delay(2000).fadeOut();
				}
							
			},
			complete : function(data){
				hideLoader();
			}
		});			
	}else{
		$("#HoldAssignTaskKey").val(assignkey);
		$("#HoldTaskWarning").modal("show");
	}
}
function approveTask(assignkey){
	if(assignkey=="NA"){
		assignkey=$("#ApproveAssignTaskKey").val();
		showLoader();
		$.ajax({
			type: "GET",
			url : "<%=request.getContextPath()%>/ApproveThisTask111",		
			data : {
				assignkey : assignkey,
				"status" : "1"
				},
			success : function(data){
				if(data=="pass"){
					$("#"+assignkey).remove();
					$("#ApprovalTaskWarning").modal("hide");
				}else{
					document.getElementById('errorMsg').innerHTML = 'Something went wrong, please try-again later.';
		    		$('.alert-show').show().delay(2000).fadeOut();
				}
							
			},
			complete : function(data){
				hideLoader();
			}
		});			
	}else{
		$("#ApproveAssignTaskKey").val(assignkey);
		$("#ApprovalTaskWarning").modal("show");
	}
}
function openTaskApproveBox(){
	$(".taskApproveList").remove();
	getApproveTaskList();
	var id = $(".taskapproveBox").attr('data-related'); 
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });	
}

function getApproveTaskList(){
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetApproveTask111",
		dataType : "HTML",
		data : {
		},
		success : function(response){		
		if(Object.keys(response).length!=0){
		response = JSON.parse(response);			
		 var len = response.length;	
		 var loginuaid="<%=loginuaid%>";
		for(var i=0;i<len;i++){	
			var key = response[i]['key'];
			var date = response[i]['date'];
			var projectNo = response[i]['projectNo'];
			var taskName = response[i]['taskName'];
			var assignedBy = response[i]['assignedBy'];
			var assignedTo = response[i]['assignedTo'];
			var teamAdminUid = response[i]['teamAdminUid'];
			var approveStatus = response[i]['approveStatus'];
			
			var actionContent="";
			if(loginuaid==teamAdminUid){
				actionContent="<span style='margin-right: 10px;font-size: 20px;color: #50b5dc;' onclick='approveTask(\""+key+"\")'><i class='fas fa-check pointers' title='Approve'></i></span><span style='font-size: 20px;color: #50b5dc;' onclick='holdTask(\""+key+"\")'><i class='fas fa-times text-danger pointers' title='Hold'></i></span>";
			}else{
				actionContent="";
			}
			var holdColor="";
			if(approveStatus=="3"){
				holdColor="style='background:#f1efed'";
			}else{
				holdColor="";
			}
			
			$(''+
			'<div class="clearfix taskApproveList" id="'+key+'" '+holdColor+'>'+
			'<div class="col-xs-2 box-intro-background box-width9">'+
			'<div class="clearfix">'+
			'<p class="news-border" title="Assign date : '+date+'">'+date+'</p>'+ 
			'</div> '+
			'</div>'+
			'<div class="col-xs-2 box-intro-background">'+
			'<div class="clearfix">'+
			'<p class="news-border" title="Project No. : '+projectNo+'">'+projectNo+'</p>'+ 
			'</div> '+
			'</div>'+
			'<div class="col-xs-3 box-intro-background">'+
			'<div class="clearfix">'+
			'<p class="news-border" title="Task Name : '+taskName+'">'+taskName+'</p> '+
			'</div> '+
			'</div>'+
			'<div class="col-xs-2 box-intro-background">'+
			'<div class="clearfix">'+
			'<p class="news-border" title="Assigned by : '+assignedBy+'">'+assignedBy+'</p>'+
			'</div>'+ 
			'</div>'+
			'<div class="col-xs-2 box-intro-background">'+
			'<div class="clearfix">'+
			'<p class="news-border" title="Assigned to : '+assignedTo+'">'+assignedTo+'</p>'+
			'</div>'+ 
			'</div>'+
			'<div class="col-xs-2 box-intro-background box-width5"> '+
			'<div class="clearfix"><p class="news-border">'+
			''+actionContent+''+
			'</p>'+
			'</div>'+
			'</div>'+
			'</div>'			
          ).insertBefore('#AppendTaskApproveId');
			
		}}else{
			$('<div class="text-center text-danger noDataFound taskApproveList">No. Data Found</div>').insertBefore('#AppendTaskApproveId');	
		}
		},
		complete : function(data){
			hideLoader();
		}
	});
}

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
function updateAssignTeam(salesrefid,teamrefid,teamname){
	var teamName=$("#"+salesrefid).html();	
	$("#AssignSaleToTeamSaleKey").val(salesrefid);
	$("#AssignSaleToTeamKey").val(teamrefid);
	$("#AssignSaleToTeamName").val(teamname);
	
	if(teamName=="Unassigned"){
		assignToTeam();
	}else if(teamName!=null&&teamName!=""){
		$("#ChangeTeamWarning").modal("show");
	}
}
function proceedToChangeTeam(){
	$("#ChangeTeamWarning").modal("hide");
	assignToTeam();
}
function assignToTeam(){
	showLoader();
	var salesrefid=$("#AssignSaleToTeamSaleKey").val();
	var teamrefid=$("#AssignSaleToTeamKey").val();
	var teamname=$("#AssignSaleToTeamName").val();
	
	if(salesrefid==null||salesrefid=="NA"||salesrefid=="")salesrefid="NA";
	if(teamrefid==null||teamrefid=="NA"||teamrefid=="")teamrefid="NA";
	if(teamname==null||teamname=="NA"||teamname=="")teamname="NA";
	if(salesrefid!="NA"&&teamrefid!="NA"&&teamname!="NA"){
	$.ajax({
		type: "POST",
		url : "<%=request.getContextPath()%>/AssignToTeam111",		
		data : {
			salesrefid : salesrefid,
			teamrefid : teamrefid,
			teamname : teamname
			},
		success : function(data){
			if(data=="pass"){
				document.getElementById('errorMsg1').innerHTML = 'Success.';
				$("#"+salesrefid).html(teamname);
	    		$('.alert-show1').show().delay(500).fadeOut();
			}else if(data=="assigned"){
				document.getElementById('errorMsg').innerHTML = 'This Project already assigned to this team !!.';
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
function validateFinalSubmit(InvoiceBoxId){
	var length=$("#SimilarInvoiceProductContainerId").children('div').length;
	if(Number(length)>1){
		document.getElementById('errorMsg').innerHTML = "Please set all product's hierarchy !!";
		$('.alert-show').show().delay(2000).fadeOut();
	}else{
	var invoiceno=$("#"+InvoiceBoxId).val();
	showLoader();
	$.ajax({
		type: "POST",
		url : "<%=request.getContextPath()%>/SubmitFinalSalesHierarchy111",		
		data : {
			invoiceno : invoiceno
			},
		success : function(data){		
			location.reload(true);
		/* 	if(data=="pass"){
				$('.fixed_right_box').removeClass('active');
				$('.addnew').show();	
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong, please try-again later.';
	    		$('.alert-show').show().delay(2000).fadeOut();
			} */
		},
		complete : function(data){
			hideLoader();
		}
	});	
	}
}
function updateTags(value,salesrefid){
	showLoader();
	$.ajax({
		type: "POST",
		url : "<%=request.getContextPath()%>/updateTags111",		
		data : {value : value,salesrefid : salesrefid},
		success : function(data){
			if(data=="pass"){
				document.getElementById('errorMsg1').innerHTML = '#Tags added.';
	    		$('.alert-show1').show().delay(2000).fadeOut();
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
$(function() {
	$("#projectname").autocomplete({
		source : function(request, response) {
			if(document.getElementById('projectname').value.trim().length>=1)
			$.ajax({
				url : "getprojectname.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					cid : "NA",
					col : "pregpname"
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
        		
            	$("#projectname").val("");
            }
            else{
            	$("#projectname").val(ui.item.value);
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

$(function() {
	$("#tname").autocomplete({
		source : function(request, response) {
			if(document.getElementById('tname').value.trim().length>=1)
			$.ajax({
				url : "gettaskname.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term					
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
        		
            	$("#tname").val("");
            }
            else{
            	$("#tname").val(ui.item.value);
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

$(function() {
$("#date").datepicker({
changeMonth: true,
changeYear: true,
dateFormat: 'dd-mm-yy'
});
});
$(function() {
	$("#ddate").datepicker({
	changeMonth: true,
	changeYear: true,
	dateFormat: 'dd-mm-yy'
	});
	});
</script>
<script type="text/javascript">
<%-- var counter=25;
$(window).scroll(function () {
    if ($(window).scrollTop() == $(document).height() - $(window).height()) {
//     	appendData();
    }
});

function appendData() {
    var html = '';
    if(document.getElementById("end").innerHTML=="End") return false;
    $.ajax({
    	type: "POST",
        url: '<%=request.getContextPath()%>/getmoretasks',
        datatype : "json",
        data: {
        	counter:counter,
        	projectname:'<%=projectname%>',
        	date:'<%=date%>',
        	ddate:'<%=ddate%>',
        	tname:'<%=tname%>',
        	userroll:'<%=userroll%>',
        	loginuaid:'<%=loginuaid%>',
        	tstatus:'<%=tstatus%>',
        	from:'<%=from%>',
        	to:'<%=to%>'
        	},
        success: function(data){        	
        	for(i=0;i<data[0].taskdata.length;i++){var sn=data[0].taskdata.length-i;
            	html += '<div class="row"><div class="col-md-12 col-sm-12 col-xs-12"><div class="clearfix"><div class="box-width1 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+sn+'</p></div></div><div class="box-width14 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].taskdata[i][1]+'</p></div></div><div class="box-width8 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].taskdata[i][2]+'</p></div></div><div class="box-width5 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].taskdata[i][3]+'</p></div></div><div class="box-width5 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].taskdata[i][5]+'</p></div></div><div class="box-width5 col-xs-12 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].taskdata[i][4]+'</p></div></div><div class="box-width2 col-xs-3 box-intro-background"><div class="link-style12"><p><a href="javascript:void(0);" onclick="vieweditpage1('+data[0].taskdata[i][0]+');"><i class="fa fa-comments"></i></a></p></div></div></div></div></div>';
        	}if(html!='') $('#target').append(html);
            else document.getElementById("end").innerHTML = "End";
        },
        error: function(error){
        	console.log(error.responseText);
        }
    });
    
    counter=counter+25;
} --%>
</script>
<script type="text/javascript">
function vieweditpage(id,page){
	showLoader();
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/vieweditpage",
	    data:  { 
	    	"uid" : id
	    },
	    success: function (response) {
	    	if(page=="view")    	window.location = "<%=request.getContextPath()%>/viewdetails.html";
	    	else if(page=="edit")    	window.location = "<%=request.getContextPath()%>/edittask.html"; 
        },
		complete : function(data){
			hideLoader();
		}
	});
} 

function openFinalHierarchy(salesInovice,clientName,clientLocation,prodName,workPercent){
	$("#SalesHierarchyClientNameId").html(clientName);
	$("#SalesHierarchyInvoiceNoId").html(salesInovice+" : "+prodName);
	$("#SalesHierarchyLocationId").html(clientLocation);
	$("#TaskHierarchyFormTimes").attr("onclick","isRelodable()");
	$("#FinalSubmitCancelBtn").hide();
	$(".removeDiv").remove();
	getAllFinalInvoice(salesInovice);
	$("#ResetSalesHierarchy").val(salesInovice);
	if(Number(workPercent)<100)
	$(".btn-reset").show();
	else $(".btn-reset").hide();
	var id = $(".taskpriority").attr('data-related'); 
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });	
}
function resetSalesHierarchy(){
	var invoice=$("#ResetSalesHierarchy").val();
	showLoader();
	$.ajax({
		type: "GET",
		url : "<%=request.getContextPath()%>/ResetSalesHierarchy111",		
		data : {
			invoice : invoice
			},
		success : function(data){		
			if(data=="pass"){
				document.getElementById('errorMsg1').innerHTML = 'Sales Hierarchy Reseted Successfully !!';
	    		$('.alert-show1').show().delay(4000).fadeOut();
	    		setTimeout(() => {
					location.reload(true);
				}, 4000);
			}else if(data=="permission"){
				document.getElementById('errorMsg').innerHTML = "You don't have permission to reset sale, Please Contact to admin !!.";
	    		$('.alert-show').show().delay(4000).fadeOut();
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong, please try-again later.';
	    		$('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function(data){
			hideLoader();
		}
	});	
}
function isRelodable(){
	var reload=$("#EDFinalSalesIsRelodable").val();
	if(Number(reload)==1){window.location='managedelivery.html';}	
}
function openSetHierarchy(salesinvoice,clientName,clientLocation,prodName){ 
	$("#SalesHierarchyClientNameId").html(clientName);
	$("#SalesHierarchyInvoiceNoId").html(salesinvoice+" : "+prodName);
	$("#SalesHierarchyLocationId").html(clientLocation);
	$("#TaskHierarchyFormTimes").attr("onclick","deletePrintData()");
	$("#SalesInvoiceFinalHierarchy").val(salesinvoice);
	$("#FinalSubmitCancelBtn").show();
	$(".removeDiv").remove();
	getAllSimilarInvoice(salesinvoice);
	$("#ResetSalesHierarchy").val("NA");
	$(".btn-reset").hide();
	var id = $(".taskpriority").attr('data-related'); 
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });		
}

function getAllFinalInvoice(salesinvoice){
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetAllFinalSalesHierarchyList111",
		dataType : "HTML",
		data : {				
			salesinvoice : salesinvoice		
		},
		success : function(response){			
		response = JSON.parse(response);			
		 var len = response.length;			
		 if(len>0){ 	
			 for(var i=0;i<Number(len);i++){	
			 	var hrefid=response[i]["hrefid"];
				var salesrefid=response[i]["salesrefid"];
				var htype=response[i]["htype"];
				var holdstatus=response[i]["holdstatus"];
				var hdate=response[i]["hdate"];
				var prodname=response[i]["prodname"];
				
				var InvoiceBox="InvoiceBox"+i;
				var CheckCircleId="CheckCircleId"+i;
				var TimeCircleId="TimeCircleId"+i;
				var dragBox="dragBox"+i;
				var circleDisp='style="display:none"';
				var timesDisp='style="display:none"';
				if(Number(holdstatus)==1){
					circleDisp='style="display:block"';
				}else if(Number(holdstatus)==2){
					timesDisp='style="display:block"';
				}
				$(''+
				'<div class="ps_date removeDiv">'+
				'<span>'+hdate+'</span>'+
				'</div>').insertBefore("#SimilarInvoiceHierarchyDateId");		
				
				if(Number(i)==0 && htype=="parent"){
					$(''+
							'<div class="dropElement droppable removeDiv dragEnter hasChild" id="'+dragBox+'">'+
							'<div class="dragBoxTitle dragElement removeDiv" id="'+InvoiceBox+'">'+
							'<span class="line_icon"><img src="<%=request.getContextPath() %>/staticresources/images/braille.png" alt=""></span>'+
							'<span class="task_title" title="'+prodname+'">'+prodname+'</span>'+
							'<span class="action_icon">'+
							'<i class="fa fa-check-circle pointers" '+circleDisp+' id="'+CheckCircleId+'" onclick="enableDisableFinalSalesModel(\''+salesrefid+'\',\''+hrefid+'\',\''+CheckCircleId+'\',\''+TimeCircleId+'\',\''+2+'\')"></i>'+
							'<i class="fa fa-times-circle pointers" '+timesDisp+' id="'+TimeCircleId+'"  onclick="enableDisableFinalSalesModel(\''+salesrefid+'\',\''+hrefid+'\',\''+CheckCircleId+'\',\''+TimeCircleId+'\',\''+1+'\')"></i></span>'+
							'</div>'+
					'</div>').insertBefore("#SimilarInvoiceHierarchyDesignId");
				}else{
					if(htype=="parent"){
					$(''+
							'<div class="dropElement droppable removeDiv" id="'+dragBox+'">'+
							'<div class="dragBoxTitle dragElement removeDiv" id="'+InvoiceBox+'">'+
							'<span class="line_icon"><img src="<%=request.getContextPath() %>/staticresources/images/braille.png" alt=""></span>'+
							'<span class="task_title" title="'+prodname+'">'+prodname+'</span>'+
							'<span class="action_icon">'+
							'<i class="fa fa-check-circle pointers" '+circleDisp+' id="'+CheckCircleId+'" onclick="enableDisableFinalSalesModel(\''+salesrefid+'\',\''+hrefid+'\',\''+CheckCircleId+'\',\''+TimeCircleId+'\',\''+2+'\')"></i>'+
							'<i class="fa fa-times-circle pointers" '+timesDisp+' id="'+TimeCircleId+'"  onclick="enableDisableFinalSalesModel(\''+salesrefid+'\',\''+hrefid+'\',\''+CheckCircleId+'\',\''+TimeCircleId+'\',\''+1+'\')"></i></span>'+
							'</div>'+
						'</div>'+
							'<div class="dropElement droppable arrow_up_box removeDiv" id="'+dragBox+'X">'+							
							'</div>').insertBefore("#SimilarInvoiceHierarchyDesignId");
					}else if(htype=="child"){
						$(''+
								'<div class="dropElement droppable removeDiv" id="'+dragBox+'"></div>'+
								'<div class="dropElement droppable arrow_up_box removeDiv dragEnter hasChild" id="'+dragBox+'X">'+
								'<div class="dragBoxTitle dragElement removeDiv" id="'+InvoiceBox+'">'+
								'<span class="line_icon"><img src="<%=request.getContextPath() %>/staticresources/images/braille.png" alt=""></span>'+
								'<span class="task_title" title="'+prodname+'">'+prodname+'</span>'+
								'<span class="action_icon">'+
								'<i class="fa fa-check-circle pointers" '+circleDisp+' id="'+CheckCircleId+'" onclick="enableDisableFinalSalesModel(\''+salesrefid+'\',\''+hrefid+'\',\''+CheckCircleId+'\',\''+TimeCircleId+'\',\''+2+'\')"></i>'+
								'<i class="fa fa-times-circle pointers" '+timesDisp+' id="'+TimeCircleId+'"  onclick="enableDisableFinalSalesModel(\''+salesrefid+'\',\''+hrefid+'\',\''+CheckCircleId+'\',\''+TimeCircleId+'\',\''+1+'\')"></i></span>'+
								'</div>'+
								'</div>').insertBefore("#SimilarInvoiceHierarchyDesignId");
					}
				}
			}
		 }
		},
		complete : function(data){
			hideLoader();
		}
	});
	
}

function getAllSimilarInvoice(salesinvoice){
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetAllSimilarSalesList111",
		dataType : "HTML",
		data : {				
			salesinvoice : salesinvoice		
		},
		success : function(response){			
		response = JSON.parse(response);			
		 var len = response.length;			
		 if(len>0){ 	
			 var date="<%=today%>";
			 for(var i=0;i<Number(len);i++){		
			 	var refid=response[i]["refid"];
				var name=response[i]["name"];
				var InvoiceBox="InvoiceBox"+i;
				var CheckCircleId="CheckCircleId"+i;
				var TimeCircleId="TimeCircleId"+i;
				var dragBox="dragBox"+i;
				$(''+
					'<div class="dragBoxTitle dragElement removeDiv" id="'+InvoiceBox+'" name="'+refid+'">'+
					'<span class="line_icon"><img src="<%=request.getContextPath() %>/staticresources/images/braille.png" alt=""></span>'+
					'<span class="task_title" title="'+name+'">'+name+'</span>'+
					'<span class="action_icon"><i class="fa fa-check-circle noDisplay pointers" id="'+CheckCircleId+'" onclick="enableDisableSalesModel(\''+refid+'\',\''+CheckCircleId+'\',\''+TimeCircleId+'\',\''+2+'\')"></i><i class="fa fa-times-circle noDisplay pointers" id="'+TimeCircleId+'"  onclick="enableDisableSalesModel(\''+refid+'\',\''+CheckCircleId+'\',\''+TimeCircleId+'\',\''+1+'\')"></i></span>'+
					'</div>').insertBefore("#SimilarInvoiceProductId");			
				$(''+
				'<div class="ps_date removeDiv">'+
				'<span>'+date+'</span>'+
				'</div>').insertBefore("#SimilarInvoiceHierarchyDateId");		
				
				if(Number(i)==0){
					$(''+
							'<div class="dropElement droppable removeDiv" id="'+dragBox+'" ondragend="printData(\'parent\',\''+i+'\',\''+dragBox+'\',\''+salesinvoice+'\')">'+
					'</div>').insertBefore("#SimilarInvoiceHierarchyDesignId");
				}else{
					var sn=i+"."+i;
					$(''+
							'<div class="dropElement droppable removeDiv" id="'+dragBox+'" ondragend="printData(\'parent\',\''+i+'\',\''+dragBox+'\',\''+salesinvoice+'\')"></div>'+
							'<div class="dropElement droppable arrow_up_box removeDiv" id="'+dragBox+'X"  ondragend="printData(\'child\',\''+sn+'\',\''+dragBox+'X\',\''+salesinvoice+'\')">'+
							'</div>').insertBefore("#SimilarInvoiceHierarchyDesignId");
				}			

				refreshDragover();
			}
		 }
		},
		complete : function(data){
			hideLoader();
		}
	});
	fillPaymentInstruction(salesinvoice);
}

function enableDisableFinalSalesModel(salesrefid,hrefid,circleid,timesid,status){
	$("#EDFinalSalesIsRelodable").val("1");
	$("#EDFinalSalesRefid").val(salesrefid);
	$("#EDFinalHRefid").val(hrefid);
	$("#EDFinalSalesCircleid").val(circleid);
	$("#EDFinalSalesTimesid").val(timesid);
	if(Number(status)==1){
		$("#warningFinalUnHold").modal("show");
	}else if(Number(status)==2){
		$("#warningFinalHold").modal("show");
	}
}
function enableDisableSalesModel(salesrefid,circleid,timesid,status){
	$("#EDSalesRefid").val(salesrefid);
	$("#EDSalesCircleid").val(circleid);
	$("#EDSalesTimesid").val(timesid);
	if(Number(status)==1){
		$("#warningUnHold").modal("show");
	}else if(Number(status)==2){
		$("#warningHold").modal("show");
	}
}
function enableDisableFinalSales(salesrefBoxid,hrefboxid,circleboxid,timesboxid,status){
	var salesrefid=$("#"+salesrefBoxid).val();
	var hrefid=$("#"+hrefboxid).val();
	var circleid=$("#"+circleboxid).val();
	var timesid=$("#"+timesboxid).val();
	showLoader();
	$.ajax({
		type: "POST",
		url : "<%=request.getContextPath()%>/EnableDisableFinalSales111",		
		data : {
			hrefid : hrefid,
			salesrefid : salesrefid,
			status : status
			},
		success : function(data){		
			if(data=="pass"){
				if(Number(status)==2){
					$("#"+circleid).hide();
					$("#"+timesid).show();
				}else if(Number(status)==1){
					$("#"+circleid).show();
					$("#"+timesid).hide();
				}
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong, please try-again later.';
	    		$('.alert-show').show().delay(2000).fadeOut();
			}
		},
		complete : function(data){
			hideLoader();
		}
	});
}
function enableDisableSales(salesrefboxid,circleboxid,timesboxid,status){
	var salesrefid=$("#"+salesrefboxid).val();
	var circleid=$("#"+circleboxid).val();
	var timesid=$("#"+timesboxid).val();
	showLoader();
	$.ajax({
		type: "POST",
		url : "<%=request.getContextPath()%>/EnableDisableVirtualSales111",		
		data : {
			salesrefid : salesrefid,
			status : status
			},
		success : function(data){		
			if(data=="pass"){
				if(Number(status)==2){
					$("#"+circleid).hide();
					$("#"+timesid).show();
				}else if(Number(status)==1){
					$("#"+circleid).show();
					$("#"+timesid).hide();
				}
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong, please try-again later.';
	    		$('.alert-show').show().delay(2000).fadeOut();
			}
		},
		complete : function(data){
			hideLoader();
		}
	});
}
function deletePrintData(){
	showLoader();
	$.ajax({
		type: "POST",
		url : "<%=request.getContextPath()%>/DeleteSalesHierarchyVirtual111",		
		data : {
			},
		success : function(data){		
		},
		complete : function(data){
			hideLoader();
		}
	});
}
function printData(type,numbering,dragBox,salesinvoice){
		
var salesrefid=$("#"+dragBox).children().attr("name");
var id=$("#"+dragBox).children().attr("id");
console.log("dragBox="+dragBox+"  =  "+salesrefid+"   id="+id+"   id value="+$("#"+id).attr("name"));

	showLoader();
	$.ajax({
		type: "POST",
		url : "<%=request.getContextPath()%>/SalesHierarchyVirtual111",		
		data : {
			salesrefid : salesrefid,
			type : type,
			numbering : numbering,
			salesinvoice : salesinvoice,
			},
		success : function(data){
			if(data=="pass"){	}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong, please try-again later.';
	    		$('.alert-show').show().delay(2000).fadeOut();
			}
		},
		complete : function(data){
			hideLoader();
		}
	});
	
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
<script>
function refreshDragover(){

(function(){
  //each droppable element needs this for its dragover event
  var allowDragover = function (event) {
    //prevent the browser from any default behavior
    event.preventDefault();
  },
  //each dragable element needs this for its dragstart event
  dragStartHandler = function (event) {
    var dragIcon = null;
    //set a reference to the element that is currenly being dragged
    event.originalEvent.dataTransfer.setData("id",event.target.id);
    //create a custom drag image
    dragIcon = document.createElement('img');
    dragIcon.src = 'staticresources/images/drag_img.png';
    //set the custom drag image
    event.originalEvent.dataTransfer.setDragImage(dragIcon, 30, 30); 
  },
  //each of the four light-brown boxes at top have this bound to their drop event
  dropHandlerSingle = function (event) {
    var id = '';
    //prevent the browser from any default behavior
    event.preventDefault();
    //only allow one child element at a time
    if($(this).children().length){return;}
    //get a reference to the element that is being dropped
    id = event.originalEvent.dataTransfer.getData("id");
    //add the hasChild class so that the UI can update
    $(event.target).addClass('hasChild');
    //trigger the custom event so that we can update the UI
    $(document).trigger('custom:dropEvent');
    //move the dragged element into the drop target
    event.target.appendChild(document.getElementById(id));
  },
  //the box that holds the four blue dragable boxes on page load has this bound to its drop event
  dropHandlerMultiple = function (event) {
    event.preventDefault();
    var id = event.originalEvent.dataTransfer.getData("id");
    $(event.target).addClass('hasChild');
    event.target.appendChild(document.getElementById(id));
    $(document).trigger('custom:dropEvent');
  };
  $(document).ready(function(){
    //cache a reference to all four blue draggable boxes
    var $dragElements = $('.dragElement');
    //make each dragElement draggable
    $dragElements.attr('draggable','true');
    //bind the dragStartHandler function to all dragElements
    $dragElements.bind('dragstart',dragStartHandler);
    //bind the dropHandlerSingle function to all of the droppable elements (omit the original container)
    $('.droppable').not('.multipleChildren').bind('drop',dropHandlerSingle);
    //bind the dropHandlerMultiple function to the .droppable.multipleChildren element
    $('.droppable.multipleChildren').bind('drop',dropHandlerMultiple);
    //after something is dropped
    $(document).on('custom:dropEvent',function(){
      //make sure the DOM has been updated
      setTimeout(function(){
        //check each droppable element to see if it has a child
        $('.droppable').each(function(){
          //if this element has no children
          if (!$(this).children().length){
            //remove the hasChild class
            $(this).removeClass('hasChild');
          }
        });
      },50);
    });
    //bind the appropriate handlers for the dragover, dragenter and dragleave events
    $('.droppable').bind({
      dragover: allowDragover,
      dragenter: function() {
        //ignore this event for the original container of the drag elements
        if ( $(this).hasClass('multipleChildren') ){return;}
        $(this).addClass('dragEnter');
      },
      dragleave: function() {
        $(this).removeClass('dragEnter');
      }
    });
  })
})();
}
</script>
<script type="text/javascript">
$( document ).ready(function() {
	   var dateRangeDoAction="<%=deliveryDateRangeAction%>";
	   if(dateRangeDoAction!="NA"){	  
		   $('input[name="date_range"]').val(dateRangeDoAction);
	   }
	});

$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var data=$(this).val();
	doAction(data,"deliveryDateRangeAction");
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
            	doAction(ui.item.value,'deliveryInvoiceAction');
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
					"field" : "deliveryclientname"
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
            	doAction(ui.item.value,'deliveryClientAction');
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
					"field" : "deliverycontactname"
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
            	doAction(ui.item.value,'deliveryContactAction');
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
			type : "Delivery"
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
function fillPaymentInstruction(salesinvoice){
	showLoader();
	$.ajax({
	    type: "GET",
	    url: "<%=request.getContextPath()%>/GetPaymentInstructions111",
	    data:  { 
	    	salesinvoice : salesinvoice
	    },
	    success: function (response) {
	    	$("#paymentInstructions").html(response);
        },
		complete : function(data){
			hideLoader();
		}
	});	
}
$(document).ready(function(){
	$("#deliveryFilterStatus").change(function(){
		var action=$(this).val();
		if(action!=null&&action!=""){
			var x="Cancelled";
			if(action=="2")x="Restore";
			$("#salesReasonHead").html("Sale "+x+" Reason");
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
	
	var action=$("#deliveryFilterStatus").val();
	
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
</script>
</body>
</html>