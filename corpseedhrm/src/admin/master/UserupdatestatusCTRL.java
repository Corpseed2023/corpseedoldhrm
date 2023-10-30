package admin.master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UserupdatestatusCTRL extends HttpServlet{
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request,HttpServletResponse response) throws IOException,ServletException
	{
		try
		{
			String uid=request.getParameter("info").trim();
			String status=request.getParameter("status").trim();
					
			Usermaster_ACT.deleteUser(uid,status);
			/*For Activate/deactivate company/employee/client*/
			Usermaster_ACT.deleteRelatedUser(uid,status);
			
	
			
		}catch (Exception e) {
		
		}
	}

}
