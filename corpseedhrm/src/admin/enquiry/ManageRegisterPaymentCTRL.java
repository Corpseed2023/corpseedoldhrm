package admin.enquiry;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import com.oreilly.servlet.MultipartRequest;

import admin.master.CloudService;
import admin.master.Usermaster_ACT;
import admin.task.TaskMaster_ACT;
import commons.DateUtil;

@SuppressWarnings("serial")
public class ManageRegisterPaymentCTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {

			boolean status = false;
			
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			
			String key =RandomStringUtils.random(40, true, true);
//			System.out.println("pid="+pid);
			String token = (String)session.getAttribute("uavalidtokenno");
			String addedby = (String)session.getAttribute("loginuID");
			String loginuaid = (String)session.getAttribute("loginuaid");
			String today=DateUtil.getCurrentDateIndianFormat1();
			String date=DateUtil.getCurrentDateIndianReverseFormat();
			
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
			String docpath=properties.getProperty("path")+"documents";
			String docBasePath=properties.getProperty("docBasePath");
	
			String domain=properties.getProperty("domain");
			
			docpath+=File.separator;
			String imgname="NA";
			String imgpath="NA";
			MultipartRequest m=new MultipartRequest(request,docpath,1024*1024*50);
			File file=m.getFile("choosefile");
			if(file!=null){
			imgname=file.getName();
			file = new File(docpath+imgname);
			String imgkey =RandomStringUtils.random(20, true, true);
			imgname=imgname.replaceAll("\\s","_");
			imgname=imgkey+"_"+imgname;
			File newFile = new File(docpath+imgname);
			file.renameTo(newFile);
			imgpath=docBasePath+imgname;
			
	        CloudService.uploadDocument(newFile, imgname);
			newFile.delete();
			}
			
			String paymentmode=m.getParameter("paymentmode");
			String pymtdate=m.getParameter("pymtdate");
			String transactionid=m.getParameter("transactionid");
			String amount=m.getParameter("transactionamount");
			String prodrefid=m.getParameter("WhichPaymentFor");
			String salesInvoiceNo=m.getParameter("salesInvoiceNo");
			String salesEstimatenoNo=m.getParameter("salesEstimatenoNo");
			
			String service_Name=m.getParameter("services");
			String professional_Fee=m.getParameter("professional_Fee");
			String Government_Fee=m.getParameter("government_Fee");
			String service_Charges=m.getParameter("service_Charges");
			String other_Fee=m.getParameter("other_Fee");
			String other_Fee_remark=m.getParameter("other_Fee_remark");
			String gstApplied=m.getParameter("gstApplied");
			String remarks=m.getParameter("remarks");
			int serviceQty=1;
			if(m.getParameter("serviceQty")!=null)serviceQty=Integer.parseInt(m.getParameter("serviceQty"));
			
			if(professional_Fee==null||professional_Fee.length()<=0)professional_Fee="0";
			if(Government_Fee==null||Government_Fee.length()<=0)Government_Fee="0";
			if(service_Charges==null||service_Charges.length()<=0)service_Charges="0";
			if(other_Fee==null||other_Fee.length()<=0)other_Fee="0";
			if(other_Fee_remark==null||other_Fee_remark.length()<=0)other_Fee_remark="NA";
			
			if(paymentmode==""||paymentmode.length()<=0)paymentmode="Online";
			if(pymtdate==""||pymtdate.length()<=0)pymtdate=DateUtil.getCurrentDateIndianFormat1();
			if(transactionid==""||transactionid.length()<=0)transactionid="NA";
			if(amount==""||amount.length()<=0)amount="0";
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
//			System.out.println(paymentmode+"/"+pymtdate+"/"+transactionid+"/"+amount+"/"+imgname+"/"+prodrefid);
			
			//add payment into virtual order
			status=Enquiry_ACT.uploadSalesProductManage(key,salesInvoiceNo,salesEstimatenoNo,paymentmode,
					pymtdate,transactionid,amount,imgname,imgpath,token,addedby,service_Name,pinvoice,
					remarks,loginuaid,serviceQty);
			if(status){		
				String typeAmount="0";
				//adding payment type in payment details table
				if(!professional_Fee.equals("0")) {
					int professionalCgst=Integer.parseInt(m.getParameter("professionalCgst"));
					int professionalSgst=Integer.parseInt(m.getParameter("professionalSgst"));
					int professionalIgst=Integer.parseInt(m.getParameter("professionalIgst"));
					if(gstApplied.equals("0")) {
						professionalCgst=0;
						professionalSgst=0;
						professionalIgst=0;
					}
					typeAmount=m.getParameter("professional_Fee");
					String dkey=RandomStringUtils.random(40,true,true);
					Enquiry_ACT.savePaymentDetails(dkey,key,"Professional Fees",professionalCgst,professionalSgst,professionalIgst,token,date,typeAmount);
				}
				if(!Government_Fee.equals("0")) {
					int governmentCgst=Integer.parseInt(m.getParameter("governmentCgst"));
					int governmentSgst=Integer.parseInt(m.getParameter("governmentSgst"));
					int governmentIgst=Integer.parseInt(m.getParameter("governmentIgst"));
					if(gstApplied.equals("0")) {
						governmentCgst=0;
						governmentSgst=0;
						governmentIgst=0;
					}
					typeAmount=m.getParameter("government_Fee");
					String dkey=RandomStringUtils.random(40,true,true);
					Enquiry_ACT.savePaymentDetails(dkey,key,"Government Fees",governmentCgst,governmentSgst,governmentIgst,token,date,typeAmount);
				}
				if(!service_Charges.equals("0")) {
					int serviceCgst=Integer.parseInt(m.getParameter("serviceChargeCgst"));
					int serviceSgst=Integer.parseInt(m.getParameter("serviceChargeSgst"));
					int serviceIgst=Integer.parseInt(m.getParameter("serviceChargeIgst"));
					if(gstApplied.equals("0")) {
						serviceCgst=0;
						serviceSgst=0;
						serviceIgst=0;
					}
					typeAmount=m.getParameter("service_Charges");
					String dkey=RandomStringUtils.random(40,true,true);
					Enquiry_ACT.savePaymentDetails(dkey,key,"Service charges",serviceCgst,serviceSgst,serviceIgst,token,date,typeAmount);
				}
				if(!other_Fee.equals("0")) {
					int otherCgst=Integer.parseInt(m.getParameter("otherCgst"));
					int otherSgst=Integer.parseInt(m.getParameter("otherSgst"));
					int otherIgst=Integer.parseInt(m.getParameter("otherIgst"));
					if(gstApplied.equals("0")) {
						otherCgst=0;
						otherSgst=0;
						otherIgst=0;
					}
					typeAmount=m.getParameter("other_Fee");
					String dkey=RandomStringUtils.random(40,true,true);
					Enquiry_ACT.savePaymentDetails(dkey,key,"Other Fees("+m.getParameter("other_Fee_remark")+")",otherCgst,otherSgst,otherIgst,token,date,typeAmount);
				}
				
				//if this payment details is in project billing then update transaction amount and increase notification otherwise create new
				boolean flag=Enquiry_ACT.isInvoiceExist(salesInvoiceNo,token);
				if(flag){
					status=Enquiry_ACT.updateInvoicePaymentDetails(salesInvoiceNo,amount,token);
				}
				//adding notification
				String nKey=RandomStringUtils.random(40,true,true);
//				String userName=Usermaster_ACT.getLoginUserName(loginuaid, token);
//				String message="Payment of rs. "+amount+" is registered against invoice :"+salesInvoiceNo+" for approval by &nbsp;<span class='text-muted'>"+userName+"</span>";
				String message="Invoice #"+salesInvoiceNo+" : Paid "+amount+" Rs. Payment is awating for approval";
				String showUaid=Enquiry_ACT.getSalesSoldByUaid(salesInvoiceNo,token);
				TaskMaster_ACT.addNotification(nKey,today,showUaid,"2","manage-sales.html",message,token,loginuaid,"fas fa-rupee-sign");
				 String accountant[][]=Usermaster_ACT.getAllAccountant(token);
					if(accountant!=null&&accountant.length>0) {
						 //for accountant
						String nKey1=RandomStringUtils.random(40,true,true);
						
						TaskMaster_ACT.addNotification(nKey1,today,accountant[0][0],"2","manage-billing.html",message,token,loginuaid,"fas fa-rupee-sign");
						
						//sending email to accountant for payment approval		
						String message1="<table border=\"0\" style=\"margin:0 auto; width:700px;min-width:700px;font-size:15px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\n"
								+ "        <tr><td style='text-align: left ;background-color: #fff; padding: 15px 0; width: 50px'>\n"
								+ "                <a href='#' target='_blank'>\n"
								+ "                <img src=\"https://corpseed.com/assets/img/logo.png\"></a>\n"
								+ "            </td></tr>\n"
								+ "            <tr>\n"
								+ "              <td style='text-align: center;'>\n"
								+ "                <h1>Payment Added</h1>"
								+ "              </td></tr>"
								+ "        <tr>\n"
								+ "          <td style='padding:70px 0 20px;color: #353637;'>\n"
								+ "            Hi "+accountant[0][1]+",</td></tr>"
								+ "             <tr>\n"
								+ "                    <td style='padding: 10px 0 15px;color: #353637;'> \n"
								+ "                     <p> Payment of Rs. "+amount+" has been added on <b>#"+salesInvoiceNo+"</b>. Please review the payment to proceed with order. \n"
								+ "                      </p>\n"					
								+ "                    </td></tr>  \n"
								+ "                         <tr>\n"
								+ "                                <td style='padding: 15px 20px 20px;border: 15px solid #e5e5e5;text-align: center;'> \n"
								+ "                                  <h2 style=\"text-align: center;\">Action Required</h2>\n"
								+ "                                 <p style=\"text-align: center;\">You have pending approval for payments that require your attention for processing the order. \n"
								+ "                                  </p>\n"
								+ "                                <a href='"+domain+"manage-billing.html'><button style=\"background-color: #2b63f9 ;margin-top:15px;color:#fff;padding: 10px 30px;border: 1px solid #2b63f9;border-radius:50px\">View Payments</button>\n"
								+ "                                </td></tr>  \n"
								+ "             <tr ><td style='text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;'>\n"
								+ "                <b>Invoice no #"+salesInvoiceNo+"</b><br>\n"
								+ "                <p>Address:Corpseed,A-43 sector 63 Noida</p>\n"
								+ "                \n"
								+ "        \n"
								+ "    </td></tr> \n"
								+ "    </table>";
						if(accountant[0][2]!=null&&!accountant[0][2].equalsIgnoreCase("NA")&&accountant[0][2].length()>0)
						Enquiry_ACT.saveEmail(accountant[0][2],"empty",salesInvoiceNo+" payment's awating for approval", message1,2,token);
					}				
			}
			if(status){
				out.write("pass");
			}else{
				out.write("fail");
			}
		}

		catch (Exception e) {
				e.printStackTrace();
		}

	}
}