package admin.scheduler;

import java.util.Arrays;
import java.util.List;
import java.util.TimerTask;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import admin.enquiry.Enquiry_ACT;
import admin.export.ExcelGenerator;
import admin.master.Usermaster_ACT;
import admin.task.TaskMaster_ACT;
import commons.DateUtil;

public class SalesWeeklyReport extends TimerTask {

	@Override
	public void run() {
		
		try {
			String[] findPreviousWeekStartEndDate = DateUtil.findPreviousWeekStartEndDate();
			String date7DaysBefore = findPreviousWeekStartEndDate[0];
			
			String today=findPreviousWeekStartEndDate[1];
					
//			System.out.println("SalesWeeklyReport="+date7DaysBefore+"#"+today);
		    
			List<String> headerList=Arrays.asList("Sold_Date","Invoice","Project_No",
					"Product_Name","Contact_Name","Client","Order_Amount","Received_Amount",
					"Progress","Status","Sold_By");
					
			
			String excelFilePathAccountant =ExcelGenerator.getFileName("sales_weekly_report","xlsx");			
			XSSFWorkbook workbookAccountant = new XSSFWorkbook();
			XSSFSheet sheetAccountant = workbookAccountant.createSheet("sales_weekly_report");
			ExcelGenerator.generateExcelHeader(headerList,sheetAccountant);
			
			//for sales executive weekly report
			String users[][]=TaskMaster_ACT.findWeeklySalesPerson(date7DaysBefore,today);
			if(users!=null&&users.length>0) {				
				int r=1;
				for(int i=0;i<users.length;i++) {
					
					String executiveReport="<div style=\"max-height: 25rem;overflow: auto;max-width: 60rem;\"><table border=\"1\" style=\"white-space: nowrap;\"><thead>"
							+ "<th>#</th><th>Sold Date</th><th>Invoice</th><th>Project No.</th>"
							+ "<th>Product Name</th><th>Contact Name</th><th>Client</th><th>Order Amount</th><th>Received Amount</th>"
							+ "<th>Progress</th><th>Status</th><th>Sold By</th>"
							+ "</thead><tbody>";
					
					String sales[][]=TaskMaster_ACT.findSalesByBetweenDates(date7DaysBefore,today,users[i][0]);
					if(sales!=null&&sales.length>0) {
						String invoice="";
						for(int j=0;j<sales.length;j++) {
							//weekly report for accountant
							String status="Cancelled";
							if(sales[j][9].equalsIgnoreCase("2"))status=sales[j][10];
							String contactName=TaskMaster_ACT.getSalesContactName(sales[j][5]);
							String userName=Usermaster_ACT.findUserByUaid(sales[j][8]);
							double orderAmount=TaskMaster_ACT.findSalesOrderAmount(sales[j][0]);
							double receivedAmount=TaskMaster_ACT.getSalesPaidAmount(sales[j][2],sales[j][11]);
							
							Row rowAccountant = sheetAccountant.createRow(r);
							
							if(invoice.equalsIgnoreCase(sales[j][2])) {
								ExcelGenerator.setExcelValue(Arrays.asList(sales[j][1],sales[j][2],sales[j][3],sales[j][4],
									contactName,sales[j][6],orderAmount," ",sales[j][7]+"%",status,userName),rowAccountant,workbookAccountant);
								
								//weekly report for sales executive
								executiveReport+="<tr><td>"+r+"</td><td>"+sales[j][1]+"</td><td>"+sales[j][2]+"</td><td>"+sales[j][3]+"</td><td>"+sales[j][4]+"</td>"
										+ "<td>"+contactName+"</td><td>"+sales[j][6]+"</td><td>"+orderAmount+"</td><td>_</td><td>"+sales[j][7]+"</td><td>"+status+"</td>"
										+ "<td>"+userName+"</td></tr>";
								
							}else {
								ExcelGenerator.setExcelValue(Arrays.asList(sales[j][1],sales[j][2],sales[j][3],sales[j][4],
										contactName,sales[j][6],orderAmount,receivedAmount,sales[j][7]+"%",status,userName),rowAccountant,workbookAccountant);
								
								//weekly report for sales executive
								executiveReport+="<tr><td>"+r+"</td><td>"+sales[j][1]+"</td><td>"+sales[j][2]+"</td><td>"+sales[j][3]+"</td><td>"+sales[j][4]+"</td>"
										+ "<td>"+contactName+"</td><td>"+sales[j][6]+"</td><td>"+orderAmount+"</td><td>"+receivedAmount+"</td><td>"+sales[j][7]+"</td><td>"+status+"</td>"
										+ "<td>"+userName+"</td></tr>";
								
								invoice=sales[j][2];
							}
							r++;
							
							
						}
						executiveReport+="</tbody></table></div>";
						
						//store in table and send to sales person
	//					System.out.println("sales report for executives=="+sales[i][0]);
						String userDetails[]=Usermaster_ACT.findUserDetailsByUaid(users[i][0]);
						//get sales executive message
						String message=ExcelGenerator.getSalesExecutiveMessage(userDetails[0],executiveReport,date7DaysBefore,today);
						//userDetails[1]
						Enquiry_ACT.saveEmail(userDetails[1], "empty", "Sales Weekly Report between "+date7DaysBefore+" to "+today, message, 2, "NA");
					}
				}				
				//Send weekly report to accountant
				ExcelGenerator.uploadExportedFile(excelFilePathAccountant,workbookAccountant);
				String filePathAccountant="https://corpseednew.blob.core.windows.net/corpseed-crm/"+excelFilePathAccountant;				
//				System.out.println("sales path="+filePathAccountant);
				String messageAccountant = ExcelGenerator.findWeeklyMessage(date7DaysBefore, today,"Praveen Kumar",filePathAccountant);
				Enquiry_ACT.saveEmail("praveen.kumar@corpseed.com", "empty", "Sales Weekly Report between "+date7DaysBefore+" to "+today, messageAccountant, 2, "NA");
			}else workbookAccountant.close();			
			
//			System.out.println("-------weekly report for sales manager-------");
			
			//weekly report for sales manager
			String teams[][]=TaskMaster_ACT.findTeamByDepartment("Sales");
			if(teams!=null&&teams.length>0) {				
				for(int i=0;i<teams.length;i++) {
					
					List<String> headerListManager=Arrays.asList("Sold_Date","Invoice","Project_No",
							"Product_Name","Contact_Name","Client","Order_Amount","Received Amount",
							"Progress","Status","Sold_By");
					
					String fileName="sales_weekly_report_"+teams[i][2].replace(" ", "_");
					String excelFilePathManager =ExcelGenerator.getFileName(fileName,"xlsx");			
					XSSFWorkbook workbookManager = new XSSFWorkbook();
					XSSFSheet sheetManager = workbookManager.createSheet(fileName);
					
					ExcelGenerator.generateExcelHeader(headerListManager,sheetManager);
					
					String sales1[][]=TaskMaster_ACT.findSalesByBetweenDatesAndTeam(date7DaysBefore,today,teams[i][0],teams[i][1]);
					if(sales1!=null&&sales1.length>0) {
						String invoice="";
						for(int j=0;j<sales1.length;j++) {
							
							String status="Cancelled";
							if(sales1[j][9].equalsIgnoreCase("2"))status=sales1[j][10];
							String contactName=TaskMaster_ACT.getSalesContactName(sales1[j][5]);
							String userName=Usermaster_ACT.findUserByUaid(sales1[j][8]);
							double orderAmount=TaskMaster_ACT.findSalesOrderAmount(sales1[j][0]);
							double receivedAmount=TaskMaster_ACT.getSalesPaidAmount(sales1[j][2],sales1[j][11]);

							Row rowManager = sheetManager.createRow((j+1));
							if(invoice.equalsIgnoreCase(sales1[j][2]))
								ExcelGenerator.setExcelValue(Arrays.asList(sales1[j][1],sales1[j][2],sales1[j][3],sales1[j][4],
									contactName,sales1[j][6],orderAmount," ",sales1[j][7]+"%",status,userName),rowManager,workbookManager);
							else {
								ExcelGenerator.setExcelValue(Arrays.asList(sales1[j][1],sales1[j][2],sales1[j][3],sales1[j][4],
										contactName,sales1[j][6],orderAmount,receivedAmount,sales1[j][7]+"%",status,userName),rowManager,workbookManager);
								invoice=sales1[j][2];
							}
						}		
						ExcelGenerator.uploadExportedFile(excelFilePathManager,workbookManager);
						String filePathManager="https://corpseednew.blob.core.windows.net/corpseed-crm/"+excelFilePathManager;
//						System.out.println("filePathManager"+filePathManager);
						String message=ExcelGenerator.findWeeklyMessage(date7DaysBefore, today, teams[i][2], filePathManager);
						String emailTo=Usermaster_ACT.getUserEmail(teams[i][1], teams[i][3]);
						Enquiry_ACT.saveEmail(emailTo, "empty", "Sales Weekly Report between "+date7DaysBefore+" to "+today, message, 2, "NA");
						
					}else
						workbookManager.close();
					
				}
			}
			
			//due sales weekly report
			//weekly report for sales manager	
					
			List<String> headerListceo=Arrays.asList("Sold_Date","Invoice","Project_No",
					"Product_Name","Contact_Name","Client","Order_Amount","Due_Amount",
					"Progress","Delivery_Date","Status","Sales_Person","Service_Type");
			
			String fileName="due_sales_weekly_report";
			String excelFilePathceo =ExcelGenerator.getFileName(fileName,"xlsx");			
			XSSFWorkbook workbookceo = new XSSFWorkbook();
			XSSFSheet sheetceo = workbookceo.createSheet(fileName);
			
			ExcelGenerator.generateExcelHeader(headerListceo,sheetceo);
			
			String sales1[][]=TaskMaster_ACT.findDueSales("NA");
			if(sales1!=null&&sales1.length>0) {
				String invoice="";
				for(int j=0;j<sales1.length;j++) {
					
					String status="Cancelled";
					if(sales1[j][9].equalsIgnoreCase("2"))status=sales1[j][10];
					String contactName=TaskMaster_ACT.getSalesContactName(sales1[j][5]);
					String userName=Usermaster_ACT.findUserByUaid(sales1[j][8]);
					double orderAmount=TaskMaster_ACT.findSalesOrderAmount(sales1[j][0]);
					double orderDueAmount=Double.parseDouble(sales1[j][13]);
					String saleType="Non-Consulting Service";
					if(sales1[j][14].equals("2"))saleType="Consulting Service";

					Row rowceo = sheetceo.createRow((j+1));
					if(invoice.equalsIgnoreCase(sales1[j][2]))
						ExcelGenerator.setExcelValue(Arrays.asList(sales1[j][1],sales1[j][2],sales1[j][3],sales1[j][4],
							contactName,sales1[j][6],Math.ceil(orderAmount)," ",sales1[j][7]+"%",sales1[j][11],status,userName,saleType),rowceo,workbookceo);
					else {
						ExcelGenerator.setExcelValue(Arrays.asList(sales1[j][1],sales1[j][2],sales1[j][3],sales1[j][4],
								contactName,sales1[j][6],Math.ceil(orderAmount),Math.ceil(orderDueAmount),sales1[j][7]+"%",sales1[j][11],status,userName,saleType),rowceo,workbookceo);
						invoice=sales1[j][2];
					}
				}		
				ExcelGenerator.uploadExportedFile(excelFilePathceo,workbookceo);
				String filePathceo="https://corpseednew.blob.core.windows.net/corpseed-crm/"+excelFilePathceo;
//						System.out.println("filePathManager"+filePathManager);
				String message=ExcelGenerator.findDueSalesMessageForCeo("Vipan", filePathceo,date7DaysBefore+" to "+today);
				Enquiry_ACT.saveEmail("update@corpseed.com", "empty", "Due Sales Report", message, 2, "NA");
				
			}else
				workbookceo.close();		
			
			
//			String date7Daybefore=DateUtil.getDateAfterDays(-7);
											
			String estimates[][]=Enquiry_ACT.getAllDraftSaleByDate(date7DaysBefore,"NA");
			
			if(estimates!=null&&estimates.length>0) {
								
				List<String> estimateReportCeo=Arrays.asList("Reg_Date","Estimate_No",
						"Product_Name","Quantity","Contact_Name","Client","Sales_Person","Service_Type");
				
				String fileNameDraft="draft_estimate_report";
				String excelFilePathDraft =ExcelGenerator.getFileName(fileNameDraft,"xlsx");			
				XSSFWorkbook workbookDraft = new XSSFWorkbook();
				XSSFSheet sheetDraft = workbookDraft.createSheet(fileNameDraft);
				
				ExcelGenerator.generateExcelHeader(estimateReportCeo,sheetDraft);
				
				for(int j=0;j<estimates.length;j++) {
					String contactName=TaskMaster_ACT.getSalesContactName(estimates[j][4]);
					String userName=Usermaster_ACT.findUserByUaid(estimates[j][6]);
					String saleType="Non-Consulting Service";
					if(estimates[j][8].equals("2"))saleType="Consulting Service";
					
					Row rowDraft = sheetDraft.createRow((j+1));
					
					ExcelGenerator.setExcelValue(Arrays.asList(estimates[j][0],estimates[j][1],estimates[j][2],estimates[j][3],
							contactName,estimates[j][5],userName,saleType),rowDraft,workbookDraft);											
				}
				ExcelGenerator.uploadExportedFile(excelFilePathDraft,workbookDraft);
				String filePathDraft="https://corpseednew.blob.core.windows.net/corpseed-crm/"+excelFilePathDraft;
				String receiverName="Vipan";
				String emailTo="update@corpseed.com";
				String message=ExcelGenerator.findDraftEstimateMessageCeo(receiverName,filePathDraft);
				Enquiry_ACT.saveEmail(emailTo, "empty", "More than one week draft estimates report. : "+DateUtil.getCurrentDateIndianFormat(), message, 2, "NA");
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
