package salary_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdateMed_CTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4978791633956611287L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			boolean status = false;
			HttpSession session = request.getSession();

			String medid = request.getParameter("medid").trim();
			String medemid = request.getParameter("emid").trim();
			String emname = request.getParameter("EmployeeName").trim();
			String medamt = request.getParameter("medamt").trim();
			String medmonth = request.getParameter("medmonth").trim();
			String medpaidfrom = request.getParameter("medpaidfrom").trim();
			String medpaidto = request.getParameter("medpaidto").trim();
			String medpaidon = request.getParameter("medpaidon").trim();
			String medremarks = request.getParameter("medremarks").trim();

			status = SalaryMon_ACT.updateMed(medid, medemid, medamt, medmonth, medpaidfrom, medpaidto, medpaidon, medremarks);

			if (status) {
				session.setAttribute("ErrorMessage", "Med Details of " + emname + " is Successfully saved!");
				response.sendRedirect(request.getContextPath() + "/notification.html");
			} else {
				session.setAttribute("ErrorMessage", "Med Details of " + emname + " is not saved");
				response.sendRedirect(request.getContextPath() + "/notification.html");
			}
		}

		catch (Exception e) {
			
		}

	}

}