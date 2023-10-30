<%@page import="admin.seo.SeoOnPage_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Show Task Content</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp"%>
</head>
<body>
<div class="wrap">
    <%@ include file="../staticresources/includes/itswsheader.jsp"%>    
    <%
String taskid = (String) session.getAttribute("tpassid");
String getcontent[][] = SeoOnPage_ACT.getContentByTaskID(taskid);
%>
<%if(!MS03){%><jsp:forward page="/login.html" /><%} %>
<div id="content">
  <div class="container">
      <div class="bread-crumb">
          <div class="bd-breadcrumb bd-light">
              <a href="<%=request.getContextPath()%>/dashboard.html">Home</a> <a>Show Task Content</a>
          </div>
      </div>
  </div>

  <div class="main-content">
      <div class="container">
          <div class="row">
              <div class="col-md-9 col-sm-9 col-xs-12">
                  <div class="menuDv post-slider clearfix">
                      <form>
                          <% for (int i = 0; i < getcontent.length; i++) { %>
                          <div class="clearfix">
                              <div class="row">
                                  <div class="col-md-12 col-sm-12 col-xs-12">
                                      <div class="form-group">
                                          <label>Content No. <%=i+1%></label>
                                          <div class="input-group">
                                              <span class="input-group-addon">
                                              <i class="form-icon sprite page"></i>
                                              </span>
                                              <textarea class="form-control" name="longdescription" readonly
                                                  rows="6" id="Long Description"><%=getcontent[i][0]%></textarea>
                                          </div>
                                      </div>
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
<%@ include file="../staticresources/includes/itswsfooter.jsp"%>
</div>
<%@ include file="../staticresources/includes/itswsscripts.jsp"%>
</body>
</html>