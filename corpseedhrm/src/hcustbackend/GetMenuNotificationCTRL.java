package hcustbackend;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class GetMenuNotificationCTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session=request.getSession();
			  String clientloginuaid = (String) session.getAttribute("loginClintUaid");	          
	          String notificationtoken=(String)session.getAttribute("uavalidtokenno"); 
	          boolean order=false;
	          boolean chat=false;
	          boolean document=false;
	          boolean payment=false;
	          order=ClientACT.isUnseenNotification(notificationtoken,clientloginuaid,"client_orders.html");
		      chat=ClientACT.isUnseenNotification(notificationtoken,clientloginuaid,"client_inbox.html");
		      document=ClientACT.isUnseenNotification(notificationtoken,clientloginuaid,"client_documents.html");
		      payment=ClientACT.isUnseenNotification(notificationtoken,clientloginuaid,"client_payments.html");
			response.getWriter().write(order+"#"+chat+"#"+document+"#"+payment);
		}catch (Exception e) {
				e.printStackTrace();
		}
	}

}
