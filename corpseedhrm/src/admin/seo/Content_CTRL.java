package admin.seo;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class Content_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		try
		{
			boolean status =false;
			HttpSession session = request.getSession();
			
			String wacpuid = request.getParameter("ProjectName").trim();
			String x[]=wacpuid.split("-");
			wacpuid=x[1];
			String wactuid = request.getParameter("taskname").trim();
			String wacactivity = request.getParameter("activitytype").trim();
			String wacacontent = request.getParameter("content").trim();
			String wacastatus = request.getParameter("status").trim();
			String wacaddedby= request.getParameter("addedbyuser").trim();
			String noofword= request.getParameter("noofword").trim();
			
		status=SeoOnPage_ACT.saveContentDetail(wacpuid,wactuid,wacactivity,wacacontent,wacastatus,wacaddedby,noofword);
		if(status)
		{		
			response.sendRedirect(request.getContextPath()+"/manage-content.html");
		}
		else {
			session.setAttribute("ErrorMessage", "Content is not saved!.");
			response.sendRedirect(request.getContextPath()+"/notification.html");
		}
	}
		
		catch(Exception e)
		{
				
		}
		
	}

}
