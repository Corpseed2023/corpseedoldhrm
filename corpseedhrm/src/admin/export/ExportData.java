package admin.export;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import admin.master.CloudService;
import commons.CommonHelper;
import commons.DateUtil;
import commons.DbCon;

public class ExportData {
	private static Logger log = Logger.getLogger(ExportData.class);
	
    public String export(String table,String sql,String basePath,String token,String formate) {
        String status="";
        String excelFilePath = getFileName(table.concat("_Export"),formate);
        Connection connection =null;
        ResultSet result =null;
        ResultSet result1=null;
        try{           
        	connection = DbCon.getCon("","","");
        	Statement statement = connection.createStatement();
        	result = statement.executeQuery(sql);            
            
            if(result!=null) {
            XSSFWorkbook workbook = new XSSFWorkbook();
            XSSFSheet sheet = workbook.createSheet(table);
 
            if(table.equalsIgnoreCase("estimate")) {
	            writeHeaderLine(result, sheet); 
	            writeDataLines(result,result1, workbook, sheet,token,connection);
            }else if(table.equalsIgnoreCase("sales")||table.equalsIgnoreCase("Delivery")) {
            	writeSalesHeaderLine(result, sheet); 
            	writeSalesDataLines(result,result1, workbook, sheet,token,connection);
            }else if(table.equalsIgnoreCase("Document_Collection")) {
            	writeDocumentHeaderLine(result, sheet); 
            	writeDocumentDataLines(result,result1, workbook, sheet,token,connection);
            }else if(table.equalsIgnoreCase("mytask")) {
            	writeTaskHeaderLine(result, sheet); 
            	writeTaskDataLines(result,result1, workbook, sheet,token,connection);
            }else if(table.equalsIgnoreCase("Account")) {
            	writeAccountHeaderLine(result, sheet); 
            	writeAccountDataLines(result,result1, workbook, sheet,token,connection);
            }else if(table.equalsIgnoreCase("Billing")) {
            	writeBillingHeaderLine(result, sheet); 
            	writeBillingDataLines(result, workbook, sheet,token,connection);
            }else if(table.equalsIgnoreCase("Transaction")) {
            	writeTransactionHeaderLine(result, sheet); 
            	writeTransactionDataLines(result, workbook, sheet,token);
            }else if(table.equalsIgnoreCase("Approve_Expense")) {
            	writeExpenseHeaderLine(result, sheet); 
            	writeExpenseDataLines(result,result1, workbook, sheet,token,connection);
            }else if(table.equalsIgnoreCase("Credit-history")) {
            	writeCreditHeaderLine(result, sheet); 
            	writeCommonDataLines(result, workbook, sheet,token);
            }else if(table.equalsIgnoreCase("Product")) {
            	writeProductHeaderLine(result, sheet); 
            	writeCommonDataLines(result, workbook, sheet,token);
            }else if(table.equalsIgnoreCase("Template")) {
            	writeTemplateHeaderLine(result, sheet); 
            	writeCommonDataLines(result, workbook, sheet,token);
            }else if(table.equalsIgnoreCase("Guide")) {
            	writeGuideHeaderLine(result, sheet); 
            	writeGuideDataLines(result,result1, workbook, sheet,token,connection);
            }else if(table.equalsIgnoreCase("Trigger")) {
            	writeTriggerHeaderLine(result, sheet); 
            	writeCommonDataLines(result, workbook, sheet,token);
            }else if(table.equalsIgnoreCase("Tax")) {
            	writeTaxHeaderLine(result, sheet); 
            	writeCommonDataLines(result, workbook, sheet,token);
            }else if(table.equalsIgnoreCase("Team")) {
            	writeTeamHeaderLine(result, sheet); 
            	writeTeamDataLines(result,result1, workbook, sheet,token,connection);
            }else if(table.equalsIgnoreCase("Contact")) {
            	writeContactHeaderLine(result, sheet); 
            	writeCommonDataLines(result, workbook, sheet,token);
            }else if(table.equalsIgnoreCase("Coupon")) {
            	writeCouponHeaderLine(result, sheet); 
            	writeCommonDataLines(result, workbook, sheet,token);
            }else if(table.equalsIgnoreCase("Client")) {
            	writeClientHeaderLine(result, sheet); 
            	writeCommonDataLines(result, workbook, sheet,token);
            }else if(table.equalsIgnoreCase("milestone_report")) {
            	writeMilestoneReportHeaderLine(result, sheet); 
            	writeMilestoneReportDataLines(result,result1, workbook, sheet,token,connection);
            }else if(table.equalsIgnoreCase("unbilled")) {
            	writeUnbilledReportHeaderLine(result, sheet); 
            	writeUnibilledReportDataLines(result,result1, workbook, sheet,token,connection);
            }else if(table.equalsIgnoreCase("invoiced")) {
            	writeInvoicedReportHeaderLine(result, sheet); 
            	writeInvoicedReportDataLines(result,result1, workbook, sheet,token,connection);
            } 
            
            FileOutputStream outputStream = new FileOutputStream(basePath+"/"+excelFilePath);
            workbook.write(outputStream);
            workbook.close();
            outputStream.close();
            
            try {
				Thread.sleep(2000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
            
            
	        File path = new File(basePath+"/"+excelFilePath);
	        CloudService.uploadDocument(path, excelFilePath);            
            
            status=excelFilePath;
            }else {
            	status="Fail";
            }
            
            statement.close();
 
        } catch (SQLException e) {
        	log.info("Datababse error in export():ExportData class"+e.getMessage());
            e.printStackTrace();
        } catch (IOException e) {
            log.info("Datababse error in export():ExportData class"+e.getMessage());
            e.printStackTrace();
        }finally {
        	try {
			if(connection!=null)connection.close();
			if(result!=null)result.close();
			if(result1!=null)result1.close();
        	}catch(Exception e) {
        		e.printStackTrace();
        	}
		}
        return status;
    }
    private String getFileName(String baseName,String formate) {
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd_HH-mm-ss");
        String dateTimeInfo = dateFormat.format(new Date());
        return baseName.concat(String.format("_%s."+formate, dateTimeInfo));
    }
    
    private void writeUnbilledReportHeaderLine(ResultSet result, XSSFSheet sheet) throws SQLException {
        // write header line containing column names
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        Row headerRow = sheet.createRow(0);
 
        // exclude the first column which is the ID field
        for (int i = 1; i <= numberOfColumns; i++) {
            String columnName = metaData.getColumnName(i);
            columnName=getUnbilledColumnName(columnName);
            Cell headerCell = headerRow.createCell(i-1);
//            System.out.println("columnName="+columnName);
            headerCell.setCellValue(columnName);
        }
    }
    private void writeInvoicedReportHeaderLine(ResultSet result, XSSFSheet sheet) throws SQLException {
        // write header line containing column names
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        Row headerRow = sheet.createRow(0);
 
        // exclude the first column which is the ID field
        for (int i = 1; i <= numberOfColumns; i++) {
            String columnName = metaData.getColumnName(i);
            columnName=getInvoicedColumnName(columnName);
            Cell headerCell = headerRow.createCell(i-1);
//            System.out.println("columnName="+columnName);
            headerCell.setCellValue(columnName);
        }
    }
    
    private void writeClientHeaderLine(ResultSet result, XSSFSheet sheet) throws SQLException {
        // write header line containing column names
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        Row headerRow = sheet.createRow(0);
 
        // exclude the first column which is the ID field
        for (int i = 1; i <= numberOfColumns; i++) {
            String columnName = metaData.getColumnName(i);
            columnName=getClientCouponColumnName(columnName);
            Cell headerCell = headerRow.createCell(i-1);
//            System.out.println("columnName="+columnName);
            headerCell.setCellValue(columnName);
        }
    }
    
    private void writeMilestoneReportHeaderLine(ResultSet result, XSSFSheet sheet) throws SQLException {
        // write header line containing column names
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        Row headerRow = sheet.createRow(0);
 
        // exclude the first column which is the ID field
        for (int i = 1; i <= numberOfColumns; i++) {
            String columnName = metaData.getColumnName(i);
            Cell headerCell = headerRow.createCell(i-1);
            headerCell.setCellValue(columnName);
        }
    }
    
    private void writeCouponHeaderLine(ResultSet result, XSSFSheet sheet) throws SQLException {
        // write header line containing column names
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        Row headerRow = sheet.createRow(0);
 
        // exclude the first column which is the ID field
        for (int i = 1; i <= numberOfColumns; i++) {
            String columnName = metaData.getColumnName(i);
            columnName=getCouponColumnName(columnName);
            Cell headerCell = headerRow.createCell(i-1);
//            System.out.println("columnName="+columnName);
            headerCell.setCellValue(columnName);
        }
    }
    private void writeContactHeaderLine(ResultSet result, XSSFSheet sheet) throws SQLException {
        // write header line containing column names
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        Row headerRow = sheet.createRow(0);
 
        // exclude the first column which is the ID field
        for (int i = 1; i <= numberOfColumns; i++) {
            String columnName = metaData.getColumnName(i);
            columnName=getContactColumnName(columnName);
            Cell headerCell = headerRow.createCell(i-1);
//            System.out.println("columnName="+columnName);
            headerCell.setCellValue(columnName);
        }
    }
    private void writeTeamHeaderLine(ResultSet result, XSSFSheet sheet) throws SQLException {
        // write header line containing column names
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        Row headerRow = sheet.createRow(0);
 
        // exclude the first column which is the ID field
        for (int i = 1; i <= numberOfColumns; i++) {
            String columnName = metaData.getColumnName(i);
            columnName=getTeamColumnName(columnName);
            Cell headerCell = headerRow.createCell(i-1);
//            System.out.println("columnName="+columnName);
            headerCell.setCellValue(columnName);
        }
    }
    private void writeTaxHeaderLine(ResultSet result, XSSFSheet sheet) throws SQLException {
        // write header line containing column names
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        Row headerRow = sheet.createRow(0);
 
        // exclude the first column which is the ID field
        for (int i = 1; i <= numberOfColumns; i++) {
            String columnName = metaData.getColumnName(i);
            columnName=getTaxColumnName(columnName);
            Cell headerCell = headerRow.createCell(i-1);
//            System.out.println("columnName="+columnName);
            headerCell.setCellValue(columnName);
        }
    }
    private void writeTriggerHeaderLine(ResultSet result, XSSFSheet sheet) throws SQLException {
        // write header line containing column names
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        Row headerRow = sheet.createRow(0);
 
        // exclude the first column which is the ID field
        for (int i = 1; i <= numberOfColumns; i++) {
            String columnName = metaData.getColumnName(i);
            columnName=getTriggerColumnName(columnName);
            Cell headerCell = headerRow.createCell(i-1);
//            System.out.println("columnName="+columnName);
            headerCell.setCellValue(columnName);
        }
    }
    private void writeGuideHeaderLine(ResultSet result, XSSFSheet sheet) throws SQLException {
        // write header line containing column names
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        Row headerRow = sheet.createRow(0);
 
        // exclude the first column which is the ID field
        for (int i = 1; i <= numberOfColumns; i++) {
            String columnName = metaData.getColumnName(i);
            columnName=getGuideColumnName(columnName);
            Cell headerCell = headerRow.createCell(i-1);
//            System.out.println("columnName="+columnName);
            headerCell.setCellValue(columnName);
        }
    }
    private void writeTemplateHeaderLine(ResultSet result, XSSFSheet sheet) throws SQLException {
        // write header line containing column names
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        Row headerRow = sheet.createRow(0);
 
        // exclude the first column which is the ID field
        for (int i = 1; i <= numberOfColumns; i++) {
            String columnName = metaData.getColumnName(i);
            columnName=getTemplateColumnName(columnName);
            Cell headerCell = headerRow.createCell(i-1);
//            System.out.println("columnName="+columnName);
            headerCell.setCellValue(columnName);
        }
    }
    private void writeProductHeaderLine(ResultSet result, XSSFSheet sheet) throws SQLException {
        // write header line containing column names
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        Row headerRow = sheet.createRow(0);
 
        // exclude the first column which is the ID field
        for (int i = 1; i <= numberOfColumns; i++) {
            String columnName = metaData.getColumnName(i);
            columnName=getProductColumnName(columnName);
            Cell headerCell = headerRow.createCell(i-1);
//            System.out.println("columnName="+columnName);
            headerCell.setCellValue(columnName);
        }
    }
    private void writeCreditHeaderLine(ResultSet result, XSSFSheet sheet) throws SQLException {
        // write header line containing column names
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        Row headerRow = sheet.createRow(0);
 
        // exclude the first column which is the ID field
        for (int i = 1; i <= numberOfColumns; i++) {
            String columnName = metaData.getColumnName(i);            
            columnName=getCreditColumnName(columnName);
            Cell headerCell = headerRow.createCell(i-1);
//            System.out.println("columnName="+columnName);
            headerCell.setCellValue(columnName);
        }
    }
    private void writeExpenseHeaderLine(ResultSet result, XSSFSheet sheet) throws SQLException {
        // write header line containing column names
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        Row headerRow = sheet.createRow(0);
 
        // exclude the first column which is the ID field
        for (int i = 1; i <= numberOfColumns; i++) {
            String columnName = metaData.getColumnName(i);            
            columnName=getExpenseColumnName(columnName);
            Cell headerCell = headerRow.createCell(i-1);
//            System.out.println("columnName="+columnName);
            headerCell.setCellValue(columnName);
        }
    }
    private void writeTransactionHeaderLine(ResultSet result, XSSFSheet sheet) throws SQLException {
        // write header line containing column names
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        Row headerRow = sheet.createRow(0);
 
        // exclude the first column which is the ID field
        for (int i = 1; i <= numberOfColumns; i++) {
            String columnName = metaData.getColumnName(i);            
            columnName=getTransactionColumnName(columnName);
            Cell headerCell = headerRow.createCell(i-1);
//            System.out.println("columnName="+columnName);
            headerCell.setCellValue(columnName);
        }
    }
    private void writeAccountHeaderLine(ResultSet result, XSSFSheet sheet) throws SQLException {
        // write header line containing column names
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        Row headerRow = sheet.createRow(0);
 
        // exclude the first column which is the ID field
        for (int i = 1; i <= numberOfColumns; i++) {
            String columnName = metaData.getColumnName(i);            
            columnName=getAccountColumnName(columnName);
            Cell headerCell = headerRow.createCell(i-1);
//            System.out.println("columnName="+columnName);
            headerCell.setCellValue(columnName);
        }
    }
    
    private void writeHeaderLine(ResultSet result, XSSFSheet sheet) throws SQLException {
        // write header line containing column names
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        Row headerRow = sheet.createRow(0);
 
        // exclude the first column which is the ID field
        for (int i = 1; i <= numberOfColumns; i++) {
            String columnName = metaData.getColumnName(i);
            if(columnName.equals("esdiscount")){
        		continue;
        	}
            columnName=getColumnName(columnName);
            Cell headerCell = headerRow.createCell(i-1);
//            System.out.println("columnName="+columnName);
            headerCell.setCellValue(columnName);
        }
    }
    private void writeBillingHeaderLine(ResultSet result, XSSFSheet sheet) throws SQLException {
        // write header line containing column names
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        Row headerRow = sheet.createRow(0);
 
        // exclude the first column which is the ID field
        for (int i = 1; i <= numberOfColumns; i++) {
            String columnName = metaData.getColumnName(i);            
            columnName=getBillingColumnName(columnName);
            Cell headerCell = headerRow.createCell(i-1);
//            System.out.println("columnName="+columnName);
            headerCell.setCellValue(columnName);
        }
    }
    private void writeSalesHeaderLine(ResultSet result, XSSFSheet sheet) throws SQLException {
        // write header line containing column names
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        Row headerRow = sheet.createRow(0);
 
        // exclude the first column which is the ID field
        for (int i = 1; i <= numberOfColumns; i++) {
            String columnName = metaData.getColumnLabel(i);            
//            columnName=getSalesColumnName(columnName);
            Cell headerCell = headerRow.createCell(i-1);
//            System.out.println("columnName="+columnName);
            headerCell.setCellValue(columnName);
        }
    }
    private void writeDocumentHeaderLine(ResultSet result, XSSFSheet sheet) throws SQLException {
    	// write header line containing column names
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        Row headerRow = sheet.createRow(0);
 
        // exclude the first column which is the ID field
        for (int i = 1; i <= numberOfColumns; i++) {
            String columnName = metaData.getColumnName(i);   
//            columnName=getSalesColumnName(columnName);
            Cell headerCell = headerRow.createCell(i-1);
//            System.out.println("columnName="+columnName);
            headerCell.setCellValue(columnName);
        }
    }
    private void writeTaskHeaderLine(ResultSet result, XSSFSheet sheet) throws SQLException {
        // write header line containing column names
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        Row headerRow = sheet.createRow(0);
 
        // exclude the first column which is the ID field
        for (int i = 1; i <= numberOfColumns; i++) {
            String columnName = metaData.getColumnName(i);            
            columnName=getTaskColumnName(columnName);
            Cell headerCell = headerRow.createCell(i-1);
//            System.out.println("columnName="+columnName);
            headerCell.setCellValue(columnName);
        }
    }
    public String getContactColumnName(String columnName) {
    	String name="";
    	switch(columnName) {
    	case "cccontactfirstname":name="First_Name";break;
    	case "cccontactlastname" :name="Last_Name";break;
    	case "ccworkphone" :name="Work_Phone";break;
    	case "ccmobilephone" :name="Mobile_Phone";break;
    	case "ccemailfirst" :name="Email";break;
    	case "cccompanyname" :name="Company_Name";break;
    	default :name="Data";
    	}    	
    	return name;
    }
    public String getClientCouponColumnName(String columnName) {
    	String name="";
    	switch(columnName) {
    	case "cregucid":name="Client_Number";break;
    	case "cregname" :name="Client_Name";break;
    	case "cregemailid" :name="Client_Email";break;
    	case "cregcontemailid" :name="Contact_Email";break;
    	case "cregcontaddress" :name="Address";break;
    	case "creglocation" :name="Location";break;
    	case "cregcontfirstname" :name="Contact_First_Name";break;
    	case "cregcontlastname" :name="Contact_Last_Name";break;
    	case "cregmob" :name="CLient_Mobile";break;
    	case "cregcontmobile" :name="Contact_Mobile";break;
    	default :name="Data";
    	}    	
    	return name;
    }
    public String getUnbilledColumnName(String columnName) {
    	String name="";
    	switch(columnName) {
    	case "saddeddate":name="Date";break;
    	case "sunbill_no" :name="Unbill_No";break;
    	case "service_name" :name="Service_name";break;
    	case "escontactrefid" :name="Client";break;
    	case "escompany" :name="Company";break;
    	case "amount" :name="Taxable";break;
    	case "cgst" :name="CGST";break;
    	case "sgst" :name="SGST";break;
    	case "igst" :name="IGST";break;
    	case "stransactionamount" :name="Invoice_Value";break;
    	case "saddedbyuid" :name="Sales_Person";break;
    	default :name="Data";
    	}    	
    	return name;
    }
    public String getInvoicedColumnName(String columnName) {
    	String name="";
    	switch(columnName) {
    	case "date":name="Date";break;
    	case "invoice_no" :name="Invoice_No";break;
    	case "contact_name" :name="Client";break;
    	case "company" :name="Company";break;
    	case "gstin" :name="GST_No";break;
    	case "state" :name="State";break;
    	case "address" :name="Address";break;
    	case "service_name" :name="Service";break;
    	case "amount" :name="Taxable";break;
    	case "cgst" :name="CGST";break;
    	case "sgst" :name="SGST";break;
    	case "igst" :name="IGST";break;
    	case "total_amount" :name="Invoice_Value";break;
    	case "saddedbyuid" :name="Sales_Person";break;
    	default :name="Data";
    	}    	
    	return name;
    }
    public String getCouponColumnName(String columnName) {
    	String name="";
    	switch(columnName) {
    	case "title":name="Title";break;
    	case "value" :name="Value";break;
    	case "type" :name="Type";break;
    	case "startDate" :name="Start_Date";break;
    	case "endDate" :name="End_Date";break;
    	case "service_type" :name="Service_Type";break;
    	default :name="Data";
    	}    	
    	return name;
    }
    public String getTeamColumnName(String columnName) {
    	String name="";
    	switch(columnName) {
    	case "mtdate":name="Date";break;
    	case "mtdepartment" :name="Department";break;
    	case "mtteamname" :name="Team_Name";break;
    	case "mtadminname" :name="Admin_Name";break;
    	case "mtrefid" :name="Team_Members";break;
    	default :name="Data";
    	}    	
    	return name;
    }
    public String getTaxColumnName(String columnName) {
    	String name="";
    	switch(columnName) {
    	case "mthsncode":name="HSN";break;
    	case "mtcgstpercent" :name="CGST_%";break;
    	case "mtsgstpercent" :name="SGST_%";break;
    	case "mtigstpercent" :name="IGST_%";break;
    	default :name="Data";
    	}    	
    	return name;
    }
    public String getTriggerColumnName(String columnName) {
    	String name="";
    	switch(columnName) {
    	case "tDate":name="Date";break;
    	case "tTriggerNo" :name="Trigger_No";break;
    	case "tName" :name="Trigger_Name";break;
    	case "tDescription" :name="Description";break;
    	default :name="Data";
    	}    	
    	return name;
    }
    public String getGuideColumnName(String columnName) {
    	String name="";
    	switch(columnName) {
    	case "sgdate":name="Date";break;
    	case "sgprodkey" :name="Product_Name";break;
    	case "sgmilestonename" :name="Milestone_Name";break;
    	default :name="Data";
    	}    	
    	return name;
    }
    public String getTemplateColumnName(String columnName) {
    	String name="";
    	switch(columnName) {
    	case "tdate":name="Date";break;
    	case "tname" :name="Template_Name";break;
    	default :name="Data";
    	}    	
    	return name;
    }
    public String getProductColumnName(String columnName) {
    	String name="";
    	switch(columnName) {
    	case "pprodid":name="Product_Id";break;
    	case "pname" :name="Product_Name";break;
    	default :name="Product_Price";
    	}    	
    	return name;
    }
    public String getCreditColumnName(String columnName) {
    	String name="";
    	switch(columnName) {
    	case "swcreditdate":name="Date";break;
    	case "swinvoiceno" :name="Invoice";break;
    	case "swprojectname" :name="Product_Name";break;
    	case "swremarks" :name="Description";break;
    	case "swdepositamt" :name="Amount";break;
    	default :name="Data";
    	}    	
    	return name;
    }
    public String getExpenseColumnName(String columnName) {
    	String name="";
    	switch(columnName) {
    	case "expdate":name="Date";break;
    	case "expclientmobile" :name="Contact_Phone";break;
    	case "expclientname" :name="Client";break;
    	case "expamount" :name="Amount";break;
    	case "expcategory" :name="Category";break;
    	case "expdepartment" :name="Department";break;
    	case "expaccount" :name="Account";break;
    	case "expaddedbyuid" :name="Added_by";break;
    	default :name="Data";
    	}    	
    	return name;
    }
    public String getTransactionColumnName(String columnName) {
    	String name="";
    	switch(columnName) {
    	case "mtdate":name="Date";break;
    	case "mtremarks" :name="Description";break;
    	case "mtclientname" :name="Client";break;
    	case "mtaccounts" :name="Account";break;
    	case "mtcategory" :name="Category";break;
    	case "mtwithdraw" :name="Withdrawal";break;
    	case "mtdeposit" :name="Deposit";break;
    	case "mtincludeincashflow" :name="Include_in_cash_flow";break;
    	default :name="Data";
    	}    	
    	return name;
    }
    public String getBillingColumnName(String columnName) {
    	String name="";
    	switch(columnName) {
    	case "cbinvoiceno":name="Invoice";break;
    	case "cbcontactrefid" :name="Contact_Name";break;
    	case "cbcompanyname" :name="Client";break;
    	case "cbtransactionamount" :name="Transaction_Amount";break;
    	case "cborderamount" :name="Order_Amount";break;
    	case "cbpaidamount" :name="Paid";break;
    	case "cbuid" :name="Status";break;
    	default :name="Data";
    	}    	
    	return name;
    }
    public String getAccountColumnName(String columnName) {
    	String name="";
    	switch(columnName) {
    	case "cregname":name="Client";break;
    	case "cregemailid" :name="Email";break;
    	case "cregmob" :name="Mobile";break;
    	case "caid" :name="Account_Balance";break;
    	default :name="Data";
    	}    	
    	return name;
    }
    public String getTaskColumnName(String columnName) {
    	String name="";
    	switch(columnName) {
    	case "maid":name="Invoice";break;
    	case "mamilestonename" :name="Task_Name";break;
    	case "masalesrefid" :name="Client_Name";break;
    	case "maworkstarteddate" :name="Assign_Date";break;
    	case "madeliverydate" :name="Delivery_Date";break;
    	case "madelivereddate" :name="Deliver_Date";break;
    	case "mateammemberid" :name="Assigned_To";break;
    	case "maworkpercentage" :name="Progress_%";break;
    	case "maworkpriority" :name="Priority";break;
    	default :name="Data";
    	}    	
    	return name;
    }
//    public String getSalesColumnName(String columnName) {
//    	String name="";
//    	switch(columnName) {
//    	case "mssolddate":name="Date";break;
//    	case "msinvoiceno" :name="Invoice";break;
//    	case "msprojectnumber" :name="Project_No";break;
//    	case "msproductname" :name="Product_Name";break;
//    	case "mscontactrefid" :name="Contact_Name";break;
//    	case "mscompany" :name="Client";break;
//    	case "msrefid" :name="Order_Amount";break;
//    	case "msworkpercent" :name="Progress_%";break;
//    	case "mssoldbyuid" :name="Sold_by";break;
//    	case "msworktags" :name="Tags";break;
//    	case "msworkstatus" :name="Status";break;
//    	case "msassignedtoname" :name="Team_Name";break;
//    	case "msworkpriority" :name="Priority";break;
//    	case "msdeliveredon" :name="Delivered_date";break;
//    	case "msid" :name="Delivery_date";break;
//    	case "delivery_person_name" :name="Assignee";break;
//    	default :name="Data";
//    	}    	
//    	return name;
//    }
    public String getColumnName(String columnName) {
    	String name="";
    	switch(columnName) {
    	case "esregdate":name="Date";break;
    	case "essaleno" :name="Estimate_No";break;
    	case "escontactrefid" :name="Contacts";break;
    	case "escompany" :name="Company";break;
    	case "esstatus" :name="Status";break;
    	case "esrefid" :name="Amount";break;
    	default :name="Data";
    	}
    	
    	return name;
    }
  

    private void writeCommonDataLines(ResultSet result, XSSFWorkbook workbook, XSSFSheet sheet,String token)
            throws SQLException {
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        int rowCount = 1;
 
        while (result.next()) {
            Row row = sheet.createRow(rowCount++);
            Object valueObject="";
            for (int i = 1; i <= numberOfColumns; i++) {
            	
            	valueObject = result.getObject(i);            	
                
                Cell cell = row.createCell(i-1);
 
                if (valueObject instanceof Boolean)
                    cell.setCellValue((Boolean) valueObject);
                else if (valueObject instanceof Integer)
                    cell.setCellValue((Integer) valueObject);
                else if (valueObject instanceof Double)
                    cell.setCellValue((double) valueObject);
                else if (valueObject instanceof Float)
                    cell.setCellValue((float) valueObject);
                else if (valueObject instanceof Date) {
                    cell.setCellValue((Date) valueObject);
                    formatDateCell(workbook, cell);
                } else cell.setCellValue((String) valueObject);
 
            }
 
        }
    }
    
    private void writeTeamDataLines(ResultSet result,ResultSet result1, 
    		XSSFWorkbook workbook, XSSFSheet sheet,String token,Connection con)
            throws SQLException {
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        int rowCount = 1;
        while (result.next()) {
            Row row = sheet.createRow(rowCount++);
            Object valueObject="";
            for (int i = 1; i <= numberOfColumns; i++) {
            	
            	if(metaData.getColumnName(i).equals("mtrefid")) {
            		valueObject=getTeamMembers(result1,(String)result.getObject(i),token,con);
            	}else {
            		valueObject = result.getObject(i);
            	}
                
                Cell cell = row.createCell(i-1);
 
                if (valueObject instanceof Boolean)
                    cell.setCellValue((Boolean) valueObject);
                else if (valueObject instanceof Integer)
                    cell.setCellValue((Integer) valueObject);
                else if (valueObject instanceof Double)
                    cell.setCellValue((double) valueObject);
                else if (valueObject instanceof Float)
                    cell.setCellValue((float) valueObject);
                else if (valueObject instanceof Date) {
                    cell.setCellValue((Date) valueObject);
                    formatDateCell(workbook, cell);
                } else cell.setCellValue((String) valueObject);
 
            }
 
        }
    }
    private void writeGuideDataLines(ResultSet result,ResultSet result1, 
    		XSSFWorkbook workbook, XSSFSheet sheet,String token,Connection con)
            throws SQLException {
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        int rowCount = 1;
 
        while (result.next()) {
            Row row = sheet.createRow(rowCount++);
            Object valueObject="";
            for (int i = 1; i <= numberOfColumns; i++) {
            	
            	if(metaData.getColumnName(i).equals("sgprodkey")) {
            		valueObject=getProductName(result1,(String)result.getObject(i),token,con);
            	}else {
            		valueObject = result.getObject(i);
            	}
                
                Cell cell = row.createCell(i-1);
 
                if (valueObject instanceof Boolean)
                    cell.setCellValue((Boolean) valueObject);
                else if (valueObject instanceof Integer)
                    cell.setCellValue((Integer) valueObject);
                else if (valueObject instanceof Double)
                    cell.setCellValue((double) valueObject);
                else if (valueObject instanceof Float)
                    cell.setCellValue((float) valueObject);
                else if (valueObject instanceof Date) {
                    cell.setCellValue((Date) valueObject);
                    formatDateCell(workbook, cell);
                } else cell.setCellValue((String) valueObject);
 
            }
 
        }
    }
    private void writeExpenseDataLines(ResultSet result,ResultSet result1, 
    		XSSFWorkbook workbook, XSSFSheet sheet,String token,Connection con)
            throws SQLException {
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        int rowCount = 1;
 
        while (result.next()) {
            Row row = sheet.createRow(rowCount++);
            Object valueObject="";
            for (int i = 1; i <= numberOfColumns; i++) {
            	
            	if(metaData.getColumnName(i).equals("expaddedbyuid")) {
            		valueObject=getLoginUserName(result1,(String)result.getObject(i),token,con);
            	}else {
            		valueObject = result.getObject(i);
            	}
                
                Cell cell = row.createCell(i-1);
 
                if (valueObject instanceof Boolean)
                    cell.setCellValue((Boolean) valueObject);
                else if (valueObject instanceof Integer)
                    cell.setCellValue((Integer) valueObject);
                else if (valueObject instanceof Double)
                    cell.setCellValue((double) valueObject);
                else if (valueObject instanceof Float)
                    cell.setCellValue((float) valueObject);
                else if (valueObject instanceof Date) {
                    cell.setCellValue((Date) valueObject);
                    formatDateCell(workbook, cell);
                } else cell.setCellValue((String) valueObject);
 
            }
 
        }
    }
    private void writeAccountDataLines(ResultSet result,ResultSet result1, 
    		XSSFWorkbook workbook, XSSFSheet sheet,String token,Connection con)
            throws SQLException {
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        int rowCount = 1;
 
        while (result.next()) {
            Row row = sheet.createRow(rowCount++);
            Object valueObject="";
            for (int i = 1; i <= numberOfColumns; i++) {
            	
            	if(metaData.getColumnName(i).equals("caid")) {
            		valueObject=getRunningBalance(result1,(Integer)result.getObject(i)+"",con);
            	}else {
            		valueObject = result.getObject(i);
            	}
                
                Cell cell = row.createCell(i-1);
 
                if (valueObject instanceof Boolean)
                    cell.setCellValue((Boolean) valueObject);
                else if (valueObject instanceof Integer)
                    cell.setCellValue((Integer) valueObject);
                else if (valueObject instanceof Double)
                    cell.setCellValue((double) valueObject);
                else if (valueObject instanceof Float)
                    cell.setCellValue((float) valueObject);
                else if (valueObject instanceof Date) {
                    cell.setCellValue((Date) valueObject);
                    formatDateCell(workbook, cell);
                } else cell.setCellValue((String) valueObject);
 
            }
 
        }
    }
    private void writeTransactionDataLines(ResultSet result, XSSFWorkbook workbook, XSSFSheet sheet,String token)
            throws SQLException {
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
        int rowCount = 1;
 
        while (result.next()) {
            Row row = sheet.createRow(rowCount++);
            Object valueObject="";
            for (int i = 1; i <= numberOfColumns; i++) {
            	
            	if(metaData.getColumnName(i).equals("mtincludeincashflow")) {
            		valueObject=(String)result.getObject(i);
//            		System.out.println(valueObject);
            		if(valueObject.equals("1"))valueObject="Yes";
            		else valueObject="No";
            	}else {
            		valueObject = result.getObject(i);
            	}
                
                Cell cell = row.createCell(i-1);
 
                if (valueObject instanceof Boolean)
                    cell.setCellValue((Boolean) valueObject);
                else if (valueObject instanceof Integer)
                    cell.setCellValue((Integer) valueObject);
                else if (valueObject instanceof Double)
                    cell.setCellValue((double) valueObject);
                else if (valueObject instanceof Float)
                    cell.setCellValue((float) valueObject);
                else if (valueObject instanceof Date) {
                    cell.setCellValue((Date) valueObject);
                    formatDateCell(workbook, cell);
                } else cell.setCellValue((String) valueObject);
 
            }
 
        }
    }        
    
    private void writeTaskDataLines(ResultSet result,ResultSet result1, XSSFWorkbook workbook, 
    		XSSFSheet sheet,String token,Connection con)
            throws SQLException {
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        int rowCount = 1;
 
        while (result.next()) {
            Row row = sheet.createRow(rowCount++);
            Object valueObject="";
            for (int i = 1; i <= numberOfColumns; i++) {
            	
            	if(metaData.getColumnName(i).equals("maid")) {
            		valueObject=getSalesInvoice(result1,(Integer)result.getObject(i),token,con);
            	}else if(metaData.getColumnName(i).equals("masalesrefid")) {
            		valueObject=getClientName(result1,(String)result.getObject(i),token,con);
            	}else if(metaData.getColumnName(i).equals("mateammemberid")) {
            		valueObject=getLoginUserName(result1,(String)result.getObject(i),token,con);
            		if(valueObject=="NA")valueObject="Unassigned";
            	}else {
            		valueObject = result.getObject(i);
            	}
                
                Cell cell = row.createCell(i-1);
 
                if (valueObject instanceof Boolean)
                    cell.setCellValue((Boolean) valueObject);
                else if (valueObject instanceof Integer)
                    cell.setCellValue((Integer) valueObject);
                else if (valueObject instanceof Double)
                    cell.setCellValue((double) valueObject);
                else if (valueObject instanceof Float)
                    cell.setCellValue((float) valueObject);
                else if (valueObject instanceof Date) {
                    cell.setCellValue((Date) valueObject);
                    formatDateCell(workbook, cell);
                } else cell.setCellValue((String) valueObject);
 
            }
 
        }
    }
    
    private void writeBillingDataLines(ResultSet result, XSSFWorkbook workbook, 
    		XSSFSheet sheet,String token,Connection con)
            throws SQLException {
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        int rowCount = 1;
        ResultSet result1=null;
        while (result.next()) {
            Row row = sheet.createRow(rowCount++);
            Object valueObject="";
            for (int i = 1; i <= numberOfColumns; i++) {
            	
            	if(metaData.getColumnName(i).equals("cbcontactrefid")) {
            		valueObject=getAllContactName(result1,(String)result.getObject(i),token,con);
            	}else if(metaData.getColumnName(i).equals("cbuid")) {
            		valueObject=getSalesConvertStatus(result1,(Integer)result.getObject(i),token,con);
            	}else {
            		valueObject = result.getObject(i);
            	}
                
                Cell cell = row.createCell(i-1);
 
                if (valueObject instanceof Boolean)
                    cell.setCellValue((Boolean) valueObject);
                else if (valueObject instanceof Integer)
                    cell.setCellValue((Integer) valueObject);
                else if (valueObject instanceof Double)
                    cell.setCellValue((double) valueObject);
                else if (valueObject instanceof Float)
                    cell.setCellValue((float) valueObject);
                else if (valueObject instanceof Date) {
                    cell.setCellValue((Date) valueObject);
                    formatDateCell(workbook, cell);
                } else cell.setCellValue((String) valueObject);
 
            }
 
        }
    }
    
    private void writeUnibilledReportDataLines(ResultSet result,ResultSet result1, 
    		XSSFWorkbook workbook, XSSFSheet sheet,String token,Connection con)
            throws SQLException {
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//                        System.out.println("numberOfColumns="+numberOfColumns);
        int rowCount = 1;
 
        while (result.next()) {
            Row row = sheet.createRow(rowCount++);
            Object valueObject="";
            for (int i = 1; i <= numberOfColumns; i++) {
            	            	
            	if(metaData.getColumnName(i).equalsIgnoreCase("escontactrefid")) {
            		valueObject=getContactName(result1,(String)result.getObject(i),token,con);
            	}else if(metaData.getColumnName(i).equalsIgnoreCase("saddedbyuid")) {
            		valueObject=getSalesPerson(result1,(String)result.getObject(i),token,con);
            	}else            		
            		valueObject = result.getObject(i);
            	
                Cell cell = row.createCell(i-1);
 
                if (valueObject instanceof Boolean)
                    cell.setCellValue((Boolean) valueObject);
                else if (valueObject instanceof Integer)
                    cell.setCellValue((Integer) valueObject);
                else if (valueObject instanceof Double)
                    cell.setCellValue((double) valueObject);
                else if (valueObject instanceof Float)
                    cell.setCellValue((float) valueObject);
                else if (valueObject instanceof Date) {
                    cell.setCellValue((Date) valueObject);
                    formatDateCell(workbook, cell);
                } else cell.setCellValue((String) valueObject);
 
            }
 
        }
    }
    
    private void writeInvoicedReportDataLines(ResultSet result,ResultSet result1, 
    		XSSFWorkbook workbook, XSSFSheet sheet,String token,Connection con)
            throws SQLException {
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//                        System.out.println("numberOfColumns="+numberOfColumns);
        int rowCount = 1;
 
        while (result.next()) {
            Row row = sheet.createRow(rowCount++);
            Object valueObject="";
            for (int i = 1; i <= numberOfColumns; i++) {
            	  
            	if(metaData.getColumnName(i).equalsIgnoreCase("saddedbyuid")) {
            		valueObject=getSalesPerson(result1,(String)result.getObject(i),token,con);
            	}else
            		valueObject = result.getObject(i);
            	
                Cell cell = row.createCell(i-1);
 
                if (valueObject instanceof Boolean)
                    cell.setCellValue((Boolean) valueObject);
                else if (valueObject instanceof Integer)
                    cell.setCellValue((Integer) valueObject);
                else if (valueObject instanceof Double)
                    cell.setCellValue((double) valueObject);
                else if (valueObject instanceof Float)
                    cell.setCellValue((float) valueObject);
                else if (valueObject instanceof Date) {
                    cell.setCellValue((Date) valueObject);
                    formatDateCell(workbook, cell);
                } else cell.setCellValue((String) valueObject);
 
            }
 
        }
    }
            
    private void writeMilestoneReportDataLines(ResultSet result,ResultSet result1, 
    		XSSFWorkbook workbook, XSSFSheet sheet,String token,Connection con)
            throws SQLException {
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//                System.out.println("numberOfColumns="+numberOfColumns);
        int rowCount = 1;
 
        while (result.next()) {
            Row row = sheet.createRow(rowCount++);
            Object valueObject="";
            for (int i = 1; i <= numberOfColumns; i++) {
            	            	
            	if(metaData.getColumnName(i).equalsIgnoreCase("Milestone_TAT")) {
            		valueObject=getMilestoneTAT(result1,(String)result.getObject(i),token,con);
            	}else if(metaData.getColumnName(i).equalsIgnoreCase("Delivery_TAT")) {
            		valueObject=getDeliveryTAT(result1,(String)result.getObject(i),token,con);
            	}else if(metaData.getColumnName(i).equalsIgnoreCase("Delivery_Extended_Reason")) {
            		valueObject=getDeliveryExtendReason(result1,(String)result.getObject(i),token,con);
            	}else            		
            		valueObject = result.getObject(i);
            	
                Cell cell = row.createCell(i-1);
 
                if (valueObject instanceof Boolean)
                    cell.setCellValue((Boolean) valueObject);
                else if (valueObject instanceof Integer)
                    cell.setCellValue((Integer) valueObject);
                else if (valueObject instanceof Double)
                    cell.setCellValue((double) valueObject);
                else if (valueObject instanceof Float)
                    cell.setCellValue((float) valueObject);
                else if (valueObject instanceof Date) {
                    cell.setCellValue((Date) valueObject);
                    formatDateCell(workbook, cell);
                } else cell.setCellValue((String) valueObject);
 
            }
 
        }
    }
       
    private void writeDocumentDataLines(ResultSet result,ResultSet result1, XSSFWorkbook workbook,
    		XSSFSheet sheet,String token,Connection con)
            throws SQLException {
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
        int rowCount = 1;
        while (result.next()) {
            Row row = sheet.createRow(rowCount++);
            Object valueObject="";
            for (int i = 1; i <= numberOfColumns; i++) {
            	String columnName=metaData.getColumnName(i);
            	if(columnName.equals("Delivery_TAT")) {
            		valueObject=getDocumentSalesDeliveryTat(result1,(String)result.getObject(i),token,con);            		
            	}else if(columnName.equalsIgnoreCase("Document_Status")) {
            		String status=result.getObject(i).toString();            		
            		if(status.equals("1"))valueObject="Active";else if(status.equals("2"))valueObject="Inactive";else if(status.equals("3"))valueObject="Expired";else if(status.equals("4"))valueObject="Completed";
            	}else if(columnName.equals("Uploaded")) {            		
            		valueObject=findClientDocumentUploads(result1,(String)result.getObject(i),token,con);
            	}else {
            		valueObject = result.getObject(i);
            	}
                
                Cell cell = row.createCell(i-1);
 
                if (valueObject instanceof Boolean)
                    cell.setCellValue((Boolean) valueObject);
                else if (valueObject instanceof Integer)
                    cell.setCellValue((Integer) valueObject);
                else if (valueObject instanceof Double)
                    cell.setCellValue((double) valueObject);
                else if (valueObject instanceof Float)
                    cell.setCellValue((float) valueObject);
                else if (valueObject instanceof Date) {
                    cell.setCellValue((Date) valueObject);
                    formatDateCell(workbook, cell);
                } else cell.setCellValue((String) valueObject);
 
            }
 
        }
    }
    
    private void writeSalesDataLines(ResultSet result,ResultSet result1, XSSFWorkbook workbook,
    		XSSFSheet sheet,String token,Connection con)
            throws SQLException {
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
        int rowCount = 1;
        Map<String,Integer> invMap=new HashMap<>();
        while (result.next()) {
            Row row = sheet.createRow(rowCount++);
            Object valueObject="";
            
            
            for (int i = 1; i <= numberOfColumns; i++) {
            	         	
            	
            	if(metaData.getColumnLabel(i).equals("Invoice")) {
            		String inv=(String)result.getObject(i);
            		if(invMap.get(inv)!=null)
            			invMap.put(inv, invMap.get(inv)+1);
            		else
            			invMap.put(inv, 1);
            	}
            	
            	if(metaData.getColumnLabel(i).equals("Order_Amount")||
            			metaData.getColumnLabel(i).equals("Paid_Amount")||
            			metaData.getColumnLabel(i).equals("Due_Amount")) {
            		valueObject=result.getObject(2);
            		if(valueObject!=null&&valueObject instanceof String) {
            		String invoice=(String)result.getObject(2);
            		if(invoice!=null&&invMap.get(invoice)!=null&&invMap.get(invoice)>1)
            			valueObject="NA";
            		else
            			valueObject =CommonHelper.withLargeIntegers(Double.parseDouble((String)result.getObject(i)));            		            		
            		}else
            			valueObject =CommonHelper.withLargeIntegers(Double.parseDouble((String)result.getObject(i)));
            		
            	}else if(metaData.getColumnLabel(i).equals("Work_Status"))
            		valueObject=(((String)result.getObject(i)).equals("1"))?"In-Active":(((String)result.getObject(i)).equals("2"))?"Completed":"In-Progress";
            	else if(metaData.getColumnLabel(i).equalsIgnoreCase("Assignee"))
            		valueObject = getAllAssignee(result,(String)result.getObject(i),token,con);
            	else            
            		valueObject = result.getObject(i);         	
            	            	
                Cell cell = row.createCell(i-1);
 
                if (valueObject instanceof Boolean)
                    cell.setCellValue((Boolean) valueObject);
                else if (valueObject instanceof Integer)
                    cell.setCellValue((Integer) valueObject);
                else if (valueObject instanceof Double)
                    cell.setCellValue((double) valueObject);
                else if (valueObject instanceof Float)
                    cell.setCellValue((float) valueObject);
                else if (valueObject instanceof Date) {
                    cell.setCellValue((Date) valueObject);
                    formatDateCell(workbook, cell);
                } else cell.setCellValue((String) valueObject);
 
            }
 
        }
    }

	private void writeDataLines(ResultSet result,ResultSet result1, XSSFWorkbook workbook, 
			XSSFSheet sheet,String token,Connection con)
            throws SQLException {
        ResultSetMetaData metaData = result.getMetaData();
        int numberOfColumns = metaData.getColumnCount();
//        System.out.println("numberOfColumns="+numberOfColumns);
        int rowCount = 1;
        while (result.next()) {
            Row row = sheet.createRow(rowCount++);
            Object valueObject="";
            for (int i = 1; i <= numberOfColumns; i++) {
            	
            	if(metaData.getColumnName(i).equals("escontactrefid")) {
            		valueObject=getAllContactName(result1,(String)result.getObject(i),token,con);
//            		System.out.println("escontactrefid="+result.getObject(i));
            	}else if(metaData.getColumnName(i).equals("esrefid")) {
            		valueObject=getEstimateAmount(result1,(String)result.getObject(i),
            				(String)result.getObject(i+1),token,con);
//            		System.out.println("esrefid="+result.getObject(i));
            	}else if(metaData.getColumnName(i).equals("esdiscount")){
            		continue;
            	}else {
            		valueObject = result.getObject(i);
            	}
                
// System.out.println("valueObject="+valueObject);
                Cell cell = row.createCell(i-1);
 
                if (valueObject instanceof Boolean)
                    cell.setCellValue((Boolean) valueObject);
                else if (valueObject instanceof Integer)
                    cell.setCellValue((Integer) valueObject);
                else if (valueObject instanceof Double)
                    cell.setCellValue((double) valueObject);
                else if (valueObject instanceof Float)
                    cell.setCellValue((float) valueObject);
                else if (valueObject instanceof Date) {
                    cell.setCellValue((Date) valueObject);
                    formatDateCell(workbook, cell);
                } else cell.setCellValue((String) valueObject);
 
            }
 
        }
    }
    private void formatDateCell(XSSFWorkbook workbook, Cell cell) {
        CellStyle cellStyle = workbook.createCellStyle();
        CreationHelper creationHelper = workbook.getCreationHelper();
        cellStyle.setDataFormat(creationHelper.createDataFormat().getFormat("yyyy-MM-dd HH:mm:ss"));
        cell.setCellStyle(cellStyle);
    }
    
    private String getAllAssignee(ResultSet result1,String salesKey,String token,Connection connection) {
    	String name="";
    	Statement statement1=null;
    	try {
            statement1 = connection.createStatement();
 
            result1 = statement1.executeQuery("SELECT u.uaname FROM user_account u INNER JOIN manage_assignctrl ma on ma.mateammemberid = u.uaid WHERE ma.masalesrefid='"+salesKey+"' and ma.matokenno='"+token+"' group by u.uaname");
           
            while(result1!=null&&result1.next()) {
            	
            	name+=result1.getString(1)+", ";
            }
            name = name.trim();
        } catch (SQLException e) {
        	log.info("Datababse error in export():ExportData class"+e.getMessage());
            e.printStackTrace();
        }finally {
			try {
			if(statement1!=null)statement1.close();			
			}catch(SQLException e) {
				log.info("getAllAssignee() Sql error :" + e.getMessage());
			}
		}
    	return name.length()>0 ? name.substring(0,name.length()-1) : name;
    }
    
    private String getSalesPerson(ResultSet result1,String uid,String token,Connection connection) {
    	String name="";
    	Statement statement1=null;
    	try {
            
            statement1 = connection.createStatement();
 
            result1 = statement1.executeQuery("SELECT uaname FROM user_account WHERE uaid='"+uid+"' and uavalidtokenno='"+token+"'");
           
            while(result1!=null&&result1.next()) {
            	
            	name+=result1.getString(1)+",";
            }
        } catch (SQLException e) {
        	log.info("Datababse error in export():ExportData class"+e.getMessage());
            e.printStackTrace();
        }finally {
			try {
			if(statement1!=null)statement1.close();			
			}catch(SQLException e) {
				log.info("getSalesPerson() Sql error :" + e.getMessage());
			}
		}
    	return name.substring(0,name.length()-1);
    }
    
    private String getContactName(ResultSet result1,String contactKey,String token,Connection connection) {
    	String name="";
    	Statement statement1=null;
    	try {
            
            statement1 = connection.createStatement();
 
            result1 = statement1.executeQuery("select cbname from contactboxctrl where cbrefid='"+contactKey+"' and cbtokenno='"+token+"'");
           
            while(result1!=null&&result1.next()) {
            	
            	name+=result1.getString(1)+",";
            }
        } catch (SQLException e) {
        	log.info("Datababse error in export():ExportData class"+e.getMessage());
            e.printStackTrace();
        }finally {
			try {
			if(statement1!=null)statement1.close();			
			}catch(SQLException e) {
				log.info("getAllContactName() Sql error :" + e.getMessage());
			}
		}
    	return name.substring(0,name.length()-1);
    }
    
    private String getAllContactName(ResultSet result1,String contactKey,String token,Connection connection) {
    	String name="";
    	Statement statement1=null;
    	try {
            
            statement1 = connection.createStatement();
 
            result1 = statement1.executeQuery("select cbname from contactboxctrl where cbrefid='"+contactKey+"' and cbtokenno='"+token+"'");
           
            while(result1!=null&&result1.next()) {
            	
            	name+=result1.getString(1)+",";
            }
        } catch (SQLException e) {
        	log.info("Datababse error in export():ExportData class"+e.getMessage());
            e.printStackTrace();
        }finally {
			try {
			if(statement1!=null)statement1.close();			
			}catch(SQLException e) {
				log.info("getAllContactName() Sql error :" + e.getMessage());
			}
		}
    	return name.substring(0,name.length()-1);
    }
    private double getEstimateAmount(ResultSet result1,String estimateKey,String discount,
    		String token,Connection connection) {
    	double amount=0;
    	Statement statement1=null;
    	try{
            
            statement1 = connection.createStatement();
 
            result1 = statement1.executeQuery("select sum(sptotalprice) from salesproductprice where spessalerefid='"+estimateKey+"' and sptokenno='"+token+"'");
           
            if(result1!=null&&result1.next()) {
            	amount=result1.getDouble(1)-Double.parseDouble(discount);            	
            }
        } catch (SQLException e) {
        	log.info("Datababse error in getEstimateAmount():ExportData class"+e.getMessage());
            e.printStackTrace();
        }finally {
			try {
			if(statement1!=null)statement1.close();
			}catch(SQLException e) {
				log.info("getEstimateAmount() Sql error :" + e.getMessage());
			}
		}
    	return amount;
    }
    
    private String getSalesInvoice(ResultSet result1,int maid,String token,Connection connection) {
    	String invoice="NA";
    	Statement statement1=null;
    	try{
            
            statement1 = connection.createStatement();
 
            result1 = statement1.executeQuery("SELECT msinvoiceno FROM `managesalesctrl` WHERE EXISTS(select maid from manage_assignctrl where maid='"+maid+"' and masalesrefid=msrefid and matokenno='"+token+"')");
           
            if(result1!=null&&result1.next()) {
            	invoice=result1.getString(1);            	
            }
        } catch (SQLException e) {
        	log.info("Datababse error in getSalesInvoice():ExportData class"+e.getMessage());
            e.printStackTrace();
        }finally {
			try {
			if(statement1!=null)statement1.close();
			}catch(SQLException e) {
				log.info("getSalesInvoice() Sql error :" + e.getMessage());
			}
		}
    	return invoice;
    }
    private String getClientName(ResultSet result1,String salesKey,String token,Connection connection) {
    	String invoice="NA";
    	Statement statement1=null;
    	try{
            
            statement1 = connection.createStatement();
 
            result1 = statement1.executeQuery("SELECT cregname FROM `hrmclient_reg` WHERE EXISTS(select msid from managesalesctrl where msrefid='"+salesKey+"' and msclientrefid=cregclientrefid and mstoken='"+token+"')");
           
            if(result1!=null&&result1.next()) {
            	invoice=result1.getString(1);            	
            }
        } catch (SQLException e) {
        	log.info("Datababse error in getClientName():ExportData class"+e.getMessage());
            e.printStackTrace();
        }finally {
			try {
			if(statement1!=null)statement1.close();
			}catch(SQLException e) {
				log.info("getClientName() Sql error :" + e.getMessage());
			}
		}
    	return invoice;
    }
    private String getSalesConvertStatus(ResultSet result1,int cbuid,String token,Connection connection) {
    	String status="NA";
    	Statement statement1=null;
    	try{
            
            statement1 = connection.createStatement();
 
            result1 = statement1.executeQuery("SELECT cbinvoiceno FROM `hrmclient_billing` WHERE cbuid='"+cbuid+"' and cbtokenno='"+token+"'");
           
            if(result1!=null&&result1.next()) {
            	if(result1.getString(1)!=null&&!result1.getString(1).equalsIgnoreCase("NA")&&result1.getString(1).length()>0) {
            		status="Invoiced";
            	}else {
            		status="Draft";
            	}
            }
        } catch (SQLException e) {
        	log.info("Datababse error in getSalesConvertStatus():ExportData class"+e.getMessage());
            e.printStackTrace();
        }finally {
			try {
			if(statement1!=null)statement1.close();
			}catch(SQLException e) {
				log.info("getSalesConvertStatus() Sql error :" + e.getMessage());
			}
		}
    	return status;
    }
 
    private String getDeliveryExtendReason(ResultSet result1,String marefid,String token,Connection connection) {
    	String data="";
    	Statement statement1=null;
    	try{
            
            statement1 = connection.createStatement();
 
            result1 = statement1.executeQuery("select comment from milestone_extend_history where marefid='"+marefid+"' and token='"+token+"'");
            int k=1;
            while(result1!=null&&result1.next()) {  
            	data+=k+". "+result1.getString(1)+" ";
            	k++;
            }
        } catch (SQLException e) {
        	log.info("Datababse error in getDeliveryExtendReason():ExportData class"+e.getMessage());
            e.printStackTrace();
        }finally {
			try {
			if(statement1!=null)statement1.close();
			}catch(SQLException e) {
				log.info("getDeliveryExtendReason() Sql error :" + e.getMessage());
			}
		}
    	return data;
    }
    
    private String getDeliveryTAT(ResultSet result1,String marefid,String token,Connection con) {
//    	System.out.println("marefid=="+marefid);
    	String deliveredTime="";
    	String dateNow=DateUtil.getCurrentDateIndianReverseFormat();
    	String timeNow=DateUtil.getCurrentTime24Hours();
    	String milestoneData[]=getMileStoneData(result1,marefid, token,con);
 	   
 		if(!milestoneData[5].equalsIgnoreCase("NA")&&!milestoneData[5].equalsIgnoreCase("00-00-0000")&&!milestoneData[6].equalsIgnoreCase("NA")){
   	   
 		   if(milestoneData[3]!=null&&!milestoneData[3].equalsIgnoreCase("NA")
 				   &&milestoneData[4]!=null&&!milestoneData[4].equalsIgnoreCase("NA"))
 			   deliveredTime=CommonHelper.getTime(milestoneData[5],milestoneData[6],milestoneData[3],milestoneData[4]);
 		   else{		   
 			   deliveredTime=CommonHelper.getTime(milestoneData[5],milestoneData[6],dateNow,timeNow);
 		   }
 		}else{
 			deliveredTime="NS";
 		}
 		return deliveredTime;
    }
    
    private String getMilestoneTAT(ResultSet result1,String maid,String token,Connection connection) {
    	String data="";
    	Statement statement1=null;
//    	System.out.println("maid==="+maid);
    	try{
            
            statement1 = connection.createStatement();
 
            result1 = statement1.executeQuery("select masalesrefid,mamilestonerefid from manage_assignctrl where maid='"+maid+"' and matokenno='"+token+"'");
//           System.out.println("select masalesrefid,mamilestonerefid from manage_assignctrl where maid='"+maid+"' and matokenno='"+token+"'");
            if(result1!=null&&result1.next()) {  
//            	System.out.println("going to fetch data");
            	data=getMilestoneDuration(result1,result1.getString(1),result1.getString(2),token,connection);
//            	System.out.println("data fetch result="+data);
            }
        } catch (SQLException e) {
        	log.info("Datababse error in getMilestoneTAT():ExportData class"+e.getMessage());
            e.printStackTrace();
        }finally {
			try {
			if(statement1!=null)statement1.close();
			}catch(SQLException e) {
				log.info("getMilestoneTAT() Sql error :" + e.getMessage());
			}
		}
    	return data;
    }
    private String getTeamMembers(ResultSet result1,String contactKey,String token,Connection connection) {
    	String name="";
    	Statement statement1=null;
    	try {
            
            statement1 = connection.createStatement();
 
            result1 = statement1.executeQuery("select tmusername from manageteammemberctrl where tmteamrefid='"+contactKey+"' and tmtoken='"+token+"'");
           
            while(result1!=null&&result1.next()) {
            	
            	name+=result1.getString(1)+",";
            }
            
        } catch (SQLException e) {
        	log.info("Datababse error in getTeamMembers():ExportData class"+e.getMessage());
            e.printStackTrace();
        }finally {
			try {
			if(statement1!=null)statement1.close();
			}catch(SQLException e) {
				log.info("getTeamMembers() Sql error :" + e.getMessage());
			}
		}
    	return name.substring(0,name.length()-1);
    }
    private String getLoginUserName(ResultSet result1,String uid,String token,Connection connection) {
    	String name="";
    	Statement statement1=null;
    	try{
            
            statement1 = connection.createStatement();
           
            if(uid!=null&&!uid.equalsIgnoreCase("NA")&&uid.length()>0) {
    			String query="SELECT uaname FROM user_account WHERE uaid='"+uid+"' and uavalidtokenno='"+token+"'";
    			 result1 = statement1.executeQuery(query);
    			
    			if(result1!=null&&result1.next()) name=result1.getString(1);
    		}
            
        } catch (SQLException e) {
        	log.info("Datababse error in getLoginUserName():ExportData class"+e.getMessage());
            e.printStackTrace();
        }finally {
			try {
			if(statement1!=null)statement1.close();
			}catch(SQLException e) {
				log.info("getProductName() Sql error :" + e.getMessage());
			}
		}
    	return name;
    }
    private String getProductName(ResultSet result1,String prodKey, String token,Connection connection) {
    	String name="";
    	Statement statement1=null;
    	try {
            
            statement1 = connection.createStatement();
           
            String queryselect = "SELECT pname FROM product_master where prefid='" + prodKey + "' and ptokenno='"
					+ token + "'";
    			result1 = statement1.executeQuery(queryselect);
    			
    			if(result1!=null&&result1.next()) name=result1.getString(1);
    		
            
        } catch (SQLException e) {
        	log.info("Datababse error in getProductName():ExportData class"+e.getMessage());
            e.printStackTrace();
        }finally {
			try {
			if(statement1!=null)statement1.close();
			}catch(SQLException e) {
				log.info("getProductName() Sql error :" + e.getMessage());
			}
		}
    	return name;
    }
    private double getRunningBalance(ResultSet rset1,String accountid,Connection connection) {
    	double getinfo=0;
    	Statement statement1=null;
    	try{            
            statement1 = connection.createStatement();
           
            String queryselect="select sum(accbdebit),sum(accbcredit) from client_accounts_statement where accbmuid='"+accountid+"' order by accbaddedon desc limit 1";
    			 
            rset1 = statement1.executeQuery(queryselect);
    			
            while(rset1!=null && rset1.next()){
				getinfo=(rset1.getDouble(2)-rset1.getDouble(1));
			}            
        } catch (SQLException e) {
        	log.info("Datababse error in getRunningBalance():ExportData class"+e.getMessage());
            e.printStackTrace();
        }finally {
			try {
			if(statement1!=null)statement1.close();
			}catch(SQLException e) {
				log.info("getRunningBalance() Sql error :" + e.getMessage());
			}
		}
    	return getinfo;
    }
    public String[] getMileStoneData(ResultSet rset1,String marefid, String token,Connection con) {		
		String getinfo[] = new String[8];
		PreparedStatement ps1=null;
		
		try{
			String queryselect = "SELECT mamilestonerefid,madeliverydate,madeliverytime,"
					+ "madelivereddate,madeliveredtime,maworkstarteddate,maworkstartedtime,"
					+ "maworkpercentage FROM manage_assignctrl"
					+ " WHERE marefid='"+marefid+"' and matokenno='"+token+"'";
			ps1 = con.prepareStatement(queryselect);
			
			rset1 = ps1.executeQuery();
			if (rset1 != null && rset1.next()) {
				getinfo[0] = rset1.getString(1);			
				getinfo[1] = rset1.getString(2);			
				getinfo[2] = rset1.getString(3);			
				getinfo[3] = rset1.getString(4);			
				getinfo[4] = rset1.getString(5);	
				getinfo[5] = rset1.getString(6);			
				getinfo[6] = rset1.getString(7);	
				getinfo[7] = rset1.getString(8);	
			}			
		} catch (Exception e) {
			log.info("getMilestoneData" + e.getMessage());
		}finally {
			try {
			if(ps1!=null)ps1.close();
			}catch(SQLException e) {
				log.info("getMilestoneData() Sql error :" + e.getMessage());
			}
		}
		return getinfo;
	}
    public String getMilestoneDuration(ResultSet rs1,String salesKey,String milestoneKey, 
    		String token,Connection con) {
		PreparedStatement ps1 = null;
		String data = "NA";
		try{
			String queryselect = "select smtimelinevalue,smtimelineperiod from salesmilestonectrl where smrefid=? and smsalesrefid=? and smtoken=?";
			ps1 = con.prepareStatement(queryselect);
			ps1.setString(1, milestoneKey);
			ps1.setString(2, salesKey);
			ps1.setString(3, token);

			rs1 = ps1.executeQuery();
			if (rs1 != null && rs1.next()) {
				data = rs1.getString(1)+" "+rs1.getString(2);
			}
			
		} catch (Exception e) {
			log.info("getMilestoneDuration()" + e.getMessage());
		}finally {
			try {
			if(ps1!=null)ps1.close();
			}catch(SQLException e) {
				log.info("getMilestoneDuration() Sql error :" + e.getMessage());
			}
		}
		return data;
	}
    
    public String findClientDocumentUploads(ResultSet rs1,String salesKey,String token,Connection con) {
		PreparedStatement ps1 = null;
		int uploaded=0;
		int total=0;
		try{
			String query = "SELECT sddocname,sduploadedby,sduploaddate FROM salesdocumentctrl where "
					+ "sdsalesrefid='"+salesKey+"' and sduploadby='Client' and sdtokenno='"+token+"'";
			ps1 = con.prepareStatement(query);	
			rs1=ps1.executeQuery();
			while(rs1.next()) {
				total++;
				if(!rs1.getString(1).equals("NA")&&rs1.getString(1)!=null&&
						!rs1.getString(2).equals("NA")&&rs1.getString(2)!=null
						&&!rs1.getString(3).equals("00-00-0000")&&rs1.getString(3)!=null)
					uploaded++;
			}
		}
		catch (Exception e) {
			log.info("Error in findClientDocumentUploads method ExportData class\n"+e.getMessage());
		}
		finally{
			try{
				if(ps1!=null) {ps1.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects findClientDocumentUploads:ExportData class\n"+sqle.getMessage());
			}
		}
		return uploaded+" Out Of "+total;
	}
    
    private String getDocumentSalesDeliveryTat(ResultSet rs1,String salesKey, String token,Connection con) {
    	PreparedStatement ps1 = null;
		String data = "NA";
		try{
			String queryselect = "select document_assign_date,document_assign_time,document_uploaded_date,document_uploaded_time "
					+ "from managesalesctrl where msrefid=?";
			ps1 = con.prepareStatement(queryselect);
			ps1.setString(1, salesKey);

			rs1 = ps1.executeQuery();
			if (rs1 != null && rs1.next()) {
				if(rs1.getString(1)!=null&&!rs1.getString(1).equalsIgnoreCase("NA")&&
						rs1.getString(2)!=null&&!rs1.getString(2).equalsIgnoreCase("NA")&&
						rs1.getString(3)!=null&&!rs1.getString(3).equalsIgnoreCase("NA")&&
						rs1.getString(4)!=null&&!rs1.getString(4).equalsIgnoreCase("NA")) {
					CommonHelper.getTime(rs1.getString(1), rs1.getString(2), rs1.getString(3).substring(6)+rs1.getString(3).substring(2,6)+rs1.getString(3).substring(0,2), rs1.getString(4));
				}
			}
			
		} catch (Exception e) {
			log.info("getDocumentSalesDeliveryTat()" + e.getMessage());
		}finally {
			try {
			if(ps1!=null)ps1.close();
			}catch(SQLException e) {
				log.info("getDocumentSalesDeliveryTat() Sql error :" + e.getMessage());
			}
		}
		return data;    	
	}
    
	public static String[] getProjectsDeliveryDate(ResultSet rset,String salesKey, String token,Connection con) {
		String projDeliveryDate = "00-00-0000";
		String deliveryData[]=new String[2];
		try {

			String milestones[][] = getSalesMilestoneByKey(rset,salesKey, token,con);
			String workStartedDate = getProjectStartedDate(rset,salesKey, token,con);
			long TotalDay = 0;
			int minutes=0;
			if (milestones != null && milestones.length > 0) {
				for (int i = 0; i < milestones.length; i++) {
					 int data[]=getEstimateDays(rset,milestones[i][0], token,con);
					 TotalDay +=data[0];
					 minutes+=data[1];
				}
			}
//		System.out.println("days="+days+"/"+salesKey);
			if(minutes>480) {
				TotalDay+=minutes/480;
				minutes=minutes%480;
			}
			SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
			Calendar c1 = Calendar.getInstance();
			int year = Integer.parseInt(workStartedDate.substring(6, 10));
//	  	System.out.println("year="+year);
			int month = Integer.parseInt(workStartedDate.substring(3, 5));
//	  	System.out.println("month="+month);
			
			c1.add(Calendar.MINUTE, minutes);
			int dhours=c1.get(Calendar.HOUR_OF_DAY);
			int dminutes=c1.get(Calendar.MINUTE);
			int extraminute=0;
		    
		    if(dhours>=18) {
		    	TotalDay+=1;
		    	c1.set(year, (month) - 1, 1, 9, 0);
		    	extraminute=((dhours-18)*60)+dminutes;
		    	c1.add(Calendar.MINUTE, extraminute);
		    	dhours=c1.get(Calendar.HOUR_OF_DAY);
				dminutes=c1.get(Calendar.MINUTE);
		    }
		    
		    String deliveryTime=dhours+ ":"+ dminutes;
		    c1 = Calendar.getInstance();			
			
			int days = Integer.parseInt(workStartedDate.substring(0, 2));
			days += TotalDay;
//	  	System.out.println("days="+days);
			c1.set(year, (month) - 1, (days));
			projDeliveryDate = sdf.format(c1.getTime());
//	    System.out.println("deliveryDate="+deliveryDate);
			boolean flag = isSunday(projDeliveryDate);
			if (flag) {
				year = Integer.parseInt(projDeliveryDate.substring(6, 10));
				month = Integer.parseInt(projDeliveryDate.substring(3, 5));
				days = Integer.parseInt(projDeliveryDate.substring(0, 2)) + 1;
//	    	System.out.println(year+"/"+month+"/"+days);
				c1.set(year, (month) - 1, (days));
				projDeliveryDate = sdf.format(c1.getTime());

			}		
			
		    deliveryData[0]=projDeliveryDate;
		    deliveryData[1]=deliveryTime;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return deliveryData;
	}
	public static String[][] getSalesMilestoneByKey(ResultSet rsGCD,String mrefId, 
			String salesrefid, String token,Connection getacces_con) {
		PreparedStatement stmnt = null;
		String[][] newsdata = null;
		try{
			StringBuffer query = new StringBuffer(
					"SELECT mamilestonerefid,mamilestonename,mateammemberid,mamemberassigndate,maassignDate,marefid,machildteamrefid,mamemberassigndate,maworkpercentage,maworkstatus,maworkstartpricepercentage,maworkstarteddate,maworkpriority,maparentteamrefid from manage_assignctrl WHERE masalesrefid='"
							+ salesrefid + "' and marefid='" + mrefId + "' and matokenno='" + token + "'");
			query.append(" order by maid");
//			System.out.println(query);
			stmnt = getacces_con.prepareStatement(query.toString());
			rsGCD = stmnt.executeQuery();
			rsGCD.last();
			int row = rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd = rsGCD.getMetaData();
			int col = rsmd.getColumnCount();
			newsdata = new String[row][col];
			int rr = 0;
			while (rsGCD != null && rsGCD.next()) {
				for (int i = 0; i < col; i++) {
					newsdata[rr][i] = rsGCD.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {
			log.info("getSalesMilestoneByKey()" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getSalesMilestoneByKey:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}
	public static String getProjectStartedDate(ResultSet rs,String taskKey, String token,Connection con) {
		PreparedStatement ps = null;
		String data = "NA";
		try{
			String queryselect = "select mssolddate from managesalesctrl where msrefid=? and mstoken=?";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			ps.setString(1, taskKey);
			ps.setString(2, token);

			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data = rs.getString(1);
			}
		} catch (Exception e) {
			log.info("getProjectStartedDate" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException e) {
				log.info("getProjectStartedDate" + e.getMessage());
			}
		}
		return data;
	}
	public static boolean isSunday(String last_date) {
		boolean flag = false;
		SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy");
		try {
			Date d1 = formatter.parse(last_date);
			Calendar c1 = Calendar.getInstance();
			c1.setTime(d1);
			if (c1.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY) {
				flag = true;
			}
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			log.info("isSunday()" + e.getMessage());
		}

		return flag;
	}
	public static String[][] getSalesMilestoneByKey(ResultSet rsGCD,String salesrefid, 
			String token,Connection getacces_con) {
		// Initialing variables
		PreparedStatement stmnt = null;
		String[][] newsdata = null;
		try{
			String query = "SELECT smrefid,smstep,smmilestonename,smpricepercentage,smnextassignpercentage from salesmilestonectrl WHERE smsalesrefid='"
					+ salesrefid + "'  and smtoken='" + token + "' order by smid";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			rsGCD.last();
			int row = rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd = rsGCD.getMetaData();
			int col = rsmd.getColumnCount();
			newsdata = new String[row][col];
			int rr = 0;
			while (rsGCD != null && rsGCD.next()) {
				for (int i = 0; i < col; i++) {
					newsdata[rr][i] = rsGCD.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {
			log.info("Error in getSalesMilestoneByKey method \n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getSalesMilestoneByKey:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}
	public static int[] getEstimateDays(ResultSet rset,String milestoneKey, String token,Connection con) {
		PreparedStatement ps = null;
		int getinfo[] =new int[2];
		try{
			String queryselect = "SELECT smtimelinevalue,smtimelineperiod FROM salesmilestonectrl where smrefid='"
					+ milestoneKey + "' and smtoken='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				
				if (rset.getString(2).equalsIgnoreCase("Week")) {
					getinfo[0] += (rset.getInt(1) * 7);
				} else if (rset.getString(2).equalsIgnoreCase("Month")) {
					getinfo[0] += (rset.getInt(1) * 30);
				} else if (rset.getString(2).equalsIgnoreCase("Day")) {
					getinfo[0] += rset.getInt(1);
				} else if (rset.getString(2).equalsIgnoreCase("Hour")) {
					getinfo[1] += (rset.getInt(1) * 60);
				} else if (rset.getString(2).equalsIgnoreCase("Minute")) {
					getinfo[1] += rset.getInt(1);
				}
								
			}
		} catch (Exception e) {
			log.info("getEstimateDays" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException e) {
				log.info("getEstimateDays" + e.getMessage());
			}
		}
		return getinfo;
	}
}
