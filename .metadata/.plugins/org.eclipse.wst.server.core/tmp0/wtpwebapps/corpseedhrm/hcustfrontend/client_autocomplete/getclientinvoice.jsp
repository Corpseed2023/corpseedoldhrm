
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
String loginUaid = (String) session.getAttribute("loginuaid");
String userRole=(String)session.getAttribute("userRole");
if(userRole==null||userRole.length()<=0)userRole="NA";


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

ResultSet rs=null;
Statement st=null;
try(Connection con=DbCon.getCon("","","")){
st=con.createStatement();
StringBuffer query =new StringBuffer("select b.cbestimateno from hrmclient_billing b left join hrmclient_reg h on b.cbclientrefid=h.cregclientrefid ");
if(userRole.equalsIgnoreCase("SUPER_USER"))
	query.append("where h.super_user_uaid='"+loginUaid+"' ");
else
	query.append("left join client_user_info c on h.creguid=c.client_id where c.user_id='"+loginUaid+"'");

query.append(" and (b.cbinvoiceno like '%"+name+"%' or b.cbestimateno like '%"+name+"%') and b.cbtokenno='"+token+"' order by b.cbinvoiceno desc limit 10");

rs=st.executeQuery(query.toString());
while(rs.next()){
	String invoice=rs.getString(1);
	if(invoice.equalsIgnoreCase("NA"))
		json.put("value",rs.getString(2));
	else
		json.put("value",invoice);
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