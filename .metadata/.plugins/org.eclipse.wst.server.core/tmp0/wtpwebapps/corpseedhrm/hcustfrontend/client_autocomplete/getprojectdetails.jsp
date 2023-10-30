
<%@page import="commons.DbCon"%>
<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="net.sf.json.JSONObject,net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%
JSONArray jsonArr = new JSONArray();
JSONObject json=new JSONObject();
String name = (String)request.getParameter("name");
String loginuaid =(String)session.getAttribute("loginuaid");
String token= (String)session.getAttribute("uavalidtokenno");
String userRole=(String)session.getAttribute("userRole");
if(userRole==null||userRole.length()<=0)userRole="NA";

String doAction=(String)session.getAttribute("ClientOrderDoAction");
if(doAction==null||doAction.length()<=0)doAction="All";

String searchFromToDate=(String)session.getAttribute("searchFromToDate");
if(searchFromToDate==null||searchFromToDate.length()<=0)searchFromToDate="NA";
String fromDate="NA";
String toDate="NA";
if(!searchFromToDate.equalsIgnoreCase("NA")) {
	fromDate=searchFromToDate.substring(0,10).trim();
	fromDate=fromDate.substring(6,10)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
	toDate=searchFromToDate.substring(13).trim();
	toDate=toDate.substring(6,10)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
}

Statement st=null;
ResultSet rs=null;
try(Connection con=DbCon.getCon("","","")){
st=con.createStatement();
StringBuffer query =new StringBuffer("select m.msprojectnumber,m.msproductname from managesalesctrl m left join ");

if(userRole.equalsIgnoreCase("SUPER_USER"))
	query.append("hrmclient_reg h on m.msclientrefid=h.cregclientrefid where h.super_user_uaid='"+loginuaid+"'");
else
	query.append("user_sales_info u on m.msid=u.sales_id where u.user_id = '"+loginuaid+"'");

if(!doAction.equalsIgnoreCase("NA")&&doAction.equalsIgnoreCase("In Progress"))query.append(" and m.msworkpercent!='100'");
if(!doAction.equalsIgnoreCase("NA")&&doAction.equalsIgnoreCase("Completed"))query.append(" and m.msworkpercent='100'");
if(!doAction.equalsIgnoreCase("NA")&&doAction.equalsIgnoreCase("Unread"))query.append(" and m.msunseenchat!='0'");
if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA"))query.append(" and str_to_date(m.mssolddate,'%d-%m-%Y')<='"+toDate+"' and str_to_date(m.mssolddate,'%d-%m-%Y')>='"+fromDate+"' ");
query.append(" and (m.msprojectnumber like '"+name+"%' or m.msproductname like '"+name+"%') and m.mstoken='"+token+"' order by m.msid limit 10");
rs=st.executeQuery(query.toString());
while(rs.next()){
	json.put("name",rs.getString(1)+" : "+rs.getString(2));
	json.put("value",rs.getString(1)+" : "+rs.getString(2));
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