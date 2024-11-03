<%@page import="java.util.Properties"%>
<%@page import="commons.CommonHelper"%>
<%@page import="admin.enquiry.Enquiry_ACT"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/> 
	<title>Manage template</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>	 
<%if(!MTT00){%><jsp:forward page="/login.html" /><%} 
String token = (String) session.getAttribute("uavalidtokenno");

String templateDateRangeAction=(String)session.getAttribute("templateDateRangeAction");
if(templateDateRangeAction==null||templateDateRangeAction.length()<=0)templateDateRangeAction="NA";

String templateNameAction=(String)session.getAttribute("templateNameAction");
if(templateNameAction==null||templateNameAction.length()<=0)templateNameAction="NA";

String templateDoAction=(String)session.getAttribute("templateDoAction");
if(templateDoAction==null||templateDoAction.length()<=0)templateDoAction="All";

int totalTemplate=TaskMaster_ACT.getTotalTemplates(templateNameAction,templateDoAction,templateDateRangeAction,token);
long formTemplate=TaskMaster_ACT.getTotalFormTemplates(templateNameAction,templateDoAction,templateDateRangeAction,token);
long smsTemplate=TaskMaster_ACT.getTotalSmsTemplates(templateNameAction,templateDoAction,templateDateRangeAction,token);
long emailTemplate=TaskMaster_ACT.getTotalEmailTemplates(templateNameAction,templateDoAction,templateDateRangeAction,token);

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
String sort_url=domain+"manage-template.html?page="+pageNo+"&rows="+rows;

//pagination end
%>
	<div id="content">		
		<div class="main-content">
			<div class="container">				
				<div class="box_shadow1 invoice_info redius_box pad_box4 bg_wht mb30">
                        <div class="clearfix dashboard_info">
                          <div class="pad0 col-md-3 col-sm-3 col-xs-6">
                          <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:100px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div>
						   <div class="clearfix mlft20">
                            <h3><i class="fas fa-signal"></i> <%=CommonHelper.formatValue(totalTemplate) %></h3>
							<span>Total</span>
						   </div>
                          </div>
                          <div class="pad0 bdr_left col-md-3 col-sm-3 col-xs-6">
                          <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:100px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div>
						   <div class="clearfix mlft20">
                            <h3><i class="fab fa-wpforms"></i> <%=CommonHelper.formatValue(formTemplate) %></h3>
							<span>Form</span>
                           </div>
						  </div>
                          <div class="pad0 bdr_left col-md-3 col-sm-3 col-xs-6">
                          <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:100px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div>
						   <div class="clearfix mlft20">
                            <h3><i class="fas fa-sms"></i> <%=CommonHelper.formatValue(smsTemplate) %></h3>
							<span>SMS</span>
                           </div>
						  </div>
                          <div class="pad0 bdr_left col-md-3 col-sm-3 col-xs-6">
                          <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:100px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div>
						   <div class="clearfix mlft20">
                            <h3><i class="fas fa-envelope"></i> <%=CommonHelper.formatValue(emailTemplate) %></h3>
							<span>Email</span>
                           </div>
						  </div>
                        </div> 
				</div>
				
<div class="clearfix"> 
<form onsubmit="return false;">
<div class="bg_wht home-search-form clearfix mb10" id="SearchOptions">  
<div class="row">
<div class="post" style="position:absolute;z-index:9">
                        <div class="linee" style="margin-top: -1px;width:1350px;height:50px"></div>
                            </div>
<div class="col-md-6 col-sm-6 col-xs-9 row"> 
<div class="col-md-3 col-sm-4 dropdown">
<button type="button" class="filtermenu dropbtn fas fa-plus" style="padding: 0 20px;">&nbsp;&nbsp;New</button>
<div class="dropdown-content" style="border-radius: 3px;margin-left: 0;">   
    <a class="clickeble" id="OpenAddForm">+ Dynamic form</a>
    <a class="clickeble" data-toggle="modal" data-target="#newSMSTemplate">+ SMS Template</a>
    <a class="clickeble" data-toggle="modal" data-target="#newEmailTemplate">+ Email Template</a>    
 </div>
 </div>
 <div class="col-md-9">
<ul class="clearfix filter_menu">
<li <%if(templateDoAction.equalsIgnoreCase("All")){ %>class="active"<%} %>><a onclick="doAction('All','templateDoAction');location.reload();">All</a></li>  
<li <%if(templateDoAction.equalsIgnoreCase("form")){ %>class="active"<%} %>><a onclick="doAction('form','templateDoAction');location.reload();">Form</a></li>
<li <%if(templateDoAction.equalsIgnoreCase("sms")){ %>class="active"<%} %>><a onclick="doAction('sms','templateDoAction');location.reload();">SMS</a></li>
<li <%if(templateDoAction.equalsIgnoreCase("email")){ %>class="active"<%} %>><a onclick="doAction('email','templateDoAction');location.reload();">Email</a></li>
</ul>
</div>
</div>
<a href="javascript:void(0)" class="doticon"> <i class="fa fa-filter" aria-hidden="true"></i>Filter</a>
<div class="filtermmenu">
<div class="col-md-6 col-sm-6 col-xs-12">
<div class="clearfix flex_box justify_end">  
<div class="item-bestsell col-md-5 col-sm-6 col-xs-12">
<p><input type="search" name="templatename" id="TemplateName" autocomplete="off" <% if(!templateNameAction.equalsIgnoreCase("NA")){ %>onsearch="clearSession('templateNameAction');location.reload();" value="<%=templateNameAction%>"<%} %> placeholder="Template name...." class="form-control"/>
</p>
</div>
<div class="item-bestsell col-md-5 col-sm-6 col-xs-12 has-clear"> 
<p><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="FROM - TO" class="form-control text-center date_range pointers <%if(!templateDateRangeAction.equalsIgnoreCase("NA")){%>selected<%} %>" readonly="readonly"/>
<span class="form-control-clear form-control-feedback" onclick="clearSession('templateDateRangeAction');location.reload();"></span>
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
                        <table  class="ctable">
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
						            <th width="150" class="sorting <%if(sort.equals("date")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','date','<%=order%>')">Date</th>
						            <th class="sorting <%if(sort.equals("name")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','name','<%=order%>')">Template name</th>
						            <th width="200">Action</th>
						        </tr>
						    </thead>
						    <tbody>
						    <%
						    int ssn=0;  
						    int startRange=pageNo-2;
						    int endRange=pageNo+2;
						    int totalPages=1;
						    int showing=0;
						    String[][] template=TaskMaster_ACT.getAllTemplates(templateNameAction,templateDoAction,templateDateRangeAction,token,pageNo,rows,sort,order);
                            
						    if(template!=null&&template.length>0){
                            	ssn=rows*(pageNo-1);
                            	showing=ssn+1;
                          	  totalPages=(totalTemplate/rows);
                          	if((totalTemplate%rows)!=0)totalPages+=1;
                          	  if (totalPages > 1) {     	 
                          		  if((endRange-2)==totalPages)startRange=pageNo-4;        
                                    if(startRange==pageNo)endRange=pageNo+4;
                                    if(startRange<1) {startRange=1;endRange=startRange+4;}
                                    if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
                                    if(startRange<1)startRange=1;
                               }else{startRange=0;endRange=0;}
                             for(int i=0;i<template.length;i++) { 
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
						            <td><%=template[i][1] %></td>
						            <td><%=template[i][2] %></td>
						            <td>
						            <%if(template[i][3].equalsIgnoreCase("form")){ %>
						            <a href="#" onclick="editDynamicTemplate('<%=template[i][0] %>','<%=template[i][2] %>')"><i class="fas fa-edit"></i>Edit</a>&nbsp;|&nbsp;
						            <%}else if(template[i][3].equalsIgnoreCase("sms")){%>
						            <a href="#" onclick="editSmsEmailTemplate('<%=template[i][0] %>','<%=template[i][2] %>','<%=template[i][4] %>','sms')"><i class="fas fa-edit"></i>&nbsp;Edit</a>&nbsp;|&nbsp;
						            <%}else if(template[i][3].equalsIgnoreCase("email")){ %>
						            <a href="#" onclick="editSmsEmailTemplate('<%=template[i][0] %>','<%=template[i][2] %>','<%=template[i][4] %>','email')"><i class="fas fa-edit"></i>&nbsp;Edit</a>&nbsp;|&nbsp;
						            <%} %>
						            <a href="#" onclick="warningDeleteTemplate('<%=template[i][0] %>')"><i class="fas fa-trash"></i>&nbsp;Delete</a>
						            </td>						
						        </tr>
						     <%}}%>
                                 
						    </tbody>
						</table>
						</div>
						<div class="filtertable">
						  <span>Showing <%=showing %> to <%=ssn+template.length %> of <%=totalTemplate %> entries</span>
						  <div class="pagination">
						    <ul> <%if(pageNo>1){ %>
						      <li class="page-item">	                     
						      <a class="page-link text-primary" href="<%=request.getContextPath()%>/manage-template.html?page=1&rows=<%=rows%>">First</a>
						   </li><%} %>
						    <li class="page-item">					      
						      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/manage-template.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
						    </li>  
						      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
							    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
							    <a class="page-link" href="<%=request.getContextPath()%>/manage-template.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
							    </li>   
							  <%} %>
							   <li class="page-item">						      
							      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/manage-template.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
							   </li><%if(pageNo<=(totalPages-1)){ %>
							   <li class="page-item">
							      <a class="page-link text-primary" href="<%=request.getContextPath()%>/manage-template.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
							   </li><%} %>
							</ul>
							</div>
							<select class="select2" onchange="changeRows(this.value,'manage-template.html?page=1','<%=domain%>')">
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
<div class="modal fade" id="warningDeleteTemplate" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title fas fa-exclamation-triangle text-danger" id="exampleModalLabel" style="padding-bottom: 6px;">&nbsp;&nbsp;Do you really want to delete this template ?</h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>   
      <input type="hidden" id="deleteTemplateId" value="NA">
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="deleteTemplate();">Yes</button>
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
      <div class="col-md-7">
      <div class="row">
      <div class="col-md-4 box-width32" style="margin-top: 7px;">
      <label class="floatLeft">Template Name : <sup class="text-danger">*</sup></label>
      </div>
      <div class="col-md-8">
      <input type="text" class="form-control" autocomplete="off" onchange="isTemplateNameExist('DynamicFormName','DynamicFormTemplate')" name="dynamicFormName" id="DynamicFormName" placeholder="Dynamic form name...">      
      <input type="text" class="form-control" autocomplete="off" onchange="isTemplateExist('NewDynamicFormName')" name="newdynamicFormName" id="NewDynamicFormName" placeholder="Dynamic form name...">
      </div>
      </div>
      </div>
      <div class="col-md-5">   
        <button type="button" class="btn btn-secondary" data-dismiss="modal" id="onclearall">Close</button>
        <button type="button" class="btn btn-info" id="getJSON">Update</button>
        <button type="button" class="btn btn-info" id="getTemplateJSON">Save Template</button>
      </div>
      </div> 
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
            	<option value="tdate">Date</option>
            	<option value="tname">Template</option>
            </select>            
          </div>
         <div class="form-group">
            <label for="recipient-name" class="col-form-label">Formate :</label>
            <select class="form-control" name="file-formate" id="File-Formate">
            	<option value="csv">CSV</option>
            	<option value="xlsx" selected>XLS</option>
            </select>
          </div>   
          <div class="form-group DispNone">
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
<div class="myModal modal fade template" id="newSMSTemplate" aria-modal="false" style="padding-right: 17px; display: none;">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title"><i class="fas fa-sms font25" aria-hidden="true"></i>New SMS Template</h4>  
          <button type="button" class="closeBox" data-dismiss="modal"><span aria-hidden="true">&times;</span></button>
        </div>
        <form method="post" onsubmit="return false">
        <div class="modal-body">          
		  <div class="tab-content">		  
		  <div id="pay_method2">
		  <div class="row mb10">
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>Template name :</label>
            <input type="text" class="form-control" name="smstemplate_name" onchange="isTemplateExist('SMS_Template_Name')" id="SMS_Template_Name" placeholder="Template Name..." autocomplete="off">
            </div>
            </div> 
            <div class="row mb10">
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>Message</label>
            <textarea class="form-control" name="sms_description" id="SMS_Description" placeholder="Description..." autocomplete="off"></textarea>
            </div>
            </div>
          </div>
		  </div>  		  
        </div>
        <div class="modal-footer flex-end">
          <button type="button" class="btn btn-cancel bt-link bt-radius" data-dismiss="modal">Cancel</button> 
          <button type="submit" class="bt-link bt-radius bt-loadmore" onclick="return validateNewTemplate('sms')">Submit</button> 
        </div>
        </form>
      </div>
    </div>
  </div>
 <div class="myModal modal fade template" id="newEmailTemplate" aria-modal="false" style="padding-right: 17px; display: none;">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title"><i class="far fa-envelope" aria-hidden="true"></i>New Email Template</h4>  
          <button type="button" class="closeBox" data-dismiss="modal"><span aria-hidden="true">&times;</span></button>
        </div>
        <form method="post" onsubmit="return false">
        <div class="modal-body">          
		  <div class="tab-content">		  
		  <div id="pay_method2">
		  <div class="row mb10">
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>Template name :</label>
            <input type="text" class="form-control" name="emailtemplate_name" onchange="isTemplateExist('Email_Template_Name')" id="Email_Template_Name" placeholder="Template Name..." autocomplete="off">
            </div>
            </div> 
            <div class="row mb10">
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>Subject :</label>
            <input type="text" class="form-control" name="emailtemplate_subject" id="Email_Template_Subject" placeholder="Subject..." autocomplete="off">
            </div>
            </div> 
            <div class="row mb10">
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>Message</label>
            <textarea class="form-control" name="Email_description" id="Email_Description" placeholder="Description..." autocomplete="off"></textarea>
            </div>
            </div>
          </div>
		  </div>  		  
        </div>
         
        <div class="modal-footer flex-end">
          <button type="button" class="btn btn-cancel bt-link bt-radius" data-dismiss="modal">Cancel</button> 
          <button type="submit" class="bt-link bt-radius bt-loadmore" onclick="return validateNewTemplate('email')">Submit</button> 
        </div>
        </form>
      </div>
    </div>
  </div>
<div class="myModal modal fade template" id="editNewSMSTemplate" aria-modal="false" style="padding-right: 17px; display: none;">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title"><i class="fas fa-sms font25" aria-hidden="true"></i>Update SMS Template</h4>  
          <button type="button" class="closeBox" data-dismiss="modal"><span aria-hidden="true">&times;</span></button>
        </div>
        <form method="post" onsubmit="return false">
        <div class="modal-body">          
		  <div class="tab-content">		  
		  <div id="pay_method2">
		  <div class="row mb10">
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>Template name :</label>
            <input type="text" class="form-control" name="editsmstemplate_name" onchange="isTemplateNameExist('Edit_SMS_Template_Name','SmsEmailTemplateUpdateKey')" id="Edit_SMS_Template_Name" placeholder="Template Name..." autocomplete="off">
            </div>
            </div> 
            <div class="row mb10">
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>Message</label>
            <textarea class="form-control" name="editsms_description" id="Edit_SMS_Description" placeholder="Description..." autocomplete="off"></textarea>
            </div>
            </div>
          </div>
		  </div>  		  
        </div>
        <div class="modal-footer flex-end">
          <button type="button" class="btn btn-cancel bt-link bt-radius" data-dismiss="modal">Cancel</button> 
          <button type="submit" class="bt-link bt-radius bt-loadmore" onclick="return validateUpdateTemplate('sms')">Update</button> 
        </div>
        </form>
      </div>
    </div>
  </div> 
 <div class="myModal modal fade template" id="editNewEmailTemplate" aria-modal="false" style="padding-right: 17px; display: none;">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title"><i class="far fa-envelope" aria-hidden="true"></i>Update Email Template</h4>  
          <button type="button" class="closeBox" data-dismiss="modal"><span aria-hidden="true">&times;</span></button>
        </div>
        <form method="post" onsubmit="return false">
        <div class="modal-body">          
		  <div class="tab-content">		  
		  <div id="pay_method2">
		  <div class="row mb10">
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>Template name :</label>
            <input type="text" class="form-control" name="editemailtemplate_name" onchange="isTemplateNameExist('Edit_Email_Template_Name','SmsEmailTemplateUpdateKey')" id="Edit_Email_Template_Name" placeholder="Template Name..." autocomplete="off">
            </div>
            </div> 
            <div class="row mb10">
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>Subject :</label>
            <input type="text" class="form-control" name="editemailtemplate_subject" id="Edit_Email_Template_Subject" placeholder="Subject..." autocomplete="off">
            </div>
            </div> 
            <div class="row mb10">
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>Message</label>
            <textarea class="form-control" name="editEmail_description" id="Edit_Email_Description" placeholder="Description..." autocomplete="off"></textarea>
            </div>
            </div>
          </div>
		  </div>  		  
        </div>
        <div class="modal-footer flex-end">
          <button type="button" class="btn btn-cancel bt-link bt-radius" data-dismiss="modal">Cancel</button> 
          <button type="submit" class="bt-link bt-radius bt-loadmore" onclick="return validateUpdateTemplate('email')">Update</button> 
        </div>
        </form>
      </div>
    </div>
  </div>
<input type="hidden" id="SmsEmailTemplateUpdateKey" value="NA">
<button type="button" id="clear-all-fields" class="DispNone"></button>
<button type="button" id="Set-dynamic-form-template" class="DispNone"></button>
<input type="hidden" id="DynamicFormTemplate" value="NA">
	<p id="end" style="display:none;"></p>
	</div>
	<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>	
<div class="noDisplay"><a href="" id="DownloadExportedLink" download><button id="DownloadExported">Download</button></a></div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/formBuilder/js/form-builder.min.js"></script>
<script type="text/javascript">
$( document ).ready(function() {	 
	   CKEDITOR.replace('SMS_Description');
	   CKEDITOR.replace('Email_Description');
	   CKEDITOR.replace('Edit_Email_Description');
	   CKEDITOR.replace('Edit_SMS_Description');
	   var dateRangeDoAction="<%=templateDateRangeAction%>";
	   if(dateRangeDoAction!="NA"){	  
		   $('input[name="date_range"]').val(dateRangeDoAction);
	   }
	});

function validateUpdateTemplate(type){
	var templateName="";
	var templateSubject="";
	var templateDescription="";
	var modalHide="editNewEmailTemplate";
	var templateKey=$("#SmsEmailTemplateUpdateKey").val();
	
	if(type=="sms"){ 
		modalHide="editNewSMSTemplate";
		templateName=$("#Edit_SMS_Template_Name").val();
		templateDescription=CKEDITOR.instances['Edit_SMS_Description'].getData();
		templateSubject="NA";		
	}else if(type=="email"){     
		templateName=$("#Edit_Email_Template_Name").val();
		templateDescription=CKEDITOR.instances['Edit_Email_Description'].getData();
		templateSubject=$("#Edit_Email_Template_Subject").val();
	}
	
	if(templateName==null||templateName==""){
		document.getElementById('errorMsg').innerHTML ="Please enter template name !! ";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(templateSubject==null||templateSubject==""){
		document.getElementById('errorMsg').innerHTML ="Please enter template subject !! ";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(templateDescription==null||templateDescription==""){
		document.getElementById('errorMsg').innerHTML ="Please enter template message !! ";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	
	//adding dynamic form data
	showLoader();
	 $.ajax({
			type : "POST",
			url : "UpdateSmsEmailTemplate111",
			dataType : "HTML",
			data : {		
				templateKey : templateKey,
				templateName : templateName,
				templateSubject : templateSubject,
				templateDescription : templateDescription
			},
			success : function(data){
				if(data=="pass"){
					$("#"+modalHide).modal("hide");
					document.getElementById('errorMsg1').innerHTML ="Template updated : "+templateName;
					setTimeout(() => {
						location.reload(true);
					}, 3000);
					$('.alert-show1').show().delay(3000).fadeOut();					
				}else{
					document.getElementById('errorMsg').innerHTML ="Something went wrong !! Please Try-again later !!";
					$('.alert-show').show().delay(3000).fadeOut();
				}			
			},
			complete : function(data){
				hideLoader();
			}
		});	
	
}	

function validateNewTemplate(type){
	var templateName="";
	var templateSubject="";
	var templateDescription="";
	var modalHide="newEmailTemplate";
	
	if(type=="sms"){
		modalHide="newSMSTemplate";
		templateName=$("#SMS_Template_Name").val();
		templateDescription=CKEDITOR.instances['SMS_Description'].getData();
		templateSubject="NA";		
	}else if(type=="email"){   
		templateName=$("#Email_Template_Name").val();
		templateDescription=CKEDITOR.instances['Email_Description'].getData();
		templateSubject=$("#Email_Template_Subject").val();
	}
	
	if(templateName==null||templateName==""){
		document.getElementById('errorMsg').innerHTML ="Please enter template name !! ";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(templateSubject==null||templateSubject==""){
		document.getElementById('errorMsg').innerHTML ="Please enter template subject !! ";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(templateDescription==null||templateDescription==""){
		document.getElementById('errorMsg').innerHTML ="Please enter template message !! ";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	
	//adding dynamic form data
	showLoader();
	 $.ajax({
			type : "POST",
			url : "SaveSmsEmailTemplate111",
			dataType : "HTML",
			data : {				
				templateName : templateName,
				templateSubject : templateSubject,
				templateDescription : templateDescription,
				type : type
			},
			success : function(data){
				if(data=="pass"){
					$("#"+modalHide).modal("hide");
					document.getElementById('errorMsg1').innerHTML ="Template added : "+templateName;
					setTimeout(() => {
						location.reload(true);
					}, 3000);
					$('.alert-show1').show().delay(3000).fadeOut();					
				}else{
					document.getElementById('errorMsg').innerHTML ="Something went wrong !! Please Try-again later !!";
					$('.alert-show').show().delay(3000).fadeOut();
				}			
			},
			complete : function(data){
				hideLoader();
			}
		});	
	
}	
function isTemplateExist(FormNameId){
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
		complete : function(data){
			hideLoader();
		}
	});
}	
function warningDeleteTemplate(templateKey){
	$("#deleteTemplateId").val(templateKey);
	$("#warningDeleteTemplate").modal("show");
}
function editSmsEmailTemplate(templateKey,templateName,subject,type){ 	    
	$("#SmsEmailTemplateUpdateKey").val(templateKey);
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
				var content=response[0]["formTemplate"];					
				
				if(type=="sms"){
					$("#Edit_SMS_Template_Name").val(templateName);
					CKEDITOR.instances['Edit_SMS_Description'].setData(content);
					$("#editNewSMSTemplate").modal("show");
				}else if(type=="email"){
					$("#Edit_Email_Template_Name").val(templateName);
					$("#Edit_Email_Template_Subject").val(subject);
					CKEDITOR.instances['Edit_Email_Description'].setData(content);
					$("#editNewEmailTemplate").modal("show");
				}	
				
			}},
			complete : function(data){
				hideLoader();
			}
		});	

}
function editDynamicTemplate(templateKey,templateName){	
	$("#DynamicFormTemplate").val(templateKey);	
	$("#DynamicFormName").val(templateName);		
	$("#DynamicFormName").show();
    $("#NewDynamicFormName").hide();
    $("#getJSON").show();
    $("#getTemplateJSON").hide();    
	$("#Set-dynamic-form-template").click();
	$("#DynamicFormModal").modal("show");
}
function isTemplateNameExist(FormNameId,templateKey){
	var formName=$("#"+FormNameId).val();
	templateKey=$("#"+templateKey).val();
	$.ajax({
		type : "POST",
		url : "IsEditformNameExists111",
		dataType : "HTML",
		data : {				
			formName : formName,
			templateKey : templateKey
		},
		success : function(data){
			if(data=="pass"){	
				document.getElementById('errorMsg').innerHTML ="Duplicate template name : "+formName;
				$("#"+FormNameId).val("");
				$('.alert-show').show().delay(4000).fadeOut();
			}
		}
	});
}
jQuery(function($) {
	  var fbEditor = document.getElementById('build-wrap');
	  var formBuilder = $(fbEditor).formBuilder();
	  document.getElementById('getJSON').addEventListener('click', function() {
		  var formDataJson=formBuilder.actions.getData('json',true);
		  var dynamicFormName=$("#DynamicFormName").val();
		  
		 if(formDataJson=="[]"){
			  document.getElementById('errorMsg').innerHTML ="Please create form design !!.";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
		  }else if(dynamicFormName==null||dynamicFormName==""){
			  document.getElementById('errorMsg').innerHTML ="Please enter form name !!.";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
		  }else{			    
		    formBuilder.actions.clearFields();			    
		   	$("#DynamicFormModal").modal("hide");
		  }
		 var templateKey=$("#DynamicFormTemplate").val();
		 //updating dynamic form data
		 showLoader();
		 $.ajax({
				type : "POST",
				url : "UpdateDynamicFormTemplate111",
				dataType : "HTML",
				data : {				
					dynamicFormName : dynamicFormName,
					formDataJson : formDataJson,
					templateKey : templateKey
				},
				success : function(data){
					if(data=="pass"){	
						document.getElementById('errorMsg1').innerHTML ="Template updated : "+dynamicFormName;
						setTimeout(() => {
							location.reload(true);
						}, 3000);
						$('.alert-show1').show().delay(3000).fadeOut();					
					}else{
						document.getElementById('errorMsg').innerHTML ="Something went wrong !! Please Try-again later !!";
						$('.alert-show').show().delay(3000).fadeOut();
					}			
				},
				complete : function(data){
					hideLoader();
				}
			});				 
	  });
	  document.getElementById('OpenAddForm').onclick = function() {
		  formBuilder.actions.clearFields();
		  $("#DynamicFormName").hide();
		  $("#NewDynamicFormName").show();
		  $("#getJSON").hide();
		  $("#getTemplateJSON").show();
		  $("#DynamicFormModal").modal("show");		    
		};
	  document.getElementById('getTemplateJSON').addEventListener('click', function() {
		  var formDataJson=formBuilder.actions.getData('json',true);
		  var dynamicFormName=$("#NewDynamicFormName").val();
		  
		 if(formDataJson=="[]"){
			  document.getElementById('errorMsg').innerHTML ="Please create form design !!.";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
		  }else if(dynamicFormName==null||dynamicFormName==""){
			  document.getElementById('errorMsg').innerHTML ="Please enter form name !!.";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
		  }else{			    
		   	$("#DynamicFormModal").modal("hide");
		  }
		 //adding dynamic form data
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
						document.getElementById('errorMsg1').innerHTML ="Template added : "+dynamicFormName;
						setTimeout(() => {
							location.reload(true);
						}, 3000);
						$('.alert-show1').show().delay(3000).fadeOut();					
					}else{
						document.getElementById('errorMsg').innerHTML ="Something went wrong !! Please Try-again later !!";
						$('.alert-show').show().delay(3000).fadeOut();
					}			
				},
				complete : function(data){
					hideLoader();
				}
			});				 
	  });
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
				complete : function(data){
					hideLoader();
				}
			});	
		};
	});
function deleteTemplate(){
	showLoader();
	var templateKey=$("#deleteTemplateId").val();
	var xhttp;
	xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
	if (this.readyState == 4 && this.status == 200) {
	$("#"+templateKey).remove();
	}
	};
	xhttp.open("POST", "<%=request.getContextPath()%>/DeleteTemplate111?templateKey="+templateKey, true);
	xhttp.send();
	hideLoader();
}
$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var data=$(this).val();
	doAction(data,"templateDateRangeAction");
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
	$("#TemplateName").autocomplete({
		source : function(request, response) {			
			if(document.getElementById('TemplateName').value.trim().length>=1)
			$.ajax({
				url : "getemplate.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					"field" : "<%=templateDoAction%>"
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
            	doAction(ui.item.value,'templateNameAction');
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
			type : "Template"
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