package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@SuppressWarnings("serial")
public class UpdateMainDocumentDataCTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		PrintWriter pw=response.getWriter();
		
			String column = request.getParameter("column").trim();
			String val = request.getParameter("val").trim();
			String uid = request.getParameter("uid").trim();
			
			boolean flag=TaskMaster_ACT.updateProductDocument(column,val,uid);		
			
			
		if(flag)pw.write("pass");
		else pw.write("fail");
	}

}