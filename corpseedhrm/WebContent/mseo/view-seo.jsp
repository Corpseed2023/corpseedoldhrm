<%@page import="admin.task.TaskMaster_ACT"%>
<%@page import="admin.seo.SeoOnPage_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title>SEO</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div class="wrap">	
	<%
String addedby= (String)session.getAttribute("loginuID");
String uid=(String) session.getAttribute("passid");
String[][] seodata=SeoOnPage_ACT.getSeoByID(uid);

String loginuaid = (String)session.getAttribute("loginuaid");
String userroll= (String)session.getAttribute("emproleid");
String token=(String)session.getAttribute("uavalidtokenno");
String[][] project=SeoOnPage_ACT.getAssignedProject(loginuaid,userroll,token);
String mname=TaskMaster_ACT.getMilestoneName(seodata[0][1],token);
%>
<div id="content">
<div class="main-content">
<div class="container">
<div class="row">
<div class="col-md-7 col-sm-7 col-xs-12">
    <div class="menuDv  post-slider">
        <form action="update-seo.html" method="post" name="seopage" id="seopage">
        <input type="hidden" name="addedbyuser" value="<%=addedby%>">
        <input type="hidden" name="uid" value="<%=uid%>">
          <div class="clearfix">
            <div class="row">
         <div class="col-md-4 col-sm-4 col-xs-12">
			<div class="form-group">
			<label>Project's Name</label>
			<div class="input-group">
			<span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
			<select id="Project_Name" name="ProjectName" class="form-control" disabled="disabled">
			<option value="<%=seodata[0][12]%>"><%=seodata[0][4]%></option>			
			</select>
			</div>
			</div>
			</div>						
			<div class="col-md-4 col-sm-4 col-xs-12">
			<div class="form-group">
			<label>Task's Name</label>
			<div class="input-group">
			<span class="input-group-addon"><i class="form-icon sprite list"></i></span>
			<select id="Task_Name" name="taskname" class="form-control" disabled="disabled">
			<option value="<%=seodata[0][1]%>"><%=mname%></option>
			</select>
			</div>			
			</div>
			</div>
			<div class="col-md-4 col-sm-4 col-xs-12">
			<div class="form-group">
			<label>Activity Type</label>
			<div class="input-group">
			<span class="input-group-addon"><i class="form-icon sprite list"></i></span>
			<select name="activitytype" id="activitytype" class="form-control" disabled="disabled">
			<option value="<%=seodata[0][4]%>"><%=seodata[0][4]%></option>			    
			</select>
			</div>			
			</div>
			</div>			  
            </div>
            <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
             <div class="form-group">
              <label>Target Website</label>
              <div class="input-group">
              <span class="input-group-addon"><i class="form-icon sprite fa fa-chrome"></i></span>
              <input type="text" name="website" id="Website" value="<%=seodata[0][3]%>"placeholder="Target Website"  class="form-control" readonly="readonly">
              </div>              
             </div>
            </div>
            <div class="col-md-12 col-sm-12 col-xs-12">
             <div class="form-group">
              <label>Target URL</label>
              <div class="input-group">
              <span class="input-group-addon"><i class="form-icon sprite info"></i></span>
              <input type="text" name="targeturl" id="TargetURL"value="<%=seodata[0][5]%>" placeholder="Target URL"  class="form-control" readonly="readonly">
              </div>           
             </div>
            </div>
            </div>
            <div class="row">
            <div class="col-md-12 col-sm-6 col-xs-12">
            <div class="form-group">
              <label>Keyword</label>
              <div class="input-group">
              <span class="input-group-addon"><i class="form-icon sprite tag"></i></span>
              <input type="text" name="keyword" id="Keyword" value="<%=seodata[0][6]%>"placeholder="Keyword" class="form-control" readonly="readonly">
              </div>             
            </div>
            </div>
            </div>
            <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
            <div class="form-group">
              <label>Content</label>
              <div class="input-group">
              <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
              <textarea class="form-control" name="longdescription" id="Long Description" placeholder="Long Description" readonly="readonly"><%=seodata[0][2]%></textarea>
              </div>
              <div id="LongDescriptionErrorMSGdiv" class="errormsg"></div>
            </div>
            </div>
            </div>
            <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
             <div class="form-group">
              <label>Submitted On URL</label>
              <div class="input-group">
              <span class="input-group-addon"><i class="form-icon sprite info"></i></span>
              <input type="text" name="submittedonurl" id="Submitted On URL" value="<%=seodata[0][7]%>"placeholder="Submitted On URL" class="form-control" readonly="readonly">
              </div>            
             </div>
            </div>
            </div>
            <div class="row">
            <div class="col-md-6 col-sm-6 col-xs-12">
             <div class="form-group">
              <label>Search Engine</label>
              <div class="input-group">
              <span class="input-group-addon"><i class="form-icon fa fa-search"onblur="requiredFieldValidation('Search Engine','SearchEngineErrorMSGdiv');"></i></span>
              <select id="Search Engine" name="searchengine" class="form-control" disabled="disabled">
                <option value="<%=seodata[0][8] %>"><%=seodata[0][8] %></option>
               </select>
              </div>      
             </div>
             </div>
            <div class="col-md-6 col-sm-6 col-xs-12">
            <div class="form-group">
            <label>Website Nature</label>
            <div class="input-group">
            <span class="input-group-addon"><i class="form-icon fa fa-search"></i></span>
            <select id="Website Nature" name="websitenature" class="form-control" disabled="disabled">          
            <option value="<%=seodata[0][11] %>"><%=seodata[0][11] %></option>            
            </select>
            </div>          
            </div>
            </div>
            </div>
            <div class="row">
            <div class="col-md-6 col-sm-6 col-xs-12">
             <div class="form-group">
              <label>Status</label>
              <div class="input-group">
              <span class="input-group-addon"><i class="form-icon sprite checked"onblur="requiredFieldValidation('Status','StatusErrorMSGdiv');"></i></span>
              <select id="Status" name="status" class="form-control"  disabled="disabled">
                 <option value="<%=seodata[0][9] %>"><%=seodata[0][9] %></option> 
               </select>
              </div>
              <div id="StatusErrorMSGdiv" class="errormsg"></div>
             </div>
            </div> 
            <div class="col-md-6 col-sm-6 col-xs-12">
             <div class="form-group">
              <label>Task Status</label>
              <div class="input-group">
              <span class="input-group-addon"><i class="form-icon sprite checked"></i></span>
              <select id="Task Status" name="tstatus" class="form-control" disabled="disabled">
                 <option value="<%=seodata[0][10] %>"><%=seodata[0][10] %></option> 
               </select>
              </div>              
             </div>
            </div>
            </div>            
          </div>
        </form>
    </div>
</div>
                    
<div class="mini-cart-total col-md-5 col-sm-5 col-xs-12">
<div id="target">
<div class="menuDv">
<div class="inner-bestsell">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="widget widget-category">
<ul>
<li><a class="link">Assigned On -</a> <span id="idassign"></span></li>
<li><a class="link">Deliver On -</a> <span id="iddeliver"></span></li>
<li><a class="link">Remark -</a> <span id="idremark"></span></li>
</ul>
</div>
</div>
</div>
</div>
</div>
<div id="innerdiv">
<%
String taskid=(String)session.getAttribute("taskid");
String getcontent[][] = SeoOnPage_ACT.getContentByTaskID(taskid);
if(getcontent.length > 0){ %>
<div class="menuDv">
<div class="inner-bestsell">
<p class="seo-content"><a href="javascript:void(0);" onclick="showcontent(<%=taskid%>)">Show Content</a></p>
</div>
</div>
<%} %>
</div>
<% session.removeAttribute("taskid"); %>
</div>
</div>
</div>
</div>
</div>
</div>
</div>	
<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
$(document).ready(function(){
var aid="<%=seodata[0][1]%>";
$.ajax({
	type : "POST",
	url : "SetTaskDetails111",
	dataType : "HTML",
	data : {				
		"aid":aid,
	},
	success : function(data){
		var x=data.split("@");
		document.getElementById("idassign").innerHTML=x[0];
		document.getElementById("iddeliver").innerHTML=x[1];
		document.getElementById("idremark").innerHTML=x[2];
	}
});});

    $(function() { 
	$("#Task_Name").autocomplete({
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
				id: item.id,
		};}));},
		error: function (error) {
	       alert('error: ' + error);
	    }});},
		select : function(e, ui) {
	    	$("#tid").val(ui.item.id);
		},});
	});
    
    function validateSeo(){
    	if(document.getElementById('Project_Name').value.trim()=="" ) {
    		ProjectNameErrorMSGdiv.innerHTML="Select Project";
    		ProjectNameErrorMSGdiv.style.color="#800606";
    		return false;
    		}
    	if(document.getElementById('Task_Name').value.trim()=="" ) {
    		tasknameErrorMSGdiv.innerHTML="Select Task";
    		tasknameErrorMSGdiv.style.color="#800606";
    		return false;
    		}	
    	if(document.getElementById('activitytype').value.trim()=="" ) {
    		activitytypeErrorMSGdiv.innerHTML="Select An Activity";
    		activitytypeErrorMSGdiv.style.color="#800606";
    		return false;
    		}
    	var spacecheck = /^\s|\s$/;
    	if (spacecheck.test(document.getElementById('Keyword').value.trim())){
    	KeywordErrorMSGdiv.innerHTML="INCORRECT KEYWORD.";
    	KeywordErrorMSGdiv.style.color="#800606";
    	return false;
    	}
    	if(document.getElementById('Keyword').value.trim()==""){
    		KeywordErrorMSGdiv.innerHTML="Keyword is required.";
    		KeywordErrorMSGdiv.style.color="#800606";
    		return false;
    		}
    	if(document.getElementById('Website').value.trim()=="" ) {
    	WebsiteErrorMSGdiv.innerHTML="Website is required.";
    	WebsiteErrorMSGdiv.style.color="#800606";
    	return false;
    	}
    	if(document.getElementById('TargetURL').value.trim()=="") {
    	TargetURLErrorMSGdiv.innerHTML="TargetURL is required.";
    	TargetURLErrorMSGdiv.style.color="#800606";
    	return false;
    	}

    	var data = $('#seopage').find('.nicEdit-main').text();
    	if(data.trim()==""){
    	LongDescriptionErrorMSGdiv.innerHTML="Long Description is required.";
    	LongDescriptionErrorMSGdiv.style.color="#800606";
    	return false;
    	}
    	elsedata = data.replace(/'/g, "");

    	if(document.getElementById('Submitted On URL').value.trim()==""){
    	SubmittedOnURLErrorMSGdiv.innerHTML="Submitted On URL is required.";
    	SubmittedOnURLErrorMSGdiv.style.color="#800606";
    	return false;
    	}
    	if(document.getElementById('Search Engine').value.trim()==""){
    	SearchEngineErrorMSGdiv.innerHTML="Search Engine is required.";
    	SearchEngineErrorMSGdiv.style.color="#800606";
    	return false;
    	}
    	if(document.getElementById('Website Nature').value.trim()==""){
    	WebsiteNatureErrorMSGdiv.innerHTML="Website Nature is required.";
    	WebsiteNatureErrorMSGdiv.style.color="#800606";
    	return false;
    	}
    	if(document.getElementById('Status').value.trim()==""){
    	StatusErrorMSGdiv.innerHTML="Status is required.";
    	StatusErrorMSGdiv.style.color="#800606";
    	return false;
    	}
    	if(document.getElementById('Task Status').value.trim()==""){
    	TaskStatusErrorMSGdiv.innerHTML="Task Status is required.";
    	TaskStatusErrorMSGdiv.style.color="#800606";
    	return false;
    	}   
    	}
    
    window.onload=approve1();
    
    function approve1() {
    	var info=document.getElementById('tid').value;
    	if(info=="")
    	{
    	idassign.innerHTML="";
    	iddeliver.innerHTML="";
    	idremark.innerHTML="";
    	return false;
    	}
    	else
    	{
    	var seoid=info;
    	var xhttp;
    	xhttp = new XMLHttpRequest();
    	xhttp.onreadystatechange = function() {
    	if (this.readyState == 4 && this.status == 200) {
    	var sp=xhttp.responseText.split("#");
    	idassign.innerHTML=sp[0];
    	iddeliver.innerHTML=sp[1];
    	idremark.innerHTML=sp[2];
    	$("#innerdiv").load("off-page-seo-techniques.html #innerdiv");
    	}
    	};
    	xhttp.open("POST", "<%=request.getContextPath()%>/SeoIn111?seoid="+seoid, true);
    	xhttp.send(seoid);
    	}
    	};
</script>
<script type="text/javascript">
function showcontent(id){
	$.ajax({
	    type: "POST",
	    url: "<%=request.getContextPath()%>/vieweditpage",
	    data:  { 
	    	"uid" : id
	    },
	    success: function (response) {
        	window.open("<%=request.getContextPath()%>/show-task-content.html","_blank");
        },
	});
}
</script>
</body>
</html>