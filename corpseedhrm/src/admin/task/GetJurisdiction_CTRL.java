package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.enquiry.Enquiry_ACT;

public class GetJurisdiction_CTRL extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			
			PrintWriter pw=response.getWriter();
			
			HttpSession session = request.getSession(); 

			String token = (String)session.getAttribute("uavalidtokenno");
			
			String global=request.getParameter("global");
			if(global==null)global="NA";else global=global.trim();
			
			String central=request.getParameter("central");
			if(central==null)central="NA";else central=central.trim();
			
			String state=request.getParameter("state");
			if(state==null)state="NA";else state=state.trim();
			
			if(global.equalsIgnoreCase("NA")&&central.equalsIgnoreCase("NA")
					&&state.equalsIgnoreCase("NA")) {
				String prodrefid=request.getParameter("prodrefid").trim();
				String product[]=Enquiry_ACT.getProductJurisdiction(prodrefid, token);
				central=product[0];
				state=product[1];
				global=product[2];
			}
			
			
			String jurisdiction="<option value=''>Select Jurisdiction</option>";
			if(global.equals("1")){
				jurisdiction+="<optgroup label=\"Global\"><option value=\"Global\">Global</option></optgroup>";
			}
			if(central.equals("1")) {
				jurisdiction+="<optgroup label=\"Central\"><option value=\"Central\">Central</option></optgroup>";
			}
			if(state.equals("1")) {
				String states[][]=TaskMaster_ACT.getStatesByCountryCode("IN");
				if(states!=null&&states.length>0) {
					jurisdiction+="<optgroup label=\"State\">";
					for (int i=0;i<states.length;i++) {
						jurisdiction+="<option value='"+states[i][0]+"'>"+states[i][0]+"</option>";
					}
					jurisdiction+="</optgroup>";
				}
			}			
		pw.write(jurisdiction);
			
		}catch (Exception e) {
			e.printStackTrace();
		}

	}

}