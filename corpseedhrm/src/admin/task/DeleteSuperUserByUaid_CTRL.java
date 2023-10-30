package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.master.Usermaster_ACT;
import client_master.Clientmaster_ACT;

public class DeleteSuperUserByUaid_CTRL extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session=request.getSession();
			String token=(String)session.getAttribute("uavalidtokenno");
			
			PrintWriter out=response.getWriter();
			
			String uaid=request.getParameter("uaid");
			if(uaid==null||uaid.length()<=0)uaid="0";
			
			
			int clientCount=Clientmaster_ACT.countClientsBySuperUser(uaid, token);
			
			if(clientCount>0)out.write("existClient");
			else {
				int contactCount=Clientmaster_ACT.countContactBySuperUser(uaid,token);
				if(contactCount>0)out.write("existContact");
				if(clientCount==0&&contactCount==0) {
					boolean deleteFlag = Usermaster_ACT.deleteSuperUser(uaid,token);
					if(deleteFlag)out.write("pass");
				}
			}			
			
		}catch (Exception e) {
			e.printStackTrace();
		}

	}

}