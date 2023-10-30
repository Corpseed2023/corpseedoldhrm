<%@page import="org.slf4j.Logger"%>
<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="net.sf.json.JSONObject,net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="commons.DbCon"%>
<%

JSONArray jsonArr = new JSONArray();
JSONObject json=new JSONObject();
String name = (String)request.getParameter("name");
String field = (String)request.getParameter("field");
String token= (String)session.getAttribute("uavalidtokenno");

ResultSet rs=null;
PreparedStatement ps=null;


// System.out.println("field="+field+"/name=="+name);
try(Connection con=DbCon.getCon("","","")){

	if(field.equalsIgnoreCase("companynameContact")){
		/* String compname=request.getParameter("compname").trim();
		
		if(compname==null||compname==""||compname.length()<=0) compname="...."; */ 
		String suaid=request.getParameter("suaid").trim();
		
		StringBuffer sql=new StringBuffer("SELECT cccontactfirstname,cccontactlastname,ccemailfirst,ccworkphone,ccbrefid FROM clientcontactbox where super_user_id='"+suaid+"' and (cccontactfirstname like '%"+name+"%' or ccemailfirst like '%"+name+"%' or ccworkphone like '%"+name+"%') and ccstatus='1' LIMIT 0 , 10");
// 		System.out.println(sql);
		ps=con.prepareStatement(sql.toString());
		rs =ps.executeQuery();
		while(rs.next())
		{		
	        json.put("label",rs.getString(1)+" "+rs.getString(2)+" / "+rs.getString(4)+" / "+rs.getString(3));
	 	    json.put("value",rs.getString(1)+" "+rs.getString(2));
		    json.put("email",rs.getString(3));
		    json.put("mobile",rs.getString(4));
		    json.put("key",rs.getString(5));
		    	       
		    jsonArr.add(json);
		}
	}
	
if(field.equalsIgnoreCase("companyname")){
	String suaid=request.getParameter("suaid").trim();
	String sql="SELECT cregname,cregaddress,cregclientrefid FROM hrmclient_reg where super_user_uaid='"+suaid+"' and cregname like '%"+name+"%'  and cregstatus='1' LIMIT 0 , 10";
// 	System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{		
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    json.put("address",rs.getString(2));
	    json.put("cregrefid",rs.getString(3));
	    	       
	    jsonArr.add(json);
	}
}

if(field.equalsIgnoreCase("companynamenew")){
	String sql="SELECT cregname,cregaddress,cregclientrefid,super_user_uaid FROM hrmclient_reg where cregname like '%"+name+"%'  and cregstatus='1' LIMIT 0 , 10";
// 	System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{		
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    json.put("address",rs.getString(2));
	    json.put("cregrefid",rs.getString(3));
	    json.put("suaid",rs.getString(4));
	    	       
	    jsonArr.add(json);
	}
}

out.println(jsonArr);
}catch(Exception e){
	e.printStackTrace();
}finally{
	if(ps!=null)ps.close();
	if(rs!=null)rs.close();
}
	
%>