package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@SuppressWarnings("serial")
public class UpdateMilestoneStep_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

			PrintWriter pw=response.getWriter();
		
			String pmid = request.getParameter("pmid").trim();
			String val = request.getParameter("val").trim();
			String type = request.getParameter("type").trim();
			
			boolean flag=TaskMaster_ACT.updateMilestoneStep(pmid,val,type);		
			
			if(flag)pw.write("pass");
			else pw.write("fail");
	}

}