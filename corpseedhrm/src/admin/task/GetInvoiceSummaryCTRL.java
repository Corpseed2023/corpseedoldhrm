package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.enquiry.Enquiry_ACT;
import commons.CommonHelper;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class GetInvoiceSummaryCTRL extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			
			PrintWriter pw=response.getWriter();
			HttpSession session =request.getSession();
			String token = (String)session.getAttribute("uavalidtokenno");
			String invoice=request.getParameter("invoice").trim();
						
//			System.out.println("selected id==="+selectedId);
			
			StringBuffer data=new StringBuffer();
			
			String[][] sales=Enquiry_ACT.getAllSales(invoice, token);
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
				double dueAmount=Enquiry_ACT.findSalesDueAmount(invoice, token);
				data.append("<tr class=\"text-right\"><td colspan=\"5\"><b style='color: #b72323;'>Due Amount : "+CommonHelper.withLargeIntegers(dueAmount)+"</b></td><td colspan=\"2\"><b>Total : "+CommonHelper.withLargeIntegers(totalAmount)+"</b></td></tr>");
			}
			
			pw.write(data.toString());
			
		}catch (Exception e) {
			e.printStackTrace();
		}

	}

}