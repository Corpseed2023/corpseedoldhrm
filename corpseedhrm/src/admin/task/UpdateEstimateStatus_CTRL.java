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
public class UpdateEstimateStatus_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 		   
		String token = (String) session.getAttribute("uavalidtokenno");
		String loginuaid= (String)session.getAttribute("loginuaid");
		
		String str = request.getParameter("array");
		String action=request.getParameter("action");
		String description=request.getParameter("description");
		String[] array=str.split(",");
		if(array!=null)
		for (String estSaleNo : array) {
			System.out.println("estSaleNo="+estSaleNo);
			boolean flag = Enquiry_ACT.updateEstimateStatus(action,estSaleNo,token);
			if(flag)
				TaskMaster_ACT.saveSaleCancelReason(estSaleNo,"NA",action,description,loginuaid,token,DateUtil.getCurrentDateIndianReverseFormat());
		}		
	}

}