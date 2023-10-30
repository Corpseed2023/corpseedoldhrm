package hcustbackend;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class MarkAsRead_CTRL  extends HttpServlet{

private static final long serialVersionUID = 1L;

public void doGet(HttpServletRequest request,HttpServletResponse response)
{
try
{  
	String refid=request.getParameter("refid").trim();
	String page=request.getParameter("page").trim();
	ClientACT.markAsRead(refid);

	RequestDispatcher rd=request.getRequestDispatcher("/"+page);
	rd.forward(request, response);
}catch (Exception e) {
	e.printStackTrace();
}
}

}