package salary_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AddTDS_CTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6700637634935089717L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			boolean status = false;
			HttpSession session = request.getSession();

			String tdsemid = request.getParameter("emid").trim();
			String emname = request.getParameter("EmployeeName").trim();
			String tdsamt = request.getParameter("tdsamt").trim();
			String tdsmonth = request.getParameter("tdsmonth").trim();
			String tdspaidfrom = request.getParameter("tdspaidfrom").trim();
			String tdspaidto = request.getParameter("tdspaidto").trim();
			String tdspaidon = request.getParameter("tdspaidon").trim();
			String tdsremarks = request.getParameter("tdsremarks").trim();

			status = SalaryMon_ACT.addTds(tdsemid, tdsamt, tdsmonth, tdspaidfrom, tdspaidto, tdspaidon, tdsremarks);
			
			if (status) {
				session.setAttribute("ErrorMessage", "TDS Details of " + emname + " is Successfully saved!");
				response.sendRedirect(request.getContextPath() + "/notification.html");
			} else {
				session.setAttribute("ErrorMessage", "TDS Details of " + emname + " is not saved");
				response.sendRedirect(request.getContextPath() + "/notification.html");
			}
		}

		catch (Exception e) {
			
		}

	}

}
