package hcustbackend;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdateMenuNotificationCTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session=request.getSession();
			  String clientloginuaid = (String) session.getAttribute("loginClintUaid");	          
	          String notificationtoken=(String)session.getAttribute("uavalidtokenno"); 
	          String name=request.getParameter("name").trim();
	          boolean unseenNotification = ClientACT.isUnseenNotification(notificationtoken,clientloginuaid,name);
	          if(unseenNotification)
	          ClientACT.markAsRead(clientloginuaid, notificationtoken, name);
	          
	          
		}catch (Exception e) {
				e.printStackTrace();
		}
	}

}
