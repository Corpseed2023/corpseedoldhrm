<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="net.sf.json.JSONObject,net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="commons.DbCon"%>
<%

JSONArray jsonArr = new JSONArray();
JSONObject json=new JSONObject();
String name = (String)request.getParameter("name");
String field = (String)request.getParameter("field");
String token= (String)session.getAttribute("uavalidtokenno");
ResultSet rs=null;
PreparedStatement ps=null;
try(Connection con=DbCon.getCon("","","")){

String column="tName";
if(field.equalsIgnoreCase("number"))column="tTriggerNo";

String sql="SELECT "+column+" FROM triggers where "+column+" like '%"+name+"%' and tToken='"+token+"' LIMIT 0 , 10";
ps=con.prepareStatement(sql);
rs =ps.executeQuery();
while(rs.next())
{
	json.put("value",rs.getString(1));
    	       
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