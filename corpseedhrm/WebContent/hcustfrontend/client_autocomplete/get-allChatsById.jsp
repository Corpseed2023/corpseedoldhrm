
<%@page import="commons.CommonHelper"%>
<%@page import="java.nio.file.Files"%>
<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="net.sf.json.JSONObject,net.sf.json.JSONArray"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="commons.DbCon"%>
<%
JSONArray jsonArr = new JSONArray();
JSONObject json=new JSONObject();

String token= (String)session.getAttribute("uavalidtokenno");
String clientKey1=request.getParameter("clientKey");
String salesKey=request.getParameter("salesKey");
ResultSet rs=null;
PreparedStatement ps=null;
String sql=null;
try(Connection con=DbCon.getCon("","","")){
	Properties properties = new Properties();
	properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));				
	
	sql="select pfkey,pfmilestonekey,pfmilestonename,pfdynamicform,pfcontent,pffilename,"
	+"pfdate,pftime,pfsubmitstatus,pfaddedbyuid,pfaddedbyname,pfformsubmitstatus,"
	+"pfdynamicformname,pfunreadstatus from hrmproject_followup where "
	+"pfsaleskey='"+salesKey+"' and pftokenno='"+token+"' and pfstatus='1' order by pfuid desc limit 0,10";
// 	System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	
	while(rs.next())
	{
		json.put("key",rs.getString(1));		
		json.put("milestoneKey",rs.getString(2));
		json.put("milestoneName",rs.getString(3));
		json.put("dynamicForm",rs.getString(4));
		json.put("content",rs.getString(5));
		json.put("fileName",rs.getString(6));
		json.put("date",rs.getString(7));
		json.put("time",rs.getString(8));
		json.put("submitStatus",rs.getString(9));
		json.put("addedbyUid",rs.getString(10));
		json.put("addedbyName",rs.getString(11));
		json.put("formStatus",rs.getString(12));
		json.put("formName",rs.getString(13));
		json.put("unread",rs.getString(14));
		
		String fileName=rs.getString(6);
		String extension="";
		String size="";
		if(fileName!=null&&!fileName.equalsIgnoreCase("NA")&&fileName.length()>0){
		
	boolean fileExist=CommonHelper.isFileExists(fileName);
	long bytes=0;
	if(fileExist){
		bytes=CommonHelper.getBlobSize(fileName);
	}			
	long kb=bytes/1024;
	long mb=kb/1024;	
	
	if(mb>=1)size=mb+" MB";
	else if(kb>=1) size=kb+" KB";
	else size=bytes+" bytes";
	int index=rs.getString(6).lastIndexOf(".");
	extension=rs.getString(6).substring(index);
		}
		json.put("extension",extension);
		json.put("size",size);
		
		jsonArr.add(json);
	}

out.println(jsonArr);
}catch(Exception e){
	e.printStackTrace();
}finally{
	if(ps!=null){ps.close();}
	if(rs!=null){rs.close();}
}
%>