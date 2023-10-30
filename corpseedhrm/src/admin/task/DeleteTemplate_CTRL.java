package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class DeleteTemplate_CTRL extends HttpServlet {
	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try
		{
			HttpSession session=request.getSession();
			PrintWriter pw=response.getWriter();
			String token=(String)session.getAttribute("uavalidtokenno");
			String templateKey=request.getParameter("templateKey").trim();			
			boolean flag=TaskMaster_ACT.deleteTemplate(templateKey,token);
			if(flag)pw.write("pass");
			else pw.write("fail");
		}catch (Exception e) {
			e.printStackTrace();
		}

	}
}
