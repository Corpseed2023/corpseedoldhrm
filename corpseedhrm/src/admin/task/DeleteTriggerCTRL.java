package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class DeleteTriggerCTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		PrintWriter pw=response.getWriter();
		HttpSession session=request.getSession();
		String token=(String)session.getAttribute("uavalidtokenno");
		try
		{
			String tKey=request.getParameter("tKey").trim();
			boolean flag=false;
			
			String[][] trigger=TaskMaster_ACT.getTriggerData(tKey, token);
			if(trigger!=null&&trigger.length>0) {
				//deleting trigger condition
				flag=TaskMaster_ACT.deleteTriggerCondition(trigger[0][2]);
				//deleting trigger action
				flag=TaskMaster_ACT.deleteTriggerAction(trigger[0][3]);
			}
			if(flag)			
			flag=TaskMaster_ACT.deleteTrigger(tKey,token);
			
			if(flag)
				pw.write("pass");
			else
				pw.write("fail");
		}catch (Exception e) {
			e.printStackTrace();
		}

	}
}
