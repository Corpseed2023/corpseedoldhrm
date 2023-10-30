package admin.task;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class TaskMaster_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			boolean status = false;
			HttpSession session = request.getSession();
			String ptltuid = request.getParameter("TaskID").trim();
			String ptlpuid = request.getParameter("pid").trim();
			String ptlby = request.getParameter("abid").trim();
			String ptlto = request.getParameter("atid").trim();
			String ptlname = request.getParameter("TaskName").trim();
			String ptlremark = request.getParameter("Remark").trim();
			String ptladate = request.getParameter("Assignedon").trim();
			String ptlddate = request.getParameter("DeliverOn").trim();
			String ptladdedby = request.getParameter("ptladdedby").trim();
			String uacompany= (String)session.getAttribute("uacompany");

			status = TaskMaster_ACT.saveTaskDetail(ptltuid, ptlpuid, ptlby, ptlto, ptlname, ptlremark, ptladate,
					ptlddate, ptladdedby,uacompany);

			if (status) {
				session.setAttribute("ErrorMessage", "Task is Successfully assigned!.");
				response.sendRedirect(request.getContextPath() + "/notification.html");
			} else {
				session.setAttribute("ErrorMessage", "Task is not assigned!.");
				response.sendRedirect(request.getContextPath() + "/notification.html");
			}
		}

		catch (Exception e) {
			
		}

	}
}