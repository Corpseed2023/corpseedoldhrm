package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdateSalesReminder_CTRL extends HttpServlet {	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1090963577862127456L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		PrintWriter pw=response.getWriter();
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
			
		String remKey = request.getParameter("remKey").trim();	
		String taskName = request.getParameter("taskName").trim();	
		String Time = request.getParameter("Time").trim();	
		String Date = request.getParameter("Date").trim();	
		
		
		boolean flag=TaskMaster_ACT.updateSalesReminder(remKey,taskName,Date,Time,uavalidtokenno);		
		if(flag) {
			pw.write("pass");
		}else {
			pw.write("fail");
		}
	}

}