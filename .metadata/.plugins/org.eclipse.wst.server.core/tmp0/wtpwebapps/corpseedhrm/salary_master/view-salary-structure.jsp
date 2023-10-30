<!DOCTYPE HTML>
<%@page import="salary_master.SalaryStr_ACT"%>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Employee Salary Structure</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<div class="wrap">
<% 
String salid=(String) session.getAttribute("passid");
String[][] salStr = SalaryStr_ACT.getSalaryStrById(salid); %>
<div id="content">
		<div class="container">
			<div class="row">
				<div class="col-xs-12">
					<div class="menuDv post-slider advert mb10 clearfix">
						<form>
						  <div class="row">
						  <div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>Employee Name :<span style="color: red;">*</span></label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
							  <input type="text" name="emname" id="emname" class="form-control" readonly value="<%=salStr[0][17]%>">
							  </div>
							 </div>
							</div>
						  <div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>Employee ID :<span style="color: red;">*</span></label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
							  <input type="text" name="emuid" id="emuid" readonly class="form-control" value="<%=salStr[0][18]%>">
							  </div>
							 </div>
							</div>
							<div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>Employee Department :<span style="color: red;">*</span></label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
							  <input type="text" name="emdept" id="emdept" readonly class="form-control" value="<%=salStr[0][19]%>">
							  </div>
							 </div>
							</div>                              
						   <div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>Employee Designation :<span style="color: red;">*</span></label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
							  <input type="text" name="emdesig" id="emdesig" readonly class="form-control" value="<%=salStr[0][20]%>">
							   </div>
							 </div>
							</div>
							</div>
						  <div class="row">
							<div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>CTC :<span style="color: red;">*</span></label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
							  <input type="text" name="CTC" id="CTC" readonly class="form-control" value="<%=salStr[0][1]%>">
							  </div>
							 </div>
							</div>
						   <div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>Leaves Allowed :<span style="color: red;">*</span></label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
							  <input type="text" name="LeavesAllowed" id="LeavesAllowed" readonly class="form-control" value="<%=salStr[0][2]%>">
							   </div>
							 </div>
							</div>                              
							<div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>Total Gross Salary :<span style="color: red;">*</span></label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
							  <input type="text" name="GrossSalary" id="GrossSalary" readonly class="form-control" value="<%=salStr[0][3]%>">
							  </div>
							 </div>
							</div>                                
						  <div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>Basic Salary :<span style="color: red;">*</span></label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite info"></i></span>
							  <input type="text" name="BasicSalary" id="BasicSalary" readonly class="form-control" value="<%=salStr[0][4]%>">
							  </div>
							 </div>
							</div>
						  </div>
						  <div class="row">
							 <div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>DA :<span style="color: red;">*</span></label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite info"></i></span>
							  <input type="text" name="DA" id="DA" readonly class="form-control" value="<%=salStr[0][5]%>">
							  </div>
							 </div>
							</div>
							<div class="col-md-3 col-sm-3 col-xs-12">
							<div class="form-group">
							  <label>HRA :<span style="color: red;">*</span></label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
							  <input type="text" name="HRA" id="HRA" readonly class="form-control" value="<%=salStr[0][6]%>">
							  </div>
							</div>
							</div>                              
							<div class="col-md-3 col-sm-3 col-xs-12">
							<div class="form-group">
							  <label>Conveyance :<span style="color: red;">*</span></label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
							  <input type="text" name="Conveyance" id="Conveyance" readonly class="form-control" value="<%=salStr[0][7]%>">
							  </div>
							</div>
							</div>
							<div class="col-md-3 col-sm-3 col-xs-12">
							<div class="form-group">
							  <label>Medical Expenses :<span style="color: red;">*</span></label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
							  <input type="text" name="MedicalExpenses" id="MedicalExpenses" readonly class="form-control" value="<%=salStr[0][8]%>">
							  </div>
							</div>
							</div>
							</div>
						  <div class="row">
							<div class="col-md-3 col-sm-3 col-xs-12">
							<div class="form-group">
							  <label>Special :<span style="color: red;">*</span></label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
							  <input type="text" name="Special" id="Special" readonly class="form-control" value="<%=salStr[0][9]%>">
							  </div>
							</div>
							</div>                              
							<div class="col-md-3 col-sm-3 col-xs-12">
							<div class="form-group">
							  <label>Bonus :<span style="color: red;">*</span></label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
							  <input type="text" name="Bonus" id="Bonus" readonly class="form-control" value="<%=salStr[0][10]%>">
							  </div>
							</div>
							</div>
							<div class="col-md-3 col-sm-3 col-xs-12">
							<div class="form-group">
							  <label>TA :<span style="color: red;">*</span></label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
							  <input type="text" name="TA" id="TA" readonly class="form-control" value="<%=salStr[0][11]%>">
							  </div>
							</div>
							</div>                              
						  <div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>Total Deductions :<span style="color: red;">*</span></label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
							  <input type="text" name="TotalDeductions" id="TotalDeductions" readonly class="form-control" value="<%=salStr[0][12]%>">
							  </div>
							 </div>
							</div>
						  </div>
						  <div class="row">
							<div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>PF :<span style="color: red;">*</span></label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
							  <input type="text" name="PF" id="PF" readonly class="form-control" value="<%=salStr[0][13]%>">
							  </div>
							 </div>
							</div>
						   <div class="col-md-3 col-sm-3 col-xs-12">
							 <div class="form-group">
							  <label>Professional Tax :<span style="color: red;">*</span></label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
							  <input type="text" name="ProfessionalTax" id="ProfessionalTax" readonly class="form-control" value="<%=salStr[0][14]%>">
							   </div>
							 </div>
							</div>
							<div class="col-md-3 col-sm-3 col-xs-12">
							<div class="form-group">
							  <label>TDS :<span style="color: red;">*</span></label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
							  <input type="text" name="TDS" id="TDS" readonly class="form-control" value="<%=salStr[0][15]%>">
							  </div>
							</div>
							</div>                              
						  <div class="col-md-3 col-sm-3 col-xs-12">
							<div class="form-group">
							  <label>Net Salary Payable :<span style="color: red;">*</span></label>
							  <div class="input-group">
							  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
							  <input type="text" name="Payable" id="Payable" readonly class="form-control" value="<%=salStr[0][16]%>">
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
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
</body>
</html>