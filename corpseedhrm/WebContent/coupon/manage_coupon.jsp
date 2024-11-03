<%@page import="java.util.Properties"%>
<%@page import="commons.CommonHelper"%>
<%@page import="commons.DateUtil"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/> 
	<title>Manage Coupon</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %> 
	<%
	String token=(String)session.getAttribute("uavalidtokenno");
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
	String sort_url=domain+"managecoupon.html?page="+pageNo+"&rows="+rows;

	//pagination end
%>
<%-- <%if(!MCO0){%><jsp:forward page="/login.html" /><%} %> --%>
	<div id="content">
		<div class="main-content">
			<div class="container">		
				
				
<div class="clearfix"> 
<form name="RefineSearchenqu" action="return false" method="Post">
<div class="bg_wht clearfix mb10" id="SearchOptions">  
<div class="row">
<div class="post" style="position:absolute;z-index:9">
                        <div class="linee" style="margin-top: -1px;width:1350px;height:50px"></div>
                            </div>
<div class="col-md-7 col-sm-7 col-xs-9"> 
<div class="row col-md-12 dropdown">
<a href="<%=request.getContextPath()%>/addcoupon.html"><button type="button" class="filtermenu addcontact" data-related="add_contact">+&nbsp;New Coupon</button></a>
</div>
</div>
<a href="javascript:void(0)" class="doticon"> <i class="fa fa-filter" aria-hidden="true"></i>Filter</a>
<div class="filtermmenu">
<div class="col-md-5 col-sm-5 col-xs-12">
<div class="clearfix">  
<div class="item-bestsell col-md-6 col-sm-6 col-xs-12">
<p><input type="search" name="couponName" id="CouponName" autocomplete="off" value=""  placeholder="Search by coupon name.." class="form-control"/></p>
</div> 
<div class="item-bestsell col-md-6 col-sm-6 col-xs-12 has-clear">
<p><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="FROM - TO" class="form-control text-center date_range pointers"  readonly="readonly"/>
<span class="form-control-clear form-control-feedback"></span>
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
						            <th class="sorting <%if(sort.equals("title")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','title','<%=order%>')">Title</th>
						            <th class="sorting <%if(sort.equals("value")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','value','<%=order%>')">Value</th>
						            <th class="sorting <%if(sort.equals("type")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','type','<%=order%>')">Type</th>
						            <th class="sorting <%if(sort.equals("validity")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','validity','<%=order%>')">Validity</th>
						            <th class="sorting <%if(sort.equals("service_type")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','service_type','<%=order%>')">Service Type</th>
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
						    String[][] coupons=TaskMaster_ACT.getAllCoupons(token,pageNo,rows,sort,order); 
						    int totalCoupon=TaskMaster_ACT.countAllCoupons(token); 
                            if(coupons!=null&&coupons.length>0){
                            	ssn=rows*(pageNo-1);
                          	  totalPages=(totalCoupon/rows);
                          	  if((totalCoupon%rows)!=0)totalPages+=1;
                          	  showing=ssn+1;
                          	  if (totalPages > 1) {     	 
                          		  if((endRange-2)==totalPages)startRange=pageNo-4;        
                                    if(startRange==pageNo)endRange=pageNo+4;
                                    if(startRange<1) {startRange=1;endRange=startRange+4;}
                                    if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
                                    if(startRange<1)startRange=1;
                               }else{startRange=0;endRange=0;}
                             for(int i=0;i<coupons.length;i++) {
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
						            <td><%=coupons[i][2] %></td>
						            <td><%=CommonHelper.withLargeIntegers(Double.parseDouble(coupons[i][3])) %></td>
						            <td><%=coupons[i][4] %></td>
						            <td><%=coupons[i][5] %> - <%=coupons[i][6] %></td>
						            <td><%=coupons[i][13] %></td>
						            <td><%if(coupons[i][14].equals("2")){%>
                                    <a href="<%=request.getContextPath() %>/updatecoupon.html?uuid=<%=coupons[i][1]%>" class="pointers"><i class="fas fa-edit" title="Edit"></i></a>&nbsp;
                                    <a href="javascript:void(0)" class="pointers" onclick="deleteCoupon('<%=coupons[i][1]%>')"><i class="fas fa-trash" title="Delete"></i></a>
                                    <%} %></td>									
						        </tr>
						     <%}}%>
                                 
						    </tbody>
						</table>
						</div>
						<div class="filtertable">
  <span>Showing <%=showing %> to <%=ssn+coupons.length %> of <%=totalCoupon %> entries</span>
  <div class="pagination">
    <ul> <%if(pageNo>1){ %>
      <li class="page-item">	                     
      <a class="page-link text-primary" href="<%=request.getContextPath()%>/managecoupon.html?page=1&rows=<%=rows%>">First</a>
   </li><%} %>
    <li class="page-item">					      
      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/managecoupon.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
    </li>  
      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
	    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
	    <a class="page-link" href="<%=request.getContextPath()%>/managecoupon.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
	    </li>   
	  <%} %>
	   <li class="page-item">						      
	      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/managecoupon.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
	   </li><%if(pageNo<=(totalPages-1)){ %>
	   <li class="page-item">
	      <a class="page-link text-primary" href="<%=request.getContextPath()%>/managecoupon.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
	   </li><%} %>
	</ul>
	</div>
	<select class="select2" onchange="changeRows(this.value,'managecoupon.html?page=1','<%=domain%>')">
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
	<div class="modal fade" id="warningDelete" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="delete">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;"><span class="fa fa-exclamation-triangle" style="color: #ece521;margin-right: 10px;"> </span><span class="text-danger">Are you sure,want to delete coupon ??</span></h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <input type="hidden" id="DeleteCouponUuid">
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" >No</button>
        <button type="button" class="btn btn-secondary" onclick="deleteCoupon('NA')">Yes</button>
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
            	<option value="title">Title</option>
            	<option value="value">Value</option>
            	<option value="type">Type</option>
            	<option value="startDate,endDate">Validity</option>
            	<option value="service_type">Service Type</option>
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
	<p id="end" style="display:none;"></p>
	</div>
<div class="noDisplay"><a href="" id="DownloadExportedLink" download><button id="DownloadExported">Download</button></a></div>
	<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>	
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>

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
function deleteCoupon(data){
	if(data=="NA"){
		var uuid=$("#DeleteCouponUuid").val();
		showLoader();
		$.ajax({
		    type: "GET",
		    url: "DeleteAdminCoupon111",
		    data:  { 
		    	uuid : uuid
		    },
		    success: function (response) {
		    	$("#warningDelete").modal("hide");
		    	location.reload(true);		    	
	        },
			complete : function(data){
				hideLoader();
			}
		});
	}else{
		$("#warningDelete").modal("show");
		$("#DeleteCouponUuid").val(data);
	}
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
			type : "Coupon"
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