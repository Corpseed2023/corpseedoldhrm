<!DOCTYPE HTML>
<%@page import="salary_master.SalaryMon_ACT"%>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>View Med Details</title>
<%@ include file="../../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../../staticresources/includes/itswsheader.jsp" %>
<% 
String uid=(String) session.getAttribute("passid");
String[][] medData=SalaryMon_ACT.getMedById(uid);
%>
<%if(!MMH02){%><jsp:forward page="/login.html" /><%} %>
<!-- End Header -->

<div id="content">
    <div class="container">   
      <div class="bread-crumb">
        <div class="bd-breadcrumb bd-light">
        <a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
        <a>View Med Details</a>
        </div>
      </div>
    </div>

    <div class="main-content">
        <div class="container">
            <div class="row">
                <div class="col-xs-12">
                    <div class="menuDv post-slider clearfix">
                        <form>
                        <input type="hidden" name="emid" id="emid" readonly>
                          <div class="row">
                          <div class="col-md-4 col-sm-4 col-xs-12">
                             <div class="form-group">
                              <label>Employee Name</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
                              <input type="text" name="EmployeeName" id="EmployeeName" readonly value="<%=medData[0][7]%>" class="form-control">
                              </div>
                              <div id="EmployeeNameEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                          <div class="col-md-4 col-sm-4 col-xs-12">
                             <div class="form-group">
                              <label>Employee ID</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
                              <input type="text" name="EmployeeID" id="emuid" readonly value="<%=medData[0][8]%>" class="form-control">
                              </div>
                             </div>
                            </div>
                            <div class="col-md-4 col-sm-4 col-xs-12">
                             <div class="form-group">
                              <label>Employee Department</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
                              <input type="text" name="EmployeeDepartment" id="emdept" readonly value="<%=medData[0][9]%>" class="form-control">
                              </div>
                             </div>
                            </div>
                          </div>
                          <div class="row">
                           <div class="col-md-4 col-sm-4 col-xs-12">
                             <div class="form-group">
                              <label>Employee Designation</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
                              <input type="text" name="EmployeeDesignation" id="emdesig" readonly value="<%=medData[0][10]%>" class="form-control">
                               </div>
                             </div>
                            </div>
                            <div class="col-md-4 col-sm-4 col-xs-12">
                             <div class="form-group">
                              <label>Med Amount</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
                              <input type="text" name="medamt" id="medamt" readonly value="<%=medData[0][4]%>" class="form-control">
                              </div>
                              <div id="medamtEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                           <div class="col-md-4 col-sm-4 col-xs-12">
                             <div class="form-group">
                              <label>Paid For the Month of</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
                              <input type="text" name="medmonth" id="medmonth" readonly value="<%=medData[0][5]%>" class="form-control">
                               </div>
                               <div id="medmonthEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                          </div>
                          <div class="row">
                            <div class="col-md-4 col-sm-4 col-xs-12">
                             <div class="form-group">
                              <label>Paid From</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
                              <input type="text" name="medpaidfrom" id="medpaidfrom" readonly value="<%=medData[0][1]%>" class="form-control">
                              </div>
                              <div id="medpaidfromEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                           <div class="col-md-4 col-sm-4 col-xs-12">
                             <div class="form-group">
                              <label>Paid To</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
                              <input type="text" name="medpaidto" id="medpaidto" readonly value="<%=medData[0][2]%>" class="form-control">
                               </div>
                               <div id="medpaidtoEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                            <div class="col-md-4 col-sm-4 col-xs-12">
                             <div class="form-group">
                              <label>Paid On</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
                              <input type="text" name="medpaidon" id="medpaidon" readonly value="<%=medData[0][3]%>" class="form-control">
                              </div>
                              <div id="medpaidonEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                            </div>
                          <div class="row">
                            <div class="col-md-12 col-sm-12 col-xs-12">
                             <div class="form-group">
                              <label>Remarks</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
                              <input type="text" name="medremarks" id="medremarks" readonly value="<%=medData[0][6]%>" class="form-control">
                              </div>
                              <div id="medremarksEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- End Advert -->
</div>
<!-- End Content -->
<%@ include file="../../staticresources/includes/itswsfooter.jsp" %>
<!-- End Footer -->
</div>
<%@ include file="../../staticresources/includes/itswsscripts.jsp" %>
</body>
</html>