package admin.scheduler;

import java.text.ParseException;
import java.util.TimerTask;

import org.apache.commons.lang.RandomStringUtils;

import admin.enquiry.Enquiry_ACT;
import admin.master.Usermaster_ACT;
import admin.task.TaskMaster_ACT;
import commons.CommonHelper;
import commons.DateUtil;
import cron_job.cron_job_ACT;
import hcustbackend.ClientACT;

public class Cron_Job extends TimerTask {
	
	@Override
	public void run() {
		StringBuffer dquery=null;
		StringBuffer tquery=new StringBuffer();
		StringBuffer actQuery=null;
		StringBuffer mquery=null;
		//getting today's date
		String today=DateUtil.getCurrentDateIndianReverseFormat();
		String todayDate=DateUtil.getCurrentDateIndianFormat1();
		
		String token="CP27102021ITES1";
		String domain="https://crm.corpseed.com/";
		String loginuaid="178";
				
//		String loginuaid = (String)session.getAttribute("loginuaid");
		String addedby = "trigger";
		//getting all milestone which delivery date is passed and adding work duration
		String currentTime=DateUtil.getCurrentTime24Hours();
		try {
			
		String tasks[][]=TaskMaster_ACT.getAllToExpiredMilestones(today,currentTime);
		if(tasks!=null&&tasks.length>0) {
			for(int i=0;i<tasks.length;i++) {
				 String date=tasks[i][3];
				 String mtime=tasks[i][4];
				 String workStatus=tasks[i][2];
				 String salesKey=tasks[i][1];
				if(date!=null&&mtime!=null&&!date.equalsIgnoreCase("NA")&&
						!mtime.equalsIgnoreCase("NA")) {
					//getting total hours and minutes till now status change
					long hourMinutes[]=CommonHelper.calculateHours(date,mtime);
					String column_hh="NA";
					String column_mm="NA";
					if(workStatus.equalsIgnoreCase("New")) {
						column_hh="task_new_hh";
						column_mm="task_new_mm";
					}else if(workStatus.equalsIgnoreCase("Open")) {
						column_hh="task_open_hh";
						column_mm="task_open_mm";
					}else if(workStatus.equalsIgnoreCase("On-hold")) {
						column_hh="task_hold_hh";
						column_mm="task_hold_mm";
					}else if(workStatus.equalsIgnoreCase("Pending")) {
						column_hh="task_pending_hh";
						column_mm="task_pending_mm";
					}else if(workStatus.equalsIgnoreCase("Expired")) {
						column_hh="task_expired_hh";
						column_mm="task_expired_mm";
					}
					
					long hhmm[]=TaskMaster_ACT.getTaskHHMM(column_hh,column_mm,tasks[i][0],salesKey,tasks[i][5],token);
					
					if(!column_hh.equals("NA")&&!column_mm.equals("NA")) {
						long hours=hourMinutes[1]+hhmm[0];
						long minutes=hourMinutes[0]+hhmm[1];
						
						if(minutes>60) {
							long hour=(minutes/60);
							hours+=hour;
							minutes=(minutes-(hour*60));
						}
						
						TaskMaster_ACT.updateTaskProgress(column_hh,column_mm,hours,minutes,tasks[i][0],salesKey,tasks[i][5],token);
					}
				}
			 }			
		}
		
		//updating all milestone status expired which date is passed
		if(tasks!=null&&tasks.length>0)
		TaskMaster_ACT.updateExpiredToMilestones(today,currentTime);
		
		}catch(Exception e) {e.printStackTrace();}
		
		
		
		//getting all expired milestones
		String expMilestones[][]=TaskMaster_ACT.getAllExpiredMilestones(todayDate);
		if(expMilestones!=null&&expMilestones.length>0) {
			for(int i=0;i<expMilestones.length;i++) {	
				String teamKey=expMilestones[i][2];
				if(!expMilestones[i][3].equalsIgnoreCase("NA"))teamKey=expMilestones[i][3];
					 String teamLeaderUid=TaskMaster_ACT.getTeamLeaderId(teamKey, expMilestones[i][5]);
					if(teamKey!="NA"&&teamLeaderUid!="NA") {
							String salesData[]=TaskMaster_ACT.getSalesData(expMilestones[i][0], expMilestones[i][5]);
							 //adding notification
							String nKey=RandomStringUtils.random(40,true,true);
							String message="<span class='text-info'>"+salesData[1]+" : "+expMilestones[i][1]+"</span> is <b class='text-danger'>expired</b>, Please update status.";
							TaskMaster_ACT.addNotification(nKey,todayDate,teamLeaderUid,"2","managedelivery.html",message,expMilestones[i][5],"NA","fas fa-file-powerpoint text-danger");
							//adding for sold person
							String userNKey=RandomStringUtils.random(40,true,true);
							String userMessage="<span class='text-info'>"+salesData[2]+" : "+expMilestones[i][1]+"</span> is expired, Please update status.";
							TaskMaster_ACT.addNotification(userNKey,todayDate,expMilestones[i][4],"2","edittask-"+expMilestones[i][6]+".html",userMessage,expMilestones[i][5],"NA","fas fa-file-powerpoint text-danger");
							//updating notification send date
							TaskMaster_ACT.updateExpiryNotificationSendDate(expMilestones[i][6],todayDate,expMilestones[i][5]);
					}
			}
		}
		String currentTime12Hours = DateUtil.getCurrentTime12Hours();
		//get sales reminder and send notification related user
		String reminders[][]=TaskMaster_ACT.getAllUpcomingReminders(today,todayDate,currentTime12Hours);
		if(reminders!=null&&reminders.length>0) {
			for(int i=0;i<reminders.length;i++) {
				//GETTING USER
				String user[][]=Usermaster_ACT.getUserByID(reminders[i][1]);
				//adding for sold person
				String userNKey=RandomStringUtils.random(40,true,true);
				String userMessage="<span class='text-info'>Reminder : </span> "+reminders[i][2];
				TaskMaster_ACT.addNotification(userNKey,todayDate,reminders[i][1],"2","edittask-"+reminders[i][6]+".html",userMessage,reminders[i][5],"NA","far fa-clock");
				String milestone="";
				String invoice=TaskMaster_ACT.getSalesInvoiceNumber(reminders[i][7], token);
				if(reminders[i][6]!=null&&!reminders[i][6].equalsIgnoreCase("NA"))
					milestone=TaskMaster_ACT.getAssignMileStoneName(reminders[i][6], token);
				else
					milestone=invoice;
				
				String message="<table border=\"0\" style=\"margin:0 auto; min-width:700px;font-size:15px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\r\n"
						+ "        <tbody><tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\r\n"
						+ "                <a href=\"#\" target=\"_blank\">\r\n"
						+ "                <img src=\"https://www.corpseed.com/assets/img/logo.png\"></a>\r\n"
						+ "            </td></tr>\r\n"
						+ "            <tr>\r\n"
						+ "              <td style=\"text-align: center;\">\r\n"
						+ "                <h1>REMINDER</h1>\r\n"
						+ "              <p style=\"font-size: 18px; line-height: 20px;color: #353637;\">Everything is processing well with your order</p></td></tr>\r\n"
						+ "        <tr>\r\n"
						+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\r\n"
						+ "            Hi "+user[0][5]+",</td></tr>"
						+ "             <tr>"
						+ "                    <td style=\"padding: 10px 0;color: #353637;\"> \r\n"
						+ "                     <p>You have a reminder for <b>"+milestone+"</b> on <b>"+reminders[i][3]+" "+reminders[i][4]+"</b> for following :-\r\n"
						+ "                      </p>\r\n"
						+ "                    <p>"+reminders[i][2]+"\r\n"
						+ "                    </p>\r\n"
						+ "                     <p>Note : </b>This is an auto generated email. Please complete the reminder to stop receiving the updates.\r\n"
						+ "                     </p>\r\n"
						+ "                    </td></tr>  \r\n"
						+ "             <tr><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\r\n"
						+ "                <b>Invoice No. #"+invoice+"</b><br>\r\n"
						+ "                <p>Address:Corpseed,2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\r\n"
						+ "    </td></tr> \r\n"
						+ "    </tbody></table>";				
				
				Enquiry_ACT.saveEmail(user[0][7],"empty",invoice+" :  Reminder Notification : "+DateUtil.getCurrentDateIndianFormat(), message,2,token);
				
				//updating notification send date
				TaskMaster_ACT.updateReminderSendDate(reminders[i][0],todayDate,reminders[i][5]);
			}
		}
		//adding notification if client not replayed on chat within 5 minutes		
		String timeAfter=DateUtil.getTimeAfterMinutes(-5);
		String salesNotification[][]=TaskMaster_ACT.getPendingFollowUpSendData(today,timeAfter,token);
		if(salesNotification!=null&&salesNotification.length>0) {
			for(int i=0;i<salesNotification.length;i++) {
				String clientUid=ClientACT.getClientIdByKey(salesNotification[i][4], token);
				String nKey=RandomStringUtils.random(40,true,true);
				String url="client_inbox.html?skey="+salesNotification[i][0]+"&pno="+salesNotification[i][1]+"&pname="+salesNotification[i][2]+"&cdate="+salesNotification[i][3];
				String message="You have new follow-up on project <span class=\"text-info\">"+salesNotification[i][1]+" : "+salesNotification[i][2]+"</span>";
				TaskMaster_ACT.addNotification(nKey,today,clientUid,"1",url,message,token,loginuaid,"far fa-check-circle");
				TaskMaster_ACT.updateNotificationDate(salesNotification[i][0],today);
			}
		}		
		
		String userNotification[][]=TaskMaster_ACT.getUserPendingFollowUpSendData(timeAfter,token);
		if(userNotification!=null&&userNotification.length>0) {
			for(int i=0;i<userNotification.length;i++) {
				//adding notification
				String nKey=RandomStringUtils.random(40,true,true);
				boolean addNotification = TaskMaster_ACT.addNotification(nKey,userNotification[i][2],userNotification[i][4],"2",userNotification[i][5],userNotification[i][8],userNotification[i][9],userNotification[i][7],userNotification[i][6]);
				if(addNotification)TaskMaster_ACT.removeUserNotificationById(userNotification[i][0]);
			}
		}
		//getting two days before date
		String before1date=DateUtil.getPrevDaysDate(1);
		String before3date=DateUtil.getPrevDaysDate(4);
		String before7date=DateUtil.getPrevDaysDate(11);
		
		//getting todays date in yyyy-mm-dd formate
		String date=DateUtil.getCurrentDateIndianReverseFormat();
		
		//getting chat not replied details
		String[][] salesData=TaskMaster_ACT.getSalesDataWhomNotRepliedFollowUp(before1date,before3date,before7date,date);
		if(salesData!=null&&salesData.length>0) {
			for(int i=0;i<salesData.length;i++) {
				String contact=TaskMaster_ACT.getContactEmail(salesData[i][1]);
				if(!contact.equalsIgnoreCase("NA")) {
					String x[]=contact.split("#");
					String contactName=x[0];
					String contactEmail=x[1];
					//going to send email
//					String content="Hey, "+contactName+"<br>You haven replied on our team, Please <a href='#'>login here</a> and send your valuable reply.";
//					boolean sendEmail =Enquiry_ACT.saveEmail(contactEmail,"empty","Corpseed follow-up notification", content,2,token);
					String abc="#FCE9EF";
					String ac="#CB6C8C";
					String cbc="#d8e2dc";
					String cc="#838985";
					
					String message="<table border=\"0\" style=\"margin:0 auto; width:700px;min-width:700px;font-size:18px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\n"
							+ "        <tr><td style='text-align: left ;background-color: #fff;width: 50px'>\n"
							+ "                <a href='#' target='_blank'>\n"
							+ "                <img src=\"https://corpseed.com/assets/img/logo.png\"></a>\n"
							+ "            </td></tr>\n"
							+ "            <tr>\n"
							+ "              <td style='text-align: center;'>\n"
							+ "                <h1>ORDER UPDATE</h1>\n"
							+ "              <p style=\"font-size: 18px; line-height: 20px;color: #353637;\">Everything is processing well with your order.</p></td></tr>\n"
							+ "        <tr>\n"
							+ "          <td style='padding:70px 0 20px;color: #353637;'>\n"
							+ "            Hi "+contactName+",</td></tr>\n"
							+ "             <tr>\n"
							+ "                    <td style='padding: 10px 0 15px;color: #353637;'> \n"
							+ "                     <p> You have pending Follow-Up on Project <b>"+salesData[i][2]+"</b>. Reply by clicking below reply button.\n"
							+ "                      </p>\n"
							+ "                    </td></tr>";	
							
					String followUp[][]=TaskMaster_ACT.getLastFiveFollowUp(salesData[i][4]);
					if(followUp!=null&&followUp.length>0) {
					for(int j=followUp.length-1;j>=0;j--) {
						String icon=followUp[j][1].substring(0,1).toUpperCase();
						
						String content=followUp[j][0].replace("<p>", "");
						content=content.replace("</p>", "");
												
					if(followUp[j][2]==null||followUp[j][2].equalsIgnoreCase("NA")) {
						message+="<tr><td style=\"padding: 10px 0;\"> \r\n"
							    + "<span style=\"display: inline-block;width: 31px;height: 31px;border-radius: 50%;text-align: center; color: "+ac+";margin-right:20px;\r\n"
							    + "font-size: 31px; line-height: 32px;background-color: "+abc+";padding: 10px;vertical-align:top\">"+icon+"</span>\r\n"
							    + "<div style=\"display:inline-block;width:85%;margin-top:0\"><strong style=\"font-size: 16px;\">"+followUp[j][1]+"</strong><br><small  style=\"display: inline-block;font-size: 14px;overflow: hidden;white-space: nowrap;text-overflow: ellipsis;width: 500px;\">"+content+"</small></div>\r\n"
							    + "</td></tr> ";
						}else {
							message+="<tr><td style=\"padding: 10px 0;\"> \r\n"
								    + "<span style=\"display: inline-block;width: 31px;height: 31px;border-radius: 50%;text-align: center; color: "+cc+";margin-right:20px;\r\n"
								    + "font-size: 31px; line-height: 32px;background-color: "+cbc+";padding: 10px;vertical-align:top\">"+icon+"</span>\r\n"
								    + "<div style=\"display:inline-block;width:85%;margin-top:0\"><strong style=\"font-size: 16px;\">"+followUp[j][1]+"</strong><br><small  style=\"display: inline-block;font-size: 14px;overflow: hidden;white-space: nowrap;text-overflow: ellipsis;width: 500px;\">"+content+"</small></div>\r\n"
								    + "</td></tr> ";	
						}
					}
					message+="<tr><td><a href='"+domain+"client_inbox.html?skey="+salesData[i][4]+"&pno="+salesData[i][2]+"&pname="+salesData[i][5]+"&cdate="+salesData[i][6]+"'><button style=\"cursor: pointer;background-color: #2b63f9 ;margin-top:15px;margin-bottom:1rem;color:#fff;padding: 10px 30px;border: 1px solid #2b63f9;border-radius:50px\">Reply</button></a></td></tr>";
					
					}
						    
					message+="             <tr ><td style='text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;'>\n"
							+ "                <b>Project : #"+salesData[i][2]+"</b><br>\n"
							+ "                <p>Address:Corpseed,2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\n"
							+ "    </td></tr>"
							+ "    </table>";
					boolean sendEmail=Enquiry_ACT.saveEmail(contactEmail,"empty",salesData[i][2]+" : Follow-Up Notification | Corpseed", message,2,token);					
					
					
					if(sendEmail) {
						//updating chat not reply email send date
						TaskMaster_ACT.updateSalesEmailSendDate(salesData[i][4],todayDate);
					}
				}				
			}
		}
		//getting active triggers
		String triggers[][]=TaskMaster_ACT.getAllActiveTriggers();
		if(triggers!=null&&triggers.length>0) {
			
			for(int i=0;i<triggers.length;i++) { 
				switch (triggers[i][1]) {
				case "Delivery":
					//getting condition wise query
					tquery=cron_job_ACT.deliveryTrigger(triggers[i][2],triggers[i][4]);									
					if(tquery.toString()!=null&&tquery.toString().length()>0&&!tquery.toString().equalsIgnoreCase("NA")) {
						dquery=new StringBuffer("select dhkey,dhsaleskey,dhcurrentteamkey from deliveryactionhistory where exists(select shmid from saleshierarchymanagectrl where shmsalesrefid=dhsaleskey and shmtoken='"+triggers[i][4]+"') and"+tquery+" and dhjobstatus='1' and dhtoken='"+triggers[i][4]+"' group by dhsaleskey order by dhid");
					}else {
						dquery=new StringBuffer("NA");
					}
//					System.out.println(i+":"+triggers[i][0]+":"+dquery);
					//apply action on condition
					tquery=cron_job_ACT.deliveryActionTrigger(triggers[i][3],triggers[i][4],dquery.toString(),todayDate,addedby);
					if(tquery.toString()!=null&&tquery.toString().length()>0&&!tquery.toString().equalsIgnoreCase("NA")) {
						actQuery=new StringBuffer("update managesalesctrl set"+tquery+" where mstoken='"+triggers[i][4]+"'");
					}else {
						actQuery=new StringBuffer("NA");
					}
					if(!dquery.toString().equalsIgnoreCase("NA")) {
						StringBuffer disableQuery=null;
						//getting all data according query
						String delivery[][]=TaskMaster_ACT.getTriggerConditionsData(dquery.toString());
						if(delivery!=null&&delivery.length>0) {
							for(int j=0;j<delivery.length;j++) {
								if(actQuery.length()>0&&!actQuery.toString().equalsIgnoreCase("NA"))
									TaskMaster_ACT.doTriggerAction(actQuery.toString()+" and msrefid='"+delivery[j][1]+"'");
								
									disableQuery=new StringBuffer("update deliveryactionhistory set dhjobstatus='2' where dhkey='"+delivery[j][0]+"' and dhtoken='"+triggers[i][4]+"'");
									TaskMaster_ACT.doTriggerAction(disableQuery.toString());
								
							}
						}
					}
//					System.out.println(i+":"+triggers[i][0]+":"+actQuery);
					break; 
				
				case "Milestone":
					//getting condition wise query
					tquery=cron_job_ACT.milestoneTrigger(triggers[i][2],triggers[i][4]);					
					if(tquery.toString()!=null&&tquery.toString().length()>0&&!tquery.toString().equalsIgnoreCase("NA")) {
						mquery=new StringBuffer("select maKey,maTaskKey,maSalesKey,maCurrentParentTeamKey,maCurrentTeamMemberUid from milestone_action_history where "+tquery+" and maJobStatus='1' and maToken='"+triggers[i][4]+"' group by maTaskKey order by maId ");
					}else {      
						mquery=new StringBuffer("NA");
					}
//					System.out.println(i+":"+triggers[i][0]+":"+mquery);
					         
					//apply action on condition
					try {
						tquery=cron_job_ACT.milestoneActionTrigger(triggers[i][3],triggers[i][4],mquery.toString(),todayDate,addedby);
					} catch (ParseException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
					if(tquery.toString()!=null&&tquery.toString().length()>0&&!tquery.toString().equalsIgnoreCase("NA")) {
						actQuery=new StringBuffer("update manage_assignctrl set"+tquery+" where matokenno='"+triggers[i][4]+"'");
					}else {
						actQuery=new StringBuffer("NA");
					}	
//					System.out.println(tquery+"\n"+actQuery);
					if(!mquery.toString().equalsIgnoreCase("NA")) {
						StringBuffer disableQuery=null;
						//getting all data according query
						String milestone[][]=TaskMaster_ACT.getTriggerConditionsData(mquery.toString());
						if(milestone!=null&&milestone.length>0) {
							for(int j=0;j<milestone.length;j++) {
								if(actQuery.length()>0&&!actQuery.toString().equalsIgnoreCase("NA"))
									TaskMaster_ACT.doTriggerAction(actQuery.toString()+" and marefid='"+milestone[j][1]+"'");
								
									disableQuery=new StringBuffer("update milestone_action_history set maJobStatus='2' where maKey='"+milestone[j][0]+"' and maToken='"+triggers[i][4]+"'");
									TaskMaster_ACT.doTriggerAction(disableQuery.toString());
								
							}
						}
					}
//					System.out.println(i+":"+triggers[i][0]+":"+actQuery);
					break;

				default:
					break;
				}
			}
		}	
	}


}
