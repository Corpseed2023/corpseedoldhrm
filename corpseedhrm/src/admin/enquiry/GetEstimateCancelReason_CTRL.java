package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class GetEstimateCancelReason_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			
			String type=request.getParameter("type").trim();
			
			String invoice=request.getParameter("invoice").trim();
			
			String token = (String)session.getAttribute("uavalidtokenno");			
			
			String data="";
			String heading=invoice+" : ";
			
			if(type.equalsIgnoreCase("estimate")) {
				heading+=Enquiry_ACT.getEstimateInvoiceHeading(invoice,token);
				String[][] estimateCancel=Enquiry_ACT.fetchAllCancelReport(invoice,type,token);
				if(estimateCancel!=null&&estimateCancel.length>0) {
					for(int i=0;i<estimateCancel.length;i++) {
						String classd="bg-danger";
						if(estimateCancel[i][7].equals("Draft"))classd="bg-primary";
						data+="<div class=\"box\">\n"
								+ "		<p>"+estimateCancel[i][4]+"</p>\n"
								+ "		<div class=\"box-patch\">\n"
								+ "		    <span class=\""+classd+"\">"+estimateCancel[i][7]+"</span>\n"
								+ "		    <span class=\"bg-info\">"+estimateCancel[i][5]+"</span></div>\n"
								+ "	    </div>";
					}
				}
			}else if(type.equalsIgnoreCase("sales")) {
				heading+=Enquiry_ACT.getSalesInvoiceHeading(invoice,token);
				String[][] salesCancel=Enquiry_ACT.fetchAllCancelReport(invoice,type,token);
				if(salesCancel!=null&&salesCancel.length>0) {
					for(int i=0;i<salesCancel.length;i++) {
						String classd="bg-danger";
						if(salesCancel[i][7].equals("Draft"))classd="bg-primary";
						data+="<div class=\"box\">\n"
								+ "		<p>"+salesCancel[i][4]+"</p>\n"
								+ "		<div class=\"box-patch\">\n"
								+ "		    <span class=\""+classd+"\">"+salesCancel[i][7]+"</span>\n"
								+ "		    <span class=\"bg-info\">"+salesCancel[i][5]+"</span></div>\n"
								+ "	    </div>";
					}
				}
			}
			out.write(heading+"#"+data);			
			
		}catch (Exception e) {
				e.printStackTrace();
		}

	}
}