package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;



@SuppressWarnings("serial")
public class AddVirtualTriggerCond_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		PrintWriter pw=response.getWriter();
		   
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String loginuaid = (String)session.getAttribute("loginuaid");	
		String triggerKey = request.getParameter("triggerKey").trim();
		String data = request.getParameter("data").trim();
		int numbering = Integer.parseInt(request.getParameter("numbering").trim());
		String column = request.getParameter("column").trim();
		String tckey=RandomStringUtils.random(40,true,true);
		
		boolean flag=TaskMaster_ACT.isTriggerConditionExist(triggerKey,numbering,uavalidtokenno);
			if(flag){
				flag=TaskMaster_ACT.updateTriggerConditions(triggerKey, data, numbering, column,uavalidtokenno);
			}else {
				flag=TaskMaster_ACT.saveTriggerConditions(tckey,triggerKey, data, numbering, column,uavalidtokenno,loginuaid);
			}
		if(flag)pw.write("pass");
		else pw.write("fail");
	}

}