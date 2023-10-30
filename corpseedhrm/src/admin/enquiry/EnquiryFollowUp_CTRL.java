package admin.enquiry;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class EnquiryFollowUp_CTRL extends HttpServlet {

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

//		RequestDispatcher rd = null;
//		boolean status = false;
		
		HttpSession session = request.getSession();
		DateFormat df = new SimpleDateFormat("dd-MM-yyyy");
		Calendar calobj = Calendar.getInstance();
//		String today = df.format(calobj.getTime());
		
		String loginid = (String) session.getAttribute("loginuID");
		
		String showdelivery = request.getParameter("showdelivery").trim();
		String enqdate = request.getParameter("today").trim();
		String enqfeuid = request.getParameter("enqfeuid").trim();
		String enqfstatus = request.getParameter("enqfstatus").trim();
		String enqfdate = request.getParameter("enqfdate").trim();
		String enqfremark = request.getParameter("enqfremark").trim();
		String token= (String)session.getAttribute("uavalidtokenno");
//		String addeduser=(String)session.getAttribute("loginuID");
		String uarefid= (String)session.getAttribute("uarefid");
		
//		if(enqfstatus.equalsIgnoreCase("Final")){
//			Enquiry_ACT.registerClientAndAssign(enqfeuid,token,addeduser,today);
//		}
		
		
		boolean status1 = Enquiry_ACT.saveFollowUp(enqfeuid,enqfstatus,enqdate,enqfremark,loginid,enqfdate,token,uarefid,showdelivery);
//		boolean status2 = Enquiry_ACT.saveFollowUpStatus(enqfeuid, enqfstatus,enqdate,enqfdate,token);

//		if((status1 == true) && (status2 == true))
//			status = true;
		
//		if (status) 
//			session.setAttribute("ErrorMessage","Enquiry Follow Up is Successfully added!");
//		else 
//			session.setAttribute("ErrorMessage", "Enquiry Follow Up Failed!");
		

//		rd = request.getRequestDispatcher("/manage-enquiry.html");
//		rd.forward(request, response);

	}

}