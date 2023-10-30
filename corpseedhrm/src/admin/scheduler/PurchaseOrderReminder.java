package admin.scheduler;

import java.util.TimerTask;

import admin.enquiry.Enquiry_ACT;
import admin.export.ExcelGenerator;
import admin.master.Usermaster_ACT;
import client_master.Clientmaster_ACT;
import commons.DateUtil;

public class PurchaseOrderReminder extends TimerTask {

	@Override
	public void run() {
		
		String today=DateUtil.getCurrentDateIndianReverseFormat();
		String[][] purchasePayment=Clientmaster_ACT.fetchPurchasePayment(today);
		if(purchasePayment!=null&&purchasePayment.length>0) {
			for(int i=0;i<purchasePayment.length;i++) {
				
				int superUserUaid=Enquiry_ACT.getClientKeyByInvoiceNo(purchasePayment[i][13]);
				String clientEmail="";
				if(superUserUaid>0)
					clientEmail=Usermaster_ACT.findUserEmailByUaid(superUserUaid);
				
				String clientName=purchasePayment[i][5];
				int poValidity=Integer.parseInt(purchasePayment[i][6]);
				String poNumber=purchasePayment[i][7];
				String poEndDate=purchasePayment[i][4];
				String taxInvoiceNo=purchasePayment[i][8];
				double invoiceDueAmount=Double.parseDouble(purchasePayment[i][9]);
				String approvedByEmail=Usermaster_ACT.findUserEmailByUaid(Integer.parseInt(purchasePayment[i][10]));
//				String addedByEmail=Usermaster_ACT.findUserEmailByUaid(Integer.parseInt(purchasePayment[i][11]));
				String invoiceUrl="https://crm.corpseed.com/generateinvoice-"+purchasePayment[i][12]+".html";
				String emailBody=ExcelGenerator.findClientPoMail(clientName,poValidity,poNumber,poEndDate,invoiceUrl,taxInvoiceNo,invoiceDueAmount);
				
				if(!clientEmail.equalsIgnoreCase("NA")&&clientEmail.contains("@"))
					Enquiry_ACT.saveEmail(clientEmail, approvedByEmail, "Corpseed ITES Private Limited #"+taxInvoiceNo, emailBody, 2, "NA");
				
				
				String reminderDate="";
				long daysBetween=DateUtil.daysBetweenTwoDates(today,purchasePayment[i][4]);
				if(daysBetween<=0)reminderDate=DateUtil.getDateAfterDays(1);
				else if(daysBetween>=7)
					reminderDate=DateUtil.getDateAfterDays(7);
				else
					reminderDate=purchasePayment[i][4];		
				
				Enquiry_ACT.updateNextReminderDate(Integer.parseInt(purchasePayment[i][0]),reminderDate);
				
//				System.out.println(reminderDate+" : "+daysBetween);
			}
		}
		
	}

}
