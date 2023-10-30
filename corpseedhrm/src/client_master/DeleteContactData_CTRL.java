package client_master;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.enquiry.Enquiry_ACT;

@SuppressWarnings("serial")
public class DeleteContactData_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session=request.getSession();
			PrintWriter pw=response.getWriter();
			String token=(String)session.getAttribute("uavalidtokenno");
			String crefid = request.getParameter("crefid").trim();
			boolean refFlag=Enquiry_ACT.isContactRefUsed(crefid,token);
			if(!refFlag) {
				boolean flag=Clientmaster_ACT.deleteContact(crefid,token);			
				if(flag)pw.write("pass");
				else pw.write("fail");
			}else pw.write("exist");
			
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}
