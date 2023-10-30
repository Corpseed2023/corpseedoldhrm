package client_master;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class PrimaryContactData_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session=request.getSession();
			PrintWriter pw=response.getWriter();
			boolean flag=false;
			String token=(String)session.getAttribute("uavalidtokenno");
			String conKey = request.getParameter("conKey").trim();
			String clientKey = request.getParameter("clientKey").trim();
			//getting given contact details to update company personal details			
			String contact[][]=Clientmaster_ACT.getContactDetails(conKey,token);
			//updating client personal details
			if(contact!=null&&contact.length>0){				
				flag=Clientmaster_ACT.updateClientPersonalData(clientKey,contact[0][0],contact[0][1],contact[0][2],contact[0][3],contact[0][4],contact[0][5],contact[0][6],token);
			}
		if(flag){
//			make primary of this contact and except secondary
			flag=Clientmaster_ACT.makeThisPrimary(conKey,token);
			Clientmaster_ACT.makePrimaryExceptThis(clientKey,conKey,token);
		}
			if(flag)pw.write("pass");
			else pw.write("fail");
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}
