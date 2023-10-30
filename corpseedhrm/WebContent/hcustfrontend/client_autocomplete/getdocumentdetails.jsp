
<%@page import="commons.DbCon"%>
<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="net.sf.json.JSONObject,net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%
JSONArray jsonArr = new JSONArray();
JSONObject json=new JSONObject();
String name = (String)request.getParameter("name");
//String clientid =request.getParameter("clientid");
String token= (String)session.getAttribute("uavalidtokenno");
String loginUaid = (String) session.getAttribute("loginuaid");
String userRole=(String)session.getAttribute("userRole");
if(userRole==null||userRole.length()<=0)userRole="NA";

String doActionDocuments=(String)session.getAttribute("doActionDocuments");
if(doActionDocuments==null||doActionDocuments.length()<=0)doActionDocuments="Projects";

Statement st=null;
ResultSet rs=null;
try(Connection con=DbCon.getCon("","","")){
st=con.createStatement();
StringBuffer query=new StringBuffer("select f.fname from folder_master f left join ");

if(userRole.equalsIgnoreCase("SUPER_USER"))query.append("hrmclient_reg h on f.fclientid=h.creguid where h.super_user_uaid='"+loginUaid+"'");
else query.append("managesalesctrl m on f.fsalesrefid=m.msrefid left join user_sales_info u on m.msid=u.sales_id where u.user_id='"+loginUaid+"'");
		
if(doActionDocuments.equalsIgnoreCase("Projects"))query.append(" and f.ffcategory='Sub' and f.ftype='Sales'");
else if(doActionDocuments.equalsIgnoreCase("Personal"))query.append(" and f.ffcategory='Main' and f.ftype='Personal'");
query.append(" and f.ftokenno='"+token+"' and f.fname like '"+name+"%' order by f.fid desc limit 10");
rs=st.executeQuery(query.toString());
while(rs.next()){
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