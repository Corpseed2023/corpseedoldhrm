
<!DOCTYPE HTML>
<%@page import="java.util.Properties"%>
<%@page import="commons.CommonHelper"%>
<%@page import="commons.DateUtil"%>
<%@page import="admin.task.TaskMaster_ACT"%>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Manage Product</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %> 
<%
String token = (String) session.getAttribute("uavalidtokenno");
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
String sort_url=domain+"manage-product.html?page="+pageNo+"&rows="+rows;

//pagination end
/* new */
String productDateRangeAction=(String)session.getAttribute("productDateRangeAction");
if(productDateRangeAction==null||productDateRangeAction.length()<=0)productDateRangeAction="NA";

String productIdAction=(String)session.getAttribute("productIdAction");
if(productIdAction==null||productIdAction.length()<=0)productIdAction="NA";

String productNameAction=(String)session.getAttribute("productNameAction");
if(productNameAction==null||productNameAction.length()<=0)productNameAction="NA";

int totalProduct=TaskMaster_ACT.getTotalProducts(productNameAction,productIdAction,productDateRangeAction,token);
int totalProductType=TaskMaster_ACT.getTotalProductType(token);

String toDate=DateUtil.getCurrentDateIndianReverseFormat();
String fromDate=DateUtil.getPrevDaysDate(30);

int recentlyAddedProduct=TaskMaster_ACT.getAllRecentlyAddedProduct(fromDate,toDate,token);
%>
<%if(!MPP00){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
<div class="main-content">
<div class="container-fluid">

<div class="box_shadow1 invoice_info redius_box pad_box4 bg_wht mb30 mtop10"> 
                        <div class="clearfix dashboard_info">
                          <div class="pad0 col-md-3 col-sm-3 col-xs-6">
                          <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:100px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div>
						   <div class="clearfix mlft20">
                            <h3><i class="fas fa-cart-plus"></i>
                            <%=CommonHelper.formatValue(totalProduct) %></h3>  
							<span>Total Product</span>
						   </div>
                          </div>
                          <div class="pad0 bdr_left col-md-3 col-sm-3 col-xs-6">
                          <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:100px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div>
						   <div class="clearfix mlft20">
                            <h3><i class="fab fa-buffer"></i>
                            <%=CommonHelper.formatValue(totalProductType) %> </h3>
							<span>Total Product Type</span>
                           </div>
						  </div>
                          <div class="pad0 bdr_left col-md-3 col-sm-3 col-xs-6">
                          <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:100px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div>
						   <div class="clearfix mlft20">
                            <h3><i class="fas fa-cart-arrow-down"></i>
                            <%=CommonHelper.formatValue(recentlyAddedProduct) %></h3>
							<span>Recently Added Products</span>
                           </div>
						  </div>
                          <div class="pad0 bdr_left col-md-3 col-sm-3 col-xs-6">
                          <div class="post" style="position:absolute;z-index:9">
                          <div class="avatar" style="width:100px;height:35px;float:none;margin: 2px;border-radius:15%"></div>
                          <div class="linee" style="margin-top: -1px;"></div>
                            </div>
						   <div class="clearfix mlft20">
                            <h3><i class="fas fa-luggage-cart"></i>
                            0</h3>
							<span>Trending Products</span>
                           </div>
						  </div>
                        </div> 
</div>

<div class="clearfix"> 
<form name="RefineSearchenqu" action="return false" method="Post">
<div class="bg_wht clearfix mb10" id="SearchOptions">  
<div class="row">
<div class="post" style="position:absolute;z-index:9">
                        <div class="linee" style="margin-top: -1px;width:1350px;height:50px"></div>
                            </div>
<div class="col-md-5 col-sm-5 col-xs-6"> 
<div class="col-sm-12 col-xs-12 dropdown">
<%if(MPP01){%><a href="<%=request.getContextPath()%>/add-product.html"><button type="button" class="filtermenu dropbtn" style="width: 110px;margin-left: -14px;">+&nbsp;New Product</button></a><%} %>
</div>
</div>
<a href="javascript:void(0)" class="doticon"> <i class="fa fa-filter" aria-hidden="true"></i>Filter</a>
<div class="filtermmenu">
<div class="col-md-7 col-sm-7 col-xs-12">
<div class="clearfix flex_box justify_end"> 
<div class="item-bestsell col-md-4 col-sm-4 col-xs-12"> 
<p><input type="search" name="productId" id="Product_Id" autocomplete="off" <%if(!productIdAction.equalsIgnoreCase("NA")){ %>onsearch="clearSession('productIdAction');location.reload()" value="<%=productIdAction%>"<%} %> placeholder="Product id.." class="form-control"/></p>
</div> 
<div class="item-bestsell col-md-4 col-sm-4 col-xs-12">
<p><input type="search" name="productname" id="ProductName" autocomplete="off" <% if(!productNameAction.equalsIgnoreCase("NA")){ %>onsearch="clearSession('productNameAction');location.reload()" value="<%=productNameAction%>"<%} %> placeholder="Product name.." class="form-control"/></p>
</div>
<div class="item-bestsell col-md-4 col-sm-4 col-xs-12 has-clear">
<p><input type="text" name="date_range" id="date_range" autocomplete="off" placeholder="FROM - TO" class="form-control text-center date_range pointers <%if(!productDateRangeAction.equalsIgnoreCase("NA")){ %>selected<%} %>"  readonly="readonly"/>
<span class="form-control-clear form-control-feedback" onclick="clearSession('productDateRangeAction');location.reload();"></span>
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
            <th class="sorting <%if(sort.equals("date")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','date','<%=order%>')">Date</th>
            <th class="sorting <%if(sort.equals("product_no")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','product_no','<%=order%>')">Product No.</th>
            <th class="sorting <%if(sort.equals("name")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','name','<%=order%>')">Name</th>
            <th width="120">Price</th>
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
    String[][] product=TaskMaster_ACT.getAllProducts(productNameAction,productIdAction,productDateRangeAction,token,pageNo,rows,sort,order);
  
    if(product!=null&&product.length>0){
    	ssn=rows*(pageNo-1);
  	  totalPages=(totalProduct/rows);
  	if((totalProduct%rows)!=0)totalPages+=1;
  	  showing=ssn+1;
  	  if (totalPages > 1) {     	 
  		  if((endRange-2)==totalPages)startRange=pageNo-4;        
            if(startRange==pageNo)endRange=pageNo+4;
            if(startRange<1) {startRange=1;endRange=startRange+4;}
            if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
            if(startRange<1)startRange=1;
       }else{startRange=0;endRange=0;}
    for(int i=0;i<product.length;i++){
    	double ppricegst[]=TaskMaster_ACT.getProductDetails(product[i][4],token);	
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
        <tr id="<%=product[i][4]%>">
            <td><input type="checkbox" name="checkbox" id="checkbox" class="checked"></td>
            <td><%=product[i][5] %></td>
            <td><%=product[i][3] %></td>
            <td><%=product[i][0] %></td>
            <td><i class="fa fa-inr"></i>&nbsp;<%=CommonHelper.withLargeIntegers(ppricegst[0]) %></td>
            <td>
            <a href="<%=request.getContextPath()%>/editproduct-<%=product[i][4]%>.html"><i class="fas fa-edit"></i>&nbsp;Edit</a>&nbsp;|&nbsp;
            <a href="#" onclick="deleteProduct('<%=product[i][4]%>')"><i class="fas fa-trash"></i>&nbsp;Delete</a>
            </td>            									
        </tr>
     <%}}%>
                           
    </tbody>
</table>
</div>
<div class="filtertable">
  <span>Showing <%=showing %> to <%=ssn+product.length %> of <%=totalProduct %> entries</span>
  <div class="pagination">
    <ul> <%if(pageNo>1){ %>
      <li class="page-item">	                     
      <a class="page-link text-primary" href="<%=request.getContextPath()%>/manage-product.html?page=1&rows=<%=rows%>">First</a>
   </li><%} %>
    <li class="page-item">					      
      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/manage-product.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
    </li>  
      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
	    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
	    <a class="page-link" href="<%=request.getContextPath()%>/manage-product.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
	    </li>   
	  <%} %>
	   <li class="page-item">						      
	      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/manage-product.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
	   </li><%if(pageNo<=(totalPages-1)){ %>
	   <li class="page-item">
	      <a class="page-link text-primary" href="<%=request.getContextPath()%>/manage-product.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
	   </li><%} %>
	</ul>
	</div>
	<select class="select2" onchange="changeRows(this.value,'manage-product.html?page=1','<%=domain%>')">
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
<section class="clearfix" id="manageProduct" style="display: none;">
<div class="clearfix  text-center">
<div class="col-md-12 col-xs-12" id="userid" style="display: none;"></div>
<div class="col-md-12 col-xs-12">
<div class="box-intro1">
  <h2><span class="title">Activate/Deactivate this Product?</span></h2>
</div>
</div>
<div class="col-md-12 col-xs-12 mb10">
<a class="sub-btn1" onclick="" id="cancelpopup">Cancel</a>

<a class="sub-btn1 mlft10" onclick="return approve(document.getElementById('userid').innerHTML,'1');" title="Activate This Product">Activate</a>
<a class="sub-btn1 mlft10" onclick="return approve(document.getElementById('userid').innerHTML,'0');" title="Deactivate This Product">Deactivate</a>
<a class="sub-btn1 mlft10" onclick="return deleteProduct(document.getElementById('userid').innerHTML);" title="Delete this Product">Delete</a>
</div>
</div>
</section>
<div class="modal fade" id="warningDeleteProduct" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title fas fa-exclamation-triangle text-danger" id="exampleModalLabel" style="padding-bottom: 6px;">&nbsp;&nbsp;Do you really want to delete this product ?</h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>   
      <input type="hidden" id="deleteProductStockId" value="NA">
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="deleteProductStock();">Yes</button>
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
            	<option value="p.pprodid">Product Id</option>
            	<option value="p.pname">Product Name</option>
            	<option value="SUM(pp.pp_total_price)">Product Price</option>
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
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>

<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">	
	$('#cancelpopup').click(function(){
		  $.fancybox.close();
	});
</script>
<script type="text/javascript">
function deleteProduct(prodKey){
	$("#deleteProductStockId").val(prodKey);
	$("#warningDeleteProduct").modal("show");
}
function deleteProductStock(){
	var prodKey=$("#deleteProductStockId").val();
	var xhttp;
	xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
	if (this.readyState == 4 && this.status == 200) {
	$("#"+prodKey).remove();
	}
	};
	xhttp.open("GET", "<%=request.getContextPath()%>/DeleteProductDb111?prodKey="+prodKey, true);
	xhttp.send();
}
</script>
<script type="text/javascript">
$(function() {
	$("#ProductName").autocomplete({
		source : function(request, response) {
			if(document.getElementById('ProductName').value.trim().length>=1)
			$.ajax({
				url : "getproduct.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field : "product_name"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.value,
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
            if(!ui.item){ }
            else{
            	doAction(ui.item.value,"productNameAction");
            	location.reload(true);
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

$(function() {
	$("#Product_Id").autocomplete({
		source : function(request, response) {
			if(document.getElementById('Product_Id').value.trim().length>=1)
			$.ajax({
				url : "getproduct.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field : "product_Id"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.value,
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
            if(!ui.item){ }
            else{
            	doAction(ui.item.value,"productIdAction");
            	location.reload(true);
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});
</script>
<!-- <script type="text/javascript">
var counter=25;
$(window).scroll(function () {
    if ($(window).scrollTop() == $(document).height() - $(window).height()) {
    	appendData();
    }
});

</script> -->
<script type="text/javascript">

function approve(id,status) {
	showLoader();
var xhttp;
xhttp = new XMLHttpRequest();
xhttp.onreadystatechange = function() {
if (this.readyState == 4 && this.status == 200) {
location.reload();
}
};
xhttp.open("GET", "<%=request.getContextPath()%>/DeleteProdut111?info="+id+"&status="+status, true);
xhttp.send();
hideLoader();
}

</script>
<script type="text/javascript">
$('.list_action_box').hover(function(){
	$(this).children().next().toggleClass("show");
}); 
</script>
<script type="text/javascript">
$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var data=$(this).val();
	doAction(data,"productDateRangeAction");
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
	   var dateRangeDoAction="<%=productDateRangeAction%>";
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
			type : "Product"
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