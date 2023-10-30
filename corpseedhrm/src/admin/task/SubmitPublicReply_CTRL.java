package admin.task;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import com.azure.storage.blob.BlobClientBuilder;
import com.oreilly.servlet.MultipartRequest;

import admin.enquiry.Enquiry_ACT;
import admin.master.Usermaster_ACT;
import client_master.Clientmaster_ACT;
import commons.AzureBlob;
import commons.CommonHelper;
import commons.DateUtil;
import hcustbackend.ClientACT;

public class SubmitPublicReply_CTRL extends HttpServlet {	
	
	private static final long serialVersionUID = -8868020792105662794L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 PrintWriter pw=response.getWriter();
		 Path path=null;
		 
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String loginuID = (String) session.getAttribute("loginuID");		
		String today=DateUtil.getCurrentDateIndianFormat1();
		String time=DateUtil.getCurrentTime();
		String uaid = (String) session.getAttribute("loginuaid");
		String userName=Usermaster_ACT.getLoginUserName(uaid, uavalidtokenno);
		
		boolean flag=false;
		String imgname="NA";
		String size="0 KB";
		String extension=".NA";
		try {
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
			String docpath=properties.getProperty("path")+"documents";
			String azure_key=properties.getProperty("azure_key");
			String azure_path=properties.getProperty("azure_path");
			String domain=properties.getProperty("domain");
			String azure_container=properties.getProperty("azure_container");
			
		MultipartRequest m=new MultipartRequest(request,docpath,1024*1024*50);		
					
			File file=m.getFile("AttachChatFile");
			
			
			if(file!=null){
				imgname=file.getName();
				file = new File(docpath+File.separator+imgname);
				String key =RandomStringUtils.random(20, true, true);
				imgname=imgname.replaceAll("\\s", "-");
				imgname=key+"_"+imgname;
				File newFile = new File(docpath+File.separator+imgname);
				file.renameTo(newFile);
				
				BlobClientBuilder client=AzureBlob.getBlobClient(azure_key, azure_container);
		        client.connectionString(azure_key);
		        client.containerName(azure_container);
		        InputStream targetStream = new FileInputStream(newFile);
		        client.blobName(imgname).buildClient().upload(targetStream,newFile.length());
				
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
		        
		        
//				targetStream.close();
//				newFile.delete();
				} 
			
			String content=m.getParameter("BoxContent");
			String submitStatus=m.getParameter("submitStatus");
			String milestoneData=m.getParameter("milestoneDataBox");
			String salesrefId=m.getParameter("salesrefId");
			String clientrefId=m.getParameter("clientrefId");
			String formDataJson=m.getParameter("formDataJson");
			String deliveryDate=m.getParameter("deliveryDate");
			String newDeliveryDate=m.getParameter("newDeliveryDate");
			String dynamicFormDataName=m.getParameter("dynamicFormDataName");
			String assigneeUId=m.getParameter("assigneeUId");
			String marefid=m.getParameter("marefid");
			String extendComment=m.getParameter("extendComment");
						
			long diffDays=0;
			String milestoneKey="NA";
			String milestoneName="NA";
			String prevDeliveryTime="NA";
			String newDeliveryTime="NA";
			long totalMinutes=0;
			if(milestoneData!=null&&!milestoneData.equalsIgnoreCase("NA")&&milestoneData.length()>0) {
				String x[]=milestoneData.split("#");
				milestoneKey=x[0];
				milestoneName=x[1];
			}
//			System.out.println(deliveryDate+"#"+newDeliveryDate);
			String key=RandomStringUtils.random(40,true,true);
			if(!deliveryDate.equalsIgnoreCase(newDeliveryDate)) {	
				prevDeliveryTime=deliveryDate.substring(deliveryDate.indexOf("T")+1);
				newDeliveryTime=newDeliveryDate.substring(newDeliveryDate.indexOf("T")+1);
				deliveryDate=deliveryDate.substring(0,deliveryDate.indexOf("T"));
				newDeliveryDate=newDeliveryDate.substring(0,newDeliveryDate.indexOf("T"));
				
				diffDays=DateUtil.getDaysBetweenTwoDates(deliveryDate, newDeliveryDate);
			
				SimpleDateFormat simpleDateFormat= new SimpleDateFormat("HH:mm");
				String time1 = prevDeliveryTime;
				String time2 = newDeliveryTime;
				Date date1 = simpleDateFormat.parse(time1);
				Date date2 = simpleDateFormat.parse(time2);
				long differenceInMilliSeconds= Math.abs(date2.getTime() - date1.getTime());
				long differenceInMinutes= (differenceInMilliSeconds / (60 * 1000)) % 60;
				long differenceInHours= (differenceInMilliSeconds / (60 * 60 * 1000))% 24;
				
				if(((differenceInHours*60)+differenceInMinutes)>0) {				
					totalMinutes=((differenceInHours*60)+differenceInMinutes);
					int compareTo = date2.compareTo(date1);
					if(compareTo<0)totalMinutes=totalMinutes-(totalMinutes*2);
				}				
//				System.out.println("days=="+diffDays);				
			}
			
			if((diffDays>0 || totalMinutes>0)&&!milestoneKey.equalsIgnoreCase("NA")){								
				//extending days of milestone delivery
//				System.out.println("Difference_Days="+diffDays+"#"+totalMinutes+"#"+milestoneKey);
				
				TaskMaster_ACT.extendMilestoneDeliveryDate(diffDays,milestoneKey,uavalidtokenno,totalMinutes);
				newDeliveryDate=newDeliveryDate.substring(8)+newDeliveryDate.substring(4,8)+newDeliveryDate.substring(0,4);
				TaskMaster_ACT.updateAssignTaskDeliveryDate(salesrefId,milestoneKey,newDeliveryDate,uavalidtokenno,newDeliveryTime);
//				System.out.println("extendCommentextendComment="+extendComment);
				//creating date extend record
				if(!extendComment.equalsIgnoreCase("NA"))
				TaskMaster_ACT.saveMilestoneExtendRecord(marefid,DateUtil.getCurrentDateIndianReverseFormat(),extendComment,uavalidtokenno,uaid);
				
				//getting last milestone key 
				String lastMilestoneKey=TaskMaster_ACT.getLastMilestoneKey(salesrefId,uavalidtokenno);
				
				//getting milestone step no
				int stepNo=TaskMaster_ACT.getMilestoneStep(salesrefId, milestoneKey, uavalidtokenno);
				String milestones[][]=TaskMaster_ACT.getAllSalesMilestoneKeyData(salesrefId, stepNo, uavalidtokenno);
				if(milestones!=null&&milestones.length>0) {
					for(int i=0;i<milestones.length;i++) {
						//extending delivery days
						TaskMaster_ACT.extendMilestoneDeliveryDate(diffDays,milestones[i][0],uavalidtokenno,totalMinutes);
						String memberassigndate=TaskMaster_ACT.getTaskAssignedDate(salesrefId,milestones[i][0],uavalidtokenno);
						String newTaskDeliveryData[]=TaskMaster_ACT.getMilestoneDeliveryDate(salesrefId,memberassigndate, milestones[i][0], Integer.parseInt(milestones[i][1]), uavalidtokenno);
						String newTaskDeliveryDate="NA";
						String newTaskDeliveryTime="NA";
						if(newTaskDeliveryData[0]!=null)newTaskDeliveryDate=newTaskDeliveryData[0];
						if(newTaskDeliveryData[1]!=null)newTaskDeliveryTime=newTaskDeliveryData[1];
						//updating milestone delivery date
						TaskMaster_ACT.updateAssignTaskDeliveryDate(salesrefId,milestones[i][0],newTaskDeliveryDate,uavalidtokenno,newTaskDeliveryTime);
						
//						System.out.println("1=="+newTaskDeliveryDate+"#"+newTaskDeliveryTime);
						
						if(milestones[i][0].equalsIgnoreCase(lastMilestoneKey))
							TaskMaster_ACT.updateSalesDeliveryDateAndTime(newTaskDeliveryDate,newTaskDeliveryTime,salesrefId,uavalidtokenno);
					}					
				}else if(milestoneKey.equalsIgnoreCase(lastMilestoneKey)){
//					System.out.println("2=="+newDeliveryDate+"#"+newDeliveryTime);
					TaskMaster_ACT.updateSalesDeliveryDateAndTime(newDeliveryDate,newDeliveryTime,salesrefId,uavalidtokenno);
				}
			}
			
			flag=TaskMaster_ACT.addTaskFollowUp(key,salesrefId,milestoneKey,milestoneName,clientrefId,content,imgname,today,time,submitStatus,uaid,userName,loginuID,uavalidtokenno,formDataJson,dynamicFormDataName);
			String clientUid=ClientACT.getClientIdByKey(clientrefId, uavalidtokenno);
			String clientName=Clientmaster_ACT.getClientName(clientUid, uavalidtokenno);
			String clientEmail=Clientmaster_ACT.getClientEmail(clientUid, uavalidtokenno);
			if(flag) { 

				//increase sales unseen status
				flag=TaskMaster_ACT.updateUnseenStatus(salesrefId,uavalidtokenno);
				
				//checking previous chat client replied or not
				boolean flag1=TaskMaster_ACT.checkClientNotRepliedStatus(salesrefId,uavalidtokenno);
				if(flag1) {					
					TaskMaster_ACT.updateChatNOtReply(salesrefId,today,uavalidtokenno,DateUtil.getCurrentTime24Hours());
				}
				//getting all assigned milestone data
				String milestone[][]=TaskMaster_ACT.getAssignedSalesMilestone(salesrefId,milestoneKey,uavalidtokenno);
				
				String dateTime[]=TaskMaster_ACT.getTaskDateTime(salesrefId,milestoneKey,uavalidtokenno);
				
				//update assign milestone status
				flag=TaskMaster_ACT.updateMilestoneStatus(salesrefId,milestoneKey, submitStatus, uavalidtokenno,DateUtil.getCurrentDateIndianReverseFormat(),DateUtil.getCurrentTime24Hours());
				
				//add data in milestone action history
				if(flag&&milestone!=null&&milestone.length>0){				
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
				if(submitStatus.equalsIgnoreCase("On-hold")) {
					String type=m.getParameter("type");
					String reason=m.getParameter("reason");
					String hkey=RandomStringUtils.random(40,true,true);
					String date=DateUtil.getCurrentDateIndianReverseFormat();
					String time1=DateUtil.getCurrentTime24Hours();
					TaskMaster_ACT.saveTaskHoldData(hkey,marefid,type,date,time1,reason,uavalidtokenno);
					
				}
//				System.out.println("going to check project completed");
				if(submitStatus.equalsIgnoreCase("Completed")) {
					double salesProgress=Enquiry_ACT.getSalesWorkProgress(salesrefId,uavalidtokenno);
					boolean statusFlag=TaskMaster_ACT.isAllTaskStatusCompleted(salesrefId,uavalidtokenno);
//					System.out.println(salesProgress+"#"+statusFlag);
					if(salesProgress==100&&statusFlag) {
						String closeDate=DateUtil.getCurrentDateIndianReverseFormat();
						TaskMaster_ACT.closeProject(salesrefId,uavalidtokenno,closeDate);
						
						String salesData[]=TaskMaster_ACT.getSalesData(salesrefId, uavalidtokenno);
						//sending email to client : successfully order completed			
						String message1="<table border=\"0\" style=\"margin:0 auto; width:700px;min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\n"
								+ "        <tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\n"
								+ "                <a href=\"#\" target=\"_blank\">\n"
								+ "                <img src=\"https://corpseed.com/assets/img/logo.png\"></a>\n"
								+ "            </td></tr>\n"
								+ "            <tr>\n"
								+ "              <td style=\"text-align: center;\">\n"
								+ "                <h1>ORDER COMPLETED</h1>"
								+ "              </td></tr>"
								+ "        <tr>\n"
								+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\n"
								+ "            Hi "+clientName+",</td></tr>"
								+ "             <tr>\n"
								+ "                    <td style=\"padding: 10px 0 15px;color: #353637;\"> \n"
								+ "                     <p>Thanks for choosing Corpseed to complete your service requirement.</p>\n"
								+ "                     <p>"+salesData[0]+" : <a href=\""+domain+"viewalldocuments-"+salesrefId+".html\">Use this link to download certificate</a></p>\n"
								+ "                     <p>Please note and review the files which contains information provided to fulfill your order. If any information is inaccurate please contact us.</a></p>\n"
								+ "                     <p>Use this <a href=\""+domain+"client_inbox.html?skey="+salesrefId+"&pno="+salesData[1]+"&pname="+salesData[0]+"&cdate="+salesData[8]+"\" to give us your valuable feedback for the service.</a></p>\n"
								+ "                    </td></tr>"							
								+ "             <tr ><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\n"
								+ "                <b>Invoice #"+salesData[2]+"</b><br>\n"
								+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\n"
								+ "    </td></tr> \n"
								+ "    </table>";
						
						if(clientEmail!=null&&!clientEmail.equalsIgnoreCase("NA")&&clientEmail.length()>5)
						Enquiry_ACT.saveEmail(clientEmail,"empty",""+salesData[0]+" completed", message1,2,uavalidtokenno);
						
					//send email to seller
						String seller[][]=Usermaster_ACT.getUserByID(salesData[6]);
						if(seller.length>0) {
						String sellerName=seller[0][5];
						String sellerEmail=seller[0][7];
						String sellerManagerUaid=TaskMaster_ACT.getSellerManagerUaid(salesData[6]);	
						String sellerManagerEmail="empty";
						if(sellerManagerUaid!=null&&!sellerManagerUaid.equalsIgnoreCase("NA")&&!sellerManagerEmail.equalsIgnoreCase(salesData[6]))
							sellerManagerEmail=Usermaster_ACT.getUserEmail(sellerManagerUaid, uavalidtokenno);
						
						String sellerMessage="<table border=\"0\" style=\"margin:0 auto; width:700px;min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\n"
								+ "        <tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\n"
								+ "                <a href=\"#\" target=\"_blank\">\n"
								+ "                <img src=\"https://corpseed.com/assets/img/logo.png\"></a>\n"
								+ "            </td></tr>\n"
								+ "            <tr>\n"
								+ "              <td style=\"text-align: center;\">\n"
								+ "                <h1>ORDER COMPLETED</h1>"
								+ "              </td></tr>"
								+ "        <tr>\n"
								+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\n"
								+ "            Hi "+sellerName+",</td></tr>"
								+ "             <tr>\n"
								+ "                    <td style=\"padding: 10px 0 15px;color: #353637;\"> \n"
								+ "                     <p>"+salesData[1]+" : "+salesData[0]+" is completed.</p>\n"
								+ "                     <p>Please proceed if any dues otherwise ignore this email.</p>\n"
								+ "                    </td></tr>"							
								+ "             <tr ><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\n"
								+ "                <b>Invoice #"+salesData[2]+"</b><br>\n"
								+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\n"
								+ "    </td></tr> \n"
								+ "    </table>";
						
						if(sellerEmail!=null&&!sellerEmail.equalsIgnoreCase("NA")&&sellerEmail.length()>5)
						 Enquiry_ACT.saveEmail(sellerEmail,sellerManagerEmail,""+salesData[1]+" : "+salesData[0]+" completed", sellerMessage,2,uavalidtokenno);
						
						//+++++++++++++++++++++++send email to account person+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						Enquiry_ACT.saveEmail("praveen.kumar@corpseed.com","praveen.kumar@corpseed.com",""+salesData[1]+" : "+salesData[0]+" completed", sellerMessage,2,uavalidtokenno);

						//send notification to client and seller
						String nKey=RandomStringUtils.random(40,true,true);
						String message=salesData[1]+" : "+salesData[0]+" is completed. Please proceed if any dues.";
						TaskMaster_ACT.addNotification(nKey,today,salesData[6],"2","manage-sales.html",message,uavalidtokenno,uaid,"far fa-check-circle");
						}
						
				}
					}
				//add notification
				
				//getting sales name,project no and invoice no
				String salesData[]=TaskMaster_ACT.getSalesData(salesrefId,uavalidtokenno);
				
				//getting primary contact data
				String contactData[]=Enquiry_ACT.getClientContactByKey(salesData[3], uavalidtokenno);
				
				//add chat thread
				String taskKey=RandomStringUtils.random(40,true,true);				
				String subject="Public Reply";
				
				//set notification task assigned to team leader	
				flag=TaskMaster_ACT.setTaskNotification(taskKey,salesrefId,salesData[0],salesData[1],salesData[2],"Public Reply","public_reply.png",contactData[0],contactData[1],contactData[2],uaid,userName,today+" "+time,subject,content,loginuID,uavalidtokenno,clientUid,"Client",clientName,submitStatus,"NA");
			
				//adding notification
//				String nKey=RandomStringUtils.random(40,true,true);
//				String url="client_inbox.html?skey="+salesrefId+"&pno="+salesData[1]+"&pname="+salesData[0]+"&cdate="+salesData[8];
//				String message="You have new follow-up on project <span class=\"text-info\">"+salesData[1]+" : "+salesData[0]+"</span>";
//				TaskMaster_ACT.addNotification(nKey,today,clientUid,"1",url,message,uavalidtokenno,uaid,"far fa-check-circle");
				
				if(dateTime[0]!=null&&dateTime[1]!=null&&!dateTime[0].equalsIgnoreCase("NA")&&
						!dateTime[1].equalsIgnoreCase("NA")&&!submitStatus.equalsIgnoreCase("Completed")) {
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
					
					long hhmm[]=TaskMaster_ACT.getTaskHHMM(column_hh,column_mm,marefid,salesrefId,assigneeUId,uavalidtokenno);
					
					if(!column_hh.equals("NA")&&!column_mm.equals("NA")) {
						long hours=hourMinutes[1]+hhmm[0];
						long minutes=hourMinutes[0]+hhmm[1];
						
						if(minutes>60) {
							long hour=(minutes/60);
							hours+=hour;
							minutes=(minutes-(hour*60));
						}
						
						TaskMaster_ACT.updateTaskProgress(column_hh,column_mm,hours,minutes,marefid,salesrefId,assigneeUId,uavalidtokenno);
					}
				}
				//removing client reply
				TaskMaster_ACT.removeUserNotification(salesrefId,uaid,uavalidtokenno);
				//checking client is active or not, If not send email
				String clientNo=Clientmaster_ACT.getClientNumberByKey(clientrefId, uavalidtokenno);
				int loginStatus=Usermaster_ACT.getLoginStatus(clientNo, uavalidtokenno);
				if(loginStatus==2) {					
					//getting chat not replied details
					String[][] followUpSalesData=TaskMaster_ACT.getSalesDataFollowUp(salesrefId,uavalidtokenno);
					if(salesData!=null&&salesData.length>0) {
							String contact=TaskMaster_ACT.getContactEmail(followUpSalesData[0][1]);
							if(!contact.equalsIgnoreCase("NA")) {
								String x[]=contact.split("#");
								String contactName=x[0];
								String contactEmail=x[1];
								//going to send email
//								String content="Hey, "+contactName+"<br>You haven replied on our team, Please <a href='https://corpseed-crm.azurewebsites.net/client_inbox.html'>login here</a> and send your valuable reply.";
//								boolean sendEmail =Enquiry_ACT.saveEmail(contactEmail,"empty","Corpseed follow-up notification", content,2,token);
								String abc="#FCE9EF";
								String ac="#CB6C8C";
								String cbc="#d8e2dc";
								String cc="#838985";
								
								String message="<table border=\"0\" style=\"margin:0 auto; width:700px;min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\n"
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
										+ "                     <p> You have pending Follow-Up on Project <b>"+followUpSalesData[0][2]+"</b>. Reply by clicking below reply button.\n"
										+ "                      </p>\n"
										+ "                    </td></tr>";	
										
								String followUp[][]=TaskMaster_ACT.getLastFiveFollowUp(followUpSalesData[0][4]);
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
								message+="<tr><td><a href='"+domain+"client_inbox.html?skey="+followUpSalesData[0][4]+"&pno="+followUpSalesData[0][2]+"&pname="+followUpSalesData[0][5]+"&cdate="+followUpSalesData[0][6]+"'><button style=\"cursor: pointer;background-color: #2b63f9 ;margin-top:15px;margin-bottom:1rem;color:#fff;padding: 10px 30px;border: 1px solid #2b63f9;border-radius:50px\">Reply</button></a></td></tr>";
								
								}
									    
								message+="             <tr ><td style='text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;'>\n"
										+ "                <b>Project : #"+followUpSalesData[0][2]+"</b><br>\n"
										+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\n"
										+ "    </td></tr>"
										+ "    </table>";
								Enquiry_ACT.saveEmail(contactEmail,"empty",followUpSalesData[0][2]+" : Follow-Up Notification | Corpseed", message,2,uavalidtokenno);					
																
							}				
						
					}
					
				}
				
			}
			String docname="NA";
			if(!imgname.equals("NA")) {
				docname=imgname.substring(imgname.indexOf("_")+1);
			}
			if(flag)pw.write("pass#"+azure_path+imgname+"#"+size+"#"+extension+"#"+docname+"#"+key);
			else pw.write("fail");
		}catch(Exception e) {
			e.printStackTrace();
		}
	}

}