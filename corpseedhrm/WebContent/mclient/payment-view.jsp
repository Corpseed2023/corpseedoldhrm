<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>View Payment</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp"%>
</head>
<body>
	<div class="wrap">
		<%@ include file="../staticresources/includes/itswsheader.jsp"%>
		<% String uid=(String) session.getAttribute("passid");
	String[][] getPaymentById=null; %>
<%if(!MP01){%><jsp:forward page="/login.html" /><%} %>
		<div id="content">
			<div class="container">
				<div class="bread-crumb">
					<div class="bd-breadcrumb bd-light">
						<a href="<%=request.getContextPath()%>/dashboard.html">Home</a> <a>View Payment</a>
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
									<div class="row">
										<div class="col-md-4 col-sm-4 col-xs-12">
											<div class="form-group">
												<label>Client Name</label>
												<div class="input-group">
													<span class="input-group-addon"><i
														class="form-icon sprite full-name"></i></span> <input type="text"
														name="clientName" id="Client_Name" value="<%=getPaymentById[0][10]%>"
														placeholder="Enter Client Name" readonly
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
														name="projectName" id="Project_Name" readonly
														placeholder="Enter Project Name" value="<%=getPaymentById[0][9]%>"
														onblur="requiredFieldValidation('Project_Name','ProjectNameErrorMSGdiv');approve2(this.value);"
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
										readonly class="form-control">
										</div>
										<div id="InV_noErrorMSGdiv" class="errormsg"></div>
										</div>
										</div>
										<div class="col-md-4 col-sm-4 col-xs-12">
											<div class="form-group">
												<label>Invoice Amount</label>
												<div class="input-group">
													<span class="input-group-addon"><i
														class="form-icon sprite list"></i></span> <input type="text"
														name="InvoiceAmount" id="InvoiceAmount" readonly value="<%=getPaymentById[0][4]%>"
														class="form-control">
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
														name="AmountReceived" id="Amount Received" readonly
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
														name="PaymentStatus" id="Payment Status" readonly="readonly"
														onblur="requiredFieldValidation('Payment Status','PaymentStatusErrorMSGdiv');"
														class="form-control">
														<%
						                                  if(getPaymentById[0][6]!=null)
						                                  {%>
						                                	 <option value="<%=getPaymentById[0][6] %>"><%=getPaymentById[0][6] %></option> 
						                                  <%}%>
													</select>
												</div>
												<div id="PaymentStatusAmountErrorMSGdiv" class="errormsg"></div>
											</div>
											</div>
										<div class="col-md-4 col-sm-4 col-xs-12">
											<div class="form-group">
												<label>Receiving Date</label>
												<div class="input-group">
													<span class="input-group-addon"><i
														class="form-icon sprite list"></i></span> <input type="text"
														name="ReceivingDate" id="RecevingDate" readonly
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
														class="form-icon sprite list"></i></span> <input type="text"
														name="Status" id="Status" value="<%=getPaymentById[0][11]%>" readonly
														class="form-control">
												</div>
											</div>
										</div>
										<div class="col-md-4 col-sm-4 col-xs-12">
											<div class="form-group">
												<label>Next Billing Date</label>
												<div class="input-group">
													<span class="input-group-addon"><i
														class="form-icon sprite list"></i></span> <input type="text"
														name="NextBillingDate" id="NextBillingDate" value="<%=getPaymentById[0][12]%>" readonly
														class="form-control">
												</div>
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
														id="Remarks" placeholder="Remarks" readonly
														onblur="requiredFieldValidation('Remarks','RemarksErrorMSGdiv');"><%=getPaymentById[0][8]%></textarea>
												</div>
												<div id="RemarksErrorMSGdiv" class="errormsg"></div>
											</div>
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
</body>
</html>