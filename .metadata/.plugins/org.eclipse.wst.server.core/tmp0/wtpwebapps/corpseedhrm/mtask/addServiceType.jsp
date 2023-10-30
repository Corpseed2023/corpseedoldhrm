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
    
    <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="menuDv marg10">
                    <div class="box-intro">
                      <h2><span class="title">Add Product Type</span></h2>
                    </div>
                <div class="clearfix pad_box2">
                       <form onsubmit="return false;"  name="follow-up-form">                            
                            <div class="clearfix form-group mtop10">
                            <label>Product Type :<span style="color: red;">*</span></label>
                            <div class="clearfix relative_box">
                            <input type="text" id="Service_Type" autocomplete="off" name="service_type"  class="form-control" onblur="validateCompanyName('Service_Type','service_typeErr');isExist('Service_Type','service_typeErr');" placeholder="Product Type Name here !"/>
                            <div id="service_typeErr" class="popup_error"></div>
                            </div>
                            </div>                           
                            <div class="clearfix item-product-info form-group">
                                  <button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateProduct();">Submit</button>
                            </div>
                         
                            <div class="menuDv clearfix mb10  footer-bottom2">
                            <div class="row">
                           <div class="col-md-12 col-sm-12 col-xs-12">
                           <div class="clearfix ">
                           <div class="col-xs-1 box-intro-bg">
                            <div class="box-intro-border">
                            <p class="news-border">SN</p>
                            </div>
                           </div>
                           <div class="col-xs-9 box-intro-bg">
                            <div class="box-intro-border">
                            <p class="news-border">Product Type's Name</p>
                            </div>
                           </div>
                           <div class="col-xs-2 box-intro-bg ">
                            <div class="box-intro-border">
                            <p class="">Action</p>
                            </div>
                           </div>
                           </div>
                           </div>
                           </div>
                              <%
                            String token = (String) session.getAttribute("uavalidtokenno");
                            String[][] servicetype=TaskMaster_ACT.getAllServiceType(token);
                            for(int i=0;i<servicetype.length;i++){
                            %>
                          <div class="row">
                          <div class="col-md-12 col-sm-12 col-xs-12">
                          <div class="clearfix">
                          <div class="col-xs-1 box-intro-background">
                            <div class="link-style12">
                            <p class="news-border" title=""><%=servicetype.length-i %></p>
                            </div>
                          </div>  
                          <div class="col-xs-9 box-intro-background">
                            <div class="link-style12">
                            <p class="news-border" title="<%=servicetype[i][1]%>"><%=servicetype[i][1]%></p>
                            </div>
                          </div> 
                          <div class="col-xs-2 box-intro-background">
                            <div class="link-style12">
                            <p class="" title=""><a href="" onclick="deleteServiceType(<%=servicetype[i][0]%>)"><i class="fa fa-trash" title="delete"></i></a></p>
                            </div>
                          </div> 
                          </div>
                           </div>
                           </div>
                           <%} %>
                           </div>
                            
                     </form>
                   </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
	function deleteServiceType(id){
		var xhttp;
		xhttp = new XMLHttpRequest();
		xhttp.onreadystatechange = function() {
		if (this.readyState == 4 && this.status == 200) {
		location.reload();
		}
		};
		xhttp.open("GET", "<%=request.getContextPath()%>/DeleteServiceType111?info="+id, true);
		xhttp.send();
	}

	function validateProduct() {		
	if(document.getElementById("Service_Type").value.trim()=="" ) {
		service_typeErr.innerHTML="Service Type is required.";
		service_typeErr.style.color="red";
	return false;
	}else
		service_typeErr.innerHTML="";
	
	var stype=document.getElementById("Service_Type").value.trim();	
	
	$.ajax({
		type: "POST",
		dataType: "html",
		url: "SaveServiceType111",
		data:  {
			stype: stype,				
		},
		success: function (data) {
		location.reload();
		},
		error: function (error) {
		alert("error in addServiceType() " + error.responseText);
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
			"field":"servicetype",
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