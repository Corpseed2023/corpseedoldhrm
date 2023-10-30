package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import commons.DateUtil;


@SuppressWarnings("serial")
public class AddMemberInMainTeam_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		PrintWriter pw=response.getWriter();
		   
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String loginuID = (String) session.getAttribute("loginuID");	
		String teamrefid = request.getParameter("teamrefid").trim();
		String membername = request.getParameter("mname").trim();
		String membercode = request.getParameter("mcode").trim();
		String memberuaid = request.getParameter("muaid").trim();
		String memberkey=request.getParameter("memberkey").trim();
		String date=DateUtil.getCurrentDateIndianFormat1();
		
		boolean flag=TaskMaster_ACT.saveTeamMember(teamrefid, memberkey, date, memberuaid, membercode, membername, uavalidtokenno, loginuID)		;
		if(flag)pw.write("pass");
		else pw.write("fail");
	}

}