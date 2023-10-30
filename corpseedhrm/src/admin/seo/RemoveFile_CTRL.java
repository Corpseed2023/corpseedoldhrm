package admin.seo;

import java.io.File;
import java.io.IOException;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class RemoveFile_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
  
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		try
		{
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
			String docpath=properties.getProperty("path")+"documents";
						
			HttpSession session=request.getSession();
			String token=(String)session.getAttribute("uavalidtokenno");
			
			String skey=request.getParameter("skey").trim();
			String fileName=request.getParameter("fileName").trim();
			
			SeoOnPage_ACT.removeFile(skey,token);	
			
			File f= new File(docpath+File.separator+fileName); 
			f.delete();
			
		}catch (Exception e) {
		e.printStackTrace();
		}
		
	}
}
