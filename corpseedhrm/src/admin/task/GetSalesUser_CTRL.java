package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.master.Usermaster_ACT;


@SuppressWarnings("serial")
public class GetSalesUser_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		PrintWriter out=response.getWriter();	   
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");		
		try{		
		String salesKey = request.getParameter("salesKey").trim();
		List<String> taskUser=TaskMaster_ACT.getSalesTaskUser(salesKey,uavalidtokenno); 
		String data="";
		for (String t : taskUser) {
			data+=Usermaster_ACT.getUserByUaid(t,uavalidtokenno);
		}
		data+=Usermaster_ACT.getAllDeliveryManager(uavalidtokenno);
		out.write(data);
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}

}