package employee_master;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class ManageEmployeesCTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		RequestDispatcher rd = null;
		HttpSession session = request.getSession();
		String uavalidtokenno111 = (String) session.getAttribute("uavalidtokenno");
		String uaIsValid = (String) session.getAttribute("loginuID");
		if (uaIsValid == null || uaIsValid.equals("") || uavalidtokenno111 == null || uavalidtokenno111.equals("")) {
			rd = request.getRequestDispatcher("/login.html");
			rd.forward(request, response);
		}
		
		RequestDispatcher RD = request.getRequestDispatcher("employee_master/manage-employee.jsp");
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
		String name = request.getParameter("name").trim();
		String mobile = request.getParameter("mobile").trim();
		String email = request.getParameter("email").trim();
		String from = request.getParameter("from").trim();
		String to = request.getParameter("to").trim();
		HttpSession SES = request.getSession(true);
		SES.setAttribute("mename", name);
		SES.setAttribute("memobile", mobile);
		SES.setAttribute("meemail", email);
		SES.setAttribute("mefrom", from);
		SES.setAttribute("meto", to);
		}else if(request.getParameter("button").equalsIgnoreCase("Reset")){
			HttpSession SES = request.getSession(true);
			SES.removeAttribute("mename");
			SES.removeAttribute("memobile");
			SES.removeAttribute("meemail");
			SES.removeAttribute("mefrom");
			SES.removeAttribute("meto");
		}
		RequestDispatcher RD = request.getRequestDispatcher("employee_master/manage-employee.jsp");
		RD.forward(request, response);
	}

}