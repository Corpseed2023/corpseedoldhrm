package admin.task;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.master.Usermaster_ACT;

public class UpdateForgetPassword_CTRL extends HttpServlet {	
	/**
	 * 
	 */
	private static final long serialVersionUID = -4130059693338567572L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session=request.getSession();
		String user_uuid=request.getParameter("user_uuid").trim();
		String forget_key=request.getParameter("forget_key").trim();
		String newpassword=request.getParameter("newpassword").trim();
		String confirmPassword=request.getParameter("confirmPassword").trim();
//		System.out.println(user_uuid+"/"+forget_key+"/"+confirmPassword);
		if(newpassword.equalsIgnoreCase(confirmPassword)) {
			boolean flag=Usermaster_ACT.updateUserPassword(user_uuid,confirmPassword);
			if(flag) {
				Usermaster_ACT.inactivePasswordLink(forget_key);
				session.setAttribute("passwordresetsuccess", "Successfully password updated !!");
			}else session.setAttribute("loginerrormsg", "Something went wrong, Please contact to admin !!");
			RequestDispatcher rd=request.getRequestDispatcher("madministrator/login.jsp");
			rd.forward(request, response);
		}else {
			session.setAttribute("resetpassworderrormsg", "Password doesn't match !!");
			response.sendRedirect("reset-password.html?ufp="+user_uuid+"&fpk="+forget_key);
		}
	}

}