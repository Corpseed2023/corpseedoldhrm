package invoice_master;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class GstHistory_CTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6448519425025074865L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		RequestDispatcher rd = null;
		HttpSession session = request.getSession();
		String uavalidtokenno111 = (String) session.getAttribute("uavalidtokenno");
		String uaIsValid = (String) session.getAttribute("loginuID");
		if (uaIsValid == null || uaIsValid.equals("") || uavalidtokenno111 == null || uavalidtokenno111.equals("")) {
			rd = request.getRequestDispatcher("/login.html");
			rd.forward(request, response);
		}
		String ghmonth = null;
		String ghcategory = null;
		String from =null;
		String to =null;

		String type = request.getParameter("jsstype");
		String pagename = request.getParameter("pageName");
		HttpSession SES = request.getSession(true);
		String check = request.getParameter("page_no");
		if (check == null) {
			SES.removeAttribute("ghmonth");
			SES.removeAttribute("ghcategory");
			SES.removeAttribute("from");
			SES.removeAttribute("to");
		} else {
			ghmonth = (String) SES.getAttribute("ghmonth");
			ghcategory = (String) SES.getAttribute("ghcategory");
			from = (String)SES.getAttribute("from");
			to= (String)SES.getAttribute("to");
		}
		RequestDispatcher RD = request.getRequestDispatcher("invoice_master/gst-history.jsp");
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
			String ghmonth = request.getParameter("ghmonth").trim();
			String ghcategory = request.getParameter("ghcategory").trim();
			String from = request.getParameter("from").trim();
			String to = request.getParameter("to").trim();
			HttpSession SES = request.getSession(true);
			SES.setAttribute("ghmonth", ghmonth);
			SES.setAttribute("ghcategory", ghcategory);
			SES.setAttribute("from", from);
			SES.setAttribute("to", to);
			RequestDispatcher RD = request.getRequestDispatcher("invoice_master/gst-history.jsp");
			RD.forward(request, response);
		}
	}

}
