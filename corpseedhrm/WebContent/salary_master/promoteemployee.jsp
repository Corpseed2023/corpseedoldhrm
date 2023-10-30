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
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<% 	
String salid=(String) session.getAttribute("passid");
String[][] salStr = SalaryStr_ACT.getSalaryStrById(salid); %>
<%if(!SAL04){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
    <div class="container">   
      <div class="bread-crumb">
        <div class="bd-breadcrumb bd-light">
        <a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
        <a>Employee Salary Structure</a>
        </div>
      </div>
    </div>

    <div class="main-content">
        <div class="container">
            <div class="row">
                <div class="col-xs-12">
                    <div class="menuDv post-slider clearfix">
                        <form action="<%=request.getContextPath() %>/promote-salary-structure.html" method="post" name="registerEmployee" id="registerEmployee">
                        <input type="hidden" name="salid" id="salid" readonly value="<%=salStr[0][0]%>">
                        <input type="hidden" name="emid" id="emid" readonly value="<%=salStr[0][21]%>">
                          <div class="row">
                          <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Employee Name :<span style="color: red;">*</span></label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-user"></i></span>
                              <input type="text" autocomplete="off" name="EmployeeName" id="EmployeeName" value="<%=salStr[0][18]%>" placeholder="Enter Employee Name" onblur="requiredFieldValidation('EmployeeName','EmployeeNameEerorMSGdiv');" class="form-control" readonly>
                              </div>
                              <div id="EmployeeNameEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                          <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Employee ID :<span style="color: red;">*</span></label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-user"></i></span>
                              <input type="text" name="EmployeeID" id="emuid" readonly class="form-control" value="<%=salStr[0][17]%>">
                              </div>
                             </div>
                            </div>
                            <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Employee Department :<span style="color: red;">*</span></label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-briefcase"></i></span>
                              <input type="text" name="EmployeeDepartment" id="emdept" readonly class="form-control" value="<%=salStr[0][19]%>">
                              </div>
                             </div>
                            </div>                              
                           <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Employee Designation :<span style="color: red;">*</span></label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-line-chart"></i></span>
                              <input type="text" name="EmployeeDesignation" id="emdesig" class="form-control" value="<%=salStr[0][20]%>">
                               </div>
                             </div>
                            </div>
                            </div>
                          <div class="row">
                            <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>CTC :<span style="color: red;">*</span></label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
                              <input type="text" name="CTC" id="CTC" placeholder="Enter CTC" value="<%=salStr[0][1]%>" onblur="requiredFieldValidation('CTC','CTCEerorMSGdiv');" class="form-control" onkeypress="return isNumberKey(event)">
                              </div>
                              <div id="CTCEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                           <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Leaves Allowed :<span style="color: red;">*</span></label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-lock"></i></span>
                              <input type="text" name="LeavesAllowed" id="LeavesAllowed" value="<%=salStr[0][2]%>" placeholder="Enter Leaves Allowed" onblur="requiredFieldValidation('LeavesAllowed','LeavesAllowedEerorMSGdiv');" class="form-control" onkeypress="return isNumber(event)">
                               </div>
                               <div id="LeavesAllowedEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>                       
                          <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Basic Salary :<span style="color: red;">*</span></label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
                              <input type="text" name="BasicSalary" id="BasicSalary" value="<%=salStr[0][4]%>" placeholder="Enter Basic Salary" onblur="addGross(this.value);netPay();requiredFieldValidation('BasicSalary','BasicSalaryEerorMSGdiv');" class="form-control" onkeypress="return isNumberKey(event)">
                              </div>
                              <div id="BasicSalaryEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                            <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Total Gross Salary :<span style="color: red;">*</span></label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
                              <input type="text" name="GrossSalary" id="GrossSalary" readonly class="form-control" value="<%=salStr[0][3]%>">
                              </div>
                             </div>
                            </div>
                             </div>
                          <div class="row">
                             <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>DA :<span style="color: red;">*</span></label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-home"></i></span>
                              <input type="text" name="DA" id="DA" placeholder="Enter DA" value="<%=salStr[0][5]%>" onblur="addGross(this.value);netPay();requiredFieldValidation('DA','DAEerorMSGdiv');" class="form-control" onkeypress="return isNumberKey(event)">
                              </div>
                              <div id="DAEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                            <div class="col-md-3 col-sm-3 col-xs-12">
                            <div class="form-group">
                              <label>HRA :<span style="color: red;">*</span></label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-home"></i></span>
                              <input type="text" name="HRA" id="HRA" placeholder="Enter HRA" value="<%=salStr[0][6]%>" onblur="addGross(this.value);netPay();requiredFieldValidation('HRA','HRAEerorMSGdiv');" class="form-control" onkeypress="return isNumberKey(event)">
                              </div>
                              <div id="HRAEerorMSGdiv" class="errormsg"></div>
                            </div>
                            </div>                              
                            <div class="col-md-3 col-sm-3 col-xs-12">
                            <div class="form-group">
                              <label>Conveyance :<span style="color: red;">*</span></label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-car"></i></span>
                              <input type="text" name="Conveyance" id="Conveyance" value="<%=salStr[0][7]%>" placeholder="Enter Conveyance" onblur="addGross(this.value);netPay();requiredFieldValidation('Conveyance','ConveyanceEerorMSGdiv');" class="form-control" onkeypress="return isNumberKey(event)">
                              </div>
                              <div id="ConveyanceEerorMSGdiv" class="errormsg"></div>
                            </div>
                            </div>
                            <div class="col-md-3 col-sm-3 col-xs-12">
                            <div class="form-group">
                              <label>Medical Expenses :<span style="color: red;">*</span></label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-medkit"></i></span>
                              <input type="text" name="MedicalExpenses" id="MedicalExpenses" value="<%=salStr[0][8]%>" placeholder="Enter MedicalExpenses" onblur="addGross(this.value);netPay();requiredFieldValidation('MedicalExpenses','MedicalExpensesEerorMSGdiv');" class="form-control" onkeypress="return isNumberKey(event)">
                              </div>
                              <div id="MedicalExpensesEerorMSGdiv" class="errormsg"></div>
                            </div>
                            </div>
                            </div>
                          <div class="row">
                            <div class="col-md-3 col-sm-3 col-xs-12">
                            <div class="form-group">
                              <label>Special :<span style="color: red;">*</span></label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-user-secret"></i></span>
                              <input type="text" name="Special" id="Special" placeholder="Enter Special" value="<%=salStr[0][9]%>" onblur="addGross(this.value);netPay();requiredFieldValidation('Special','SpecialEerorMSGdiv');" class="form-control" onkeypress="return isNumberKey(event)">
                              </div>
                              <div id="SpecialEerorMSGdiv" class="errormsg"></div>
                            </div>
                            </div>                              
                            <div class="col-md-3 col-sm-3 col-xs-12">
                            <div class="form-group">
                              <label>Bonus :<span style="color: red;">*</span></label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
                              <input type="text" name="Bonus" id="Bonus" value="<%=salStr[0][10]%>" placeholder="Enter Bonus" onblur="addGross(this.value);netPay();requiredFieldValidation('Bonus','BonusEerorMSGdiv');" class="form-control" onkeypress="return isNumberKey(event)">
                              </div>
                              <div id="BonusEerorMSGdiv" class="errormsg"></div>
                            </div>
                            </div>
                            <div class="col-md-3 col-sm-3 col-xs-12">
                            <div class="form-group">
                              <label>TA :<span style="color: red;">*</span></label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-bus"></i></span>
                              <input type="text" name="TA" id="TA" value="<%=salStr[0][11]%>" placeholder="Enter TA" onblur="addGross(this.value);netPay();requiredFieldValidation('TA','TAEerorMSGdiv');" class="form-control" onkeypress="return isNumberKey(event)">
                              </div>
                              <div id="TAEerorMSGdiv" class="errormsg"></div>
                            </div>
                            </div>                              
                          <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Total Deductions :<span style="color: red;">*</span></label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
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
                              <span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
                              <input type="text" name="PF" id="PF" placeholder="Enter PF" value="<%=salStr[0][13]%>" onblur="addDed(this.value);netPay();requiredFieldValidation('PF','PFEerorMSGdiv');" class="form-control" onkeypress="return isNumberKey(event)">
                              </div>
                              <div id="PFEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                           <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Professional Tax :<span style="color: red;">*</span></label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
                              <input type="text" name="ProfessionalTax" id="ProfessionalTax" value="<%=salStr[0][14]%>" placeholder="Enter Professional Tax" onblur="addDed(this.value);netPay();requiredFieldValidation('ProfessionalTax','ProfessionalTaxEerorMSGdiv');" class="form-control" onkeypress="return isNumberKey(event)">
                               </div>
                               <div id="ProfessionalTaxEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                            <div class="col-md-3 col-sm-3 col-xs-12">
                            <div class="form-group">
                              <label>TDS :<span style="color: red;">*</span></label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
                              <input type="text" name="TDS" id="TDS" placeholder="Enter TDS" value="<%=salStr[0][15]%>" onblur="addDed(this.value);netPay();requiredFieldValidation('TDS','TDSEerorMSGdiv');" class="form-control" onkeypress="return isNumberKey(event)">
                              </div>
                              <div id="TDSEerorMSGdiv" class="errormsg"></div>
                            </div>
                            </div>                            
                          <div class="col-md-3 col-sm-3 col-xs-12">
                            <div class="form-group">
                              <label>Net Salary Payable :<span style="color: red;">*</span></label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
                              <input type="text" name="Payable" id="Payable" readonly class="form-control" value="<%=salStr[0][16]%>">
                              </div>
                              <div id="DateOfBirthEerorMSGdiv" class="errormsg"></div>
                            </div>
                            </div>
                            </div>
                          <div class="row">
                            <div class="col-md-12 col-sm-12 col-xs-12 item-product-info">
                            <button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateSalaryStructure();">Promote<i class="fa fa-paper-plane" aria-hidden="true"></i></button>
                            </div>
                          </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
function addGross(amount) {
	var BasicSalary = document.getElementById('BasicSalary').value;
	var DA = document.getElementById('DA').value;
	var HRA = document.getElementById('HRA').value;
	var Conveyance = document.getElementById('Conveyance').value;
	var MedicalExpenses = document.getElementById('MedicalExpenses').value;
	var Special = document.getElementById('Special').value;
	var Bonus = document.getElementById('Bonus').value;
	var TA = document.getElementById('TA').value;

	var Total = Number(BasicSalary) + Number(DA) + Number(HRA)
			+ Number(Conveyance) + Number(MedicalExpenses)
			+ Number(Special) + Number(Bonus) + Number(TA);
	
	document.getElementById('GrossSalary').value = Total;
}

function addDed(amount) {
	var PF = document.getElementById('PF').value;
	var ProfessionalTax = document.getElementById('ProfessionalTax').value;
	var TDS = document.getElementById('TDS').value;
	
	var Total = Number(PF) + Number(ProfessionalTax) + Number(TDS);
	
	document.getElementById('TotalDeductions').value = Total;
}

function netPay() {
	var GrossSalary = document.getElementById('GrossSalary').value
	var TotalDeductions = document.getElementById('TotalDeductions').value
	
	var Total = Number(GrossSalary) - Number(TotalDeductions);
	
	document.getElementById('Payable').value = Total;
}
</script>
<script type="text/javascript">
function validateSalaryStructure() {

		if (document.getElementById('EmployeeName').value.trim() == "") {
			EmployeeNameEerorMSGdiv.innerHTML = "Employee Name is required.";
			EmployeeNameEerorMSGdiv.style.color = "red";
			return false;
		}
		if (document.getElementById('CTC').value.trim() == "") {
			CTCEerorMSGdiv.innerHTML = "CTC is required.";
			CTCEerorMSGdiv.style.color = "red";
			return false;
		}
		if (document.getElementById('LeavesAllowed').value.trim() == "") {
			LeavesAllowedEerorMSGdiv.innerHTML = "Leaves Allowed is required.";
			LeavesAllowedEerorMSGdiv.style.color = "red";
			return false;
		}
		if (document.getElementById('BasicSalary').value.trim() == "") {
			BasicSalaryEerorMSGdiv.innerHTML = "Basic Salary is required.";
			BasicSalaryEerorMSGdiv.style.color = "red";
			return false;
		}
		if (document.getElementById('DA').value.trim() == "") {
			DAEerorMSGdiv.innerHTML = "DA is required.";
			DAEerorMSGdiv.style.color = "red";
			return false;
		}
		if (document.getElementById('HRA').value.trim() == "") {
			HRAEerorMSGdiv.innerHTML = "HRA  is required.";
			HRAEerorMSGdiv.style.color = "red";
			return false;
		}
		if (document.getElementById('Conveyance').value.trim() == "") {
			ConveyanceEerorMSGdiv.innerHTML = "Conveyance is required.";
			ConveyanceEerorMSGdiv.style.color = "red";
			return false;
		}
		if (document.getElementById('MedicalExpenses').value.trim() == "") {
			MedicalExpensesEerorMSGdiv.innerHTML = "Medical Expenses is required.";
			MedicalExpensesEerorMSGdiv.style.color = "red";
			return false;
		}
		if (document.getElementById('Special').value.trim() == "") {
			SpecialEerorMSGdiv.innerHTML = "Special is required.";
			SpecialEerorMSGdiv.style.color = "red";
			return false;
		}
		if (document.getElementById('Bonus').value.trim() == "") {
			BonusEerorMSGdiv.innerHTML = "Bonus is required.";
			BonusEerorMSGdiv.style.color = "red";
			return false;
		}
		if (document.getElementById('TA').value.trim() == "") {
			TAEerorMSGdiv.innerHTML = "TA is required.";
			TAEerorMSGdiv.style.color = "red";
			return false;
		}
		if (document.getElementById('PF').value.trim() == "") {
			PFEerorMSGdiv.innerHTML = "PF is required.";
			PFEerorMSGdiv.style.color = "red";
			return false;
		}
		if (document.getElementById('ProfessionalTax').value.trim() == "") {
			ProfessionalTaxEerorMSGdiv.innerHTML = "Professional Tax is required.";
			ProfessionalTaxEerorMSGdiv.style.color = "red";
			return false;
		}
		if (document.getElementById('TDS').value.trim() == "") {
			TDSEerorMSGdiv.innerHTML = "TDS is required.";
			TDSEerorMSGdiv.style.color = "red";
			return false;
		}
		
// 			document.registerEmployee.submit();
	}
</script>
</body>
</html>