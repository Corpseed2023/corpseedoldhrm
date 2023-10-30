package company_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class UpdateCompany_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			boolean status = false;
			HttpSession session = request.getSession();

			String compuid = request.getParameter("CompanyID").trim();
			String compname = request.getParameter("CompanyName").trim();
			String compaddress = request.getParameter("CompanyAddress").trim();
			String comppan = request.getParameter("PAN").trim();
			String compgstin = request.getParameter("GSTIN").trim();
			String compstatecode = request.getParameter("statecode").trim();
			String compbankname = request.getParameter("BankName").trim();
			String compbankacc = request.getParameter("BankACNo").trim();
			String compbankifsc = request.getParameter("BankIFSCCode").trim();
			String compbankaddress = request.getParameter("BankAddress").trim();
			String compaddedby = request.getParameter("addedbyuser").trim();
			String compbankaccname = request.getParameter("AccountName").trim();
			String mobile = request.getParameter("mobile").trim();
			String email = request.getParameter("email").trim();

			status = CompanyMaster_ACT.updateCompanyDetail(compuid, compaddress, comppan, compgstin,
					compstatecode, compbankname, compbankacc, compbankifsc, compbankaddress, compaddedby,compbankaccname,compname,mobile,email);
			boolean flag=CompanyMaster_ACT.existUser(compuid);
			if(flag) {
				CompanyMaster_ACT.updateUserAccount(compname,mobile,email,compuid);
			}
			if (status) {
//				session.setAttribute("ErrorMessage", "Company "+compname+" is Successfully Updated!.");
				response.sendRedirect(request.getContextPath() + "/manage-company.html");
			} else {
				session.setAttribute("ErrorMessage", "Company "+compname+" is not Updated!.");
				response.sendRedirect(request.getContextPath() + "/notification.html");
			}
		}

		catch (Exception e) {
			
		}

	}

}