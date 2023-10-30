package admin.enquiry;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.task.TaskMaster_ACT;

@SuppressWarnings("serial")
public class GetRecentActiveProjects_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
									
			HttpSession session = request.getSession(); 
			String token = (String)session.getAttribute("uavalidtokenno");
			String loginuaid = (String)session.getAttribute("loginuaid");
			String tdata="";
			String role=request.getParameter("role");
			String teamKey=request.getParameter("teamKey");
			String uaid=request.getParameter("uaid");
//			System.out.println(role+"/"+teamKey+"/"+uaid);
			String recentDeliveryProjects[][]=TaskMaster_ACT.getRecentActiveProjects(role,teamKey,uaid,token,"NA",loginuaid);
			if(recentDeliveryProjects!=null)
			for(int i=0;i<recentDeliveryProjects.length;i++) {
				String deliveryData[]=TaskMaster_ACT.getProjectsDeliveryDate(recentDeliveryProjects[i][2], token, "NA");
				tdata+="<tr><td>"+recentDeliveryProjects[i][0]+"</td><td>"+recentDeliveryProjects[i][1]+"</td><td>"+deliveryData[0]+"  "+deliveryData[1]+"</td></tr>";
			}
			response.getWriter().write(tdata);
			
		}catch (Exception e) {
				e.printStackTrace();
		}

	}
}