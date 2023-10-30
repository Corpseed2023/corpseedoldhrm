<%@page import="java.util.Properties"%>
<%@page import="commons.DateUtil"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/> 
	<title>Manage Contacts</title>
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

String contactDateRangeAction=(String)session.getAttribute("contactDateRangeAction");
if(contactDateRangeAction==null||contactDateRangeAction.length()<=0)contactDateRangeAction="NA";

String contactCompanyNameAction=(String)session.getAttribute("contactCompanyNameAction");
if(contactCompanyNameAction==null||contactCompanyNameAction.length()<=0)contactCompanyNameAction="NA";
//pagination start
int pageNo=1;
int rows=10;
String sort="";
String order=(String)session.getAttribute("mcosortby_ord");
if(order==null)order="desc";

String sorting_order=(String)session.getAttribute("mcosorting_order");
if(sorting_order==null)sorting_order="";

if(request.getParameter("page")!=null)pageNo=Integer.parseInt(request.getParameter("page"));
if(request.getParameter("rows")!=null)rows=Integer.parseInt(request.getParameter("rows"));

if(request.getParameter("sort")!=null)sort=request.getParameter("sort");
Properties properties = new Properties();
properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
String domain=properties.getProperty("domain");
String azure_path=properties.getProperty("azure_path");
String sort_url=domain+"managecontacts.html?page="+pageNo+"&rows="+rows;
String country[][]=TaskMaster_ACT.getAllCountries();

//pagination end
%>
<%if(!MCO0){%><jsp:forward page="/login.html" /><%} %>
	<div id="content">
		<div class="main-content">
			<div class="container">		
				
				
<div class="clearfix"> 
<form name="RefineSearchenqu" action="return false" method="Post">
<div class="bg_wht clearfix mb10" id="SearchOptions">  
<div class="row">
<div class="col-md-7 col-sm-7 col-xs-9"> 
<div class="row col-md-12 dropdown">
<button type="button" class="filtermenu addcontact" data-related="add_contact" onclick="openContactBox()">+&nbsp;New Contact</button>
</div>
</div>
<a href="javascript:void(0)" class="doticon"> <i class="fa fa-filter" aria-hidden="true"></i>Filter</a>
<div class="filtermmenu">
<div class="post" style="position:absolute;z-index:9">
                        <div class="linee" style="margin-top: -1px;width:1350px;height:50px"></div>
                            </div>
<div class="col-md-5 col-sm-5 col-xs-12">
<div class="clearfix">  
<div class="item-bestsell col-md-6 col-sm-1 col-xs-12">
<p><input type="search" name="clientname" id="ClientName" autocomplete="off" <%if(!contactCompanyNameAction.equalsIgnoreCase("NA")){ %>onsearch="clearSession('contactCompanyNameAction');location.reload();" value="<%=contactCompanyNameAction%>"<%} %>  placeholder="Search by company.." class="form-control"/></p>
</div> 
<div class="item-bestsell col-md-6 col-sm-1 col-xs-12 has-clear">
<p><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="FROM - TO" class="form-control text-center date_range pointers <%if(!contactDateRangeAction.equalsIgnoreCase("NA")){ %>selected<%} %>"  readonly="readonly"/>
<span class="form-control-clear form-control-feedback" onclick="clearSession('contactDateRangeAction');location.reload();"></span>
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
						            <th class="sorting <%if(sort.equals("status")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','status','<%=order%>','mcosorting_order','mcosortby_ord')">Status</th>
						            <th class="sorting <%if(sort.equals("name")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','name','<%=order%>','mcosorting_order','mcosortby_ord')">Contact Name</th>
						            <th class="sorting <%if(sort.equals("mobile")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','mobile','<%=order%>','mcosorting_order','mcosortby_ord')">Contact Mobile</th>
						            <th class="sorting <%if(sort.equals("email")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','email','<%=order%>','mcosorting_order','mcosortby_ord')">Contact Email</th>
						            <th class="sorting <%if(sort.equals("company")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','company','<%=order%>','mcosorting_order','mcosortby_ord')">Company Name</th>
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
						    String[][] contacts=TaskMaster_ACT.getAllContacts(contactCompanyNameAction,contactDateRangeAction,token,pageNo,rows,sort,order); 
                            int totalContact=TaskMaster_ACT.countAllContacts(contactCompanyNameAction,contactDateRangeAction,token);
						    if(contacts!=null&&contacts.length>0){
                            	 ssn=rows*(pageNo-1);
                           	  totalPages=(totalContact/rows);
                           	if((totalContact%rows)!=0)totalPages+=1;
                           	  showing=ssn+1;
                           	  if (totalPages > 1) {     	 
                           		  if((endRange-2)==totalPages)startRange=pageNo-4;        
                                     if(startRange==pageNo)endRange=pageNo+4;
                                     if(startRange<1) {startRange=1;endRange=startRange+4;}
                                     if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
                                     if(startRange<1)startRange=1;
                                }else{startRange=0;endRange=0;}
                             for(int i=0;i<contacts.length;i++) {     
                            	 String name=contacts[i][3]+"  "+contacts[i][4];
                            	 boolean flag=true;
                            	 String primaryStatus="S";
                            	 String  primaryclass="iconstatusn";
                            	 String primaryTitle="Secondary Contact";
                            	 boolean primary=true;
                            	 if(contacts[i][2]==null||contacts[i][2].equalsIgnoreCase("...."))flag=false;
                             	if(contacts[i][14].equalsIgnoreCase("1")){
                             		primaryStatus="P";
                             		primaryclass="iconstatusp";
                             		primaryTitle="Primary Contact";
                             		primary=false;
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
      <div class="line" style="position:relative;z-index:9"></div>
    </td>
   
  </tr>
                           
						        <tr>
						            <td><input type="checkbox" name="checkbox" id="checkbox" class="checked"></td>
						            <td><span class="<%=primaryclass%>" title="<%=primaryTitle%>"><%=primaryStatus %></span></td>
						            <td class="updateContact clickeble" data-related="update_contact" onclick="openUpdateContact('<%=contacts[i][1] %>')"><%=name%></td>
						            <td><%=contacts[i][7] %></td>
						            <td><%=contacts[i][5] %></td>
						            <td><%=contacts[i][2] %></td>
						            <td class="list_icon" >
						           <a href="javascript:void(0)" class="icoo">
			<i class="fa fa-angle-up pointers "></i>
			<i class="fa fa-angle-down pointers "></i>
			</a>
									<ul class="dropdown_list" id="act<%=contacts.length-i%>">
									<%if(flag&&primary){ %><li><a class="addnew2 pointers" data-related="add_payment" onclick="openPrimaryBox('<%=contacts[i][1] %>','<%=contacts[i][13] %>')">Make Primary</a></li><%} %>
									<li><a class="addnew2 pointers" data-related="add_payment" onclick="openDeleteBox('<%=contacts[i][1] %>')">Delete</a></li>
									</ul>
						            </td>									
						        </tr>
						     <%}}%>
                                 
						    </tbody>
						</table>
						
						<div class="filtertable">
					  <span>Showing <%=showing %> to <%=ssn+contacts.length %> of <%=totalContact %> entries</span>
					  <div class="pagination">
					    <ul> <%if(pageNo>1){ %>
					      <li class="page-item">	                     
					      <a class="page-link text-primary" href="<%=request.getContextPath()%>/managecontacts.html?page=1&rows=<%=rows%>">First</a>
					   </li><%} %>
					    <li class="page-item">					      
					      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/managecontacts.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
					    </li>  
					      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
						    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
						    <a class="page-link" href="<%=request.getContextPath()%>/managecontacts.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
						    </li>   
						  <%} %>
						   <li class="page-item">						      
						      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/managecontacts.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
						   </li><%if(pageNo<=(totalPages-1)){ %>
						   <li class="page-item">
						      <a class="page-link text-primary" href="<%=request.getContextPath()%>/managecontacts.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
						   </li><%} %>
						</ul>
						</div>
						<select class="select2" onchange="changeRows(this.value,'managecontacts.html?page=1','<%=domain%>')">
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
	<p id="end" style="display:none;"></p>
	</div>
<div class="fixed_right_box">
<!-- right open start-->
<div class="clearfix add_inner_box pad_box4 addcompany" id="add_contact">
<div class="close_icon close_box"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-fax"></i>New Contact</h3>
<p>When someone reaches out to you, they become a contact in your account. You can create companies and associate contacts with them.</div>

<form onsubmit="return false;" id="FormContactBox">
<input type="hidden" id="AddContactKeyId">
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="logo-footer3">
  <div class="input-group">
  <input type="text" name="CompanyName" id="CompanyName" placeholder="Company name" class="form-control bdrd4">
  <input type="hidden" id="CompanyRefId" value="NA"/>
  <input type="hidden" id="CompanyAddress" value="NA"/>
  <input type="hidden" id="super_user_id" value="NA"/>
  </div>
  <div id="fnameErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
<div class="clearfix">
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
  <input type="text" name="contPan" id="ContPan" onblur="validatePanPopup('ContPan');validateValuePopup('ContPan');isExistPan('ContPan');" placeholder="Pan" maxlength="10" class="form-control bdrd4">
  </div>
  <div id="wphoneErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>Work Phone :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
  <input type="text" name="workphone" id="ContactWorkPhone" onblur="isDuplicateMobilePhone('ContactWorkPhone')" placeholder="Work phone" maxlength="10" class="form-control bdrd4" onkeypress="return isNumber(event)">
  </div>
  <div id="wphoneErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>Mobile Phone :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
  <input type="text" name="mobilephone" id="ContactMobilePhone" placeholder="Mobile Phone" maxlength="10" onblur="validateMobilePopup('ContactMobilePhone');isDuplicateMobilePhone('ContactMobilePhone');" class="form-control bdrd4" onkeypress="return isNumber(event)">
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
<input type="radio" name="addresstype" id="ContactperAddress" checked>
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
  <textarea class="form-control bdrd4" rows="2" name="enqAdd" id="ContAddress" placeholder="Address" onblur="validateValuePopup('ContAddress');validateLocationPopup('ContAddress');" ></textarea>
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
<button class="bt-link bt-radius bt-gray mrt10 close_box" type="button">Cancel</button>
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateContact();">Create</button>
</div>
</form>
</div>
<!-- update contact box -->
<div class="clearfix add_inner_box pad_box4 addcompany" id="update_contact">
<div class="close_icon close_box"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-fax"></i>Update Contact</h3>
<p>When someone reaches out to you, they become a contact in your account. You can create companies and associate contacts with them.</div>

<form onsubmit="return false;" id="FormUpdateContactBox">
<input type="hidden" id="UpdateContactKey"/>
<div class="row">
<div class="col-md-6 col-sm-6 col-xs-12">
 <div class="logo-footer3">
  <div class="input-group">
  <input type="text" name="UpdateCompanyName" id="UpdateCompanyName" placeholder="Company name" class="form-control bdrd4">
  <input type="hidden" id="UpdateCompanyRefId" value="NA"/>
  <input type="hidden" id="UpdateCompanyAddress" value="NA"/>
  <input type="hidden" id="update_super_user_id" value="NA"/>
  </div>
  <div id="fnameErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
</div>
<div class="clearfix">
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
  <input type="text" name="contPan" id="UpdateContPan" onblur="validatePanPopup('UpdateContPan');validateValuePopup('UpdateContPan');isExistEditPanCon('UpdateContPan');" placeholder="Pan" maxlength="10" class="form-control bdrd4">
  </div>
  <div id="wphoneErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>Work Phone :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
  <input type="text" name="workphone" id="UpdateContactWorkPhone" onblur="isUpdateDuplicateMobilePhone('UpdateContactWorkPhone')" placeholder="Work phone" maxlength="10" class="form-control bdrd4" onkeypress="return isNumber(event)">
  </div>
  <div id="wphoneErrorMSGdiv" class="errormsg"></div>
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>Mobile Phone :</label>
  <div class="input-group">
  <input type="text" name="mobilephone" id="UpdateContactMobilePhone" placeholder="Mobile Phone" maxlength="10" onblur="validateMobilePopup('UpdateContactMobilePhone');isUpdateDuplicateMobilePhone('UpdateContactMobilePhone');" class="form-control bdrd4" onkeypress="return isNumber(event)">
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
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateUpdateContact();">Update</button>
</div>
</form>
</div>
<!-- right open end -->
</div>

<div class="modal fade" id="warningDeleteContact" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span><span class="text-danger">Are you sure want to delete this contact ?.</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>      
      <div class="modal-footer">
         <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="deleteContact('ContactUniqueRefid')">Yes</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="warningPrimary" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span><span class="text-danger">Are you sure want to make primary this contact ?.</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <div class="modal-footer">
         <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="makePrimaryContact('ContactUniqueRefid','ClientUniqueRefid')">Yes</button>
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
            	<option value="cccontactfirstname,cccontactlastname">Name</option>
            	<option value="ccworkphone,ccmobilephone">Mobile</option>
            	<option value="ccemailfirst">Email</option>
            	<option value="cccompanyname">Company Name</option>
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
<div class="noDisplay"><a href="" id="DownloadExportedLink" download><button id="DownloadExported">Download</button></a></div>
  <input type="hidden" id="ClientUniqueRefid" value="NA">
  <input type="hidden" id="ContactUniqueRefid" value="NA">
	<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>	
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>

<script type="text/javascript"> 
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
    	state=x[2];
    	stateCode=x[1];
    	city=document.getElementById("UpdateContCity").value.trim();    	
    	address=document.getElementById("UpdateContAddress").value.trim();    	
    }
    if($('#UpdateContactcomAddress').prop('checked')){
		companyaddress=document.getElementById("UpdateEnqCompAddress").value.trim();
		addresstype="Company";
    }
   var super_user_id=$("#update_super_user_id").val().trim();
   var contkey=document.getElementById("UpdateContactKey").value.trim(); 
   var clientkey=document.getElementById("UpdateCompanyRefId").value.trim(); 
   var compName=$("#UpdateCompanyName").val().trim();    
   showLoader();
	$.ajax({
		type : "POST",
		url : "UpdateContactData111",
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
			stateCode : stateCode,
			address : address,
			companyaddress : companyaddress,
			addresstype : addresstype,
			contkey : contkey,
			compName : compName,
			clientkey : clientkey,
			country : country,
			pan : pan,
			super_user_id : super_user_id
		},
		success : function(data){
			if(data=="pass"){
				document.getElementById('errorMsg1').innerHTML = 'Successfully Contact Updated !!';
				$('.alert-show1').show().delay(4000).fadeOut();
				setTimeout(() => {location.reload();}, 4000);												
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
function validateContact(){
	var firstname=$("#ContactFirstName").val().trim();
	var lastname=$("#ContactLastName").val().trim();
	var email=$("#ContactEmail_Id").val().trim();
	var email2=$("#ContactEmailId2").val().trim();
	var workphone=$("#ContactWorkPhone").val().trim();
	var mobile=$("#ContactMobilePhone").val().trim();
	var CompanyRefId=$("#CompanyRefId").val().trim();
	var pan=$("#ContPan").val().trim();
    var country="NA";
	var city="NA";
    var state="NA";
    var stateCode="NA";
    var address="NA";
    var companyaddress="NA";
    var addresstype="Personal";
    var super_user_id=$("#super_user_id").val();
    
	if(firstname==null||firstname==""){
		document.getElementById('errorMsg').innerHTML ="First name is mandatory.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(lastname==null||lastname==""){
		document.getElementById('errorMsg').innerHTML ="Last name is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(email==null||email==""){
		document.getElementById('errorMsg').innerHTML ="Email is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(email2==null||email2==""){
		email2="NA";
		
	}
	if(workphone==null||workphone==""){
		document.getElementById('errorMsg').innerHTML ="Work phone is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(mobile==null||mobile==""){
		mobile="NA";
	}
	if(pan==null||pan==""){
		pan="NA";
	}
	
	if($('#ContactperAddress').prop('checked')){
		if($("#ContCountry").val().trim()==null||$("#ContCountry").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Country is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#ContState").val().trim()==null||$("#ContState").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="State is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#ContCity").val().trim()==null||$("#ContCity").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="City is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		
		if($("#ContAddress").val().trim()==null||$("#ContAddress").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Address is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
	}
	
    if($('#ContactperAddress').prop('checked')){
    	country=$("#ContCountry").val();
    	var x=country.split("#");
    	country=x[1];
    	state=$("#ContState").val();
    	x=state.split("#");
    	state=x[2];
    	stateCode=x[1];
    	city=$("#ContCity").val();    	
    	address=$("#ContAddress").val().trim();    	
    }
    if($('#ContactcomAddress').prop('checked')){
		companyaddress=$("#EnqCompAddress").val().trim();
		addresstype="Company";
    }
   
    var compname="....";
    if($("#CompanyName").val().trim()!=null&&$("#CompanyName").val().trim()!=""){
    	compname=$("#CompanyName").val().trim();
    }
    if(compname=="....")CompanyRefId="NA";
    var key=makeid(40);
    showLoader();
	$.ajax({
		type : "POST",
		url : "RegisterNewContact777",
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
			stateCode : stateCode,
			address : address,
			companyaddress : companyaddress,
			compname : compname,
			addresstype : addresstype,
			key : key,
			CompanyRefId : CompanyRefId,
			country : country,
			pan : pan,
			super_user_id : super_user_id
		},
		success : function(data){
			if(data=="pass"){
				document.getElementById('errorMsg1').innerHTML = 'Successfully Contact Created !! !!';
				$('.alert-show1').show().delay(4000).fadeOut();
				setTimeout(() => {location.reload();}, 4000);				
			}else if(data=="invalid"){
				document.getElementById('errorMsg').innerHTML = 'Please enter a valid email !! !!';
				$('.alert-show').show().delay(4000).fadeOut();
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
function makeid(length) {
	   var result           = '';
	   var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
	   var charactersLength = characters.length;
	   for ( var i = 0; i < length; i++ ) {
	      result += characters.charAt(Math.floor(Math.random() * charactersLength));
	   }
	   return result;
	}
function makePrimaryContact(conBoxId,clientBoxId){
	var conKey=$("#"+conBoxId).val();
	var clientKey=$("#"+clientBoxId).val();
	showLoader();
	$.ajax({
		type : "POST",
		url : "PrimaryContactData111",
		dataType : "HTML",
		data : {conKey : conKey,clientKey : clientKey},
		success : function(data){
			if(data=="pass"){
			location.reload(true);
			}else{
				document.getElementById("errorMsg").innerHTML="Something went erong ! Please try-again later !!";
				$('.alert-show').show().delay(4000).fadeOut();
			}
			
		},
		complete : function(data){
			hideLoader();
		}
	});	
}
function openPrimaryBox(conKey,clientKey){
	$("#ContactUniqueRefid").val(conKey);
	$("#ClientUniqueRefid").val(clientKey);
	$("#warningPrimary").modal("show");
}
function openDeleteBox(crefid){
	$("#ContactUniqueRefid").val(crefid);
	$("#warningDeleteContact").modal("show");
}
function deleteContact(crefBoxId){
	var crefid=$("#"+crefBoxId).val();
	//delete contact by refid
	showLoader();
	$.ajax({
		type : "POST",
		url : "DeleteContactData111",
		dataType : "HTML",
		data : {crefid : crefid},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg1").innerHTML="Deleted.";
			$("#Cont"+crefid).remove();	
			$('.alert-show1').show().delay(2000).fadeOut();
			setTimeout(() => {
				location.reload();
			}, 2000);
			}else if(data=="exist"){
				document.getElementById("errorMsg").innerHTML="Contact is in sales, Deletion not allowed. !!";
				$('.alert-show').show().delay(4000).fadeOut();
			}else{
				document.getElementById("errorMsg").innerHTML="Something went erong ! Please try-again later !!";
				$('.alert-show').show().delay(4000).fadeOut();
			}
			
		},
		complete : function(data){
			hideLoader();
		}
	});	
}
function isDuplicateMobilePhone(phoneid){
	var val=document.getElementById(phoneid).value.trim();
	if(val!=""&&val!="NA")
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
			
		}
	});
}
function isDuplicateEmail(emailid){
	var val=document.getElementById(emailid).value.trim();
	if(val!=""&&val!="NA")
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
			
		}
	});
}

function openContactBox(){	
	$('#FormContactBox').trigger("reset");
	var id = $(".addcontact").attr('data-related'); 
	$(id).hide();
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });	
}

function openUpdateContact(contactrefid){	
	$("#FormUpdateContactBox").trigger("reset");
		var id = $(".updateContact").attr('data-related'); 
		fillContactDetails(contactrefid);
		$('.fixed_right_box').addClass('active');
		    $("div.add_inner_box").each(function(){
		        $(this).hide();
		        if($(this).attr('id') == id) {
		            $(this).show();
		        }
		    });		
}
function fillContactDetails(key){
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
			var company=response[0]["company"];
			var clientRefid=response[0]["clientRefid"];
			var compAddress=response[0]["compAddress"];
			var country=response[0]["country"];
			var pan=response[0]["pan"];
			var super_user_id=response[0]["super_user_id"];
			
			$("#update_super_user_id").val(super_user_id);
			$("#UpdateCompanyName").val(company);$("#UpdateCompanyAddress").val(compAddress);$("#UpdateCompanyRefId").val(clientRefid);
			$("#UpdateContactKey").val(contkey);$("#UpdateContactFirstName").val(firstname);$("#UpdateContactLastName").val(lastname);$("#UpdateContactEmail_Id").val(email1);
			$("#UpdateContPan").val(pan);
			if(email2!=="NA"){
				$("#UpdateContactEmailId2").val(email2);
				document.getElementById("UpdateContactDivId").style.display="block";
			}			
			$("#UpdateContactWorkPhone").val(workphone);$("#UpdateContactMobilePhone").val(mobilephone);
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
			
		 }}
		},
		complete : function(data){
			hideLoader();
		}
	});
}
$(function() {
	$("#UpdateCompanyName").autocomplete({
		source : function(request, response) {
			if(document.getElementById('UpdateCompanyName').value.trim().length>=2)
			$.ajax({
				url : "<%=request.getContextPath()%>/getCompanyDetails.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field: "companynamenew",
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.label,
							value : item.value,
							address : item.address,
							cregrefid  : item.cregrefid,
							suaid : item.suaid
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
            	document.getElementById('errorMsg').innerHTML ="Select from list";
            	$("#UpdateCompanyName").val("");
            	$("#UpdateCompanyAddress").val("");
            	$("#UpdateCompanyRefId").val("");
            	$("#update_super_user_id").val("");
            	$('.alert-show').show().delay(2000).fadeOut();            	
            }
            else{
            	$("#UpdateCompanyAddress").val(ui.item.address);
            	$("#UpdateCompanyRefId").val(ui.item.cregrefid);
            	$("#update_super_user_id").val(ui.item.suaid);
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});



$(function() {
	$("#CompanyName").autocomplete({
		source : function(request, response) {
			if(document.getElementById('CompanyName').value.trim().length>=1)
			$.ajax({
				url : "<%=request.getContextPath()%>/getCompanyDetails.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field: "companynamenew",
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.label,
							value : item.value,
							address : item.address,
							cregrefid  : item.cregrefid,
							suaid : item.suaid
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
            	document.getElementById('errorMsg').innerHTML ="Select from list";
            	$("#CompanyName").val("");
            	$("#CompanyAddress").val("");
            	$("#CompanyRefId").val("");
            	$("#super_user_id").val("");
            	$('.alert-show').show().delay(2000).fadeOut();            	
            }
            else{
            	$("#CompanyAddress").val(ui.item.address);
            	$("#CompanyRefId").val(ui.item.cregrefid);
            	$("#super_user_id").val(ui.item.suaid);
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
				url : "<%=request.getContextPath()%>/getCompanyDetails.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field: "companynamenew",
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.label,
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
            if(!ui.item){ }
            else{
            	doAction(ui.item.value,"contactCompanyNameAction");
            	location.reload(true);
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});
function getUpdateCompanyAddress(){
	var compaddress=document.getElementById("UpdateCompanyAddress").value.trim();
	document.getElementById("UpdateEnqCompAddress").value=compaddress;
}
function getCompanyAddress(){
	var compaddress=document.getElementById("CompanyAddress").value.trim();
	document.getElementById("EnqCompAddress").value=compaddress;
}
function showActionMenu(id){
	$('#'+id).addClass("show");
}
function hideActionMenu(id){
	$('#'+id).removeClass("show");
}
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
$('.add_new').on( "click", function(e) {
	$(this).parent().next().show();	
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
$('.del_icon').on( "click", function(e) {
	$('.new_field').hide();	
	});
</script>	
<script type="text/javascript">
$(document).ready(function() {
$('#multiple_item').select2();
});
$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var data=$(this).val();
	doAction(data,"contactDateRangeAction");
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
	   var dateRangeDoAction="<%=contactDateRangeAction%>";
	   if(dateRangeDoAction!="NA"){	  
		   $('input[name="date_range"]').val(dateRangeDoAction);
	   }
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
			type : "Contact"
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
	function isExistPan(valueid){
		var val=document.getElementById(valueid).value.trim();
		if(val!=""&&val!="NA")
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
				
			}
		});
	}
	function isExistEditPanCon(valueid){
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
	function isUpdateDuplicateEmail(emailid){
		var contkey=$("#UpdateContactKey").val().trim();
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
</script>

</body>
</html>