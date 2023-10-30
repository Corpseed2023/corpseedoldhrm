<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="net.sf.json.JSONObject,net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="commons.DbCon"%>
<%
JSONArray jsonArr = new JSONArray();
JSONObject json=new JSONObject();
String mid = (String)request.getParameter("mid");
String token= (String)session.getAttribute("uavalidtokenno");
ResultSet rs=null;
PreparedStatement ps=null;
try(Connection con=DbCon.getCon("","","")){
String smsid="NA";
String emailid="NA";
	StringBuffer sql=new StringBuffer("SELECT smsid,emailid FROM project_milestone where id='"+mid+"' and tokenno='"+token+"'");
	
	ps=con.prepareStatement(sql.toString());
	rs =ps.executeQuery();
	if(rs.next()){
		smsid=rs.getString(1);
		emailid=rs.getString(2);
	}
	if(!smsid.equalsIgnoreCase("NA")&&!emailid.equalsIgnoreCase("NA")){
		ps=con.prepareStatement("select tid,tname,ttype from manage_template where tid='"+smsid+"' or tid='"+emailid+"'");
		rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("tid",rs.getString(1));
		json.put("tname",rs.getString(2));
	    json.put("ttype",rs.getString(3));    
	    	       
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