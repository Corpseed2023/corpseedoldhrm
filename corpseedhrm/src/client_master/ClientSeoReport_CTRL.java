package client_master;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ClientSeoReport_CTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7464396997982440833L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String pid = null;
		String datefrom = null;
		String dateto = null;

		HttpSession session = request.getSession();

		session.setAttribute("pid", pid);
		session.setAttribute("datefrom", datefrom);
		session.setAttribute("dateto", dateto);

		RequestDispatcher rd = request.getRequestDispatcher("/client_dash/seo-report.jsp");
		rd.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String pid = request.getParameter("pid");
		String datefrom = request.getParameter("datefrom");
		String dateto = request.getParameter("dateto");

		HttpSession session = request.getSession();

		session.setAttribute("pid", pid);
		session.setAttribute("datefrom", datefrom);
		session.setAttribute("dateto", dateto);

		RequestDispatcher rd = request.getRequestDispatcher("/client_dash/seo-report.jsp");
		rd.forward(request, response);
	}

}