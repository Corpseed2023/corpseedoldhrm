package client_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import admin.Login.LoginAction;
import admin.master.Usermaster_ACT;
import hcustbackend.ClientACT;

@SuppressWarnings("serial")
public class DeleteAssignTask_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			 //fetching date
			
			HttpSession session=request.getSession();
			String loginuaid = (String) session.getAttribute("loginuaid");
			String token=(String)session.getAttribute("uavalidtokenno");
			String loginid = (String) session.getAttribute("loginuID");
			String aid = request.getParameter("info").trim();
			String taskid = request.getParameter("taskid").trim();
			String asstoid = request.getParameter("asstoid").trim();
			String pregno = request.getParameter("pregno").trim();
			String taskno=Clientmaster_ACT.getTaskNumber(taskid,token);
			String imgname=Clientmaster_ACT.getDocument(aid,token);
		
			//add notification 'assign task ...'
			String pagename="mytask.html";
			String accesscode="MT00";
			String uuid =RandomStringUtils.random(30, true, true);	
			String assignby=Usermaster_ACT.getLoginUserName(loginuaid,token);	
			String assignedto=Usermaster_ACT.getLoginUserName(asstoid,token);
			String[] task=LoginAction.getTaskDetails(taskid);
			String msg="<b>"+pregno+" : "+task[1]+"</b> task removed by  <b>"+assignby+"</b> from <b>"+assignedto+"</b>";
			ClientACT.addNotification(uuid,pregno,msg,pagename,"assigntask","0","NA","1","1",loginid,token,"NA",loginuaid,accesscode,"1","0");
			
			//REMOVING ASSIGN TASK
			Clientmaster_ACT.deleteAssignedTask(aid,taskid,asstoid,taskno,token);
			
			if(imgname!=null){
				Clientmaster_ACT.deleteDocument(imgname,pregno,token);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}
