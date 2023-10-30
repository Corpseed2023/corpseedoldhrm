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
public class AddMemberInTeam_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		PrintWriter pw=response.getWriter();
		   
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String loginuID = (String) session.getAttribute("loginuID");	
		
		String membername = request.getParameter("mname").trim();
		String membercode = request.getParameter("mcode").trim();
		String memberuaid = request.getParameter("muaid").trim();
		String key=request.getParameter("memberkey").trim();
		String date=DateUtil.getCurrentDateIndianFormat1();
		
		boolean flag=TaskMaster_ACT.addMember(key,membername,membercode,memberuaid,uavalidtokenno,loginuID,date);		
		if(flag)pw.write("pass");
		else pw.write("fail");
	}

}