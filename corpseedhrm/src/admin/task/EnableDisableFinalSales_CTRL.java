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
import commons.DateUtil;


@SuppressWarnings("serial")
public class EnableDisableFinalSales_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session=request.getSession();
		PrintWriter pw=response.getWriter();
		
			String hrefid = request.getParameter("hrefid").trim();			
			String salesrefid = request.getParameter("salesrefid").trim();		
			String status = request.getParameter("status").trim();	
			String today=DateUtil.getCurrentDateIndianFormat1();
			String loginuaid = (String)session.getAttribute("loginuaid");
			String token = (String) session.getAttribute("uavalidtokenno");
			String addedby = (String) session.getAttribute("loginuID");
			
			boolean flag=TaskMaster_ACT.updateFinalSalesHierarchy(hrefid,status,token);		
		
			if(flag){
				String salesStatus="Active";
				if(status.equalsIgnoreCase("2"))salesStatus="Inactive";
				//getting sales data before update work status
				String salesData[][]=Enquiry_ACT.getSalesByRefId(salesrefid, token);
				//update status in manage sales
				flag=TaskMaster_ACT.updateSalesActiveStatus(salesrefid,salesStatus,token);
				
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
					if(prevCurrentData[1]!=null&&prevCurrentData[1].equalsIgnoreCase(salesStatus))prevStatus=prevCurrentData[0];
					else if(prevCurrentData[1]!=null) prevStatus=prevCurrentData[1];
					String prevTeamKey="NA";
					if(prevCurrentData[3]!=null&&prevCurrentData[3].equalsIgnoreCase(salesData[0][14]))prevTeamKey=prevCurrentData[2];
					else if(prevCurrentData[3]!=null) prevTeamKey=prevCurrentData[3];
					String prevPriority="NA";
					if(prevCurrentData[5]!=null&&prevCurrentData[5].equalsIgnoreCase(salesData[0][15]))prevPriority=prevCurrentData[4];
					else if(prevCurrentData[5]!=null) prevPriority=prevCurrentData[5];
					//adding data in delivery action history for triggers
					flag=TaskMaster_ACT.saveDeliveryActionHistory(dhKey, salesrefid, deliveryDate, prevStatus, salesStatus, prevTeamKey, salesData[0][14],prevPriority, salesData[0][15], today, token, loginuaid,deliveryTime);
				}					
			}
			if(status.equalsIgnoreCase("1")&&flag) {
			//on active sale disperse amount if available
			//checking on this sale already amount dispersed or not? If not then disperse only
			boolean isDisparsed=TaskMaster_ACT.isAmountDispersed(salesrefid,token);
//			System.out.println("isDisparsed="+isDisparsed);
			if(!isDisparsed) {
				//checking it have parent or not
				String parentKey=TaskMaster_ACT.getParentKey(salesrefid,token);
//				System.out.println("parentKey="+parentKey);
				String invoiceNo=TaskMaster_ACT.getSalesInvoiceNumber(salesrefid, token);
//				System.out.println("invoiceNo="+invoiceNo);
				if(parentKey!=null&&!parentKey.equalsIgnoreCase("NA")) {
					//checking parent's work 100% completed
					boolean workCompleted=TaskMaster_ACT.isProjectCompleted(parentKey,token);
//					System.out.println("workCompleted="+workCompleted);
					if(workCompleted) {
						//updating saleshierarchy status
						TaskMaster_ACT.updateSalesHierarchyOfAssignedMilestone(salesrefid,token);
//						System.out.println("if--going to disperse amount");
						TaskMaster_ACT.disperseAmount(salesrefid, invoiceNo, today, token, addedby,loginuaid);
//						System.out.println("dispersed");
					}
				}else {
//					System.out.println("else--going to disperse amount");
					TaskMaster_ACT.disperseAmount(salesrefid, invoiceNo, today, token, addedby,loginuaid);
//					System.out.println("dispersed");
				}
			}
			//update all assigned milestone's of this project active status
			TaskMaster_ACT.updateAssignTaskHierarchyActiveStatus(salesrefid,"1",token);
			
			}else if(status.equalsIgnoreCase("2")&&flag) {
				//update all assigned milestone's of this project deactive status
				TaskMaster_ACT.updateAssignTaskHierarchyActiveStatus(salesrefid,"2",token);
			}
			String milestones[][]=TaskMaster_ACT.getAllSalesMilestone("NA", salesrefid, token);
			if(milestones!=null&&milestones.length>0){
				String salesStatus="NA";
				for(int k=0;k<milestones.length;k++){
				//checking task all status ok and assigned
				boolean allOk=TaskMaster_ACT.isTaskStatusOk(milestones[k][5],token);
//				System.out.println("allOk=="+allOk);
				if(allOk){
//					String invoice=TaskMaster_ACT.getSalesInvoiceNumber(salesrefid, token);
					//set milestone start date
					boolean existFlag=TaskMaster_ACT.isDisperseExist(salesrefid, token); 				
					double avlPrice=TaskMaster_ACT.getMainDispersedAmount(salesrefid, token);
					double orderAmt=TaskMaster_ACT.getSalesAmount(salesrefid, token);
					double percentage=Double.parseDouble(milestones[k][10]);
					double workPrice=(orderAmt*percentage)/100;
//					System.out.println("existFlag=="+existFlag+"/avlPrice="+avlPrice+"/orderAmt="+orderAmt+"/percentage="+percentage+"/workPrice="+workPrice);
					if(avlPrice>=workPrice&&existFlag){
						String deliveryData[]=TaskMaster_ACT.getTaskDeliveryDate(salesrefid, today, milestones[k][0],token);
						String deliveryDate="NA";
						String deliveryTime="NA";
						if(deliveryData[0]!=null)deliveryDate=deliveryData[0];
						if(deliveryData[1]!=null)deliveryTime=deliveryData[1];
						String date=DateUtil.getCurrentDateIndianReverseFormat();
						String startTime=DateUtil.getCurrentTime24Hours();
						TaskMaster_ACT.updateTaskWorkStartedDate(milestones[k][5],today,token,startTime,deliveryDate,deliveryTime,date);
//						System.out.println("Work started (AssignWorkPercentage-1)");
						salesStatus="3";
					}else {
						salesStatus="1";
						TaskMaster_ACT.updateTaskProgressStatus(milestones[k][5],"1",token);
					}
				}
			}
//				System.out.println("salesStatus=="+salesStatus);
			if(!salesStatus.equalsIgnoreCase("NA"))	
				TaskMaster_ACT.updateProjectStatus(salesrefid,salesStatus,token);
			else if(status.equalsIgnoreCase("1")) {
				
				boolean isOk=TaskMaster_ACT.isTaskInProgress(salesrefid,token);
//				System.out.println("isOk=="+isOk);
				if(isOk)
					TaskMaster_ACT.updateProjectStatus(salesrefid,"3",token);
				else
					TaskMaster_ACT.updateProjectStatus(salesrefid,"1",token);
			}else if(status.equalsIgnoreCase("2")) {
//				System.out.println("inactive sale.......");
				TaskMaster_ACT.updateProjectStatus(salesrefid,"1",token);
			}
				
			}
		if(flag){pw.write("pass");}else{pw.write("fail");}
	}

}