<%@page import="Company_Login.CompanyLogin_ACT"%>
<%@page import="admin.report.Report_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>SEO Report</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body onload="getDates();">

<div id="loader"><img src="<%=request.getContextPath()%>/staticresources/images/hrmreportloader.gif" /></div>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%
String pid = (String)session.getAttribute("pid");
String datefrom = (String)session.getAttribute("datefrom");
String dateto = (String)session.getAttribute("dateto");
String projectname = null;
if(pid!=null) projectname = CompanyLogin_ACT.getprojectname(pid);
String[][] reportData2=Report_ACT.getAllClientActivityReport(pid,datefrom, dateto);
String l1 = datefrom;
String l2 = null;
String l3 = null;
String[][] prevdates = Report_ACT.getPrevDates(pid, datefrom);
try{
	l2 = prevdates[0][0];
	l3 = prevdates[1][0];
}
catch(Exception e){}
%>
<%if(!SR02){%><jsp:forward page="/login.html" /><%} %>
    
<div id="content">
    <div class="container">   
      <div class="bread-crumb">
        <div class="bd-breadcrumb bd-light">
        <a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
        <a>SEO Report</a>
        </div>
      </div>
    </div>

    <div class="main-content">
        <div class="container">
            <div class="row">
                <div class="col-md-12 col-sm-12 col-xs-12">
                    <div class="menuDv partner-slider8">
                        <div class="box-intro">
                          <h2><span class="title">SEO Report <% if(dateto!=null){ if(dateto!=""){ %><span>(<%=dateto%> to <%=datefrom%>)</span><%}}%> <span title="This report might generate incorrect result!" style="cursor: help;">[Beta Version]</span></span></h2>
                        </div>
                        <form onsubmit="$('#loader').fadeIn();" action="<%=request.getContextPath()%>/seo-report.html" method="POST" id="showform">
                          <div class="home-search-form clearfix">
                            <div class="item-bestsell box-width18 col-md-3 col-sm-3 col-xs-12">
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                              <input type="hidden" readonly name="pid" id="pid" value="<%=pid%>">
                              <input type="text" name="ProjectName" autocomplete="off" id="Project_Name" placeholder="Enter Project Name" required class="form-control" oninvalid="this.setCustomValidity('Please select a Project')" oninput="setCustomValidity('')" <% if(projectname!=null){ %>value="<%=projectname%>" <% } %>>
                              </div>
                            </div>
                            <div class="item-bestsell box-width18 col-md-3 col-sm-3 col-xs-12">
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-calendar"></i></span>
                              <select name="datefrom" id="datefrom" class="form-control" required oninvalid="this.setCustomValidity('Please select a Date!')" oninput="setCustomValidity('')">
                              <option value="">Select Date</option>
                              </select>
                              </div>
                              <input type="hidden" name="dateto" id="dateto">
                            </div>
                            <div class="item-bestsell box-width18 col-md-2 col-sm-2 col-xs-12">
                            <input class="btn-link-default bt-radius" type="submit" value="Show">
                            </div>
                          </div>
                        </form>
                        <% if(reportData2.length>0){ %>
                        <div class="box-intro">
                          <h2><span class="title">SEO Activities & Activity Report</span></h2>
                        </div>
                         <div class="row">
                          <div class="col-md-12 col-sm-12 col-xs-12">
                           <div class="clearfix">
                            <div class="col-md-2 col-sm-2 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">SN</p>
                                </div>
                            </div>
                            <div class="col-md-6 col-sm-6 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Name Activities</p>
                                </div>
                            </div>
                            <div class="col-md-4 col-sm-4 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Activity</p>
                                </div>
                            </div>
                           </div>
                          </div>
                        </div>
                        <%
                        for(int i=0;i<reportData2.length;i++){
                        %>
                        <div class="row">
                          <div class="col-md-12 col-sm-12 col-xs-12">
                           <div class="clearfix">
                            <div class="col-md-2 col-sm-2 col-xs-12 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><%=i+1%></p>
                                </div>
                            </div>
                            <div class="col-md-6 col-sm-6 col-xs-12 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><%=reportData2[i][0] %></p>
                                </div>
                            </div>
                            <div class="col-md-4 col-sm-4 col-xs-12 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><%=reportData2[i][1] %></p>
                                </div>
                            </div>
                           </div>
                          </div>
                          </div>
                          <% } } %>
                          <% String[][] reportData=Report_ACT.getAllClientReport(pid,l1,l2,l3);
                        String[][] reportl1 = null;String[][] reportl2 = null;String[][] reportl3 = null;
                        if(reportData.length>0){ %>
                          <div class="box-intro">
                          <h2><span class="title">Targeted Keywords & Page Position Report</span></h2>
                        </div>
                        <div style="overflow-y: scroll; overflow-x: hidden; height: 400px;">
                        <div class="row">
                          <div class="col-md-12 col-sm-12 col-xs-12">
                           <div class="clearfix">
                            <div class="col-md-1 col-sm-1 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">SN</p>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-3 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Keyword</p>
                                </div>
                            </div>
                            <div class="col-md-5 col-sm-5 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Target URL</p>
                                </div>
                            </div>
                            <% if(l3!=null&&datefrom!=null){ %>
                            <div class="col-md-1 col-sm-1 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border"><%=l3 %></p>
                                </div>
                            </div>
                            <% } %>
                            <% if(l2!=null&&datefrom!=null){ %>
                            <div class="col-md-1 col-sm-1 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border"><%=l2 %></p>
                                </div>
                            </div>
                            <% } %>
                            <% if(l1!=null&&datefrom!=null){ %>
                            <div class="col-md-1 col-sm-1 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border"><%=l1%></p>
                                </div>
                            </div>
                            <% } %>
                          </div>
                          </div>
                        </div>
                        <%
                        for(int i=0;i<reportData.length;i++){
                            String l1g="-";String l2g="-";String l3g="-";
                                if(l1!=null||!l1.equals("")||!l1.equals("null")) reportl1 = Report_ACT.getl1(pid, reportData[i][0],l1);
                                try{l1g=reportl1[0][0];}catch(Exception e){}
                                if(l2!=null||!l1.equals("null")) reportl2 = Report_ACT.getl2(pid, reportData[i][0],l2);
                                try{l2g=reportl2[0][0];}catch(Exception e){}
                                if(l3!=null||!l1.equals("null")) reportl3 = Report_ACT.getl3(pid, reportData[i][0],l3);
                                try{l3g=reportl3[0][0];}catch(Exception e){}
                        %>
                        <div class="row">
                          <div class="col-md-12 col-sm-12 col-xs-12">
                           <div class="clearfix">
                            <div class="col-md-1 col-sm-1 col-xs-12 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><%=i+1%></p>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-3 col-xs-12 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><input value="<%=reportData[i][0]%>" id="<%=reportData[i][3]%>" class="updatereport" onchange="updatereport('keyword',this.id, this.value);" /></p>
                                </div>
                            </div>
                            <div class="col-md-5 col-sm-5 col-xs-12 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><input value="<%=reportData[i][1]%>" id="<%=reportData[i][3]%>" class="updatereport" onchange="updatereport('targeturl',this.id, this.value);" /></p>
                                </div>
                            </div>
                            <% if(l3!=null){ %>
                            <div class="col-md-1 col-sm-1 col-xs-12 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><%=l3g %></p>
                                </div>
                            </div>
                            <% } %>
                            <% if(l2!=null){ %>
                            <div class="col-md-1 col-sm-1 col-xs-12 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><%=l2g %></p>
                                </div>
                            </div>
                            <% } %>
                            <% if(l1!=null){ %>
                            <div class="col-md-1 col-sm-1 col-xs-12 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><%=l1g %></p>
                                </div>
                            </div>
                            <% } %>
                           </div>
                          </div>
                          </div>
                          <% } %>
                          </div>
                          <% } %>
                          <% if(reportData2.length>0){ %>
                          <div class="box-intro">
                          <h2><span class="title">Activity based Details</span></h2>
                        </div>
                        <div class="clearfix box-intro-background col-md-12">
                        <% for(int y=0;y<reportData2.length;y++){ %>
                            <div class="inline_block" style="margin: 8px 2px;">
                                <a class="pointers" onclick="return getactdata('<%=pid%>','<%=datefrom%>','<%=dateto%>','<%=reportData2[y][0]%>')"><%=reportData2[y][0]%></a>
                            </div>
                        <% } %>
                        </div>
                        <div class="row">
                          <div class="col-md-12 col-sm-12 col-xs-12">
                           <div class="clearfix">
                            <div class="col-md-1 col-sm-1 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">SN</p>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-3 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Keyword</p>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-3 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Target URL</p>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-3 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Submitted URL</p>
                                </div>
                            </div>
                            <div class="col-md-2 col-sm-2 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p>Status</p>
                                </div>
                            </div>
                          </div>
                          </div>
                        </div>
                        <% } %>
                        <div id="target"></div>
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
	    	getDates();
		},});
	});
</script>
<script type="text/javascript">
function getactdata(pid, datefrom, dateto, key){
	var html = '';
	document.getElementById("target").innerHTML="";
	$('#loader').fadeIn();
    $.ajax({
    	type: "POST",
        url: '<%=request.getContextPath()%>/getactivitydata111',
        datatype : "json",
        data: {
        	pid:pid,
        	date:datefrom,
        	date2:dateto,
        	key:key
        },
        success: function(data){
        	for(i=0;i<data[0].actdata.length;i++)
            	html += '<div class="row"><div class="col-md-12 col-sm-12 col-xs-12"><div class="clearfix"><div class="col-md-1 col-sm-1 col-xs-12 box-intro-background"><div class="link-style12"><p class="news-border">'+(Number(i)+1)+'</p></div></div><div class="col-md-3 col-sm-3 col-xs-12  box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].actdata[i][1]+'</p></div></div><div class="col-md-3 col-sm-3 col-xs-12  box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].actdata[i][2]+'</p></div></div><div class="col-md-3 col-sm-3 col-xs-12 box-intro-background"><div class="link-style12"><p class="news-border">'+data[0].actdata[i][3]+'</p></div></div><div class="col-md-2 col-sm-2 col-xs-12 box-intro-background"><div class="link-style12"><p>'+data[0].actdata[i][4]+'</p></div></div></div></div></div>';
            $('#target').append(html);
            $('#loader').fadeOut("slow");
        }
    });
}
</script>
<script type="text/javascript">
$(function(){
	$('#datefrom').on('change', function(){
		var selected_element = $('option:selected');
		$('#dateto').val(selected_element.next().val());
	});
});

function getDates(){
    var $pid=$("#pid").val();
    if($pid==""||$pid=='null') return false;
    $.ajax({
    	url:'GetActivityDates',
        method:'GET',
        data:{pid: $pid},
        dataType:'json',
        success:function(response){
        	var html;
            var $select = $('#datefrom');
            html += '<option value="">Select Date</option>';
            $.each(response.arrayName, function(options, values) {
            	var length = response.arrayName.length-1;
            	if(length==options){
        			html += '<option style="display:none;" value="' + values.rkdate + '">'+ values.rkdate +'</option>';
            	}
            	else{
        			html += '<option value="' + values.rkdate + '">'+ values.rkdate +'</option>';
            	}
            });
            $select.html(html);
        },
        error:function(response){
        	alert("Please try again.");
            location.reload();
        }
    });
}

$(window).load(function() {
	$('#loader').fadeOut("slow");
});

<% String userrole = (String) session.getAttribute("emproleid");
if(userrole.equals("Administrator")){ %>
function updatereport(type, id, newvalue){
    if(confirm("Are you sure you want to Update this?")){
	    $.ajax({
	    	type: "POST",
	        url: '<%=request.getContextPath()%>/UpdateReport',
	        datatype : "json",
	        data: {
	            type:type,
	            id:id,
	            newvalue:newvalue
	        },
	        success: function(data){
	        	alert("Updated!");
	        },
	        error: function(error){
	            alert("Some Error Occured! Please try again.");
	        }
	    });
    }
}
<% } %>
</script>
</body>
</html>