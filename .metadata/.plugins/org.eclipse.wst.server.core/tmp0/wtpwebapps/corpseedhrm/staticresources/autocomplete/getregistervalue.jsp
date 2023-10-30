<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="net.sf.json.JSONObject,net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="commons.DbCon"%>
<%

JSONArray jsonArr = new JSONArray();
JSONObject json=new JSONObject();
String name = (String)request.getParameter("name");
String roletype = (String)request.getParameter("roletype");
String department = (String)request.getParameter("dept");
String token= (String)session.getAttribute("uavalidtokenno");
ResultSet rs=null;
PreparedStatement ps=null;

try(Connection con=DbCon.getCon("","","")){

if(roletype.equalsIgnoreCase("Employee")&&department!=null&&department!="")
{
	
	String sql="SELECT emuid,emname,emmobile,ememail,emtokenno FROM employee_master where not exists(select uaid from user_account where uaempid=emuid and uavalidtokenno=emtokenno) and emname like '%"+name+"%' and emtokenno='"+token+"' and emdept='"+department+"' and emstatus='1' LIMIT 0 , 20";
// 	System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("emuid",rs.getString(1));
		json.put("name",rs.getString(2));
	    json.put("value",rs.getString(2));
	    json.put("emmobile",rs.getString(3));
	    json.put("ememail",rs.getString(4));
	    json.put("tokenno",rs.getString(5));
	       
	    jsonArr.add(json);
	}
	
}else if(roletype.equalsIgnoreCase("Administrator"))
{
	String sql="SELECT compuid,compname,compmobile,compemail,compname,comptokenno FROM company_master where not exists(select uaid from user_account where uaempid=compuid) and compname like '%"+name+"%' and compstatus='1' LIMIT 0 , 20";
// 	System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs = ps.executeQuery(sql);
	while(rs.next())
	{
		json.put("emuid",rs.getString(1));
		json.put("name",rs.getString(2));
	    json.put("value",rs.getString(2));
	    json.put("emmobile",rs.getString(3));
	    json.put("ememail",rs.getString(4));
	    json.put("company",rs.getString(5));
	    json.put("tokenno",rs.getString(6));
	    
	    jsonArr.add(json);
	}
}else if(roletype.equalsIgnoreCase("Client"))
{
	String sql="SELECT cregucid,cregname,cregmob,cregemailid,cregcompany,cregtokenno FROM hrmclient_reg where not exists(select uaid from user_account where uaempid=cregucid) and cregname like '%"+name+"%' and cregstatus='1' LIMIT 0 , 10";
	ps=con.prepareStatement(sql);
	rs = ps.executeQuery();	
	while(rs.next())
	{
		json.put("emuid",rs.getString(1));
		json.put("name",rs.getString(2));
	    json.put("value",rs.getString(2));
	    json.put("emmobile",rs.getString(3));
	    json.put("ememail",rs.getString(4));
	    json.put("company",rs.getString(5));
	    json.put("tokenno",rs.getString(6));
	    
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