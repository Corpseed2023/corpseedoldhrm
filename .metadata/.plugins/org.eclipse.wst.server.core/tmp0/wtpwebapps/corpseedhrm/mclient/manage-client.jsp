<%@page import="java.util.Properties"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Manage Client</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%
String token = (String) session.getAttribute("uavalidtokenno");

String clientDateRangeAction=(String)session.getAttribute("clientDateRangeAction");
if(clientDateRangeAction==null||clientDateRangeAction.length()<=0)clientDateRangeAction="NA";

String SearchByClientNameReg=(String)session.getAttribute("SearchByClientNameReg");
if(SearchByClientNameReg==null||SearchByClientNameReg.length()<=0)SearchByClientNameReg="NAA";

Properties properties = new Properties();
properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
String domain=properties.getProperty("domain");
String azure_path=properties.getProperty("azure_path");

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

String sort_url=domain+"manage-client.html?page="+pageNo+"&rows="+rows;

//pagination end

String[][] client=Clientmaster_ACT.getAlluser(SearchByClientNameReg,token,clientDateRangeAction,pageNo,rows,sort,order);
int totalClient=Clientmaster_ACT.countAllClient(SearchByClientNameReg,token,clientDateRangeAction);
String country[][]=TaskMaster_ACT.getAllCountries();
%>
<%if(!CPR03){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
<div class="main-content">
<div class="container-fluid">
<div class="row">
<form onsubmit="return false" method="post">
<div class="bg_wht clearfix mb10" id="SearchOptions">  
<div class="clearfix">
<div class="col-md-7 col-sm-7 col-xs-6 mb10">
<%-- <div class="col-md-12">
<%if(CR01){ %><a href="<%=request.getContextPath() %>/client-registration.html"><button type="button" class="filtermenu dropbtn" style="width: 83px;margin-left: -14px;">+&nbsp;Add new</button></a><%} %>
</div> --%>
</div>
<a href="javascript:void(0)" class="doticon"> <i class="fa fa-filter" aria-hidden="true"></i>Filter</a>
<div class="filtermmenu">
<div class="post" style="position:absolute;z-index:9">
                        <div class="linee" style="margin-top: -1px;width:1350px;height:50px"></div>
                            </div>
<div class="col-md-5 col-sm-5 col-xs-12 mb10">
<div class="clearfix flex_box justify_end">  
<div class="item-bestsell col-md-6 col-sm-3 col-xs-12">
<p><input type="search" name="clientName" id="ClientName" <%if(!SearchByClientNameReg.equalsIgnoreCase("NAA")){ %>onsearch="clearSession('SearchByClientNameReg');location.reload()" value="<%=SearchByClientNameReg %>"<%} %> title="Search by client's name !" placeholder="Search by client's name.." class="form-control" autocomplete="off">
</p>
</div>
<div class="item-bestsell col-md-6 col-sm-3 col-xs-12 has-clear"> 
<p><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="FROM - TO" class="form-control text-center date_range pointers <%if(!clientDateRangeAction.equalsIgnoreCase("NA")){ %>selected<%} %>" readonly="readonly">
<span class="form-control-clear form-control-feedback" onclick="clearSession('clientDateRangeAction');location.reload();"></span>
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
           <th class="sorting <%if(sort.equals("client_no")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','client_no','<%=order%>')">Client No</th>
           <th class="sorting <%if(sort.equals("company_type")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','company_type','<%=order%>')">Company Type</th>
           <th class="sorting <%if(sort.equals("client")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','client','<%=order%>')">Client</th>
           <th class="sorting <%if(sort.equals("mobile")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','mobile','<%=order%>')">Mobile</th>
           <th class="sorting <%if(sort.equals("email")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','email','<%=order%>')">Email</th>           
           <th class="sorting <%if(sort.equals("location")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','location','<%=order%>')">Location</th>
           <th class="sorting <%if(sort.equals("cname")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','cname','<%=order%>')">Contact Name</th>
           <th class="sorting <%if(sort.equals("cphone")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','cphone','<%=order%>')">Contact Phone</th>
<!--            <th width="80">Action</th> -->
       </tr>
   </thead>
   <tbody>
   <%
   int ssn=0;
   int showing=0;
   int startRange=pageNo-2;
   int endRange=pageNo+2;
   int totalPages=1;
   if(client!=null&&client.length>0){
	   ssn=rows*(pageNo-1);
		  totalPages=(totalClient/rows);
		  if((totalClient%rows)!=0)totalPages+=1;
		  showing=ssn+1; 
		  if (totalPages > 1) {     	 
			  if((endRange-2)==totalPages)startRange=pageNo-4;        
	          if(startRange==pageNo)endRange=pageNo+4;
	          if(startRange<1) {startRange=1;endRange=startRange+4;}
	          if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
	          if(startRange<1)startRange=1;
	     }else{startRange=0;endRange=0;}
	   for(int i=0;i<client.length;i++){
		   String cType="";
		   if(client[i][10]!=null&&!client[i][10].equalsIgnoreCase("NA")&&client[i][10].length()>0){
			   int type=Integer.parseInt(client[i][10]);
			   if(type==0)cType="Individuals";
			   else if(type>0&&type<=6) cType="Startup ";
			   else if(type>6&&type<=10) cType="SME";
			   else if(type>10) cType="Enterprise";
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
       <tr <% if(client[i][8].equalsIgnoreCase("0")){%>style="background-color: #4a6182; color:#fff;"<%}%>>
           <td><input type="checkbox" name="checkbox" id="checkbox" class="checked"></td>
           <td><%=client[i][9] %></td>
           <td><%=cType %></td>
           <td><span class="clickeble name_action_box companybox" data-related="update_company" onclick="openCompanyBox('<%=client[i][11]%>')"><%=client[i][1] %></span></td>
           <td><%=client[i][2] %></td>
           <td><%=client[i][3] %></td>           
           <td><%=client[i][5] %></td>
           <td><%=client[i][6] %></td>
           <td><%=client[i][7] %></td>
           <%-- <td>
           <%if(CR02){ %><a href="javascript:void(0);" onclick="vieweditpage(<%=client[i][0] %>, 'upload');"><i class="fa fa-upload" title="Upload document"></i></a><%} %>
			<%if(CR03){ %><a href="javascript:void(0);" onclick="vieweditpage(<%=client[i][0] %>, 'edit');"><i class="fa fa-edit" title="Edit client"></i></a><%} %>
			<!-- update all details like as client profile business update -->
			<%if(CR03){ %><a href="javascript:void(0);" onclick="alert('pending....')"><i class="fa fa-edit" title="Edit client"></i></a><%} %>
			<%if(CR04||CR05){ %><a class="quick-view" href="#manageClient" onclick="document.getElementById('userid').innerHTML='<%=client[i][0] %>'"> <i class="fa fa-trash" title="Activate/Deactivate/Delete client"></i></a><%} %>
           </td> --%>
       </tr>
    <%}}%>
                           
    </tbody>
</table> 
</div>
<div class="filtertable">
  <span>Showing <%=showing %> to <%=ssn+client.length %> of <%=totalClient %> entries</span>
  <div class="pagination">
    <ul> <%if(pageNo>1){ %>
      <li class="page-item">	                     
      <a class="page-link text-primary" href="<%=request.getContextPath()%>/manage-client.html?page=1&rows=<%=rows%>">First</a>
   </li><%} %>
    <li class="page-item">					      
      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/manage-client.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
    </li>  
      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
	    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
	    <a class="page-link" href="<%=request.getContextPath()%>/manage-client.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
	    </li>   
	  <%} %>
	   <li class="page-item">						      
	      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/manage-client.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
	   </li><%if(pageNo<=(totalPages-1)){ %>
	   <li class="page-item">
	      <a class="page-link text-primary" href="<%=request.getContextPath()%>/manage-client.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
	   </li><%} %>
	</ul>
	</div>
	<select class="select2" onchange="changeRows(this.value,'manage-client.html?page=1','<%=domain%>')">
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
 <input type="text" name="companyname" id="UpdateCompanyName" placeholder="Company Name" onblur="validCompanyNamePopup('UpdateCompanyName');validateValuePopup('UpdateCompanyName');isExistValue('UpdateCompanyName')" class="form-control bdrd4">
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
<!--   <input type="text" name="state" id="UpdateState" placeholder="State" onblur="validateCityPopup('UpdateState');validateValuePopup('UpdateState')" class="form-control bdrd4"> -->
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
  <!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
<!--   <input type="text" name="city" id="UpdateCity" placeholder="City" onblur="validateCityPopup('UpdateCity');validateValuePopup('UpdateCity')" class="form-control bdrd4"> -->
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
  <!--<span class="input-group-addon"><i class="form-icon sprite page"></i></span>-->
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
</div>









<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>
<section class="clearfix" id="manageClient" style="display: none;">
<div class="clearfix  text-center">
<div class="col-md-12 col-xs-12" id="userid" style="display: none;"></div>
<div class="col-md-12 col-xs-12">
<div class="box-intro1">
  <h2><span class="title">Activate/Deactivate/Delete This Client?</span></h2>
</div>
</div>
<div class="col-md-12 col-xs-12 mb10">
<a class="sub-btn1" onclick="" id="cancelpopup">Cancel</a>

<%if(CR04){ %><a class="sub-btn1 mlft10" onclick="return approve(document.getElementById('userid').innerHTML,'1');" title="Activate This Client">Activate</a>
<a class="sub-btn1 mlft10" onclick="return approve(document.getElementById('userid').innerHTML,'0');" title="Deactivate This Client">Deactivate</a><%} %>
<%if(CR05){ %><a class="sub-btn1 mlft10" onclick="return deleteClient(document.getElementById('userid').innerHTML);" title="Delete This Client">Delete</a><%} %>
</div>
</div>
</section>
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
            	<option value="cregucid ">Client No.</option>
            	<option value="cregname">Client Name</option>
            	<option value="cregemailid,cregcontemailid">Email</option>
            	<option value="cregcontaddress">Address</option>
            	<option value="creglocation">Location</option>
            	<option value="cregcontfirstname,cregcontlastname">Contact Person</option>
            	<option value="cregmob,cregcontmobile">Mobile</option> 
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
<div class="noDisplay"><a href="" id="DownloadExportedLink" download><button id="DownloadExported">Download</button></a></div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">	
	$('#cancelpopup').click(function(){
		  $.fancybox.close();
	});
</script>
<script>
$(function() {
	$("#clientlocation").autocomplete({
		source : function(request, response) {
			if(document.getElementById('clientlocation').value.trim().length>=1)
			$.ajax({
				url : "getclientname.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					col : "creglocation"
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
        		
            	$("#clientlocation").val("");
            }
            else{
            	$("#clientlocation").val(ui.item.value);
            	            	
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

$(function() {
	$("#clientmobile").autocomplete({
		source : function(request, response) {
			if(document.getElementById('clientmobile').value.trim().length>=1)
			$.ajax({
				url : "getclientname.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					col : "cregmob"
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
            if(!ui.item){}
            else{
            	doAction(ui.item.value,'SearchByClientNameReg');
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
				url : "getclientname.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					col : "cregname"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name	
						};
					}));
				},
				error : function(error) {
					alert('error: ' + error.responseText);
				}
			});
		},
		select: function (event, ui) {
            if(!ui.item){}
            else{
            	doAction(ui.item.label,'SearchByClientNameReg');
            	location.reload();            	            	
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

</script>
<script type="text/javascript">
function deleteClient(id){
	var xhttp;
	xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
	if (this.readyState == 4 && this.status == 200) {
	location.reload();
	}
	};
	xhttp.open("POST", "<%=request.getContextPath()%>/DeleteThisClient111?info="+id, true);
	xhttp.send();
}

function approve(id,status) {
var xhttp;
xhttp = new XMLHttpRequest();
xhttp.onreadystatechange = function() {
if (this.readyState == 4 && this.status == 200) {
location.reload();
}
};
xhttp.open("GET", "<%=request.getContextPath()%>/DeleteClient111?info="+id+"&status="+status, true);
xhttp.send();
}

function RefineSearchenquiry() {
document.RefineSearchenqu.jsstype.value="SSEqury";
document.RefineSearchenqu.action="<%=request.getContextPath()%>/manage-client.html";
document.RefineSearchenqu.submit();
}
</script>
<script type="text/javascript">
function vieweditpage(id,page){
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/vieweditpage",
	    data:  { 
	    	"uid" : id
	    },
	    success: function (response) {
        	if(page=="edit") window.location = "<%=request.getContextPath()%>/editclient.html";
<%--         	else if(page=="upload") window.location = "<%=request.getContextPath()%>/uploaddocuments-client.html"; --%>
        },
	});
}
$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var data=$(this).val();
	doAction(data,"clientDateRangeAction");
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
	   var dateRangeDoAction="<%=clientDateRangeAction%>";
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
			type : "Client"
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
			       
			$("#UpdateCompanyKey").val(clientkey);$("#UpdateCompanyName").val(name);
			$("#UpdateIndustry_Type").val(industry);$("#Update_Super_User").val(superUserUaid).trigger('change');
			$("#UpdatePanNumber").val(pan);$("#Edit_Company_age").val(compAge);
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
			
		 }
		},
		complete : function(data){
			hideLoader();
		}
	});
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
$(document).ready(function(){
	$('.close_box').on( "click", function(e) { 
		$('.fixed_right_box').removeClass('active');
		$('.addnew').show();	
	});
	$('#Update_Super_User').select2({
        placeholder: 'Select Super User',
        allowClear: true
    });
})
function isExistValue(valueid){
	var val=document.getElementById(valueid).value.trim();
	var clientkey=$("#UpdateCompanyKey").val();
	if(val!=""&&val!="NA")
	$.ajax({
		type : "POST",
		url : "ExistClientValue111",
		dataType : "HTML",
		data : {val:val,clientkey:clientkey},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg").innerHTML=val +" is already existed.";
			document.getElementById(valueid).value="";
			$('.alert-show').show().delay(4000).fadeOut();
			}
			
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
</script>
</body>
</html>