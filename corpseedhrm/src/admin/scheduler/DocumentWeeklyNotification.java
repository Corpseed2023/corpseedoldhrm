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
import commons.CommonHelper;
import commons.DateUtil;

public class DocumentWeeklyNotification extends TimerTask {

	@Override
	public void run() {
		try {
			String[] findPreviousWeekStartEndDate = DateUtil.findPreviousWeekStartEndDate();
			String date7DaysBefore = findPreviousWeekStartEndDate[0];
			
			String today=findPreviousWeekStartEndDate[1];
//		System.out.println(date7DaysBefore+"\n"+today);
		
		String teams[][]=TaskMaster_ACT.findTeamByDepartment("Document");
		if(teams!=null&&teams.length>0) {				
			for(int t=0;t<teams.length;t++) {		
				String sales[][]=TaskMaster_ACT.findWeeklyDocumentSales(date7DaysBefore,today,teams[t][0]);
				if(sales!=null&&sales.length>0) {
					
					List<String> headerListManager=Arrays.asList("Invoice","Project_No",
							"Service_Name","Company","Assign_Date_Time","Delivery_Date_Time","Delivered_Date",
							"Assignee","TAT","Delivery_TAT","Status","Uploaded");
					
					String fileName="document_weekly_report_"+teams[t][2].replace(" ", "_");
					String excelFilePathManager =ExcelGenerator.getFileName(fileName,"xlsx");			
					XSSFWorkbook workbookManager = new XSSFWorkbook();
					XSSFSheet sheetManager = workbookManager.createSheet(fileName);
					
					ExcelGenerator.generateExcelHeader(headerListManager,sheetManager);
					
					for(int i=0;i<sales.length;i++) {
						String delivered="In Progess";
						String deliveryTat="In Progress";
						String status="NA";
						String uploaded=TaskMaster_ACT.findClientDocumentUploads(sales[i][0], sales[i][18],2);
						
						if(sales[i][16]!=null&&!sales[i][16].equalsIgnoreCase("NA")&&
								sales[i][17]!=null&&!sales[i][17].equalsIgnoreCase("NA")) {
							delivered=sales[i][16]+" "+sales[i][17];
							
							if(sales[i][11]!=null&&!sales[i][11].equalsIgnoreCase("NA")&&sales[i][12]!=null&&!sales[i][12].equalsIgnoreCase("NA"))
							deliveryTat=CommonHelper.getTime(sales[i][11], sales[i][12], sales[i][16].substring(6)+sales[i][16].substring(2,6)+sales[i][16].substring(0,2), sales[i][17]);
						}
						if(sales[i][15].equals("1"))status="Active";else if(sales[i][15].equals("2"))status="Inactive";else if(sales[i][15].equals("3"))status="Expired";else if(status.equals("4"))status="Completed";
						
						Row rowManager = sheetManager.createRow((i+1));
						ExcelGenerator.setExcelValue(Arrays.asList(sales[i][1],sales[i][2],sales[i][3],sales[i][4],sales[i][11]+" "+sales[i][12]
										,sales[i][13]+" "+sales[i][14],delivered,sales[i][10],sales[i][7]+" "+sales[i][8]
										,deliveryTat,status,uploaded),rowManager,workbookManager);
					}
					ExcelGenerator.uploadExportedFile(excelFilePathManager,workbookManager);
					String filePathManager="https://corpseednew.blob.core.windows.net/corpseed-crm/"+excelFilePathManager;
//					System.out.println("filePathManager"+filePathManager);
					String message=ExcelGenerator.findDocumentWeeklyMessage(date7DaysBefore, today, teams[t][2], filePathManager);
					String emailTo=Usermaster_ACT.getUserEmail(teams[t][1], teams[t][3]);
					Enquiry_ACT.saveEmail(emailTo, "empty", "Document Weekly Report between "+date7DaysBefore+" to "+today, message, 2, "NA");					
				}
			}
		}
	}catch(Exception e) {
		e.printStackTrace();
	}
	}
}
