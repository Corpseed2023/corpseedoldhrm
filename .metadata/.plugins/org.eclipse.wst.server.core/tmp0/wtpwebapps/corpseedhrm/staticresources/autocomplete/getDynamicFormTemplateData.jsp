<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="net.sf.json.JSONObject,net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="commons.DbCon"%>
<%
JSONArray jsonArr = new JSONArray();
JSONObject json=new JSONObject();
String templateKey = (String)request.getParameter("templateKey");
String token= (String)session.getAttribute("uavalidtokenno");
ResultSet rs=null;
PreparedStatement ps=null;
try(Connection con=DbCon.getCon("","","")){

	String sql="SELECT tmcontent FROM manage_template  where tkey='"+templateKey+"' and ttokenno='"+token+"' and tstatus='1'";
// 	System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("formTemplate",rs.getString(1));
		       
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