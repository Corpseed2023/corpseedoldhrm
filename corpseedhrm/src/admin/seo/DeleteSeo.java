package admin.seo;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class DeleteSeo extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
  
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		try
		{
			String uid=request.getParameter("info").trim();
			SeoOnPage_ACT.deleteSeo(uid);			
		}catch (Exception e) {
		
		}
		
	}
}
