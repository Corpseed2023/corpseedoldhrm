<%@page import="commons.DateUtil"%>
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
// System.out.println("field=="+field);
String token= (String)session.getAttribute("uavalidtokenno");
String loginuaid = (String)session.getAttribute("loginuaid");
String userRole= (String)session.getAttribute("userRole");

ResultSet rs=null;
PreparedStatement ps=null;
try(Connection con=DbCon.getCon("","","")){

if(field.equalsIgnoreCase("salesenq"))
{
	
	String sql="SELECT cregname,cregcontname,cregmob,cregcontmobile,cregemailid,creglocation,cregaddress FROM hrmclient_reg where cregname like '%"+name+"%' and cregtokenno='"+token+"' and cregstatus='1' LIMIT 0 , 10";
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("cregname",rs.getString(1));
		json.put("cregcontname",rs.getString(2));
	    json.put("cregmob",rs.getString(3));	
	    json.put("cregcontmobile",rs.getString(4));
		json.put("cregemailid",rs.getString(5));
	    json.put("creglocation",rs.getString(6));
	    json.put("cregaddress",rs.getString(7));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("estimatecontactname")){
	
	StringBuffer queryselect=new StringBuffer("SELECT cb.cbname FROM contactboxctrl cb inner join estimatesalectrl e on cb.cbrefid=e.escontactrefid where e.estoken='"+token+"' and cb.cbname like '%"+name+"%' and cb.cbtokenno='"+token+"'");
	if(!userRole.equalsIgnoreCase("NA")&&!loginuaid.equalsIgnoreCase("NA")&&userRole.equalsIgnoreCase("Executive")) queryselect.append(" and e.essoldbyid = '"+loginuaid+"' ");
	if(!userRole.equalsIgnoreCase("NA")&&!loginuaid.equalsIgnoreCase("NA")&&userRole.equalsIgnoreCase("Assistant"))
		queryselect.append("and exists(select t.mtid from manageteamctrl t join manageteammemberctrl m on t.mtrefid=m.tmteamrefid where t.mtadminid='"+loginuaid+"' and m.tmuseruid=e.essoldbyid or e.essoldbyid='"+loginuaid+"') ");
	queryselect.append(" group by cb.cbname LIMIT 0 , 10");
	ps=con.prepareStatement(queryselect.toString());
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("estimateclientname"))
{
	
	StringBuffer VCQUERY=new StringBuffer("SELECT escompany FROM estimatesalectrl  where escompany like '%"+name+"%' and estoken='"+token+"'");
	if(!userRole.equalsIgnoreCase("NA")&&!loginuaid.equalsIgnoreCase("NA")&&userRole.equalsIgnoreCase("Executive")) VCQUERY.append(" and essoldbyid = '"+loginuaid+"' ");
	if(!userRole.equalsIgnoreCase("NA")&&!loginuaid.equalsIgnoreCase("NA")&&userRole.equalsIgnoreCase("Assistant"))
		VCQUERY.append("and exists(select t.mtid from manageteamctrl t join manageteammemberctrl m on t.mtrefid=m.tmteamrefid where t.mtadminid='"+loginuaid+"' and m.tmuseruid=essoldbyid or essoldbyid='"+loginuaid+"') ");
	VCQUERY.append("  group by escompany LIMIT 0 , 10");
	ps=con.prepareStatement(VCQUERY.toString());
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("invoiceDetails")){
	
	StringBuffer queryselect=new StringBuffer("SELECT m.msinvoiceno,c.cregname,c.creggstin,c.cregaddress,concat(c.cregstate,concat('(',concat(c.cregstatecode,')'))) as place_of_supply	FROM managesalesctrl m inner join hrmclient_reg c on m.msclientrefid=c.cregclientrefid where m.msinvoiceno like '%"+name+"%' and m.mstoken='"+token+"' order by m.msinvoiceno desc LIMIT 0 , 10");
	
	ps=con.prepareStatement(queryselect.toString());
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    json.put("client",rs.getString(2));
	    json.put("gstin",rs.getString(3));
	    json.put("address",rs.getString(4));
	    json.put("supply",rs.getString(5));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("serviceName")){
	
	StringBuffer queryselect=new StringBuffer("SELECT ms.msproductname FROM managesalesctrl ms join manage_assignctrl m on m.masalesrefid=ms.msrefid where");
	
	if(!userRole.equalsIgnoreCase("Admin")&&!userRole.equalsIgnoreCase("Super Admin"))
		queryselect.append(" m.mateammemberid='"+loginuaid+"' and");
	
	queryselect.append(" ms.msproductname like '%"+name+"%' and ms.mstoken='"+token+"' and ms.msstatus='1' group by ms.msproductname LIMIT 0 , 10");
// 	System.out.println(queryselect);
	ps=con.prepareStatement(queryselect.toString());
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("docDeliveryclientname")){
	
	StringBuffer queryselect=new StringBuffer("SELECT mscompany FROM managesalesctrl where mscompany like '%"+name+"%' and mstoken='"+token+"' and msstatus='1'");
	if(!userRole.equalsIgnoreCase("Admin")&&!userRole.equalsIgnoreCase("Super Admin")&&!userRole.equalsIgnoreCase("Manager"))
		queryselect.append("and document_assign_uaid='"+loginuaid+"' ");
	queryselect.append(" group by mscompany LIMIT 0 , 10");
// 	System.out.println(queryselect);
	ps=con.prepareStatement(queryselect.toString());
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("deliveryclientname")){
	
	StringBuffer queryselect=new StringBuffer("SELECT mscompany FROM managesalesctrl where mscompany like '%"+name+"%' and mstoken='"+token+"' and msstatus='1'");
	if(!userRole.equalsIgnoreCase("NA")&&userRole.equalsIgnoreCase("Assistant")){
		queryselect.append(" and exists(select t.mtid from manageteamctrl t where msassignedtorefid=t.mtrefid and t.mtadminid='"+loginuaid+"' and t.mttoken='"+token+"') ");
	}
	queryselect.append(" group by mscompany LIMIT 0 , 10");
// 	System.out.println(queryselect);
	ps=con.prepareStatement(queryselect.toString());
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("salesclientname"))
{
	
	StringBuffer queryselect=new StringBuffer("SELECT mscompany FROM managesalesctrl where mscompany like '%"+name+"%' and mstoken='"+token+"' and msstatus='1'");
	if(!userRole.equalsIgnoreCase("NA")&&userRole.equalsIgnoreCase("Executive")) queryselect.append(" and mssoldbyuid = '"+loginuaid+"'");
	if(!userRole.equalsIgnoreCase("NA")&&!loginuaid.equalsIgnoreCase("NA")&&userRole.equalsIgnoreCase("Assistant"))
		queryselect.append(" and exists(select t.mtid from manageteamctrl t join manageteammemberctrl m on t.mtrefid=m.tmteamrefid where t.mtadminid='"+loginuaid+"' and m.tmuseruid=mssoldbyuid or mssoldbyuid='"+loginuaid+"')");
	queryselect.append(" group by mscompany LIMIT 0 , 10");
	ps=con.prepareStatement(queryselect.toString());
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("clientname"))
{
	
	String sql="SELECT creguid,cregname,cregclientrefid FROM hrmclient_reg where cregname like '%"+name+"%' and cregtokenno='"+token+"' and cregstatus='1' LIMIT 0 , 10";
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("cid",rs.getString(1));
		json.put("name",rs.getString(2));
	    json.put("value",rs.getString(2));	
	    json.put("key",rs.getString(3));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("unbillCompanyName")){
	String sql="SELECT e.escompany FROM salesestimatepayment s INNER JOIN estimatesalectrl e on s.sestsaleno=e.essaleno where s.stransactionstatus='1' and e.escompany like '%"+name+"%' and s.stokenno= '"+token+"' and s.sinvoice_status='2' group by e.escompany limit 10";
// 	String sql="SELECT sunbill_no FROM salesestimatepayment where sunbill_no like '%"+name+"%' and stokenno='"+token+"' and sinvoice_status='2' and stransactionstatus='1' LIMIT 0 , 10";
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("invoiceCompanyNameInvoiced")){
	String sql="SELECT company FROM invoice where company like '%"+name+"%' and token= '"+token+"' and status='1' group by company limit 10";
	/* System.out.println(sql); */
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("invoiceCompanyName")){
	String sql="SELECT bill_to FROM manage_invoice where bill_to like '%"+name+"%' and token= '"+token+"' and active_status='1' group by bill_to limit 10";
	System.out.println(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("refInvoiceNumber")){
	String sql="SELECT ref_invoice FROM manage_invoice where ref_invoice like '%"+name+"%' and token= '"+token+"' and active_status='1' group by ref_invoice limit 10";
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("manageInvoiceFilter")){
	String sql="SELECT invoice_no FROM manage_invoice where invoice_no like '%"+name+"%' and token= '"+token+"' and active_status='1' group by invoice_no";
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("unbill_no")){
	
	String sql="SELECT sunbill_no FROM salesestimatepayment where sunbill_no like '%"+name+"%' and stokenno='"+token+"' and sinvoice_status='2' and stransactionstatus='1' LIMIT 0 , 10";
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("invoice_no"))
{
	
	String sql="SELECT invoice_no FROM invoice where invoice_no like '%"+name+"%' and token='"+token+"' and status='1' LIMIT 0 , 10";
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("invoiceCompanyName"))
{
	
	String sql="SELECT company FROM invoice where company like '%"+name+"%' and token='"+token+"' and status='1' LIMIT 0 , 10";
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("estimateNumber"))
{
	
	String sql="SELECT essaleno FROM estimatesalectrl where essaleno like '%"+name+"%' and estoken='"+token+"' group by essaleno LIMIT 0 , 10";
// 	System.out.print(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("salesInvoiceNo")){
	
	String sql="SELECT msinvoiceno,msproductname FROM managesalesctrl where msinvoiceno like '%"+name+"%' and mstoken='"+token+"' group by msinvoiceno LIMIT 0 , 10";
// 	System.out.print(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1)+" : "+rs.getString(2));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("docDalesInvoiceNo")){
	
	StringBuffer sql=new StringBuffer("SELECT msinvoiceno,msproductname FROM managesalesctrl where msstatus='1' ");
	if(!userRole.equalsIgnoreCase("Admin")&&!userRole.equalsIgnoreCase("Super Admin")&&!userRole.equalsIgnoreCase("Manager"))
		sql.append("and document_assign_uaid='"+loginuaid+"' ");	
	sql.append("and msinvoiceno like '%"+name+"%' and mstoken='"+token+"' group by msinvoiceno LIMIT 0,10");
// 	System.out.print(sql.toString());
	ps=con.prepareStatement(sql.toString());
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1)+" : "+rs.getString(2));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("billingInvoiceNo"))
{	
	String sql="SELECT cbinvoiceno FROM hrmclient_billing where cbinvoiceno like '%"+name+"%' and cbtokenno='"+token+"' and cbinvoiceno!='NA' LIMIT 0 , 10";
// 	System.out.print(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("salesPhoneNo"))
{
	
	String sql="SELECT cb.cbmobile1st,cb.cbrefid,cb.cbname,ms.msinvoiceno FROM contactboxctrl cb join managesalesctrl ms on cb.cbrefid=ms.mscontactrefid where ms.mstoken='"+token+"' and ms.msstatus='1' and cb.cbmobile1st like '%"+name+"%' and cb.cbtokenno='"+token+"' group by ms.msinvoiceno LIMIT 0 , 10";
// 	System.out.print(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(4)+" : "+rs.getString(1)+" - "+rs.getString(3));
	    json.put("value",rs.getString(1));
	    json.put("key",rs.getString(2));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("taskcontactname")){
	String today=DateUtil.getCurrentDateIndianReverseFormat();
	StringBuffer sql=new StringBuffer("SELECT cb.cbname FROM manage_assignctrl ma INNER JOIN managesalesctrl ms on ma.masalesrefid=ms.msrefid INNER JOIN contactboxctrl cb on ms.mscontactrefid=cb.cbrefid where ma.masaleshierarchystatus='1' and ma.mahierarchyactivestatus='1' and ma.maapprovalstatus='1' and ma.mastepstatus='1' and ma.mateammemberid!='NA' and ma.matokenno='"
	+ token + "' and ma.maworkstarteddate!='00-00-0000' and cb.cbname like '%"+name+"%'");
	if (!userRole.equalsIgnoreCase("NA") && (userRole.equalsIgnoreCase("Assistant")
	|| userRole.equalsIgnoreCase("Manager") || userRole.equalsIgnoreCase("Executive"))) {
		sql.append(" and ma.mateammemberid='" + loginuaid
		+ "' and ma.mamemberassigndate!='00-00-0000' and str_to_date(ma.mamemberassigndate,'%d-%m-%Y')<='"
		+ today + "' ");
	}
		sql.append("group by cb.cbname LIMIT 0 , 10");
// 	System.out.print(sql);
	ps=con.prepareStatement(sql.toString());
	rs =ps.executeQuery();
	while(rs.next())
	{
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("invoicedcontactname"))
{
	StringBuffer queryselect=new StringBuffer("SELECT contact_name FROM invoice where status='1' and contact_name like '%"+name+"%'");
	queryselect.append(" group by contact_name LIMIT 0 , 10");
	ps=con.prepareStatement(queryselect.toString());
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("unbilledcontactname"))
{
	StringBuffer queryselect=new StringBuffer("SELECT cb.cbname FROM contactboxctrl cb INNER JOIN estimatesalectrl e on "
	+ "cb.cbrefid=e.escontactrefid INNER JOIN salesestimatepayment s on s.sestsaleno=e.essaleno where s.stransactionstatus='1' and s.stokenno= '"+token+"' "
	+ "and s.sinvoice_status='2' and cb.cbname like '%"+name+"%'");
	queryselect.append(" group by cb.cbname LIMIT 0 , 10");
	ps=con.prepareStatement(queryselect.toString());
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("billingcontactname")){
	
	StringBuffer queryselect=new StringBuffer("SELECT cb.cbname FROM contactboxctrl cb inner join hrmclient_billing b on cb.cbrefid=b.cbcontactrefid where b.cbtokenno='"+token+"' and cb.cbname like '%"+name+"%' and cb.cbtokenno='"+token+"'");
	queryselect.append(" group by cb.cbname LIMIT 0 , 10");
	ps=con.prepareStatement(queryselect.toString());
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("expenseclientname")){
	
	StringBuffer queryselect=new StringBuffer("SELECT expclientname FROM expense_approval_ctrl where exptoken= '"+token+"' and expclientname like '%"+name+"%'");
	queryselect.append(" group by expclientname LIMIT 0 , 10");
	
	ps=con.prepareStatement(queryselect.toString());
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("expensecontactmobile")){
	
	StringBuffer queryselect=new StringBuffer("SELECT expclientmobile FROM expense_approval_ctrl where exptoken= '"+token+"' and expclientmobile like '%"+name+"%'");
	queryselect.append(" group by expclientmobile LIMIT 0 , 10");
	ps=con.prepareStatement(queryselect.toString());
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("docDeliverycontactname")){
	
	StringBuffer queryselect=new StringBuffer("SELECT cb.cbname FROM contactboxctrl cb inner join managesalesctrl ms on cb.cbrefid=ms.mscontactrefid where ms.mstoken='"+token+"' and ms.msstatus='1' and cb.cbname like '%"+name+"%' and cb.cbtokenno='"+token+"'");
	if(!userRole.equalsIgnoreCase("Admin")&&!userRole.equalsIgnoreCase("Super Admin")&&!userRole.equalsIgnoreCase("Manager"))
		queryselect.append("and ms.document_assign_uaid='"+loginuaid+"' ");
	
	queryselect.append(" group by cb.cbname LIMIT 0 , 10");
	ps=con.prepareStatement(queryselect.toString());
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("deliverycontactname")){
	
	StringBuffer queryselect=new StringBuffer("SELECT cb.cbname FROM contactboxctrl cb inner join managesalesctrl ms on cb.cbrefid=ms.mscontactrefid where ms.mstoken='"+token+"' and ms.msstatus='1' and cb.cbname like '%"+name+"%' and cb.cbtokenno='"+token+"'");
	if(!userRole.equalsIgnoreCase("NA")&&userRole.equalsIgnoreCase("Assistant")){
		queryselect.append(" and exists(select mtid from manageteamctrl t where ms.msassignedtorefid=t.mtrefid and t.mtadminid='"+loginuaid+"' and t.mttoken='"+token+"') ");
	}
	queryselect.append(" group by cb.cbname LIMIT 0 , 10");
	ps=con.prepareStatement(queryselect.toString());
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("salescontactname"))
{
	
	StringBuffer queryselect=new StringBuffer("SELECT cb.cbname FROM contactboxctrl cb inner join managesalesctrl ms on cb.cbrefid=ms.mscontactrefid where ms.mstoken='"+token+"' and ms.msstatus='1' and cb.cbname like '%"+name+"%' and cb.cbtokenno='"+token+"'");
	if(!userRole.equalsIgnoreCase("NA")&&userRole.equalsIgnoreCase("Executive")) queryselect.append(" and ms.mssoldbyuid = '"+loginuaid+"'");
	if(!userRole.equalsIgnoreCase("NA")&&!loginuaid.equalsIgnoreCase("NA")&&userRole.equalsIgnoreCase("Assistant"))
		queryselect.append(" and exists(select t.mtid from manageteamctrl t join manageteammemberctrl m on t.mtrefid=m.tmteamrefid where t.mtadminid='"+loginuaid+"' and m.tmuseruid=ms.mssoldbyuid or ms.mssoldbyuid='"+loginuaid+"')");
	queryselect.append(" group by cb.cbname LIMIT 0 , 10");
	ps=con.prepareStatement(queryselect.toString());
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("contactname"))
{
	
	String sql="SELECT cb.cbrefid,cb.cbname,ms.msinvoiceno FROM contactboxctrl cb join managesalesctrl ms on cb.cbrefid=ms.mscontactrefid where ms.mstoken='"+token+"' and ms.msstatus='1' and cb.cbname like '%"+name+"%' and cb.cbtokenno='"+token+"' group by ms.msinvoiceno LIMIT 0 , 10";
// 	System.out.print(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(3)+" : "+rs.getString(2));
	    json.put("value",rs.getString(2));
	    json.put("key",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("salesProductName"))
{
	
	String sql="SELECT msproductname FROM managesalesctrl where msproductname like '%"+name+"%' and mstoken='"+token+"' group by msproductname LIMIT 0 , 10";
// 	System.out.print(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("SoldByName"))
{
	
	String sql="SELECT uaname,uaid FROM user_account where exists(select msid from managesalesctrl where mssoldbyuid=uaid and mstoken='"+token+"') and uaname like '%"+name+"%' and uavalidtokenno='"+token+"' LIMIT 0 , 10";
// 	System.out.print(sql);
	ps=con.prepareStatement(sql);
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1));
	    json.put("value",rs.getString(1));
	    json.put("uaid",rs.getString(2));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("mytaskClientName"))
{
	
	StringBuffer sql=new StringBuffer("SELECT ms.msclientrefid,ms.mscompany FROM manage_assignctrl ma INNER JOIN managesalesctrl ms on ma.masalesrefid=ms.msrefid where ma.matokenno='"+token+"'");
	if(!userRole.equalsIgnoreCase("NA")&&(userRole.equalsIgnoreCase("Assistant")||userRole.equalsIgnoreCase("Manager")||userRole.equalsIgnoreCase("Executive"))){
		sql.append(" and ma.mateammemberid='"+loginuaid+"'");
	}
	sql.append(" and ms.mscompany like '%"+name+"%' and ms.mstoken='"+token+"' group by ms.mscompany LIMIT 0 , 10");
// 		System.out.print(sql);
	ps=con.prepareStatement(sql.toString());
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(2));
	    json.put("value",rs.getString(2));
	    json.put("clientKey",rs.getString(1));
	    	       
	    jsonArr.add(json);
	}
	
}else if(field.equalsIgnoreCase("mytaskInvoiceNo"))
{
	
	StringBuffer sql=new StringBuffer("SELECT msinvoiceno,msrefid,msproductname FROM managesalesctrl where exists(select maid from manage_assignctrl where masalesrefid=msrefid and matokenno='"+token+"'");
	if(!userRole.equalsIgnoreCase("NA")&&(userRole.equalsIgnoreCase("Assistant")||userRole.equalsIgnoreCase("Manager")||userRole.equalsIgnoreCase("Executive"))){
		sql.append(" and mateammemberid='"+loginuaid+"'");
	}
	sql.append(") and msinvoiceno like '%"+name+"%' and mstoken='"+token+"' group by msrefid LIMIT 0 , 10");
// 		System.out.print(sql);
	ps=con.prepareStatement(sql.toString());
	rs =ps.executeQuery();
	while(rs.next())
	{
		json.put("name",rs.getString(1)+" : "+rs.getString(3));
	    json.put("value",rs.getString(1));
	    json.put("salesKey",rs.getString(2));
	    	       
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