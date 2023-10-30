package admin.master;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class Uresetpass_CTRL extends HttpServlet{
private static final long serialVersionUID = 1L;
public void doPost(HttpServletRequest request,HttpServletResponse response)
{
try
{
RequestDispatcher rd=null;
boolean status=false;
HttpSession session=request.getSession();
String uid= (String)session.getAttribute("loginuID");
String userpass = request.getParameter("currentPassword").trim();
String newuserpass = request.getParameter("newpassword").trim();
String renterpass = request.getParameter("userPassword").trim();
status=Uresetpass_ACT.updatepassDetail(uid, userpass, newuserpass,renterpass);
if (!status)
{
session.setAttribute("ErrorMessage", "Password Is Not Updated!.");
rd=request.getRequestDispatcher("/notification.html");
rd.forward(request, response);
}else {
rd=request.getRequestDispatcher("/logout.html");
rd.forward(request, response);
}
}catch (Exception e) {

}
}

}
