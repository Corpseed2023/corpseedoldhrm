package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import commons.DateUtil;

public class GetProjectOverviewData_CTRL extends HttpServlet {

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
			
			Long projectCreated[]=new Long[6];
			Long projectDelivered[]=new Long[6];
						
			String today=DateUtil.getCurrentDateIndianFormat1();
			int month=Integer.parseInt(today.substring(3, 5));
			String months[]=DateUtil.getPrevious6MonthName(month);
			
			String monthDate[]=DateUtil.get6MonthEndDate(months);
			
			if(monthDate!=null) {
				for(int i=0;i<monthDate.length;i++) {
					String startDate=monthDate[i].substring(0, 7)+"-01";
					
					projectCreated[i]=TaskMaster_ACT.countAllCreatedProject(startDate,monthDate[i],token,role,uaid,teamKey);
					projectDelivered[i]=TaskMaster_ACT.countAllDeliveredProject(startDate,monthDate[i],token,role,uaid,teamKey);
					
				}
			}	
			String monthApp=months[0]+"#"+months[1]+"#"+months[2]+"#"+months[3]+"#"+months[4]+"#"+months[5];
			String created=projectCreated[0]+"#"+projectCreated[1]+"#"+projectCreated[2]+"#"+projectCreated[3]+"#"+projectCreated[4]+"#"+projectCreated[5];
			String delivered=projectDelivered[0]+"#"+projectDelivered[1]+"#"+projectDelivered[2]+"#"+projectDelivered[3]+"#"+projectDelivered[4]+"#"+projectDelivered[5];
//			System.out.println(monthApp);
//			System.out.println(created);
//			System.out.println(delivered);
//			System.out.println(monthApp+"#"+created+"#"+delivered);
			pw.write(monthApp+"#"+created+"#"+delivered);	
			
		}catch (Exception e) {
			e.printStackTrace();
		}

	}

}