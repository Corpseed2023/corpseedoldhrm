package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@SuppressWarnings("serial")
public class RemoveNotificationCTRL extends HttpServlet {	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		    String nkey = request.getParameter("nkey").trim();	
			
			HttpSession session=request.getSession();
			PrintWriter pw=response.getWriter();
			String token= (String)session.getAttribute("uavalidtokenno");
			
			boolean flag=TaskMaster_ACT.removeNotification(nkey,token);
			if(flag)pw.write("pass");
			else pw.write("fail");
	}

}