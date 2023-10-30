package salary_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class UpdateSalMon_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			boolean status = false;
			HttpSession session = request.getSession();

			String salremark = request.getParameter("salremark").trim();
			String salmid = request.getParameter("salmid").trim();
			String salmemid = request.getParameter("emid").trim();
			String emname = request.getParameter("EmployeeName").trim();
			String salmmonth = request.getParameter("Month").trim();
			String salmdays = request.getParameter("Days").trim();
			String salmleavesallowed = request.getParameter("LeavesAllowed").trim();
			String salmleavestaken = request.getParameter("LeavesTaken").trim();
			String salmwday = request.getParameter("WorkingDays").trim();
			String salmgross = request.getParameter("GrossSalary").trim();
			String salmbasic = request.getParameter("BasicSalary").trim();
			String salmda = request.getParameter("DA").trim();
			String salmhra = request.getParameter("HRA").trim();
			String salmcon = request.getParameter("Conveyance").trim();
			String salmmed = request.getParameter("MedicalExpenses").trim();
			String salmspecial = request.getParameter("Special").trim();
			String salmbonus = request.getParameter("Bonus").trim();
			String salmta = request.getParameter("TA").trim();
			String salmded = request.getParameter("TotalDeductions").trim();
			String salmpf = request.getParameter("PF").trim();
			String salmptax = request.getParameter("ProfessionalTax").trim();
			String salmtds = request.getParameter("TDS").trim();
			String salmod = request.getParameter("OtherDeductions").trim();
			String salmnet = request.getParameter("Payable").trim();
			String salmaddedby = request.getParameter("addeduser").trim();

			status = SalaryMon_ACT.updateSalMon(salmid,salmemid, salmmonth,salmdays, salmleavesallowed,salmleavestaken, salmgross, salmbasic, salmda, salmhra, salmcon,
					salmmed, salmspecial, salmbonus, salmta, salmded, salmpf, salmptax, salmtds, salmnet, salmaddedby,salmwday,salmod,salremark);
			if (status) {
//				session.setAttribute("ErrorMessage", "Monthly Salary of "+emname+" is Successfully updated!");
				response.sendRedirect(request.getContextPath() + "/Manage-Monthly-Salary.html");
			} else {
				session.setAttribute("Notification", "Monthly Salary of "+emname+" is not Updated!");
				response.sendRedirect(request.getContextPath() + "/notification.html");
			}
		}

		catch (Exception e) {
			
		}

	}

}