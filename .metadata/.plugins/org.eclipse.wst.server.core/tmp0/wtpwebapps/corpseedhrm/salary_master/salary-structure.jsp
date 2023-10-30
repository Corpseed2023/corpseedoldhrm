<!DOCTYPE HTML>
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
<%if(!SAL01){%><jsp:forward page="/login.html" /><%} %>
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
<form action="<%=request.getContextPath()%>/add-salary-structure.html" method="post" name="registerEmployee" id="registerEmployee"> 
<input type="hidden" name="emid" id="emid" readonly>
<div class="row">
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Employee Name :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-user"></i></span>
<input type="text" name="EmployeeName" autocomplete="off" id="EmployeeName" placeholder="Enter Employee Name" onblur="requiredFieldValidation('EmployeeName','EmployeeNameEerorMSGdiv');" class="form-control">
</div>
<div id="EmployeeNameEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Employee ID :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-user"></i></span>
<input type="text" autocomplete="off" name="EmployeeID" id="emuid" placeholder="Employee Id." readonly class="form-control">
</div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Employee Department :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-briefcase"></i></span>
<input type="text" autocomplete="off" name="EmployeeDepartment" placeholder="Employee Department" id="emdept" readonly class="form-control">
</div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Employee Designation :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-line-chart"></i></span>
<input type="text" autocomplete="off" name="EmployeeDesignation" placeholder="Employee Designation" id="emdesig" readonly class="form-control">
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
<input type="text" autocomplete="off" name="CTC" id="CTC" placeholder="Enter CTC" onblur="requiredFieldValidation('CTC','CTCEerorMSGdiv');" class="form-control ccp" onkeypress="return isNumberKey(event,'CTCEerorMSGdiv')">
</div>
<div id="CTCEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Leaves Allowed :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-lock"></i></span>
<input type="text" autocomplete="off" name="LeavesAllowed" id="LeavesAllowed" placeholder="Enter Leaves Allowed" onblur="requiredFieldValidation('LeavesAllowed','LeavesAllowedEerorMSGdiv');" class="form-control ccp" onkeypress="return isNumber(event)">
</div>
<div id="LeavesAllowedEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Basic Salary :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
<input type="text" autocomplete="off" name="BasicSalary" id="BasicSalary" placeholder="Enter Basic Salary" onblur="addGross(this.value);netPay();requiredFieldValidation('BasicSalary','BasicSalaryEerorMSGdiv');" class="form-control ccp" onkeypress="return isNumberKey(event)">
</div>
<div id="BasicSalaryEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Total Gross Salary :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
<input type="text" autocomplete="off" name="GrossSalary" placeholder="Total Gross Salary." id="GrossSalary" readonly class="form-control">
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
<input type="text" autocomplete="off" name="DA" id="DA" placeholder="Enter DA" onblur="addGross(this.value);netPay();requiredFieldValidation('DA','DAEerorMSGdiv');" class="form-control ccp" onkeypress="return isNumberKey(event)">
</div>
<div id="DAEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>HRA :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-home"></i></span>
<input type="text" autocomplete="off" name="HRA" id="HRA" placeholder="Enter HRA" onblur="addGross(this.value);netPay();requiredFieldValidation('HRA','HRAEerorMSGdiv');" class="form-control ccp" onkeypress="return isNumberKey(event)">
</div>
<div id="HRAEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Conveyance :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-car"></i></span>
<input type="text" autocomplete="off" name="Conveyance" id="Conveyance" placeholder="Enter Conveyance" onblur="addGross(this.value);netPay();requiredFieldValidation('Conveyance','ConveyanceEerorMSGdiv');" class="form-control ccp" onkeypress="return isNumberKey(event)">
</div>
<div id="ConveyanceEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Medical Expenses :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-medkit"></i></span>
<input type="text" autocomplete="off" name="MedicalExpenses" id="MedicalExpenses" placeholder="Enter MedicalExpenses" onblur="addGross(this.value);netPay();requiredFieldValidation('MedicalExpenses','MedicalExpensesEerorMSGdiv');" class="form-control ccp" onkeypress="return isNumberKey(event)">
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
<span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
<input type="text" autocomplete="off" name="Special" id="Special" placeholder="Enter Special" onblur="addGross(this.value);netPay();requiredFieldValidation('Special','SpecialEerorMSGdiv');" class="form-control ccp" onkeypress="return isNumberKey(event)">
</div>
<div id="SpecialEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Bonus :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
<input type="text" autocomplete="off" name="Bonus" id="Bonus" placeholder="Enter Bonus" onblur="addGross(this.value);netPay();requiredFieldValidation('Bonus','BonusEerorMSGdiv');" class="form-control ccp" onkeypress="return isNumberKey(event)">
</div>
<div id="BonusEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>TA :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-bus"></i></span>
<input type="text" autocomplete="off" name="TA" id="TA" placeholder="Enter TA" onblur="addGross(this.value);netPay();requiredFieldValidation('TA','TAEerorMSGdiv');" class="form-control ccp" onkeypress="return isNumberKey(event)">
</div>
<div id="TAEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Total Deductions :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
<input type="text" autocomplete="off" name="TotalDeductions" placeholder="Total Deductions" id="TotalDeductions" readonly class="form-control">
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
<input type="text" autocomplete="off" name="PF" id="PF" placeholder="Enter PF" onblur="addDed(this.value);netPay();requiredFieldValidation('PF','PFEerorMSGdiv');" class="form-control ccp" onkeypress="return isNumberKey(event)">
</div>
<div id="PFEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Professional Tax :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
<input type="text" autocomplete="off" name="ProfessionalTax" id="ProfessionalTax" placeholder="Enter Professional Tax" onblur="addDed(this.value);netPay();requiredFieldValidation('ProfessionalTax','ProfessionalTaxEerorMSGdiv');" class="form-control ccp" onkeypress="return isNumberKey(event)">
</div>
<div id="ProfessionalTaxEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>TDS :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
<input type="text" autocomplete="off" name="TDS" id="TDS" placeholder="Enter TDS" onblur="addDed(this.value);netPay();requiredFieldValidation('TDS','TDSEerorMSGdiv');" class="form-control ccp" onkeypress="return isNumberKey(event)">
</div>
<div id="TDSEerorMSGdiv" class="errormsg"></div>
</div>
</div>
<div class="col-md-3 col-sm-3 col-xs-12">
<div class="form-group">
<label>Net Salary Payable :<span style="color: red;">*</span></label>
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-money"></i></span>
<input type="text" autocomplete="off" name="Payable" placeholder="Net payable salary" id="Payable" readonly class="form-control">
</div>
<div id="DateOfBirthEerorMSGdiv" class="errormsg"></div>
</div>
</div>
</div>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12 item-product-info">
<button onclick="return validateSalaryStructure()" class="bt-link bt-radius bt-loadmore">Save<i class="fa fa-paper-plane" aria-hidden="true"></i></button>
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
	ProfessionalTaxEerorMSGdiv.innerHTML = "ProfessionalTax is required.";
	ProfessionalTaxEerorMSGdiv.style.color = "red";
	return false;
	}
	if (document.getElementById('TDS').value.trim() == "") {
	TDSEerorMSGdiv.innerHTML = "TDS is required.";
	TDSEerorMSGdiv.style.color = "red";
	return false;
	}
	// document.registerEmployee.submit();
	}
</script>
<script type="text/javascript">
$(function() {
	$("#EmployeeName").autocomplete({
		source : function(request, response) {
			if(document.getElementById('EmployeeName').value.trim().length>=2)
			$.ajax({
				url : "getemployeestr.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term					
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value,
							emuid : item.emuid,
							emdept : item.emdept,
							emdesig : item.emdesig,
							emid : item.emid,				
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
            	document.getElementById('errorMsg').innerHTML = 'Select From List.';
        		$('.alert-show').show().delay(1000).fadeOut();
        		
            	$("#emid").val(""); 
    			$("#emuid").val(""); 
    			$("#EmployeeName").val(""); 
    			$("#emdept").val(""); 
            	$("#emdesig").val("");     	
            }
            else{
            	$("#emid").val(ui.item.emid);
            	$("#emuid").val(ui.item.emuid);
            	$("#EmployeeName").val(ui.item.value);
            	$("#emdept").val(ui.item.emdept);
            	$("#emdesig").val(ui.item.emdesig);            	 
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

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


$('.ccp').bind("cut copy paste",function(e) {
    e.preventDefault();
});
</script>
</body>
</html>