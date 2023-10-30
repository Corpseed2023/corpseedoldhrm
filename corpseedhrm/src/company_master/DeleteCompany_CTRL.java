package company_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
public class DeleteCompany_CTRL extends HttpServlet {
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {

			String uid = request.getParameter("info").trim();
			String compuid = request.getParameter("id1").trim();
			String status = request.getParameter("status").trim();
			CompanyMaster_ACT.deleteCompany(uid,status,compuid);

		} catch (Exception e) {
			
		}
	}

}
