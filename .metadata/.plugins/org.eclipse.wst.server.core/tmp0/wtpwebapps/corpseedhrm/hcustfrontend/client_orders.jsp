<!doctype html>
<%@page import="commons.CommonHelper"%>
<%@page import="admin.task.TaskMaster_ACT"%>
<%@page import="java.util.Random"%>
<%@page import="admin.task.SalesHierarchyVirtual_CTRL"%>
<%@page import="client_master.Clientmaster_ACT"%>
<%@page import="hcustbackend.ClientACT"%>
<html lang="en">
<head>  
  <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<%@ include file="includes/client-header-css.jsp" %>
    <title>corpSeed-orders</title>
</head>
<body id="mySite" style="display: block">
<%@ include file="includes/checkvalid_client.jsp" %> 
<!-- main content starts -->
<%
//get token no from session
String token=(String)session.getAttribute("uavalidtokenno");
String loginuaid = (String) session.getAttribute("loginuaid");
// String userRole=(String)session.getAttribute("userRole");
// if(userRole==null||userRole.length()<=0)userRole="NA";
String doAction=(String)session.getAttribute("ClientOrderDoAction");
if(doAction==null||doAction.length()<=0)doAction="All";
String searchDoAction=(String)session.getAttribute("ClientOrderSearchDoAction");
if(searchDoAction==null||searchDoAction.length()<=0)searchDoAction="NA";
String searchFromToDate=(String)session.getAttribute("searchFromToDate");
if(searchFromToDate==null||searchFromToDate.length()<=0)searchFromToDate="NA";
String sortBy=(String)session.getAttribute("searchOrderSorting");
if(sortBy==null||sortBy.length()<=0)sortBy="desc";
//System.out.println("userRole="+userRole);
// get client no from session
/* String clientrefid=ClientACT.getClientRefId(uaempid,token);  

String client[][]=ClientACT.getClientByNo(clientrefid,token);*/

/* String clientfrom=(String)session.getAttribute("clientfrom");
String clientto=(String)session.getAttribute("clientto");
String include=(String)session.getAttribute("include");
String sortby=(String)session.getAttribute("sortby");	
String sprjno=(String)session.getAttribute("sprjno");
String sprjname=(String)session.getAttribute("sprjname");

// if(sprjno==null||sprjno=="")sprjno="NA";
if(sprjname==null||sprjname=="")sprjname="NA";
if(clientfrom==null||clientfrom=="")clientfrom="NA";
if(clientto==null||clientto=="")clientto="NA";
if(include==null||include=="")include="Yes";
if(sortby==null||sortby=="")sortby="NA"; */

long pageLimit=10;
String pageLimit1=(String)session.getAttribute("orderPageLimit");
if(pageLimit1!=null&&pageLimit1.length()>0)pageLimit=Long.parseLong(pageLimit1);


long pageStart=1;
String pageStart1=(String)session.getAttribute("orderPageStart");
if(pageStart1!=null&&pageStart1.length()>0)pageStart=Long.parseLong(pageStart1);

long pageEnd=10;
String pageEnd1=(String)session.getAttribute("orderPageEnd");
if(pageEnd1!=null&&pageEnd1.length()>0)pageEnd=Long.parseLong(pageEnd1);

long count=pageEnd/pageLimit;

Random randomGenerator = new Random();
long randomInt = randomGenerator.nextInt(100000000);
%>
<section class="main clearfix">
  <%@ include file="includes/client_header_menu.jsp" %>   
  
  <section class="main-order clearfix">
  <div class="container-fluid">
    <div class="container">
      <div class="row">
        <div class="col-12 p-0">
       
          <div class="shadow_none box_bg box-orders">
          <div class="clearfix document_page"> 
		  
		  <div class="row mbt12 sticky_top">
		  
		  <div class="col-lg-6 col-md-6 col-sm-12 col-12 order">
		  <ul class="clearfix filter_menu pointers">
			<li onclick="doAction('All','ClientOrderDoAction')" <%if(doAction.equalsIgnoreCase("All")){ %>class="active"<%} %>><a>All</a></li> 
			<li onclick="doAction('In Progress','ClientOrderDoAction')" <%if(doAction.equalsIgnoreCase("In Progress")){ %>class="active"<%} %>><a>In Progress</a></li>
			<li onclick="doAction('Completed','ClientOrderDoAction')" <%if(doAction.equalsIgnoreCase("Completed")){ %>class="active"<%} %>><a>Completed</a></li>  
		  </ul>
		  </div>
		  <div class="col-lg-6 col-md-6 col-sm-12 col-12">
          <div class="form-group-orders"> 
              <div class="m_width80 inbox_input" <%if(!searchDoAction.equalsIgnoreCase("NA")){ %>style="display: block;"<%} %>>
              <input class="form-control-search" id="SearchOrder" <%if(!searchDoAction.equalsIgnoreCase("NA")){ %>value="<%=searchDoAction%>"<%} %> type="search" onsearch="removeSearchOption('ClientOrderSearchDoAction')" placeholder="Search"> 
              <i class="fa fa-search" aria-hidden="true"></i>  			
			  </div>
			  <i class="fas fa-long-arrow-alt-left" id="backico" <%if(!searchDoAction.equalsIgnoreCase("NA")){ %>style="display: block;"<%} %>></i>			  
			  <div class="inbox-chatlist"> 
			  <button type="button" id="search" <%if(sortBy.equalsIgnoreCase("desc")){ %> onClick="doAction('asc','searchOrderSorting')"<%}else{ %>onClick="doAction('desc','searchOrderSorting')"<%} %>><i class="fa fa-list icon-circle" title="Sort By"></i></button> 
              <button class="calendar_box" type="button" title="Search by date"><i class="fa fa-calendar-times icon-circle"></i>
			  <input type="text" class="form-control" <%if(!searchFromToDate.equalsIgnoreCase("NA")){ %>value="<%=searchFromToDate %>"<%} %> name="date_range" id="date_range" readonly="readonly"/>
			  </button>
			  <%if(!searchFromToDate.equalsIgnoreCase("NA")){ %>
			  <button type="button" title="Clear date" style="position: absolute;right: -41px;" onclick="removeSearchOption('searchFromToDate')"><i class="fas fa-times icon-circle" aria-hidden="true"></i></button>
			  <%} %></div>
			  
		  </div> 
		  
		  	<a href="javascript:void(0)" class="mobilesearchico"> <i class="fa fa-search " aria-hidden="true"></i> </a>
			<div class="pageheading">
          <h2>Order</h2>
          </div>
			 
		  </div>
		  </div>
		  
<!-- 1st box starts -->
 <div class="row">
        <div class="col-sm-12 bg_whitee">
          <div class="row">
            <div class="col-12 page-max">
            <%
			String projects[][]=ClientACT.getAllProjectsById(loginuaid,token,doAction,searchDoAction,searchFromToDate,sortBy,pageLimit,pageStart,userRole);     
            if(projects!=null&&projects.length>0){
            	for(int i=0;i<projects.length;i++){
//             		int milestoneQty=ClientACT.getTotalMilestones(projects[i][0],token); 
//             		int milestoneWorkPercentage=ClientACT.getMilestonesWorkPercentage(projects[i][0],token);
//             		int workPercentage=milestoneWorkPercentage/milestoneQty;
            		double totalPrice=ClientACT.getProjectsTotalPrice(projects[i][0],token);
            		double dueAmount=ClientACT.getDueAmount(projects[i][3],token);
            		String bg_color="";
            		if(projects[i][16].equalsIgnoreCase("Inactive"))bg_color="bg-danger";
			%>
              <div class="order-progress-box">
                <div class="row order_view pointers">
                  <div class="col-md-5 col-sm-5 col-12 p-0">
                    <div class="order-details">
                      <p><strong>Order No.:</strong> <a class="pointers"><%=projects[i][2] %></a></p>              
                      <p><span><%=projects[i][7] %></span></p>
                    </div>
                  </div>
                  <div class="col-md-4 col-sm-4 col-12">
                    <!-- Progress bar 1 -->
                    <div class="progress clearfix mt-3"><%if(projects[i][17].equals("1")){ %>
                      <div class="progress-bar" style="width:<%=projects[i][13]%>%"><%=projects[i][13]%> %</div><%}else{ %>
                      <div class="progress-bar" style="width:100%">Consulting Service</div><%} %>
                    </div>					
                  </div>
                  <div class="col-md-3 col-sm-3 col-12">
                    <div class="edit-orders"> 
                      <a class="locks" onclick="openCertificates('<%=projects[i][0] %>')"><i class="fas fa-file-alt" title="Certificates"></i></a>
                      <a class="comments" href="<%=request.getContextPath() %>/client_inbox.html?skey=<%=projects[i][0] %>&pno=<%=projects[i][2] %>&pname=<%=projects[i][7] %>&cdate=<%=projects[i][15] %>" title="Open Chat"><i class="far fa-comment-alt" aria-hidden="true"></i></a>
					
					</div>
					<div class="mobileeditbtn">
					<a href="javascript:void(0)" class="docbtn" onclick="openCertificates('<%=projects[i][0] %>')">Doc</a>
					<a class="chatbtn" href="<%=request.getContextPath() %>/client_inbox.html?skey=<%=projects[i][0] %>&pno=<%=projects[i][2] %>&pname=<%=projects[i][7] %>&cdate=<%=projects[i][15] %>">Chat</a>
						<button class="exapandarrow"><i class="fa fa-angle-down"></i></button>
					</div>
                  </div>
                </div>
				<div class="clearfix" style="display:none;">
				<div class="row">
				  <div class="col-md-12 col-sm-12 col-12">
                    <div class="order_details">
                      <p>
					  <span><i class="fas fa-clipboard-check"></i><span>Sales order created on <%=projects[i][12] %> !!</span></span> 
                      <span></span>
					  </p>
					  <p>
					  <span><i class="fas fa-clipboard-check"></i><span>Payment added on <%=projects[i][12] %> !!</span></span>
                      <span></span>
					  </p>
					  <%if(projects[i][13].equals("100")){ %>
					  <p>
					  <span><i class="fas fa-clipboard-check"></i><span><%=projects[i][2] %> Successfully completed !!</span></span>
                      <span></span> 
					  </p><%} %>
                    </div>
                  </div>
				</div>
				<div class="row">
				  <div class="col-md-6 col-sm-6 col-12">  
                    <div class="order-date">
                      <p><%if(projects[i][17].equals("1")){ %>
					  <span><strong>Status:</strong> <a class="pointers status_view <%=bg_color%>"><%=projects[i][16] %></a></span>
					  <%}if(dueAmount>0){ %>
					  <span><strong>Payment:</strong> <a class="pointers payment_view" data-toggle="modal" data-target="#paymentModal" onclick="setSalesKey('<%=projects[i][0] %>','<%=dueAmount%>')"><i></i></a></span>
					 <%} %>
					  </p>
                    </div>
                  </div>
				  <div class="col-md-6 col-sm-6 col-12">
				  <div class="order_amount text-right">
				    <p><strong>Total Amount:</strong><span class="amount" title="<%=totalPrice%>"><strong class="pl-4"><i class="fa fa-inr"></i> <%=CommonHelper.withLargeIntegers(totalPrice) %></strong></span></p> 
				  </div>
				  </div>
				</div>
				</div>
              </div>
              <%}}else{ %>
              <div class="clearfix text-center text-danger noDataFound">
              <img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/nodata.png" alt="">
              <p>Your orders are under progress !!</p></div>
              <%} %>
            </div>
            <div class="col-md-12 row page-range">
            <div class="col-md-9"></div>
            <div class="col-md-1 col-md-offset-9">
				<select name="pageShow" id="PageShow"<%if(projects.length>=10){ %> onchange="pageLimit(this.value)"<%} %>>
				    <option value="10" <%if(pageLimit==10){ %>selected<%} %>>10</option>
				    <option value="20" <%if(pageLimit==20){ %>selected<%} %>>20</option>
				    <option value="40" <%if(pageLimit==40){ %>selected<%} %>>40</option>
				    <option value="80" <%if(pageLimit==80){ %>selected<%} %>>80</option>
				</select>
			</div>
		    <div class="col-md-2 text-center">
		    <i class="fas fa-chevron-left pointers" <%if(pageStart>1){ %>onclick="backwardPage()"<%} %>></i><span><%=pageStart %>-<%=pageEnd %></span><i class="fas fa-chevron-right pointers" <%if(projects!=null&&projects.length>=pageLimit){ %>onclick="forwardPage()"<%} %>></i>
		    </div>
			  </div>
          </div>

<!-- 1ST box end -->
    
	  </div>
      </div>
      </div>
    </div>
    </div>
    </div>
     </div>
    </div>
  </section>
</section>
<!-- main content ends -->

<!-- Payment Modal -->
  <div class="myModal modal fade" id="paymentModal">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title"><i class="fa fa-credit-card" aria-hidden="true"></i>+Add Payments</h4>  
          <button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>
        <form action="payment.html" target="_blank" method="post">
        <div class="modal-body">        
          <ul class="payment_tab nav nav-tabs">
		  <li><a data-toggle="tab" href="#pay_method3"><img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/paytm.png" alt=""></a></li>
		  </ul>
		  <div class="tab-content">
		  
		  <div id="pay_method3" class="tab-pane fade show active">
		  <div class="row">
            <div class="form-group-payment col-md-8 col-sm-7 col-12">
			<label>Mobile No.</label>
            <input type="text" class="form-control" name="MOBILE_NO" id="Mobile No." required="required">
            </div>
            <div class="form-group-payment col-md-4 col-sm-5 col-12">
			<label>Amount</label>
            <input type="text" class="form-control" name="TXN_AMOUNT" id="Amount" required="required">
            </div>
            <input type="hidden" id="ORDER_ID" name="ORDER_ID" value="ORDS_<%= randomInt %>">
		  </div>
          </div>
		  </div>  		  
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-success">Confirm Payment</button> 
        </div>
        </form>
      </div>
    </div>
  </div>
<!-- End Payment Modal -->

<%@ include file="includes/client-footer-js.jsp" %>
<script>
$('.order_view').click(function(){
    $(this).next().slideToggle();
});
</script>
<script src="<%=request.getContextPath() %>/hcustfrontend/fntdjs/jquery.circlechart.js"></script>
<script type="text/javascript">
function setSalesKey(data,due){
	$("#Amount").val(due);
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/SetOrderTypeSearch999",
	    data:  { 
	    	data : data,
	    	name : "SalesKey"
	    },
	    success: function (response) {  
        },
	});
}
function removeSearchOption(data){
		$.ajax({
		    type: "POST",
		    url: "<%=request.getContextPath()%>/ClearOrderTypeSearch999",
		    data:  { 
		    	data : data
		    },
		    success: function (response) {        	  
	         location.reload(true);
	        },
		});	
}
function doAction(data,name){
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/SetOrderTypeSearch999",
	    data:  { 
	    	data : data,
	    	name : name
	    },
	    success: function (response) {        	  
         location.reload();
        },
	});
}

// function openChatBox(salesKey,projectNo,projectName,closeDate){
// 	$.ajax({
// 	    type: "POST",
<%-- 	    url: "<%=request.getContextPath()%>/OpenThisProjectChat999", --%>
// 	    data:  { 
// 	    	salesKey : salesKey,
// 	    	projectNo : projectNo,
// 	    	projectName : projectName,
// 	    	closeDate : closeDate,
// 	    	"status" : "1"
// 	    },
// 	    success: function (response) {        	  
<%--          window.location="<%=request.getContextPath()%>/client_inbox.html";        	   --%>
//         },
// 	});
// }
// function workInProgress(){
// 	document.getElementById('errorMsg').innerHTML ="Work is in progress,After completing you may download your certificate...!";	        		  
// 	  $('.alert-show').show().delay(4000).fadeOut();	
// }
function openCertificates(salesKey){	
	$.ajax({
		type : "POST",
		url : "documentUploadBy999",
		dataType : "HTML",
		data : {
			data : "Agent",
		},
		success : function(response){
			window.location="<%=request.getContextPath()%>/viewalldocuments-"+salesKey+".html";					
		}
	});
	
}

$(function() {
	$("#SearchOrder,#SearchOrder1").autocomplete({
		source : function(request, response) {			
			if($('#SearchOrder').val().trim().length>=2||$('#SearchOrder1').val().trim().length>=2)
			$.ajax({
				url : "getprojectdetails.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					loginuaid : "<%=loginuaid%>"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value,	
							projectNo :item.projectNo,
						};
					}));
				},
				error : function(error) {
					alert('error: ' + error.responseText);
				}
			});
		},
		select: function (event, ui) {
			if(!ui.item){   
            	
            }
            else{
            	doAction(ui.item.value,'ClientOrderSearchDoAction');
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});
function sortBy(){
	var clientfrom=document.getElementById("ClientFrom").value.trim();
	var clientto=document.getElementById("ClientTo").value.trim();
	if(clientfrom=="") clientfrom="NA";
	if(clientto=="")clientto="NA";
	var include="No";
	var searchorder=document.getElementById("SearchOrder").value.trim();
	var sprjno="NA";
	var sprjname="NA";
	if(searchorder!=""){
		var x=searchorder.split("#");
		sprjno=x[0];
		sprjname=x[1];
	}
	if(document.getElementById('gridCheck').checked)include="Yes";
	var sortby=document.getElementById("SortedBy").value.trim();
	
		$.ajax({
			type : "POST",
			url : "ManageClientOrderCTRL.html",
			dataType : "HTML",
			data : {
				clientfrom : clientfrom,
				clientto : clientto,
				include : include,
				sortby : sortby,
				sprjno : sprjno,
				sprjname : sprjname,
			},
			success : function(data){
				location.reload();					
			}
		});
}
function restSearch(){
	$.ajax({
		type : "GET",
		url : "ManageClientOrderCTRL.html",
		dataType : "HTML",
		data : {
			reset : "reset",
		},
		success : function(data){
			location.reload();					
		}
	});	
}
function setDtaeFromTo(){	
	if(document.getElementById("ClientFrom").value.trim()==""){
		document.getElementById('errorMsg').innerHTML = 'Select Start Date First.';
		document.getElementById("ClientTo").value="";
		$('.alert-show').show().delay(2000).fadeOut();		
	}else{
		var clientfrom=document.getElementById("ClientFrom").value.trim();
		var clientto=document.getElementById("ClientTo").value.trim();		
		if(clientfrom=="") clientfrom="NA";
		if(clientto=="")clientto="NA";
		
		var searchorder=document.getElementById("SearchOrder").value.trim();
		var sprjno="NA";
		var sprjname="NA";
		if(searchorder!=""){
			var x=searchorder.split("#");
			sprjno=x[0];
			sprjname=x[1];
		}
		var clientto=document.getElementById("ClientTo").value.trim();
		
		var include="No";
		if(document.getElementById('gridCheck').checked)include="Yes";
		var sortby=document.getElementById("SortedBy").value.trim();
		
			$.ajax({
				type : "POST",
				url : "ManageClientOrderCTRL.html",
				dataType : "HTML",
				data : {
					clientfrom : clientfrom,
					clientto : clientto,
					include : include,
					sortby : sortby,
					sprjno : sprjno,
					sprjname : sprjname,
				},
				success : function(data){
					location.reload();					
				}
			});
			
		
	}
}

</script>
<script type="text/javascript">
$('input[name="date_range"]').daterangepicker({
	autoApply: true,
	locale: {
      format: 'DD-MM-YYYY' 
    }  
});
$('#date_range').on('apply.daterangepicker', function(ev, picker) {
	var date=$("#date_range").val();
    doAction(date,'searchFromToDate');
});
</script>
<script>
$('.progress_bar').percentcircle({
animate : true,
diameter : 10,
guage: 15,
coverBg: '#fff',
bgColor: '#efefef',
fillColor: '#007bff',
percentSize: '20px',
percentWeight: 'normal'
});	

function pageLimit(data){
	  var start="<%=pageStart%>";
	  var limit="<%=pageLimit%>";
	  var end=Number(start)+Number(data);
	  if(Number(start)==1)end-=1;
	  doAction(data,'orderPageLimit');
	  doAction(end,'orderPageEnd');
	  location.reload(true);
}
function backwardPage(){
		 var count="<%=count-1%>";
		 var limit="<%=pageLimit%>";
		 var start=0;
		 if(Number(count)>=1){			 
			 start=(Number(count)-1)*Number(limit);
			 if(start==0)start=1;
			 var end=Number(count)*Number(limit);			 
		 }else if(count==0){
			 start=1;
			 end=limit;
		 }
		 doAction(start,'orderPageStart');
		 doAction(end,'orderPageEnd');
		 location.reload(true);
	 }
function forwardPage(){  
	 var count="<%=count+1%>";
	 var limit="<%=pageLimit%>";
	 var start=(Number(count)-1)*Number(limit);
	 var end=Number(count)*Number(limit);
	 doAction(start,'orderPageStart');
	 doAction(end,'orderPageEnd');
	 location.reload(true);
}

</script>
</body>
<!-- body ends -->
</html>