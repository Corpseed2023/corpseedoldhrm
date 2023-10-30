<%@page import="admin.task.TaskMaster_ACT"%>
<%@page import="admin.seo.SeoOnPage_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Manage SEO</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>

</head>
<body>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%
String userroll= (String)session.getAttribute("emproleid");
String loginuaid = (String)session.getAttribute("loginuaid");
String projectname = (String) session.getAttribute("projectname");
String activitytype = (String) session.getAttribute("activitytype");
String token=(String)session.getAttribute("uavalidtokenno");
String from = (String) session.getAttribute("from");
String to = (String) session.getAttribute("to");
String nature = (String) session.getAttribute("nature");
String keyword = (String) session.getAttribute("keyword");
String taskname = (String) session.getAttribute("taskname");
String[][] seo=SeoOnPage_ACT.getAllseo(loginuaid,userroll,"LIMIT 25",projectname,activitytype,token, from, to, nature, keyword, taskname);
String[][] activity = SeoOnPage_ACT.getActivityByID();
%>
<%if(!MS04){%><jsp:forward page="/login.html" /><%} %>
    
<div id="content">  
  <div class="main-content">
      <div class="container">
          <div class="row">
              <div class="col-md-12 col-sm-12 col-xs-12">
                  <div class="menuDv partner-slider8">                      
                      <div class="row">
					<div class="col-md-12 col-sm-12 col-xs-12">
					<div class="top_title text-center">
					<h2>Manage SEO</h2>
					</div>
					<%if(MS03){%><a class="add_btn sub-btn1" href="<%=request.getContextPath() %>/off-page-seo-techniques.html">SEO Off Page</a><%} %>
					</div>
					</div>
                      <form name="RefineSearchenqu" action="<%=request.getContextPath()%>/manage-seo.html" method="Post">
                        <input type="hidden" name="pageName" id="pageName"  value="manageservice.jsp">
                          <input type="hidden" name="jsstype" id="jsstype">
                          <div class="home-search-form clearfix">
                          <div class="item-bestsell box-width9 col-md-2 col-sm-2 col-xs-12">
                            <div class="input-group">
                              <% if(projectname!=null){ %>
                              <p><input type="text" name="projectname" autocomplete="off" id="projectname" value="<%=projectname%>" placeholder="Select Project" class="form-control"/></p>
                              <%}else{ %>
                              <p><input type="text" name="projectname" autocomplete="off" id="projectname" placeholder="Select Project" class="form-control"/></p>
                              <%} %>
                            </div>
                          </div>
                          <div class="item-bestsell box-width9 col-md-2 col-sm-2 col-xs-12">
                            <div class="input-group">
                              <% if(taskname!=null){ %>
                              <p><input type="text" name="taskname" autocomplete="off" id="taskname" value="<%=taskname%>" placeholder="Select Task" class="form-control"/></p>
                              <%}else{ %>
                              <p><input type="text" name="taskname" autocomplete="off" id="taskname" placeholder="Select Task" class="form-control"/></p>
                              <%} %>
                            </div>
                          </div>
                          <div class="item-bestsell box-width9 col-md-2 col-sm-2 col-xs-12">
                            <div class="input-group">
                            <select name="activitytype" id="activitytype" class="form-control">
                                  <option value="">Please Select an Activity</option>
                                  <%for(int i=0;i<activity.length;i++){
                                      if(activitytype!=null && activitytype.equalsIgnoreCase(activity[i][1])){ %>
                                          <option value="<%=activity[i][1] %>" selected="selected"><%=activity[i][0]%></option>
                                      <%}else{ %>
                                          <option value="<%=activity[i][1] %>"><%=activity[i][0] %></option>
                              <%}}%>
                              </select>
                            </div>
                          </div>
                          <div class="item-bestsell box-width12 col-md-2 col-sm-2 col-xs-12">
                          <div class="input-group">
                          <p>
                          <select name="nature" id="nature" class="form-control">
                          <% if(nature!=null){ %>
                          <option value="<%=nature%>"><%=nature%></option>
                          <% } %>
                          <option value="">Select Nature</option>
                          <option value="Dofollow">Dofollow</option>
                          <option value="Nofollow">Nofollow</option>
                          <option value="Not Sure">Not Sure</option>
                          </select>
                          </p>
                          </div>
                          </div>
                          <div class="item-bestsell box-width16 col-md-2 col-sm-2 col-xs-12">
                          <div class="input-group">
                          <% if(from!=null){ %>
                          <p><input type="text" name="from" id="from" value="<%=from%>" placeholder="From" class="form-control searchdate" autocomplete="off" /></p>
                          <%}else{ %>
                          <p><input type="text" name="from" id="from" placeholder="From" class="form-control searchdate"  autocomplete="off" /></p>
                          <%} %>
                          </div>
                          </div>
                          <div class="item-bestsell box-width16 col-md-2 col-sm-2 col-xs-12">
                          <div class="input-group">
                          <% if(to!=null){ %>
                          <p><input type="text" name="to" id="to" value="<%=to%>" placeholder="To" class="form-control searchdate"  autocomplete="off" /></p>
                          <%}else{ %>
                          <p><input type="text" name="to" id="to" placeholder="To" class="form-control searchdate"  autocomplete="off" /></p>
                          <%} %>
                          </div>
                          </div>
                          <div class="item-bestsell box-width12 col-md-2 col-sm-2 col-xs-12">
                          <div class="input-group">
                          <% if(keyword!=null){ %>
                          <p><input type="text" name="keyword" id="keyword" value="<%=keyword%>" placeholder="Keyword" class="form-control"/></p>
                          <%}else{ %>
                          <p><input type="text" name="keyword" id="keyword" placeholder="Keyword" class="form-control"/></p>
                          <%} %>
                          </div>
                          </div>
                          <div class="item-bestsell box-width2 col-md-2 col-sm-2 col-xs-12">
                          <input class="btn-link-default bt-radius" type="button"  value="Search"  onclick="RefineSearchenquiry()"/>
                          </div>
                        </div>
                      </form>                             
                      <div class="row">
                        <div class="col-md-12 col-sm-12 col-xs-12">
                         <div class="clearfix box-intro-bg">
                          <div class="box-width1 col-xs-1 box-intro-bg">
                              <div class="box-intro-border">
                              <p class="news-border">SN</p>
                              </div>
                          </div>
                          <div class="box-width12 col-xs-1 box-intro-bg">
                              <div class="box-intro-border">
                              <p class="news-border">Date</p>
                              </div>
                          </div>
                          <div class="box-width3 col-xs-1 box-intro-bg">
                              <div class="box-intro-border">
                              <p class="news-border">Project Name</p>
                              </div>
                          </div>
                          <div class="box-width14 col-xs-1 box-intro-bg">
                              <div class="box-intro-border">
                              <p class="news-border">Target URL</p>
                              </div>
                          </div>
                          <div class="box-width14 col-xs-1 box-intro-bg">
                              <div class="box-intro-border">
                              <p class="news-border">Submit URL</p>
                              </div>
                          </div>
                          
                          <div class="box-width5 col-xs-1 box-intro-bg">
                              <div class="box-intro-border">
                              <p class="news-border">Keyword</p>
                              </div>
                          </div>
                          <div class="box-width20 col-xs-1 box-intro-bg">
                              <div class="box-intro-border">
                              <p class="news-border">Engine</p>
                              </div>
                          </div>
                          <div class="box-width20 col-xs-1 box-intro-bg">
                              <div class="box-intro-border">
                              <p class="news-border">Status</p>
                              </div>
                          </div>
                          <div class="box-width20 col-xs-1 box-intro-bg">
                              <div class="box-intro-border">
                              <p class="news-border">Nature</p>
                              </div>
                          </div>
                          <div class="box-width22 col-xs-1 box-intro-bg">
                              <div class="box-intro-border">
                              <p>Action</p>
                              </div>
                          </div>
                         </div>
                        </div>
                       </div>
                      <div id="target">
                      <%
                       for(int i=0;i<seo.length;i++) {                    	   
                       %>
                      <div class="row">
                        <div class="col-md-12 col-sm-12 col-xs-12">
                         <div class="clearfix">
                          <div class="box-width1 col-xs-1 box-intro-background">
                              <div class="link-style12">
                              <p class="news-border" title="<%=seo.length-i%>"><%=seo.length-i%></p>
                              </div>
                          </div>
                          <div class="box-width12 col-xs-1 box-intro-background">
                              <div class="link-style12">
                              <p class="news-border" title="<%=seo[i][10] %>"><%=seo[i][10] %></p>
                              </div>
                          </div>
                          <div class="box-width3 col-xs-1 box-intro-background">
                              <div class="link-style12">
                              <p class="news-border" title="<%=seo[i][11] %>"><%=seo[i][11] %></p>
                              </div>
                          </div>
                          <div class="box-width14 col-xs-1 box-intro-background">
                              <div class="link-style12">
                              <p class="news-border" title="<%=seo[i][2] %>"><%=seo[i][2] %></p>
                              </div>
                          </div>
                          <div class="box-width14 col-xs-1 box-intro-background">
                              <div class="link-style12">
                              <p class="news-border" title="<%=seo[i][7] %>"><%=seo[i][7] %></p>
                              </div>
                          </div>                          
                          <div class="box-width5 col-xs-1 box-intro-background">
                              <div class="link-style12">
                              <p class="news-border" title="<%=seo[i][8] %>"><%=seo[i][8] %></p>
                              </div>
                          </div>
                          <div class="box-width20 col-xs-1 box-intro-background">
                              <div class="link-style12">
                              <p class="news-border" title="<%=seo[i][3] %>"><%=seo[i][3] %></p>
                              </div>
                          </div>
                          <div class="box-width20 col-xs-1 box-intro-background">
                              <div class="link-style12">
                              <p class="news-border" title="<%=seo[i][5] %>"><%=seo[i][5] %></p>
                              </div>
                          </div>
                          <div class="box-width20 col-xs-1 box-intro-background">
                              <div class="link-style12">
                              <p class="news-border" title="<%=seo[i][6] %>"><%=seo[i][6] %></p>
                              </div>
                          </div>
                          <div class="box-width22 col-xs-1 box-intro-background">
                              <div class="link-style12">
                              <p>
                              <%if(MST00){ %><a class="fancybox" href="<%=request.getContextPath()%>/view-seo.html" onclick="vieweditpage(<%=seo[i][1]%>,'view');"><i class="fa fa-eye" title="view"></i></a><%} %>
                              <%if(MST01){ %><a href="javascript:void(0);" onclick="vieweditpage(<%=seo[i][1]%>,'edit');"><i class="fa fa-edit" title="edit"></i></a><%} %>
                              <%if(MST02){ %><a href="javascript:void(0);" onclick="approve(<%=seo[i][1]%>)"> <i class="fa fa-trash" title="delete"></i></a><%} %>
                              </p>
                              </div>
                          </div>
                         </div>
                        </div>
                      </div>
                    <% }%>
                 </div>
              </div>
          </div>
      </div>
  </div>
</div>
<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
<p id="end" style="display:none;"></p>
</div>	
</div>
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
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
	if(confirm("Sure you want to Delete this SEO ? "))
	{
	var xhttp; 
	xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
	if (this.readyState == 4 && this.status == 200) {
	location.reload();
	}
	};
	xhttp.open("GET", "<%=request.getContextPath()%>/DeleteSeo111?info="+id, true);
	xhttp.send();
	}
}
</script>
<script>
function RefineSearchenquiry() {
	document.RefineSearchenqu.jsstype.value="SSEqury";
	document.RefineSearchenqu.action="<%=request.getContextPath()%>/manage-seo.html";
	document.RefineSearchenqu.submit();
}

$(function() {
	$("#projectname").autocomplete({
		source: function(request, response) {
		$.ajax({
		url: "getprojectname.html",
		type: "POST",
		dataType: "json",
		data: {	name: request.term, cid : "NA"},
		success: function( data ) {			
		response( $.map( data, function( item ) {
			return {
				label: item.name,
				value: item.value,
				id: item.id,
		};}));},
		error: function (error) {
		   alert('error: ' + error);
		}});},
		select : function(e, ui) {
			$("#pid").val(ui.item.id);
		},});
	});

$(function() {
	$("#taskname").autocomplete({
	source: function(request, response) {
	$.ajax({
	url: "gettaskname.html",
	type: "POST",
	dataType: "json",
	data: {	name: request.term},
	success: function( data ) {
	response( $.map( data, function( item ) {
	return {
	label: item.name,
	value: item.value,
	};}));},
	error: function (error) {
	alert('error: ' + error);
	}});}});
	});
</script>
<script>
$(function() {
	$("#date").datepicker({
		changeMonth: true,
		changeYear: true,
		dateFormat: 'yy-mm-dd'
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
function appendData() {
    var html = '';
    if(document.getElementById("end").innerHTML=="End") return false;
    $.ajax({
    	type: "POST",
        url: '<%=request.getContextPath()%>/getmoreseo',
        datatype : "json",
        data: {
        	counter:counter,
        	userroll:'<%=userroll%>',
        	loginuaid:'<%=loginuaid%>',
        	projectname:'<%=projectname%>',
        	activitytype:'<%=activitytype%>',
        	from:'<%=from%>',
        	to:'<%=to%>',
        	nature:'<%=nature%>',
        	keyword:'<%=keyword%>'
        	},
        success: function(data){
        	for(i=0;i<data[0].seo.length;i++)
            	html += '<div class="row"><div class="col-md-12 col-sm-12 col-xs-12"><div class="clearfix"><div class="box-width1 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].seo[i][1]+'</p></div></div><div class="box-width5 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].seo[i][0]+'</p></div></div><div class="box-width14 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].seo[i][2]+'</p></div></div><div class="box-width14 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].seo[i][7]+'</p></div></div><div class="box-width7 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].seo[i][4]+'</p></div></div><div class="box-width5 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].seo[i][8]+'</p></div></div><div class="box-width20 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].seo[i][3]+'</p></div></div><div class="box-width20 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].seo[i][5]+'</p></div></div><div class="box-width20 col-xs-1 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].seo[i][6]+'</p></div></div><div class=" box-intro-background"><div class="link-style12"><p><a href="javascript:void(0);"onclick="vieweditpage('+data[0].seo[i][1]+');">Edit</a><a href="javascript:void(0);"onclick="approve('+data[0].seo[i][1]+')"> Delete</a></p></div></div></div></div></div>';
            if(html!='') $('#target').append(html);
            else document.getElementById("end").innerHTML = "End";
        },
        error: function(error){
        	console.log(error.responseText);
        }
    });
    counter=counter+25;
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
        	if(page=="edit") window.location = "<%=request.getContextPath()%>/editseo.html";
        },
	});
}
</script>
</body>
</html>