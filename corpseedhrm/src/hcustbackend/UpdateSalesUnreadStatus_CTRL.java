package hcustbackend;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdateSalesUnreadStatus_CTRL extends HttpServlet {
	
	private static final long serialVersionUID = -9061601386575213509L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		   		
		try {
			String salesKey=request.getParameter("salesKey").trim();	
			HttpSession session=request.getSession();
			
			String token=(String)session.getAttribute("uavalidtokenno");
			//update client unread status
			ClientACT.updateFollowUpUnread(salesKey,token);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
