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
public class AssignToManager_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session=request.getSession();
		PrintWriter pw=response.getWriter();
		
		String salesrefid = request.getParameter("salesrefid").trim();
		String teamuaid = request.getParameter("teamuaid").trim();		
		String teamname = request.getParameter("teamname").trim();
		//getting today's date
		String today=DateUtil.getCurrentDateIndianFormat1();
		String token= (String)session.getAttribute("uavalidtokenno");
		
		String assignUaid=TaskMaster_ACT.findAssignedManager(salesrefid,token);
		
		if(!assignUaid.equalsIgnoreCase(teamuaid)) {		
			boolean flag=TaskMaster_ACT.updateDeliveryAssignDetails(salesrefid,teamuaid,teamname,today,token);
			if(flag)pw.write("pass");
			else pw.write("fail");
		}else {
			pw.write("assigned");
		}
			
	}

}