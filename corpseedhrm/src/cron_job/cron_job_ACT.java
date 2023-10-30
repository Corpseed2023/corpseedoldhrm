package cron_job;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Date;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServlet;

import org.apache.commons.lang.RandomStringUtils;

import admin.enquiry.Enquiry_ACT;
import admin.master.Usermaster_ACT;
import admin.task.TaskMaster_ACT;
import commons.CommonHelper;
import commons.DateUtil;
import commons.DbCon;

public class cron_job_ACT extends HttpServlet {

	private static final long serialVersionUID = -2686869388104064257L;
	
	
	public static StringBuffer milestoneTrigger(String conditionKey,String token) {
		StringBuffer query=new StringBuffer();
		StringBuffer aQuery=new StringBuffer();
		boolean queryStatus=false;
		String conditions[][]=TaskMaster_ACT.getAllConditions(conditionKey);
		if(conditions!=null&&conditions.length>0) {
			for(int i=0;i<conditions.length;i++) {
				switch (conditions[i][0]) {
				
				case "Status":aQuery=getMilestoneStatusQuery(conditions[i][1],conditions[i][2]);
					if(aQuery.toString()!=null&&!aQuery.toString().equalsIgnoreCase("NA")) {
						query.append(aQuery);
						queryStatus=true;
					}
					break;
					
				case "Priority":aQuery=getMilestonePriorityQuery(conditions[i][1],conditions[i][2]);
					if(aQuery.toString()!=null&&!aQuery.toString().equalsIgnoreCase("NA")) {
						if(queryStatus)query.append(" and "+aQuery);
						else query.append(aQuery);
						queryStatus=true;
					}
					break;
				
				case "Due date":aQuery=getMilestoneDueDateQuery(conditions[i][1],conditions[i][2]);
					if(aQuery.toString()!=null&&!aQuery.toString().equalsIgnoreCase("NA")) {
						if(queryStatus)query.append(" and "+aQuery);
						else query.append(aQuery);
						queryStatus=true;
					}
					break;
					
				case "Group":aQuery=getMilestoneGroupQuery(conditions[i][1],conditions[i][2],token);
					if(aQuery.toString()!=null&&!aQuery.toString().equalsIgnoreCase("NA")) {
						if(queryStatus)query.append(" and "+aQuery);
						else query.append(aQuery);
						queryStatus=true;
					}
					break;
					
				case "Assignee":aQuery=getMilestoneAssigneeQuery(conditions[i][1],conditions[i][2]);
					if(aQuery.toString()!=null&&!aQuery.toString().equalsIgnoreCase("NA")) {
						if(queryStatus)query.append(" and "+aQuery);
						else query.append(aQuery);
						queryStatus=true;
					}
					break;
					
				case "Project":aQuery=getMilestoneProjectQuery(conditions[i][1],conditions[i][2]);
					if(aQuery.toString()!=null&&!aQuery.toString().equalsIgnoreCase("NA")) {
						if(queryStatus)query.append(" and "+aQuery);
						else query.append(aQuery);
						queryStatus=true;
					}
					break;

				default:
					break;
				}
			}
		}
//		System.out.println("milestoneTrigger : "+query);
		return query;
	}
	
	public static StringBuffer milestoneActionTrigger(String actionKey,String token,String mquery,String today,String addedby) throws ParseException {
		StringBuffer query=new StringBuffer();
		boolean queryStatus=false;
		String actions[][]=TaskMaster_ACT.getAllActions(actionKey);
		if(actions!=null&&actions.length>0) {
			//getting all data according query
			String milestone[][]=TaskMaster_ACT.getTriggerConditionsData(mquery);
			for(int i=0;i<actions.length;i++) {
				switch (actions[i][0]) {
				
				case "Status":query.append(" maworkstatus='"+actions[i][1]+"'");
						if(milestone!=null&&milestone.length>0) {
							for(int j=0;j<milestone.length;j++) {
								//apply work duration
								String salesrefId=milestone[j][2];
								String marefid=milestone[j][1];
								String assigneeUId=milestone[j][4];
								String milestoneKey=TaskMaster_ACT.getAssignedMilestoneKey(marefid, token);
								String dateTime[]=TaskMaster_ACT.getTaskDateTime(salesrefId,milestoneKey,token);
								if(dateTime[0]!=null&&dateTime[1]!=null&&!dateTime[0].equalsIgnoreCase("NA")&&
										!dateTime[1].equalsIgnoreCase("NA")) {
									//getting total hours and minutes till now status change
									long hourMinutes[]=CommonHelper.calculateHours(dateTime[0],dateTime[1]);
									String column_hh="NA";
									String column_mm="NA";
									if(dateTime[2].equalsIgnoreCase("New")) {
										column_hh="task_new_hh";
										column_mm="task_new_mm";
									}else if(dateTime[2].equalsIgnoreCase("Open")) {
										column_hh="task_open_hh";
										column_mm="task_open_mm";
									}else if(dateTime[2].equalsIgnoreCase("On-hold")) {
										column_hh="task_hold_hh";
										column_mm="task_hold_mm";
									}else if(dateTime[2].equalsIgnoreCase("Pending")) {
										column_hh="task_pending_hh";
										column_mm="task_pending_mm";
									}else if(dateTime[2].equalsIgnoreCase("Expired")) {
										column_hh="task_expired_hh";
										column_mm="task_expired_mm";
									}
									
									long hhmm[]=TaskMaster_ACT.getTaskHHMM(column_hh,column_mm,marefid,salesrefId,assigneeUId,token);
									
									if(!column_hh.equals("NA")&&!column_mm.equals("NA")) {
										long hours=hourMinutes[1]+hhmm[0];
										long minutes=hourMinutes[0]+hhmm[1];
										
										if(minutes>60) {
											long hour=(minutes/60);
											hours+=hour;
											minutes=(minutes-(hour*60));
										}
										
										TaskMaster_ACT.updateTaskProgress(column_hh,column_mm,hours,minutes,marefid,salesrefId,assigneeUId,token);
									}
								}
								setMilestoneStatusActionHistory(milestone[j][1],milestone[j][2],actions[i][1],today,token,addedby);
							}
						}					
					 queryStatus=true;
					break;
					
				case "Priority":if(queryStatus)query.append(",maworkpriority='"+actions[i][1]+"'");
						else query.append(" maworkpriority='"+actions[i][1]+"'");
						if(milestone!=null&&milestone.length>0) {
							for(int j=0;j<milestone.length;j++) {								
								setMilestonePriorityActionHistory(milestone[j][1],milestone[j][2],actions[i][1],today,"NA",token,addedby);
							}
						}				
						queryStatus=true;					
					break;
					
				case "Assignee":if(actions[i][1].equalsIgnoreCase("Team leader")) {
							if(queryStatus)query.append(",mateammemberid=(select mtadminid from manageteamctrl where mtrefid=maparentteamrefid)");
							else query.append(" mateammemberid=(select mtadminid from manageteamctrl where mtrefid=maparentteamrefid)");
						}else if(actions[i][1].equalsIgnoreCase("Delivery manager")) {
							String managerUid=Usermaster_ACT.getDeliveryManagerUid(token);
							if(queryStatus)query.append(",mateammemberid='"+managerUid+"'");
							else query.append(" mateammemberid='"+managerUid+"'");
						}		
						if(milestone!=null&&milestone.length>0) {
							for(int j=0;j<milestone.length;j++) {								
								setMilestoneAssigneeActionHistory(milestone[j][1],milestone[j][2],actions[i][1],today,token,addedby);
							}
						}				
						queryStatus=true;
						break;
					
				case "Email":					
					  if(milestone!=null&&milestone.length>0) { 
						  for(int j=0;j<milestone.length;j++){ 
							  String contactKey=Enquiry_ACT.getSalesContactKey(milestone[j][2],token);
							  String contacts[][]=TaskMaster_ACT.getAllSalesContacts(contactKey,token);
							  String newMessage="NA";
							  if(actions[i][1].equalsIgnoreCase("requester and cc")) {
								  if(contacts!=null&&contacts.length>0) {									  
								 	for(int k=0;k<contacts.length;k++) {
								 		if(k==0)
								 		newMessage=replacePlaceholder(actions[i][3],contacts,milestone[j][4],milestone[j][3],milestone[j][1],milestone[j][2],token);
								 		if(newMessage!=null&&newMessage.length()>0&&!newMessage.equals("NA")) {
								 			Enquiry_ACT.saveEmail(contacts[k][1],"empty",actions[i][2], newMessage,2,token);
								 		}
								 	}
								  }
							  }else if(actions[i][1].equalsIgnoreCase("requester")) {
								  if(contacts!=null&&contacts.length>0) {
									  newMessage=replacePlaceholder(actions[i][3],contacts,milestone[j][4],milestone[j][3],milestone[j][1],milestone[j][2],token);
									  if(newMessage!=null&&newMessage.length()>0&&!newMessage.equals("NA")) {
//										  System.out.println("sending email to--"+contacts[0][1]+"\nsubject--"+actions[i][2]+"\nMessage="+newMessage);
										  Enquiry_ACT.saveEmail(contacts[0][1],"empty",actions[i][2], newMessage,2,token);
									  }
								  }
							  }else if(actions[i][1].equalsIgnoreCase("assignee")) {
								  String assigneEmail=Usermaster_ACT.getUserEmail(milestone[j][4],token);
								  if(!assigneEmail.equalsIgnoreCase("NA")) {									  
									  newMessage=replacePlaceholder(actions[i][3],contacts,milestone[j][4],milestone[j][3],milestone[j][1],milestone[j][2],token);
//									  System.out.println("After replace=="+newMessage);
									  if(newMessage!=null&&newMessage.length()>0&&!newMessage.equals("NA")) {
										  Enquiry_ACT.saveEmail(assigneEmail,"empty",actions[i][2], newMessage,2,token);
									  }
								  }
							  }else if(actions[i][1].equalsIgnoreCase("assignee manager")) {
								  String teamLeader=TaskMaster_ACT.getTeamLeaderId(milestone[j][3], token);
								  String teamLeaderEmail=Usermaster_ACT.getUserEmail(teamLeader,token);
								  if(!teamLeaderEmail.equalsIgnoreCase("NA")) {
									  newMessage=replacePlaceholder(actions[i][3],contacts,milestone[j][4],milestone[j][3],milestone[j][1],milestone[j][2],token);
									  if(newMessage!=null&&newMessage.length()>0&&!newMessage.equals("NA")) {
										  Enquiry_ACT.saveEmail(teamLeaderEmail,"empty",actions[i][2], newMessage,2,token);
									  }
								  }
							  }
							  }}					 
						break;
			
				case "Sms":					
					  if(milestone!=null&&milestone.length>0) { 
						  for(int j=0;j<milestone.length;j++){ 
							  String contactKey=Enquiry_ACT.getSalesContactKey(milestone[j][2],token);
							  String contacts[][]=TaskMaster_ACT.getAllSalesContacts(contactKey,token);
							  String newMessage="NA";
							  if(actions[i][1].equalsIgnoreCase("requester and cc")) {
								  if(contacts!=null&&contacts.length>0) {									  
								 	for(int k=0;k<contacts.length;k++) {
								 		if(k==0)
								 		newMessage=replacePlaceholder(actions[i][3],contacts,milestone[j][4],milestone[j][3],milestone[j][1],milestone[j][2],token);
								 		if(newMessage!=null&&newMessage.length()>0&&!newMessage.equals("NA")) {
								 			sendSms(contacts[k][2],newMessage);
								 		}
								 	}
								  }
							  }else if(actions[i][1].equalsIgnoreCase("requester")) {
								  if(contacts!=null&&contacts.length>0) {
									  newMessage=replacePlaceholder(actions[i][3],contacts,milestone[j][4],milestone[j][3],milestone[j][1],milestone[j][2],token);
									  if(newMessage!=null&&newMessage.length()>0&&!newMessage.equals("NA")) {
										  sendSms(contacts[0][2],newMessage);
									  }
								  }
							  }else if(actions[i][1].equalsIgnoreCase("assignee")) {
								  String assigneMobile=Usermaster_ACT.getUserMobile(milestone[j][4],token);
								  if(!assigneMobile.equalsIgnoreCase("NA")) {
//									  System.out.println("actions[i][3]="+actions[i][3]);
									  newMessage=replacePlaceholder(actions[i][3],contacts,milestone[j][4],milestone[j][3],milestone[j][1],milestone[j][2],token);
									  if(newMessage!=null&&newMessage.length()>0&&!newMessage.equals("NA")) {
										  sendSms(assigneMobile,newMessage);
									  }
								  }
							  }else if(actions[i][1].equalsIgnoreCase("assignee manager")) {
								  String teamLeader=TaskMaster_ACT.getTeamLeaderId(milestone[j][3], token);
								  String teamLeaderMobile=Usermaster_ACT.getUserMobile(teamLeader,token);
								  if(!teamLeaderMobile.equalsIgnoreCase("NA")) {
									  newMessage=replacePlaceholder(actions[i][3],contacts,milestone[j][4],milestone[j][3],milestone[j][1],milestone[j][2],token);
									  if(newMessage!=null&&newMessage.length()>0&&!newMessage.equals("NA")) {
										  sendSms(teamLeaderMobile,newMessage);
									  }
								  }
							  }
							  }}					 
						break;

				default:query=new StringBuffer("NA");
					break;
				}
			}
		}
//		System.out.println("deliveryActionTrigger : "+query);
		return query;
	}
	
	private static void sendSms(String mobile, String newMessage) {
		// TODO Auto-generated method stub
//		System.out.println("Sending sms on mobile=="+mobile+"\nMessage=="+newMessage);
	}

	public static String replacePlaceholder(String message,String[][] contacts,String uaid,String teamKey,String marefid,String salesKey,String token) {
		String summary=message;
		String assignee[][]=null;
		String milestone[]=null;
//		System.out.println("uaid=="+uaid);
		if(!uaid.equals("NA")) {
			assignee=Usermaster_ACT.getUserByID(uaid);
		}		
		
		String teamLeader=TaskMaster_ACT.getTeamLeaderId(teamKey, token);
		String manager[][]=Usermaster_ACT.getUserByID(teamLeader);
		
		String teamName=TaskMaster_ACT.getTeamName(teamKey, token);
		
		String salesData[][]=Enquiry_ACT.getSalesByRefId(salesKey, token);
//		System.out.println("Sales Key========"+salesKey);
		if(!marefid.equals("NA")) {
			milestone=TaskMaster_ACT.getAssignedMilestoneData(marefid, token);
		}		
//		System.out.println("11=="+summary);
		if(summary.contains("{{requester.name}}")) {
			String contactName="NAN";
			if(contacts!=null&&contacts.length>0)contactName=contacts[0][0];
			summary=summary.replace("{{requester.name}}", contactName);
		}
		if(summary.contains("{{requester.email}}")) {
			String contactEmail="NAN";
			if(contacts!=null&&contacts.length>0)contactEmail=contacts[0][1];
			summary=summary.replace("{{requester.email}}", contactEmail);
		}
		if(summary.contains("{{requester.mobile}}")) {
			String contactMobile="NAN";
			if(contacts!=null&&contacts.length>0)contactMobile=contacts[0][2];
			summary=summary.replace("{{requester.mobile}}", contactMobile);
		}
		if(summary.contains("{{assignee.name}}")) {
//			System.out.println(summary);
			String assigneeName="NAN";
			if(assignee!=null&&assignee.length>0)assigneeName=assignee[0][5];
//			System.out.println("assigneeName="+assigneeName);
			summary=summary.replace("{{assignee.name}}", assigneeName);
//			System.out.println(summary+"\n"+assigneeName);
		}
		if(summary.contains("{{assignee.email}}")) {
			String assigneeEmail="NAN";
			if(assignee!=null&&assignee.length>0)assigneeEmail=assignee[0][7];
			summary=summary.replace("{{assignee.email}}", assigneeEmail);
		}
		if(summary.contains("{{assignee.mobile}}")) {
			String assigneeMobile="NAN";
			if(assignee!=null&&assignee.length>0)assigneeMobile=assignee[0][6];
			summary=summary.replace("{{assignee.mobile}}", assigneeMobile);
		}
		if(summary.contains("{{assignee.manager.name}}")) {
			String managerName="NAN";
			if(manager!=null&&manager.length>0)managerName=manager[0][5];
			summary=summary.replace("{{assignee.manager.name}}", managerName);
		}
		if(summary.contains("{{assignee.manager.email}}")) {
			String managerEmail="NAN";
			if(manager!=null&&manager.length>0)managerEmail=manager[0][7];
			summary=summary.replace("{{assignee.manager.email}}", managerEmail);
		}
		if(summary.contains("{{assignee.manager.mobile}}")) {
			String managerMobile="NAN";
			if(manager!=null&&manager.length>0)managerMobile=manager[0][6];
			summary=summary.replace("{{assignee.manager.mobile}}", managerMobile);
		}		
		if(summary.contains("{{team.name}}")) {
			String teamName1="NAN";
			if(teamName!=null&&teamName.length()>0)teamName1=teamName;
			summary=summary.replace("{{team.name}}", teamName1);
		}
		if(!salesKey.equals("NA")&&summary.contains("{{company.name}}")) {
			String companyName="NAN";
			if(salesData!=null&&salesData.length>0)companyName=salesData[0][5];
//			System.out.println(companyName+"===========");
			summary=summary.replace("{{company.name}}", companyName);
		}
		if(!salesKey.equals("NA")&&summary.contains("{{project.name}}")) {
			String projectName="NAN";
			if(salesData!=null&&salesData.length>0)projectName=salesData[0][7];
			summary=summary.replace("{{project.name}}", projectName);
		}
		if(!salesKey.equals("NA")&&summary.contains("{{project.number}}")) {
			String projectNo="NAN";
			if(salesData!=null&&salesData.length>0)projectNo=salesData[0][16];
			summary=summary.replace("{{project.number}}", projectNo);
		}
		if(!salesKey.equals("NA")&&summary.contains("{{project.invoice}}")) {
			String projectInvoice="NAN";
			if(salesData!=null&&salesData.length>0)projectInvoice=salesData[0][3];
			summary=summary.replace("{{project.invoice}}", projectInvoice);
		}
		if(summary.contains("{{milestone.name}}")) {
			String milestoneName="NAN";
			if(milestone!=null&&milestone[0]!=null)milestoneName=milestone[0];
			summary=summary.replace("{{milestone.name}}", milestoneName);
		}
		if(summary.contains("{{milestone.start-date}}")) {
			String milestoneDate="NAN";
			if(milestone!=null&&milestone[1]!=null)milestoneDate=milestone[1];
			summary=summary.replace("{{milestone.start-date}}", milestoneDate);
		}
		if(summary.contains("{{milestone.completed}}")) {
			String milestoneWork="NAN";
			if(milestone!=null&&milestone[2]!=null)milestoneWork=milestone[2];
			summary=summary.replace("{{milestone.completed}}", milestoneWork+"%");
		}
		
		return summary;
	}
	
	public static boolean setMilestoneAssigneeActionHistory(String assignKey,String salesKey,String assignTo,String today,String token,String addedby) {
		boolean flag=false;	
		String memberId="NA";
		boolean assignstatus=false;
		String teamKey=TaskMaster_ACT.getTeamKeyByTaskKey(assignKey,token);
		if(assignTo.equalsIgnoreCase("Team leader")) {
			memberId=TaskMaster_ACT.getTeamLeaderId(teamKey, token);
			assignstatus=true;
		}else if(assignTo.equalsIgnoreCase("Delivery manager")) {
			memberId=Usermaster_ACT.getDeliveryManagerUid(token);
			flag=TaskMaster_ACT.isUserTeamMember(memberId,teamKey,token);
			if(flag)assignstatus=true;
			else assignstatus=false;
		}
		if(assignstatus&&!memberId.equalsIgnoreCase("NA")) {
			//getting assigned member uid to check already assigned or not
			String oldUserId=TaskMaster_ACT.isTaskAlreadyAssigned(assignKey,token);
			if(!oldUserId.equalsIgnoreCase(memberId)){
			
			String assignedMemberId=TaskMaster_ACT.getAssignedMemberId(assignKey,token);
			//getting all assigned milestone data
			String milestoneData[][]=TaskMaster_ACT.getAssignedSalesMilestone(assignKey, token);
			
			flag=TaskMaster_ACT.assignThisMilestone(assignKey,memberId,today,"New",token);
			
			if(flag){								
				//add data in milestone action history
				if(flag&&milestoneData!=null&&milestoneData.length>0){				
						String prevParentTeamKey="NA";
						String prevChildTeamKey="NA";
						String prevTeamMemberUid="NA";
						String prevWorkStatus="NA";
						String pervWorkPriority="NA";						
						String userPost=assignTo;
						String prevUserPost="NA";
											
						String prevCurrMilestoneData[]=TaskMaster_ACT.getPrevCurrMilestoneDataByKey(assignKey,token);
						if(prevCurrMilestoneData[0]!=null) {
							if(prevCurrMilestoneData[1].equalsIgnoreCase(milestoneData[0][13]))prevParentTeamKey=prevCurrMilestoneData[0];
							else prevParentTeamKey=prevCurrMilestoneData[1];
							
							if(prevCurrMilestoneData[3].equalsIgnoreCase(milestoneData[0][6]))prevChildTeamKey=prevCurrMilestoneData[2];
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
							int stepNo=TaskMaster_ACT.getMilestoneStep(salesKey, milestoneData[0][0], token);
							String deliveryData[]=TaskMaster_ACT.getMilestoneDeliveryDate(salesKey,today, milestoneData[0][0],stepNo,token);
							String deliveryDate="NA";
							String deliveryTime="NA";
							if(deliveryData[0]!=null)deliveryDate=deliveryData[0];
							if(deliveryData[1]!=null)deliveryTime=deliveryData[1];
							
							flag=TaskMaster_ACT.saveMilestoneActionHistory(mKey,milestoneData[0][5],salesKey,salesName,prevParentTeamKey,milestoneData[0][13],prevChildTeamKey,milestoneData[0][6],prevTeamMemberUid,memberId,prevWorkStatus,"New",pervWorkPriority,milestoneData[0][12],deliveryDate,today,token,prevUserPost,userPost,deliveryTime);
						}
				}
				
				String salesStatus="NA";
				//checking task all status ok and assigned
				boolean allOk=TaskMaster_ACT.isTaskStatusOk(assignKey,token);
				if(allOk){
					String invoice=TaskMaster_ACT.getSalesInvoiceNumber(salesKey, token);
					//set milestone start date
					boolean existFlag=TaskMaster_ACT.isDisperseExist(salesKey, token); 
					double avlPrice=TaskMaster_ACT.getMainDispersedAmount(salesKey, token);
					double orderAmt=TaskMaster_ACT.getSalesAmount(salesKey, token);
					double percentage=TaskMaster_ACT.getWorkStartPercentage(assignKey,token);
					double workPrice=(orderAmt*percentage)/100;
					if(avlPrice>=workPrice&&existFlag){
						String deliveryData[]=TaskMaster_ACT.getTaskDeliveryDate(salesKey, today, milestoneData[0][0],token);
						String deliveryDate="NA";
						String deliveryTime="NA";
						if(deliveryData[0]!=null)deliveryDate=deliveryData[0];
						if(deliveryData[1]!=null)deliveryTime=deliveryData[1];
						String date=DateUtil.getCurrentDateIndianReverseFormat();
						String startTime=DateUtil.getCurrentTime24Hours();
						TaskMaster_ACT.updateTaskWorkStartedDate(assignKey,today,token,startTime,deliveryDate,deliveryTime,date);
//						System.out.println("Work started (AssignThisToAssignee)");
						salesStatus="3";
					}else {
						salesStatus="1";
						TaskMaster_ACT.updateTaskProgressStatus(assignKey,"1",token);
					}
				}
				if(!salesStatus.equalsIgnoreCase("NA"))	
					TaskMaster_ACT.updateProjectStatus(salesKey,salesStatus,token);
				//getting team name
				String teamName=TaskMaster_ACT.getTeamName(teamKey,token);

				//getting current time
				String Time=DateUtil.getCurrentTime();
				
				//getting sales name,project no and invoice no
				String salesData[]=TaskMaster_ACT.getSalesData(salesKey,token);
				
				//getting primary contact data
				String contactData[]=Enquiry_ACT.getClientContactByKey(salesData[3], token);
				
				String memberName=Usermaster_ACT.getLoginUserName(memberId, token);
				//add chat thread
				String taskKey=RandomStringUtils.random(40,true,true);				
				String subject="Milestone Assigned";
				String assStatus="assigned";
				if(assignedMemberId!=null&&assignedMemberId!=""&&!assignedMemberId.equalsIgnoreCase("NA")) {
					subject="Milestone Re-assigned";
					assStatus="Re-assigned";
				}
				String milestoneName=TaskMaster_ACT.getAssignedMilestoneName(assignKey,token);
				String content="<span style='color: #4ac4f3;font-weight: 600;'>'"+milestoneName+"</span> "+assStatus+" to <span style='color: #4ac4f3;font-weight: 600;'>'"+memberName+"'</span> of Team <span style='color: #4ac4f3;font-weight: 600;'>'"+teamName+"</span> on <span style='color: #4ac4f3;font-weight: 600;'>"+today+" "+Time+"</span> by <span style='color: #4ac4f3;font-weight: 600;'>'Trigger'</span>";
				//set notification task assigned to team leader	
				flag=TaskMaster_ACT.setTaskNotification(taskKey,salesKey,salesData[0],salesData[1],salesData[2],"Notification","bell.png",contactData[0],contactData[1],contactData[2],"NA","NA",today+" "+Time,subject,content,addedby,token,"NA","NA","NA","New","NA");
			}		
		}	
		}
		return flag;
	}
	
	public static boolean setMilestonePriorityActionHistory(String milestoneTaskKey,String salesrefid,String Priority,String today,String loginuaid,String token,String addedby) {
		boolean flag=false;	
		//getting all assigned milestone data
		String milestoneData[][]=TaskMaster_ACT.getSalesMilestoneByKey(milestoneTaskKey, salesrefid, token);
		
		//updating assigned sales milestones's priority
		flag=TaskMaster_ACT.updateMilestonePriorityByKey(milestoneTaskKey,salesrefid,Priority,token);
		
		//adding milestone action history for trigger
		if(flag&&milestoneData!=null&&milestoneData.length>0){
				String prevParentTeamKey="NA";
				String prevChildTeamKey="NA";
				String prevTeamMemberUid="NA";
				String prevWorkStatus="NA";
				String pervWorkPriority="NA";
				String userPost="NA";
				String prevUserPost="NA";
				if(!milestoneData[0][2].equalsIgnoreCase("NA")) {
					userPost=Usermaster_ACT.getUserPost(milestoneData[0][2],token);
					if(!userPost.equalsIgnoreCase("Delivery manager")) {
						String teamLeaderUid=TaskMaster_ACT.getTeamLeaderId(milestoneData[0][13], token);
						if(milestoneData[0][2].equalsIgnoreCase(teamLeaderUid)&&!teamLeaderUid.equalsIgnoreCase("NA"))userPost="Team Leader";
					}
				}
				
				String prevCurrMilestoneData[]=TaskMaster_ACT.getPrevCurrMilestoneData(salesrefid,token);
				if(prevCurrMilestoneData[0]!=null) {
					if(prevCurrMilestoneData[1].equalsIgnoreCase(milestoneData[0][13]))prevParentTeamKey=prevCurrMilestoneData[0];
					else prevParentTeamKey=prevCurrMilestoneData[1];
					
					if(prevCurrMilestoneData[3].equalsIgnoreCase(milestoneData[0][6]))prevChildTeamKey=prevCurrMilestoneData[2];
					else prevChildTeamKey=prevCurrMilestoneData[3];
					
					if(prevCurrMilestoneData[5].equalsIgnoreCase(milestoneData[0][2]))prevTeamMemberUid=prevCurrMilestoneData[4];
					else prevTeamMemberUid=prevCurrMilestoneData[5];
					
					if(prevCurrMilestoneData[7].equalsIgnoreCase(milestoneData[0][9]))prevWorkStatus=prevCurrMilestoneData[6];
					else prevWorkStatus=prevCurrMilestoneData[7];
					
					if(prevCurrMilestoneData[9].equalsIgnoreCase(Priority))pervWorkPriority=prevCurrMilestoneData[8];
					else pervWorkPriority=prevCurrMilestoneData[9];
					
					if(prevCurrMilestoneData[11].equalsIgnoreCase(userPost))prevUserPost=prevCurrMilestoneData[10];
					else prevUserPost=prevCurrMilestoneData[11];
					
					String workStartedDate=milestoneData[0][4];	
					if(!milestoneData[0][11].equalsIgnoreCase("00-00-0000"))workStartedDate=milestoneData[0][11];	
					String mKey=RandomStringUtils.random(40,true,true);
					String salesName=Enquiry_ACT.getSalesProductName(salesrefid, token);
					int stepNo=TaskMaster_ACT.getMilestoneStep(salesrefid, milestoneData[0][0], token);
					String deliveryData[]=TaskMaster_ACT.getMilestoneDeliveryDate(salesrefid,workStartedDate, milestoneData[0][0],stepNo,token);
					String deliveryDate="NA";
					String deliveryTime="NA";
					if(deliveryData[0]!=null)deliveryDate=deliveryData[0];
					if(deliveryData[1]!=null)deliveryTime=deliveryData[1];
					flag=TaskMaster_ACT.saveMilestoneActionHistory(mKey,milestoneData[0][5],salesrefid,salesName,prevParentTeamKey,milestoneData[0][13],prevChildTeamKey,milestoneData[0][6],prevTeamMemberUid,milestoneData[0][2],prevWorkStatus,milestoneData[0][9],pervWorkPriority,Priority,deliveryDate,today,token,prevUserPost,userPost,deliveryTime);
				}
		}
		
		return flag;
	}
	
	public static boolean setMilestoneStatusActionHistory(String milestoneTaskKey,String salesrefId,String submitStatus,String today,String uavalidtokenno,String addedby) {
		boolean flag=false;	
		String milestoneKey=TaskMaster_ACT.getAssignedMilestoneKey(milestoneTaskKey,uavalidtokenno);
		//getting all assigned milestone data
		String milestone[][]=TaskMaster_ACT.getAssignedSalesMilestone(salesrefId,milestoneKey,uavalidtokenno);
		
		//add data in milestone action history
		if(milestone!=null&&milestone.length>0){				
			String prevParentTeamKey="NA";
			String prevChildTeamKey="NA";
			String prevTeamMemberUid="NA";
			String prevWorkStatus="NA";
			String pervWorkPriority="NA";
			String userPost="NA";
			String prevUserPost="NA";
			if(!milestone[0][2].equalsIgnoreCase("NA")) {
				userPost=Usermaster_ACT.getUserPost(milestone[0][2],uavalidtokenno);
				if(!userPost.equalsIgnoreCase("Delivery manager")) {
					String teamLeaderUid=TaskMaster_ACT.getTeamLeaderId(milestone[0][13], uavalidtokenno);
					if(milestone[0][2].equalsIgnoreCase(teamLeaderUid)&&!teamLeaderUid.equalsIgnoreCase("NA"))userPost="Team Leader";
				}
			}					
			
			String prevCurrMilestoneData[]=TaskMaster_ACT.getPrevCurrMilestoneDataByKey(milestone[0][5],uavalidtokenno);
			if(prevCurrMilestoneData[0]!=null) {
				if(prevCurrMilestoneData[1].equalsIgnoreCase(milestone[0][13]))prevParentTeamKey=prevCurrMilestoneData[0];
				else prevParentTeamKey=prevCurrMilestoneData[1];
				
				if(prevCurrMilestoneData[3].equalsIgnoreCase(milestone[0][6]))prevChildTeamKey=prevCurrMilestoneData[2];
				else prevChildTeamKey=prevCurrMilestoneData[3];
				
				if(prevCurrMilestoneData[5].equalsIgnoreCase(milestone[0][2]))prevTeamMemberUid=prevCurrMilestoneData[4];
				else prevTeamMemberUid=prevCurrMilestoneData[5];
				
				if(prevCurrMilestoneData[7].equalsIgnoreCase(submitStatus))prevWorkStatus=prevCurrMilestoneData[6];
				else prevWorkStatus=prevCurrMilestoneData[7];
				
				if(prevCurrMilestoneData[9].equalsIgnoreCase(milestone[0][12]))pervWorkPriority=prevCurrMilestoneData[8];
				else pervWorkPriority=prevCurrMilestoneData[9];
				
				if(prevCurrMilestoneData[11].equalsIgnoreCase(userPost))prevUserPost=prevCurrMilestoneData[10];
				else prevUserPost=prevCurrMilestoneData[11];
									
				String mKey=RandomStringUtils.random(40,true,true);
				String salesName=Enquiry_ACT.getSalesProductName(salesrefId, uavalidtokenno);
				int stepNo=TaskMaster_ACT.getMilestoneStep(salesrefId, milestone[0][0], uavalidtokenno);
				String mDeliveryData[]=TaskMaster_ACT.getMilestoneDeliveryDate(salesrefId,milestone[0][11], milestone[0][0],stepNo,uavalidtokenno);
				String mDeliveryDate="NA";
				String mDeliveryTime="NA";
				if(mDeliveryData[0]!=null)mDeliveryDate=mDeliveryData[0];
				if(mDeliveryData[1]!=null)mDeliveryTime=mDeliveryData[1];
				
				flag=TaskMaster_ACT.saveMilestoneActionHistory(mKey,milestone[0][5],salesrefId,salesName,prevParentTeamKey,milestone[0][13],prevChildTeamKey,milestone[0][6],prevTeamMemberUid,milestone[0][2],prevWorkStatus,submitStatus,pervWorkPriority,milestone[0][12],mDeliveryDate,today,uavalidtokenno,prevUserPost,userPost,mDeliveryTime);
			}
		}
		
		return flag;
	}
	
	public static boolean setDeliveryStatusActionHistory(String salesKey,String salesStatus,String today,String token,String addedby) {
		boolean flag=false;		
		//getting sales data before update work status
		String salesData[][]=Enquiry_ACT.getSalesByRefId(salesKey, token);
		//update status in manage sales
		flag=TaskMaster_ACT.updateSalesActiveStatus(salesKey,salesStatus,token);
		
		String dhKey=RandomStringUtils.random(40,true,true);				
		if(salesData!=null&&salesData.length>0) {
			int totalDay=0;
			int minutes=0;
			int data[]=TaskMaster_ACT.getTotalMilestoneDays(salesKey, token);
			totalDay=data[0];
			minutes=data[1];
			
			String deliveryData[]=DateUtil.getLastDate(salesData[0][12], totalDay,minutes);
			String deliveryDate="NA";
			String deliveryTime="NA";
			if(deliveryData[0]!=null)deliveryDate=deliveryData[0];
			if(deliveryData[1]!=null)deliveryTime=deliveryData[1];
			
			String prevCurrentData[]=TaskMaster_ACT.getPreviousCurrentData(salesKey,token);
			String prevStatus="NA";
			if(prevCurrentData[1]!=null&&prevCurrentData[1].equalsIgnoreCase(salesStatus))prevStatus=prevCurrentData[0];
			else if(prevCurrentData[1]!=null) prevStatus=prevCurrentData[1];
			String prevTeamKey="NA";
			if(prevCurrentData[3]!=null&&prevCurrentData[3].equalsIgnoreCase(salesData[0][14]))prevTeamKey=prevCurrentData[2];
			else if(prevCurrentData[3]!=null) prevTeamKey=prevCurrentData[3];
			String prevPriority="NA";
			if(prevCurrentData[5]!=null&&prevCurrentData[5].equalsIgnoreCase(salesData[0][15]))prevPriority=prevCurrentData[4];
			else if(prevCurrentData[5]!=null) prevPriority=prevCurrentData[5];
			//adding data in delivery action history for triggers
			flag=TaskMaster_ACT.saveDeliveryActionHistory(dhKey, salesKey, deliveryDate, prevStatus, salesStatus, prevTeamKey, salesData[0][14],prevPriority, salesData[0][15], today, token, "trigger",deliveryTime);
		}
		
		if(salesStatus.equalsIgnoreCase("Active")&&flag) {
		//on active sale disperse amount if available
		//checking on this sale already amount dispersed or not? If not then disperse only
		boolean isDisparsed=TaskMaster_ACT.isAmountDispersed(salesKey,token);
//		System.out.println("isDisparsed="+isDisparsed);
		if(!isDisparsed) {
			//checking it have parent or not
			String parentKey=TaskMaster_ACT.getParentKey(salesKey,token);
//			System.out.println("parentKey="+parentKey);
			String invoiceNo=TaskMaster_ACT.getSalesInvoiceNumber(salesKey, token);
//			System.out.println("invoiceNo="+invoiceNo);
			if(parentKey!=null&&!parentKey.equalsIgnoreCase("NA")) {
				//checking parent's work 100% completed
				boolean workCompleted=TaskMaster_ACT.isProjectCompleted(parentKey,token);
//				System.out.println("workCompleted="+workCompleted);
				if(workCompleted) {		
//					System.out.println("if--going to disperse amount");
					TaskMaster_ACT.disperseAmount(salesKey, invoiceNo, today, token, addedby,"autogenerated");
//					System.out.println("dispersed");
				}
			}else {
//				System.out.println("else--going to disperse amount");
				TaskMaster_ACT.disperseAmount(salesKey, invoiceNo, today, token, addedby,"autogenerated");
//				System.out.println("dispersed");
			}
		}
		//update all assigned milestone's of this project active status
		TaskMaster_ACT.updateAssignTaskHierarchyActiveStatus(salesKey,"1",token);
		}else if(salesStatus.equalsIgnoreCase("Inactive")&&flag) {
			//update all assigned milestone's of this project deactive status
			TaskMaster_ACT.updateAssignTaskHierarchyActiveStatus(salesKey,"2",token);
		}
		
		return flag;
	}
	
	public static boolean setDeliveryPriorityActionHistory(String salesrefid,String Priority,String today,String token,String addedby) {
		boolean flag=false;		
		
		//getting sales data before update work status
		String salesData[][]=Enquiry_ACT.getSalesByRefId(salesrefid, token);
		//getting all assigned milestone data
		String milestoneData[][]=TaskMaster_ACT.getAllSalesMilestone("NA", salesrefid, token);
		//updating sales table
		flag=TaskMaster_ACT.updateSalesPriority(salesrefid,Priority,token);
		//updating assigned sales milestones's priority
		flag=TaskMaster_ACT.updateMilestonePriority(salesrefid,Priority,token);
		//adding delivery action for trigger
		String dhKey=RandomStringUtils.random(40,true,true);				
		if(salesData!=null&&salesData.length>0) {
			int totalDay=0;
			int minutes=0;
			int data[]=TaskMaster_ACT.getTotalMilestoneDays(salesrefid, token);
			totalDay=data[0];
			minutes=data[1];
			
			String deliveryData[]=DateUtil.getLastDate(salesData[0][12], totalDay,minutes);
			String deliveryDate="NA";
			String deliveryTime="NA";
			if(deliveryData[0]!=null)deliveryDate=deliveryData[0];
			if(deliveryData[1]!=null)deliveryTime=deliveryData[1];
			
			String prevCurrentData[]=TaskMaster_ACT.getPreviousCurrentData(salesrefid,token);
			String prevStatus="NA";
			if(prevCurrentData[1].equalsIgnoreCase(salesData[0][13]))prevStatus=prevCurrentData[0];
			else prevStatus=prevCurrentData[1];
			String prevTeamKey="NA";
			if(prevCurrentData[3].equalsIgnoreCase(salesData[0][14]))prevTeamKey=prevCurrentData[2];
			else prevTeamKey=prevCurrentData[3];
			String prevPriority="NA";
			if(prevCurrentData[5].equalsIgnoreCase(Priority))prevPriority=prevCurrentData[4];
			else prevPriority=prevCurrentData[5];
			//adding data in delivery action history for triggers
			flag=TaskMaster_ACT.saveDeliveryActionHistory(dhKey, salesrefid, deliveryDate, prevStatus, salesData[0][13], prevTeamKey, salesData[0][14], prevPriority, Priority, today, token, "trigger",deliveryTime);
		}
		//adding milestone action history for trigger
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
					if(prevCurrMilestoneData[1].equalsIgnoreCase(milestoneData[i][13]))prevParentTeamKey=prevCurrMilestoneData[0];
					else prevParentTeamKey=prevCurrMilestoneData[1];
					
					if(prevCurrMilestoneData[3].equalsIgnoreCase(milestoneData[i][6]))prevChildTeamKey=prevCurrMilestoneData[2];
					else prevChildTeamKey=prevCurrMilestoneData[3];
					
					if(prevCurrMilestoneData[5].equalsIgnoreCase(milestoneData[i][2]))prevTeamMemberUid=prevCurrMilestoneData[4];
					else prevTeamMemberUid=prevCurrMilestoneData[5];
					
					if(prevCurrMilestoneData[7].equalsIgnoreCase(milestoneData[i][9]))prevWorkStatus=prevCurrMilestoneData[6];
					else prevWorkStatus=prevCurrMilestoneData[7];
					
					if(prevCurrMilestoneData[9].equalsIgnoreCase(Priority))pervWorkPriority=prevCurrMilestoneData[8];
					else pervWorkPriority=prevCurrMilestoneData[9];
					
					if(prevCurrMilestoneData[11].equalsIgnoreCase(userPost))prevUserPost=prevCurrMilestoneData[10];
					else prevUserPost=prevCurrMilestoneData[11];
					
					String workStartedDate=milestoneData[i][4];	
					if(!milestoneData[i][11].equalsIgnoreCase("00-00-0000"))workStartedDate=milestoneData[i][11];	
					String mKey=RandomStringUtils.random(40,true,true);
					String salesName=Enquiry_ACT.getSalesProductName(salesrefid, token);
					int stepNo=TaskMaster_ACT.getMilestoneStep(salesrefid, milestoneData[i][0], token);
					String deliveryData[]=TaskMaster_ACT.getMilestoneDeliveryDate(salesrefid,workStartedDate, milestoneData[i][0],stepNo,token);
					String deliveryDate="NA";
					String deliveryTime="NA";
					if(deliveryData[0]!=null)deliveryDate=deliveryData[0];
					if(deliveryData[1]!=null)deliveryTime=deliveryData[1];
					
					flag=TaskMaster_ACT.saveMilestoneActionHistory(mKey,milestoneData[i][5],salesrefid,salesName,prevParentTeamKey,milestoneData[i][13],prevChildTeamKey,milestoneData[i][6],prevTeamMemberUid,milestoneData[i][2],prevWorkStatus,milestoneData[i][9],pervWorkPriority,Priority,deliveryDate,today,token,prevUserPost,userPost,deliveryTime);
				}
			}
		}
		
		return flag;
	}

	public static boolean setDeliveryGroupActionHistory(String salesrefid,String teamrefid,String teamname,String today,String token,String addedby) {
		boolean flag=false;		
		//getting teamrefid
		String assigned=TaskMaster_ACT.getProjectAssignedData(salesrefid,token);
		if(!assigned.equalsIgnoreCase(teamrefid)&&teamrefid!=null&&!teamrefid.equalsIgnoreCase("NA")){
		
			//getting sales data before update work status
			String salesDataOld[][]=Enquiry_ACT.getSalesByRefId(salesrefid, token);
								
			//getting current time
			String Time=DateUtil.getCurrentTime();
			
			//getting sales name,project no and invoice no
			String salesData[]=TaskMaster_ACT.getSalesData(salesrefid,token);
			
			//getting primary contact data
			String contactData[]=Enquiry_ACT.getClientContactByKey(salesData[3], token);
			
			String teamLeader="NA";
			
			//getting team leader id and name
			String leaderId=TaskMaster_ACT.getTeamLeaderId(teamrefid,token); 
			if(!leaderId.equalsIgnoreCase("NA"))
				teamLeader=Usermaster_ACT.getLoginUserName(leaderId, token);
			
			//getting sales dependency status if depend then status 2 otherwise 1
			String salesDependency=TaskMaster_ACT.getSalesDependencyStatus(salesrefid,token);
			String hierarchy[]=salesDependency.split("#");
			
			//		update team info in manage Sales
			flag=TaskMaster_ACT.updateAssigne(salesrefid,teamname,teamrefid, token);			
		if(flag) {
			String dhKey=RandomStringUtils.random(40,true,true);				
			if(salesDataOld!=null&&salesDataOld.length>0) {
				int totalDay=0;
				int minutes=0;
				int data[]=TaskMaster_ACT.getTotalMilestoneDays(salesrefid, token);
				totalDay=data[0];
				minutes=data[1];
				
				String deliveryData[]=DateUtil.getLastDate(salesDataOld[0][12], totalDay,minutes);
				String deliveryDate="NA";
				String deliveryTime="NA";
				if(deliveryData[0]!=null)deliveryDate=deliveryData[0];
				if(deliveryData[1]!=null)deliveryTime=deliveryData[1];
				
				String prevCurrentData[]=TaskMaster_ACT.getPreviousCurrentData(salesrefid,token);
				String prevStatus="NA";
				if(prevCurrentData[1].equalsIgnoreCase(salesDataOld[0][13]))prevStatus=prevCurrentData[0];
				else prevStatus=prevCurrentData[1];
				String prevTeamKey="NA";
				if(prevCurrentData[3].equalsIgnoreCase(teamrefid))prevTeamKey=prevCurrentData[2];
				else prevTeamKey=prevCurrentData[3];
				String prevPriority="NA";
				if(prevCurrentData[5].equalsIgnoreCase(salesDataOld[0][15]))prevPriority=prevCurrentData[4];
				else prevPriority=prevCurrentData[5];
				//adding data in delivery action history for triggers
				flag=TaskMaster_ACT.saveDeliveryActionHistory(dhKey, salesrefid, deliveryDate,prevStatus, salesDataOld[0][13], prevTeamKey,teamrefid,prevPriority,salesDataOld[0][15], today, token, "trigger",deliveryTime);
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
					String deliveryData[]=TaskMaster_ACT.getMilestoneDeliveryDate(salesrefid,today, milestone[i][0],stepNo,token);
					String deliveryDate="NA";
					String deliveryTime="NA";
					if(deliveryData[0]!=null)deliveryDate=deliveryData[0];
					if(deliveryData[1]!=null)deliveryTime=deliveryData[1];
					
					//assign this task to this team	
					flag=TaskMaster_ACT.assignThisTask(assignKey,salesrefid,milestone[i][0],teamrefid,today,hierarchy[0],hierarchy[1],"1",stepStatus,addedby,token,milestone[i][2],milestone[i][3],milestone[i][4],salesData[5],deliveryDate,deliveryTime);
				
					//add data in milestone action history
					if(flag){
						String mKey=RandomStringUtils.random(40,true,true);
						String salesName=Enquiry_ACT.getSalesProductName(salesrefid, token);				//childTeam    uid             workStatus			 priority
//						String deliveryDate=TaskMaster_ACT.getMilestoneDeliveryDate(today, milestone[i][0], token);
						flag=TaskMaster_ACT.saveMilestoneActionHistory(mKey,assignKey,salesrefid,salesName,"NA",teamrefid,"NA","NA","NA","NA","Unassigned","Unassigned","Low","Low",deliveryDate,today,token,"NA","NA",deliveryTime);
					}
				}
			}				
			//add chat thread
			String taskKey=RandomStringUtils.random(40,true,true);				
			String subject="Project Assigned";
			String content="Project assigned to team leader <span style='color: #4ac4f3;font-weight: 600;'>'"+teamLeader+"'</span> on <span style='color: #4ac4f3;font-weight: 600;'>"+today+" "+Time+"</span> by <span style='color: #4ac4f3;font-weight: 600;'>'Trigger'</span>";
			String salesStatus=TaskMaster_ACT.getSalesStatus(salesrefid,token);
			//set notification task assigned to team leader	
			flag=TaskMaster_ACT.setTaskNotification(taskKey,salesrefid,salesData[0],salesData[1],salesData[2],"Notification","bell.png",contactData[0],contactData[1],contactData[2],"NA","NA",today+" "+Time,subject,content,addedby,token,"NA","NA","NA",salesStatus,"NA");				
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
			String content="Project Re-assigned to team leader <span style='color: #4ac4f3;font-weight: 600;'>'"+teamLeader+"'</span> on <span style='color: #4ac4f3;font-weight: 600;'>"+today+" "+Time+"</span> by <span style='color: #4ac4f3;font-weight: 600;'>'Trigger'</span>";
			String salesStatus=TaskMaster_ACT.getSalesStatus(salesrefid, token);
			//set notification task assigned to team leader	
			flag=TaskMaster_ACT.setTaskNotification(taskKey,salesrefid,salesData[0],salesData[1],salesData[2],"Notification","bell.png",contactData[0],contactData[1],contactData[2],"NA","NA",today+" "+Time,subject,content,addedby,token,"NA","NA","NA",salesStatus,"NA");
		}
	}
		return flag;
	}
	
	public static StringBuffer deliveryActionTrigger(String actionKey,String token,String dquery,String today,String addedby) {
		StringBuffer query=new StringBuffer();
		boolean queryStatus=false;
		String actions[][]=TaskMaster_ACT.getAllActions(actionKey);
		if(actions!=null&&actions.length>0) {
			String delivery[][]=TaskMaster_ACT.getTriggerConditionsData(dquery);
			for(int i=0;i<actions.length;i++) {
				switch (actions[i][0]) {
				
				case "Status":query.append(" msworkstatus='"+actions[i][1]+"'");
						String status="1";
						if(actions[i][1].equalsIgnoreCase("Inactive"))status="2";						
						if(delivery!=null&&delivery.length>0) {
							for(int j=0;j<delivery.length;j++) {
								boolean flag=TaskMaster_ACT.updateFinalSalesHierarchyBySalesKey(delivery[j][1],status,token);
								if(flag) {
									setDeliveryStatusActionHistory(delivery[j][1],actions[i][1],today,token,addedby);
								}
							}
						}				
					 queryStatus=true;
					break;
					
				case "Priority":if(queryStatus)query.append(",msworkpriority='"+actions[i][1]+"'");
						else query.append(" msworkpriority='"+actions[i][1]+"'");
						
						if(delivery!=null&&delivery.length>0) {
							for(int j=0;j<delivery.length;j++) {								
								setDeliveryPriorityActionHistory(delivery[j][1],actions[i][1],today,token,addedby);
							}
						}
						queryStatus=true;	
					break;			
				
				case "Group":String teamKey=TaskMaster_ACT.getTeamKey(actions[i][1], token);
							String teamName=TaskMaster_ACT.getTeamName(teamKey, token);
						if(queryStatus)query.append(",msassignedtorefid='"+teamKey+"',msassignedtoname='"+teamName+"'");
						else query.append(" msassignedtorefid='"+teamKey+"',msassignedtoname='"+teamName+"'");
						
						if(delivery!=null&&delivery.length>0) {
							for(int j=0;j<delivery.length;j++) {								
								setDeliveryGroupActionHistory(delivery[j][1],teamKey,teamName,today,token,addedby);
							}
						}						
						queryStatus=true;
					break;
					
				case "Email":
					if(delivery!=null&&delivery.length>0) { 
						  for(int j=0;j<delivery.length;j++){ 
							  String contactKey=Enquiry_ACT.getSalesContactKey(delivery[j][1],token);
							  String contacts[][]=TaskMaster_ACT.getAllSalesContacts(contactKey,token);
							  String newMessage="NA";
							  if(actions[i][1].equalsIgnoreCase("requester and cc")) {
								  if(contacts!=null&&contacts.length>0) {
								 	for(int k=0;k<contacts.length;k++) {
								 		//replace placeholder value
								 		newMessage=replacePlaceholder(actions[i][3],contacts,"NA",delivery[j][2],"NA",delivery[j][1],token);
										  if(newMessage!=null&&newMessage.length()>0&&!newMessage.equals("NA")) {
											  Enquiry_ACT.saveEmail(contacts[k][1],"empty",actions[i][2], newMessage,2,token);
										  }
								 		
								 	}
								  }
							  }else if(actions[i][1].equalsIgnoreCase("requester")) {
								  if(contacts!=null&&contacts.length>0) {
									  newMessage=replacePlaceholder(actions[i][3],contacts,"NA",delivery[j][2],"NA",delivery[j][1],token);
									  if(newMessage!=null&&newMessage.length()>0&&!newMessage.equals("NA")) {
										  Enquiry_ACT.saveEmail(contacts[0][1],"empty",actions[i][2], newMessage,2,token);
									  }
								  }
							  }else if(actions[i][1].equalsIgnoreCase("assignee manager")) {
								  String teamLeader=TaskMaster_ACT.getTeamLeaderId(delivery[j][2], token);
								  String teamLeaderEmail=Usermaster_ACT.getUserEmail(teamLeader,token);
								  if(!teamLeaderEmail.equalsIgnoreCase("NA")) {
									  newMessage=replacePlaceholder(actions[i][3],contacts,"NA",delivery[j][2],"NA",delivery[j][1],token);
									  if(newMessage!=null&&newMessage.length()>0&&!newMessage.equals("NA")) {
										  Enquiry_ACT.saveEmail(teamLeaderEmail,"empty",actions[i][2], newMessage,2,token);
									  }
								  }
							  }
							  }}
					//send email
						break;
			
				case "Sms":
					if(delivery!=null&&delivery.length>0) { 
						  for(int j=0;j<delivery.length;j++){ 
							  String contactKey=Enquiry_ACT.getSalesContactKey(delivery[j][1],token);
							  String contacts[][]=TaskMaster_ACT.getAllSalesContacts(contactKey,token);
							  String newMessage="NA";
							  if(actions[i][1].equalsIgnoreCase("requester and cc")) {
								  if(contacts!=null&&contacts.length>0) {
								 	for(int k=0;k<contacts.length;k++) {
								 		//replace placeholder value
								 		newMessage=replacePlaceholder(actions[i][3],contacts,"NA",delivery[j][2],"NA",delivery[j][1],token);
										  if(newMessage!=null&&newMessage.length()>0&&!newMessage.equals("NA")) {
											  sendSms(contacts[k][2],newMessage);
										  }
								 		
								 	}
								  }
							  }else if(actions[i][1].equalsIgnoreCase("requester")) {
								  if(contacts!=null&&contacts.length>0) {
									  newMessage=replacePlaceholder(actions[i][3],contacts,"NA",delivery[j][2],"NA",delivery[j][1],token);
									  if(newMessage!=null&&newMessage.length()>0&&!newMessage.equals("NA")) {
										  sendSms(contacts[0][2],newMessage);
									  }
								  }
							  }else if(actions[i][1].equalsIgnoreCase("assignee manager")) {
								  String teamLeader=TaskMaster_ACT.getTeamLeaderId(delivery[j][2], token);
								  String teamLeaderMobile=Usermaster_ACT.getUserMobile(teamLeader,token);
								  if(!teamLeaderMobile.equalsIgnoreCase("NA")) {
									  newMessage=replacePlaceholder(actions[i][3],contacts,"NA",delivery[j][2],"NA",delivery[j][1],token);
									  if(newMessage!=null&&newMessage.length()>0&&!newMessage.equals("NA")) {
										  sendSms(teamLeaderMobile,newMessage);
									  }
								  }
							  }
							  }}
					//send sms
						break;

				default:query=new StringBuffer("NA");
					break;
				}
			}
		}
//		System.out.println("deliveryActionTrigger : "+query);
		return query;
	}
	
	public static StringBuffer deliveryTrigger(String conditionKey,String token) {
		StringBuffer query=new StringBuffer();
		StringBuffer aQuery=new StringBuffer();
		boolean queryStatus=false;
		String conditions[][]=TaskMaster_ACT.getAllConditions(conditionKey);
		if(conditions!=null&&conditions.length>0) {
			for(int i=0;i<conditions.length;i++) {
				switch (conditions[i][0]) {
				
				case "Status":aQuery=getStatusQuery(conditions[i][1],conditions[i][2]);
					if(aQuery.toString()!=null&&!aQuery.toString().equalsIgnoreCase("NA")) {
						query.append(aQuery);
						queryStatus=true;
					}
					break;
					
				case "Priority":aQuery=getPriorityQuery(conditions[i][1],conditions[i][2]);
					if(aQuery.toString()!=null&&!aQuery.toString().equalsIgnoreCase("NA")) {
						if(queryStatus)query.append(" and "+aQuery);
						else query.append(aQuery);
						queryStatus=true;
					}
					break;
				
				case "Due date":aQuery=getDueDateQuery(conditions[i][1],conditions[i][2]);
					if(aQuery.toString()!=null&&!aQuery.toString().equalsIgnoreCase("NA")) {
						if(queryStatus)query.append(" and "+aQuery);
						else query.append(aQuery);
						queryStatus=true;
					}
					break;
					
				case "Group":aQuery=getGroupQuery(conditions[i][1],conditions[i][2],token);
					if(aQuery.toString()!=null&&!aQuery.toString().equalsIgnoreCase("NA")) {
						if(queryStatus)query.append(" and "+aQuery);
						else query.append(aQuery);
						queryStatus=true;
					}
					break;

				default:
					break;
				}
			}
		}
//		System.out.println("deliveryTrigger : "+query);
		return query;
	}
	
	public static StringBuffer getGroupQuery(String conditionSub,String conditionChild,String token) {
		StringBuffer query=new StringBuffer();
		String teamKey=TaskMaster_ACT.getTeamKey(conditionChild,token);
		
		switch (conditionSub) {
		case "is":query.append(" dhcurrentteamkey='"+teamKey+"'");		
			break;
		
		case "is not":query.append(" dhcurrentteamkey!='"+teamKey+"'");
			break;
			
		case "changed":query.append(" dhprevteamkey!=dhcurrentteamkey");				
			break;			
			
		case "changed to":query.append(" dhprevteamkey!='"+teamKey+"' and dhcurrentteamkey='"+teamKey+"'");
			break;
			
		case "changed from":query.append(" dhprevteamkey='"+teamKey+"' and dhcurrentteamkey!='"+teamKey+"'");
			break;
		
		case "not changed":query.append(" dhprevteamkey=dhcurrentteamkey");				
		break;
		
		case "not changed from":query.append(" dhprevteamkey='"+teamKey+"' and dhcurrentteamkey='"+teamKey+"'");
			break;
			
		case "not changed to":query.append(" dhprevteamkey='"+teamKey+"' and dhcurrentteamkey!='"+teamKey+"'");
			break;
			
		default:query=new StringBuffer("NA");
			break;
		}	
		return query;
	}
	
	public static StringBuffer getDueDateQuery(String conditionSub,String conditionChild) {
		String today=DateUtil.getCurrentDateIndianReverseFormat();
		StringBuffer query=new StringBuffer();
		switch (conditionSub) {
		case "is":if(conditionChild.equalsIgnoreCase("present")) {
				query.append(" str_to_date(dhdeliverydate,'%d-%m-%Y')>='"+today+"'");						
			}else if(conditionChild.equalsIgnoreCase("expired")) {
				query.append(" str_to_date(dhdeliverydate,'%d-%m-%Y')<'"+today+"'");		
			}
			break;
			
		default:query=new StringBuffer("NA");
			break;
		}	
		return query;
	}
	
	public static StringBuffer getPriorityQuery(String conditionSub,String conditionChild) {
		
		StringBuffer query=new StringBuffer();
		
		switch (conditionSub) {
		case "is":query.append(" dhcurrentpriority='"+conditionChild+"'");						
			break;
		
		case "is not":query.append(" dhcurrentpriority!='"+conditionChild+"'");			
			break;
			
		case "less than":if(conditionChild.equalsIgnoreCase("Normal")) {
			query.append(" dhcurrentpriority='Low'");
			}else if(conditionChild.equalsIgnoreCase("Moderate")) {
				query.append(" (dhcurrentpriority='Low' or dhcurrentpriority='Normal')");
			}else if(conditionChild.equalsIgnoreCase("high")) {
				query.append(" (dhcurrentpriority='Low' or dhcurrentpriority='Normal' or dhcurrentpriority='Moderate')");
			}	
			break;
			
		case "greater than":if(conditionChild.equalsIgnoreCase("Moderate")) {
			query.append(" dhcurrentpriority='High'");
			}else if(conditionChild.equalsIgnoreCase("Normal")) {
				query.append(" (dhcurrentpriority='Moderate' or dhcurrentpriority='High')");
			}else if(conditionChild.equalsIgnoreCase("low")) {
				query.append(" (dhcurrentpriority='Normal' or dhcurrentpriority='Moderate' or dhcurrentpriority='High')");
			}	
			break;
			
		case "changed":query.append(" dhprevpriority!=dhcurrentpriority");				
			break;			
			
		case "changed to":query.append(" dhprevpriority!='"+conditionChild+"' and dhcurrentpriority='"+conditionChild+"'");				
			break;
			
		case "changed from":query.append(" dhprevpriority='"+conditionChild+"' and dhcurrentpriority!='"+conditionChild+"'");
			break;
		
		case "not changed":query.append(" dhprevpriority=dhcurrentpriority");				
		break;
		
		case "not changed from":query.append(" dhprevpriority='"+conditionChild+"' and dhcurrentpriority='"+conditionChild+"'");
			break;
			
		case "not changed to":query.append(" dhprevstatus='"+conditionChild+"' and dhcurrentpriority!='"+conditionChild+"'");
			break;
			
		default:query=new StringBuffer("NA");
			break;
		}	
		return query;
	}
	
	public static StringBuffer getStatusQuery(String conditionSub,String conditionChild) {
		StringBuffer query=new StringBuffer();
		
		switch (conditionSub) {
		case "is":query.append(" dhcurrentstatus='"+conditionChild+"'");		
			break;
		
		case "is not":query.append(" dhcurrentstatus!='"+conditionChild+"'");
			break;
			
		case "changed":query.append(" dhprevstatus!=dhcurrentstatus");				
			break;			
			
		case "changed to":query.append(" dhprevstatus!='"+conditionChild+"' and dhcurrentstatus='"+conditionChild+"'");
			break;
			
		case "changed from":query.append(" dhprevstatus='"+conditionChild+"' and dhcurrentstatus!='"+conditionChild+"'");
			break;
		
		case "not changed":query.append(" dhprevstatus=dhcurrentstatus");				
		break;
		
		case "not changed from":query.append(" dhprevstatus='"+conditionChild+"' and dhcurrentstatus='"+conditionChild+"'");
			break;
			
		case "not changed to":query.append(" dhprevstatus='"+conditionChild+"' and dhcurrentstatus!='"+conditionChild+"'");
			break;
			
		default:query=new StringBuffer("NA");
			break;
		}	
		return query;
	}
	//milestone
	public static StringBuffer getMilestoneStatusQuery(String conditionSub,String conditionChild) {
		
		StringBuffer query=new StringBuffer();
		
		switch (conditionSub) {
		case "is":query.append(" maCurrentWorkStatus='"+conditionChild+"'");						
			break;
		
		case "is not":query.append(" maCurrentWorkStatus!='"+conditionChild+"'");			
			break;
			
		case "less than":if(conditionChild.equalsIgnoreCase("Open")) {
			query.append(" maCurrentWorkStatus='New'");
			}else if(conditionChild.equalsIgnoreCase("Pending")) {
				query.append(" (maCurrentWorkStatus='New' or maCurrentWorkStatus='Open')");
			}else if(conditionChild.equalsIgnoreCase("On-Hold")) {
				query.append(" (maCurrentWorkStatus='New' or maCurrentWorkStatus='Open' or maCurrentWorkStatus='Pending')");
			}else if(conditionChild.equalsIgnoreCase("Expired")) {
				query.append(" (maCurrentWorkStatus='New' or maCurrentWorkStatus='Open' or maCurrentWorkStatus='Pending' or maCurrentWorkStatus='On-Hold')");
			}else if(conditionChild.equalsIgnoreCase("Completed")) {
				query.append(" (maCurrentWorkStatus='New' or maCurrentWorkStatus='Open' or maCurrentWorkStatus='Pending' or maCurrentWorkStatus='On-Hold' or maCurrentWorkStatus='Expired')");
			}	
			break;
			
		case "greater than":if(conditionChild.equalsIgnoreCase("Expired")) {
			query.append(" maCurrentWorkStatus='Completed'");
			}else if(conditionChild.equalsIgnoreCase("On-Hold")) {
				query.append(" (maCurrentWorkStatus='Expired' or maCurrentWorkStatus='Completed')");
			}else if(conditionChild.equalsIgnoreCase("pending")) {
				query.append(" (maCurrentWorkStatus='On-Hold' or maCurrentWorkStatus='Expired' or maCurrentWorkStatus='Completed')");
			}else if(conditionChild.equalsIgnoreCase("Open")) {
				query.append(" (maCurrentWorkStatus='Pending' or maCurrentWorkStatus='On-Hold' or maCurrentWorkStatus='Expired' or maCurrentWorkStatus='Completed')");
			}else if(conditionChild.equalsIgnoreCase("New")) {
				query.append(" (maCurrentWorkStatus='Open' or maCurrentWorkStatus='Pending' or maCurrentWorkStatus='On-Hold' or maCurrentWorkStatus='Expired' or maCurrentWorkStatus='Completed')");
			}
			break;
			
		case "changed":query.append(" maPrevWorkStatus!=maCurrentWorkStatus");				
			break;			
			
		case "changed to":query.append(" maPrevWorkStatus!='"+conditionChild+"' and maCurrentWorkStatus='"+conditionChild+"'");				
			break;
			
		case "changed from":query.append(" maPrevWorkStatus='"+conditionChild+"' and maCurrentWorkStatus!='"+conditionChild+"'");
			break;
		
		case "not changed":query.append(" maPrevWorkStatus=maCurrentWorkStatus");				
		break;
		
		case "not changed from":query.append(" maPrevWorkStatus='"+conditionChild+"' and maCurrentWorkStatus='"+conditionChild+"'");
			break;
			
		case "not changed to":query.append(" maPrevWorkStatus='"+conditionChild+"' and maCurrentWorkStatus!='"+conditionChild+"'");
			break;
			
		default:query=new StringBuffer("NA");
			break;
		}	
		return query;
	}
public static StringBuffer getMilestonePriorityQuery(String conditionSub,String conditionChild) {
		
		StringBuffer query=new StringBuffer();
		
		switch (conditionSub) {
		case "is":query.append(" maCurrentWorkPriority='"+conditionChild+"'");						
			break;
		
		case "is not":query.append(" maCurrentWorkPriority!='"+conditionChild+"'");			
			break;
			
		case "less than":if(conditionChild.equalsIgnoreCase("Normal")) {
			query.append(" maCurrentWorkPriority='Low'");
			}else if(conditionChild.equalsIgnoreCase("Moderate")) {
				query.append(" (maCurrentWorkPriority='Low' or maCurrentWorkPriority='Normal')");
			}else if(conditionChild.equalsIgnoreCase("high")) {
				query.append(" (maCurrentWorkPriority='Low' or maCurrentWorkPriority='Normal' or maCurrentWorkPriority='Moderate')");
			}	
			break;
			
		case "greater than":if(conditionChild.equalsIgnoreCase("Moderate")) {
			query.append(" maCurrentWorkPriority='High'");
			}else if(conditionChild.equalsIgnoreCase("Normal")) {
				query.append(" (maCurrentWorkPriority='Moderate' or maCurrentWorkPriority='High')");
			}else if(conditionChild.equalsIgnoreCase("low")) {
				query.append(" (maCurrentWorkPriority='Normal' or maCurrentWorkPriority='Moderate' or maCurrentWorkPriority='High')");
			}	
			break;
			
		case "changed":query.append(" maPervWorkPriority!=maCurrentWorkPriority");				
			break;			
			
		case "changed to":query.append(" maPervWorkPriority!='"+conditionChild+"' and maCurrentWorkPriority='"+conditionChild+"'");				
			break;
			
		case "changed from":query.append(" maPervWorkPriority='"+conditionChild+"' and maCurrentWorkPriority!='"+conditionChild+"'");
			break;
		
		case "not changed":query.append(" maPervWorkPriority=maCurrentWorkPriority");				
		break;
		
		case "not changed from":query.append(" maPervWorkPriority='"+conditionChild+"' and maCurrentWorkPriority='"+conditionChild+"'");
			break;
			
		case "not changed to":query.append(" maPervWorkPriority='"+conditionChild+"' and maCurrentWorkPriority!='"+conditionChild+"'");
			break;
			
		default:query=new StringBuffer("NA");
			break;
		}	
		return query;
	}
	public static StringBuffer getMilestoneDueDateQuery(String conditionSub,String conditionChild) {
		String today=DateUtil.getCurrentDateIndianReverseFormat();
		StringBuffer query=new StringBuffer();
		switch (conditionSub) {
		case "is":if(conditionChild.equalsIgnoreCase("present")) {
				query.append(" str_to_date(maDeliveryDate,'%d-%m-%Y')>='"+today+"'");						
			}else if(conditionChild.equalsIgnoreCase("expired")) {
				query.append(" str_to_date(maDeliveryDate,'%d-%m-%Y')<'"+today+"'");		
			}
			break;
			
		default:query=new StringBuffer("NA");
			break;
		}	
		return query;
	}
	
	public static StringBuffer getMilestoneAssigneeQuery(String conditionSub,String conditionChild) {
		StringBuffer query=new StringBuffer();
		
		switch (conditionSub) {
		case "is":query.append(" maCurrentUserPost='"+conditionChild+"'");		
			break;
		
		case "is not":query.append(" maCurrentUserPost!='"+conditionChild+"'");		
			break;
			
		case "changed":query.append(" maPrevUserPost!=maCurrentUserPost");				
			break;			
			
		case "changed to":query.append(" maPrevUserPost!='"+conditionChild+"' and maCurrentUserPost='"+conditionChild+"'");
			break;
			
		case "changed from":query.append(" maPrevUserPost='"+conditionChild+"' and maCurrentUserPost!='"+conditionChild+"'");
			break;
		
		case "not changed":query.append(" maPrevUserPost=maCurrentUserPost");				
			break;
		
		case "not changed from":query.append(" maPrevUserPost='"+conditionChild+"' and maCurrentUserPost='"+conditionChild+"'");
			break;
			
		case "not changed to":query.append(" maPrevUserPost='"+conditionChild+"' and maCurrentUserPost!='"+conditionChild+"'");
			break;
			
		default:query=new StringBuffer("NA");
			break;
		}	
		return query;
	}
	
	public static StringBuffer getMilestoneGroupQuery(String conditionSub,String conditionChild,String token) {
		StringBuffer query=new StringBuffer();
		String teamKey=TaskMaster_ACT.getTeamKey(conditionChild,token);
		
		switch (conditionSub) {
		case "is":query.append(" maCurrentParentTeamKey='"+teamKey+"'");		
			break;
		
		case "is not":query.append(" maCurrentParentTeamKey!='"+teamKey+"'");		
			break;
			
		case "changed":query.append(" maPrevParentTeamKey!=maCurrentParentTeamKey");				
			break;			
			
		case "changed to":query.append(" maPrevParentTeamKey!='"+teamKey+"' and maCurrentParentTeamKey='"+teamKey+"'");
			break;
			
		case "changed from":query.append(" maPrevParentTeamKey='"+teamKey+"' and maCurrentParentTeamKey!='"+teamKey+"'");
			break;
		
		case "not changed":query.append(" maPrevParentTeamKey=maCurrentParentTeamKey");				
			break;
		
		case "not changed from":query.append(" maPrevParentTeamKey='"+teamKey+"' and maCurrentParentTeamKey='"+teamKey+"'");
			break;
			
		case "not changed to":query.append(" maPrevParentTeamKey='"+teamKey+"' and maCurrentParentTeamKey!='"+teamKey+"'");
			break;
			
		default:query=new StringBuffer("NA");
			break;
		}	
		return query;
	}
	
	public static StringBuffer getMilestoneProjectQuery(String conditionSub,String conditionChild) {
		StringBuffer query=new StringBuffer();
		
		switch (conditionSub) {
		case "Contains atleast one of the following word":query.append(" maSalesName like '%"+conditionChild+"%'");		
			break;
		
		case "Contains none of the following word":query.append(" maSalesName not like '%"+conditionChild+"%'");		
			break;
			
		case "Contains the string":query.append(" maSalesName like '%"+conditionChild+"%'");				
			break;			
			
		case "not contains the string":query.append(" maSalesName not like '%"+conditionChild+"%'");
			break;			
		
		default:query=new StringBuffer("NA");
			break;
		}	
		return query;
	}
	public static boolean sendEmail1(String destmailid,String subject,String message) {
//		System.out.println(destmailid+"/"+subject+"/"+message);
		boolean flag=false;
		//Declare recipient's & sender's e-mail id.
	      String sendrmailid = "Ajay.kumar@corpseed.com";	  
	     //Mention user name and password as per your configuration
	      final String uname = "Ajay.kumar@corpseed.com";
	      final String pwd = "ajay@8757024219";
	      //We are using relay.jangosmtp.net for sending emails
	      String smtphost = "mail.corpseed.com";
	     //Set properties and their values
	      Properties propvls = new Properties();
	      propvls.put("mail.smtp.auth", "true");
	      propvls.put("mail.smtp.starttls.enable", "true");
	      propvls.put("mail.smtp.host", smtphost);
	      propvls.put("mail.smtp.port", "587");
	      //Create a Session object & authenticate uid and pwd
	      Session sessionobj = Session.getInstance(propvls,
	         new javax.mail.Authenticator() {
	            protected PasswordAuthentication getPasswordAuthentication() {
	               return new PasswordAuthentication(uname, pwd);
		   }
	         });

	      try {
		   //Create MimeMessage object & set values
		   Message messageobj = new MimeMessage(sessionobj);
		   messageobj.setFrom(new InternetAddress(sendrmailid));
		   messageobj.setRecipients(Message.RecipientType.TO,InternetAddress.parse(destmailid));
		   messageobj.setSubject(subject);
		   messageobj.setContent(message, "text/html");
		   messageobj.setSentDate(new Date());
		  //Now send the message
		   Transport.send(messageobj);
		   flag=true;
//		   System.out.println("Your email sent successfully....");
	      } catch (MessagingException exp) {
	         throw new RuntimeException(exp);
	      }
		return flag;
	}
	public static int sendPost(String POST_URL,String POST_PARAMS) {
		int responseCode=0;
		try {
		URL obj = new URL(POST_URL);
        HttpURLConnection httpURLConnection = (HttpURLConnection) obj.openConnection();
        httpURLConnection.setRequestMethod("POST");
        httpURLConnection.setRequestProperty("User-Agent", "Mozilla/5.0");

        // For POST only - START
        httpURLConnection.setDoOutput(true);
        OutputStream os = httpURLConnection.getOutputStream();
        os.write(POST_PARAMS.getBytes());
        os.flush();
        os.close();
        // For POST only - END

        responseCode = httpURLConnection.getResponseCode();
//        System.out.println("POST Response Code :: " + responseCode);
		}catch(Exception e) {
			e.printStackTrace();
		}
		return responseCode;
	}

	public static String[][] getUnPostedRating(String token) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String[][] data = null;
		try {
			con =DbCon.getCon("", "", "");
			
			StringBuffer query =new StringBuffer("select * from service_rating where token='"+token+"' and push_status='2'");
			
			ps = con.prepareStatement(query.toString());
			rs = ps.executeQuery();
			rs.last();
			int row = rs.getRow();
			rs.beforeFirst();
			ResultSetMetaData rsmd = rs.getMetaData();
			int col = rsmd.getColumnCount();
			data = new String[row][col];
			int rr = 0;
			while (rs != null && rs.next()) {
				for (int i = 0; i < col; i++) {
					data[rr][i] = rs.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
			}
		}
		return data;
	}

	public static String getTotalRating(String productKey, String token,String defaultUser,String defaultValue) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rs=null;
		double rating1=0;
		double client1=0;
		double client2=0;
		double client3=0;
		double client4=0;
		double client5=0;
		String data="";
		try{
			getacces_con=DbCon.getCon("","","");		
			stmnt=getacces_con.prepareStatement("select rating_value from service_rating where product_key='"+productKey+"' and token='"+token+"'");
			rs=stmnt.executeQuery();
			
			while(rs.next()) {
				int rating=rs.getInt(1);
				if(rating==1)client1+=1;
				else if(rating==2)client2+=1;
				else if(rating==3)client3+=1;
				else if(rating==4)client4+=1;
				else if(rating==5)client5+=1;
			}
			long du=Long.parseLong(defaultUser);
			double dv=Double.parseDouble(defaultValue);
			
			rating1=(client1+(client2*2)+(client3*3)+(client4*4)+(client5*5)+(du*dv))/(client1+client2+client3+client4+client5+du);
			data=(client1+client2+client3+client4+client5+du)+"#"+CommonHelper.withLargeIntegers(rating1);
			
		}catch(Exception e)
		{e.printStackTrace();}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();				
			}
		}
		return data;
	}
	
	public static String getProductKey(String productNo, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rs=null;
		String data="NA";
		try{
			getacces_con=DbCon.getCon("","","");		
			stmnt=getacces_con.prepareStatement("select prefid from product_master where pprodid='"+productNo+"' and ptokenno='"+token+"'");
			rs=stmnt.executeQuery();
			
			if(rs.next())data=rs.getString(1);
			
		}catch(Exception e)
		{e.printStackTrace();}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();				
			}
		}
		return data;
	}
	
	public static String getProductNumber(String prodKey, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rs=null;
		String data="NA";
		try{
			getacces_con=DbCon.getCon("","","");		
			stmnt=getacces_con.prepareStatement("select pprodid from product_master where prefid='"+prodKey+"' and ptokenno='"+token+"'");
			rs=stmnt.executeQuery();
			
			if(rs.next())data=rs.getString(1);
			
		}catch(Exception e)
		{e.printStackTrace();}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();				
			}
		}
		return data;
	}
	
}
