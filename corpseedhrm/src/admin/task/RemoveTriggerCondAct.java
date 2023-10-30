package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
public class RemoveTriggerCondAct extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		PrintWriter pw=response.getWriter();
		boolean flag=false;   
		String id = request.getParameter("id").trim();	
		String type=request.getParameter("type");
		if(type.equals("condition")) {
			flag=TaskMaster_ACT.removeTriggerCondition(id);			
		}else if(type.equals("action")) {
			flag=TaskMaster_ACT.removeTriggerAction(id);			
		}
		
		if(flag)pw.write("pass");
		else pw.write("fail");
	}

}