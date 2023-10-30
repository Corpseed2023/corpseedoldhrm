package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import commons.DateUtil;

@SuppressWarnings("serial")
public class GetConsultingSaleDetails_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {	
			PrintWriter pw=response.getWriter();
			HttpSession session = request.getSession(); 
			String token = (String)session.getAttribute("uavalidtokenno");
			
			String salesKey=request.getParameter("salesKey");	
			String today=DateUtil.getCurrentDateIndianReverseFormat();
			
			String data="";
			
			if(salesKey!=null&&salesKey.length()>0) {
				String[] consultingService=Enquiry_ACT.findConsultingSaleDetails(salesKey, token);				
				if(consultingService!=null&&consultingService.length>0) {					
					data="<div class=\"col-sm-12\">\n"
							+ "		<div class=\"col-sm-6 mb10\">Consultant</div>\n"
							+ "	    <div class=\"col-sm-6 mb10\">"+consultingService[4]+"</div>\n"
							+ "		<div class=\"col-sm-6 mb10\">Service Type</div>\n"
							+ "	    <div class=\"col-sm-6 mb10\">"+consultingService[0]+" ("+consultingService[1]+" "+consultingService[2]+")</div>\n"
							+ "	    <div class=\"col-sm-6 mb10\">End Date</div>\n"
							+ "	    <div class=\"col-sm-6 mb10\"><input type=\"date\" id=\"consultingSaleEndDate\" onchange=\"dateChange()\" min=\""+today+"\" value=\""+consultingService[3]+"\"><button type=\"button\" class=\"btn-primary mlft10\" id=\"consultingSaleBtn\" onclick=\"updateEndDate()\" disabled=\"disabled\">Update</button></div>\n"
							+ "	    <input type=\"hidden\" id=\"consultingSalesKey\" value=\""+salesKey+"\">\n"
							+ "	   </div>";
				}
			}			
			pw.write(data);
		}catch (Exception e) {
				e.printStackTrace();
		}

	}
}