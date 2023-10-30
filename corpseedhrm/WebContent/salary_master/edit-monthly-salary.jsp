<%String landingpage_basepath = request.getContextPath();%>
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
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<% 	String addedby= (String)session.getAttribute("loginuID");
String salmid=(String) session.getAttribute("passid");
String[][] salMon = SalaryMon_ACT.getSalaryMonById(salmid); 
%>
<%if(!MSL03){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
    <div class="container">   
      <div class="bread-crumb">
        <div class="bd-breadcrumb bd-light">
        <a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
        <a>Employee Monthly Salary</a>
        </div>
      </div>
    </div>

    <div class="main-content">
        <div class="container">
            <div class="row">
                <div class="col-xs-12">
                    <div class="menuDv post-slider clearfix">
                        <form action="<%=request.getContextPath() %>/update-monthy-salary.html" method="post" name="registerEmployee" id="registerEmployee">
                        <input type="hidden" name="addeduser" value="<%=addedby%>" readonly>
                        <input type="hidden" name="emid" id="emid" readonly value="<%=salMon[0][24]%>">
                        <input type="hidden" name="salmid" id="salmid" readonly value="<%=salMon[0][0]%>">
                          <div class="row">
                          <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Employee Name</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-user"></i></span>
                              <input type="text" autocomplete="off" name="EmployeeName" id="EmployeeName" placeholder="Enter Employee Name" onblur="requiredFieldValidation('EmployeeName','EmployeeNameEerorMSGdiv');validateName('EmployeeName','EmployeeNameEerorMSGdiv');" class="form-control" value="<%=salMon[0][20]%>" readonly>
                              </div>
                              <div id="EmployeeNameEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                          <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Employee ID</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-star"></i></span>
                              <input type="text" name="EmployeeID" id="emuid" readonly class="form-control" value="<%=salMon[0][21]%>">
                              </div>
                             </div>
                            </div>
                            <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Employee Department</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-building"></i></span>
                              <input type="text" name="EmployeeDepartment" id="emdept" readonly class="form-control" value="<%=salMon[0][22]%>">
                              </div>
                             </div>
                            </div>                              
                           <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Employee Designation</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-cogs"></i></span>
                              <input type="text" name="EmployeeDesignation" id="emdesig" readonly class="form-control" value="<%=salMon[0][23]%>">
                               </div>
                             </div>
                            </div>
                            </div>
                          <div class="row">
                            <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Salary's Month:</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-calendar"></i></span>
                              <input type="text" name="Month" id="Month" placeholder="Select Month" onblur="return getLeavesTaken(this.value);requiredFieldValidation('Month','MonthEerorMSGdiv');" class="form-control readonlyAllow" value="<%=salMon[0][2]%>" datepicker readonly>
                              </div>
                              <div id="MonthEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                           <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Days in month</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-sort-numeric-asc"></i></span>
                              <input type="text" name="Days" id="Days" placeholder="Enter Days" onblur="return getNetPay(this.value);requiredFieldValidation('Days','DaysEerorMSGdiv');" class="form-control" value="<%=salMon[0][3]%>">
                               </div>
                               <div id="DaysEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>                             
                           <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Leaves Allowed</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-sort-numeric-asc"></i></span>
                              <input type="text" name="LeavesAllowed" id="LeavesAllowed" placeholder="Enter Leaves Allowed" onblur="requiredFieldValidation('LeavesAllowed','LeavesAllowedEerorMSGdiv');" class="form-control" value="<%=salMon[0][4]%>" onkeypress="return isNumberKey(event)">
                               </div>
                               <div id="LeavesAllowedEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                            <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Leaves Taken</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-sort-numeric-asc"></i></span>
                              <input type="text" name="LeavesTaken" id="LeavesTaken" placeholder="Enter Leaves Taken" onblur="requiredFieldValidation('LeavesTaken','LeavesTakenEerorMSGdiv');" class="form-control" value="<%=salMon[0][5]%>" onkeypress="return isNumber(event)">
                              </div>
                              <div id="LeavesTakenEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                             </div>
                          <div class="row">
                            <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Working Days</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-sort-numeric-asc"></i></span>
                              <input type="text" name="WorkingDays" id="WorkingDays" placeholder="Enter Working Days" onblur="requiredFieldValidation('WorkingDays','WorkingDaysEerorMSGdiv');" class="form-control" value="<%=salMon[0][25]%>" onkeypress="return isNumber(event)">
                              </div>
                              <div id="WorkingDaysEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>                              
                            <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Total Gross Salary</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
                              <input type="text" name="GrossSalary" id="GrossSalary" readonly class="form-control" value="<%=salMon[0][6]%>">
                              </div>
                             </div>
                            </div>                                
                          <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Basic Salary</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
                              <input type="text" name="BasicSalary" id="BasicSalary" placeholder="Enter Basic Salary" onblur="addGross(this.value);netPay();requiredFieldValidation('BasicSalary','BasicSalaryEerorMSGdiv');" class="form-control" value="<%=salMon[0][7]%>" onkeypress="return isNumberKey(event)">
                              </div>
                              <div id="BasicSalaryEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                             <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>DA</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-home"></i></span>
                              <input type="text" name="DA" id="DA" placeholder="Enter DA" onblur="addGross(this.value);netPay();requiredFieldValidation('DA','DAEerorMSGdiv');" class="form-control" value="<%=salMon[0][8]%>" onkeypress="return isNumberKey(event)">
                              </div>
                              <div id="DAEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                            </div>
                          <div class="row">
                            <div class="col-md-3 col-sm-3 col-xs-12">
                            <div class="form-group">
                              <label>HRA</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-home"></i></span>
                              <input type="text" name="HRA" id="HRA" placeholder="Enter HRA" onblur="addGross(this.value);netPay();requiredFieldValidation('HRA','HRAEerorMSGdiv');" class="form-control" value="<%=salMon[0][9]%>" onkeypress="return isNumberKey(event)">
                              </div>
                              <div id="HRAEerorMSGdiv" class="errormsg"></div>
                            </div>
                            </div>                              
                            <div class="col-md-3 col-sm-3 col-xs-12">
                            <div class="form-group">
                              <label>Conveyance</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-car"></i></span>
                              <input type="text" name="Conveyance" id="Conveyance" placeholder="Enter Conveyance" onblur="addGross(this.value);netPay();requiredFieldValidation('Conveyance','ConveyanceEerorMSGdiv');" class="form-control" value="<%=salMon[0][10]%>" onkeypress="return isNumberKey(event)">
                              </div>
                              <div id="ConveyanceEerorMSGdiv" class="errormsg"></div>
                            </div>
                            </div>
                            <div class="col-md-3 col-sm-3 col-xs-12">
                            <div class="form-group">
                              <label>Medical Expenses</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-medkit"></i></span>
                              <input type="text" name="MedicalExpenses" id="MedicalExpenses" placeholder="Enter MedicalExpenses" onblur="addGross(this.value);netPay();requiredFieldValidation('MedicalExpenses','MedicalExpensesEerorMSGdiv');" class="form-control" value="<%=salMon[0][11]%>" onkeypress="return isNumberKey(event)">
                              </div>
                              <div id="MedicalExpensesEerorMSGdiv" class="errormsg"></div>
                            </div>
                            </div>
                            <div class="col-md-3 col-sm-3 col-xs-12">
                            <div class="form-group">
                              <label>Special</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
                              <input type="text" name="Special" id="Special" placeholder="Enter Special" onblur="addGross(this.value);netPay();requiredFieldValidation('Special','SpecialEerorMSGdiv');" class="form-control" value="<%=salMon[0][12]%>" onkeypress="return isNumberKey(event)">
                              </div>
                              <div id="SpecialEerorMSGdiv" class="errormsg"></div>
                            </div>
                            </div>
                            </div>
                          <div class="row">
                            <div class="col-md-3 col-sm-3 col-xs-12">
                            <div class="form-group">
                              <label>Bonus</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
                              <input type="text" name="Bonus" id="Bonus" placeholder="Enter Bonus" onblur="addGross(this.value);netPay();requiredFieldValidation('Bonus','BonusEerorMSGdiv');" class="form-control" value="<%=salMon[0][13]%>" onkeypress="return isNumberKey(event)">
                              </div>
                              <div id="BonusEerorMSGdiv" class="errormsg"></div>
                            </div>
                            </div>
                            <div class="col-md-3 col-sm-3 col-xs-12">
                            <div class="form-group">
                              <label>TA</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-bus"></i></span>
                              <input type="text" name="TA" id="TA" placeholder="Enter TA" onblur="addGross(this.value);netPay();requiredFieldValidation('TA','TAEerorMSGdiv');" class="form-control" value="<%=salMon[0][14]%>" onkeypress="return isNumberKey(event)">
                              </div>
                              <div id="TAEerorMSGdiv" class="errormsg"></div>
                            </div>
                            </div>                              
                          <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Total Deductions</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
                              <input type="text" name="TotalDeductions" id="TotalDeductions" readonly class="form-control" value="<%=salMon[0][15]%>">
                              </div>
                             </div>
                            </div>                              
                            <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>PF</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite fa fa-money"></i></span>
                              <input type="text" name="PF" id="PF" placeholder="Enter PF" onblur="addDed(this.value);netPay();requiredFieldValidation('PF','PFEerorMSGdiv');" class="form-control" value="<%=salMon[0][16]%>" onkeypress="return isNumberKey(event)">
                              </div>
                              <div id="PFEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                            </div>
                          <div class="row">
                           <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Professional Tax</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
                              <input type="text" name="ProfessionalTax" id="ProfessionalTax" placeholder="Enter Professional Tax" onblur="addDed(this.value);netPay();requiredFieldValidation('ProfessionalTax','ProfessionalTaxEerorMSGdiv');" class="form-control" value="<%=salMon[0][17]%>" onkeypress="return isNumberKey(event)">
                               </div>
                               <div id="ProfessionalTaxEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                            <div class="col-md-3 col-sm-3 col-xs-12">
                            <div class="form-group">
                              <label>TDS</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
                              <input type="text" name="TDS" id="TDS" placeholder="Enter TDS" onblur="addDed(this.value);netPay();requiredFieldValidation('TDS','TDSEerorMSGdiv');" class="form-control" value="<%=salMon[0][18]%>" onkeypress="return isNumberKey(event)" readonly>
                              </div>
                              <div id="TDSEerorMSGdiv" class="errormsg"></div>
                            </div>
                            </div>                              
                          <div class="col-md-3 col-sm-3 col-xs-12">
                            <div class="form-group">
                            <label>Other Deductions</label>
                            <div class="input-group">
                            <span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
                            <input type="text" name="OtherDeductions" id="OtherDeductions" onblur="addDed(this.value);netPay();" class="form-control" value="<%=salMon[0][26]%>" onkeypress="return isNumberKey(event)">
                            </div>
                            </div>
                          </div>

                          <div class="col-md-3 col-sm-3 col-xs-12">
                            <div class="form-group">
                              <label>Net Salary Payable</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
                              <input type="text" name="Payable" id="Payable" readonly class="form-control" value="<%=salMon[0][19]%>">
                              </div>
                              <div id="DateOfBirthEerorMSGdiv" class="errormsg"></div>
                            </div>
                            </div>
                            </div>
                            <div class="row">
                          <div class="col-md-12 col-sm-12 col-xs-12">
                            <div class="form-group">
                            <label>Remark</label>
                            <div class="input-group">
                            <span class="input-group-addon"><i class="form-icon fa fa-comment-o"></i></span>
                            <textarea  name="salremark" placeholder="Remarks here!!" id="Remark" class="form-control" onblur="validateLocation('Remark','DateOfBirthEerorMSGdiv');validateValue('Remark','DateOfBirthEerorMSGdiv');"><%=salMon[0][27]%></textarea>
                            </div>
                            <div id="salremarkEerorMSGdiv" class="errormsg"></div>
                            </div>
                            </div>
                          </div>
                          <div class="row">
                            <div class="col-md-12 col-sm-12 col-xs-12 item-product-info">
                            <button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validatePaidSalary();">Update<i class="fa fa-paper-plane" aria-hidden="true"></i></button>
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
<script>
$('[datepicker]').datepicker({
	   format: 'mm-yyyy'
});
</script>
<script type="text/javascript">
// 		$(function() {
// 			$("#EmployeeName").autocomplete({
// 				source : function(request, response) {
// 					$.ajax({
// 						url : "get-employee.html",
// 						type : "POST",
// 						dataType : "json",
// 						data : {
// 							name : request.term

// 						},
// 						success : function(data) {
// 							response($.map(data, function(item) {
// 								return {
// 									label : item.emname,
// 									value : item.emname,
// 									emid : item.emid,
// 									emuid : item.emuid,
// 									emdept : item.emdept,
// 									emdesig : item.emdesig
// 								};
// 							}));
// 						},
// 						error : function(error) {
// 							alert('error: ' + error);
// 						}
// 					});
// 				},
// 				select : function(e, ui) {
// 					$("#emid").val(ui.item.emid);
// 					$("#emuid").val(ui.item.emuid);
// 					$("#emdept").val(ui.item.emdept);
// 					$("#emdesig").val(ui.item.emdesig);
// 				},
// 			});
// 		});
</script>

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
		var OD = document.getElementById('OtherDeductions').value;

		var Total = Number(PF) + Number(ProfessionalTax) + Number(TDS)+Number(OD);

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
function validatePaidSalary() {

		if (document.getElementById('EmployeeName').value.trim() == "") {
			EmployeeNameEerorMSGdiv.innerHTML = "Employee Name is required.";
			EmployeeNameEerorMSGdiv.style.color = "red";
			return false;
		}
		if (document.getElementById('Month').value.trim() == "") {
			MonthEerorMSGdiv.innerHTML = "Month is required.";
			MonthEerorMSGdiv.style.color = "red";
			return false;
		}
		if (document.getElementById('LeavesAllowed').value.trim() == "") {
			LeavesAllowedEerorMSGdiv.innerHTML = "Leaves Allowed is required.";
			LeavesAllowedEerorMSGdiv.style.color = "red";
			return false;
		}
		if (document.getElementById('Days').value.trim() == "") {
			DaysEerorMSGdiv.innerHTML = "Days is required.";
			DaysEerorMSGdiv.style.color = "red";
			return false;
		}
		if (document.getElementById('LeavesTaken').value.trim() == "") {
			LeavesTakenEerorMSGdiv.innerHTML = "Leaves Taken is required.";
			LeavesTakenEerorMSGdiv.style.color = "red";
			return false;
		}
		if (document.getElementById('BasicSalary').value.trim() == "") {
			BasicSalaryEerorMSGdiv.innerHTML = "BasicSalary is required.";
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
			MedicalExpensesEerorMSGdiv.innerHTML = "MedicalExpenses is required.";
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
			ProfessionalTaxEerorMSGdiv.innerHTML = "ProfessionalTax is required.";
			ProfessionalTaxEerorMSGdiv.style.color = "red";
			return false;
		}
		if (document.getElementById('TDS').value.trim() == "") {
			TDSEerorMSGdiv.innerHTML = "TDS is required.";
			TDSEerorMSGdiv.style.color = "red";
			return false;
		}
		if (document.getElementById('Remark').value.trim() == "") {
			salremarkEerorMSGdiv.innerHTML = "Remark is required.";
			salremarkEerorMSGdiv.style.color = "red";
			return false;
		}
// 			document.registerEmployee.submit();
	}
	

function getLeavesTaken(month){
var empid = document.getElementById('emuid').value.trim();
if(month==""){
	document.getElementById("LeavesTaken").value="";
	return false;
}
else{
	var xhttp;
	xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
		if (this.readyState == 4 && this.status == 200) {
			document.getElementById("LeavesTaken").value=xhttp.responseText;
			getLeavesAllowed(month);
		}
	};
	xhttp.open("POST", "<%=landingpage_basepath %>/getLeavesTaken111?month="+month+"&empid="+empid, true);
	xhttp.send(month,empid);
}
}

function getNetPay(){
var days=document.getElementById("Days").value.trim();
var LeavesAllowed=document.getElementById("LeavesAllowed").value.trim();
var LeavesTaken=document.getElementById("LeavesTaken").value.trim();
var Payable = document.getElementById('Payable').value.trim();

var PayablePerDay = Number(Payable)/days;
var WorkingDays=Number(days)-Number(LeavesTaken);
document.getElementById("WorkingDays").value=WorkingDays;
var OtherDeductions = Number(PayablePerDay)*Number(LeavesTaken);
document.getElementById('OtherDeductions').value = Number(OtherDeductions).toFixed(2);
}

function getLeavesAllowed(month){

var thismonth = month.split("-");
document.getElementById("Days").value= new Date(thismonth[1], thismonth[0], 0).getDate();

var empid = document.getElementById('emid').value.trim();
if(month==""){
	document.getElementById("LeavesAllowed").value="";
	return false;
}
else{
	var xhttp;
	xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
		if (this.readyState == 4 && this.status == 200) {
			document.getElementById("LeavesAllowed").value=xhttp.responseText;
		}
	};
	xhttp.open("POST", "<%=landingpage_basepath %>/getLeavesAllowed111?month="+month+"&empid="+empid, true);
	xhttp.send(month,empid);
}
}
</script>
</body>
</html>