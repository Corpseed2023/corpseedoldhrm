package client_master;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class updateDeliveryDate_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
	   
	   try
		{  
		 
		HttpSession session =request.getSession();

		String id = request.getParameter("id").trim();
		String ddate = request.getParameter("ddate").trim();
		String token = (String) session.getAttribute("uavalidtokenno");
		
		Clientmaster_ACT.updateProjectDeliveryDate( id, ddate, token);
		
		}catch (Exception e) {
		e.printStackTrace();
		}
	
	}

}
