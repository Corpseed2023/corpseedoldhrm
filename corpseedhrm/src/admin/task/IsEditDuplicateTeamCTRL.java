package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class IsEditDuplicateTeamCTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try
		{
			HttpSession session=request.getSession();
			PrintWriter pw=response.getWriter();
			
			String token=(String)session.getAttribute("uavalidtokenno");
			String teamname=request.getParameter("teamname").trim();
			String teamrefid=request.getParameter("teamrefid").trim();
			boolean flag=TaskMaster_ACT.isEditTeamExist(teamname,teamrefid,token);
//			System.out.println("flag==="+flag);
			if(flag)pw.write("pass");
			else pw.write("fail");
		}catch (Exception e) {

		}

	}
}
