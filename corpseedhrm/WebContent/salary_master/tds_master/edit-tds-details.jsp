<!DOCTYPE HTML>
<%@page import="salary_master.SalaryMon_ACT"%>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Edit TDS Details</title>
<%@ include file="../../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../../staticresources/includes/itswsheader.jsp" %>
<% 
String uid=(String) session.getAttribute("passid");
String[][] tdsData=SalaryMon_ACT.getTdsById(uid);
%>
<%if(!MTH03){%><jsp:forward page="/login.html" /><%} %>
<!-- End Header -->

<div id="content">
    <div class="container">   
      <div class="bread-crumb">
        <div class="bd-breadcrumb bd-light">
        <a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
        <a>Edit TDS Details</a>
        </div>
      </div>
    </div>

    <div class="main-content">
        <div class="container">
            <div class="row">
                <div class="col-xs-12">
                    <div class="menuDv post-slider clearfix">
                        <form action="edit-tds.html" method="post" name="registerEmployee" id="registerEmployee">
                        <input type="hidden" name="tdsid" id="tdsid" readonly value="<%=tdsData[0][0]%>">
                        <input type="hidden" name="emid" id="emid" readonly value="<%=tdsData[0][11]%>">
                          <div class="row">
                          <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Employee Name</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
                              <input type="text" autocomplete="off" name="EmployeeName" id="EmployeeName" placeholder="Enter Employee Name" value="<%=tdsData[0][7]%>" onblur="requiredFieldValidation('EmployeeName','EmployeeNameEerorMSGdiv');" class="form-control" readonly="readonly">
                              </div>
                              <div id="EmployeeNameEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                          <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Employee ID</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
                              <input type="text" autocomplete="off" name="EmployeeID" id="emuid" readonly value="<%=tdsData[0][8]%>" class="form-control">
                              </div>
                             </div>
                            </div>
                            <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Employee Department</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
                              <input type="text" autocomplete="off" name="EmployeeDepartment" id="emdept" readonly value="<%=tdsData[0][9]%>" class="form-control">
                              </div>
                             </div>
                            </div>
                           <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Employee Designation</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
                              <input type="text" autocomplete="off" name="EmployeeDesignation" id="emdesig" readonly value="<%=tdsData[0][10]%>" class="form-control">
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
                              <input type="text" autocomplete="off" name="tdsamt" id="tdsamt" placeholder="Enter TDS Amount" value="<%=tdsData[0][4]%>" onblur="requiredFieldValidation('tdsamt','tdsamtEerorMSGdiv');" class="form-control">
                              </div>
                              <div id="tdsamtEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                           <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Paid For the Month of</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
                              <input type="text" autocomplete="off" name="tdsmonth" id="tdsmonth" placeholder="Select Month " value="<%=tdsData[0][5]%>" onblur="requiredFieldValidation('tdsmonth','tdsmonthEerorMSGdiv');" class="form-control">
                               </div>
                               <div id="tdsmonthEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                            <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Paid From</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
                              <input type="text" autocomplete="off" name="tdspaidfrom" id="tdspaidfrom" placeholder="Enter TDS Paid From" value="<%=tdsData[0][1]%>" onblur="requiredFieldValidation('tdspaidfrom','tdspaidfromEerorMSGdiv');" class="form-control">
                              </div>
                              <div id="tdspaidfromEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                           <div class="col-md-3 col-sm-3 col-xs-12">
                             <div class="form-group">
                              <label>Paid To</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>
                              <input type="text" autocomplete="off" name="tdspaidto" id="tdspaidto" placeholder="Enter Tds Paid To" value="<%=tdsData[0][2]%>" onblur="requiredFieldValidation('tdspaidto','tdspaidtoEerorMSGdiv');" class="form-control">
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
                              <input type="text" autocomplete="off" name="tdspaidon" id="tdspaidon" placeholder="Select Tds Paid On" value="<%=tdsData[0][3]%>" onblur="requiredFieldValidation('tdspaidon','tdspaidonEerorMSGdiv');" class="form-control">
                              </div>
                              <div id="tdspaidonEerorMSGdiv" class="errormsg"></div>
                             </div>
                            </div>
                            <div class="col-md-9 col-sm-9 col-xs-12">
                             <div class="form-group">
                              <label>Remarks</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite mobile-number"></i></span>
                              <input type="text" autocomplete="off" name="tdsremarks" id="tdsremarks" placeholder="Enter Remarks" value="<%=tdsData[0][6]%>" onblur="requiredFieldValidation('tdsremarks','tdsremarksEerorMSGdiv');" class="form-control">
                              </div>
                              <div id="tdsremarksEerorMSGdiv" class="errormsg"></div>
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
</div>
<%@ include file="../../staticresources/includes/itswsfooter.jsp" %>
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
        $( "#tdsmonth" ).datepicker({
            changeMonth: true,
            changeYear: true,
            dateFormat: 'mm-yy'
        });
    } );
    
    $( function() {
        $( "#tdspaidon" ).datepicker({
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
        if (document.getElementById('tdsamt').value == "") {
            tdsamtEerorMSGdiv.innerHTML = "TDS Amount is required.";
            tdsamtEerorMSGdiv.style.color = "#800606";
            return false;
        }
        if (document.getElementById('tdspaidfrom').value == "") {
            tdspaidfromEerorMSGdiv.innerHTML = "Paid From is required.";
            tdspaidfromEerorMSGdiv.style.color = "#800606";
            return false;
        }
        if (document.getElementById('tdspaidto').value == "") {
            tdspaidtoEerorMSGdiv.innerHTML = "Paid To is required.";
            tdspaidtoEerorMSGdiv.style.color = "#800606";
            return false;
        }
        if (document.getElementById('tdspaidon').value == "") {
            tdspaidonEerorMSGdiv.innerHTML = "Paid On is required.";
            tdspaidonEerorMSGdiv.style.color = "#800606";
            return false;
        }
        if (document.getElementById('tdsmonth').value == "") {
            tdsmonthEerorMSGdiv.innerHTML = "Month  is required.";
            tdsmonthEerorMSGdiv.style.color = "#800606";
            return false;
        }
        if (document.getElementById('tdsremarks').value == "") {
            tdsremarksEerorMSGdiv.innerHTML = "Remarks is required.";
            tdsremarksEerorMSGdiv.style.color = "#800606";
            return false;
        }
        
        document.registerEmployee.submit();
    }
</script>
</body>
</html>