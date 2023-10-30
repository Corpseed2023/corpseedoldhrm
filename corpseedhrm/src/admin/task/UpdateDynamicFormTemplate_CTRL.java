package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdateDynamicFormTemplate_CTRL extends HttpServlet {	
	
	private static final long serialVersionUID = 6876401832178092868L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		PrintWriter pw=response.getWriter();
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
			
		String dynamicFormName = request.getParameter("dynamicFormName").trim();	
		String formDataJson = request.getParameter("formDataJson").trim();	
		String templateKey = request.getParameter("templateKey").trim();	
				
		boolean flag=TaskMaster_ACT.updateFormTemplate(templateKey,dynamicFormName,formDataJson,uavalidtokenno);
		
		if(flag) {
			pw.write("pass");
		}else {
			pw.write("fail");
		}
	}

}