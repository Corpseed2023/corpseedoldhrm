package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import commons.DateUtil;

public class GenerateEstimate_CTRL extends HttpServlet {

	private static final long serialVersionUID = 6143815125411746024L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out=response.getWriter();
		try {
			HttpSession session = request.getSession(); 
			String token=(String)session.getAttribute("uavalidtokenno");
		
			String products=request.getParameter("product");
			if(products!=null)products=products.trim();
			
			String profFee=request.getParameter("profFee");
			if(profFee!=null)profFee=profFee.trim();
			
			String govFee=request.getParameter("govFee");
			if(govFee!=null)govFee=govFee.trim();
			
			String serviceCharge=request.getParameter("serviceCharge");
			if(serviceCharge!=null)serviceCharge=serviceCharge.trim();
			
			String otherFee=request.getParameter("otherFee");
			if(otherFee!=null)otherFee=otherFee.trim();
			
			String otherRemark=request.getParameter("otherRemark");
			if(otherRemark!=null)otherRemark=otherRemark.trim();
			
			String gstApply=request.getParameter("gstApply");
			if(gstApply!=null)gstApply=gstApply.trim();
			
			String pffCgst=request.getParameter("pffCgst");
			if(pffCgst!=null)pffCgst=pffCgst.trim();
			
			String pffSgst=request.getParameter("pffSgst");
			if(pffSgst!=null)pffSgst=pffSgst.trim();
			
			String pffIgst=request.getParameter("pffIgst");
			if(pffIgst!=null)pffIgst=pffIgst.trim();
			
			String govtCgst=request.getParameter("govtCgst");
			if(govtCgst!=null)govtCgst=govtCgst.trim();
			
			String govtSgst=request.getParameter("govtSgst");
			if(govtSgst!=null)govtSgst=govtSgst.trim();
			
			String govtIgst=request.getParameter("govtIgst");
			if(govtIgst!=null)govtIgst=govtIgst.trim();
			
			String serviceCgst=request.getParameter("serviceCgst");
			if(serviceCgst!=null)serviceCgst=serviceCgst.trim();
			
			String serviceSgst=request.getParameter("serviceSgst");
			if(serviceSgst!=null)serviceSgst=serviceSgst.trim();
			
			String serviceIgst=request.getParameter("serviceIgst");
			if(serviceIgst!=null)serviceIgst=serviceIgst.trim();
			
			String OtherCgst=request.getParameter("OtherCgst");
			if(OtherCgst!=null)OtherCgst=OtherCgst.trim();
			
			String OtherSgst=request.getParameter("OtherSgst");
			if(OtherSgst!=null)OtherSgst=OtherSgst.trim();
			
			String OtherIgst=request.getParameter("OtherIgst");
			if(OtherIgst!=null)OtherIgst=OtherIgst.trim();
			
			String pymtamount=request.getParameter("pymtamount");
			if(pymtamount!=null)pymtamount=pymtamount.trim();
			
			String estKey=request.getParameter("estKey");
			if(estKey!=null)estKey=estKey.trim();
			
			String estimateNotes=request.getParameter("estimateNotes");
			if(estimateNotes!=null)estimateNotes=estimateNotes.trim();
			
			String today=DateUtil.getCurrentDateIndianFormat1();
			String date=DateUtil.getCurrentDateIndianReverseFormat();
			String time=DateUtil.getCurrentTime24Hours();
			
			if(profFee==null||profFee.length()<=0)profFee="0";
			if(govFee==null||govFee.length()<=0)govFee="0";
			if(serviceCharge==null||serviceCharge.length()<=0)serviceCharge="0";
			if(otherFee==null||otherFee.length()<=0)otherFee="0";
			if(otherRemark==null||otherRemark.length()<=0)otherRemark="NA";
			
			int min = 100;  
			int max = 999;  
			int random = (int)(Math.random()*(max-min+1)+min);  
			String pinvoice="EST"+today.replaceAll("-", "").substring(0,4)+today.substring(today.length()-2)+random;
			boolean invoice_flag=true;
			while(invoice_flag) {
				invoice_flag=Enquiry_ACT.isPaymentInvoiceExist(pinvoice, token);
				if(invoice_flag)
					pinvoice="EST"+today.replaceAll("-", "").substring(0,4)+today.substring(today.length()-2)+random;
			}
			
			//add payment into generate table
			String uuid=RandomStringUtils.random(40,true,true);
			boolean status=Enquiry_ACT.saveGenerateEstimate(uuid,estKey,products,pymtamount,date,time,token,pinvoice,estimateNotes);
			if(status) {
				//adding payment type in payment details table
				if(!profFee.equals("0")) {
					int professionalCgst=Integer.parseInt(pffCgst);
					int professionalSgst=Integer.parseInt(pffSgst);
					int professionalIgst=Integer.parseInt(pffIgst);
					if(gstApply.equals("0")) {
						professionalCgst=0;
						professionalSgst=0;
						professionalIgst=0;
					}
					String gkey=RandomStringUtils.random(40,true,true);
					Enquiry_ACT.saveGeneratePymtDetails(gkey,uuid,"Professional Fees",professionalCgst,professionalSgst,professionalIgst,token,date,profFee);
				}
				if(!govFee.equals("0")) {
					int governmentCgst=Integer.parseInt(govtCgst);
					int governmentSgst=Integer.parseInt(govtSgst);
					int governmentIgst=Integer.parseInt(govtIgst);
					if(gstApply.equals("0")) {
						governmentCgst=0;
						governmentSgst=0;
						governmentIgst=0;
					}
					String gkey=RandomStringUtils.random(40,true,true);
					Enquiry_ACT.saveGeneratePymtDetails(gkey,uuid,"Government Fees",governmentCgst,governmentSgst,governmentIgst,token,date,govFee);
				}
				if(!serviceCharge.equals("0")) {
					int servCgst=Integer.parseInt(serviceCgst);
					int servSgst=Integer.parseInt(serviceSgst);
					int servIgst=Integer.parseInt(serviceIgst);
					if(gstApply.equals("0")) {
						servCgst=0;
						servSgst=0;
						servIgst=0;
					}
					String gkey=RandomStringUtils.random(40,true,true);
					Enquiry_ACT.saveGeneratePymtDetails(gkey,uuid,"Service charges",servCgst,servSgst,servIgst,token,date,serviceCharge);
				}
				if(!otherFee.equals("0")) {
					int otherCgst=Integer.parseInt(OtherCgst);
					int otherSgst=Integer.parseInt(OtherSgst);
					int otherIgst=Integer.parseInt(OtherIgst);
					if(gstApply.equals("0")) {
						otherCgst=0;
						otherSgst=0;
						otherIgst=0;
					}
					String gkey=RandomStringUtils.random(40,true,true);
					Enquiry_ACT.saveGeneratePymtDetails(gkey,uuid,"Other Fees("+otherRemark+")",otherCgst,otherSgst,otherIgst,token,date,otherFee);
				}
				out.write("pass");
			}else out.write("fail");
			
			
		}
		catch (Exception e) {
			e.printStackTrace();
		}

	}
}