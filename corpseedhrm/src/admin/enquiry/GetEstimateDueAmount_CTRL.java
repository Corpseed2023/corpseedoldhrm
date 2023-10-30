package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.task.TaskMaster_ACT;
import commons.CommonHelper;

@SuppressWarnings("serial")
public class GetEstimateDueAmount_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			PrintWriter out=response.getWriter();
			String result="fail#";
			HttpSession session = request.getSession(); 
			
			String salesNo=request.getParameter("saleno").trim();
//			System.out.println("pid="+pid);
			String token = (String)session.getAttribute("uavalidtokenno");
			double discount=TaskMaster_ACT.getSalesDiscount(salesNo, token);
			double estimateprice[]=Enquiry_ACT.getEstimatePrice(salesNo,token);
			
			String dueAmt=Enquiry_ACT.getSalesDueAmount(salesNo, token);
			
			if(!dueAmt.equalsIgnoreCase("NA")){
				result=CommonHelper.withLargeIntegers(Double.parseDouble(dueAmt))+"#";
			}
			result+=CommonHelper.withLargeIntegers(Math.round(estimateprice[0]))+"#"+CommonHelper.withLargeIntegers(Math.round(estimateprice[1]))+"#"+CommonHelper.withLargeIntegers(Math.round((estimateprice[2]-discount)))+"#"+discount;
			out.write(result);
		}

		catch (Exception e) {
				e.printStackTrace();
		}

	}
}