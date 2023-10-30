package client_master;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class ManageProject_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		RequestDispatcher rd = null;
		HttpSession session = request.getSession();
		String uavalidtokenno111 = (String) session.getAttribute("uavalidtokenno");
		String uaIsValid = (String) session.getAttribute("loginuID");
		if (uaIsValid == null || uaIsValid.equals("") || uavalidtokenno111 == null || uavalidtokenno111.equals("")) {
			rd = request.getRequestDispatcher("/login.html");
			rd.forward(request, response);
		}
		
		RequestDispatcher RD = request.getRequestDispatcher("mclient/manage-project.jsp");
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
			String clientid = request.getParameter("clientid").trim();
			String clientname = request.getParameter("clientname").trim();
			String projectname = request.getParameter("projectname").trim();
			String projecttype = request.getParameter("projecttype").trim();
			String deliverymonth = request.getParameter("deliverymonth").trim();
			String pstatus = request.getParameter("pstatus").trim();
			String from = request.getParameter("from").trim();
			String to = request.getParameter("to").trim();
			
			SES.setAttribute("mpclientid", clientid);
			SES.setAttribute("mpclientname", clientname);
			SES.setAttribute("mpprojectname", projectname);
			SES.setAttribute("mpprojecttype", projecttype);
			SES.setAttribute("mpdeliverymonth", deliverymonth);
			SES.setAttribute("mppstatus", pstatus);
			SES.setAttribute("mpfrom", from);
			SES.setAttribute("mpto", to);
			
		}else if(request.getParameter("button").equalsIgnoreCase("Reset")){
			SES.removeAttribute("mpclientid");
			SES.removeAttribute("mpclientname");
			SES.removeAttribute("mpprojectname");
			SES.removeAttribute("mpprojecttype");
			SES.removeAttribute("mpdeliverymonth");
			SES.removeAttribute("mppstatus");
			SES.removeAttribute("mpfrom");
			SES.removeAttribute("mpto");
		}
			RequestDispatcher RD = request.getRequestDispatcher("mclient/manage-project.jsp");
			RD.forward(request, response);
		
	}

}
