package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import commons.DateUtil;

public class GetDeliveryStatics_CTRL extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session=request.getSession();
			PrintWriter pw=response.getWriter();
			DecimalFormat df = new DecimalFormat("####0.00");
			String token=(String)session.getAttribute("uavalidtokenno");
			String role=request.getParameter("role");
			if(role!=null)role=role.trim();
			
			String uaid=request.getParameter("uaid");
			if(uaid!=null)uaid=uaid.trim();
			
			if(uaid==null||uaid.length()<=0||uaid.equalsIgnoreCase("NA"))uaid=(String)session.getAttribute("loginuaid");
			String teamKey=request.getParameter("teamKey");
			if(teamKey==null||teamKey.length()<=0)teamKey="NA";
			
			String dateRev=DateUtil.getCurrentDateIndianReverseFormat();
			double total=0;
			double onTime=0;
			double delayed=0;
			double ontimePercent=0;
			double delayedPercent=0;
			String milestones[][]=TaskMaster_ACT.findMilestoneByCondition(role,uaid,teamKey,dateRev,token);
			
			if(milestones!=null&&milestones.length>0) {
				total=milestones.length;
				for(int i=0;i<milestones.length;i++) {
					String deliverydate=milestones[i][0];
					if(deliverydate!=null&&deliverydate.length()>0) {
						deliverydate=deliverydate.substring(6)+"-"+deliverydate.substring(3, 5)+"-"+deliverydate.substring(0,2);
						String deliveredOn=milestones[i][1];
						long days=0;
						if(deliveredOn!=null&&!deliveredOn.equals("NA"))
						days=DateUtil.daysBetweenTwoDates(deliverydate, deliveredOn);
						if(days==0&&deliveredOn!=null&&!deliveredOn.equals("NA"))onTime+=1;
						else if(days>0||deliveredOn==null||deliveredOn.equals("NA"))delayed+=1;
					}
				}
				ontimePercent=(100*onTime)/total;
				delayedPercent=(100*delayed)/total;
//				System.out.println(total+"/"+onTime+"/"+delayed);
			}
		pw.write(df.format(ontimePercent)+"#"+df.format(delayedPercent));	
		}catch (Exception e) {
			e.printStackTrace();
		}

	}

}