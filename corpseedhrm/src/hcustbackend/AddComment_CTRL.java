package hcustbackend;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import com.oreilly.servlet.MultipartRequest;

import admin.enquiry.Enquiry_ACT;
import admin.master.CloudService;
import admin.master.Usermaster_ACT;
import admin.task.TaskMaster_ACT;
import commons.CommonHelper;
import commons.DateUtil;


public class AddComment_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session=request.getSession();
		
		String today = DateUtil.getCurrentDateIndianFormat1();
		String time=DateUtil.getCurrentTime();
		
		//get addedby by session
		String addedby=(String)session.getAttribute("loginuID");
		//get token no by session
		String token=(String)session.getAttribute("uavalidtokenno");
		String loginuaid = (String) session.getAttribute("loginuaid");
		String addedbyName=Usermaster_ACT.getLoginUserName(loginuaid,token);	
		String followUpKey=RandomStringUtils.random(40,true,true);
		boolean flag=false;
		PrintWriter pw=response.getWriter();
		Path path=null;
		
		try {
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
			String docpath=properties.getProperty("path")+"documents";
			String domain=properties.getProperty("domain");
			
			MultipartRequest m=new MultipartRequest(request,docpath,1024*1024*50);		
			String salesKey=m.getParameter("projectSalesKey").trim();
			String closeDate=Enquiry_ACT.getSalesCloseDate(salesKey, token);
			String clientKey=Enquiry_ACT.getClientKeyBySalesKey(salesKey,token);
			if(closeDate==null||closeDate.equalsIgnoreCase("NA")) {
			
			File file=m.getFile("attachment-file");
			String imgname="NA";
			String size="0 KB";
			String extension=".NA";
			if(file!=null){
				imgname=file.getName();
				file = new File(docpath+"/"+imgname);
				String key =RandomStringUtils.random(20, true, true);
				imgname=imgname.replaceAll("\\s", "-");
				imgname=key+"_"+imgname;
				File newFile = new File(docpath+"/"+imgname);
				file.renameTo(newFile);
				
				CloudService.uploadDocument(newFile, imgname);
				
				//getting file size and extension
				path = Paths.get(docpath+"/"+imgname);
				long bytes=Files.size(path);
				long kb=bytes/1024;
				long mb=kb/1024;	
				
				
				if(mb>=1)size=mb+" MB";
				else if(kb>=1) size=kb+" KB";
				else size=bytes+" bytes";
				int index=imgname.lastIndexOf(".");
				extension=imgname.substring(index);
				}
						
			
			
//			String clientKey=m.getParameter("projectSalesClientKey").trim();
			String msgForUid=m.getParameter("selectedUserUid").trim();
			String msgForName=m.getParameter("selectedUserName").trim();
			String content=m.getParameter("chatReplyBox").trim();
			
//			System.out.println(salesKey+"/"+clientKey+"/"+msgForUid+"/"+msgForName+"/"+content);
			
			if(salesKey!=null&&salesKey.length()>0&&clientKey!=null&&clientKey.length()>0) {
			flag=ClientACT.addTaskFollowUp(followUpKey, salesKey, "NA", "NA", clientKey, content,imgname, today, time, "NA", loginuaid, addedbyName, addedby, token, "NA",msgForUid,msgForName);
			if(flag) {
				//getting sales name,project no and invoice no
				String salesData[]=TaskMaster_ACT.getSalesData(salesKey,token);
				//getting primary contact data
				String contactData[]=Enquiry_ACT.getClientContactByKey(salesData[3], token);
				
				//add chat thread
				String taskKey=RandomStringUtils.random(40,true,true);				
				String subject="Public Reply";
				String userName=Usermaster_ACT.getLoginUserName(loginuaid, token);
				//adding notification in sales task-notification
				flag=TaskMaster_ACT.setTaskNotification(taskKey,salesKey,salesData[0],salesData[1],salesData[2],"Public Reply","public_reply.png",contactData[0],contactData[1],contactData[2],loginuaid,userName,today+" "+time,subject,content,addedby,token,msgForUid,"Admin",msgForName,"NA","NA");
				
				
				//getting project no
				String invoiceNo=TaskMaster_ACT.getinvoiceNoByKey(salesKey,token);
				String message="You have new message on invoice. : "+invoiceNo+"  by &nbsp;<span class='text-muted'>"+userName+"</span>";			
				
				//saving to user_notification
				String uKey=RandomStringUtils.random(40,true,true);
				TaskMaster_ACT.saveUserNotification(uKey,today,msgForUid,"mytask.html","far fa-comment-alt",loginuaid,message,token,DateUtil.getCurrentTime24Hours(),salesKey);
				
				String status=Usermaster_ACT.getLoginStatus(msgForUid);
				if(status.equalsIgnoreCase("2")) {
															
					//getting chat not replied details
					String[][] followUpSalesData=TaskMaster_ACT.getSalesDataFollowUp(salesKey,token);
					if(salesData!=null&&salesData.length>0) {
							String contactEmail=Usermaster_ACT.getUserEmail(msgForUid, token);
							if(!contactEmail.equalsIgnoreCase("NA")) {								
								//going to send email
								String abc="#FCE9EF";
								String ac="#CB6C8C";
								String cbc="#d8e2dc";
								String cc="#838985";
								
								String message1="<table border=\"0\" style=\"margin:0 auto; width:700px;min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\n"
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
										+ "            Hi "+msgForName+",</td></tr>\n"
										+ "             <tr>\n"
										+ "                    <td style='padding: 10px 0 15px;color: #353637;'> \n"
										+ "                     <p> You have pending Follow-Up on Invoice <b>"+followUpSalesData[0][7]+"</b>. Reply by clicking below reply button.\n"
										+ "                      </p>\n"
										+ "                    </td></tr>";	
										
								String followUp[][]=TaskMaster_ACT.getLastFiveFollowUp(followUpSalesData[0][4],msgForUid);
								if(followUp!=null&&followUp.length>0) {
								for(int j=followUp.length-1;j>=0;j--) {
									String icon=followUp[j][1].substring(0,1).toUpperCase();
									
									String contentData=followUp[j][0].replace("<p>", "");
									contentData=contentData.replace("</p>", "");
															
								if(followUp[j][2]==null||followUp[j][2].equalsIgnoreCase("NA")) {
									message+="<tr><td style=\"padding: 10px 0;\"> \r\n"
										    + "<span style=\"display: inline-block;width: 31px;height: 31px;border-radius: 50%;text-align: center; color: "+ac+";margin-right:20px;\r\n"
										    + "font-size: 31px; line-height: 32px;background-color: "+abc+";padding: 10px;vertical-align:top\">"+icon+"</span>\r\n"
										    + "<div style=\"display:inline-block;width:85%;margin-top:0\"><strong style=\"font-size: 16px;\">"+followUp[j][1]+"</strong><br><small  style=\"display: inline-block;font-size: 14px;overflow: hidden;white-space: nowrap;text-overflow: ellipsis;width: 500px;\">"+contentData+"</small></div>\r\n"
										    + "</td></tr> ";
									}else {
										message+="<tr><td style=\"padding: 10px 0;\"> \r\n"
											    + "<span style=\"display: inline-block;width: 31px;height: 31px;border-radius: 50%;text-align: center; color: "+cc+";margin-right:20px;\r\n"
											    + "font-size: 31px; line-height: 32px;background-color: "+cbc+";padding: 10px;vertical-align:top\">"+icon+"</span>\r\n"
											    + "<div style=\"display:inline-block;width:85%;margin-top:0\"><strong style=\"font-size: 16px;\">"+followUp[j][1]+"</strong><br><small  style=\"display: inline-block;font-size: 14px;overflow: hidden;white-space: nowrap;text-overflow: ellipsis;width: 500px;\">"+contentData+"</small></div>\r\n"
											    + "</td></tr> ";	
									}
								}
								message+="<tr><td><a href='"+domain+"mytask.html'><button style=\"cursor: pointer;background-color: #2b63f9 ;margin-top:15px;margin-bottom:1rem;color:#fff;padding: 10px 30px;border: 1px solid #2b63f9;border-radius:50px\">Reply</button></a></td></tr>";
								
								}
									    
								message+="             <tr ><td style='text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;'>\n"
										+ "                <b>Project : #"+followUpSalesData[0][2]+"</b><br>\n"
										+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\n"
										+ "    </td></tr>"
										+ "    </table>";
								Enquiry_ACT.saveEmail(contactEmail,"empty",followUpSalesData[0][2]+" : Follow-Up Notification | Corpseed", message,2,token);					
																
							}				
						
					}
					
				}
				String milestone[][]=null;
				String maid=ClientACT.getLastAssignedMilestone(salesKey,msgForUid,token);
				if(maid!=null) {	
				
				//getting all assigned milestone data
				milestone=TaskMaster_ACT.getClientAssignedSalesMilestone(maid);	
				if(milestone!=null&&milestone.length>0) {	
					int i=0;
					 String date=milestone[i][15];
					 String mtime=milestone[i][16];
					 String workStatus=milestone[i][9];
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
						
						long hhmm[]=TaskMaster_ACT.getTaskHHMM(column_hh,column_mm,milestone[i][5],salesKey,milestone[i][2],token);
						
						if(!column_hh.equals("NA")&&!column_mm.equals("NA")) {
							long hours=hourMinutes[1]+hhmm[0];
							long minutes=hourMinutes[0]+hhmm[1];
							
							if(minutes>60) {
								long hour=(minutes/60);
								hours+=hour;
								minutes=(minutes-(hour*60));
							}
							
							TaskMaster_ACT.updateTaskProgress(column_hh,column_mm,hours,minutes,milestone[i][5],salesKey,milestone[i][2],token);
						}
					}
				}
				//updating milestone status open
				ClientACT.updateMilestonesStatusOpen(maid,token,DateUtil.getCurrentDateIndianReverseFormat(),DateUtil.getCurrentTime24Hours());
				}
				//increasing unseen status
				ClientACT.updateChatUnseenStatus(salesKey,token);
				
				//add data in milestone action history
				if(flag&&milestone!=null&&milestone.length>0){
					int i=0;
					String prevParentTeamKey="NA";
					String prevChildTeamKey="NA";
					String prevTeamMemberUid="NA";
					String prevWorkStatus="NA";
					String pervWorkPriority="NA";
					String userPost="NA";
					String prevUserPost="NA";
					if(!milestone[i][2].equalsIgnoreCase("NA")) {
						userPost=Usermaster_ACT.getUserPost(milestone[i][2],token);
						if(!userPost.equalsIgnoreCase("Delivery manager")) {
							String teamLeaderUid=TaskMaster_ACT.getTeamLeaderId(milestone[i][13], token);
							if(milestone[i][2].equalsIgnoreCase(teamLeaderUid)&&!teamLeaderUid.equalsIgnoreCase("NA"))userPost="Team Leader";
						}
					}					
					
					String prevCurrMilestoneData[]=TaskMaster_ACT.getPrevCurrMilestoneDataByKey(milestone[i][5],token);
					if(prevCurrMilestoneData[0]!=null) {
						if(prevCurrMilestoneData[1].equalsIgnoreCase(milestone[i][13]))prevParentTeamKey=prevCurrMilestoneData[0];
						else prevParentTeamKey=prevCurrMilestoneData[1];
						
						if(prevCurrMilestoneData[3].equalsIgnoreCase(milestone[i][6]))prevChildTeamKey=prevCurrMilestoneData[2];
						else prevChildTeamKey=prevCurrMilestoneData[3];
						
						if(prevCurrMilestoneData[5].equalsIgnoreCase(milestone[i][2]))prevTeamMemberUid=prevCurrMilestoneData[4];
						else prevTeamMemberUid=prevCurrMilestoneData[5];
						
						if(prevCurrMilestoneData[7].equalsIgnoreCase("Open"))prevWorkStatus=prevCurrMilestoneData[6];
						else prevWorkStatus=prevCurrMilestoneData[7];
						
						if(prevCurrMilestoneData[9].equalsIgnoreCase(milestone[i][12]))pervWorkPriority=prevCurrMilestoneData[8];
						else pervWorkPriority=prevCurrMilestoneData[9];
						
						if(prevCurrMilestoneData[11].equalsIgnoreCase(userPost))prevUserPost=prevCurrMilestoneData[10];
						else prevUserPost=prevCurrMilestoneData[11];
											
						String mKey=RandomStringUtils.random(40,true,true);
						String salesName=Enquiry_ACT.getSalesProductName(salesKey, token);
//						String deliveryDate=TaskMaster_ACT.getMilestoneDeliveryDate(salesKey,milestone[i][11], milestone[i][0],stepNo,token);
						flag=TaskMaster_ACT.saveMilestoneActionHistory(mKey,milestone[i][5],salesKey,salesName,prevParentTeamKey,milestone[i][13],prevChildTeamKey,milestone[i][6],prevTeamMemberUid,milestone[i][2],prevWorkStatus,"Open",pervWorkPriority,milestone[i][12],milestone[i][14],today,token,prevUserPost,userPost,milestone[i][17]);
					}
				}
				
			}
			}	
			
				if(flag)pw.write("pass#"+size+"#"+extension+"#"+imgname);
				else pw.write("fail");
			}else {
				pw.write("denied");
			}
			}catch(Exception e) {
				e.printStackTrace();
			}
			
	}

}
