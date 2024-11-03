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
public class GetPaymentDetails_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			
			String invoiceno=request.getParameter("invoiceno").trim();
//			System.out.println("pid="+pid);
			String token = (String)session.getAttribute("uavalidtokenno");
			String billingDoAction=(String)session.getAttribute("billingDoAction");
			if(billingDoAction==null||billingDoAction.length()<=0)billingDoAction="All";
			
			String payment[][]=null;
			if(!billingDoAction.equalsIgnoreCase("Hold"))
				payment=Enquiry_ACT.getSalesPayment(invoiceno,token,"2");
			else
				payment=Enquiry_ACT.getSalesPayment(invoiceno,token,"4");
			
			if(payment!=null&&payment.length>0){
				for(int i=0;i<payment.length;i++){
					json.put("refid", payment[i][0]);
					json.put("date", payment[i][1]);
					json.put("mode", payment[i][2]);
					json.put("transactionid", payment[i][3]);
					json.put("amount", payment[i][4]);
					json.put("docname", payment[i][5]);
					json.put("docpath", payment[i][6]);
					json.put("remarks", payment[i][7]);
					json.put("addedby", payment[i][8]);
					json.put("service", payment[i][9]);
					json.put("holdremarks", payment[i][10]);
					json.put("povalidity", payment[i][11]);
					String financialYear="NA";
					if(payment[i][12]!=null && payment[i][13]!=null) {
						financialYear = payment[i][12].concat("-").concat(payment[i][13].substring(2));
					}
					json.put("financialYear", financialYear);
					json.put("portalNumber", payment[i][14]);
					json.put("piboCategory", payment[i][15]);
					json.put("creditType", payment[i][16]);
					json.put("productCategory", payment[i][17]);
					json.put("quantity", payment[i][18]);
					json.put("comment", payment[i][19]);
					
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