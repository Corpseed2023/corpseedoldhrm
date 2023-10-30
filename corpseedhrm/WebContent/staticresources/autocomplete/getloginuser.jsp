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
String department = (String)request.getParameter("department");
if(department==null||department=="")department="NA";
String token= (String)session.getAttribute("uavalidtokenno");
String addedby= (String)session.getAttribute("loginuID");
ResultSet rs=null;
PreparedStatement ps=null;
try(Connection con=DbCon.getCon("","","")){
if(field.equalsIgnoreCase("editloginusername")&&!department.equalsIgnoreCase("NA")){
	String teamrefid=request.getParameter("teamrefid").trim();
	String sql="SELECT uaid,uaempid,uaname FROM user_account  where not exists(select tmid from manageteammemberctrl where tmuseruid=uaid and tmteamrefid='"+teamrefid+"') and uavalidtokenno='"+token+"' and uaname like ? and uastatus='1' and uaroletype!='Client' and uadepartment='"+department+"'  and uarole='Assistant'";
	
	ps=con.prepareStatement(sql);
	ps.setString(1, "%"+name+"%");
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("uaid",rs.getString(1));
		json.put("uaempid",rs.getString(2));
		json.put("uname",rs.getString(3));	  
		json.put("name",rs.getString(3));	 
	    	       
	    jsonArr.add(json);
	}
}else if(field.equalsIgnoreCase("editloginusermembername")&&!department.equalsIgnoreCase("NA")){
	String teamrefid=request.getParameter("teamrefid").trim();
	String sql="SELECT uaid,uaempid,uaname FROM user_account  where not exists(select tmid from manageteammemberctrl where tmuseruid=uaid and tmteamrefid='"+teamrefid+"') and uavalidtokenno='"+token+"' and uaname like ? and uastatus='1' and uaroletype!='Client' and uadepartment='"+department+"'  and (uarole='Executive' or uarole='Manager' or uarole='Assistant')";
	
	ps=con.prepareStatement(sql);
	ps.setString(1, "%"+name+"%");
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("uaid",rs.getString(1));
		json.put("uaempid",rs.getString(2));
		json.put("uname",rs.getString(3));	  
		json.put("name",rs.getString(3));	 
	    	       
	    jsonArr.add(json);
	}
}else if(field.equalsIgnoreCase("loginusername")&&!department.equalsIgnoreCase("NA")){
	String sql="SELECT uaid,uaempid,uaname FROM user_account where not exists(select vtid from virtualteammemberctrl where vtuid=uaid and vtaddedby='"+addedby+"') and uavalidtokenno='"+token+"' and uaname like ? and uastatus='1' and uaroletype!='Client' and uadepartment='"+department+"' and (uarole='Assistant' or uarole='Manager')";
// 	System.out.println(sql);
	ps=con.prepareStatement(sql);
	ps.setString(1, "%"+name+"%");
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("uaid",rs.getString(1));
		json.put("uaempid",rs.getString(2));
		json.put("uname",rs.getString(3));	  
		json.put("name",rs.getString(3));	 
	    	       
	    jsonArr.add(json);
	}
}else if(field.equalsIgnoreCase("loginusermembername")&&!department.equalsIgnoreCase("NA")){
	String sql="SELECT uaid,uaempid,uaname FROM user_account  where not exists(select vtid from virtualteammemberctrl where vtuid=uaid and vtaddedby='"+addedby+"') and uavalidtokenno='"+token+"' and uaname like ? and uastatus='1' and uaroletype!='Client' and uadepartment='"+department+"' and (uarole='Executive' or uarole='Manager' or uarole='Assistant')";
// 	System.out.println(sql);
	ps=con.prepareStatement(sql);
	ps.setString(1, "%"+name+"%");
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("uaid",rs.getString(1));
		json.put("uaempid",rs.getString(2));
		json.put("uname",rs.getString(3));	  
		json.put("name",rs.getString(3));	 
	    	       
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