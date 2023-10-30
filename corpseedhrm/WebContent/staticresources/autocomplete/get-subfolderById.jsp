<%@page import="admin.task.TaskMaster_ACT"%>
<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="net.sf.json.JSONObject,net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="commons.DbCon"%>
<%
JSONArray jsonArr = new JSONArray();
JSONObject json=new JSONObject();

String id =request.getParameter("frefid");
String name =request.getParameter("prno");
String token= (String)session.getAttribute("uavalidtokenno");
ResultSet rs=null;
PreparedStatement ps=null;
try(Connection con=DbCon.getCon("","","")){
String sql=null;

	sql="SELECT fsfrefid,fname FROM folder_master WHERE frefid='"+id+"' and ftokenno='"+token+"' and fname='"+name+"' and ffcategory='folsubcategory'";
// System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	if(rs.next())
	{
		json.put("id",rs.getString(1));			
		json.put("value",rs.getString(2));
		
		jsonArr.add(json);	
	}
	
out.println(jsonArr);
}catch(Exception e){
	e.printStackTrace();
}finally{
	if(ps!=null){ps.close();}
	if(rs!=null){rs.close();}
}
%>