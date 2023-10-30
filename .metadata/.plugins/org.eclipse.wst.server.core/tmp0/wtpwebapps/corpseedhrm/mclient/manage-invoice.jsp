<%@page import="commons.DateUtil"%>
<%@page import="com.azure.storage.blob.BlobClientBuilder"%>
<%@page import="java.util.Properties"%>
<%@page import="commons.CommonHelper"%>
<%@page import="admin.enquiry.Enquiry_ACT"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Manage Invoice</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp"%>

</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp"%>
<%if(!GI00){%><jsp:forward page="/login.html" />
<%}
Properties properties = new Properties();
properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
String azure_path=properties.getProperty("azure_path");
String domain=properties.getProperty("domain");
//pagination start
int pageNo=1;
int rows=10;
String sort="";
String sorting_order="sorting_desc";
String order=request.getParameter("ord");
if(order==null)order="desc";
else if(order.equalsIgnoreCase("asc")){order="desc";sorting_order="sorting_desc";}
else if(order.equalsIgnoreCase("desc")){order="asc";sorting_order="sorting_asc";}

// String sorting_order=(String)session.getAttribute("ubsorting_order");
// if(sorting_order==null)sorting_order="";

if(request.getParameter("page")!=null)pageNo=Integer.parseInt(request.getParameter("page"));
if(request.getParameter("rows")!=null)rows=Integer.parseInt(request.getParameter("rows"));

if(request.getParameter("sort")!=null)sort=request.getParameter("sort");

String sort_url=domain+"manageinvoice.html?page="+pageNo+"&rows="+rows;
String token=(String)session.getAttribute("uavalidtokenno");

//pagination end

String invoiceTypeFilter=(String)session.getAttribute("invoiceTypeFilter");
if(invoiceTypeFilter==null||invoiceTypeFilter.length()<=0)invoiceTypeFilter="All";

String refInvoiceNumber=(String)session.getAttribute("refInvoiceNumber");
if(refInvoiceNumber==null||refInvoiceNumber.length()<=0)refInvoiceNumber="NA";

String manageInvoiceFilter=(String)session.getAttribute("manageInvoiceFilter");
if(manageInvoiceFilter==null||manageInvoiceFilter.length()<=0)manageInvoiceFilter="NA";

String invoiceClient=(String)session.getAttribute("invoiceClient");
if(invoiceClient==null||invoiceClient.length()<=0)invoiceClient="NA";

String invoiceDateRange=(String)session.getAttribute("invoiceDateRange");
if(invoiceDateRange==null||invoiceDateRange.length()<=0)invoiceDateRange="NA";

%>
		<div id="content">
			<div class="main-content">
				<div class="container-fluid">
					<div class="clearfix">
						<form onsubmit="return false;">
							<div class="bg_wht home-search-form clearfix mb10"
								id="SearchOptions">
								<div class="row">
									<div class="post" style="position: absolute; z-index: 9">
										<div class="linee"
											style="margin-top: -1px; width: 1350px; height: 50px"></div>
									</div>
									<div class="post" style="position: absolute; z-index: 9">
										<div class="linee"
											style="margin-top: -1px; width: 1350px; height: 50px"></div>
									</div>
									<div class="col-md-4 col-sm-4 col-xs-12">
										<div class="col-md-5 col-sm-5 row">
											<a href="javascript:void(0)" class="generate_invoice_box"
												data-related="generate_invoice" id="generateInvoiceBtn"><button
													type="button" class="filtermenu dropbtn"
													style="height: 40px; padding: 0 9px 0 9px;">+&nbsp;Generate
													Invoice</button></a>
										</div>
										<div class="col-md-7 col-sm-7">
											<select class="form-control filtermenu"
												onchange="doAction(this.value,'invoiceTypeFilter');location.reload();">
												<option value="all">All</option>
												<option value="PI"<%if(invoiceTypeFilter.equalsIgnoreCase("PI")){ %> selected="selected"<%} %>>Proforma Invoice</option>
												<option value="Tax"<%if(invoiceTypeFilter.equalsIgnoreCase("Tax")){ %> selected="selected"<%} %>>Tax Invoice</option>
												<option value="Debit"<%if(invoiceTypeFilter.equalsIgnoreCase("Debit")){ %> selected="selected"<%} %>>Debit Notes</option>
											</select>
										</div>
									</div>
									<a href="javascript:void(0)" class="doticon"> <i
										class="fa fa-filter" aria-hidden="true"></i>Filter
									</a>
									<div class="filtermmenu">
										<div class="col-md-8 col-sm-8 col-xs-12">
											<div class="clearfix flex_box justify_end">
												<div class="item-bestsell col-md-4 col-sm-6 col-xs-12">
													<p>
														<input type="search" name="refInvoiceFilter" id="refInvoiceFilter"
															autocomplete="off"
															<% if(!refInvoiceNumber.equalsIgnoreCase("NA")){ %>
															onsearch="clearSession('refInvoiceNumber');location.reload();"
															value="<%=refInvoiceNumber%>" <%} %>
															placeholder="Search by ref. invoice" class="form-control" />
													</p>
												</div>
												<div class="item-bestsell col-md-4 col-sm-6 col-xs-12">
													<p>
														<input type="search" name="manageInvoiceFilter" id="manageInvoiceFilter"
															autocomplete="off"
															<% if(!manageInvoiceFilter.equalsIgnoreCase("NA")){ %>
															onsearch="clearSession('manageInvoiceFilter');location.reload();"
															value="<%=manageInvoiceFilter%>" <%} %>
															placeholder="Search by invoice" class="form-control" />
													</p>
												</div>
												<div class="item-bestsell col-md-4 col-sm-4 col-xs-12">
													<p>
														<input type="search" name="companyName" id="companyName"
															<% if(!invoiceClient.equalsIgnoreCase("NA")){ %>
															onsearch="clearSession('invoiceClient');location.reload();"
															value="<%=invoiceClient%>" <%} %> autocomplete="off"
															placeholder="Search by client" class="form-control" />
													</p>
												</div>
												<div class="item-bestsell col-md-4 col-sm-4 col-xs-12 has-clear">
													<p>
														<input type="text" name="date_range" id="date_range"
															autocomplete="off" placeholder="FROM - TO"
															class="form-control text-center date_range pointers <%if(!invoiceDateRange.equalsIgnoreCase("NA")){%>selected<%} %>"
															readonly="readonly" /> <span
															class="form-control-clear form-control-feedback"
															onclick="clearSession('invoiceDateRange');location.reload();"></span>
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
										<button type="button" class="filtermenu dropbtn"
											style="width: 90px;" data-toggle="modal"
											data-target="#ExportData">&nbsp;Export</button>
									</div>
								</div>
								<div class="col-md-7 col-sm-7 col-xs-12 min-height50">
									<div class="clearfix flex_box justify_end"></div>
								</div>
							</div>
						</form>
					</div>
					<div class="row">
						<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="table-responsive">
								<table class="ctable">
									<thead>
										<tr class="tg"
											style="position: absolute; width: 100%; display: inline-table">
											<th class="tg-cly1">
												<div class="line"></div>
											</th>
											<th class="tg-cly1">
												<div class="line"></div>
											</th>
											<th class="tg-cly1">
												<div class="line"></div>
											</th>
											<th class="tg-cly1">
												<div class="line"></div>
											</th>
											<th class="tg-cly1">
												<div class="line"></div>
											</th>
											<th class="tg-cly1">
												<div class="line"></div>
											</th>
										</tr>
										<tr>
											<th><span class="hashico">#</span></th>
											<th class="sorting <%if(sort.equals("date")){ %><%=sorting_order%><%} %>"
												onclick="sortBy('<%=sort_url%>','date','<%=order%>')">Date</th>
											<th>Type</th>
											<th class="sorting">Ref.Invoice</th>
											<th class="sorting">Invoice No.</th>
											<th>Client</th>
											<th class="sorting">Amount</th>
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
									  
									  String[][] invoice=Clientmaster_ACT.getAllManageInvoice(invoiceTypeFilter,refInvoiceNumber,manageInvoiceFilter,invoiceClient,invoiceDateRange,token,pageNo,rows,sort,order);
									  int totalInvoice=Clientmaster_ACT.countAllManageInvoice(invoiceTypeFilter,refInvoiceNumber,manageInvoiceFilter,invoiceClient,invoiceDateRange,token);
									  if(invoice!=null&&invoice.length>0){	 
										  ssn=rows*(pageNo-1);
										  totalPages=(totalInvoice/rows);
										  if((totalInvoice%rows)!=0)totalPages+=1;
										  showing=ssn+1;
										  if (totalPages > 1) {     	 
											  if((endRange-2)==totalPages)startRange=pageNo-4;        
									          if(startRange==pageNo)endRange=pageNo+4;
									          if(startRange<1) {startRange=1;endRange=startRange+4;}
									          if(endRange>totalPages) {endRange=totalPages;startRange=endRange-4;}             
									          if(startRange<1)startRange=1;
									     }else{startRange=0;endRange=0;}
										  
									  for(int i=0;i<invoice.length;i++)
									  {String invoiceType="PROFORMA INVOICE";
									  if(invoice[i][1].equalsIgnoreCase("DN"))invoiceType="DEBIT NOTE";
									  else if(invoice[i][1].equalsIgnoreCase("TAX"))invoiceType="TAX INVOICE";
									  %>
										<tr class="tg"
											style="position: absolute; width: 100%; display: inline-table">
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
												<div class="line" style="position: relative; z-index: 9"></div>
											</td>
										</tr>
										<tr id="row<%=invoice.length-i%>">
											<td><%=(showing+i) %></td>
											<td><%=invoice[i][5] %></td>
											<td><%=invoiceType %></td>
											<td><%=invoice[i][2] %></td>
											<td><%=invoice[i][6] %></td>
											<td><%=invoice[i][3] %></td>
											<td><%=CommonHelper.withLargeIntegers(Double.parseDouble(invoice[i][4])) %></td>
											<td><a href="<%=request.getContextPath()%>/generateinvoice-<%=(invoice[i][0]).toLowerCase()%>.html" target="_blank">View</a>| 
											<a href="javascript:void(0)" data-related="generate_invoice_edit" 
											onclick="editGeneratedInvoice('<%=invoice[i][0] %>')" class="generate_invoice_box_edit">Edit</a>| 
											<a href="javascript:void(0)" onclick="deleteGeneratedInvoice('<%=invoice[i][0] %>','row<%=invoice.length-i%>')">Delete</a>
											</td>
										</tr>
										<%}} %>
									</tbody>
								</table>

								<div class="filtertable">
								<span>Showing <%=showing %> to <%=ssn+invoice.length %> of <%=totalInvoice %> entries</span>									
									<div class="pagination">
										<ul>
											<%if(pageNo>1){ %>
											<li class="page-item"><a class="page-link text-primary"
												href="<%=request.getContextPath()%>/manageinvoice.html?page=1&rows=<%=rows%>">First</a>
											</li>
											<%} %>
											<li class="page-item"><a
												class="page-link <%if(pageNo>1){ %>text-primary<%}else{ %> text-muted<%} %>"
												<%if(pageNo>1){ %>
												href="<%=request.getContextPath()%>/manageinvoice.html?page=<%=(pageNo-1) %>&rows=<%=rows%>"
												<%}else{ %> href="javascript:void(0)" <%} %>>Previous</a></li>
											<%if(startRange>0&&endRange>0)for(int i=startRange;i<=endRange;i++){ %>
											<li class="page-item <%if(pageNo==i){ %>active<%}%>"><a
												class="page-link"
												href="<%=request.getContextPath()%>/manageinvoice.html?page=<%=i %>&rows=<%=rows%>"><%=i %></a>
											</li>
											<%} %>
											<li class="page-item"><a
												class="page-link <%if(pageNo!=totalPages){ %>text-primary<%}else{ %>text-muted<%} %>"
												<%if(pageNo!=totalPages){ %>
												href="<%=request.getContextPath()%>/manageinvoice.html?page=<%=(pageNo+1) %>&rows=<%=rows%>"
												<%}else{ %> href="javascript:void(0)" <%} %>>Next</a></li>
											<%if(pageNo<=(totalPages-1)){ %>
											<li class="page-item"><a class="page-link text-primary"
												href="<%=request.getContextPath()%>/manageinvoice.html?page=<%=(totalPages) %>&rows=<%=rows%>">Last</a>
											</li>
											<%} %>
										</ul>
									</div>
									<select class="select2"
										onchange="changeRows(this.value,'manageinvoice.html?page=1','<%=domain%>')">
										<option value="10" <%if(rows==10){ %> selected="selected"
											<%} %>>Rows 10</option>
										<option value="20" <%if(rows==20){ %> selected="selected"
											<%} %>>Rows 20</option>
										<option value="40" <%if(rows==40){ %> selected="selected"
											<%} %>>Rows 40</option>
										<option value="80" <%if(rows==80){ %> selected="selected"
											<%} %>>Rows 80</option>
										<option value="100" <%if(rows==100){ %> selected="selected"
											<%} %>>Rows 100</option>
										<option value="200" <%if(rows==200){ %> selected="selected"
											<%} %>>Rows 200</option>
									</select>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="modal fade" id="ExportData" tabindex="-1" role="dialog"
			aria-labelledby="exampleModalLabel" aria-hidden="true">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="exampleModalLabel"
							style="padding-bottom: 6px;">
							<span class="fas fa-file-export text-primary"
								style="margin-right: 10px;"> </span><span class="text-primary">Export</span>
						</h5>
						<button type="button" class="closeBox" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<form action="return false" id="exportUnbilledCol">
						<div class="modal-body">
							<div class="form-group">
								<label for="recipient-name" class="col-form-label">FROM
									:</label> <input type="text" autocomplete="off"
									class="form-control searchdate pointers" name="from-date"
									id="From-Date" placeholder="FROM-DATE" readonly="readonly">
							</div>
							<div class="form-group">
								<label for="recipient-name" class="col-form-label">TO :</label>
								<input type="text" autocomplete="off"
									class="form-control searchdate pointers" name="to-date"
									id="To-Date" placeholder="TO-DATE" readonly="readonly">
							</div>
							<div class="form-group">
								<label for="recipient-name" class="col-form-label">Columns
									:</label> <select class="form-control" name="exportColumn"
									id="ExportColumn" multiple="multiple">
									<option value="s.saddeddate" selected>Date</option>
									<option value="s.sunbill_no" selected>Unbill No.</option>
									<option value="s.service_name" selected>Service Name</option>
									<option value="e.escontactrefid" selected>Client</option>
									<option value="e.escompany" selected>Company</option>
									<option value="es.amount" selected>Taxable</option>
									<option value="es.cgst" selected>CGST</option>
									<option value="es.sgst" selected>SGST</option>
									<option value="es.igst" selected>IGST</option>
									<option value="s.stransactionamount" selected>Amount</option>
									<option value="s.saddedbyuid" selected>Sales Person</option>
								</select>
							</div>
							<div class="form-group">
								<label for="recipient-name" class="col-form-label">Format
									:</label> <select class="form-control" name="file-formate"
									id="File-Formate">
									<option value="csv">CSV</option>
									<option value="xlsx" selected>XLS</option>
								</select>
							</div>
							<div class="form-group noDisplay">
								<label for="recipient-name" class="col-form-label">Password
									Protected :</label> <input type="checkbox" name="protected"
									id="Protected" value="2">&nbsp;&nbsp; <input
									type="password" class="noDisplay form-control"
									name="filePassword" id="FilePassword"
									placeholder="Enter password..">
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary"
								data-dismiss="modal">Cancel</button>
							<button type="button" class="btn btn-primary"
								onclick="return validateExport()">Submit</button>
						</div>
					</form>
				</div>
			</div>
		</div>

		<div class="modal fade" id="warningDelete" tabindex="-1"
			role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="exampleModalLabel"
							style="padding-bottom: 6px;">
							<span class="text-danger">Do you want to delete ? </span>
						</h5>
						<button type="button" class="closeBox" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<p>Please ensure before delete, After delete It can't be undo !!</p>
					</div>
					<input type="hidden" id="deleteInvoiceKey">
					<input type="hidden" id="deleteInvoiceRow">
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-dismiss="modal">NO</button>
						<button type="button" class="btn btn-secondary"
							onclick="deleteGeneratedInvoice('NA','NA')">Yes</button>
					</div>
				</div>
			</div>
		</div>
		<div class="fixed_right_box">
			<div class="clearfix add_inner_box pad_box4" id="generate_invoice">
				<div class="close_icon close_box">
					<i class="fas fa-times" style="font-size: 21px;"></i>
				</div>
				<div class="rttop_title">
					<h3 style="color: #42b0da;">
						<i class="fas fa-user-cog"></i>Generate Invoice
					</h3>
					<p>When someone reaches out to you, they become a contact in
						your account. You can create companies and associate contacts with
						them.
				</div>

				<form action="javascript:void(0)" method="post"
					id="generateInvoiceForm">
					<input type="hidden" id="refkey" name="refkey" value="NA">
					<div class="form-group row">
						<label class="col-sm-3 col-form-label">Type Of Invoice</label>
						<div class="col-sm-9">
							<select class="form-control" id="invoiceType" name="invoiceType">
								<option value="">Invoice Type</option>
								<option value="PI">Proforma Invoice</option>
								<option value="DN">Debit Note</option>
								<option value="TAX">Tax Invoice</option>
							</select>
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-3 col-form-label">Ref. Invoice</label>
						<div class="col-sm-9">
							<input type="text" class="form-control" id="refInvoice"
								name="refInvoice" placeholder="Reference Invoice No.">
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-3 col-form-label">Bill To</label>
						<div class="col-sm-9">
							<input type="text" class="form-control" id="billTo" name="billTo"
								placeholder="Bill To">
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-3 col-form-label">GSTIN</label>
						<div class="col-sm-9">
							<input type="text" class="form-control" id="gstin" name="gstin"
								placeholder="GST No.">
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-3 col-form-label">Ship To</label>
						<div class="col-sm-9">
							<textarea class="form-control" id="shipTo" name="shipTo" rows="6"
								placeholder="Ship To"></textarea>
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-3 col-form-label">Place Of Supply</label>
						<div class="col-sm-9">
							<input type="text" class="form-control" id="placeOfSupply"
								name="placeOfSupply" placeholder="Place Of Supply">
						</div>
					</div>
					<div class="form-group">
						<table class="ctable" id="invoiceSummary">
						</table>
					</div>
					<div class="form-group row">
						<div class="col-sm-12 text-right">
							<button type="button" class="btn btn-danger close_box">Cancel</button>
							<button type="submit" class="btn btn-primary"
								onclick="return validateGenerateInvoice()">Submit</button>
						</div>
					</div>
				</form>

			</div>
			<div class="clearfix add_inner_box pad_box4" id="generate_invoice_edit">
				<div class="close_icon close_box">
					<i class="fas fa-times" style="font-size: 21px;"></i>
				</div>
				<div class="rttop_title">
					<h3 style="color: #42b0da;">
						<i class="fas fa-user-cog"></i>Update Invoice&nbsp:<span id="invoiceNoEdit"></span>
					</h3>
					<p>When someone reaches out to you, they become a contact in
						your account. You can create companies and associate contacts with
						them.
				</div>

				<form action="<%=request.getContextPath() %>/create-invoice.html" method="post"
					id="generateInvoiceFormEdit">
					<input type="hidden" id="refkey" name="refkey">
					<div class="form-group row">
						<label class="col-sm-3 col-form-label">Type Of Invoice</label>
						<div class="col-sm-9">
							<select class="form-control" id="invoiceTypeEdit" name="invoiceTypeEdit" disabled="disabled">
								<option value="">Invoice Type</option>
								<option value="PI">Proforma Invoice</option>
								<option value="DN">Debit Note</option>
								<option value="TAX">Tax Invoice</option>
							</select>
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-3 col-form-label">Ref. Invoice</label>
						<div class="col-sm-9">
							<input type="text" class="form-control" id="refInvoiceEdit"
								name="refInvoiceEdit" placeholder="Reference Invoice No." disabled="disabled">
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-3 col-form-label">Bill To</label>
						<div class="col-sm-9">
							<input type="text" class="form-control" id="billToEdit" name="billToEdit"
								placeholder="Bill To">
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-3 col-form-label">GSTIN</label>
						<div class="col-sm-9">
							<input type="text" class="form-control" id="gstinEdit" name="gstinEdit"
								placeholder="GST No.">
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-3 col-form-label">Ship To</label>
						<div class="col-sm-9">
							<textarea class="form-control" id="shipToEdit" name="shipToEdit" rows="6"
								placeholder="Ship To"></textarea>
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-3 col-form-label">Place Of Supply</label>
						<div class="col-sm-9">
							<input type="text" class="form-control" id="placeOfSupplyEdit"
								name="placeOfSupplyEdit" placeholder="Place Of Supply">
						</div>
					</div>
					<div class="form-group">
						<table class="ctable" id="invoiceSummaryEdit">
						</table>
					</div>
					<div class="form-group row">
						<div class="col-sm-12 text-right">
							<button type="button" class="btn btn-danger close_box">Cancel</button>
							<button type="submit" class="btn btn-primary"
								onclick="return validateUpdateGenerateInvoice()">Submit</button>
						</div>
					</div>
				</form>

			</div>
		</div>
		<p id="end" style="display: none;"></p>
	</div>
	<div class="noDisplay">
		<a href="" id="DownloadExportedLink" download><button
				id="DownloadExported">Download</button></a>
	</div>
	<%@ include file="../staticresources/includes/itswsfooter.jsp"%>

	<%@ include file="../staticresources/includes/itswsscripts.jsp"%>

	<script type="text/javascript">

$(function() {
	$("#companyName").autocomplete({
		source : function(request, response) {
			if(document.getElementById('companyName').value.trim().length>=1)
			$.ajax({
				url : "get-client-details.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field :"invoiceCompanyName"
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
            	      	
            }
            else{
            	doAction(ui.item.value,"invoiceClient");
            	location.reload(true);
            	
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});
	</script>

	<script type="text/javascript">
$( document ).ready(function() {
	   var dateRangeDoAction="<%=invoiceDateRange%>";
	   if(dateRangeDoAction!="NA"){	  
		   $('input[name="date_range"]').val(dateRangeDoAction);
	   }
	   
	   $("#generateInvoiceBtn").click(function(){
		   var id = $(".generate_invoice_box").attr('data-related'); 
			$('.fixed_right_box').addClass('active');
			    $("div.add_inner_box").each(function(){
			        $(this).hide();
			        if($(this).attr('id') == id) {
			            $(this).show();
			        }
			    });	
	   })
	   
	});

function editGeneratedInvoice(refkey){
	fillGeneratedInvoice(refkey);
	var id = $(".generate_invoice_box_edit").attr('data-related'); 
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });	
}

$('.close_box').on( "click", function(e) { 
	$('.fixed_right_box').removeClass('active');
	$('.addnew').show();	
	});
$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
	var data=$(this).val();
	doAction(data,"invoiceDateRange");
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
				data : {
					data : data
				},
				success : function(response) {
				},
				complete : function(data) {
					hideLoader();
				}
			});
		}

		$("#Protected").click(function() {
			if ($("#Protected").is(":checked")) {
				$("#FilePassword").val("");
				$("#FilePassword").show();
			} else {
				$("#FilePassword").hide();
				$("#FilePassword").val("NA");
			}
		});
		$(function() {
			$(".searchdate").datepicker({
				changeMonth : true,
				changeYear : true,
				dateFormat : 'yy-mm-dd'
			});
		});
		$(document).ready(function() {
			$('#ExportColumn').select2({
				placeholder : 'Select columns..',
				allowClear : true,
				dropdownParent : $("#ExportData")
			});
			$('#Update_Super_User').select2({
				placeholder : 'Select Super User',
				allowClear : true
			});
		});

		if ($(window).width() < 768) {
			jQuery(".icoo")
					.click(
							function() {
								$('.dropdown_list').removeClass("show");
								var display = jQuery(this).next(
										".dropdown_list").css("display");
								if (display == "none") {
									jQuery(".fa-angle-up ").css("display",
											"none");
									jQuery(".dropdown_list").removeClass(
											"active");
									jQuery(".dropdown_list").slideUp("fast");
									jQuery(this).next(".dropdown_list")
											.slideDown("fast");
									jQuery(this).addClass("active");
									jQuery(".fa-angle-down ").css("display",
											"block");

								} else {
									jQuery(".fa-angle-up ").css("display",
											"none");
									jQuery(this).next(".dropdown_list")
											.slideUp("fast");
									jQuery(this).removeClass("active");
									jQuery(".fa-angle-down ").css("display",
											"block");

								}
							});
		}

		$('.list_icon').hover(function() {
			$(this).children().next().toggleClass("show");
		});
		$('body').click(function() {

			$('.dropdown_list ').removeClass('show');

		});

			
		
		$(function() {
			$("#refInvoiceFilter").autocomplete(
					{
						source : function(request, response) {
							if (document.getElementById('refInvoiceFilter').value
									.trim().length >= 1)
								$.ajax({
									url : "get-client-details.html",
									type : "POST",
									dataType : "JSON",
									data : {
										name : request.term,
										"field" : "refInvoiceNumber"
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
						select : function(event, ui) {
							if (!ui.item) {

							} else {
								doAction(ui.item.value, 'refInvoiceNumber');
								location.reload();
							}
						},
						error : function(error) {
							alert('error: ' + error.responseText);
						},
					});

			$("#refInvoice").autocomplete({
				source : function(request, response) {
					$.ajax({
						url : "get-client-details.html",
						type : "GET",
						dataType : "JSON",
						data : {
							name : request.term,
							"field" : "invoiceDetails"
						},
						success : function(data) {
							response($.map(data, function(item) {
								return {
									label : item.name,
									value : item.value,
									client : item.client,
									gstin : item.gstin,
									address : item.address,
									supply : item.supply
								};
							}));
						},
						error : function(error) {
							alert('error: ' + error.responseText);
						}
					});
				},
				select : function(event, ui) {
					if (ui.item) {
						$("#billTo").val(ui.item.client);
						$("#gstin").val(ui.item.gstin);
						$("#shipTo").val(ui.item.address);
						$("#placeOfSupply").val(ui.item.supply);
						findInvoiceDetails(ui.item.value,"invoiceSummary");
					} else {
						$("#billTo").val("");
						$("#gstin").val("");
						$("#shipTo").val("");
						$("#placeOfSupply").val("");
						$("#invoiceSummary").empty();
					}
				},
				error : function(error) {
					alert('error: ' + error.responseText);
				},
			});
			
			$("#manageInvoiceFilter").autocomplete(
					{
						source : function(request, response) {
							if (document.getElementById('manageInvoiceFilter').value.trim().length >= 1)
								$.ajax({
									url : "get-client-details.html",
									type : "POST",
									dataType : "JSON",
									data : {
										name : request.term,
										"field" : "manageInvoiceFilter"
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
						select : function(event, ui) {
							if (!ui.item) {

							} else {
								doAction(ui.item.value, 'manageInvoiceFilter');
								location.reload();
							}
						},
						error : function(error) {
							alert('error: ' + error.responseText);
						},
					});
			
			$("#refInvoiceEdit").autocomplete({
				source : function(request, response) {
					$.ajax({
						url : "get-client-details.html",
						type : "GET",
						dataType : "JSON",
						data : {
							name : request.term,
							"field" : "invoiceDetails"
						},
						success : function(data) {
							response($.map(data, function(item) {
								return {
									label : item.name,
									value : item.value,
									client : item.client,
									gstin : item.gstin,
									address : item.address,
									supply : item.supply
								};
							}));
						},
						error : function(error) {
							alert('error: ' + error.responseText);
						}
					});
				},
				select : function(event, ui) {
					if (ui.item) {
						$("#billToEdit").val(ui.item.client);
						$("#gstinEdit").val(ui.item.gstin);
						$("#shipToEdit").val(ui.item.address);
						$("#placeOfSupplyEdit").val(ui.item.supply);
						findInvoiceDetails(ui.item.value,"invoiceSummaryEdit");
					} else {
						$("#billToEdit").val("");
						$("#gstinEdit").val("");
						$("#shipToEdit").val("");
						$("#placeOfSupplyEdit").val("");
						$("#invoiceSummaryEdit").empty();
					}
				},
				error : function(error) {
					alert('error: ' + error.responseText);
				},
			});
		});

		function findInvoiceDetails(invoice,invoiceSummaryId) {
			$("#"+invoiceSummaryId).empty();
			$.ajax({
				type : "GET",
				url : "GetInvoiceSummary111",
				dataType : "HTML",
				data : {
					invoice : invoice
				},
				success : function(response) {
					$("#"+invoiceSummaryId).append(response);
				}
			});
		}
		
		function validateUpdateGenerateInvoice(){
			let billTo = $("#billToEdit").val();
			let gstin = $("#gstinEdit").val();
			let shipTo = $("#shipToEdit").val();
			let placeOfSupply = $("#placeOfSupplyEdit").val();

			if (billTo == null || billTo == "") {
				document.getElementById('errorMsg').innerHTML = "Please Enter Bill To Name..";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
			}

			if (shipTo == null || shipTo == "") {
				document.getElementById('errorMsg').innerHTML = "Please Enter shipping address..";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
			}

			if (placeOfSupply == null || placeOfSupply == "") {
				document.getElementById('errorMsg').innerHTML = "Please Enter place of supply..";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
			}
		}

		function validateGenerateInvoice() {
			let invoiceType = $("#invoiceType").val();
			let invoiceNo = $("#refInvoice").val();
			let billTo = $("#billTo").val();
			let gstin = $("#gstin").val();
			let shipTo = $("#shipTo").val();
			let placeOfSupply = $("#placeOfSupply").val();

			if (invoiceType == null || invoiceType == "") {
				document.getElementById('errorMsg').innerHTML = "Select Invoice Type.";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
			}

			if (invoiceNo == null || invoiceNo == "") {
				document.getElementById('errorMsg').innerHTML = "Please Enter Invoice No..";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
			}

			if (billTo == null || billTo == "") {
				document.getElementById('errorMsg').innerHTML = "Please Enter Bill To Name..";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
			}

			if (shipTo == null || shipTo == "") {
				document.getElementById('errorMsg').innerHTML = "Please Enter shipping address..";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
			}

			if (placeOfSupply == null || placeOfSupply == "") {
				document.getElementById('errorMsg').innerHTML = "Please Enter place of supply..";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
			}

			$.ajax({
				type : "GET",
				url : "IsInvoiceGenerated111",
				dataType : "HTML",
				data : {
					invoiceType : invoiceType,
					invoiceNo : invoiceNo
				},
				success : function(response) {
					if (response == "pass") {
						document.getElementById('errorMsg').innerHTML = "Invoice Already created..";
						$('.alert-show').show().delay(4000).fadeOut();
						return false;
					} else {
						$("#generateInvoiceForm").attr("action","<%=request.getContextPath()%>/create-invoice.html");
						$("#generateInvoiceForm")[0].submit();
					}
		}
	});
	
}

function fillGeneratedInvoice(refkey){
	showLoader();
	$.ajax({
		type : "GET",
		url : "GetManageInvoice111",
		dataType : "HTML",
		data : {				
			refkey : refkey
		},
		success : function(response){		
		if(Object.keys(response).length!=0){	
		response = JSON.parse(response);			
		 let len = response.length;			 
		 if(Number(len)>0){			   
			let type = response[0]['type'];	
			let invoice = response[0]['invoice'];
			let bill_to= response[0]['bill_to'];
			let gstin = response[0]['gstin'];	
			let ship_to = response[0]['ship_to'];
			let place_supply= response[0]['place_supply'];
			let invoice_no= response[0]['invoice_no'];
			let data= response[0]['data'];
			
			$("#invoiceTypeEdit").val(type);
			$("#refInvoiceEdit").val(invoice);
			$("#billToEdit").val(bill_to);
			$("#gstinEdit").val(gstin);
			$("#shipToEdit").val(ship_to);
			$("#placeOfSupplyEdit").val(place_supply);	
			$("#generateInvoiceFormEdit #refkey").val(refkey);
			$("#invoiceNoEdit").html(" "+invoice_no);
			
			$("#invoiceSummaryEdit").empty();
			$("#invoiceSummaryEdit").append(data);
			
		}}},
		complete : function(data){
			hideLoader();
		}
	});
}

function deleteGeneratedInvoice(refkey,rowId){
	if(refkey=="NA"){
		refkey=$("#deleteInvoiceKey").val();
		rowId=$("#deleteInvoiceRow").val();
		showLoader();
		$.ajax({
			type : "POST",
			url : "DeleteManageInvoice111",
			dataType : "HTML",
			data : {				
				refkey : refkey
			},
			success : function(response){		
				$("#warningDelete").modal("hide");
				$("#"+rowId).remove();
			},
			complete : function(data){
				hideLoader();
			}
		});
	}else{
		$("#deleteInvoiceKey").val(refkey);
		$("#deleteInvoiceRow").val(rowId);
		$("#warningDelete").modal("show");
	}
}
</script>
</body>
</html>