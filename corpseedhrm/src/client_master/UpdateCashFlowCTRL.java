package client_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdateCashFlowCTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
	   
	   try
		{  
		HttpSession session =request.getSession();
		
		String token= (String)session.getAttribute("uavalidtokenno");
		String transtatus = request.getParameter("status").trim();
		String refid = request.getParameter("refid").trim();
			
		Clientmaster_ACT.updateCashFlowStatus(refid, transtatus, token);	
		
		}catch (Exception e) {
			e.printStackTrace();
		}
	
	}

}
