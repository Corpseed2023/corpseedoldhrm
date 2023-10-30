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
import commons.CommonHelper;
import commons.DateUtil;

public class SubmitFinalSalesHierarchy_CTRL extends HttpServlet {	
	/**
	 * 
	 */
	private static final long serialVersionUID = -7246563137834711804L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
	try {
		HttpSession session = request.getSession();
		 
		PrintWriter pw=response.getWriter();
		 boolean flag=false; 
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String loginuID = (String) session.getAttribute("loginuID");	
		String loginuaid = (String)session.getAttribute("loginuaid");
		String today=DateUtil.getCurrentDateIndianFormat1();
		String invoiceno = request.getParameter("invoiceno").trim();	
		String paymentMode=Enquiry_ACT.getPaymentModeByInvoice(invoiceno, uavalidtokenno);
				
		String hierarchy[][]=TaskMaster_ACT.getAllSalesHierarchy(invoiceno,uavalidtokenno,loginuID);
		if(hierarchy!=null&&hierarchy.length>0){
			String parentkey="NA";
			for(int i=0;i<hierarchy.length;i++){				
				if(i==Double.parseDouble(hierarchy[i][3])&&hierarchy[i][2].equalsIgnoreCase("parent")){
					parentkey=hierarchy[i][1];
					//inserting into main hierarchy table as parent 
//					System.out.println("going to insert into sales hierarchy");
					boolean isExist=TaskMaster_ACT.isSalesHierarchyDoneBySalesKey(hierarchy[i][1], uavalidtokenno);
					if(!isExist)
					flag=TaskMaster_ACT.saveParentsHierarchy(today,hierarchy[i][0],invoiceno,parentkey,hierarchy[i][2],hierarchy[i][4],uavalidtokenno,loginuID);
//					System.out.println(flag+"Parent : "+parentkey+"/"+hierarchy[i][2]+"/"+hierarchy[i][3]);
					//update sales parent hierarchy status 1
					flag=TaskMaster_ACT.updateAssignTaskHierarchyStatus(hierarchy[i][1],uavalidtokenno);
				}else if(hierarchy[i][2].equalsIgnoreCase("child")){
					//inserting into main hierarchy table as child						salesrefid
					boolean isExist=TaskMaster_ACT.isSalesHierarchyDoneBySalesKey(hierarchy[i][1], uavalidtokenno);
					if(!isExist)
					flag=TaskMaster_ACT.saveChildsHierarchy(today,hierarchy[i][0],invoiceno,hierarchy[i][1],parentkey,hierarchy[i][2],hierarchy[i][4],uavalidtokenno,loginuID);
//					System.out.println("Child : "+hierarchy[i][1]+"/"+parentkey+"/"+hierarchy[i][2]+"/"+hierarchy[i][3]);					
				}
				String currentWorkStatus="Inactive";
				//getting sales data before update work status
//				System.out.println("going to fetch sales data.....");
				String salesData[][]=Enquiry_ACT.getSalesByRefId(hierarchy[i][1], uavalidtokenno);
				//update sales active status
				if(hierarchy[i][4].equalsIgnoreCase("1")){
					flag=TaskMaster_ACT.updateSalesActiveStatus(hierarchy[i][1],"Active",uavalidtokenno);
				//update sales hierarchy active status
					flag=TaskMaster_ACT.updateAssignTaskHierarchyActiveStatus(hierarchy[i][1],"1",uavalidtokenno);					
					currentWorkStatus="Active";
				}
				String dhKey=RandomStringUtils.random(40,true,true);				
				if(salesData!=null&&salesData.length>0) {
					int totalDay=0;
					int minutes=0;
					int data[]=TaskMaster_ACT.getTotalMilestoneDays(hierarchy[i][1], uavalidtokenno);
					totalDay=data[0];
					minutes=data[1];
					
					String deliveryData[]=DateUtil.getLastDate(salesData[0][12], totalDay,minutes);
					String deliveryDate="NA";
					String deliveryTime="NA";
					if(deliveryData[0]!=null)deliveryDate=deliveryData[0];
					if(deliveryData[1]!=null)deliveryTime=deliveryData[1];
					
					String prevCurrentData[]=TaskMaster_ACT.getPreviousCurrentData(hierarchy[i][1],uavalidtokenno);
					String prevStatus="NA";
					if(prevCurrentData[1]!=null&&prevCurrentData[1].equalsIgnoreCase(currentWorkStatus))prevStatus=prevCurrentData[0];
					else if(prevCurrentData[1]!=null) prevStatus=prevCurrentData[1];
					String prevTeamKey="NA";
					if(prevCurrentData[3]!=null&&prevCurrentData[3].equalsIgnoreCase(salesData[0][14]))prevTeamKey=prevCurrentData[2];
					else if(prevCurrentData[3]!=null) prevTeamKey=prevCurrentData[3];
					String prevPriority="NA";
					if(prevCurrentData[5]!=null&&prevCurrentData[5].equalsIgnoreCase(salesData[0][15]))prevPriority=prevCurrentData[4];
					else if(prevCurrentData[5]!=null) prevPriority=prevCurrentData[5];
					
					//adding data in delivery action history for triggers
					flag=TaskMaster_ACT.saveDeliveryActionHistory(dhKey, hierarchy[i][1], deliveryDate, prevStatus, currentWorkStatus, prevTeamKey, salesData[0][14], prevPriority, salesData[0][15], today, uavalidtokenno, loginuaid,deliveryTime);
//					System.out.println(deliveryDate+" Final hierarchy days : "+totalDay);
				}
			}
//			System.out.println("going to delete sales hierarchy");
		flag=TaskMaster_ACT.deleteSalesHierarchy(uavalidtokenno,loginuID);
//		System.out.println("hierarchy deleted...."+flag);
		
		if(flag) {
			//getting all sales hierarchies parent whose status is 1
			String parents[][]=TaskMaster_ACT.getAllParentsActiveProject(invoiceno,uavalidtokenno);
			if(parents!=null&&parents.length>0) {
				double avlAmount=TaskMaster_ACT.getTotalInvoicePaid(invoiceno,uavalidtokenno);
//				System.out.println("Available amount="+avlAmount);				
//				double orderAmount=TaskMaster_ACT.getOrderAmount(invoiceno,uavalidtokenno);
				double dueAmount[]=TaskMaster_ACT.getOrderDueAmount(invoiceno, uavalidtokenno);
				
				double dispersedAmt=0;
				for(int i=0;i<parents.length;i++) {			
					int step=1;
					double workPricePercentage=0;
					String workPayType=TaskMaster_ACT.getSalesWorkPayType(parents[i][1],uavalidtokenno);
					if(dueAmount[0]>0) {
//					System.out.println("workPayType="+workPayType);
					if(workPayType.equalsIgnoreCase("Milestone Pay")) {
						int count=TaskMaster_ACT.getTotalMilestones(parents[i][1],uavalidtokenno); 					
						boolean isExist=true;
						while(isExist&&step<=count) {
							isExist=TaskMaster_ACT.getFirstStep(parents[i][1],step,uavalidtokenno);
							if(isExist)step+=1;							
						}
						//getting this project's first milestone percentage
						workPricePercentage=TaskMaster_ACT.getPricePercentage(parents[i][1],step,uavalidtokenno);		
//						System.out.println("step="+step);
					}else if(workPayType.equalsIgnoreCase("Partial Pay")) {workPricePercentage=50;step=0;}
					else if(workPayType.equalsIgnoreCase("Full Pay")) {workPricePercentage=100;step=0;}
					}else workPricePercentage=100;
//					System.out.println("workPricePercentage="+workPricePercentage);
					//getting each sales order amount
					double orderAmount=Enquiry_ACT.getProductAmount(parents[i][1],uavalidtokenno); 
//					System.out.println("avlAmount="+avlAmount);
					//check if amount available then paid otherwise not
					double price=(orderAmount*workPricePercentage)/100;
//					System.out.println("Price="+price+"/orderAmount="+orderAmount+"/workPricePercentage="+workPricePercentage);
					if(price>0&&avlAmount>=price) {
						avlAmount-=price;
						dispersedAmt+=price;
						String key=RandomStringUtils.random(40,true,true);
						String salesDetails[]=TaskMaster_ACT.getSalesData(parents[i][1], uavalidtokenno);
						String remarks=CommonHelper.withLargeIntegers(price)+"Rs. paid to Project : "+salesDetails[1]+" - "+salesDetails[0];
						//add in dispersed amount in salesworkpricectrl table projectNo		   projectName	  invoice
						flag=TaskMaster_ACT.saveDispersedAmount(key,parents[i][1],salesDetails[1],salesDetails[0],salesDetails[2],today,price,remarks,uavalidtokenno,loginuID);
//						System.out.println("Disperced amount="+dispersedAmt);	
						boolean isExist=TaskMaster_ACT.isThisSaleDispersed(parents[i][1],uavalidtokenno);
						if(isExist) {					
							//add each project's dispersed amount 
							TaskMaster_ACT.updateDisperseAmountOfSales(parents[i][1],price,uavalidtokenno,step);
						}else {
						//add each project's dispersed amount 
						String smwkey=RandomStringUtils.random(40,true,true);
						flag=TaskMaster_ACT.addDisperseAmountOfSales(smwkey,parents[i][1],salesDetails[1],salesDetails[2],price,orderAmount,uavalidtokenno,loginuID,step);
						}
					}else if(!paymentMode.equalsIgnoreCase("PO")) {
						 String accountant[][]=Usermaster_ACT.getAllAccountant(uavalidtokenno);
						if(accountant!=null&&accountant.length>0) {
							for(int j=0;j<accountant.length;j++) {
								String salesData[]=TaskMaster_ACT.getSalesData(parents[i][1], uavalidtokenno);
								 //adding notification
								String nKey=RandomStringUtils.random(40,true,true);
								String message="Project : <span class='text-info'>"+salesData[1]+"</span> :- add payment to start project work.";
								TaskMaster_ACT.addNotification(nKey,today,accountant[j][0],"2","manage-billing.html",message,uavalidtokenno,loginuaid,"fas fa-rupee-sign");
								//adding for sold person
								String userNKey=RandomStringUtils.random(40,true,true);
								String userMessage="Estimate No. : <span class='text-info'>"+salesData[7]+"</span> :- add payment to start project work.";
								TaskMaster_ACT.addNotification(userNKey,today,salesData[6],"2","manage-estimate.html",userMessage,uavalidtokenno,loginuaid,"fas fa-rupee-sign");
						}}
					 }
					
					String milestones[][]=TaskMaster_ACT.getAllSalesMilestone("NA", parents[i][1], uavalidtokenno);
					
					if(milestones!=null&&milestones.length>0){
						String salesStatus="NA";
						for(int k=0;k<milestones.length;k++){
						//checking task all status ok and assigned
						boolean allOk=TaskMaster_ACT.isTaskStatusOk(milestones[k][5],uavalidtokenno);
						if(allOk){
							//set milestone start date
							boolean existFlag=TaskMaster_ACT.isDisperseExist(parents[i][1], uavalidtokenno); 
							double avlPrice=TaskMaster_ACT.getMainDispersedAmount(parents[i][1], uavalidtokenno);
							double orderAmt=TaskMaster_ACT.getSalesAmount(parents[i][1], uavalidtokenno);
							double percentage=Double.parseDouble(milestones[k][10]);
							double workPrice=(orderAmt*percentage)/100;
							if(avlPrice>=workPrice&&(existFlag||paymentMode.equalsIgnoreCase("PO"))){
								String deliveryData[]=TaskMaster_ACT.getTaskDeliveryDate(parents[i][1], today, milestones[k][0],uavalidtokenno);
								String deliveryDate="NA";
								String deliveryTime="NA";
								if(deliveryData[0]!=null)deliveryDate=deliveryData[0];
								if(deliveryData[1]!=null)deliveryTime=deliveryData[1];
								String date=DateUtil.getCurrentDateIndianReverseFormat();
								String startTime=DateUtil.getCurrentTime24Hours();
								TaskMaster_ACT.updateTaskWorkStartedDate(milestones[k][5],today,uavalidtokenno,startTime,deliveryDate,deliveryTime,date);
//								System.out.println("Work started (SubmitFinalSalesHierarchy)");//finacc
								salesStatus="3";
							}else {
								salesStatus="1";
								TaskMaster_ACT.updateTaskProgressStatus(milestones[k][5],"1",uavalidtokenno);
							}
						}
					}
					if(!salesStatus.equalsIgnoreCase("NA"))	
						TaskMaster_ACT.updateProjectStatus(parents[i][1],salesStatus,uavalidtokenno);
					}
					
				}
//				System.out.println("Final Disperced amount="+dispersedAmt);
				if(dispersedAmt>0) {
					//update dispersed amount in billing table
					flag=TaskMaster_ACT.updateDispersedAmount(invoiceno,dispersedAmt,uavalidtokenno);
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