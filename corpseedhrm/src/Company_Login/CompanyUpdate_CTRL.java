package Company_Login;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import client_master.Clientmaster_ACT;

public class CompanyUpdate_CTRL extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 813193679097578449L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			boolean status = false;
			HttpSession session = request.getSession();

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

			status = Clientmaster_ACT.updateClient(uid, cregucid, cregmob, cregname, cregemailid, cregaddress,
					creglocation, cregcontname, cregcontemailid, cregcontmobile, cregcontrole, cregpan, creggstin,
					cregstatecode);
			if (status) {
				session.setAttribute("ErrorMessage", "Company Details are Successfully Updated!.");
			} else {
				session.setAttribute("ErrorMessage", "Company Details are not Updated!.");
			}

			response.sendRedirect(request.getContextPath() + "/client-notification.html");
			
		} catch (Exception e) {
			
		}

	}

}
