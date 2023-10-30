package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.enquiry.Enquiry_ACT;

public class ResetSalesHierarchyCTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter pw=response.getWriter();
		HttpSession session=request.getSession();
		String token = (String) session.getAttribute("uavalidtokenno");
		String userRole= (String)session.getAttribute("emproleid");
		try
		{
			String invoice=request.getParameter("invoice").trim();
//			System.out.println(invoice);
			if(invoice!=null&&invoice.length()>0&&userRole.equalsIgnoreCase("Administrator")) {
//				System.out.println("validated...........");
				//getting sales key from invoice
				String sales[][]=Enquiry_ACT.getAllSales(invoice,token);
				if(sales!=null&&sales.length>0) {
				for(int i=0;i<sales.length;i++) {
				//updating manage_assignctrl
					
//				TaskMaster_ACT.updateAssignedTask(sales[i][0],token);
					
				//updating managesalectrl workstatus
				Enquiry_ACT.updateSalesWorkStatus("Inactive",sales[i][0],token);
				//deleting from hrmproject_follow-up
				
//				TaskMaster_ACT.removeFollowUp(sales[i][0],token);
				
				//deleting from licence_renewal
//				TaskMaster_ACT.resetLicenceRenewal(sales[i][0],token);
				}
				//updating sales dispersed amount
				TaskMaster_ACT.resetDispersedAmount(invoice, 0, token);
				//deleting from saleshierarchymanagectrl
				TaskMaster_ACT.resetSalesHierarchy(invoice,token);
				//deleting from salesworkpricectrl
				TaskMaster_ACT.resetSalesWorkPrice(invoice,token);
				//deleting from salesmainworkpricectrl
				TaskMaster_ACT.resetMainSalesWorkPrice(invoice,token);		
				//deleting from task_notification
//				TaskMaster_ACT.resetTaskNotification(invoice,token);	
				
				}		
				pw.write("pass");
			}else if(!userRole.equalsIgnoreCase("Administrator"))
				pw.write("permission");
			else pw.write("fail");
			
		}catch (Exception e) {
			e.printStackTrace();
			pw.write("fail");
		}

	}
}
