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
ResultSet rs=null;
PreparedStatement ps=null;
try(Connection con=DbCon.getCon("","","")){

if(field.equalsIgnoreCase("conditionsub")){
	String sql="";
	String module=request.getParameter("module");
	String condition1=request.getParameter("condition1");
	if(!condition1.equalsIgnoreCase("Group")){
		sql="SELECT mtchildconditionname FROM managetriggerctrl where mtconditiontype = 'con_child' and mtconditionname='"+condition1+"' and mtsubconditionname='"+name+"' and mtmodule='"+module+"'";
	}else if(condition1.equalsIgnoreCase("Group")&&!name.equalsIgnoreCase("not changed")&&!name.equalsIgnoreCase("changed")){
		sql="select mtteamname from manageteamctrl where mtdepartment='Delivery' and mtstatus='1'";
	}
	// 		System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
}else if(field.equalsIgnoreCase("conditionFirst")){
	String sql="SELECT mtconditionname FROM managetriggerctrl where mtconditiontype = 'con_main' and mtmodule='"+name+"'";
// 		System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
}else if(field.equalsIgnoreCase("actionmainData")){
	String sql="SELECT mtconditionname FROM managetriggerctrl where mtconditiontype = 'act_main'  and mtmodule='"+name+"'";
// 		System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
}else if(field.equalsIgnoreCase("conditionmain")){
	String module=request.getParameter("module");
	String sql="SELECT mtsubconditionname FROM managetriggerctrl where mtconditiontype = 'con_sub' and mtconditionname='"+name+"' and mtmodule='"+module+"'";
// 		System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
}else if(field.equalsIgnoreCase("actionmain")){
	String module=request.getParameter("module");
	String sql="NA";
	if(name.equals("Group")){
		sql="select mtteamname from manageteamctrl where mtdepartment='Delivery' and mtstatus='1'";
	}else{
		sql="SELECT mtsubconditionname FROM managetriggerctrl where mtconditiontype = 'act_sub' and mtconditionname='"+name+"' and mtmodule='"+module+"'";
	}
	
	
	// 		System.out.println(sql);
	if(!sql.equals("NA")){
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}}
}

out.println(jsonArr);
}catch(Exception e){
	e.printStackTrace();
}finally{
	if(ps!=null){ps.close();}
	if(rs!=null){rs.close();}
}
%>