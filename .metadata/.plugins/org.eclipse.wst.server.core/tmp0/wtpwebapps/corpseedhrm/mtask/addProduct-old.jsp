<%@page import="admin.task.TaskMaster_ACT"%>
<%@ include file="../../madministrator/checkvalid_user.jsp" %>
<%@page import="admin.enquiry.Enquiry_ACT"%>

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
   String[][] servicetype=TaskMaster_ACT.getAllServiceType(token); %>
    <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="menuDv marg10">
                    <div class="box-intro">
                      <h2><span class="title">Add Product</span></h2>
                    </div>
                <div class="clearfix pad_box2">
                       <form onsubmit="return false;"  name="follow-up-form">
                       <div class="marg-05 row">
                          <div class="pad05 col-md-6 col-sm-6 col-xs-6">
                            <div class="clearfix form-group mtop10">
                            <label>Product's Type :<span style="color: red;">*</span></label>
                            <div class="clearfix relative_box">
                            <select id="Product_Type" name="productType" class="form-control">
                                      <option value="">Select Product Type</option>
                                      <%for(int i=0;i<servicetype.length;i++){ %>
                                      <option value="<%=servicetype[i][1]%>"><%=servicetype[i][1]%></option>
                                      <%} %>
								 </select>                            
                            <div id="productTypeErr" class="popup_error"></div>
                            </div>
                            </div>
                            </div>
                            <div class="pad05 col-md-6 col-sm-6 col-xs-6">
                            <div class="clearfix form-group mtop10">
                            <label>Product's Name :<span style="color: red;">*</span></label>
                            <div class="clearfix relative_box">
                            <input type="text" id="Product_Name" autocomplete="off" name="product_name"  class="form-control" onblur="validateCompanyName('Product_Name','product_nameErr');isExist('Product_Name','product_nameErr');" placeholder="Product's Name here !"/>
                            <div id="product_nameErr" class="popup_error"></div>
                            </div>
                            </div>
                            </div>
                            </div>
                            <div class="clearfix form-group">
                            <label>Remarks :<span style="color: red;">*</span></label>
                            <div class="clearfix relative_box">
                            <textarea id="Remarks" name="remarks" rows="5" autocomplete="off"  class="form-control" placeholder="Product's description here !"></textarea>
                            <div id="remarksErr" class="popup_error"></div>
                            </div>
                            </div>
                            <div class="clearfix item-product-info form-group">
                                  <button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateProduct();">Submit</button>
                            </div>
                     </form>
                   </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
	function validateProduct() {
		if(document.getElementById("Product_Type").value.trim()=="" ) {
			productTypeErr.innerHTML="Product's Type is required.";
			productTypeErr.style.color="red";
		return false;
		}else
			productTypeErr.innerHTML="";
		
	if(document.getElementById("Product_Name").value.trim()=="" ) {
		product_nameErr.innerHTML="Product Name is required.";
		product_nameErr.style.color="red";
	return false;
	}else
		product_nameErr.innerHTML="";
	
	if(document.getElementById("Remarks").value.trim()=="" ) {
		remarksErr.innerHTML="Date is required.";
		remarksErr.style.color="red";
	return false;
	}else
		remarksErr.innerHTML="";
	var ptype=document.getElementById("Product_Type").value.trim();
	var pname=document.getElementById("Product_Name").value.trim();
	var premarks=document.getElementById("Remarks").value.trim();
	
	$.ajax({
		type: "POST",
		dataType: "html",
		url: "<%=request.getContextPath()%>/add-ProductCTRL.html",
		data:  {
			ptype:ptype,
			pname: pname,
			premarks: premarks,			
		},
		success: function (data) {
		parent.location.reload();
		},
		error: function (error) {
		alert("error in addProduct() " + error.responseText);
		}
		});
}
</script>
<script type="text/javascript">
function isExist(value,err){
	var val=document.getElementById(value).value.trim();
	$.ajax({
		type : "POST",
		url : "ExistValue111",
		dataType : "HTML",
		data : {
			"val" : val,
			"field":"product",
		},
		success : function(data){
			if(data=="pass"){
			document.getElementById(err).innerHTML="'"+val +"'  already existed.";
			document.getElementById(err).style.color="red";
			document.getElementById(value).value="";
			}
			
		}
	});
}
</script>
</body>
</html>