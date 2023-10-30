package salary_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DeleteSalStr_CTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1395783078743995556L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {

			String uid = request.getParameter("info").trim();
			SalaryStr_ACT.deleteSalStr(uid);

		} catch (Exception e) {
			
		}

	}

}
