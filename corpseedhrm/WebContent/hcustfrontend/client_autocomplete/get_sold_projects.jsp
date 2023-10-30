
<%@page import="commons.DbCon"%>
<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="net.sf.json.JSONObject,net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%
JSONArray jsonArr = new JSONArray();
JSONObject json=new JSONObject();
String name = (String)request.getParameter("name");
String token= (String)session.getAttribute("uavalidtokenno");
String userRole=(String)session.getAttribute("userRole");
if(userRole==null||userRole.length()<=0)userRole="NA";
String loginuaid =(String)session.getAttribute("loginuaid");

ResultSet rs=null;
Statement st=null;
try(Connection con=DbCon.getCon("","","")){
if(loginuaid!=null){
st=con.createStatement();

StringBuffer query =new StringBuffer("select m.msrefid,m.msprojectnumber,m.msproductname,m.msunseenchat,m.project_close_date from managesalesctrl m left join ");

if(userRole.equalsIgnoreCase("SUPER_USER"))
	query.append("hrmclient_reg h on m.msclientrefid=h.cregclientrefid where h.super_user_uaid='"+loginuaid+"'");
else
	query.append("user_sales_info u on m.msid=u.sales_id where u.user_id = '"+loginuaid+"'");

query.append(" and (m.msprojectnumber like '"+name+"%' or m.msproductname like '"+name+"%') and m.mstoken='"+token+"' order by m.msid limit 10");
System.out.println(query);
rs=st.executeQuery(query.toString());
while(rs.next()){
	json.put("key",rs.getString(1));
	json.put("projectnumber",rs.getString(2));
	json.put("productname",rs.getString(3));
	json.put("unseenChat",rs.getString(4));
	json.put("closeDate",rs.getString(5));
	jsonArr.add(json);
}
out.println(jsonArr);
}

}catch(Exception e){
	e.printStackTrace();
}finally{
	if(st!=null){st.close();}
	if(rs!=null){rs.close();}
}
%>