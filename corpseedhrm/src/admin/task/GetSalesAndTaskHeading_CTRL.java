package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class GetSalesAndTaskHeading_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out=response.getWriter();
		HttpSession session=request.getSession();
				
		String token = (String) session.getAttribute("uavalidtokenno");
		
		String salesKey=request.getParameter("salesKey");
		if(salesKey!=null)salesKey=salesKey.trim();
		
		String taskKey=request.getParameter("taskKey");
		if(taskKey!=null)taskKey=taskKey.trim();
		
		String expKey=request.getParameter("expKey");
		if(expKey!=null)expKey=expKey.trim();
		
		String status=request.getParameter("status");
		if(status!=null)status=status.trim();
		
		String addedBy=request.getParameter("addedBy");
		if(addedBy!=null)addedBy=addedBy.trim();
		
		String postDate=request.getParameter("postDate");
		if(postDate!=null)postDate=postDate.trim();
		
		String pComment="";
		
		String expHead=TaskMaster_ACT.getExpenseApproveHead(salesKey,token);
		String milestone=TaskMaster_ACT.getAssignedMilestoneName(taskKey, token);
		String expNotes=TaskMaster_ACT.getExpenseNotes(expKey,token);
				
		String data ="<div class=\"sms_head note_box\">\r\n"
				+ "		<p contenteditable=\"false\">Milestone : "+milestone+" by "+addedBy+"<br><b>Comment : </b>"+expNotes+"</p> \r\n"
				+ "		</div>\r\n"
				+ "		<div class=\"sms_title\"> \r\n"
				+ "		<label class=\"pad-rt10\">New</label>  \r\n"
				+ "		<span class=\"gray_txt bdr_bt pad-rt10\" style=\"float: right;\">"+postDate+"</span>\r\n"
				+ "		</div>";
		
		if(status.equals("4")) {
			String comment[]=TaskMaster_ACT.getExpenseComment(expKey,token);
//			System.out.println(expKey);
			pComment="<div class=\"sms_head note_box\">\r\n"
					+ "		<p contenteditable=\"false\">Milestone : "+milestone+" by "+comment[2]+"<br><b>Comment : </b>"+comment[1]+"</p> \r\n"
					+ "		</div>\r\n"
					+ "		<div class=\"sms_title\"> \r\n"
					+ "		<label class=\"pad-rt10\">"+comment[0]+"</label>  \r\n"
					+ "		<span class=\"gray_txt bdr_bt pad-rt10\" style=\"float: right;\">"+comment[3]+"</span>\r\n"
					+ "		</div>";
		}
		
		out.write(expHead+"#"+data+"#"+pComment);
	}

}