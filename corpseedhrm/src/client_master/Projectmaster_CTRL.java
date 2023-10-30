package client_master;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import admin.master.Usermaster_ACT;
import commons.DateUtil;
import hcustbackend.ClientACT;


public class Projectmaster_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		try
		{
			boolean status =false;
			HttpSession session = request.getSession();
			Date date = new Date();
			SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
			String dateTime=formatter.format(date);
		
			String today =DateUtil.getCurrentDateIndianFormat1();
			
			String paymentbased= request.getParameter("paymentbased").trim();
			String pid= request.getParameter("pid").trim();
			String pregcuid = request.getParameter("cid").trim();
			String pregpuno = request.getParameter("ProjectNo").trim();
			String serviceType = request.getParameter("serviceType").trim();
			String pregtype = request.getParameter("ProjectType").trim();
			String pregpname = request.getParameter("ProjectName").trim();
			String pregsdate = request.getParameter("StartingDate").trim();
			String pregddate = request.getParameter("DeliveryDate").trim();
			String pregstatus = "1";
			String pregremarks = request.getParameter("Remarks").trim();
			String addeduser=(String)session.getAttribute("loginuID");
			String token = (String) session.getAttribute("uavalidtokenno");
			
		status=Clientmaster_ACT.saveProjectDetail(pregpuno,pregcuid,pregtype,pregpname,pregsdate,pregddate,addeduser,pregstatus,pregremarks, token,serviceType,paymentbased);
		Clientmaster_ACT.createProjectFolder(pregpuno,pregpname,addeduser,token,pregcuid);
		
		if(!pregtype.equalsIgnoreCase("Customize")){		
			String id=Clientmaster_ACT.getProjectId(pregpuno,pregcuid,pregtype,token);
			Clientmaster_ACT.saveProjectPrice(pid,id,token,addeduser,dateTime);
			Clientmaster_ACT.saveProjectMilestone(pid,id,token,addeduser,dateTime);	
			Clientmaster_ACT.updateProjectTimeline(id, token, "NA");			
		}
			double total_price=Clientmaster_ACT.getTotalPrice(pid,token);
			String accbmuid=Clientmaster_ACT.getAccountId(pregcuid,token);
			String remarks=pregpuno+"#"+pregpname;
			Clientmaster_ACT.addPrice(accbmuid,total_price,remarks,today,addeduser,pregpuno);		
		
			//add notification 'register project ...'
			String loginuaid = (String) session.getAttribute("loginuaid");
			String pagename="manage-project.html";
			String accesscode="CMP04";
			String clientpage="client_inbox.html";
			String uuid =RandomStringUtils.random(30, true, true);	
			String clname=ClientACT.getClientName(pregcuid, token);
			String assignby=Usermaster_ACT.getLoginUserName(loginuaid,token);				
			String msg="<b>"+pregpuno+" : "+pregpname+"</b> project created by  <b>"+assignby+"</b> for <b>"+clname+"</b>";
			ClientACT.addNotification(uuid, pregpuno, msg, pagename,"project", "1", pregcuid, "1", "1", addeduser, token,clientpage, loginuaid,accesscode,"1","1");
			
		if(status)
		{
//			session.setAttribute("ErrorMessage", "Project is Successfully registered!.");
			response.sendRedirect(request.getContextPath()+"/manage-project.html");
		}
		else {
			session.setAttribute("ErrorMessage", "Project is not updated!.");
			response.sendRedirect(request.getContextPath()+"/notification.html");
		}
	}
		
		catch(Exception e)
		{
				
		}
		
		
	}

}
