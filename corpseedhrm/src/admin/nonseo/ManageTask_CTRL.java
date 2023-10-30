package admin.nonseo;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class ManageTask_CTRL  extends HttpServlet {

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
		String from =null;
		String to =null;
		String type = request.getParameter("jsstype");
		String pagename = request.getParameter("pageName");
		HttpSession SES = request.getSession(true);
		String check = request.getParameter("page_no");
		if (check == null) {
			SES.removeAttribute("pregpname");
			SES.removeAttribute("from");
			SES.removeAttribute("to");
		} else {
			pregpname = (String) SES.getAttribute("pregpname");
			from = (String)SES.getAttribute("from");
			to= (String)SES.getAttribute("to");
		}
		RequestDispatcher RD = request.getRequestDispatcher("mnonseo/nonseo-manage-task.jsp");
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
			String pregpname = request.getParameter("pregpname");
			String from = request.getParameter("from").trim();
			String to = request.getParameter("to").trim();
			HttpSession SES = request.getSession(true);
			SES.setAttribute("pregpname", pregpname);
			SES.setAttribute("from", from);
			SES.setAttribute("to", to);
			RequestDispatcher RD = request.getRequestDispatcher("mnonseo/nonseo-manage-task.jsp");
			RD.forward(request, response);
		}
	}

}