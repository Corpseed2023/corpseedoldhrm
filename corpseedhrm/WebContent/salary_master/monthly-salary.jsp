<%String landingpage_basepath = request.getContextPath(); %>
<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Employee's Monthly Salary</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/staticresources/css/datepicker.css" media="all"/>
</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<% 	String addedby= (String)session.getAttribute("loginuID");%>
<%if(!MSL01){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
<div class="main-content">
<div class="container">
<div class="row">
<div class="col-xs-12">
<div class="menuDv post-slider clearfix">
<form action="<%=request.getContextPath() %>/add-monthy-salary.html" method="post" name="registerEmployee" id="registerEmployee">
<input type="hidden" name="addeduser" value="<%=addedby%>" readonly>
<input type="hidden" name="emid" id="emid" readonly>
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Employee Name</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-user"></i></span>
<input type="text" name="EmployeeName" autocomplete="off" id="EmployeeName" placeholder="Enter Employee Name" onblur="requiredFieldValidation('EmployeeName','EmployeeNameEerorMSGdiv');" class="form-control">
</div>
<div id="EmployeeNameEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Employee ID</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-star"></i></span>
<input type="text" autocomplete="off" name="EmployeeID" placeholder="Employee Id" id="emuid" readonly class="form-control">
</div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Employee Department</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-building"></i></span>
<input type="text" autocomplete="off" name="EmployeeDepartment" placeholder="Employee Department" id="emdept" readonly class="form-control">
</div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Employee Designation</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-cogs"></i></span>
<input type="text" autocomplete="off" name="EmployeeDesignation" placeholder="Employee Designation" id="emdesig" readonly class="form-control">
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
<input type="text" autocomplete="off" name="Month"  id="Month" placeholder="Select Month" onchange="return getLeavesTaken(this.value);isPaidSalary('Salary Month','salarymontherrMsg');" class="form-control readonlyAllow" readonly>
</div>
<div id="MonthEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Days in month</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-sort-numeric-asc"></i></span>
<input type="text" autocomplete="off" name="Days" id="Days" placeholder="Enter Days" onblur="return getNetPay();" class="form-control">
</div>
<div id="DaysEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Leaves Allowed</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-sort-numeric-asc"></i></span>
<input type="text" autocomplete="off" name="LeavesAllowed" id="LeavesAllowed" placeholder="Enter Leaves Allowed" onblur="requiredFieldValidation('LeavesAllowed','LeavesAllowedEerorMSGdiv');" class="form-control" onkeypress="return isNumber(event)">
</div>
<div id="LeavesAllowedEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Leaves Taken</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-sort-numeric-asc"></i></span>
<input type="text" autocomplete="off" name="LeavesTaken" id="LeavesTaken" placeholder="Enter Leaves Taken" onblur="return getNetPay();requiredFieldValidation('LeavesTaken','LeavesTakenEerorMSGdiv');" class="form-control" onkeypress="return isNumber(event)">
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
<input type="text" autocomplete="off" name="WorkingDays" id="WorkingDays" placeholder="Enter Working Days" onblur="requiredFieldValidation('WorkingDays','WorkingDaysEerorMSGdiv');" class="form-control" onkeypress="return isNumber(event)">
</div>
<div id="WorkingDaysEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Total Gross Salary</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
<input type="text" autocomplete="off" name="GrossSalary" placeholder="Gross salary" id="GrossSalary" readonly class="form-control">
</div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Basic Salary</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
<input type="text" autocomplete="off" name="BasicSalary" id="BasicSalary" placeholder="Enter Basic Salary" onblur="addGross(this.value);netPay();requiredFieldValidation('BasicSalary','BasicSalaryEerorMSGdiv');" class="form-control" onkeypress="return isNumberKey(event)">
</div>
<div id="BasicSalaryEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>DA</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-home"></i></span>
<input type="text" autocomplete="off" name="DA" id="DA" placeholder="Enter DA" onblur="addGross(this.value);netPay();requiredFieldValidation('DA','DAEerorMSGdiv');" class="form-control" onkeypress="return isNumberKey(event)">
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
<input type="text" autocomplete="off" name="HRA" id="HRA" placeholder="Enter HRA" onblur="addGross(this.value);netPay();requiredFieldValidation('HRA','HRAEerorMSGdiv');" class="form-control" onkeypress="return isNumberKey(event)">
</div>
<div id="HRAEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Conveyance</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-car"></i></span>
<input type="text" autocomplete="off" name="Conveyance" id="Conveyance" placeholder="Enter Conveyance" onblur="addGross(this.value);netPay();requiredFieldValidation('Conveyance','ConveyanceEerorMSGdiv');" class="form-control" onkeypress="return isNumberKey(event)">
</div>
<div id="ConveyanceEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Medical Expenses</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-medkit"></i></span>
<input type="text" autocomplete="off" name="MedicalExpenses" id="MedicalExpenses" placeholder="Enter MedicalExpenses" onblur="addGross(this.value);netPay();requiredFieldValidation('MedicalExpenses','MedicalExpensesEerorMSGdiv');" class="form-control" onkeypress="return isNumberKey(event)">
</div>
<div id="MedicalExpensesEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Special</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
<input type="text" autocomplete="off" name="Special" id="Special" placeholder="Enter Special" onblur="addGross(this.value);netPay();requiredFieldValidation('Special','SpecialEerorMSGdiv');" class="form-control" onkeypress="return isNumberKey(event)">
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
<input type="text" autocomplete="off" name="Bonus" id="Bonus" placeholder="Enter Bonus" onblur="addGross(this.value);netPay();requiredFieldValidation('Bonus','BonusEerorMSGdiv');" class="form-control" onkeypress="return isNumberKey(event)">
</div>
<div id="BonusEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>TA</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-bus"></i></span>
<input type="text" autocomplete="off" name="TA" id="TA" placeholder="Enter TA" onblur="addGross(this.value);netPay();requiredFieldValidation('TA','TAEerorMSGdiv');" class="form-control" onkeypress="return isNumberKey(event)">
</div>
<div id="TAEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Total Deductions</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
<input type="text" autocomplete="off" name="TotalDeductions" placeholder="Total deductions" id="TotalDeductions" readonly class="form-control">
</div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>PF</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
<input type="text" autocomplete="off" name="PF" id="PF" placeholder="Enter PF" onblur="addDed(this.value);netPay();requiredFieldValidation('PF','PFEerorMSGdiv');" class="form-control" onkeypress="return isNumberKey(event)">
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
<input type="text" autocomplete="off" name="ProfessionalTax" id="ProfessionalTax" placeholder="Enter Professional Tax" onblur="addDed(this.value);netPay();requiredFieldValidation('ProfessionalTax','ProfessionalTaxEerorMSGdiv');" class="form-control" onkeypress="return isNumberKey(event)">
</div>
<div id="ProfessionalTaxEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>TDS</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
<input type="text" autocomplete="off" name="TDS" id="TDS" placeholder="Enter TDS" onblur="addDed(this.value);netPay();requiredFieldValidation('TDS','TDSEerorMSGdiv');" class="form-control" onkeypress="return isNumberKey(event)" readonly>
</div>
<div id="TDSEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Other Deductions</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
<input type="text" autocomplete="off" name="OtherDeductions" placeholder="Deduction" id="OtherDeductions" onblur="addDed(this.value);netPay();" class="form-control" onkeypress="return isNumberKey(event)">
</div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Net Salary Payable</label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
<input type="text" autocomplete="off" name="Payable" placeholder="Net Salary Payable" id="Payable" readonly class="form-control">
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
<textarea  autocomplete="off" name="salremark" placeholder="Remarks here!!" id="Remark" rows="3" class="form-control" onblur="validateLocation('Remark','DateOfBirthEerorMSGdiv');"></textarea>

</div>
<div id="salremarkEerorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12 item-product-info">
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateSalary();">Save<i class="fa fa-paper-plane" aria-hidden="true"></i></button>
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
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/datepicker.js"></script>
<script>
$('[datepicker]').datepicker({
	   format: 'mm-yyyy'
});
</script>
<script type="text/javascript">
// function daysInMonth(){
// 	var month=document.getElementById('Salary Month').value.trim();
// 	var str=month.split("-");
// 	var workingdays=new Date(str[1], str[0], 0).getDate(); 
// 	document.getElementById('Days').value=workingdays; 
	       
// 	}


$(function() {
	$("#EmployeeName").autocomplete({
		source : function(request, response) {
			if(document.getElementById('EmployeeName').value.trim().length>=2)
			$.ajax({
				url : "get-salary-employee.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.emname,
							value : item.emname,
							emid : item.emid,
							emuid : item.emuid,
							emdept : item.emdept,
							emdesig : item.emdesig,
							salleaves:item.salleaves,
							salgross : item.salgross,
							salbasic : item.salbasic,
							salda : item.salda,
							salhra : item.salhra,
							salcon : item.salcon,
							salmed : item.salmed,
							salspecial : item.salspecial,
							salbonus : item.salbonus,
							salta : item.salta,
							salded : item.salded,
							salpf : item.salpf,
							salptax : item.salptax,
							saltds : item.saltds,
							salnet : item.salnet,
						};
					}));
				},
				error : function(error) {
					alert('error: ' + error.responseText);
				}
			});
		},
		change: function (event, ui) {
            if(!ui.item){     
            	document.getElementById("EmployeeNameEerorMSGdiv").innerHTML="Select From List.";
            	document.getElementById("EmployeeNameEerorMSGdiv").style.color="red";
            	$("#EmployeeName").val("");
            	$("#emid").val("");
            	$("#emuid").val("");
            	$("#emdept").val("");
            	$("#emdesig").val("");
            	$("#LeavesAllowed").val("");
            	$("#GrossSalary").val("");
            	$("#BasicSalary").val("");
            	$("#DA").val("");
            	$("#HRA").val("");
            	$("#Conveyance").val("");
            	$("#MedicalExpenses").val("");
            	$("#Special").val("");
            	$("#Bonus").val("");
            	$("#TA").val("");
            	$("#TotalDeductions").val("");
            	$("#PF").val("");
            	$("#ProfessionalTax").val("");
            	$("#TDS").val("");
            	$("#Payable").val("");
            }
            else{
            	$("#emid").val(ui.item.emid);
            	$("#emuid").val(ui.item.emuid);
            	$("#emdept").val(ui.item.emdept);
            	$("#emdesig").val(ui.item.emdesig);
            	$("#LeavesAllowed").val(ui.item.salleaves);
            	$("#GrossSalary").val(ui.item.salgross);
            	$("#BasicSalary").val(ui.item.salbasic);
            	$("#DA").val(ui.item.salda);
            	$("#HRA").val(ui.item.salhra);
            	$("#Conveyance").val(ui.item.salcon);
            	$("#MedicalExpenses").val(ui.item.salmed);
            	$("#Special").val(ui.item.salspecial);
            	$("#Bonus").val(ui.item.salbonus);
            	$("#TA").val(ui.item.salta);
            	$("#TotalDeductions").val(ui.item.salded);
            	$("#PF").val(ui.item.salpf);
            	$("#ProfessionalTax").val(ui.item.salptax);
            	$("#TDS").val(ui.item.saltds);
            	$("#Payable").val(ui.item.salnet);
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});


</script>

<script type="text/javascript">
function addGross(amount) {
var BasicSalary = document.getElementById('BasicSalary').value.trim();
var DA = document.getElementById('DA').value.trim();
var HRA = document.getElementById('HRA').value.trim();
var Conveyance = document.getElementById('Conveyance').value.trim();
var MedicalExpenses = document.getElementById('MedicalExpenses').value.trim();
var Special = document.getElementById('Special').value.trim();
var Bonus = document.getElementById('Bonus').value.trim();
var TA = document.getElementById('TA').value.trim();

var Total = Number(BasicSalary) + Number(DA) + Number(HRA)
+ Number(Conveyance) + Number(MedicalExpenses)
+ Number(Special) + Number(Bonus) + Number(TA);

document.getElementById('GrossSalary').value = Total;
}

function addDed(amount) {
var PF = document.getElementById('PF').value.trim();
var ProfessionalTax = document.getElementById('ProfessionalTax').value.trim();
var TDS = document.getElementById('TDS').value.trim();
var OD = document.getElementById('OtherDeductions').value.trim();

var Total = Number(PF) + Number(ProfessionalTax) + Number(TDS)+Number(OD);

document.getElementById('TotalDeductions').value = Total;
}

function netPay() {
var GrossSalary = document.getElementById('GrossSalary').value.trim();
var TotalDeductions = document.getElementById('TotalDeductions').value.trim();

var Total = Number(GrossSalary) - Number(TotalDeductions);

document.getElementById('Payable').value = Total;
}
</script>

<script type="text/javascript">
function validateSalary() {

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
// document.registerEmployee.submit();
}

$( function() {
$( "#Month" ).datepicker({
changeMonth:true,
changeYear:true,
dateFormat:"mm-yy"
});
});
</script>
<script>
function getLeavesTaken(month){
	var thismonth = month.split("-");
	document.getElementById("Days").value= new Date(thismonth[1], thismonth[0], 0).getDate();
	
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
	var empid = document.getElementById('emid').value.trim();
	if(month==""){alert(month)
// 		document.getElementById("LeavesAllowed").value="";
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