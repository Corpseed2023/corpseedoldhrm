package admin.report;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdatePriorityCTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1662021379138261773L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		HttpSession session = request.getSession();

		try {
			String pid = request.getParameter("pid").trim();
			String key = request.getParameter("key").trim();
			String target = request.getParameter("target").trim();
			String priority = request.getParameter("priority").trim();
			String addedby = (String)session.getAttribute("loginuID");
			
			Report_ACT.updatePriority(pid,key,target, priority,addedby);
		}
		catch (Exception e) {
			
		}

	}

}
