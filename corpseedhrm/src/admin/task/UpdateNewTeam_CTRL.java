package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@SuppressWarnings("serial")
public class UpdateNewTeam_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		PrintWriter pw=response.getWriter();
		   
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		
		String deptname = request.getParameter("deptname").trim();
		String teamname = request.getParameter("teamname").trim();
		String leadername = request.getParameter("leadername").trim();
		String leadercode = request.getParameter("leadercode").trim();
		String leaderid = request.getParameter("leaderid").trim();
		
		String teamkey=request.getParameter("teamrefid").trim();
				
		boolean flag=TaskMaster_ACT.updateNewTeam(teamkey,deptname,teamname,leadername,leadercode,leaderid,uavalidtokenno);		
	
		if(flag)pw.write("pass");
		else pw.write("fail");
	}

}