package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.task.TaskMaster_ACT;

@SuppressWarnings("serial")
public class GetMinSalePay_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

			try {
				
				PrintWriter out=response.getWriter();
							
				HttpSession session = request.getSession(); 
				
				String estpaymentKey=request.getParameter("refid");
				String payAmount=request.getParameter("amount");
				
//				System.out.println("pid="+pid);
				String token = (String)session.getAttribute("uavalidtokenno");
				String estimateno=Enquiry_ACT.getEstimateNoFromPayment(estpaymentKey,token);
				String soldProduct[][]=Enquiry_ACT.getSoldProducts(estimateno, token);
				if(soldProduct!=null&&soldProduct.length>0){
					double minPay=0;	
					for(int i=0;i<soldProduct.length;i++){											
						String paytype ="NA";
						double amount=Enquiry_ACT.getEstimateSaleOrderAmount(soldProduct[i][0], token);
						String productkey=Enquiry_ACT.getSalesProductKey(soldProduct[i][0], token);
						
						if(soldProduct[i][2].equals("1"))
							paytype = Enquiry_ACT.getEstimateSalesPayType(soldProduct[i][0], token);
						else paytype="Full Pay";
						
						if(paytype.equalsIgnoreCase("Full Pay")) {	
							minPay+=amount;
						}else if(paytype.equalsIgnoreCase("Partial Pay")) {
							minPay+=(amount/2);
						}else if(paytype.equalsIgnoreCase("Milestone Pay")) {
							double milestonePercent=Enquiry_ACT.getEstimateFirstMilestonePercent(soldProduct[i][0],productkey, token);
							minPay+=(amount*milestonePercent)/100;
						}	
					}
					
					double totalPaid=TaskMaster_ACT.getPaidAmount(estimateno, token);
					totalPaid+=Double.parseDouble(payAmount);
					if(totalPaid>=minPay)minPay=0;
					
					out.write(minPay+"");
				}
			}

			catch (Exception e) {
					e.printStackTrace();
			}

	}
}