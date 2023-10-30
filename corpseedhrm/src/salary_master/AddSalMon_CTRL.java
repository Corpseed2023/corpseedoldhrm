package salary_master;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AddSalMon_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			boolean status = false;
			HttpSession session = request.getSession();

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
			String salremark = request.getParameter("salremark").trim();
			String salmaddedby = request.getParameter("addeduser").trim();
			String token= (String)session.getAttribute("uavalidtokenno");
			
			DateFormat df = new SimpleDateFormat("dd-MM-yyyy");
			Calendar calobj = Calendar.getInstance();
			String today = df.format(calobj.getTime());

			
			
			String[] a=salmmonth.split("-");
			String mm=a[0];
			String yy=a[1];
			//YearMonth yearMonthObject = YearMonth.of(Integer.parseInt(yy),Integer.parseInt(mm));
			//int daysInMonth = yearMonthObject.lengthOfMonth();
			Calendar calendar = Calendar.getInstance();
			int daysInMonth=calendar.get(Calendar.MONTH);
			
			Double salmleavesallowed2 = Double.parseDouble(salmleavesallowed)-Double.parseDouble(salmleavestaken);
			salmleavesallowed = Double.toString(salmleavesallowed2);
			
			status = SalaryStr_ACT.addSalMon(salmemid, salmmonth,salmdays, salmleavesallowed,salmleavestaken, salmwday, salmgross, salmbasic, salmda, salmhra, salmcon,
					salmmed, salmspecial, salmbonus, salmta, salmded, salmpf, salmptax, salmtds, salmnet, salmaddedby, salmod,salremark);
			if(!salmtds.equalsIgnoreCase("0"))
			SalaryStr_ACT.addTDS(salmemid,"01-"+salmmonth,daysInMonth+"-"+salmmonth,today,salmtds,salmmonth,"NA",token);
			if(!salmmed.equalsIgnoreCase("0"))
				SalaryStr_ACT.addMedical(salmemid,"01-"+salmmonth,daysInMonth+"-"+salmmonth,today,salmmed,salmmonth,"NA",token);	
				
			if (status) {
//				session.setAttribute("ErrorMessage", "Monthly Salary of "+emname+" is Successfully saved!");
				response.sendRedirect(request.getContextPath() + "/Manage-Monthly-Salary.html");
			} else {
				session.setAttribute("ErrorMessage", "Monthly Salary of "+emname+" is not saved");
				response.sendRedirect(request.getContextPath() + "/notification.html");
			}
		}

		catch (Exception e) {
			
		}

	}

}