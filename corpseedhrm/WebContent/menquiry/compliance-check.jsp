<%@page import="admin.enquiry.Enquiry_ACT"%>
<%@page import="java.util.Properties"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/> 
	<title>Compliance-check</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	<%
	int pageNo=1;
	int rows=10;
	
	if(request.getParameter("page")!=null)pageNo=Integer.parseInt(request.getParameter("page"));
	if(request.getParameter("rows")!=null)rows=Integer.parseInt(request.getParameter("rows"));

	Properties properties = new Properties();
	properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
	String domain=properties.getProperty("domain");
	String token = (String)session.getAttribute("uavalidtokenno");
	String role=(String)session.getAttribute("userRole");
	if(role==null)role="NA";
	
// 	String sort_url=domain+"compliance-check.html?page="+pageNo+"&rows="+rows;
	String product=request.getParameter("product");
	String service=request.getParameter("service");
	
	if(product==null||product.length()<=0)product="NA";
	if(service==null||service.length()<=0)service="NA";
	
	%>
	<div id="content">		
		<div class="main-content">
			<div class="container">
			
<div class="clearfix"> 
<div class="bg_wht clearfix mb10" id="SearchOptions">  
<div class="row">
<div class="post" style="position:absolute;z-index:9">
                        <div class="linee" style="margin-top: -1px;width:1350px;height:50px"></div>
                            </div>
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix flex_box"> <%if(role.equalsIgnoreCase("Admin")){%>
<div class="col-sm-2 compliance1">
<button type="button" class="filtermenu addcompliance btn-block" data-related="add_compliance" onclick="openComplianceBox()">+&nbsp;Add new</button>
</div><%} %>
<form action="<%=request.getContextPath() %>/compliance-check.html" method="get" style="width:100%">
<div class="col-sm-6 compliance">
<input type="search" name="product" class="form-control" placeholder="Search for products.." autocomplete="off"
title="Type in a product" <%if(!product.equalsIgnoreCase("NA")){ %>value="<%=product%>"<%} %>>
<button type="submit"><i class="fa fa-search"></i></button>
</div>
<div class="col-sm-6 compliance">
<input type="search" name="service" class="form-control" placeholder="Search for services.." autocomplete="off"
title="Type in a service" <%if(!service.equalsIgnoreCase("NA")){ %>value="<%=service%>"<%} %>>
<button type="submit"><i class="fa fa-search"></i></button>
</div>
<input type="hidden" name="page" value="<%=pageNo%>"/>
<input type="hidden" name="rows" value="<%=rows%>"/>
</form>
</div>
</div>
</div>
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
						            <th><span class="hashico">#</span><input type="checkbox" class="pointers noDisplay" id="CheckAll"></th>
						            <th>Product Name</th>
						            <th>Service</th>
						            <th>Class/Intended use/ Indian Standard</th>
						            <th>Testing fee if applicable</th>
						            <th>Government fee</th>
						        </tr>
						    </thead>
						    <tbody>
						    <%int ssn=0;
						    
						    int startRange=pageNo-2;
						    int endRange=pageNo+2;
						    int totalPages=1;
						    int showing=0;
						    String pymtstatus="NA";
	                           String color="NA";
	                          String compliance[][]=null;
	                          int totalCompliance=0;
	                          if(!product.equalsIgnoreCase("NA")||!service.equalsIgnoreCase("NA")){
	                        	  compliance=Enquiry_ACT.getCompliance(product,service,pageNo,rows,token);
	                        	  totalCompliance=Enquiry_ACT.countCompliance(product,service,token);
	                          }
	                          
	                           if(compliance!=null&&compliance.length>0){	                        	   
	                        	   ssn=rows*(pageNo-1);
	                        	   showing=ssn+1;
	                        		  totalPages=(totalCompliance/rows);
	                        		  if((totalCompliance%rows)!=0)totalPages+=1;
	                        		  
	                        		  if (totalPages > 1) {     	 
	                        			  if((endRange-2)==totalPages)startRange=pageNo-4;        
	                        	          if(startRange==pageNo)endRange=pageNo+4;
	                        	          if(startRange<1) {startRange=1;endRange=startRange+4;}
	                        	          if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
	                        	          if(startRange<1)startRange=1;
	                        	     }else{startRange=0;endRange=0;}	                        	   
	                            for(int i=0;i<compliance.length;i++) {	                           				    
						    %>
						    <tr>
						    <td><%=(showing+i) %></td><%if(role.equalsIgnoreCase("Admin")){%>							    
						    <td><a href="javascript:void(0)" class="editcompliance" data-related="edit_compliance" onclick="updateComplianceBox('<%=compliance[i][1] %>')">
						    <%=compliance[i][2] %></a></td><%}else{ %>
						    <td><%=compliance[i][2] %></td>	
						    <%} %>
						    <td><%=compliance[i][3] %></td>	
						    <td><%=compliance[i][4] %></td>	
						    <td><%=compliance[i][5] %></td>	
						    <td><%=compliance[i][6] %></td>							   					    
						    </tr>
						   <%}}else{ %> 
							<tr>
							<td colspan="6" class="search_compliance"><img alt="" src="<%=request.getContextPath()%>/staticresources/images/0_glF20Ro3jzlUZtI8.webp"></td>
							</tr>
							<%} %>
														                                 
						    </tbody>
						</table>
						</div>	
						<div class="filtertable">
						  <span>Showing <%=(showing) %> to <%if(compliance!=null){%><%=ssn+compliance.length %><%}else{ %><%=ssn %><%} %> of <%=totalCompliance %> entries</span>
						  <div class="pagination">
						    <ul> <%if(pageNo>1){ %>
						      <li class="page-item">	                     
						      <a class="page-link text-primary" href="<%=request.getContextPath()%>/compliance-check.html?product=<%=product %>&service=<%=service %>&page=1&rows=<%=rows%>">First</a>
						   </li><%} %>
						    <li class="page-item">					      
						      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/compliance-check.html?product=<%=product %>&service=<%=service %>&page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
						    </li>  
						      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
							    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
							    <a class="page-link" href="<%=request.getContextPath()%>/compliance-check.html?product=<%=product %>&service=<%=service %>&page=<%=i %>&rows=<%=rows%>"><%=i %></a>
							    </li>   
							  <%} %>
							   <li class="page-item">						      
							      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/compliance-check.html?product=<%=product %>&service=<%=service %>&page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
							   </li><%if(pageNo<=(totalPages-1)){ %>
							   <li class="page-item">
							      <a class="page-link text-primary" href="<%=request.getContextPath()%>/compliance-check.html?product=<%=product %>&service=<%=service %>&page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
							   </li><%} %>
							</ul>
							</div>
							<select class="select2" onchange="changeRows(this.value,'compliance-check.html?product=<%=product %>&service=<%=service %>&page=1','<%=domain%>')">
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
<!-- right open start-->
<div class="clearfix add_inner_box pad_box4 addcompany" id="add_compliance">
<div class="close_icon close_box"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-fax"></i>New Compliance</h3>
<p>When someone reaches out to you, they become a contact in your account. You can create companies and associate contacts with them.</div>

<form onsubmit="return false;" id="FormComplianceBox">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="logo-footer3">
  <div class="input-group">
  <input type="text" name="productName" id="productName" onblur="isComplianceProductExist(this.value)" placeholder="Product name.." class="form-control bdrd4">
  </div>
 </div>
</div>
</div>
<div class="clearfix">
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <div class="input-group">
  <input type="text" name="serviceName" id="serviceName" placeholder="Service name" class="form-control bdrd4">
  </div>
 </div>
</div>
</div>
<div class="clearfix inner_box_bg">
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
 <label>Class/Intended use/ Indian Standard :</label>
  <div class="input-group">
  <textarea name="intendedUse" id="intendedUse" rows="3" placeholder="Class/Intended use/ Indian Standard.." class="form-control bdrd4"></textarea>
 </div>
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>Testing fee if applicable :</label>
  <div class="input-group">
  <textarea name="testingFee" id="testingFee" placeholder="Testing fee if applicable.." class="form-control bdrd4"></textarea>
  </div>
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>Government fee :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <textarea name="governmentFee" id="governmentFee" rows="3" placeholder="Government fee.." class="form-control bdrd4"></textarea>
  </div>
 </div>
</div>
</div>
<div class="clearfix mtop10 mb10 text-right">
<button class="bt-link bt-radius bt-gray mrt10 close_box" type="button">Cancel</button>
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateCompliance();">Submit</button>
</div>
</form>
</div>

<div class="clearfix add_inner_box pad_box4 addcompany" id="edit_compliance">
<div class="close_icon close_box"><i class="fa fa-times" style="font-size: 21px;"></i></div>
<div class="rttop_title">
<h3 style="color: #42b0da;"><i class="fa fa-fax"></i>Update Compliance</h3>
<p>When someone reaches out to you, they become a contact in your account. You can create companies and associate contacts with them.</div>

<form onsubmit="return false;" id="editFormComplianceBox">
<input type="hidden" id="editComplianceKey">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="logo-footer3">
  <div class="input-group">
  <input type="text" name="editProductName" id="editProductName" onblur="isEditComplianceProductExist(this.value)" placeholder="Product name.." class="form-control bdrd4">
  </div>
 </div>
</div>
</div>
<div class="clearfix">
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <div class="input-group">
  <input type="text" name="editServiceName" id="editServiceName" placeholder="Service name" class="form-control bdrd4">
  </div>
 </div>
</div>
</div>
<div class="clearfix inner_box_bg">
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
 <label>Class/Intended use/ Indian Standard :</label>
  <div class="input-group">
  <textarea name="editIntendedUse" id="editIntendedUse" rows="3" placeholder="Class/Intended use/ Indian Standard.." class="form-control bdrd4"></textarea>
 </div>
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>Testing fee if applicable :</label>
  <div class="input-group">
  <textarea name="editTestingFee" id="editTestingFee" placeholder="Testing fee if applicable.." class="form-control bdrd4"></textarea>
  </div>
 </div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
 <div class="form-group">
  <label>Government fee :<span style="color: #4ac4f3;">*</span></label>
  <div class="input-group">
  <textarea name="editGovernmentFee" id="editGovernmentFee" rows="3" placeholder="Government fee.." class="form-control bdrd4"></textarea>
  </div>
 </div>
</div>
</div>
<div class="clearfix mtop10 mb10 text-right">
<button class="bt-link bt-radius bt-gray mrt10 close_box" type="button">Cancel</button>
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateUpdateCompliance();">Submit</button>
</div>
</form>
</div>

<!-- right open end -->
</div>
<!-- Modal -->
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>	
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>

<script type="text/javascript">

function deleteTax(TaxId,DeleteRowid){
	var mtrefid=$('#'+TaxId).val();
	var rowid=$('#'+DeleteRowid).val();
	showLoader();
	$.ajax({
		type : "GET",
		url : "DeleteRegisterdTax111",
		dataType : "HTML",
		data : {				
			mtrefid : mtrefid
		},
		success : function(data){
			if(data=="pass"){	
				$("#warningDelete").modal('hide');
				location.reload(true);
// 				$("#"+rowid).load("managetax.html #"+rowid);
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

function validateUpdateCompliance(){ 
    
	var productName=$("#editProductName").val().trim();
	var serviceName=$("#editServiceName").val().trim();
	var intendedUse=$("#editIntendedUse").val().trim();
	var testingFee=$("#editTestingFee").val().trim();
	var governmentFee=$("#editGovernmentFee").val().trim();
	var ckey=$("#editComplianceKey").val().trim();
	
	if(productName==null||productName==""){
		document.getElementById('errorMsg').innerHTML ="Enter product name !!";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(serviceName==null||serviceName==""){
		document.getElementById('errorMsg').innerHTML ="Enter service name !!";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(intendedUse==null||intendedUse=="")intendedUse="NA";
	
	if(testingFee==null||testingFee=="")testingFee="NA";
	
	if(governmentFee==null||governmentFee=="")governmentFee="NA";
		
	showLoader();
	$.ajax({
		type : "POST",
		url : "AddNewCompliance111",
		dataType : "HTML",
		data : {				
			productName : productName,
			serviceName : serviceName,
			intendedUse : intendedUse,
			testingFee : testingFee,
			governmentFee : governmentFee,
			ckey : ckey
		},
		success : function(data){
			if(data=="pass"){	
				document.getElementById('errorMsg1').innerHTML = 'Successfully updated !!';
				$('.alert-show1').show().delay(4000).fadeOut();
				$('.fixed_right_box').removeClass('active');
				$('.addnew').show();
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

function validateCompliance(){ 
	    
	var productName=$("#productName").val().trim();
	var serviceName=$("#serviceName").val().trim();
	var intendedUse=$("#intendedUse").val().trim();
	var testingFee=$("#testingFee").val().trim();
	var governmentFee=$("#governmentFee").val().trim();
	
	if(productName==null||productName==""){
		document.getElementById('errorMsg').innerHTML ="Enter product name !!";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(serviceName==null||serviceName==""){
		document.getElementById('errorMsg').innerHTML ="Enter service name !!";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(intendedUse==null||intendedUse=="")intendedUse="NA";
	
	if(testingFee==null||testingFee=="")testingFee="NA";
	
	if(governmentFee==null||governmentFee=="")governmentFee="NA";
		
	showLoader();
	$.ajax({
		type : "POST",
		url : "AddNewCompliance111",
		dataType : "HTML",
		data : {				
			productName : productName,
			serviceName : serviceName,
			intendedUse : intendedUse,
			testingFee : testingFee,
			governmentFee : governmentFee,
			ckey : "NA"
		},
		success : function(data){
			if(data=="pass"){	
				document.getElementById('errorMsg1').innerHTML = 'Successfully added !!';
				$('.alert-show1').show().delay(4000).fadeOut();
				$('.fixed_right_box').removeClass('active');
				$('.addnew').show();
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


$('.close_icon_btn').click(function(){
	$('.notify_box').hide();
});
$('.close_box').on( "click", function(e) { 
	$('.fixed_right_box').removeClass('active');
	$('.addnew').show();	
	});
function openComplianceBox(){	
	$('#FormComplianceBox').trigger("reset");
	var id = $(".addcompliance").attr('data-related'); 
	$(id).hide();
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });	
}
function updateComplianceBox(ckey){	
	$('#editFormComplianceBox').trigger("reset");
	var id = $(".editcompliance").attr('data-related'); 
	$(id).hide();
	fillComplianceDetails(ckey);
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });	
}

function isEditComplianceProductExist(data){	
	showLoader();
	var ckey=$("#editComplianceKey").val();
	if(data!="")
	$.ajax({
		type : "GET",
		url : "IsComplianceExist111",
		dataType : "HTML",
		data : {				
			data : data,
			ckey : ckey
		},
		success : function(response){
			if(response=="pass"){	
				document.getElementById('errorMsg').innerHTML = data+' already existed !!';
				$("#editProductName").val("");
				$('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function(response){
			hideLoader();
		}
	});
}

function isComplianceProductExist(data){
	showLoader();
	if(data!="")
	$.ajax({
		type : "GET",
		url : "IsComplianceExist111",
		dataType : "HTML",
		data : {				
			data : data,
			ckey : "NA"
		},
		success : function(response){
			if(response=="pass"){	
				document.getElementById('errorMsg').innerHTML = data+' already existed !!';
				$("#productName").val("");
				$('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function(response){
			hideLoader();
		}
	});
}
function fillComplianceDetails(ckey){
	showLoader();
	$.ajax({
		type : "GET",
		url : "GetComplianceByKey111",
		dataType : "HTML",
		data : {				
			ckey : ckey
		},
		success : function(response){		
		if(Object.keys(response).length!=0){
		response = JSON.parse(response);			
		 var len = response.length;		 
		 if(len>0){
		 	var uuid=response[0]["uuid"];
			var product_name=response[0]["product_name"];
			var service_name=response[0]["service_name"];
			var indended_use=response[0]["indended_use"];
			var testing_fee=response[0]["testing_fee"];
			var government_fee=response[0]["government_fee"];
			     
			$("#editComplianceKey").val(uuid);
			$("#editProductName").val(product_name);
			$("#editServiceName").val(service_name);
			$("#editIntendedUse").val(indended_use);
			$("#editTestingFee").val(testing_fee);
			$("#editGovernmentFee").val(government_fee);
		 }}
		},
		complete : function(data){
			hideLoader();
		}
	});
}
</script>
</body>
</html>