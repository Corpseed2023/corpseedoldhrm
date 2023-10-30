package salary_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdateSalStr_CTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3694638311852276287L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			boolean status = false;
			HttpSession session = request.getSession();

			String salid = request.getParameter("salid").trim();
			String salemid = request.getParameter("emid").trim();
			String emname = request.getParameter("EmployeeName").trim();
			String salctc = request.getParameter("CTC").trim();
			String salleaves = request.getParameter("LeavesAllowed").trim();
			String salgross = request.getParameter("GrossSalary").trim();
			String salbasic = request.getParameter("BasicSalary").trim();
			String salda = request.getParameter("DA").trim();
			String salhra = request.getParameter("HRA").trim();
			String salcon = request.getParameter("Conveyance").trim();
			String salmed = request.getParameter("MedicalExpenses").trim();
			String salspecial = request.getParameter("Special").trim();
			String salbonus = request.getParameter("Bonus").trim();
			String salta = request.getParameter("TA").trim();
			String salded = request.getParameter("TotalDeductions").trim();
			String salpf = request.getParameter("PF").trim();
			String salptax = request.getParameter("ProfessionalTax").trim();
			String saltds = request.getParameter("TDS").trim();
			String salnet = request.getParameter("Payable").trim();
			String saladdedby =(String)session.getAttribute("loginuID");

			status = SalaryStr_ACT.updateSalStr(salid, salemid, salctc, salleaves, salgross, salbasic, salda, salhra, salcon,
					salmed, salspecial, salbonus, salta, salded, salpf, salptax, saltds, salnet, saladdedby);
			if (status) {
//				session.setAttribute("ErrorMessage", "Salary Structure of "+emname+" is Successfully updated!");
				response.sendRedirect(request.getContextPath() + "/Manage-Salary-Structure.html");
			} else {
				session.setAttribute("ErrorMessage", "Salary Structure of "+emname+" is not updated");
				response.sendRedirect(request.getContextPath() + "/notification.html");
			}
		}

		catch (Exception e) {
			
		}

	}

}
