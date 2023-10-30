package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.task.TaskMaster_ACT;
import client_master.Clientmaster_ACT;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@SuppressWarnings("serial")
public class GetApprovedInvoiceCTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			
			String invoice=request.getParameter("invoice").trim();

			String token = (String)session.getAttribute("uavalidtokenno");
			
			String payments[][]=Enquiry_ACT.getInvoicedPayments(invoice,token);
			if(payments!=null&&payments.length>0){
				for(int i=0;i<payments.length;i++){
					String approveby=Clientmaster_ACT.getLoginUserName(payments[i][3]);
					json.put("prefid", payments[i][0]);
					json.put("date", payments[i][1]);
					json.put("approvedate", payments[i][2]);
					json.put("approveby", approveby);
					json.put("paymode", payments[i][4]);
					json.put("transactionid", payments[i][5]);
					json.put("transacamount", payments[i][6]);
					json.put("docname", payments[i][7]);
					json.put("transtatus", payments[i][8]);
					json.put("invoiceuuid", TaskMaster_ACT.getInvoiceUuid(payments[i][10],token));
					
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