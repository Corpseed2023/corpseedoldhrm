package hcustbackend;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class OpenThisProjectChatCTRL extends HttpServlet {
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		try {
			HttpSession session=request.getSession();
			
			String status=request.getParameter("status").trim();
			if(status.equalsIgnoreCase("1")) {
			String salesKey=request.getParameter("salesKey").trim();
			String projectNo=request.getParameter("projectNo").trim();
			String projectName=request.getParameter("projectName").trim();
			String closeDate=request.getParameter("closeDate").trim();
			
//			System.out.println("saving attribute");
//			System.out.println(salesKey+"/"+projectNo+"/"+projectName);
			session.setAttribute("forwardSalesKey", salesKey);
			session.setAttribute("forwardProjectNo", projectNo);
			session.setAttribute("forwardProjectName", projectName);
			session.setAttribute("forwardProjectCloseDate", closeDate);
			}else {
//				System.out.println("removing attribute");
				session.removeAttribute("forwardSalesKey");
				session.removeAttribute("forwardProjectNo");
				session.removeAttribute("forwardProjectName");
				session.removeAttribute("forwardProjectCloseDate");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
