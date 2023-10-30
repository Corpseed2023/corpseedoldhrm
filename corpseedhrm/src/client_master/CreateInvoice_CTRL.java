package client_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import admin.enquiry.Enquiry_ACT;
import admin.export.ExcelGenerator;
import admin.master.Usermaster_ACT;
import commons.CommonHelper;
import commons.DateUtil;


@SuppressWarnings("serial")
public class CreateInvoice_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 	 
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String loginuaid = (String)session.getAttribute("loginuaid");
		String today=DateUtil.getCurrentDateTime();
		String refkey=request.getParameter("refkey");
		if(refkey.equalsIgnoreCase("NA")) {		
			String invoiceType = request.getParameter("invoiceType").trim();
			String refInvoice = request.getParameter("refInvoice").trim();
			String billTo = request.getParameter("billTo").trim();
			String gstin = request.getParameter("gstin").trim();
			String shipTo = request.getParameter("shipTo").trim();
			String placeOfSupply = request.getParameter("placeOfSupply").trim();
			
			boolean isExist=Clientmaster_ACT.isInvoiceExist(invoiceType,refInvoice,uavalidtokenno);
			if(!isExist) {
				String key=RandomStringUtils.random(40,true,true).toLowerCase();
				String invoice_no=CommonHelper.getInvoice(uavalidtokenno, loginuaid, RandomStringUtils.random(40,true,true),invoiceType);
				double orderDueAmt=Clientmaster_ACT.getSalesDueAmount(refInvoice, uavalidtokenno);		
				double orderAmt=Clientmaster_ACT.getSalesOrderAmount(refInvoice, uavalidtokenno);	
				//creating manage invoice
				boolean status=Clientmaster_ACT.saveManageInvoice(key,invoiceType,refInvoice,billTo,gstin,shipTo,placeOfSupply,
						loginuaid,uavalidtokenno,today,invoice_no,orderAmt,orderDueAmt);
				
				//check if Tax invoice and it is po :- insert start and end date
				if(invoiceType.equalsIgnoreCase("TAX")) {
					int manageInvoiceId=Clientmaster_ACT.getManageInvoiceIdByKey(key,uavalidtokenno);
					String payment[]=Enquiry_ACT.fetchPaymentDetails(refInvoice,uavalidtokenno); 
					String startDate=DateUtil.getCurrentDateIndianReverseFormat();
					String reminderDate=DateUtil.getDateAfterDays(7);
					
				if(payment[0]!=null&&payment[1]!=null) {
					String endDate = DateUtil.getDateAfterDays(Integer.parseInt(payment[1]));					
//					System.out.println(manageInvoiceId+"\t"+payment[0]+"\t"+payment[1]+"\t"+startDate+"\t"+endDate+"\t"+reminderDate);
					long daysBetweenTwoDates = DateUtil.daysBetweenTwoDates(reminderDate,endDate);
					if(daysBetweenTwoDates<0)reminderDate=endDate;
					boolean reminderStatus=Clientmaster_ACT.updateTaxInvoiceReminder(Integer.parseInt(payment[0]),
							manageInvoiceId,true,startDate,endDate,reminderDate);
					
					if(reminderStatus) {
						//sending email to client related purchase order
						double dueAmount=Clientmaster_ACT.getSalesDueAmount(refInvoice, uavalidtokenno);
						if(dueAmount>0) {
							int superUserUaid=Enquiry_ACT.getClientKeyByInvoiceNo(refInvoice);
							String clientEmail="";
							if(superUserUaid>0)
								clientEmail=Usermaster_ACT.findUserEmailByUaid(superUserUaid);
							
							String clientName=Enquiry_ACT.getCompanyName(refInvoice, uavalidtokenno);
//							System.out.println("Going to send email to client : "+clientName);
							String invoiceUrl="https://crm.corpseed.com/generateinvoice-"+key+".html";
							String emailBody=ExcelGenerator.findClientPoMail(clientName,Integer.parseInt(payment[1]),
									payment[2],endDate,invoiceUrl,invoice_no,orderDueAmt);
							String approvedByEmail=Usermaster_ACT.findUserEmailByUaid(Integer.parseInt(payment[3]));
							if(!clientEmail.equalsIgnoreCase("NA")&&clientEmail.contains("@"))
								Enquiry_ACT.saveEmail(clientEmail, approvedByEmail, "Corpseed ITES Private Limited #"+invoice_no, emailBody, 2, "NA");
							
//							ExcelGenerator.findClientTaxDueMessage(endDate, manageInvoiceId, refInvoice, reminderDate, invoice_no);	
						}						
					}
				}
				}
				
				if(status) {
					String[][] sales=Enquiry_ACT.getAllSales(refInvoice, uavalidtokenno);
					double totalAmount=0;
					if(sales!=null&&sales.length>0) {
						for(int i=0;i<sales.length;i++) {		
								String ipKey=RandomStringUtils.random(40,true,true).toLowerCase();
								status=Clientmaster_ACT.saveInvoiceProduct(ipKey,key,sales[i][1]);					
							if(status) {
								String[][] payment=Enquiry_ACT.fetchAllSalesPriceDetails(sales[i][0], uavalidtokenno);
								if(payment!=null&&payment.length>0)
									for(int j=0;j<payment.length;j++) {
										Clientmaster_ACT.saveInvoiceProductItem(ipKey,payment[j][0],Double.parseDouble(payment[j][2])
												,payment[j][1],Double.parseDouble(payment[j][3]),Double.parseDouble(payment[j][4]),
												Double.parseDouble(payment[j][5]),Double.parseDouble(payment[j][6]),
												Double.parseDouble(payment[j][7]),Double.parseDouble(payment[j][8])
														,Double.parseDouble(payment[j][9]));
										totalAmount+=Double.parseDouble(payment[j][9]);
									}	
							}
						}
						Clientmaster_ACT.updateManageInvoiceBillingAmount(key,totalAmount,uavalidtokenno);
					}			
				}	
			}else {						
				double orderDueAmt=Clientmaster_ACT.getSalesDueAmount(refInvoice, uavalidtokenno);
				Clientmaster_ACT.updateManageInvoiceDueAmount(invoiceType,refInvoice,orderDueAmt,uavalidtokenno);				
			}
		}else {
			String billTo = request.getParameter("billToEdit").trim();
			String gstin = request.getParameter("gstinEdit").trim();
			String shipTo = request.getParameter("shipToEdit").trim();
			String placeOfSupply = request.getParameter("placeOfSupplyEdit").trim();	
//			System.out.println("Gstin : "+gstin);
			Clientmaster_ACT.updateManageInvoiceBillingAmount(refkey, billTo,gstin,shipTo,placeOfSupply,loginuaid,uavalidtokenno);			
		}
		response.sendRedirect(request.getContextPath() + "/manageinvoice.html");		
	}

}