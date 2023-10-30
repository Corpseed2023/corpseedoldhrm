
<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="net.sf.json.JSONObject,net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="commons.DbCon"%>
<%
JSONArray jsonArr = new JSONArray();
JSONObject json=new JSONObject();

String token= (String)session.getAttribute("uavalidtokenno");
String salesKey=request.getParameter("salesKey");

PreparedStatement ps=null;
ResultSet rs=null;
try(Connection con=DbCon.getCon("","","")){

String sql=null;

	sql="select ua.uaid,ua.uaname,ua.ualoginstatus from user_account ua join manage_assignctrl ma on ma.mateammemberid=ua.uaid where ma.masalesrefid='"+salesKey+"' and ma.matokenno='"+token+"' and ma.masaleshierarchystatus='1' and ma.mahierarchyactivestatus='1' and ma.maapprovalstatus='1' and ma.mastepstatus='1' group by ua.uaid";
// 	System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	
	while(rs.next())
	{
		json.put("uaid",rs.getString(1));		
		json.put("uaname",rs.getString(2));
		json.put("status",rs.getString(3));
		
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