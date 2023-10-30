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
<div class="wrap clearfix">
<%
String token=(String)session.getAttribute("uavalidtokenno");
String url = request.getParameter("uid");
String[] a=url.split(".html");
String[] b=a[0].split("-");
String id=b[1];
String product[]=TaskMaster_ACT.getProduct(id,token);
%>
<div class="col-md-12 col-sm-12 col-xs-12">
    <div class="row advert">
        <div class="col-md-12 col-sm-12 col-xs-12 mb10">
            <div class="menuDv partner-slider8">
                <div class="box-intro">
                  <h2><span class="title">Set Price</span></h2>
                </div>
                <div class="row">
                  <div class="col-md-12 col-sm-12 col-xs-12">
                   <div class="clearfix">
                    <div class="box-width15 col-xs-1 box-intro-bg">
                        <div class="box-intro-border">
                        <p class="news-border">Product's Name</p>
                        </div>
                    </div>
                    <div class="box-width72 col-xs-1 box-intro-bg">
                        <div class="box-intro-border">
                        <p class="news-border">Description</p>
                        </div>
                    </div>
                    
                   </div>
                  </div>
                 </div>
                <div class="row">
                  <div class="col-md-12 col-sm-12 col-xs-12">
                   <div class="clearfix">
                    <div class="box-width15 col-xs-1 box-intro-background">
                        <div class="link-style12">
                        <p class="news-border"><%=product[0] %></p>
                        </div>
                    </div>
                    <div class="box-width72 col-xs-1 box-intro-background">
                        <div class="link-style12">
                        <p class="news-border"><%=product[1] %></p>
                        </div>
                    </div>                    
                   </div>
                  </div>
                  </div>
            </div>
        </div>
    </div>
    <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12 mb10">
                <div class="menuDv partner-slider8">
                    <div class="box-intro">
                      <h2><span class="title">Add Price</span></h2>
                    </div>
                    <div class="row">
                      <div class="col-md-12 col-sm-12 col-xs-12">
                       <form method="post" onsubmit="return false;" name="follow-up-form">                   
                       <div class="clearfix box-intro-border">                        
                         <div class="box-width6 col-xs-1 box-intro-background">
                            <div class="add-enquery news-border">
                            <input type="text" id="Price Type" autocomplete="off" title="Price Type here !" name="price_type" onblur="validateLocation('Price Type','pricetypeErr')" placeholder="Price Type here !" class="text-center"/>
                            <div id="pricetypeErr" class="errormsg"></div>
                            </div>
                        </div>
                        <div class="box-width22 col-xs-1 box-intro-background">
                            <div class="add-enquery news-border">
                             <input type="text" id="Price" autocomplete="off" name="price"  title="Price here !" onblur="calculateAmount();" placeholder="Price here !" class="text-center" onkeypress="return isNumberKey(event)"/>
                             <div id="priceErr" class="errormsg"></div>
                            </div>
                        </div>
                        <div class="box-width5 col-xs-1 box-intro-background" style="display: none;">
                            <div class="add-enquery news-border">
                            <select name="Service_type" id="Service_Type" onchange="serviceType(this.value);document.getElementById('Term_Status').value='';document.getElementById('Term Time').value='';">
                              <option value="">Service Type</option>
                              <option value="One Time">One Time</option>
                              <option value="Renewal">Renewal</option>                              
                             </select>
                            <div id="Service_typeErr" class="errormsg"></div>
                            </div>
                        </div>
                        <div class="box-width5 col-xs-6 box-intro-background" id="TermId" style="display: none;">
                            <div class="add-enquery news-border">
                            <select name="term_status" id="Term_Status">
                              <option value="">Term</option>
                              <option value="Monthly">Monthly</option>
                              <option value="Yearly">Yearly</option>                              
                             </select>
                            <div id="term_statusErr" class="errormsg"></div>
                            </div>
                        </div>
                        <div class="box-width22 col-xs-1 box-intro-background" id="TermTimeId" style="display: none;">
                            <div class="add-enquery news-border">
                             <input type="text" id="Term Time" autocomplete="off" title="Renewal Time here !" name="term_time" placeholder="Time here !" class="text-center" onkeypress="return isNumber(event)"/>
                             <div id="term_timeErr" class="errormsg"></div>
                            </div>
                        </div>
                        <div class="box-width14 col-xs-6 box-intro-background">
							<div class="add-enquery news-border"> 
                             <select name="gst_status" class="gst_multiple" id="GST_Status" multiple="multiple" onkeypress="GstType(this.value);document.getElementById('Gst_Percent').value='';document.getElementById('Gst_Price').value='';">
                              <option>18% GST</option>
							  <option>20% GST</option> 							  
                             </select>
							 <div id="gst_statusErr" class="errormsg"></div>
                            </div>
                        </div>
                        <div class="box-width22 col-xs-1 box-intro-background"  id="GstPercentId" style="display: none;">
                            <div class="add-enquery news-border">
                             <input type="text" id="Gst_Percent"  autocomplete="off" title="GST Percent here !" name="gst_percent" onblur="calculateGST();" placeholder="Gst % here !" class="text-center" onkeypress="return isNumber(event)"/>
                             <div id="gst_percentErr" class="errormsg"></div>
                            </div>
                        </div>
                        <div class="box-width22 col-xs-1 box-intro-background"  id="GstAmountId" style="display: none;">
                            <div class="add-enquery news-border">
                             <input type="text" id="Gst_Price" autocomplete="off" title="GST Price here !" name="gst_price" placeholder="Gst Rs. here !" class="text-center" readonly="readonly"/>
                             <div id="gst_priceErr" class="errormsg"></div>
                            </div>
                        </div>                        
                        <div class="box-width5 col-xs-1 box-intro-background">
                            <div class="add-enquery news-border">
                             <input type="text" id="Total_Price" autocomplete="off" title="Total Price here !" name="total_price" placeholder="Total Price here !" class="text-center" readonly="readonly"/>
                             <div id="total_priceErr" class="errormsg"></div>
                            </div>
                        </div>
                        <div class="box-width21 col-xs-2 box-intro-background">
                            <div class="add-enquery">
                            <!-- <a href="javascript:void(0);" onclick="return statusValidations();">Add</a> -->
                            <button class="btn-link-default bt-radius" type="submit" onclick="return setPrice();">Add</button>
                            </div>
                        </div>
                     </div>
                     </form>
                   </div>
                </div>
                     
                  <div class="row footer-bottom2">
                      <div class="col-md-12 col-sm-12 col-xs-12">
                       <div class="clearfix ">
                       <div class="box-width24 col-xs-1 box-intro-bg">
                            <div class="box-intro-border">
                            <p class="news-border">SN</p>
                            </div>
                        </div>
                        <div class="box-width15 col-xs-1 box-intro-bg">
                            <div class="box-intro-border">
                            <p class="news-border">Price Type</p>
                            </div>
                        </div>
                        <div class="box-width9 col-xs-1 box-intro-bg">
                            <div class="box-intro-border">
                            <p class="news-border">Price</p>
                            </div>
                        </div>
						<!--
                        <div class="box-width5 col-xs-1 box-intro-bg">
                            <div class="box-intro-border">
                            <p class="news-border">Service Type</p>
                            </div>
                        </div>
                        <div class="box-width5 col-xs-6 box-intro-bg">
                            <div class="box-intro-border">
                            <p class="news-border">Renewal</p>
                            </div>
                        </div>
						-->
                         <div class="box-width9 col-xs-6 box-intro-bg">
                            <div class="box-intro-border">
                            <p class="news-border">GST</p>
                            </div>
                        </div>
                         <div class="box-width9 col-xs-6 box-intro-bg">
                            <div class="box-intro-border">
                            <p class="news-border">GST Amount</p>
                            </div>
                        </div>
                        <div class="box-width9 col-xs-6 box-intro-bg">
                            <div class="box-intro-border">
                            <p class="news-border">Total Amount</p>
                            </div>
                        </div>
                        <div class="box-width22 col-xs-2 box-intro-bg">
                            <div class="box-intro-border">
                            <p class="">Action</p>
                            </div>
                        </div>
                       </div>
                      </div>
                     </div>
                   <div id="ref">
                   <%
                   String[][] productPrice=TaskMaster_ACT.getProductPrice(id);
                   if(productPrice.length>0){
                	   for(int i=0;i<productPrice.length;i++){                  
                   %>
                    <div class="row">
                      <div class="col-md-12 col-sm-12 col-xs-12">
                       <div class="clearfix">
                       <div class="box-width24 col-xs-1 box-intro-background">
                            <div class="link-style12">
                            <p class="news-border"><%=productPrice.length-i %></p>
                            </div>
                        </div>
                        <div class="box-width15 col-xs-1 box-intro-background">
                            <div class="link-style12">
                            <p class="news-border" title="<%=productPrice[i][1] %>"><%=productPrice[i][1] %></p>
                            </div>
                        </div>
                        <div class="box-width9 col-xs-1 box-intro-background">
                            <div class="link-style12">
                            <p class="news-border"><i class="fa fa-inr"></i> <%=productPrice[i][2] %></p>
                            </div>
                        </div>
						<!--
                        <div class="box-width5 col-xs-1 box-intro-background">
                            <div class="link-style12">
                            <p class="news-border"><%=productPrice[i][3] %></p>
                            </div>
                        </div>
                        <div class="box-width5 col-xs-6 box-intro-background">
                            <div class="link-style12">
                            <p class="news-border"><%=productPrice[i][4] %><%if(!productPrice[i][4].equalsIgnoreCase("NA")&&productPrice[i][4]!="") {%>(<%=productPrice[i][5] %>)<%} %></p>
                            </div>
                        </div>
						--> 
                        <div class="box-width9 col-xs-6 box-intro-background">
                            <div class="link-style12">
                            <p class="news-border" title=""><%=productPrice[i][6] %><%if(!productPrice[i][6].equalsIgnoreCase("NA")&&!productPrice[i][6].equalsIgnoreCase("Not Applicable")) {%>  <%=productPrice[i][7] %>%<%} %></p>
                            </div>
                        </div>
                        <div class="box-width9 col-xs-6 box-intro-background">
                            <div class="link-style12">
                            <p class="news-border"><%if(!productPrice[i][8].equalsIgnoreCase("NA")){ %><i class="fa fa-inr"></i><%} %> <%=productPrice[i][8] %></p>
                            </div>
                        </div>
                        <div class="box-width9 col-xs-6 box-intro-background">
                            <div class="link-style12">
                            <p class="news-border"><i class="fa fa-inr"></i> <%=productPrice[i][9] %></p>
                            </div>
                        </div>                        
                        <div class="box-width22 col-xs-2 box-intro-background">
                            <div class="link-style12">
                            <p class="text-center"><a  href="" onclick="deletePrice('<%=productPrice[i][0] %>');"><i class="fa fa-trash" title="Delete this price type."></i></a></p>
                            </div>
                        </div>
                     </div>
                   </div>
                </div>
                <%}} %>
                 </div>
            </div>
        </div>
    </div>
</div>
</div>

<section id="addNewPopup" class="addNewPopup" style="display: none"> 
<div class="clearfix pad_box4">
<form method="post">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group">
<label>Tax</label>
<div class="input-group">
<input type="text" name="" id="" placeholder="Tax" class="form-control">
</div>
</div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group">
<label>Type of tax</label>
<div class="input-group">
<input type="text" name="" id="" placeholder="Type of tax" class="form-control">
</div>
</div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group">
<label>Tax % to be deducted</label>
<div class="input-group">
<input type="text" name="" id="" placeholder="Tax % to be deducted" class="form-control">
</div>
</div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="form-group">
<label>Additional description</label>
<div class="input-group">
 <textarea class="form-control" rows="3" name="expensenote" id="ExpenseNote" placeholder="Additional description" onblur="validateLocationPopup('UpdateAddress');validateValuePopup('UpdateAddress');"></textarea>
</div>
</div>
</div>
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix mtop10 mb10 text-center"> 
<button class="bt-link bt-radius bt-loadmore" type="submit" onclick="">Add</button>
</div>
</div>
</div>
</form>
</div>
</section> 

<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
$('.gst_multiple').select2({
	placeholder: 'GST if applicable', 
	tags: true,
})
.on('select2:open', function () {
    var a = $(this).data('select2');
    if (!$('.select2-link').length) {
        a.$results.parents('.select2-results')
        .append('<div class="select2-link"><a><svg viewBox="0 0 20 20" id="add" xmlns="http://www.w3.org/2000/svg"><path d="M10 19a9 9 0 1 1 0-18 9 9 0 0 1 0 18zm1-10V5.833c0-.46-.448-.833-1-.833s-1 .373-1 .833V9H5.833C5.373 9 5 9.448 5 10s.373 1 .833 1H9v3.167c0 .46.448.833 1 .833s1-.373 1-.833V11h3.167c.46 0 .833-.448.833-1s-.373-1-.833-1H11zm-1 8c4.067 0 7-2.933 7-7s-2.933-7-7-7-7 2.933-7 7 2.933 7 7 7z"></path></svg> Add New</a></div>')
        .on('click', function (b) {
           a.trigger('close');
           //add your code
		   $.fancybox({
            'href' : '#addNewPopup', 
            'autoScale': true,
			'autoDimensions': true,
            'centerOnScroll': true			
			});	    
        }); 
    }
});
</script>
<script type="text/javascript">
function serviceType(val){
	if(val=="Renewal"){
		$("#TermId").slideDown();
		$("#TermTimeId").slideDown();
	}else if(val=="One Time"){
		$("#TermId").slideUp();
		$("#TermTimeId").slideUp();
	}
}    
function GstType(val){
	if(val=="Not Applicable"){
		$("#GstPercentId").slideUp();
		$("#GstAmountId").slideUp();
	}else if(val=="Included" || val=="Excluded"){
		$("#GstPercentId").slideDown();
		$("#GstAmountId").slideDown();		
	}
}   
function calculateAmount(){
	document.getElementById("GST_Status").value="";
	document.getElementById("Gst_Percent").value="";
	document.getElementById("Gst_Price").value="";
	var price=document.getElementById("Price").value.trim();
	document.getElementById("Total_Price").value=price;
}
function calculateGST(){
	var gst_status=document.getElementById("GST_Status").value; 
	var gst=document.getElementById("Gst_Percent").value; 
	if(gst_status=="Included" || gst_status=="Excluded"  ){		
		var price=document.getElementById("Price").value.trim();
		if(gst_status=="Included"){
			var x=(Number(price)*Number(gst))/(100+Number(gst));
			document.getElementById("Gst_Price").value=Math.round(x);
			document.getElementById("Total_Price").value=price;
		}else{
			var x=(Number(price)*Number(gst))/100;
			document.getElementById("Gst_Price").value=Math.round(x);			
			document.getElementById("Total_Price").value=Math.round((Number(x)+Number(price)));
		}
		
	}
}
function setPrice() {
		if(document.getElementById("Price Type").value.trim()==""){
			pricetypeErr.innerHTML="Price Type is required.";
			pricetypeErr.style.color="red";
			return false;
		}
		if(document.getElementById("Price").value.trim()==""){
			priceErr.innerHTML="Required.";
			priceErr.style.color="red";
			return false;
		}else priceErr.innerHTML="";
		if(document.getElementById("Service_Type").value.trim()==""){
			Service_typeErr.innerHTML="Required.";
			Service_typeErr.style.color="red";
			return false;
		}else Service_typeErr.innerHTML="";		
		
		if(document.getElementById("Service_Type").value.trim()=="Renewal"){
			if(document.getElementById("Term_Status").value.trim()==""){
				term_statusErr.innerHTML="Required.";
				term_statusErr.style.color="red";
				return false;
			}else term_statusErr.innerHTML="";
			if(document.getElementById("Term Time").value.trim()==""){
				term_timeErr.innerHTML="Required..";
				term_timeErr.style.color="red";
				return false;
			}else term_timeErr.innerHTML="";		
		}
		if(document.getElementById("GST_Status").value.trim()==""){
			gst_statusErr.innerHTML="Required..";
			gst_statusErr.style.color="red";
			return false;
		}else gst_statusErr.innerHTML="";	
		
		if(document.getElementById("GST_Status").value.trim()=="Included" || document.getElementById("GST_Status").value.trim()=="Excluded"){
			if(document.getElementById("Gst_Percent").value.trim()==""){
				gst_percentErr.innerHTML="Required..";
				gst_percentErr.style.color="red";
				return false;
			}else gst_percentErr.innerHTML="";
			if(document.getElementById("Gst_Price").value.trim()==""){
				gst_priceErr.innerHTML="Required..";
				gst_priceErr.style.color="red";
				return false;
			}else gst_priceErr.innerHTML="";		
		}
		if(document.getElementById("Total_Price").value.trim()==""){
			total_priceErr.innerHTML="Required..";
			total_priceErr.style.color="red";
			return false;
		}else total_priceErr.innerHTML="";
		
		var Term_Status="";
		var Term_Time="";
		var Gst_Percent="";
		var Gst_Price="";
		
		if(document.getElementById("Service_Type").value.trim()=="One Time"){
			Term_Status="NA";
			Term_Time="NA";
		}else{
			Term_Status=document.getElementById("Term_Status").value.trim();
			Term_Time=document.getElementById("Term Time").value.trim();
		}
		if(document.getElementById("GST_Status").value.trim()=="Not Applicable"){
			Gst_Percent="NA";
			Gst_Price="NA";
		}else{
			Gst_Percent=document.getElementById("Gst_Percent").value.trim();
			Gst_Price=document.getElementById("Gst_Price").value.trim();
		}
		
		
		var price_type=document.getElementById("Price Type").value.trim();
		var Price=document.getElementById("Price").value.trim();
		var Service_Type=document.getElementById("Service_Type").value.trim();		
		var GST_Status=document.getElementById("GST_Status").value.trim();		
		var Total_Price=document.getElementById("Total_Price").value.trim();
		var pid="<%=id%>";
	
	$.ajax({
		type: "POST",
		dataType: "html",
		url: "<%=request.getContextPath()%>/AddProductPrice111",
		data:  {
			price_type: price_type,
			Price: Price,
			Service_Type: Service_Type,
			Term_Status: Term_Status,
			Term_Time: Term_Time,
			GST_Status: GST_Status,
			Gst_Percent: Gst_Percent,
			Gst_Price: Gst_Price,
			Total_Price: Total_Price,
			pid:pid,
		},
		success: function (data) {
		location.reload();
		},
		error: function (error) {
		alert("error in setPrice() " + error.responseText);
		}
		});
}
	function deletePrice(id) {
		var attribute="ppid";
		var table="product_price";
		var attributetoken="pp_tokenno";
    	var xhttp; 
    	xhttp = new XMLHttpRequest();
    	xhttp.onreadystatechange = function() {
    	if (this.readyState == 4 && this.status == 200) {
		location.reload();
    	}
    	};
    	xhttp.open("GET", "<%=request.getContextPath()%>/DeleteProductPrice111?id="+id+"&attribute="+attribute+"&table="+table+"&attributetoken="+attributetoken, true);
    	xhttp.send();   
    }
</script>

</body>
</html>