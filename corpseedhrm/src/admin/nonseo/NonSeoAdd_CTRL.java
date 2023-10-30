package admin.nonseo;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class NonSeoAdd_CTRL extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 7004763307290347435L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		try {
			boolean status = false;
			HttpSession session = request.getSession();

			String dartuid = request.getParameter("tid").trim();
			String darremarks = request.getParameter("longdescription").trim();
			String darstatus = request.getParameter("tstatus").trim();
			String daraddedby = (String)session.getAttribute("loginuID");
			status = NonSeo_ACT.nonSeoTaskAdd(dartuid,darremarks,darstatus,daraddedby);
			
			if (status) {
				session.setAttribute("ErrorMessage", "Task is Successfully saved!");
				response.sendRedirect(request.getContextPath() + "/notification.html");
			} else {
				session.setAttribute("ErrorMessage", "Task is not saved!");
				response.sendRedirect(request.getContextPath() + "/notification.html");
			}
		}

		catch (Exception e) {
			
		}

	}

}