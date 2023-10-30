package employee_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
public class DeleteEmployee_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			
			String uid = request.getParameter("info").trim();
			String status = request.getParameter("status").trim();
			String emuid = request.getParameter("emuid").trim();
			String token = request.getParameter("token").trim();
			Employee_ACT.deleteEmployee(uid,status);
			
			boolean flag=Employee_ACT.isExistEmployee(emuid,token);
			if(flag)
			{
				Employee_ACT.updateUserAccount(emuid,token,status);
			}

		} catch (Exception e) {
			
		}

	}

}
