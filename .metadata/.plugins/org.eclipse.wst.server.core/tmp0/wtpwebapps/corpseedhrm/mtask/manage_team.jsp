<%@page import="java.util.Properties"%>
<%@page import="commons.DateUtil"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/> 
	<title>Manage teams</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<div class="wrap"> 
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%
String addedby= (String)session.getAttribute("loginuID");
String token=(String)session.getAttribute("uavalidtokenno");
String today=DateUtil.getCurrentDateIndianFormat1();
TaskMaster_ACT.clearVirtualMemberTable(token,addedby); 

String teamDateRangeAction=(String)session.getAttribute("teamDateRangeAction");
if(teamDateRangeAction==null||teamDateRangeAction.length()<=0)teamDateRangeAction="NA";

String teamNameDoAction=(String)session.getAttribute("teamNameDoAction");
if(teamNameDoAction==null||teamNameDoAction.length()<=0)teamNameDoAction="NA";

String teamDoAction=(String)session.getAttribute("teamDoAction");
if(teamDoAction==null||teamDoAction.length()<=0)teamDoAction="NA";
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
String sort_url=domain+"manageteam.html?page="+pageNo+"&rows="+rows;

//pagination end
%>
	<%if(!MTM0){%><jsp:forward page="/login.html" /><%} %>
	<div id="content">
		<div class="main-content">
			<div class="container">
				
<div class="clearfix"> 
<form onsubmit="return false" method="Post">
<div class="bg_wht clearfix mb10" id="SearchOptions">  
<div class="row">
<div class="col-md-7 col-sm-7 col-xs-12"> 
<div class="col-md-12 dropdown">
<button type="button" class="filtermenu addteam" data-related="add_team" onclick="openTeam()" style="width: 100px;margin-left: -14px;">Add Team&nbsp;+</button>
<select class="filtermenu addteam mlft20" onchange="doAction(this.value,'teamDoAction');location.reload()">
    <option value="" <%if(teamDoAction.equals("NA")){%>selected="selected"<%} %>>Search by department</option>
    <option value="Sales" <%if(teamDoAction.equals("Sales")){%>selected="selected"<%} %>>Sales</option>
	<option value="Delivery" <%if(teamDoAction.equals("Delivery")){%>selected="selected"<%} %>>Delivery</option>
	<option value="Account" <%if(teamDoAction.equals("Account")){%>selected="selected"<%} %>>Account</option>
	<option value="HR" <%if(teamDoAction.equals("HR")){%>selected="selected"<%} %>>HR</option>
	<option value="Document" <%if(teamDoAction.equals("Document")){%>selected="selected"<%} %>>Document</option>
 </select>
</div>
</div>
<a href="javascript:void(0)" class="doticon"> <i class="fa fa-filter" aria-hidden="true"></i>Filter</a>
<div class="filtermmenu">
<div class="post" style="position:absolute;z-index:9">
                        <div class="linee" style="margin-top: -1px;width:1350px;height:50px"></div>
                            </div>
<div class="col-md-5 col-sm-5 col-xs-12">
<div class="clearfix">
<div class="item-bestsell col-md-6 col-sm-6 col-xs-12 has-clear">
<p><input type="search" name="team_name" id="Team_Name" <%if(!teamNameDoAction.equalsIgnoreCase("NA")){ %> onsearch="clearSession('teamNameDoAction');location.reload()" value="<%=teamNameDoAction%>"<%} %> autocomplete="off" placeholder="Search by team name.." class="form-control"/></p>
</div>
<div class="item-bestsell col-md-6 col-sm-6 col-xs-12 has-clear">
<p><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="FROM - TO" class="form-control text-center date_range pointers <%if(!teamDateRangeAction.equalsIgnoreCase("NA")){ %>selected<%} %>"  readonly="readonly"/>
<span class="form-control-clear form-control-feedback" onclick="clearSession('teamDateRangeAction');location.reload();"></span>
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
						   
						        <tr>
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
						            <th><span class="hashico">#</span><input type="checkbox" class="pointers noDisplay" id="CheckAll"></th>
						            <th width="100" class="sorting <%if(sort.equals("date")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','date','<%=order%>')">Date</th>
						            <th class="sorting <%if(sort.equals("department")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','department','<%=order%>')">Department</th>
						            <th class="sorting <%if(sort.equals("name")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','name','<%=order%>')">Team Name</th>
						            <th class="sorting <%if(sort.equals("admin")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','admin','<%=order%>')">Team Admin</th>
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
						    String[][] teams=TaskMaster_ACT.getAllTeams(teamDoAction,teamNameDoAction,teamDateRangeAction,token,pageNo,rows,sort,order);
                            int totalTeams=TaskMaster_ACT.countAllTeams(teamDoAction,teamNameDoAction,teamDateRangeAction,token);
						    if(teams!=null&&teams.length>0){
                            	 ssn=rows*(pageNo-1);
                           	  totalPages=(totalTeams/rows);
                           	if((totalTeams%rows)!=0)totalPages+=1;
                           	  showing=ssn+1;
                           	  if (totalPages > 1) {     	 
                           		  if((endRange-2)==totalPages)startRange=pageNo-4;        
                                     if(startRange==pageNo)endRange=pageNo+4;
                                     if(startRange<1) {startRange=1;endRange=startRange+4;}
                                     if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
                                     if(startRange<1)startRange=1;
                                }else{startRange=0;endRange=0;}
                             for(int i=0;i<teams.length;i++) { 
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
						            <td><%=teams[i][2] %></td>
						            <td><%=teams[i][3] %></td>
						            <td class="updateteam pointers" data-related="update_team" onclick="openUpdateTeam('<%=teams[i][1] %>','<%=teams[i][3] %>','<%=teams[i][4] %>','<%=teams[i][5] %>','<%=teams[i][6] %>','<%=teams[i][7] %>')"><%=teams[i][4] %></td>
						            <td><%=teams[i][5] %></td>
						            <td>
						            <a href="#" onclick="deleteTeam('<%=teams[i][0] %>')"><i class="fas fa-trash text-danger"></i>&nbsp;Delete</a>
						            </td>									
						        </tr>
						     <%}}%>
                                 
						    </tbody>
						</table>
						</div>
						<div class="filtertable">
						  <span>Showing <%=showing %> to <%=ssn+teams.length %> of <%=totalTeams %> entries</span>
						  <div class="pagination">
						    <ul> <%if(pageNo>1){ %>
						      <li class="page-item">	                     
						      <a class="page-link text-primary" href="<%=request.getContextPath()%>/manageteam.html?page=1&rows=<%=rows%>">First</a>
						   </li><%} %>
						    <li class="page-item">					      
						      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/manageteam.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
						    </li>  
						      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
							    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
							    <a class="page-link" href="<%=request.getContextPath()%>/manageteam.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
							    </li>   
							  <%} %>
							   <li class="page-item">						      
							      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/manageteam.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
							   </li><%if(pageNo<=(totalPages-1)){ %>
							   <li class="page-item">
							      <a class="page-link text-primary" href="<%=request.getContextPath()%>/manageteam.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
							   </li><%} %>
							</ul>
							</div>
							<select class="select2" onchange="changeRows(this.value,'manageteam.html?page=1','<%=domain%>')">
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
<div class="clearfix add_inner_box pad_box4 addcompany" id="update_team" style="padding-top: 5px;">
<div class="close_icon close_box"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-users"></i>Update Team</h3> 
 <p style="font-size: 12px;"><span style="color: red;font-weight: 600;">Notes :- </span>After change team leader, All permissions of previous team leader will granted to new team leader and he/she will not able to track work status and not able to assign task to anyone.</p>
</div>
<form onsubmit="return false" id="UpdateNewTeam">
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <select name="updateDepartmentName" id="UpdateDepartmentName" class="form-control bdrd4">
 </select>
 </div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 </div>
 </div>
</div>
</div>
<div class="clearfix inner_box_bg" style="margin-top: 10px;">
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Team Name :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <input type="hidden" id="TeamRefid" name="teamrefid" value="NA"/>
  <input type="text" autocomplete="off" name="UpdateTeamName" onchange="isEditDuplicateTeam('UpdateTeamName','TeamRefid')" id="UpdateTeamName" placeholder="Team Name" class="form-control bdrd4">
  </div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Team Leader's Name :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <input type="text" autocomplete="off" name="teamleadername" id="UpdateLeaderName" placeholder="Team Leader's Name" class="form-control bdrd4">
  <input type="hidden" id="UpdateTeamAdminMemberCode" name="Updatemembercode">
  <input type="hidden" id="UpdateTeamAdminMemberUaid" name="Updatememberuaid">
  </div>
  <div id="stateErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
</div>
<div class="clearfix mb30">

<div class="clearfix inner_box_bg">
<div class="row">
<div class="col-md-8 col-sm-8 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Member's Name :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <input type="text" autocomplete="off" name="membername" id="UpdateMemberName" placeholder="Member's Name" class="form-control bdrd4">
  <input type="hidden" id="UpdateMemberCode" name="updatemembercode">
  <input type="hidden" id="UpdateMemberUaid" name="updatememberuaid">
  </div>
  <div id="cityErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
 <div class="form-group">
 <label style="font-size: 12px;font-weight: normal;">&nbsp;</label>
 <div class="input-group">
<button class="bt-link bt-radius btn-primary btn-block" type="button" onclick="return addUpdateMemberName('EditMemberOfTeamAppend')">Add</button>
</div>
 </div>
</div>
</div>
</div>

<div class="clearfix" id="EditMemberOfTeamAppend"></div>


</div>  

<div class="clearfix mtop10 mb10 text-right"> 
<button class="bt-link bt-radius bt-gray mrt10 close_box" type="button">Cancel</button>
<button class="bt-link bt-radius bt-loadmore" type="button" onclick="return validateUpdateTeam()">Update</button>
</div>
</form>                             
</div>
<div class="clearfix add_inner_box pad_box4 addcompany" id="add_team" style="padding-top: 5px;">
<div class="close_icon close_box" onclick="clearVirtualMemberTable()"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-users"></i>New Team</h3> 
<p>Add Team to manage easily your work.</div>
<form onsubmit="return false" id="AddNewTeam">
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <select name="addDepartmentName" id="AddDepartmentName" class="form-control bdrd4" onchange="resetTeamLeader('TeamLeaderName','TeamAdminMemberCode','TeamAdminMemberUaid')">
   <option value="">Select Department  !!</option>
	<option value="Sales">Sales</option>
	<option value="Delivery">Delivery</option>
	<option value="Account">Account</option>
	<option value="HR">HR</option>
	<option value="Document">Document</option>
 </select>
 </div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 </div>
 </div>
</div>
</div>
<div class="clearfix inner_box_bg" style="margin-top: 10px;">
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Team Name :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <input type="text" autocomplete="off" name="addTeamName" id="AddTeamName" onchange="isDuplicateTeam('AddTeamName')" placeholder="Team Name" class="form-control bdrd4">
  </div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Team Leader's Name :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <input type="text" autocomplete="off" name="teamleadername" id="TeamLeaderName" placeholder="Team Leader's Name" class="form-control bdrd4">
  <input type="hidden" id="TeamAdminMemberCode" name="membercode">
  <input type="hidden" id="TeamAdminMemberUaid" name="memberuaid">
  </div>
  <div id="stateErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
</div>
<div class="clearfix mb30">

<div class="clearfix inner_box_bg">
<div class="row">
<div class="col-md-8 col-sm-8 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Member's Name :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <input type="text" autocomplete="off" name="membername" id="MemberName" placeholder="Member's Name" class="form-control bdrd4">
  <input type="hidden" id="MemberCode" name="membercode">
  <input type="hidden" id="MemberUaid" name="memberuaid">
  </div>
  <div id="cityErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
 <div class="form-group">
 <label style="font-size: 12px;font-weight: normal;">&nbsp;</label>
 <div class="input-group">
<button class="bt-link bt-radius btn-primary btn-block" type="button" onclick="return addMemberName('MemberOfTeamAppend')">Add</button>
</div>
 </div>
</div>
</div>
</div>

<div class="clearfix" id="MemberOfTeamAppend"></div>


</div>  

<div class="clearfix mtop10 mb10 text-right"> 
<button class="bt-link bt-radius bt-gray mrt10 close_box" type="button" onclick="clearVirtualMemberTable()">Cancel</button>
<button class="bt-link bt-radius bt-loadmore" type="button" onclick="return validateTeam()">Submit</button>
</div>
</form>                             
</div>
</div>

<div class="modal fade" id="warningVirtualDeleteTeam" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span><span class="text-danger">Do you really want to remove from this team ?..</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <input type="hidden" id="AddTeamRefBoxId" value="NA">
      <div class="modal-footer">
         <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="removeVirtualMember('AddTeamRefBoxId')">Yes</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="warningDeleteTeam" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span><span class="text-danger">Do you really want to remove from this team ?..</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
       <div class="modal-body warBody">
        <p style="font-size: 14px;"><span style="color: red;font-weight: 600;">Warning :- </span>After removing team member, All assigned project will reverse to assigner.</p>
      </div>     
      <input type="hidden" id="TeamRefBoxId" value="NA">
      <div class="modal-footer">
         <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="removeMember('TeamRefBoxId')">Yes</button>
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
            	<option value="mtdate">Date</option>
            	<option value="mtdepartment">Department</option>
            	<option value="mtteamname">Team Name</option>
            	<option value="mtadminname">Team Admin</option>
            	<option value="mtrefid">Team Members</option>
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
<div class="modal fade" id="warningDelete" tabindex="-1" role="dialog" aria-labelledby="deleteModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="delete">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;">Do you really want to delete this team ?</h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <div class="modal-footer">
      <input type="hidden" id="TeamId"/>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
        <button type="button" class="btn btn-primary" onclick="deleteTeam('NA')">Yes</button>
      </div>
    </div>
  </div>
</div>
<div class="noDisplay"><a href="#" id="DownloadExportedLink" download><button id="DownloadExported">Download</button></a></div>  
	<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>	
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>

<script type="text/javascript">
function deleteTeam(teamId){
	if(teamId=="NA"){
		teamId=$("#TeamId").val();
		showLoader();
		$.ajax({
			type : "GET",
			url : "DeleteRegisterdTeam111",
			dataType : "HTML",
			data : {				
				teamId : teamId
			},
			success : function(data){
				if(data=="pass"){	
					$("#warningDelete").modal('hide');
					location.reload(true);
//	 				$("#"+rowid).load("managetax.html #"+rowid);
				}else{
					document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
					$('.alert-show').show().delay(4000).fadeOut();
				}
			},
			complete : function(data){
				hideLoader();
			}
		});
	}else{
		$("#TeamId").val(teamId);
		$("#warningDelete").modal('show');
	}	
}
function resetTeamLeader(TeamLeaderName,TeamAdminMemberCode,TeamAdminMemberUaid){
	$("#"+TeamLeaderName).val("");$("#"+TeamAdminMemberCode).val("");$("#"+TeamAdminMemberUaid).val("");
	//remove previous team members
	clearVirtualMemberTable();
}
function isEditDuplicateTeam(TextBoxId,TeamrefBoxid){
	var teamname=$("#"+TextBoxId).val();
	var teamrefid=$("#"+TeamrefBoxid).val();
	showLoader(); 
	$.ajax({
			type : "POST",
			url : "IsEditDuplicateTeam111",
			dataType : "HTML",
			data : {	teamname : teamname,
				teamrefid : teamrefid
			},
			success : function(response){
				if(response=="pass"){
					 document.getElementById('errorMsg').innerHTML ='Team name already exist.';			
					 $("#"+TextBoxId).val("");
			 		 $('.alert-show').show().delay(4000).fadeOut();
				}
			},
			complete : function(data){
				hideLoader();
			}
	 });
}
function isDuplicateTeam(TextBoxId){
	var teamname=$("#"+TextBoxId).val();
	showLoader();
	 $.ajax({
			type : "POST",
			url : "IsDuplicateTeam111",
			dataType : "HTML",
			data : {	teamname : teamname
			},
			success : function(response){
				if(response=="pass"){
					 document.getElementById('errorMsg').innerHTML ='Team name already exist.';			
					 $("#"+TextBoxId).val("");
			 		 $('.alert-show').show().delay(4000).fadeOut();
				}
			},
			complete : function(data){
				hideLoader();
			}
	 });
}
function clearVirtualMemberTable(){
	showLoader();
	 $.ajax({
			type : "POST",
			url : "ClearMemberInTeam111",
			dataType : "HTML",
			data : {	
			},
			success : function(response){		
				$(".membergroup").remove();
			},
			complete : function(data){
				hideLoader();
			}
	 });	
}    
function validateUpdateTeam(){	    
	 var deptname=$("#UpdateDepartmentName").val();
	 var teamname=$("#UpdateTeamName").val();
	 var leadername=$("#UpdateLeaderName").val();
	 var leadercode=$("#UpdateTeamAdminMemberCode").val();
	 var leaderid=$("#UpdateTeamAdminMemberUaid").val();
	 var teamrefid=$("#TeamRefid").val();
	 
	 if(deptname==null||deptname==""){
			document.getElementById('errorMsg').innerHTML ='Please enter team department name !!';			
			 $('.alert-show').show().delay(4000).fadeOut();
			 return false;
		}
	 if(teamname==null||teamname==""){
			document.getElementById('errorMsg').innerHTML ='Please enter team name !!';			
			 $('.alert-show').show().delay(4000).fadeOut();
			 return false;
		}
	 if(leadername==null||leadername==""){
			document.getElementById('errorMsg').innerHTML ='Please enter team leader name !!';			
			 $('.alert-show').show().delay(4000).fadeOut();
			 return false;
		}
	 showLoader();
	 $.ajax({
			type : "POST",
			url : "UpdateNewTeam111",
			dataType : "HTML",
			data : {				
				deptname : deptname,
				teamname : teamname,
				leadername : leadername,
				leadercode : leadercode,
				leaderid : leaderid,
				teamrefid : teamrefid
			},
			success : function(response){
				if(response=="pass"){
					$('.fixed_right_box').removeClass('active');
					$('.addnew').show();
					document.getElementById('errorMsg1').innerHTML ='Successfully updated !!';			
					clearVirtualMemberTable();
					 $('.alert-show1').show().delay(3000).fadeOut();
					
					setTimeout(() => {
						location.reload();
					}, 3000);
				}
			},
			complete : function(data){
				hideLoader();
			}
	 });	
}

function validateTeam(){	    
	 var deptname=$("#AddDepartmentName").val();
	 var teamname=$("#AddTeamName").val();
	 var leadername=$("#TeamLeaderName").val();
	 var leadercode=$("#TeamAdminMemberCode").val();
	 var leaderid=$("#TeamAdminMemberUaid").val();
	 
	 if(deptname==null||deptname==""){
			document.getElementById('errorMsg').innerHTML ='Please enter team department name !!';			
			 $('.alert-show').show().delay(4000).fadeOut();
			 return false;
		}
	 if(teamname==null||teamname==""){
			document.getElementById('errorMsg').innerHTML ='Please enter team name !!';			
			 $('.alert-show').show().delay(4000).fadeOut();
			 return false;
		}
	 if(leadername==null||leadername==""){
			document.getElementById('errorMsg').innerHTML ='Please enter team leader name !!';			
			 $('.alert-show').show().delay(4000).fadeOut();
			 return false;
		}
	 showLoader();
	 $.ajax({
			type : "POST",
			url : "AddNewTeam111",
			dataType : "HTML",
			data : {				
				deptname : deptname,
				teamname : teamname,
				leadername : leadername,
				leadercode : leadercode,
				leaderid : leaderid
			},
			success : function(response){
				if(response=="pass"){
					$('.fixed_right_box').removeClass('active');
					$('.addnew').show();
					document.getElementById('errorMsg1').innerHTML ='Added Successfully !!';
					clearVirtualMemberTable();
					 $('.alert-show1').show().delay(3000).fadeOut();					
					setTimeout(() => {
						location.reload();
					}, 3000);
				}
			},
			complete : function(data){
				hideLoader();
			}
	 });	
}
function addUpdateMemberName(AppendId){  
	var date="<%=today%>";  
	var teamrefid=$("#TeamRefid").val();
	var mname=$("#UpdateMemberName").val();
	var mcode=$("#UpdateMemberCode").val();
	var muaid=$("#UpdateMemberUaid").val();

	if(mname==null||mname==""){
		document.getElementById('errorMsg').innerHTML ='Please enter member name !!';			
		 $('.alert-show').show().delay(4000).fadeOut();
		 return false;
	}
	var memberkey=getKey(40);
	showLoader();
	 $.ajax({
			type : "POST",
			url : "AddMemberInMainTeam111",
			dataType : "HTML",
			data : {				
				mname : mname,
				mcode : mcode,
				muaid : muaid,
				teamrefid : teamrefid,
				memberkey : memberkey
			},
			success : function(response){
			if(response=="pass")		{
				$("#UpdateMemberName").val("");
				$("#UpdateMemberCode").val("");
				$("#UpdateMemberUaid").val("");
				$(''+
						'<div class="clearfix bg_wht membergroup" style="padding-left: 13px;" id="'+memberkey+'">'+
				'<div class="col-md-3 box-intro-background">'+
					'<div class="clearfix">'+
						'<p class="news-border">'+date+'</p>'+
					'</div>'+
				'</div>	'+
				'<div class="col-md-3 box-intro-background">'+
					'<div class="clearfix">'+
						'<p class="news-border">'+mcode+'</p>'+
					'</div>'+
				'</div>'+
					'<div class="col-md-5 box-intro-background">'+
						'<div class="clearfix">'+
							'<p class="news-border" title="">'+mname+'</p>'+
						'</div>'+
				'</div>'+
				'<div class="box-width22 col-xs-1 box-intro-background">'+
					'<div class="clearfix">'+
						'<p class="news-border fas fa-trash pointers text-danger" onclick="removeThisMember(\''+memberkey+'\')" title="Remove" style="font-size: 18px;color: #e80e0e;"></p>'+
					'</div>'+
				'</div>'+
				'</div>').insertBefore('#'+AppendId);				
			}else{
				 document.getElementById('errorMsg').innerHTML ='Something went wrong ,Try-again later.';				 
		 		    $('.alert-show').show().delay(4000).fadeOut();
			 }		
			},
			complete : function(data){
				hideLoader();
			}
		});		
}

function removeVirtualMember(memrefidBoxId){
	var memrefid=$("#"+memrefidBoxId).val();
	showLoader(); 
	$.ajax({
			type : "GET",
			url : "DeleteVirtualMemberInTeam111",
			dataType : "HTML",
			data : {				
				memrefid : memrefid
			},
			success : function(response){
			if(response=="pass")		{
				$("#"+memrefid).remove();				
			}else{
				document.getElementById('errorMsg').innerHTML ='Something went wrong ,Try-again later.';				 
	 		    $('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function(data){
			hideLoader();
		}
	 });
}

function removeMember(memrefidBoxId){
	var memrefid=$("#"+memrefidBoxId).val();
	showLoader(); 
	$.ajax({
			type : "GET",
			url : "DeleteMemberInTeam111",
			dataType : "HTML",
			data : {				
				memrefid : memrefid
			},
			success : function(response){
			if(response=="pass")		{
				$("#"+memrefid).remove();				
			}else{
				document.getElementById('errorMsg').innerHTML ='Something went wrong ,Try-again later.';				 
	 		    $('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function(data){
			hideLoader();
		}
	 });
}
function addMemberName(AppendId){  
	var date="<%=today%>";
	var mname=$("#MemberName").val();
	var mcode=$("#MemberCode").val();
	var muaid=$("#MemberUaid").val();

	if(mname==null||mname==""){
		document.getElementById('errorMsg').innerHTML ='Please enter member name !!';			
		 $('.alert-show').show().delay(4000).fadeOut();
		 return false;
	}
	var memberkey=getKey(40);
	showLoader();
	 $.ajax({
			type : "POST",
			url : "AddMemberInTeam111",
			dataType : "HTML",
			data : {				
				mname : mname,
				mcode : mcode,
				muaid : muaid,
				memberkey : memberkey
			},
			success : function(response){
			if(response=="pass")		{
				$("#MemberName").val("");
				$("#MemberCode").val("");
				$("#MemberUaid").val("");
				$(''+
						'<div class="clearfix bg_wht membergroup" style="padding-left: 13px;" id="'+memberkey+'">'+
				'<div class="col-md-3 box-intro-background">'+
					'<div class="clearfix">'+
						'<p class="news-border">'+date+'</p>'+
					'</div>'+
				'</div>	'+
				'<div class="col-md-3 box-intro-background">'+
					'<div class="clearfix">'+
						'<p class="news-border">'+mcode+'</p>'+
					'</div>'+
				'</div>'+
					'<div class="col-md-5 box-intro-background">'+
						'<div class="clearfix">'+
							'<p class="news-border" title="">'+mname+'</p>'+
						'</div>'+
				'</div>'+
				'<div class="box-width22 col-xs-1 box-intro-background">'+
					'<div class="clearfix">'+
						'<p class="news-border fas fa-trash pointers text-danger" onclick="deleteVirtualMember(\''+memberkey+'\')" title="Remove" style="font-size: 18px;color: #e80e0e;"></p>'+
					'</div>'+
				'</div>'+
				'</div>').insertBefore('#'+AppendId);				
			}else{
				 document.getElementById('errorMsg').innerHTML ='Something went wrong ,Try-again later.';				 
		 		    $('.alert-show').show().delay(4000).fadeOut();
			 }		
			},
			complete : function(data){
				hideLoader();
			}
		});		
}
function fillTeamDetails(teamrefid){
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetMemberInTeam111",
		dataType : "HTML",
		data : {				
			teamrefid : teamrefid
		},
		success : function(response){
			if(Object.keys(response).length!=0){
				response = JSON.parse(response);			
				 var len = response.length;		 
				 if(len>0){
					 for(var i=0;i<len;i++){	
						 var id=response[i]["tmid"];
							var refid=response[i]["tmrefid"];
							var date=response[i]["tmdate"];
							var usercode=response[i]["tmusercode"];
							var userid=response[i]["tmuseruid"];
							var username=response[i]["tmusername"];
						 
					$(''+
							'<div class="clearfix bg_wht editmembergroup" style="padding-left: 13px;" id="'+refid+'">'+
					'<div class="col-md-3 box-intro-background">'+
						'<div class="clearfix">'+
							'<p class="news-border">'+date+'</p>'+
						'</div>'+
					'</div>	'+
					'<div class="col-md-3 box-intro-background">'+
						'<div class="clearfix">'+
							'<p class="news-border">'+usercode+'</p>'+
						'</div>'+
					'</div>'+
						'<div class="col-md-5 box-intro-background">'+
							'<div class="clearfix">'+
								'<p class="news-border" title="">'+username+'</p>'+
							'</div>'+
					'</div>'+
					'<div class="box-width22 col-xs-1 box-intro-background">'+
						'<div class="clearfix">'+
							'<p class="news-border fas fa-trash pointers text-danger" onclick="removeThisMember(\''+refid+'\')" title="Remove" style="font-size: 18px;color: #e80e0e;"></p>'+
						'</div>'+
					'</div>'+
					'</div>').insertBefore('#EditMemberOfTeamAppend');		
						 } }
				}else{
					 document.getElementById('errorMsg').innerHTML ='Member Not Found !! Please Add Team Member !!.';				 
			 		    $('.alert-show').show().delay(4000).fadeOut();
				 }		
				},
				complete : function(data){
					hideLoader();
				}
			});		
}
function deleteVirtualMember(mrefid){
	$("#AddTeamRefBoxId").val(mrefid);
	$("#warningVirtualDeleteTeam").modal("show");
}
function removeThisMember(mrefid){
	$("#TeamRefBoxId").val(mrefid);
	$("#warningDeleteTeam").modal("show");
}
function openUpdateTeam(teamrefid,department,teamname,adminname,admincode,adminid){	   
	$("#UpdateDepartmentName").empty();
	$("#UpdateDepartmentName").append("<option value='"+department+"'>"+department+"</option>");
	$("#UpdateTeamName").val(teamname);
	$("#UpdateLeaderName").val(adminname);$("#UpdateTeamAdminMemberCode").val(admincode);
	$("#UpdateTeamAdminMemberUaid").val(adminid);$("#TeamRefid").val(teamrefid);
	$(".editmembergroup").remove();
	fillTeamDetails(teamrefid);
	var id = $(".updateteam").attr('data-related'); 
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });		
}
function openTeam(){
	$(".membergroup").remove();
	$("#AddNewTeam").trigger('reset');	
	var id = $(".addteam").attr('data-related'); 
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });		
}

$(function() {
	$("#UpdateLeaderName").autocomplete({
		source : function(request, response) {
			var department=$("#UpdateDepartmentName").val();
			$.ajax({
				url : "<%=request.getContextPath()%>/getloginuser.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					department : department,
					field: "loginusername",
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							uaid : item.uaid,
							uaempid : item.uaempid,
							uname : item.uname
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
            	document.getElementById('errorMsg').innerHTML ="Select user name from list";
            	$("#UpdateLeaderName").val("");  
            	$("#UpdateTeamAdminMemberCode").val(""); 
            	$("#UpdateTeamAdminMemberUaid").val(""); 
            	$('.alert-show').show().delay(2000).fadeOut();            	
            }
            else{               	
            	$("#UpdateLeaderName").val(ui.item.uname);
            	$("#UpdateTeamAdminMemberCode").val(ui.item.uaempid); 
            	$("#UpdateTeamAdminMemberUaid").val(ui.item.uaid); 
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});	

$(function() {
	$("#TeamLeaderName").autocomplete({
		source : function(request, response) {
			var department=$("#AddDepartmentName").val();
			$.ajax({
				url : "<%=request.getContextPath()%>/getloginuser.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					department : department,
					field: "loginusername",
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							uaid : item.uaid,
							uaempid : item.uaempid,
							uname : item.uname
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
            	document.getElementById('errorMsg').innerHTML ="Select user name from list";
            	$("#TeamLeaderName").val("");  
            	$("#TeamAdminMemberCode").val(""); 
            	$("#TeamAdminMemberUaid").val(""); 
            	$('.alert-show').show().delay(2000).fadeOut();            	
            }
            else{               	
            	$("#TeamLeaderName").val(ui.item.uname);
            	$("#TeamAdminMemberCode").val(ui.item.uaempid); 
            	$("#TeamAdminMemberUaid").val(ui.item.uaid); 
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});	
$(function() {
	$("#UpdateMemberName").autocomplete({
		source : function(request, response) {
			var teamrefid=$("#TeamRefid").val();
			var department=$("#UpdateDepartmentName").val();
			$.ajax({
				url : "<%=request.getContextPath()%>/getloginuser.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field: "editloginusermembername",
					teamrefid : teamrefid,
					department : department
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							uaid : item.uaid,
							uaempid : item.uaempid,
							uname : item.uname
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
            	document.getElementById('errorMsg').innerHTML ="Select user name from list";
            	$("#UpdateMemberName").val("");  
            	$("#UpdateMemberCode").val(""); 
            	$("#UpdateMemberUaid").val(""); 
            	$('.alert-show').show().delay(2000).fadeOut();            	
            }
            else{               	
            	$("#UpdateMemberName").val(ui.item.uname);
            	$("#UpdateMemberCode").val(ui.item.uaempid); 
            	$("#UpdateMemberUaid").val(ui.item.uaid); 
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});	
$(function() {
	$("#MemberName").autocomplete({
		source : function(request, response) {
			var department=$("#AddDepartmentName").val();
			$.ajax({
				url : "<%=request.getContextPath()%>/getloginuser.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					department : department,
					field: "loginusermembername",
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							uaid : item.uaid,
							uaempid : item.uaempid,
							uname : item.uname
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
            	document.getElementById('errorMsg').innerHTML ="Select user name from list";
            	$("#MemberName").val("");  
            	$("#MemberCode").val(""); 
            	$("#MemberUaid").val(""); 
            	$('.alert-show').show().delay(2000).fadeOut();            	
            }
            else{               	
            	$("#MemberName").val(ui.item.uname);
            	$("#MemberCode").val(ui.item.uaempid); 
            	$("#MemberUaid").val(ui.item.uaid); 
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});	
function updateCashFlow(refid,Id){
	var status="0";
	if($('#CashFlowId'+Id).is(":checked")){
		status="1";
	}else{
		status="2";
	}
	var xhttp; 
	xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
	if (this.readyState == 4 && this.status == 200) {
	}
	};
	xhttp.open("POST", "<%=request.getContextPath()%>/UpdateCashFlow111?status="+status+"&refid="+refid, true); 
	xhttp.send();
}	
	
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
<script type="text/javascript">
$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var data=$(this).val();
	doAction(data,"teamDateRangeAction");
	location.reload();
});

$('input[name="date_range"]').daterangepicker({
	  autoUpdateInput: false,
	  autoApply: false,
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
	   var dateRangeDoAction="<%=teamDateRangeAction%>";
	   if(dateRangeDoAction!="NA"){	  
		   $('input[name="date_range"]').val(dateRangeDoAction);
	   }
	});
$(function() {
	$("#Team_Name").autocomplete({
		source : function(request, response) {
			$.ajax({
				url : "GetTeamData111",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field: "teamName"
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
            	doAction(ui.item.value,"teamNameDoAction");
            	location.reload(true);
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
			type : "Team"
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
</script>
</body>
</html>