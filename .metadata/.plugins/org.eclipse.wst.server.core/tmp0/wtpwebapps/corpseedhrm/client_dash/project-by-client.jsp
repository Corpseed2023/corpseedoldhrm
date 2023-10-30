<%@page import="client_master.Clientmaster_ACT"%>
<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="net.sf.json.JSONObject,net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%> 
<%@page import="java.util.*"%>
<%@page import="commons.DbCon"%>
<%
JSONArray jsonArr = new JSONArray();
JSONObject json=new JSONObject();
String query = (String)request.getParameter("name");
String uaname = (String)session.getAttribute("uaname");
String clientID = Clientmaster_ACT.getClientIDByLoginName(uaname);
Statement st=null;
ResultSet rs=null;
try(Connection con=DbCon.getCon("","","")){
st=con.createStatement();
String sqlquery="SELECT preguid,pregpname FROM hrmproject_reg where pregpname like '"+query+"%' and pregcuid = '"+clientID+"' and pregtype='SEO' LIMIT 0 , 20";
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