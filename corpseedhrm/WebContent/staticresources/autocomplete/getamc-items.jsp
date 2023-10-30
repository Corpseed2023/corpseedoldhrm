<%@page import="admin.task.TaskMaster_ACT"%>
<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="net.sf.json.JSONObject,net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="commons.DbCon"%>
<%
JSONArray jsonArr = new JSONArray();
JSONObject json=new JSONObject();

String id = (String)request.getParameter("pid");
String token= (String)session.getAttribute("uavalidtokenno");
Connection con=null;
ResultSet rs=null;
PreparedStatement ps=null;
con=DbCon.getCon("","","");
String sql=null;

sql="SELECT id,pricetype FROM project_price WHERE !EXISTS(select vid from virtual_project_price join clientbillingmapping WHERE (virtual_project_price.vpriceid=id OR clientbillingmapping.cbmppid=id) and (virtual_project_price.vpricefrom='amc' OR clientbillingmapping.cbmcategory='amc') and clientbillingmapping.cbmpaymentstatus='0') and preguid='"+id+"' and tokenno='"+token+"' and servicetype='Renewal' and enq='NA' order by id desc";
// System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	
	while(rs.next())
	{
		json.put("id",rs.getString(1));		
		json.put("value",rs.getString(2));
		
		jsonArr.add(json);
	}
	
if(con!=null){con.close();}
if(ps!=null){ps.close();}
if(rs!=null){rs.close();}
out.println(jsonArr);
%>