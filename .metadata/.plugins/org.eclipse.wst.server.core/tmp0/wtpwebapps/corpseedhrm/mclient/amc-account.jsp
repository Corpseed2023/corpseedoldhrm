<%@page import="client_master.Clientmaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title>AMC Account</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %> 
	<%
String addedby= (String)session.getAttribute("loginuID");
String clientname = (String) session.getAttribute("mngamcclientname");
if(clientname==null||clientname.length()<=0)clientname="NA";
String userroll= (String)session.getAttribute("emproleid");
String token=(String)session.getAttribute("uavalidtokenno");

String[][] amc=Clientmaster_ACT.getAllAmc(clientname,"25",token,userroll);
%>
<%if(!AMC00){%><jsp:forward page="/login.html" /><%} %>
	<div id="content">
		<div class="container">   
          <div class="bread-crumb">
            <div class="bd-breadcrumb bd-light">
            <a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
            <a>AMC Account</a>
            </div>
          </div>
        </div>
		<div class="main-content">
			<div class="container">
				<div class="row">
                	<div class="col-md-12 col-sm-12 col-xs-12">
                        <div class="menuDv partner-slider8">
                        <div class="row">
						<div class="col-md-12 col-sm-12 col-xs-12">
						<div class="top_title text-center">
						<h2>AMC Account</h2>
						
						</div>
						</div>
						</div>


<div class="home-search-form clearfix">
<form name="RefineSearchenqu" action="<%=request.getContextPath()%>/amc-account.html" method="Post">
<div class="item-bestsell col-sm-3 col-xs-12">
  <div class="input-group"> 
<p><input type="text" name="clientname" id="clientname" autocomplete="off" <% if(!clientname.equalsIgnoreCase("NA")){ %>value="<%=clientname%>"<%} %> placeholder="Search By Client Name" class="form-control"/></p>
</div>
</div>
<div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
<button class="btn-link-default bt-radius" type="submit" name="button" value="Search"><i class="fa fa-search" title="Search"></i></button>
<button class="btn-link-default bt-radius" type="submit" name="button" value="Reset"><i class="fa fa-refresh" title="Reset"></i></button>
</div>
</form>
</div>

                            <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix box-intro-bg">
                            	<div class="box-width1 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">SN</p>
                                    </div>
                                </div>
                                <div class="box-width6 col-md-1 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Client</p>
                                    </div>
                                </div>                              
                                <div class="box-width22 col-md-1 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">No. Of Project</p>
                                    </div>
                                </div>
                                <div class="box-width2 col-md-1 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Renewal Date</p>
                                    </div>
                                </div>
                                <div class="box-width5 col-md-1 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Renewal Amount</p>
                                    </div>
                                </div>
                                <div class="box-width5 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Billing Amount</p>
                                    </div>
                                </div>  
                                 <div class="box-width5 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Due Amount</p>
                                    </div>
                                </div> 
                                 <div class="box-width5 col-md-1 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Pyment Status</p>
                                    </div>
                                </div>
                                 <div class="box-width22 col-md-1 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Client Status</p>
                                    </div>
                                </div>                           
                                                                
                               <div class="box-width5 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p>Action</p>
                                    </div>
                                </div>
                               </div>
                              </div>
                            </div>
                            
                            <%
                            String pymtstatus="NA";
                            String color="NA";
                             for(int i=0;i<amc.length;i++)
                             {	
                            	 int totalproject=Clientmaster_ACT.getTotalDeliveredProject(amc[i][0],token);
                            	 String rendate=Clientmaster_ACT.getRenewalDate(amc[i][0],token);
                            	 double renamt=Clientmaster_ACT.getRenewalAmount(amc[i][0],token);
                            	 double billamt=Clientmaster_ACT.getBillingAmount(amc[i][0],token,"amc");
                            	 double dueamt=Clientmaster_ACT.getTotalClientProjectDueAmount(amc[i][0],token,"amc");
                            	 
                            	if(billamt==0){pymtstatus="Bill Not Generated";color="red;";}
     							else if(billamt==dueamt){pymtstatus="Under Process";color="blue;";}
     							else if(billamt>dueamt&&dueamt!=0){pymtstatus="Partial Payment";color="darkorange;";}
     							else if(dueamt==0){pymtstatus="Full payment";color="#2fdf2f;";}
                            	
                            	if(rendate==null)rendate="No Project";
                             %>
                            <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix">
                            	<div class="box-width1 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border" title="<%=amc.length-i %>"><%=amc.length-i %></p>
                                    </div>
                                </div>
                                <div class="box-width6 col-md-1 col-xs-12 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border" title=""><%=amc[i][1] %></p>
                                    </div>
                                </div>                              
                                <div class="box-width22 col-md-1 col-xs-12 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border text-center" title="<%=totalproject %>"><%=totalproject %></p>
                                    </div>
                                </div>
                                <div class="box-width2 col-md-1 col-xs-12 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border" title="<%=rendate%>"><%=rendate%></p>
                                    </div>
                                </div>    
                                  <div class="box-width5 col-md-1 col-xs-12 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border" title="renamt" style="color: cornflowerblue;font-size: 15px;font-weight: 600;"><i class="fa fa-inr"></i>&nbsp;<%=renamt %> </p>
                                    </div>
                                </div> 
                                <div class="box-width5 col-md-1 col-xs-12 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border" title="" style="color: cornflowerblue;font-size: 15px;font-weight: 600;"><%if(billamt!=0){%><i class="fa fa-inr"></i>&nbsp;<%=Math.round(billamt) %><%}else if(billamt==0){ %><i style="color: red;font-size: 12px;font-weight: 500;">Bill Not Generated</i><%} %> </p>
                                    </div>
                                </div>
                                <div class="box-width5 col-md-1 col-xs-12 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border" title="" style="color: cornflowerblue;font-size: 15px;font-weight: 600;"><%if(billamt!=0){%><i class="fa fa-inr"></i>&nbsp;<%=Math.round(dueamt) %><%}else if(billamt==0){ %><i style="color: red;font-size: 12px;font-weight: 500;">Bill Not Generated</i><%} %> </p>
                                    </div>
                                </div>
                                <div class="box-width5 col-md-1 col-xs-12 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border" title=""><i style="color: <%=color%>font-size: 12px;"><%=pymtstatus %></i></p>
                                    </div>
                                </div> 
                                <div class="box-width22 col-md-1 col-xs-12 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border" style="font-size: 15px;color: blue;font-weight: 600;"<%if(amc[i][3].equalsIgnoreCase("1")){ %> title="Active">Active</p><%}else{ %>title="Inactive">Inactive</p><%} %>
                                    </div>
                                </div>                             
                                <div class="box-width5 col-xs-12 box-intro-background">
                                	<div class="link-style12">
                                    <p>
                                    <a href="javascript:void(0);" onclick="vieweditpage('<%=amc[i][0]  %>','amc');"><i class="fa fa-files-o" style="font-size: 18px;" title="Generate Invoice"></i></a>
                                    <a href="javascript:void(0);" onclick="alert('Working..,not done yet !!')"><i class="fa fa-history" style="font-size: 18px;" title="All Billing History.."></i></a>
<!--                                     <a class="toggle_btn"><i class="fa fa-bell"></i></a><span class="badge">2</span> -->
                                    </p>
                                    </div>
                                </div>
                               </div>
                              </div>
                              </div>   
                              <%}%>
                              
                                                  
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
	<script>
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
var counter=25;
$(window).scroll(function () {
    if ($(window).scrollTop() == $(document).height() - $(window).height()) {
    	appendData();
    }
});

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
	        	if(page=="followup") window.location = "<%=request.getContextPath()%>/follow-up-amc.html";
	        	else if(page=="amc") window.location = "<%=request.getContextPath() %>/amc-billing.html";  
	        },
		});
	}
	</script>
</body>
</html>