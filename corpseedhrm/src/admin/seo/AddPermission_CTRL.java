package admin.seo;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class AddPermission_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		try
		{
			HttpSession session = request.getSession();
			
			String fcategory= request.getParameter("fcategory");
			if(fcategory!=null)fcategory=fcategory.trim();
			
			String userId= request.getParameter("userId");
			if(userId!=null)userId=userId.trim();
			
			String frefid = request.getParameter("frefid").trim();
			String token=(String)session.getAttribute("uavalidtokenno");
			String loginid=(String)session.getAttribute("loginuID");
						
		SeoOnPage_ACT.addPermissions(userId,frefid,token,loginid,fcategory);
		
	}
		catch(Exception e)
		{
				e.printStackTrace();
		}
		
	}

}
