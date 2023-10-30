package admin.enquiry;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class EnquiryHistory_CTRL extends HttpServlet {
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			
			HttpSession session = request.getSession();
			String loginid = (String) session.getAttribute("loginuID");
			String uid = request.getParameter("info").trim();
			String click = request.getParameter("click").trim();
			String ipaddress=request.getRemoteAddr();
			
			Enquiry_ACT.HistoryAdd(uid, loginid, ipaddress,click);

		} catch (Exception e) {
			
		}

	}

}
