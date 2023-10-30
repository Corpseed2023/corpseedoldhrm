<%@page import="hcustbackend.ClientACT"%>
<%@ include file="../../madministrator/checkvalid_user.jsp" %>
<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title></title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div class="wrap">
   <% String token = (String) session.getAttribute("uavalidtokenno");
   String billrefid=request.getParameter("brf");
   String billtype=request.getParameter("btpe");
   String[] bill=ClientACT.getbillingDetails(billrefid,token); 
   String[] billpayment=ClientACT.getbillingPaymentDetails(billrefid,token,billtype);  
   String billno="NA";
   String billdate="NA";
   String billamt="0";
   String dueamt="0";
   if(bill.length>=0&&bill!=null){
	   billno=bill[0];
	   billdate=bill[3];
	   billamt=bill[4];
	   dueamt=bill[5];
   }
   %>
   
    <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="menuDv marg10">
                    <div class="box-intro">
                      <h2><span class="title">Confirm Client's Payment</span></h2>
                    </div>
                <div class="row pad_box2">
                <div class="col-md-4">
                <div class="row" style="margin-top: 20px">               
                <div class="col-md-5"><h5>Bill No.</h5></div><div class="col-md-7"><h5>:&nbsp;&nbsp; <%=billno %></h5></div>
                </div>
                <div class="row">               
                <div class="col-md-5"><h5>Billing Date</h5></div><div class="col-md-7"><h5>:&nbsp;&nbsp; <%=billdate %></h5></div>
                </div>
                <div class="row">               
                <div class="col-md-5"><h5>Billing Amount</h5></div><div class="col-md-7"><h5>:&nbsp;&nbsp; Rs.&nbsp;<%=billamt %></h5></div>
                </div>
                <div class="row">               
                <div class="col-md-5"><h5>Due Amount</h5></div><div class="col-md-7"><h5>:&nbsp;&nbsp; Rs.&nbsp;<%=dueamt %></h5></div>
                </div>
                </div>		                       
                <div class="col-md-8">
                <%
                if(billpayment[0]!=null){            	
                %>
                       <form onsubmit="return false;" name="follow-up-form">
                       <div class="marg-05 row">
                          <div class="pad05 col-md-6 col-sm-6 col-xs-6">
                            <div class="clearfix form-group mtop10">
                            <div class="clearfix relative_box">
                            <select id="PayOption" name="payoption" class="form-control" onchange="payOption(this.value)">
                               <%if(billpayment[4]!=null&&billpayment[4]!=""){ %>
                               <option value="<%=billpayment[4]%>"><%=billpayment[4] %></option><%} %>
                               <option value="">Select Payment Method</option>
                               <option value="Online">Online</option>
                               <option value="Cash">Cash</option>
							</select>
                            </div>
                            </div>
                            </div>
                            <div class="pad05 col-md-6 col-sm-6 col-xs-6">
                            <div class="clearfix form-group mtop10">
                            <div class="clearfix relative_box">
                            <input type="text" id="PmtDate" autocomplete="off" <%if(billpayment[2]!=null&&billpayment[2]!=""){ %>value="<%=billpayment[2] %>"<%} %> name="pmdate"  class="form-control readonlyAllow datepicker" placeholder="Select Payment Date !" readonly/>
                            </div>
                            </div>
                            </div>
                         </div>
                         <div class="marg-05 row">
                          <div class="pad05 col-md-6 col-sm-6 col-xs-6">
                            <div class="clearfix form-group mtop10">
                            <div class="clearfix relative_box">
                            <input type="text" id="TransId" autocomplete="off"<%if(billpayment[5]!=null&&billpayment[5]!=""){ %>value="<%=billpayment[5] %>"<%} %> name="transid"  class="form-control" placeholder="Enter Transaction Id here !"/>
                            </div>
                            </div>
                            </div>
                            <div class="pad05 col-md-6 col-sm-6 col-xs-6">
                            <div class="clearfix form-group mtop10">
                            <div class="clearfix relative_box">
                            <input type="text" id="TransAmount" onblur="validAmount(this.value)" autocomplete="off"<%if(billpayment[3]!=null&&billpayment[3]!=""){ %>value="<%=billpayment[3] %>"<%} %> name="transamount" class="form-control" placeholder="Enter Transaction Amount here !"/>
                            </div>
                            </div>
                            </div>
                         </div> 
                         <div class="row">
                           <div class="clearfix item-product-info form-group col-md-4">
                                  <button class="form-control" type="submit" onclick="return frauidPayment('<%=billpayment[0] %>','<%=billtype %>');" style="background: red;color: #ffff;font-size: 17px;">Fraud Payment</button>
                            </div>
                            <div class="clearfix item-product-info form-group col-md-4">
                                  <button class="form-control" type="submit" onclick="parent.$.fancybox.close();" style="background: limegreen;color: #ffff;font-size: 17px;">Cancel</button>
                            </div>
                            <div class="clearfix item-product-info form-group col-md-4">
                                  <button class="form-control" type="submit" onclick="return payAmount('<%=billpayment[0] %>','<%=billtype %>');" style="background: limegreen;color: #ffff;font-size: 17px;">Confirm Payment</button>
                            </div>
                        </div>
                     </form>
                     <%}else{%>
                     <div class="text-center" style="color: red;margin-top: 60px;"><h3>Not Received Any Payment !</h3></div>
                     <%} %>
                     </div>
                   </div>
            </div>
        </div>
    </div>
</div>
<div class="alert-show"><div class="alert-bg alert-striped" id="errorMsg" style="width: 30%;"></div></div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
function validAmount(amt){
var dueamt="<%=dueamt %>";
	if(Number(amt)>Number(dueamt)){
		document.getElementById('errorMsg').innerHTML = 'Max Amount Will Be Equal To Due Amount.';
		document.getElementById("TransAmount").value="";
		$('.alert-show').show().delay(3000).fadeOut();
	}
}

$(document).ready(function(){
	setTimeout(function(){
		if(document.getElementById("PayOption").value=="Cash"){
			$('#TransId').attr('readonly',true);
		}
	},100);	
});
function frauidPayment(val,type){
	var brefid="<%=billrefid%>";
	$.ajax({
		type: "GET",
		dataType: "html",
		url: "<%=request.getContextPath()%>/FraudTransaction111",
		data:  {
			val : val,
			type : type,
			brefid : brefid
		},
		success: function (data) {
		location.reload();
		},
		error: function (error) {
		alert("error in frauidPayment() " + error.responseText);
		}
		});
}

function payAmount(pymtrefid,tablefrom){
	if(document.getElementById("PayOption").value.trim()==""){
		document.getElementById('errorMsg').innerHTML = 'Select Payment method.';
		$('.alert-show').show().delay(1500).fadeOut();
		return false;
	}
	if(document.getElementById("PmtDate").value.trim()==""){
		document.getElementById('errorMsg').innerHTML = 'Select Payment Date.';
		$('.alert-show').show().delay(1500).fadeOut();
		return false;
	}
	if(document.getElementById("PayOption").value.trim()=="Online"){
	if(document.getElementById("TransId").value.trim()==""){
		document.getElementById('errorMsg').innerHTML = 'Enter transaction Id.';
		$('.alert-show').show().delay(1500).fadeOut();
		return false;
	}
	}
	if(document.getElementById("TransAmount").value.trim()==""){
		document.getElementById('errorMsg').innerHTML = 'Enter Transaction Amount.';
		$('.alert-show').show().delay(1500).fadeOut();
		return false;
	}
	var payoption=document.getElementById("PayOption").value.trim();
	var pdate=document.getElementById("PmtDate").value.trim();
	var transid=document.getElementById("TransId").value.trim();
	var transamt=document.getElementById("TransAmount").value.trim();
	var brefid="<%=billrefid%>";	
	
	$.ajax({
		type: "POST",
		dataType: "html",
		url: "<%=request.getContextPath()%>/ConfirmBillingPayment111",
		data:  {
			payoption : payoption,
			pdate : pdate,
			transid : transid,
			transamt : transamt,
			brefid : brefid,
			pymtrefid : pymtrefid,
			tablefrom : tablefrom
		},
		success: function (data) {
		location.reload();
		},
		error: function (error) {
		alert("error in payAmount() " + error.responseText);
		}
		});
	
}
</script>
<script type="text/javascript">
function payOption(val){
	if(val=="Cash"){
		document.getElementById("TransId").value="NA";
		$('#TransId').attr('readonly',true);
	}else{
		document.getElementById("TransId").value="";
		$("#TransId").removeAttr("readonly");
	}		
	}

</script>
</body>
</html>