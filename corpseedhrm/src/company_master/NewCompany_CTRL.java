package company_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.master.Usermaster_ACT;

@SuppressWarnings("serial")
public class NewCompany_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			boolean status = false;
			boolean status1 = false;			
			HttpSession session = request.getSession();
			
			String compuid = request.getParameter("CompanyID").trim();
			String compname = request.getParameter("CompanyName").trim();
			String mobile = request.getParameter("mobile").trim();
			String email = request.getParameter("email").trim();
			String compaddress = request.getParameter("CompanyAddress").trim();
			String comppan = request.getParameter("PAN").trim();
			String compgstin = request.getParameter("GSTIN").trim();
			String compstatecode = request.getParameter("statecode").trim();
			String compbankname = request.getParameter("BankName").trim();
			String compbankaccname = request.getParameter("AccountName").trim();
			String compbankacc = request.getParameter("BankACNo").trim();
			String compbankifsc = request.getParameter("BankIFSCCode").trim();
			String compbankaddress = request.getParameter("BankAddress").trim();
			String compaddedby = request.getParameter("addedbyuser").trim();
				
			      
			String today = request.getParameter("today").trim();			
			String employeekey = request.getParameter("employeekey").trim();
			String enquirykey = request.getParameter("enquirykey").trim();
			String clientkey = request.getParameter("clientkey").trim();
			String projectkey = request.getParameter("projectkey").trim();
			String taskkey = request.getParameter("taskkey").trim();
			String unbilledkey = request.getParameter("unbilledkey").trim();
			String invoicekey = request.getParameter("invoicekey").trim();
			String productskey = request.getParameter("productskey").trim();
			String estimatebillkey = request.getParameter("estimatebillkey").trim();
			String expensekey = request.getParameter("expensekey").trim();
			String transferkey = request.getParameter("transferkey").trim();
			String triggerkey = request.getParameter("triggerkey").trim();
			
			String tokenno=null; 
			
			tokenno=Usermaster_ACT.getlasttoken();
			if (tokenno==null || tokenno=="") {
				tokenno="CP27102021ITES1";	
			}
			else {
				String n=tokenno.substring(14);
				int j=Integer.parseInt(n)+1;
			tokenno="CP27102021ITES"+Integer.toString(j);
			}
			status = CompanyMaster_ACT.saveCompanyDetail(compuid, compname, compaddress, comppan, compgstin,
					compstatecode, compbankname, compbankaccname,  compbankacc, compbankifsc, compbankaddress, compaddedby,mobile,email,tokenno);
			if(status){
				//saving initial_master data
				status1=CompanyMaster_ACT.saveInitialData(compname,employeekey,"NA",clientkey,projectkey,unbilledkey,taskkey,enquirykey,"NA",compaddedby,today,tokenno,productskey,estimatebillkey,expensekey,transferkey,triggerkey,invoicekey);
			}
			
			if (status&&status1) {
//				session.setAttribute("ErrorMessage", "Company "+compname+" is Successfully registered!.");
				response.sendRedirect(request.getContextPath() + "/manage-company.html");
			} else {
				session.setAttribute("ErrorMessage", "Company "+compname+" is not registered!.");
				response.sendRedirect(request.getContextPath() + "/notification.html");
			}
		}

		catch (Exception e) {
			
		}

	}

}