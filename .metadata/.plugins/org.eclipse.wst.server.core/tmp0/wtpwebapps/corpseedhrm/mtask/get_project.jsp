<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="net.sf.json.JSONObject,net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="commons.DbCon"%>
<%

JSONArray jsonArr = new JSONArray();
JSONObject json=new JSONObject();
String query = (String)request.getParameter("name");
String field=(String)request.getParameter("field");
String token=(String)session.getAttribute("uavalidtokenno");
Statement st=null;
ResultSet rs=null;
try(Connection con=DbCon.getCon("","","")){
st=con.createStatement();

if(field.equalsIgnoreCase("byprojectno")){
	StringBuffer sqlquery= new StringBuffer("SELECT m.msprojectnumber from managesalesctrl m join task_progress t on t.sales_key=m.msrefid where m.msprojectnumber like '%"+query+"%' and t.token='"+token+"' limit 0,10");
		
	rs = st.executeQuery(sqlquery.toString());
	
	while(rs.next())
	{
		json.put("name",rs.getString(1));
		json.put("value",rs.getString(1));
	    
	    jsonArr.add(json);
	}
	out.println(jsonArr);
}else if(field.equalsIgnoreCase("byassignee")){
	StringBuffer sqlquery= new StringBuffer("SELECT assignee_name,assignee_uid from task_progress where assignee_name like '%"+query+"%' and token='"+token+"' group by assignee_name limit 0,10");
		
	rs = st.executeQuery(sqlquery.toString());
	
	while(rs.next())
	{
		json.put("name",rs.getString(1));
		json.put("value",rs.getString(1));
		json.put("uid",rs.getString(2));
	    
	    jsonArr.add(json);
	}
	out.println(jsonArr);
}
}catch(Exception e){
	e.printStackTrace();
}finally{
	if(st!=null){st.close();}
	if(rs!=null){rs.close();}
}
%>