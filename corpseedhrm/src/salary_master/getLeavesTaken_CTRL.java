package salary_master;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
public class getLeavesTaken_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			String month = request.getParameter("month").trim();
			String empid = request.getParameter("empid").trim();
			String LeavesTaken = "";
			String view[][] = SalaryMon_ACT.getLeavesTaken(month, empid);
			LeavesTaken = view[0][0];
			PrintWriter pw = response.getWriter();
			pw.write(LeavesTaken);
		} catch (Exception e) {
			
		}
	}
}
