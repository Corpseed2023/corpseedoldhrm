<%@page import="admin.enquiry.Enquiry_ACT"%>
<%@page import="commons.DateUtil"%>
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
   <% 
   String today=DateUtil.getCurrentDateIndianFormat1();
   String token = (String) session.getAttribute("uavalidtokenno");
   String sref=request.getParameter("sref");
   String name=request.getParameter("name");
   String[][] payment=Enquiry_ACT.getRelatedTransaction(sref);
   %>
   
    <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="menuDv marg10">
                    <div class="box-intro">
                      <h2><span class="title">Add Payment Details of <span style="color:red;"><%=name %></span></span></h2>
                    </div>
                <div class="row pad_box2">
                <div class="col-md-7">
                <div class="row">
				<div class="col-md-12 col-sm-12 col-xs-12">
				<div class="clearfix">
				<div class="box-width9 col-xs-1 box-intro-bg">
				<div class="box-intro-border">
				<p class="news-border" title="Enquiry Date">Date</p>
				</div>
				</div>
				<div class="box-width3 col-xs-1 box-intro-bg">
				<div class="box-intro-border">
				<p class="news-border" title="Follow Up Date">Payment Mode</p>
				</div>
				</div>
				<div class="box-width19 col-xs-1 box-intro-bg">
				<div class="box-intro-border">
				<p class="news-border" title="Next Follow Up Date">Transaction Id</p>
				</div>
				</div>
				<div class="box-width10 col-xs-1 box-intro-bg">
				<div class="box-intro-border">
				<p class="news-border" title="Enquiry Type">Amount</p>
				</div>
				</div>
				<div class="box-width9 col-xs-1 box-intro-bg">
				<div class="box-intro-border">
				<p title="Action">Status</p>
				</div>
				</div>
				</div>
				</div>
				</div>
				<div class="scroll">
				<%if(payment!=null&&payment.length>0){
				for(int i=0;i<payment.length;i++){
					String color="red;";
					if(payment[i][4].equalsIgnoreCase("Approved"))color="#4ac4f3;";
				%>
				<div class="clearfix box_shadow2">
				<div class="box-width9 col-xs-1 box-intro-background">
				<div class="link-style12">
				<p class="news-border" title="<%=payment[i][0] %>" ><%=payment[i][0] %></p>
				</div>
				</div>
				<div class="box-width3 col-xs-1 box-intro-background">
				<div class="link-style12">
				<p class="news-border" title="<%=payment[i][1] %>"><%=payment[i][1] %></p>
				</div>
				</div>
				<div class="box-width19 col-xs-1 box-intro-background">
				<div class="link-style12">
				<p class="news-border" title="<%=payment[i][2] %>"><%=payment[i][2] %></p>
				</div>
				</div>
				<div class="box-width10 col-xs-1 box-intro-background">
				<div class="link-style12">
				<p class="news-border" title="<%=payment[i][3] %>"><i class="fa fa-inr"></i>&nbsp;<%=payment[i][3] %></p>
				</div>
				</div>
				<div class="box-width9 col-xs-1 box-intro-background">
				<div class="link-style12">
				<p class="news-border" title="<%=payment[i][4] %>" style="color: <%=color%>"><%=payment[i][4] %></p>
				</div>
				</div>
				</div>				
				<%}}else{ %>
				<div class="col-xs-12 box-intro-background" style="text-align: center;margin-top: 73px;">
				<span style="color: red;text-align: center;">No Data Found !</span>
				</div>
				<%} %>
				</div>
                </div>                       
                <div class="col-md-5">
                
                       <form onsubmit="return false;" name="follow-up-form">
                       <div class="marg-05 row">
                          <div class="pad05 col-md-6 col-sm-6 col-xs-6">
                            <div class="clearfix form-group mtop10">
                            <div class="clearfix relative_box">
                            <select id="PayOption" name="payoption" class="form-control" onchange="payOption(this.value)">
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
                            <input type="text" id="PmtDate" value="<%=today %>" autocomplete="off" name="pmdate"  class="form-control readonlyAllow datepicker" placeholder="Select Payment Date !" readonly/>
                            </div>
                            </div>
                            </div>
                         </div>
                         <div class="marg-05 row">
                          <div class="pad05 col-md-6 col-sm-6 col-xs-6">
                            <div class="clearfix form-group mtop10">
                            <div class="clearfix relative_box">
                            <input type="text" id="TransId" autocomplete="off" name="transid"  class="form-control" placeholder="Enter Transaction Id here !"/>
                            </div>
                            </div>
                            </div>
                            <div class="pad05 col-md-6 col-sm-6 col-xs-6">
                            <div class="clearfix form-group mtop10">
                            <div class="clearfix relative_box">
                            <input type="text" id="TransAmount" autocomplete="off" name="transamount"  class="form-control" placeholder="Enter Transaction Amount here !"/>
                            </div>
                            </div>
                            </div>
                         </div> 
                            <div class="clearfix item-product-info form-group">
                                  <button class="form-control" type="submit" onclick="return payAmount();" style="background: limegreen;color: #ffff;font-size: 17px;">Submit</button>
                            </div>
                     </form>
                     
<!--                      <div class="text-center" style="color: red;margin-top: 60px;"><h3>No Due Payment !</h3></div> -->
                     
                     </div>
                   </div>
            </div>
        </div>
    </div>
</div>
<div class="alert-show"><div class="alert-bg alert-striped" id="errorMsg"></div></div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
function payAmount(){
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
	var sref="<%=sref%>";
	var rfrom="Admin";
	showLoader();
	$.ajax({
		type: "POST",
		dataType: "html",
		url: "<%=request.getContextPath()%>/addestimatepayment.html",
		data:  {
			payoption : payoption,
			pdate : pdate,
			transid : transid,
			transamt : transamt,
			sref : sref
		},
		success: function (data) {
		location.reload();
		},
		error: function (error) {
		alert("error in payAmount() " + error.responseText);
		},
		complete : function(data){
			hideLoader();
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