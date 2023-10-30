<!DOCTYPE HTML>
<%@page import="employee_master.Employee_ACT"%>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title>Update Employee</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %> 
	
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	<% 	String addedby= (String)session.getAttribute("loginuID");
		String emid=(String) session.getAttribute("passid");
		String[][] employee = Employee_ACT.getEmployeeById(emid); 
	%>
<%if(!ME02){%><jsp:forward page="/login.html" /><%} %>
	<div id="content">
		<div class="container">   
          <div class="bread-crumb">
            <div class="bd-breadcrumb bd-light">
            <a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
            <a>Update Employee</a>
            </div>
          </div>
        </div>

		<div class="main-content">
			<div class="container">
				<div class="row">
                	<div class="col-xs-12">
                        <div class="menuDv  post-slider">
                            <form action="update-employee.html" method="post" name="registerEmployee" id="registerEmployee">
                              <div class="row">
                              <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <input type="hidden" name="addeduser" value="<%=addedby%>">
                                  <input type="hidden" name="emid" value="<%=employee[0][24]%>">
                                  <label>Employee ID :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
                                  <input type="text" name="EmployeeID" id="Employee ID" title="<%=employee[0][0]%>" value="<%=employee[0][0]%>" readonly placeholder="Enter Employee ID" onblur="requiredFieldValidation('Employee ID','EmployeeIDEerorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="EmployeeIDEerorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <label>Employee Name :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon fa fa-user"></i></span>
                                  <select name="EmployeePrefix" id="Employee Prefix" onblur="requiredFieldValidation('Employee Prefix','EmployeeNameEerorMSGdiv');" class="form-control prefix">
                                   <%
                                  if(employee[0][1]!=null)
                                  {%>
                                	<option value="<%=employee[0][1] %>" title="<%=employee[0][1] %>"><%=employee[0][1] %></option> 
                                  <%}%>
                                  <option value="">Select prefix</option>
                                  <option value="Mr">Mr</option>
                                  <option value="Miss">Miss</option>
                                  </select>
                                  <input type="text" name="EmployeeName" id="Employee Name" title="<%=employee[0][2]%>" value="<%=employee[0][2]%>" placeholder="Employee's Name here !" onblur="requiredFieldValidation('Employee Name','EmployeeNameEerorMSGdiv');validateName('Employee Name','EmployeeNameEerorMSGdiv');validateValue('Employee Name','EmployeeNameEerorMSGdiv');" class="form-control" style="width: 75%;">
                                  </div>
                                  <div id="EmployeeNameEerorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <label>Department :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon fa fa-building "></i></span>
<%--                                   <input type="text" name="EmployeeDepartment" id="Employee Department" value="<%=employee[0][3]%>" title="<%=employee[0][3]%>" placeholder="Employee's Department here !" onblur="requiredFieldValidation('Employee Department','EmployeeDepartmentEerorMSGdiv');validateName('Employee Department','EmployeeDepartmentEerorMSGdiv');validateValue('Employee Department','EmployeeDepartmentEerorMSGdiv');" class="form-control"> --%>
                                  <select name="EmployeeDepartment" id="Employee Department" class="form-control">
									<option value="">Department</option>
									<option value="Sales" <%if(employee[0][3].equals("Sales")){ %>selected="selected"<%} %>>Sales</option>
									<option value="Delivery" <%if(employee[0][3].equals("Delivery")){ %>selected="selected"<%} %>>Delivery</option>
									<option value="Account" <%if(employee[0][3].equals("Account")){ %>selected="selected"<%} %>>Account</option>
									<option value="HR" <%if(employee[0][3].equals("HR")){ %>selected="selected"<%} %>>HR</option>
									<option value="IT" <%if(employee[0][3].equals("IT")){ %>selected="selected"<%} %>>IT</option>
									<option value="Marketing" <%if(employee[0][3].equals("Marketing")){ %>selected="selected"<%} %>>Marketing</option>
									<option value="Document" <%if(employee[0][3].equals("Document")){ %>selected="selected"<%} %>>Document</option>
								</select>
                                  </div>
                                  <div id="EmployeeDepartmentEerorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>                              
                               <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <label>Designation :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon fa fa-cog"></i></span>
                                  <input type="text" name="EmployeeDesignation" id="Employee Designation" title="<%=employee[0][4]%>" value="<%=employee[0][4]%>" placeholder="Employee's Designation here !" onblur="requiredFieldValidation('Employee Designation','EmployeeDesignationEerorMSGdiv');validateName('Employee Designation','EmployeeDesignationEerorMSGdiv');validateValue('Employee Designation','EmployeeDesignationEerorMSGdiv');" class="form-control">
                                   </div>
                                   <div id="EmployeeDesignationEerorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>
                                </div>
                              <div class="row">
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <label>Mobile No. :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon fa fa-mobile"></i></span>
                                  <input type="text" name="EmployeeMobile" id="Employee Mobile" value="<%=employee[0][5]%>" title="<%=employee[0][5]%>" placeholder="Mobile No. here !" onblur="requiredFieldValidation('Employee Mobile','EmployeeMobileEerorMSGdiv');validateMobileno('Employee Mobile','EmployeeMobileEerorMSGdiv');isExistValue('Employee Mobile','EmployeeMobileEerorMSGdiv','<%=employee[0][24]%>');" class="form-control" maxlength="10" onkeypress="return isNumber(event)">
                                  </div>
                                  <div id="EmployeeMobileEerorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>
                               <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <label>Alternate Mobile No. :</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon fa fa-mobile"></i></span>
                                  <input type="text" name="EmployeeAlternateMobile" id="Employee Alternate Mobile" onblur="isExistValue('Employee Alternate Mobile','EmployeeAlternateMobileEerorMSGdiv','<%=employee[0][24]%>');" value="<%=employee[0][8]%>"title="<%=employee[0][8]%>" placeholder="Alternate Mobile No(optional)" onblur="" maxlength="10" class="form-control" onkeypress="return isNumber(event)">
                                  </div>
                                  <div id="EmployeeAlternateMobileEerorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>                              
                               <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <label>Email Id :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon fa fa-at"></i></span>
                                  <input type="text" name="EmployeeEmail" id="Employee Email" value="<%=employee[0][6]%>" title="<%=employee[0][6]%>" placeholder="Email Id here !" onblur="requiredFieldValidation('Employee Email','EmployeeEmailEerorMSGdiv');verifyEmailId('Employee Email','EmployeeEmailEerorMSGdiv');isExistValue('Employee Email','EmployeeEmailEerorMSGdiv','<%=employee[0][24]%>');" class="form-control">
                                   </div>
                                   <div id="EmployeeEmailEerorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>                               
                               <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <label>Alternate Email Id :</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon fa fa-at"></i></span>
                                  <input type="text" name="EmployeeAlternateEmail" id="Employee Alternate Email" value="<%=employee[0][9]%>" title="<%=employee[0][9]%>" placeholder="Alternate Email Id(optional)" onblur="isExistValue('Employee Alternate Email','EmployeeAlternateEmailEerorMSGdiv','<%=employee[0][24]%>');" class="form-control">
                                   </div>
                                   <div id="EmployeeAlternateEmailEerorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>                                 
                              </div>
                              <div class="row">                                                              
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                <div class="form-group">
                                  <label>PAN :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" name="PAN" id="PAN" placeholder="PAN No. here !" maxlength="10" title="<%=employee[0][18]%>" value="<%=employee[0][18]%>" onblur="requiredFieldValidation('PAN','PANEerorMSGdiv');validateUserName('PAN','PANEerorMSGdiv');validateValue('PAN','PANEerorMSGdiv');isExistValue('PAN','PANEerorMSGdiv','<%=employee[0][24]%>');" class="form-control">
                                  </div>
                                  <div id="PANEerorMSGdiv" class="errormsg"></div>
                                </div>
                                </div>
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                <div class="form-group">
                                  <label>Aadhar :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" name="Aadhar" id="Aadhar" placeholder="Aadhar No. here !" title="<%=employee[0][19]%>" value="<%=employee[0][19]%>" onblur="requiredFieldValidation('Aadhar','AadharEerorMSGdiv');isExistValue('Aadhar','AadharEerorMSGdiv','<%=employee[0][24]%>');" maxlength="12" class="form-control" onkeypress="return isNumber(event)">
                                  </div>
                                  <div id="AadharEerorMSGdiv" class="errormsg"></div>
                                </div>
                                </div>
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                <div class="form-group">
                                  <label>Gender :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon fa fa-user"></i></span>
                                  <select name="Gender" id="Gender" onblur="requiredFieldValidation('Gender','GenderEerorMSGdiv');" class="form-control">
                                   <%
                                  if(employee[0][7]!=null)
                                  {%>
                                	<option value="<%=employee[0][7] %>" title="<%=employee[0][7] %>"><%=employee[0][7] %></option> 
                                  <%}%>
                                  <option value="">Select your Gender</option>
                                  <option value="Male">Male</option>
                                  <option value="Female">Female</option>
                                  </select>
                                  </div>
                                  <div id="GenderEerorMSGdiv" class="errormsg"></div>
                                </div>
                                </div>
                               <div class="col-md-3 col-sm-3 col-xs-12">
								<div class="form-group">
								<label>Date Of Joining :<span style="color: red;">*</span></label>
								<div class="input-group">
								<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
								<input type="text" name="DateOfJoining" id="Date_Of_Joining" placeholder="Select Joining date" title="<%=employee[0][26]%>" value="<%=employee[0][26]%>" class="form-control readonlyAllow" readonly>
								</div>
								<div id="DateOfJoiningEerorMSGdiv" class="errormsg"></div>
								</div>
								</div>
                                </div>
                              <div class="row">
                              <div class="col-md-3 col-sm-3 col-xs-12">
                                <div class="form-group">
                                  <label>Date Of Birth :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" name="DateOfBirth" id="DateOfBirth" placeholder="Select Date Of Birth" title="<%=employee[0][10]%>" value="<%=employee[0][10]%>" class="form-control readonlyAllow" readonly>
                                  </div>
                                  <div id="DateOfBirthEerorMSGdiv" class="errormsg"></div>
                                </div>
                                </div>                                                             
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                <div class="form-group">
                                  <label>Date of Anniversary :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" name="DateofAnniversary" id="DateofAnniversary" placeholder="Select Anniversary Date" title="<%=employee[0][11]%>" value="<%=employee[0][11]%>" class="form-control readonlyAllow" readonly>
                                  </div>
                                  <div id="DateofAnniversaryEerorMSGdiv" class="errormsg"></div>
                                </div>
                                </div>
                                 <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <label>Emergency Contact Name :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon fa fa-user"></i></span>
                                  <input type="text" name="EmergencyContactEmployeeName" id="Emergency Contact Employee Name" title="<%=employee[0][12]%>" value="<%=employee[0][12]%>" placeholder="Emergency Contact Employee Name here !" onblur="requiredFieldValidation('Emergency Contact Employee Name','EmergencyContactEmployeeNameEerorMSGdiv');validateName('Emergency Contact Employee Name','EmergencyContactEmployeeNameEerorMSGdiv');validateValue('Emergency Contact Employee Name','EmergencyContactEmployeeNameEerorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="EmergencyContactEmployeeNameEerorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>                               
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <label>Emergency Contact Mobile No. :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon fa fa-mobile"></i></span>
                                  <input type="text" maxlength="10" name="EmergencyContactEmployeeMobile" id="Emergency Contact Employee Mobile" title="<%=employee[0][13]%>" value="<%=employee[0][13]%>" placeholder="Emergency Contact Mobile No. here !" onblur="requiredFieldValidation('Emergency Contact Employee Mobile','EmergencyContactEmployeeMobileEerorMSGdiv');validateMobileno('Emergency Contact Employee Mobile','EmergencyContactEmployeeMobileEerorMSGdiv');isExistValue('Emergency Contact Employee Mobile','EmergencyContactEmployeeMobileEerorMSGdiv','<%=employee[0][24]%>');" class="form-control" onkeypress="return isNumber(event)">
                                  </div>
                                  <div id="EmergencyContactEmployeeMobileEerorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>
                                 </div>
                              <div class="row">
                               <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <label>Emergency Contact Email Id :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon fa fa-at"></i></span>
                                  <input type="text" name="EmergencyContactEmployeeEmail" id="Emergency Contact Employee Email" title="<%=employee[0][14]%>" value="<%=employee[0][14]%>" placeholder="Emergency Contact Email Id here !" onblur="requiredFieldValidation('Emergency Contact Employee Email','EmergencyContactEmployeeEmailEerorMSGdiv');verifyEmailId('Emergency Contact Employee Email','EmergencyContactEmployeeEmailEerorMSGdiv');isExistValue('Emergency Contact Employee Email','EmergencyContactEmployeeEmailEerorMSGdiv','<%=employee[0][24]%>');" class="form-control">
                                   </div>
                                   <div id="EmergencyContactEmployeeEmailEerorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>                              
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                <div class="form-group">
                                  <label>Relation with Employee :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" name="relation" id="Relation" placeholder="Relation with Employee" title="<%=employee[0][15]%>"  value="<%=employee[0][15]%>" onblur="requiredFieldValidation('Relation','RelationEerorMSGdiv');validateName('Relation','RelationEerorMSGdiv');validateValue('Relation','RelationEerorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="RelationEerorMSGdiv" class="errormsg"></div>
                                </div>
                                </div>
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                <div class="form-group">
                                  <label>Bank's Name :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon fa fa-bank"></i></span>
                                  <input type="text" name="BankName" id="Bank Name" placeholder="Bank's Name here !" title="<%=employee[0][20]%>" value="<%=employee[0][20]%>" onblur="requiredFieldValidation('Bank Name','BankNameEerorMSGdiv');validateName('Bank Name','BankNameEerorMSGdiv');validateValue('Bank Name','BankNameEerorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="BankNameEerorMSGdiv" class="errormsg"></div>
                                </div>
                                </div>                              
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                <div class="form-group">
                                  <label>Account holder's Name :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon fa fa-user"></i></span>
                                  <input type="text" name="AccountName" id="Account Name" placeholder="Account holder's Name here !" title="<%=employee[0][25]%>" value="<%=employee[0][25]%>" onblur="requiredFieldValidation('Account Name','AccountNameEerorMSGdiv');validateName('Account Name','AccountNameEerorMSGdiv');validateValue('Account Name','AccountNameEerorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="AccountNameEerorMSGdiv" class="errormsg"></div>
                                </div>
                                </div>
                                </div>
                              <div class="row">
                              <div class="col-md-3 col-sm-3 col-xs-12">
                                <div class="form-group">
                                  <label>Bank A/C No. :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" name="BankACNo" id="Bank AC No" placeholder="Bank Account Number here !" title="<%=employee[0][21]%>" value="<%=employee[0][21]%>" onblur="requiredFieldValidation('Bank AC No','BankACNoEerorMSGdiv');isExistValue('Bank AC No','BankACNoEerorMSGdiv','<%=employee[0][24]%>');" class="form-control" onkeypress="return isNumber(event)">
                                  </div>
                                  <div id="BankACNoEerorMSGdiv" class="errormsg"></div>
                                </div>
                                </div>                                
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                <div class="form-group">
                                  <label>IFSC Code :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" name="BankIFSCCode" id="Bank IFSC Code" placeholder="Bank's IFSC Code here !" title="<%=employee[0][22]%>"  value="<%=employee[0][22]%>" onblur="requiredFieldValidation('Bank IFSC Code','BankIFSCCodeEerorMSGdiv');validateUserName('Bank IFSC Code','BankIFSCCodeEerorMSGdiv');validateValue('Bank IFSC Code','BankIFSCCodeEerorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="BankIFSCCodeEerorMSGdiv" class="errormsg"></div>
                                </div>
                                </div>                              
                                <div class="col-md-6 col-sm-6 col-xs-12">
                                <div class="form-group">
                                  <label>Bank's Address :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" name="BankAddress" id="Bank Address" placeholder="Bank's Address here !" title="<%=employee[0][23]%>" value="<%=employee[0][23]%>" onblur="requiredFieldValidation('Bank Address','BankAddressEerorMSGdiv');validateLocation('Bank Address','BankAddressEerorMSGdiv');validateValue('Bank Address','BankAddressEerorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="BankAddressEerorMSGdiv" class="errormsg"></div>
                                </div>
                                </div>  
                                </div>
                              <div class="row">                                                            
                                <div class="col-md-6 col-sm-6 col-xs-12">
                                 <div class="form-group">
                                  <label>Present Address :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite info"></i></span>
                                  <input type="text" name="EmployeePresentAddress" id="Employee Present Address" value="<%=employee[0][17]%>" title="<%=employee[0][17]%>" placeholder="Employee's Present Address here !" onblur="requiredFieldValidation('Employee Present Address','EmployeePresentAddressEerorMSGdiv');validateLocation('Employee Present Address','EmployeePresentAddressEerorMSGdiv');validateValue('Employee Present Address','EmployeePresentAddressEerorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="EmployeePresentAddressEerorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div> 
                                <div class="col-md-6 col-sm-6 col-xs-12">
                                 <div class="form-group">
                                  <label>Permanent Address :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite info"></i></span>
                                  <input type="text" name="EmployeePermanentAddress" id="Employee Permanent Address" value="<%=employee[0][16]%>" title="<%=employee[0][16]%>" placeholder="Employee's Permanent Address here !" onblur="requiredFieldValidation('Employee Permanent Address','EmployeePermanentAddressEerorMSGdiv');validateLocation('Employee Permanent Address','EmployeePermanentAddressEerorMSGdiv');validateValue('Employee Permanent Address','EmployeePermanentAddressEerorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="EmployeePermanentAddressEerorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>
                                </div>
                              <div class="row">
                                <div class="col-md-12 col-sm-12 col-xs-12 item-product-info">
                                <button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateEmployee();">Update Employee<i class="fa fa-paper-plane" aria-hidden="true"></i></button>
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
	$( function() {
		$( "#DateOfBirth" ).datepicker({
			changeMonth: true,
			changeYear: true,
			yearRange: '-60: -0',
			dateFormat: 'dd-mm-yy'
		});
	} );
	$( function() {
		$( "#Date_Of_Joining" ).datepicker({
			changeMonth: true,
			changeYear: true,
			yearRange: '-60: -0',
			dateFormat: 'dd-mm-yy'
		});
	} );
	$( function() {
		$( "#DateofAnniversary" ).datepicker({
			changeMonth: true,
			changeYear: true,
			yearRange: '-60: -0',
			dateFormat: 'dd-mm-yy'
		});
	} );
	</script>
	<script type="text/javascript">
	function isExistValue(value,err,id){
		var val=document.getElementById(value).value.trim();
		if(val!="")
		$.ajax({
			type : "POST",
			url : "ExistEditValue111",
			dataType : "HTML",
			data : {"val":val,"field":"employeeall","id":id},
			success : function(data){
				if(data=="pass"){
				document.getElementById(err).innerHTML=val +" is already existed.";
				document.getElementById(err).style.color="red";
				document.getElementById(value).value="";
				}
				
			}
		});
	}
	
	
function validateEmployee() {
		if (document.getElementById('Employee Prefix').value.trim() == "") {
				EmployeeNameEerorMSGdiv.innerHTML = "Employee's Prefix is required.";
				EmployeeNameEerorMSGdiv.style.color = "red";
				return false;
			}
			if (document.getElementById('Employee Name').value.trim() == "") {
				EmployeeNameEerorMSGdiv.innerHTML = "Employee's Name is required.";
				EmployeeNameEerorMSGdiv.style.color = "red";
				return false;
			}
			if (document.getElementById('Employee Department').value.trim() == "") {
				EmployeeDepartmentEerorMSGdiv.innerHTML = "Department  is required.";
				EmployeeDepartmentEerorMSGdiv.style.color = "red";
				return false;
			}
			if (document.getElementById('Employee Designation').value.trim() == "") {
				EmployeeDesignationEerorMSGdiv.innerHTML = "Designation is required.";
				EmployeeDesignationEerorMSGdiv.style.color = "red";
				return false;
			}
			if (document.getElementById('Employee Mobile').value.trim() == "") {
				EmployeeMobileEerorMSGdiv.innerHTML = "Mobile  is required.";
				EmployeeMobileEerorMSGdiv.style.color = "red";
				return false;
			}
			
			var altermobile=document.getElementById('Employee Alternate Mobile').value.trim();
			if (altermobile== ""||altermobile=="NA"||altermobile=="na"||altermobile=="Na"||altermobile=="nA") {
				document.getElementById('Employee Alternate Mobile').value="NA";
			}else{
				return validateMobileno('Employee Alternate Mobile','EmployeeAlternateMobileEerorMSGdiv');
			}
			
			if (document.getElementById('Employee Email').value.trim() == "") {
				EmployeeEmailEerorMSGdiv.innerHTML = "Employee's Email is required.";
				EmployeeEmailEerorMSGdiv.style.color = "red";
				return false;
			}
			var alteremail=document.getElementById('Employee Alternate Email').value.trim();
			if ( alteremail== ""||alteremail=="NA"||alteremail=="na"||alteremail=="Na"||alteremail=="nA") {
				document.getElementById('Employee Alternate Email').value="NA";
			}else{
				return verifyEmailId('Employee Alternate Email','EmployeeAlternateEmailEerorMSGdiv');
			}
			
			if (document.getElementById('Employee Permanent Address').value.trim() == "") {
				EmployeePermanentAddressEerorMSGdiv.innerHTML = "Permanent Address is required.";
				EmployeePermanentAddressEerorMSGdiv.style.color = "red";
				return false;
			}
			if (document.getElementById('Employee Present Address').value.trim() == "") {
				EmployeePresentAddressEerorMSGdiv.innerHTML = "Present Address is required.";
				EmployeePresentAddressEerorMSGdiv.style.color = "red";
				return false;
			}
			if (document.getElementById('PAN').value.trim() == "") {
				PANEerorMSGdiv.innerHTML = "PAN is required.";
				PANEerorMSGdiv.style.color = "red";
				return false;
			}
			if (document.getElementById('Aadhar').value.trim() == "") {
				AadharEerorMSGdiv.innerHTML = "Aadhar is required.";
				AadharEerorMSGdiv.style.color = "red";
				return false;
			}
			if (document.getElementById('Bank Name').value.trim() == "") {
				BankNameEerorMSGdiv.innerHTML = "Bank's Name is required.";
				BankNameEerorMSGdiv.style.color = "red";
				return false;
			}
			if (document.getElementById('Account Name').value.trim() == "") {
				AccountNameEerorMSGdiv.innerHTML = "Account holder's Name is required.";
				AccountNameEerorMSGdiv.style.color = "red";
				return false;
			}
			if (document.getElementById('Bank AC No').value.trim() == "") {
				BankACNoEerorMSGdiv.innerHTML = "Bank AC No is required.";
				BankACNoEerorMSGdiv.style.color = "red";
				return false;
			}
			if (document.getElementById('Bank IFSC Code').value.trim() == "") {
				BankIFSCCodeEerorMSGdiv.innerHTML = "Bank's IFSC Code is required.";
				BankIFSCCodeEerorMSGdiv.style.color = "red";
				return false;
			}
			if (document.getElementById('Bank Address').value.trim() == "") {
				BankAddressEerorMSGdiv.innerHTML = "Bank's Address is required.";
				BankAddressEerorMSGdiv.style.color = "red";
				return false;
			}
			if (document.getElementById('Emergency Contact Employee Name').value.trim() == "") {
				EmergencyContactEmployeeNameEerorMSGdiv.innerHTML = "Emergency Contact Employee Name is required.";
				EmergencyContactEmployeeNameEerorMSGdiv.style.color = "red";
				return false;
			}
			if (document.getElementById('Emergency Contact Employee Mobile').value.trim() == "") {
				EmergencyContactEmployeeMobileEerorMSGdiv.innerHTML = "Emergency Contact Employee Mobile is required.";
				EmergencyContactEmployeeMobileEerorMSGdiv.style.color = "red";
				return false;
			}
			if (document.getElementById('Relation').value.trim() == "") {
				RelationEerorMSGdiv.innerHTML = "Relation is required.";
				RelationEerorMSGdiv.style.color = "red";
				return false;
			}
			if (document.getElementById('Gender').value.trim() == "") {
				GenderEerorMSGdiv.innerHTML = "Your Gender is required.";
				GenderEerorMSGdiv.style.color = "red";
				return false;
			}
			if (document.getElementById('DateOfBirth').value.trim() == "") {
				DateOfBirthEerorMSGdiv.innerHTML = "Your Date Of Birth is required.";
				DateOfBirthEerorMSGdiv.style.color = "red";
				return false;
			}
			if (document.getElementById('Date_Of_Joining').value.trim() == "") {
				DateOfJoiningEerorMSGdiv.innerHTML = "Your Joining Date is required.";
				DateOfJoiningEerorMSGdiv.style.color = "red";
				return false;
			}
			if (document.getElementById('DateofAnniversary').value.trim() == ""||document.getElementById('DateofAnniversary').value.trim() == "NA") {
				document.getElementById('DateofAnniversary').value="NA";
				
			}
			showLoader();
			//document.registerEmployee.submit();
		}
	</script>
</body>
</html>