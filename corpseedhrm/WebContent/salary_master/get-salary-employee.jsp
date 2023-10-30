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
Statement st=null;
ResultSet rs=null;
try(Connection con=DbCon.getCon("","","")){
st=con.createStatement();
String sqlquery="SELECT emid, emuid, emname, emdept, emdesig, salleaves, salgross, salbasic, salda, salhra, salcon, salmed, salspecial, salbonus, salta, salded, salpf, salptax, saltds, salnet FROM employee_master join salary_structure on emid=salemid where emname like '"+query+"%' and emtokenno='"+token+"' and salstatus='1' LIMIT 0 , 20";
rs = st.executeQuery(sqlquery);

while(rs.next())
{
	json.put("emid",rs.getString(1));
	json.put("emuid",rs.getString(2));
	json.put("emname",rs.getString(3));
	json.put("emdept",rs.getString(4));
	json.put("emdesig",rs.getString(5));
	json.put("salleaves",rs.getString(6));
	json.put("salgross",rs.getString(7));
	json.put("salbasic",rs.getString(8));
	json.put("salda",rs.getString(9));
	json.put("salhra",rs.getString(10));
	json.put("salcon",rs.getString(11));
	json.put("salmed",rs.getString(12));
	json.put("salspecial",rs.getString(13));
	json.put("salbonus",rs.getString(14));
	json.put("salta",rs.getString(15));
	json.put("salded",rs.getString(16));
	json.put("salpf",rs.getString(17));
	json.put("salptax",rs.getString(18));
	json.put("saltds",rs.getString(19));
	json.put("salnet",rs.getString(20));
    
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