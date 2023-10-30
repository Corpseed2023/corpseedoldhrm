<%@page import="admin.task.TaskMaster_ACT"%>
<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="net.sf.json.JSONObject,net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="commons.DbCon"%>
<%

JSONArray jsonArr = new JSONArray();
JSONObject json=new JSONObject();

String name = (String)request.getParameter("name");
String token= (String)session.getAttribute("uavalidtokenno");
String field=request.getParameter("field");

ResultSet rs=null;
PreparedStatement ps=null;
try(Connection con=DbCon.getCon("","","")){
String sql=null;

if(field.equals("teamName")){

sql="SELECT mtteamname FROM manageteamctrl WHERE mtteamname like '%"+name+"%' and mttoken='"+token+"' and mtstatus='1' order by mtid desc limit 10";
// System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	
	while(rs.next())
	{
		json.put("name",rs.getString(1));		
		json.put("value",rs.getString(1));
		
		jsonArr.add(json);
	}
}
out.println(jsonArr);
}catch(Exception e){
	e.printStackTrace();
}finally{
	if(ps!=null){ps.close();}
	if(rs!=null){rs.close();}
}
%>