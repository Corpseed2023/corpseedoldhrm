<%@page import="company_master.CompanyMaster_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Manage Company</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%
String token= (String)session.getAttribute("uavalidtokenno");
String userrole=(String)session.getAttribute("emproleid");
String name=(String)session.getAttribute("mcname");
String from=(String)session.getAttribute("mcfrom");
String to=(String)session.getAttribute("mcto");

if(name==null||name=="")name="NA";
if(from==null||name=="")from="NA";
if(to==null||name=="")to="NA";
%>

<%if(!MC00){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
<div class="main-content">
<div class="container">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="menuDv partner-slider8">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="top_title text-center">
<h2>Manage Company</h2>
</div>
<%if(RC00&&userrole.equalsIgnoreCase("super admin")){%><a class="add_btn sub-btn1" href="<%=request.getContextPath() %>/register-company.html">Register Company</a><%} %>
</div>
</div>

<div class="home-search-form clearfix">
<form action="<%=request.getContextPath() %>/manage-company.html" method="post">
<div class="item-bestsell col-md-3 col-sm-3 col-xs-12">
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-user"></i></span>
<input type="text" name="name" id="name" placeholder="Org. Name" class="form-control" <% if(!name.equalsIgnoreCase("NA")){ %>value="<%=name%>"<%}%>>
</div>
</div>
<div class="item-bestsell col-md-2 col-sm-3 col-xs-12">
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-calendar"></i></span>
<input type="text" name="from" id="from" placeholder="From" class="form-control searchdate readonlyAllow" <% if(!from.equalsIgnoreCase("NA")){ %>value="<%=from%>"<%}%> readonly="readonly">
</div>
</div>
<div class="item-bestsell col-md-2 col-sm-3 col-xs-12">
<div class="input-group">
<span class="input-group-addon"><i class="form-icon fa fa-calendar"></i></span>
<input type="text" name="to" id="to" placeholder="To" class="form-control searchdate readonlyAllow" <% if(!to.equalsIgnoreCase("NA")){ %>value="<%=to%>"<%}%> readonly="readonly">
</div>
</div>
<div class="item-bestsell col-md-2 col-sm-2 col-xs-12">
<button class="btn-link-default bt-radius" type="submit" name="button" value="Search"><i class="fa fa-search" title="Search"></i></button>
<button class="btn-link-default bt-radius" type="submit" name="button" value="Reset"><i class="fa fa-refresh" title="Reset"></i></button>
</div>
</form>
</div>
<%@ include file="../staticresources/includes/skelton.jsp" %>  
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix">
<div class="box-width1 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">SN</p>
</div>
</div>
<div class="box-width3 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Company Name</p>
</div>
</div>
<div class="box-width2 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Mobile No.</p>
</div>
</div>
<div class="box-width3 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Email Id</p>
</div>
</div>
<div class="box-width3 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Bank Account Name</p>
</div>
</div>
<div class="box-width14 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Bank A/C No</p>
</div>
</div>
<div class="box-width5 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p class="news-border">Bank IFSC Code</p>
</div>
</div>
<div class="box-width16 col-xs-1 box-intro-bg">
<div class="box-intro-border">
<p>Actions</p>
</div>
</div>
</div>
</div>
</div>
<div id="ref">
<%
String[][] company= CompanyMaster_ACT.getAllCompany(token, userrole, name, from, to);
for(int i=0;i<company.length;i++)
{
%>
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="clearfix" <% if(company[i][9].equalsIgnoreCase("0")){%>style="background-color: #4a6182;color:#fff; "<%}%>>
<div class="box-width1 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=company.length-i%>"><%=company.length-i%></p>
</div>
</div>
<div class="box-width3 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=company[i][1] %>"><%=company[i][1] %></p>
</div>
</div>
<div class="box-width2 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=company[i][10] %>"><%=company[i][10] %></p>
</div>
</div>
<div class="box-width3 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=company[i][11] %>"><%=company[i][11] %></p>
</div>
</div>
<div class="box-width3 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border"  title="<%=company[i][6] %>"><%=company[i][6] %></p>
</div>
</div>
<div class="box-width14 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=company[i][7] %>"><%=company[i][7] %></p>
</div>
</div>
<div class="box-width5 col-xs-1 box-intro-background">
<div class="link-style12">
<p class="news-border" title="<%=company[i][8] %>"><%=company[i][8] %></p>
</div>
</div>
<div class="box-width16 col-xs-1 box-intro-background">
<div class="link-style12">
<p>
<%if(MC01){ %><a class="fancybox" href="<%=request.getContextPath()%>/viewcompany-<%=company[i][0]%>.html"><i class="fa fa-eye" title="View"></i></a><%} %>
<%if(MC02){ %><a href="javascript:void(0);" onclick="vieweditpage(<%=company[i][0] %>);"><i class="fa fa-edit" title="Edit"></i></a><%} %>
<%if(MC03||MC04){ %><a class="quick-view" href="#managecompany" onclick="document.getElementById('userid').innerHTML='<%=company[i][0]%>';document.getElementById('userid1').innerHTML='<%=company[i][12]%>';"> <i class="fa fa-trash" title="Activate/Deactivate this company"></i></a><%} %>
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
</div>
<section class="clearfix" id="managecompany" style="display: none;">
<div class="clearfix  text-center">
<div class="col-md-12 col-xs-12" id="userid" style="display: none;"></div>
<div class="col-md-12 col-xs-12" id="userid1" style="display: none;"></div>
<div class="col-md-12 col-xs-12">
<div class="box-intro1">
  <h2><span class="title">Activate/Deactivate/Delete this Company ?</span></h2>
</div>
</div>
<div class="col-md-12 col-xs-12 mb10">
<a class="sub-btn1" onclick="" id="cancelpopup">Cancel</a>

<%if(MC03){ %><a class="sub-btn1 mlft10" id="activate" onclick="return approve(document.getElementById('userid').innerHTML,document.getElementById('userid1').innerHTML,'1');" title="Activate this company">Activate</a><%} %>
<%if(MC03){ %><a class="sub-btn1 mlft10" id="deactivate" onclick="return approve(document.getElementById('userid').innerHTML,document.getElementById('userid1').innerHTML,'0');" title="Deactivate this company">Deactivate</a><%} %>
<%if(MC04){ %><a class="sub-btn1 mlft10" onclick="" title="Delete this company">Delete</a><%} %>
</div>
</div>
</section>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div></div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">

function approve(id,id1,status) {
	showLoader();
var xhttp;
xhttp = new XMLHttpRequest();
xhttp.onreadystatechange = function() {
if (this.readyState == 4 && this.status == 200) {
// 	$("#ref").load(location.href + " #ref");
location.reload();
}
};
xhttp.open("GET", "<%=request.getContextPath()%>/DeleteCompany111?info="+id+"&id1="+id1+"&status="+status, true);
xhttp.send();
hideLoader();
}
</script>
<script type="text/javascript">
function vieweditpage(id){
	showLoader();
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/vieweditpage",
	    data:  { 
	    	"uid" : id
	    },
	    success: function (response) {
        	window.location = "<%=request.getContextPath()%>/editcompany.html";
        },
        complete : function(data){
			hideLoader();
		}
	});
}

$(function() {
	$("#name").autocomplete({
		source : function(request, response) {
			if(document.getElementById('name').value.trim().length>=2)
			$.ajax({
				url : "get-company-details.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field :"name"
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
        		
            	$("#name").val("");     	
            }
            else{
            	$("#name").val(ui.item.value);
            	
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

</script>
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
</script>
<script type="text/javascript">	
	$('#activate').click(function(){
		  $.fancybox.close();
	});
</script>
<script type="text/javascript">	
	$('#deactivate').click(function(){
		  $.fancybox.close();
	});
</script>
</body>
</html>