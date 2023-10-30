<%@page import="com.itextpdf.io.util.DateTimeUtil"%>
<%@page import="commons.DateUtil"%>
<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/> 
	<title>Calendar</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	<%
String addedby= (String)session.getAttribute("loginuID");
String clientname = (String) session.getAttribute("mngbclientname");
if(clientname==null||clientname.length()<=0)clientname="NA";
String userroll= (String)session.getAttribute("emproleid");
String token=(String)session.getAttribute("uavalidtokenno");
String today=DateUtil.getCurrentDateIndianFormat1();
String date_range_value=(String)session.getAttribute("date_range_value");
if(date_range_value==null||date_range_value.length()<=0)date_range_value="NA";

String loginuaid = (String)session.getAttribute("loginuaid");
String userName=Usermaster_ACT.getLoginUserName(loginuaid, token);

int assignments=TaskMaster_ACT.getAllAssignments(loginuaid,token,date_range_value);  

%>
<%if(!MCC0){%><jsp:forward page="/login.html" /><%} %>
	<div id="content">
		<div class="main-content calendar_page"> 
			<div class="container">	
				<div class="row">
                	<div class="col-md-12 col-sm-12 col-xs-12"> 
                	<div class="clearfix mbt20 text-center">
                	<a onclick="getNextPrevDate('prev')"><span>Previous week</span></a><span class="fa fa-angle-left mlft14 mrht14"></span>
					<span class="date_range"><input type="text" class="pointers date_range" placeholder="FROM - TO DATE" name="date_range" id="date_range" readonly/></span> 
					<span class="fa fa-angle-right mlft14 mrht14"></span> 
					<a onclick="getNextPrevDate('next')"><span>Next week</span></a>
                	</div> 
                        <div class="menuDv pad_box1 pad_box2">
                         <div class="clearfix mbt20">
                         <div class="col-md-2 col-sm-2 col-xs-12 box-width5">
                         <img alt="" src="<%=request.getContextPath()%>/staticresources/images/notification1.png">
                         </div>
                         <div class="col-md-10 col-sm-10 col-xs-12">
                         <div style="font-size: 15px;"><span>Hi <%=userName %></span></div>
                         <div style="font-size: 18px;font-weight: 400;margin-top: 5px;"><span>You have <%=assignments %> assignments</span></div>
                         </div>
                         </div>   
						<div class="clearfix mb30"> 
                         <div class="col-md-2 col-sm-3 col-xs-6">
						 <div class="clearfix dropdown inline_block">
                         <button type="button" class="calmenu dropbtn">All<span>5</span><i class="fa fa-angle-down"></i></button> 
						 <div class="dropdown-content" style="border-radius: 3px;min-width: 102px;margin-left: 0;">
						     <a class="clickeble" onclick="">All</a>
						     <a class="clickeble" onclick="">New</a>
						     <a class="clickeble" onclick="">Open</a>	
						     <a class="clickeble" onclick="">Hold</a>	
						     <a class="clickeble" onclick="">Pending</a>				    
						 </div>
                         </div> 
						 </div>
                        </div> 
						
						<div class="clearfix calendar_ovrflow_hide">
						<div class="calendar_box_fix">
						<%
						String milestones[][]=TaskMaster_ACT.getAllMilestones(loginuaid,token,date_range_value);
						if(milestones!=null&&milestones.length>0){
							for(int i=0;i<milestones.length;i++){
								String iconBox="";
								if(milestones[i][6].equalsIgnoreCase("Open"))iconBox="calender_open.png";
								else if(milestones[i][6].equalsIgnoreCase("Pending"))iconBox="calender_pending.png";
								else if(milestones[i][6].equalsIgnoreCase("On-Hold"))iconBox="calender_hold.png";
								else if(milestones[i][6].equalsIgnoreCase("New"))iconBox="calender_new.png";
								else if(milestones[i][6].equalsIgnoreCase("Expired"))iconBox="calender_expired.png";
								String serviceType=TaskMaster_ACT.getSalesProductName(milestones[i][1], token);
// 								String deliveryData[]=TaskMaster_ACT.getDeliveryDate(milestones[i][5],milestones[i][2],token);
								String deliveryData[]=TaskMaster_ACT.getMonthAndDay(milestones[i][7]);
						%>						
						
						<div class="clearfix" onmouseover="displayContents('ProgressBarId<%=i %>','BarProgressReport<%=i %>','CalActionBtn<%=i %>')" onmouseout="hideContents('ProgressBarId<%=i %>','BarProgressReport<%=i %>','CalActionBtn<%=i %>')"> 
                         <div class="col-md-2 col-sm-2 col-xs-12">
                         <div class="calender">
						 <span class="text-center relative_box ">
                       
						 <span class="calmonth"><%=deliveryData[0] %></span> 
						 <span class="caldate"><%=milestones[i][7].substring(0, 2) %></span>
						 <span class="calday"><%=deliveryData[1] %></span> 
						 </span>
                         </div>
                         </div>
						 <div class="col-md-10 col-sm-10 col-xs-12">
						 <div class="row">
                         <div class="pad0 mtop10 col-md-4 col-sm-4 col-xs-12">
						 <div class="clearfix"> 
						 <div class="clearfix mbt5"><span><%=milestones[i][3] %></span></div>
						 <div class="dimcolor"><span><%=serviceType %></span></div>
						 </div>
						 </div>
						 <div class="pad-rt0 footer-bottom2 col-md-4 col-sm-4 col-xs-12" id="ProgressBarId<%=i %>" style="opacity: 0;">  
                         <div class="progress" style="background-color:#E7E7E7;">
					     <div class="progress-bar pointers taskhis" data-related="task_history" role="progressbar" aria-valuenow="<%=milestones[i][4] %>" aria-valuemin="0" aria-valuemax="100" style="width:<%=milestones[i][4] %>%;background-color:#aaa;">
<%-- 					      <span class="sr-only"><%=milestones[i][4] %>% Complete</span> --%>
					     </div>
					     </div>
                         </div>
						 <div class="footer-bottom2 pad05 col-md-2 col-sm-2 col-xs-12" style="opacity: 0;" id="BarProgressReport<%=i %>">
                         <span class="dimcolor"><%=milestones[i][4] %>% Complete</span>
                         </div>
                         <div class="mtop10 col-md-2 col-sm-2 col-xs-12 text-right"><span class="dimcolor"><%=milestones[i][5] %></span></div>
                         </div>
						 <div class="dimcolor row" id="CalActionBtn<%=i %>" style="opacity: 0;margin-top: 65px;">  
                         <a href="<%=request.getContextPath()%>/edittask-<%=milestones[i][0]%>.html"><span class="dimcolor pointers">Edit</span></a>
                         <a href="<%=request.getContextPath()%>/edittask-<%=milestones[i][0]%>.html?typ=chat" class="dimcolor mlft22 pointers">Follow-Up</a>
                         <a href="<%=request.getContextPath()%>/edittask-<%=milestones[i][0]%>.html?typ=doc" class="dimcolor mlft22 pointers">Documents</a>
                         </div>
						 </div>
						 </div>						 
                         <hr class="mb30 mrt14 mlft14 mtp38">
						 
						 <%}}else{ %>						 
						 	<div class="clearfix text-center text-danger footer-bottom2 noDataFound">No Data Found !!</div>
						 <%} %>
						 </div>
						 </div>
                         
					</div>
				</div>
			</div>
		</div>
	</div>
	<p id="end" style="display:none;"></p>
	</div>
	<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>	
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>

	<script type="text/javascript">	
	function displayContents(ProgressBarId,BarProgressReport,CalActionBtn){
		$("#TodayId").css('margin-left','');
		$("#"+ProgressBarId).css('opacity','1');
		$("#"+BarProgressReport).css('opacity','1');
		$("#"+CalActionBtn).css('opacity','1');
	}
	function hideContents(ProgressBarId,BarProgressReport,CalActionBtn){
		$("#TodayId").css('margin-left','');
		$("#"+ProgressBarId).css('opacity','0');
		$("#"+BarProgressReport).css('opacity','0');
		$("#"+CalActionBtn).css('opacity','0');
	}
	function openTax(){

		$("#AddNewTax").trigger('reset');
		
		var id = $(".newtax").attr('data-related'); 
		$('.fixed_right_box').addClass('active');
		    $("div.add_inner_box").each(function(){
		        $(this).hide();
		        if($(this).attr('id') == id) {
		            $(this).show();
		        }
		    });		
	}
	function openExpense(){

		$("#AddNewExpense").trigger('reset');
		
		var id = $(".expense").attr('data-related'); 
		$('.fixed_right_box').addClass('active');
		    $("div.add_inner_box").each(function(){
		        $(this).hide();
		        if($(this).attr('id') == id) {
		            $(this).show();
		        }
		    });		
	}
	function openRefundExpense(){

		$("#RefundNewExpense").trigger('reset');
		
		var id = $(".refundexpense").attr('data-related'); 
		$('.fixed_right_box').addClass('active');
		    $("div.add_inner_box").each(function(){
		        $(this).hide();
		        if($(this).attr('id') == id) {
		            $(this).show();
		        }
		    });		
	}
	function openIncomeRefund(){

		$("#RefundExpense").trigger('reset');
		
		var id = $(".incomerefund").attr('data-related'); 
		$('.fixed_right_box').addClass('active');
		    $("div.add_inner_box").each(function(){
		        $(this).hide();
		        if($(this).attr('id') == id) {
		            $(this).show();
		        }
		    });		
	}
	function openTransferBox(){

		$("#Transfer_Funds").trigger('reset');
		
		var id = $(".transfer").attr('data-related'); 
		$('.fixed_right_box').addClass('active');
		    $("div.add_inner_box").each(function(){
		        $(this).hide();
		        if($(this).attr('id') == id) {
		            $(this).show();
		        }
		    });		
	}
	
	$(function() {
		$("#clientname").autocomplete({
			source : function(request, response) {
				if(document.getElementById('clientname').value.trim().length>=2)
				$.ajax({
					url : "getclientname.html",
					type : "POST",
					dataType : "JSON",
					data : {
						name : request.term,
						col :"cregname"
					},
					success : function(data) {
						response($.map(data, function(item) {
							return {  
								label : item.name,
								value : item.value,					
							};
						}));
					},
					error : function(error) {
						alert('error: ' + error.responseText);
					}
				});
			},
			change: function (event, ui) {
	            if(!ui.item){     
	            	document.getElementById('errorMsg').innerHTML = 'Select From List.';
	        		$('.alert-show').show().delay(1000).fadeOut();
	        		
	            	$("#clientname").val("");     	
	            }
	            else{
	            	$("#clientname").val(ui.item.value);
	            	
	            }
	        },
	        error : function(error){
				alert('error: ' + error.responseText);
			},
		});
	});
	</script>
	<script type="text/javascript">
/* var counter=25;
$(window).scroll(function () {
    if ($(window).scrollTop() == $(document).height() - $(window).height()) {
    	appendData();
    }
}); */

// function appendData() {
//     var html = '';
//     if(document.getElementById("end").innerHTML=="End") return false;
//     $.ajax({
//     	type: "POST",
<%--         url: '<%=request.getContextPath()%>/getmorebillings', --%>
//         datatype : "json",
//         data: {
//         	counter:counter,
<%--         	clientname:'<%=clientname%>', --%>
<%--         	projectname:'<%=projectname%>', --%>
<%--         	projecttype:'<%=projecttype%>', --%>
<%--         	billingtype:'<%=billingtype%>', --%>
<%--         	status:'<%=status%>', --%>
<%--         	from:'<%=from%>', --%>
<%--         	to:'<%=to%>' --%>
//         	},
//         success: function(data){
//         	for(i=0;i<data[0].billing.length;i++)
//             	html += '<div class="row"><div class="col-md-12 col-sm-12 col-xs-12"><div class="clearfix"><div class="box-width1 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].billing[i][0]+'</p></div></div><div class="box-width3 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].billing[i][1]+'</p></div></div><div class="box-width16 col-xs-3 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].billing[i][3]+'</p></div></div><div class="col-md-1 col-xs-12 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].billing[i][2]+'</p></div></div><div class="col-md-1 col-xs-12 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].billing[i][4]+'</p></div></div><div class="col-md-1 col-xs-12 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].billing[i][6]+'</p></div></div><div class="col-md-1 col-xs-12 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].billing[i][7]+'</p></div></div><div class="col-md-1 col-xs-12 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].billing[i][8]+'</p></div></div><div class="box-width2 col-xs-12 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].billing[i][9]+'</p></div></div><div class="col-md-1 col-xs-12 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].billing[i][5]+'</p></div></div><div class="col-md-1 col-xs-12 box-intro-background"><div class="link-style12"><p><a href="javascript:void(0);" onclick="vieweditpage('+data[0].billing[i][0]+');">Edit</a><a href="javascript:void(0);" onclick="approve('+data[0].billing[i][0]+')"> Delete</a></p></div></div></div></div></div>';
//             if(html!='') $('#target').append(html);
//             else document.getElementById("end").innerHTML = "End";
//         }
//     });
    
//     counter=counter+25;
// }
</script>
<script type="text/javascript">
function approve(id) {
	if(confirm("Sure you want to Delete this Bill ? "))
	{
	var xhttp; 
	xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
	if (this.readyState == 4 && this.status == 200) {
	location.reload();
	}
	};
	xhttp.open("GET", "<%=request.getContextPath()%>/DeleteBill111?info="+id, true); 
	xhttp.send();
	}
}
function RefineSearchenquiry() {
	document.RefineSearchenqu.jsstype.value="SSEqury";
	document.RefineSearchenqu.action="<%=request.getContextPath()%>/manage-billing.html";
	document.RefineSearchenqu.submit();
}
</script>
<script type="text/javascript">
function vieweditpage(id,page){
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/vieweditpage",
	    data:  { 
	    	"uid" : id
	    },
	    success: function (response) {
        	if(page=="followup") window.location = "<%=request.getContextPath()%>/follow-up-billing.html";  
        	else if(page=="billing") window.location = "<%=request.getContextPath() %>/billing.html";  
        },
	});
}
</script>

<script>
$('.list_action_box').hover(function(){
	$(this).children().next().toggleClass("show");
}); 
</script>
<script>
$('.close_icon_btn').click(function(){
	$('.notify_box').hide();
});
$('.close_box').on( "click", function(e) { 
	$('.fixed_right_box').removeClass('active');
	$('.addnew').show();	
	});
</script>	
<script>
$(document).ready(function() {
$('#multiple_item').select2();
});
</script>
<script type="text/javascript">

$('input[name="date_range"]').on('apply.daterangepicker', function(ev, picker) {
//     $(this).val(picker.startDate.format('MM/DD/YYYY') + ' - ' + picker.endDate.format('MM/DD/YYYY'));
	var data=$(this).val();
	doAction(data,"date_range_value");
});

$('input[name="date_range"]').daterangepicker({
	  autoUpdateInput: false,
	  autoApply: true,
	  showDropdowns: true,
	}, function(start_date, end_date) {
	  $('input[name="date_range"]').val(start_date.format('DD-MM-YYYY')+' - '+end_date.format('DD-MM-YYYY'));
	});

function doAction(data,name){
	showLoader();
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/SetDataToSession111",
	    data:  { 
	    	data : data,
	    	name : name
	    },
	    success: function (response) {        	  
         location.reload(true)     	  ;
        },
		complete : function(data){
			hideLoader();
		},
	});
}

function getNextPrevDate(data){
	var currentDate=$("#date_range").val();
	if(currentDate!=null&&currentDate!=""&&currentDate!="NA"){
		showLoader();
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/GetPrevNextDateRange111",
	    data:  { 
	    	data : data,
	    	currentDate : currentDate,
	    },
	    success: function (response) {        	  
         location.reload(true)     	  ;
        },
		complete : function(data){
			hideLoader();
		}
	});
	}else{
		document.getElementById("errorMsg").innerHTML="Please Select a valid Date range !!.";				
		$('.alert-show').show().delay(4000).fadeOut();
	}
}
$( document ).ready(function() {
	   var dateRangeDoAction="<%=date_range_value%>";
	   if(dateRangeDoAction!="NA"){	  
		   $('input[name="date_range"]').val(dateRangeDoAction);
	   }
	});
</script>
</body>
</html>