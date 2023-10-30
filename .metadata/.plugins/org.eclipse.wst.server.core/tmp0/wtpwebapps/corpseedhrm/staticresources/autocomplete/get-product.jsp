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
if(field.equalsIgnoreCase("product_Id")){

	String sql="SELECT pprodid FROM product_master where pprodid like '%"+name+"%' and ptokenno='"+token+"' and pstatus='1'  LIMIT 0 , 10";
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("value",rs.getString(1));
	    jsonArr.add(json);
	}
}else if(field.equalsIgnoreCase("product_name")){

	String sql="SELECT pname,prefid,pcentral,pstate,pglobal FROM product_master where pname like '%"+name+"%' and ptokenno='"+token+"' and pstatus='1'  LIMIT 0 , 10";
// 	System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("value",rs.getString(1));
		json.put("key",rs.getString(2));
		json.put("central",rs.getString(3));
		json.put("state",rs.getString(4));
		json.put("global",rs.getString(5));
	    jsonArr.add(json);
	}
}else if(field.equalsIgnoreCase("product_name")){

	String sql="SELECT pname,prefid FROM product_master where pname like '%"+name+"%' and ptokenno='"+token+"' and pstatus='1'  LIMIT 0 , 10";
// 	System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("value",rs.getString(1));
		json.put("key",rs.getString(2));
	    jsonArr.add(json);
	}
}else if(field.equalsIgnoreCase("product_milestone")){

	String sql="SELECT sgmilestonename FROM step_guide where sgmilestonename like '%"+name+"%' and sgtoken='"+token+"' and sgststus='1' group by sgmilestonename LIMIT 0 , 10";
// 	System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
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