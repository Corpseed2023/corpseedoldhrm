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
String project[]=TaskMaster_ACT.getEnqProject(id,token);
%>
<div class="col-md-12 col-sm-12 col-xs-12">
    <div class="row advert">
        <div class="col-md-12 col-sm-12 col-xs-12 mb10">
            <div class="menuDv partner-slider8">
                <div class="box-intro">
                  <h2><span class="title">Set Product's Price</span></h2>
                </div>
                <div class="row">
                  <div class="col-md-12 col-sm-12 col-xs-12">
                   <div class="clearfix">                   
                    <div class="box-width18 col-xs-1 box-intro-bg">
                        <div class="box-intro-border">
                        <p class="news-border">Product Type</p>
                        </div>
                    </div>
                    <div class="box-width15 col-xs-1 box-intro-bg">
                        <div class="box-intro-border">
                        <p class="news-border">Product's Name</p>
                        </div>
                    </div>
                    <div class="box-width52 col-xs-1 box-intro-bg">
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
                    <div class="box-width18 col-xs-1 box-intro-background">
                        <div class="link-style12">
                        <p class="news-border" title="<%=project[0] %>"><%=project[0] %></p>
                        </div>
                    </div>
                    <div class="box-width15 col-xs-1 box-intro-background">
                        <div class="link-style12">
                        <p class="news-border" title="<%=project[1] %>"><%=project[1] %></p>
                        </div>
                    </div>
                    <div class="box-width52 col-xs-1 box-intro-background">
                        <div class="link-style12">
                        <p class="news-border" title="<%=project[2] %>"><%=project[2] %></p>
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
                      <h2><span class="title">Add Product's Price Details</span></h2>
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
                        <div class="box-width5 col-xs-1 box-intro-background">
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
                        <div class="box-width5 col-xs-6 box-intro-background">
                            <div class="add-enquery news-border">
                            <select name="gst_status" id="GST_Status" onchange="GstType(this.value);document.getElementById('Gst_Percent').value='';document.getElementById('Gst_Price').value='';">
                              <option value="">GST</option>
                              <option value="Included">Included</option>
                              <option value="Excluded">Excluded</option> 
                              <option value="Not Applicable">Not Applicable</option>                             
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
                        <div class="box-width2 col-xs-1 box-intro-background">
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
                        <div class="box-width5 col-xs-1 box-intro-bg">
                            <div class="box-intro-border">
                            <p class="news-border">Price</p>
                            </div>
                        </div>
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
                         <div class="box-width5 col-xs-6 box-intro-bg">
                            <div class="box-intro-border">
                            <p class="news-border">GST</p>
                            </div>
                        </div>
                         <div class="box-width5 col-xs-6 box-intro-bg">
                            <div class="box-intro-border">
                            <p class="news-border">GST Amount</p>
                            </div>
                        </div>
                        <div class="box-width16 col-xs-6 box-intro-bg">
                            <div class="box-intro-border">
                            <p class="news-border">Total Amount</p>
                            </div>
                        </div>
                        <div class="box-width21 col-xs-2 box-intro-bg">
                            <div class="box-intro-border">
                            <p class="">Action</p>
                            </div>
                        </div>
                       </div>
                      </div>
                     </div>
                   <div id="ref">
                   <%
                   String[][] projectPrice=TaskMaster_ACT.getEnqProductPrice(id);
                   if(projectPrice.length>0){
                	   for(int i=0;i<projectPrice.length;i++){                  
                   %>
                    <div class="row">
                      <div class="col-md-12 col-sm-12 col-xs-12">
                       <div class="clearfix">
                       <div class="box-width24 col-xs-1 box-intro-background">
                            <div class="link-style12">
                            <p class="news-border" title="<%=projectPrice.length-i %>"><%=projectPrice.length-i %></p>
                            </div>
                        </div>
                        <div class="box-width15 col-xs-1 box-intro-background">
                            <div class="link-style12">
                            <p class="news-border" title="<%=projectPrice[i][1] %>"><%=projectPrice[i][1] %></p>
                            </div>
                        </div>
                        <div class="box-width5 col-xs-1 box-intro-background">
                            <div class="link-style12">
                            <p class="news-border" title="<%=projectPrice[i][2] %>"><i class="fa fa-inr"></i> <%=projectPrice[i][2] %></p>
                            </div>
                        </div>
                        <div class="box-width5 col-xs-1 box-intro-background">
                            <div class="link-style12">
                            <p class="news-border" title="<%=projectPrice[i][3] %>"><%=projectPrice[i][3] %></p>
                            </div>
                        </div>
                        <div class="box-width5 col-xs-6 box-intro-background">
                            <div class="link-style12">
                            <p class="news-border"><%=projectPrice[i][4] %><%if(!projectPrice[i][4].equalsIgnoreCase("NA")&&projectPrice[i][4]!="") {%>(<%=projectPrice[i][5] %>)<%} %></p>
                            </div>
                        </div>
                        <div class="box-width5 col-xs-6 box-intro-background">
                            <div class="link-style12">
                            <p class="news-border" title=""><%=projectPrice[i][6] %><%if(!projectPrice[i][6].equalsIgnoreCase("NA")&&!projectPrice[i][6].equalsIgnoreCase("Not Applicable")) {%>  <%=projectPrice[i][7] %>%<%} %></p>
                            </div>
                        </div>
                        <div class="box-width5 col-xs-6 box-intro-background">
                            <div class="link-style12">
                            <p class="news-border"><%if(!projectPrice[i][8].equalsIgnoreCase("NA")){ %><i class="fa fa-inr"></i><%} %> <%=projectPrice[i][8] %></p>
                            </div>
                        </div>
                        <div class="box-width16 col-xs-6 box-intro-background">
                            <div class="link-style12">
                            <p class="news-border"><i class="fa fa-inr"></i> <%=projectPrice[i][9] %></p>
                            </div>
                        </div>                        
                        <div class="box-width21 col-xs-2 box-intro-background">
                            <div class="link-style12">
                            <p class="text-center"><a  href="" onclick="deletePrice('<%=projectPrice[i][0] %>')"><i class="fa fa-trash" title="Delete this price type."></i></a></p>
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

<%@ include file="../staticresources/includes/itswsscripts.jsp" %>

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
		url: "<%=request.getContextPath()%>/AddProjectPrice111",
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
			"Enq":"enquiry",
		},
		success: function (data) {
// 			$("#ref").load(location.href + " #ref");
			location.reload();
		},
		error: function (error) {
		alert("error in setPrice() " + error.responseText);
		}
		});
}
function deletePrice(id) {
	var attribute="id";
	var table="project_price";
	var attributetoken="tokenno";
	var Enqprice="enquiry";
	var xhttp; 
	xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
	if (this.readyState == 4 && this.status == 200) {
	location.reload();
	}
	};
	xhttp.open("GET", "<%=request.getContextPath()%>/DeleteProductPrice111?id="+id+"&attribute="+attribute+"&table="+table+"&attributetoken="+attributetoken+"&Enqprice="+Enqprice, true);
	xhttp.send();   
}
</script>

</body>
</html>