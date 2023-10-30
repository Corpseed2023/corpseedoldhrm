package admin.seo;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class DeleteFollowupStatus_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
  
    
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		try
		{
			HttpSession session=request.getSession();
			String loginuID = (String) session.getAttribute("loginuID");
			String token=(String)session.getAttribute("uavalidtokenno");
			String emproleid=(String)session.getAttribute("emproleid");
			String id=request.getParameter("id").trim();
			SeoOnPage_ACT.deleteTaskStatus(id,loginuID,emproleid,token);			
		}catch (Exception e) {
		
		}
		
	}

	
}
