<%@page import="java.util.Properties"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/> 
	<title>Manage Tax</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	<%if(!MTX0){%><jsp:forward page="/login.html" /><%} %>
	<%
	String token= (String)session.getAttribute("uavalidtokenno");
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
	String sort_url=domain+"managetax.html?page="+pageNo+"&rows="+rows;

	//pagination end
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
<div class="clearfix flex_box justify_end"> 
<button class="btn-link-default bt-radius" data-toggle="modal" data-target="#TaxModal" style="text-transform: none;" type="button" name="button" onclick="$('#RegisterNewTaxForm').trigger('reset')">Create a Tax</button>
</div>
</div>
</div>
</div>
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
						            <th class="sorting <%if(sort.equals("hsn")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','hsn','<%=order%>')">HSN</th>
						            <th class="sorting <%if(sort.equals("cgst")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','cgst','<%=order%>')">CGST (%)</th>
						            <th class="sorting <%if(sort.equals("sgst")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','sgst','<%=order%>')">SGST (%)</th>
						            <th class="sorting <%if(sort.equals("igst")){ %><%=sorting_order%><%} %>" onclick="sortBy('<%=sort_url%>','igst','<%=order%>')">IGST (%)</th>
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
						    String saleTax[][]=TaskMaster_ACT.getAllSaleTax(token,"NA",pageNo,rows,sort,order);
						    int totalTaxes=TaskMaster_ACT.countAllSaleTax(token,"NA");
	                           if(saleTax!=null&&saleTax.length>0){
	                        	   ssn=rows*(pageNo-1);
	                        		  totalPages=(totalTaxes/rows);
	                        		  if((totalTaxes%rows)!=0)totalPages+=1;
	                        		  showing=ssn+1;
	                        		  if (totalPages > 1) {     	 
	                        			  if((endRange-2)==totalPages)startRange=pageNo-4;        
	                        	          if(startRange==pageNo)endRange=pageNo+4;
	                        	          if(startRange<1) {startRange=1;endRange=startRange+4;}
	                        	          if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
	                        	          if(startRange<1)startRange=1;
	                        	     }else{startRange=0;endRange=0;}
	                        	   for(int i=0;i<saleTax.length;i++){
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
						            <td><%=saleTax[i][1] %></td>
						            <td><%=saleTax[i][3] %></td>
						            <td><%=saleTax[i][2] %></td>
						            <td><%=saleTax[i][4] %></td>
						            <td>
						            <i class="fas fa-edit pointers" style="margin-right: 10px;" data-toggle="modal" data-target="#EditTaxModal" onclick="setDivId('<%=saleTax[i][0] %>','Row<%=i+1%>','<%=saleTax[i][1] %>','<%=saleTax[i][3] %>','<%=saleTax[i][2] %>','<%=saleTax[i][4] %>','<%=saleTax[i][5] %>')">&nbsp;Edit</i>
									<i class="fas fa-trash pointers" data-toggle="modal" data-target="#warningDelete" onclick="$('#DeleteRefid').val('<%=saleTax[i][0] %>');$('#DeleteRowid').val('Row<%=i+1%>');">&nbsp;Delete</i>
						            </td>									
						        </tr>
						     <%}}%>
                                 
						    </tbody>
						</table>
						</div>
						<div class="filtertable">
						  <span>Showing <%=showing %> to <%=ssn+saleTax.length %> of <%=totalTaxes %> entries</span>
						  <div class="pagination">
						    <ul> <%if(pageNo>1){ %>
						      <li class="page-item">	                     
						      <a class="page-link text-primary" href="<%=request.getContextPath()%>/managetax.html?page=1&rows=<%=rows%>">First</a>
						   </li><%} %>
						    <li class="page-item">					      
						      <a class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>" <%if(pageNo>1){ %>href="<%=request.getContextPath()%>/managetax.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Previous</a>
						    </li>  
						      <%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>        
							    <li class="page-item <%if(pageNo==i){ %>active<%}%>">
							    <a class="page-link" href="<%=request.getContextPath()%>/managetax.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
							    </li>   
							  <%} %>
							   <li class="page-item">						      
							      <a class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>" <%if(pageNo!=totalPages){ %>href="<%=request.getContextPath()%>/managetax.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"<%}else{ %>href="javascript:void(0)"<%} %>>Next</a>
							   </li><%if(pageNo<=(totalPages-1)){ %>
							   <li class="page-item">
							      <a class="page-link text-primary" href="<%=request.getContextPath()%>/managetax.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
							   </li><%} %>
							</ul>
							</div>
							<select class="select2" onchange="changeRows(this.value,'managetax.html?page=1','<%=domain%>')">
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

<!-- Modal -->
<div class="modal fade" id="EditTaxModal" tabindex="-1" role="dialog" aria-labelledby="EditTaxModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
  <form onsubmit="return false" id="RegisterEditTaxForm">
  <input type="hidden" id="KeyIdForm"/>
  <input type="hidden" id="RowIdDiv"/>
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Update this sale tax</h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <div class="col-md-12 col-sm-12 col-xs-12">
		<div class="form-group">
		<label>HSN</label>
		<div class="input-group">
		<input type="text" name="" autocomplete="off" id="EditHSNCode" placeholder="HSN Code" class="form-control" readonly="readonly">
		</div>
		</div>
		</div>
        <div class="col-md-12 col-sm-12 col-xs-12">
		<div class="form-group">
		<label>CGST % Rate</label>
		<div class="input-group">
		<input type="text" name="" autocomplete="off" id="EditCGSTRate" placeholder="CGST % to be deducted" class="form-control" onkeypress="return isNumberKey(event)">
		</div>
		</div>
		</div>
		<div class="col-md-12 col-sm-12 col-xs-12">
		<div class="form-group">
		<label>SGST % Rate</label>
		<div class="input-group">
		<input type="text" name="" autocomplete="off" id="EditSGSTRate" placeholder="CGST % to be deducted" class="form-control" onkeypress="return isNumberKey(event)">
		</div>
		</div>
		</div>
		<div class="col-md-12 col-sm-12 col-xs-12">
		<div class="form-group">
		<label>IGST % Rate</label>
		<div class="input-group">
		<input type="text" name="" autocomplete="off" id="EditIGSTRate" placeholder="IGST % to be deducted" class="form-control" onkeypress="return isNumberKey(event)">
		</div>
		</div>
		</div>
		<div class="col-md-12 col-sm-12 col-xs-12">
		<div class="form-group">
		<label>Additional description</label>
		<div class="input-group">
		 <textarea class="form-control" autocomplete="off" rows="3" name="expensenote" id="EditTaxNote" placeholder="Additional description" onblur="validateLocationPopup('TaxNote');validateValuePopup('TaxNote');"></textarea>
		</div>
		</div>
		</div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-primary" onclick="return validateEditTax('KeyIdForm','RowIdDiv')">Update</button>
      </div>
    </div>
    </form>
  </div>
</div>
<div class="modal fade" id="TaxModal" tabindex="-1" role="dialog" aria-labelledby="TaxModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
  <form onsubmit="return false" id="RegisterNewTaxForm">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Create a sale tax</h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <div class="col-md-12 col-sm-12 col-xs-12">
		<div class="form-group">
		<label>HSN</label>
		<div class="input-group">
		<input type="text" name="" onchange="isExistValue('HSNCode')" autocomplete="off" id="HSNCode" placeholder="HSN Code" class="form-control">
		</div>
		</div>
		</div>
        <div class="col-md-12 col-sm-12 col-xs-12">
		<div class="form-group">
		<label>CGST % Rate</label>
		<div class="input-group">
		<input type="text" name="" autocomplete="off" id="CGSTRate" placeholder="CGST % to be deducted" class="form-control" onkeypress="return isNumberKey(event)">
		</div>
		</div>
		</div>
		<div class="col-md-12 col-sm-12 col-xs-12">
		<div class="form-group">
		<label>SGST % Rate</label>
		<div class="input-group">
		<input type="text" name="" autocomplete="off" id="SGSTRate" placeholder="CGST % to be deducted" class="form-control" onkeypress="return isNumberKey(event)">
		</div>
		</div>
		</div>
		<div class="col-md-12 col-sm-12 col-xs-12">
		<div class="form-group">
		<label>IGST % Rate</label>
		<div class="input-group">
		<input type="text" name="" autocomplete="off" id="IGSTRate" placeholder="IGST % to be deducted" class="form-control" onkeypress="return isNumberKey(event)">
		</div>
		</div>
		</div>
		<div class="col-md-12 col-sm-12 col-xs-12">
		<div class="form-group">
		<label>Additional description</label>
		<div class="input-group">
		 <textarea class="form-control" autocomplete="off" rows="3" name="expensenote" id="TaxNote" placeholder="Additional description" onblur="validateValuePopup('TaxNote');"></textarea>
		</div>
		</div>
		</div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-primary" onclick="return validateTax()">Submit</button>
      </div>
    </div>
    </form>
  </div>
</div>
<div class="modal fade" id="warningDelete" tabindex="-1" role="dialog" aria-labelledby="deleteModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="delete">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="padding-bottom: 6px;">Do you really want to delete this sale tax ?</h5>
        <button type="button" class="closeBox" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
      <div class="modal-footer">
      <input type="hidden" id="DeleteRefid"/>
      <input type="hidden" id="DeleteRowid"/>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="deleteTax('DeleteRefid','DeleteRowid')">Yes</button>
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
            	<option value="mthsncode">HSN</option>
            	<option value="mtcgstpercent">CGST %</option>
            	<option value="mtsgstpercent">SGST %</option>
            	<option value="mtigstpercent">IGST %</option>
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
</div>	
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>

<script type="text/javascript">
function isExistValue(textboxid){
	var val=$("#"+textboxid).val();
	showLoader();
	$.ajax({
		type : "GET",
		url : "IsExistSaleHSN111",
		dataType : "HTML",
		data : {				
			val : val
		},
		success : function(data){
			if(data=="pass"){	
				document.getElementById('errorMsg').innerHTML = val+' already existed !!';
				$("#"+textboxid).val("");
				$('.alert-show').show().delay(3000).fadeOut();
			}
		},
		complete : function(data){
			hideLoader();
		}
	});
}
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
function setDivId(key,rowid,hsn,cgst,sgst,igst,notes){
	$('#KeyIdForm').val(key);
	$('#RowIdDiv').val(rowid);
	$('#EditHSNCode').val(hsn);
	$('#EditCGSTRate').val(cgst);
	$('#EditSGSTRate').val(sgst);
	$('#EditIGSTRate').val(igst);
	$('#EditTaxNote').val(notes);
}
function validateEditTax(keyid,rowiddiv){  	
	var key=$("#"+keyid).val().trim();
	var rowid=$("#"+rowiddiv).val().trim();
	var hsn=$("#EditHSNCode").val().trim();
	var cgst=$("#EditCGSTRate").val().trim();
	var sgst=$("#EditSGSTRate").val().trim();
	var igst=$("#EditIGSTRate").val().trim();
	var taxnotes=$("#EditTaxNote").val().trim();
	if(hsn==""){
		document.getElementById('errorMsg').innerHTML ="Fill HSN CODE.";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(cgst==""){
		document.getElementById('errorMsg').innerHTML ="Fill CGST %.";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(sgst==""){
		document.getElementById('errorMsg').innerHTML ="Fill SGST %.";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(igst==""){
		document.getElementById('errorMsg').innerHTML ="Fill IGST %.";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(taxnotes==""){
		document.getElementById('errorMsg').innerHTML ="Fill Description.";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}	
	showLoader();
	$.ajax({
		type : "POST",
		url : "RegisterEditTax111",
		dataType : "HTML",
		data : {				
			hsn : hsn,
			cgst : cgst,
			sgst : sgst,
			igst : igst,
			taxnotes : taxnotes,
			key : key
		},
		success : function(data){
			if(data=="pass"){	
				$("#EditTaxModal").modal('hide');	
				$("#"+rowid).load("managetax.html #"+rowid);
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

function validateTax(){  	
	var hsn=$("#HSNCode").val().trim();
	var cgst=$("#CGSTRate").val().trim();
	var sgst=$("#SGSTRate").val().trim();
	var igst=$("#IGSTRate").val().trim();
	var taxnotes=$("#TaxNote").val().trim();
	if(hsn==""){
		document.getElementById('errorMsg').innerHTML ="Fill HSN CODE.";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(cgst==""){
		document.getElementById('errorMsg').innerHTML ="Fill CGST %.";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(sgst==""){
		document.getElementById('errorMsg').innerHTML ="Fill SGST %.";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(igst==""){
		document.getElementById('errorMsg').innerHTML ="Fill IGST %.";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
	if(taxnotes==""){
		document.getElementById('errorMsg').innerHTML ="Fill Description.";
		$('.alert-show').show().delay(3000).fadeOut();
		return false;
	}
		
	var key=makeid(40);
	showLoader();
	$.ajax({
		type : "POST",
		url : "RegisterNewTax111",
		dataType : "HTML",
		data : {				
			hsn : hsn,
			cgst : cgst,
			sgst : sgst,
			igst : igst,
			taxnotes : taxnotes,
			key : key
		},
		success : function(data){
			if(data=="pass"){	
				$("#TaxModal").modal('hide');			
				location.reload();
				/* $(''+'<div class="clearfix">'+                    
                '<div class="box-width24 col-md-1 col-xs-12 box-intro-background">'+
                	'<div class="link-style12">'+
                    '<p class="news-border"><input type="checkbox" name=""></p> '+
                    '</div></div>'+
                '<div class="box-width26 col-md-1 col-xs-12 box-intro-background">'+
                	'<div class="link-style12">'+
                    '<p class="news-border">'+hsn+'</p>'+
                    '</div></div> '+
				'<div class="box-width13 col-xs-1 box-intro-background">'+
                	'<div class="link-style12">'+
                    '<p class="news-border">'+cgst+'</p>'+
                    '</div></div>'+
				'<div class="box-width13 col-xs-12 box-intro-background">'+
                	'<div class="link-style12">'+
                    '<p class="news-border">'+sgst+'</p>'+
                    '</div></div>'+
                '<div class="box-width13 col-xs-12 box-intro-background">'+
                	'<div class="link-style12">'+
                    '<p class="news-border">'+igst+'</p>'+
                    '</div></div>'+
                '<div class="box-width22 col-xs-12 box-intro-background">'+
                	'<div class="link-style12">  '+
					'<p>'+
					'<span class="fa fa-pencil pointers" style="font-size: 20px;margin-right: 10px;"></span>'+
					'<span class="fa fa-trash pointers" style="font-size: 20px;"></span>'+
					'</p></div></div></div>').insertBefore("#MainContainerDiv"); */
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
			type : "Tax"
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