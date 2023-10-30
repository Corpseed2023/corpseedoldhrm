package admin.scheduler;

import java.util.TimerTask;

import admin.enquiry.Enquiry_ACT;
import admin.task.TaskMaster_ACT;
import commons.DateUtil;

public class AccountantApproval extends TimerTask {
	
	@Override
	public void run() {
		try {	
			String token="CP27102021ITES1";
			//getting pending approval before 2 days
			String prevDaysDate = DateUtil.getPrevDaysDate(2);
//			System.out.println("2 days before date=="+prevDaysDate);
			int pendingApproval=TaskMaster_ACT.countApprovalExpense(token, prevDaysDate);
			pendingApproval+=TaskMaster_ACT.countPaymentApproval(token,prevDaysDate);
//			System.out.println("pendingApproval=="+pendingApproval);
			if(pendingApproval>0) {
			
//				 String accountant[][]=Usermaster_ACT.getAllAccountant(token);
//					if(accountant!=null&&accountant.length>0) {
						
						String payment[][]=TaskMaster_ACT.getAllApprovalPayment(token,prevDaysDate);
						String expense[][]=TaskMaster_ACT.getAllApprovalExpense(token,prevDaysDate);
						int sn=0;
						//sending email to accountant for payment approval		
						String message1="<table border=\"0\" style=\"margin:0 auto; width:700px;min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\n"
								+ "        <tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\n"
								+ "                <a href=\"#\" target=\"_blank\">\n"
								+ "                <img src=\"https://corpseed.com/assets/img/logo.png\"></a>\n"
								+ "            </td></tr>\n"
								+ "            <tr>\n"
								+ "              <td style=\"text-align: center;\">\n"
								+ "                <h1>Payment Approval</h1>"
								+ "              </td></tr>"
								+ "        <tr>\n"
								+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\n"
								+ "            Hi Praveen,</td></tr>"
								+ "             <tr>\n"
								+ "                    <td style=\"padding: 10px 0 15px;color: #353637;\"> \n"
								+ "                     <p> You have <b>"+pendingApproval+"</b> approval that require your attention</b>.</p>"
								+ "<table style=\"width: 100%;border: 1px solid black;border-collapse: collapse;\" border=\"0\" cellpadding=\"5\">\r\n"
								+ "<tbody><tr style=\"border-bottom: 1px solid;\"><th style=\"text-align: left;border: 1px solid black;border-collapse: collapse;\">SN</th><th style=\"\r\n"
								+ "    text-align: left;\r\n"
								+ "    border: 1px solid black;\r\n"
								+ "    border-collapse: collapse;\r\n"
								+ "\">Invoice/Estimate</th><th style=\"\r\n"
								+ "    text-align: left;\r\n"
								+ "    border: 1px solid black;\r\n"
								+ "\">Client</th><th style=\"\r\n"
								+ "    text-align: left;\r\n"
								+ "    border: 1px solid black;\r\n"
								+ "    border-collapse: collapse;\r\n"
								+ "\">Amount</th><th style=\"\r\n"
								+ "    text-align: left;\r\n"
								+ "\">Type</th>    \r\n"
								+ "    </tr>\r\n";
							if(payment!=null&&payment.length>0) {	
								for(int i=0;i<payment.length;i++) {
									String saleName="";
									if(!payment[i][1].equalsIgnoreCase("NA"))saleName=payment[i][1];
									else saleName=payment[i][0];
									String company="";
									String estimate[]=TaskMaster_ACT.getSalesName(payment[i][0], token);
									if(estimate[0]!=null)saleName+=" : "+estimate[0];
									if(estimate[1]!=null)company+=estimate[1];
								sn++;
									message1+=" <tr><td style=\"border: 1px solid black;border-collapse: collapse;\">"+sn+"</td>"
								+ "    <td style=\"border: 1px solid black;border-collapse: collapse;\">"+saleName+"</td>"
								+ "        <td style=\"border: 1px solid black;border-collapse: collapse;\">"+company+"</td>"
								+ "        <td style=\"border: 1px solid black;border-collapse: collapse;\">Rs "+payment[i][2]+"</td>"
								+ "        <td style=\"border: 1px solid black;border-collapse: collapse;\">Sales</td>"
								+ "    </tr>";
								
							}}
							if(expense!=null&&expense.length>0) {	
								for(int i=0;i<expense.length;i++) {
									String salesName=TaskMaster_ACT.getSalesInvoiceNumber(expense[i][3], token);
									salesName+=" : "+TaskMaster_ACT.getSalesProductName(expense[i][3], token);
								sn++;
									message1+=" <tr><td style=\"border: 1px solid black;border-collapse: collapse;\">"+sn+"</td>"
								+ "        <td style=\"border: 1px solid black;border-collapse: collapse;\">"+salesName+"</td>"
								+ "        <td style=\"border: 1px solid black;border-collapse: collapse;\">"+expense[i][0]+"</td>"
								+ "        <td style=\"border: 1px solid black;border-collapse: collapse;\">Rs "+expense[i][1]+"</td>"
								+ "        <td style=\"border: 1px solid black;border-collapse: collapse;\">Expense</td>\r\n"
								+ "    </tr>";
								
							}}
								
							message1+="</tbody></table>"					
								+ "                    </td></tr>  \n"
								+ "                         <tr><td><p><b>Note:-</b> These item will impact the process and can delay the order processing.</p></td></tr>\n"
								+ "             <tr ><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\n"
								+ "                <p>Address:Corpseed,2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\n"
								+ "    </td></tr> \n"
								+ "    </table>";
//						if(accountant[0][2]!=null&&!accountant[0][2].equalsIgnoreCase("NA")&&accountant[0][2].length()>0)	
						Enquiry_ACT.saveEmail("praveen.kumar@corpseed.com","empty","Awating for approvals : "+DateUtil.getCurrentDateIndianFormat(), message1,2,token);
//					}			
				
			}			
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		}
}
