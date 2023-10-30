package client_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@SuppressWarnings("serial")
public class AddItemVirtual_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();	 

		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String loginuID = (String) session.getAttribute("loginuID");
		
			String projectid = request.getParameter("projectid").trim();
			String itemid = request.getParameter("itemid").trim();	
			String clientid = request.getParameter("clientid").trim();	
			
			
			Clientmaster_ACT.addBillingPrice(projectid,itemid,loginuID,uavalidtokenno,"billing",clientid);		
			
	}

}