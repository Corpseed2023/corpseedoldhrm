<!DOCTYPE HTML>
<%@page import="salary_master.SalaryMon_ACT"%>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Add Med Details</title>
<%@ include file="../../staticresources/includes/itswsstyles.jsp" %> 

</head>
<body>
<div class="wrap">
<%@ include file="../../staticresources/includes/itswsheader.jsp" %>
<% 
String uid=(String) session.getAttribute("passid");
String[][] medData=SalaryMon_ACT.getMedById(uid);
%>
<%if(!MMH03){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
    <div class="container">   
      <div class="bread-crumb">
        <div class="bd-breadcrumb bd-light">
        <a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
        <a>Add Med Details</a>
        </div>
      </div>
    </div>

    <div class="main-content">
        <div class="container">
            <div class="row">
                <div class="col-xs-12">
                    <div class="menuDv post-slider clearfix">
                        <form action="edit-med.html" method="post" name="registerEmployee" id="registerEmployee">
                        <input type="hidden" name="medid" id="medid" readonly value="<%=medData[0][0]%>">
                        <input type="hidden" name="emid" id="emid" readonly value="<%=medData[0][11]%>">
                          <div class="row">
                          <div class="col-md-4 col-sm-4 col-xs-12">
                             <div class="form-group">
                              <label>Employee Name</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
                              <input type="text" autocomplete="off" name="EmployeeName" id="EmployeeName" value="<%=medData[0][7]%>" placeholder="Enter Employee Name" onblur="requiredFieldValidation('EmployeeName','EmployeeNameEerorMSGdiv');" class="form-control">
                              </div>
                              <div id="EmployeeNameEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                          <div class="col-md-4 col-sm-4 col-xs-12">
                             <div class="form-group">
                              <label>Employee ID</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
                              <input type="text" autocomplete="off" name="EmployeeID" id="emuid" readonly value="<%=medData[0][8]%>" class="form-control">
                              </div>
                             </div>
                            </div>
                            <div class="col-md-4 col-sm-4 col-xs-12">
                             <div class="form-group">
                              <label>Employee Department</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
                              <input type="text" autocomplete="off" name="EmployeeDepartment" id="emdept" readonly value="<%=medData[0][9]%>" class="form-control">
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
                              <input type="text" autocomplete="off" name="EmployeeDesignation" id="emdesig" readonly value="<%=medData[0][10]%>" class="form-control">
                               </div>
                             </div>
                            </div>
                            <div class="col-md-4 col-sm-4 col-xs-12">
                             <div class="form-group">
                              <label>Med Amount</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
                              <input type="text" autocomplete="off" name="medamt" id="medamt" placeholder="Enter Med Amount" value="<%=medData[0][4]%>" onblur="requiredFieldValidation('medamt','medamtEerorMSGdiv');" class="form-control">
                              </div>
                              <div id="medamtEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                           <div class="col-md-4 col-sm-4 col-xs-12">
                             <div class="form-group">
                              <label>Paid For the Month of</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
                              <input type="text" autocomplete="off" name="medmonth" id="medmonth" placeholder="Select Month " value="<%=medData[0][5]%>" onblur="requiredFieldValidation('medmonth','medmonthEerorMSGdiv');" class="form-control">
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
                              <input type="text" autocomplete="off" name="medpaidfrom" id="medpaidfrom" placeholder="Enter Med Paid From" value="<%=medData[0][1]%>" onblur="requiredFieldValidation('medpaidfrom','medpaidfromEerorMSGdiv');" class="form-control">
                              </div>
                              <div id="medpaidfromEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                           <div class="col-md-4 col-sm-4 col-xs-12">
                             <div class="form-group">
                              <label>Paid To</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
                              <input type="text" autocomplete="off" name="medpaidto" id="medpaidto" placeholder="Enter Med Paid To" value="<%=medData[0][2]%>" onblur="requiredFieldValidation('medpaidto','medpaidtoEerorMSGdiv');" class="form-control">
                               </div>
                               <div id="medpaidtoEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                            <div class="col-md-4 col-sm-4 col-xs-12">
                             <div class="form-group">
                              <label>Paid On</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
                              <input type="text" autocomplete="off" name="medpaidon" id="medpaidon" placeholder="Select Med Paid On" value="<%=medData[0][3]%>" onblur="requiredFieldValidation('medpaidon','medpaidonEerorMSGdiv');" class="form-control">
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
                              <input type="text" autocomplete="off" name="medremarks" id="medremarks" placeholder="Enter Remarks" value="<%=medData[0][6]%>" onblur="requiredFieldValidation('medremarks','medremarksEerorMSGdiv');" class="form-control">
                              </div>
                              <div id="medremarksEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                            </div>
                          <div class="row">
                            <div class="col-md-12 col-sm-12 col-xs-12 item-product-info">
                            <button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return registerEmployee();">Update<i class="fa fa-paper-plane" aria-hidden="true"></i></button>
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
<script type="text/javascript">
    $(function() {
        $("#EmployeeName").autocomplete({
            source : function(request, response) {
                $.ajax({
                    url : "get-employee.html",
                    type : "POST",
                    dataType : "json",
                    data : {
                        name : request.term

                    },
                    success : function(data) {
                        response($.map(data, function(item) {
                            return {
                                label : item.emname,
                                value : item.emname,
                                emid : item.emid,
                                emuid : item.emuid,
                                emdept : item.emdept,
                                emdesig : item.emdesig
                            };
                        }));
                    },
                    error : function(error) {
                        alert('error: ' + error);
                    }
                });
            },
            select : function(e, ui) {
                $("#emid").val(ui.item.emid);
                $("#emuid").val(ui.item.emuid);
                $("#emdept").val(ui.item.emdept);
                $("#emdesig").val(ui.item.emdesig);
            },
        });
    });
    
    $( function() {
        $( "#medmonth" ).datepicker({
            changeMonth: true,
            changeYear: true,
            dateFormat: 'mm-yy'
        });
    } );
    
    $( function() {
        $( "#medpaidon" ).datepicker({
            changeMonth: true,
            changeYear: true,
            dateFormat: 'dd-mm-yy'
        });
    } );
</script>
<script type="text/javascript">
  function registerEmployee() {

        if (document.getElementById('EmployeeName').value == "") {
            EmployeeNameEerorMSGdiv.innerHTML = "Employee Name is required.";
            EmployeeNameEerorMSGdiv.style.color = "#800606";
            return false;
        }
        if (document.getElementById('medamt').value == "") {
            medamtEerorMSGdiv.innerHTML = "Med Amount is required.";
            medamtEerorMSGdiv.style.color = "#800606";
            return false;
        }
        if (document.getElementById('medpaidfrom').value == "") {
            medpaidfromEerorMSGdiv.innerHTML = "Paid From is required.";
            medpaidfromEerorMSGdiv.style.color = "#800606";
            return false;
        }
        if (document.getElementById('medpaidto').value == "") {
            medpaidtoEerorMSGdiv.innerHTML = "Paid To is required.";
            medpaidtoEerorMSGdiv.style.color = "#800606";
            return false;
        }
        if (document.getElementById('medpaidon').value == "") {
            medpaidonEerorMSGdiv.innerHTML = "Paid On is required.";
            medpaidonEerorMSGdiv.style.color = "#800606";
            return false;
        }
        if (document.getElementById('medmonth').value == "") {
            medmonthEerorMSGdiv.innerHTML = "Month  is required.";
            medmonthEerorMSGdiv.style.color = "#800606";
            return false;
        }
        if (document.getElementById('medremarks').value == "") {
            medremarksEerorMSGdiv.innerHTML = "Remarks is required.";
            medremarksEerorMSGdiv.style.color = "#800606";
            return false;
        }
        
        document.registerEmployee.submit();
    }
</script>
</body>
</html>