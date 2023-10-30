<%@page import="client_master.Clientmaster_ACT"%>
<%@page import="java.util.Properties"%>
<%@page import="admin.master.Usermaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Manage Clients Admin</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%if(!CLA00){%><jsp:forward page="/login.html" /><%} %> 
<%
String addedby= (String)session.getAttribute("loginuID");
String token= (String)session.getAttribute("uavalidtokenno");
String name= (String)session.getAttribute("claname");
String mobile= (String)session.getAttribute("clamobile");

if(name==null||name=="")name="NA";
if(mobile==null||mobile=="")mobile="NA";

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
String sort_url=domain+"clientadmin.html?page="+pageNo+"&rows="+rows;

//pagination end

String[][] user=Usermaster_ACT.fetchAllSuperUser(token, name, mobile,pageNo,rows,sort,order);
int totalUser=Usermaster_ACT.countAllSuperUser(token, name, mobile);

%>

<div id="content">
<div class="main-content">
<div class="container">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">

<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="top_title text-center">
<h2><i class="fa fa-users"></i>&nbsp;&nbsp; Manage Client's Admin</h2>
</div>
<form name="RefineSearchenqu" onsubmit="return false;">
<div class="bg_wht home-search-form clearfix mb10" id="SearchOptions">
<a href="javascript:void(0)" class="doticon"> <i class="fa fa-filter" aria-hidden="true"></i>Filter</a>
<div class="filtermmenu">
<div class="post" style="position:absolute;z-index:9">
  <div class="linee" style="margin-top: -1px;width:1350px;height:50px"></div>
</div>

<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<p><input type="search" name="invoiceNo" id="SearchByName" <%if(!name.equals("NA")){ %> value="<%=name %>" onsearch="clearSession('claname')"<%} %> title="Search by name !" placeholder="Search by Name" class="form-control"/>
</p>
</div>
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<p><input type="search" name="PhoneNo" id="SearchByPhoneNo" maxlength="13" <%if(!mobile.equals("NA")){ %> value="<%=mobile %>" onsearch="clearSession('clamobile')"<%} %>  placeholder="Phone No." class="form-control" onkeypress="return isNumber(event)"/>
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
         <th class="sorting <%if(sort.equals("mobile")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','mobile','<%=order%>')">Mobile</th>
         <th class="sorting <%if(sort.equals("email")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','email','<%=order%>')">Email</th>
         <th class="sorting <%if(sort.equals("user_id")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','user_id','<%=order%>')">Username</th>
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
	 for(int i=0;i<user.length;i++){ 
	 //int totalClients=Clientmaster_ACT.countClientsBySuperUser(user[i][0],token);
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
         <td><%=(showing+i) %></td>
         <td><%=user[i][1] %></td>
         <td><%=user[i][2] %></td>
         <td><%=user[i][3] %></td>
         <td><%=user[i][4] %></td>                 
         <td class="list_icon"><a href="javascript:void(0)" class="icoo"><i class="fa fa-angle-up pointers "></i><i class="fa fa-angle-down pointers "></i></a>
         <ul class="dropdown_list">
         <li><a href="javascript:void(0);" onclick="showAllClientUser('<%=user[i][0]%>')">Users</a></li>
         <li><a href="javascript:void(0)" onclick="showAllClients('<%=user[i][0]%>')">Clients</a></li>
         <li><a href="javascript:void(0);" class="mrt10" onclick="editSuperUser('<%=user[i][0] %>')">Edit</a></li>
		 <li><a href="javascript:void(0);" onclick="deleteSuperUser('<%=user[i][0] %>')">Delete</a></li>		
         </ul>
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
      <a class="page-link text-primary" href="<%=request.getContextPath()%>/clientadmin.html?page=1&rows=<%=rows%>">First</a>
   </li><%} %>
    <li class="page-item">					      
      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/clientadmin.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
    </li>  
      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
	    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
	    <a class="page-link" href="<%=request.getContextPath()%>/clientadmin.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
	    </li>   
	  <%} %>
	   <li class="page-item">						      
	      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/clientadmin.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
	   </li><%if(pageNo<=(totalPages-1)){ %>
	   <li class="page-item">
	      <a class="page-link text-primary" href="<%=request.getContextPath()%>/clientadmin.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
	   </li><%} %>
	</ul>
	</div>
	<select class="select2" onchange="changeRows(this.value,'clientadmin.html?page=1','<%=domain%>')">
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
<div class="modal fade" id="deleteSuperUserWarning" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span>
        <span class="text-danger" id="bodyId"></span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">OK</button>
      </div>
    </div>
  </div>
</div>
<div class="modal fade" id="deleteSuperUserWarningMsg" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="fas fa-trash" style="color: #c90000;margin-right: 10px;"></i>Are you sure, Want to delete this User ?</h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <div class="modal-footer">
      <input type="hidden" id="superUserUaid">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">OK</button>
        <button type="button" class="btn btn-danger" onclick="deleteSuperUser('NA')">Delete</button>
      </div>
    </div>
  </div>
</div>
<div class="myModal modal fade" id="superUserClients">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title"><i class="fas fa-user" aria-hidden="true"></i> Clients</h4>  
          <button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>    
        <div class="modal-body">           
		  		  		  
        </div>
        <div class="modal-footer pad_box4">
          <div class="mtop10">
	         <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>
</div>
<div class="myModal modal fade" id="superUsersUser">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title"><i class="fas fa-user" aria-hidden="true"></i> Users</h4>  
          <button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>    
        <div class="modal-body">           
		  		  		  
        </div>
        <div class="modal-footer pad_box4">
          <div class="mtop10">
	         <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>
</div>
<div class="myModal modal fade" id="update_super_user">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title"><i class="fas fa-user" aria-hidden="true"></i>+ Update Client Admin</h4>  
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
              <input type="hidden" id="update_super_user_id">
	          <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
	          <button type="submit" class="btn btn-success">Submit</button> 
          </div>
        </div>
        </form>
      </div>
    </div>
</div>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>

<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
 
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
					field :"superUser",
					col : "uamobileno"
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
            	doAction(ui.item.value,"clamobile");
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
				type : "GET",
				dataType : "JSON",
				data : {
					name : request.term,
					field :"superUser",
					col : "uaname"
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
            	doAction(ui.item.value,"claname");
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
		
function showAllClientUser(uaid){	
	showLoader();
	$.ajax({
	    type: "GET",
	    url: "<%=request.getContextPath()%>/GetSuperUsersUser111",
	    data:  { 
	    	uaid : uaid
	    },
	    success: function (response) {
	    	$("#superUsersUser .modal-body").html(response);
			$("#superUsersUser").modal("show");
        },
		complete : function(data){
			hideLoader();
		}
	});
}		
		
function showAllClients(uaid){	
	showLoader();
	$.ajax({
	    type: "GET",
	    url: "<%=request.getContextPath()%>/GetSuperUserClients111",
	    data:  { 
	    	uaid : uaid
	    },
	    success: function (response) {
	    	$("#superUserClients .modal-body").html(response);
			$("#superUserClients").modal("show");
        },
		complete : function(data){
			hideLoader();
		}
	});
}
function editSuperUser(uaid){
	showLoader();
	$.ajax({
		type : "GET",
		url : "GetClientSuperUserByUaid111",
		dataType : "HTML",
		data : {uaid:uaid},
		success : function(response){
			if(Object.keys(response).length!=0){
				response = JSON.parse(response);			
				let firstName = response[0]['firstName'];
				let lastName = response[0]['lastName'];
				let email = response[0]['email'];
				let mobile = response[0]['mobile'];
				$("#super_name").val(firstName+" "+lastName);
				$("#super_email").val(email);
				$("#super_mobile").val(mobile);
				$("#update_super_user_id").val(uaid);
				$("#update_super_user").modal("show");
			}
		}
	});
	hideLoader();
}   
function validateSuperUser(){
	let super_name=$("#super_name").val();
	let super_email=$("#super_email").val();
	let super_mobile=$("#super_mobile").val();
	let uaid=$("#update_super_user_id").val();
	
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
		url : "UpdateClientSuperUser111",
		dataType : "HTML",
		data : {				
			super_name : super_name,
			super_email : super_email,
			super_mobile : super_mobile,
			uaid : uaid
		},
		success : function(data){
			if(data=="exist"){
				document.getElementById('errorMsg').innerHTML = 'Either mobile or email already exist !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}else if(data=="pass"){
				$("#update_super_user").modal("hide");
				document.getElementById('errorMsg1').innerHTML = 'Super User Updated Successfully !!';
				$('.alert-show1').show().delay(4000).fadeOut();
				setTimeout(() => {location.reload();}, 4000);
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
function deleteSuperUser(uaid){
	if(uaid!="NA"){
		$("#superUserUaid").val(uaid);
		$("#deleteSuperUserWarningMsg").modal("show");	
	}else{	
		$("#deleteSuperUserWarningMsg").modal("hide");
		uaid=$("#superUserUaid").val();
		showLoader();
		$.ajax({
			type : "GET",
			url : "DeleteSuperUserByUaid111",
			dataType : "HTML",
			data : {uaid:uaid},
			success : function(response){
				if(response=="pass"){
					document.getElementById('errorMsg1').innerHTML = 'Super User deleted Successfully !!';
					$('.alert-show1').show().delay(4000).fadeOut();
				}else if(response=="existClient"){
					$("#bodyId").html("Super User have Client, Please unmap first !!");
					$("#deleteSuperUserWarning").modal("show");
				}else if(response=="existContact"){
					$("#bodyId").html("Super User have Contact, Please unmap first !!");
					$("#deleteSuperUserWarning").modal("show");
				}else{
					document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
					$('.alert-show').show().delay(4000).fadeOut();
				}
			}
		});
		hideLoader();	
	}
}

</script>
</body>
</html>