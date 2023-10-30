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
public class GetUnbillPaymentPriceList_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();		
			
			HttpSession session = request.getSession(); 
			
			String refid=request.getParameter("refid").trim();
//System.out.println("refid=="+refid);
			String token = (String)session.getAttribute("uavalidtokenno");
			String paymentDetails[][]=Enquiry_ACT.getPaymentList(refid,token);
					
				if(paymentDetails!=null&&paymentDetails.length>0){
					for(int j=0;j<paymentDetails.length;j++){
						json.put("type", paymentDetails[j][3]);
						json.put("amount",paymentDetails[j][4]);
						json.put("cgst", paymentDetails[j][5]);
						json.put("sgst", paymentDetails[j][6]);						
						json.put("igst", paymentDetails[j][7]);					
						
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