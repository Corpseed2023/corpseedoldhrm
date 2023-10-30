
<%@page import="commons.DbCon"%>
<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="net.sf.json.JSONObject,net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%
JSONArray jsonArr = new JSONArray();
JSONObject json=new JSONObject();
String salesKey = (String)request.getParameter("salesKey");

String token= (String)session.getAttribute("uavalidtokenno");

Statement st=null;
ResultSet rs=null;
try(Connection con=DbCon.getCon("","","")){
st=con.createStatement();
String query="";
query="select sdrefid,sduploaddocname,sddescription,sddocname from salesdocumentctrl where sdsalesrefid='"+salesKey+"' and sdtokenno='"+token+"' and sduploadby='Client' and sdstatus='1' and sdvisibility='1' order by sddocname";
// System.out.println(query);
rs=st.executeQuery(query);
while(rs.next()){
	json.put("docKey",rs.getString(1));
	json.put("uploadDocName",rs.getString(2));
	json.put("description",rs.getString(3));
	json.put("DocName",rs.getString(4));
	
	jsonArr.add(json);
}
out.println(jsonArr);
}catch(Exception e){
	e.printStackTrace();
}finally{
	if(st!=null){st.close();}
	if(rs!=null){rs.close();}
}
%>