<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="net.sf.json.JSONObject,net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="commons.DbCon"%>
<%
JSONArray jsonArr = new JSONArray();
JSONObject json=new JSONObject();
String query = request.getParameter("name");
String uacompany=(String)session.getAttribute("uacompany");
String token = (String) session.getAttribute("uavalidtokenno");
Statement st=null;
ResultSet rs=null;
try(Connection con=DbCon.getCon("","","")){
st=con.createStatement();
String sqlquery="SELECT uaid,uaname FROM user_account where uaname like '"+query+"%' and uastatus = '1' and uavalidtokenno='"+token+"' LIMIT 0 , 20";
// System.out.println(sqlquery);
rs = st.executeQuery(sqlquery);

while(rs.next())
{
	json.put("name",rs.getString(2));
	json.put("value",rs.getString(2));
    json.put("id",rs.getString(1));
    
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