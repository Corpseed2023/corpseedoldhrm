package admin.scheduler;

import java.util.TimerTask;

import admin.enquiry.Enquiry_ACT;
import admin.export.ExcelGenerator;
import admin.master.Usermaster_ACT;
import admin.task.TaskMaster_ACT;
import commons.DateUtil;

public class ClientUpcomingDuePaymentSecheduler extends TimerTask {

	@Override
	public void run() {
		//for past due payment	
		String dateAfterDays = DateUtil.getDateAfterDays(3);
		
		String dueSales[][]=TaskMaster_ACT.findUpcomingDueSalesForClient(dateAfterDays);
		if(dueSales!=null&&dueSales.length>0) {
			for(int j=0;j<dueSales.length;j++) {							
				//sending email to sales person
				String clientName=TaskMaster_ACT.getSalesContactName(dueSales[j][2]);
//				System.out.println("up clientName="+clientName+"#"+clientName.contains(" "));
				if(clientName.contains(" "))clientName=clientName.substring(0,clientName.indexOf(" "));
//				System.out.println("up clientName="+clientName);
				String clientEmail=TaskMaster_ACT.getSalesContactEmail(dueSales[j][2]);
				String salesPersonEmail=Usermaster_ACT.findUserEmailByUaid(Integer.parseInt(dueSales[j][3]));
				double orderDueAmount=Double.parseDouble(dueSales[j][6]);
				String invoiceNo=dueSales[j][1];
				String dueDate=dueSales[j][5];
				String invoiceLink="https://crm.corpseed.com/sales-invoice-"+dueSales[j][0]+".html";
				
				if(salesPersonEmail==null || salesPersonEmail.equalsIgnoreCase("NA") || salesPersonEmail.length()<=0)salesPersonEmail="empty";
				
				String message=ExcelGenerator.findClientDueMessage(clientName,orderDueAmount,invoiceNo,dueDate,invoiceLink);
				Enquiry_ACT.saveEmail(clientEmail, salesPersonEmail, "Corpseed ITES Private Limited #"+invoiceNo, message, 2, "NA");							
			}	
		}
	}

}
