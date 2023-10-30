<%@page import="admin.report.Report_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Update Report</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div id="loader"><img src="<%=request.getContextPath()%>/staticresources/images/hrmreportloader.gif" /></div>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<%
String landingpage_basepath = request.getContextPath();
String uaemprole = (String) session.getAttribute("emproleid");
%> 
<%if(!SR01){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
    <div class="container">   
      <div class="bread-crumb">
        <div class="bd-breadcrumb bd-light">
        <a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
        <a>Update Report</a>
        </div>
      </div>
    </div>

    <div class="main-content">
        <div class="container">
            <div class="row">
                <div class="middle col-md-12 col-sm-12 col-xs-12">
                    <div class="menuDv  partner-slider8">
                        <form method="post" name="addkeywordform" id="addkeywordform">
                         <div class="home-search-form clearfix">
                            <div class="col-md-3 col-sm-3 col-xs-12">
                              <label>Project Name</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                              <input type="hidden" readonly name="pid" id="pid">
                              <input type="text" name="ProjectName" autocomplete="off" id="Project_Name" placeholder="Enter Project Name" class="form-control" onblur="approve();">
                              </div>
                            </div>
                             <div class="col-md-3 col-sm-3 col-xs-12">
                              <label>Date</label>
                              <div class="input-group">
                              <span class="input-group-addon"><i class="form-icon fa fa-calendar"></i></span>
                              <input id="date" name="date" class="form-control" placeholder="Select Date" onchange="requiredFieldValidation('date','dateErrorMSGdiv');">
                              </div>
                              <div id="dateErrorMSGdiv" class="errormsg"></div>
                            </div>
                         </div>
                         
                         <div class="row">
                          <div class="col-md-12 col-sm-12 col-xs-12">
                           <div class="clearfix">
                            <div class="box-width24 col-xs-1 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">SN</p>
                                </div>
                            </div>
                            <div class="box-width17 col-md-3 col-xs-1 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Keyword</p>
                                </div>
                            </div>
                            <div class="box-width29 col-md-6 col-xs-1 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Target URL</p>
                                </div>
                            </div>
                             <div class="box-width25 col-xs-1 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Priority</p>
                                </div>
                            </div>
                            <div class="box-width20 col-xs-1 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Google</p>
                                </div>
                            </div>
                            <div class="box-width20 col-xs-1 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Yahoo</p>
                                </div>
                            </div>
                            <div class="box-width20 col-xs-1 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Bing</p>
                                </div>
                            </div>
                            <div class="box-width2 col-xs-1 box-intro-bg">
                                <div class="box-intro-border">
                                <p>Action</p>
                                </div>
                            </div>
                           </div>
                          </div>
                         </div>
                         <div id="target">
                         <%
                            String pid = (String)session.getAttribute("pid");
                            String[][] getKeywords = Report_ACT.getKeywords(pid);
                            for(int i=0;i<getKeywords.length;i++){
                                String priority = Report_ACT.getPriority(pid,getKeywords[i][0]);
                                if(priority==null) priority="0";
                         %>
                        <div class="row">
                          <div class="col-md-12 col-sm-12 col-xs-12">
                           <div class="clearfix">
                            <div class="box-width24 col-xs-1 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><%=i+1%></p>
                                </div>
                            </div>
                            <div class="box-width17 col-md-3 col-xs-1 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><input type="text" id="key<%=i+1%>" name="key<%=i+1%>" value="<%=getKeywords[i][0]%>" readonly class="update-field"></p>
                                </div>
                            </div>
                            <div class="box-width29 col-md-6 col-xs-1 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><input type="text" id="target<%=i+1%>" name="target<%=i+1%>" value="<%=getKeywords[i][1]%>" readonly class="update-field"></p>
                                </div>
                            </div>
                            <div class="box-width25 col-xs-1 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><input type="number" min="0" id="priority<%=i+1%>" name="priority<%=i+1%>" class="update-field" value="<%=priority%>" onchange="return updatepriority('<%=i+1%>');" <%-- <% if(!uaemprole.equals("Administrator")){ %> readonly="readonly" <% } %> --%>></p>
                                </div>
                            </div>
                            <div class="box-width20 col-xs-1 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><input type="number" min="0" id="google<%=i+1%>" name="google<%=i+1%>" class="update-field"></p>
                                </div>
                            </div>
                            <div class="box-width20 col-xs-1 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><input type="number" min="0" id="yahoo<%=i+1%>" name="yahoo<%=i+1%>" class="update-field"></p>
                                </div>
                            </div>
                            <div class="box-width20 col-xs-1 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><input type="number" min="0" id="bing<%=i+1%>" name="bing<%=i+1%>" class="update-field"></p>
                                </div>
                            </div>
                            <div class="box-width2 col-xs-1 box-intro-background">
                                <div class="link-style12">
                                <p><a href="javascript:void(0);" onClick="update(<%=i+1%>);" id="updated<%=i+1%>"><i class="fa fa-arrow-up"></i></a>
                                <%-- <% if(uaemprole.equals("Administrator")){ %> --%><a href="javascript:void(0);" onClick="deleteact(<%=getKeywords[i][2]%>);" id="delete<%=i+1%>"><i class="fa fa-trash-o"></i></a><%-- <% } %> --%></p>
                                </div>
                            </div>
                           </div>
                          </div>
                          </div>
                          <% }
                          session.removeAttribute("pid");
                          %>
                          <div id="idErrorMSGdiv" class="errormsg text-center" style="color: #800606;"></div>
                          </div>
                        </form>
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
		},});
	});
	
function approve() {
	var pid = document.getElementById('pid').value;
	if(pid=="") return false;
	$('#loader').fadeIn();
	var xhttp; 
	xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
		if (this.readyState == 4 && this.status == 200) {
			$("#target").load("update-report.html #target");
			$('#loader').fadeOut("Slow");
		}
	};
	xhttp.open("GET", "<%=landingpage_basepath %>/updateReportAddSession111?pid="+pid, true);
	xhttp.send(pid);
};	
	
$( function() {
	$("#date").datepicker({
		changeMonth: true,
		changeYear: true,
		dateFormat: 'dd-mm-yy'
	});
});


function update(id){
	var info = id;
	var pid = document.getElementById('pid').value;
	var date= document.getElementById('date').value;
	if(date==''){
		dateErrorMSGdiv.innerHTML = 'Select Date';
		dateErrorMSGdiv.style.color = '#800606';
		return false;
	}
	var key = document.getElementById('key'+info).value;
	var target = document.getElementById('target'+info).value;
	var gid = document.getElementById('google'+info).value;
	if(gid==''||gid==null){
		idErrorMSGdiv.innerHTML = 'Insert into Google';
		document.getElementById('google'+info).style.backgroundColor = "#fcc";
		return false;
	}
	var yid = document.getElementById('yahoo'+info).value;
	if(yid==''||gid==null){
		idErrorMSGdiv.innerHTML = 'Insert into Yahoo';
		document.getElementById('yahoo'+info).style.backgroundColor = "#fcc";
		return false;
	}
	var bid = document.getElementById('bing'+info).value;
	if(bid==''||gid==null){
		idErrorMSGdiv.innerHTML = 'Insert into Bing';
		document.getElementById('bing'+info).style.backgroundColor = "#fcc";
		return false;
	}
	$("#updated"+info).hide();
	$("#delete"+info).hide();
	$.ajax({
		async : false,
		url : "<%=landingpage_basepath%>/addKeywordInfo111",
		type : "GET",
		dataType : 'HTML',
		data : {
			"gid" : gid,
			"yid" : yid,
			"bid" : bid,
			"pid" : pid,
			"date" : date,
			"key" : key,
			"target" : target,
		},
		success : function(response) {
			idErrorMSGdiv.innerHTML = 'Updated!';
		},
		error : function(error) {
		    alert("Please try again.");
		    $("#updated"+info).show();
			$("#delete"+info).show();
		}
	});
}

function updatepriority(id){
	var info = id;
	var pid = document.getElementById('pid').value;
	if(pid==""||pid==null||pid=="null") return false;
	var nonkey = document.getElementById('key'+info).value;
	var key = encodeURIComponent(nonkey);
	var target = document.getElementById('target'+info).value;
	var priority = document.getElementById('priority'+info).value;
	var xhttp; 
	xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
		if (this.readyState == 4 && this.status == 200) {
			$('#priority'+info).prop('readonly', true);
			idErrorMSGdiv.innerHTML = 'Updated!';
		}
	};
	xhttp.open("GET", "<%=landingpage_basepath %>/updatePriority111?pid="+pid+"&key="+key+"&target="+target+"&priority="+priority, true);
	xhttp.send();
}

function deleteact(id) {
	var xhttp; 
	xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
		if (this.readyState == 4 && this.status == 200) {
			$("#target").load("update-report.html #target");
		}
	};
	xhttp.open("GET", "<%=landingpage_basepath%>/DeleteActivity111?id="+id, true);
	xhttp.send();
};
</script>
</body>
</html>