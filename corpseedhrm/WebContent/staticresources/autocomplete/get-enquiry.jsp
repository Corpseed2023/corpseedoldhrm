<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="net.sf.json.JSONObject,net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="commons.DbCon"%>
<%

JSONArray jsonArr = new JSONArray();
JSONObject json=new JSONObject();
String name = request.getParameter("name");
String field =request.getParameter("field");
String token= (String)session.getAttribute("uavalidtokenno");
String role=(String)session.getAttribute("emproleid");
String addedby= (String)session.getAttribute("loginuID");
StringBuffer sql=new StringBuffer();
ResultSet rs=null;
PreparedStatement ps=null;

try(Connection con=DbCon.getCon("","","")){
if(field.equalsIgnoreCase("mngeenq")){
	String attribute =request.getParameter("attribute");
	sql.append("SELECT "+attribute+" FROM userenquiry where "+attribute+" like '%"+name+"%' and enqTokenNo='"+token+"'");
	if(!role.equalsIgnoreCase("Administrator"))
		sql.append(" and enqStatus!='Cancel' and enqAddedby='"+addedby+"' ");
	sql.append(" order by "+attribute+" LIMIT 0 , 10 ");
	ps=con.prepareStatement(sql.toString());
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