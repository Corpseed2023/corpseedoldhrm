<%@page import="admin.task.TaskMaster_ACT"%>
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
   String token=(String)session.getAttribute("uavalidtokenno");
   String url = request.getParameter("uid");
   String[] a=url.split(".html");
   String[] b=a[0].split("-");
   String id=b[1];
   String[] product=TaskMaster_ACT.getProduct(id,token);
   %> 
    <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="menuDv marg10">
                    <div class="box-intro">
                      <h2><span class="title">View Product</span></h2>
                    </div>
                <div class="clearfix pad_box2">
                       <form onsubmit="return false;"  name="follow-up-form">
                       	<div class="marg-05 row">
                       		 <div class="pad05 col-md-6 col-sm-6 col-xs-6">
                            <div class="clearfix form-group mtop10">
                            <label>Product's Type :<span style="color: red;">*</span></label>
                            <div class="clearfix relative_box">
                            <select id="Product_Type" name="productType" class="form-control" disabled="disabled"  title="<%=product[2] %>">
                                      <option value="<%=product[2] %>"><%=product[2] %></option>                                     
							</select>
                            </div>
                            </div>
                            </div>
                            <div class="pad05 col-md-6 col-sm-6 col-xs-6">
                            <div class="clearfix form-group mtop10">
                            <label>Product's Name :<span style="color: red;">*</span></label>
                            <div class="clearfix relative_box">
                            <input type="text" id="Product_Name" readonly="readonly" autocomplete="off" name="product_name" value="<%=product[0] %>" title="<%=product[0] %>" class="form-control" placeholder="Product's Name here !"/>
                            <div id="product_nameErr" class="popup_error"></div>
                            </div>
                            </div>
                            </div>
                            </div>
                            <div class="clearfix form-group">
                            <label>Remarks :<span style="color: red;">*</span></label>
                            <div class="clearfix relative_box">
                            <textarea id="Remarks" name="remarks" readonly="readonly" rows="5" autocomplete="off"  class="form-control" placeholder="Product's description here !"><%=product[1] %></textarea>
                            <div id="remarksErr" class="popup_error"></div>
                            </div>
                            </div>                            
                     </form>
                   </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../staticresources/includes/itswsscripts.jsp" %>


</body>
</html>