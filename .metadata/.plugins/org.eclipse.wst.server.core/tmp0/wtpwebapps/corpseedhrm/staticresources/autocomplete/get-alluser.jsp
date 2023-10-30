<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="net.sf.json.JSONObject,net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="commons.DbCon"%>
<%

JSONArray jsonArr = new JSONArray();
JSONObject json=new JSONObject();
String name = (String)request.getParameter("name");
String refid = (String)request.getParameter("refid");
String token= (String)session.getAttribute("uavalidtokenno");

ResultSet rs=null;
PreparedStatement ps=null;
try(Connection con=DbCon.getCon("","","")){
	String sql="SELECT uaid,uaname,uaroletype FROM user_account  where not exists(select fpid from folder_permission where fp_frefid='"+refid+"' and fp_uid=uaid) and uaname like '%"+name+"%' and uavalidtokenno='"+token+"' and uaroletype!='Administrator' and uaroletype!='Client' and uastatus='1'";
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("uid",rs.getString(1));
		json.put("uname",rs.getString(2)+" - "+rs.getString(3));	  
		json.put("name",rs.getString(2));	 
	    	       
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