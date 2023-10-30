package admin.seo;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class DeleteFolder_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
  
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		try
		{
			HttpSession session=request.getSession();
			String token=(String)session.getAttribute("uavalidtokenno");
			String uid=request.getParameter("id").trim();
			String refno=request.getParameter("refno").trim();
			SeoOnPage_ACT.deleteFolder(uid,refno,token);			
		}catch (Exception e) {
		e.printStackTrace();
		}
		
	}
}
