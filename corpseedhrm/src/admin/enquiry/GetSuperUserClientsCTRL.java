package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import client_master.Clientmaster_ACT;

@SuppressWarnings("serial")
public class GetSuperUserClientsCTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			PrintWriter out=response.getWriter();		
			
			HttpSession session = request.getSession(); 
			String token = (String)session.getAttribute("uavalidtokenno");
			
			String uaid=request.getParameter("uaid").trim();
			String data="";
			if(uaid!=null&&uaid.length()>0) {
			String clients[][]=Clientmaster_ACT.fetchAllClientsBySuperUser(uaid,token);
			if(clients!=null&&clients.length>0){
				data+="<ul>";
				for(int j=0;j<clients.length;j++){
					data+="<li>"+clients[j][0]+"</li>";						
				}
				data+="</ul>";
			}
			}	
//			System.o ut.println(data);
			out.write(data);
		}
		catch (Exception e) {
				e.printStackTrace();
		}

	}
}