package client_master;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@SuppressWarnings("serial")
public class AddProjectMilestone_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();		 
		Date date = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");	
		String dateTime=formatter.format(date);  
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String loginuID = (String) session.getAttribute("loginuID");
	
		String psdate=null;
			String work_type = request.getParameter("work_type").trim();
			String Unit_Time = request.getParameter("Unit_Time").trim();
			String Duration = request.getParameter("Duration").trim();
			String SMSID = request.getParameter("SMSID").trim();
			String EmailId = request.getParameter("EmailId").trim();
			String pid = request.getParameter("pid").trim();
			String Enq = request.getParameter("Enq").trim();
			if(Enq.equalsIgnoreCase("NA"))
			psdate = request.getParameter("psdate").trim();
			
			
			Clientmaster_ACT.addProjectMilestone(pid,work_type,Unit_Time,Duration,SMSID,EmailId,uavalidtokenno,loginuID,dateTime,Enq);		
			Clientmaster_ACT.updateProjectTimeline(pid,uavalidtokenno,Enq);
			if(Enq.equalsIgnoreCase("NA"))
			Clientmaster_ACT.updateDeliveryDate(psdate,pid,uavalidtokenno);
	}

}