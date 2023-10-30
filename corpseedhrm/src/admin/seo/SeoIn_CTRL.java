package admin.seo;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class SeoIn_CTRL extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			boolean status =false;
			HttpSession session = request.getSession();
			String token=(String)session.getAttribute("uavalidtokenno");
			String amopscontent = request.getParameter("longdescription").trim();
			String amonpspuid = request.getParameter("ProjectName").trim();			
			String amonpstatype =request.getParameter("activitytype").trim();
			String amonpstuid = request.getParameter("taskname").trim();
			String amopstwurl = request.getParameter("website").trim();
			
			String amonpsturl = request.getParameter("targeturl").trim();
			String amopskeyw = request.getParameter("keyword").trim();
			String amopssourl = request.getParameter("submittedonurl").trim();
			String amopsseng = request.getParameter("searchengine").trim();
			String amonpsstatus = request.getParameter("status").trim();
			String amonpststatus = request.getParameter("tstatus").trim();
			String amonpsaddedby= request.getParameter("addedbyuser").trim();
			String websitenature= request.getParameter("websitenature").trim();
//			System.out.println(amopscontent+"/"+amonpspuid+"/"+amonpstuid+"/"+amopstwurl+"/"+amonpstatype+"/"+amonpsturl);
//			System.out.println(amopskeyw+"/"+amopssourl+"/"+amopsseng+"/"+amonpsstatus+"/"+amonpststatus+"/"+amonpsaddedby+"/"+websitenature);
			session.setAttribute("amopstwurl", amopstwurl);
			session.setAttribute("amonpstatype", amonpstatype);
			session.setAttribute("amonpsturl", amonpsturl);
			session.setAttribute("amopskeyw", amopskeyw);

			status=SeoOnPage_ACT.saveSeoDetail(amopscontent,amonpstuid,amopstwurl,amonpstatype,amonpsturl,amopskeyw,amopssourl,amopsseng,amonpsstatus,amonpststatus,amonpsaddedby,amonpspuid, websitenature);
			
			String[] newsubmiturlarr = amopssourl.split("/");
			String newurl = "";
			try{
				newurl = newsubmiturlarr[2];
			}
			catch (Exception e) {e.printStackTrace();
				newurl = newsubmiturlarr[0];
			}
			SeoOnPage_ACT.saveNewSEOURL(newurl,amonpstatype,websitenature,"Alive",amonpsaddedby);		
		
			
			if(status) {				
				response.sendRedirect(request.getContextPath()+"/manage-seo.html");
			}
			else {
				session.setAttribute("ErrorMessage", "SEO is not done!");
				response.sendRedirect(request.getContextPath()+"/notification.html");
			}
		}
		catch(Exception e){ }
	}
}