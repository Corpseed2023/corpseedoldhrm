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
if(field.equalsIgnoreCase("EmployeeAccount")){
	String col=request.getParameter("col");
	String sql="select em.emname,ea.empaceunqid from employee_master em join employee_accounts ea on em.emid=ea.empaceunqid where ea.empacstatus=1 and ea.empactokenno='"+token+"' and em.emname like '%"+name+"%' LIMIT 0 , 10";
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("label",rs.getString(1));
	    json.put("value",rs.getString(1));	    
	    json.put("id",rs.getString(2));	 
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("ManageEmployee")){
	String col=request.getParameter("col");
	String sql="SELECT "+col+" FROM employee_master where "+col+" like '%"+name+"%' and emtokenno='"+token+"' and emstatus='1' LIMIT 0 , 10";
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));	    
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("ManageEmployeeStructure"))
{
	String sql="SELECT emid,emname FROM employee_master where exists(select salid from salary_structure where salemid=emid) and emname like '%"+name+"%' and emtokenno='"+token+"' and emstatus='1' LIMIT 0 , 10";
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(2));
	    json.put("value",rs.getString(2));
	    json.put("empid",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("Employee"))
{
	
	String sql="SELECT emuid,emname,emdept,emdesig,emid FROM employee_master where not exists(select salemid from salary_structure where salemid=emid )and emname like '%"+name+"%' and emtokenno='"+token+"' and emstatus='1' LIMIT 0 , 20";
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("emuid",rs.getString(1));
		json.put("name",rs.getString(2));
	    json.put("value",rs.getString(2));
	    json.put("emdept",rs.getString(3));
	    json.put("emdesig",rs.getString(4));
	    json.put("emid",rs.getString(5));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("AddTdsEmployee"))
{
	
	String sql="SELECT emuid,emname,emdept,emdesig,emid FROM employee_master where emname like '%"+name+"%' and emtokenno='"+token+"' and emstatus='1' LIMIT 0 , 20";
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("emuid",rs.getString(1));
		json.put("name",rs.getString(2));
	    json.put("value",rs.getString(2));
	    json.put("emdept",rs.getString(3));
	    json.put("emdesig",rs.getString(4));
	    json.put("emid",rs.getString(5));
	    	       
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