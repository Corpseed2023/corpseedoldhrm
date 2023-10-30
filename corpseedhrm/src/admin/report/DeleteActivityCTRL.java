package admin.report;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DeleteActivityCTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 9174574857433536352L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {

			String uid = request.getParameter("id").trim();
			
			Report_ACT.deleteActivity(uid);

		} catch (Exception e) {
			
		}
	}
	
}
