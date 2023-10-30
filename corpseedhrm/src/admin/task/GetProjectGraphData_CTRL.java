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
import admin.master.Usermaster_ACT;

public class GetProjectGraphData_CTRL extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			DecimalFormat df = new DecimalFormat("####0.00");
			HttpSession session=request.getSession();
			PrintWriter pw=response.getWriter();
			String token=(String)session.getAttribute("uavalidtokenno");
			String loginuaid = (String)session.getAttribute("loginuaid");
			String department=Usermaster_ACT.getUserDepartment(loginuaid,token);
			if(department.equals("Admin")||department.equals("Account")) {
				
			String projects[][]=Enquiry_ACT.getAllSales(token);
			double totalProjects=0;
			double completed=0;
			double partial=0;
			double due=0;
			double completePercent=0;
			double partialPercent=0;
			double duePercent=0;
			if(projects!=null&&projects.length>0) {
				totalProjects=projects.length;
				for(int i=0;i<projects.length;i++) {
					if(projects[i][2]!=null&&projects[i][2].equals("100")) {
						boolean pymtDone=TaskMaster_ACT.isPaymentDone(projects[i][1],token);
						if(pymtDone)completed+=1;
						else due+=1;
					}else {
						boolean pymtDone=TaskMaster_ACT.isPaymentDone(projects[i][1],token);
						if(pymtDone)completed+=1;
						else partial+=1;
					}
				}
			}			
//			System.out.println(totalProjects+"/"+completed+"/"+partial+"/"+due);
			if(totalProjects>0) {
				completePercent=(100*completed)/totalProjects;
				partialPercent=(100*partial)/totalProjects;
				duePercent=(100*due)/totalProjects;
			}
//			System.out.println(completePercent+"/"+partialPercent+"/"+duePercent+"/"+((100*completed)/totalProjects));
			
			pw.write(df.format(duePercent)+"#"+df.format(partialPercent)+"#"+df.format(completePercent));
			}
		}catch (Exception e) {
			e.printStackTrace();
		}

	}

}