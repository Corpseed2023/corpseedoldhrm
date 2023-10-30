package salary_master;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class getLeavesAllowed_CTRL extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -5098867198594346410L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			String month = request.getParameter("month").trim();
			String empid = request.getParameter("empid").trim();
			String LeavesAllowed = "";
			
			Calendar cal =  Calendar.getInstance();
			cal.add(Calendar.MONTH ,-1);
			String previousMonthYear  = new SimpleDateFormat("MM-yyyy").format(cal.getTime());
			
			String view[][] = SalaryMon_ACT.getLeavesAllowed(previousMonthYear, empid);
			LeavesAllowed = view[0][0];
			PrintWriter pw = response.getWriter();
			pw.write(LeavesAllowed);
		} catch (Exception e) {
			
		}
	}
}
