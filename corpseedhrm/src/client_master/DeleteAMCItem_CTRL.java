package client_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class DeleteAMCItem_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session=request.getSession();
			String token=(String)session.getAttribute("uavalidtokenno");
			String itemid = request.getParameter("info").trim();
			Clientmaster_ACT.deleteAmcDetails(itemid,token);			
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}
