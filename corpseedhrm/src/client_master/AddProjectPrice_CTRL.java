package client_master;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@SuppressWarnings("serial")
public class AddProjectPrice_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		Date date = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		String dateTime=formatter.format(date);  
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String loginuID = (String) session.getAttribute("loginuID");	
		
			String price_type = request.getParameter("price_type").trim();
			String Price = request.getParameter("Price").trim();
			String Service_Type = request.getParameter("Service_Type").trim();
			String Term_Status = request.getParameter("Term_Status").trim();
			String Term_Time = request.getParameter("Term_Time").trim();
			String GST_Status = request.getParameter("GST_Status").trim();
			String Gst_Percent = request.getParameter("Gst_Percent").trim();
			String Gst_Price = request.getParameter("Gst_Price").trim();
			String Total_Price = request.getParameter("Total_Price").trim();	
			String pid = request.getParameter("pid").trim();
			String Enq = request.getParameter("Enq").trim();
			Clientmaster_ACT.addProductPrice(pid,price_type,Price,Service_Type,Term_Status,Term_Time,GST_Status,Gst_Percent,Gst_Price,Total_Price,uavalidtokenno,loginuID,dateTime,Enq);		
			if(Enq.equalsIgnoreCase("NA")){
				String pregpuno = request.getParameter("pregpuno");
				String pregname =Clientmaster_ACT.getProjectName(pregpuno,uavalidtokenno);
				Clientmaster_ACT.updateAccountStatement(pid,pregpuno,uavalidtokenno,pregname);
			}
	}

}