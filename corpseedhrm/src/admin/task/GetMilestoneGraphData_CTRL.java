package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class GetMilestoneGraphData_CTRL extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
//			DecimalFormat df = new DecimalFormat("####0.00");
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
			else
				teamKey=teamKey.trim();
			
			String milestones[][]=TaskMaster_ACT.getAssignedSalesMilestone(role,uaid,teamKey,token);
//			double totalMilestones=0;
			int unassigned=0;
			int newtask=0;
			int open=0;
			int hold=0;
			int pending=0;
			int completed=0;
			int expired=0;
			
//			double unassignedPercent=0;
//			double newtaskPercent=0;
//			double openPercent=0;
//			double holdPercent=0;
//			double pendingPercent=0;
//			double completedPercent=0;
//			double expiredPercentage=0;
			if(milestones!=null&&milestones.length>0) {
				
				for(int i=0;i<milestones.length;i++) {
					if(milestones[i][0]!=null) {
					if(milestones[i][0].equalsIgnoreCase("Unassigned")) {
						unassigned+=1;
					}else if(milestones[i][0].equalsIgnoreCase("New")){
						newtask+=1;
					}else if(milestones[i][0].equalsIgnoreCase("Open")){
						open+=1;
					}else if(milestones[i][0].equalsIgnoreCase("On-hold")){
						hold+=1;
					}else if(milestones[i][0].equalsIgnoreCase("Pending")){
						pending+=1;
					}else if(milestones[i][0].equalsIgnoreCase("Completed")){
						completed+=1;
					}else if(milestones[i][0].equalsIgnoreCase("Expired")){
						expired+=1;
					}
					}
				}
			}			
//			System.out.println(totalProjects+"/"+completed+"/"+partial+"/"+due);
//			if(totalMilestones>0) {
//				unassignedPercent=(100*unassigned)/totalMilestones;
//				newtaskPercent=(100*newtask)/totalMilestones;
//				openPercent=(100*open)/totalMilestones;
//				holdPercent=(100*hold)/totalMilestones;
//				pendingPercent=(100*pending)/totalMilestones;
//				completedPercent=(100*completed)/totalMilestones;
//				expiredPercentage=(100*expired)/totalMilestones;
//			}
//			System.out.println(completePercent+"/"+partialPercent+"/"+duePercent+"/"+((100*completed)/totalProjects));
			
//			pw.write(df.format(unassignedPercent)+"#"+df.format(newtaskPercent)+"#"+df.format(openPercent)
//			+"#"+df.format(holdPercent)+"#"+df.format(pendingPercent)+"#"+df.format(completedPercent)+"#"+
//					df.format(expiredPercentage)+"#"+unassigned+"#"+newtask+"#"+open+"#"+hold+"#"+pending+"#"+
//					completed+"#"+expired);
			pw.write(unassigned+"#"+newtask+"#"+open+"#"+hold+"#"+pending+"#"+completed+"#"+expired);
		}catch (Exception e) {
			e.printStackTrace();
		}

	}

}