package admin.seo;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class SeoEdit_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;


	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{try
	{
		boolean status =false;
		HttpSession session = request.getSession();
		String uid = request.getParameter("uid");

		String amopscontent = request.getParameter("longdescription").trim();
		String amonpstatype =request.getParameter("activitytype").trim();		
		String amopstwurl = request.getParameter("website").trim();		
		String amonpsturl = request.getParameter("targeturl").trim();
		String amopskeyw = request.getParameter("keyword").trim();
		String amopssourl = request.getParameter("submittedonurl").trim();
		String amopsseng = request.getParameter("searchengine").trim();
		String amonpsstatus = request.getParameter("status").trim();
		String amonpststatus = request.getParameter("tstatus").trim();
		String amonpsaddedby= request.getParameter("addedbyuser").trim();
		String websitenature= request.getParameter("websitenature").trim();

		status=SeoOnPage_ACT.updateSeoDetail(uid,amopscontent,amopstwurl,amonpstatype,amonpsturl,amopskeyw,amopssourl,amopsseng,amonpsstatus,amonpststatus,amonpsaddedby, websitenature);
		if(status)
		{
			response.sendRedirect(request.getContextPath()+"/manage-seo.html");
		}
		else {
			session.setAttribute("ErrorMessage", "Seo is not Updated!.");
			response.sendRedirect(request.getContextPath()+"/notification.html");
		}
	}

	catch(Exception e)
	{

	}


	}

}
