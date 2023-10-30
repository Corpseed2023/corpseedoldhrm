package hcustbackend;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.master.Usermaster_ACT;

public class UpdateUserActiveStatusCTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session=request.getSession();
			String loginuaid= (String)session.getAttribute("loginuaid");
			if(loginuaid!=null) {
				String activeStatus=Usermaster_ACT.getLoginStatus(loginuaid);
//				System.out.println("activeStatus========"+activeStatus);
				if(activeStatus.equalsIgnoreCase("1")){
					Usermaster_ACT.updateUserLoginStatus(loginuaid,2);
					session.invalidate();
				}
			}
			
		}catch (Exception e) {
				e.printStackTrace();
		}
	}

}
