package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdateSmsEmailTemplate_CTRL extends HttpServlet {	
	
	private static final long serialVersionUID = 6876401832178092868L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		PrintWriter pw=response.getWriter();
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
//		String uaid = (String) session.getAttribute("loginuaid");
		
			
		String templateKey = request.getParameter("templateKey").trim();	
		String templateName = request.getParameter("templateName").trim();
		String templateSubject=request.getParameter("templateSubject");
		String templateDescription=request.getParameter("templateDescription");
		
		
		boolean flag=TaskMaster_ACT.updateTemplate(templateKey,templateName,templateSubject,templateDescription,uavalidtokenno);		
		if(flag) {
			pw.write("pass");
		}else {
			pw.write("fail");
		}
	}

}