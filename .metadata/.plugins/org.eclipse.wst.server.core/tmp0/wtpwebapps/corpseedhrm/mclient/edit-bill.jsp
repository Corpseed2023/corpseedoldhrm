<%@page import="client_master.Clientmaster_ACT"%>
<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title>Billing Details</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%
String[][] billdata=null;
String addedby= (String)session.getAttribute("loginuID");
String uid=(String) session.getAttribute("passid");
// String[][] billdata=Clientmaster_ACT.getBillByID(uid);
	%>
<%if(!CB06){%><jsp:forward page="/login.html" /><%} %>
    
	<div id="content">
		<div class="container">   
          <div class="bread-crumb">
            <div class="bd-breadcrumb bd-light">
            <a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
            <a>Billing Details</a>
            </div>
          </div>
        </div>

		<div class="main-content">
			<div class="container">
				<div class="row">
                	<div class="col-xs-12">
                        <div class="menuDv  post-slider">
                            <form action="update-bill.html" method="post" name="userBill" id="userBill">
                              <div class="row">
                              <div class="col-md-4 col-sm-4 col-xs-12">
                                 <div class="form-group">
                                  <label>Billing InVno </label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite fa fa-chrome"></i></span>
                                  <input type="text" name="InVno" id="InV_no" value="<%=billdata[0][7]%>"placeholder="Enter InVno Value" onblur="requiredFieldValidation('InV_no','InV_noErrorMSGdiv');" readonly class="form-control">
                                  </div>
                                  <div id="InV_noErrorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>
                                <div class="col-md-4 col-sm-4 col-xs-12">
                                 <div class="form-group">
                                  <input type="hidden" name="addedbyuser" value="<%=addedby%>">
                                 <input type="hidden" name="uid" value="<%=uid%>">
                                 <input type="hidden" readonly name="cid" id="cid" value="<%=billdata[0][8]%>">
                                 <input type="hidden" readonly name="pid" id="pid" value="<%=billdata[0][9]%>">
                                  <label>Client Name</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
                                  <input type="text" name="clientName" value="<%=billdata[0][1]%>"id="Client_Name" autocomplete="off" placeholder="Enter Client Name" onblur="requiredFieldValidation('Client_Name','ClientNameErrorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="ClientNameErrorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>
                                <div class="col-md-4 col-sm-4 col-xs-12">
                                 <div class="form-group">
                                  <label>Project Name</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
                                  <input type="text" name="projectName" value="<%=billdata[0][10]%>" id="Project_Name" autocomplete="off" placeholder="Enter Project Name" onblur="requiredFieldValidation('Project_Name','ProjectNameErrorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="ProjectNameErrorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>
                                </div>
                                  <div class="row">
                                <div class="col-md-4 col-sm-4 col-xs-12">
                                 <div class="form-group">
                                  <label>Project Type</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
                                  <input type="text" name="projectType" id="Project_Type" value="<%=billdata[0][11]%>" placeholder="Enter Project Type" onblur="requiredFieldValidation('Project_Type','ProjectTypeErrorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="ProjectTypeErrorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>
                                  <div class="col-md-4 col-sm-4 col-xs-12">
                                 <div class="form-group">
                                  <label>Billing Type</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon fa fa-search"></i></span>
                                  <select id="Billing Type" name="BillingType"onblur="requiredFieldValidation('Billing Type','BillingTypeErrorMSGdiv');" class="form-control">
                                  <%
                                  if(billdata[0][4]!=null)
                                  {%>
                                	 <option value="<%=billdata[0][4] %>"><%=billdata[0][4] %></option> 
                                  <%}%>
                                      <option value="">Select Type</option>
                                      <option value="Monthly">Monthly</option>
                                      <option value="Quaterly">Quaterly</option>
                                      <option value="Half-Yearly">Half-Yearly</option>
                                      <option value="Yearly">Yearly</option>
                                   </select>
                                  </div>
                                  <div id="BillingTypeErrorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>
                                <div class="col-md-4 col-sm-4 col-xs-12">
                                 <div class="form-group">
                                  <label>Quotation Value </label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite fa fa-chrome"></i></span>
                                  <input type="text" name="QuotationValue" id="Quotation Value" value="<%=billdata[0][2]%>" placeholder="Enter Quotation Value" onblur="requiredFieldValidation('Quotation Value','QuotationValueErrorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="QuotationValueErrorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>
                                </div>
                             <div class="row">
                                <div class="col-md-4 col-sm-4 col-xs-12">
                                 <div class="form-group">
                                  <label>Final Value</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite list"></i></span>
                                  <input type="text" name="FinalValue" id="Final Value"value="<%=billdata[0][3]%>"  placeholder="Enter Final Value" onblur="requiredFieldValidation('Final Value','FinalValueErrorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="FinalValueErrorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>
                                <div class="col-md-4 col-sm-4 col-xs-12">
                                 <div class="form-group">
                                  <label>Discount</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite info"></i></span>
                                  <input type="text" name="Discount" id="Discount" value="<%=billdata[0][5]%>" placeholder="Enter Discount" onblur="requiredFieldValidation('Discount','DiscountErrorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="DiscountErrorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>
                                <div class="col-md-4 col-sm-4 col-xs-12">
                                 <div class="form-group">
                                  <label>Billing Date</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite info"></i></span>
                                  <input type="text" name="BillingDate" id="BillingDate" value="<%=billdata[0][12]%>" placeholder="Enter Billing Date" onblur="requiredFieldValidation('BillingDate','BillingDateErrorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="BillingDateErrorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>
                             </div>
                             <div class="row">
                             <div class="col-md-4 col-sm-4 col-xs-12">
                                 <div class="form-group">
                                  <label>Status</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite info"></i></span>
                                  <input type="text" name="BillingStatus" id="BillingStatus" value="<%=billdata[0][13]%>" placeholder="Enter Billing Status" onblur="requiredFieldValidation('BillingStatus','BillingStatusErrorMSGdiv');" class="form-control">
                                  </div>
                                  <div id="BillingStatusErrorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>
                                </div>
                              <div class="row">
                             <div class="col-md-12 col-sm-12 col-xs-12">
                                <div class="form-group">
                                  <label>Remarks</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <textarea class="form-control" name="shortdescription"  id="Remarks" placeholder="Short Description" onblur="requiredFieldValidation('Remarks','RemarksErrorMSGdiv');"><%=billdata[0][6]%></textarea>
                                  </div>
                                  <div id="RemarksErrorMSGdiv" class="errormsg"></div>
                                </div>
                                </div>
                             </div>
                              <div class="row"> 
                                <div class="col-md-12 col-sm-12 col-xs-12 item-product-info">
                                <button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return billing();">Update<i class="fa fa-paper-plane" aria-hidden="true"></i></button>
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
$(function() {
	$("#BillingDate").datepicker({
		changeMonth: true,
		changeYear: true,
		dateFormat: 'dd-mm-yy',
	});
});
</script>
<script type="text/javascript">
function billing() {
	if(document.getElementById('Client_Name').value=="" ) {
	ClientNameErrorMSGdiv.innerHTML="Client Name is required.";
	ClientNameErrorMSGdiv.style.color="#800606";
	return false;
}
	if(document.getElementById('Billing Type').value=="") {
	BillingTypeErrorMSGdiv.innerHTML="Billing Type is required.";
	BillingTypeErrorMSGdiv.style.color="#800606";
		return false;
	}
	if(document.getElementById('Quotation Value').value==""){
	QuotationValueErrorMSGdiv.innerHTML="Quotation Value is required.";
	QuotationValueErrorMSGdiv.style.color="#800606";
	return false;
}
	if(document.getElementById('Final Value').value==""){
		FinalValueErrorMSGdiv.innerHTML="Final Value is required.";
		FinalValueErrorMSGdiv.style.color="#800606";
	return false;
}
	if(document.getElementById('Discount').value==""){
		DiscountErrorMSGdiv.innerHTML="Discount is required.";
		DiscountErrorMSGdiv.style.color="#800606";
		return false;
	}
	if(document.getElementById('Remarks').value==""){
		RemarksErrorMSGdiv.innerHTML="Remark is required.";
		RemarksErrorMSGdiv.style.color="#800606";
		return false;
	}
document.userBill.submit();
}

$(function() {
	$("#Client_Name").autocomplete({
		source: function(request, response) {
		$.ajax({
		url: "getclientname.html",
	    type: "POST",
		dataType: "json",
		data: {	name: request.term},
		success: function( data ) {			
		response( $.map( data, function( item ) {
			return {
				label: item.name,
				value: item.value,
				id: item.id,
		};}));},
		error: function (error) {
	       alert('error: ' + error);
	    }});},
		select : function(e, ui) {
	    	$("#cid").val(ui.item.id);
		},});
	});

$(function() {
	$("#Project_Name").autocomplete({
		source: function(request, response) {
		$.ajax({
		url: "getprojectname.html",
	    type: "POST",
		dataType: "json",
		data: {	name: request.term, cid : document.getElementById("cid").value},
		success: function( data ) {			
		response( $.map( data, function( item ) {
			return {
				label: item.name,
				value: item.value,
				type:item.type,
				id: item.id,
		};}));},
		error: function (error) {
	       alert('error: ' + error);
	    }});},
		select : function(e, ui) {
	    	$("#pid").val(ui.item.id);
	    	$("#Project_Type").val(ui.item.type);
		},});
	});
</script>	
</body>
</html>