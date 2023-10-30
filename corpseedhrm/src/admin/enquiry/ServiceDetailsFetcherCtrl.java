package admin.enquiry;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.task.TaskMaster_ACT;

@SuppressWarnings("serial")
public class ServiceDetailsFetcherCtrl extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {		
									
			HttpSession session = request.getSession(); 
			
			String token = (String)session.getAttribute("uavalidtokenno");
			String salesKey=request.getParameter("salesKey").trim();		
			String remarks=TaskMaster_ACT.findSalesRemarksBySalesKeyAndtoken(salesKey,token);
			if(!remarks.equalsIgnoreCase("NA"))
				response.getWriter().write(remarks);
			
		}

		catch (Exception e) {
				e.printStackTrace();
		}

	}
}