<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="net.sf.json.JSONObject,net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="commons.DbCon"%>
<%
JSONArray jsonArr = new JSONArray();
JSONObject json=new JSONObject();
String token=(String)session.getAttribute("uavalidtokenno");
String query = (String)request.getParameter("name");
ResultSet rs=null;
Statement st=null;
try(Connection con=DbCon.getCon("","","")){
st=con.createStatement();
String sqlquery="SELECT emid,emuid,emname,emdept,emdesig FROM employee_master where !Exists(select salid from salary_structure where salemid=emid) and emname like '"+query+"%' and emtokenno='"+token+"' LIMIT 0 , 10";
// System.out.println(sqlquery);
rs = st.executeQuery(sqlquery);

while(rs.next())
{
	json.put("emid",rs.getString(1));
	json.put("emuid",rs.getString(2));
	json.put("name",rs.getString(3));
	json.put("value",rs.getString(3));
	json.put("emdept",rs.getString(4));
	json.put("emdesig",rs.getString(5));
    
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