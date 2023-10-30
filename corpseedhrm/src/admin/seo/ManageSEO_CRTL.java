package admin.seo;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ManageSEO_CRTL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4742414723484452845L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		RequestDispatcher rd = null;
		HttpSession session = request.getSession();
		String uavalidtokenno111 = (String) session.getAttribute("uavalidtokenno");
		String uaIsValid = (String) session.getAttribute("loginuID");
		if (uaIsValid == null || uaIsValid.equals("") || uavalidtokenno111 == null || uavalidtokenno111.equals("")) {
			rd = request.getRequestDispatcher("/login.html");
			rd.forward(request, response);
		}
		String projectname = null;
		String activitytype = null;
		String from =null;
		String to =null;
		String nature =null;
		String keyword =null;
		String taskname =null;
		String type = request.getParameter("jsstype");
		String pagename = request.getParameter("pageName");
		HttpSession SES = request.getSession(true);
		String check = request.getParameter("page_no");
		if (check == null) {
			SES.removeAttribute("projectname");
			SES.removeAttribute("activitytype");
			SES.removeAttribute("date");
			SES.removeAttribute("nature");
			SES.removeAttribute("keyword");
			SES.removeAttribute("taskname");
		} else {
			projectname = (String) SES.getAttribute("projectname");
			activitytype = (String) SES.getAttribute("activitytype");
			from = (String)SES.getAttribute("from");
			to= (String)SES.getAttribute("to");
			nature= (String)SES.getAttribute("nature");
			keyword= (String)SES.getAttribute("keyword");
			taskname= (String)SES.getAttribute("taskname");
		}
		RequestDispatcher RD = request.getRequestDispatcher("mseo/manage-seo.jsp");
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
			String projectname = request.getParameter("projectname").trim();
			String activitytype = request.getParameter("activitytype").trim();
			String from = request.getParameter("from").trim();
			String to = request.getParameter("to").trim();
			String nature = request.getParameter("nature").trim();
			String keyword = request.getParameter("keyword").trim();
			String taskname = request.getParameter("taskname").trim();
			HttpSession SES = request.getSession(true);
			SES.setAttribute("projectname", projectname);
			SES.setAttribute("activitytype", activitytype);
			SES.setAttribute("from", from);
			SES.setAttribute("to", to);
			SES.setAttribute("nature", nature);
			SES.setAttribute("keyword", keyword);
			SES.setAttribute("taskname", taskname);
			RequestDispatcher RD = request.getRequestDispatcher("mseo/manage-seo.jsp");
			RD.forward(request, response);
		}
	}

}