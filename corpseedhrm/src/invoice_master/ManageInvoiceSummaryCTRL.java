package invoice_master;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ManageInvoiceSummaryCTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8433281841684195402L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		RequestDispatcher rd = null;
		HttpSession session = request.getSession();
		String uavalidtokenno111 = (String) session.getAttribute("uavalidtokenno");
		String uaIsValid = (String) session.getAttribute("loginuID");
		if (uaIsValid == null || uaIsValid.equals("") || uavalidtokenno111 == null || uavalidtokenno111.equals("")) {
			rd = request.getRequestDispatcher("/login.html");
			rd.forward(request, response);
		}
		String clientid = null;
		String clientname = null;
		String projectid = null;
		String projectname = null;
		String invoiceno = null;
		String month = null;
		String pstatus = null;
		String from =null;
		String to =null;

		String type = request.getParameter("jsstype");
		String pagename = request.getParameter("pageName");
		HttpSession SES = request.getSession(true);
		String check = request.getParameter("page_no");
		if (check == null) {
			SES.removeAttribute("clientid");
			SES.removeAttribute("clientname");
			SES.removeAttribute("projectid");
			SES.removeAttribute("projectname");
			SES.removeAttribute("invoiceno");
			SES.removeAttribute("month");
			SES.removeAttribute("pstatus");
			SES.removeAttribute("from");
			SES.removeAttribute("to");
		} else {
			clientid = (String) SES.getAttribute("clientid");
			projectname = (String) SES.getAttribute("projectname");
			clientname = (String) SES.getAttribute("clientname");
			projectid = (String) SES.getAttribute("projectid");
			invoiceno = (String) SES.getAttribute("invoiceno");
			month = (String) SES.getAttribute("month");
			pstatus = (String) SES.getAttribute("pstatus");
			from = (String)SES.getAttribute("from");
			to= (String)SES.getAttribute("to");
		}
		RequestDispatcher RD = request.getRequestDispatcher("invoice_master/invoice-summary.jsp");
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
			String clientid = request.getParameter("clientid").trim();
			String projectid = request.getParameter("projectid").trim();
			String clientname = request.getParameter("clientname").trim();
			String projectname = request.getParameter("projectname").trim();
			String invoiceno = request.getParameter("invoiceno").trim();
			String month = request.getParameter("month").trim();
			String pstatus = request.getParameter("pstatus").trim();
			String from = request.getParameter("from").trim();
			String to = request.getParameter("to").trim();
			HttpSession SES = request.getSession(true);
			SES.setAttribute("clientid", clientid);
			SES.setAttribute("projectid", projectid);
			SES.setAttribute("clientname", clientname);
			SES.setAttribute("projectname", projectname);
			SES.setAttribute("invoiceno", invoiceno);
			SES.setAttribute("month", month);
			SES.setAttribute("pstatus", pstatus);
			SES.setAttribute("from", from);
			SES.setAttribute("to", to);
			RequestDispatcher RD = request.getRequestDispatcher("invoice_master/invoice-summary.jsp");
			RD.forward(request, response);
		}
	}

}
