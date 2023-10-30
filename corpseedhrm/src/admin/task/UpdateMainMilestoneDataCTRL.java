package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@SuppressWarnings("serial")
public class UpdateMainMilestoneDataCTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		PrintWriter pw=response.getWriter();
		
			String colname = request.getParameter("colname").trim();
			String val = request.getParameter("val").trim();
			String uid = request.getParameter("uid").trim();
			
			boolean flag=TaskMaster_ACT.updateProductMilestone(colname,val,uid);		
			
			
		if(flag)pw.write("pass");
		else pw.write("fail");
	}

}