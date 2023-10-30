package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@SuppressWarnings("serial")
public class DeleteThisTaskChat_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		PrintWriter pw=response.getWriter();
				
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
			
			String TaskKey = request.getParameter("TaskKey").trim();			
			
			boolean flag=TaskMaster_ACT.removeTaskChat(TaskKey,uavalidtokenno);
			
			if(flag)pw.write("pass");
			else pw.write("fail");
	}

}