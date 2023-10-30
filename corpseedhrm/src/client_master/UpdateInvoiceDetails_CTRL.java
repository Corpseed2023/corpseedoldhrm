package client_master;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;
import org.apache.log4j.Logger;

import admin.Login.LoginAction;
import admin.enquiry.Enquiry_ACT;
import admin.task.TaskMaster_ACT;
import commons.DateUtil;

@SuppressWarnings("serial")
public class UpdateInvoiceDetails_CTRL extends HttpServlet {
	private static Logger log = Logger.getLogger(LoginAction.class);

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

//		System.out.println("class called.......");
		PrintWriter out=response.getWriter();
		boolean flag=false;		
		HttpSession session = request.getSession();
		
		String token= (String)session.getAttribute("uavalidtokenno");
		String loginuaid = (String)session.getAttribute("loginuaid");
		String today=DateUtil.getCurrentDateIndianReverseFormat();
try{
		String invoice = request.getParameter("invoice").trim();
		String invoiceType = request.getParameter("invoiceType").trim();
		String invoiceDate=request.getParameter("invoiceDate");
		String invoiceDetails[][]=Enquiry_ACT.getCancelledInvoiceDetails(invoice,token);
		
		if(invoiceDetails!=null&&invoiceDetails.length>0) {
			
			int serviceQty=Integer.parseInt(invoiceDetails[0][20]);
		
		if(invoiceType.equalsIgnoreCase("Individual")) {		
		
		String contactName = request.getParameter("contactName").trim();
		String contactPan =request.getParameter("contactPan").trim();
		String individualCountry = request.getParameter("individualCountry").trim();
		String individualState = request.getParameter("individualState").trim();		
		String individualstate_code =request.getParameter("individualstate_code").trim();		
		String individualCity=request.getParameter("individualCity").trim();
		String individualAddress = request.getParameter("individualAddress").trim();
			
		String uuid=RandomStringUtils.random(40,true,true);
		flag=TaskMaster_ACT.saveInvoice(uuid,invoiceDetails[0][0],
				invoiceDetails[0][1],invoiceDate,invoiceDetails[0][2],invoiceDetails[0][3],
				invoiceDetails[0][4],invoiceDetails[0][5],invoiceDetails[0][6],invoiceDetails[0][7],
				invoiceDetails[0][8],invoiceDetails[0][9],invoiceDetails[0][10],token,loginuaid,invoiceDetails[0][11],
				invoiceDetails[0][12],invoiceType,contactName,contactPan,individualCountry,
				individualState,individualCity,individualAddress,individualstate_code,serviceQty);
		if(flag) {
			//Canceling previous invoice
			TaskMaster_ACT.cancelInvoice(invoice,token,uuid);			
		}
		}else if(invoiceType.equalsIgnoreCase("Business")) {
			String companyName = request.getParameter("CompanyName").trim();
			String gstin =request.getParameter("gstinNumber").trim();
			String country = request.getParameter("businessCountry").trim();
			String state = request.getParameter("businessState").trim();		
			String state_code =request.getParameter("businessState_code").trim();		
			String city=request.getParameter("businessCity").trim();
			String address = request.getParameter("businessAddress").trim();
	
			String uuid=RandomStringUtils.random(40,true,true);
			flag=TaskMaster_ACT.saveInvoice(uuid,invoiceDetails[0][0],invoiceDetails[0][1],invoiceDate,
					companyName,gstin,address,invoiceDetails[0][5],invoiceDetails[0][6],country,state,
					city,state_code,token,loginuaid,invoiceDetails[0][11],invoiceDetails[0][12],
					invoiceType,invoiceDetails[0][13],invoiceDetails[0][14],invoiceDetails[0][15],
					invoiceDetails[0][16],invoiceDetails[0][17],invoiceDetails[0][18],
					invoiceDetails[0][19],serviceQty);
			if(flag) {
				//Canceling previous invoice
				TaskMaster_ACT.cancelInvoice(invoice,token,uuid);
			}
			
		}
		}
		if(flag)out.write("pass");
		else out.write("fail");
	}catch(Exception e){e.printStackTrace();
			log.info("Error in UpdateContactDetails_CTRL \n"+e);
		}	
	}

}
