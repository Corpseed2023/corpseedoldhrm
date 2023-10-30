package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class EnableDisableTriggerCTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		PrintWriter pw=response.getWriter();
		HttpSession session=request.getSession();
		String token=(String)session.getAttribute("uavalidtokenno");
		try
		{
			String tKey=request.getParameter("tKey").trim();
			String status=request.getParameter("status").trim();	
			
			boolean flag=TaskMaster_ACT.enableDisableTrigger(tKey,status,token);
			
			if(flag)
				pw.write("pass");
			else
				pw.write("fail");
		}catch (Exception e) {
			e.printStackTrace();
		}

	}
}
