package hcustbackend;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import admin.master.Usermaster_ACT;

public class GetEmployeeActiveStatusCTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			PrintWriter pw=response.getWriter();
			String uaid=request.getParameter("uaid").trim();
			String activeStatus=Usermaster_ACT.getLoginStatus(uaid);
//			System.out.println("active status=="+activeStatus);
			pw.write(activeStatus);
			
		}catch (Exception e) {
				e.printStackTrace();
		}
	}

}
