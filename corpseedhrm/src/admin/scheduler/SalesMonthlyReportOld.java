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

public class SalesMonthlyReportOld extends TimerTask {

	@Override
	public void run() {
		
		try {
			//sales monthly report
			String endDate = DateUtil.findPreviousMonthEndDate(1);
			String startDate=endDate.substring(0, 8)+"01";
			
//			System.out.println("SalesMonthlyReport="+startDate+"#"+endDate);
			
			List<String> headerListOperation=Arrays.asList("Date","Invoice","Project_No",
					"Product_Name","Contact_Name","Client","Progress","Status","Sold_By");
			
			List<String> headerListQuality=Arrays.asList("Date","Invoice","Project_No",
					"Product_Name","Contact_Name","Client","Order_Amount","Received_Amount",
					"Progress","Status","Sold_By");
			
			String excelFilePathOperation =ExcelGenerator.getFileName("sales_monthly_report","xlsx");
						
			String excelFilePathQuality =ExcelGenerator.getFileName("sales_monthly_report","xlsx");			
						
			XSSFWorkbook workbookQuality = new XSSFWorkbook();
			XSSFWorkbook workbookOperation = new XSSFWorkbook();
			
			XSSFSheet sheetOperation = workbookOperation.createSheet("sales_monthly_report");
            XSSFSheet sheetQuality = workbookQuality.createSheet("sales_monthly_report");
            
            ExcelGenerator.generateExcelHeader(headerListOperation,sheetOperation);
            ExcelGenerator.generateExcelHeader(headerListQuality,sheetQuality);
            
                        
			//send sales report to quality
			String[][] sales=TaskMaster_ACT.findSalesByBetweenDates(startDate, endDate);
			if(sales!=null&&sales.length>0) {
				String invoice="";
				for(int i=0;i<sales.length;i++) {
					
					String status="Cancelled";
					if(sales[i][9].equalsIgnoreCase("2"))status=sales[i][10];
					String contactName=TaskMaster_ACT.getSalesContactName(sales[i][5]);
					String userName=Usermaster_ACT.findUserByUaid(sales[i][8]);
					double orderAmount=TaskMaster_ACT.findSalesOrderAmount(sales[i][0]);
					double receivedAmount=TaskMaster_ACT.getSalesPaidAmount(sales[i][2],sales[i][11]);

					Row rowOperation = sheetOperation.createRow((i+1));
										
					ExcelGenerator.setExcelValue(Arrays.asList(sales[i][1],sales[i][2],sales[i][3],sales[i][4],
							contactName,sales[i][6],sales[i][7]+"%",status,userName),rowOperation,workbookOperation);
					
					Row rowQuality = sheetQuality.createRow((i+1));
					
					if(invoice.equalsIgnoreCase(sales[i][2]))
						ExcelGenerator.setExcelValue(Arrays.asList(sales[i][1],sales[i][2],sales[i][3],sales[i][4],
							contactName,sales[i][6],orderAmount," ",sales[i][7]+"%",status,userName),rowQuality,workbookQuality);
					else {
						ExcelGenerator.setExcelValue(Arrays.asList(sales[i][1],sales[i][2],sales[i][3],sales[i][4],
								contactName,sales[i][6],orderAmount,receivedAmount,sales[i][7]+"%",status,userName),rowQuality,workbookQuality);
						invoice=sales[i][2];
					}
					
				}
			}
			
			ExcelGenerator.uploadExportedFile(excelFilePathOperation,workbookOperation);
			String filePathOperation="https://corpseeds.blob.core.windows.net/corpseed-crm/"+excelFilePathOperation;
			
			ExcelGenerator.uploadExportedFile(excelFilePathQuality,workbookQuality);
			String filePathQuality="https://corpseeds.blob.core.windows.net/corpseed-crm/"+excelFilePathQuality;			
			
//			System.out.println(filePathQuality);
//			System.out.println(filePathOperation);
			
			String emailTo="navjot.singh@corpseed.com";
			String emailToCC="vipan@corpseed.com";
			String Subject="Monthly Sales Report : "+startDate+" - "+endDate;
			//sending email to quality 
			String messageQuality=ExcelGenerator.findSalesMonthlyMessage(startDate,endDate,"Navjot",filePathQuality);
			Enquiry_ACT.saveEmail(emailTo, emailToCC, Subject, messageQuality, 2, "NA");
			String messageAccountant=ExcelGenerator.findSalesMonthlyMessage(startDate,endDate,"Praveen",filePathQuality);
			Enquiry_ACT.saveEmail("praveen.kumar@corpseed.com", "empty", Subject, messageAccountant, 2, "NA");
			
			emailTo="suneeta.tikoo@corpseed.com";
			emailToCC="empty";
			Subject="Monthly Sales Report : "+startDate+" - "+endDate;
			//sending email to operation 
			String messageOperation=ExcelGenerator.findSalesMonthlyMessage(startDate,endDate,"Suneeta",filePathOperation);
			Enquiry_ACT.saveEmail(emailTo, emailToCC, Subject, messageOperation, 2, "NA");
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	
}
