<%@page import="admin.enquiry.Enquiry_ACT"%>
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
String addedby=(String)session.getAttribute("loginuID");
ResultSet rs=null;
PreparedStatement ps=null;
try(Connection con=DbCon.getCon("","","")){
if(field.equalsIgnoreCase("salesinvoice")){
	String sql="SELECT msinvoiceno,mscontactrefid FROM managesalesctrl where msinvoiceno like '%"+name+"%' and mstoken='"+token+"' group by msinvoiceno limit 10";
// 		System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
		json.put("value",rs.getString(1));
		String cname="NA";
		String cmobile="NA";
		String contact[][]=Enquiry_ACT.getClientDetails(rs.getString(2), token);
		if(contact!=null&&contact.length>0){
	cname=contact[0][0];
	cmobile=contact[0][1];
		}
		json.put("cname",cname);
		json.put("cmobile",cmobile);
	    jsonArr.add(json);
	}
}else if(field.equalsIgnoreCase("salehsntax")){
	String sql="SELECT mtrefid,mthsncode,mtsgstpercent,mtcgstpercent,mtigstpercent FROM managetaxctrl where mthsncode like '%"+name+"%' and mttoken='"+token+"' limit 10";
// 		System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(2)+" -> "+rs.getString(4)+"% CGST -> "+rs.getString(3)+"% SGST -> "+rs.getString(5)+" % IGST");
		json.put("value",rs.getString(2)); 
		json.put("refid",rs.getString(1));
	    json.put("hsn",rs.getString(2));    
	    json.put("sgst",rs.getString(3));   
	    json.put("cgst",rs.getString(4));   
	    json.put("igst",rs.getString(5));   
	    	       
	    jsonArr.add(json);
	}
}else if(field.equalsIgnoreCase("GetProductDetails")){
	String sql="SELECT pname,pdescription,ptype FROM product_master where prefid = '"+name+"' and ptokenno='"+token+"'";
// 		System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("type",rs.getString(3));    
	    json.put("remarks",rs.getString(2));   
	    	       
	    jsonArr.add(json);
	}
}else if(field.equalsIgnoreCase("producttypename")){
	String sql="SELECT stypename,sid FROM service_type where stypename like '%"+name+"%' and stokenno='"+token+"' and sstatus='1'  LIMIT 0 , 10";
// 		System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));    
	    json.put("sid",rs.getString(2));   
	    	       
	    jsonArr.add(json);
	}
}else if(field.equalsIgnoreCase("productname")){
	String sql="SELECT pid,pname,ptype,pdescription,prefid,pcentral,pstate,pglobal FROM product_master where pname like '%"+name+"%' and ptokenno='"+token+"' and pstatus='1'  LIMIT 0 , 10";
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("pid",rs.getString(1));
		json.put("name",rs.getString(2));
	    json.put("value",rs.getString(2));    
	    json.put("ptype",rs.getString(3));    
	    json.put("pdesc",rs.getString(4));  
	    json.put("prefid",rs.getString(5)); 
	    json.put("central",rs.getString(6));
	    json.put("state",rs.getString(7));
	    json.put("global",rs.getString(8));
	    	       
	    jsonArr.add(json);
	}
}else if(field.equalsIgnoreCase("productData")){
	String sql="SELECT pid,pname,ptype,pdescription,prefid,tat_value,tat_type FROM product_master where prefid='"+name+"' and ptokenno='"+token+"' and pstatus='1'";
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("pid",rs.getString(1));
		json.put("name",rs.getString(2));
	    json.put("value",rs.getString(2));    
	    json.put("ptype",rs.getString(3));    
	    json.put("pdesc",rs.getString(4));  
	    json.put("prefid",rs.getString(5));   
	    json.put("tatValue",rs.getString(6)); 
	    json.put("tatType",rs.getString(7)); 
	    	       
	    jsonArr.add(json);
	}
}else if(field.equalsIgnoreCase("productprice")){
	String sql="SELECT ppid,pp_service_type,pp_price,pp_hsncode,pp_igstpercent,pp_total_price FROM product_price where pp_prodrefid = '"+name+"' and pp_tokenno='"+token+"' order by ppid";
// 	System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("id",rs.getString(1));
		json.put("service",rs.getString(2));
	    json.put("price",rs.getString(3));    
	    json.put("hsn",rs.getString(4));    
	    json.put("igst",rs.getString(5));  
	    json.put("total",rs.getString(6));    
	    	       
	    jsonArr.add(json);
	}
}else if(field.equalsIgnoreCase("Select2Gst")){
	String sql="SELECT vtselect2id,vtselect2tax FROM virtualtaxidctrl where vtprodrefid = '"+name+"' and vttoken='"+token+"' and vtaddedby='"+addedby+"'";
// 	System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("id",rs.getString(1));
		json.put("tax",rs.getString(2));
	    	       
	    jsonArr.add(json);
	}
}else if(field.equalsIgnoreCase("productmilestone")){
	String sql="SELECT pmid,pm_milestonename,pm_timelinevalue,pm_timelineunit,pmsteps,pm_assign,pm_pricepercent FROM product_milestone where pm_prodrefid = '"+name+"' and pm_tokeno='"+token+"' order by pmid";
// 	System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("id",rs.getString(1));
		json.put("name",rs.getString(2));
	    json.put("timelinevalue",rs.getString(3));    
	    json.put("timelineunit",rs.getString(4));    
	    json.put("step",rs.getString(5));  
	    json.put("assign",rs.getString(6));    
	    json.put("pricePercent",rs.getString(7));    
	    	       
	    jsonArr.add(json);
	}
}else if(field.equalsIgnoreCase("productdocument")){
	String sql="SELECT pdid,pd_docname,pd_description,pd_uploadby,pd_visibility FROM product_documents where pd_prodrefid = '"+name+"' and pd_token='"+token+"' order by pdid";
// 	System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("id",rs.getString(1));
		json.put("name",rs.getString(2));
	    json.put("description",rs.getString(3));    
	    json.put("uploadby",rs.getString(4)); 
	    json.put("visibility",rs.getString(5)); 
	    	       
	    jsonArr.add(json);
	}
}
out.println(jsonArr);
}catch(Exception e){
	e.printStackTrace();
}finally{
	if(ps!=null){ps.close();}
	if(rs!=null){rs.close();}
}
%>