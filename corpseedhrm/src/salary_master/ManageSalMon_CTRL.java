package salary_master;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ManageSalMon_CTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6048692150927119402L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		RequestDispatcher rd = null;
		HttpSession session = request.getSession();
		String uavalidtokenno111 = (String) session.getAttribute("uavalidtokenno");
		String uaIsValid = (String) session.getAttribute("loginuID");
		if (uaIsValid == null || uaIsValid.equals("") || uavalidtokenno111 == null || uavalidtokenno111.equals("")) {
			rd = request.getRequestDispatcher("/login.html");
			rd.forward(request, response);
		}		
		RequestDispatcher RD = request.getRequestDispatcher("salary_master/manage-monthly-salary.jsp");
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
		if (request.getParameter("button").equalsIgnoreCase("Search")) {
			String emname = request.getParameter("emname").trim();
			String month = request.getParameter("month").trim();
			String from = request.getParameter("from").trim();
			String to = request.getParameter("to").trim();
			
			SES.setAttribute("mmsemname", emname);
			SES.setAttribute("mmsmonth", month);
			SES.setAttribute("mmsfrom", from);
			SES.setAttribute("mmsto", to);
		}else if(request.getParameter("button").equalsIgnoreCase("Reset")){
			SES.removeAttribute("mmsemname");
			SES.removeAttribute("mmsmonth");
			SES.removeAttribute("mmsfrom");
			SES.removeAttribute("mmsto");
		}
			RequestDispatcher RD = request.getRequestDispatcher("salary_master/manage-monthly-salary.jsp");
			RD.forward(request, response);
		
	}
}