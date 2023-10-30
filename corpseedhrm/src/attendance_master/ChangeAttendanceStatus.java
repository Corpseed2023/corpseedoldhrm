package attendance_master;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ChangeAttendanceStatus extends HttpServlet{

	private static final long serialVersionUID = 1L;
	public void doGet(HttpServletRequest request,HttpServletResponse response)
	{
		try {
			HttpSession session=request.getSession();
			String loginuser=(String)session.getAttribute("loginuID");
			String id=request.getParameter("info").trim();
			String atten=request.getParameter("atten").trim();
			String date=request.getParameter("date").trim();
			String intime=request.getParameter("intime").trim();
			String outtime=request.getParameter("outtime").trim();

			Attendance_ACT.changeAttendanceStatus(id, atten, date, loginuser,intime,outtime);

		}
		catch(Exception e){

		}
	}
}