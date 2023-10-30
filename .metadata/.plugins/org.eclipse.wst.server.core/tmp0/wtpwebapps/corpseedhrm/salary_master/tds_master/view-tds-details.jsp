<!DOCTYPE HTML>
<%@page import="salary_master.SalaryMon_ACT"%>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>View TDS Details</title>
<%@ include file="../../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<% 
String uid=(String) session.getAttribute("passid");
String[][] tdsData=SalaryMon_ACT.getTdsById(uid);
%>

<!-- End Header -->

<div id="content">    
    <div class="pad_box1 clearfix">
        <div class="container">
            <div class="row">
                <div class="col-xs-12">
                    <div class="menuDv post-slider clearfix">
                        <form method="post">
                        <input type="hidden" name="emid" id="emid" readonly>
                          <div class="row">
                          <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Employee Name</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
                              <input type="text" name="EmployeeName" id="EmployeeName" readonly value="<%=tdsData[0][7]%>" class="form-control">
                              </div>
                              <div id="EmployeeNameEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                          <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Employee ID</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
                              <input type="text" name="EmployeeID" id="emuid" readonly value="<%=tdsData[0][8]%>" class="form-control">
                              </div>
                             </div>
                            </div>
                            <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Employee Department</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
                              <input type="text" name="EmployeeDepartment" id="emdept" readonly value="<%=tdsData[0][9]%>" class="form-control">
                              </div>
                             </div>
                            </div>
                           <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Employee Designation</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
                              <input type="text" name="EmployeeDesignation" id="emdesig" readonly value="<%=tdsData[0][10]%>" class="form-control">
                               </div>
                             </div>
                            </div>
                            </div>
                          <div class="row">
                            <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>TDS Amount</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
                              <input type="text" name="tdsamt" id="tdsamt" readonly value="<%=tdsData[0][4]%>" class="form-control">
                              </div>
                              <div id="tdsamtEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                           <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Paid For the Month of</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
                              <input type="text" name="tdsmonth" id="tdsmonth" readonly value="<%=tdsData[0][5]%>" class="form-control">
                               </div>
                               <div id="tdsmonthEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                            <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Paid From</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
                              <input type="text" name="tdspaidfrom" id="tdspaidfrom" readonly value="<%=tdsData[0][1]%>" class="form-control">
                              </div>
                              <div id="tdspaidfromEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                           <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Paid To</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
                              <input type="text" name="tdspaidto" id="tdspaidto" readonly value="<%=tdsData[0][2]%>" class="form-control">
                               </div>
                               <div id="tdspaidtoEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                            </div>
                          <div class="row">
                            <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Paid On</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
                              <input type="text" name="tdspaidon" id="tdspaidon" readonly value="<%=tdsData[0][3]%>" class="form-control">
                              </div>
                              <div id="tdspaidonEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                             <div class="col-md-9 col-sm-9 col-xs-12">
                             <div class="form-group">
                              <label>Remarks</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
                              <input type="text" name="tdsremarks" id="tdsremarks" readonly value="<%=tdsData[0][6]%>" class="form-control">
                              </div>
                              <div id="tdsremarksEerorMSGdiv" class="errormsg"></div>
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
<%@ include file="../../staticresources/includes/itswsscripts.jsp" %>
</body>
</html>