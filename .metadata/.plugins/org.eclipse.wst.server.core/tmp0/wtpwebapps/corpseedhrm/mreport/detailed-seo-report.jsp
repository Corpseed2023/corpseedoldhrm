<%@page import="admin.report.Report_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title>Detailed SEO Report</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	<%
String landingpage_basepath = request.getContextPath();
String landingpage_basePath = request.getScheme()+"://"+request.getServerName()+":8080"+landingpage_basepath+"/";
String uaemprole = (String) session.getAttribute("emproleid");
String pid = (String)session.getAttribute("pid");
String datefrom = (String)session.getAttribute("datefrom");
%>
	<!-- End Header -->
    
	<div id="content">
		<div class="container">   
          <div class="bread-crumb">
            <div class="bd-breadcrumb bd-light">
            <a href="">Home</a>
            <a>Detailed SEO Report</a>
            </div>
          </div>
        </div>

		<div class="main-content">
			<div class="container">
				<div class="row">
                	<div class="col-md-12 col-sm-12 col-xs-12">
                        <div class="menuDv partner-slider8">
                        	<div class="box-intro">
                              <h2><span class="title">Detailed SEO Report</span></h2>
                            </div>
                            <form name="RefineSearchenqu" action="<%=request.getContextPath()%>/detailed-seo-report.html" method="Post">
                            <input type="hidden" name="pageName" id="pageName"  value="manageservice.jsp">
							<input type="hidden" name="jsstype" id="jsstype">
                              <div class="home-search-form clearfix">
                                <div class="item-bestsell box-width18 col-md-3 col-sm-3 col-xs-12">
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="hidden" readonly name="pid" id="pid" value="<%=pid%>">
                                  <input type="text" name="ProjectName" autocomplete="off" id="Project_Name" placeholder="Enter Project Name" class="form-control">
                                  </div>
                                </div>
                                <div class="item-bestsell box-width18 col-md-3 col-sm-3 col-xs-12">
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon fa fa-calendar"></i></span>
                                  <select name="datefrom" id="datefrom" class="form-control">
                                  <option value="">Select Date</option>
                                  <%-- <% String[][] dates = Report_ACT.getActDates(pid);
                                  for(int j=0;j<dates.length;j++){%>
                                  <option value="<%=dates[j][0] %>"><%=dates[j][0] %></option>
                                  <% } %> --%>
                                  </select>
                                  </div>
                                </div>
                                <div class="item-bestsell box-width18 col-md-2 col-sm-2 col-xs-12">
                                <input class="btn-link-default bt-radius" type="submit" onclick="RefineSearchenquiry()" value="Show">
                                </div>
                              </div>
                            </form>
                            <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix">
                            	<div class="box-width24 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">SN</p>
                                    </div>
                                </div>
                                <div class="box-width17 col-md-3 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Keyword</p>
                                    </div>
                                </div>
                                <div class="box-width23 col-md-4 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Target URL</p>
                                    </div>
                                </div>
                                <div class="box-width2 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Google</p>
                                    </div>
                                </div>
                                <div class="box-width2 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Yahoo</p>
                                    </div>
                                </div>
                                <div class="box-width2 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Bing</p>
                                    </div>
                                </div>
                                <div class="box-width21 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="">+</p>
                                    </div>
                                </div>
                               </div>
                              </div>
                            </div>
                            <%
                                                       
                            String[][] reportData=Report_ACT.getAllReport(pid,datefrom,"NA");
                            
                            for(int i=0;i<reportData.length;i++)
                            {
                            %>
                            <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix">
                            	<div class="box-width24 col-xs-12 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=i+1%></p>
                                    </div>
                                </div>
                                <div class="box-width17 col-md-3 col-xs-12 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=reportData[i][0] %></p>
                                    </div>
                                </div>
                                <div class="box-width23 col-md-4 col-xs-12 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=reportData[i][4] %></p>
                                    </div>
                                </div>
                                <div class="box-width2 col-xs-12 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=reportData[i][1] %></p>
                                    </div>
                                </div>
                                <div class="box-width2 col-xs-12 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=reportData[i][2] %></p>
                                    </div>
                                </div>
                                <div class="box-width2 col-xs-12 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=reportData[i][3] %></p>
                                    </div>
                                </div>
                                <div class="box-width21 col-xs-12 box-intro-background">
                                	<div class="link-style12">
                                    <p class="">
                                    <% if(uaemprole.equals("Administrator")){ %><input type="button" value="+" onclick="getAct(<%=i+1%>,'<%=reportData[i][0] %>');"  style="border: none;"><% } %>
                                   </p>
                                    </div>
                                </div>
                               </div>
                              </div>
                              </div>
                              <div class="slide<%=i+1%>" style="display: none;">
                              <%
                              String keyword = (String)session.getAttribute("rkkey");
                              String[][] moreReportData = Report_ACT.moreReportData(keyword);
                              %>
                              <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix">
                            	<div class="col-md-1 col-sm-1 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Date</p>
                                    </div>
                                </div>
                                <div class="col-md-2 col-sm-2 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Activity Type</p>
                                    </div>
                                </div>
                                <div class="col-md-5 col-sm-5 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Submitted On URL</p>
                                    </div>
                                </div>
                                <div class="col-md-2 col-sm-2 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p class="news-border">Search Engine</p>
                                    </div>
                                </div>
                                <div class="col-md-2 col-sm-2 col-xs-12 box-intro-bg">
                                	<div class="box-intro-border">
                                    <p>Added By</p>
                                    </div>
                                </div>
                               </div>
                              </div>
                              </div>
                              <%
                              for(int j=0;j<moreReportData.length;j++)
                              {
                              %>
                              <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                               <div class="clearfix">
                            	<div class="col-md-1 col-sm-1 col-xs-12 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=moreReportData[j][4]%></p>
                                    </div>
                                </div>
                                <div class="col-md-2 col-sm-2 col-xs-12 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=moreReportData[j][0]%></p>
                                    </div>
                                </div>
                                <div class="col-md-5 col-sm-5 col-xs-12 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=moreReportData[j][1]%></p>
                                    </div>
                                </div>
                                <div class="col-md-2 col-sm-2 col-xs-12 box-intro-background">
                                	<div class="link-style12">
                                    <p class="news-border"><%=moreReportData[j][2]%></p>
                                    </div>
                                </div>
                                <div class="col-md-2 col-sm-2 col-xs-12 box-intro-background">
                                	<div class="link-style12">
                                    <p><%=moreReportData[j][3]%></p>
                                    </div>
                                </div>
                               </div>
                              </div>
                              </div>
                              <% } %>
                              </div>
                            <%}
                            session.removeAttribute("rkkey");
                            %>
					</div>
				</div>
			</div>
		</div>
	</div>
	</div>
	<%@ include file="../staticresources/includes/itswsfooter.jsp" %>
</div>	
	<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
$(function() {
	$("#Project_Name").autocomplete({
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
	    	sessionStorage.setItem("pname",ui.item.label);
	    	approve(ui.item.id);
		},});
	});
	
function approve(pid) {
	$.ajax({
    	url:'getdates.html',
        method:'GET',
        data:{pid: pid},
        dataType:'json',
        success:function(response){
        	var html;
             var $select = $('#datefrom');
             $.each(response.arrayName, function(options, values) {
              html += '<option name="' + values.rkdate + '" >'+ values.rkdate +'</option>';
             });
            $select.html(html);
        },
        error:function(response){
        	alert(JSON.stringify(response));
        }
    });
	}
	
function getAct(id,keyword){
	var xhttp; 
	xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
	if (this.readyState == 4 && this.status == 200) {
		sessionStorage.setItem("id", id);
		window.location.reload();
	} 
	};
	xhttp.open("GET", "<%=landingpage_basepath%>/showActivity111?keyword="+keyword, true);
	xhttp.send(keyword);
};

function RefineSearchenquiry() {
	document.RefineSearchenqu.jsstype.value="SSEqury";
	document.RefineSearchenqu.action="<%=request.getContextPath()%>/detailed-seo-report.html";
	document.RefineSearchenqu.submit();
}

window.onload = function() {
    var id = sessionStorage.getItem("id");
    	$('.slide'+id).slideDown("fast");
    	sessionStorage.removeItem("id");
    	
    var pname = sessionStorage.getItem("pname");
    	if(pname!=null) document.getElementById("Project_Name").value=pname;
    	sessionStorage.removeItem("pname");
}
</script>
</body>
</html>