<%@page import="admin.task.TaskMaster_ACT"%>
<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="net.sf.json.JSONObject,net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="commons.DbCon"%>
<%
JSONArray jsonArr = new JSONArray();
JSONObject json=new JSONObject();

String id = (String)request.getParameter("aid");
String token= (String)session.getAttribute("uavalidtokenno");
String userroll= (String)session.getAttribute("emproleid");
String loginuaid = (String)session.getAttribute("loginuaid");
ResultSet rs=null;
PreparedStatement ps=null;
try(Connection con=DbCon.getCon("","","")){
String sql=null;
if(!userroll.equalsIgnoreCase("Administrator"))
	sql="SELECT aid,amilestoneid FROM assigntask WHERE ataskid='"+id+"' and aassignedtoid='"+loginuaid+"' and atokenno='"+token+"' and ataskstatus!='Completed' order by aid desc";
	else
		sql="SELECT aid,amilestoneid FROM assigntask WHERE ataskid='"+id+"' and aassignedtoid!='NA' and atokenno='"+token+"' group by amilestoneid order by aid desc";	
	
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	List li =new ArrayList();
	List li1=new ArrayList();
	while(rs.next())
	{
		li.add(rs.getString(1));
		String mname=TaskMaster_ACT.getMilestoneName(rs.getString(2),token);
		li1.add(mname); 
	}
	String[] str=new String[li.size()];
	Iterator it=li.iterator();
	String[] str1=new String[li1.size()];
	Iterator it1=li1.iterator();
	
	if(it.hasNext()){
		while(it.hasNext())
		{
	String p=(String)it.next();
	String q=(String)it1.next();
	
	json.put("id",p);			
	json.put("value",q);
	 jsonArr.add(json);			
	 }
	}
	else{
		String resultnot="No Result";
		json.put("id"," ");
		json.put("value",resultnot);
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