<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/> 
	<title>Manage Report</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %> 
	<%if(!MP02){%><jsp:forward page="/login.html" /><%} %>
	<%
String addedby= (String)session.getAttribute("loginuID");
String clientname = (String) session.getAttribute("mngbclientname");
if(clientname==null||clientname.length()<=0)clientname="NA";
String userroll= (String)session.getAttribute("emproleid");
String token=(String)session.getAttribute("uavalidtokenno");

%>
<%-- <%if(!MB07){%><jsp:forward page="/login.html" /><%} %> --%>
	<div id="content">
		<div class="container">   
          <div class="bread-crumb relative_box" style="border-bottom: none;">
            <div class="bd-breadcrumb bd-light">
            <a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
            <a>Report</a>
            </div>
						
          </div>
        </div>
		<div class="main-content">
			<div class="container">
			<div class="row">
			<div class="col-md-5 col-sm-5 col-xs-12">				
                      <div class="col-md-12 col-sm-12 col-xs-12" style="box-shadow: 0px 1px 3px 0px #aaa;border-radius: 4px;">
                      	<div class="row"><h4 style="margin-top: 20px;margin-left: 14px;">Focus on customers</h4></div>
                      	<p>See which customers contribute most of your revenue, and keep on top of overdue balances.</p>
                      	<div class="row"><h4 style="margin-top: 10px;margin-left: 14px;"><a href="<%=request.getContextPath() %>/agedreceivablesinvoice.html" style="color: #4ac4f3;">Aged Receivables</a></h4></div>
                      	<p>Unpaid and overdue invoices for the last 30,60 and 90+ days.</p>
                      	<div class="row"><h4 style="margin-top: 10px;margin-left: 14px;"><a href="<%=request.getContextPath() %>/salesgsttax.html" style="color: #4ac4f3;">Sales Tax</a></h4></div>
                      	<p>Taxes collected from sales to help you file sales tax returns.</p>
                      </div>
                      <div class="col-md-12 col-sm-12 col-xs-12" style="box-shadow: 0px 1px 3px 0px #aaa;border-radius: 4px;margin-top: 10px;padding: 4px 10px;">
                      	<div class="row"><h4 style="margin-top: 10px;margin-left: 14px;">Focus on vendors</h4></div>
                      	<p>Understand business which contribute most of your revenue, where you spend, and how much they owe for your professional services.</p>
                      	<div class="row"><h4 style="margin-top: 10px;margin-left: 14px;"><a href="<%=request.getContextPath() %>/agedreceivablesbills.html" style="color: #4ac4f3;">Aged Receivables Bills</a></h4></div>
                      	<p>Unpaid and overdue invoices for the last 30,60 and 90+ days.</p>
                      </div> 
			
			</div>
			<div class="col-md-7 col-sm-7 col-xs-12">			
			<div class="col-md-12 col-sm-12 col-xs-12" style="box-shadow: 0px 1px 3px 0px #aaa;border-radius: 4px;">
                   	<div class="row"><h4 style="margin-top: 20px;margin-left: 14px;">Get the big picture</h4></div>
                   	<p>How much profit are you making? Are your assets growing faster than your liabilities? Is cash flowing, or getting stuck?</p>
                   	<div class="row" style="margin-left: 0px;margin-top: 46px;">
                   	<div class="col-md-6 col-sm-6 col-xs-12">
                   	<div class="row"><h4 style="margin-top: 10px;margin-left: 14px;"><a href="<%=request.getContextPath() %>/profitandloss.html" style="color: #4ac4f3;">Profit & Loss (Income Statement)</a></h4></div>
                   	<p>Summary of your revenue and expenses that determine the profit you made.</p>
                   	</div>                   	
                   	<div class="col-md-6 col-sm-6 col-xs-12">
                   	<div class="row"><h4 style="margin-top: 10px;margin-left: 14px;"><a href="<%=request.getContextPath() %>/accountbalance.html" style="color: #4ac4f3;">Account Balance</a></h4></div>
                   	<p>Summary viewof balances and activity for all accounts.</p>
                   	</div>
                   	</div>
                   	<div class="row" style="margin-left: 0px;margin-top: 46px;padding-bottom: 53px;">
                   	<div class="col-md-6 col-sm-6 col-xs-12">
                   	<div class="row"><h4 style="margin-top: 10px;margin-left: 14px;"><a href="<%=request.getContextPath() %>/balancesheet.html" style="color: #4ac4f3;">Balance Sheet</a></h4></div>
                   	<p>Snapshot of what your business assets, liabilities and equity.</p>
                   	</div>
                   	<div class="col-md-6 col-sm-6 col-xs-12">
                   	<div class="row"><h4 style="margin-top: 10px;margin-left: 14px;"><a href="<%=request.getContextPath() %>/cashflow.html" style="color: #4ac4f3;">Cash Flow</a></h4></div>
                   	<p>Cash coming in and going out of your business.</p>
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
// var counter=25;
// $(window).scroll(function () {
//     if ($(window).scrollTop() == $(document).height() - $(window).height()) {
//     	appendData();
//     }
// });

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

</body>
</html>