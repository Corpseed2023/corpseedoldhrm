<%@page import="admin.task.TaskMaster_ACT"%>
<%@page import="admin.seo.SeoOnPage_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Content Detail</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div class="wrap">
	<%@ include file="../staticresources/includes/itswsheader.jsp" %>
	<%
String addedby= (String)session.getAttribute("loginuID");  
String activity[][] = SeoOnPage_ACT.getActivityByID();
String uid=(String) session.getAttribute("passid");
String token=(String)session.getAttribute("uavalidtokenno");
String[][] seodata=SeoOnPage_ACT.getSeoByID(uid);
String contentdata[][] = SeoOnPage_ACT.getContentByID(uid);
String mname=TaskMaster_ACT.getMilestoneName(contentdata[0][6],token);
%>
<%if(!MS05){%><jsp:forward page="/login.html" /><%} %>
	<div id="content">
		<div class="container">   
          <div class="bread-crumb">
            <div class="bd-breadcrumb bd-light">
            <a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
            <a>Content Detail</a>
            </div>
          </div>
        </div>

		<div class="main-content">
			<div class="container">
				<div class="row">
				   
                	<div class="col-xs-12">
                        <div class="menuDv post-slider clearfix">
                            <form action="update-content.html" method="post" name="addcontent" id="addcontent">
                              <div class="row">
                                <div class="col-md-4 col-sm-6 col-xs-12">
                                 <div class="form-group">
                                   <input type="hidden" name="addedbyuser" value="<%=addedby%>">
                                      <input type="hidden" name="uid" value="<%=uid%>">								
                                  <label>Project Name</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite full-name"></i></span>
                                  <select id="Project_Name" name="ProjectName" onblur="requiredFieldValidation('Project_Name','ProjectNameErrorMSGdiv');"class="form-control" readonly>
									<option value="<%=contentdata[0][0]%>"><%=contentdata[0][0]%></option>									
									</select>
                                  </div>
                                  <div id="ProjectNameErrorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>
                                <div class="col-md-4 col-sm-4 col-xs-12">
								<div class="form-group">
								<label>Task's Name</label>
								<div class="input-group">
								<span class="input-group-addon"><i class="form-icon sprite list"></i></span>
								<select id="Task_Name" name="taskname" onblur="requiredFieldValidation('Task_Name','tasknameErrorMSGdiv');"class="form-control" readonly>
								<option value="<%=contentdata[0][6]%>"><%=mname %></option>
								</select>
								</div>
								<div id="tasknameErrorMSGdiv" class="errormsg"></div>
								</div>
								</div>
                                <div class="col-md-4 col-sm-6 col-xs-12">
                                 <div class="form-group">
                                  <label>Activity</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                 <select id="Activity_Type" name="ActivityType" onblur="requiredFieldValidation('Activity_Type','ActivityTypeErrorMSGdiv');"class="form-control" >
                                    <%
                                  if(contentdata[0][2]!=null)
                                  {%>
                                	 <option value="<%=contentdata[0][2] %>"><%=contentdata[0][2] %></option> 
                                  <%}%>
                                      <option value="">Select Activity Type</option>
                                      <%for(int i=0;i<activity.length;i++)
                                      {%>
                               	   <option value="<%=activity[i][1] %>"><%=activity[i][0] %></option> 
                                    <%}%> 
                                   </select>
                                  </div>
                                  <div id="ActivityTypeErrorMSGdiv" class="errormsg"></div>
                                 </div>
                                </div>
                              </div>
                              <div class="row">
                              <div class="col-md-12 col-sm-12 col-xs-12">
                                <div class="form-group">
                                  <label>Content</label>
                                  <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite edit-top"></i></span>
                                  <textarea class="form-control" name="content" id="Content" placeholder="Content" rows="6" onblur="requiredFieldValidation('Content','ContentErrorMSGdiv');"><%=contentdata[0][3]%></textarea>
                                  </div>
                                  <div id="ContentErrorMSGdiv" class="errormsg"></div>
                                </div>
                                </div>
                              </div>
                              <div class="row">
                                <div class="col-md-4 col-sm-6 col-xs-12">
                                <div class="form-group">
                                 <label>No. Of Words</label>
                                 <div class="input-group">
                                  <span class="input-group-addon"><i class="form-icon sprite page"></i></span>
                                  <input type="text" class="form-control readonlyAllow" name="noofword" id="noofword" value="<%=contentdata[0][5] %>" readonly />
                                   </div>
                                  </div>
                                </div>
                                <div class="col-md-4 col-sm-6 col-xs-12">
                                   <div class="form-group">
                                    <label>Status </label>
                                    <div class="input-group">
                                    <span class="input-group-addon"><i class="form-icon fa fa-industry"></i></span>
                                    <select id="Status" name="status" onblur="requiredFieldValidation('Status','StatusErrorMSGdiv');"class="form-control">
                                    <%
                                    if(contentdata[0][4]!=null)
                                    {%>
                                       <option value="<%=contentdata[0][4] %>"><%=contentdata[0][4] %></option> 
                                    <%}%>
                                        <option value="">Select Status</option>
                                        <option value="Inreview">Inreview</option>
                                        <option value="Approved">Approved</option>
                                     </select>
                                    </div>
                                    <div id="StatusErrorMSGdiv" class="errormsg"></div>
                                   </div>
                                  </div>
                              </div>
							  <div class="row">  
                                <div class="col-md-12 col-sm-12 col-xs-12 item-product-info">
                                <button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return contentsubmit();">Update<i class="fa fa-paper-plane" aria-hidden="true"></i></button>
                                </div>
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
function contentsubmit() 
{
	if(document.getElementById('Project_Name').value=="" ) {
	ProjectNameErrorMSGdiv.innerHTML="Project_Name is required.";
	ProjectNameErrorMSGdiv.style.color="#800606";
	return false;
	}
	if(document.getElementById('Activity_Type').value=="" ) {
	ActivityTypeErrorMSGdiv.innerHTML="Activity_Type is required.";
	ActivityTypeErrorMSGdiv.style.color="#800606";
	return false;
    }
	var data = $('#addcontent').find('.nicEdit-main').text();
	if(data=="")  {
	ContentErrorMSGdiv.innerHTML="Content  is required.";
	ContentErrorMSGdiv.style.color="#800606";
	return false;
	}
	if(document.getElementById('Status').value=="") {
	StatusErrorMSGdiv.innerHTML="Status is required.";
	StatusErrorMSGdiv.style.color="#800606";
	return false;
	}
	
document.addcontent.submit();
}

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

bkLib.onDomLoaded(function(){
  var myInstance = new nicEditor().panelInstance('Content');
  myInstance.addEvent('blur', function() {
	  var str = $('#addcontent').find('.nicEdit-main').text();
	  var count = 0;
	  words = str.split(" ");
	  for (var i=0; i < words.length; i++) if (words[i] != "") count += 1;
	  document.getElementById("noofword").value=count;
  });
});
</script>
</body>
</html>