package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.enquiry.Enquiry_ACT;
import client_master.Clientmaster_ACT;
import commons.DateUtil;


@SuppressWarnings("serial")
public class AddSalesPermissionCTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		PrintWriter pw=response.getWriter();
				
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String today=DateUtil.getCurrentDateIndianFormat1();
		String uaid=request.getParameter("uaid");
		
		String type = request.getParameter("type").trim();
		if(type.equalsIgnoreCase("sales")) {
			String salesId = request.getParameter("salesId").trim();
			boolean isExist=Enquiry_ACT.findSalesUserMapping(salesId,uaid,uavalidtokenno);
			if(isExist)pw.write("exist");
			else {
				boolean saveFlag=Clientmaster_ACT.saveClientUserSalesInfo(Integer.parseInt(salesId), Integer.parseInt(uaid), today, uavalidtokenno);
				if(saveFlag)pw.write("pass");
				else pw.write("fail");
			}			
		}else if(type.equalsIgnoreCase("company")) {
			String companyId = request.getParameter("companyId").trim();
			boolean isExist=Enquiry_ACT.findCompanyUserMapping(companyId,uaid,uavalidtokenno);
			if(isExist)pw.write("exist");
			else {
				boolean saveFlag=Clientmaster_ACT.saveClientUserInfo(Integer.parseInt(companyId), Integer.parseInt(uaid), today, uavalidtokenno);
				if(saveFlag)pw.write("pass");
				else pw.write("fail");
			}
		}		
	}

}