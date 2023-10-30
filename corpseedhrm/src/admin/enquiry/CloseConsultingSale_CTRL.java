package admin.enquiry;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class CloseConsultingSale_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		try {
			HttpSession session = request.getSession(); 
			String token=(String)session.getAttribute("uavalidtokenno");
			String salesKey=request.getParameter("salesKey");
			String today=request.getParameter("closeDate");
			
			if(salesKey!=null&&salesKey.length()>0){
				Enquiry_ACT.updateSalesEndDate(salesKey,token,today);
			}			
		}
		catch (Exception e) {
			e.printStackTrace();
		}

	}
}