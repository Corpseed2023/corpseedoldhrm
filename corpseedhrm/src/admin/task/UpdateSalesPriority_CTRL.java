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
public class UpdateSalesPriority_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session=request.getSession();
		PrintWriter pw=response.getWriter();
		String today=DateUtil.getCurrentDateIndianFormat1();
		String loginuaid = (String)session.getAttribute("loginuaid");
		
		boolean flag=false;
			String salesrefid = request.getParameter("salesrefid").trim();
			String Priority = request.getParameter("Priority").trim();			
			String token= (String)session.getAttribute("uavalidtokenno");
			try {
			if(salesrefid!=null&&salesrefid.length()>0) {
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
					if(prevCurrentData[1]!=null&&prevCurrentData[1].equalsIgnoreCase(salesData[0][13]))prevStatus=prevCurrentData[0];
					else if(prevCurrentData[1]!=null) prevStatus=prevCurrentData[1];
					String prevTeamKey="NA";
					if(prevCurrentData[3]!=null&&prevCurrentData[3].equalsIgnoreCase(salesData[0][14]))prevTeamKey=prevCurrentData[2];
					else if(prevCurrentData[3]!=null) prevTeamKey=prevCurrentData[3];
					String prevPriority="NA";
					if(prevCurrentData[5]!=null&&prevCurrentData[5].equalsIgnoreCase(Priority))prevPriority=prevCurrentData[4];
					else if(prevCurrentData[5]!=null) prevPriority=prevCurrentData[5];
					//adding data in delivery action history for triggers
					flag=TaskMaster_ACT.saveDeliveryActionHistory(dhKey, salesrefid, deliveryDate, prevStatus, salesData[0][13], prevTeamKey, salesData[0][14], prevPriority, Priority, today, token, loginuaid,deliveryTime);
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
			}
			
		 if(flag)pw.write("pass");
			else pw.write("fail");
			}catch(Exception e) {
				e.printStackTrace();
			}
	}

}