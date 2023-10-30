package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@SuppressWarnings("serial")
public class GetCancelledInvoice_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();		
			
			HttpSession session = request.getSession(); 
			
			String invoice=request.getParameter("invoice").trim();

			String token = (String)session.getAttribute("uavalidtokenno");
			String cancelledInvoice[][]=Enquiry_ACT.getCancelledInvoice(invoice, token);
			
				if(cancelledInvoice!=null&&cancelledInvoice.length>0){
					for(int j=0;j<cancelledInvoice.length;j++){
						json.put("uuid", cancelledInvoice[j][0]);
						json.put("invoice", cancelledInvoice[j][1]);	
						json.put("date", cancelledInvoice[j][2]);
						json.put("amount", cancelledInvoice[j][3]);
						
						jsonArr.add(json);
					}
					out.println(jsonArr);
				}
				}		

		catch (Exception e) {
				e.printStackTrace();
		}

	}
}