package daily_expenses;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class ManageDailyExpenses_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		RequestDispatcher rd = null;
		HttpSession session = request.getSession();
		String uavalidtokenno111 = (String) session.getAttribute("uavalidtokenno");
		String uaIsValid = (String) session.getAttribute("loginuID");
		if (uaIsValid == null || uaIsValid.equals("") || uavalidtokenno111 == null || uavalidtokenno111.equals("")) {
			rd = request.getRequestDispatcher("/login.html");
			rd.forward(request, response);
		}
	
		RequestDispatcher RD = request.getRequestDispatcher("daily_expenses/manage_daily_expenses.jsp");
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
			String month = request.getParameter("month").trim();
			String date = request.getParameter("date").trim();
			String to = request.getParameter("to").trim();
			String gst = request.getParameter("gst").trim();
			
			SES.setAttribute("mdxmonth", month);
			SES.setAttribute("mdxto", to);
			SES.setAttribute("mdxdate", date);
			SES.setAttribute("mdxgst", gst);
		}else if(request.getParameter("button").equalsIgnoreCase("Reset")){
			SES.removeAttribute("mdxmonth");
			SES.removeAttribute("mdxdate");
			SES.removeAttribute("mdxto");
			SES.removeAttribute("mdxgst");
		}
			RequestDispatcher RD = request.getRequestDispatcher("daily_expenses/manage_daily_expenses.jsp");
			RD.forward(request, response);
		
	}

}