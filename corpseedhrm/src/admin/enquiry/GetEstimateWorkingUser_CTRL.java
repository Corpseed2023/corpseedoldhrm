package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.master.Usermaster_ACT;
import admin.task.TaskMaster_ACT;

@SuppressWarnings("serial")
public class GetEstimateWorkingUser_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
					
			HttpSession session = request.getSession(); 
			PrintWriter out=response.getWriter();
			String estkey=request.getParameter("estkey").trim();

			String token = (String)session.getAttribute("uavalidtokenno");
			String data="";
			boolean isInvoiced=Enquiry_ACT.isEstimateInvoiced(estkey, token);
			if(isInvoiced) {
				String salesKey=TaskMaster_ACT.getSalesKeyByEstimateKey(estkey,token);
				if(salesKey!=null&&!salesKey.equalsIgnoreCase("NA")) {
					List<String> taskUser=TaskMaster_ACT.getSalesTaskUser(salesKey,token); 
					
					for (String t : taskUser) {
						data+=Usermaster_ACT.getUserByUaid(t,token);
					}
				}
			}			
			
		   data+=Usermaster_ACT.getAllDeliveryManager(token);
		   out.write(data);
		}catch (Exception e) {
				e.printStackTrace();
		}

	}
}