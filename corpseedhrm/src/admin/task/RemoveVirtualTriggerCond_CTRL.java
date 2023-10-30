package admin.task;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;



@SuppressWarnings("serial")
public class RemoveVirtualTriggerCond_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		   
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
			
		String triggerKey = request.getParameter("triggerKey").trim();
		int numbering = Integer.parseInt(request.getParameter("rowId").trim());
		//removing trigger condition table data
		TaskMaster_ACT.removeTriggerConditions(triggerKey,numbering,uavalidtokenno);		
	}

}