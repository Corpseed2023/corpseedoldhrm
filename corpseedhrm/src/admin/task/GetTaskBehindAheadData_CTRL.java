package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import commons.DateUtil;

public class GetTaskBehindAheadData_CTRL extends HttpServlet {

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
			
			Long behind[]=new Long[3];
			Long ahead[]=new Long[3];
			Long ontime[]=new Long[3];
			
			
			String today=DateUtil.getCurrentDateIndianFormat1();
			String date=DateUtil.getCurrentDateIndianReverseFormat();
			int month=Integer.parseInt(today.substring(3, 5));
			String months[]=DateUtil.getPrevious3MonthName(month);
			
			String monthDate[]=DateUtil.getMonthEndDate(months);
			
			if(monthDate!=null) {
				for(int i=0;i<monthDate.length;i++) {
					String startDate=monthDate[i].substring(0, 7)+"-01";
					behind[i]=TaskMaster_ACT.countAllBehindTask(startDate,monthDate[i],date,token,role,uaid,teamKey);
					ahead[i]=TaskMaster_ACT.countAllAheadTask(startDate,monthDate[i],token,role,uaid,teamKey);
					ontime[i]=TaskMaster_ACT.countAllOnTimeTask(startDate,monthDate[i],token,role,uaid,teamKey);
				}
			}		
			pw.write(months[0]+"#"+months[1]+"#"+months[2]+"#"+-behind[0]+"#"+-behind[1]+"#"+-behind[2]+"#"+ahead[0]+"#"+ahead[1]+"#"+ahead[2]+"#"+ontime[0]+"#"+ontime[1]+"#"+ontime[2]);	
			
		}catch (Exception e) {
			e.printStackTrace();
		}

	}

}