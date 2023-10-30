<!DOCTYPE HTML>
<%@page import="salary_master.SalaryMon_ACT"%>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Employee Monthly Salary</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<div class="wrap">
<%
String salmid=(String) session.getAttribute("passid");
String[][] salMon = SalaryMon_ACT.getSalaryMonById(salmid); %> 
<div id="content">
	<div class="main-content">
		<div class="container">
			<div class="row">
				<div class="col-xs-12">
					<div class="menuDv post-slider clearfix">
						<form>
						  <div class="row">
						  <div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>Employee Name</label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
							  <input type="text" name="EmployeeName" id="EmployeeName" readonly class="form-control" title="<%=salMon[0][20]%>" value="<%=salMon[0][20]%>">
							  </div>
							 </div>
							</div>
						  <div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>Employee ID</label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
							  <input type="text" name="EmployeeID" id="emuid" readonly class="form-control" title="<%=salMon[0][21]%>" value="<%=salMon[0][21]%>">
							  </div>
							 </div>
							</div>
							<div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>Employee Department</label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
							  <input type="text" name="EmployeeDepartment" id="emdept" readonly class="form-control" title="<%=salMon[0][22]%>" value="<%=salMon[0][22]%>">
							  </div>
							 </div>
							</div>                              
						   <div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>Employee Designation</label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
							  <input type="text" name="EmployeeDesignation" id="emdesig" readonly class="form-control" title="<%=salMon[0][23]%>" value="<%=salMon[0][23]%>">
							   </div>
							 </div>
							</div>
							</div>
						  <div class="row">
							<div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>For the month of:</label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
							  <input type="text" name="Month" id="Month" readonly class="form-control" title="<%=salMon[0][2]%>" value="<%=salMon[0][2]%>">
							  </div>
							 </div>
							</div>
						   <div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>No of Days in month</label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
							  <input type="text" name="Days" id="Days" readonly class="form-control" title="<%=salMon[0][3]%>" value="<%=salMon[0][3]%>">
							   </div>
							 </div>
							</div>                              
						   <div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>Leaves Allowed</label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
							  <input type="text" name="LeavesAllowed" id="LeavesAllowed" readonly class="form-control" title="<%=salMon[0][4]%>" value="<%=salMon[0][4]%>">
							   </div>
							 </div>
							</div>
							<div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>Leaves Taken</label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
							  <input type="text" name="LeavesTaken" id="LeavesTaken" readonly class="form-control" title="<%=salMon[0][5]%>" value="<%=salMon[0][5]%>">
							  </div>
							 </div>
							</div>
							</div>
						  <div class="row">
						  <div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>Working Days</label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
							  <input type="text" name="WorkingDays" id="WorkingDays" readonly class="form-control" title="<%=salMon[0][25]%>" value="<%=salMon[0][25]%>">
							  </div>
							 </div>
							</div>                              
							<div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>Total Gross Salary</label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
							  <input type="text" name="GrossSalary" id="GrossSalary" readonly class="form-control" title="<%=salMon[0][6]%>" value="<%=salMon[0][6]%>">
							  </div>
							 </div>
							</div>                                
						  <div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>Basic Salary</label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite info"></i></span>
							  <input type="text" name="BasicSalary" id="BasicSalary" readonly class="form-control" title="<%=salMon[0][7]%>" value="<%=salMon[0][7]%>">
							  </div>
							 </div>
							</div>
							 <div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>DA</label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite info"></i></span>
							  <input type="text" name="DA" id="DA" readonly class="form-control" title="<%=salMon[0][8]%>" value="<%=salMon[0][8]%>">
							  </div>
							 </div>
							</div>
							</div>
						  <div class="row">
							<div class="col-md-3 col-sm-3 col-xs-12">
							<div class="form-group">
							  <label>HRA</label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
							  <input type="text" name="HRA" id="HRA" readonly class="form-control" title="<%=salMon[0][9]%>" value="<%=salMon[0][9]%>">
							  </div>
							</div>
							</div>                              
							<div class="col-md-3 col-sm-3 col-xs-12">
							<div class="form-group">
							  <label>Conveyance</label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
							  <input type="text" name="Conveyance" id="Conveyance" readonly class="form-control" title="<%=salMon[0][10]%>" value="<%=salMon[0][10]%>">
							  </div>
							</div>
							</div>
							<div class="col-md-3 col-sm-3 col-xs-12">
							<div class="form-group">
							  <label>Medical Expenses</label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
							  <input type="text" name="MedicalExpenses" id="MedicalExpenses" readonly class="form-control" title="<%=salMon[0][11]%>" value="<%=salMon[0][11]%>">
							  </div>
							</div>
							</div>
							<div class="col-md-3 col-sm-3 col-xs-12">
							<div class="form-group">
							  <label>Special</label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
							  <input type="text" name="Special" id="Special" readonly class="form-control" title="<%=salMon[0][12]%>" value="<%=salMon[0][12]%>">
							  </div>
							</div>
							</div>
						  </div>
						  <div class="row">
							<div class="col-md-3 col-sm-3 col-xs-12">
							<div class="form-group">
							  <label>Bonus</label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
							  <input type="text" name="Bonus" id="Bonus" readonly class="form-control" title="<%=salMon[0][13]%>" value="<%=salMon[0][13]%>">
							  </div>
							</div>
							</div>
							<div class="col-md-3 col-sm-3 col-xs-12">
							<div class="form-group">
							  <label>TA</label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
							  <input type="text" name="TA" id="TA" readonly class="form-control" title="<%=salMon[0][14]%>" value="<%=salMon[0][14]%>">
							  </div>
							</div>
							</div>                              
						  <div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>Total Deductions</label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
							  <input type="text" name="TotalDeductions" id="TotalDeductions" readonly class="form-control" title="<%=salMon[0][15]%>" value="<%=salMon[0][15]%>">
							  </div>
							 </div>
							</div>                              
							<div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>PF</label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
							  <input type="text" name="PF" id="PF" readonly class="form-control" title="<%=salMon[0][16]%>" value="<%=salMon[0][16]%>">
							  </div>
							 </div>
							</div>
							</div>
						  <div class="row">
						   <div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>Professional Tax</label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
							  <input type="text" name="ProfessionalTax" id="ProfessionalTax" readonly class="form-control" title="<%=salMon[0][17]%>" value="<%=salMon[0][17]%>">
							   </div>
							 </div>
							</div>
							<div class="col-md-3 col-sm-3 col-xs-12">
							<div class="form-group">
							  <label>TDS</label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
							  <input type="text" name="TDS" id="TDS" readonly class="form-control" title="<%=salMon[0][18]%>" value="<%=salMon[0][18]%>">
							  </div>
							</div>
						  </div>                             
						  <div class="col-md-3 col-sm-3 col-xs-12">
							<div class="form-group">
							<label>Other Deductions</label>
							<div class="input-group">
							<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
							<input type="text" name="OtherDeductions" id="OtherDeductions" onblur="addDed(this.value);netPay();" readonly class="form-control" title="<%=salMon[0][26]%>" value="<%=salMon[0][26]%>">
							</div>
							</div>
						  </div>

						  <div class="col-md-3 col-sm-3 col-xs-12">
							<div class="form-group">
							  <label>Net Salary Payable</label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
							  <input type="text" name="Payable" id="Payable" readonly class="form-control" title="<%=salMon[0][19]%>" value="<%=salMon[0][19]%>">
							  </div>
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
</div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
</body>
</html>