package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class GetOrderAndDueAmountCTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {			
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			
			String estimateno=request.getParameter("estimateno").trim();
//			System.out.println("pid="+pid);
			String token = (String)session.getAttribute("uavalidtokenno");
			String saleType=Enquiry_ACT.findSalesType(estimateno, token);
			double discount=Enquiry_ACT.getEstimateDiscount(estimateno, token);
			double orderAmt=Enquiry_ACT.getOrderAmount(estimateno,token);
			double paidAmt=Enquiry_ACT.getPaidAmount(estimateno,token);
			
//			double[] professionalFees=Enquiry_ACT.getFees(estimateno,token,"Professional fees");
//			double[] governmentFees=Enquiry_ACT.getFees(estimateno,token,"Government fees");
//			double[] otherFees=Enquiry_ACT.getFees(estimateno,token,"Other fees");
			
			String pFeeType="Professional fees";
			if(saleType.equals("2")) {
				pFeeType=Enquiry_ACT.findConsultationFeeType(estimateno,token);
			}
			
			int[] professionalTax=Enquiry_ACT.getMaxTax(estimateno,token,pFeeType);
			int[] governmentTax=Enquiry_ACT.getMaxTax(estimateno,token,"Government fees");
			int[] otherTax=Enquiry_ACT.getMaxTax(estimateno,token,"Other fees");
			int[] serviceTax=Enquiry_ACT.getMaxTax(estimateno,token,"Service charges");
			
			orderAmt-=discount;
			double due=orderAmt-paidAmt;
		out.write(orderAmt+"#"+due+"#"+professionalTax[0]+"#"+professionalTax[1]+"#"+professionalTax[2]
				+"#"+governmentTax[0]+"#"+governmentTax[1]+"#"+governmentTax[2]+"#"+otherTax[0]+"#"
				+otherTax[1]+"#"+otherTax[2]+"#"+serviceTax[0]+"#"+serviceTax[1]+"#"+serviceTax[2]);
		}

		catch (Exception e) {
				e.printStackTrace();
		}

	}
}