package admin.report;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class SearchSeoReport_CTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3460305233670572865L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession();

		session.removeAttribute("pid");
		session.removeAttribute("datefrom");
		session.removeAttribute("dateto");

		RequestDispatcher rd = request.getRequestDispatcher("/mreport/seo-report.jsp");
		rd.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String pid = request.getParameter("pid").trim();
		String datefrom = request.getParameter("datefrom").trim();
		String dateto = request.getParameter("dateto").trim();

		HttpSession session = request.getSession();
		session.setAttribute("pid", pid);
		session.setAttribute("datefrom", datefrom);
		session.setAttribute("dateto", dateto);

		RequestDispatcher rd = request.getRequestDispatcher("/mreport/seo-report.jsp");
		rd.forward(request, response);

	}

}
