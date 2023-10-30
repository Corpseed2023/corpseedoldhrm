package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import admin.master.Usermaster_ACT;
import admin.task.TaskMaster_ACT;
import commons.DateUtil;

public class ApproveThisTaskCTRL extends HttpServlet {

	private static final long serialVersionUID = 5077192931763876833L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
		HttpSession session=request.getSession();
		PrintWriter pw=response.getWriter();
		boolean flag=false;
		String assignkey=request.getParameter("assignkey");
		if(assignkey!=null)assignkey=assignkey.trim();
		
		String status=request.getParameter("status");
		if(status!=null)status=status.trim();
		
		String token=(String)session.getAttribute("uavalidtokenno");
		String userUid=(String)session.getAttribute("loginuaid");
		String today=DateUtil.getCurrentDateIndianFormat1();
		String loginuaid = (String)session.getAttribute("loginuaid");
		
		if(assignkey!=null&&assignkey.length()>0) {			
			flag=TaskMaster_ACT.updateTaskApproval(assignkey,status,token);
			String assignData[]=TaskMaster_ACT.getAssignedTaskDataByKey(assignkey, token);
			if(flag) {
				String salesStatus="NA";
				//checking task all status ok and assigned
				boolean allOk=TaskMaster_ACT.isTaskStatusOk(assignData[0],assignData[1],token);
				if(allOk){
//					String invoice=TaskMaster_ACT.getSalesInvoiceNumber(assignData[0], token);
					//set milestone start date
					boolean existFlag=TaskMaster_ACT.isDisperseExist(assignData[0], token); 
					double avlPrice=TaskMaster_ACT.getMainDispersedAmount(assignData[0], token);
					double orderAmt=TaskMaster_ACT.getSalesAmount(assignData[0], token);
					double percentage=TaskMaster_ACT.getWorkStartPercentage(assignData[0],assignData[1],token);
					double workPrice=(orderAmt*percentage)/100;
					if(avlPrice>=workPrice&&existFlag){
//						int taskStep=TaskMaster_ACT.getMilestoneStep(assignData[0], assignData[1], token);
						String deliveryData[]=TaskMaster_ACT.getTaskDeliveryDate(assignData[0], today, assignData[1],token);
						String deliveryDate="NA";
						String deliveryTime="NA";
						if(deliveryData[0]!=null)deliveryDate=deliveryData[0];
						if(deliveryData[1]!=null)deliveryTime=deliveryData[1];
						
						String date=DateUtil.getCurrentDateIndianReverseFormat();
						String startTime=DateUtil.getCurrentTime24Hours();
						TaskMaster_ACT.updateWorkStartedDate(assignData[0],assignData[1],today,deliveryDate,token,deliveryTime,startTime,date);
						
						//adding notification
						String nKey=RandomStringUtils.random(40,true,true);
						String milestoneData[]=TaskMaster_ACT.getAssignedMilestoneData(assignData[0],assignData[1], token);
						String message="Milestone : <span class='text-info'>"+milestoneData[0]+"</span> assigned started now,Begin your work !!.";
						TaskMaster_ACT.addNotification(nKey,today,milestoneData[1],"2","edittask-"+milestoneData[3]+".html",message,token,loginuaid,"fas fa-tasks");
						salesStatus="3";
					}else {
						salesStatus="1";
						TaskMaster_ACT.updateTaskProgressStatus(assignData[0],assignData[1],"1",token);
					}
				}
				if(!salesStatus.equalsIgnoreCase("NA"))	
					TaskMaster_ACT.updateProjectStatus(assignData[0],salesStatus,token);			
				//getting assigned task data
				String task[]=TaskMaster_ACT.getAssignedTaskData(assignkey,token);
				//sending notification to parent team's leader
				String teamLeaderuid=TaskMaster_ACT.getTeamLeaderId(task[0], token);
//				getting login user name
				String userName=Usermaster_ACT.getLoginUserName(userUid, token);
				String nApproveKey=RandomStringUtils.random(40,true,true);
				String approveMessage="";
				if(status.equals("1"))approveMessage="Your approval request milestone : <span class='text-info'>"+task[1]+"</span> is <b class='text-success'>approved</b> by &nbsp;<span class='text-muted'>"+userName+"</span>";
				else if(status.equals("3"))approveMessage="Your approval request milestone : <span class='text-info'>"+task[1]+"</span> is <b class='text-warning'>on hold</b> by &nbsp;<span class='text-muted'>"+userName+"</span>";
				TaskMaster_ACT.addNotification(nApproveKey,today,teamLeaderuid,"2","managedelivery.html",approveMessage,token,userUid,"fas fa-tasks");
			}			
		}
		if(flag)pw.write("pass");
		else pw.write("fail");
		}catch(Exception e) {
			e.printStackTrace();
		}
	}

}
