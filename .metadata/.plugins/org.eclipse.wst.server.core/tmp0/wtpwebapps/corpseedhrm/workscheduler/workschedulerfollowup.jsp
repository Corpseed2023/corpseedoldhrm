<!DOCTYPE HTML>
<%@page import="workscheduler.WorkSchedulerACT"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>

<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Work Scheduler Follow Up</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<%
String wsuid = request.getParameter("uid");
%>
<div class="container min_width">
<div class="row advert">
  <div class="col-md-12 col-sm-12 col-xs-12">
    <div class="row">
        <div class="col-md-4 col-sm-4 col-xs-12">
            <div class="menuDv partner-slider8 mb10">
                <div class="box-intro">
                  <h2><span class="title">Follow Up</span></h2>
                </div>
                <div class="row">
                <form onsubmit="return false;" method="post" id="workschedulefollowup">
                <input type="hidden" name="wsuid" id="wsuid" value="<%=wsuid%>" />
                  <div class="col-md-12 col-sm-12 col-xs-12">
                   <div class="clearfix">
                    <div class="col-md-12 col-sm-12 col-xs-12">
                        <div class="form-group">
                        <label>Status :</label>
                        <select class="form-control" id="fstatus" name="fstatus"><option value="Pending">Pending</option><option value="Completed">Completed</option></select>
                        </div>
                    </div>
                    <div class="col-md-12 col-sm-12 col-xs-12">
                        <div class="form-group">
                        <label>Remarks :</label>
                        <textarea class="form-control" id="fremarks" name="fremarks" rows="3" placeholder="Enter Remarks" required></textarea>
                        <div id="ErrorDiv"></div>
                        </div>
                    </div>
                    <div class="col-md-12 col-sm-12 col-xs-12">
                        <div class="mb10 advert clearfix text-center">
                        <input type="submit" value="Save" class="bt-link bt-radius bt-loadmore" onclick="savefollowup();" />
                        </div>
                    </div>
                   </div>
                 </div>
                 </form>
               </div>
            </div>
        </div>
        <div class="col-md-8 col-sm-8 col-xs-12">
            <div class="menuDv partner-slider8 mb10">
                <div class="box-intro">
                  <h2><span class="title">Work Scheduler</span></h2>
                </div>
                <div class="row">
                  <div class="col-md-12 col-sm-12 col-xs-12">
                   <div class="clearfix">
                    <div class="col-md-1 col-xs-1 box-intro-bg">
                        <div class="box-intro-border">
                        <p class="news-border">SN</p>
                        </div>
                    </div>
                    <div class="col-md-2 col-xs-2 box-intro-bg">
                        <div class="box-intro-border">
                        <p class="news-border">Date</p>
                        </div>
                    </div>
                      <div class="col-md-2 col-xs-2 box-intro-bg">
                        <div class="box-intro-border">
                        <p class="news-border">Status</p>
                        </div>
                    </div>
                    <div class="col-md-7 col-xs-4 box-intro-bg">
                        <div class="box-intro-border">
                        <p>Remarks</p>
                        </div>
                    </div>
                   </div>
                  </div>
                </div>
               <div id="target">
                <%
                String[][] works = WorkSchedulerACT.getFollowUpById(wsuid);
                for(int i=0;i<works.length;i++) {
                 %>
                <div class="row">
                  <div class="col-md-12 col-sm-12 col-xs-12">
                   <div class="clearfix">
                    <div class="col-md-1 col-xs-1 box-intro-background">
                        <div class="link-style12">
                        <p class="news-border"><%=works[i][0] %></p>
                        </div>
                    </div>
                    <div class="col-md-2 col-xs-1 box-intro-background">
                        <div class="link-style12">
                        <p class="news-border"><%=works[i][1] %></p>
                        </div>
                    </div>
                    <div class="col-md-2 col-xs-3 box-intro-background">
                        <div class="link-style12">
                        <p class="news-border"><%=works[i][2] %></p>
                        </div>
                    </div>
                    <div class="col-md-7 col-xs-12 box-intro-background">
                        <div class="link-style12">
                        <p><%=works[i][3] %></p>
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
</div>
<script type="text/javascript">
function savefollowup(){
    if($("textarea#fremarks").val()=="") return false;
    $.ajax({
        type: "POST",
        url: '<%=request.getContextPath()%>/saveworkschedulerfollowup.html',
        datatype : "HTML",
        data: {
            "today" : $("#today").val(),
            "fstatus" : $("#fstatus").val(),
            "remarks" : $("textarea#fremarks").val(),
            "wsuid" : $("#wsuid").val()
            },
        success: function(data){
            $("#workschedulefollowup").trigger("reset");
            $("#target").load("<%=request.getContextPath()%>/workschedulerfollowup-1.html #target");
        }
    });
}
</script>
</body>
</html>