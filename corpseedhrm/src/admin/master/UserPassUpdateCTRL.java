package admin.master;

import java.io.PrintWriter;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UserPassUpdateCTRL extends HttpServlet{
private static final long serialVersionUID = 1L;
public void doPost(HttpServletRequest request,HttpServletResponse response)
{
try
{
PrintWriter pw=response.getWriter();
String uid=request.getParameter("ualoginid").trim();
String newuserpass = request.getParameter("newpassword").trim();
String renterpass = request.getParameter("userPassword").trim();
boolean updateUserPassword = Uresetpass_ACT.updateUserPassword(uid,newuserpass,renterpass);

if(updateUserPassword)pw.write("pass");
else pw.write("fail");

}catch (Exception e) {
	e.printStackTrace();
}
}

}
