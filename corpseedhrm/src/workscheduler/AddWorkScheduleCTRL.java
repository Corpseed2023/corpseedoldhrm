package workscheduler;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class AddWorkScheduleCTRL extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		boolean status = false;
		HttpSession session = request.getSession();

		String today = request.getParameter("today").trim();
		String schedulefor = request.getParameter("schedulefor").trim();
		String type = request.getParameter("type").trim();
		String taskname = request.getParameter("taskname").trim();
		String remarks = request.getParameter("remarks").trim();
		String addedby = request.getParameter("addedby");

		status = WorkSchedulerACT.saveWorkSchedule(today, schedulefor, type, taskname, remarks, addedby);

		if (status) {
			session.setAttribute("ErrorMessage", "Work Schedule is Successfully saved!");
			response.sendRedirect(request.getContextPath() + "/notification.html");
		} else {
			session.setAttribute("ErrorMessage", "Work Schedule is not saved!");
			response.sendRedirect(request.getContextPath() + "/notification.html");
		}

	}

}
