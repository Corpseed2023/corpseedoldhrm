package client_master;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class IsAssignedTaskCTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session=request.getSession();
			boolean result=false;
			PrintWriter p=response.getWriter();
			String uid=request.getParameter("uid").trim();
			String taskid=request.getParameter("task").trim();
			String projectno=request.getParameter("projectno").trim();			
			String token=(String)session.getAttribute("uavalidtokenno");
			result=Clientmaster_ACT.isAssignedTask(uid,taskid,projectno,token);
			
			if(result) {
				p.write("pass");
			}else
				p.write("fail");
			
			
		}

		catch (Exception e) {
			
		}

	}

}