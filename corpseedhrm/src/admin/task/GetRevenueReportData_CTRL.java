package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import commons.DateUtil;

public class GetRevenueReportData_CTRL extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
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
			
			double totalRevenue[]=new double[6];
			double estimateReve[]=new double[6];
						
			String today=DateUtil.getCurrentDateIndianFormat1();
			int month=Integer.parseInt(today.substring(3, 5));
			String months[]=DateUtil.getPrevious6MonthName(month);
			
			String monthDate[]=DateUtil.get6MonthEndDate(months);
			
			if(monthDate!=null) {
				for(int i=0;i<monthDate.length;i++) {
					String startDate=monthDate[i].substring(0, 7)+"-01";
					
					totalRevenue[i]=TaskMaster_ACT.sumTotalRevenue(startDate,monthDate[i],token,role,uaid,teamKey);
					double discount=TaskMaster_ACT.sumTotalRevenueDiscount(startDate,monthDate[i],token,role,uaid,teamKey);
//					System.out.println("discount="+discount);
					totalRevenue[i]=totalRevenue[i]-discount;
					estimateReve[i]=TaskMaster_ACT.sumEstimateRevenue(startDate,monthDate[i],token,role,uaid,teamKey);
					
				}
			}	
			String monthApp=months[0]+"#"+months[1]+"#"+months[2]+"#"+months[3]+"#"+months[4]+"#"+months[5];
			String tRev=totalRevenue[0]+"#"+totalRevenue[1]+"#"+totalRevenue[2]+"#"+totalRevenue[3]+"#"+totalRevenue[4]+"#"+totalRevenue[5];
			String eRev=estimateReve[0]+"#"+estimateReve[1]+"#"+estimateReve[2]+"#"+estimateReve[3]+"#"+estimateReve[4]+"#"+estimateReve[5];
//			System.out.println(monthApp);
//			System.out.println(tRev);
//			System.out.println(eRev);
			pw.write(monthApp+"#"+tRev+"#"+eRev);	
			
		}catch (Exception e) {
			e.printStackTrace();
		}

	}

}