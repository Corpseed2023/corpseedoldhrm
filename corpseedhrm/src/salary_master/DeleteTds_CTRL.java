package salary_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DeleteTds_CTRL extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -3588067532094105692L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {

			String uid = request.getParameter("info").trim();
			SalaryMon_ACT.deleteTds(uid);

		} catch (Exception e) {
			
		}

	}

}
