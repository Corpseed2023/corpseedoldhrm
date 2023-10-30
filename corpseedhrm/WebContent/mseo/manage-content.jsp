<%@page import="admin.seo.SeoOnPage_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title>Manage Content</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
	
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	<%
	String token=(String)session.getAttribute("uavalidtokenno");
String[][] content=SeoOnPage_ACT.getAllcontent(token);
%>
<%if(!MS06){%><jsp:forward page="/login.html" /><%} %>
	<div id="content">		
		<div class="main-content">
			<div class="container">
				<div class="row">
                	<div class="col-md-12 col-sm-12 col-xs-12">
                        <div class="menuDv partner-slider8">                        	
                     <div class="row">
					<div class="col-md-12 col-sm-12 col-xs-12">
					<div class="top_title text-center">
					<h2>Manage Content</h2>
					</div>
					<%if(MS05){%><a class="add_btn sub-btn1" href="<%=request.getContextPath() %>/content.html">Add Content</a><%} %>
					</div>
					</div>
                            <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix box-intro-bg">
                            	<div class="box-width25 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">SN</p>
                                    </div>
                                </div>
                                <div class="box-width8 col-xs-1 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Date</p>
                                    </div>
                                </div>
                                <div class="box-width27 col-xs-3 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Project Name</p>
                                    </div>
                                </div>
                              
                                <div class="box-width19 col-xs-3 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Activity</p>
                                    </div>
                                </div>
                               
                                <div class="box-width5 col-xs-3 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Status</p>
                                    </div>
                                </div>
                                <div class="box-width2 col-xs-3 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p>Action</p>
                                    </div>
                                </div>
                               </div>
                              </div>
                             </div>
                             <%
                             for(int i=0;i<content.length;i++)
                             {
                             %>
                          
                            <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix">
                            	<div class="box-width25 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=content.length-i%></p>
                                    </div>
                                </div>
                                <div class="box-width8 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=content[i][4] %></p>
                                    </div>
                                </div>
                                <div class="box-width27 col-xs-3 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=content[i][0] %></p>
                                    </div>
                                </div>
                                <div class="box-width19 col-xs-1 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=content[i][2] %></p>
                                    </div>
                                </div>
                                <div class="box-width5 col-xs-3 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=content[i][3] %></p>
                                    </div>
                                </div>
                                <div class="box-width2 col-xs-3 box-intro-background">
                                	<div class="link-style12">
                                    <p>
<%--                                     <a href="javascript:void(0);" onclick="vieweditpage(<%=content[i][1] %>);"><i class="fa fa-eye" title="view"></i></a> --%>
<%--                                     <a href="javascript:void(0);" onclick="approve(<%=content[i][1] %>)"> <i class="fa fa-trash" title="delete"></i></a> --%>
                                    <%if(MCV00){ %><a href="javascript:void(0);" ><i class="fa fa-eye" title="view"></i></a><%} %>
                                    <%if(MCV01){ %><a href="javascript:void(0);" onclick="vieweditpage(<%=content[i][1] %>);"><i class="fa fa-edit" title="edit"></i></a><%} %>
                                    <%if(MCV02){ %><a href="javascript:void(0);"  onclick="approve(<%=content[i][1] %>)"> <i class="fa fa-trash" title="delete"></i></a><%} %>
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
	</div>
	<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
	<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
    <script type="text/javascript">
    function approve(id) {
    	if(confirm("Sure you want to Delete this Content ? "))
    	{
    	var xhttp; 
    	xhttp = new XMLHttpRequest();
    	xhttp.onreadystatechange = function() {
    	if (this.readyState == 4 && this.status == 200) {
    	location.reload();
    	}
    	};
    	xhttp.open("GET", "<%=request.getContextPath()%>/DeleteContent111?info="+id, true);
    	xhttp.send();
    	}
    }
    </script>
    <script type="text/javascript">
	function vieweditpage(id){
    	$.ajax({
    	    type: "POST",
    	    url: "<%=request.getContextPath()%>/vieweditpage",
    	    data:  { 
    	    	"uid" : id
    	    },
    	    success: function (response) {
            	window.location = "<%=request.getContextPath()%>/editcontent.html";
            },
    	});
    }
	</script>
</body>
</html>