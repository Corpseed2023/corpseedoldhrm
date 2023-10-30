package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import commons.DateUtil;


@SuppressWarnings("serial")
public class VerifyRenewalDate_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		PrintWriter pw=response.getWriter();
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		
		String action = request.getParameter("action");
		boolean flag=false;
		String today=DateUtil.getCurrentDateIndianReverseFormat();
		String uuid = request.getParameter("uuid");	
		if(action.equals("1")) {
			String approvalDate = request.getParameter("approvalDate");
			String renewalDate = request.getParameter("renewalDate");
			flag=TaskMaster_ACT.verifyLicenceRenewal(uuid,approvalDate,renewalDate,"1",today,uavalidtokenno);
			
		}else if(action.equals("2")) {
			flag=TaskMaster_ACT.deleteLicenceRenewal(uuid,uavalidtokenno);
		}
	
				
		if(flag) {
			pw.write("pass");
		}else {
			pw.write("fail");
		}
	}

}