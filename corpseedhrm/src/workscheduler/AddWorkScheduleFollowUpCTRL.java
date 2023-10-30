package workscheduler;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class AddWorkScheduleFollowUpCTRL extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession();

		String fstatus = request.getParameter("fstatus").trim();
		String remarks = request.getParameter("remarks").trim();
		String wsuid = request.getParameter("wsuid").trim();
		String addedby = (String) session.getAttribute("loginuID");

		WorkSchedulerACT.saveWorkScheduleFollowUp(wsuid, fstatus, remarks, addedby);

	}

}
