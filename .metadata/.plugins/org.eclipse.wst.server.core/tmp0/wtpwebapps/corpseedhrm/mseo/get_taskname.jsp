<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="net.sf.json.JSONObject,net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="commons.DbCon"%>
<%

JSONArray jsonArr = new JSONArray();
JSONObject json=new JSONObject();
String token=(String)session.getAttribute("uavalidtokenno");
String loginuaid = (String)session.getAttribute("loginuaid");
String userroll= (String)session.getAttribute("emproleid");
String query = (String)request.getParameter("name");
Statement st=null;
ResultSet rs=null;
try(Connection con=DbCon.getCon("","","")){
st=con.createStatement();
StringBuffer sqlquery=new StringBuffer("SELECT ptluid,ptlname,ptlpuid FROM projecttask_list join hrmproject_reg on projecttask_list.ptlpuid=hrmproject_reg.preguid where");
if(!userroll.equalsIgnoreCase("Administrator")) sqlquery.append(" exists(select atid from assignedtaskid where attaskno=projecttask_list.ptltuid and atassignedid='"+loginuaid+"') and hrmproject_reg.pregtokenno='"+token+"' and projecttask_list.ptlname like '"+query+"%' and projecttask_list.ptlstatus!='Completed'");
else sqlquery.append(" hrmproject_reg.pregtokenno='"+token+"' and projecttask_list.ptlname like '%"+query+"%'");
// sqlquery.append(" LIMIT 0 , 20");
// System.out.println(sqlquery);
rs = st.executeQuery(sqlquery.toString());
while(rs.next())
{
	json.put("name",rs.getString(2));
	json.put("value",rs.getString(2));
    json.put("id",rs.getString(1));
    json.put("projectid",rs.getString(3));
    
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