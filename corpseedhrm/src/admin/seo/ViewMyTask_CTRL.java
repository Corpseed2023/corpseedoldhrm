package admin.seo;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class ViewMyTask_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		RequestDispatcher rd = null;
		HttpSession session = request.getSession();
		String uavalidtokenno111 = (String) session.getAttribute("uavalidtokenno");
		String uaIsValid = (String) session.getAttribute("loginuID");
		if (uaIsValid == null || uaIsValid.equals("") || uavalidtokenno111 == null || uavalidtokenno111.equals("")) {
			rd = request.getRequestDispatcher("/login.html");
			rd.forward(request, response);
		}else {
	
		RequestDispatcher RD = request.getRequestDispatcher("mseo/mytask-details.jsp");
		RD.forward(request, response);
		}
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
			String projectname = request.getParameter("projectname");
			String date = request.getParameter("date").trim();
			String tname = request.getParameter("tname").trim();
			String ddate = request.getParameter("ddate").trim();
			String tstatus = request.getParameter("tstatus").trim();
			String from = request.getParameter("from").trim();
			String to = request.getParameter("to").trim();			
			SES.setAttribute("mtdprojectname", projectname);
			SES.setAttribute("mtddate", date);
			SES.setAttribute("mtdddate", ddate);
			SES.setAttribute("mtdtname", tname);
			SES.setAttribute("mtdtstatus", tstatus);
			SES.setAttribute("mtdfrom", from);
			SES.setAttribute("mtdto", to);
		}else if(request.getParameter("button").equalsIgnoreCase("Reset")){
			SES.removeAttribute("mtdprojectname");
			SES.removeAttribute("mtddate");
			SES.removeAttribute("mtdddate");
			SES.removeAttribute("mtdtname");
			SES.removeAttribute("mtdtstatus");
			SES.removeAttribute("mtdfrom");
			SES.removeAttribute("mtdto");
		}
		
			RequestDispatcher RD = request.getRequestDispatcher("mseo/mytask-details.jsp");
			RD.forward(request, response);
		
	}

}