package admin.enquiry;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import client_master.Clientmaster_ACT;

@SuppressWarnings("serial")
public class EnquiryEdit_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			boolean status = false;
			HttpSession session = request.getSession();
			Date date = new Date();
			SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");	
			String dateTime=formatter.format(date);   
			
			
			String productType = request.getParameter("productType").trim();
			String product_name = request.getParameter("product_name").trim();
			String enquid = request.getParameter("enquid").trim();
			String uid = request.getParameter("uid").trim();
			String enqType = request.getParameter("enqType").trim();
			String company = request.getParameter("company").trim();
			String industry = request.getParameter("industry").trim();
			String enqName = request.getParameter("enqName").trim();
			String enqMob = request.getParameter("enqMob").trim();
			String enqEmail = request.getParameter("enqEmail").trim();
			String country = request.getParameter("country").trim();
			String state = request.getParameter("state").trim();
			String city = request.getParameter("city").trim();
			String enqStatus = request.getParameter("enqStatus");
			String enqAdd = request.getParameter("enqAdd").trim();
			String enqRemarks =request.getParameter("enqRemarks").trim();
			String altermob =request.getParameter("altermob").trim();
			String pid =request.getParameter("pid").trim();
				
			String token = (String)session.getAttribute("uavalidtokenno");
			String addedby = (String)session.getAttribute("loginuID");
			String ptype=Enquiry_ACT.getProductType(enquid,token);
			
			if(!pid.equalsIgnoreCase("NA")){
				if(!ptype.equalsIgnoreCase(productType)){
					Enquiry_ACT.deletePriceMilestone(uid,token,"enquiry");
					
					Enquiry_ACT.addProjectPrice(pid,uid,token,addedby,dateTime,"enquiry");					
					Enquiry_ACT.addProjectMilestone(pid,uid,token,addedby,dateTime,"enquiry");					
					Clientmaster_ACT.updateProjectTimeline(uid, token, "enquiry");	
					
				}
			}else if(productType.equalsIgnoreCase("Customize")){				
				if(!ptype.equalsIgnoreCase("Customize")){
					Enquiry_ACT.deletePriceMilestone(uid,token,"enquiry");
				}
			}
			//updating enquiry table's data
			status = Enquiry_ACT.EditEnquiry(enquid, enqType, company,industry,enqName,enqMob,enqEmail, country,state,city,enqStatus, enqAdd,enqRemarks,altermob,addedby,token,productType,product_name);
			
			if (status) {
//				session.setAttribute("ErrorMessage", "Enquiry is Successfully updated!");
				response.sendRedirect(request.getContextPath() + "/manage-enquiry.html");
			} else {
				session.setAttribute("ErrorMessage", "Enquiry is not updated!");
				response.sendRedirect(request.getContextPath() + "/notification.html");
			}
		}

		catch (Exception e) {
			
		}

	}

}
