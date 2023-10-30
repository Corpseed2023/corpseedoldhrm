package admin.task;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ManageTask_CTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3969492053621676908L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		RequestDispatcher rd = null;
		HttpSession session = request.getSession();
		String uavalidtokenno111 = (String) session.getAttribute("uavalidtokenno");
		String uaIsValid = (String) session.getAttribute("loginuID");
		if (uaIsValid == null || uaIsValid.equals("") || uavalidtokenno111 == null || uavalidtokenno111.equals("")) {
			rd = request.getRequestDispatcher("/login.html");
			rd.forward(request, response);
		}
		String pregpname = null;
		String taskname = null;
		String assignon = null;
		String deliveron = null;
		String from =null;
		String to =null;
		String type = request.getParameter("jsstype");
		String pagename = request.getParameter("pageName");
		HttpSession SES = request.getSession(true);
		String check = request.getParameter("page_no");
		if (check == null) {
			SES.removeAttribute("pregpname");
			SES.removeAttribute("taskname");
			SES.removeAttribute("assignon");
			SES.removeAttribute("deliveron");
			SES.removeAttribute("from");
			SES.removeAttribute("to");
		} else {
			pregpname = (String) SES.getAttribute("pregpname");
			taskname = (String) SES.getAttribute("taskname");
			assignon = (String) SES.getAttribute("assignon");
			deliveron = (String) SES.getAttribute("deliveron");
			from = (String)SES.getAttribute("from");
			to= (String)SES.getAttribute("to");
		}
		RequestDispatcher RD = request.getRequestDispatcher("mtask/manage-task.jsp");
		RD.forward(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		RequestDispatcher rd = null;
		HttpSession session = request.getSession();
		String uavalidtokenno111 = (String) session.getAttribute("uavalidtokenno");
		String uaIsValid = (String) session.getAttribute("loginuID");
		if (uaIsValid == null || uaIsValid.equals("") || uavalidtokenno111 == null || uavalidtokenno111.equals("")) {
			rd = request.getRequestDispatcher("/login.html");
			rd.forward(request, response);
		}
		String type = request.getParameter("jsstype");
		String pagename = request.getParameter("pageName");
		if (type != null && pagename != null && type.equalsIgnoreCase("SSEqury")
				&& pagename.equalsIgnoreCase("manageservice.jsp")) {
			String pregpname = request.getParameter("pregpname").trim();
			String taskname = request.getParameter("taskname").trim();
			String assignon = request.getParameter("assignon").trim();
			String deliveron = request.getParameter("deliveron").trim();
			String from = request.getParameter("from").trim();
			String to = request.getParameter("to").trim();
			HttpSession SES = request.getSession(true);
			SES.setAttribute("pregpname", pregpname);
			SES.setAttribute("taskname", taskname);
			SES.setAttribute("assignon", assignon);
			SES.setAttribute("deliveron", deliveron);
			SES.setAttribute("from", from);
			SES.setAttribute("to", to);
			RequestDispatcher RD = request.getRequestDispatcher("mtask/manage-task.jsp");
			RD.forward(request, response);
		}
	}

}