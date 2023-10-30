<%@page import="admin.task.TaskMaster_ACT"%>
<html>
<head></head>
<title>Testing doc upload</title>
<body>
<form action="<%=request.getContextPath() %>/uploadmydocument.html" method="post" enctype="multipart/form-data">
<input type="file" name="file">
<input type="submit" value="submit">
</form>
<%
String document[][]=TaskMaster_ACT.getAllUploadedFiles(); 
if(document!=null&&document.length>0){
	for(int i=0;i<document.length;i++){
%>
<a href="<%=request.getContextPath() %>/documents/<%=document[i][0] %>" download>Download</a>
<%}} %>
</body>
</html>