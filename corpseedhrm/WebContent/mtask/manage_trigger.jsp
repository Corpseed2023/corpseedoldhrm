<%@page import="java.util.Properties"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/> 
	<title>Manage Trigger</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	<%if(!MTR0){%><jsp:forward page="/login.html" /><%} 
	String token=(String)session.getAttribute("uavalidtokenno");
	
	String TriggerNameDoAction=(String)session.getAttribute("TriggerNameDoAction");
	if(TriggerNameDoAction==null||TriggerNameDoAction.length()<=0)TriggerNameDoAction="NA";

	String TriggerNoDoAction=(String)session.getAttribute("TriggerNoDoAction");
	if(TriggerNoDoAction==null||TriggerNoDoAction.length()<=0)TriggerNoDoAction="NA";

	String TriggerdateRangeDoAction=(String)session.getAttribute("TriggerdateRangeDoAction");
	if(TriggerdateRangeDoAction==null||TriggerdateRangeDoAction.length()<=0)TriggerdateRangeDoAction="NA";
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
	String sort_url=domain+"managetrigger.html?page="+pageNo+"&rows="+rows;

	String triggers[][]=TaskMaster_ACT.getAllTriggers(token,TriggerNameDoAction,TriggerNoDoAction,TriggerdateRangeDoAction,pageNo,rows,sort,order);
    int totalTrigger=TaskMaster_ACT.countAllTriggers(token,TriggerNameDoAction,TriggerNoDoAction,TriggerdateRangeDoAction);
    int activeTriggers=TaskMaster_ACT.countTrigger(token,TriggerNameDoAction,TriggerNoDoAction,TriggerdateRangeDoAction,1);
    int inactiveTriggers=TaskMaster_ACT.countTrigger(token,TriggerNameDoAction,TriggerNoDoAction,TriggerdateRangeDoAction,2);
	//pagination end
	
	%>
	<div id="content">		
		<div class="main-content">
		<div class="container">
				
		<div class="box_shadow1 invoice_info redius_box pad_box4 bg_wht mb30">
                      <div class="clearfix dashboard_info">
                        <div class="pad0 col-md-4 col-sm-4 col-xs-6">
                        <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:100px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div>
				   <div class="clearfix mlft20">
                          <h3><i class="fas fa-signal"></i> <%=totalTrigger %></h3>
					<span> Total Trigger</span>
				   </div>
                        </div>
                        <div class="pad0 bdr_left col-md-4 col-sm-4 col-xs-6">
                        <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:100px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div>
				   <div class="clearfix mlft20">
                          <h3><i class="far fa-check-circle"></i> <%=activeTriggers %> </h3>
					<span>Active Trigger</span>
                         </div>
				  </div>
                        <div class="pad0 bdr_left col-md-4 col-sm-4 col-xs-6">
                        <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:100px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div>
				   <div class="clearfix mlft20">
                          <h3><i class="far fa-times-circle"></i> <%=inactiveTriggers %></h3>
					<span>Inactive Trigger</span>
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
<div class="box-width8 dropdown"> 
<button type="button" class="filtermenu dropbtn addnew" style="width: 105px;" data-related="add_trigger" onclick="openTriggerBox()">+&nbsp;New trigger</button> 
</div>
</div>
<a href="javascript:void(0)" class="doticon"> <i class="fa fa-filter" aria-hidden="true"></i>Filter</a>
<div class="filtermmenu">
<div class="col-md-7 col-sm-7 col-xs-12">
<div class="clearfix flex_box justify_end"> 
<div class="col-md-4 item-bestsell col-sm-4 col-xs-12">
<p><input type="search" name="triggerName" id="SearchTriggerName" autocomplete="off" <% if(!TriggerNameDoAction.equalsIgnoreCase("NA")){ %>onsearch="clearSession('TriggerNameDoAction');location.reload();" value="<%=TriggerNameDoAction%>"<%} %> placeholder="Trigger name.." class="form-control"/></p>
</div>
<div class="col-md-4 item-bestsell col-sm-4 col-xs-12">
<p><input type="search" name="triggerNo" id="TriggerNo" autocomplete="off" <% if(!TriggerNoDoAction.equalsIgnoreCase("NA")){ %>onsearch="clearSession('TriggerNoDoAction');location.reload();" value="<%=TriggerNoDoAction%>"<%} %> placeholder="Trigger no..." class="form-control"/></p>
</div>
<div class="item-bestsell col-md-4 col-sm-4 col-xs-12 has-clear">
<p><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="FROM - TO" class="form-control text-center date_range pointers <%if(!TriggerdateRangeDoAction.equalsIgnoreCase("NA")){ %>selected<%} %>" readonly="readonly"/>
<span class="form-control-clear form-control-feedback" onclick="clearSession('TriggerdateRangeDoAction');location.reload();"></span>
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
						            <th width="100" class="sorting <%if(sort.equals("date")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','date','<%=order%>')">Date</th>
						            <th class="sorting <%if(sort.equals("trigger_no")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','trigger_no','<%=order%>')">Trigger No.</th>
						            <th class="sorting <%if(sort.equals("name")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','name','<%=order%>')">Name</th>
						            <th class="sorting <%if(sort.equals("description")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','description','<%=order%>')">Description</th>
						            <th width="200">Action</th>
						        </tr>
						    </thead>
						    <tbody>
						    <%
						    int ssn=0;
						    int showing=0; 
						    int startRange=pageNo-2;
						    int endRange=pageNo+2;
						    int totalPages=1;
						       
						    if(triggers!=null&&triggers.length>0){
	                        	   ssn=rows*(pageNo-1);
	                        		  totalPages=(totalTrigger/rows);
	                        		  if((totalTrigger%rows)!=0)totalPages+=1;
	                        		  showing=ssn+1;
	                        		  if (totalPages > 1) {     	 
	                        			  if((endRange-2)==totalPages)startRange=pageNo-4;        
	                        	          if(startRange==pageNo)endRange=pageNo+4;
	                        	          if(startRange<1) {startRange=1;endRange=startRange+4;}
	                        	          if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
	                        	          if(startRange<1)startRange=1;
	                        	     }else{startRange=0;endRange=0;}
	                        	   for(int i=0;i<triggers.length;i++){
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
						            <td><input type="checkbox" name="checkbox" id="checkbox" class="checked"></td>
						            <td><%=triggers[i][8] %></td>
						            <td><%=triggers[i][1] %></td>
						            <td><%=triggers[i][3] %></td>
						            <td><%=triggers[i][4] %></td>
						            <td>
						            <a class="img_view" data-toggle="modal" data-target="#productModal">
									<%if(triggers[i][9].equalsIgnoreCase("1")){ %>
									<i class="fas fa-thumbs-up" title="disable" onclick="enableDisable('<%=triggers[i][0] %>','2')">&nbsp;Disable</i>
									<%}else if(triggers[i][9].equalsIgnoreCase("2")){ %>
									<i class="fas fa-thumbs-down" title="enable" onclick="enableDisable('<%=triggers[i][0] %>','1')">&nbsp;Enable</i>
									<%} %>
									&nbsp;
									<i class="fas fa-edit text-primary updateTrigger" title="edit" data-related="update_trigger" onclick="editTrigger('<%=triggers[i][0] %>','<%=triggers[i][5] %>','<%=triggers[i][6] %>','<%=triggers[i][2] %>','<%=triggers[i][3] %>','<%=triggers[i][4] %>')">&nbsp;Edit</i>
									&nbsp;
									<i class="fas fa-trash text-danger" title="delete" onclick="deleteTrigger('<%=triggers[i][0] %>')">&nbsp;Delete</i>
									</a> 
						            </td>									
						        </tr>
						     <%}}%>
                                 
						    </tbody>
						</table>
						</div>
						<div class="filtertable">
						  <span>Showing <%=showing %> to <%=ssn+triggers.length %> of <%=totalTrigger %> entries</span>
						  <div class="pagination">
						    <ul> <%if(pageNo>1){ %>
						      <li class="page-item">	                     
						      <a class="page-link text-primary" href="<%=request.getContextPath()%>/managetrigger.html?page=1&rows=<%=rows%>">First</a>
						   </li><%} %>
						    <li class="page-item">					      
						      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/managetrigger.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
						    </li>  
						      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
							    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
							    <a class="page-link" href="<%=request.getContextPath()%>/managetrigger.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
							    </li>   
							  <%} %>
							   <li class="page-item">						      
							      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/managetrigger.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
							   </li><%if(pageNo<=(totalPages-1)){ %>
							   <li class="page-item">
							      <a class="page-link text-primary" href="<%=request.getContextPath()%>/managetrigger.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
							   </li><%} %>
							</ul>
							</div>
							<select class="select2" onchange="changeRows(this.value,'managetrigger.html?page=1','<%=domain%>')">
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

<%
String conditions[][]=TaskMaster_ACT.getAllConditions(); 
String actions[][]=TaskMaster_ACT.getAllActions(); 
%>
<div class="fixed_right_box">

<div class="clearfix add_inner_box pad_box4 addcompany" id="update_trigger" style="width: 680px;">
<div class="close_icon close_box" style="right: 680px;" onclick="clearVirtualTriggerCond()"><i class="fas fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-building-o"></i>Update Trigger</h3> 
<p>When someone reaches out to you, they become a contact in your account. You can create companies and associate contacts with them.</div>
<form onsubmit="return false;" id="UpdateNewTrigger">
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <select class="form-control bdrd4" id="Edit_Trigger_Module"> 	
 </select>
 </div>
 </div>
</div>
</div>
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="EditTriggerName" id="EditTriggerName" autocomplete="off" placeholder="Trigger Name" class="form-control bdrd4">
 </div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="EditTriggerDescription" autocomplete="off" id="EditTriggerDescription" placeholder="Trigger Description" onblur="" class="form-control bdrd4">
  </div>
  <div id="industryErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
<div class="clearfix" id="EditRefreshTrigger">
<div class="clearfix inner_box_bg">
<div class="clearfix" id="EditNewConditionRow"></div>
<div class="clearfix pointers mb10" style="color: #9e9797;" onclick="addAnotherRow('EditNewConditionRow','AddAnotherCondition','Edit_Trigger_Module')">Add another condition</div>

</div>
<div class="clearfix inner_box_bg">

<div class="clearfix" id="EditNewActionRow"></div>
<div class="clearfix pointers" style="color: #9e9797;display:none;" onclick="addAnotherActionRow('EditNewActionRow','Edit_Trigger_Module')" id="EditAnotherAction">Add another action</div>

</div>
</div>
<div class="clearfix mtop10 mb10 text-right"> 
<button class="bt-link bt-radius bt-gray mrt10 close_box" type="button" onclick="clearVirtualTriggerCond()">Cancel</button>
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateEditTrigger()">Update</button>
</div>
</form>                                  
</div>

<div class="clearfix add_inner_box pad_box4 addcompany" id="add_trigger" style="width: 680px;">
<div class="close_icon close_box" style="right: 680px;" onclick="clearVirtualTriggerCond()"><i class="fas fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-building-o"></i>New Trigger</h3> 
<p>When someone reaches out to you, they become a contact in your account. You can create companies and associate contacts with them.</div>
<form onsubmit="return false;" id="RegNewTrigger">
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <select class="form-control bdrd4" id="Trigger_Module" onchange="getConditionAction(this.value);">
 	<option value="">Select module</option>
 	<option value="Delivery">Delivery</option>
 	<option value="Milestone">Milestone</option>
 </select>
 </div>
 </div>
</div>
</div>
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="newproducttype" id="TriggerName" autocomplete="off" placeholder="Trigger Name" class="form-control bdrd4">
 </div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="newproductname" autocomplete="off" id="TriggerDescription" placeholder="Trigger Description" onblur="" class="form-control bdrd4">
  </div>
  <div id="industryErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
<div class="clearfix" id="RefreshTrigger">
<div class="clearfix inner_box_bg">
<div class="row">
<div class="box-width33 col-md-4 col-sm-12 col-xs-12">
<div class="form-group">
  <label>Condition :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <select class="form-control bdrd4" id="ConditionMain" onchange="showSubCondition('ConditionMain','ConditionSub','ConditionChild','NA');setConditionData(this.value,'0','tcConditionMain');">
  <option value="">Select condition</option>  
  </select>
  </div>
</div>
</div>
<div class="box-width33 col-md-4 col-sm-12 col-xs-12">
<div class="form-group">
  <label>&nbsp;</label>
  <div class="input-group">
 <select class="form-control bdrd4" id="ConditionSub" onchange="showChildCondition('ConditionMain','ConditionSub','ConditionChild','NA','ConditionChildText');setConditionData(this.value,'0','tcConditionSub');" style="display: none;">
 
 </select>
 </div>
</div>
</div>
<div class="box-width33 col-md-4 col-sm-12 col-xs-12">
<div class="form-group">
  <label>&nbsp;</label>
  <div class="input-group">
  <select class="form-control bdrd4" id="ConditionChild" onchange="setConditionData(this.value,'0','tcConditionChild');" style="display: none;"> 
 </select>
 <input type="text" class="form-control" name="ConditionChildText" onchange="setConditionData(this.value,'0','tcConditionChild');" id="ConditionChildText" style="display: none;" placeholder="Type here...">
  </div>
</div>
</div>
</div>

<div class="clearfix" id="AddNewConditionRow"></div>
<input type="hidden" id="AddAnotherCondition" value="1">
<div class="clearfix pointers mb10" style="color: #9e9797;" onclick="addAnotherRow('AddNewConditionRow','AddAnotherCondition','Trigger_Module')">Add another condition</div>

</div>
<div class="clearfix inner_box_bg">

<div class="row">
<div class="box-width47 col-md-6 col-sm-12 col-xs-12">
<div class="form-group">
  <label>Action :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <select class="form-control bdrd4" id="ActionMain" onchange="showSubAction('ActionMain','ActionSub','NA');showSmsEmail(this.value,'0','AddNewActionRowSmsEmail','NAA','NA','Trigger_Module','NA')">
  <option value="">Select action</option>  
  </select>
  </div>
</div>
</div>
<div class="box-width47 col-md-6 col-sm-12 col-xs-12">
<div class="form-group">
  <label>&nbsp;</label>
  <div class="input-group">
  <select class="form-control bdrd4" id="ActionSub" onchange="setActionData(this.value,'0','taActionApply');" style="display: none;">
 
 </select>
  </div>
</div>
</div>
</div>
<div class="clearfix" id="AddNewActionRowSmsEmail"></div>
<div class="clearfix" id="AddNewActionRow"></div>
<input type="hidden" id="AppendActionBoxId" value="1">
<div class="clearfix pointers" style="color: #9e9797;display:none;" onclick="addAnotherActionRow('AddNewActionRow','Trigger_Module')" id="AddAnotherAction">Add another action</div>

</div>
</div>
<div class="clearfix mtop10 mb10 text-right"> 
<button class="bt-link bt-radius bt-gray mrt10 close_box" type="button" onclick="clearVirtualTriggerCond()">Cancel</button>
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateTrigger()">Submit</button>
</div>
</form>                                  
</div>
</div>

<div class="modal fade" id="warningDeleteAction" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span>
        <span class="text-danger">Are you sure want to delete this trigger ?</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>          
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" style="width: 15%;">No</button>
        <button type="button" class="btn btn-danger" style="width: 15%;" onclick="deleteTrigger('hide')">Delete</button>
      </div>
    </div>
  </div>
</div>
<div class="modal fade" id="warningEnableDisable" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span>
        <span class="text-danger" id="WarningText"></span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <input type="hidden" id="TriggerStatusNo" value="NA"/>      
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" style="width: 15%;">No</button>
        <button type="button" class="btn btn-primary" style="width: 15%;" onclick="enableDisable('hide','NA')" id="EnableDisableBtn"></button>
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
            	<option value="tDate">Date</option>
            	<option value="tTriggerNo">Trigger No.</option>
            	<option value="tName">Trigger Name</option>
            	<option value="tDescription">Description</option>
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
<input type="hidden" id="TriggerKeyId" value="NA"/>
<input type="text" class="noDisplayBox" id="TicketCopierId">
<input type="hidden" id="NewTriggerKey" value="NA">
<!-- <input type="hidden" id="NewEditTriggerKey" value="NA"> -->
<div class="noDisplay"><a href="" id="DownloadExportedLink" download><button id="DownloadExported">Download</button></a></div>
	<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>	
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<%-- <script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/ckeditor/ckeditor.js"></script> --%>
<script type="text/javascript">
$(document).ready(function(){
	showLoader();
	$.ajax({
		type : "POST",
		url : "ClearVirtualTriggerCond111",
		dataType : "HTML",
		data : {
		},
		success : function(data){
			
		},
		complete : function(data){
			hideLoader();
		}
	});
});
function enableDisable(tKey,status){
	if(tKey=="hide"){
		tKey=$("#TriggerKeyId").val();
		status=$("#TriggerStatusNo").val();
		showLoader();
		$.ajax({
		    type: "POST",
		    url: "<%=request.getContextPath()%>/EnableDisableTrigger111",
		    data:  { 
		    	tKey : tKey,
		    	status : status
		    },
		    success: function (response) {
	        	if(response=="pass"){
	        		$("#warningEnableDisable").modal("hide");  
	        		var msg="Successfully enabled !!";
	        		if(status=="2"){
	        			msg="Successfully disabled !!";
	        		}
        			document.getElementById('errorMsg1').innerHTML =msg;
        			$("#"+tKey).load(location.href + " #"+tKey);
        			$('.alert-show1').show().delay(2000).fadeOut();	        		
	        	}else{
	        		document.getElementById('errorMsg').innerHTML = 'Something Went Wrong , Try-Again Later.';
	        		$('.alert-show').show().delay(3000).fadeOut();
	        	}
	        },
	    	complete : function(data){
	    		hideLoader();
	    	}
		});
			
	}else{
		$("#TriggerKeyId").val(tKey);
		$("#TriggerStatusNo").val(status);
		if(status=="1"){
			$("#WarningText").html("Are you sure want to enable this trigger ?");
			$("#EnableDisableBtn").html("Enable");
		}else{
			$("#WarningText").html("Are you sure want to disable this trigger ?");
			$("#EnableDisableBtn").html("Disable");
		}
		$("#warningEnableDisable").modal("show");
	}
}
function deleteTrigger(tKey){
	if(tKey=="hide"){
		tKey=$("#TriggerKeyId").val();
		showLoader();
		$.ajax({
		    type: "POST",
		    url: "<%=request.getContextPath()%>/DeleteTrigger111",
		    data:  { 
		    	tKey : tKey
		    },
		    success: function (response) {
	        	if(response=="pass"){
	        		$("#warningDeleteAction").modal("hide");        		
        			document.getElementById('errorMsg1').innerHTML = 'Successfully deleted!!';
        			$("#"+tKey).load(location.href + " #"+tKey);
        			$('.alert-show1').show().delay(2000).fadeOut();	        		
	        	}else{
	        		document.getElementById('errorMsg').innerHTML = 'Something Went Wrong , Try-Again Later.';
	        		$('.alert-show').show().delay(3000).fadeOut();
	        	}
	        },
	    	complete : function(data){
	    		hideLoader();
	    	}
		});
			
	}else{
		$("#TriggerKeyId").val(tKey);
		$("#warningDeleteAction").modal("show");
	}
}

function validateEditTrigger(){ 
	
	var module=$("#Edit_Trigger_Module").val();
	var triggerName=$("#EditTriggerName").val();
	var triggerDescription=$("#EditTriggerDescription").val();
		
	if(module==null||module==""){
		document.getElementById('errorMsg').innerHTML = 'Please select module !!';
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(triggerName==null||triggerName==""){
		document.getElementById('errorMsg').innerHTML = 'Please enter trigger name !!';
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(triggerDescription==null||triggerDescription==""){
		document.getElementById('errorMsg').innerHTML = 'Please write about trigger !!';
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}

	var triggerKey=$("#NewTriggerKey").val();
	showLoader();
	$.ajax({
		type : "POST",
		url : "SaveTrigger111",
		dataType : "HTML",
		data : {
			triggerKey : triggerKey,
			module : module,
			triggerName : triggerName,
			triggerDescription : triggerDescription,
			type : "update"
		},
		success : function(data){
			if(data=="pass"){
				document.getElementById('errorMsg1').innerHTML = 'Successfully trigger updated !!';
				$('.fixed_right_box').removeClass('active');
				$('.addnew').show();
				$('.alert-show1').show().delay(2000).fadeOut();
				setTimeout(() => {
					location.reload(true);
				}, 2000);
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

function validateTrigger(){ 
	
	var module=$("#Trigger_Module").val();
	var triggerName=$("#TriggerName").val();
	var triggerDescription=$("#TriggerDescription").val();
	var conditionMain=$("#ConditionMain").val();
	var conditionSub=$("#ConditionSub").val();
	var conditionChild=$("#ConditionChild").val();
	if(conditionMain=="Project"){
		conditionChild=$("#ConditionChildText").val();
	}
	var actionMain=$("#ActionMain").val();
	var actionSub=$("#ActionSub").val();
	
	if(module==null||module==""){
		document.getElementById('errorMsg').innerHTML = 'Please select module !!';
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(triggerName==null||triggerName==""){
		document.getElementById('errorMsg').innerHTML = 'Please enter trigger name !!';
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(triggerDescription==null||triggerDescription==""){
		document.getElementById('errorMsg').innerHTML = 'Please write about trigger !!';
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(conditionMain==null||conditionMain==""){
		document.getElementById('errorMsg').innerHTML = 'Please select condition main !!';
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(conditionSub==null||conditionSub==""){
		document.getElementById('errorMsg').innerHTML = 'Please select condition sub !!';
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(conditionChild==null||conditionChild==""){
		document.getElementById('errorMsg').innerHTML = 'Please fill condition child !!';
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(actionMain==null||actionMain==""){
		document.getElementById('errorMsg').innerHTML = 'Please select action main !!';
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(actionSub==null||actionSub==""){
		document.getElementById('errorMsg').innerHTML = 'Please select action sub !!';
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	
	var triggerKey=$("#NewTriggerKey").val();
	showLoader();
	$.ajax({
		type : "POST",
		url : "SaveTrigger111",
		dataType : "HTML",
		data : {
			triggerKey : triggerKey,
			module : module,
			triggerName : triggerName,
			triggerDescription : triggerDescription,
			type : "add"
		},
		success : function(data){
			if(data=="pass"){
				document.getElementById('errorMsg1').innerHTML = 'Successfully trigger added !!';
				$('.fixed_right_box').removeClass('active');
				$('.addnew').show();
				$('.alert-show1').show().delay(2000).fadeOut();
				setTimeout(() => {
					location.reload(true);
				}, 2000);
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

function clearVirtualTriggerCond(){
	showLoader();
	$.ajax({
		type : "POST",
		url : "ClearVirtualTriggerCond111",
		dataType : "HTML",
		data : {
		},
		success : function(data){			
		},
		complete : function(data){
			hideLoader();
		}
	});
}
function getConditionAction(data){	
	$("#EditRefreshTrigger").load(location.href + " #EditRefreshTrigger");
	$("#RefreshTrigger").load(location.href + " #RefreshTrigger");
	setTimeout(() => {
		setConditionFirst("ConditionMain",data);
		setActionMain("ActionMain",data);
		clearVirtualTriggerCond();
	}, 500);
	
}
// start
function showSubAction(actionmainid,actionsubid,module){
	var name=$("#"+actionmainid).val();
	if(module=="NA"){
		module=$("#Trigger_Module").val();
	}
	if(name!=""){
		$("#AddAnotherAction").show();
		showLoader();
	$.ajax({
		type : "POST",
		url : "gettriggerdetails.html",
		dataType : "HTML",
		data : {
			name : name,
			"field" : "actionmain",
			module : module
		},
		success : function(response){
			response = JSON.parse(response);
			var len=response.length;		
			if(Number(len)>0){
				$("#"+actionsubid).show();
				 $("#"+actionsubid).empty();
				    $("#"+actionsubid).append("<option value=''>"+"Select action"+"</option>");
					for( var i =0; i<len; i++){		
					var name = response[i]['name'];
					$("#"+actionsubid).append("<option value='"+name+"'>"+name+"</option>");
				}
			}else{$("#"+actionsubid).hide();}
		},
		complete : function(data){
			hideLoader();
		}
	});
	}else{
		$("#"+actionsubid).hide();
		$("#AddAnotherAction").hide();
		}
}

function showChildCondition(condmainid,condsubid,condchildid,module,textboxid){
	$("#"+textboxid).hide();
	$("#"+condchildid).hide();
	$("#"+condchildid).empty();
	
	var condition1=$("#"+condmainid).val();
	if(module=="NA"){
		module=$("#Trigger_Module").val();
	}
	var name=$("#"+condsubid).val();
	if(name!=""){
		showLoader();
		$.ajax({
			type : "POST",
			url : "gettriggerdetails.html",
			dataType : "HTML",
			data : {
				name : name,
				condition1 : condition1,
				"field" : "conditionsub",
				module : module
			},
			success : function(response){
				response = JSON.parse(response);
				var len=response.length;		
				if(Number(len)>0){					
					var textboxname = response[0]['name'];
					if(textboxname!="textbox"){						
					$("#"+condchildid).show();
					 $("#"+condchildid).empty();
					    $("#"+condchildid).append("<option value=''>"+"Select condition"+"</option>");
						for( var i =0; i<len; i++){		
						var name = response[i]['name'];
						$("#"+condchildid).append("<option value='"+name+"'>"+name+"</option>");
					}}else{
						$("#"+textboxid).show();
					}
						
				}
			},
			complete : function(data){
				hideLoader();
			}
		});
		}else{
			$("#"+condchildid).hide();
			}
}

function showSubCondition(conditionmainid,condsubid,condchildid,module){
	$("#"+condsubid).empty();
	$("#"+condchildid).empty();
	$("#"+condsubid).hide();
	$("#"+condchildid).hide();
	
	var name=$("#"+conditionmainid).val();
	if(module=="NA"){
		module=$("#Trigger_Module").val();
	}
	if(name!=""){
		showLoader();
	$.ajax({
		type : "POST",
		url : "gettriggerdetails.html",
		dataType : "HTML",
		data : {
			name : name,
			"field" : "conditionmain",
			module : module
		},
		success : function(response){
			response = JSON.parse(response);
			var len=response.length;		
			if(Number(len)>0){
				$("#"+condsubid).show();
				 $("#"+condsubid).empty();
				    $("#"+condsubid).append("<option value=''>"+"Select condition"+"</option>");
					for( var i =0; i<len; i++){		
					var name = response[i]['name'];
					$("#"+condsubid).append("<option value='"+name+"'>"+name+"</option>");
				}
			}
		},
		complete : function(data){
			hideLoader();
		}
	});
	}else{
		$("#"+condsubid).css('display','none');
		$("#"+condchildid).css('display','none');
		}	
}

function setActionData(data,numbering,column){
	var triggerKey=$("#NewTriggerKey").val();
	if(data==""){
		data="NA";
	}	
	showLoader();
	$.ajax({
		type : "POST",
		url : "AddVirtualTriggerAct111",
		dataType : "HTML",
		data : {				
			triggerKey : triggerKey,
			data : data,
			numbering : numbering,
			column : column
		},
		success : function(data){
			if(data=="fail"){
				document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function(data){
			hideLoader();
		}
	});
}
function setConditionData(data,numbering,column){
	var triggerKey=$("#NewTriggerKey").val();
	if(data==""){
		data="NA";
	}	
	showLoader();
	$.ajax({
		type : "POST",
		url : "AddVirtualTriggerCond111",
		dataType : "HTML",
		data : {				
			triggerKey : triggerKey,
			data : data,
			numbering : numbering,
			column : column
		},
		success : function(data){
			if(data=="fail"){
				document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function(data){
			hideLoader();
		}
	});
}
function addAnotherActionRow(AppendDivId,moduleId){
	showLoader();
	var module=$("#"+moduleId).val();
	if(module!=""){
	$("#AddAnotherAction").hide();
	var rowId=$("#AppendActionBoxId").val();
	var ActionMain="ActionMain"+rowId;
	var ActionSub="ActionSub"+rowId;
	var actionRemoveClass="actionRemoveClass"+rowId;
	$(''+
			'<div class="row '+actionRemoveClass+'">'+
	'<div class="box-width47 col-md-6 col-sm-12 col-xs-12">'+
	'<div class="form-group">'+
	 ' <label>Action :<span style="color: #4ac4f3;">*</span></label>'+
	  '<div class="input-group">'+
	  '<select class="form-control bdrd4" id="'+ActionMain+'" onchange="showSubAction(\''+ActionMain+'\',\''+ActionSub+'\',\''+module+'\');showSmsEmail(this.value,\''+rowId+'\',\''+'AddNewActionRowSmsEmail'+rowId+''+'\',\'NAA\',\'NA\',\''+moduleId+'\',\'NA\')">'+
	  '<option value="">Select action</option>'+	  
	  '</select>'+
	 ' </div>'+
	'</div>'+
	'</div>'+
	'<div class="box-width47 col-md-6 col-sm-12 col-xs-12">'+
	'<div class="form-group">'+
	  '<label>&nbsp;</label>'+
	  '<div class="input-group">'+
	  '<select class="form-control bdrd4" id="'+ActionSub+'" onchange="setActionData(this.value,\''+rowId+'\',\'taActionApply\');" style="display: none;">'+	 
	 '</select>'+
	 ' </div>'+
	'</div>'+
	'</div>'+
	'<div class="box-width25 col-md-4 col-sm-12 col-xs-12">'+  
	'<div class="form-group">'+
	  '<button class="addbtn pointers new_con_add close_icon3" type="button" style="top: 25px;" onclick="removeAction(\''+actionRemoveClass+'\',\''+rowId+'\')"><i class="fas fa-times" style="font-size: 21px;"></i></button>'+  
	'</div>'+
	'</div>'+
	'</div>'+
	'<div class="clearfix" id="AddNewActionRowSmsEmail'+rowId+'"></div>').insertBefore("#"+AppendDivId);
	$("#AppendActionBoxId").val(Number(rowId)+1);
	setActionMain(ActionMain,module);
	}else{
		document.getElementById('errorMsg').innerHTML = 'Please select module for trigger !!';
		$('.alert-show').show().delay(3000).fadeOut();
	}
	hideLoader();
}
function showSmsEmail(data,rowId,AppendId,subject,body,moduleId,id){
	if(data=="Email"){
		addAnotherEmailRow(AppendId,rowId,subject,body,moduleId,id);
	}else{
		$(".addAnotherEmailRow"+rowId).remove();
	}
	if(data=="Sms"){
		addAnotherSmsRow(AppendId,rowId,body,moduleId,id);
	}else{
		$(".addAnotherSmsRow"+rowId).remove();
	}
	if(subject=="NAA"&&id=="NA"){
		setActionData(data,rowId,'taActionMain');
	}else if(subject=="NAA"&&id!="NA"){
		setActionDataSelected(data,id,"taActionMain");
	}
	
}
function setActionMain(ActionMain,module){
	showLoader();
	$.ajax({
		type : "POST",
		url : "gettriggerdetails.html",
		dataType : "HTML",
		data : {
			name : module,
			"field" : "actionmainData"
		},
		success : function(response){
			response = JSON.parse(response);
			var len=response.length;		
			if(Number(len)>0){
				 $("#"+ActionMain).empty();
				    $("#"+ActionMain).append("<option value=''>"+"Select action"+"</option>");
					for( var i =0; i<len; i++){		
					var name = response[i]['name'];
					$("#"+ActionMain).append("<option value='"+name+"'>"+name+"</option>");
				}
			}
		},
		complete : function(data){
			hideLoader();
		}
	});
	
}

function addAnotherSmsRow(divid,rowId,body,moduleId){
	var module=$("#"+moduleId).val();
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetTriggerPlaceholder111",
		dataType : "HTML",
		data : {				
			module : module
		},
		success : function(response){			
		if(Object.keys(response).length!=0){
		response = JSON.parse(response);			
		 var len = response.length;	 
		 var placeholders="";
		 for(var i=0;i<len;i++){			
			var id = response[i]['id'];
			var value = response[i]['value'];
			var description = response[i]['description'];
			if(body=="NA")body="";
			placeholders=placeholders+"<div class='view_pbox'>"+
			"<div class='d-flex'>"+
			"<p>"+value+"</p>"+
			"<span>"+description+"</span>"+
			"</div>"+
			"<span class='copy-btn' onclick='copyPlaceholder(\""+value+"\",\""+rowId+i+"\")' title='Click to Copy !!' id='Row"+rowId+i+"'> Copy </span>"+
			"</div>";
			
		 }	
		 var funBody="onchange='setActionData(this.value,\""+rowId+"\",\"taEmailSmsBody\");'";
		 if(id!="NA"){
			 funBody="onchange='setActionDataSelected(this.value,\""+id+"\",\"taEmailSmsBody\");'";
		 }
			$(''+	
					'<div class="row edittriggeraction addAnotherSmsRow'+rowId+'">'+
					'<div class="col-md-12 col-sm-12 col-xs-12">'+
					'<div class="form-group close-dropdown">'+
					'  <div class="input-group">'+
					  '<textarea  name="newproductname" rows="5" id="SmsBody'+rowId+'" placeholder="Sms body...." '+funBody+' class="form-control bdrd4">'+body+'</textarea>'+
					  '</div>'+
					'</div>'+
					'<div class="mb10 pointers relative_box placeholders" style="color: #02b6fb;">'+
					'<span class="pc_btn" onclick="openPlaceholders(\''+rowId+'\')">View available placeholders</span>'+
					'<div class="view_placeholder" id="View_placeholder'+rowId+'">'+
					'<div class="inner_view_pbox">'+
					placeholders+				
					'</div>'+
					'</div>'+
					'</div>'+
					'</div>'+
					'</div>').insertBefore('#'+divid);
			
		}		
		},
		complete : function(data){
			hideLoader();
		}
	});	
}

function addAnotherEmailRow(divid,rowId,subject,body,moduleId,id1){
	var module=module=$("#"+moduleId).val();
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetTriggerPlaceholder111",
		dataType : "HTML",
		data : {				
			module : module
		},
		success : function(response){			
		if(Object.keys(response).length!=0){
		response = JSON.parse(response);			
		 var len = response.length;	 
		 var placeholders="";
		 for(var i=0;i<len;i++){			
			var id = response[i]['id'];
			var value = response[i]['value'];
			var description = response[i]['description'];
			if(subject=="NAA")subject="";
			if(body=="NA")body="";
			
			placeholders=placeholders+"<div class='view_pbox'>"+
			"<div class='d-flex'>"+
			"<p>"+value+"</p>"+
			"<span>"+description+"</span>"+
			"</div>"+
			"<span class='copy-btn' onclick='copyPlaceholder(\""+value+"\",\""+rowId+i+"\")' title='Click to Copy !!' id='Row"+rowId+i+"'> Copy </span>"+
			"</div>";
			
		 }	
		 var funSub="onchange='setActionData(this.value,\""+rowId+"\",\"taEmailSubject\");'";
		 var funBody="onchange='setActionData(this.value,\""+rowId+"\",\"taEmailSmsBody\");'";
		 if(id1!="NA"){
			 funSub="onchange='setActionDataSelected(this.value,\""+id1+"\",\"taEmailSubject\");'";
			 funBody="onchange='setActionDataSelected(this.value,\""+id1+"\",\"taEmailSmsBody\");'";
		 }
			$(''+	
					'<div class="row edittriggeraction addAnotherEmailRow'+rowId+'">'+	
					'<div class="col-md-12 col-sm-12 col-xs-12">'+
					'<div class="form-group">'+
					  '<div class="input-group">'+
					  '<input type="text" name="newproductname" id="EmailSubject" value="'+subject+'" placeholder="Email subject...." '+funSub+' class="form-control bdrd4">'+
					  '</div>'+
					'</div>'+
					'</div>'+
					'</div>'+
					'<div class="row edittriggeraction addAnotherEmailRow'+rowId+'">'+
					'<div class="col-md-12 col-sm-12 col-xs-12">'+
					'<div class="form-group close-dropdown">'+
					'  <div class="input-group">'+
					  '<textarea  name="newproductname" rows="5" id="EmailBody'+rowId+'" placeholder="Email body...." '+funBody+' class="form-control bdrd4">'+body+'</textarea>'+
					  '</div>'+
					'</div>'+
					'<div class="mb10 pointers relative_box placeholders" style="color: #02b6fb;">'+
					'<span class="pc_btn" onclick="openPlaceholders(\''+rowId+'\')">View available placeholders</span>'+
					'<div class="view_placeholder" id="View_placeholder'+rowId+'">'+
					'<div class="inner_view_pbox">'+
					placeholders+				
					'</div>'+
					'</div>'+
					'</div>'+
					'</div>'+
					'</div>').insertBefore('#'+divid);
			
		}		
		},
		complete : function(data){
			hideLoader();
		}
	});
}
function openPlaceholders(rowId){	
	if($("#View_placeholder"+rowId).hasClass("active")){
		$("#View_placeholder"+rowId).removeClass("active");
		$("#View_placeholder"+rowId).slideUp("slow");
	}else{	
		$("#View_placeholder"+rowId).slideDown("slow");
		$("#View_placeholder"+rowId).addClass("active");		
	}
}
function addAnotherRow(divid,newId,moduleId){
	showLoader();
	var module=$("#"+moduleId).val();
	if(module!=""){
	var	rowId=$("#"+newId).val();
	var ConditionMain="ConditionMain"+rowId;
	var ConditionSub="ConditionSub"+rowId;
	var ConditionChild="ConditionChild"+rowId;
	var conditionRemoveClass="conditionRemoveClass"+rowId;
	$(''+
			 '<div class="row '+conditionRemoveClass+'">'+
'<div class="box-width33 col-md-4 col-sm-12 col-xs-12">'+
'<div class="form-group">'+
  '<label>&nbsp;</label>'+
  '<div class="input-group">'+
  '<select class="form-control bdrd4" id="'+ConditionMain+'" onchange="showSubCondition(\''+ConditionMain+'\',\''+ConditionSub+'\',\''+ConditionChild+'\',\''+module+'\');setConditionData(this.value,\''+rowId+'\',\'tcConditionMain\');">'+
  
  '</select>'+
  '</div>'+
'</div>'+
'</div>'+
'<div class="box-width33 col-md-4 col-sm-12 col-xs-12">'+
'<div class="form-group">'+
  '<label>&nbsp;</label>'+
  '<div class="input-group">'+
 '<select class="form-control bdrd4" id="'+ConditionSub+'" onchange="showChildCondition(\''+ConditionMain+'\',\''+ConditionSub+'\',\''+ConditionChild+'\',\''+module+'\',\''+'ConditionChildText'+rowId+''+'\');setConditionData(this.value,\''+rowId+'\',\'tcConditionSub\');" style="display: none;">'+
 '</select>'+
 '</div>'+
'</div>'+
'</div>'+
'<div class="box-width33 col-md-4 col-sm-12 col-xs-12">'+
'<div class="form-group">'+
'<label>&nbsp;</label>'+
  '<div class="input-group">'+
  '<select class="form-control bdrd4" id="'+ConditionChild+'" onchange="setConditionData(this.value,\''+rowId+'\',\'tcConditionChild\');" style="display: none;"></select>'+
  '<input type="text" class="form-control" name="ConditionChildText'+rowId+'" id="ConditionChildText'+rowId+'" onchange="setConditionData(this.value,\''+rowId+'\',\'tcConditionChild\');" style="display: none;" placeholder="Type here...">'+
  '</div>'+
'</div>'+
'</div>'+
'<div class="box-width25 col-md-4 col-sm-12 col-xs-12">'+  
  '<button class="addbtn pointers new_con_add close_icon3" type="button" style="top: 25px;" onclick="removeCondition(\''+conditionRemoveClass+'\',\''+rowId+'\')"><i class="fas fa-times" style="font-size: 21px;"></i></button>'+  
'</div>'+
'</div>').insertBefore('#'+divid);
	
	$("#"+newId).val(Number(rowId)+1);	
	setConditionFirst(ConditionMain,module);
	}else{
		document.getElementById('errorMsg').innerHTML = 'Please select module for trigger !!';
		$('.alert-show').show().delay(3000).fadeOut();
	}
hideLoader();
}

function removeAction(ConditionClass,rowId){
	var active=$("#ActionMain"+rowId).val();
	if(active!=""){
	var triggerKey=$("#NewTriggerKey").val();
	showLoader();
	$.ajax({
		type : "POST",
		url : "RemoveVirtualTriggerAct111",
		dataType : "HTML",
		data : {				
			triggerKey : triggerKey,
			rowId : rowId
		},
		success : function(data){		
			$("."+ConditionClass).remove();	
			$(".addAnotherEmailRow"+rowId).remove();
			$(".addAnotherSmsRow"+rowId).remove();
			$("#AddNewActionRowSmsEmail"+rowId).remove();
			$("#AddAnotherAction").show();		
		},
		complete : function(data){
			hideLoader();
		}
	});	
	}else{
		$("."+ConditionClass).remove();	
		$(".addAnotherEmailRow"+rowId).remove();
		$(".addAnotherSmsRow"+rowId).remove();
		$("#AddAnotherAction").show();
	}
}

function removeCondition(ConditionClass,rowId){
	var active=$("#ActionMain"+rowId).val();
	if(active!=""){
	var triggerKey=$("#NewTriggerKey").val();
	showLoader();
	$.ajax({
		type : "POST",
		url : "RemoveVirtualTriggerCond111",
		dataType : "HTML",
		data : {				
			triggerKey : triggerKey,
			rowId : rowId
		},
		success : function(data){
		
			$("."+ConditionClass).remove();	
			$(".addAnotherEmailRow"+rowId).remove();
			$(".addAnotherSmsRow"+rowId).remove();
			$("#AddAnotherAction").show();				
			
		},
		complete : function(data){
			hideLoader();
		}
	});	
	}else{
		$("."+ConditionClass).remove();	
		$(".addAnotherEmailRow"+rowId).remove();
		$(".addAnotherSmsRow"+rowId).remove();
		$("#AddAnotherAction").show();
	}
}
function setConditionFirst(ConditionMain,module){
// 	alert(ConditionMain+"/"+module);
		showLoader();
		$.ajax({
			type : "POST",
			url : "gettriggerdetails.html",
			dataType : "HTML",
			data : {
				name : module,
				"field" : "conditionFirst"
			},
			success : function(response){
				response = JSON.parse(response);
				var len=response.length;
				if(Number(len)>0){
					 $("#"+ConditionMain).empty();
					    $("#"+ConditionMain).append("<option value=''>"+"Select condition"+"</option>");
						for( var i =0; i<len; i++){		
						var name = response[i]['name'];
						$("#"+ConditionMain).append("<option value='"+name+"'>"+name+"</option>");
					}
				}
			},
			complete : function(data){
				hideLoader();
			}
		});
	
}

function openTriggerBox(){
	$("#RegNewTrigger").trigger("reset");
	$("#RefreshTrigger").load(location.href + " #RefreshTrigger");
	var id = $(".addnew").attr('data-related'); 
	$(id).hide();
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });	
	    
	    var triggerKey=getKey(40);
	    $("#NewTriggerKey").val(triggerKey);
}

$('.close_box').on( "click", function(e) { 
	$('.fixed_right_box').removeClass('active');
	$('.addnew').show();	
});
/* $(function(){
	$('body').on('click',function(){
		$(".view_placeholder").slideUp();
	});
});  */
$(document).on('click', function (event) {
	  if (!$(event.target).closest('.pc_btn,.view_placeholder').length) {
		  $(".view_placeholder").removeClass("active");
		  $(".view_placeholder").slideUp("slow");
	  }
	});	
	
// end

function vieweditpage(id,page){
	showLoader();
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
    	complete : function(data){
    		hideLoader();
    	}
	});
}

function copyPlaceholder(data,id){	
	$("#TicketCopierId").val(data);
	  var copyText = document.getElementById('TicketCopierId');
	  copyText.select();
	  copyText.setSelectionRange(0, 99999)
	  document.execCommand("copy");
	  $("#Row"+id).html("Copied");
// 	  document.getElementById('errorMsg1').innerHTML = 'Copied !!';
// 	  $('.alert-show1').show().delay(1000).fadeOut();
}
</script>	
<script type="text/javascript">
function editTrigger(triggerKey,triggerCondKey,triggerActKey,module,name,description){
	$("#UpdateNewTrigger").trigger("reset");
	$("#RegNewTrigger").trigger("reset");
	$("#Edit_Trigger_Module").empty();
	$("#Edit_Trigger_Module").append("<option value='"+module+"'>"+module+"</option>");
	$("#EditTriggerName").val(name);$("#EditTriggerDescription").val(description); 
	loadTriggerConditions(triggerCondKey,triggerActKey,module);
	var id = $(".updateTrigger").attr('data-related'); 
	$(id).hide();
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });	
	    
	    $("#NewTriggerKey").val(triggerKey);
}
function loadTriggerConditions(triggerCondKey,triggerActKey,module){
	$(".editConditions").remove();
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetEditTriggerData111",
		dataType : "HTML",
		data : {				
			triggerKey : triggerCondKey,
			type:"condition"
		},
		success : function(response){			
		if(Object.keys(response).length!=0){
		response = JSON.parse(response);			
		 var len = response.length;
		 for(var i=0;i<len;i++){			
			var id = response[i]['id'];
			var main = response[i]['main'];
			var sub = response[i]['sub'];
			var child = response[i]['child'];
			var rowId=$("#AddAnotherCondition").val();
			var ConditionMain="ConditionMain"+rowId;
			var ConditionSub="ConditionSub"+rowId;
			var ConditionChild="ConditionChild"+rowId;
			var conditionRemoveClass="conditionRemoveClass"+rowId;
			$(''+
					 '<div class="row editConditions '+conditionRemoveClass+'">'+
		'<div class="box-width33 col-md-4 col-sm-12 col-xs-12">'+
		'<div class="form-group">'+
		  '<label>&nbsp;</label>'+
		  '<div class="input-group">'+
		  '<select class="form-control bdrd4" id="'+ConditionMain+'" onchange="showSubCondition(\''+ConditionMain+'\',\''+ConditionSub+'\',\''+ConditionChild+'\',\''+module+'\');setConditionDataSelected(this.value,\''+id+'\',\'tcConditionMain\');">'+
		  
		  '</select>'+
		  '</div>'+
		'</div>'+
		'</div>'+
		'<div class="box-width33 col-md-4 col-sm-12 col-xs-12">'+
		'<div class="form-group">'+
		  '<label>&nbsp;</label>'+
		  '<div class="input-group">'+
		 '<select class="form-control bdrd4" id="'+ConditionSub+'" onchange="showChildCondition(\''+ConditionMain+'\',\''+ConditionSub+'\',\''+ConditionChild+'\',\''+module+'\',\''+'ConditionChildText'+rowId+''+'\');setConditionDataSelected(this.value,\''+id+'\',\'tcConditionSub\');">'+
		 
		 '</select>'+
		 '</div>'+
		'</div>'+
		'</div>'+
		'<div class="box-width33 col-md-4 col-sm-12 col-xs-12">'+
		'<div class="form-group">'+
		'<label>&nbsp;</label>'+
		  '<div class="input-group">'+
		  '<select class="form-control bdrd4" id="'+ConditionChild+'" onchange="setConditionDataSelected(this.value,\''+id+'\',\'tcConditionChild\');"></select>'+
		  '<input type="text" class="form-control" name="ConditionChildText'+rowId+'" id="ConditionChildText'+rowId+'" onchange="setConditionDataSelected(this.value,\''+id+'\',\'tcConditionChild\');" style="display: none;" placeholder="Type here...">'+
		  '</div>'+
		'</div>'+
		'</div>'+
		'<div class="box-width25 col-md-4 col-sm-12 col-xs-12">'+  
		  '<button class="addbtn pointers new_con_add close_icon3" type="button" style="top: 25px;" onclick="removeConditionSelected(\''+conditionRemoveClass+'\',\''+rowId+'\',\''+id+'\')"><i class="fas fa-times" style="font-size: 21px;"></i></button>'+  
		'</div>'+
		'</div>').insertBefore('#EditNewConditionRow');
		
		$("#AddAnotherCondition").val(Number(rowId)+1);	
		setConditionFirstSelected(ConditionMain,module,main);
		showSubConditionSelected(main,ConditionSub,ConditionChild,module,sub);
		showChildConditionSelected(main,sub,ConditionChild,module,"ConditionChildText"+rowId,child)
			
		}
		loadTriggerActions(triggerActKey,module); 
		}		
		},
		complete : function(data){
			hideLoader();
		}
	});	
}
function removeConditionSelected(ConditionClass,rowId,id){
	var active=$("#ActionMain"+rowId).val();
	if(active!=""){
		showLoader();
	$.ajax({
		type : "POST",
		url : "RemoveTriggerCondAct111",
		dataType : "HTML",
		data : {				
			id : id,
			type : "condition"
		},
		success : function(data){
		
			$("."+ConditionClass).remove();	
			$(".addAnotherEmailRow"+rowId).remove();
			$(".addAnotherSmsRow"+rowId).remove();
			$("#AddAnotherAction").show();				
			
		},
		complete : function(data){
			hideLoader();
		}
	});	
	}else{
		$("."+ConditionClass).remove();	
		$(".addAnotherEmailRow"+rowId).remove();
		$(".addAnotherSmsRow"+rowId).remove();
		$("#AddAnotherAction").show();
	}
}
function setConditionDataSelected(data,id,column){
	if(data==""){
		data="NA";
	}	
	showLoader();
	$.ajax({
		type : "POST",
		url : "UpdateTriggerCondAct111",
		dataType : "HTML",
		data : {				
			id : id,
			data : data,
			column : column,
			type : "condition"
		},
		success : function(data){
			if(data=="fail"){
				document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function(data){
			hideLoader();
		}
	});
}
function setActionDataSelected(data,id,column){
	if(data==""){
		data="NA";
	}	
	showLoader();
	$.ajax({
		type : "POST",
		url : "UpdateTriggerCondAct111",
		dataType : "HTML",
		data : {				
			id : id,
			data : data,
			column : column,
			type : "action"
		},
		success : function(data){
			if(data=="fail"){
				document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function(data){
			hideLoader();
		}
	});
}
function loadTriggerActions(triggerActKey,module){
	$(".edittriggeraction").remove();
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetEditTriggerData111",
		dataType : "HTML",
		data : {				
			triggerKey : triggerActKey,
			type:"action"
		},
		success : function(response){			
		if(Object.keys(response).length!=0){
		response = JSON.parse(response);			
		 var len = response.length;
		 for(var i=0;i<len;i++){			
			var id = response[i]['id'];
			var main = response[i]['main'];
			var apply = response[i]['apply'];
			var subject = response[i]['subject'];
			var body = response[i]['body'];
			
			if(module!=""){
				$("#AddAnotherAction").hide();
				var rowId=$("#AppendActionBoxId").val();
				var ActionMain="ActionMain"+rowId;
				var ActionSub="ActionSub"+rowId;
				var actionRemoveClass="actionRemoveClass"+rowId;
				$(''+
						'<div class="row edittriggeraction '+actionRemoveClass+'">'+
				'<div class="box-width47 col-md-6 col-sm-12 col-xs-12">'+
				'<div class="form-group">'+
				 ' <label>Action :<span style="color: #4ac4f3;">*</span></label>'+
				  '<div class="input-group">'+
				  '<select class="form-control bdrd4" id="'+ActionMain+'" onchange="showSubAction(\''+ActionMain+'\',\''+ActionSub+'\',\''+module+'\');showSmsEmail(this.value,\''+rowId+'\',\''+'EditNewActionRowSmsEmail'+rowId+''+'\',\'NAA\',\'NA\',\'Edit_Trigger_Module\',\''+id+'\')">'+
				  '<option value="">Select action</option>'+
				  
				  '</select>'+
				 ' </div>'+
				'</div>'+
				'</div>'+
				'<div class="box-width47 col-md-6 col-sm-12 col-xs-12">'+
				'<div class="form-group">'+
				  '<label>&nbsp;</label>'+
				  '<div class="input-group">'+
				  '<select class="form-control bdrd4" id="'+ActionSub+'" onchange="setActionDataSelected(this.value,\''+id+'\',\'taActionApply\');">'+	 
				 '</select>'+
				 ' </div>'+
				'</div>'+
				'</div>'+
				'<div class="box-width25 col-md-4 col-sm-12 col-xs-12">'+  
				'<div class="form-group">'+
				  '<button class="addbtn pointers new_con_add close_icon3" type="button" style="top: 25px;" onclick="removeAction(\''+actionRemoveClass+'\',\''+rowId+'\')"><i class="fas fa-times" style="font-size: 21px;"></i></button>'+  
				'</div>'+
				'</div>'+
				'</div>'+
				'<div class="clearfix" id="EditNewActionRowSmsEmail'+rowId+'"></div>').insertBefore("#EditNewActionRow");
				$("#AppendActionBoxId").val(Number(rowId)+1);
				setActionMainSelected(ActionMain,module,main);
				showSubActionSelected(main,ActionSub,module,apply);
				showSmsEmail(main,rowId,"EditNewActionRowSmsEmail"+rowId,subject,body,"Edit_Trigger_Module",id);
				}	
		} 
		}		
		},
		complete : function(data){
			hideLoader();
		}
	});	
}

function showSubActionSelected(name,actionsubid,module,value){
	$("#"+actionsubid).hide();
	$("#EditAnotherAction").hide();
	
	if(module=="NA"){
		module=$("#Edit_Trigger_Module").val();
	}
	if(name!=""){
		$("#EditAnotherAction").show();
		showLoader();
	$.ajax({
		type : "POST",
		url : "gettriggerdetails.html",
		dataType : "HTML",
		data : {
			name : name,
			"field" : "actionmain",
			module : module
		},
		success : function(response){
			response = JSON.parse(response);
			var len=response.length;		
			if(Number(len)>0){
				$("#"+actionsubid).show();
				 $("#"+actionsubid).empty();
				    $("#"+actionsubid).append("<option value=''>"+"Select action"+"</option>");
					for( var i =0; i<len; i++){		
					var name = response[i]['name'];
					if(name==value){
						$("#"+actionsubid).append("<option value='"+name+"' selected>"+name+"</option>");
					}else{
						$("#"+actionsubid).append("<option value='"+name+"'>"+name+"</option>");
					}
					
				}
			}else{$("#"+actionsubid).hide();}
		},
		complete : function(data){
			hideLoader();
		}
	});
	}
}
function setActionMainSelected(ActionMain,module,value){
	showLoader();
	$.ajax({
		type : "POST",
		url : "gettriggerdetails.html",
		dataType : "HTML",
		data : {
			name : module,
			"field" : "actionmainData"
		},
		success : function(response){
			response = JSON.parse(response);
			var len=response.length;		
			if(Number(len)>0){
				 $("#"+ActionMain).empty();
				    $("#"+ActionMain).append("<option value=''>"+"Select action"+"</option>");
					for( var i =0; i<len; i++){		
					var name = response[i]['name'];
					if(name==value){
						$("#"+ActionMain).append("<option value='"+name+"' selected>"+name+"</option>");
					}else{
						$("#"+ActionMain).append("<option value='"+name+"'>"+name+"</option>");
					}
					
				}
			}
		},
		complete : function(data){
			hideLoader();
		}
	});
	
}
function showChildConditionSelected(condition1,name,condchildid,module,textboxid,value){
	if(module=="NA"){
		module=$("#Edit_Trigger_Module").val();
	}
	if(name!=""){
		showLoader();
		$.ajax({
			type : "POST",
			url : "gettriggerdetails.html",
			dataType : "HTML",
			data : {
				name : name,
				condition1 : condition1,
				"field" : "conditionsub",
				module : module
			},
			success : function(response){
				response = JSON.parse(response);
				var len=response.length;		
				if(Number(len)>0){					
					var textboxname = response[0]['name'];
					if(textboxname!="textbox"){						
					$("#"+condchildid).show();
					 $("#"+condchildid).empty();
					    $("#"+condchildid).append("<option value=''>"+"Select condition"+"</option>");
						for( var i =0; i<len; i++){		
						var name = response[i]['name'];
						if(name==value){
							$("#"+condchildid).append("<option value='"+name+"' selected>"+name+"</option>");
						}else{
							$("#"+condchildid).append("<option value='"+name+"'>"+name+"</option>");
						}
						
					}}else{
						$("#"+textboxid).val(value);
						$("#"+textboxid).show();
					}
						
				}else{
					$("#"+condchildid).hide();
					$("#"+condchildid).empty();					
					}
			},
			complete : function(data){
				hideLoader();
			}
		});
		}else{
			$("#"+condchildid).hide();
			}
}
function showSubConditionSelected(name,condsubid,condchildid,module,value){
	if(module=="NA"){
		module=$("#Edit_Trigger_Module").val();
	}
	if(name!=""){
		showLoader();
	$.ajax({
		type : "POST",
		url : "gettriggerdetails.html",
		dataType : "HTML",
		data : {
			name : name,
			"field" : "conditionmain",
			module : module
		},
		success : function(response){
			response = JSON.parse(response);
			var len=response.length;		
			if(Number(len)>0){
				$("#"+condsubid).show();
				 $("#"+condsubid).empty();
				    $("#"+condsubid).append("<option value=''>"+"Select condition"+"</option>");
					for( var i =0; i<len; i++){		
					var name = response[i]['name'];
					if(name==value){
						$("#"+condsubid).append("<option value='"+name+"' selected>"+name+"</option>");
					}else{
						$("#"+condsubid).append("<option value='"+name+"'>"+name+"</option>");
					}
					
				}
			}else{
				$("#"+condsubid).empty();
				$("#"+condchildid).empty();
				$("#"+condsubid).hide();
				$("#"+condchildid).hide();
			}
		},
		complete : function(data){
			hideLoader();
		}
	});
	}else{
		$("#"+condsubid).css('display','none');
		$("#"+condchildid).css('display','none');
		}	
}
function setConditionFirstSelected(ConditionMain,module,value){
	showLoader();
	$.ajax({
		type : "POST",
		url : "gettriggerdetails.html",
		dataType : "HTML",
		data : {
			name : module,
			"field" : "conditionFirst"
		},
		success : function(response){
			response = JSON.parse(response);
			var len=response.length;		
			if(Number(len)>0){
				 $("#"+ConditionMain).empty();
				    $("#"+ConditionMain).append("<option value=''>"+"Select condition"+"</option>");
					for( var i =0; i<len; i++){		
					var name = response[i]['name'];
					if(value==name){
						$("#"+ConditionMain).append("<option value='"+name+"' selected>"+name+"</option>");
					}else{
						$("#"+ConditionMain).append("<option value='"+name+"'>"+name+"</option>");
					}
				}
			}
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
			type : "Trigger"
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
$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var data=$(this).val();
	doAction(data,"TriggerdateRangeDoAction");
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
	   var dateRangeDoAction="<%=TriggerdateRangeDoAction%>";
	   if(dateRangeDoAction!="NA"){	  
		   $('input[name="date_range"]').val(dateRangeDoAction);
	   }
	});
$(function() {
	$("#SearchTriggerName").autocomplete({
		source : function(request, response) {			
			if(document.getElementById('SearchTriggerName').value.trim().length>=1)
			$.ajax({
				url : "TriggerData111",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					"field" : "name"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.value
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
            	doAction(ui.item.label,'TriggerNameDoAction');
            	location.reload();
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});
$(function() {
	$("#TriggerNo").autocomplete({
		source : function(request, response) {			
			if(document.getElementById('TriggerNo').value.trim().length>=2)
			$.ajax({
				url : "TriggerData111",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					"field" : "number"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.value
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
            	doAction(ui.item.label,'TriggerNoDoAction');
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