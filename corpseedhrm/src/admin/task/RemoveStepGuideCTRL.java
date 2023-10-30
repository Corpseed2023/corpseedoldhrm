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

public class RemoveStepGuideCTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		PrintWriter pw=response.getWriter();
		HttpSession session=request.getSession();
		String token=(String)session.getAttribute("uavalidtokenno");
		try
		{
			String milestoneId=request.getParameter("milestoneId").trim();
			String attachdDoc[][]=TaskMaster_ACT.getAllAttachedFiles(milestoneId,token);
			if(attachdDoc!=null&&attachdDoc.length>0) {
				Properties properties = new Properties();
				properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
				String docpath=properties.getProperty("path")+"documents";
				for(int i=0;i<attachdDoc.length;i++) {
					String filePath=docpath+File.separator+attachdDoc[i][0];
					File f=new File(filePath);
					f.delete();
				}
			}
			boolean flag=TaskMaster_ACT.removeStepGuide(milestoneId,token);
			if(flag)
				pw.write("pass");
			else
				pw.write("fail");
		}catch (Exception e) {
			e.printStackTrace();
		}

	}
}
