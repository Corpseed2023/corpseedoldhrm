package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import admin.master.Usermaster_ACT;
import commons.DateUtil;

@SuppressWarnings("serial")
public class SaveTrigger_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		PrintWriter pw=response.getWriter();
		boolean flag=false;   
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String loginuaid = (String)session.getAttribute("loginuaid");	
		String triggerKey = request.getParameter("triggerKey").trim();		
		String module = request.getParameter("module").trim();
		String triggerName = request.getParameter("triggerName").trim();
		String triggerDescription = request.getParameter("triggerDescription").trim();
		String type=request.getParameter("type");
		if(type.equals("add")) {
			String takey=RandomStringUtils.random(40,true,true);
			String tckey=RandomStringUtils.random(40,true,true);
			
			String[][] conditions=TaskMaster_ACT.getAllVirtualConditions(triggerKey,loginuaid,uavalidtokenno);
			String[][] actions=TaskMaster_ACT.getAllVirtualActions(triggerKey,loginuaid,uavalidtokenno);
			
			if(conditions!=null&&conditions.length>0&&actions!=null&&actions.length>0) {
				//adding conditions
				for(int i=0;i<conditions.length;i++) {
					flag=TaskMaster_ACT.addTriggerCondition(tckey,conditions[i][0],conditions[i][1],conditions[i][2]);
				}
				//adding actions
				for(int i=0;i<actions.length;i++) {
					flag=TaskMaster_ACT.addTriggerAction(takey,actions[i][0],actions[i][1],actions[i][2],actions[i][3]);
				}
				if(flag) {
					//getting trigger number
					String start=Usermaster_ACT.getStartingCode(uavalidtokenno,"imtriggerkey");
					String triggerNo=TaskMaster_ACT.getTriggerNo(uavalidtokenno);
					
					if (triggerNo==null||triggerNo.equalsIgnoreCase("NA")) {	
						triggerNo=start+"1";
					}
					else {
						String c=triggerNo.substring(start.length());
					int j=Integer.parseInt(c)+1;
					triggerNo=start+Integer.toString(j);
					}
					//mapping trigger's condition and action
					String tkey=RandomStringUtils.random(40,true,true);
					String today=DateUtil.getCurrentDateIndianFormat1();				
					flag=TaskMaster_ACT.mapTriggerConditionActions(tkey,triggerNo,module,triggerName,triggerDescription,tckey,takey,loginuaid,uavalidtokenno,today);
				}
			}
		}else if(type.equals("update")) {
			String trigger[][]=TaskMaster_ACT.getTriggerData(triggerKey,uavalidtokenno);
			if(trigger!=null&&trigger.length>0) {
				if(!trigger[0][0].equals(triggerName)||!trigger[0][1].equals(triggerDescription)) {
					//update trigger
					flag=TaskMaster_ACT.updateTrigger(triggerKey,triggerName,triggerDescription,uavalidtokenno);
				}else {
					flag=true;
				}
				if(flag) {
					String[][] conditions=TaskMaster_ACT.getAllVirtualConditions(triggerKey,loginuaid,uavalidtokenno);
					String[][] actions=TaskMaster_ACT.getAllVirtualActions(triggerKey,loginuaid,uavalidtokenno);
					
					if(conditions!=null&&conditions.length>0) {
						//adding conditions
						for(int i=0;i<conditions.length;i++) {
							flag=TaskMaster_ACT.addTriggerCondition(trigger[0][2],conditions[i][0],conditions[i][1],conditions[i][2]);
						}
					}
					if(actions!=null&&actions.length>0) {
						//adding actions
						for(int i=0;i<actions.length;i++) {
							flag=TaskMaster_ACT.addTriggerAction(trigger[0][3],actions[i][0],actions[i][1],actions[i][2],actions[i][3]);
						}						
					}
					
				}
			}			
		}
		
		if(flag)pw.write("pass");
		else pw.write("fail");
	}

}