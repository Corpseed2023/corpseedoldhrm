package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class GetPaymentInstructions_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out=response.getWriter();
		HttpSession session=request.getSession();
				
		String token = (String) session.getAttribute("uavalidtokenno");
		
		String salesinvoice=request.getParameter("salesinvoice").trim();
		
		String payment[][]=TaskMaster_ACT.getPaymentComments(salesinvoice,token);
		String data="";
		if(payment!=null&&payment.length>0) {
			for(int i=0;i<payment.length;i++) {
				data+="<div class=\"box_shadow1 relative_box mb10\"><div class=\"sms_head note_box\">\r\n"
					+ "		<p contenteditable=\"false\">Service : "+payment[i][1]+" by "+payment[i][3]+"<br><b>Comment : </b>"+payment[i][2]+"</p> \r\n"
					+ "		</div>\r\n"
					+ "		<div class=\"sms_title\"> \r\n"
					+ "		<label class=\"pad-rt10\"></label>  \r\n"
					+ "		<span class=\"gray_txt bdr_bt pad-rt10\" style=\"float: right;\">"+payment[i][0]+"</span>\r\n"
					+ "		</div></div>";
		}}
		
		out.write(data);
	}

}