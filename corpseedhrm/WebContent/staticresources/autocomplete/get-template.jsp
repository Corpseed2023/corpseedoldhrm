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
	StringBuffer sql=new StringBuffer("SELECT tid,tname FROM manage_template where tname like '%"+name+"%' and ttokenno='"+token+"' and tstatus='1'");
	if(field!=null&&field.length()>0&&!field.equalsIgnoreCase("All"))sql.append("  and ttype='"+field+"'");
	sql.append(" LIMIT 0 , 10");
	ps=con.prepareStatement(sql.toString());
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("tid",rs.getString(1));
		json.put("name",rs.getString(2));
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