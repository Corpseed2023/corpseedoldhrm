package admin.export;

import java.io.File;
import java.io.FileOutputStream;
import java.util.Date;
import java.util.List;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import admin.master.CloudService;
import commons.CommonHelper;

public class ExcelGenerator {

	public static void formatDateCell(XSSFWorkbook workbook, Cell cell) {
        CellStyle cellStyle = workbook.createCellStyle();
        CreationHelper creationHelper = workbook.getCreationHelper();
        cellStyle.setDataFormat(creationHelper.createDataFormat().getFormat("yyyy-MM-dd"));
        cell.setCellStyle(cellStyle); 
    }
	public static String getFileName(String baseName,String formate) throws InterruptedException {
		Thread.sleep(100);
        return baseName.concat(String.format("_%s."+formate, System.currentTimeMillis()));
    }
	public static Row generateExcelHeader(List<String> headerList,XSSFSheet sheet) {
		Row headerRow = sheet.createRow(0);
		
		int i=0;
		for (String h : headerList) {
			Cell headerCell = headerRow.createCell(i);
	        headerCell.setCellValue(h);
	        i++;
		}
        return headerRow;       
	}
	public static void setExcelValue(List<Object> data,Row row,XSSFWorkbook workbook) {
		int i=0;
		for (Object d : data) {
			Cell cell = row.createCell(i);
			
			if (d instanceof Boolean)
                cell.setCellValue((Boolean) d);
            else if (d instanceof Integer)
                cell.setCellValue((Integer) d);
            else if (d instanceof Double)
                cell.setCellValue((double) d);
            else if (d instanceof Float)
                cell.setCellValue((float) d);
            else if (d instanceof Date) {
                cell.setCellValue((Date) d);
                formatDateCell(workbook, cell);
            } else cell.setCellValue((String) d);
			
			i++;
		}		
	}
	public static void uploadExportedFile(String excelFilePath,XSSFWorkbook workbook) {
//		String basePath="D:\\eclipse space\\corpseedhrm\\WebContent\\exported";
		String basePath="home/site/wwwroot/exported";
//		String basePath="D:\\oldcrm_21sept\\crm_24jan\\WebContent\\exported";//for local changes and reports
		
		try {
			FileOutputStream outputStream = new FileOutputStream(basePath+"/"+excelFilePath);
	        workbook.write(outputStream);
	        workbook.close();
	        outputStream.close();        
        
			Thread.sleep(2000);
		
	        File path = new File(basePath+"/"+excelFilePath);
	        CloudService.uploadDocument(path, excelFilePath);
			if(path.exists())path.delete();
		
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public static String findWeeklyMessage(String startDate, String endDate,String receiverName,String filePath) {
		return "<table border=\"0\" style=\"margin:0 auto; min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\r\n"
				+ "        <tbody><tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\r\n"
				+ "                <a href=\"#\" target=\"_blank\">\r\n"
				+ "                <img src=\"https://www.corpseed.com/assets/img/logo.png\"></a>\r\n"
				+ "            </td></tr>\r\n"
				+ "            <tr>\r\n"
				+ "              <td style=\"text-align: center;\">\r\n"
				+ "                <h1 style=\"font-size: 28px;line-height: 38px;\">Sales Weekly Report</h1>\r\n"
				+ "              </td></tr>\r\n"
				+ "        <tr>\r\n"
				+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\r\n"
				+ "            Hi "+receiverName+",</td></tr>"
				+ "             <tr>"
				+ "                    <td style=\"padding: 10px 0;color: #353637;\"> \r\n"
				+ "                     <p>You have received sales weekly report between "+startDate+" to "+endDate+" :</p>\r\n"
				+ "                     <p>Download Link : <a href='"+filePath+"'>Download Report</a></p>\r\n"
				+ "                    </td></tr>  \r\n"
				+ "                <tr><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\r\n"
				+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\r\n"
				+ "    </td></tr> \r\n"
				+ "    </tbody></table>";	
	}
	
	public static String findDocumentWeeklyMessage(String startDate, String endDate,String receiverName,String filePath) {
		return "<table border=\"0\" style=\"margin:0 auto; min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\r\n"
				+ "        <tbody><tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\r\n"
				+ "                <a href=\"#\" target=\"_blank\">\r\n"
				+ "                <img src=\"https://www.corpseed.com/assets/img/logo.png\"></a>\r\n"
				+ "            </td></tr>\r\n"
				+ "            <tr>\r\n"
				+ "              <td style=\"text-align: center;\">\r\n"
				+ "                <h1 style=\"font-size: 28px;line-height: 38px;\">Document Weekly Report</h1>\r\n"
				+ "              </td></tr>\r\n"
				+ "        <tr>\r\n"
				+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\r\n"
				+ "            Hi "+receiverName+",</td></tr>"
				+ "             <tr>"
				+ "                    <td style=\"padding: 10px 0;color: #353637;\"> \r\n"
				+ "                     <p>You have received document weekly report between "+startDate+" to "+endDate+" :</p>\r\n"
				+ "                     <p>Download Link : <a href='"+filePath+"'>Download Report</a></p>\r\n"
				+ "                    </td></tr>  \r\n"
				+ "                <tr><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\r\n"
				+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\r\n"
				+ "    </td></tr> \r\n"
				+ "    </tbody></table>";	
	}
	
	public static String findSalesMonthlyMessage(String startDate, String endDate,String receiverName,String filePath) {
		return "<table border=\"0\" style=\"margin:0 auto; min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\r\n"
				+ "        <tbody><tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\r\n"
				+ "                <a href=\"#\" target=\"_blank\">\r\n"
				+ "                <img src=\"https://www.corpseed.com/assets/img/logo.png\"></a>\r\n"
				+ "            </td></tr>\r\n"
				+ "            <tr>\r\n"
				+ "              <td style=\"text-align: center;\">\r\n"
				+ "                <h1 style=\"font-size: 28px;line-height: 38px;\">Sales Weekly Report</h1>\r\n"
				+ "              </td></tr>\r\n"
				+ "        <tr>\r\n"
				+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\r\n"
				+ "            Hi "+receiverName+",</td></tr>"
				+ "             <tr>"
				+ "                    <td style=\"padding: 10px 0;color: #353637;\"> \r\n"
				+ "                     <p>You have received sales monthly report from "+startDate+" to "+endDate+" :</p>\r\n"
				+ "                     <p>Download Link : <a href='"+filePath+"'>Download Report</a></p>\r\n"
				+ "                    </td></tr>  \r\n"
				+ "                <tr><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\r\n"
				+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\r\n"
				+ "    </td></tr> \r\n"
				+ "    </tbody></table>";	
	}
	public static String getSalesExecutiveMessage(String receiverName, String executiveReport,String startDate,String endDate) {
		return "<table border=\"0\" style=\"margin:0 auto; min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\r\n"
				+ "        <tbody><tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\r\n"
				+ "                <a href=\"#\" target=\"_blank\">\r\n"
				+ "                <img src=\"https://www.corpseed.com/assets/img/logo.png\"></a>\r\n"
				+ "            </td></tr>\r\n"
				+ "            <tr>\r\n"
				+ "              <td style=\"text-align: center;\">\r\n"
				+ "                <h1 style=\"font-size: 28px;line-height: 38px;\">Sales Weekly Report</h1>\r\n"
				+ "              </td></tr>\r\n"
				+ "        <tr>\r\n"
				+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\r\n"
				+ "            Hi "+receiverName+",</td></tr>"
				+ "             <tr>"
				+ "                    <td style=\"padding: 10px 0;color: #353637;\"> \r\n"
				+ "                     <p>You have received sales weekly report between "+startDate+" to "+endDate+" :</p>\r\n"
				+ "                    </td></tr><tr><td colspan=\"1\">"+executiveReport+"</td></tr>"
				+ "                <tr><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\r\n"
				+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\r\n"
				+ "    </td></tr> \r\n"
				+ "    </tbody></table>";
	}
	public static String findTomorrowDeliveryMessage(String receiverName, String executiveReport) {
		return "<table border=\"0\" style=\"margin:0 auto; min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\r\n"
				+ "        <tbody><tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\r\n"
				+ "                <a href=\"#\" target=\"_blank\">\r\n"
				+ "                <img src=\"https://www.corpseed.com/assets/img/logo.png\"></a>\r\n"
				+ "            </td></tr>\r\n"
				+ "            <tr>\r\n"
				+ "              <td style=\"text-align: center;\">\r\n"
				+ "                <h1 style=\"font-size: 28px;line-height: 38px;\">Projects delivery Report</h1>\r\n"
				+ "              </td></tr>\r\n"
				+ "        <tr>\r\n"
				+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\r\n"
				+ "            Hi "+receiverName+",</td></tr>" 
				+ "             <tr>"
				+ "                    <td style=\"padding: 10px 0;color: #353637;\"> \r\n"
				+ "                     <p>You have received tomorrow's delivery project details,  Do needful.</p>\r\n"
				+ "                    </td></tr><tr><td colspan=\"1\">"+executiveReport+"</td></tr>"
				+ "                <tr><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\r\n"
				+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\r\n"
				+ "    </td></tr> \r\n"
				+ "    </tbody></table>";
	}
	
	public static String findExpiredSalesDeliveryMessage(String receiverName, String executiveReport) {
		return "<table border=\"0\" style=\"margin:0 auto; min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\r\n"
				+ "        <tbody><tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\r\n"
				+ "                <a href=\"#\" target=\"_blank\">\r\n"
				+ "                <img src=\"https://www.corpseed.com/assets/img/logo.png\"></a>\r\n"
				+ "            </td></tr>\r\n"
				+ "            <tr>\r\n"
				+ "              <td style=\"text-align: center;\">\r\n"
				+ "                <h1 style=\"font-size: 28px;line-height: 38px;\">Expired Projects delivery Report</h1>\r\n"
				+ "              </td></tr>\r\n"
				+ "        <tr>\r\n"
				+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\r\n"
				+ "            Hi "+receiverName+",</td></tr>" 
				+ "             <tr>"
				+ "                    <td style=\"padding: 10px 0;color: #353637;\"> \r\n"
				+ "                     <p>You have received expired projects delivery report,  Do needful.</p>\r\n"
				+ "                    </td></tr><tr><td colspan=\"1\">"+executiveReport+"</td></tr>"
				+ "                <tr><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\r\n"
				+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\r\n"
				+ "    </td></tr> \r\n"
				+ "    </tbody></table>";
	}
	
	public static String findDueSalesMessage(String receiverName, String executiveReport) {
		return "<table border=\"0\" style=\"margin:0 auto; min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\r\n"
				+ "        <tbody><tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\r\n"
				+ "                <a href=\"#\" target=\"_blank\">\r\n"
				+ "                <img src=\"https://www.corpseed.com/assets/img/logo.png\"></a>\r\n"
				+ "            </td></tr>\r\n"
				+ "            <tr>\r\n"
				+ "              <td style=\"text-align: center;\">\r\n"
				+ "                <h1 style=\"font-size: 28px;line-height: 38px;\">Due Projects Report</h1>\r\n"
				+ "              </td></tr>\r\n"
				+ "        <tr>\r\n"
				+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\r\n"
				+ "            Hi "+receiverName+",</td></tr>" 
				+ "             <tr>"
				+ "                    <td style=\"padding: 10px 0;color: #353637;\"> \r\n"
				+ "                     <p>You have received due projects report,  Do needful.</p>\r\n"
				+ "                    </td></tr><tr><td colspan=\"1\">"+executiveReport+"</td></tr>"
				+ "                <tr><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\r\n"
				+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\r\n"
				+ "    </td></tr> \r\n"
				+ "    </tbody></table>";
	}
	
	public static String findDueSalesMessageForCeo(String receiverName, String ceoReport,String betweenDates) {
		return "<table border=\"0\" style=\"margin:0 auto; min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\r\n"
				+ "        <tbody><tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\r\n"
				+ "                <a href=\"#\" target=\"_blank\">\r\n"
				+ "                <img src=\"https://www.corpseed.com/assets/img/logo.png\"></a>\r\n"
				+ "            </td></tr>\r\n"
				+ "            <tr>\r\n"
				+ "              <td style=\"text-align: center;\">\r\n"
				+ "                <h1 style=\"font-size: 28px;line-height: 38px;\">Due Sales Report</h1>\r\n"
				+ "              </td></tr>\r\n"
				+ "        <tr>\r\n"
				+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\r\n"
				+ "            Hi "+receiverName+",</td></tr>" 
				+ "             <tr>"
				+ "                    <td style=\"padding: 10px 0 0;color: #353637;\"> \r\n"
				+ "                     <p>Due Sales report</p>\r\n"
				+ "                    </td></tr><tr><td style=\"line-height: 50px;\"><a href='"+ceoReport+"'>Download Report</a></td></tr>"
				+ "                <tr><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\r\n"
				+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\r\n"
				+ "    </td></tr> \r\n"
				+ "    </tbody></table>";
	}
	
	public static String findDraftEstimateMessage(String receiverName, String executiveReport) {
		return "<table border=\"0\" style=\"margin:0 auto; min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\r\n"
				+ "        <tbody><tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\r\n"
				+ "                <a href=\"#\" target=\"_blank\">\r\n"
				+ "                <img src=\"https://www.corpseed.com/assets/img/logo.png\"></a>\r\n"
				+ "            </td></tr>\r\n"
				+ "            <tr>\r\n"
				+ "              <td style=\"text-align: center;\">\r\n"
				+ "                <h1 style=\"font-size: 28px;line-height: 38px;\">Draft Estimate Report</h1>\r\n"
				+ "              </td></tr>\r\n"
				+ "        <tr>\r\n"
				+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\r\n"
				+ "            Hi "+receiverName+",</td></tr>" 
				+ "             <tr>"
				+ "                    <td style=\"padding: 10px 0;color: #353637;\"> \r\n"
				+ "                     <p>You have draft estimates more than a week,  Do needful.</p>\r\n"
				+ "                    </td></tr><tr><td colspan=\"1\">"+executiveReport+"</td></tr>"
				+ "                <tr><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\r\n"
				+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\r\n"
				+ "    </td></tr> \r\n"
				+ "    </tbody></table>";
	}
	
	public static String findDraftEstimateMessageCeo(String receiverName, String reporturl) {
		return "<table border=\"0\" style=\"margin:0 auto; min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\r\n"
				+ "        <tbody><tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\r\n"
				+ "                <a href=\"#\" target=\"_blank\">\r\n"
				+ "                <img src=\"https://www.corpseed.com/assets/img/logo.png\"></a>\r\n"
				+ "            </td></tr>\r\n"
				+ "            <tr>\r\n"
				+ "              <td style=\"text-align: center;\">\r\n"
				+ "                <h1 style=\"font-size: 28px;line-height: 38px;\">Draft Estimate Report</h1>\r\n"
				+ "              </td></tr>\r\n"
				+ "        <tr>\r\n"
				+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\r\n"
				+ "            Hi "+receiverName+",</td></tr>" 
				+ "             <tr>"
				+ "                    <td style=\"padding: 10px 0 0;color: #353637;\"> \r\n"
				+ "                     <p>More than one week draft estimate report.</p>\r\n"
				+ "                    </td></tr><tr><td style=\"line-height:50px\"><a href='"+reporturl+"'>Download Report</a></td></tr>"
				+ "                <tr><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\r\n"
				+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\r\n"
				+ "    </td></tr> \r\n"
				+ "    </tbody></table>";
	}
	
	public static String findTomorrowDeliveryMilestoneMessage(String receiverName,String taskReports) {
		return "<table border=\"0\" style=\"margin:0 auto; min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\r\n"
				+ "        <tbody><tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\r\n"
				+ "                <a href=\"#\" target=\"_blank\">\r\n"
				+ "                <img src=\"https://www.corpseed.com/assets/img/logo.png\"></a>\r\n"
				+ "            </td></tr>\r\n"
				+ "            <tr>\r\n"
				+ "              <td style=\"text-align: center;\">\r\n"
				+ "                <h1 style=\"font-size: 28px;line-height: 38px;\">Milestone Delivery Report</h1>\r\n"
				+ "              </td></tr>\r\n"
				+ "        <tr>\r\n"
				+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\r\n"
				+ "            Hi "+receiverName+",</td></tr>" 
				+ "             <tr>"
				+ "                    <td style=\"padding: 10px 0;color: #353637;\"> \r\n"
				+ "                     <p>You have received tomorrow's delivery milestone,  Do needful.</p>\r\n"
				+ "                    </td></tr><tr><td colspan=\"1\">"+taskReports+"</td></tr>"
				+ "                <tr><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\r\n"
				+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\r\n"
				+ "    </td></tr> \r\n"
				+ "    </tbody></table>";
	}
	public static String findInactiveSalesMessage(String receiverName, String inactiveSalesTable) {
		return "<table border=\"0\" style=\"margin:0 auto; min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\r\n"
				+ "        <tbody><tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\r\n"
				+ "                <a href=\"#\" target=\"_blank\">\r\n"
				+ "                <img src=\"https://www.corpseed.com/assets/img/logo.png\"></a>\r\n"
				+ "            </td></tr>\r\n"
				+ "            <tr>\r\n"
				+ "              <td style=\"text-align: center;\">\r\n"
				+ "                <h1 style=\"font-size: 28px;line-height: 38px;\">Inactive Sales</h1>\r\n"
				+ "              </td></tr>\r\n"
				+ "        <tr>\r\n"
				+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\r\n"
				+ "            Hi "+receiverName+",</td></tr>" 
				+ "             <tr>"
				+ "                    <td style=\"padding: 10px 0;color: #353637;\"> \r\n"
				+ "                     <p>You have received an inactive sales report,  Do needful.</p>\r\n"
				+ "                    </td></tr><tr><td colspan=\"1\">"+inactiveSalesTable+"</td></tr>"
				+ "                <tr><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\r\n"
				+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\r\n"
				+ "    </td></tr> \r\n"
				+ "    </tbody></table>";
	}
	public static String findExpiredMilestoneMessage(String receiverName, String expiredTask) {
		return "<table border=\"0\" style=\"margin:0 auto; min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\r\n"
				+ "        <tbody><tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\r\n"
				+ "                <a href=\"#\" target=\"_blank\">\r\n"
				+ "                <img src=\"https://www.corpseed.com/assets/img/logo.png\"></a>\r\n"
				+ "            </td></tr>\r\n"
				+ "            <tr>\r\n"
				+ "              <td style=\"text-align: center;\">\r\n"
				+ "                <h1 style=\"font-size: 28px;line-height: 38px;\">Expired Milestones</h1>\r\n"
				+ "              </td></tr>\r\n"
				+ "        <tr>\r\n"
				+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\r\n"
				+ "            Hi "+receiverName+",</td></tr>" 
				+ "             <tr>"
				+ "                 <td style=\"padding: 10px 0;color: #353637;\"> \r\n"
				+ "                     <p>You have received expired milestone report,  Do needful.</p>\r\n"
				+ "                    </td></tr><tr><td colspan=\"1\">"+expiredTask+"</td></tr>"
				+ "                <tr><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\r\n"
				+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\r\n"
				+ "    </td></tr> \r\n"
				+ "    </tbody></table>";
	}
	public static String findClientDueMessage(String clientName,double dueAmount,String invoiceNo,
			String dueDate,String invoicelink) {
		return "<table border=\"0\" style=\"width:100%;font-size:18px;border-spacing:0;font-family:sans-serif\">\r\n"
				+ "	<tbody>\r\n"
				+ "		<tr>\r\n"
				+ "			<td style=\"text-align:left;background-color:#fff;padding:15px 0;width:50px\"><a href=\"#m_7948719413716184828_\"><img alt=\"corpseed logo\" src=\"https://www.corpseed.com/assets/img/logo.png\" /></a></td>\r\n"
				+ "		</tr>\r\n"
				+ "		<tr>\r\n"
				+ "			<td>\r\n"
				+ "			<p>Hello <strong>"+clientName+",</strong></p>\r\n"
				+ "			</td>\r\n"
				+ "		</tr>\r\n"
				+ "		<tr>\r\n"
				+ "			<td>\r\n"
				+ "			<p>I hope you are well.</p>\r\n"
				+ "			<p>I just wanted to drop you a quick note to remind you that amount of INR <strong>"+Math.ceil(dueAmount)+"</strong> in respect of our invoice <strong>"+invoiceNo+"</strong> is due for payment on <strong>"+dueDate+"</strong>.</p>\r\n"
				+ "			<p>I would be really grateful if you could confirm that everything is on track for payment.</p>\r\n"
				+ "			<p>View your invoice <a href=\""+invoicelink+"\" target=\"_blank\"><strong>Invoice link</strong></a></p>\r\n"
				+ "			<p style=\"margin-top:1.5rem;margin-bottom:1.5rem\">If you have already paid, please accept our apologies and kindly ignore this payment reminder.</p>\r\n"
				+"          <p><b>Online Payment link : </b><a href=\"https://www.corpseed.com/payment\" target=\"_blank\">https://www.corpseed.com/payment</a></p>"
				+ "			<p><strong>Company&rsquo;s Bank Details</strong></p>\r\n"
				+ "			<p>Payment should be made through IMPS / NEFT / RTGS</p>\r\n"
				+ "			<p>Account Number: 10052624515</p>\r\n"
				+ "			<p>IFSC Code: IDFB0021331</p>\r\n"
				+ "			<p>Beneficiary Name: Corpseed ITES Private Limited</p>\r\n"
				+ "			<p>Bank Name: IDFC First Bank</p>\r\n"
				+ "			<p style=\"margin-top:1.5rem\">Best regards,</p>\r\n"
				+ "			<p>Collection Team,</p>\r\n"
				+ "			<p>Corpseed Ites Private Limited</p>\r\n"
				+ "			</td>\r\n"
				+ "		</tr>\r\n"
				+ "		<tr>\r\n"
				+ "			<td style=\"text-align:center;padding:15px;background-color:#fff;border-top:5px solid #2b63f9\">\r\n"
				+ "			<p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\r\n"
				+ "			</td>\r\n"
				+ "		</tr>\r\n"
				+ "	</tbody>\r\n"
				+ "</table>";
	}
	
	public static String findClientTaxDueMessage(String clientName,double dueAmount,String invoiceNo,
			String dueDate,String invoicelink) {
		return "<table border=\"0\" style=\"width:100%;font-size:18px;border-spacing:0;font-family:sans-serif\">\r\n"
				+ "	<tbody>\r\n"
				+ "		<tr>\r\n"
				+ "			<td style=\"text-align:left;background-color:#fff;padding:15px 0;width:50px\"><a href=\"#m_7948719413716184828_\"><img alt=\"corpseed logo\" src=\"https://www.corpseed.com/assets/img/logo.png\" /></a></td>\r\n"
				+ "		</tr>\r\n"
				+ "		<tr>\r\n"
				+ "			<td>\r\n"
				+ "			<p>Hello <strong>"+clientName+",</strong></p>\r\n"
				+ "			</td>\r\n"
				+ "		</tr>\r\n"
				+ "		<tr>\r\n"
				+ "			<td>\r\n"
				+ "			<p>I hope you are well.</p>\r\n"
				+ "			<p>I just wanted to drop you a quick note to remind you that amount of INR <strong>"+Math.ceil(dueAmount)+"</strong> in respect of our invoice <strong>"+invoiceNo+"</strong> is due for payment on <strong>"+dueDate+"</strong>.</p>\r\n"
				+ "			<p>I would be really grateful if you could confirm that everything is on track for payment.</p>\r\n"
				+ "			<p>View your invoice <a href=\""+invoicelink+"\" target=\"_blank\"><strong>Invoice link</strong></a></p>\r\n"
				+ "			<p style=\"margin-top:1.5rem;margin-bottom:1.5rem\">If you have already paid, please accept our apologies and kindly ignore this payment reminder.</p>\r\n"
				+"          <p><b>Online Payment link : </b><a href=\"https://www.corpseed.com/payment\" target=\"_blank\">https://www.corpseed.com/payment</a></p>"
				+ "			<p><strong>Company&rsquo;s Bank Details</strong></p>\r\n"
				+ "			<p>Payment should be made through IMPS / NEFT / RTGS</p>\r\n"
				+ "			<p>Account Number: 10052624515</p>\r\n"
				+ "			<p>IFSC Code: IDFB0021331</p>\r\n"
				+ "			<p>Beneficiary Name: Corpseed ITES Private Limited</p>\r\n"
				+ "			<p>Bank Name: IDFC First Bank</p>\r\n"
				+ "			<p style=\"margin-top:1.5rem\">Best regards,</p>\r\n"
				+ "			<p>Collection Team,</p>\r\n"
				+ "			<p>Corpseed Ites Private Limited</p>\r\n"
				+ "			</td>\r\n"
				+ "		</tr>\r\n"
				+ "		<tr>\r\n"
				+ "			<td style=\"text-align:center;padding:15px;background-color:#fff;border-top:5px solid #2b63f9\">\r\n"
				+ "			<p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\r\n"
				+ "			</td>\r\n"
				+ "		</tr>\r\n"
				+ "	</tbody>\r\n"
				+ "</table>";
	}
	public static String findClientPoMail(String clientName, int poValidity, String poNumber, String poEndDate,
			String invoiceUrl,String taxInvoiceNo,double invoiceAmount) {
		String message="<table border=\"0\" style=\"margin:0 auto; width:700px;min-width:700px;font-size:20px;line-height: 25px;border-spacing: 0;font-family: sans-serif;\">\n"
				+ "         \n"
				+ "        <tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\n"
				+ "        \n"
				+ "                <a href=\"#\" target=\"_blank\">\n"
				+ "                <img src=\"https://corpseed.com/assets/img/logo.png\"></a>\n"
				+ "            </td></tr>\n"
				+ "            <tr>\n"
				+ "              <td style=\"text-align: center;\">\n"
				+ "                <h1>"+taxInvoiceNo+"</h1>"
				+ "              </td></tr>"
				+ "        <tr>\n"
				+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\n"
				+ "            Dear "+clientName+",</td></tr>"
				+ "             <tr>\n"
				+ "                    <td style=\"padding: 10px 0 15px;color: #353637;\"> \n"
				+ "                     <p>Greetings from Corpseed!</p><p>I am writing this to inform you that your payment is Due against the Purchase order "+poNumber.toUpperCase()+" Dated "+poEndDate+".</p>"
						+ "<p>We have generated the tax invoice against the Purchase order below are the details.</p>"
						+ "<p>Please Note that, Payment beyond "+poValidity+" days from the date of the bill will attract 18% interest P.A.</p>"
								+ "<p>Thank you for your business. Your invoice can be viewed, printed and downloaded as PDF from the link below. You can also choose to pay it online.</p>\n"					
				+ "                    </td></tr>  \n"			
				+ "                         <tr>\n"
				+ "                                <td style=\"padding: 15px 20px 20px;border: 15px solid #e5e5e5;text-align: center;\"> \n"
				+ "                                  <h2 style=\"text-align: center;\">Invoice Amount</h2>\n"
				+ "                                 <p style=\"text-align: center;\">Rs. "+CommonHelper.withLargeIntegers(invoiceAmount)+"\n"
				+ "                                  </p>\n"
				+ "                                <p style=\"text-align: center;\">Invoice No. : "+taxInvoiceNo+"</p>\n"
				+ "                                <p style=\"text-align: center;\">Payment Date : "+poEndDate+" \n"
				+ "                                 </p>\n"
				+ "                                <a href=\""+invoiceUrl+"\"><button style=\"background-color: #2b63f9 ;margin-top:15px;color:#fff;padding: 10px 30px;border: 1px solid #2b63f9;border-radius:50px\">View Invoice</button>\n"
				+ "                                </td></tr>  \n"
				+ "             <tr ><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\n"
				+ "                <b>Invoice no #"+taxInvoiceNo+"</b><br>\n"
				+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\n"
				+ "                \n"
				+ "        \n"
				+ "    </td></tr> \n"
				+ "      \n"
				+ "    </table>";
		return message;
	}
	
}
