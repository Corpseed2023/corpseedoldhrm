package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import commons.DateUtil;


@SuppressWarnings("serial")
public class SetRenewalDate_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		PrintWriter pw=response.getWriter();
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String uaid = (String) session.getAttribute("loginuaid");
		
			
		String assignKey = request.getParameter("assignKey").trim();	
		String salesKey = request.getParameter("salesKey").trim();	
		String salesmilestonekey = request.getParameter("salesmilestonekey").trim();	
		String approvalDate = request.getParameter("approvalDate").trim();
		String renewalDate = request.getParameter("renewalDate").trim();
		String today=DateUtil.getCurrentDateIndianReverseFormat();
		
		String renewalKey1=TaskMaster_ACT.isRenewalExist(assignKey,salesKey,salesmilestonekey,uavalidtokenno);
//		System.out.println("renewalKey1="+renewalKey1);
		boolean flag=false;
		if(renewalKey1!=null&&!renewalKey1.equalsIgnoreCase("NA")) {
			//update approval and renewal date
			flag=TaskMaster_ACT.updateLicenceRenewal(renewalKey1,approvalDate,renewalDate,today,uavalidtokenno,uaid);
		}else {
			String renewalKey=RandomStringUtils.random(40,true,true);
			//insert approval and renewal date
			flag=TaskMaster_ACT.saveLicenceRenewal(renewalKey,assignKey,salesmilestonekey,salesKey,approvalDate,renewalDate,today,uavalidtokenno,uaid);
		}
				
		if(flag) {
			pw.write("pass");
		}else {
			pw.write("fail");
		}
	}

}