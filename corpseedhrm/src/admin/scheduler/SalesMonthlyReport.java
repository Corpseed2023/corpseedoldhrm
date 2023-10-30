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

public class SalesMonthlyReport extends TimerTask {

	@Override
	public void run() {
		
		try {
			//sales monthly report
			String endDate = DateUtil.findPreviousMonthEndDate(1);
			String startDate=endDate.substring(0, 8)+"01";
			
//			System.out.println("SalesMonthlyReport="+startDate+"#"+endDate);
			           
            String deliveryManager[][]=Usermaster_ACT.findAllUserByDepartmentAndRole("Delivery", "Manager");
            if(deliveryManager!=null&&deliveryManager.length>0) {
            	for (int k=0;k<deliveryManager.length;k++) {
            		
            		String[][] sales=TaskMaster_ACT.findDeliverySalesByBetweenDates(startDate, endDate,deliveryManager[k][0]);
            		if(sales!=null&&sales.length>0) {
            			
            			List<String> headerListOperation=Arrays.asList("Sold_Date","Invoice","Project_No",
            					"Product_Name","Contact_Name","Client","Progress","Status","Sold_By");
                    	
                    	String fileName="sales_monthly_report"+deliveryManager[k][1].replace(" ", "_").toLowerCase();
        				String excelFilePathOperation =ExcelGenerator.getFileName(fileName,"xlsx");			
        				XSSFWorkbook workbookOperation = new XSSFWorkbook();
        				XSSFSheet sheetOperation = workbookOperation.createSheet(fileName);    				
        				ExcelGenerator.generateExcelHeader(headerListOperation,sheetOperation);             			
            			
        				for(int i=0;i<sales.length;i++) {
        					
        					String status="Cancelled";
        					if(sales[i][9].equalsIgnoreCase("2"))status=sales[i][10];
        					String contactName=TaskMaster_ACT.getSalesContactName(sales[i][5]);
        					String userName=Usermaster_ACT.findUserByUaid(sales[i][8]);

        					Row rowOperation = sheetOperation.createRow((i+1));
        										
        					ExcelGenerator.setExcelValue(Arrays.asList(sales[i][1],sales[i][2],sales[i][3],sales[i][4],
        							contactName,sales[i][6],sales[i][7]+"%",status,userName),rowOperation,workbookOperation);
        					        					
        				}
        				
        				ExcelGenerator.uploadExportedFile(excelFilePathOperation,workbookOperation);
        				String filePathOperation="https://corpseeds.blob.core.windows.net/corpseed-crm/"+excelFilePathOperation;
        				//sending email to operation 
        				String messageOperation=ExcelGenerator.findSalesMonthlyMessage(startDate,endDate,deliveryManager[k][1],filePathOperation);
        				Enquiry_ACT.saveEmail(deliveryManager[k][2], "sakshi.jaggi@corpseed.com", "Monthly Sales Report : "+startDate+" - "+endDate, messageOperation, 2, deliveryManager[k][3]);
        				
        			}
				}
            }
                    
            
			//send sales report to quality
			String[][] sales=TaskMaster_ACT.findSalesByBetweenDates(startDate, endDate);
			if(sales!=null&&sales.length>0) {
				List<String> headerListQuality=Arrays.asList("Sold_Date","Invoice","Project_No",
						"Product_Name","Contact_Name","Client","Order_Amount","Received_Amount",
						"Progress","Status","Sold_By","Assignee","Service_Type");
				
							
				String excelFilePathQuality =ExcelGenerator.getFileName("sales_monthly_report","xlsx");							
				XSSFWorkbook workbookQuality = new XSSFWorkbook();			
	            XSSFSheet sheetQuality = workbookQuality.createSheet("sales_monthly_report");            
	            ExcelGenerator.generateExcelHeader(headerListQuality,sheetQuality);
				
				String invoice="";
				for(int i=0;i<sales.length;i++) {
					
					String status="Cancelled";
					if(sales[i][9].equalsIgnoreCase("2"))status=sales[i][10];
					String contactName=TaskMaster_ACT.getSalesContactName(sales[i][5]);
					String userName=Usermaster_ACT.findUserByUaid(sales[i][8]);
					double orderAmount=TaskMaster_ACT.findSalesOrderAmount(sales[i][0]);
					double receivedAmount=TaskMaster_ACT.getSalesPaidAmount(sales[i][2],sales[i][11]);
					String saleType="Non-Consulting Service";
					if(sales[i][13].equals("2"))saleType="Consulting Service";
					Row rowQuality = sheetQuality.createRow((i+1));
					
					if(invoice.equalsIgnoreCase(sales[i][2]))
						ExcelGenerator.setExcelValue(Arrays.asList(sales[i][1],sales[i][2],sales[i][3],sales[i][4],
							contactName,sales[i][6],orderAmount," ",sales[i][7]+"%",status,userName,sales[i][12],saleType),rowQuality,workbookQuality);
					else {
						ExcelGenerator.setExcelValue(Arrays.asList(sales[i][1],sales[i][2],sales[i][3],sales[i][4],
								contactName,sales[i][6],orderAmount,receivedAmount,sales[i][7]+"%",status,userName,sales[i][12],saleType),rowQuality,workbookQuality);
						invoice=sales[i][2];
					}
					
				}
				ExcelGenerator.uploadExportedFile(excelFilePathQuality,workbookQuality);
				String filePathQuality="https://corpseeds.blob.core.windows.net/corpseed-crm/"+excelFilePathQuality;			
				
//				System.out.println(filePathQuality);
//				System.out.println(filePathOperation);
				
				String emailTo="navjot.singh@corpseed.com";
				String emailToCC="vipan@corpseed.com";
				String Subject="Monthly Sales Report : "+startDate+" - "+endDate;
				//sending email to quality 
				String messageQuality=ExcelGenerator.findSalesMonthlyMessage(startDate,endDate,"Navjot",filePathQuality);
				Enquiry_ACT.saveEmail(emailTo, emailToCC, Subject, messageQuality, 2, "NA");
				String messageAccountant=ExcelGenerator.findSalesMonthlyMessage(startDate,endDate,"Praveen",filePathQuality);
				Enquiry_ACT.saveEmail("praveen.kumar@corpseed.com", "empty", Subject, messageAccountant, 2, "NA");		
				
			}	
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	
}
