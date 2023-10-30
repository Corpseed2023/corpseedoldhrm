<%@page import="commons.CommonHelper"%>
<%@page import="java.nio.file.Path"%>
<%@page import="java.util.Properties"%>
<%@page import="commons.DateUtil"%>
<%@page import="client_master.Clientmaster_ACT"%>
<%@page import="commons.AzureBlob"%>
<%@page import="com.azure.storage.blob.BlobClientBuilder"%>
<%@page import="com.azure.storage.blob.models.BlobProperties"%>
<%@page import="org.docx4j.org.xhtmlrenderer.css.style.Length"%>
<%@page import="admin.enquiry.Enquiry_ACT"%>
<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Edit Task</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/staticresources/css/editor.css"/>

</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %> 
<%
String assignKey=request.getParameter("uid").trim();

assignKey=assignKey.substring(9,assignKey.length()-5);
String today=DateUtil.getCurrentDateIndianFormat1();
String addedby= (String)session.getAttribute("loginuID");
String reupload=request.getParameter("reupload");

String chatOpenBox= request.getParameter("typ");
if(chatOpenBox==null||chatOpenBox.length()<=0)chatOpenBox="NA";

String token=(String)session.getAttribute("uavalidtokenno");
String userRole=(String)session.getAttribute("userRole");
String dateToday=DateUtil.getCurrentDateIndianFormat1();
String salesrefid="NA";
String salesPayType="NA";
String milestoneKey="NA";
String workStartPrice="0";
String taskStatus="NA";
String assigneeUid="NA";
String marefid="NA";
double taskProgress=0;
String milestone[][]=TaskMaster_ACT.getAssignedSalesKey(assignKey,token); 
if(milestone!=null&&milestone.length>0){
	salesrefid=milestone[0][1];
	marefid=milestone[0][0];
	assigneeUid=milestone[0][2];
	milestoneKey=milestone[0][3];	
	taskStatus=milestone[0][6];
	taskProgress=Integer.parseInt(milestone[0][5]);
}
if(!salesrefid.equalsIgnoreCase("NA"))
	salesPayType=TaskMaster_ACT.getSalesPayType(salesrefid,token);
	
String product[]=TaskMaster_ACT.getProductNameAndKey(milestoneKey,token);
if(product[0]!=null&&!product[0].equalsIgnoreCase("NA")){
	if(salesPayType.equalsIgnoreCase("Milestone Pay"))
		workStartPrice=milestone[0][10];
	else
		workStartPrice=TaskMaster_ACT.getWorkPricePercentage(product[0],product[1],token);
}
String closeDate=Enquiry_ACT.getSalesCloseDate(salesrefid,token);
if(closeDate==null||closeDate.length()<=0)closeDate="NA";
// double salesProgress=Enquiry_ACT.getSalesWorkProgress(salesrefid,token);
String contactefid=TaskMaster_ACT.getSalesContactrefid(salesrefid,token);
String compaddress=TaskMaster_ACT.getCompanyAddress(salesrefid,token);
String jurisdiction=TaskMaster_ACT.getSalesJurisdiction(salesrefid,token);

String companyname="NA";
String projectNo="NA";
String productName="Not Found";
String contactName="Not Found";
String contactEmail="Not Found";
String contactPhone="Not Found";
String clientKey="NA";
String teamKey="NA";
String productType="Not Found";
String workStarted="00-00-0000";
String workStartedTime="00:00";
String milestoneName="NA";
String data=TaskMaster_ACT.getCompanyName(salesrefid,token);
String x[]=data.split("#");
companyname=x[0];
projectNo=x[1];
productName=x[2];
clientKey=x[3];
teamKey=x[4];
productType=x[5];
String teamLeaderUid=TaskMaster_ACT.getTeamLeaderId(teamKey, token);
String clientLoc=TaskMaster_ACT.getClientlocation(clientKey,token);
String contact[][]=Enquiry_ACT.getClientDetails(contactefid, token);
String clientNo=Clientmaster_ACT.getClientNumberByKey(clientKey, token);
int loginStatus=Usermaster_ACT.getLoginStatus(clientNo, token);
String loginClass="offline";
String loginTitle="Offline";
if(loginStatus==1){
	loginClass="online";
	loginTitle="Online";
}
if(contact!=null&&contact.length>0){contactName=contact[0][0];contactEmail=contact[0][5];contactPhone=contact[0][1];}
String uaid = (String) session.getAttribute("loginuaid");

String loginUserName=Usermaster_ACT.getLoginUserName(uaid, token);
//getting all dynamic form template
String template[][]=TaskMaster_ACT.getAllFormTemplate(token);

String activityType=(String)session.getAttribute("searchByActivity");
if(activityType==null||activityType.length()<=0)activityType="NA";
String workStatusIcon="NA";
String workStatusClass="";
if(taskStatus.equalsIgnoreCase("New")){
	workStatusClass="task_new";	
	workStatusIcon="New";
}else if(taskStatus.equalsIgnoreCase("Open")){
	workStatusClass="task_open";
	workStatusIcon="Open";
}else if(taskStatus.equalsIgnoreCase("Pending")){
	workStatusClass="task_pending";
	workStatusIcon="Pending";
}	else if(taskStatus.equalsIgnoreCase("Expired")){
	workStatusClass="task_expired";
	workStatusIcon="Expired";
}else if(taskStatus.equalsIgnoreCase("On-Hold")){
	workStatusClass="task_hold";
	workStatusIcon="On-Hold";
}else if(taskStatus.equalsIgnoreCase("Completed")){
	workStatusClass="task_completed";
	workStatusIcon="Completed";
}
String companyIndustry=Clientmaster_ACT.findCompanyIndustry(clientKey,token);
Properties properties = new Properties();
properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
String docpath=properties.getProperty("path")+"documents";
String azure_key=properties.getProperty("azure_key");
String azure_container=properties.getProperty("azure_container");
String azure_path=properties.getProperty("azure_path");
String domain=properties.getProperty("corpseed_domain");

String currentTime=DateUtil.getCurrentTime24Hours();
String country[][]=TaskMaster_ACT.getAllCountries();
%>
<%if(!MT01){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
<div class="main-content">
<div class="container">
<div class="row">
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="menuDv pad_box4">
<form method="post">
<div class="task_lft_box">
<p class="<%=workStatusClass%>"><%=workStatusIcon %></p>
<h3><span id="onlineOffline" class="<%=loginClass %>" title="<%=loginTitle%>"></span><%=contactName %></h3>
<p><a href="#" onclick="loadServiceDetails('<%=salesrefid %>')" class="tooltips1 visible"><i class="fa fa-info-circle" aria-hidden="true"></i><span class="tooltiptext">More Details</span></a>&nbsp;&nbsp;<%=companyname %>&nbsp;(<%=companyIndustry %>)</p>
<%-- <p><%=productName %>&nbsp;( <%=jurisdiction %> )</p> --%>
<div class="location_box">
<i><img src="<%=request.getContextPath() %>/staticresources/images/location_icon.png" alt=""/></i><span><%=clientLoc %></span> 
</div>

<div class="clearfix mbt20 box_shadow1" id="TeamAdminAssignedTaskId">
<div class="clearfix task search_section"> 
<h4 class="normal_txt trnsclient "><span>My Task</span>
<a href="#" onclick="transferRetrieve('<%=milestone[0][0]%>','<%=milestone[0][12]%>')">
<%if(milestone[0][12].equals("3")||milestone[0][12].equals("2")) {%>Transfer to client<%}else{ %>
Retrieve from client
<%} %>
</a></h4> 
</div>
<%if(milestone!=null&&milestone.length>0){ 
	workStarted=milestone[0][9];
	workStarted=workStarted.substring(6)+workStarted.substring(2, 6)+workStarted.substring(0, 2);	
	workStartedTime=milestone[0][11];
	if(workStartedTime.equalsIgnoreCase("NA"))workStartedTime="09:00";
	milestoneName=milestone[0][4];%>
	
	<div class="clearfix MyTaskAssigned">
	<div class="clearfix inner_section"> 
	<span class="icon_box1 text-center">T</span> 
	<span class="text_box1"><label><%=milestone[0][4] %></label><span><%=milestone[0][7] %></span></span>
	<span class="link_icon text-center toggleBtn"><i onclick="showAssignBox('TaskAssignedMeId')"><img src="<%=request.getContextPath()%>/staticresources/images/down_arrow.png" alt=""></i></span>
	</div>
	<div class="clearfix padBox0 marg0 access_box_info toggleBox" id="TaskAssignedMeId"> 
	<div class="bg_ltgray pad_box3 pad-lft10 pad-rt10">
	<div class="form-group">
	<label>Task </label> 
	<div class="input-group">
	<span class="input-group-addon"><i class="form-icon fa fa-check"></i></span>
	<input type="text" name="task" id="Task" placeholder="" value="<%=milestone[0][4] %>" class="form-control" readonly="readonly">
	</div>
	</div>
	<div class="form-group">
	<label>Work Completed (%)</label>
	<div class="input-group">
	<span class="input-group-addon"><i class="form-icon fa fa-circle-o-notch"></i></span> 
	<input type="number" name="taskdate" min="0" max="100" value="<%=milestone[0][5] %>" onchange="validateNumber(this.value,'TaskPercentagedone')" id="TaskPercentagedone" placeholder="Percentage" class="form-control" onkeypress="return isNumber(event)">
	</div>
	</div>
	<div class="clearfix mtop10 mb10 row">
	<div class="col-md-12 col-sm-12 col-xs-12">
	<div class="clearfix tips mtop10">
	<div class="tooltips pointers" data-related="Task_Step" onclick="openToolTipBox('<%=milestone[0][4] %>')">Task Tips<i class="fa fa-lightbulb-o"></i>
		
	</div>
	</div>
	</div>
	<div class="col-md-12 col-sm-12 col-xs-12 text-right">  
	<button class="bt-link bt-radius bt-gray cancelBtn" type="button" onclick="hideAssignBox('TaskAssignedMeId')">Cancel</button>
	<button class="bt-link bt-radius bt-loadmore" type="button" onclick="saveWorkPercentage('<%=milestone[0][0] %>','TaskPercentagedone','<%=milestone[0][3] %>')">Save</button>
	</div>
	</div>
	</div>
	</div>
	</div>
<%} %>
</div>

<div class="clearfix mbt20 box_shadow1">
<div class="clearfix search_section"> 
<h4 class="normal_txt"><span>Reminders</span></h4> 
<span class="search_icon text-center toggleBtn"><i onclick="showAssignBox('TaskAssignedReminderId1')"><img src="<%=request.getContextPath() %>/staticresources/images/plus_icon.png" alt=""/></i></span>
</div>
<form onsubmit="return false">
<div class="clearfix padBox0 marg0 access_box_info toggleBox" id="TaskAssignedReminderId1"> 
<div class="bg_ltgray pad_box3 pad-lft10 pad-rt10">
<div class="form-group">
<label>Task </label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-check"></i></span>
<input type="text" autocomplete="off" name="remindertask" id="ReminderTask" placeholder="Enter Task" value="" class="form-control" />
</div>
</div>
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
<label>Time</label>
<div class="input-group">
 <span class="input-group-addon"><i class="form-icon fa fa-clock-o"></i></span>
<input type="text" autocomplete="off" name="Remindertime" id="ReminderTime" placeholder="Time" class="form-control pointers timepicker" readonly="readonly"/>
</div>
</div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
<label>Date</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-calendar"></i></span> 
<input type="text" autocomplete="off" name="Reminderdate" autocomplete="off" id="ReminderDate" placeholder="DD-MM-YYYY" class="searchdate form-control pointers" readonly="readonly"/>
</div>
<div id="dateEerorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="clearfix mtop10 mb10 text-right">
<button class="bt-link bt-radius bt-gray cancelBtn" type="button" onclick="hideAssignBox('TaskAssignedReminderId1')">Cancel</button>
<button class="bt-link bt-radius bt-loadmore" type="button" onclick="return saveReminder()">Save</button>
</div>
</div>
</div>
</form>
<div class="clearfix reminder" id="ReloadReminder"> 
<div class="clearfix" id="ReloadReminder1">
<%
String reminders[][]=TaskMaster_ACT.getAllReminders(salesrefid,uaid,userRole,teamLeaderUid,token);  
if(reminders!=null&&reminders.length>0){
	for(int i=0;i<reminders.length;i++){		
		String userName=Usermaster_ACT.getLoginUserName(reminders[i][5], token);
		String shortName=userName.substring(0,2);
		String display="toggle_box";
		if(reminders[i][4].equalsIgnoreCase("2"))display="";
		
%>
<div class="clearfix inner_section" id="ReminderRow<%=i%>">
<div class="col-md-12 crossTask <%=display %>" id="TaskReminderClose<%=i%>">&nbsp;</div> 
<span class="icon_box1 text-center" title="<%=userName%> !!"><%=shortName %></span> 
<span class="text_box1"><label><%=reminders[i][1] %></label><span><%=reminders[i][2] %></span></span> 
<span class="link_icon text-center toggleBtn mrt10"><i onclick="showAssignBox('TaskAssignedAddReminderId<%=i%>')" title="Update Reminder"><img src="<%=request.getContextPath() %>/staticresources/images/edit_icon.png" alt=""/></i></span>
<span class="link_icon text-center" onclick="closeReminder('<%=reminders[i][0] %>','TaskReminderClose<%=i%>')" title="Close Reminder"><img src="<%=request.getContextPath() %>/staticresources/images/checked_icon.png" alt=""/></span>
</div>
<div class="clearfix padBox0 marg0 access_box_info toggleBox" id="TaskAssignedAddReminderId<%=i%>"> 
<div class="bg_ltgray pad_box3 pad-lft10 pad-rt10">
<div class="form-group">
<label>Task </label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-check"></i></span>
<input type="text" autocomplete="off" name="updateremindertask<%=i%>" id="UpdateReminderTask<%=i%>" placeholder="Task" value="<%=reminders[i][1] %>" class="form-control" />
</div>
</div>
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
<label>Time</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-clock-o"></i></span>
<input type="text" name="updateremindertime<%=i%>" onclick="openClock('UpdateReminderTime<%=i%>')" id="UpdateReminderTime<%=i%>" value="<%=reminders[i][3]%>" class="form-control timepicker" readonly="readonly"/>
</div>
</div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
<label>Date</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-calendar"></i></span> 
<input type="text" autocomplete="off" onclick="openCalendar('UpdateReminderDate<%=i%>')" name="updatereminderdate<%=i%>" autocomplete="off" id="UpdateReminderDate<%=i%>" value="<%=reminders[i][2] %>" placeholder="DD-MM-YYYY" class="searchdate form-control pointers" readonly="readonly"/>
</div>
</div>
</div>
</div>
<div class="clearfix mtop10 mb10 text-right">
<button class="bt-link bt-radius bt-gray cancelBtn" type="button" onclick="hideAssignBox('TaskAssignedAddReminderId<%=i%>')">Cancel</button>
<button class="bt-link bt-radius bt-loadmore" type="button" onclick="return updateReminder('<%=reminders[i][0] %>','<%=i%>')">Update</button>
</div>
</div>
</div>
<%}} %>
</div>
</div>
</div>

<div class="clearfix mbt20 box_shadow1">
<div class="clearfix search_section"> 
<h4 class="normal_txt"><span>Contacts</span> &nbsp <span class="count_number"></span></h4> 
<span class="search_icon text-center addnew1" data-related="add_contact" onclick="openContactBox('<%=contactefid%>')"><i><img src="<%=request.getContextPath() %>/staticresources/images/plus_icon.png" alt=""/></i></span>
</div> 
<div class="clearfix reminder contacts"> 
<div class="clearfix" id="RefreshContacts">
<div class="clearfix" id="RefreshContacts1">
<%
if(contact!=null&&contact.length>0){
	for(int i=0;i<contact.length;i++){
%>
<div class="clearfix inner_section">  
<span class="pad-lft0 text_box1 pdtop9"><label><%=contact[i][0] %></label></span> 
<span class="link_icon text-center toggleBtn mrt10"><i class="clickeble updatecontactbox" data-related="update_contact" onclick="openUpdateContactBox('<%=contact[i][3] %>','<%=contact[i][2] %>')"><img src="<%=request.getContextPath() %>/staticresources/images/edit_icon.png" alt=""/></i></span>
<span class="link_icon text-center"><i onclick="showContact('<%=contact[i][0] %>','<%=contact[i][1] %>','<%=contact[i][4] %>','mobile')"><img src="<%=request.getContextPath() %>/staticresources/images/phone_icon.png" alt=""/></i></span>
<span class="link_icon text-center"><i onclick="showContact('<%=contact[i][0] %>','<%=contact[i][5] %>','<%=contact[i][6] %>','email')"><img src="<%=request.getContextPath() %>/staticresources/images/sms_icon.png" alt=""/></i></span>
</div>
<%}} %>
</div>
</div>
<div class="pad_box3 pad-lft10 pad-rt10 contacts_info DispNone"  id="ContactMobileDiv">
<div class="clearfix">
<div class="pad0 col-md-4 col-sm-4 col-xs-12">
<div class="mb10">
<span class="txt_blue">Name</span>
</div>
</div>
<div class="pad0 col-md-8 col-sm-8 col-xs-12">
<div class="mb10">
<span class="txt_blue" id="FirstContactMobileName"></span>
</div>
</div>
</div>
<div class="clearfix">
<div class="pad0 col-md-4 col-sm-4 col-xs-12">
<div class="mb10">
<span class="txt_blue">Mobile</span>
</div>
</div>
<div class="pad0 col-md-8 col-sm-8 col-xs-12">
<div class="mb10">
<span class="txt_blue" id="FirstContactMobile"></span>
</div>
</div>
</div>
<div class="clearfix" id="SecondContactMobileDisp">
<div class="pad0 col-md-4 col-sm-4 col-xs-12">
<div class="mb10">
<span class="txt_blue">Alt. mobile</span>
</div>
</div>
<div class="pad0 col-md-8 col-sm-8 col-xs-12">
<div class="mb10">
<span class="txt_blue" id="SecondContactMobile"></span>
</div>
</div>
</div>
</div>
<div class="pad_box3 pad-lft10 pad-rt10 contacts_info DispNone" id="ContactEmailDiv">
<div class="clearfix">
</div>
<div class="clearfix">
<div class="pad0 col-md-4 col-sm-4 col-xs-12">
<div class="mb10">
<span class="txt_blue">Name</span>
</div>
</div>
<div class="pad0 col-md-8 col-sm-8 col-xs-12">
<div class="mb10">
<span class="txt_blue" id="FirstContactEmailName"></span>
</div>
</div>
</div>
<div class="clearfix">
<div class="pad0 col-md-4 col-sm-4 col-xs-12">
<div class="mb10">
<span class="txt_blue">Email</span>
</div>
</div>
<div class="pad0 col-md-8 col-sm-8 col-xs-12">
<div class="mb10"> 
<span class="txt_blue" id="FirstContactEmail"></span>
</div>
</div>
</div>
<div class="clearfix" id="SecondContactEmailDisp">
<div class="pad0 col-md-4 col-sm-4 col-xs-12">
<div class="mb10">
<span class="txt_blue">Alt. email</span>
</div>
</div>
<div class="pad0 col-md-8 col-sm-8 col-xs-12" >
<div class="mb10"> 
<span class="txt_blue" id="SecondContactEmail"></span>
</div>
</div>
</div>
</div>
</div>
</div>

</div>

</form>
</div>
<button class="btn-warning btn-block form-control info-extra bold_txt expense" data-related="add_expense" onclick="openExpense()" type="button">+&nbsp;Expense</button>
</div>
<div class="col-md-8 col-sm-8 col-xs-12"> 
<form method="post">
<div class="task_rt_box">
 
<div class="filterBox relative_box">
<div class="row">
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="filterBox_inner">
<div class="filterBox_title"><img src="<%=request.getContextPath() %>/staticresources/images/arrow_down1.png" alt=""/> All Activities</div>
<ul class="filterBox_dropdown">
<li><a onclick="doAction('NA','searchByActivity');"><span class="dot_circle0"></span>All</a></li>
<li><a onclick="doAction('Call log','searchByActivity');"><span class="dot_circle"></span>Call logs</a></li>
<li><a onclick="doAction('Email','searchByActivity');"><span class="dot_circle1"></span>Email</a></li>
<li><a onclick="doAction('Public Reply','searchByActivity');"><span class="dot_circle2"></span>Chats</a></li>
<li><a onclick="doAction('Note','searchByActivity');"><span class="dot_circle3"></span>Note</a></li>
<li><a onclick="doAction('Notification','searchByActivity');"><span class="dot_circle4"></span>Notification</a></li>
<li><a onclick="doAction('Reminder','searchByActivity');"><span class="dot_circle5"></span>Reminders</a></li>
<li><a onclick="doAction('Expense','searchByActivity');"><span class="dot_circle6"></span>Expense</a></li>
</ul> 
</div>
</div>
<div class="flex_box justify_end col-md-8 col-sm-8 col-xs-12"> 
<div class="filterBox_inner"> 
<div class="filterBox_title box_shadow1"><span>Follow up</span></div>
<ul class="filterBox_dropdown"><%if(closeDate.equalsIgnoreCase("NA")){ %>
<li><a class="openChat" data-related="open_chat" onclick="openChatBox()">Chat</a></li><%} %>
<li><a onclick="focusTextara('newCallLogsId','CallLogNotesId')">Call log</a></li>
<li><a onclick="focusTextara('newNotesDivId','NewNotesBoxId')">Note</a></li>
<li><a onclick="focusTextara('newNotesSalesDivId','NewNotesSalesBoxId')">Note(Sales)</a></li>
</ul> 
</div>
<div class="filterBox_inner">
<div class="filterBox_title box_shadow1 adddoc" data-related="add_document" onclick="openDocumentBox()"><span>Documents</span></div>
</div>
</div>
</div>
</div>

<div class="contentBox"> 
<ul class="contentBoxLft">
<li style="display: none;" id="newCallLogsId">
<span><img src="<%=request.getContextPath() %>/staticresources/images/phone_icon.png" alt=""/></span>
<div class="contentInnerBox contentInnerBox1 box_shadow1 relative_box mb10"> 
<div class="call_log_box">
<div class="contentBox1"> 
<p><textarea placeholder="Call Log...." rows="5" id="CallLogNotesId" class="textarea_brd"></textarea></p>
</div> 
<div class="contentBox2">
<div class="row">
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="clearfix"><span class="pointers" onclick="removeCallNotes('newCallLogsId','CallLogNotesId')"><img src="<%=request.getContextPath() %>/staticresources/images/delete_icon.png" alt=""/></span></div>
</div>
<div class="col-md-8 col-sm-8 col-xs-12">
<div class="clearfix flex_box justify_end">
<select class="box_shadow1" id="AddCallLogOptId" name="">
<%
if(contact!=null&&contact.length>0){
	for(int i=0;i<contact.length;i++){
%>
<option value="<%=contact[i][0]%>#<%=contact[i][1]%>#<%=contact[i][5]%>"><%=contact[i][0]%>@<%=contact[i][1]%></option>
<%}}%>
</select>

<button class="box_shadow1" type="button" onclick="return addCallLogNotes('CallLogNotesId')"><img src="<%=request.getContextPath() %>/staticresources/images/checked_icon.png" alt=""/></button>
</div>
</div>
</div>
</div>
</div>
</div>
</li>
<li style="display: none;" id="newNotesDivId">
<span><img src="<%=request.getContextPath() %>/staticresources/images/notes.webp" alt=""/></span>
<div class="contentInnerBox contentInnerBox1 box_shadow1 relative_box mb10"> 
<div class="call_log_box">
<div class="contentBox1"> 
<p><textarea placeholder="Notes...." rows="5" id="NewNotesBoxId" class="textarea_brd"></textarea></p>
</div> 
<div class="contentBox2">
<div class="row">
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="clearfix"><span class="pointers" onclick="removeCallNotes('newNotesDivId','NewNotesBoxId')"><img src="<%=request.getContextPath() %>/staticresources/images/delete_icon.png" alt=""/></span></div>
</div>
<div class="col-md-8 col-sm-8 col-xs-12">
<div class="clearfix flex_box justify_end">
<select class="box_shadow1" id="AddNotesOptId" name="">
<%
if(contact!=null&&contact.length>0){
	for(int i=0;i<contact.length;i++){
%>
<option value="<%=contact[i][0]%>#<%=contact[i][1]%>#<%=contact[i][5]%>"><%=contact[i][0]%>@<%=contact[i][1]%></option>
<%}}%>
</select>

<button class="box_shadow1" type="button" onclick="return addTaskNotes('NewNotesBoxId')"><img src="<%=request.getContextPath() %>/staticresources/images/checked_icon.png" alt=""/></button>
</div>
</div>
</div>
</div>
</div>
</div>
</li>

<li style="display: none;" id="newNotesSalesDivId">
<span><img src="<%=request.getContextPath() %>/staticresources/images/notes.webp" alt=""/></span>
<div class="contentInnerBox contentInnerBox1 box_shadow1 relative_box mb10"> 
<div class="call_log_box">
<div class="contentBox1"> 
<p><textarea placeholder="Notes...." rows="5" id="NewNotesSalesBoxId" class="textarea_brd"></textarea></p>
</div> 
<div class="contentBox2">
<div class="row">
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="clearfix"><span class="pointers" onclick="removeCallNotes('newNotesSalesDivId','NewNotesSalesBoxId')"><img src="<%=request.getContextPath() %>/staticresources/images/delete_icon.png" alt=""/></span></div>
</div>
<div class="col-md-8 col-sm-8 col-xs-12">
<div class="clearfix flex_box justify_end">
<select class="box_shadow1" id="AddNotesOptIdSales" name="">
<%
if(contact!=null&&contact.length>0){
	for(int i=0;i<contact.length;i++){
%>
<option value="<%=contact[i][0]%>#<%=contact[i][1]%>#<%=contact[i][5]%>"><%=contact[i][0]%>@<%=contact[i][1]%></option>
<%}}%>
</select>

<button class="box_shadow1" type="button" onclick="return addTaskNotesForSales('NewNotesSalesBoxId')"><img src="<%=request.getContextPath() %>/staticresources/images/checked_icon.png" alt=""/></button>
</div>
</div>
</div>
</div>
</div>
</div>
</li>

<div class="clearfix" id="ReloadTaskThread">
<div class="clearfix" id="ReloadTaskThread1">
<%
String threds[][]=TaskMaster_ACT.getAllThread(salesrefid,uaid,userRole,teamLeaderUid,token,activityType,assignKey); 
if(threds!=null&&threds.length>0){
	String dateNow="NA";
	String datePrinted="NA";
	String time="NA";
	for(int i=0;i<threds.length;i++){
		dateNow=threds[i][3].substring(0,10);
		String userName=threds[i][10];
		String shortName=userName.substring(0,2);
		if(threds[i][1].equalsIgnoreCase("Notification")||threds[i][1].equalsIgnoreCase("Expense")||threds[i][1].equalsIgnoreCase("Reminder")){
			time=DateUtil.getHoursMinutes(threds[i][3]);
%>
<li>
<span><img src="<%=request.getContextPath() %>/staticresources/images/<%=threds[i][2] %>" alt=""></span>
<div class="contentInnerBox contentInnerBox3 box_shadow1 relative_box mb10">
<div class="sms_head note_box">
<div class="note_box_inner">
<p contentEditable="false"><%=threds[i][5] %></p> 
</div>
<span class="icon_box1 text-center" title="<%=userName%> !!"><%=shortName %></span>
</div>
<div class="sms_title"> 
<label class="pad-rt10"><img src="<%=request.getContextPath() %>/staticresources/images/long_arrow_down.png" alt="">&nbsp; <%=threds[i][1] %></label>  
<span class="gray_txt bdr_bt pad-rt10"><%=time %></span>
</div>
</div>
</li>
<%}else if(threds[i][1].equalsIgnoreCase("Notes")||threds[i][1].equalsIgnoreCase("Call Log")){
	time=DateUtil.getHoursMinutes(threds[i][3]);
	String StatusPrint="Notes Written";
	if(threds[i][1].equalsIgnoreCase("Call Log"))StatusPrint="Called";	
%>
	<li id="CallNotesBoxId<%=i %>">
	<span><img src="<%=request.getContextPath() %>/staticresources/images/<%=threds[i][2] %>" alt=""></span>
	<div class="contentInnerBox contentInnerBox3 box_shadow1 relative_box mb10">
	<div class="sms_head note_box">
	<div class="note_box_inner">
	<div id="NotesWrittenId<%=i %>" contentEditable="false"><%=threds[i][5] %></div> 
	</div>
	<span class="icon_box1 text-center" id="DisplayNoneJsId<%=i %>" title="<%=userName%> !!"><%=shortName %></span>
	</div>
	<div class="mlft10 mrt10 pad-bt5 DispNone" id="DisplayNoneSubmitId<%=i %>"> 
	<div class="contentBox2">
	<div class="row">
	<div class="col-md-4 col-sm-4 col-xs-12">
	<div class="clearfix"><span class="pointers" onclick="removeMainCallNotes('CallNotesBoxId<%=i %>','<%=threds[i][0] %>')"><img src="<%=request.getContextPath() %>/staticresources/images/delete_icon.png" alt=""></span></div>
	</div>
	<div class="col-md-8 col-sm-8 col-xs-12">
	<div class="clearfix flex_box justify_end">
	<select class="box_shadow1" id="ContactBoxId<%=i %>">
	<%if(contact!=null&&contact.length>0){
		for(int j=0;j<contact.length;j++){		
// 			System.out.println(threds[i][7]+"="+contact[j][0]+"/"+threds[i][8]+"="+contact[j][1]+"/"+threds[i][9]+"="+contact[j][5]);
		if(threds[i][7].equalsIgnoreCase(contact[j][0])&&threds[i][8].equalsIgnoreCase(contact[j][1])&&threds[i][9].equalsIgnoreCase(contact[j][5])){	
	%>
	<option value="<%=contact[j][0]%>#<%=contact[j][1]%>#<%=contact[j][5]%>" selected="selected"><%=contact[j][0]%>@<%=contact[j][1]%></option>
	<%}else{%>
	<option value="<%=contact[j][0]%>#<%=contact[j][1]%>#<%=contact[j][5]%>"><%=contact[j][0]%>@<%=contact[j][1]%></option>
	<%}}}%>
	</select>
	
	<button class="box_shadow1" type="button" onclick="updateThisNotes('<%=threds[i][0] %>','NotesWrittenId<%=i %>','ContactBoxId<%=i %>','DisplayNoneJsId<%=i %>','DisplayNoneSubmitId<%=i %>','DisplayNoneTimerId<%=i %>','TimeCalculator<%=i %>')"><img src="<%=request.getContextPath() %>/staticresources/images/checked_icon.png" alt=""></button>
	</div>
	</div>
	</div>
	</div>
	</div>
	<div class="sms_title" id="DisplayNoneTimerId<%=i %>"> 
	<label class="pad-rt10"><img src="<%=request.getContextPath() %>/staticresources/images/long_arrow_down.png" alt="">&nbsp; <%=StatusPrint %></label>  
	<span class="gray_txt bdr_bt pad-rt10" id="TimeCalculator<%=i %>"><%=time %></span>
<%-- 	<%if(threds[i][11].equalsIgnoreCase("NA")){} %> --%>
<%-- 	<span class="gray_txt bdr_bt pointers mlft10" onclick="editTextarea('NotesWrittenId<%=i %>','DisplayNoneJsId<%=i %>','DisplayNoneSubmitId<%=i %>','DisplayNoneTimerId<%=i %>')">Edit</span> --%>
	<%if(!threds[i][11].equalsIgnoreCase("NA")){ %>
	<span class="gray_txt bdr_bt pointers mlft10" onclick="saveNotesReply('NAA','<%=threds[i][12]%>')">Reply</span>
	<%} %>
	</div>
	</div>
	</li>
	
<%}else if(threds[i][1].equalsIgnoreCase("Public Reply")){
	if(!datePrinted.equalsIgnoreCase(dateNow)){
		datePrinted=dateNow;		
%>
	<li>
	<span><img src="<%=request.getContextPath() %>/staticresources/images/public_reply.png" style="width: 14px;"></span>
	<div class="contentInnerBox contentInnerBox3 box_shadow1 relative_box mb10">
	<%
	String chatThread[][]=TaskMaster_ACT.getAllTodaysChats(datePrinted,salesrefid,uaid,userRole,teamLeaderUid,token,assignKey);
	if(chatThread!=null&&chatThread.length>0){
		for(int k=0;k<chatThread.length;k++){
			time=DateUtil.getHoursMinutes(chatThread[k][3]);
			String color="iconn";
			String status=chatThread[k][12];
			if(status.equalsIgnoreCase("Pending"))color="iconp";
			else if(status.equalsIgnoreCase("On-hold"))color="iconh";
			else if(status.equalsIgnoreCase("Open"))color="icono";
			else if(status.equalsIgnoreCase("Completed"))color="iconc";
	%>
	<div class="sms_head">
	<div class="clearfix pad-top5 box_width82">
	<p class="txt_blue">
	<span><%=chatThread[k][10] %>&nbsp;&nbsp;<i class="fa fa-caret-right"></i>&nbsp;<%=chatThread[k][11] %></span>
	</p>
	<p><%=chatThread[k][5] %></p>
	</div>  
	<span class="relative"><span class="gray_txt bdr_bt fntsize10"><%=time %></span>
	<%if(!status.equalsIgnoreCase("NA")){ %>
	<span class="chatstatus <%=color%>"><%=status %></span></span><%} %>
	</div>	
	<%}} %>
	
	</div>
	</li>	
	
	
<%}}}}%>
</div>
</div>
</ul>
</div>

</div>
</form>
</div>
</div>
</div>
</div>
</div>
</div>

<div class="fixed_right_box"> 
<div class="clearfix add_inner_box pad_box4 addcompany" id="add_expense">
<div class="close_icon close_box"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fas fa-inr"></i>New Expense</h3> 
<p>Add Expenses for your department.</div>
<form onsubmit="return false" method="post" id="AddNewExpense">
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" autocomplete="off" name="addexpenseclientname" value="<%=companyname %>" id="AddExpenseClientName" placeholder="Client's name.." onblur="validCompanyNamePopup('AddExpenseClientName');validateValuePopup('AddExpenseClientName');" class="form-control bdrd4">
 </div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" autocomplete="off" maxlength="14" name="addexpenseClientContactNumber" value="<%=contactPhone %>" id="AddExpenseClientContactNumber" placeholder="Contact number.." onblur="validateMobilePopup('AddExpenseClientContactNumber');validateValuePopup('AddExpenseClientContactNumber')" class="form-control bdrd4" onkeypress="return isNumberKey(event)">
  </div>
  <div id="industryErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
<div class="clearfix inner_box_bg" style="margin-top: 10px;">
<div class="row">
<div class="col-md-4 col-sm-4 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Total amount :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <input type="text" autocomplete="off" name="addexpenseamount" id="AddExpense_Amount" placeholder="Total amount.." class="form-control bdrd4 onlyDecimal" onkeyup="return validateNumber(this)">
  </div>
  <div id="cityErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-8 col-sm-8 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">How would you like to categorize this expense ? :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <select class="form-control bdrd4" id="AddExpenseCategory" name="addExpenseCategory">
  <option value="">Expense Category</option>
  <option value="Advertising and Marketing Expense">Advertising and Marketing Expense</option>
  <option value="Bank Charges and Internet Expense">Bank Charges and Internet Expense</option>
  <option value="Contractor Expense">Contractor Expense</option>
  <option value="Cost of Goods Sold Expense">Cost of Goods Sold Expense</option>
  <option value="Deprecation Expense">Deprecation Expense</option>
  <option value="Insurance Expense">Insurance Expense</option>
  <option value="Management and Administration Expense">Management and Administration Expense</option>
  <option value="Meals & Entertainment Expense">Meals and Entertainment Expense</option>
  <option value="Office Expense">Office Expense</option>
  <option value="Payroll Expense">Payroll Expense</option>  
  <option value="Personal Expense">Personal Expense</option>
  <option value="Professional Dues/Membership/Licenses">Professional Dues/Membership/Licenses</option>
  <option value="Professional Services Expense">Professional Services Expense</option>
  <option value="Rent">Rent Expense</option>
  <option value="Repairs & Maintenance Expense">Repairs & Maintenance Expense</option>
  <option value="Shipping & Postage Expense">Shipping & Postage Expense</option>
  <option value="Travel Expense">Travel Expense</option>
  <option value="Utilities Expense">Utilities Expense</option>
  <option value="Vehicle Expense">Vehicle Expense</option>
  <option value="Department Fees">Department Fees</option>
  <option value="Filing Fees">Filing Fees</option>
  <option value="Other Expense">Other Expense</option>
  <option value="Re-submission">Re-submission</option>
  </select>
  </div>
 </div>
</div>
</div>
<div class="row" style="margin-top: 10px;">
<div class="col-md-4 col-sm-4 col-xs-12">
 <div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">HSN (Tax if applicable) :</label>
  <div class="input-group">
   <input type="text" autocomplete="off" name="addexpensehsncode" id="AddHSN_Code" placeholder="HSN Code..." class="form-control bdrd4">
   </div>
   <div id="countryErrorMSGdiv" class="errormsg"></div>
  </div>
 </div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Department :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
<!--   <input type="text" autocomplete="off" name="addexpensedepartment" id="AddExpenseDepartment" onblur="validateValuePopup('ExpenseDepartment');" placeholder="Department here..." class="form-control bdrd4"> -->
  <select id="AddExpenseDepartment" name="addexpensedepartment" class="form-control bdrd4">
	<option value="">Select department</option>
  	<option value="Account">Account</option>
  	<option value="Sales">Delivery</option>
  	<option value="HR">HR</option>
  	<option value="IT">IT</option>
  	<option value="Marketing">Marketing</option>  	
  	<option value="Quality">Quality</option>
  	<option value="Sales">Sales</option>
  </select>
  </div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="form-group">
  <label style="font-size: 12px;font-weight: normal;">Paid from account :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
 <select class="form-control bdrd4" id="AddPaidFromAccount" name="addPaidFromAccount">
  <option value="">Select</option>
  <option value="Online">Online</option>
  <option value="Cash">Cash</option>
  <option value="Cheque/DD">Cheque/DD</option>
  </select>
  </div>
</div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12" style="margin-top: 10px;">
<div class="form-group">
  <label>Notes :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <textarea class="form-control bdrd4" autocomplete="off" rows="3" name="addexpensenote" id="AddExpenseNote" placeholder="Enter Note" onblur="validateLocationPopup('AddExpenseNote');validateValuePopup('AddExpenseNote');" ></textarea>
  </div>
</div>
</div>
</div>
<div class="clearfix mtop10 mb10 text-right"> 
<button class="bt-link bt-radius bt-gray mrt10 close_box closeAddExpenseBtn" type="button">Cancel</button>
<button class="bt-link bt-radius bt-loadmore" type="submit" id="exp_btn" onclick="return validateAddExpense()">Submit</button>
</div>
</form>                                  
</div>

<div class="clearfix add_inner_box pad_box4 addcompany" id="update_contact">
<div class="close_icon close_box"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-fax"></i>Update Contact's details</h3>
<p>When someone reaches out to you, they become a contact in your account. You can create companies and associate contacts with them.</div>

<form onsubmit="return false;" id="FormUpdateContactBox">
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
<button class="addbtn pointers close_icon1 del_icon" type="button" onclick="$('#UpdateContactEmailId2').val('')"><i class="fa fa-times" style="font-size: 20px;"></i></button>
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

<div class="clearfix add_inner_box pad_box4 addcompany" id="add_contact" style="display: none;">
<div class="close_icon close_box"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-fax"></i>New Contact</h3>
<p>When someone reaches out to you, they become a contact in your account. You can create companies and associate contacts with them.</p></div>

<form onsubmit="return false;" id="FormContactBox">
<input type="hidden" id="AddContactKeyId">
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="form-group">
  <div class="input-group">
  <input type="text" name="firstname" id="ContactFirstName" placeholder="First Name" onblur="validateNamePopup('ContactFirstName');validateValuePopup('ContactFirstName')" class="form-control bdrd4">
  </div>
  <div id="fnameErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="form-group">
 <div class="input-group">
 <input type="text" name="lastname" id="ContactLastName" placeholder="Last Name" onblur="validateNamePopup('ContactLastName');validateValuePopup('ContactLastName');" class="form-control bdrd4">
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
  <input type="email" name="enqEmail" id="ContactEmail_Id" onblur="verifyEmailIdPopup('ContactEmail_Id');isDuplicateEmail('ContactEmail_Id');" placeholder="Email" class="form-control bdrd4">
 </div>
 <div id="enqEmailErrorMSGdiv" class="errormsg"></div>
</div>
<div class="text-right">
<span class="add_new pointers">+ Email</span>
</div>
<div class="relative_box form-group new_field" style="display:none;">
  <label>Email 2nd :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>-->
  <input type="email" name="enqEmail" id="ContactEmailId2" onblur="isDuplicateEmail('ContactEmailId2');" placeholder="Email" class="form-control bdrd4">
<button class="addbtn pointers close_icon1 del_icon" type="button"><i class="fa fa-times" style="font-size: 20px;"></i></button>
  </div>
  <div id="newEmailErrorMSGdiv" class="errormsg"></div> 
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>Pan :</label>
  <div class="input-group">
  <input type="text" name="contPan" id="ContactPan" onblur="validatePanPopup('ContactPan');validateValuePopup('ContactPan');isExistPan('ContactPan');" placeholder="Pan" maxlength="14" class="form-control bdrd4">
  </div>
  <div id="conPanErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>Work Phone :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
  <input type="text" name="workphone" id="ContactWorkPhone" onblur="isDuplicateMobilePhone('ContactWorkPhone')" placeholder="Work phone" maxlength="14" class="form-control bdrd4" onkeypress="return isNumber(event)">
  </div>
  <div id="wphoneErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>Mobile Phone :</label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
  <input type="text" name="mobilephone" id="ContactMobilePhone" placeholder="Mobile Phone" maxlength="14" onblur="validateMobilePopup('ContactMobilePhone');isDuplicateMobilePhone('ContactMobilePhone');" class="form-control bdrd4" onkeypress="return isNumber(event)">
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
<input type="radio" name="addresstype" id="ContactperAddress" checked="checked">
<span>Personal Address</span>
</span>
<span class="mlft10 input_radio">
<input type="radio" name="addresstype" id="ContactcomAddress" onclick="getCompanyAddress()">
<span>Company Address</span>
</span>
</div>
</div>
</div>
<div class="row address_box">
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
   <label>Country :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <select class="form-control" name="country" id="ContCountry" onchange="updateState(this.value,'ContState')">
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
<div class="row address_box">
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="form-group">
  <label>State :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <select class="form-control bdrd4" name="state" id="ContState" onchange="updateCity(this.value,'ContCity')">
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
  <select class="form-control bdrd4" name="city" id="ContCity">
  <option value="">Select City</option>
  </select>
  </div>
  <div id="cityErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
<div class="row address_box">
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
   <label>Address :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite page"></i></span>-->
  <textarea class="form-control bdrd4" rows="2" name="enqAdd" id="ContAddress" placeholder="Address" onblur="validateValuePopup('ContAddress');validateLocationPopup('ContAddress');"></textarea>
  </div>
  <div id="enqAddErrorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row company_box" style="display:none;">
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon fa fa-bank"></i></span>-->
  <textarea class="form-control bdrd4" rows="2" name="enqCompAdd" id="EnqCompAddress" placeholder="Company Address" onblur="validateValuePopup('EnqCompAddress');validateLocationPopup('EnqCompAddress');" readonly="readonly"></textarea>
  </div>
  <div id="companyErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
<div class="clearfix mtop10 mb10 text-right">
<button class="bt-link bt-radius bt-gray close_box" type="button">Cancel</button>
<button class="bt-link bt-radius bt-loadmore" type="submit" id="ValidateAddContact" onclick="return validateContact();">Create</button>
</div>
</form>
</div>

<div class="clearfix add_inner_box pad_box4 addcompany" id="add_document" style="display: none;">
<div class="close_icon close_box"><i class="fa fa-times"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-file-o"></i>Document List : <span style="color:#357b8bf5;"><%=projectNo %></span></h3> 
</div>
<div class="tab">
  <button class="tablinks active" onclick="openDocument(event, 'AgentUploadDoc')">&nbsp;Agent's Uploads</button>
  <button class="tablinks" onclick="openDocument(event, 'ClientUploadDoc')">&nbsp;Client's Uploads</button>
  <button class="tablinks" onclick="openDocument(event, 'HistoryUploadDoc')">&nbsp;Upload History</button>
</div>
<div class="clearfix pad_box3 pad05 tabcontent" style="display:block;" id="AgentUploadDoc">
<div class="clearfix mb10">
<div class="clearfix bg_wht link-style12">
   <div class="col-xs-3 box-intro-bg">
       <div class="clearfix">
       <p class="news-border">Date</p>
       </div>
   </div>
   <div class="col-xs-7 box-intro-bg">
       <div class="clearfix">
       <p class="news-border" title="">Documents Name</p>
       </div>
   </div>
   <div class="col-xs-2 box-intro-bg">
       <div class="clearfix">
       <p class="news-border">Action</p>
       </div>
   </div> 
</div>
<div class="clearfix" id="DocumentListBox">
<div class="clearfix" id="DocumentListBox1">
<%
String doclist[][]=TaskMaster_ACT.getSalesDocumentList(salesrefid,token,"Agent");
String invoice=TaskMaster_ACT.getSalesInvoiceNumber(salesrefid, token);
double orderAmount=TaskMaster_ACT.getOrderAmount(invoice, token);
// double dueAmount=Clientmaster_ACT.getSalesDueAmount(invoice,token); 
boolean isExist=TaskMaster_ACT.isDisperseExist(salesrefid, token);
double orderPaidAmount[]=null;
if(isExist)
 	orderPaidAmount=TaskMaster_ACT.getSalesOrderAndPaidAmount(salesrefid,token); 
else
	orderPaidAmount=TaskMaster_ACT.getSalesOrderAndPaidAmountByInvoice(invoice,token);
double payPercent=100;
if(orderPaidAmount[1]!=0&&orderPaidAmount[0]!=0)
	payPercent=(orderPaidAmount[1]*100)/orderPaidAmount[0];

if(doclist!=null&&doclist.length>0){
	for(int i=0;i<doclist.length;i++){
		boolean fileExist=false;
		if(doclist[i][4]!=null&&!doclist[i][4].equalsIgnoreCase("NA"))
			fileExist=CommonHelper.isFileExists(doclist[i][4],azure_key,azure_container);
		
// 		System.out.println(doclist[i][4]+"#"+fileExist);
			
%>
<div class="clearfix bg_wht link-style12">
   <div class="col-xs-3 box-intro-background">
       <div class="clearfix">
       <p class="news-border" id="DocumentListDateId<%=i%>"><%=doclist[i][5] %></p>
       </div>
   </div>
   <div class="col-xs-7 box-intro-background">
       <div class="clearfix">
       <p class="news-border" title="<%=doclist[i][2] %>"><%=doclist[i][1] %></p>
       </div>
   </div>
   <div class="col-xs-2 box-intro-background">
   <form class="upload-box<%=i %>" onsubmit="return false">
       <div class="clearfix">
       <p class="news-border" style="font-size: 15px;">
	   <%if(doclist[i][4]!=null&&doclist[i][4].length()>0&&!doclist[i][4].equalsIgnoreCase("NA")&&fileExist){ %>
	   <a class="bg_none colorNone MainDownloadIcon<%=i %>" href="<%=azure_path%><%=doclist[i][4] %>" download><i class="fas fa-arrow-down pointers" title="Download this document"></i></a>
       <%}%>
      <span id="AppendDocDownload<%=i %>"></span>
       <span style="margin-right: 3px;">
       <input id="fileInput<%=i %>" name="fileInput<%=i %>" type="file" onchange="uploadFile('upload-box<%=i %>','MainDownloadIcon<%=i %>','AppendDocDownload<%=i %>','<%=doclist[i][0] %>','fileInput<%=i %>','DocumentListDateId<%=i%>')" style="display:none;">
       <button onclick="document.getElementById('fileInput<%=i %>').click();" style="border: none;background: #ffff;" title="Upload this document"><i class="fas fa-file"></i></button>
       </span>
       <%if(Double.parseDouble(doclist[i][6])<=payPercent&&fileExist){ %>
       <button onclick="sendDocumentEmail('<%=doclist[i][0]%>')" style="border: none;background: #ffff;" title="Click to send to client">
       <i class="fas fa-envelope pointers"></i></button>
       <%} %>
       </p>
       </div>
      </form>
   </div>                                         
</div>
<%}} %>
<div class="clearfix" id="AppendNewAgentDocList"></div>
</div>
</div>
</div>
<div class="row pointers" style="float: right;margin-right: 31px;"><a data-toggle="modal" data-target="#AddNewDocumentList" onclick="$('#AddNewDocumentListForm').trigger('reset')">+&nbsp;New Document</a></div>
</div>
<div class="clearfix pad_box3 pad05 tabcontent" style="display:none;" id="ClientUploadDoc">
<div class="clearfix mb10">
<div class="clearfix bg_wht link-style12">
   <div class="col-xs-3 box-intro-bg">
       <div class="clearfix">
       <p class="news-border">Date</p>
       </div>
   </div>
   <div class="col-xs-7 box-intro-bg">
       <div class="clearfix">
       <p class="news-border" title="">Documents Name</p>
       </div>
   </div>
   <div class="col-xs-2 box-intro-bg">
       <div class="clearfix">
       <p class="news-border">Action</p>
       </div>
   </div> 
</div>
<div class="clearfix" id="DocumentListBox2">
<div class="clearfix" id="DocumentListBox3">
<%
String doclist1[][]=TaskMaster_ACT.getSalesDocumentList(salesrefid,token,"Client");
if(doclist1!=null&&doclist1.length>0){
	for(int i=0;i<doclist1.length;i++){
		boolean fileExist=false;
		if(doclist1[i][4]!=null&&!doclist1[i][4].equalsIgnoreCase("NA"))
			fileExist=CommonHelper.isFileExists(doclist1[i][4],azure_key,azure_container);
%>
<div class="clearfix bg_wht link-style12">
   <div class="col-xs-3 box-intro-background">
       <div class="clearfix">
       <p class="news-border" id="DocumentListDateId1<%=i%>"><%=doclist1[i][5] %></p>
       </div>
   </div>
   <div class="col-xs-7 box-intro-background">
       <div class="clearfix">
       <p class="news-border" title="<%=doclist1[i][2] %>"><%=doclist1[i][1] %></p>
       </div>
   </div>
   <div class="col-xs-2 box-intro-background">
   <form class="upload-box1<%=i %>" onsubmit="return false">
       <div class="clearfix">
       <p class="news-border" style="font-size: 15px;">
	   <%if(doclist1[i][4]!=null&&doclist1[i][4].length()>0&&!doclist1[i][4].equalsIgnoreCase("NA")&&fileExist){ %>
	   <a class="bg_none colorNone MainDownloadIcon1<%=i %>" href="<%=azure_path%><%=doclist1[i][4] %>" download><i class="fas fa-arrow-down pointers" title="Download this document"></i></a>
       <%}%>
      <span id="AppendDocDownload1<%=i %>"></span>
       <span style="margin-right: 3px;">
       <input id="fileInput1<%=i %>" name="fileInput1<%=i %>" type="file" onchange="uploadFile('upload-box1<%=i %>','MainDownloadIcon1<%=i %>','AppendDocDownload1<%=i %>','<%=doclist1[i][0] %>','fileInput1<%=i %>','DocumentListDateId1<%=i%>')" style="display:none;">
       <button onclick="document.getElementById('fileInput1<%=i %>').click();" style="border: none;background: #ffff;" title="Upload this document"><i class="fas fa-file"></i></button>
       </span><%if(doclist1[i][7].equalsIgnoreCase("2")){ %>       
       <a class="bg_none colorNone" href="javascript:void(0)" onclick="reUploadRequest('<%=doclist1[i][0] %>','<%=salesrefid%>')"><i class="fa fa-retweet pointers" title="Request To Re-Upload"></i></a>
		<%}else{ %>
		<a class="bg_none colorNone" href="javascript:void(0)" data-toggle="modal" data-target="#ReUploadInProgress"><i class="fa fa-spinner pointers" title="Re-Upload In Progress"></i></a>
		<%} %>
       </p>
       </div>
      </form>
   </div>                                         
</div>
<%}} %>
<div class="clearfix" id="AppendNewClientDocList"></div>
</div>
</div>
</div>
<div class="row pointers" style="float: right;margin-right: 31px;"><a data-toggle="modal" data-target="#AddNewDocumentList" onclick="$('#AddNewDocumentListForm').trigger('reset')">+&nbsp;New Document</a></div>


</div>
<div class="clearfix pad_box3 pad05 tabcontent" style="display:none;" id="HistoryUploadDoc">
<div class="clearfix mb10">

<%
String docAction[][]=TaskMaster_ACT.getDocumentActionHistory(salesrefid,token);
if(docAction!=null&&docAction.length>0){
	for(int i=0;i<docAction.length;i++){
	String remarks=docAction[i][2];
	boolean status=false;
	if(docAction[i][3].equalsIgnoreCase("Upload")){
		remarks+=" uploaded by "+docAction[i][5];
		status=true;
	}else if(docAction[i][3].equalsIgnoreCase("Create")){
		remarks+=" created by "+docAction[i][5];
		status=false;
	}else if(docAction[i][3].equalsIgnoreCase("Share")){
		remarks+=" shared by "+docAction[i][5];
		status=false;
	}
	boolean existDoc=false;
	if(docAction[i][9]!=null&&docAction[i][9].length()>0&&!docAction[i][9].equalsIgnoreCase("NA"))existDoc=true;
	boolean fileExist=false;
		if(existDoc)
			fileExist=CommonHelper.isFileExists(docAction[i][9], azure_key, azure_container);
		
%>
<div class="clearfix bg_wht link-style12">
   <div class="col-xs-2 box-intro-background">
       <div class="clearfix">
       <p class="news-border" id="<%=docAction[i][7] %>"><%=docAction[i][7] %></p>
       </div>
   </div>
   <div class="col-xs-9 box-intro-background">
       <div class="clearfix">
       <p class="news-border" title="<%=remarks %>"><%=remarks %></p>
       </div>
   </div> 
   <div class="col-xs-1 box-intro-background">
      <div class="clearfix">
       <p class="news-border"><%if(userRole.equalsIgnoreCase("Admin")&&status){ %>
       <a id="Download<%=docAction[i][0] %>" <%if(existDoc&&fileExist){%>href="<%=azure_path%><%=docAction[i][9] %>" download<%}else{ %>data-toggle="modal" data-target="#NoDocument"<%} %>><i class="fas fa-arrow-down <%if(!existDoc){%>text-muted<%}%>"></i></a>&nbsp;
       <a id="Delete<%=docAction[i][0] %>" <%if(existDoc&&fileExist){%>onclick="deleteDocument('<%=docAction[i][0] %>','<%=docAction[i][9] %>')"<%}else{ %>data-toggle="modal" data-target="#NoDocument"<%} %>><i class="fas fa-trash  <%if(!existDoc&&!fileExist){%>text-muted<%}else{%>text-danger<%}%>"></i></a><%}else{ %>
       <a href="#" data-toggle="modal" data-target="#PermissionNot"><i class="fas fa-arrow-down text-muted"></i></a>
       <a href="#" data-toggle="modal" data-target="#PermissionNot"><i class="fas fa-trash text-muted"></i></a>
       <%} %>
       </p>
       </div>
   </div>                                         
</div>
<%}}else{ %>
<div class="clearfix text-center text-danger noDataFound mt-10">No Data Found</div>
<%} %>
</div>
</div>
</div>

<!-- Tool Tip -->
<div class="clearfix add_inner_box pad_box4 addcompany" id="Task_Step" style="display: none;">
<div class="close_icon close_box"><i class="fa fa-times"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-file-o"></i>Task Step : <span id="TaskMilestoneName"></span></h3> 
</div>

<div class="clearfix pad_box3 pad05">
<div class="clearfix mb10">
<div class="clearfix bg_wht link-style12">
<%
//getting product key and milestome name 
String milestoneData[]=TaskMaster_ACT.getMilestoneData(milestoneKey,token);
String toolTip[][]=null;
if(milestoneData[0]!=null&&milestoneData[1]!=null){
	toolTip=TaskMaster_ACT.getAllStepGuide(milestoneData[0],milestoneData[1],token,jurisdiction);
}
if(toolTip!=null&&toolTip.length>0){
for(int i=0;i<toolTip.length;i++){%>
<h6>STEP - <%=toolTip[i][2] %></h6>	
<%=toolTip[i][0] %>				
<%if(toolTip[i][1]!=null&&!toolTip[i][1].equals("NA")){ %>	
<span class="attachment">
<div class="file-upload-box">
<i class="far fa-file"></i>
<span id="StepGuideFileName1"><%=toolTip[i][1].substring(21) %></span>
<div class="action-btn"><a href="<%=azure_path%><%=toolTip[i][1] %>" download>
<i class="far fa-arrow-alt-circle-down"></i></a>		
</div>
</div>
</span>
<%}}}else{%>
<h6>No tips provided !!</h6>
<%} %>
</div>
</div>
</div>
</div>

<div class="clearfix add_inner_box pad_box4 addcompany" id="open_chat" style="display: none;">
<div class="close_icon close_box"><i class="fa fa-times"></i></div>


<div class="clearfix bdr_bt pad-lft10 pad-rt10 about-content">
<div class="rttop_title">
<h3><%=productName %></h3> 
<div class="clearfix communication_history1"> 
<span class="gray_txt pad-rt10 mrt10"><%=companyname %></span>
<%-- <span class="gray_txt pad-rt10 mrt10"><%=clientData[1] %></span> --%>
<span class="bg_circle relative_box filterBox_inner"><span id="ChatReplyEmailId"><%=contactEmail %></span><button type="button" class="editBtn"><img src="<%=request.getContextPath() %>/staticresources/images/edit_icon1.png" alt=""></button> 
<ul class="filterBox_dropdown">
<%if(contact!=null&&contact.length>1){
	for(int i=1;i<contact.length;i++){%>
<li><a onclick="$('#ChatReplyEmailId').html('<%=contact[i][5] %>')"><%=contact[i][5] %></a></li>
<%}} %>
</ul>
</span>
<span class="gray_txt">via <span class="bg_circle fa fa-user">&nbsp;<%=loginUserName %></span></span> 
</div> 
</div> 
<div class="clearfix nav-tabs-border"> 
<ul class="nav-tabs">
<li class="active" id="PublicreplyLi" onclick="showChatReply('PublicreplyLi','InternalreplyLi','ReplyNotesBoxId','InternalNotesBoxId','ChatReplyButtonId')"><a>Public reply</a></li> 
<li id="InternalreplyLi" onclick="showInternalReply('PublicreplyLi','InternalreplyLi','ReplyNotesBoxId','InternalNotesBoxId','ChatReplyButtonId')"><a >Internal note</a></li>
</ul>
<form onsubmit="return false" class="PublicChatReply" id="PublicChatReplyFormId">
<input type="hidden" name="BoxContent" id="BoxContent">
<input type="hidden" name="submitStatus" id="SubmitStatus">
<input type="hidden" name="milestoneDataBoxId" id="MilestoneDataBoxId">
<input type="hidden" name="salesrefId" value="<%=salesrefid%>">
<input type="hidden" name="clientrefId" value="<%=clientKey%>">
<input type="hidden" name="assigneeUId" value="<%=assigneeUid%>">
<input type="hidden" name="marefid" value="<%=marefid%>">
<div class="clearfix box_shadow1 relative_box reply_box" id="ReplyNotesBoxId">
<div class="reply_box_title bdr_bt">
<span><span>Starting Date:</span>
<span class="bg_circle"><input type="datetime-local" value="<%=workStarted %>T<%=workStartedTime%>" readonly></span></span> 
<span><span>Ending Date:</span>

<span class="clearfix" id="MilestoneEndDateId"></span>

</span>
</div>
<textarea class="ChatTextareaBox" rows="2" id="ChatTextareaBoxReply" name="ChatTextareaBoxReply" placeholder="Public reply here..... !!"></textarea> 
<textarea id="DynamicForData" name="dynamicFormData" style="display: none;"></textarea>
</div>
<div class="clearfix contentInnerBox3 box_shadow1 relative_box" id="ChatReplyButtonId">
<div class="col-md-6 col-sm-6 col-xs-12">

	<div class="editor_title"> 
	<a class="pad-rt10 pointers" onclick="$('#ChatTextareaBoxReply+.cke_editor_ChatTextareaBoxReply .cke_top').toggleClass('DispNone');" title="Editor">T</a> 
	<input type="file" name="AttachChatFile" id="AttachChatFile" onchange="fileSize('AttachChatFile')" style="display: none;"> 
	<a class="pad-rt10 pointers" onclick="$('#AttachChatFile').click()" title="Attact File"><i class="fa fa-paperclip"></i></a>
	<a class="pad-rt10 pointers" data-toggle="modal" data-target="#DynamicFormModal" onclick="$('#DynamicFormName').val('')" title="Create dynami form !!"><img src="<%=request.getContextPath() %>/staticresources/images/dynamic.png" alt=""></a>
	<a class="pad-rt10 pointers" data-toggle="modal" data-target="#newSMSTemplate" title="SMS"><img src="<%=request.getContextPath() %>/staticresources/images/message.png" alt=""></a>
	<a class="pointers" title="Email" data-toggle="modal" data-target="#newEmailTemplate"><i class="fa fa-envelope-o"></i></a>
	</div>

</div>
<div class="pad0 text-right col-md-6 col-sm-6 col-xs-12 Task_Box">
<select id="ChatReplyBoxTaskId">	
	<option value="<%=milestoneKey%>#<%=milestoneName %>"><%=milestoneName %></option>
</select>
</div>
</div>
</form>
<div class="clearfix box_shadow1 relative_box reply_box toggle_box" id="InternalNotesBoxId">
<!-- <textarea class="ChatTextareaBox1" rows="5" id="ChatTextareaBoxReplyInternotes" placeholder="Internal notes here..... !!"></textarea>  -->
<textarea id="ChatTextareaBoxReply1" name="ChatTextareaBoxReply1"></textarea>
</div>
</div>

<div id="reload">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12 cmhistscrollInternal internalNotes toggle_box"> 
<div class="clearfix" id="TaskChatInternalHistroy">
<div class="clearfix" id="TaskChatInternalHistroy1">
<%
String internalNotes[][]=TaskMaster_ACT.getProjectsInternalNotes(salesrefid,uaid,userRole,teamLeaderUid,token);
if(internalNotes!=null&&internalNotes.length>0){
	for(int i=0;i<internalNotes.length;i++){
		String time=DateUtil.getHoursMinutes(internalNotes[i][1]);
%>
<div class="contentInnerBox3 box_shadow1 relative_box mb10 mtop10">
	<div class="sms_head note_box">
	<div class="note_box_inner">
	<%=internalNotes[i][3] %>
	</div>
	<span class="icon_box1 text-center" title="Corpseed private limited !!"><%=internalNotes[i][4].substring(0,2) %></span>
	</div>	
	<div class="sms_title" id="DisplayNoneTimerId24"> 
	<label class="pad-rt10"><img src="<%=request.getContextPath() %>/staticresources/images/long_arrow_down.png" alt="">&nbsp; <%=internalNotes[i][2] %></label>  
	<span class="gray_txt bdr_bt pad-rt10" id="TimeCalculator24"><%=time %></span>
	</div>
	</div>
	<%}}else{ %>
	<div class="clearfix text-center text-danger noDataFound">No Data Found</div>
	<%} %>
	</div>
	</div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12 cmhistscroll">
<div class="clearfix communication_history">
<div class="clearfix" id="TaskChatHistroy">
<div class="clearfix" id="TaskChatHistroy1">
<%
String followUp[][]=TaskMaster_ACT.getProjectsFollowUp(salesrefid,uaid,userRole,teamLeaderUid,token);
if(followUp!=null&&followUp.length>0){
	for(int i=0;i<followUp.length;i++){
		String icon=followUp[i][11].substring(0,2);
		//getting extension and file size
		String fileName=followUp[i][6];
		String extension="";
		String size="";
		Path path=null;
		if(followUp[i][6]!=null&&!followUp[i][6].equalsIgnoreCase("NA")&&followUp[i][6].length()>0){
			boolean fileExist=CommonHelper.isFileExists(fileName, azure_key, azure_container);
			long bytes=0;
			if(fileExist){
				bytes=CommonHelper.getBlobSize(fileName,azure_key,azure_container);
			}
			long kb=bytes/1024;
			long mb=kb/1024;	
			
			if(mb>=1)size=mb+" MB";
			else if(kb>=1) size=kb+" KB";
			else size=bytes+" bytes";
			int index=followUp[i][6].lastIndexOf(".");
			extension=followUp[i][6].substring(index);
		}
		String msgFrom=Usermaster_ACT.getUserType(followUp[i][10],token);
		if(msgFrom.equalsIgnoreCase("Client")){
			
%>
<div class="communication_item clearfix">
<div class="communication_item_lft">
<span class="admin_icon"><%=icon %></span>
<div class="clearfix communication_info">
<span class="cmhistname"><%=followUp[i][11] %><%if(followUp[i][12]!=null&&followUp[i][12].length()>0&&!followUp[i][12].equalsIgnoreCase("NA")){ %>&nbsp;&nbsp;<i class="fa fa-caret-right"></i>&nbsp;<%=followUp[i][12]%><%} %></span>
<span class="clearfix cmhistmsg">
<span><%=followUp[i][5] %></span>
</span>
<%if(followUp[i][6]!=null&&!followUp[i][6].equalsIgnoreCase("NA")&&followUp[i][6].length()>0){%>
<div class="clearfix download_file">
<div class="download_box"><span><img src="<%=request.getContextPath() %>/staticresources/images/file.png" alt=""><span title="<%=followUp[i][6].substring(21) %>"><%=followUp[i][6].substring(21) %></span></span>
<a href="<%=azure_path%><%=followUp[i][6]%>" download><img src="<%=request.getContextPath() %>/staticresources/images/download.png" alt=""></a></div>
<div class="download_size"><span><%=size %>  <%=extension.toUpperCase()%></span><span><%=followUp[i][8] %></span></div>
</div>
<%} %>
</div>
</div>
</div>
<%}else{ %>
<div class="communication_item_rt clearfix">
<div class="clearfix communication_info">
<span class="cmhistname"><%=followUp[i][11] %></span>
<span class="clearfix cmhistmsg">
<span><%=followUp[i][5] %><%if(followUp[i][4]!=null&&followUp[i][4].length()>0&&!followUp[i][4].equalsIgnoreCase("NA")){ %>
<a class="setData" onclick="setFollowUpId('<%=followUp[i][0] %>','<%=followUp[i][14] %>')" style="color:#fff;"><u><%=followUp[i][14] %></u>
<%if(followUp[i][13].equalsIgnoreCase("1")){ %>&nbsp;&nbsp;<i class="fa fa-check-circle"></i><%} %>
</a><%} %></span>
</span>
<%if(followUp[i][6]!=null&&!followUp[i][6].equalsIgnoreCase("NA")&&followUp[i][6].length()>0){%>
<div class="clearfix download_file">
<div class="download_box"><span><img src="<%=request.getContextPath() %>/staticresources/images/file.png" alt=""><span title="<%=followUp[i][6].substring(21) %>"><%=followUp[i][6].substring(21) %></span></span>
<a href="<%=azure_path%><%=followUp[i][6]%>" download><img src="<%=request.getContextPath() %>/staticresources/images/download.png" alt=""></a></div>
<div class="download_size"><span><%=size %>  <%=extension.toUpperCase()%></span><span><%=followUp[i][8] %></span></div>
</div>
<%} %>
</div>
<span class="admin_icon"><%=icon %></span>
</div>
<%}}}else{ %>
<div class="clearfix text-center text-danger noDataFound" id="NoDataFoundMsg">No Data Found</div>
<%} %>
<div id="scrolling-messages" class="scrolling-messages"></div>
</div>
</div>
</div>
</div>
</div>
</div>


</div>
<div class="clearfix about-content text-right pad-lft10 pad-rt10 communication_history1"> 
    <button class="bt-link bt-radius bt-loadmore mrt10 close_box btn-cancel" type="button">Cancel</button>
	
	<span class="relative_box submit_as"><button class="bt-link bt-radius bt-loadmore" type="button">Submit As</button>
		<ul class="filterBox_dropdown" id="chatReplyList">  
		<li><a onclick="validateChatReply('Pending')"><span class="dot_circle_pending"></span>Pending</a></li>
		<li><a onclick="validateChatReply('On-hold')"><span class="dot_circle_hold"></span>On-hold</a></li>
		<li><a onclick="validateChatReply('Open')"><span class="dot_circle_open"></span>Open</a></li>
		<%if(taskProgress==100){ %><li class="appendedList"><a onclick="validateChatReply('Completed')"><span class="dot_circle_completed"></span>Completed</a></li><%} %>
		</ul>
	</span>
</div>

<div class="clearfix about-content text-right pad-lft10 pad-rt10 internalNotes toggle_box"> 
    <button class="bt-link bt-radius bt-loadmore mrt10 close_box btn-cancel" type="button">Cancel</button>
	<span class="relative_box"><button class="bt-link bt-radius bt-loadmore" type="button" onclick="return validateInternalNotes()">Submit</button>	
	</span> 
</div>

</div>
</div>
<div class="myModal modal fade template" id="holdWarning" aria-modal="false" style="padding-right: 17px; display: none;">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title"><i class="fas fa-question font25" aria-hidden="true"></i>Task Hold Reason</h4>  
          <button type="button" class="closeBox" data-dismiss="modal"><span aria-hidden="true">&times;</span></button>
        </div>
        <form method="post" onsubmit="return false">
        <div class="modal-body">          
		  <div class="tab-content">		  
		  <div id="pay_method2">
		    <div class="row mb10">
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>Type<sup class="text-danger">*</sup></label>
            <select class="form-control" id="holdChatType" name="">
            	<option value="">Select type</option>
            	<option value="Government">Government</option>
            	<option value="Client">Client</option>
            	<option value="Resubmission/Query">Resubmission/Query</option>
            	<option value="Vendor">Vendor</option>
            </select>
            </div>
            </div>		 
            <div class="row mb10">
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>Reason/Remarks<sup class="text-danger">*</sup></label>
            <textarea class="form-control" style="min-height: 80px" rows="3" name="holdReason" id="holdReason" placeholder="Describe task hold reason...." autocomplete="off"></textarea>
            </div>
            </div>
          </div>
		  </div>  		  
        </div>
        <div class="modal-footer flex-end">
          <button type="button" class="btn btn-cancel bt-link bt-radius" data-dismiss="modal">Cancel</button> 
          <button type="submit" class="bt-link bt-radius bt-loadmore" onclick="validateHoldReply('On-hold')">Submit</button> 
        </div>
        </form>
      </div>
    </div>
  </div>
<div class="myModal modal fade template" id="newSMSTemplate" aria-modal="false" style="padding-right: 17px; display: none;">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title"><i class="fas fa-sms font25" aria-hidden="true"></i>SMS</h4>  
          <button type="button" class="closeBox" data-dismiss="modal"><span aria-hidden="true">&times;</span></button>
        </div>
        <form method="post" onsubmit="return false">
        <div class="modal-body">          
		  <div class="tab-content">		  
		  <div id="pay_method2">
		    <div class="row mb10">
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>SMS To :</label>
            <input type="text" maxlength="14" value="<%=contactPhone %>" class="form-control" name="mobile" id="SMS_Mobile" placeholder="SMS To..." autocomplete="off">
            </div>
            </div>		 
            <div class="row mb10">
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>Message</label>
            <textarea class="form-control" name="sms_description" id="SMS_Description" placeholder="Description..." autocomplete="off">
            <p>Dear, <%=contactName %> </p><p>You have new follow-up on project number <b><%=projectNo %></b></p>
            </textarea>
            </div>
            </div>
          </div>
		  </div>  		  
        </div>
        <div class="modal-footer flex-end">
          <button type="button" class="btn btn-cancel bt-link bt-radius" data-dismiss="modal">Cancel</button> 
          <button type="submit" class="bt-link bt-radius bt-loadmore" data-dismiss="modal">Save</button> 
        </div>
        </form>
      </div>
    </div>
  </div>
  <div class="modal fade" id="PermissionNot" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span><span class="text-danger">Either document not exist or you haven't permission..</span></h5>
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
  <div class="modal fade" id="NoDocument" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span><span class="text-danger">Sorry , Document doesn't exist..</span></h5>
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
 <div class="myModal modal fade template" id="newEmailTemplate" aria-modal="false" style="padding-right: 17px; display: none;">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title"><i class="far fa-envelope" aria-hidden="true"></i>Email</h4>  
          <button type="button" class="closeBox" data-dismiss="modal"><span aria-hidden="true">&times;</span></button>
        </div>
        <form method="post" onsubmit="return false">
        <div class="modal-body">          
		  <div class="tab-content">		  
		  <div id="pay_method2">
		  <div class="row mb10">
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>Email To :</label>
            <input type="text" class="form-control" name="email_to" value="<%=contactEmail %>" id="Email_To" placeholder="Email to..." autocomplete="off">
            </div>
            </div> 
            <div class="row mb10">
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>Subject :</label>
            <input type="text" class="form-control" name="email_subject" value="New Follow-Up" id="Email_Subject" placeholder="Subject..." autocomplete="off">
            </div>
            </div> 
            <div class="row mb10">
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>Message</label>
            <textarea class="form-control" name="Email_description" id="Email_Description" placeholder="Description..." autocomplete="off"><p>Dear, <%=contactName %> </p>
            <p>You have new follow-up on project number <a href="<%=domain%>"><b><%=projectNo %></b></a></p>
            </textarea>
            </div>
            </div>
          </div>
		  </div>  		  
        </div>
         
        <div class="modal-footer flex-end">
          <button type="button" class="btn btn-cancel bt-link bt-radius" data-dismiss="modal">Cancel</button> 
          <button type="submit" class="bt-link bt-radius bt-loadmore" data-dismiss="modal">Save</button> 
        </div>
        </form>
      </div>
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
  <div class="modal fade" id="warningtransferRetrieve" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title fas fa-exclamation-triangle text-danger" id="transferRetrieveHead" style="padding-bottom: 6px;">&nbsp;&nbsp;Do you want to transfer this milestone ?</h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close" style="margin-top: 0px;">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>  
       <div class="modal-body" style="border-bottom: 1px solid #e5e5e5;" id="transferRetrieveBody">
       NOTE - System will update the client on the registered email for transferring the task.
       </div>
       <input type="hidden" id="TransferKeyModal">
       <input type="hidden" id="TransferKeyStatusModal">
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="transferRetrieve('NA','0')">Yes</button>
      </div>
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
				<select class="form-control" autocomplete="off" name="DocumentUploadBy" id="DocumentUploadBy">
					<option value="">Upload By</option>
					<option value="Client">Client</option>
					<option value="Agent">Agent</option>
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
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-primary" id="btnclick12" onclick="validateDocumentList()">Submit</button>
      </div> 
      </div>
	</form>  
  </div>
</div>
<div class="modal fade" id="replyNotesWritten" tabindex="-1" role="dialog" aria-labelledby="replyNotesWritten" aria-hidden="true">
  <div class="modal-dialog" role="document">
  <form onsubmit="return false" class="upload-box">
  <div class="modal-content">
  	 <div class="modal-header">
        <h5 class="modal-title" >+&nbsp;Reply</h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
		<div class="col-md-12 pad05 pad-top5">
		<div class="row location_box">
			<div class="col-md-12">
			<label>Comment</label>
				<textarea rows="5" name="notes_reply" id="notes_reply" class="form-control"></textarea>
			</div>	
		</div>			
		</div>
		</div>
		 <div class="modal-footer">
		 <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
         <button type="button" class="btn btn-primary" onclick="return saveNotesReply('NA','NA')">Submit</button>
      </div> 
      </div>
	</form>  
  </div>
</div>
<div class="modal fade" id="dateExtendRecord" tabindex="-1" role="dialog" aria-labelledby="dateExtendRecord" aria-hidden="true">
  <div class="modal-dialog" role="document">
  <form onsubmit="return false" class="upload-box">
  <div class="modal-content">
  	 <div class="modal-header">
        <h5 class="modal-title" >+&nbsp;Date Extend Reason</h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
		<div class="col-md-12 pad05 pad-top5">
		<div class="row location_box">
			<div class="col-md-12">
			<label>Comment</label>
				<textarea rows="5" name="date_extend_comment" id="date_extend_comment" class="form-control"></textarea>
			</div>	
		</div>			
		</div>
		</div>
		 <div class="modal-footer">
		 <input type="hidden" id="deliveryDateTime">
		 <button type="button" class="btn btn-secondary" data-dismiss="modal" onclick="setOldDate()">Cancel</button>
         <button type="button" class="btn btn-primary" onclick="return dateExtendRecord('NA')">Submit</button>
      </div> 
      </div>
	</form>  
  </div>
</div>
<div class="modal fade" id="UpdateRenewal" tabindex="-1" role="dialog" aria-labelledby="RenewalModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
  <form onsubmit="return false" class="upload-box">
  <div class="modal-content">
  	 <div class="modal-header">
        <h5 class="modal-title" >+&nbsp;Update Renewal</h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
		<div class="col-md-12 pad05 pad-top5">
		<div class="row location_box">
			<div class="col-md-6">
			<label>Approval date</label>
				<input type="date" name="ApprovalDate" id="ApprovalDate" class="form-control">
			</div>						
			<div class="col-md-6">
			<label>Renewal date</label>
				<input type="date" name="RenewalDate" id="RenewalDate" class="form-control">
			</div>
		</div>			
		</div>
		</div>
		 <div class="modal-footer">
		 <input type="hidden" name="UpdateAssignKey" id="UpdateAssignKey">
		 <input type="hidden" name="UpdateWorkPercentageId" id="UpdateWorkPercentageId">
		 <input type="hidden" name="UpdateSalesmilestonekey" id="UpdateSalesmilestonekey">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-warning" onclick="saveWorkNotApplicable()">Not Applicable</button>
        <button type="button" class="btn btn-primary" onclick="proceesSaveWork()">Submit</button>
      </div> 
      </div>
	</form>  
  </div>
</div> 

<div class="modal fade" id="documentSendWarning" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;">
        <span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span>
        <span class="text-danger">Want to share this document ?</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <div class="modal-footer">
      	<input type="hidden" id="sendDocumentClientKey">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" style="width: 15%;">OK</button>
        <button type="button" class="btn btn-primary" style="width: 15%;" onclick="sendDocumentEmail('NA')">Yes</button>
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
<div class="modal fade form_Builder" id="DynamicFormModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">
		<img src="<%=request.getContextPath() %>/staticresources/images/form.png" style="width: 19px;">
		<span class="text-danger">Dynamic Form Builder</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body warBody">
        <div id="build-wrap" class="build-wrap"></div>
      </div>
      <div class="modal-footer">
        <div class="col-md-12 row">
      <div class="col-md-4">
      <select class="form-control select2" id="DynamicFormTemplate" onchange="setDynamicForm(this.value)">
      	<option value="">Select dynamic form template</option>
      	<%if(template!=null&&template.length>0){ 
      		for(int i=0;i<template.length;i++){
      	%>
        <option value="<%=template[i][0]%>"><%=template[i][1]%></option>
        <%}} %>      
    </select>
    </div>
    <div class="col-md-3">
      <input type="text" class="form-control" autocomplete="off" onchange="isTemplateNameExist('DynamicFormName')" name="dynamicFormName" id="DynamicFormName" placeholder="Dynamic form name...">      
    </div>
    <div class="col-md-5">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" id="onclearall">Close</button>
        <button type="button" class="btn btn-primary" id="getJSON">Send</button>
        <button type="button" class="btn btn-info" onclick="saveAsTemplate()">Save as template</button>
      </div>
      </div>
      </div>
    </div>
  </div>
</div>
<div class="modal fade" id="ReUploadInProgress" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span>
        <span class="text-danger">Re-Upload Document In Progress...</span></h5>
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
<div class="modal fade form_Builder set_form_Builder" id="FilledDynamicFormData" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog form_show" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">
		<img src="<%=request.getContextPath() %>/staticresources/images/form.png" style="width: 19px;">
		<span class="text-danger">Dynamic Form</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body warBody">
        <div id="Filledbuild-wrap"></div>
      </div>      
    </div>
  </div>
</div>
<div class="modal fade" id="serviceDetails" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" style="padding-bottom: 6px;">
        <span class="fas fa-file-export text-primary" style="margin-right: 10px;"> </span>
        <span class="text-primary">Service Details</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <form action="return false">
       <div class="modal-body">
  <div class="container-fluid" id="serviceBody">
    <div class="col-md-12">
	  <h4>Client&nbsp;&nbsp;<i class="fa fa-clone pointer cmpn" aria-hidden="true" onclick="copyToClipboard('cmpn')"></i></h4>
	  	<p><span id="cmpn"><%=companyname %></span>&nbsp;(<%=companyIndustry %>)</p>
	  <h4>Service&nbsp;&nbsp;<i class="fa fa-clone pointer cmppn" aria-hidden="true" onclick="copyToClipboard('cmppn')"></i></h4>
	    <p><span id="cmppn"><%=productName %></span>&nbsp;( <%=jurisdiction %> )</p>
	  <h4>Remarks&nbsp;&nbsp;<i class="fa fa-clone pointer serviceRemark" aria-hidden="true" onclick="copyToClipboard('serviceRemark')"></i></h4>
    	<p id="serviceRemark">No Content</p>  
   </div>      
  </div>
</div>
      </form>
    </div>
  </div>
</div>
<button type="button" id="clear-all-fields" class="DispNone"></button>
<button type="button" id="Set-dynamic-form-template" class="DispNone"></button>
<input type="hidden" id="ProjectFollowUpKey"/>
<input type="hidden" id="replyNotesAddedByUid"/>
<input type="hidden" id="serviceDetailsModelKey">
<input type="hidden" id="MilestonePrevDeliveryDate" value="NA">
<!-- <input type="hidden" id="ActiveEmployeeSalesKey" value="NA"> -->
<input type="hidden" id="EditTaskCompAddress" value="<%=compaddress%>"/>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/formBuilder/js/form-builder.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/app.js"></script>
<script type="text/javascript">    
   $( document ).ready(function() {	 
	   CKEDITOR.replace('SMS_Description',{
		   height:92
	   });
	   CKEDITOR.replace('Email_Description',{
		   height:92
	   });
	   CKEDITOR.replace( 'ChatTextareaBoxReply',{
		   height:92
	   });
	   CKEDITOR.replace( 'ChatTextareaBoxReply1',{
		   height:92
	   });
	   setTimeout(() => {
			$(".tooltips1").removeClass("visible");
		}, 7000);
	});
</script>
<script type="text/javascript">
var formDataJson="";
function setFollowUpId(fkey,formName){
	$("#ProjectFollowUpKey").val(fkey);
	$("#DynamicFormName").val(formName);
}

$( document ).ready(function() {
	var chatOpenBox="<%=chatOpenBox%>";
	if(chatOpenBox=="chat"){
		setTimeout(function(){ $(".openChat").click();clearSession('chatOpenBox'); }, 500);		
	}else if(chatOpenBox=="doc"){
		setTimeout(function(){ $(".adddoc").click();clearSession('chatOpenBox'); }, 500);		
	}
	
	var workStarted="<%=workStarted%>";
	var milestoneKey="<%=milestoneKey%>";
	
	setExtendDate(workStarted,milestoneKey);
});

function isTemplateNameExist(FormNameId){
	var formName=$("#"+FormNameId).val();
	showLoader();
	$.ajax({
		type : "POST",
		url : "IsformNameExists111",
		dataType : "HTML",
		data : {				
			formName : formName
		},
		success : function(data){
			if(data=="pass"){	
				document.getElementById('errorMsg').innerHTML ="Duplicate template name : "+formName;
				$("#"+FormNameId).val("");
				$('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function() {
            hideLoader();
        }
	});
}

function saveAsTemplate(){
	$("#getJSON").click();
	var dynamicFormName=$("#DynamicFormName").val();
	setTimeout(() => {
		if(formDataJson!="[]"&&dynamicFormName!=null&&dynamicFormName!=""){
			showLoader();
			$.ajax({
				type : "POST",
				url : "SaveDynamicFormTemplate111",
				dataType : "HTML",
				data : {				
					dynamicFormName : dynamicFormName,
					formDataJson : formDataJson,
					"type" : "form"
				},
				success : function(data){
					if(data=="pass"){	
						document.getElementById('errorMsg1').innerHTML ="Form saved as template !!";
						$('.alert-show1').show().delay(3000).fadeOut();					
					}else{
						document.getElementById('errorMsg').innerHTML ="Something went wrong !! Please Try-again later !!";
						$('.alert-show').show().delay(3000).fadeOut();
					}			
				},
				complete : function() {
		            hideLoader();
		        }
			});						
		}
	}, 200);
}

function setExtendDate(memberassigndate,milestoneKey){
	$(".removeDelvDate").remove();
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetMilestoneExpireDate111",
		dataType : "HTML",
		data : {				
			milestoneKey : milestoneKey,
			memberassigndate : memberassigndate,
			"salesKey" : "<%=salesrefid%>"
		},
		success : function(deliveryDate){
			if(deliveryDate!=""){
				var data=deliveryDate.split("#");
				deliveryDate=data[0];
				if(data[1]=="NA")data[1]="18:00";
				var x=deliveryDate.split("-");
				if(Number(x[0].length)!=4)
				deliveryDate=x[2]+"-"+x[1]+"-"+x[0];
				
				var y=data[1].split(":");
				if(Number(y[0].length)==1)y[0]="0"+y[0];
				if(Number(y[1].length)==1)y[1]="0"+y[1];
				data[1]=y[0]+":"+y[1];
				
// 				if(Number(data[1].length)==4)data[1]="0"+data[1];
				
				var today="<%=today%>";
				var time="<%=currentTime%>"
				x=today.split("-");
				today=x[2]+"-"+x[1]+"-"+x[0];
				
				var endDate=new Date(deliveryDate);  
				
				var todayDate=new Date(today);    
				$("#MilestonePrevDeliveryDate").val(deliveryDate+'T'+data[1]);
// 				console.log(deliveryDate+'T'+data[1]);
// 				if(endDate<todayDate){
					$(''+
							'<span class="bg_circle removeDelvDate"><span class="pointers"><input id="SetDeliveryDateId" type="datetime-local" name="setDeliveryDate" onchange="dateExtendRecord(\''+deliveryDate+'T'+data[1]+'\')" value="'+deliveryDate+'T'+data[1]+'" min="'+deliveryDate+'T'+data[1]+'"></span></span>'
							).insertBefore("#MilestoneEndDateId");					
// 				}else{
// 					$(''+
// 							'<span class="bg_circle removeDelvDate"><input id="SetDeliveryDateId" type="datetime-local" value="'+deliveryDate+'T'+data[1]+'" readonly></span>'
// 							).insertBefore("#MilestoneEndDateId");
// 				}
			}
		},
		complete : function() {
            hideLoader();
        }
		
	});
	
}
function closeReminder(remKey,TaskReminderClose){
	showLoader();
	$.ajax({
		type : "POST",
		url : "CloseSalesReminder111",
		dataType : "HTML",
		data : {				
			remKey : remKey,			
		},
		success : function(data){
			if(data=="pass"){	
				$("#"+TaskReminderClose).show();				
			}else{
				document.getElementById('errorMsg').innerHTML ="Something went wrong !! Please Try-again later !!";
				$('.alert-show').show().delay(3000).fadeOut();
			}			
		},
		complete : function() {
            hideLoader();
        }
	});
}
function updateReminder(remKey,i){
	var UpdateReminderTask="UpdateReminderTask"+Number(i);
	var UpdateReminderTime="UpdateReminderTime"+Number(i);
	var UpdateReminderDate="UpdateReminderDate"+Number(i);
	var FormBox="TaskAssignedAddReminderId"+Number(i);

	var taskName=$("#"+UpdateReminderTask).val();
	var Time=$("#"+UpdateReminderTime).val();
	var Date=$("#"+UpdateReminderDate).val();
	
	if(taskName==null||taskName==""){
		document.getElementById('errorMsg').innerHTML ="Please enter Task !!.";
		$('.alert-show').show().delay(2000).fadeOut();
		return false;
	}
	if(Time==null||Time==""){
		document.getElementById('errorMsg').innerHTML ="Please enter Reminder Time !!.";
		$('.alert-show').show().delay(2000).fadeOut();
		return false;
	}
	if(Date==null||Date==""){
		document.getElementById('errorMsg').innerHTML ="Please enter Reminder Date !!.";
		$('.alert-show').show().delay(2000).fadeOut();
		return false;
	}
	showLoader();
	$.ajax({
		type : "POST",
		url : "UpdateSalesReminder111",
		dataType : "HTML",
		data : {				
			remKey : remKey,
			taskName : taskName,
			Time : Time,
			Date : Date
		},
		success : function(data){
			if(data=="pass"){	
				hideAssignBox(FormBox);
				$("#ReloadReminder").load(location.href + " #ReloadReminder1");						
			}else{
				document.getElementById('errorMsg').innerHTML ="Something went wrong !! Please Try-again later !!";
				$('.alert-show').show().delay(3000).fadeOut();
			}			
		},
		complete : function() {
            hideLoader();
        }
	});
	
// 	alert(remKey+"/"+i+"/"+UpdateReminderTask+"/"+UpdateReminderTime+"/"+UpdateReminderDate);
}

function saveReminder(){
	var content=$("#ReminderTask").val();
	var Time=$("#ReminderTime").val();
	var Date=$("#ReminderDate").val();
	
	if(content==null||content==""){
		document.getElementById('errorMsg').innerHTML ="Please enter Task !!.";
		$('.alert-show').show().delay(2000).fadeOut();
		return false;
	}
	if(Time==null||Time==""){
		document.getElementById('errorMsg').innerHTML ="Please enter Reminder Time !!.";
		$('.alert-show').show().delay(2000).fadeOut();
		return false;
	}
	if(Date==null||Date==""){
		document.getElementById('errorMsg').innerHTML ="Please enter Reminder Date !!.";
		$('.alert-show').show().delay(2000).fadeOut();
		return false;
	}
	var salesrefid="<%=salesrefid%>";
	var taskKey="<%=assignKey%>";
	showLoader();
	$.ajax({
		type : "POST",
		url : "SetSalesReminder111",
		dataType : "HTML",
		data : {				
			salesrefid : salesrefid,
			content : content,
			Time : Time,
			Date : Date,
			taskKey : taskKey
		},
		success : function(data){
			if(data=="pass"){	
				hideAssignBox('TaskAssignedReminderId1');
				$("#ReloadReminder").load(location.href + " #ReloadReminder1");	
				$("#ReloadTaskThread").load(location.href + " #ReloadTaskThread1");
			}else{
				document.getElementById('errorMsg').innerHTML ="Something went wrong !! Please Try-again later !!";
				$('.alert-show').show().delay(3000).fadeOut();
			}			
		},
		complete : function() {
            hideLoader();
        }
	});
	
}


function isUpdateDuplicateMobilePhone(phoneid){
	var contkey=document.getElementById("UpdateContactKey").value.trim();
	var val=document.getElementById(phoneid).value.trim();
	if(val!=""&&val!="NA"){
		showLoader();
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
			
		},
		complete : function() {
            hideLoader();
        }
	});}
	$("#"+phoneid).val(val.replace(/ /g,''));
}
function isUpdateDuplicateEmail(emailid){
	var contkey=document.getElementById("UpdateContactKey").value.trim();
	var val=document.getElementById(emailid).value.trim();
	if(val!=""&&val!="NA"){
		showLoader();
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
			
		},
		complete : function() {
            hideLoader();
        }
	});}
}

function isDuplicateMobilePhone(phoneid){
	var val=document.getElementById(phoneid).value.trim();
	if(val!=""&&val!="NA"){
		showLoader();
	$.ajax({
		type : "POST",
		url : "ExistValue111",
		dataType : "HTML",
		data : {"val":val,"field":"addcontactmobilephone"},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg").innerHTML="Duplicate Mobile Phone.";
			document.getElementById(phoneid).value="";
			$('.alert-show').show().delay(4000).fadeOut();
			}
			
		},
		complete : function() {
            hideLoader();
        }
	});}
}
function isDuplicateEmail(emailid){
	var val=document.getElementById(emailid).value.trim();
	if(val!=""&&val!="NA"){
		showLoader();
	$.ajax({
		type : "POST",
		url : "ExistValue111",
		dataType : "HTML",
		data : {"val":val,"field":"addcontactemail1"},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg").innerHTML="Duplicate Email-Id.";
			document.getElementById(emailid).value="";
			$('.alert-show').show().delay(4000).fadeOut();
			}			
		},
		complete : function() {
            hideLoader();
        }
	});}
}
function uploadFile(uploadbox,MainDownloadIcon,AppendDocDownload,docKey,File,DocumentListDateId){
	
	const fi=document.getElementById(File);
	if (fi.files.length > 0) {
		const fsize = fi.files.item(0).size; 
        const file = Math.round((fsize / 1024)); 
        
        // The size of the file. 
        if (file >= 49152) {  
            document.getElementById('errorMsg').innerHTML ='File too Big, Max File Size 48 MB !!';
            document.getElementById(File).value="";
 		    $('.alert-show').show().delay(4000).fadeOut();
        }else{
        	uploadFile1(uploadbox,MainDownloadIcon,AppendDocDownload,docKey,File,DocumentListDateId);
        }	
	}	 
}
function uploadFile1(uploadbox,MainDownloadIcon,AppendDocDownload,docKey,File,DocumentListDateId){	
	if($("#"+File).val()!=""){
		showLoader();
	var today="<%=today%>";
	var assignKey="<%=assignKey%>";
	var workStartPrice="<%=workStartPrice%>";

	var form = $("."+uploadbox)[0];
    var data = new FormData(form);
    data.append("docKey", docKey)
    data.append("file", File);
    data.append("assignKey",assignKey);
    data.append("workStartPrice",workStartPrice);
    showLoader();
	$.ajax({
        type : "POST",
        encType : "multipart/form-data",
        url : "<%=request.getContextPath()%>/UpdateSalesDocuments111",
        cache : false,
        processData : false,
        contentType : false,
        data : data,
        success : function(msg) {
        	$("."+MainDownloadIcon).remove();
        	var x=msg.split("#");
	        	if(x[0]=="pass"){
	          	document.getElementById('errorMsg1').innerHTML ="Uploaded Successfully !!";
	          	$("#"+DocumentListDateId).html(today);
	          	var fileDownload="<%=azure_path%>"+x[1];
	          	//change date and color
	          	$("."+MainDownloadIcon).hide();
	  			$(''+
	  				'<a class="bg_none colorNone '+MainDownloadIcon+'" href="'+fileDownload+'" download>'+
	  				'<i class="fas fa-arrow-down pointers" title="Download this document"></i></a>'
	  			).insertBefore("#"+AppendDocDownload);
	  			
	      		$('.alert-show1').show().delay(3000).fadeOut();
      		}else{
      			document.getElementById('errorMsg').innerHTML ="Something Went wrong ,try-again later !!";
  	    		$('.alert-show').show().delay(3000).fadeOut();
      		}
        },
        error : function(msg) {
            alert("Couldn't upload file");
        },
        complete : function(msg) {
            hideLoader();
        }
    });
	}	 
}
function addCallLogNotes(NewCallLogBoxId){
	var notes=$("#"+NewCallLogBoxId).val();
	var contact=$("#AddCallLogOptId").val();
	if(notes==null||notes==""){
		document.getElementById('errorMsg').innerHTML ="Please enter some text to post !!";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	var salesrefid="<%=salesrefid%>";
	showLoader();
	$.ajax({
		type : "POST",
		url : "SaveTaskCallLogs111",
		dataType : "HTML",
		data : {				
			salesrefid : salesrefid,
			notes : notes,
			contact : contact
		},
		success : function(data){
			if(data=="pass"){	 
				$("#newCallLogsId").hide();
				$("#ReloadTaskThread").load(location.href + " #ReloadTaskThread1");
			}else{
				document.getElementById('errorMsg').innerHTML ="Something went wrong !! Please Try-again later !!";
				$('.alert-show').show().delay(3000).fadeOut();
			}
		},
		complete : function() {
            hideLoader();
        }
	});
}
function addTaskNotes(NewNotesBoxId){
	var notes=$("#"+NewNotesBoxId).val();
	var contact=$("#AddNotesOptId").val();
	if(notes==null||notes==""){
		document.getElementById('errorMsg').innerHTML ="Please enter some text to post !!";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	var salesrefid="<%=salesrefid%>";
	showLoader();
	$.ajax({
		type : "POST",
		url : "SaveTaskNotes111",
		dataType : "HTML",
		data : {				
			salesrefid : salesrefid,
			notes : notes,
			contact : contact
		},
		success : function(data){
			if(data=="pass"){	
				$("#newNotesDivId").hide();
				$("#ReloadTaskThread").load(location.href + " #ReloadTaskThread1");
			}else{
				document.getElementById('errorMsg').innerHTML ="Something went wrong !! Please Try-again later !!";
				$('.alert-show').show().delay(3000).fadeOut();
			}
		},
		complete : function() {
            hideLoader();
        }
	});
}
function addTaskNotesForSales(NewNotesBoxId){
	var notes=$("#"+NewNotesBoxId).val();
	var contact=$("#AddNotesOptIdSales").val();
	if(notes==null||notes==""){
		document.getElementById('errorMsg').innerHTML ="Please enter some text to post !!";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	var salesrefid="<%=salesrefid%>";
	showLoader();
	$.ajax({
		type : "POST",
		url : "SaveSalesTaskNotes111",
		dataType : "HTML",
		data : {				
			salesrefid : salesrefid,
			notes : notes,
			contact : contact,
			type : "Team"
		},
		success : function(data){
			$("#newNotesSalesDivId").hide();
			$("#ReloadTaskThread").load(location.href + " #ReloadTaskThread1");			
		},
		complete : function() {
            hideLoader();
        }
	});
}		
		
function proceesSaveWork(){	
	var assignKey=$("#UpdateAssignKey").val();
	var workPercentageId=$("#UpdateWorkPercentageId").val();
	var salesmilestonekey=$("#UpdateSalesmilestonekey").val();
	var workPercentage=$("#"+workPercentageId).val();
	var salesKey="<%=salesrefid%>"; 	
	var approvalDate=$("#ApprovalDate").val();
	var renewalDate=$("#RenewalDate").val();
	if(approvalDate==null||approvalDate==""){
		document.getElementById('errorMsg').innerHTML ="Approval date can't be blank !!.";
		$('.alert-show').show().delay(2000).fadeOut();
		return false;
	}
	if(renewalDate==null||renewalDate==""){
		document.getElementById('errorMsg').innerHTML ="Renewal date can't be blank !!.";
		$('.alert-show').show().delay(2000).fadeOut();
		return false;
	}
	
	$("#UpdateRenewal").modal("hide");
	saveRenewalDate(assignKey,salesmilestonekey,salesKey,approvalDate,renewalDate);
	setTimeout(() => {
		saveWorkProgress(workPercentage,salesKey,assignKey,salesmilestonekey,workPercentageId);
	}, 2000);
	
}
function saveRenewalDate(assignKey,salesmilestonekey,salesKey,approvalDate,renewalDate){
	showLoader();
	$.ajax({
		type : "POST",
		url : "SetRenewalDate111",
		dataType : "HTML",
		data : {				
			assignKey : assignKey,
			salesKey : salesKey,
			salesmilestonekey : salesmilestonekey,
			approvalDate : approvalDate,
			renewalDate : renewalDate
		},
		success : function(data){
			if(data=="pass"){				
				document.getElementById('errorMsg1').innerHTML ="Task added in renewal !!";
				$('.alert-show1').show().delay(3000).fadeOut();				
			}else{
				document.getElementById('errorMsg').innerHTML ="Something went wrong !! Please Try-again later !!";
				$('.alert-show').show().delay(3000).fadeOut();
			}
		},
		complete : function() {
            hideLoader();
        }
	});
}
function saveWorkNotApplicable(){
	var assignKey=$("#UpdateAssignKey").val();
	var workPercentageId=$("#UpdateWorkPercentageId").val();
	var salesmilestonekey=$("#UpdateSalesmilestonekey").val();
	var workPercentage=$("#"+workPercentageId).val();
	var salesKey="<%=salesrefid%>"; 	
	$("#UpdateRenewal").modal("hide");
	saveWorkProgress(workPercentage,salesKey,assignKey,salesmilestonekey,workPercentageId);
}
function saveWorkPercentage(assignKey,workPercentageId,salesmilestonekey){
	var workPercentage=$("#"+workPercentageId).val();
	var salesKey="<%=salesrefid%>";
	
	if(workPercentage==null||workPercentage==""||Number(workPercentage)<=0||Number(workPercentage)>100){
		document.getElementById('errorMsg').innerHTML ="Work Percentage between 1-100 !!.";
		$('.alert-show').show().delay(2000).fadeOut();
		return false;
	}
	if(Number(workPercentage)==100){
		$("#UpdateAssignKey").val(assignKey);
		$("#UpdateWorkPercentageId").val(workPercentageId);
		$("#UpdateSalesmilestonekey").val(salesmilestonekey);
		$("#UpdateRenewal").modal("show");
	}else{
		saveWorkProgress(workPercentage,salesKey,assignKey,salesmilestonekey,workPercentageId);
	}	
}
function saveWorkProgress(workPercentage,salesKey,assignKey,salesmilestonekey,workPercentageId){
	showLoader()
	$.ajax({
		type : "POST",
		url : "AssignWorkPercentage111",
		dataType : "HTML",
		data : {				
			assignKey : assignKey,
			workPercentage : workPercentage,
			salesKey : salesKey,
			salesmilestonekey : salesmilestonekey
		},
		success : function(data){
			if(data=="pass"){				
				document.getElementById('errorMsg1').innerHTML ="Work Percentage assigned "+workPercentage+"%";				
				$('.alert-show1').show().delay(3000).fadeOut();		
				
				if(Number(workPercentage)==100){
					$(".appendedList").remove();
					$("#chatReplyList").append('<li class="appendedList"><a onclick="validateChatReply(\'Completed\')"><span class="dot_circle_completed"></span>Completed</a></li>');
				}else $(".appendedList").remove();
			}else if(data=="invalid"){
				document.getElementById('errorMsg').innerHTML ="Please upload all certificates before submit !!";
				$("#"+workPercentageId).val("0");
				$('.alert-show').show().delay(3000).fadeOut();
			}else{
				document.getElementById('errorMsg').innerHTML ="Something went wrong !! Please Try-again later !!";
				$('.alert-show').show().delay(3000).fadeOut();
			}
		},
		complete : function(msg) {
            hideLoader();
        }
	});
}
function showAssignBox(AssignBoxId){
	$(".toggleBox").hide();
	$("#"+AssignBoxId).show();
}
function hideAssignBox(AssignBoxId){	
	$("#"+AssignBoxId).hide();
}
</script>
<script>
$('.order_view').click(function(){
    $(this).next().slideToggle();
});
</script>
<script>
$('.toggleBtn').click(function(event){ 
	event.preventDefault();
	event.stopPropagation();
	$('.toggleBtn').removeClass("active");
	$('.toggleBox').removeClass("active");
	$(this).addClass("active");
	$(this).parent().next().addClass("active");
	$('.contacts_info').hide();
});
</script>
<script>
$('.cancelBtn').click(function(event){ 
	event.preventDefault();
	event.stopPropagation();
	$('.toggleBtn').removeClass("active");
	$('.toggleBox').removeClass("active");
});
</script> 
<script>
$('.contactBtn').click(function(event){ 
	event.preventDefault();
	event.stopPropagation();
	$('.toggleBox').removeClass("active");
	$('.contacts_info').show();
});
</script>
<script>
$('.close_box').on( "click", function(e) { 
$('.fixed_right_box').removeClass('active');	
});
</script>
<script>
$('.add_new').on( "click", function(e) {
	$(this).parent().next().show();	
	});	
$('.del_icon').on( "click", function(e) {
	$('.new_field').hide();	
	});
$('#ContactperAddress').on( "click", function(e) {
	$('.address_box').show();
	$('.company_box').hide();	
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
	
	function setTeamMember(teamrefid,Select_Assignee,memberid){		
		if(teamrefid!=""){
			showLoader();
		$.ajax({
		    type: "POST",
		    dataType: "html",
		    url: "<%=request.getContextPath()%>/GetAllTeamMemberList111",
		    data:  { 
		    	teamrefid: teamrefid,	    	
		    },
		    success: function (response) {
		    	if(Object.keys(response).length!=0){
		     	response = JSON.parse(response);			
				 var len = response.length;
				    $("#"+Select_Assignee).empty();
				    $("#"+Select_Assignee).append("<option value=''>"+"Select Assignee"+"</option>");
					for( var i =0; i<len; i++){		
						var userId = response[i]['userId'];
						var name = response[i]['name'];
						if(userId==memberid){
							$("#"+Select_Assignee).append("<option value='"+userId+"' selected='selected'>"+name+"</option>");
						}else{
							$("#"+Select_Assignee).append("<option value='"+userId+"'>"+name+"</option>");
						}
					}
		    	}
		    },
		    error: function (error) {
		    	alert("error in setTeamMember() " + error.responseText);
		    },
		    complete : function() {
	            hideLoader();
	        }
		});
		}else{
			$("#"+Select_Assignee).empty();
		    $("#"+Select_Assignee).append("<option value=''>"+"Select Assignee"+"</option>");
		}
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
		var salesrefid="<%=salesrefid%>";
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
					var append="AppendNewAgentDocList";
					if(UploadBy=="Client")append="AppendNewClientDocList";
					$("#AddNewDocumentList").modal("hide");
					$(''+
					'<div class="clearfix bg_wht link-style12">'+
					  ' <div class="col-xs-3 box-intro-background">'+
					       '<div class="clearfix">'+
					       '<p class="news-border">00-00-0000</p>'+
					       '</div>'+
					   '</div>'+
					   '<div class="col-xs-7 box-intro-background">'+
					       '<div class="clearfix">'+
					       '<p class="news-border" title="'+docname+'">'+docname+'</p>'+
					       '</div>'+
					   '</div>'+
					 '  <div class="col-xs-2 box-intro-background">'+
					       '<div class="clearfix">'+
					       '<p class="news-border" style="font-size: 15px;">'+
					       '<span style="margin-right: 3px;">'+
					       '<input id="fileInput" type="file" style="display:none;">'+
					       '<button onclick="document.getElementById(\'fileInput\').click();" style="border: none;background: #ffff;"><i class="fas fa-file"></i></button>'+
					       '</span>'+
					       '</p>'+
					       '</div>'+
					   '</div>'+                                  
					'</div>').insertBefore('#'+append);
					
				}else{
					document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
					$('.alert-show').show().delay(4000).fadeOut();
				}
			},
			complete : function() {
	            hideLoader();
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
				document.getElementById('errorMsg').innerHTML ="Country is mandatory !!";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
			}
			if(document.getElementById("UpdateContState").value.trim()==""){
				document.getElementById('errorMsg').innerHTML ="State is mandatory !!";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
			}
			if(document.getElementById("UpdateContCity").value.trim()==""){
				document.getElementById('errorMsg').innerHTML ="City is mandatory !!";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
			}			
			if(document.getElementById("UpdateContAddress").value.trim()==""){
				document.getElementById('errorMsg').innerHTML ="Address is mandatory !!";
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
	    	country=document.getElementById("UpdateContCountry").value.trim();
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
				address : address,
				companyaddress : companyaddress,
				addresstype : addresstype,
				contkey : contkey,
				pan : pan,
				country : country,
				stateCode : stateCode
			},
			success : function(data){
				$("#ValidateUpdateContact").removeAttr("disabled");
				if(data=="pass"){					
					$('.fixed_right_box').removeClass('active');
					$('.addnew').show();					
					updateSalesContact(stbid,firstname,lastname,email,email2,workphone,mobile);									
				}else if(data=="invalid"){
					document.getElementById('errorMsg').innerHTML = 'Please enter a valid email !! !!';
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
	var salesKey="<%=salesrefid%>";
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
				salesKey : salesKey
			},
			success : function(data){
				if(data=="pass"){
					
					document.getElementById('errorMsg1').innerHTML = 'Successfully Updated !!';	
					$("#RefreshContacts").load(location.href + " #RefreshContacts1");
					$('.alert-show1').show().delay(4000).fadeOut();	
					
				}else{
					document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
					$('.alert-show').show().delay(4000).fadeOut();
				}
			},
			complete : function() {
	            hideLoader();
	        }
		});
	}	
function openUpdateContactBox(contctref,cboxid){
	fillContactUpdateForm(contctref,cboxid);
	var id = $(".updatecontactbox").attr('data-related'); 
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
			var addresstype=response[0]["addresstype"].trim();
			var city=response[0]["city"];
			var state=response[0]["state"];
			var address=response[0]["address"];
			var pan=response[0]["pan"];
			var country=response[0]["country"];
			
			$("#UpdateContactKey").val(contkey);$("#UpdateContactSalesKey").val(cboxid);$("#UpdateContactFirstName").val(firstname);$("#UpdateContactLastName").val(lastname);$("#UpdateContactEmail_Id").val(email1);
			if(email2!=="NA"){
				$("#UpdateContactEmailId2").val(email2);
				document.getElementById("UpdateContactDivId").style.display="block";
			}			
			$("#UpdateContactWorkPhone").val(workphone);$("#UpdateContactMobilePhone").val(mobilephone);
			$("#UpdateContPan").val(pan);
			if(addresstype=="Personal"){
				$("#UpdateContactperAddress").prop('checked',true);
				$("#UpdateContactcomAddress").prop('checked',false);	
				$("#UpdateContCountry").val(country);
				$("#UpdateContCity").empty();
				$("#UpdateContCity").append("<option value='"+city+"'>"+city+"</option>");
				$("#UpdateContState").empty();
				$("#UpdateContState").append("<option value='0#0#"+state+"'>"+state+"</option>");
				$("#UpdateContAddress").val(address);	
				$(".UpdateAddress_box").show();
				$(".UpdateCompany_box").hide();
			}else if(addresstype=="Company"){
				$("#UpdateContactperAddress").prop('checked',false);	
				$("#UpdateContactcomAddress").prop('checked',true);
				$("#UpdateEnqCompAddress").val(address);
				$(".UpdateAddress_box").hide();
				$(".UpdateCompany_box").show();
			}			
			
		 }
		}
	},
	complete : function() {
        hideLoader();
    }
	});
}
function showContact(name,cont1,cont2,type){
	if(type=="mobile"){   
		$("#ContactEmailDiv").hide();
		$("#ContactMobileDiv").show();
		$("#FirstContactMobileName").html(name);
		$("#FirstContactMobile").html(cont1);
		if(cont2!=null&&cont2!=""&&cont2.toLowerCase()!="na"){
			$("#SecondContactMobileDisp").show();
			$("#SecondContactMobile").html(cont2);
		}else{
			$("#SecondContactMobileDisp").hide();
			$("#SecondContactMobile").html('');
		}
	}else{
		$("#ContactMobileDiv").hide();
		$("#ContactEmailDiv").show();
		$("#FirstContactEmailName").html(name);
		$("#FirstContactEmail").html(cont1);
		if(cont2!=null&&cont2!=""&&cont2.toLowerCase()!="na"){
			$("#SecondContactEmailDisp").show();
			$("#SecondContactEmail").html(cont2);
		}else{
			$("#SecondContactEmailDisp").hide();
			$("#SecondContactEmail").html('');
		}
	}
}

function  showChatReply(PublicreplyLi,InternalreplyLi,ReplyNotesBoxId,InternalNotesBoxId,ChatReplyButtonId){
	$("#"+PublicreplyLi).addClass("active");
	$("#"+InternalreplyLi).removeClass("active");
	$("#"+ReplyNotesBoxId).show();
	$("#"+InternalNotesBoxId).hide();
	$("#"+ChatReplyButtonId).show();
	$(".communication_history").show();
	$(".communication_history1").show();
	$(".internalNotes").addClass("toggle_box");
}
function  showInternalReply(PublicreplyLi,InternalreplyLi,ReplyNotesBoxId,InternalNotesBoxId,ChatReplyButtonId){
	$("#"+PublicreplyLi).removeClass("active");
	$("#"+InternalreplyLi).addClass("active");
	$("#"+ReplyNotesBoxId).hide();
	$("#"+InternalNotesBoxId).show();
	$("#"+ChatReplyButtonId).hide();
	$(".communication_history").hide();
	$(".communication_history1").hide();
	$(".internalNotes").removeClass("toggle_box");
}
function updateThisNotes(notificationKey,NotesBoxId,ContactBoxId,DisplayNoneJsId,DisplayNoneSubmitId,DisplayNoneTimerId,TimeCalculatorId){  
	var notes=$("#"+NotesBoxId).html();
	var contact=$("#"+ContactBoxId).val();	
	showLoader();
	$.ajax({
		type : "POST",
		url : "UpdateSavedNotes111",
		dataType : "HTML",
		data : {
			notificationKey : notificationKey,
			notes : notes,
			contact : contact
		},
		success : function(data){
			if(data=="pass"){
				document.getElementById('errorMsg1').innerHTML = 'Updated Successfully !!';				
					$("#"+DisplayNoneJsId).removeClass("DispNone");
					$("#"+DisplayNoneSubmitId).addClass("DispNone");
					$("#"+DisplayNoneTimerId).removeClass("DispNone");
					$("#"+NotesBoxId).removeClass("full_width");
					$("#"+NotesBoxId).removeClass("contentBox1");
					$("#"+NotesBoxId).attr("contenteditable","false");	
					$("#"+TimeCalculatorId).html("Just Now");
				$('.alert-show1').show().delay(2000).fadeOut();								
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
				$('.alert-show').show().delay(3000).fadeOut();
			}
		},
		complete : function() {
            hideLoader();
        }
	});
	
}
function editTextarea(NotesBoxId,DisplayNoneJsId,DisplayNoneSubmitId,DisplayNoneTimerId){  
	$("#"+DisplayNoneJsId).addClass("DispNone");
	$("#"+DisplayNoneSubmitId).removeClass("DispNone");
	$("#"+DisplayNoneTimerId).addClass("DispNone");
	$("#"+NotesBoxId).addClass("full_width");
	$("#"+NotesBoxId).addClass("contentBox1");
	$("#"+NotesBoxId).attr("contenteditable","true");
	$("#"+NotesBoxId).focus();
	
}
function focusTextara(Displayboxid,CallLogNotesId){
	$("#"+Displayboxid).show();
	$("#"+CallLogNotesId).focus();
}
function removeMainCallNotes(ListBoxId,TaskKey){
	showLoader();
	$.ajax({
		type : "POST",
		url : "DeleteThisTaskChat111",
		dataType : "HTML",
		data : {				
			TaskKey : TaskKey
		},
		success : function(data){
			if(data=="pass"){	
				document.getElementById('errorMsg1').innerHTML = "Deleted !!";
				$("#"+ListBoxId).remove();
				$('.alert-show1').show().delay(500).fadeOut();					
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function() {
            hideLoader();
        }
	});
}
function removeCallNotes(Hideboxid,CallLogNotesId){
	$('#'+Hideboxid).hide();
	$('#'+CallLogNotesId).val('');
}
function validateAddExpense(){	
	var expname=$("#AddExpenseClientName").val().trim();
	var expNumber=$("#AddExpenseClientContactNumber").val().trim();
	var expAmount=$("#AddExpense_Amount").val().trim();
	var expCategory=$("#AddExpenseCategory").val().trim();
	var expHSN=$("#AddHSN_Code").val().trim();
	var expDepartment=$("#AddExpenseDepartment").val().trim();
	var expAccount=$("#AddPaidFromAccount").val().trim();
	var expNote=$("#AddExpenseNote").val().trim();
	var salesKey="<%=salesrefid%>";
	
	if(expname==null||expname==""){
		document.getElementById('errorMsg').innerHTML ="Please enter client's name  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}
	if(expNumber==null||expNumber==""){
		document.getElementById('errorMsg').innerHTML ="Please enter client's contact number  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}
	if(expAmount==null||expAmount==""){
		document.getElementById('errorMsg').innerHTML ="Please enter expense amount  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}
	if(expCategory==null||expCategory==""){
		document.getElementById('errorMsg').innerHTML ="Please select expense category  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}
	if(expDepartment==null||expDepartment==""){
		document.getElementById('errorMsg').innerHTML ="Please enter expense department  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}
	if(expAccount==null||expAccount==""){
		document.getElementById('errorMsg').innerHTML ="Please select payment via account  !!";    	
    	$('.alert-show').show().delay(3000).fadeOut();    
    	return false;
	}
	if(expNote==null||expNote==""){
		document.getElementById('errorMsg').innerHTML ="Please describe this expense in few word..  !!";    	
    	$('.alert-show').show().delay(4000).fadeOut();    
    	return false;
	}
	if(expHSN==null||expHSN==""){
		$("#AddHSN_Code").val("NA");
	}
	$("#exp_btn").attr("disabled","disabled");
	var task_name="<%=milestone[0][4] %>";
	var assignKey="<%=assignKey%>";
	showLoader();
	$.ajax({
		type : "POST",
		url : "AddExpenseApproval111",
		dataType : "HTML",
		data : {				
			expname : expname,
			expNumber : expNumber,
			expAmount : expAmount,
			expCategory : expCategory,
			expHSN : expHSN,
			expDepartment : expDepartment,
			expAccount : expAccount,
			expNote : expNote,
			salesKey : salesKey,
			task_name : task_name,
			assignKey : assignKey,
			approvalStatus : "2",
			approveBy : "NA"
		},
		success : function(data){
			$("#exp_btn").removeAttr("disabled");
			if(data=="pass"){
				document.getElementById('errorMsg1').innerHTML = 'Successfully expense added for approval !!';				
				 $('.closeAddExpenseBtn').click();
				 $("#ReloadTaskThread").load(location.href + " #ReloadTaskThread1");
				$('.alert-show1').show().delay(2000).fadeOut();								
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try-again Sometime later !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function() {
            hideLoader();
        }
	});
	
}

$(function() {
	$("#AddHSN_Code").autocomplete({
		source : function(request, response) {
			if(document.getElementById("AddHSN_Code").value.trim().length>=2)
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
            	document.getElementById('errorMsg').innerHTML ="HSN number doesn't exist !!";
            	$("#AddHSN_Code").val(""); 
            	$('.alert-show').show().delay(2000).fadeOut();            	
            }
            else{              	
            	$("#AddHSN_Code").val(ui.item.hsn);
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});
function openExpense(){
showLoader();
	$("#AddNewExpense").trigger('reset');
	
	var id = $(".expense").attr('data-related'); 
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });	
	    hideLoader();
}
function openContactBox(contkey){
	showLoader();
	$("#AddContactKeyId").val(contkey);	
	$('#FormContactBox').trigger("reset");
	var id = $(".addnew1").attr('data-related'); 
	$(id).hide();
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });	
	    hideLoader();
}  

function getCompanyAddress(){
	var compaddress=document.getElementById("EditTaskCompAddress").value.trim();
	document.getElementById("EnqCompAddress").value=compaddress;
}

function validateContact(){

	if(document.getElementById("ContactFirstName").value.trim()==""){
		document.getElementById('errorMsg').innerHTML ="First name is mandatory.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(document.getElementById("ContactLastName").value.trim()==""){
		document.getElementById('errorMsg').innerHTML ="Last name is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(document.getElementById("ContactEmail_Id").value.trim()==""){
		document.getElementById('errorMsg').innerHTML ="Email is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(document.getElementById("ContactEmailId2").value.trim()==""){
		document.getElementById("ContactEmailId2").value="NA";
	}
	if(document.getElementById("ContactPan").value.trim()==""){
		document.getElementById("ContactPan").value="NA";
	}
	if(document.getElementById("ContactWorkPhone").value.trim()==""){
		document.getElementById('errorMsg').innerHTML ="Work phone is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(document.getElementById("ContactMobilePhone").value.trim()==""){
		document.getElementById("ContactMobilePhone").value="NA";
	}
	
	if($('#ContactperAddress').prop('checked')){
		if(document.getElementById("ContCountry").value.trim()==""){
			document.getElementById('errorMsg').innerHTML ="Country is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if(document.getElementById("ContState").value.trim()==""){
			document.getElementById('errorMsg').innerHTML ="State is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if(document.getElementById("ContCity").value.trim()==""){
			document.getElementById('errorMsg').innerHTML ="City is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}		
		if(document.getElementById("ContAddress").value.trim()==""){
			document.getElementById('errorMsg').innerHTML ="Address is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
	}
	var firstname=document.getElementById("ContactFirstName").value.trim();
	var lastname=document.getElementById("ContactLastName").value.trim();
	var email=document.getElementById("ContactEmail_Id").value.trim();
	var email2=document.getElementById("ContactEmailId2").value.trim();
	var workphone=document.getElementById("ContactWorkPhone").value.trim();
	var mobile=document.getElementById("ContactMobilePhone").value.trim();
	var contactkey=document.getElementById("AddContactKeyId").value.trim();
	var pan=$("#ContactPan").val().trim();
	var country="NA";
    var city="NA";
    var state="NA";
    var address="NA";
    var companyaddress="NA";
    var addresstype="Personal";
    if($('#ContactperAddress').prop('checked')){
    	country=document.getElementById("ContCountry").value.trim();
    	var x=country.split("#");
    	country=x[1];
    	state=document.getElementById("ContState").value.trim();
    	x=state.split("#");
    	state=x[2];
    	
    	city=document.getElementById("ContCity").value.trim();    	
    	address=document.getElementById("ContAddress").value.trim();    	
    }
    if($('#ContactcomAddress').prop('checked')){
		companyaddress=document.getElementById("EnqCompAddress").value.trim();
		addresstype="Company";
    }
    var compname="<%=companyname%>";
    var salesKey="<%=salesrefid%>";
    var key=getKey(40);
    var CompanyRefId="<%=clientKey%>";
    showLoader();
    $("#ValidateAddContact").attr("disabled","disabled"); 
	$.ajax({
		type : "POST",
		url : "RegisterNewSalesContact777",
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
			compname : compname,
			addresstype : addresstype,
			key : key,
			contactkey : contactkey,
			CompanyRefId : CompanyRefId,
			salesKey : salesKey,
			pan : pan,
			country : country
		},
		success : function(data){
			$("#ValidateAddContact").removeAttr("disabled");
			if(data=="pass"){
				document.getElementById('errorMsg1').innerHTML = 'Successfully Contact Added !!';				
				 $('#FormContactBox').trigger("reset");
				$('.fixed_right_box').removeClass('active');			
				$("#RefreshContacts").load(location.href + " #RefreshContacts1");				
				$('.alert-show1').show().delay(4000).fadeOut();								
			}else if(data=="invalid"){
				document.getElementById('errorMsg').innerHTML = 'Please enter a valid email !! !!';
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

function openToolTipBox(task){
	$("#TaskMilestoneName").html(task);
	var id = $(".tooltips").attr('data-related'); 
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });	
}

function openDocumentBox(){
	var id = $(".adddoc").attr('data-related'); 
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });	
}

function openChatBox(){
	var user="<%=loginUserName%>";
	var sendTo="<%=projectNo%>";
<%-- 	var salesKey="<%=salesrefid%>"; --%>
// 	$('#ActiveEmployeeSalesKey').val(salesKey)
	user+="-"+sendTo;
	init(user,sendTo);
	$('#ChatTextareaBoxReply+.cke_editor_ChatTextareaBoxReply .cke_top').toggleClass('DispNone');
	var id = $(".openChat").attr('data-related'); 
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });	
	    $(".cmhistscroll").scrollTop($(".cmhistscroll")[0].scrollHeight);
}
function validateInternalNotes(){
	var boxContent=CKEDITOR.instances.ChatTextareaBoxReply1.getData();
	if(boxContent==null||boxContent==""){
		document.getElementById('errorMsg').innerHTML ="Please write internal notes in few word !!";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	
	var salesKey="<%=salesrefid%>";
	showLoader();
	$.ajax({
		type : "POST",
		url : "<%=request.getContextPath()%>/SubmitInterNotes111",
		dataType : "HTML",
		data : {				
			salesKey : salesKey,
			boxContent : boxContent
		},
		success : function(data){
			if(data=="pass"){	
				CKEDITOR.instances.ChatTextareaBoxReply1.setData('');
				$("#TaskChatInternalHistroy").load(location.href + " #TaskChatInternalHistroy1");					
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function() {
            hideLoader();
        }
	});
	
}

function validateChatReply(submitStatus){
var chatText=CKEDITOR.instances.ChatTextareaBoxReply.getData();
	
	if(chatText==null||chatText==""){
		document.getElementById('errorMsg').innerHTML ="Please write some text here !!";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	var milestone=$("#ChatReplyBoxTaskId").val();
	if(milestone==null||milestone==""){
		document.getElementById('errorMsg').innerHTML ="Please select milestone !!";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	} 
	if(submitStatus=="On-hold"){
		$("#holdWarning").modal("show");
	}else{
		submitChatReply(submitStatus,"NA","NA");	
	}
}
function validateHoldReply(submitStatus){
	var type=$("#holdChatType").val();
	var reason=$("#holdReason").val();
	if(type==null||type==""){
		document.getElementById('errorMsg').innerHTML ="Please select type !!";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(type==null||type==""){
		document.getElementById('errorMsg').innerHTML ="Please enter reason !!";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	submitChatReply(submitStatus,type,reason);
}
function submitChatReply(submitStatus,type,reason){
	var chatText=CKEDITOR.instances.ChatTextareaBoxReply.getData();
	var milestone=$("#ChatReplyBoxTaskId").val();
	
	$("#BoxContent").val(chatText);
	$("#SubmitStatus").val(submitStatus);
	
	$("#MilestoneDataBoxId").val(milestone);
	
	var deliveryDate=$("#MilestonePrevDeliveryDate").val();
	var newDeliveryDate=$("#SetDeliveryDateId").val();
	
	if (typeof newDeliveryDate === "undefined") {
		newDeliveryDate=deliveryDate;
	}
		
	var smsPhone=$("#SMS_Mobile").val();
	if(smsPhone==null||smsPhone=="")smsPhone="NA";
	var smsDescription=CKEDITOR.instances['SMS_Description'].getData();
	if(smsDescription==null||smsDescription==""){smsPhone="NA";smsDescription="NA";};
		
	var emailTo=$("#Email_To").val();
	if(emailTo==null||emailTo=="")emailTo="NA";
	var emailSubject=$("#Email_Subject").val();
	if(emailSubject==null||emailSubject=="")emailSubject="Notification";
	var emailDescription=CKEDITOR.instances['Email_Description'].getData();
	if(emailDescription==null||emailDescription==""){emailDescription="NA";emailTo="NA"};
	
	var extendComment=$("#date_extend_comment").val();
	if(extendComment==""||extendComment==null)extendComment="NA";
	
	var formName=$("#DynamicFormName").val();
	if(formName=="")formName="NA";
	var form = $(".PublicChatReply")[0]; 
    var data = new FormData(form);
    if(formDataJson=="")formDataJson="NA";
    data.append("formDataJson", formDataJson);
    data.append("deliveryDate", deliveryDate);
    data.append("newDeliveryDate", newDeliveryDate);
    data.append("dynamicFormDataName", formName);
    data.append("milestoneDataBox", milestone);
    data.append("type", type);
    data.append("reason", reason);
    data.append("extendComment",extendComment);
    showLoader();
	$.ajax({
        type : "POST",
        encType : "multipart/form-data",
        url : "<%=request.getContextPath()%>/SubmitPublicReply111",
        cache : false,
        processData : false,
        contentType : false,
        data : data,
        success : function(msg) {        	
        	var data=msg.split("#");
        	if(data[0]=="pass"){
        		document.getElementById('errorMsg1').innerHTML ="Successfully Submitted !!";
        		if(submitStatus=="On-hold"){
        			$("#holdWarning").modal("hide");
        		}
        		$(".homeNotification").hide();
        		var chatText=CKEDITOR.instances.ChatTextareaBoxReply.setData('');
        		$("#PublicChatReplyFormId").trigger("reset");
        		$("#SetDeliveryDateId").val(newDeliveryDate);
        		$("#SetDeliveryDateId")[0].min=newDeliveryDate;
        		
        		var docpath=data[1];
        		var docsize=data[2];
        		var docextension=data[3];
        		var docname=data[4];
        		var dformkey=data[5];
        		var sendTo="<%=projectNo%>";
        		var content=$("#BoxContent").val();
        		sendMessage(content,sendTo,"user","NA",docpath,docsize,docextension,docname,dformkey,formName);        		
        		 $(".cmhistscroll").scrollTop($(".cmhistscroll")[0].scrollHeight);
//         		$("#TaskChatHistroy").load(location.href + " #TaskChatHistroy1");	
//         		sendSMSEmail(smsPhone,smsDescription,emailTo,emailSubject,emailDescription);
	    		$('.alert-show1').show().delay(3000).fadeOut();
	    		
    		}else{
    			document.getElementById('errorMsg').innerHTML ="Something Went wrong ,try-again later !!";
	    		$('.alert-show').show().delay(3000).fadeOut();
    		}
        },
        error : function(msg) {
            alert("Couldn't upload file");
        },
        complete : function() {
            hideLoader();
        }
    });
}

function sendSMSEmail(smsPhone,smsDescription,emailTo,emailSubject,emailDescription){
	showLoader(); 
	$.ajax({
		    type: "POST",
		    url: "<%=request.getContextPath()%>/SendSmsEmailNotification111",
		    data:  { 		    	
		    	smsPhone : smsPhone,
		    	smsDescription : smsDescription,
		    	emailTo : emailTo,
		    	emailSubject : emailSubject,
		    	emailDescription : emailDescription
		    },
		    success: function (response) {       	  
	        },
	        complete : function() {
	            hideLoader();
	        }
		});
}
function fileSize(fileId){
	const fi=document.getElementById(fileId);
	if (fi.files.length > 0) {
		const fsize = fi.files.item(0).size; 
        const file = Math.round((fsize / 1024)); 
        // The size of the file. 
        if (file >= 49152) {  
            document.getElementById('errorMsg').innerHTML ='File too Big, Max File Size 48 MB !!';
            document.getElementById(fileId).value="";
 		    $('.alert-show').show().delay(4000).fadeOut();
        }		
	}	
}
function clearSession(data){
	   $.ajax({
		    type: "POST",
		    url: "<%=request.getContextPath()%>/ClearSessionData111",
		    data:  { 		    	
		    	data : data
		    },
		    success: function (response) {       	  
	        }
		});
}
</script>
<script type="text/javascript">
function setDynamicForm(templateKey){
	if(templateKey==null||templateKey==""){
		$("#clear-all-fields").click();
	}else{
		$("#clear-all-fields").click();
		setTimeout(() => {
			$("#Set-dynamic-form-template").click()
		}, 400);		
	}
}

jQuery(function($) {
	  var fbEditor = document.getElementById('build-wrap');
	  var formBuilder = $(fbEditor).formBuilder();
	  document.getElementById('getJSON').addEventListener('click', function() {
		  formDataJson=formBuilder.actions.getData('json',true);
		  var formName=$("#DynamicFormName").val();
		  
		 if(formDataJson=="[]"){
			  document.getElementById('errorMsg').innerHTML ="Please create form design !!.";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
		  }else if(formName==null||formName==""){
			  document.getElementById('errorMsg').innerHTML ="Please enter form name !!.";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
		  }else{			    
		    formBuilder.actions.clearFields();			    
		   	$("#DynamicFormModal").modal("hide");
		  }
	  });
	  
		$('.setData').click(function() {
			setTimeout(() => {					
			var fKey=$("#ProjectFollowUpKey").val();
			showLoader();
			$.ajax({
				type : "POST",
				url : "GetDynamicFormData111",
				dataType : "HTML",
				data : {				
					fKey : fKey,			
				},
				success : function(response){
					if(Object.keys(response).length!=0){
						response=JSON.parse(response);
					var formData=response[0]["formData"];
					
					formBuilder.actions.setData(formData);
				    $("#DynamicFormModal").modal("show");			
				}},
				complete : function() {
		            hideLoader();
		        }
			});	    
			}, 200);
		});
		
		document.getElementById('clear-all-fields').onclick = function() {
		    formBuilder.actions.clearFields();
		};
		document.getElementById('Set-dynamic-form-template').onclick = function() {
		    var templateKey=$("#DynamicFormTemplate").val();
		    showLoader();
		    $.ajax({
				type : "POST",
				url : "GetDynamicFormTemplate111",
				dataType : "HTML",
				data : {				
					templateKey : templateKey,			
				},
				success : function(response){
					if(Object.keys(response).length!=0){
						response=JSON.parse(response);
					var formTemplate=response[0]["formTemplate"];						
					formBuilder.actions.setData(formTemplate);		
				}},
				complete : function() {
		            hideLoader();
		        }
			});	
		};
	});
</script>
<script type="text/javascript">
$(document).ready(function() {
    $(".select2").select2({
        dropdownParent: $("#DynamicFormModal .modal-content")
     });    
    
    let reupload="<%=reupload%>";
    if(reupload!=null&&reupload=="done"){
    	openDocumentBox();
    	openDocument(event, 'ClientUploadDoc');
    	$(".tab").children('.tablinks').first().next().addClass("active");
    }
});
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
	    	location.reload(true);
        },
        complete : function() {
            hideLoader();
        }
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
	        complete : function() {
	            hideLoader();
	        }
		});
	}
}

$(document).ready(function () {
    $('.doticon').click(function (e) {
        $('.mobiledropdown ').stop(true).slideToggle();
    });
    $(document).click(function (e) {
        if (!$(e.target).closest('.doticon, .mobiledropdown ').length) {
            $('.mobiledropdown ').stop(true).slideUp();
        }
    });
});
function transferRetrieve(taskKey,status){
	if(taskKey!="NA"){
		$("#TransferKeyModal").val(taskKey);
		$("#TransferKeyStatusModal").val(status);
		if(status=="1")
			$("#transferRetrieveHead").html("&nbsp;&nbsp;Do you want to transfer back this milestone ?");
		else $("#transferRetrieveHead").html("&nbsp;&nbsp;Do you want to transfer this milestone ?");
		
		$("#warningtransferRetrieve").modal("show");
	}else{
		var taskKey=$("#TransferKeyModal").val();
		var status=$("#TransferKeyStatusModal").val();
		var salesKey="<%=salesrefid%>";
		var clientKey="<%=clientKey%>";
		var taskName="<%=milestoneName%>";
		showLoader();
		$.ajax({
		    type: "POST",
		    url: "<%=request.getContextPath()%>/TransferRetrieve111",
		    data:  { 
		    	taskKey : taskKey,
		    	status : status,
		    	salesKey : salesKey,
		    	clientKey : clientKey,
		    	taskName : taskName
		    },
		    success: function (response) {
		    	if(response=="pass"){
		    		location.reload();
		    	}
	        },
	        complete : function(){
	        	hideLoader();
	        }
		});
	}
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
		complete : function() {
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
		complete : function() {
            hideLoader();
        }
	});
}
function isExistPan(valueid){
	var val=document.getElementById(valueid).value.trim();
	if(val!=""&&val!="NA"){
	$.ajax({
		type : "POST",
		url : "ExistValue111",
		dataType : "HTML",
		data : {"val":val,"field":"isPan"},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg").innerHTML=val +" is already existed.";
			document.getElementById(valueid).value="";
			$('.alert-show').show().delay(4000).fadeOut();
			}
			
		},
		complete : function() {
            hideLoader();
        }
	});}
}
function isExistEditPan(valueid){
	var val=document.getElementById(valueid).value.trim();
	var key=$("#UpdateContactKey").val().trim();
	if(val!=""&&val!="NA"&&key!=""&&key!="NA"){
		showLoader();
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
			
		},
		complete : function() {
            hideLoader();
        }
	});}
}
function saveNotesReply(data,uaid){
	if(data=="NA"){
		var comment=$("#notes_reply").val();		
	if(comment==null||comment==""){
		document.getElementById('errorMsg').innerHTML ="Please enter comment !!.";
		$('.alert-show').show().delay(2000).fadeOut();
		return false;
	}	
	var salesKey="<%=salesrefid%>";
	var contactKey="<%=contactefid%>";
	var uaid=$("#replyNotesAddedByUid").val();
	showLoader();
	$.ajax({
		type : "POST",
		url : "ReplyNotesWritten111",
		dataType : "HTML",
		data : {	
			salesKey : salesKey,
			contactKey : contactKey,
			comment : comment,
			uaid : uaid
		},
		success : function(data){
			if(data=="pass"){	
				$("#replyNotesWritten").modal("hide");
				$("#ReloadReminder").load(location.href + " #ReloadReminder1");	
				$("#ReloadTaskThread").load(location.href + " #ReloadTaskThread1");
			}else{
				document.getElementById('errorMsg').innerHTML ="Something went wrong !! Please Try-again later !!";
				$('.alert-show').show().delay(3000).fadeOut();
			}			
		},
		complete : function() {
            hideLoader();
        }
	});
	}else{
		$("#replyNotesWritten").modal("show");
		$("#replyNotesAddedByUid").val(uaid);
	}
}
function sendDocumentEmail(dockey){
	if(dockey=="NA"){
		var docKey=$("#sendDocumentClientKey").val();
		var salesKey="<%=salesrefid%>";
		var name="<%=contactName%>";
		var email="<%=contactEmail%>";
		showLoader();
		$.ajax({
			type : "POST",
			url : "ShareDocumentToClient111",
			dataType : "HTML",
			data : {	
				salesKey : salesKey,
				name : name,
				email : email,
				docKey : docKey
			},
			success : function(data){
				$("#documentSendWarning").modal("hide");
				if(data=="pass"){	
					document.getElementById('errorMsg1').innerHTML ="Successfully Shared !!";
					$('.alert-show1').show().delay(3000).fadeOut();
				}else{
					document.getElementById('errorMsg').innerHTML ="Something went wrong !! Please Try-again later !!";
					$('.alert-show').show().delay(3000).fadeOut();
				}			
			},
			complete : function() {
	            hideLoader();
	        }
		});
	}else{
		$("#sendDocumentClientKey").val(dockey);
		$("#documentSendWarning").modal("show");
	}
} 
function dateExtendRecord(deliveryDate){
	if(deliveryDate=="NA"){
		var comment=$("#date_extend_comment").val();
		if(comment==null||comment==""){
			document.getElementById('errorMsg').innerHTML ="Please enter comment !!";
			$('.alert-show').show().delay(3000).fadeOut();
			return false;
		}
		$("#dateExtendRecord").modal("hide");
	}else{
		$("#deliveryDateTime").val(deliveryDate);
		$("#dateExtendRecord").modal("show");
	}	
}
function setOldDate(){
	var deliveryDate=$("#deliveryDateTime").val();
	$("#SetDeliveryDateId").val(deliveryDate);
	$("#SetDeliveryDateId")[0].min=deliveryDate;
}
function reUploadRequest(docKey,salesKey){
	showLoader();
	$.ajax({
		type : "POST",
		url : "ReUploadDocument111",
		dataType : "HTML",
		data : {	
			docKey : docKey,
			salesKey : salesKey,
			location : window.location.pathname
		},
		success : function(data){
			if(data=="pass"){	
				document.getElementById('errorMsg1').innerHTML ="Re-Upload document request sent !!";
				$('.alert-show1').show().delay(3000).fadeOut();
			}else{
				document.getElementById('errorMsg').innerHTML ="Something went wrong !! Please Try-again later !!";
				$('.alert-show').show().delay(3000).fadeOut();
			}			
		},
		complete : function() {
            hideLoader();
        }
	});
}
function loadServiceDetails(salesKey){
	var skey=$("#serviceDetailsModelKey").val();
	if(skey==salesKey){
		$("#serviceDetails").modal("show");
	}else{	
		showLoader();
		$.ajax({
			type : "GET",
			url : "GetServiceDetails111",
			dataType : "HTML",
			data : {	
				salesKey : salesKey
			},
			success : function(data){
				$("#serviceDetailsModelKey").val(salesKey);
				$("#serviceDetails").modal("show");
				$("#serviceRemark").html(data);
			},
			complete : function() {
	            hideLoader();
	        }
		});
	}
}

function copyToClipboard(element) {
    var textField = document.createElement('textarea');
    textField.innerText = $('#'+element).html();
    document.body.appendChild(textField);
    textField.select();
    textField.focus();
    document.execCommand('copy');
    textField.remove();
    $('.'+element).css('color','blue');
}
</script>
</body>
</html>