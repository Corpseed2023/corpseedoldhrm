package admin.master;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class Profile_Update_CTRL  extends HttpServlet{

private static final long serialVersionUID = 1L;

public void doPost(HttpServletRequest request,HttpServletResponse response)
{
try
{  
 boolean status=false;
HttpSession session =request.getSession();

String userName = request.getParameter("userName").trim();
String userMobile = request.getParameter("userMobile").trim();
String userEmail = request.getParameter("userEmail").trim();
String loginid= request.getParameter("loginid").trim();

status=Usermaster_ACT.updateUserProfile(userName,userMobile,userEmail,loginid);
if(status)
{
	session.setAttribute("ErrorMessage", "Profile is Successfully Updated!.");
	response.sendRedirect(request.getContextPath()+"/notification.html");
}
else {
	session.setAttribute("ErrorMessage", "Profile is not Updated!.");
	response.sendRedirect(request.getContextPath()+"/notification.html");
}

}catch (Exception e) {

}
}

}