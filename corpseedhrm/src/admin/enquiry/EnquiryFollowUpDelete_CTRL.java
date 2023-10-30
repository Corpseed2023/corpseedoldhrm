package admin.enquiry;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
public class EnquiryFollowUpDelete_CTRL extends HttpServlet {
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			String uid = request.getParameter("info").trim();
			Enquiry_ACT.FollowUpDelete(uid);

		} catch (Exception e) {
			
		}

	}

}
