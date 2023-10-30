package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class GetMilestoneDeliveryDateCTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session=request.getSession();
						
			PrintWriter pw=response.getWriter();			
//				start
			String token=(String)session.getAttribute("uavalidtokenno");
			String milestoneKey=request.getParameter("milestoneKey").trim();
			String salesKey=request.getParameter("salesKey").trim();
			String deliveryDate=TaskMaster_ACT.getAssignedTaskDeliveryDate(salesKey,milestoneKey,token);

		pw.write(deliveryDate);				
			
		   
		}catch (Exception e) {
			e.printStackTrace();
		}
		}
}