package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@SuppressWarnings("serial")
public class CloseSalesReminder_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		PrintWriter pw=response.getWriter();
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
			
		String remKey = request.getParameter("remKey").trim();	
				
		boolean flag=TaskMaster_ACT.closeSalesReminder(remKey,uavalidtokenno);		
		if(flag) {
			pw.write("pass");
		}else {
			pw.write("fail");
		}
	}

}