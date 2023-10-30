package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import admin.enquiry.Enquiry_ACT;
import admin.master.Usermaster_ACT;
import commons.DateUtil;


@SuppressWarnings("serial")
public class ReUploadDocument_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
//System.out.println("running good..................");
		HttpSession session=request.getSession();
		PrintWriter pw=response.getWriter();
		String token=(String)session.getAttribute("uavalidtokenno");
		
			String salesKey = request.getParameter("salesKey").trim();	
			String docKey = request.getParameter("docKey").trim();
			String location = request.getParameter("location").trim();
			
			String today = DateUtil.getCurrentDateIndianReverseFormat();
			
			String userUaid=(String)session.getAttribute("loginuaid");
			boolean flag=TaskMaster_ACT.updateDocumentReUploadStatus(docKey,token,userUaid,today,location);
			if(flag)
				flag=TaskMaster_ACT.updateSalesReUploadStatus(salesKey,token);
				
			if(flag) {
				//going to send notification to document person
				
				String user[]=Enquiry_ACT.findSalesDocumentUser(salesKey,token);
				if(user[0]!=null) {				
					String docName[]=TaskMaster_ACT.findSalesDocDetails(docKey, token);
					String requestedUserName=Usermaster_ACT.findUserByUaid(userUaid);
					
					String nKey=RandomStringUtils.random(40,true,true);
					String message="Re-Upload : <span class=\"text-info\">"+docName[0]+"</span> need to re-upload. Requested by &nbsp;<span class=\"text-muted\">"+requestedUserName+"</span>";
					TaskMaster_ACT.addNotification(nKey,today,user[0],"2","document-collection.html?reupload="+salesKey,message,token,userUaid,"fa fa-file");
				}		
				
				pw.write("pass");
			}
			else pw.write("fail");	
					
	}

}