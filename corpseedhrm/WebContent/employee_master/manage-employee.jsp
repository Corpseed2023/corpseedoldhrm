<%@page import="java.util.Properties"%>
<%@page import="employee_master.Employee_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Manage Employees</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%
String role=(String)session.getAttribute("emproleid");
String token=(String)session.getAttribute("uavalidtokenno");
String name= (String)session.getAttribute("mename");
String mobile= (String)session.getAttribute("memobile");
String email= (String)session.getAttribute("meemail");

if(name==null||name.length()<=0)name="NA";
if(mobile==null||mobile.length()<=0)mobile="NA";
if(email==null||email.length()<=0)email="NA";


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
String sort_url=domain+"manage-employee.html?page="+pageNo+"&rows="+rows;
 
String[][] allEmployee= Employee_ACT.getAllEmployee(token,name, mobile, email,role,pageNo,rows,sort,order);
int totalEmployee=Employee_ACT.countAllEmployee(token,name, mobile, email,role);
%>

<%if(!ME00){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
<div class="main-content">
<div class="container-fluid">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="partner-slider8">

<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="top_title text-center">
<h2>Manage Employees</h2>
</div>
<%if(RE00){%><a class="add_btn sub-btn1" href="<%=request.getContextPath() %>/register-employee.html">Register Employee</a><%} %>
</div>
</div>


<div class="home-search-form clearfix">
<form action="return false" method="post">
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-user"></i></span>
<input type="search" name="name" autocomplete="off" id="name" placeholder="Employee Name" class="form-control" <% if(!name.equalsIgnoreCase("NA")){ %>value="<%=name%>" onsearch="clearSession('mename')"<%}%>>
</div>
</div>
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-mobile"></i></span>
<input type="search" name="mobile" autocomplete="off" id="mobile" placeholder="Mobile" class="form-control" <% if(!mobile.equalsIgnoreCase("NA")){ %>value="<%=mobile%>" onsearch="clearSession('memobile')"<%}%>>
</div>
</div>
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-at"></i></span>
<input type="search" name="email" autocomplete="off" id="email" placeholder="Email" class="form-control" <% if(!email.equalsIgnoreCase("NA")){ %>value="<%=email%>" onsearch="clearSession('meemail')"<%}%>>
</div>
</div>
<%-- <div class="item-bestsell col-md-2 col-sm-3 col-xs-12">
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-calendar"></i></span>
<input type="text" name="from" autocomplete="off" id="from" placeholder="From" class="form-control readonlyAllow searchdate" <% if(from!=null){ %>value="<%=from%>"<%}%> readonly="readonly">
</div>
</div>
<div class="item-bestsell col-md-2 col-sm-3 col-xs-12">
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-calendar"></i></span>
<input type="text" name="to" autocomplete="off" id="to" placeholder="To" class="form-control readonlyAllow searchdate" <% if(to!=null){ %>value="<%=to%>"<%}%> readonly="readonly">
</div>
</div> --%>
</form>
</div>
<%@ include file="../staticresources/includes/skelton.jsp" %>  

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
         <th class="sorting <%if(sort.equals("empid")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','empid','<%=order%>')">Employee Id</th>
         <th class="sorting <%if(sort.equals("dept")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','dept','<%=order%>')">Department</th>
         <th class="sorting <%if(sort.equals("name")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','name','<%=order%>')">Name</th>
         <th class="sorting <%if(sort.equals("joining")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','joining','<%=order%>')">Joining Date</th>
         <th class="sorting <%if(sort.equals("address")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','address','<%=order%>')">Address</th>
         <th class="sorting <%if(sort.equals("phone")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','phone','<%=order%>')">Phone</th>
         <th class="sorting <%if(sort.equals("email")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','email','<%=order%>')">Email</th>
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
 if(allEmployee!=null&&allEmployee.length>0){
	 ssn=rows*(pageNo-1);
	  totalPages=(totalEmployee/rows);
	  if((totalEmployee%rows)!=0)totalPages+=1;
	  showing=ssn+1;
	  if (totalPages > 1) {     	 
		  if((endRange-2)==totalPages)startRange=pageNo-4;        
         if(startRange==pageNo)endRange=pageNo+4;
         if(startRange<1) {startRange=1;endRange=startRange+4;}
         if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
         if(startRange<1)startRange=1;
    }else{startRange=0;endRange=0;}
	 for(int i=0;i<allEmployee.length;i++){%>
	 
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
	 
     <tr <% if(allEmployee[i][11].equalsIgnoreCase("0")){%>style="background-color: #4a6182;color:#fff; "<%}%>>
         <td><%=(showing+i) %></td>
         <td><%=allEmployee[i][9] %></td>
         <td><%=allEmployee[i][8] %></td>
         <td><%=allEmployee[i][1] %></td>
         <td><%=allEmployee[i][7] %></td>
         <td><%=allEmployee[i][6] %></td>
         <td><%=allEmployee[i][3] %></td>
         <td><%=allEmployee[i][4] %></td>
         <td>
         	<%if(ME01){ %><a class="fancybox" href="<%=request.getContextPath() %>/viewemployee-<%=allEmployee[i][0] %>.html"><i class="fa fa-eye" title="view"></i></a><%} %>
			<%if(ME02){ %><a href="javascript:void(0);" onclick="vieweditpage(<%=allEmployee[i][0] %>,'edit');"><i class="fa fa-edit" title="Edit"></i></a><%} %>
			<%-- <a href="javascript:void(0);" onclick="vieweditpage(<%=allEmployee[i][0] %>,'upload');"><i class="fa fa-upload" title="upload document"></i></a> --%>
			<%if(ME03||ME04){ %><a class="quick-view" href="#manageemployee" onclick="document.getElementById('userid').innerHTML='<%=allEmployee[i][0] %>';document.getElementById('emuid').innerHTML='<%=allEmployee[i][9] %>';document.getElementById('token').innerHTML='<%=allEmployee[i][10] %>'"> <i class="fa fa-trash" title="Activate/Deactivate this Employee"></i></a><%} %>
         </td>
     </tr>
  <%}}%>                           
    </tbody>
</table> 
</div>
<div class="filtertable">
  <span>Showing <%=showing %> to <%=ssn+allEmployee.length %> of <%=totalEmployee %> entries</span>
  <div class="pagination">
    <ul> <%if(pageNo>1){ %>
      <li class="page-item">	                     
      <a class="page-link text-primary" href="<%=request.getContextPath()%>/manage-employee.html?page=1&rows=<%=rows%>">First</a>
   </li><%} %>
    <li class="page-item">					      
      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/manage-employee.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
    </li>  
      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
	    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
	    <a class="page-link" href="<%=request.getContextPath()%>/manage-employee.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
	    </li>   
	  <%} %>
	   <li class="page-item">						      
	      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/manage-employee.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
	   </li><%if(pageNo<=(totalPages-1)){ %>
	   <li class="page-item">
	      <a class="page-link text-primary" href="<%=request.getContextPath()%>/manage-employee.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
	   </li><%} %>
	</ul>
	</div>
	<select class="select2" onchange="changeRows(this.value,'manage-employee.html?page=1','<%=domain%>')">
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

<section class="clearfix" id="manageemployee" style="display: none;">
<div class="clearfix  text-center">
<div class="col-md-12 col-xs-12" id="userid" style="display: none;"></div>
<div class="col-md-12 col-xs-12" id="emuid" style="display: none;"></div>
<div class="col-md-12 col-xs-12" id="token" style="display: none;"></div>
<div class="col-md-12 col-xs-12">
<div class="box-intro1">
<h2><span class="title">Activate/Deactivate/Delete this Employee ?</span></h2>
</div>
</div>
<div class="col-md-12 col-xs-12 mb10">
<a class="sub-btn1" onclick="" id="cancelpopup">Cancel</a>
<%if(ME03){ %><a class="sub-btn1 mlft10" onclick="return approve(document.getElementById('userid').innerHTML,'1',document.getElementById('emuid').innerHTML,document.getElementById('token').innerHTML);" title="Activate this employee">Activate</a>
<a class="sub-btn1 mlft10" id="" onclick="return approve(document.getElementById('userid').innerHTML,'0',document.getElementById('emuid').innerHTML,document.getElementById('token').innerHTML);" title="Deactivate this employee">Deactivate</a><%} %>
<%if(ME04){ %><a class="sub-btn1 mlft10" id="" onclick="" title="Delete this employee">Delete</a><%} %>
</div>
</div>
</section>

<p id="end" style="display: none;"></p>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div></div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
$(function() {
	$("#name").autocomplete({
		source : function(request, response) {
			if(document.getElementById('name').value.trim().length>=1)
			$.ajax({
				url : "get-employee.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field :"ManageEmployee",
					col :"emname"
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
        		
            	$("#name").val("");     	
            }
            else{
            	doAction(ui.item.value,"mename");
            	location.reload();    
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

$(function() {
	$("#email").autocomplete({
		source : function(request, response) {
			if(document.getElementById('email').value.trim().length>=2)
			$.ajax({
				url : "get-employee.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field :"ManageEmployee",
					col :"ememail"
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
        		
            	$("#email").val("");     	
            }
            else{
            	doAction(ui.item.value,"meemail");
            	location.reload();
            	
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

$(function() {
	$("#mobile").autocomplete({
		source : function(request, response) {
			if(document.getElementById('mobile').value.trim().length>=2)
			$.ajax({
				url : "get-employee.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field :"ManageEmployee",
					col :"emmobile"
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
        		
            	$("#mobile").val("");     	
            }
            else{
            	doAction(ui.item.value,"memobile");
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
$(".fancybox").fancybox({
    'width'             : '100%',
    'height'            : '100%',
    'autoScale'         : false,
    'transitionIn'      : 'none',
    'transitionOut'     : 'none',
    'type'              : 'iframe',
    'hideOnOverlayClick': false,
    afterClose: function () {    
    	parent.location.reload(true);
    }
});


function approve(id,status,emuid,token) {
	showLoader();
var xhttp;
xhttp = new XMLHttpRequest();
xhttp.onreadystatechange = function() {
if (this.readyState == 4 && this.status == 200) {
location.reload();
}
};
xhttp.open("GET", "<%=request.getContextPath()%>/DeleteEmployee111?info="+id+"&status="+status+"&emuid="+emuid+"&token="+token, true);
xhttp.send();
hideLoader();
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
<%--         	if(page=="view") window.location = "<%=request.getContextPath()%>/viewemployee.html"; --%>
        	if(page=="edit") window.location = "<%=request.getContextPath()%>/editemployee.html";
<%--         	else if(page=="upload") window.location = "<%=request.getContextPath()%>/uploaddocuments-employee.html"; --%>
        },
        complete : function(data){
			hideLoader();
		}
	});
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
</script>
<script type="text/javascript">	
	$('#cancelpopup').click(function(){
		  $.fancybox.close();
	});
</script>
</body>
</html>