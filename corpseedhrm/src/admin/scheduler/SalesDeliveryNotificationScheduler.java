package admin.scheduler;

import java.util.TimerTask;

import admin.enquiry.Enquiry_ACT;
import admin.export.ExcelGenerator;
import admin.master.Usermaster_ACT;
import admin.task.TaskMaster_ACT;
import commons.DateUtil;

public class SalesDeliveryNotificationScheduler extends TimerTask {

	@Override
	public void run() {
		try {
			
//-------------------------Sales start--------------------------------------			
			
			//One day before sales delivery date
			
			
			String dateAfterDays = DateUtil.getDateAfterDays(1);
//			System.out.println("dateAfterDays="+dateAfterDays);
			
			//find all tomorrow delivery sales
			//Notify sales person (his/her sales)
		   String salesPerson[][]=TaskMaster_ACT.findSalesPersonByDeliveryDate(dateAfterDays);
			if(salesPerson!=null&&salesPerson.length>0) {				
				for(int i=0;i<salesPerson.length;i++) {
								
				String sales[][]=TaskMaster_ACT.findSalesByDeliveryDate(dateAfterDays,salesPerson[i][0]);
				
				if(sales!=null&&sales.length>0) {
					
					String executiveReport="<div style=\"max-height: 25rem;overflow: auto;max-width: 60rem;\"><table border=\"1\" style=\"white-space: nowrap;\"><thead>"
							+ "<th>#</th><th>Sold Date</th><th>Invoice</th><th>Project No.</th>"
							+ "<th>Product Name</th><th>Contact Name</th><th>Client</th><th>Order Amount</th><th>Due Amount</th>"
							+ "<th>Progress</th><th>Delivery Date</th><th>Sales Person</th>"
							+ "</thead><tbody>";
					
					
					String invoice="";
					for(int j=0;j<sales.length;j++) {					
						//sending email to sales person
						String contactName=TaskMaster_ACT.getSalesContactName(sales[j][5]);
						String userName=Usermaster_ACT.findUserByUaid(sales[j][8]);
						double orderAmount=TaskMaster_ACT.findSalesOrderAmount(sales[j][0]);
						double orderDueAmount=TaskMaster_ACT.getSalesDueAmount(sales[j][2], sales[j][12]);
						
						if(invoice.equalsIgnoreCase(sales[j][2])) {
							executiveReport+="<tr><td>"+(j+1)+"</td><td>"+sales[j][1]+"</td><td>"+sales[j][2]+"</td><td>"+sales[j][3]+"</td><td>"+sales[j][4]+"</td>"
									+ "<td>"+contactName+"</td><td>"+sales[j][6]+"</td><td>"+Math.ceil(orderAmount)+"</td><td>_</td><td>"+sales[j][7]+"%</td><td>"+sales[j][11]+"</td><td>"+userName+"</td></tr>";
							
						}else {
							executiveReport+="<tr><td>"+(j+1)+"</td><td>"+sales[j][1]+"</td><td>"+sales[j][2]+"</td><td>"+sales[j][3]+"</td><td>"+sales[j][4]+"</td>"
									+ "<td>"+contactName+"</td><td>"+sales[j][6]+"</td><td>"+Math.ceil(orderAmount)+"</td><td>"+Math.ceil(orderDueAmount)+"</td><td>"+sales[j][7]+"%</td><td>"+sales[j][11]+"</td><td>"+userName+"</td></tr>";
							invoice=sales[j][2];
						}						
					}
					executiveReport+="</tbody></table></div>";
					String receiverName=Usermaster_ACT.findUserByUaid(salesPerson[i][0]);
					String emailTo=Usermaster_ACT.getUserEmail(salesPerson[i][0], salesPerson[i][1]);
					String message=ExcelGenerator.findTomorrowDeliveryMessage(receiverName,executiveReport);
					Enquiry_ACT.saveEmail(emailTo, "empty", "Projects delivery on "+dateAfterDays, message, 2, "NA");					
				}
			  }
				
			}
			
			String deliveryManager[][]=Usermaster_ACT.findAllUserByDepartmentAndRole("Delivery", "Manager");
            if(deliveryManager!=null&&deliveryManager.length>0) {
            	for (int k=0;k<deliveryManager.length;k++) {
            		
            		String sales[][]=TaskMaster_ACT.findSalesByDeliveryDateForManager(dateAfterDays,deliveryManager[k][0]);
            		if(sales!=null&&sales.length>0) {
            			String deliveryManagerReport="<div style=\"max-height: 25rem;overflow: auto;max-width: 60rem;\"><table border=\"1\" style=\"white-space: nowrap;\"><thead>"
        						+ "<th>#</th><th>Sold Date</th><th>Invoice</th><th>Project No.</th>"
        						+ "<th>Product Name</th><th>Contact Name</th><th>Client</th>"
        						+ "<th>Progress</th><th>Delivery Date</th><th>Sales Person</th>"
        						+ "</thead><tbody>";
            			for(int j=0;j<sales.length;j++) {					
    						//sending email to sales person
    						String contactName=TaskMaster_ACT.getSalesContactName(sales[j][5]);
    						String userName=Usermaster_ACT.findUserByUaid(sales[j][8]);
    						   						
    						//send in table to suneeta ma'am (Delivery Manager)
    						deliveryManagerReport+="<tr><td>"+(j+1)+"</td><td>"+sales[j][1]+"</td><td>"+sales[j][2]+"</td><td>"+sales[j][3]+"</td><td>"+sales[j][4]+"</td>"
    								+ "<td>"+contactName+"</td><td>"+sales[j][6]+"</td><td>"+sales[j][7]+"%</td><td>"+sales[j][11]+"</td><td>"+userName+"</td></tr>";
    						
    					}
            			deliveryManagerReport+="</tbody></table></div>";
        				//send in table to suneeta ma'am (Delivery Manager)
        				String messageDelivery=ExcelGenerator.findTomorrowDeliveryMessage(deliveryManager[k][1],deliveryManagerReport);
        				Enquiry_ACT.saveEmail(deliveryManager[k][2], "empty", "Projects delivery on "+dateAfterDays, messageDelivery, 2, deliveryManager[k][3]);
            		}
            	}
            }
			
			
			
			//finding all sales team
			//Notify sales manager (his/her + his/her team�s)
			String teams[][]=TaskMaster_ACT.findTeamByDepartment("Sales");
			if(teams!=null&&teams.length>0) {
				for(int i=0;i<teams.length;i++) {					
					String sales1[][]=TaskMaster_ACT.findTeamSalesByDeliveryDate(dateAfterDays,teams[i][0],teams[i][1]);
					if(sales1!=null&&sales1.length>0) {
						String salesTeamLeader="<div style=\"max-height: 25rem;overflow: auto;max-width: 60rem;\"><table border=\"1\" style=\"white-space: nowrap;\"><thead>"
								+ "<th>#</th><th>Sold Date</th><th>Invoice</th><th>Project No.</th>"
								+ "<th>Product Name</th><th>Contact Name</th><th>Client</th><th>Order Amount</th><th>Due Amount</th>"
								+ "<th>Progress</th><th>Delivery Date</th><th>Sales Person</th>"
								+ "</thead><tbody>";
						String invoice="";
						for(int j=0;j<sales1.length;j++) {
							String contactName=TaskMaster_ACT.getSalesContactName(sales1[j][5]);
							String userName=Usermaster_ACT.findUserByUaid(sales1[j][8]);
							double orderAmount=TaskMaster_ACT.findSalesOrderAmount(sales1[j][0]);
							double orderDueAmount=TaskMaster_ACT.getSalesDueAmount(sales1[j][2], sales1[j][12]);
							
							
							if(invoice.equalsIgnoreCase(sales1[j][2])) {
								salesTeamLeader+="<tr><td>"+(j+1)+"</td><td>"+sales1[j][1]+"</td><td>"+sales1[j][2]+"</td><td>"+sales1[j][3]+"</td><td>"+sales1[j][4]+"</td>"
										+ "<td>"+contactName+"</td><td>"+sales1[j][6]+"</td><td>"+Math.ceil(orderAmount)+"</td><td>_</td><td>"+sales1[j][7]+"%</td><td>"+sales1[j][11]+"</td><td>"+userName+"</td></tr>";
								
							}else {
								salesTeamLeader+="<tr><td>"+(j+1)+"</td><td>"+sales1[j][1]+"</td><td>"+sales1[j][2]+"</td><td>"+sales1[j][3]+"</td><td>"+sales1[j][4]+"</td>"
										+ "<td>"+contactName+"</td><td>"+sales1[j][6]+"</td><td>"+Math.ceil(orderAmount)+"</td><td>"+Math.ceil(orderDueAmount)+"</td><td>"+sales1[j][7]+"%</td><td>"+sales1[j][11]+"</td><td>"+userName+"</td></tr>";
								
								invoice=sales1[j][2];
							}
						}
						salesTeamLeader+="</tbody></table></div>";
						//send report to sales team leader
						String receiverName=teams[i][2];
						String emailTo=Usermaster_ACT.getUserEmail(teams[i][1], teams[i][3]);
						String messageTeamLeader=ExcelGenerator.findTomorrowDeliveryMessage(receiverName,salesTeamLeader);
						Enquiry_ACT.saveEmail(emailTo, "empty", "Projects delivery on "+dateAfterDays, messageTeamLeader, 2, "NA");					
					}
				}
			}
			//Daily notification of expired sales delivery date
			
			
			//find all yesterday delivery sales
			//Notify sales person (his/her sales)
			String dateBeforeDays = DateUtil.getDateAfterDays(-1);
			
			String expiredSalesPerson[][]=TaskMaster_ACT.findExpiredSalesPersonByDeliveryDate(dateBeforeDays);
			if(expiredSalesPerson!=null&&expiredSalesPerson.length>0) {	
				
				for(int i=0;i<expiredSalesPerson.length;i++) {
								
				String sales[][]=TaskMaster_ACT.findExpiredSalesByDeliveryDate(dateBeforeDays,expiredSalesPerson[i][0]);
				if(sales!=null&&sales.length>0) {
					
					String executiveReport="<div style=\"max-height: 25rem;overflow: auto;max-width: 60rem;\"><table border=\"1\" style=\"white-space: nowrap;\"><thead>"
							+ "<th>#</th><th>Sold Date</th><th>Invoice</th><th>Project No.</th>"
							+ "<th>Product Name</th><th>Contact Name</th><th>Client</th><th>Order Amount</th><th>Due Amount</th>"
							+ "<th>Progress</th><th>Delivery Date</th><th>Sales Person</th>"
							+ "</thead><tbody>";
					
					
					String invoice="";
					for(int j=0;j<sales.length;j++) {					
						//sending email to sales person
						String contactName=TaskMaster_ACT.getSalesContactName(sales[j][5]);
						String userName=Usermaster_ACT.findUserByUaid(sales[j][8]);
						double orderAmount=TaskMaster_ACT.findSalesOrderAmount(sales[j][0]);
						double orderDueAmount=TaskMaster_ACT.getSalesDueAmount(sales[j][2], sales[j][12]);
						
						if(invoice.equalsIgnoreCase(sales[j][2])) {
							executiveReport+="<tr><td>"+(j+1)+"</td><td>"+sales[j][1]+"</td><td>"+sales[j][2]+"</td><td>"+sales[j][3]+"</td><td>"+sales[j][4]+"</td>"
									+ "<td>"+contactName+"</td><td>"+sales[j][6]+"</td><td>"+Math.ceil(orderAmount)+"</td><td>_</td><td>"+sales[j][7]+"%</td><td>"+sales[j][11]+"</td><td>"+userName+"</td></tr>";
							
						}else {
							executiveReport+="<tr><td>"+(j+1)+"</td><td>"+sales[j][1]+"</td><td>"+sales[j][2]+"</td><td>"+sales[j][3]+"</td><td>"+sales[j][4]+"</td>"
									+ "<td>"+contactName+"</td><td>"+sales[j][6]+"</td><td>"+Math.ceil(orderAmount)+"</td><td>"+Math.ceil(orderDueAmount)+"</td><td>"+sales[j][7]+"%</td><td>"+sales[j][11]+"</td><td>"+userName+"</td></tr>";
							
							invoice=sales[j][2];
						}
					}
					executiveReport+="</tbody></table></div>";
					String receiverName=Usermaster_ACT.findUserByUaid(expiredSalesPerson[i][0]);
					String emailTo=Usermaster_ACT.getUserEmail(expiredSalesPerson[i][0], expiredSalesPerson[i][1]);
					String message=ExcelGenerator.findExpiredSalesDeliveryMessage(receiverName,executiveReport);
					Enquiry_ACT.saveEmail(emailTo, "empty", "Expired Sales Delivery Report : "+DateUtil.getCurrentDateIndianFormat(), message, 2, "NA");					
				}
			  }
			}
			
			
			if(deliveryManager!=null&&deliveryManager.length>0) {
            	for (int k=0;k<deliveryManager.length;k++) {
            		
            		String sales[][]=TaskMaster_ACT.findExpiredSalesByDeliveryDateForManager(dateBeforeDays,deliveryManager[k][0]);
            		if(sales!=null&&sales.length>0) {
            			String deliveryManagerReport="<div style=\"max-height: 25rem;overflow: auto;max-width: 60rem;\"><table border=\"1\" style=\"white-space: nowrap;\"><thead>"
        						+ "<th>#</th><th>Sold Date</th><th>Invoice</th><th>Project No.</th>"
        						+ "<th>Product Name</th><th>Contact Name</th><th>Client</th>"
        						+ "<th>Progress</th><th>Delivery Date</th><th>Sales Person</th>"
        						+ "</thead><tbody>";
            			for(int j=0;j<sales.length;j++) {					
    						//sending email to sales person
    						String contactName=TaskMaster_ACT.getSalesContactName(sales[j][5]);
    						String userName=Usermaster_ACT.findUserByUaid(sales[j][8]);
    						   						
    						//send in table to suneeta ma'am (Delivery Manager)
    						deliveryManagerReport+="<tr><td>"+(j+1)+"</td><td>"+sales[j][1]+"</td><td>"+sales[j][2]+"</td><td>"+sales[j][3]+"</td><td>"+sales[j][4]+"</td>"
    								+ "<td>"+contactName+"</td><td>"+sales[j][6]+"</td><td>"+sales[j][7]+"%</td><td>"+sales[j][11]+"</td><td>"+userName+"</td></tr>";
    						
    					}
            			deliveryManagerReport+="</tbody></table></div>";
        				//send in table to suneeta ma'am (Delivery Manager)
        				String messageDelivery=ExcelGenerator.findExpiredSalesDeliveryMessage(deliveryManager[k][1],deliveryManagerReport);
        				Enquiry_ACT.saveEmail(deliveryManager[k][2], "empty", "Expired Projects Delivery Report : "+DateUtil.getCurrentDateIndianFormat(), messageDelivery, 2, deliveryManager[k][3]);
            		}
            	}
            }
			
			
			
			//finding all sales team
			//Notify sales manager (his/her + his/her team�s)
			
			if(teams!=null&&teams.length>0) {
				for(int i=0;i<teams.length;i++) {					
					String sales1[][]=TaskMaster_ACT.findTeamExpiredSalesByDeliveryDate(dateBeforeDays,teams[i][0],teams[i][1]);
					if(sales1!=null&&sales1.length>0) {
						String salesTeamLeader="<div style=\"max-height: 25rem;overflow: auto;max-width: 60rem;\"><table border=\"1\" style=\"white-space: nowrap;\"><thead>"
								+ "<th>#</th><th>Sold Date</th><th>Invoice</th><th>Project No.</th>"
								+ "<th>Product Name</th><th>Contact Name</th><th>Client</th><th>Order Amount</th><th>Due Amount</th>"
								+ "<th>Progress</th><th>Delivery Date</th><th>Sales Person</th>"
								+ "</thead><tbody>";
						String invoice="";
						for(int j=0;j<sales1.length;j++) {
							String contactName=TaskMaster_ACT.getSalesContactName(sales1[j][5]);
							String userName=Usermaster_ACT.findUserByUaid(sales1[j][8]);
							double orderAmount=TaskMaster_ACT.findSalesOrderAmount(sales1[j][0]);
							double orderDueAmount=TaskMaster_ACT.getSalesDueAmount(sales1[j][2], sales1[j][12]);
							
							
							if(invoice.equalsIgnoreCase(sales1[j][2])) {
								salesTeamLeader+="<tr><td>"+(j+1)+"</td><td>"+sales1[j][1]+"</td><td>"+sales1[j][2]+"</td><td>"+sales1[j][3]+"</td><td>"+sales1[j][4]+"</td>"
										+ "<td>"+contactName+"</td><td>"+sales1[j][6]+"</td><td>"+Math.ceil(orderAmount)+"</td><td>_</td><td>"+sales1[j][7]+"%</td><td>"+sales1[j][11]+"</td><td>"+userName+"</td></tr>";
								
							}else {
								salesTeamLeader+="<tr><td>"+(j+1)+"</td><td>"+sales1[j][1]+"</td><td>"+sales1[j][2]+"</td><td>"+sales1[j][3]+"</td><td>"+sales1[j][4]+"</td>"
										+ "<td>"+contactName+"</td><td>"+sales1[j][6]+"</td><td>"+Math.ceil(orderAmount)+"</td><td>"+Math.ceil(orderDueAmount)+"</td><td>"+sales1[j][7]+"%</td><td>"+sales1[j][11]+"</td><td>"+userName+"</td></tr>";
								
								invoice=sales1[j][2];
							}
						}
						salesTeamLeader+="</tbody></table></div>";
						//send report to sales team leader
						String receiverName=teams[i][2];
						String emailTo=Usermaster_ACT.getUserEmail(teams[i][1], teams[i][3]);
						String messageTeamLeader=ExcelGenerator.findExpiredSalesDeliveryMessage(receiverName,salesTeamLeader);
						Enquiry_ACT.saveEmail(emailTo, "empty", "Expired Projects Delivery Report : "+DateUtil.getCurrentDateIndianFormat(), messageTeamLeader, 2, "NA");					
					}
				}
			}
			
			//Daily notification of completed sales but payment not done.
			
			// Notify sales person (his/her sales) && Notify accountant (all sales)
			String dueSalesPerson[][]=TaskMaster_ACT.findDueSalesPerson();
			if(dueSalesPerson!=null&&dueSalesPerson.length>0) {
				String dueAccountReport="<div style=\"max-height: 25rem;overflow: auto;max-width: 60rem;\"><table border=\"1\" style=\"white-space: nowrap;\"><thead>"
						+ "<th>#</th><th>Sold Date</th><th>Invoice</th><th>Project No.</th>"
						+ "<th>Product Name</th><th>Contact Name</th><th>Client</th><th>Order Amount</th><th>Due Amount</th>"
						+ "<th>Progress</th><th>Delivery Date</th><th>Sales Person</th>"
						+ "</thead><tbody>";
				for(int i=0;i<dueSalesPerson.length;i++) {
					String executiveReport="<div style=\"max-height: 25rem;overflow: auto;max-width: 60rem;\"><table border=\"1\" style=\"white-space: nowrap;\"><thead>"
							+ "<th>#</th><th>Sold Date</th><th>Invoice</th><th>Project No.</th>"
							+ "<th>Product Name</th><th>Contact Name</th><th>Client</th><th>Order Amount</th><th>Due Amount</th>"
							+ "<th>Progress</th><th>Delivery Date</th><th>Sales Person</th>"
							+ "</thead><tbody>";
					String invoice="";
					String dueSales[][]=TaskMaster_ACT.findDueSales(dueSalesPerson[i][0]);
					if(dueSales!=null&&dueSales.length>0) {
						for(int j=0;j<dueSales.length;j++) {							
							//sending email to sales person
							String contactName=TaskMaster_ACT.getSalesContactName(dueSales[j][5]);
							String userName=Usermaster_ACT.findUserByUaid(dueSales[j][8]);
							double orderAmount=TaskMaster_ACT.findSalesOrderAmount(dueSales[j][0]);
							double orderDueAmount=Double.parseDouble(dueSales[j][13]);
							
							if(invoice.equalsIgnoreCase(dueSales[j][2])) {
								executiveReport+="<tr><td>"+(j+1)+"</td><td>"+dueSales[j][1]+"</td><td>"+dueSales[j][2]+"</td><td>"+dueSales[j][3]+"</td><td>"+dueSales[j][4]+"</td>"
										+ "<td>"+contactName+"</td><td>"+dueSales[j][6]+"</td><td>"+Math.ceil(orderAmount)+"</td><td>_</td><td>"+dueSales[j][7]+"%</td><td>"+dueSales[j][11]+"</td><td>"+userName+"</td></tr>";
								
								dueAccountReport+="<tr><td>"+(j+1)+"</td><td>"+dueSales[j][1]+"</td><td>"+dueSales[j][2]+"</td><td>"+dueSales[j][3]+"</td><td>"+dueSales[j][4]+"</td>"
										+ "<td>"+contactName+"</td><td>"+dueSales[j][6]+"</td><td>"+Math.ceil(orderAmount)+"</td><td>_</td><td>"+dueSales[j][7]+"%</td><td>"+dueSales[j][11]+"</td><td>"+userName+"</td></tr>";
								
							}else {
								executiveReport+="<tr><td>"+(j+1)+"</td><td>"+dueSales[j][1]+"</td><td>"+dueSales[j][2]+"</td><td>"+dueSales[j][3]+"</td><td>"+dueSales[j][4]+"</td>"
										+ "<td>"+contactName+"</td><td>"+dueSales[j][6]+"</td><td>"+Math.ceil(orderAmount)+"</td><td>"+Math.ceil(orderDueAmount)+"</td><td>"+dueSales[j][7]+"%</td><td>"+dueSales[j][11]+"</td><td>"+userName+"</td></tr>";
								
								dueAccountReport+="<tr><td>"+(j+1)+"</td><td>"+dueSales[j][1]+"</td><td>"+dueSales[j][2]+"</td><td>"+dueSales[j][3]+"</td><td>"+dueSales[j][4]+"</td>"
										+ "<td>"+contactName+"</td><td>"+dueSales[j][6]+"</td><td>"+Math.ceil(orderAmount)+"</td><td>"+Math.ceil(orderDueAmount)+"</td><td>"+dueSales[j][7]+"%</td><td>"+dueSales[j][11]+"</td><td>"+userName+"</td></tr>";
								
								invoice=dueSales[j][2];
							}							
						}
						
						//sending email to sales person
						executiveReport+="</tbody></table></div>";
						String receiverName=Usermaster_ACT.findUserByUaid(dueSalesPerson[i][0]);
						String emailTo=Usermaster_ACT.getUserEmail(dueSalesPerson[i][0], dueSalesPerson[i][1]);
						String message=ExcelGenerator.findDueSalesMessage(receiverName,executiveReport);
						Enquiry_ACT.saveEmail(emailTo, "empty", "Due Projects Report : "+DateUtil.getCurrentDateIndianFormat(), message, 2, "NA");
					}
				}
				//sending to accountant
				dueAccountReport+="</tbody></table></div>";
				String accountantMessage=ExcelGenerator.findDueSalesMessage("Praveen Kumar",dueAccountReport);
				Enquiry_ACT.saveEmail("praveen.kumar@corpseed.com", "empty", "Due Projects Report : "+DateUtil.getCurrentDateIndianFormat(), accountantMessage, 2, "NA");
			}
			
//			Notify sales manager (his/her + his/her team�s)
			if(teams!=null&&teams.length>0) {
				for(int i=0;i<teams.length;i++) {		
					String dueSales1[][]=TaskMaster_ACT.findTeamDueSales(teams[i][0],teams[i][1]);
					if(dueSales1!=null&&dueSales1.length>0) {
						String salesTeamLeader="<div style=\"max-height: 25rem;overflow: auto;max-width: 60rem;\"><table border=\"1\" style=\"white-space: nowrap;\"><thead>"
								+ "<th>#</th><th>Sold Date</th><th>Invoice</th><th>Project No.</th>"
								+ "<th>Product Name</th><th>Contact Name</th><th>Client</th><th>Order Amount</th><th>Due Amount</th>"
								+ "<th>Progress</th><th>Delivery Date</th><th>Sales Person</th>"
								+ "</thead><tbody>";
						String invoice="";
						for(int j=0;j<dueSales1.length;j++) {
							String contactName=TaskMaster_ACT.getSalesContactName(dueSales1[j][5]);
							String userName=Usermaster_ACT.findUserByUaid(dueSales1[j][8]);
							double orderAmount=TaskMaster_ACT.findSalesOrderAmount(dueSales1[j][0]);
							double orderDueAmount=TaskMaster_ACT.getSalesDueAmount(dueSales1[j][2], dueSales1[j][12]);
							
							
							if(invoice.equalsIgnoreCase(dueSales1[j][2])) {
								salesTeamLeader+="<tr><td>"+(j+1)+"</td><td>"+dueSales1[j][1]+"</td><td>"+dueSales1[j][2]+"</td><td>"+dueSales1[j][3]+"</td><td>"+dueSales1[j][4]+"</td>"
										+ "<td>"+contactName+"</td><td>"+dueSales1[j][6]+"</td><td>"+Math.ceil(orderAmount)+"</td><td>_</td><td>"+dueSales1[j][7]+"%</td><td>"+dueSales1[j][11]+"</td><td>"+userName+"</td></tr>";
								
							}else {
								salesTeamLeader+="<tr><td>"+(j+1)+"</td><td>"+dueSales1[j][1]+"</td><td>"+dueSales1[j][2]+"</td><td>"+dueSales1[j][3]+"</td><td>"+dueSales1[j][4]+"</td>"
										+ "<td>"+contactName+"</td><td>"+dueSales1[j][6]+"</td><td>"+Math.ceil(orderAmount)+"</td><td>"+Math.ceil(orderDueAmount)+"</td><td>"+dueSales1[j][7]+"%</td><td>"+dueSales1[j][11]+"</td><td>"+userName+"</td></tr>";
								
								invoice=dueSales1[j][2];
							}
						}
						salesTeamLeader+="</tbody></table></div>";
						//send report to sales team leader
						String receiverName=teams[i][2];
						String emailTo=Usermaster_ACT.getUserEmail(teams[i][1], teams[i][3]);
						String messageTeamLeader=ExcelGenerator.findDueSalesMessage(receiverName,salesTeamLeader);
						Enquiry_ACT.saveEmail(emailTo, "empty", "Due Projects Report : "+DateUtil.getCurrentDateIndianFormat(), messageTeamLeader, 2, "NA");
					}
				}
			}
			
			
//			Weekly notification of no action estimate
			
//			Notify sales person (his/her sales)
			String date7Daybefore=DateUtil.getDateAfterDays(-7);
			
			String[][] estimateUser=Enquiry_ACT.getAllDraftSalePersonByDate(date7Daybefore);
			
			if(estimateUser!=null&&estimateUser.length>0) {
				for(int i=0;i<estimateUser.length;i++) {
					
					String estimates[][]=Enquiry_ACT.getAllDraftSaleByDate(date7Daybefore,estimateUser[i][0]);
					
					if(estimates!=null&&estimates.length>0) {
						String estimateDraft="<div style=\"max-height: 25rem;overflow: auto;max-width: 60rem;\"><table border=\"1\" style=\"white-space: nowrap;\"><thead>"
								+ "<th>#</th><th>Reg. Date</th><th>Estimate No.</th>"
								+ "<th>Product Name</th><th>Qty.</th><th>Contact Name</th><th>Client</th><th>Sales Person</th>"
								+ "</thead><tbody>";
						for(int j=0;j<estimates.length;j++) {
//							esregdate,essaleno,esprodname,esprodqty,escontactrefid,escompany,essoldbyid,estoken
							String contactName=TaskMaster_ACT.getSalesContactName(estimates[j][4]);
							String userName=Usermaster_ACT.findUserByUaid(estimates[j][6]);
							estimateDraft+="<tr><td>"+(j+1)+"</td><td>"+estimates[j][0]+"</td><td>"+estimates[j][1]+"</td>"
									+ "<td>"+estimates[j][2]+"</td><td>"+estimates[j][3]+"</td>"
									+ "<td>"+contactName+"</td><td>"+estimates[j][5]+"</td><td>"+userName+"</td></tr>";							
						}
						//sending email to sales person
						estimateDraft+="</tbody></table></div>";
						String receiverName=Usermaster_ACT.findUserByUaid(estimateUser[i][0]);
						String emailTo=Usermaster_ACT.getUserEmail(estimateUser[i][0], estimateUser[i][1]);
						String message=ExcelGenerator.findDraftEstimateMessage(receiverName,estimateDraft);
						Enquiry_ACT.saveEmail(emailTo, "empty", "Draft estimates more than a week : "+DateUtil.getCurrentDateIndianFormat(), message, 2, "NA");
					}
				}
			}
			
//			Notify sales manager (his/her + his/her team�s)
			if(teams!=null&&teams.length>0) {
				for(int i=0;i<teams.length;i++) {		
					String estimates[][]=Enquiry_ACT.getAllDraftSaleByDateForManager(date7Daybefore,teams[i][0],teams[i][1]);
					if(estimates!=null&&estimates.length>0) {
						
						String estimateDraft="<div style=\"max-height: 25rem;overflow: auto;max-width: 60rem;\"><table border=\"1\" style=\"white-space: nowrap;\"><thead>"
								+ "<th>#</th><th>Reg. Date</th><th>Estimate No.</th>"
								+ "<th>Product Name</th><th>Qty.</th><th>Contact Name</th><th>Client</th><th>Sales Person</th>"
								+ "</thead><tbody>";
						
						for(int j=0;j<estimates.length;j++) {
//							esregdate,essaleno,esprodname,esprodqty,escontactrefid,escompany,essoldbyid,estoken
							String contactName=TaskMaster_ACT.getSalesContactName(estimates[j][4]);
							String userName=Usermaster_ACT.findUserByUaid(estimates[j][6]);
							estimateDraft+="<tr><td>"+(j+1)+"</td><td>"+estimates[j][0]+"</td><td>"+estimates[j][1]+"</td>"
									+ "<td>"+estimates[j][2]+"</td><td>"+estimates[j][3]+"</td>"
									+ "<td>"+contactName+"</td><td>"+estimates[j][5]+"</td><td>"+userName+"</td></tr>";							
						}
						//sending email to sales person
						estimateDraft+="</tbody></table></div>";
						String receiverName=teams[i][2];
						String emailTo=Usermaster_ACT.getUserEmail(teams[i][1], teams[i][3]);
						String message=ExcelGenerator.findDraftEstimateMessage(receiverName,estimateDraft);
						Enquiry_ACT.saveEmail(emailTo, "empty", "Draft estimates more than a week : "+DateUtil.getCurrentDateIndianFormat(), message, 2, "NA");
					}
				}
			}		
			
			
//-------------------------Delivery start--------------------------------------	
			
			//Notify assignee (his/her milestone) 
			String[][] agents=TaskMaster_ACT.findAllTomorrowDeliveryMilestoneAssignee(dateAfterDays);
			if(agents!=null&&agents.length>0) {
				for(int i=0;i<agents.length;i++){	
					
//					m.maworkstarteddate,m.masalesrefid,m.mamilestonename,m.maworkpercentage,"
//		           + "m.madeliverydate,m.maworkstatus,m.matokenno,ms.mscompany,ms.msproductname,ms.msinvoiceno
					String milestones[][]=TaskMaster_ACT.findAllTomorrowDeliveryMilestone(dateAfterDays,agents[i][0]);
					if(milestones!=null&&milestones.length>0) {
						
						String taskDelivery="<div style=\"max-height: 25rem;overflow: auto;max-width: 60rem;\"><table border=\"1\" style=\"white-space: nowrap;\"><thead>"
								+ "<th>#</th><th>Assign Date</th><th>Invoice</th><th>Company</th><th>Service</th><th>Milestone Name</th>"
								+ "<th>Work Percentage</th><th>Delivery Date</th><th>Status</th>"
								+ "</thead><tbody>";
						
						for(int j=0;j<milestones.length;j++) {
							
							//sending email to sales person
							taskDelivery+="<tr><td>"+(j+1)+"</td><td>"+milestones[j][0]+"</td><td>"+milestones[j][9]+"</td>"
									+ "<td>"+milestones[j][7]+"</td><td>"+milestones[j][8]+"</td><td>"+milestones[j][2]+"</td><td>"+milestones[j][3]+"%</td>"
									+ "<td>"+milestones[j][4]+"</td><td>"+milestones[j][5]+"</td></tr>";							
							
						}
						taskDelivery+="</tbody></table></div>";
						String receiverName=Usermaster_ACT.findUserByUaid(agents[i][0]);
						String emailTo=Usermaster_ACT.getUserEmail(agents[i][0], agents[i][1]);
						String message=ExcelGenerator.findTomorrowDeliveryMilestoneMessage(receiverName,taskDelivery);
						Enquiry_ACT.saveEmail(emailTo, "empty", "Milestone delivery on "+dateAfterDays, message, 2, "NA");
					}
				}
			}
			
			//Notify Operation manager (operation manager's milestone + his/her team's milestone)
			String deliveryTeam[][]=TaskMaster_ACT.findTeamByDepartment("Delivery");
			if(deliveryTeam!=null&&deliveryTeam.length>0) {
				for(int i=0;i<deliveryTeam.length;i++) {		
					String milestones[][]=TaskMaster_ACT.findAllTomorrowDeliveryMilestoneByTeam(dateAfterDays,deliveryTeam[i][0]);
					if(milestones!=null&&milestones.length>0) {
						String taskDeliveryManager="<div style=\"max-height: 25rem;overflow: auto;max-width: 60rem;\"><table border=\"1\" style=\"white-space: nowrap;\"><thead>"
								+ "<th>#</th><th>Assign Date</th><th>Invoice</th><th>Company</th><th>Service</th><th>Milestone Name</th>"
								+ "<th>Work Percentage</th><th>Delivery Date</th><th>Status</th><th>Assignee</th>"
								+ "</thead><tbody>";
						
						for(int j=0;j<milestones.length;j++) {
							String assignee=Usermaster_ACT.findUserByUaid(milestones[j][10]);
							//sending email to sales person
							taskDeliveryManager+="<tr><td>"+(j+1)+"</td><td>"+milestones[j][0]+"</td><td>"+milestones[j][9]+"</td>"
									+ "<td>"+milestones[j][7]+"</td><td>"+milestones[j][8]+"</td><td>"+milestones[j][2]+"</td><td>"+milestones[j][3]+"%</td>"
									+ "<td>"+milestones[j][4]+"</td><td>"+milestones[j][5]+"</td><td>"+assignee+"</td></tr>";								
							
						}
						taskDeliveryManager+="</tbody></table></div>";
						String receiverName=deliveryTeam[i][2];
						String emailTo=Usermaster_ACT.getUserEmail(deliveryTeam[i][1], deliveryTeam[i][3]);
						String message=ExcelGenerator.findTomorrowDeliveryMilestoneMessage(receiverName,taskDeliveryManager);
						Enquiry_ACT.saveEmail(emailTo, "sakshi.jaggi@corpseed.com", "Milestone delivery on "+dateAfterDays, message, 2, "NA");
					}
				}
			}

			//inactive sale but not cancelled notification
			//Notify operation manager (service is inactive)
			if(deliveryManager!=null&&deliveryManager.length>0) {
            	for (int k=0;k<deliveryManager.length;k++) {
            		String[][] inactiveSales=TaskMaster_ACT.findAllInactiveSale(deliveryManager[k][0]);
        			
        			if(inactiveSales!=null&&inactiveSales.length>0) {
        				String inactiveSalesTable="<div style=\"max-height: 25rem;overflow: auto;max-width: 60rem;\"><table border=\"1\" style=\"white-space: nowrap;\"><thead>"
        						+ "<th>#</th><th>Sold Date</th><th>Invoice</th><th>Project No.</th>"
        						+ "<th>Product Name</th><th>Contact Name</th><th>Client</th>"
        						+ "<th>Progress</th><th>Delivery Date</th><th>Sales Person</th>"
        						+ "</thead><tbody>";
        				for(int i=0;i<inactiveSales.length;i++) {
        					String contactName=TaskMaster_ACT.getSalesContactName(inactiveSales[i][5]);
        					String userName=Usermaster_ACT.findUserByUaid(inactiveSales[i][8]);
        					inactiveSalesTable+="<tr><td>"+(i+1)+"</td><td>"+inactiveSales[i][1]+"</td>"
        							+ "<td>"+inactiveSales[i][2]+"</td><td>"+inactiveSales[i][3]+"</td>"
        									+ "<td>"+inactiveSales[i][4]+"</td>"
        							+ "<td>"+contactName+"</td><td>"+inactiveSales[i][6]+"</td>"
        									+ "<td>"+inactiveSales[i][7]+"%</td><td>"+inactiveSales[i][11]+"</td>"
        											+ "<td>"+userName+"</td></tr>";
        				}
        				inactiveSalesTable+="</tbody></table></div>";
        				String emailTo=deliveryManager[k][2];
        				String Subject="Inactive Sales Report : "+DateUtil.getCurrentDateIndianFormat();
        				//sending email to quality 
        				String message=ExcelGenerator.findInactiveSalesMessage(deliveryManager[k][1],inactiveSalesTable);
        				Enquiry_ACT.saveEmail(emailTo, "empty", Subject, message, 2, "NA");
        			}
            	}
			}		
			//Notify Expired milestone to sales person (his/her milestone)
			
			String[][] expiredAgents=TaskMaster_ACT.findAllExpiredTaskAssignee();
			if(expiredAgents!=null&&expiredAgents.length>0) {
				for(int i=0;i<expiredAgents.length;i++){	
					
//					 m.maworkstarteddate,m.masalesrefid,m.mamilestonename,m.maworkpercentage,"
//					+ "m.madeliverydate,m.maworkstatus,m.matokenno,ms.mscompany,ms.msproductname,ms.msinvoiceno
					String[][] expiredMilestone=TaskMaster_ACT.findAllExpiredMilestone(expiredAgents[i][0]);
					if(expiredMilestone!=null&&expiredMilestone.length>0) {
						
						String taskDelivery="<div style=\"max-height: 25rem;overflow: auto;max-width: 60rem;\"><table border=\"1\" style=\"white-space: nowrap;\"><thead>"
								+ "<th>#</th><th>Assign Date</th><th>Service</th><th>Company</th><th>Invoice</th><th>Milestone Name</th>"
								+ "<th>Work Percentage</th><th>Delivery Date</th><th>Status</th>"
								+ "</thead><tbody>";
						
						for(int j=0;j<expiredMilestone.length;j++) {
							
							//sending email to sales person
							taskDelivery+="<tr><td>"+(j+1)+"</td><td>"+expiredMilestone[j][0]+"</td><td>"+expiredMilestone[j][8]+"</td>"
									+ "<td>"+expiredMilestone[j][7]+"</td><td>"+expiredMilestone[j][9]+"</td>"
									+ "<td>"+expiredMilestone[j][2]+"</td><td>"+expiredMilestone[j][3]+"%</td>"
									+ "<td>"+expiredMilestone[j][4]+"</td><td>"+expiredMilestone[j][5]+"</td></tr>";							
							
						}
						taskDelivery+="</tbody></table></div>";
						String receiverName=Usermaster_ACT.findUserByUaid(expiredAgents[i][0]);
						String emailTo=Usermaster_ACT.getUserEmail(expiredAgents[i][0], expiredAgents[i][1]);
						String message=ExcelGenerator.findExpiredMilestoneMessage(receiverName,taskDelivery);
						Enquiry_ACT.saveEmail(emailTo, "empty", "Expired Milestone Report : "+DateUtil.getCurrentDateIndianFormat(), message, 2, "NA");
					}
				}
			}
			
			//Notify Expired Milestone to delivery manager (his/her milestone + team�s milestone)
			if(deliveryTeam!=null&&deliveryTeam.length>0) {
				for(int i=0;i<deliveryTeam.length;i++) {		
					String expiredMilestone[][]=TaskMaster_ACT.findAllExpiredMilestoneByTeam(deliveryTeam[i][0]);
					if(expiredMilestone!=null&&expiredMilestone.length>0) {
						String taskDeliveryManager="<div style=\"max-height: 25rem;overflow: auto;max-width: 60rem;\"><table border=\"1\" style=\"white-space: nowrap;\"><thead>"
								+ "<th>#</th><th>Assign Date</th><th>Service</th><th>Company</th><th>Invoice</th><th>Milestone Name</th>"
								+ "<th>Work Percentage</th><th>Delivery Date</th><th>Status</th><th>Assignee</th>"
								+ "</thead><tbody>";
						
						for(int j=0;j<expiredMilestone.length;j++) {
							String assignee=Usermaster_ACT.findUserByUaid(expiredMilestone[j][10]);
							//sending email to sales person
							taskDeliveryManager+="<tr><td>"+(j+1)+"</td><td>"+expiredMilestone[j][0]+"</td><td>"+expiredMilestone[j][8]+"</td>"
									+ "<td>"+expiredMilestone[j][7]+"</td><td>"+expiredMilestone[j][9]+"</td>"
									+ "<td>"+expiredMilestone[j][2]+"</td><td>"+expiredMilestone[j][3]+"%</td>"
									+ "<td>"+expiredMilestone[j][4]+"</td><td>"+expiredMilestone[j][5]+"</td><td>"+assignee+"</td></tr>";						
							
						}
						taskDeliveryManager+="</tbody></table></div>";
						String receiverName=deliveryTeam[i][2];
						String emailTo=Usermaster_ACT.getUserEmail(deliveryTeam[i][1], deliveryTeam[i][3]);
						String message=ExcelGenerator.findExpiredMilestoneMessage(receiverName,taskDeliveryManager);
						Enquiry_ACT.saveEmail(emailTo, "sakshi.jaggi@corpseed.com", "Expired Milestone Report "+DateUtil.getCurrentDateIndianFormat(), message, 2, "NA");
					}
				}
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
