package payment;

import java.io.IOException;
import java.util.Enumeration;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.RandomStringUtils;

import com.paytm.pg.merchant.PaytmChecksum;

import admin.enquiry.Enquiry_ACT;
import admin.master.Usermaster_ACT;
import admin.task.TaskMaster_ACT;
import commons.DateUtil;
import hcustbackend.ClientACT;
import paytm_java.PaytmConstants;

/**
 * Servlet implementation class PaymentResponseCTRL
 */
public class PaymentResponseCTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
  
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
				
		Enumeration<String> paramNames = request.getParameterNames();
		
		String orderId="NA";
		String txnId="NA";
		String bankTxnId="NA";
		String status="2";
		String today=DateUtil.getCurrentDateIndianFormat1();
		
		Map<String, String[]> mapData = request.getParameterMap();
		TreeMap<String,String> parameters = new TreeMap<String,String>();
		String paytmChecksum =  "";
		while(paramNames.hasMoreElements()) {
			String paramName = (String)paramNames.nextElement();
			if(paramName.equals("CHECKSUMHASH")){
				paytmChecksum = mapData.get(paramName)[0];
			}else {
				parameters.put(paramName,mapData.get(paramName)[0]);
				if(paramName.equals("ORDERID"))orderId=mapData.get(paramName)[0];
				if(paramName.equals("BANKTXNID"))bankTxnId=mapData.get(paramName)[0];
				if(paramName.equals("TXNID"))txnId=mapData.get(paramName)[0];
			}				
		}
		boolean isValideChecksum = false;
		String paymentStatus="";
		String token=ClientACT.getTokenNo(orderId);
		try{
			isValideChecksum =PaytmChecksum.verifySignature(parameters, PaytmConstants.MERCHANT_KEY, paytmChecksum);
					
			if(isValideChecksum && parameters.containsKey("RESPCODE")){
				if(parameters.get("RESPCODE").equals("01")){
					paymentStatus = "Payment Success";
					status="1";
					//add payment into virtual order
					String paymentData[]=ClientACT.getPaymentdata(orderId,token);
					String salesData[]=Enquiry_ACT.getSalesData(paymentData[0],token);
					String estPayKey=RandomStringUtils.random(40,true,true);
					if(!ClientACT.isTxnExist(txnId)) {
						int min = 100;  
						int max = 999;  
						int random = (int)(Math.random()*(max-min+1)+min);  
						String pinvoice="INV"+today.replaceAll("-", "").substring(0,4)+today.substring(today.length()-2)+random;
						boolean invoice_flag=true;
						while(invoice_flag) {
							invoice_flag=Enquiry_ACT.isPaymentInvoiceExist(pinvoice, token);
							if(invoice_flag)
								pinvoice="INV"+today.replaceAll("-", "").substring(0,4)+today.substring(today.length()-2)+random;
						}
					boolean flag=Enquiry_ACT.uploadSalesProductManage(estPayKey,salesData[0],salesData[1],"Online",today,txnId,paymentData[1],"NA","NA",token,paymentData[2],salesData[2],pinvoice,"Online Payment","NA",1);
					if(flag){				
						//if this payment details is in project billing then update transaction amount and increase notification otherwise create new
						boolean flag1=Enquiry_ACT.isInvoiceExist(salesData[0],token);
						if(flag1){
							flag=Enquiry_ACT.updateInvoicePaymentDetails(salesData[0],paymentData[1],token);
						}
						//adding notification
						String nKey=RandomStringUtils.random(40,true,true);
						String userName=Usermaster_ACT.getLoginUserName(paymentData[2], token);
						String message="Payment of rs. "+paymentData[1]+" is registered against invoice :"+salesData[0]+" for approval by &nbsp;<span class='text-muted'>"+userName+"</span>";
						String showUaid=Enquiry_ACT.getSalesSoldByUaid(salesData[0],token);
						TaskMaster_ACT.addNotification(nKey,today,showUaid,"2","manage-sales.html",message,token,paymentData[2],"fas fa-rupee-sign");
					}
					}
				}else{
					paymentStatus="Payment Failed";					
				}
			}else{
				paymentStatus="Checksum mismatched";
			}
		}catch(Exception e){
			paymentStatus="Server error.";
		}
		
		//updating banktxnid and txnid and payment status
		if(bankTxnId.length()<=0)bankTxnId="NA";
		ClientACT.updateTxnDetails(orderId,bankTxnId,txnId,status,token);
		String estSalesKey=ClientACT.getEstimateSalesKey(orderId,token);
				
		request.setAttribute("paymentStatus", paymentStatus);
		request.setAttribute("SalesKey", estSalesKey);		
		request.setAttribute("parameters", parameters);			
		request.getRequestDispatcher("hcustfrontend/pgResponse.jsp").forward(request, response);	
		
	}

}
