package admin.seo;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class ContentEdit_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
   
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		try
		{
			boolean status =false;
			HttpSession session = request.getSession();			
			
			String uid=request.getParameter("uid").trim();
			String wacactivity = request.getParameter("ActivityType").trim();
			String wacacontent = request.getParameter("content").trim();
			String wacastatus = request.getParameter("status").trim();
			String wacaddedby= request.getParameter("addedbyuser").trim();
			String noofword= request.getParameter("noofword").trim();

		
		status=SeoOnPage_ACT.updateContentDetail( uid,wacactivity,wacacontent,wacastatus,wacaddedby,noofword);
		if(status)
		{			
			response.sendRedirect(request.getContextPath()+"/manage-content.html");
		}
		else {
			session.setAttribute("ErrorMessage", "Content is not updated!.");
			response.sendRedirect(request.getContextPath()+"/notification.html");
		}
	}
		
		catch(Exception e)
		{
				
		}
		
	}

}
