package client_master;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.enquiry.Enquiry_ACT;

public class UpdateProject_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
	   
	   try
		{  
		 boolean status=false;
		HttpSession session =request.getSession();
		Date date = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");	
		String dateTime=formatter.format(date);  
		
		String token= (String)session.getAttribute("uavalidtokenno");
		String addedby= (String)session.getAttribute("loginuID");
		String paymentbased = request.getParameter("paymentbased").trim();
		String uid = request.getParameter("uid").trim();
		String pregpuno = request.getParameter("ProjectNo").trim();
		String pregcuid = request.getParameter("cid").trim();
		String pregpname = request.getParameter("ProjectName").trim();
		String pregtype = request.getParameter("ProjectType").trim();
		String pregsdate = request.getParameter("StartingDate").trim();
		String pregddate = request.getParameter("DeliveryDate").trim();
		String pregstatus = "1";
		String serviceType = request.getParameter("serviceType").trim();
		String pregremarks = request.getParameter("Remarks").trim();
		String pid = request.getParameter("pid").trim();
		String ptype=Clientmaster_ACT.getProjectType(uid,token);
		
		//if product changes then previous product's price and milestone deleted and newer inserted also updating account balance
		if(!pid.equalsIgnoreCase("NA")){
			if(!ptype.equalsIgnoreCase(pregtype)){
				Enquiry_ACT.deletePriceMilestone(uid,token,"NA");
				
				Enquiry_ACT.addProjectPrice(pid,uid,token,addedby,dateTime,"NA");					
				Enquiry_ACT.addProjectMilestone(pid,uid,token,addedby,dateTime,"NA");	
				
			}
		}else if(pregtype.equalsIgnoreCase("Customize")){				
			if(!ptype.equalsIgnoreCase("Customize")){
				Enquiry_ACT.deletePriceMilestone(uid,token,"NA");
			}
		}
		Clientmaster_ACT.updateProjectTimeline(uid, token, "NA");	
		//updating account statement and billing
		Clientmaster_ACT.updateAccountStatement(uid,pregpuno,token,pregpname);
		
		status=Clientmaster_ACT.updateProject( uid, pregpuno, pregpname, pregtype,pregcuid, pregsdate, pregddate,pregstatus, pregremarks,serviceType,paymentbased);
		if(status)
		{
//			session.setAttribute("ErrorMessage", "Project is Successfully Updated!.");
			response.sendRedirect(request.getContextPath()+"/manage-project.html");
		}
		else {
			session.setAttribute("ErrorMessage", "Project is not Updated!.");
		}

		}catch (Exception e) {
		
		}
	
	}

}
