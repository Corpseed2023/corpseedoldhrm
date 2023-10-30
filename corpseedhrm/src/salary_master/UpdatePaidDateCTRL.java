package salary_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UpdatePaidDateCTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5266186822420586294L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String id = request.getParameter("id").trim();
		String value = request.getParameter("value").trim();

		SalaryMon_ACT.updatePaidDate(id, value);

	}

}
