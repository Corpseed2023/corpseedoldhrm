package admin.nonseo;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class NonSeoUpdate_CTRL extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 6117941748568146333L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			boolean status = false;
			HttpSession session = request.getSession();

			String uid=request.getParameter("uid").trim();
			String dartuid = request.getParameter("tid").trim();
			String darremarks = request.getParameter("longdescription").trim();
			String darstatus = request.getParameter("tstatus").trim();

			status = NonSeo_ACT.nonSeoTaskUpdate(uid, dartuid,darremarks,darstatus);
			
			if (status) {
				session.setAttribute("ErrorMessage", "Task is Successfully updated!");
				response.sendRedirect(request.getContextPath() + "/notification.html");
			} else {
				session.setAttribute("ErrorMessage", "task is not updated!");
				response.sendRedirect(request.getContextPath() + "/notification.html");
			}
		}

		catch (Exception e) {
			
		}

	}

}
