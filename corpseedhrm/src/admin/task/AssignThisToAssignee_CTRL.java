package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import admin.enquiry.Enquiry_ACT;
import admin.master.Usermaster_ACT;
import commons.DateUtil;


@SuppressWarnings("serial")
public class AssignThisToAssignee_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
//System.out.println("running good..................");
		HttpSession session=request.getSession();
		PrintWriter pw=response.getWriter();
		
		boolean flag=false;
			String assignKey = request.getParameter("assignKey").trim();
			String milestoneName = request.getParameter("milestoneName").trim();		
			String teamRefKey = request.getParameter("teamRefKey").trim();		
			String memberId=request.getParameter("memberId").trim();
			String assignDate=request.getParameter("assignDate").trim();
			String assignedTeamKey=request.getParameter("assignedTeamKey").trim();
			String salesKey = request.getParameter("salesKey").trim();
			
			String token= (String)session.getAttribute("uavalidtokenno");
			String userUid=(String)session.getAttribute("loginuaid");
			String addedby=(String)session.getAttribute("loginuID");
			String childTeamKey="NA";
			String managerApproval="1";
			//getting assigned member uid to check already assigned or not
			String oldUserId=TaskMaster_ACT.isTaskAlreadyAssigned(assignKey,token);
			if(!oldUserId.equalsIgnoreCase(memberId)){
			
			String assignedMemberId=TaskMaster_ACT.getAssignedMemberId(assignKey,token);
			if(!teamRefKey.equalsIgnoreCase(assignedTeamKey)){
				childTeamKey=teamRefKey;
				managerApproval="2";
			}
			//getting all assigned milestone data
			String milestoneData[][]=TaskMaster_ACT.getAssignedSalesMilestone(assignKey, token);
			
			String time=DateUtil.getCurrentTime24Hours();
			String date=DateUtil.getCurrentDateIndianReverseFormat();
			//getting today's date
			String today=DateUtil.getCurrentDateIndianFormat1();
			
			//getting sales name,project no and invoice no
			String salesData1[]=TaskMaster_ACT.getSalesData(salesKey,token);
			
			String paymentMode=Enquiry_ACT.getPaymentModeByInvoice(salesData1[2], token);
			
			int stepNo=TaskMaster_ACT.getMilestoneStep(salesKey, milestoneData[0][0], token);
			String deliveryData[]=TaskMaster_ACT.getMilestoneDeliveryDate(salesKey,today, milestoneData[0][0],stepNo,token);
			String deliveryDate="NA";
			String deliveryTime="NA";
			if(deliveryData[0]!=null)deliveryDate=deliveryData[0];
			if(deliveryData[1]!=null)deliveryTime=deliveryData[1];
			
			flag=TaskMaster_ACT.assignThisMilestone(assignKey,milestoneName,childTeamKey,memberId,assignDate,"New",userUid,managerApproval,token,time,date,deliveryDate,deliveryTime);
			
			if(flag){	
				String milestoneKey=TaskMaster_ACT.findMilestoneKey(assignKey,token);
				if(!milestoneKey.equalsIgnoreCase("NA")) {
					String lastMilestoneKey=TaskMaster_ACT.getLastMilestoneKey(salesKey,token);
					if(milestoneKey.equalsIgnoreCase(lastMilestoneKey)) {
						TaskMaster_ACT.updateSalesDeliveryDateAndTime(deliveryDate,deliveryTime,salesKey,token);
					}
				}
				
				//add data in milestone action history
				if(flag&&milestoneData!=null&&milestoneData.length>0){				
						String prevParentTeamKey="NA";
						String prevChildTeamKey="NA";
						String prevTeamMemberUid="NA";
						String prevWorkStatus="NA";
						String pervWorkPriority="NA";						
						String userPost="NA";
						String prevUserPost="NA";
						userPost=Usermaster_ACT.getUserPost(memberId,token);
						if(!userPost.equalsIgnoreCase("Delivery manager")) {
							String teamLeaderUid=TaskMaster_ACT.getTeamLeaderId(milestoneData[0][13], token);
							if(memberId.equalsIgnoreCase(teamLeaderUid)&&!teamLeaderUid.equalsIgnoreCase("NA"))userPost="Team Leader";
						}						
						
						String prevCurrMilestoneData[]=TaskMaster_ACT.getPrevCurrMilestoneDataByKey(assignKey,token);
						if(prevCurrMilestoneData[0]!=null) {
							if(prevCurrMilestoneData[1].equalsIgnoreCase(milestoneData[0][13]))prevParentTeamKey=prevCurrMilestoneData[0];
							else prevParentTeamKey=prevCurrMilestoneData[1];
							
							if(prevCurrMilestoneData[3].equalsIgnoreCase(childTeamKey))prevChildTeamKey=prevCurrMilestoneData[2];
							else prevChildTeamKey=prevCurrMilestoneData[3];
							
							if(prevCurrMilestoneData[5].equalsIgnoreCase(memberId))prevTeamMemberUid=prevCurrMilestoneData[4];
							else prevTeamMemberUid=prevCurrMilestoneData[5];
							
							if(prevCurrMilestoneData[7].equalsIgnoreCase("New"))prevWorkStatus=prevCurrMilestoneData[6];
							else prevWorkStatus=prevCurrMilestoneData[7];
							
							if(prevCurrMilestoneData[9].equalsIgnoreCase(milestoneData[0][12]))pervWorkPriority=prevCurrMilestoneData[8];
							else pervWorkPriority=prevCurrMilestoneData[9];
									
							if(prevCurrMilestoneData[11].equalsIgnoreCase(userPost))prevUserPost=prevCurrMilestoneData[10];
							else prevUserPost=prevCurrMilestoneData[11];
							
							String mKey=RandomStringUtils.random(40,true,true);
							String salesName=Enquiry_ACT.getSalesProductName(salesKey, token);	
							
							
							flag=TaskMaster_ACT.saveMilestoneActionHistory(mKey,milestoneData[0][5],salesKey,salesName,prevParentTeamKey,milestoneData[0][13],prevChildTeamKey,childTeamKey,prevTeamMemberUid,memberId,prevWorkStatus,"New",pervWorkPriority,milestoneData[0][12],deliveryDate,today,token,prevUserPost,userPost,deliveryTime);
						}
				}
				
				String salesStatus="NA";
				//checking task all status ok and assigned
				boolean allOk=TaskMaster_ACT.isTaskStatusOk(assignKey,token);
//				System.out.println("allOk==="+allOk);
				if(allOk){
//					String invoice=TaskMaster_ACT.getSalesInvoiceNumber(salesKey, token);
					//set milestone start date
					boolean existFlag=TaskMaster_ACT.isDisperseExist(salesKey, token); 
					double avlPrice=TaskMaster_ACT.getMainDispersedAmount(salesKey, token);
					double orderAmt=TaskMaster_ACT.getSalesAmount(salesKey, token);
					double percentage=TaskMaster_ACT.getWorkStartPercentage(assignKey,token);
					double workPrice=(orderAmt*percentage)/100;
//					System.out.println("avlPrice="+avlPrice+"/workPrice="+workPrice+"/existFlag="+existFlag);
					if(avlPrice>=workPrice&&(existFlag||paymentMode.equalsIgnoreCase("PO"))){
						String deliveryData1[]=TaskMaster_ACT.getTaskDeliveryDate(salesKey, today, milestoneData[0][0],token);
						String deliveryDate1="NA";
						String deliveryTime1="NA";
						if(deliveryData1[0]!=null)deliveryDate1=deliveryData1[0];
						if(deliveryData1[1]!=null)deliveryTime1=deliveryData1[1];
						String startTime=DateUtil.getCurrentTime24Hours();
//						System.out.println("work startTime==="+startTime);
						TaskMaster_ACT.updateTaskWorkStartedDate(assignKey,today,token,startTime,deliveryDate1,deliveryTime1,date);
//						System.out.println("Work started (AssignThisToAssignee)");
						salesStatus="3";
					}else {
						salesStatus="1";
						TaskMaster_ACT.updateTaskProgressStatus(assignKey,"1",token);
						
						if(!paymentMode.equalsIgnoreCase("PO")){						
							String accountant[][]=Usermaster_ACT.getAllAccountant(token);
							if(accountant!=null&&accountant.length>0) {
								for(int j=0;j<accountant.length;j++) {
									String salesData[]=TaskMaster_ACT.getSalesData(salesKey, token);
									 //adding notification
									String nKey=RandomStringUtils.random(40,true,true);
									String message="Project : <span class='text-info'>"+salesData[1]+"</span> :- add payment to start project work.";
									TaskMaster_ACT.addNotification(nKey,today,accountant[j][0],"2","manage-billing.html",message,token,userUid,"fas fa-rupee-sign");
									//adding for sold person
									String userNKey=RandomStringUtils.random(40,true,true);
									String userMessage="Estimate No. : <span class='text-info'>"+salesData[7]+"</span> :- add payment to start project work.";
									TaskMaster_ACT.addNotification(userNKey,today,salesData[6],"2","manage-estimate.html",userMessage,token,userUid,"fas fa-rupee-sign");
							}}
						}
					}
				}
				if(!salesStatus.equalsIgnoreCase("NA"))	
					TaskMaster_ACT.updateProjectStatus(salesKey,salesStatus,token);
				
				//getting team name
				String teamName=TaskMaster_ACT.getTeamName(teamRefKey,token);
//				getting login user name
				String userName=Usermaster_ACT.getLoginUserName(userUid, token);
				
				//getting current time
				String Time=DateUtil.getCurrentTime();
							
				
				//getting primary contact data
				String contactData[]=Enquiry_ACT.getClientContactByKey(salesData1[3], token);
				
				String memberName=Usermaster_ACT.getLoginUserName(memberId, token);
				//add chat thread
				String taskKey=RandomStringUtils.random(40,true,true);				
				String subject="Milestone Assigned";
				String assStatus="assigned";
				if(assignedMemberId!=null&&assignedMemberId!=""&&!assignedMemberId.equalsIgnoreCase("NA")) {
					subject="Milestone Re-assigned";
					assStatus="Re-assigned";
				}
				String content="<span style='color: #4ac4f3;font-weight: 600;'>'"+milestoneName+"</span> "+assStatus+" to <span style='color: #4ac4f3;font-weight: 600;'>'"+memberName+"'</span> of Team <span style='color: #4ac4f3;font-weight: 600;'>'"+teamName+"</span> on <span style='color: #4ac4f3;font-weight: 600;'>"+today+" "+Time+"</span> by&nbsp;<span style='color: #4ac4f3;font-weight: 600;'>'"+userName+"'</span>";
				//set notification task assigned to team leader	
				flag=TaskMaster_ACT.setTaskNotification(taskKey,salesKey,salesData1[0],salesData1[1],salesData1[2],"Notification","bell.png",contactData[0],contactData[1],contactData[2],userUid,userName,today+" "+Time,subject,content,addedby,token,"NA","NA","NA","New","NA");
			
				//adding notification
				String nKey=RandomStringUtils.random(40,true,true);
				String message="Milestone : <span class='text-info'>"+milestoneName+"</span> assigned you by &nbsp;<span class='text-muted'>"+userName+"</span>";
				TaskMaster_ACT.addNotification(nKey,today,memberId,"2","mytask.html",message,token,userUid,"fas fa-tasks");
				
				//send notification if task assigned to child team
				if(!childTeamKey.equalsIgnoreCase("NA")) {
					String teamLeaderuid=TaskMaster_ACT.getTeamLeaderId(childTeamKey, token);
					//adding notification
					String nApproveKey=RandomStringUtils.random(40,true,true);
					String approveMessage="You have new milestone : <span class='text-info'>"+milestoneName+"</span> for approval by &nbsp;<span class='text-muted'>"+userName+"</span>";
					TaskMaster_ACT.addNotification(nApproveKey,today,teamLeaderuid,"2","managedelivery.html",approveMessage,token,userUid,"fas fa-tasks");
				}
				
				
				//adding task to task_notification table for count work duration of task
				boolean isTask=TaskMaster_ACT.isTaskProgressExist(salesKey,assignKey,memberId,token);
				if(!isTask) {
					String uid=RandomStringUtils.random(40,true,true); 
					TaskMaster_ACT.saveTaskProgress(uid,assignKey,salesKey,milestoneName,memberId,memberName,0,0,0,0,0,0,0,0,0,0,token);
				}
				
				pw.write("pass");
			}else pw.write("fail");			
		}else{
			pw.write("exist");
		}
	}

}