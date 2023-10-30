package billing;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import client_master.Clientmaster_ACT;

public class BillUpdateStatus_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
	
		try
		{
			String uid=request.getParameter("info").trim();
			Clientmaster_ACT.deleteBill(uid);		
			
		}catch (Exception e) {
		
		}
	}

}
