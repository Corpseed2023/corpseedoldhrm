<%@page import="commons.DateUtil"%>
<%@page import="admin.seo.SeoOnPage_ACT"%>
<%@page import="urlcollection.CollectionACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Update SEO URL Collection</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div id="loader"><img src="<%=request.getContextPath()%>/staticresources/images/hrmreportloader.gif" alt="" /></div>
<div class="wrap">
<%@ include file="../staticresources/includes/itswsheader.jsp" %>
<% 
String submiturl = (String) session.getAttribute("submiturl");
String activity = (String) session.getAttribute("activity");
String nature = (String) session.getAttribute("nature");
String from = (String) session.getAttribute("from");
String to = (String) session.getAttribute("to");

String[][] collection = CollectionACT.getAllCollection(submiturl, activity, nature, from, to); 
String[][] activitytype = SeoOnPage_ACT.getActivityByID();
%>
<%if(!MS09){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
    <div class="container">   
      <div class="bread-crumb">
        <div class="bd-breadcrumb bd-light">
        <a href="<%=request.getContextPath()%>/dashboard.html">Home</a>
        <a>Update SEO URL Collection</a>
        </div>
      </div>
    </div>

    <div class="main-content">
        <div class="container">
            <div class="row">
                <div class="middle col-md-12 col-sm-12 col-xs-12">
                    <div class="menuDv partner-slider8 clearfix">
                        <div class="box-intro">
                        <h2><span class="title">SEO URL Collection</span></h2>
                        </div>
                        <form action="<%=request.getContextPath()%>/seo-url-collection.html" method="POST">
                        <div class="home-search-form clearfix">
                        <div class="item-bestsell box-width9 col-md-2 col-sm-2 col-xs-12">
                        <%if(submiturl!=null){ %>
                        <input name="submiturl" id="submiturl" autocomplete="off" value="<%=submiturl %>" class="form-control" placeholder="Enter Submit URL">
                        <% } else{%>
                        <input name="submiturl" id="submiturl" autocomplete="off" class="form-control" placeholder="Enter Submit URL">
                        <%} %>
                        </div>
                        <div class="item-bestsell box-width9 col-md-2 col-sm-2 col-xs-12">
                        <select name="activity" id="activity" class="form-control">
                        <option value="">Select Activity</option>
                        <%for(int i=0;i<activitytype.length;i++){
                        if(activity!=null && activity.equalsIgnoreCase(activitytype[i][1])){ %>
                        <option value="<%=activitytype[i][1] %>" selected="selected"><%=activitytype[i][0]%></option>
                        <%}else{ %>
                        <option value="<%=activitytype[i][1] %>"><%=activitytype[i][0] %></option>
                        <%}}%>
                        </select>
                        </div>
                        <div class="item-bestsell box-width9 col-md-2 col-sm-2 col-xs-12">
                        <select name="nature" id="nature" class="form-control">
                        <% if(nature!=null){ %>
                        <option value="<%=nature%>"><%=nature%></option>
                        <% } %>
                        <option value="">Select Nature</option>
                        <option value="Dofollow">Dofollow</option>
                        <option value="Nofollow">Nofollow</option>
                        <option value="Not Sure">Not Sure</option>
                        </select>
                        </div>
                        <div class="item-bestsell box-width9 col-md-2 col-sm-2 col-xs-12">
                        <% if(from!=null){ %>
                        <p><input type="text" name="from" id="from" value="<%=from%>" placeholder="From" class="form-control searchdate" autocomplete="off" /></p>
                        <%}else{ %>
                        <p><input type="text" name="from" id="from" placeholder="From" class="form-control searchdate" autocomplete="off" /></p>
                        <%} %>
                        </div>
                        <div class="item-bestsell box-width9 col-md-2 col-sm-2 col-xs-12">
                        <% if(to!=null){ %>
                        <p><input type="text" name="to" id="to" value="<%=to%>" placeholder="To" class="form-control searchdate" autocomplete="off" /></p>
                        <%}else{ %>
                        <p><input type="text" name="to" id="to" placeholder="To" class="form-control searchdate" autocomplete="off" /></p>
                        <%} %>
                        </div>
                        <div class="item-bestsell box-width26 col-md-2 col-sm-2 col-xs-12">
                        <input class="btn-link-default bt-radius" type="submit" value="Search" />
                        <%if(SUC00){ %><input class="btn-link-default bt-radius" type="button" value="Insert" onclick="$('#myModal2').modal('show');" title="Click here to Insert New URL!!" /><%} %>
                        <%if(SUC01){ %><input class="btn-link-default bt-radius" type="button" value="Check" onclick="$('#myModal').modal('show');" title="Click here to check Status!!" /><%} %>
                        </div>
                        </div>
                        </form>
                        <form method="post" name="addkeywordform" id="addkeywordform">
                         <div class="row">
                          <div class="col-md-12 col-sm-12 col-xs-12">
                           <div class="clearfix">
                            <div class="box-width24 col-xs-1 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">SN</p>
                                </div>
                            </div>
                            <div class="box-width17 col-md-3 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Submit URL</p>
                                </div>
                            </div>
                            <div class="box-width3 col-md-6 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">SEO Activity</p>
                                </div>
                            </div>
                             <div class="box-width22 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Nature</p>
                                </div>
                            </div>
                            <div class="box-width22 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Status</p>
                                </div>
                            </div>
                            <div class="box-width5 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Last Checked On</p>
                                </div>
                            </div>
                            <div class="box-width21 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">Alexa</p>
                                </div>
                            </div>
                            <div class="box-width21 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">DA</p>
                                </div>
                            </div>
                            <div class="box-width21 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p class="news-border">IP Class</p>
                                </div>
                            </div>
                            <div class="box-width22 col-xs-12 box-intro-bg">
                                <div class="box-intro-border">
                                <p>Action</p>
                                </div>
                            </div>
                           </div>
                          </div>
                         </div>
                         <%
                            for(int i=0;i<collection.length;i++){
                         %>
                        <div class="row">
                          <div class="col-md-12 col-sm-12 col-xs-12">
                           <div class="clearfix">
                            <div class="box-width24 col-xs-1 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><%=collection[i][0]%></p>
                                </div>
                            </div>
                            <div class="box-width17 col-md-3 col-xs-12 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><input type="text" readonly id="submiturl<%=collection[i][0]%>" name="submiturl<%=collection[i][0]%>" class="update-field dblremread" value="<%=collection[i][1]%>"></p>
                                </div>
                            </div>
                            <div class="box-width3 col-md-6 col-xs-12 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><input type="text" readonly id="activity<%=collection[i][0]%>" name="activity<%=collection[i][0]%>" class="update-field dblremread" value="<%=collection[i][2]%>"></p>
                                </div>
                            </div>
                            <div class="box-width22 col-xs-12 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><input type="text" readonly id="nature<%=collection[i][0]%>" name="nature<%=collection[i][0]%>" class="update-field dblremread" value="<%=collection[i][3]%>"></p>
                                </div>
                            </div>
                            <div class="box-width22 col-xs-12 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><input type="text" readonly id="status<%=collection[i][0]%>" name="status<%=collection[i][0]%>" class="update-field dblremread" value="<%=collection[i][7]%>"></p>
                                </div>
                            </div>
                            <div class="box-width5 col-xs-12 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><%=collection[i][10]%></p>
                                </div>
                            </div>
                            <div class="box-width21 col-xs-12 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><input type="number" min="0" id="alexa<%=collection[i][0]%>" name="alexa<%=collection[i][0]%>" value="<%=collection[i][4]%>" class="update-field"></p>
                                </div>
                            </div>
                            <div class="box-width21 col-xs-12 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><input type="number" min="0" id="da<%=collection[i][0]%>" name="da<%=collection[i][0]%>" value="<%=collection[i][5]%>" class="update-field"></p>
                                </div>
                            </div>
                            <div class="box-width21 col-xs-12 box-intro-background">
                                <div class="link-style12">
                                <p class="news-border"><input type="number" min="0" id="ipclass<%=collection[i][0]%>" name="ipclass<%=collection[i][0]%>" value="<%=collection[i][6]%>" class="update-field"></p>
                                </div>
                            </div>
                            <%if(SUC02) {%>
                            <div class="box-width22 col-xs-12 box-intro-background">
                                <div class="link-style12">
                                <p id="result"><a href="javascript:void(0);" onclick="update(<%=collection[i][0]%>);" id="updated<%=collection[i][0]%>"><i class="fa fa-arrow-up"></i></a>
                                </div>
                            </div><%} %>
                           </div>
                          </div>
                          </div>
                          <% } %>
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
function update(info){
	var submiturl = document.getElementById('submiturl'+info).value;
	if(submiturl==''||submiturl==null){
		document.getElementById('submiturl'+info).style.backgroundColor = "#ffcaca";
		return false;
	}
	var activity = document.getElementById('activity'+info).value;
	if(activity==''||activity==null){
		document.getElementById('activity'+info).style.backgroundColor = "#ffcaca";
		return false;
	}
	var nature = document.getElementById('nature'+info).value;
	if(nature==''||nature==null){
		document.getElementById('nature'+info).style.backgroundColor = "#ffcaca";
		return false;
	}
	var status = document.getElementById('status'+info).value;
	if(status==''||status==null){
		document.getElementById('status'+info).style.backgroundColor = "#ffcaca";
		return false;
	}
	var alexa = document.getElementById('alexa'+info).value;
	if(alexa==''||alexa==null){
		document.getElementById('alexa'+info).style.backgroundColor = "#ffcaca";
		return false;
	}
	var da = document.getElementById('da'+info).value;
	if(da==''||da==null){
		document.getElementById('da'+info).style.backgroundColor = "#ffcaca";
		return false;
	}
	var ipclass = document.getElementById('ipclass'+info).value;
	if(ipclass==''||ipclass==null){
		document.getElementById('ipclass'+info).style.backgroundColor = "#ffcaca";
		return false;
	}
	$("#updated"+info).hide();
	$.ajax({
		async : false,
		url : "<%=request.getContextPath()%>/UpdateURLData",
		type : "GET",
		dataType : 'HTML',
		data : {
		    "id" : info,
			"submiturl" : submiturl,
			"activity" : activity,
			"nature" : nature,
			"status" : status,
			"alexa" : alexa,
			"da" : da,
			"ipclass" : ipclass,
		},
		success : function(response) {
		    result.innerHTML = 'Updated!';
		},
		error : function(error) {
		    alert("Some Error Occured!! "+error.responseText);
		    $("#updated"+info).show();
		}
	});
}

$(".dblremread").on("dblclick", function(){
    $("#"+this.id).attr("readonly", false);
    $("#"+this.id).css("background", "#f1f1f1");
});
</script>
<div id="myModal" class="modal fade in" style="display: none;">
    <div class="modal-dialog mtop">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Check URL</h4>
            </div>
            <div class="modal-body">
                <form id="contact-form" method="post" onsubmit="return false;">
                 <div class="clearfix">
                  <div class="col-sm-12 col-xs-12">
                  <div class="form-group">
                  <label>Starting Point</label>
                    <input type="number" class="form-control" name="start" id="start" placeholder="Enter Starting Point" required>
                  </div>
                  <div class="form-group">
                  <label>Ending Point</label>
                    <input type="number" class="form-control" name="end" id="end" placeholder="Enter Ending Point" required>
                  </div>
                  <div class="send-msg text-center form-group">
                    <input class="bt-link bt-radius bt-loadmore" type="submit" name="submit" value="Start" onclick="startCheck();">
                  </div>
                 </div>
                </div>
              </form>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
function startCheck(){
    var start = document.getElementById('start').value;
    var end = document.getElementById('end').value;
    if(start=="") {
		$("[id='start']").css('border-color', '#ff0000');
		return false;
    }
    if(start=="") {
		$("[id='end']").css('border-color', '#ff0000');
		return false;
    }
    if(Number(start)>Number(end)) {
		alert("End cannot be Lower than Start!");
		return false;
    }
    $.ajax({
		url : "<%=request.getContextPath()%>/CheckURLExistance",
		type : "GET",
		dataType : 'HTML',
		data : {
			"start" : start,
			"end" : end,
		},
		beforeSend: function () {
		    $('#loader').show();
	    },
		success: function (data) {
		    if(data=="success") location.reload();
		    else {
				$('#loader').hide();
				alert(data);
		    }
	    },
		error : function(error) {
		    $('#loader').hide();
		    alert("Some Error Occured!! "+error.responseText);
		}
	});
}
</script>
<div id="myModal2" class="modal fade in" style="display: none;">
    <div class="modal-dialog mtop">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">New SEO URL</h4>
            </div>
            <div class="modal-body" style="height: 400px; overflow-y: scroll;">
                <form id="contact-form" method="post" onsubmit="return false;">
                <input type="hidden" id="newlastcheckedon" name="newlastcheckedon" readonly value="<%=DateUtil.getCurrentDateTime()%>" class="form-control">
                 <div class="clearfix">
                  <div class="col-sm-12 col-xs-12">
                  <div class="form-group">
                  <label>Submit URL</label>
                    <input type="text" id="newsubmiturl" name="newsubmiturl" placeholder="Enter Submit URL" class="form-control">
                  </div>
                  <div class="form-group">
                  <label>Activity Type</label>
                    <select id="newactivity" name="newactivity" class="form-control"><option value="">Select Activity Type</option><%for(int i=0;i<activitytype.length;i++){%><option value="<%=activitytype[i][1] %>"><%=activitytype[i][0] %></option><%}%></select>
                  </div>
                  <div class="form-group">
                  <label>Nature</label>
                    <select id="newnature" name="newnature" class="form-control"><option value="">Select Activity Nature</option><option value="Dofollow">Dofollow</option><option value="Nofollow">Nofollow</option><option value="Not Sure">Not Sure</option></select>
                  </div>
                  <div class="form-group">
                  <label>URL Status</label>
                    <select id="newstatus" name="newstatus" class="form-control"><option value="">Select URL Status</option><option value="Alive">Alive</option><option value="Dead">Dead</option></select>
                  </div>
                  <div class="form-group">
                  <label>Alexa Rank</label>
                    <input type="number" min="0" id="newalexa" placeholder="Enter Alexa Rank" name="newalexa" class="form-control">
                  </div>
                  <div class="form-group">
                  <label>Domain Authority</label>
                    <input type="number" min="0" id="newda" name="newda" placeholder="Enter Domain Authority" class="form-control">
                  </div>
                  <div class="form-group">
                  <label>IP Class</label>
                    <input type="number" min="0" id="newipclass" name="newipclass" placeholder="Enter IP Class" class="form-control">
                  </div>
                  <div class="send-msg text-center form-group">
                    <input class="bt-link bt-radius bt-loadmore" type="submit" name="submit" value="Insert" onclick="insertnew();">
                  </div>
                 </div>
                </div>
              </form>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
function insertnew(){
    var newsubmiturl = document.getElementById('newsubmiturl').value;
	if(newsubmiturl==''||newsubmiturl==null){
		document.getElementById('newsubmiturl').style.backgroundColor = "#ffcaca";
		return false;
	}
	var newactivity = document.getElementById('newactivity').value;
	if(newactivity==''||newactivity==null){
		document.getElementById('newactivity').style.backgroundColor = "#ffcaca";
		return false;
	}
	var newnature = document.getElementById('newnature').value;
	if(newnature==''||newnature==null){
		document.getElementById('newnature').style.backgroundColor = "#ffcaca";
		return false;
	}
	var newstatus = document.getElementById('newstatus').value;
	if(newstatus==''||newstatus==null){
		document.getElementById('newstatus').style.backgroundColor = "#ffcaca";
		return false;
	}
	var newlastcheckedon = document.getElementById('newlastcheckedon').value;
	var newalexa = document.getElementById('newalexa').value;
	if(newalexa==''||newalexa==null){
		document.getElementById('newalexa').style.backgroundColor = "#ffcaca";
		return false;
	}
	var newda = document.getElementById('newda').value;
	if(newda==''||newda==null){
		document.getElementById('newda').style.backgroundColor = "#ffcaca";
		return false;
	}
	var newipclass = document.getElementById('newipclass').value;
	if(newipclass==''||newipclass==null){
		document.getElementById('newipclass').style.backgroundColor = "#ffcaca";
		return false;
	}
	$.ajax({
	    async : false,
		url : "<%=request.getContextPath()%>/NewSEOURL",
		type : "POST",
		dataType : 'HTML',
		data : {
			"newsubmiturl" : newsubmiturl,
			"newactivity" : newactivity,
			"newnature" : newnature,
			"newstatus" : newstatus,
			"newlastcheckedon" : newlastcheckedon,
			"newalexa" : newalexa,
			"newda" : newda,
			"newipclass" : newipclass
		},
		beforeSend: function () {
		    $('#loader').show();
	    },
		success: function (data) {
		    if(data=="success") location.reload();
		    else {
				$('#newinserted').show();
				$('#loader').hide();	
				alert(data);
		    }
	    },
		error : function(error) {
		    $('#loader').hide();
		    alert("Some Error Occured!! "+error.responseText);
		}
	});
}
</script>
</body>
</html>