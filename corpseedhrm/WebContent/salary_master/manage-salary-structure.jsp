<%@page import="salary_master.SalaryStr_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Manage Salary Structure</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%
String token= (String)session.getAttribute("uavalidtokenno");
String msemname= (String)session.getAttribute("msemname");
String empid= (String)session.getAttribute("mstempid");
String from= (String)session.getAttribute("mstfrom");
String to= (String)session.getAttribute("mstto");
if(msemname==null||msemname.length()<=0)msemname="NA";
if(empid==null||empid.length()<=0)empid="NA";
if(from==null||from.length()<=0)from="NA";
if(to==null||to.length()<=0)to="NA";

String[][] allSalStr= SalaryStr_ACT.allSalStr(token, from, to,empid);
%>
<%if(!SAL00){%><jsp:forward page="/login.html" /><%} %>
	<div id="content">
		
		<div class="main-content">
			<div class="container">
				<div class="row">
                	<div class="col-md-12 col-sm-12 col-xs-12">
                        <div class="menuDv partner-slider8">
                        <div class="row">
						<div class="col-md-12 col-sm-12 col-xs-12">
						<div class="top_title text-center">
						<h2>Manage Salary Structure</h2>
						</div>
						<%if(SAL01){ %><a class="add_btn sub-btn1" href="<%=request.getContextPath() %>/Salary-Structure.html">Add Salary Structure</a><%} %>
						</div>
						</div>
                      
						<div class="home-search-form clearfix">
						<form action="<%=request.getContextPath() %>/Manage-Salary-Structure.html" method="post">
						<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
						<div class="input-group">
						<span class="input-group-addon"><i class="form-icon fa fa-user"></i></span>
						<input type="text" name="empname" id="EmpName" placeholder="Employee Name here !" class="form-control" <% if(!msemname.equalsIgnoreCase("NA")){ %>value="<%=msemname%>"<%}%> autocomplete="off"/>
						<input type="hidden" name="empid" id="EmpId" <% if(!empid.equalsIgnoreCase("NA")){ %>value="<%=empid%>"<%}%>/>
						</div>
						</div>
						<div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
						<div class="input-group">
						<span class="input-group-addon"><i class="form-icon fa fa-calendar"></i></span>
						<input type="text" name="from" id="from" placeholder="From" class="form-control readonlyAllow searchdate" <% if(!from.equalsIgnoreCase("NA")){ %>value="<%=from%>"<%}%> autocomplete="off" readonly="readonly"/>
						</div>
						</div>
						<div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
						<div class="input-group">
						<span class="input-group-addon"><i class="form-icon fa fa-calendar"></i></span>
						<input type="text" name="to" id="to" placeholder="To" class="form-control readonlyAllow searchdate" <% if(!to.equalsIgnoreCase("NA")){ %>value="<%=to%>"<%}%> autocomplete="off" readonly="readonly"/>
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
                               <div class="clearfix">
                            	<div class="box-width25 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">SN</p>
                                    </div>
                                </div>
                               <div class="box-width19 col-md-3 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Employee Name</p>
                                    </div>
                                </div>
                               <div class="box-width9 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">CTC</p>
                                    </div>
                                </div>
                                <div class="box-width9 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Leaves Allowed</p>
                                    </div>
                                </div>
                              <div class="box-width9 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Net Salary Payable</p>
                                    </div>
                                </div>
                            	<div class="box-width18 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p>Action </p>
                                    </div>
                                </div>
                               </div>
                              </div>
                            </div>
                            
                            <%
                             for(int i=0;i<allSalStr.length;i++)
                             {
                             %>
                            <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix">
                            	<div class="box-width25 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=i+1%></p>
                                    </div>
                                </div>
                                <div class="box-width19 col-md-3 col-xs-12 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=allSalStr[i][1] %></p>
                                    </div>
                                </div>
                                <div class="box-width9 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border">Rs. <%=allSalStr[i][2] %></p>
                                    </div>
                                </div>
                                <div class="box-width9 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=allSalStr[i][3] %></p>
                                    </div>
                                </div>
                                <div class="box-width9 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border">Rs. <%=allSalStr[i][4] %></p>
                                    </div>
                                </div>
                                <div class="box-width18 col-xs-12 box-intro-background">
                                	<div class="link-style12">
                                    <p>
                                   <%if(SAL02){ %><a class="fancybox" href="<%=request.getContextPath() %>/ViewSalaryStructure.html" onclick="vieweditpage(<%=allSalStr[i][0]%>,'NA');"><i class="fa fa-eye" title="view this salary structure."></i></a><%} %>
                                   <%if(SAL03){ %><a href="javascript:void(0);" onclick="vieweditpage(<%=allSalStr[i][0] %>,'edit');"><i class="fa fa-edit" title="edit this salary structure."></i></a><%} %>
                                   <%if(SAL05){ %><a class="quick-view" href="#managesalarystructure" onclick="document.getElementById('userid').innerHTML='<%=allSalStr[i][0] %>'"><i class="fa fa-trash" title="delete this salary structure."></i></a><%} %>
                                   <%if(SAL06){ %><a class="quick-view" href="#managesalarypromotion" onclick="document.getElementById('userid1').innerHTML='<%=allSalStr[i][0] %>'"><i class="fa fa-send" title="Promote this employee."></i></a><%} %>
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
	<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>
</div>
	<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<section class="clearfix" id="managesalarypromotion" style="display: none;">
<div class="clearfix  text-center">
<div class="col-md-12 col-xs-12" id="userid1" style="display: none;"></div>
<div class="col-md-12 col-xs-12">
<div class="box-intro1">
  <h2><span class="title">Promote This Employee's Position ?</span></h2>
</div>
</div>
<div class="col-md-12 col-xs-12 mb10">
<a class="sub-btn1" onclick="" id="cancelpopup1">Cancel</a>

<a class="sub-btn1 mlft10" onclick="return promote(document.getElementById('userid1').innerHTML);" title="Promote this Employee.">Promote</a>
</div>
</div>
</section>
	
<section class="clearfix" id="managesalarystructure" style="display: none;">
<div class="clearfix  text-center">
<div class="col-md-12 col-xs-12" id="userid" style="display: none;"></div>
<div class="col-md-12 col-xs-12">
<div class="box-intro1">
  <h2><span class="title">Delete This Salary Structure ?</span></h2>
</div>
</div>
<div class="col-md-12 col-xs-12 mb10">
<a class="sub-btn1" onclick="" id="cancelpopup">Cancel</a>

<a class="sub-btn1 mlft10" onclick="return approve(document.getElementById('userid').innerHTML);" title="Delete this Salary Structure.">Delete</a>
</div>
</div>
</section>
<script type="text/javascript">
$(".fancybox").fancybox({
    'width'             : '100%',
    'height'            : '100%',
    'autoScale'         : false,
    'transitionIn'      : 'none',
    'transitionOut'     : 'none',
    'type'              : 'iframe',
    'hideOnOverlayClick': false,
    afterClose: function () {    
    	parent.location.reload(true);
    }
});

function approve(id) {	
	var xhttp; 
	xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
	if (this.readyState == 4 && this.status == 200) {
	location.reload();
	}
	};
	xhttp.open("GET", "<%=request.getContextPath()%>/DeleteSalStr111?info="+id, true);
	xhttp.send();
	
}

$(function() {
	$("#EmpName").autocomplete({
		source : function(request, response) {
			if(document.getElementById('EmpName').value.trim().length>=2)
			$.ajax({
				url : "get-employee.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field :"ManageEmployeeStructure"
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value,
							empid : item.empid,										
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
        		
            	$("#EmpId").val(""); 
    			$("#EmpName").val("");     			 	
            }
            else{
            	$("#EmpId").val(ui.item.empid);
            	$("#EmpName").val(ui.item.value);            	      	 
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

</script>
<script type="text/javascript">
function promote(id){
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/vieweditpage",
	    data:  { 
	    	"uid" : id
	    },
	    success: function (response) {
			window.location = "<%=request.getContextPath()%>/promoteemployee.html";
        },
	});
}
	function vieweditpage(id,page){
		$.ajax({
		    type: "POST",
		    url: "<%=request.getContextPath()%>/vieweditpage",
		    data:  { 
		    	"uid" : id
		    },
		    success: function (response) {
<%-- 	        	if(page=="view") window.location = "<%=request.getContextPath()%>/ViewSalaryStructure.html"; --%>
	        	if(page=="edit") window.location = "<%=request.getContextPath()%>/EditSalaryStructure.html";
	        },
		});
	}
	</script>
<script type="text/javascript">	
	$('#cancelpopup').click(function(){
		  $.fancybox.close();
	});
</script>
<script type="text/javascript">	
	$('#cancelpopup1').click(function(){
		  $.fancybox.close();
	});
</script>
</body>
</html>