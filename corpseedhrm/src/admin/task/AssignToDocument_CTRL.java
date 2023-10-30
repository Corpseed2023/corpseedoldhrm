package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.enquiry.Enquiry_ACT;
import commons.DateUtil;


@SuppressWarnings("serial")
public class AssignToDocument_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session=request.getSession();
		PrintWriter pw=response.getWriter();
		
		String salesKey = request.getParameter("salesKey").trim();
		String teamKey=request.getParameter("teamKey").trim();
		String uaid = request.getParameter("uaid").trim();		
		String name = request.getParameter("name").trim();
		//getting today's date document_assign_date
		String today=DateUtil.getCurrentDateIndianFormat1();
		String currentTime=DateUtil.getCurrentTime24Hours();
		String token= (String)session.getAttribute("uavalidtokenno");
		String tat_delivery_date="NA";
		String tat_delivery_time="NA";
		
		boolean serviceAssigned=TaskMaster_ACT.isServiceAssigned(salesKey,uaid,token);
		String tat[]=Enquiry_ACT.findSalesTat(salesKey,token);
		if(tat!=null&&tat.length>0&&tat[0]!=null&&!tat[0].equalsIgnoreCase("NA")
			&&tat[1]!=null&&!tat[1].equalsIgnoreCase("NA")) {
			
			int time[]=DateUtil.calculateTimeDayHour(tat[0],tat[1]);
			
			String deliveryData[]=DateUtil.getLastDate(today, time[0],time[1]);
			tat_delivery_date=deliveryData[0];
			tat_delivery_time=deliveryData[1];
		}		
		
		if(!serviceAssigned) {		
			boolean flag=TaskMaster_ACT.updateSalesDocumentAssignDetails(salesKey,uaid,name,today,token,currentTime,tat_delivery_date,tat_delivery_time,teamKey);
			if(flag)pw.write("pass");
			else pw.write("fail");
		}else {
			pw.write("assigned");
		}
			
	}

}