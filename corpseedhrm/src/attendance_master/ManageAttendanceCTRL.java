package attendance_master;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ManageAttendanceCTRL extends HttpServlet{
	private static final long serialVersionUID = 1L;
	public void doGet(HttpServletRequest request,HttpServletResponse response)throws IOException,ServletException {
		RequestDispatcher rd=null;
		HttpSession session =request.getSession();
		String uavalidtokenno111= (String)session.getAttribute("uavalidtokenno");
		String uaIsValid= (String)session.getAttribute("loginuID");
		if(uaIsValid== null || uaIsValid.equals("") || uavalidtokenno111== null || uavalidtokenno111.equals("")){
			rd=request.getRequestDispatcher("/login.html");
			rd.forward(request, response);
		}
		
		RequestDispatcher RD=request.getRequestDispatcher("attendance_master/manage_attendance.jsp");
		RD.forward(request,response);
	}
	public void doPost(HttpServletRequest request,HttpServletResponse response)throws IOException,ServletException {
		RequestDispatcher rd=null;
		HttpSession session =request.getSession();
		String uavalidtokenno111= (String)session.getAttribute("uavalidtokenno");
		String uaIsValid= (String)session.getAttribute("loginuID");
		if(uaIsValid== null || uaIsValid.equals("") || uavalidtokenno111== null || uavalidtokenno111.equals("")){
			rd=request.getRequestDispatcher("/login.html");
			rd.forward(request, response);
		}
		HttpSession SES = request.getSession(true);
		if(request.getParameter("button").equalsIgnoreCase("Search")){		
			String EmpID=request.getParameter("EmpID");
			String MonthDate=request.getParameter("MonthDate");
			String from = request.getParameter("from");
			String to = request.getParameter("to");
			//System.out.println("custname>>>>>>>>>"+custname);
			
			SES.setAttribute("maEmpID", EmpID);
			SES.setAttribute("maMonthDate", MonthDate);
			SES.setAttribute("mafrom", from);
			SES.setAttribute("mato", to);
		}else if(request.getParameter("button").equalsIgnoreCase("Reset")){
			SES.removeAttribute("maEmpID");
			SES.removeAttribute("maMonthDate");
			SES.removeAttribute("mafrom");
			SES.removeAttribute("mato");
		}
			RequestDispatcher RD=request.getRequestDispatcher("attendance_master/manage_attendance.jsp");
			RD.forward(request,response);
		
	}
}