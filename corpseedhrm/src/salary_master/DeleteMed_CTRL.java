package salary_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DeleteMed_CTRL extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 3359219811941074667L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {

			String uid = request.getParameter("info").trim();
			SalaryMon_ACT.deleteMed(uid);

		} catch (Exception e) {
			
		}

	}

}
