package attendance_master;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class GetDate extends HttpServlet{

	private static final long serialVersionUID = 1L;
	public void doGet(HttpServletRequest request,HttpServletResponse response)
	{
		try {
			HttpSession session=request.getSession();
			String getval=request.getParameter("info").trim();
			//System.out.println(getval);
			session.setAttribute("getdate", getval);
		}
		catch(Exception e){

		}
	}
}