package admin.master;

import java.io.PrintWriter;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class MarkAllAsRead_CTRL  extends HttpServlet{

private static final long serialVersionUID = 1L;

public void doGet(HttpServletRequest request,HttpServletResponse response)
{
try
{  
	PrintWriter pw=response.getWriter();
	HttpSession session=request.getSession();
	String token=(String)session.getAttribute("uavalidtokenno");
	String loginuaid =(String)session.getAttribute("loginuaid");
	
	boolean flag=Usermaster_ACT.markAllAsRead(loginuaid,token); 
	
	if(flag) {
		pw.write("pass");
	}else {
		pw.write("fail");
	}
	
}catch (Exception e) {
	e.printStackTrace();
}
}

}