package admin.task;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class RemoveStepGuideStepCTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		PrintWriter pw=response.getWriter();
		HttpSession session=request.getSession();
		String token=(String)session.getAttribute("uavalidtokenno");
		try
		{
			String key=request.getParameter("key").trim();	
			String document=request.getParameter("document");
			
			boolean flag=TaskMaster_ACT.removeStepGuideStep(key,token);
			
			if(flag) {	
				if(!document.equalsIgnoreCase("NA")) {
					Properties properties = new Properties();
					properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
					String docpath=properties.getProperty("path")+"documents";
					String filePath=docpath+File.separator+document;
					File f=new File(filePath);
					f.delete();
				}
				pw.write("pass");
			}else
				pw.write("fail");
		}catch (Exception e) {
			e.printStackTrace();
		}

	}
}
