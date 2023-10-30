package admin.task;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import admin.enquiry.Enquiry_ACT;
import commons.CommonHelper;
import commons.DateUtil;


@SuppressWarnings("serial")
public class ConvertInvoice_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
try {
		HttpSession session = request.getSession();
		  
		String token = (String) session.getAttribute("uavalidtokenno");
		String loginuaid = (String) session.getAttribute("loginuaid");
		
		String unbillno = request.getParameter("unbillno");
		if(unbillno!=null)unbillno=unbillno.trim();
		
		String invoice=Enquiry_ACT.getSalesInvoiceNumber(unbillno,token);
//		System.out.println("invoice=="+invoice);
		String clientkey=Enquiry_ACT.getSalesClientKey(invoice, token);
//		System.out.println("clientkey=="+clientkey);
		String company[][]=Enquiry_ACT.getCompanyByKey(clientkey,token);
		if(company!=null&&company.length>0) {
			String payment[]=TaskMaster_ACT.getSalesPayment(unbillno,token);
			
			String final_invoice=CommonHelper.getInvoice(token, loginuaid, RandomStringUtils.random(40,true,true),"TAX");
			boolean isExist=TaskMaster_ACT.isInvoiceExist(final_invoice,token);
			if(!isExist) {			
//			System.out.println("final invoice=="+final_invoice);
			String today=DateUtil.getCurrentDateIndianReverseFormat();
			String contact_uuid=Enquiry_ACT.getSalesContactKeyByInvoice(invoice, token);
			
			String uuid=RandomStringUtils.random(40,true,true);
			String company_uuid=company[0][0];
			String companyName=company[0][1];
			String gstin=company[0][4];
			String address=company[0][8];
			String country=company[0][7];
			String state=company[0][6];
			String state_code=company[0][10];
			String city=company[0][5];
			String serviceName=payment[0];
			String txnAmount=payment[1];
			int serviceQty=Integer.parseInt(payment[3]);
			String contactName="NA";
			String contactPan="NA";
			String contactCountry="NA";
			String contactState="NA";
			String contactCity="NA";
			String contactAddress="NA";
			String contactStateCode="NA";
			String invoiceType="Business";
			if(companyName==null||companyName.equalsIgnoreCase("NA")||companyName.length()<=0||companyName.equalsIgnoreCase("NA"))invoiceType="Individual";
			String client[][]=Enquiry_ACT.getInvoiceClientDetails(contact_uuid,token);
			if(client!=null&&client.length>0) {
				contactName=client[0][0];
				contactPan=client[0][1];
				contactCountry=client[0][2];
				contactState=client[0][3];
				contactCity=client[0][4];
				contactAddress=client[0][5];
				contactStateCode=client[0][6];
			}
			
			String sales_uuid=Enquiry_ACT.getSalesUuidByInvoice(invoice, token);
			
			boolean flag=TaskMaster_ACT.saveInvoice(uuid,unbillno,final_invoice,today,companyName,gstin,
					address,serviceName,txnAmount,country,state,city,state_code,token,loginuaid,company_uuid,
					contact_uuid,invoiceType,contactName,contactPan,contactCountry,contactState,contactCity,
					contactAddress,contactStateCode,serviceQty);
			if(flag) {
				//updating payment invoiced
				Enquiry_ACT.updatePaymentDetails(unbillno,token);
				String paymentDetails[][]=Enquiry_ACT.getPaymentList(payment[2],token);
				if(paymentDetails!=null&&paymentDetails.length>0) {
					for(int i=0;i<paymentDetails.length;i++) {
						String type=paymentDetails[i][3];
						String amount=paymentDetails[i][4];
						String cgst=paymentDetails[i][5];
						String sgst=paymentDetails[i][6];
						String igst=paymentDetails[i][7];
						String hsn=TaskMaster_ACT.getSalesPriceHsn(sales_uuid,type,token);
						TaskMaster_ACT.saveInvoiceItems(RandomStringUtils.random(40,true,true),final_invoice,today,type,amount,hsn,cgst,sgst,igst,token);
					}
				}
			}
		}
		}
}catch(Exception e) {
	e.printStackTrace();
}
	}

}