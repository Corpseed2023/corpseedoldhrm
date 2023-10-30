package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class DeleteVirtualMemberInTeam_CTRL extends HttpServlet {
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try
		{
			HttpSession session=request.getSession();
			
			PrintWriter pw=response.getWriter();
			String token=(String)session.getAttribute("uavalidtokenno");
			String memrefid=request.getParameter("memrefid");
			boolean flag=TaskMaster_ACT.deleteVirtualMember(memrefid,token);
			if(flag)pw.write("pass");
			else pw.write("fail");
		}catch (Exception e) {
			e.printStackTrace();
		}

	}
}
