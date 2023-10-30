package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import commons.CommonHelper;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@SuppressWarnings("serial")
public class GetManageInvoice_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			
			String refkey=request.getParameter("refkey").trim();

			String token = (String)session.getAttribute("uavalidtokenno");
						
			String invoice[][]=Enquiry_ACT.getManageInvoice(refkey,token);
			if(invoice!=null&&invoice.length>0){
					json.put("type", invoice[0][0]);
					json.put("invoice", invoice[0][1]);
					json.put("bill_to", invoice[0][2]);
					json.put("gstin", invoice[0][3]);
					json.put("ship_to", invoice[0][4]);
					json.put("place_supply", invoice[0][5]);
					json.put("invoice_no", invoice[0][6]);
					
					
					StringBuffer data=new StringBuffer();
					
					String[][] sales=Enquiry_ACT.getAllSales(invoice[0][1], token);
					double totalAmount=0;
					if(sales!=null&&sales.length>0) {
						for(int i=0;i<sales.length;i++) {
							data.append("<tr><th>"+(i+1)+".</th><th colspan=\"6\">"+sales[i][1]+"</th></tr>");
							String[][] payment=Enquiry_ACT.fetchAllSalesPrice(sales[i][0], token);
							if(payment!=null&&payment.length>0)
								for(int j=0;j<payment.length;j++) {
									data.append("<tr><td></td><td>"+payment[j][0]+"</td><td>"+payment[j][1]+"</td>"
											+ "<td>"+CommonHelper.withLargeIntegers(Double.parseDouble(payment[j][2]))+"</td>"
													+ "<td>"+payment[j][3]+"%</td><td>"+CommonHelper.withLargeIntegers(Double.parseDouble(payment[j][4]))+"</td>"
															+ "<td>"+CommonHelper.withLargeIntegers(Double.parseDouble(payment[j][5]))+"</td></tr>");
									totalAmount+=Double.parseDouble(payment[j][5]);
								}					
						}
						double dueAmount=Enquiry_ACT.findSalesDueAmount(invoice[0][1], token);
						data.append("<tr class=\"text-right\"><td colspan=\"5\"><b style='color: #b72323;'>Due Amount : "+CommonHelper.withLargeIntegers(dueAmount)+"</b></td><td colspan=\"2\"><b>Total : "+CommonHelper.withLargeIntegers(totalAmount)+"</b></td></tr>");
					}
					
					json.put("data", data.toString());					
					
					jsonArr.add(json);
				
				out.println(jsonArr);
			}
		}

		catch (Exception e) {
				e.printStackTrace();
		}

	}
}