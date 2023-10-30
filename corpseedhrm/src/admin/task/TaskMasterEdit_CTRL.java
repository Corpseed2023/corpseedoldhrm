package admin.task;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class TaskMasterEdit_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		try {
			boolean status = false;
			HttpSession session = request.getSession();
			String ptluid = request.getParameter("uid").trim();
			String ptltuid = request.getParameter("TaskID").trim();
			String ptlpuid = request.getParameter("pid").trim();
			String ptlby = request.getParameter("abid").trim();		
			String ptlname = request.getParameter("TaskName").trim();
			String ptlremark = request.getParameter("Remark2").trim();
			String ptladate = request.getParameter("Assignedon").trim();
			String ptlddate = request.getParameter("DeliverOn").trim();
			String ptladdedby = request.getParameter("ptladdedby").trim();
			
			status = TaskMaster_ACT.updateTaskDetail(ptluid, ptltuid, ptlpuid, ptlby,ptlname, ptlremark, ptladate, ptlddate, ptladdedby);

			if (status) {
//				session.setAttribute("ErrorMessage", "Task is Successfully Updated!.");
				response.sendRedirect(request.getContextPath() + "/mytask.html");
			} else {
				session.setAttribute("ErrorMessage", "Task is not Updated!.");
				response.sendRedirect(request.getContextPath() + "/notification.html");
			}
		}

		catch (Exception e) {
			
		}

	}

}
