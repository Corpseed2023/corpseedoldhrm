package urlcollection;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ManageURLCollectionCTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3608488111610937117L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		RequestDispatcher rd = null;
		HttpSession session = request.getSession();
		String uavalidtokenno111 = (String) session.getAttribute("uavalidtokenno");
		String uaIsValid = (String) session.getAttribute("loginuID");
		if (uaIsValid == null || uaIsValid.equals("") || uavalidtokenno111 == null || uavalidtokenno111.equals("")) {
			rd = request.getRequestDispatcher("/login.html");
			rd.forward(request, response);
		}
		session.removeAttribute("submiturl");
		session.removeAttribute("activity");
		session.removeAttribute("nature");
		session.removeAttribute("from");
		session.removeAttribute("to");
		RequestDispatcher RD = request.getRequestDispatcher("urlcollection/updateseourlcollection.jsp");
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
		String submiturl = request.getParameter("submiturl");
		String activity = request.getParameter("activity");
		String nature = request.getParameter("nature");
		String from = request.getParameter("from");
		String to = request.getParameter("to");
		session.setAttribute("submiturl", submiturl);
		session.setAttribute("activity", activity);
		session.setAttribute("nature", nature);
		session.setAttribute("from", from);
		session.setAttribute("to", to);
		RequestDispatcher RD = request.getRequestDispatcher("urlcollection/updateseourlcollection.jsp");
		RD.forward(request, response);
	}

}