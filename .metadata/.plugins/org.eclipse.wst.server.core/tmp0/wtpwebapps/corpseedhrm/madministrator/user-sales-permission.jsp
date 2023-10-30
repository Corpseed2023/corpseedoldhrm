<%@page import="admin.enquiry.Enquiry_ACT"%>
<%@page import="client_master.Clientmaster_ACT"%>
<%@page import="java.util.Properties"%>
<%@page import="admin.master.Usermaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Manage User Sales Permission</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%
String token= (String)session.getAttribute("uavalidtokenno");
String id=request.getParameter("id");
if(id==null||id.length()<=0)id="0";

%>
<%-- <%if(!AMU02){%><jsp:forward page="/login.html" /><%} %> --%>
<div id="content">
<div class="main-content">
<div class="container">
<div class="row mb30"> 
<div class="col-md-10 col-sm-10 col-xs-10"> 	
	<ul class="clearfix filter_menu">  
		<li class="active"><a href="<%=request.getContextPath()%>/user-sales-permission.html?id=<%=id%>">Sales</a></li>
		<li><a href="<%=request.getContextPath()%>/user-company-permission.html?id=<%=id%>">Company</a></li>	
	</ul>	
</div>
<div class="col-sm-2"><a data-toggle="modal" data-target="#addSalesPermission"><button type="button" class="filtermenu dropbtn btn-block">+&nbsp;Add Permission</button></a></div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
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
         <th>SN</th>
         <th>Invoice</th>
         <th>Project</th>
         <th>Service</th>
         <th width="100">Action</th>
     </tr>
 </thead>
 <tbody>
	 
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
  </tr>	 
 <%
 String[][] sales=Enquiry_ACT.findSalesUserPermission(id,token);
 if(sales!=null&&sales.length>0){
	for(int i=0;i<sales.length;i++){
%> 
     <tr>
         <td><%=(i+1) %></td>
         <td><%=sales[i][3] %></td>
         <td><%=sales[i][2] %></td>
         <td><%=sales[i][4] %></td>
         <td><a href="javascript:void(0);" onclick="removeSalesPermission('<%=sales[i][0] %>')">Remove</a></td>
     </tr>
  <%}} %>                       
    </tbody>
</table> 
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
<div class="myModal modal fade" id="addSalesPermission">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title"><i class="fas fa-lock" aria-hidden="true"></i> Sales Permission</h4>  
          <button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>    
        <form action="javascript:void(0)">
	        <div class="modal-body">
		    <div class="form-group">
				<label>Service</label>
		        <input type="search" class="form-control" placeholder="Service Name" id="ServiceName">
		        <input type="hidden" id="salesPermissionId">
		    </div>
	        </div>
	        <div class="modal-footer pad_box4">
	          <div class="mtop10">
		         <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
		         <button type="button" class="btn btn-primary" onclick="addSalesPermission()">Submit</button>
	          </div>
	        </div>
        </form>	
      </div>
    </div>
</div>
<div class="modal fade" id="removeSalesPermission" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="fas fa-trash" style="color: #c90000;margin-right: 10px;"></i>Are you sure, Want to remove this permission ?</h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <div class="modal-footer">
      <input type="hidden" id="permissionSalesId">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">OK</button>
        <button type="button" class="btn btn-danger" onclick="removeSalesPermission('NA')">Delete</button>
      </div>
    </div>
  </div>
</div>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
function removeSalesPermission(salesId){
	if(salesId!="NA"){
		$("#permissionSalesId").val(salesId);
		$("#removeSalesPermission").modal("show");
	}else{
		salesId=$("#permissionSalesId").val();
		$.ajax({
			type : "GET",
			url : "RemoveSalesPermission111",
			dataType : "HTML",
			data : {				
				salesId : salesId,
				id : <%=id%>
			},
			success : function(data){
				if(data=="pass"){
					$("#removeSalesPermission").modal("hide");
					document.getElementById('errorMsg1').innerHTML = 'Permission Removed Successfully !!';
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
}

$(function() {
	$("#ServiceName").autocomplete({
		source : function(request, response) {
			$.ajax({
				url : "GetClientSales111",
				type : "GET",
				dataType : "JSON",
				data : {
					name : request.term,
					id : <%=id%>,
					type : "sales"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value,		
							id : item.id		
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
        		$("#ServiceName").val("");  
        		$("#salesPermissionId").val("");
            }
            else{
            	$("#salesPermissionId").val(ui.item.id);     	          	
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});  
function addSalesPermission(){
	let salesName=$("#ServiceName").val().trim();
	let salesId=$("#salesPermissionId").val().trim();
	
	if(salesName==null||salesName==""||salesId==null||salesId==""){
		document.getElementById('errorMsg').innerHTML ="Please select service.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	
	$.ajax({
		type : "POST",
		url : "AddSalesPermission111",
		dataType : "HTML",
		data : {				
			salesId : salesId,
			"uaid" : <%=id%>,
			"type" : "sales"
		},
		success : function(data){
			console.log(data);
			if(data=="pass"){
				$("#addSalesPermission").modal("hide");
				document.getElementById('errorMsg1').innerHTML = 'Permission Added Successfully !!';
				$('.alert-show1').show().delay(4000).fadeOut();
				setTimeout(() => {location.reload();}, 4000);
			}else if(data=="exist"){
				document.getElementById('errorMsg').innerHTML = 'User already has permission. !!';
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
</script>
</body>
</html>