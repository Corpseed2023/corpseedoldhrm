package client_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;


public class Clientmaster_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
  
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		try
		{
			boolean status =false;
			HttpSession session = request.getSession();
			
			String cregucid = request.getParameter("clientID").trim();
			String cregmob = request.getParameter("ClientMobile").trim();
			String cregname = request.getParameter("clientName").trim();
			String cregemailid = request.getParameter("ClientEmail").trim();
			String cregaddress = request.getParameter("ClientAddress").trim();
			String creglocation = request.getParameter("CompanyLocation").trim();
			String cregcontname = request.getParameter("ContactName").trim();
			String cregcontemailid = request.getParameter("ContactEmail").trim();
			String cregcontmobile = request.getParameter("ContactMobile").trim();
			String cregcontrole = request.getParameter("ContactRole").trim();
			String cregpan = request.getParameter("PAN").trim();
			String creggstin = request.getParameter("GSTIN").trim();
			String cregstatecode = request.getParameter("statecode").trim();
			String company_age = request.getParameter("company_age").trim();
			String addeduser=(String)session.getAttribute("loginuID");
			String token=(String)session.getAttribute("uavalidtokenno");
			String uacompany= (String)session.getAttribute("uacompany");
			String uaaip = request.getRemoteAddr();
			String uaabname = request.getHeader("User-Agent");
			String key =RandomStringUtils.random(30, true, true);
			String clientkey =RandomStringUtils.random(40, true, true);

//		status=Clientmaster_ACT.saveClientDetail(cregucid,cregmob,cregname,cregemailid,cregaddress,creglocation,cregcontname,cregcontrole,cregcontemailid,cregcontmobile,cregpan,creggstin,cregstatecode,addeduser, token,clientkey);
//		Clientmaster_ACT.openAccount(cregucid, cregname, addeduser,token);
		
		//creating userregister
//		String x[]=cregname.split(" ");
//		
//		String uapassword=x[0]+cregmob.substring(1, 5);
//		status=Usermaster_ACT.saveUserDetail(token,cregmob,uapassword,cregname,cregmob,cregemailid,"NA",addeduser,uaaip,uaabname,"Client",cregucid, uacompany,key,"NA","NA");
		if(status) {
//			session.setAttribute("ErrorMessage", "Client is Successfully registered!.");
			response.sendRedirect(request.getContextPath()+"/manage-client.html");
		}
		else {
			session.setAttribute("ErrorMessage", "Client is not registered!.");
			response.sendRedirect(request.getContextPath()+"/notification.html");
		}
	}
		
		catch(Exception e)
		{
				
		}
		
	}

}