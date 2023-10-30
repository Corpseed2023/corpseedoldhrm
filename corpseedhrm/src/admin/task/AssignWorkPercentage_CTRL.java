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

public class AssignWorkPercentage_CTRL extends HttpServlet {	
	
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session=request.getSession();
		PrintWriter pw=response.getWriter();		
		
		boolean flag=false;
			String assignKey = request.getParameter("assignKey").trim();
			String salesKey = request.getParameter("salesKey").trim();
			String salesmilestonekey = request.getParameter("salesmilestonekey").trim();
			int workPercentage = Integer.parseInt(request.getParameter("workPercentage").trim());		
//			String workStatus="Open";
			String token= (String)session.getAttribute("uavalidtokenno");
			String loginuaid = (String)session.getAttribute("loginuaid");
			String today=DateUtil.getCurrentDateIndianFormat1();
			String addedby = (String)session.getAttribute("loginuID");
			
			String invoiceNo=TaskMaster_ACT.getSalesInvoiceNumber(salesKey, token);
			String paymentMode=Enquiry_ACT.getPaymentModeByInvoice(invoiceNo, token);
			
			//getting count all milestones of this sales
			int totalMilestone=TaskMaster_ACT.getTotalMilestones(salesKey, token);			
			
			double totalWorkPercentNot=TaskMaster_ACT.getTotalWorkCompletedPercentageNotThis(salesKey,token,assignKey);
			
			double maxWorkPercent=totalMilestone*100;
			double currentWorkPercent=totalWorkPercentNot+workPercentage;
			boolean docUploaded=TaskMaster_ACT.isAllAgentDocuploaded(salesKey,token);
//			System.out.println(totalMilestone+"/"+totalWorkPercentNot+"/"+maxWorkPercent+"/"+currentWorkPercent+"/"+docUploaded);
			
			if(docUploaded&&currentWorkPercent==maxWorkPercent) {
				pw.write("invalid");
			}else {			
			if(workPercentage==100) {
//				workStatus="Completed";
				String todaydate=DateUtil.getCurrentDateIndianReverseFormat();
				String time=DateUtil.getCurrentTime24Hours();
				TaskMaster_ACT.updateTaskCompletedDate(assignKey,todaydate,token,time);
			}
//			System.out.println("workPercentage-="+workPercentage);
			flag=TaskMaster_ACT.assignWorkPercentage(assignKey,workPercentage,token);
			//getting next step assign percentage
			int nextStepAssignPercentage=TaskMaster_ACT.getNextStepAssignPercentage(salesKey,salesmilestonekey,token);
//			System.out.println("nextStepAssignPercentage="+nextStepAssignPercentage);
			if(workPercentage>=nextStepAssignPercentage) {
				//do step status of next milestone 1  salesmilestonekey
				int taskStep=TaskMaster_ACT.getMilestoneStep(salesKey,salesmilestonekey,token);
//				System.out.println("taskStep=="+taskStep);
				if(taskStep!=0)taskStep+=1;
//				System.out.println("taskStep=="+taskStep);
				int taskCount=TaskMaster_ACT.getTotalMilestones(salesKey,token);
				boolean taskisExist=true;							
				while(taskisExist&&taskStep<=taskCount) {
					taskisExist=TaskMaster_ACT.getFirstStep(salesKey,taskStep,token);
//					System.out.println("taskisExist=="+taskisExist);
					if(taskisExist)taskStep+=1;								
				}				
				//getting milestone key
				String milestoneKeys[][]=TaskMaster_ACT.getMilestoneKey(salesKey,taskStep,token); 
				//update assign step status 1
				if(milestoneKeys!=null&&milestoneKeys.length>0) {
					for(int i=0;i<milestoneKeys.length;i++) {
					
					TaskMaster_ACT.updateAssignStepStatus(salesKey,milestoneKeys[i][0],token);
					
//					boolean isAmountDisparsed=false;
//					if(!isAmountDisparsed) {
					/* start */
					int step=0;
					double dispersedAmt=0;
					double workPricePercentage=0;
					String invoiceno=TaskMaster_ACT.getSalesInvoiceNumber(salesKey, token);
					double avlAmount=TaskMaster_ACT.getTotalInvoicePaid(invoiceno,token);
//					double orderAmount=TaskMaster_ACT.getOrderAmount(invoiceno, token);
//					System.out.println("Available amount="+avlAmount);
					double dueAmount[]=TaskMaster_ACT.getOrderDueAmount(invoiceno, token);
					String workPayType=TaskMaster_ACT.getSalesWorkPayType(salesKey,token);
							
					if(dueAmount[0]>0) {
//					System.out.println("workPayType="+workPayType);
					if(workPayType.equalsIgnoreCase("Milestone Pay")) {
						step=TaskMaster_ACT.getPaymentStep(salesKey,token);
//						System.out.println("step=="+step);
						if(step!=0)step+=1;
						int count=TaskMaster_ACT.getTotalMilestones(salesKey,token);
						boolean isExist=true;							
						while(isExist&&step<=count) {
							isExist=TaskMaster_ACT.getFirstStep(salesKey,step,token);
//							System.out.println(isExist+"=step=="+step);
							if(isExist)step+=1;								
						}						
						//getting this project's first milestone percentage
						workPricePercentage=TaskMaster_ACT.getPricePercentage(salesKey,step,token);		
//						System.out.println("step="+step+"/workPricePercentage=="+workPricePercentage);
					}else if(workPayType.equalsIgnoreCase("Partial Pay")) {workPricePercentage=50;step=0;}
					else if(workPayType.equalsIgnoreCase("Full Pay")) {workPricePercentage=100;step=0;}
					}else workPricePercentage=100;
//					System.out.println("workPricePercentage="+workPricePercentage);
					//getting each sales order amount
					double orderAmount=Enquiry_ACT.getProductAmount(salesKey,token); 
//					System.out.println("Sales Amount="+orderAmount);
//					String invoice=TaskMaster_ACT.getSalesInvoiceNumber(salesKey, token);
					//check if amount available then paid otherwise not
					double price=(orderAmount*workPricePercentage)/100;
//					System.out.println("work start price="+price);
					double dAmount=TaskMaster_ACT.getMainDispersedAmount(salesKey,token);
//					System.out.println("dAmount="+dAmount);
//					System.out.println("price="+price+"/avlAmount="+avlAmount);
					boolean addPayment=true;
					if(workPayType.equalsIgnoreCase("Partial Pay")) {
						if(dAmount>=(orderAmount/2))addPayment=false;
					}	
					if(price>dAmount){
						price=price-dAmount;
					if(price>0&&avlAmount>=price) {
						avlAmount-=price;
						dispersedAmt+=price;
						String key=RandomStringUtils.random(40,true,true);
						String salesDetails[]=TaskMaster_ACT.getSalesData(salesKey, token);
						String Dremarks=CommonHelper.withLargeIntegers(price)+"Rs. paid to Project : "+salesDetails[1]+" - "+salesDetails[0];
						//add in dispersed amount in salesworkpricectrl table projectNo		   projectName	  invoice
						TaskMaster_ACT.saveDispersedAmount(key,salesKey,salesDetails[1],salesDetails[0],salesDetails[2],today,price,Dremarks,token,addedby);
//						System.out.println("Disperced amount="+dispersedAmt);								
						
						boolean isExist=TaskMaster_ACT.isThisSaleDispersed(salesKey,token);
						if(isExist) {
//							System.out.println("main update step==="+step);
						//add each project's dispersed amount 
						TaskMaster_ACT.updateDisperseAmountOfSales(salesKey,price,token,step);
						}else {
							//add each project's dispersed amount 
							String smwkey=RandomStringUtils.random(40,true,true);
							TaskMaster_ACT.addDisperseAmountOfSales(smwkey,salesKey,salesDetails[1],salesDetails[2],price,orderAmount,token,addedby,step);
						}	
						
					 }else if(dueAmount[0]!=0&&addPayment&&!paymentMode.equalsIgnoreCase("PO")) {
						 String accountant[][]=Usermaster_ACT.getAllAccountant(token);
						if(accountant!=null&&accountant.length>0) {
							for(int j=0;j<accountant.length;j++) {
								String salesData[]=TaskMaster_ACT.getSalesData(salesKey, token);
								 //adding notification
								String nKey=RandomStringUtils.random(40,true,true);
								String message="Project : <span class='text-info'>"+salesData[1]+"</span> :- Add rs. "+(price-avlAmount)+" to re-start project's work.";
								TaskMaster_ACT.addNotification(nKey,today,accountant[j][0],"2","manage-billing.html",message,token,loginuaid,"fas fa-rupee-sign");
								//adding for sold person
								String userNKey=RandomStringUtils.random(40,true,true);
								String userMessage="Estimate No. : <span class='text-info'>"+salesData[7]+"</span> :- Add rs. "+(price-avlAmount)+" to re-start project's work.";
								TaskMaster_ACT.addNotification(userNKey,today,salesData[6],"2","manage-estimate.html",userMessage,token,loginuaid,"fas fa-rupee-sign");
						}}
					 }
					}else if(step>0&&step<=taskCount) {
//						System.out.println("going to update step of dispersed amount="+step);
						TaskMaster_ACT.updateDisperseAmountOfSalesStep(salesKey,token,step);
					}
//					System.out.println("dispersedAmt=="+dispersedAmt);
					if(dispersedAmt>0) {
						//update dispersed amount in billing table
						TaskMaster_ACT.updateDispersedAmount(invoiceno,dispersedAmt,token);
					}
					/* end */
					
					String salesStatus="NA";
					//checking task all status ok and assigned
					boolean allOk=TaskMaster_ACT.isTaskStatusOk(salesKey,milestoneKeys[i][0],token);
					if(allOk){
						//set milestone start date
						boolean existFlag=TaskMaster_ACT.isDisperseExist(salesKey, token); 
						double avlPrice=TaskMaster_ACT.getMainDispersedAmount(salesKey, token);
						double orderAmt=TaskMaster_ACT.getSalesAmount(salesKey, token);
						double percentage=TaskMaster_ACT.getWorkStartPercentage(salesKey,milestoneKeys[i][0],token);
						double workPrice=(orderAmt*percentage)/100;
						if(avlPrice>=workPrice&&(existFlag||paymentMode.equalsIgnoreCase("PO"))){
							String deliveryData[]=TaskMaster_ACT.getTaskDeliveryDate(salesKey, today, milestoneKeys[i][0],token);
							String deliveryDate="NA";
							String deliveryTime="NA";
							if(deliveryData[0]!=null)deliveryDate=deliveryData[0];
							if(deliveryData[1]!=null)deliveryTime=deliveryData[1];
							
							String date=DateUtil.getCurrentDateIndianReverseFormat();
							String startTime=DateUtil.getCurrentTime24Hours();
							TaskMaster_ACT.updateWorkStartedDate(salesKey,milestoneKeys[i][0],today,deliveryDate,token,deliveryTime,startTime,date);
							
							//adding notification
							String nKey=RandomStringUtils.random(40,true,true);
							String milestoneData[]=TaskMaster_ACT.getAssignedMilestoneData(salesKey,milestoneKeys[i][0], token);
							String message="Milestone : <span class='text-info'>"+milestoneData[0]+"</span> assigned started now,Begin your work !!.";
							TaskMaster_ACT.addNotification(nKey,today,milestoneData[1],"2","edittask-"+milestoneData[3]+".html",message,token,loginuaid,"fas fa-tasks");
							salesStatus="3";	
						}else {
							salesStatus="1";
							TaskMaster_ACT.updateTaskProgressStatus(salesKey,milestoneKeys[i][0],"1",token);
						}
					}
					if(!salesStatus.equalsIgnoreCase("NA"))	
						TaskMaster_ACT.updateProjectStatus(salesKey,salesStatus,token);
				}}
			}
			//checking all projects completed this sales
			double totalWorkPercent=TaskMaster_ACT.getTotalWorkCompletedPercentage(salesKey,token);
//			System.out.println("totalWorkPercent="+totalWorkPercent);
			if((totalMilestone*100)==totalWorkPercent) {
				String projectStatus="1";
				String invoiceno=TaskMaster_ACT.getSalesInvoiceNumber(salesKey, token);
				double salesDueAmount=TaskMaster_ACT.getSalesDueAmount(invoiceno,token);
				if(salesDueAmount<=0)projectStatus="2";
				//update sales 100% completed
				String todayRev=DateUtil.getCurrentDateIndianReverseFormat();
				flag=TaskMaster_ACT.updateSalesCompleted(salesKey,100,token,todayRev,projectStatus);
				//if it has child and active then disperse amount of that if amount available
				//System.out.println("salesKey====="+salesKey);
				boolean isParent=TaskMaster_ACT.isThisSaleParent(salesKey, token);
				//System.out.println("isParent="+isParent);
				String salesKey1=null;
				if(isParent)
					 salesKey1=salesKey;
				else
					salesKey1=TaskMaster_ACT.getParentKey(salesKey, token);
				
				//System.out.println("salesKey1="+salesKey1+"###salesKey="+salesKey);
				
				String childs[][]=TaskMaster_ACT.getAllChildActiveProject(salesKey1,token);
				//System.out.println("childs=="+childs.length);
				if(childs!=null&&childs.length>0) {
					double dispersedAmt=0;					
//					double orderAmount=TaskMaster_ACT.getOrderAmount(invoiceno, token);
					double avlAmount=TaskMaster_ACT.getTotalInvoicePaid(invoiceno,token);
					double dueAmount[]=TaskMaster_ACT.getOrderDueAmount(invoiceno, token);
					//System.out.println("avlAmount="+avlAmount+"#due amount="+dueAmount[0]+"#discount="+dueAmount[1]+"#order="+dueAmount[2]);
					for(int i=0;i<childs.length;i++) {				
				
				//System.out.println("Child==="+childs[i][0]);
				
				//updating sales hierarchy status
				TaskMaster_ACT.updateSalesHierarchyOfAssignedMilestone(childs[i][0],token);
						
				int step=1;
				double workPricePercentage=0;
				
				if(dueAmount[0]>0) {					
					String workPayType=TaskMaster_ACT.getSalesWorkPayType(childs[i][0],token);
					if(workPayType.equalsIgnoreCase("Milestone Pay")) {
						int count=TaskMaster_ACT.getTotalMilestones(childs[i][0],token); 					
						boolean isExist=true;
						while(isExist&&step<=count) {
							isExist=TaskMaster_ACT.getFirstStep(childs[i][0],step,token);
							if(isExist)step+=1;							
						}
						//getting this project's first milestone percentage
						workPricePercentage=TaskMaster_ACT.getPricePercentage(childs[i][0],step,token);		
//						//System.out.println("step="+step);
					}else if(workPayType.equalsIgnoreCase("Partial Pay")) {workPricePercentage=50;step=0;}
					else if(workPayType.equalsIgnoreCase("Full Pay")) {workPricePercentage=100;step=0;}					
				}else workPricePercentage=100;
				//getting each sales order amount
				double orderAmount=Enquiry_ACT.getProductAmount(childs[i][0],token); 
				//check if amount available then paid otherwise not
				double price=(orderAmount*workPricePercentage)/100;
				//System.out.println("Price="+price);
				if(price>0&&avlAmount>=price) {
					avlAmount-=price;
					dispersedAmt+=price;
					String key=RandomStringUtils.random(40,true,true);
					String salesDetails[]=TaskMaster_ACT.getSalesData(childs[i][0],token);
					String remarks=CommonHelper.withLargeIntegers(price)+"Rs. paid to Project : "+salesDetails[1]+" - "+salesDetails[0];
					//add in dispersed amount in salesworkpricectrl table projectNo		   projectName	  invoice
					flag=TaskMaster_ACT.saveDispersedAmount(key,childs[i][0],salesDetails[1],salesDetails[0],salesDetails[2],today,price,remarks,token,addedby);
//					System.out.println("Disperced amount="+dispersedAmt);						
					//add each project's dispersed amount 
					String smwkey=RandomStringUtils.random(40,true,true);
					flag=TaskMaster_ACT.addDisperseAmountOfSales(smwkey,childs[i][0],salesDetails[1],salesDetails[2],price,orderAmount,token,addedby,step);
					
				}
				
				String milestones[][]=TaskMaster_ACT.getAllSalesMilestone("NA", childs[i][0], token);
				if(milestones!=null&&milestones.length>0){
					for(int k=0;k<milestones.length;k++){
					//checking task all status ok and assigned
					boolean allOk=TaskMaster_ACT.isTaskStatusOk(milestones[k][5],token);
					if(allOk){
						//set milestone start date
						boolean existFlag=TaskMaster_ACT.isDisperseExist(childs[i][0], token); 
						double avlPrice=TaskMaster_ACT.getMainDispersedAmount(childs[i][0], token);
						double orderAmt=TaskMaster_ACT.getSalesAmount(childs[i][0], token);
						double percentage=Double.parseDouble(milestones[k][10]);
						double workPrice=(orderAmt*percentage)/100;
						if(avlPrice>=workPrice&&(existFlag||paymentMode.equalsIgnoreCase("PO"))){
							String deliveryData[]=TaskMaster_ACT.getTaskDeliveryDate(childs[i][0], today, milestones[i][0],token);
							String deliveryDate="NA";
							String deliveryTime="NA";
							if(deliveryData[0]!=null)deliveryDate=deliveryData[0];
							if(deliveryData[1]!=null)deliveryTime=deliveryData[1];
							String date=DateUtil.getCurrentDateIndianReverseFormat();
							String startTime=DateUtil.getCurrentTime24Hours();
							TaskMaster_ACT.updateTaskWorkStartedDate(milestones[k][5],today,token,startTime,deliveryDate,deliveryTime,date);
							//System.out.println("Work started (AssignWorkPercentage-1)");
						}
					}
				}}
				
				}
					//System.out.println("dispersedAmt1=="+dispersedAmt);
				if(dispersedAmt>0) {
					//update dispersed amount in billing table
					flag=TaskMaster_ACT.updateDispersedAmount(invoiceno,dispersedAmt,token);
				}
				}				
				
			}else {
				int completed=TaskMaster_ACT.getTotalCompletedMilestones(salesKey, token);
				if(completed>0) {
					int percentage=completed*(100/totalMilestone);
					flag=TaskMaster_ACT.updateSalesCompleted(salesKey,percentage,token,"NA");
				}
			}
			if(flag)pw.write("pass");
			else pw.write("fail");			
			}
	}

}