package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.task.TaskMaster_ACT;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@SuppressWarnings("serial")
public class GetInvoiceDetails_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			
			String invoice=request.getParameter("invoice").trim();

			String token = (String)session.getAttribute("uavalidtokenno");
			
			String invoiceDetails[][]=Enquiry_ACT.getInvoiceDetails(invoice,token);
			
			if(invoiceDetails!=null&&invoiceDetails.length>0){
					json.put("uuid", invoiceDetails[0][0]);
					json.put("invoice_no", invoiceDetails[0][1]);
					json.put("date", invoiceDetails[0][2]);
					json.put("company", invoiceDetails[0][3]);
					json.put("gstin", invoiceDetails[0][4]);
					json.put("address", invoiceDetails[0][5]);
					json.put("service_name", invoiceDetails[0][6]);
					json.put("total_amount",invoiceDetails[0][7]);
					json.put("country",TaskMaster_ACT.getCountryByName(invoiceDetails[0][8]));
					json.put("state", invoiceDetails[0][9]);
					json.put("city", invoiceDetails[0][10]);
					json.put("state_code", invoiceDetails[0][11]);
					json.put("status", invoiceDetails[0][12]);
					json.put("invoiceType", invoiceDetails[0][13]);
					json.put("contact_name", invoiceDetails[0][14]);
					json.put("contact_pan", invoiceDetails[0][15]);
					json.put("contact_country",TaskMaster_ACT.getCountryByName(invoiceDetails[0][16]));
					json.put("contact_state", invoiceDetails[0][17]);
					json.put("contact_city", invoiceDetails[0][18]);
					json.put("contact_address", invoiceDetails[0][19]);
					json.put("contact_state_code", invoiceDetails[0][20]);
					
					jsonArr.add(json);
				out.println(jsonArr);
			}
		}

		catch (Exception e) {
				e.printStackTrace();
		}

	}
}