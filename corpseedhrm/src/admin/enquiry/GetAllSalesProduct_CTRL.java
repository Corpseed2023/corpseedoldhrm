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
public class GetAllSalesProduct_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			
			String estimateno=request.getParameter("estimateno").trim();
//			System.out.println("pid="+pid);
			String token = (String)session.getAttribute("uavalidtokenno");
			
			String soldProduct[][]=Enquiry_ACT.getSoldProducts(estimateno, token);
			if(soldProduct!=null&&soldProduct.length>0){
				
				for(int i=0;i<soldProduct.length;i++){	
					double minPay=0;
					String name=soldProduct[i][1];
					json.put("refKey", soldProduct[i][0]);
					
					String paytype = Enquiry_ACT.getEstimateSalesPayType(soldProduct[i][0], token);
					
					if(soldProduct[i][2].equals("2")) {
						paytype="Full Pay";
						name="Consulting Service";
					}
					
					json.put("name", name);
					
					String notes="";		
					double amount=Enquiry_ACT.getEstimateSaleOrderAmount(soldProduct[i][0], token);
					String productkey=Enquiry_ACT.getSalesProductKey(soldProduct[i][0], token);
					
					if(paytype.equalsIgnoreCase("Full Pay")) {	
						minPay+=amount;
						notes="Full Pay :- Payment received on this order should be 100% to start the order. For "+name+" it should be Rs. <b>"+amount+"</b>";
					}else if(paytype.equalsIgnoreCase("Partial Pay")) {
						minPay+=(amount/2);
						notes="Partial Pay :- Payment received on this order should be 50% or equivalent to start the order. For "+name+" it should be Rs. <b>"+(amount/2)+"</b>";
					}else if(paytype.equalsIgnoreCase("Milestone Pay")) {
						double milestonePercent=Enquiry_ACT.getEstimateFirstMilestonePercent(soldProduct[i][0],productkey, token);
						minPay+=(amount*milestonePercent)/100;
						notes="Milestone Pay :- Payment received on this order should be "+milestonePercent+"% or equivalent to start the order. For "+name+" it should be greater or equal to Rs. <b>"+(amount*milestonePercent)/100+"</b>";
					}
					json.put("notes", notes);
					json.put("minPay", minPay);
//					System.out.println("minPay=="+minPay);
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