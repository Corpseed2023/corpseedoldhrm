package client_master;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class ManageAccountCTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		RequestDispatcher rd = null;
		HttpSession session = request.getSession();
		String uavalidtokenno111 = (String) session.getAttribute("uavalidtokenno");
		String uaIsValid = (String) session.getAttribute("loginuID");
		if (uaIsValid == null || uaIsValid.equals("") || uavalidtokenno111 == null || uavalidtokenno111.equals("")) {
			rd = request.getRequestDispatcher("/login.html");
			rd.forward(request, response);
		}
		
		RequestDispatcher RD = request.getRequestDispatcher("mclient/manage-account.jsp");
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
		HttpSession SES = request.getSession(true);
		if(request.getParameter("button").equalsIgnoreCase("Search")){
		String clientname = request.getParameter("clientname").trim();
		String clientmobile = request.getParameter("clientmobile").trim();
		String clientemail = request.getParameter("clientemail").trim();
		String from = request.getParameter("from").trim();
		String to = request.getParameter("to").trim();
		
		SES.setAttribute("mcaclientname", clientname);
		SES.setAttribute("mcaclientmobile", clientmobile);
		SES.setAttribute("mcaclientemail", clientemail);
		SES.setAttribute("mcafrom", from);
		SES.setAttribute("mcato", to);
		}else if(request.getParameter("button").equalsIgnoreCase("Reset")){
			SES.removeAttribute("mcaclientname");
			SES.removeAttribute("mcaclientmobile");
			SES.removeAttribute("mcaclientemail");
			SES.removeAttribute("mcafrom");
			SES.removeAttribute("mcato");
		}
		RequestDispatcher RD = request.getRequestDispatcher("mclient/manage-account.jsp");
		RD.forward(request, response);
	}
}