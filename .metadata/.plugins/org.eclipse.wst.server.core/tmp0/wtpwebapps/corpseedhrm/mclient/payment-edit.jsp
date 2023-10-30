<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Edit Payment</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp"%>
</head>
<body>
	<div class="wrap">
		<%@ include file="../staticresources/includes/itswsheader.jsp"%>
		<%
	String uid=(String) session.getAttribute("passid");
	String[][] getPaymentById=null;
%>
<%if(!MP01){%><jsp:forward page="/login.html" /><%} %>
		<div id="content">
			<div class="container">
				<div class="bread-crumb">
					<div class="bd-breadcrumb bd-light">
						<a href="<%=request.getContextPath()%>/dashboard.html">Home</a> <a>Edit Payment</a>
					</div>
				</div>
			</div>
			<div class="main-content">
				<div class="container">
					<div class="row">
						<div class="col-xs-12">
							<div class="menuDv  post-slider">
								<form action="generate-payment-update.html" method="post"
									name="addcontent" id="addcontent">
									<input type="hidden" name="uid" value="<%=uid%>">
									<input type="hidden" readonly name="pid" id="pid" value="<%=getPaymentById[0][2]%>">
									<input type="hidden" readonly name="cid" id="cid" value="<%=getPaymentById[0][1]%>">
									<div class="row">
										<div class="col-md-4 col-sm-4 col-xs-12">
											<div class="form-group">
												<label>Client Name</label>
												<div class="input-group">
													<span class="input-group-addon"><i
														class="form-icon sprite full-name"></i></span> <input type="text"
														name="clientName" id="Client_Name" value="<%=getPaymentById[0][10]%>"
														placeholder="Enter Client Name" autocomplete="off"
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
														placeholder="Enter Project Name" value="<%=getPaymentById[0][9]%>"
														onblur="requiredFieldValidation('Project_Name','ProjectNameErrorMSGdiv');approve2();"
														class="form-control">
												</div>
												<div id="ProjectNameErrorMSGdiv" class="errormsg"></div>
											</div>
										</div>
										<div class="col-md-4 col-sm-4 col-xs-12">
										<div class="form-group">
										<label>Invoice No.</label>
										<div class="input-group">
										<span class="input-group-addon"><i
										class="form-icon sprite fa fa-chrome"></i></span> <input type="text"
										name="InVno" id="InV_no" value="<%=getPaymentById[0][3]%>"
										placeholder="Enter Invoice No" class="form-control">
										</div>
										<div id="InV_noErrorMSGdiv" class="errormsg"></div>
										</div>
										</div>
									</div>
									<div class="row">
										<div class="col-md-4 col-sm-4 col-xs-12">
											<div class="form-group">
												<label>Invoice Amount</label>
												<div class="input-group">
													<span class="input-group-addon"><i
														class="form-icon sprite list"></i></span> <input type="text"
														name="InvoiceAmount" id="InvoiceAmount" value="<%=getPaymentById[0][4]%>"
														class="form-control" placeholder="Enter Invoice Amount">
												</div>
												<div id="InvoiceAmountErrorMSGdiv" class="errormsg"></div>
											</div>
										</div>
										<div class="col-md-4 col-sm-4 col-xs-12">
											<div class="form-group">
												<label>Amount Received</label>
												<div class="input-group">
													<span class="input-group-addon"><i
														class="form-icon sprite list"></i></span> <input type="text"
														name="AmountReceived" id="Amount Received"
														placeholder="Enter Amount Received" value="<%=getPaymentById[0][5]%>"
														onblur="requiredFieldValidation('Amount Received','AmountReceivedErrorMSGdiv');"
														class="form-control">
												</div>
												<div id="AmountReceivedErrorMSGdiv" class="errormsg"></div>
											</div>
										</div>
										<div class="col-md-4 col-sm-4 col-xs-12">
											<div class="form-group">
												<label>Payment Status</label>
												<div class="input-group">
													<span class="input-group-addon"><i
														class="form-icon sprite list"></i></span> <select
														name="PaymentStatus" id="Payment Status"
														onblur="requiredFieldValidation('Payment Status','PaymentStatusErrorMSGdiv');"
														class="form-control">
														<%
						                                  if(getPaymentById[0][6]!=null)
						                                  {%>
						                                	 <option value="<%=getPaymentById[0][6] %>"><%=getPaymentById[0][6] %></option> 
						                                  <%}%>
                                  						<option>Select Payment Status</option>
														<option value="Partial">Partial</option>
														<option value="Full">Full</option>
													</select>
												</div>
												<div id="PaymentStatusAmountErrorMSGdiv" class="errormsg"></div>
											</div>
											</div>
										</div>
										<div class="row">
										<div class="col-md-4 col-sm-4 col-xs-12">
											<div class="form-group">
												<label>Receiving Date</label>
												<div class="input-group">
													<span class="input-group-addon"><i
														class="form-icon sprite list"></i></span> <input type="text"
														name="ReceivingDate" id="RecevingDate"
														placeholder="Enter Receiving Date" value="<%=getPaymentById[0][7]%>"
														onblur="requiredFieldValidation('ReceivingDate','ReceivingDateErrorMSGdiv');"
														class="form-control">
												</div>
												<div id="ReceivingDateErrorMSGdiv" class="errormsg"></div>
											</div>
										</div>
										<div class="col-md-4 col-sm-4 col-xs-12">
											<div class="form-group">
												<label>Status</label>
												<div class="input-group">
													<span class="input-group-addon"><i
														class="form-icon sprite list"></i></span> <select
														name="Status" id="Status"
														onblur="requiredFieldValidation('Status','StatusErrorMSGdiv');"
														class="form-control">
														<option value="<%=getPaymentById[0][11]%>"><%=getPaymentById[0][11]%></option>
														<option value="Active">Active</option>
														<option value="Inactive">Inactive</option>
														</select>
												</div>
												<div id="StatusErrorMSGdiv" class="errormsg"></div>
											</div>
										</div>
										<div class="col-md-4 col-sm-4 col-xs-12">
											<div class="form-group">
												<label>Next Billing Date</label>
												<div class="input-group">
													<span class="input-group-addon"><i
														class="form-icon sprite list"></i></span> <input type="text"
														name="NextBillingDate" id="NextBillingDate"
														placeholder="Enter Next Billing Date" value="<%=getPaymentById[0][12]%>"
														onblur="requiredFieldValidation('NextBillingDate','NextBillingDateErrorMSGdiv');"
														class="form-control">
												</div>
												<div id="NextBillingDateErrorMSGdiv" class="errormsg"></div>
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
														onblur="requiredFieldValidation('Remarks','RemarksErrorMSGdiv');"><%=getPaymentById[0][8]%></textarea>
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
			if (document.getElementById('Amount Received').value == "") {
				ActivityTypeErrorMSGdiv.innerHTML = "Amount Received is required.";
				ActivityTypeErrorMSGdiv.style.color = "#800606";
				return false;
			}
			if (document.getElementById('Payment Status').value == "") {
				ContentErrorMSGdiv.innerHTML = "Payment Status  is required.";
				ContentErrorMSGdiv.style.color = "#800606";
				return false;
			}
			if (document.getElementById('RecevingDate').value == "") {
				StatusErrorMSGdiv.innerHTML = "RecevingDate is required.";
				StatusErrorMSGdiv.style.color = "#800606";
				return false;
			}
			if (document.getElementById('Remarks').value == "") {
				StatusErrorMSGdiv.innerHTML = "Remarks is required.";
				StatusErrorMSGdiv.style.color = "#800606";
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
							};}));},
							error: function (error) {
						       alert('error: ' + error);
						    }});},
							select : function(e, ui) {
						    	$("#cid").val(ui.item.id);
							},});
						});
		
		function approve2() {
			var info=document.getElementById('pid').value;
			 if(info=="")
			 {		 
				 InvoiceNo.innerHTML="";
				 InvoiceAmount.innerHTML="";
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
		  	document.getElementById('InV_no').value=sp[0];
		  	document.getElementById('InvoiceAmount').value=sp[1];
		  	}
		  	};
		  	xhttp.open("POST", "<%=request.getContextPath()%>/InvoiceData111?pid="+pid, true);
		  	xhttp.send(pid);
		  	}
		};
		
		$(function() {
		     $( "#RecevingDate" ).datepicker({
		 		changeMonth: true,
				changeYear: true,
				dateFormat: 'dd-mm-yy'
			});
		});
		$(function() {
		     $( "#NextBillingDate" ).datepicker({
		 		changeMonth: true,
				changeYear: true,
				dateFormat: 'dd-mm-yy'
			});
		});
	</script>
</body>
</html>