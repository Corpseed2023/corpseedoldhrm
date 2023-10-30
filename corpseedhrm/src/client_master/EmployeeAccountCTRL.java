package client_master;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class EmployeeAccountCTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		RequestDispatcher rd = null;
		HttpSession session = request.getSession();
		String uavalidtokenno111 = (String) session.getAttribute("uavalidtokenno");
		String uaIsValid = (String) session.getAttribute("loginuID");
		if (uaIsValid == null || uaIsValid.equals("") || uavalidtokenno111 == null || uavalidtokenno111.equals("")) {
			rd = request.getRequestDispatcher("/login.html");
			rd.forward(request, response);
		}
		String clientname = null;
		String clientmobile = null;
		String clientemail = null;
		String from =null;
		String to =null;

		HttpSession SES = request.getSession(true);
		String check = request.getParameter("page_no");
		if (check == null) {
			SES.removeAttribute("clientname");
			SES.removeAttribute("clientmobile");
			SES.removeAttribute("clientemail");
			SES.removeAttribute("from");
			SES.removeAttribute("to");
		} else {
			clientname = (String) SES.getAttribute("clientname");
			clientmobile = (String) SES.getAttribute("clientmobile");
			clientemail = (String) SES.getAttribute("clientemail");
			from = (String)SES.getAttribute("from");
			to= (String)SES.getAttribute("to");
		}
		RequestDispatcher RD = request.getRequestDispatcher("mclient/employee-account.jsp");
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
		String clientname = request.getParameter("clientname").trim();
		String clientmobile = request.getParameter("clientmobile").trim();
		String clientemail = request.getParameter("clientemail").trim();
		String from = request.getParameter("from").trim();
		String to = request.getParameter("to").trim();
		HttpSession SES = request.getSession(true);
		SES.setAttribute("clientname", clientname);
		SES.setAttribute("clientmobile", clientmobile);
		SES.setAttribute("clientemail", clientemail);
		SES.setAttribute("from", from);
		SES.setAttribute("to", to);
		RequestDispatcher RD = request.getRequestDispatcher("mclient/employee-account.jsp");
		RD.forward(request, response);
	}
}