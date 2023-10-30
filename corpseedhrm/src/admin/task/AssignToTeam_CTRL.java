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
public class AssignToTeam_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session=request.getSession();
		PrintWriter pw=response.getWriter();
		
		boolean flag=false;
			String salesrefid = request.getParameter("salesrefid").trim();
			String teamrefid = request.getParameter("teamrefid").trim();		
			String teamname = request.getParameter("teamname").trim();		
			String addedby=(String)session.getAttribute("loginuID");
			//getting today's date
			String today=DateUtil.getCurrentDateIndianFormat1();
			String loginuaid = (String)session.getAttribute("loginuaid");
			String token= (String)session.getAttribute("uavalidtokenno");
			
			//getting teamrefid
			String assigned=TaskMaster_ACT.getProjectAssignedData(salesrefid,token);
//			System.out.println("assigned==="+assigned);
			if(!assigned.equalsIgnoreCase(teamrefid)&&teamrefid!=null&&!teamrefid.equalsIgnoreCase("NA")){
			
				//getting sales data before update work status
				String salesDataOld[][]=Enquiry_ACT.getSalesByRefId(salesrefid, token);
									
				//getting current time
				String Time=DateUtil.getCurrentTime();
				
				//getting sales name,project no and invoice no
				String salesData[]=TaskMaster_ACT.getSalesData(salesrefid,token);
				
				//getting primary contact data
				String contactData[]=Enquiry_ACT.getClientContactByKey(salesData[3], token);
				
				//getting login user id 
				String userUid=(String)session.getAttribute("loginuaid");
				String teamLeader="NA";
				
				//getting team leader id and name
				String leaderId=TaskMaster_ACT.getTeamLeaderId(teamrefid,token); 
				if(!leaderId.equalsIgnoreCase("NA"))
					teamLeader=Usermaster_ACT.getLoginUserName(leaderId, token);
				
//				getting login user name
				String userName=Usermaster_ACT.getLoginUserName(userUid, token);
				
				//getting sales dependency status if depend then status 2 otherwise 1
				String salesDependency=TaskMaster_ACT.getSalesDependencyStatus(salesrefid,token);
				String hierarchy[]=salesDependency.split("#");
				
				//		update team info in manage Sales
				flag=TaskMaster_ACT.updateAssigne(salesrefid,teamname,teamrefid, token);
//				System.out.println("flag======"+flag);
			if(flag) {
				String dhKey=RandomStringUtils.random(40,true,true);				
				if(salesDataOld!=null&&salesDataOld.length>0) {
					int totalDay[]=TaskMaster_ACT.getTotalMilestoneDays(salesrefid, token);
					String deliveryData[]=DateUtil.getLastDate(salesDataOld[0][12], totalDay[0],totalDay[1]);
					
					String deliveryDate="NA";
					if(deliveryData[0]!=null&&!deliveryData[0].equalsIgnoreCase("NA"))deliveryDate=deliveryData[0];
					
					String deliveryTime="NA";
					if(deliveryData[1]!=null&&!deliveryData[1].equalsIgnoreCase("NA"))deliveryTime=deliveryData[1];
					
					
					String prevCurrentData[]=TaskMaster_ACT.getPreviousCurrentData(salesrefid,token);
					String prevStatus="NA";
					if(prevCurrentData[1]!=null&&prevCurrentData[1].equalsIgnoreCase(salesDataOld[0][13]))prevStatus=prevCurrentData[0];
					else if(prevCurrentData[1]!=null) prevStatus=prevCurrentData[1];
					String prevTeamKey="NA";
					if(prevCurrentData[3]!=null&&prevCurrentData[3].equalsIgnoreCase(teamrefid))prevTeamKey=prevCurrentData[2];
					else if(prevCurrentData[3]!=null) prevTeamKey=prevCurrentData[3];
					String prevPriority="NA";
					if(prevCurrentData[5]!=null&&prevCurrentData[5].equalsIgnoreCase(salesDataOld[0][15]))prevPriority=prevCurrentData[4];
					else if(prevCurrentData[5]!=null) prevPriority=prevCurrentData[5];
					//adding data in delivery action history for triggers
					flag=TaskMaster_ACT.saveDeliveryActionHistory(dhKey, salesrefid, deliveryDate,prevStatus, salesDataOld[0][13], prevTeamKey,teamrefid,prevPriority,salesDataOld[0][15], today, token, loginuaid,deliveryTime);
				}
			}	
				
			if(flag&&assigned.equalsIgnoreCase("NA")){				
				//getting all milestones of this sales
				String milestone[][]=TaskMaster_ACT.getSalesMilestoneByKey(salesrefid,token);
				if(milestone!=null&&milestone.length>0){
					for(int i=0;i<milestone.length;i++){
						String assignKey=RandomStringUtils.random(40,true,true);
						String stepStatus="2";
						if(milestone[i][1].equalsIgnoreCase("1"))stepStatus="1";
						int stepNo=Integer.parseInt(milestone[i][1]);
						String deliveryDate="NA";
						String deliveryTime="NA";
								
						String deliveryData[]=TaskMaster_ACT.getMilestoneDeliveryDate(salesrefid,today, milestone[i][0],stepNo,token);
						if(deliveryData[0]!=null)deliveryDate=deliveryData[0];
						if(deliveryData[1]!=null)deliveryTime=deliveryData[1];
//						System.out.println("going to assign milestones....");
						//assign this task to this team.......................
						flag=TaskMaster_ACT.assignThisTask(assignKey,salesrefid,milestone[i][0],teamrefid,today,
								hierarchy[0],hierarchy[1],"1",stepStatus,addedby,token,milestone[i][2],milestone[i][3],
								milestone[i][4],salesData[5],deliveryDate,deliveryTime);
					
						//add data in milestone action history
						if(flag){
							String mKey=RandomStringUtils.random(40,true,true);
							String salesName=Enquiry_ACT.getSalesProductName(salesrefid, token);				//childTeam    uid             workStatus			 priority
//							String deliveryDate=TaskMaster_ACT.getMilestoneDeliveryDate(today, milestone[i][0], token);
							flag=TaskMaster_ACT.saveMilestoneActionHistory(mKey,assignKey,salesrefid,salesName,"NA",teamrefid,"NA","NA","NA","NA","Unassigned","Unassigned","Low","Low",deliveryDate,today,token,"NA","NA",deliveryTime);
						}
					}
				}				
				//add chat thread
				String taskKey=RandomStringUtils.random(40,true,true);				
				String subject="Project Assigned";
				String content="Project assigned to team leader <span style='color: #4ac4f3;font-weight: 600;'>'"+teamLeader+"'</span> on <span style='color: #4ac4f3;font-weight: 600;'>"+today+" "+Time+"</span> by <span style='color: #4ac4f3;font-weight: 600;'>'"+userName+"'</span>";
				String salesStatus=TaskMaster_ACT.getSalesStatus(salesrefid, token);
				//set notification task assigned to team leader	
				flag=TaskMaster_ACT.setTaskNotification(taskKey,salesrefid,salesData[0],salesData[1],salesData[2],"Notification","bell.png",contactData[0],contactData[1],contactData[2],userUid,userName,today+" "+Time,subject,content,addedby,token,"NA","NA","NA",salesStatus,"NA");				
				
				//adding notification
				String nKey=RandomStringUtils.random(40,true,true);
				String teamLeaderUid=TaskMaster_ACT.getTeamLeaderId(teamrefid, token);
				String teamName=TaskMaster_ACT.getTeamName(teamrefid, token);
				String teamLeaderName=Usermaster_ACT.getLoginUserName(teamLeaderUid, token);
				String message="Project : <span class='text-info'>"+salesDataOld[0][16]+"</span> : <span class='text-info'>"+salesDataOld[0][7]+"</span> assigned to team leader <span class='text-muted'>"+teamLeaderName+"</span> of team <span class='text-muted'>"+teamName+"</span> by &nbsp;<span class='text-muted'>"+userName+"</span>";
				TaskMaster_ACT.addNotification(nKey,today,teamLeaderUid,"2","managedelivery.html",message,token,loginuaid,"fas fa-file-powerpoint");
			
			}else{
				//getting all assigned milestone data
				String milestoneData[][]=TaskMaster_ACT.getAllSalesMilestone("NA", salesrefid, token);
				//re assign this sale to new team
				flag=TaskMaster_ACT.reAssignThisTaskToNewTeam(salesrefid,teamrefid,today,token);	
				//add data in milestone action history
				//add data in milestone action history
				if(flag&&milestoneData!=null&&milestoneData.length>0){
					for(int i=0;i<milestoneData.length;i++) {
						String prevParentTeamKey="NA";
						String prevChildTeamKey="NA";
						String prevTeamMemberUid="NA";
						String prevWorkStatus="NA";
						String pervWorkPriority="NA";
						String userPost="NA";
						String prevUserPost="NA";
						if(!milestoneData[i][2].equalsIgnoreCase("NA")) {
							userPost=Usermaster_ACT.getUserPost(milestoneData[i][2],token);
							if(!userPost.equalsIgnoreCase("Delivery manager")) {
								String teamLeaderUid=TaskMaster_ACT.getTeamLeaderId(milestoneData[i][13], token);
								if(milestoneData[i][2].equalsIgnoreCase(teamLeaderUid)&&!teamLeaderUid.equalsIgnoreCase("NA"))userPost="Team Leader";
							}
						}
						
						String prevCurrMilestoneData[]=TaskMaster_ACT.getPrevCurrMilestoneData(salesrefid,token);
						if(prevCurrMilestoneData[0]!=null) {
							if(prevCurrMilestoneData[1].equalsIgnoreCase(teamrefid))prevParentTeamKey=prevCurrMilestoneData[0];
							else prevParentTeamKey=prevCurrMilestoneData[1];
							
							if(prevCurrMilestoneData[3].equalsIgnoreCase(milestoneData[i][6]))prevChildTeamKey=prevCurrMilestoneData[2];
							else prevChildTeamKey=prevCurrMilestoneData[3];
							
							if(prevCurrMilestoneData[5].equalsIgnoreCase(milestoneData[i][2]))prevTeamMemberUid=prevCurrMilestoneData[4];
							else prevTeamMemberUid=prevCurrMilestoneData[5];
							
							if(prevCurrMilestoneData[7].equalsIgnoreCase(milestoneData[i][9]))prevWorkStatus=prevCurrMilestoneData[6];
							else prevWorkStatus=prevCurrMilestoneData[7];
							
							if(prevCurrMilestoneData[9].equalsIgnoreCase(milestoneData[i][12]))pervWorkPriority=prevCurrMilestoneData[8];
							else pervWorkPriority=prevCurrMilestoneData[9];
							
							if(prevCurrMilestoneData[11].equalsIgnoreCase(userPost))prevUserPost=prevCurrMilestoneData[10];
							else prevUserPost=prevCurrMilestoneData[11];
												
							String mKey=RandomStringUtils.random(40,true,true);
							String salesName=Enquiry_ACT.getSalesProductName(salesrefid, token);
							int stepNo=TaskMaster_ACT.getMilestoneStep(salesrefid, milestoneData[i][0], token);
							String deliveryData[]=TaskMaster_ACT.getMilestoneDeliveryDate(salesrefid,today, milestoneData[i][0],stepNo,token);
							String deliveryDate="NA";
							String deliveryTime="NA";
							if(deliveryData[0]!=null)deliveryDate=deliveryData[0];
							if(deliveryData[1]!=null)deliveryTime=deliveryData[1];
							flag=TaskMaster_ACT.saveMilestoneActionHistory(mKey,milestoneData[i][5],salesrefid,salesName,prevParentTeamKey,teamrefid,prevChildTeamKey,milestoneData[i][6],prevTeamMemberUid,milestoneData[i][2],prevWorkStatus,milestoneData[i][9],pervWorkPriority,milestoneData[i][12],deliveryDate,today,token,prevUserPost,userPost,deliveryTime);
						}
					}					
				}				
				
				//add chat thread
				String taskKey=RandomStringUtils.random(40,true,true);				
				String subject="Project Re-assigned";
				String content="Project Re-assigned to team leader <span style='color: #4ac4f3;font-weight: 600;'>'"+teamLeader+"'</span> on <span style='color: #4ac4f3;font-weight: 600;'>"+today+" "+Time+"</span> by <span style='color: #4ac4f3;font-weight: 600;'>'"+userName+"'</span>";
				String salesStatus=TaskMaster_ACT.getSalesStatus(salesrefid, token);
				//set notification task assigned to team leader	
				flag=TaskMaster_ACT.setTaskNotification(taskKey,salesrefid,salesData[0],salesData[1],salesData[2],"Notification","bell.png",contactData[0],contactData[1],contactData[2],userUid,userName,today+" "+Time,subject,content,addedby,token,"NA","NA","NA",salesStatus,"NA");
			
				//adding notification
				String nKey=RandomStringUtils.random(40,true,true);
				String teamLeaderUid=TaskMaster_ACT.getTeamLeaderId(teamrefid, token);
				String teamName=TaskMaster_ACT.getTeamName(teamrefid, token);
				String teamLeaderName=Usermaster_ACT.getLoginUserName(teamLeaderUid, token);
				String message="Project : <span class='text-info'>"+salesDataOld[0][16]+"</span> : <span class='text-info'>"+salesDataOld[0][7]+"</span> re-assigned to team leader <span class='text-muted'>"+teamLeaderName+"</span> of team <span class='text-muted'>"+teamName+"</span> by &nbsp;<span class='text-muted'>"+userName+"</span>";
				TaskMaster_ACT.addNotification(nKey,today,teamLeaderUid,"2","managedelivery.html",message,token,loginuaid,"fas fa-people-arrows");
			}
			
			
		}		
		if(assigned.equalsIgnoreCase(teamrefid)&&teamrefid!=null&&!teamrefid.equalsIgnoreCase("NA")){
			pw.write("assigned");}else if(flag)pw.write("pass");
			else pw.write("fail");
	}

}