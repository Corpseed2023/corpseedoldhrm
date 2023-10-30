package admin.report;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class SearchMoreSeoReport_CTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4537764851555246899L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			String rkkey = request.getParameter("keyword").trim();
			HttpSession session = request.getSession();
			session.setAttribute("rkkey", rkkey);
		} catch (Exception e) {
			
		}

	}

}
