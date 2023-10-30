package admin.task;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.enquiry.Enquiry_ACT;
import commons.DateUtil;


@SuppressWarnings("serial")
public class UpdateSalesCancelStatus_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 		   
		String token = (String) session.getAttribute("uavalidtokenno");
		String loginuaid= (String)session.getAttribute("loginuaid");
		
		String str = request.getParameter("array");
		String action=request.getParameter("action");
		String description=request.getParameter("description");
		
		String type="Cancelled";
		if(action.equals("2"))type="Restored";
		
		String hstatus="1";
		if(action.equals("1"))hstatus="2";
		String[] array=str.split(",");
		boolean flag=false;
		if(array!=null)
		for (String invoice : array) {
			//updating hierarchy inactive
			if(hstatus.equals("2")) {
				TaskMaster_ACT.updateHierarchyStatus(invoice,hstatus,token);
			
			//updating sales assigned milestone hierarchy status
			String sales[][]=TaskMaster_ACT.getAllSalesList(invoice, token);
			if(sales!=null&&sales.length>0)
				for(int i=0;i<sales.length;i++) {
					TaskMaster_ACT.updateAssignedTaskHierarchyStatus(sales[i][0],hstatus ,token);
				}
			
			//updating status of sales cancel and status
			
			flag=TaskMaster_ACT.updateSalesCancelStatus(invoice,action,token);
			
			}else {
				flag=TaskMaster_ACT.updateSalesCancelStatus1(invoice,action,token);
			}
			if(flag)
				TaskMaster_ACT.saveSaleCancelReason("NA",invoice,type,description,loginuaid,token,DateUtil.getCurrentDateIndianReverseFormat());
		}		
	}

}