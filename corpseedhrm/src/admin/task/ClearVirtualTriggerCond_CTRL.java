package admin.task;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;



@SuppressWarnings("serial")
public class ClearVirtualTriggerCond_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		try { 		   
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String loginuaid = (String)session.getAttribute("loginuaid");		
		//clear all added condition data
		TaskMaster_ACT.clearTriggerConditions(loginuaid,uavalidtokenno);
		//clear all added action data
		TaskMaster_ACT.clearTriggerActions(loginuaid,uavalidtokenno);
		}catch(Exception e) {
			e.printStackTrace();
		}
	}

}