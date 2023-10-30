<!DOCTYPE HTML>
<%@page import="employee_master.Employee_ACT"%>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title>View Employee</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
	<%
	String url = request.getParameter("uid");
	String[] a=url.split(".html");
	String[] b=a[0].split("-");
	String emid=b[1];
	String[][] employee = Employee_ACT.getEmployeeById(emid); %>
	<div id="content">
			<div class="main-content">
			<div class="container">
				<div class="row">
                	<div class="col-xs-12">
                        <div class="menuDv  post-slider">
                            <form>
                              <div class="row">
                              <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <label>Employee ID :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
                                  <input type="text" title="<%=employee[0][0]%>" value="<%=employee[0][0]%>" readonly class="form-control">
                                  </div>
                                  </div>
                                </div>
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <label>Employee Name :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
                                  <input type="text" title="<%=employee[0][1]%> <%=employee[0][2]%>" value="<%=employee[0][1]%>" readonly class="form-control text-center" style="width: 18%; padding: 0 2px;">
                                  <input type="text" title="<%=employee[0][1]%> <%=employee[0][2]%>" value="<%=employee[0][2]%>" readonly class="form-control" style="width: 82%;">
                                  </div>
                                 </div>
                                </div>
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <label>Department :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
                                  <input type="text" title="<%=employee[0][3]%>" value="<%=employee[0][3]%>" readonly class="form-control">
                                  </div>
                                 </div>
                                </div>                              
                               <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <label>Designation :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
                                  <input type="text" title="<%=employee[0][4]%>" value="<%=employee[0][4]%>" readonly class="form-control">
                                  </div>
                                 </div>
                                </div>
                                </div>
                              <div class="row">
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <label>Mobile No. :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
                                  <input type="text" title="<%=employee[0][5]%>" value="<%=employee[0][5]%>" readonly class="form-control">
                                  </div>
                                 </div>
                                </div>
                                  <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <label>Alternate Mobile No. :</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
                                  <input type="text" title="<%=employee[0][8]%>" value="<%=employee[0][8]%>" readonly class="form-control">
                                  </div>
                                 </div>
                                </div>                                
                               <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <label>Email Id :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
                                  <input type="text" title="<%=employee[0][6]%>" value="<%=employee[0][6]%>" readonly class="form-control">
                                  </div>
                                 </div>
                                </div>
                               <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <label>Alternate Email Id :</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
                                  <input type="text" title="<%=employee[0][9]%>" value="<%=employee[0][9]%>" readonly class="form-control">
                                  </div>
                                 </div>
                                </div>
                              </div>
                              <div class="row">                                                           
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                <div class="form-group">
                                  <label>PAN :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" title="<%=employee[0][18]%>" value="<%=employee[0][18]%>" readonly class="form-control">
                                  </div>
                                </div>
                                </div>
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                <div class="form-group">
                                  <label>Aadhar :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" title="<%=employee[0][19]%>" value="<%=employee[0][19]%>" readonly class="form-control">
                                  </div>
                                </div>
                                </div>                                
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                <div class="form-group">
                                  <label>Gender :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" title="<%=employee[0][7]%>" value="<%=employee[0][7]%>" readonly class="form-control">
                                  </div>
                                </div>
                                </div>
                                 <div class="col-md-3 col-sm-3 col-xs-12">
								<div class="form-group">
								<label>Date Of Joining :<span style="color: red;">*</span></label>
								<div class="input-group">
								<span class="input-group-addon"><i class="form-icon sprite page"></i></span>
								<input type="text" name="DateOfJoining" id="Date_Of_Joining" title="<%=employee[0][26]%>" placeholder="Select your Joining date" value="<%=employee[0][26]%>" class="form-control" readonly>
								</div>
								</div>
								</div>
								</div>
                              <div class="row">
                              <div class="col-md-3 col-sm-3 col-xs-12">
                                <div class="form-group">
                                  <label>Date Of Birth :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" title="<%=employee[0][10]%>" value="<%=employee[0][10]%>" readonly class="form-control">
                                  </div>
                                </div>
                                </div>
								<div class="col-md-3 col-sm-3 col-xs-12">
                                <div class="form-group">
                                  <label>Date of Anniversary :</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" title="<%=employee[0][11]%>" value="<%=employee[0][11]%>" readonly class="form-control">
                                  </div>
                                </div>
                                </div>								 
                               <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <label>Emergency Contact Name :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
                                  <input type="text" title="<%=employee[0][12]%>" value="<%=employee[0][12]%>" readonly class="form-control">
                                  </div>
                                 </div>
                                </div>
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <label>Emergency Contact Mobile No. :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
                                  <input type="text" title="<%=employee[0][13]%>" value="<%=employee[0][13]%>" readonly class="form-control">
                                  </div>
                                 </div>
                                </div>
                                </div>
                              <div class="row">
                               <div class="col-md-3 col-sm-3 col-xs-12">
                                 <div class="form-group">
                                  <label>Emergency Contact Email Id :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
                                  <input type="text" title="<%=employee[0][14]%>" value="<%=employee[0][14]%>" readonly class="form-control">
                                  </div>
                                 </div>
                                </div>                              
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                <div class="form-group">
                                  <label>Relation with Employee :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" title="<%=employee[0][15]%>" value="<%=employee[0][15]%>" readonly class="form-control">
                                  </div>
                                </div>
                                </div>                                
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                <div class="form-group">
                                  <label>Bank's Name :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" title="<%=employee[0][20]%>" value="<%=employee[0][20]%>" readonly class="form-control">
                                  </div>
                                </div>
                                </div>                             
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                <div class="form-group">
                                  <label>Account holder's Name :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" title="<%=employee[0][25]%>" value="<%=employee[0][25]%>" readonly class="form-control">
                                  </div>
                                </div>
                                </div>
                                </div>
                              <div class="row">
                              <div class="col-md-3 col-sm-3 col-xs-12">
                                <div class="form-group">
                                  <label>Bank A/C No. :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" title="<%=employee[0][21]%>" value="<%=employee[0][21]%>" readonly class="form-control">
                                  </div>
                                </div>
                                </div>                                 
                                <div class="col-md-3 col-sm-3 col-xs-12">
                                <div class="form-group">
                                  <label>Bank's IFSC Code :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" title="<%=employee[0][22]%>" value="<%=employee[0][22]%>" readonly class="form-control">
                                  </div>
                                </div>
                                </div>                              
                                <div class="col-md-6 col-sm-6 col-xs-12">
                                <div class="form-group">
                                  <label>Bank's Address :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" title="<%=employee[0][23]%>" value="<%=employee[0][23]%>" readonly class="form-control">
                                  </div>
                                </div>
                                </div>
                                 </div>
                              <div class="row">                                
                                 <div class="col-md-6 col-sm-6 col-xs-12">
                                 <div class="form-group">
                                  <label>Employee's Present Address :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite info"></i></span>
                                  <input type="text" title="<%=employee[0][17]%>" value="<%=employee[0][17]%>" readonly class="form-control">
                                  </div>
                                 </div>
                                </div>
                                  <div class="col-md-6 col-sm-6 col-xs-12">
                                 <div class="form-group">
                                  <label>Employee's Permanent Address :<span style="color: red;">*</span></label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite info"></i></span>
                                  <input type="text" title="<%=employee[0][16]%>" value="<%=employee[0][16]%>" readonly class="form-control">
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