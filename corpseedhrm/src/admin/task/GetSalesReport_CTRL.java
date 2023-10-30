package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.enquiry.Enquiry_ACT;
import client_master.Clientmaster_ACT;

public class GetSalesReport_CTRL extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//		System.out.println("calledddddddddddddddddddddd");
		
		try {
			DecimalFormat df = new DecimalFormat("####0.00");
			HttpSession session=request.getSession();
			PrintWriter pw=response.getWriter();
			String token=(String)session.getAttribute("uavalidtokenno");
			String role=request.getParameter("role");	
			if(role!=null)role=role.trim();
			
			String uaid=request.getParameter("uaid");
			if(uaid!=null)uaid=uaid.trim();
			
			if(uaid==null||uaid.length()<=0||uaid.equalsIgnoreCase("NA"))uaid=(String)session.getAttribute("loginuaid");
			String teamKey=request.getParameter("teamKey");
			if(teamKey==null||teamKey.length()<=0)teamKey="NA";
			
			long estimateSale=Enquiry_ACT.getTotalEstimateQty(role,uaid,teamKey,token);
            long totalSale=Enquiry_ACT.getTotalSalesQty(role,uaid,teamKey,token);
            double dueAmount=TaskMaster_ACT.getSalesDueAmount(role,uaid,teamKey,token);
            int clients=Clientmaster_ACT.getTotalClient(role,uaid,teamKey,token);
			
		pw.write(estimateSale+"#"+totalSale+"#"+df.format(dueAmount)+"#"+clients);	
		}catch (Exception e) {
			e.printStackTrace();
		}

	}

}