package salary_master;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class ManageSalStrCTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		RequestDispatcher rd = null;
		HttpSession session = request.getSession();
		String uavalidtokenno111 = (String) session.getAttribute("uavalidtokenno");
		String uaIsValid = (String) session.getAttribute("loginuID");
		if (uaIsValid == null || uaIsValid.equals("") || uavalidtokenno111 == null || uavalidtokenno111.equals("")) {
			rd = request.getRequestDispatcher("/login.html");
			rd.forward(request, response);
		}
		
		RequestDispatcher RD = request.getRequestDispatcher("salary_master/manage-salary-structure.jsp");
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
		if(request.getParameter("button").equalsIgnoreCase("Search")){	
		String from = request.getParameter("from").trim();
		String to = request.getParameter("to").trim();
		String empname = request.getParameter("empname").trim();
		String empid = request.getParameter("empid").trim();
		HttpSession SES = request.getSession(true);
		SES.setAttribute("mstfrom", from);
		SES.setAttribute("mstto", to);
		SES.setAttribute("msemname", empname);
		SES.setAttribute("mstempid", empid);
		}else if(request.getParameter("button").equalsIgnoreCase("Reset")){
			HttpSession SES = request.getSession(true);
			SES.removeAttribute("mstfrom");
			SES.removeAttribute("mstto");
			SES.removeAttribute("msemname");
			SES.removeAttribute("mstempid");
		}
		RequestDispatcher RD = request.getRequestDispatcher("salary_master/manage-salary-structure.jsp");
		RD.forward(request, response);
	}

}