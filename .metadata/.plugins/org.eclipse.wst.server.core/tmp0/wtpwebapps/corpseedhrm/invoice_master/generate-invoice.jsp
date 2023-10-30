<%@page import="admin.master.Usermaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Generate Invoice</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp"%>
</head>
<body>
	<div class="wrap">
		<%@ include file="../staticresources/includes/itswsheader.jsp"%>
		<%
	String landingpage_basepath = request.getContextPath();
	String token= (String)session.getAttribute("uavalidtokenno"); 
	String gststart=Usermaster_ACT.getStartingCode(token,"imgstkey");
	String nongststart=Usermaster_ACT.getStartingCode(token,"imnongstkey");
%>
<%if(!MB08){%><jsp:forward page="/login.html" /><%} %>
		<div id="content">
			<div class="container">
				<div class="bread-crumb">
					<div class="bd-breadcrumb bd-light">
						<a href="<%=request.getContextPath()%>/dashboard.html">Home</a> <a>Generate Invoice</a>
					</div>
				</div>
			</div>

			<div class="main-content">
				<div class="container">
					<div class="row">
						<div class="col-xs-12">
							<div class="menuDv  post-slider">
								<form action="generate-invoice-new.html" method="post"
									name="addcontent" id="addcontent">
									<input type="hidden" readonly name="pid" id="pid">
									<input type="hidden" readonly name="cid" id="cid">
									<div class="row">
									<div class="col-md-4 col-sm-4 col-xs-12">
							<div class="form-group">
								<label>Invoice No.</label>
								<div class="input-group">
									<span class="input-group-addon"><i
										class="form-icon sprite fa fa-chrome"></i></span> <input type="text"
										name="InVno" id="InV_no"
										readonly class="form-control">
								</div>
								<div id="InV_noErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>
										<div class="col-md-4 col-sm-4 col-xs-12">
											<div class="form-group">
												<label>Client Name</label>
												<div class="input-group">
													<span class="input-group-addon"><i
														class="form-icon sprite full-name"></i></span> <input type="text"
														name="clientName" id="Client_Name" autocomplete="off"
														placeholder="Enter Client Name"
														onblur="requiredFieldValidation('Client_Name','ClientNameErrorMSGdiv');"
														class="form-control">
												</div>
												<div id="ClientNameErrorMSGdiv" class="errormsg"></div>
											</div>
										</div>
										<div class="col-md-4 col-sm-4 col-xs-12">
											<div class="form-group">
												<label>Project Name</label>
												<div class="input-group">
													<span class="input-group-addon"><i
														class="form-icon sprite full-name"></i></span> <input type="text"
														name="projectName" id="Project_Name" autocomplete="off"
														placeholder="Enter Project Name"
														onblur="requiredFieldValidation('Project_Name','ProjectNameErrorMSGdiv');approve2();"
														class="form-control">
												</div>
												<div id="ProjectNameErrorMSGdiv" class="errormsg"></div>
											</div>
										</div>
										</div>
									<div class="row">
										<div class="col-md-4 col-sm-4 col-xs-12">
											<div class="form-group">
												<label>Billing Type</label>
												<div class="input-group">
													<span class="input-group-addon"><i
														class="form-icon fa fa-search"></i></span> <input readonly
														id="BillingType" name="cbype" placeholder="Enter Billing Type"
														onblur="requiredFieldValidation('BillingType','BillingTypeErrorMSGdiv');"
														class="form-control">
												</div>
												<div id="BillingTypeErrorMSGdiv" class="errormsg"></div>
											</div>
										</div>
										<div class="col-md-4 col-sm-4 col-xs-12">
											<div class="form-group">
												<label>Billing Amount</label>
												<div class="input-group">
													<span class="input-group-addon"><i
														class="form-icon sprite list"></i></span> <input type="text"
														name="BillingAmount" id="BillingAmount"
														placeholder="Enter Billing Amount" readonly
														onblur="requiredFieldValidation('BillingAmount','BillingAmountErrorMSGdiv');"
														class="form-control">
												</div>
												<div id="BillingAmountsErrorMSGdiv" class="errormsg"></div>
											</div>
										</div>
										<div class="col-md-4 col-sm-4 col-xs-12">
											<div class="form-group">
												<label>Invoice Amount</label>
												<div class="input-group">
													<span class="input-group-addon"><i
														class="form-icon sprite list"></i></span> <input type="text"
														name="InvoiceAmount" id="InvoiceAmount"
														placeholder="Enter Invoice Amount"
														onblur="requiredFieldValidation('InvoiceAmount','InvoiceAmountErrorMSGdiv');"
														class="form-control">
												</div>
												<div id="InvoiceAmountErrorMSGdiv" class="errormsg"></div>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-md-4 col-sm-4 col-xs-12">
											<div class="form-group">
												<label>Service Code</label>
												<div class="input-group">
													<span class="input-group-addon"><i
														class="form-icon fa fa-search"></i></span> <input id="ServiceCode"
														name="ServiceCode" placeholder="Enter GST Service Code"
														onblur="requiredFieldValidation('ServiceCode','ServiceCodeErrorMSGdiv');"
														class="form-control">
												</div>
												<div id="ServiceCodeErrorMSGdiv" class="errormsg"></div>
											</div>
										</div>
										<div class="col-md-4 col-sm-4 col-xs-12">
											<div class="form-group">
												<label>GST Category</label>
												<div class="input-group">
													<span class="input-group-addon"><i
														class="form-icon sprite list"></i></span> <input type="text"
														name="GSTCategory" id="GSTCategory"
														placeholder="Enter GST Category"
														onblur="requiredFieldValidation('GSTCategory','GSTCategoryErrorMSGdiv');"
														class="form-control">
												</div>
												<div id="GSTCategoryErrorMSGdiv" class="errormsg"></div>
											</div>
										</div>
										<div class="col-md-4 col-sm-4 col-xs-12">
											<div class="form-group">
												<label>GST Tax (%)</label>
												<div class="input-group">
													<span class="input-group-addon"><i
														class="form-icon fa fa-search"></i></span> <input id="GST"
														name="GST" value="0"
														onblur="requiredFieldValidation('GST','GSTErrorMSGdiv');addgst(this.value);"
														class="form-control">
												</div>
												<div id="GSTErrorMSGdiv" class="errormsg"></div>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-md-4 col-sm-4 col-xs-12">
											<div class="form-group">
												<label>GST Value</label>
												<div class="input-group">
													<span class="input-group-addon"><i
														class="form-icon sprite list"></i></span> <input type="text"
														name="GSTValue" id="GSTValue" readonly
														placeholder="Enter GST Value"
														onblur="requiredFieldValidation('GSTValue','GSTValueErrorMSGdiv');"
														class="form-control">
												</div>
												<div id="GSTValueErrorMSGdiv" class="errormsg"></div>
											</div>
										</div>
										<div class="col-md-4 col-sm-4 col-xs-12">
											<div class="form-group">
												<label>Total Invoice Amount</label>
												<div class="input-group">
													<span class="input-group-addon"><i
														class="form-icon sprite list"></i></span> <input type="text"
														name="TotalInvoiceAmount" id="TotalInvoiceAmount"
														placeholder="Enter Total Invoice Amount" readonly
														onblur="requiredFieldValidation('TotalInvoiceAmount','TotalInvoiceAmountErrorMSGdiv');"
														class="form-control">
												</div>
												<div id="TotalInvoiceAmountErrorMSGdiv" class="errormsg"></div>
											</div>
										</div>
										<div class="col-md-4 col-sm-4 col-xs-12">
											<div class="form-group">
												<label>Billing Month</label>
												<div class="input-group">
													<span class="input-group-addon"><i
														class="form-icon sprite list"></i></span> <select
														name="BillingMonth" id="Billing Month"
														onblur="requiredFieldValidation('Billing Month','BillingMonthErrorMSGdiv');"
														class="form-control">
														<option value="">Select Billing Month</option>
													    <option value='Janaury'>Janaury</option>
													    <option value='February'>February</option>
													    <option value='March'>March</option>
													    <option value='April'>April</option>
													    <option value='May'>May</option>
													    <option value='June'>June</option>
													    <option value='July'>July</option>
													    <option value='August'>August</option>
													    <option value='September'>September</option>
													    <option value='October'>October</option>
													    <option value='November'>November</option>
													    <option value='December'>December</option>
													   </select>
												</div>
												<div id="BillingMonthErrorMSGdiv" class="errormsg"></div>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-md-4 col-sm-4 col-xs-12">
											<div class="form-group">
												<label>Billing Date</label>
												<div class="input-group">
													<span class="input-group-addon"><i
														class="form-icon sprite list"></i></span> <input type="text"
														name="BillingDate" id="BillingDate"
														placeholder="Enter Billing Date"
														onblur="requiredFieldValidation('BillingDate','BillingDateErrorMSGdiv');"
														class="form-control">
												</div>
												<div id="BillingDateErrorMSGdiv" class="errormsg"></div>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-md-12 col-sm-12 col-xs-12">
											<div class="form-group">
												<label>Remarks</label>
												<div class="input-group">
													<span class="input-group-addon"><i
														class="form-icon sprite page"></i></span>
													<textarea class="form-control" name="shortdescription"
														id="Remarks" placeholder="Remarks"
														onblur="requiredFieldValidation('Remarks','RemarksErrorMSGdiv');"></textarea>
												</div>
												<div id="RemarksErrorMSGdiv" class="errormsg"></div>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-md-12 col-sm-12 col-xs-12 item-product-info">
											<button class="bt-link bt-radius bt-loadmore" type="submit"
												onclick="return contentsubmit();">
												Submit<i class="fa fa-paper-plane" aria-hidden="true"></i>
											</button>
										</div>
									</div>
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<%@ include file="../staticresources/includes/itswsfooter.jsp"%>
	</div>
	<%@ include file="../staticresources/includes/itswsscripts.jsp"%>
	<script type="text/javascript">
		function contentsubmit() {
			if (document.getElementById('Project_Name').value == "") {
				ProjectNameErrorMSGdiv.innerHTML = "Project_Name is required.";
				ProjectNameErrorMSGdiv.style.color = "#800606";
				return false;
			}
			if (document.getElementById('Client_Name').value == "") {
				ProjectNameErrorMSGdiv.innerHTML = "Client_Name is required.";
				ProjectNameErrorMSGdiv.style.color = "#800606";
				return false;
			}
			if (document.getElementById('InvoiceAmount').value == "") {
				ActivityTypeErrorMSGdiv.innerHTML = "InvoiceAmount is required.";
				ActivityTypeErrorMSGdiv.style.color = "#800606";
				return false;
			}
			if (document.getElementById('Billing Month').value == "") {
				ContentErrorMSGdiv.innerHTML = "Billing Month  is required.";
				ContentErrorMSGdiv.style.color = "#800606";
				return false;
			}
			if (document.getElementById('BillingDate').value == "") {
				StatusErrorMSGdiv.innerHTML = "BillingDate is required.";
				StatusErrorMSGdiv.style.color = "#800606";
				return false;
			}
			if (document.getElementById('Remarks').value == "") {
				StatusErrorMSGdiv.innerHTML = "Remarks is required.";
				StatusErrorMSGdiv.style.color = "#800606";
				return false;
			}
			if(document.getElementById('ServiceCode').value==""){
				ServiceCodeErrorMSGdiv.innerHTML="Service Code is required.";
				ServiceCodeErrorMSGdiv.style.color="#800606";
				return false; 
			    }
				if(document.getElementById('GSTCategory').value==""){
					GSTCategoryErrorMSGdiv.innerHTML="GST Category is required.";
					GSTCategoryErrorMSGdiv.style.color="#800606";
				return false;
				}
			document.addcontent.submit();
		}

		$(function() {
			$("#Project_Name").autocomplete({
				source : function(request, response) {
					$.ajax({
						url : "getprojectname.html",
						type : "POST",
						dataType : "json",
						data : {
							name : request.term, cid : document.getElementById("cid").value
						},
						success : function(data) {
							response($.map(data, function(item) {
								return {
									label: item.name,
									value: item.value,
									id: item.id,
							};}));},
							error: function (error) {
						       alert('error: ' + error);
						    }});},
							select : function(e, ui) {
						    	$("#pid").val(ui.item.id);
							},});
						});

		$(function() {
			$("#Client_Name").autocomplete({
				source : function(request, response) {
					$.ajax({
						url : "getclientname.html",
						type : "POST",
						dataType : "json",
						data : {
							name : request.term
						},
						success : function(data) {
							response($.map(data, function(item) {
								return {
									label: item.name,
									value: item.value,
									id: item.id,
									gstin: item.gstin,
							};}));},
							error: function (error) {
						       alert('error: ' + error);
						    }});},
							select : function(e, ui) {
						    	$("#cid").val(ui.item.id);
						    	getuniquecode(ui.item.gstin);
							},});
						});
		
		function approve2() {
			var info=document.getElementById('pid').value;
			if(info=="")
			{		 
				 BillingType.innerHTML="";
				 BillingAmount.innerHTML="";
				 return false;
			}
			else 
			{
			var pid=info;
			var xhttp; 
		  	xhttp = new XMLHttpRequest();
		  	xhttp.onreadystatechange = function() {
		  	if (this.readyState == 4 && this.status == 200) {
		  	var sp=xhttp.responseText.split("#");
		  	document.getElementById('BillingType').value=sp[0];
		  	document.getElementById('BillingAmount').value=sp[1];
		  	}
		  	};
		  	xhttp.open("POST", "<%=landingpage_basepath %>/BillingData111?pid="+pid, true);
		  	xhttp.send(pid);
		  	}
		};
		
		function addgst(option) {
			var invAmt = document.getElementById('InvoiceAmount').value;
			var gstTax = document.getElementById('GST').value;
			var gstAmt = 0;
			if(gstTax != "0"){
				gstAmt=(Number(invAmt)*Number(gstTax))/100;
			}
			var total=Number(invAmt)+gstAmt;
			document.getElementById('GSTValue').value=gstAmt;
			document.getElementById('TotalInvoiceAmount').value=total;
		};
		
		$(function() {
		     $( "#BillingDate" ).datepicker({
		 		changeMonth: true,
				changeYear: true,
				dateFormat: 'dd-mm-yy'
			});
		});
		
	</script>
<script type="text/javascript">
function getuniquecode(gstin){
	if(gstin=="NA"){
		cbinvno = '<%=nongststart%>';
	}
	else {
		cbinvno = '<%=gststart%>';
	}
	$.ajax({
		url: "getinvoiceno.html",
	    type: "POST",
		dataType: "html",
		data: {cbinvno: cbinvno},
		success: function(data) {			
			cbinvno = data;
			document.getElementById("InV_no").value=cbinvno;
		},
		error: function (error) {
			location.reload();
	    }
	});
}
</script>
</body>
</html>