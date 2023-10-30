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
String role=(String)session.getAttribute("emproleid");
String uaid=(String)session.getAttribute("loginuaid");
ResultSet rs=null;
PreparedStatement ps=null;
String sql="NA";
try(Connection con=DbCon.getCon("","","")){
if(field.equalsIgnoreCase("ProjectNo"))
{
	if(role.equalsIgnoreCase("Administrator"))
	sql="SELECT fprojectno FROM folder_master where fprojectno like '"+name+"%' and ftokenno='"+token+"' and fstatus='1' LIMIT 0 , 10";
	else
		sql="SELECT fprojectno FROM folder_master where exists(select fpid from folder_permission where fp_frefid=frefid and fp_uid='"+uaid+"' and fpcategory='folder') and fprojectno like '"+name+"%' and ftokenno='"+token+"' and fstatus='1' LIMIT 0 , 10";
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));	   
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("foldername"))
{
	if(role.equalsIgnoreCase("Administrator"))
	sql="SELECT fname FROM folder_master where fname like '"+name+"%' and ftokenno='"+token+"' and fstatus='1' LIMIT 0 , 10";
	else
		sql="SELECT fname FROM folder_master where exists(select fpid from folder_permission where fp_frefid=frefid and fp_uid='"+uaid+"' and fpcategory='folder') and fname like '"+name+"%' and ftokenno='"+token+"' and fstatus='1' LIMIT 0 , 10";
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