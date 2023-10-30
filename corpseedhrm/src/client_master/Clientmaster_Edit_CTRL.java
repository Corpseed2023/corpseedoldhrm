package client_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class Clientmaster_Edit_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
		
		try
		{  
		 boolean status=false;
		HttpSession session =request.getSession();

		String uid = request.getParameter("uid");

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
		
		status=Clientmaster_ACT.updateClient( uid, cregucid, cregmob, cregname, cregemailid, cregaddress, creglocation, cregcontname, cregcontemailid,cregcontmobile , cregcontrole,cregpan,creggstin,cregstatecode);
		if(status)
		{
//			session.setAttribute("ErrorMessage", "Client is Successfully Updated!.");
			response.sendRedirect(request.getContextPath()+"/manage-client.html");
		}
		else {
			session.setAttribute("ErrorMessage", "Client is not Updated!.");
		}

		}catch (Exception e) {
		
		}
		
		
	}

}
