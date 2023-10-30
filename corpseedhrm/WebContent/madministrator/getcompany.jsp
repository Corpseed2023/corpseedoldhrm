<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="net.sf.json.JSONObject,net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="commons.DbCon"%>
<%
JSONArray jsonArr = new JSONArray();
JSONObject json=new JSONObject();
String query = (String)request.getParameter("name");
Statement st=null;
ResultSet rs=null;
try(Connection con=DbCon.getCon("","","")){
st=con.createStatement();
String sqlquery="SELECT compname FROM company_master where compname like '"+query+"%' LIMIT 0 , 20";
rs = st.executeQuery(sqlquery);

while(rs.next())
{
	json.put("name",rs.getString(1));
	json.put("value",rs.getString(1));
    
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