package admin.task;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.enquiry.Enquiry_ACT;


@SuppressWarnings("serial")
public class UpdateArchiveStatus_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 		   
		String token = (String) session.getAttribute("uavalidtokenno");
		
		String str = request.getParameter("array");
		String action=request.getParameter("action");
		String[] array=str.split(",");
		if(array!=null)
		for (String unbillKey : array) {
			Enquiry_ACT.updateUnbilledStatus(action,unbillKey,token);
		}		
	}

}