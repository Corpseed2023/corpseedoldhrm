<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="net.sf.json.JSONObject,net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="commons.DbCon"%>
<%
JSONArray jsonArr = new JSONArray();
JSONObject json=new JSONObject();
String token = (String) session.getAttribute("uavalidtokenno");
String query = (String)request.getParameter("name");
String col = (String)request.getParameter("col");
Statement st=null;
ResultSet rs=null;
try(Connection con=DbCon.getCon("","","")){
st=con.createStatement();
String sqlquery="SELECT "+col+",creguid FROM hrmclient_reg where "+col+" like '%"+query+"%' and cregtokenno='"+token+"' LIMIT 0 , 10";
rs = st.executeQuery(sqlquery);

while(rs.next())
{
	json.put("name",rs.getString(1));
	json.put("value",rs.getString(1));
	json.put("id",rs.getString(2));	
    
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