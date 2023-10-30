<%@page import="java.util.Properties"%>
<%@page import="admin.master.Usermaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Manage Users</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%
String addedby= (String)session.getAttribute("loginuID");
String token= (String)session.getAttribute("uavalidtokenno");
String name= (String)session.getAttribute("muname");
String mobile= (String)session.getAttribute("mumobile");
String type= (String)session.getAttribute("mutype");
String userroll= (String)session.getAttribute("emproleid");
if(name==null||name=="")name="NA";
if(mobile==null||mobile=="")mobile="NA";
if(type==null||type=="")type="NA";
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
String sort_url=domain+"managewebuser.html?page="+pageNo+"&rows="+rows;

//pagination end

String[][] user=Usermaster_ACT.getAlluser(token, name, mobile, type,userroll,addedby,pageNo,rows,sort,order);
int totalUser=Usermaster_ACT.countAlluser(token, name, mobile, type,userroll,addedby);

%>
<%if(!AMU02){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
<div class="main-content">
<div class="container-fluid">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">

<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="top_title text-center">
<h2><i class="fa fa-users"></i>&nbsp;&nbsp; Manage Users</h2>
</div>
<%if(ACU01){%><a class="add_btn sub-btn1" href="<%=request.getContextPath() %>/newwebuser.html">Register HRM Login</a><%} %>
<form name="RefineSearchenqu" onsubmit="return false;">
<div class="bg_wht home-search-form clearfix mb10" id="SearchOptions">
<a href="javascript:void(0)" class="doticon"> <i class="fa fa-filter" aria-hidden="true"></i>Filter</a>
<div class="filtermmenu">
<div class="post" style="position:absolute;z-index:9">
                        <div class="linee" style="margin-top: -1px;width:1350px;height:50px"></div>
                            </div>
<div class="item-bestsell box-width14_28 col-md-2 col-sm-11 col-xs-12">
<select class="filtermenu" style="height:41px" onchange="doAction(this.value,'mutype');location.reload();">
<option value="">All</option>
<option value="Client" <%if(type.equals("Client")){ %>selected<%} %>>Client</option>
<option value="Employee" <%if(type.equals("Employee")){ %>selected<%} %>>Employee</option>
</select>
</div>
<div class="item-bestsell box-width14_28 col-md-2 col-sm-11 col-xs-12">
<p><input type="search" name="invoiceNo" id="SearchByName" <%if(!name.equals("NA")){ %> value="<%=name %>" onsearch="clearSession('muname')"<%} %> title="Search by name !" placeholder="Search by Name" class="form-control"/>
</p>
</div>
<div class="item-bestsell box-width14_28 col-md-2 col-sm-11 col-xs-12">
<p><input type="search" name="PhoneNo" id="SearchByPhoneNo" maxlength="10" <%if(!mobile.equals("NA")){ %> value="<%=mobile %>" onsearch="clearSession('mumobile')"<%} %>  placeholder="Phone No." class="form-control" onkeypress="return isNumber(event)"/>
</p>
</div>

</div>
</div>
</form>
</div>
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
         <th class="sorting <%if(sort.equals("id")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','id','<%=order%>')">SN</th>
         <th class="sorting <%if(sort.equals("name")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','name','<%=order%>')">Name</th>
         <th class="sorting <%if(sort.equals("role_type")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','role_type','<%=order%>')">Role Type</th>
         <th class="sorting <%if(sort.equals("department")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','department','<%=order%>')">Department</th>
         <th class="sorting <%if(sort.equals("role")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','role','<%=order%>')">Role</th>
         <th class="sorting <%if(sort.equals("user_id")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','user_id','<%=order%>')">User Id</th>
<%--          <th class="sorting <%if(sort.equals("password")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','password','<%=order%>')">Password</th> --%>
         <th class="sorting <%if(sort.equals("ip")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','ip','<%=order%>')">IP Allow</th>
         <th width="100">Action</th>
     </tr>
 </thead>
 <tbody>
 <%
 int ssn=0;
 int showing=0; 
 int startRange=pageNo-2;
 int endRange=pageNo+2;
 int totalPages=1;
 if(user!=null&&user.length>0){
	 ssn=rows*(pageNo-1);
	  totalPages=(totalUser/rows);
	  if((totalUser%rows)!=0)totalPages+=1;
	  showing=ssn+1;
	  if (totalPages > 1) {     	 
		  if((endRange-2)==totalPages)startRange=pageNo-4;        
         if(startRange==pageNo)endRange=pageNo+4;
         if(startRange<1) {startRange=1;endRange=startRange+4;}
         if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
         if(startRange<1)startRange=1;
    }else{startRange=0;endRange=0;}
	 for(int i=0;i<user.length;i++){%>
	 
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
	 
     <tr <% if(user[i][9].equalsIgnoreCase("0")){%>style="background-color: #4a6182;color:#fff; "<%}%>>
         <td><%=(showing+i) %></td>
         <td><%=user[i][5] %></td>
         <td><%=user[i][14] %></td>
         <td><%=user[i][15] %></td>
         <td><%=user[i][16] %></td>
         <td><%=user[i][2] %></td>
<%--          <td><%=user[i][4] %></td> --%>
         <td><input type="text" class="ip_allow" value="<%=user[i][17] %>" onchange="updateIp(this.value,'<%=user[i][0] %>')" <%if(user[i][14].equalsIgnoreCase("Client")){ %>readonly="readonly"<%} %>>
         <i class="fas fa-check-circle text-primary pointers ip-active<%=i %> <%if(user[i][18].equals("2")){%>toggle_box<%}%>" title="Disable" onclick="activeBan('2','<%=user[i][0] %>',<%=i %>)"></i>
         <i class="fas fa-ban text-danger pointers ip-enactive<%=i %> <%if(user[i][18].equals("1")){%>toggle_box<%}%>" title="Enable" onclick="activeBan('1','<%=user[i][0] %>',<%=i %>)"></i>
         </td>
         <td>
         <%if(ACU02){ %><a href="javascript:void(0);" onclick="vieweditpage(<%=user[i][0] %>,'edit');"><i class="fa fa-edit" title="Edit"></i></a><%} %>
		 <%if(ACU03){ %><a class="fancybox" href="<%=request.getContextPath() %>/changepasswordByAdmin-<%=user[i][2] %>.html"><i class="fa fa-lock" title="Change Password"></i> </a><%} %>
		 <%if(ACU04||ACU05){ %><a class="quick-view" href="#manageuser" onclick="document.getElementById('userid').innerHTML='<%=user[i][0] %>'"><i class="fa fa-trash" title="Activate/Deactivate/Delete this user."></i> </a><%} %>
         </td>
     </tr>
  <%}}%>                           
    </tbody>
</table> 
</div>
<div class="filtertable">
  <span>Showing <%=showing %> to <%=ssn+user.length %> of <%=totalUser %> entries</span>
  <div class="pagination">
    <ul> <%if(pageNo>1){ %>
      <li class="page-item">	                     
      <a class="page-link text-primary" href="<%=request.getContextPath()%>/managewebuser.html?page=1&rows=<%=rows%>">First</a>
   </li><%} %>
    <li class="page-item">					      
      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/managewebuser.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
    </li>  
      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
	    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
	    <a class="page-link" href="<%=request.getContextPath()%>/managewebuser.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
	    </li>   
	  <%} %>
	   <li class="page-item">						      
	      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/managewebuser.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
	   </li><%if(pageNo<=(totalPages-1)){ %>
	   <li class="page-item">
	      <a class="page-link text-primary" href="<%=request.getContextPath()%>/managewebuser.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
	   </li><%} %>
	</ul>
	</div>
	<select class="select2" onchange="changeRows(this.value,'managewebuser.html?page=1','<%=domain%>')">
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
</div>
</div>
</div>
<section class="clearfix" id="manageuser" style="display: none;">
<div class="clearfix  text-center">
<div class="col-md-12 col-xs-12" id="userid" style="display: none;"></div>
<div class="col-md-12 col-xs-12">
<div class="box-intro1">
  <h2><span class="title bg_gray">Activate/Deactivate/Delete this User ?</span></h2>
</div>
</div>
<div class="col-md-12 col-xs-12 mb10">
<a class="sub-btn1" onclick="" id="cancelpopup">Cancel</a>

<%if(ACU04){ %><a class="sub-btn1 mlft10" onclick="return approve(document.getElementById('userid').innerHTML,'1');" title="Activate User">Activate</a><%} %>
<%if(ACU04){ %><a class="sub-btn1 mlft10" id="" onclick="return approve(document.getElementById('userid').innerHTML,'0');" title="Deactivate User">Deactivate</a><%} %>
<%if(ACU05){ %><a class="sub-btn1 mlft10" id="" onclick="" title="Delete User">Delete</a><%} %>
</div>
</div>
</section>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>

<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
$(".fancybox").fancybox({
    'width'             : '400px',
    'height'            : '300px',
    'autoScale'         : false,
    'transitionIn'      : 'none',
    'transitionOut'     : 'none',
    'type'              : 'iframe',
    'hideOnOverlayClick': false,
    afterClose: function () {    
    	parent.location.reload(true);
    }
});
function activeBan(status,uaid,sn){
	showLoader();
 $.ajax({
		type : "POST",
		url : "UpdateIpStatus111",
		dataType : "HTML",
		data : {				
			status : status,	
			uaid : uaid
		},
		success : function(data){				
			if(data=="pass"){
				if(status=="1"){
					$(".ip-active"+sn).show();
					$(".ip-enactive"+sn).hide();					
				}else if(status=="2"){
					$(".ip-active"+sn).hide();
					$(".ip-enactive"+sn).show();
				}
			}else{
				document.getElementById('errorMsg').innerHTML ='Something went wrong ! Try-again later !!';
				$('.alert-show').show().delay(3000).fadeOut();
			}
		},
		complete : function(data){
			hideLoader();
		}
	});
}

function approve(id,status) {

var xhttp;
xhttp = new XMLHttpRequest();
xhttp.onreadystatechange = function() {
if (this.readyState == 4 && this.status == 200) {
location.reload();
}
};
xhttp.open("GET", "<%=request.getContextPath()%>/DeleteUser111?info="+id+"&status="+status, true);
xhttp.send();

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
	    	if(page=="edit") window.location = "<%=request.getContextPath()%>/edituser.html";	    	
        },
	});
}
 
$(function() {
	$("#SearchByPhoneNo").autocomplete({
		source : function(request, response) {
			if(document.getElementById('SearchByPhoneNo').value.trim().length>=1)
			$.ajax({
				url : "get-user-details.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field :"mobile"
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
            	document.getElementById('errorMsg').innerHTML = 'Select From List.';
        		$('.alert-show').show().delay(1000).fadeOut();
        		
            	$("#SearchByPhoneNo").val("");     	
            }
            else{
            	doAction(ui.item.value,"mumobile");
            	location.reload();
            	
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

$(function() {
	$("#SearchByName").autocomplete({
		source : function(request, response) {
			if(document.getElementById('SearchByName').value.trim().length>=1)
			$.ajax({
				url : "get-user-details.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field :"name"
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
            	document.getElementById('errorMsg').innerHTML = 'Select From List.';
        		$('.alert-show').show().delay(1000).fadeOut();
        		$("#SearchByName").val("");     	
            }
            else{
            	doAction(ui.item.value,"muname");
            	location.reload();            	
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
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
		    	location.reload();
	        },
	        complete : function(data){
				hideLoader();
			}
		});
}
function updateIp(ip,uaid){
	showLoader();
	$.ajax({
		type: "POST",
		url : "<%=request.getContextPath()%>/updateIp111",		
		data : {ip : ip,uaid : uaid},
		success : function(data){
			if(data=="pass"){
				document.getElementById('errorMsg1').innerHTML = ip+' Updated.';
	    		$('.alert-show1').show().delay(2000).fadeOut();
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

</script>
<script type="text/javascript">	
	$('#cancelpopup').click(function(){
		  $.fancybox.close();
	});
	$( function() {
		$( ".PickDate" ).datepicker({
		changeMonth: true,
		changeYear: true,
		yearRange: '-60: -0',
		dateFormat: 'yy-mm-dd'
		});
		} );
</script>
</body>
</html>