package admin.seo;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import admin.master.Usermaster_ACT;
import client_master.Clientmaster_ACT;


public class AddFolder_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		try
		{
			HttpSession session = request.getSession();
			PrintWriter pw=response.getWriter();
			
			String folder_name = request.getParameter("folder_name").trim();
			String token=(String)session.getAttribute("uavalidtokenno");
			String loginid=(String)session.getAttribute("loginuID");
			String loginuaid=(String)session.getAttribute("loginuaid");
			
			String clientId="NA";
			boolean flag=Usermaster_ACT.isThisClient(loginuaid, token);
			if(flag){
				String clientNo=Usermaster_ACT.getClientNumber(loginuaid, token);
				if(!clientNo.equalsIgnoreCase("NA")){
					clientId=Clientmaster_ACT.getClientId(clientNo, token);
				}
			}
			String fkey =RandomStringUtils.random(40, true, true);
			String fsaleskey =RandomStringUtils.random(40, true, true);
			
			boolean status=SeoOnPage_ACT.addFolder(fkey,fsaleskey,folder_name,loginid,token,clientId,loginuaid,"Main","Personal");
		if(status){
			pw.write("pass");
		}else{
			pw.write("fail");
		}
	}
		catch(Exception e)
		{
				e.printStackTrace();
		}
		
	}

}
