package admin.master;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class MarkAsRead_CTRL  extends HttpServlet{

private static final long serialVersionUID = 1L;

public void doGet(HttpServletRequest request,HttpServletResponse response)
{
try
{  
	HttpSession session=request.getSession();
	
	String refid=request.getParameter("refid").trim();
	String page=request.getParameter("page").trim();
	String notificationemproleid=(String)session.getAttribute("emproleid");
	Usermaster_ACT.markAsRead(refid,notificationemproleid);

	RequestDispatcher rd=request.getRequestDispatcher("/"+page);
	rd.forward(request, response);
}catch (Exception e) {
	e.printStackTrace();
}
}

}