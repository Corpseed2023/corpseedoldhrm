package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class GetExpenseHistory_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out=response.getWriter();
		HttpSession session=request.getSession();
				
		String token = (String) session.getAttribute("uavalidtokenno");
		
		String salesKey=request.getParameter("salesKey").trim();
		String taskKey=request.getParameter("taskKey").trim();
		String expKey=request.getParameter("expKey").trim();
		String addedBy=request.getParameter("addedBy").trim();
		String postDate=request.getParameter("postDate").trim();
				
		String expHead=TaskMaster_ACT.getExpenseApproveHead(salesKey,token);
		String milestone=TaskMaster_ACT.getAssignedMilestoneName(taskKey, token);
		String expNotes=TaskMaster_ACT.getExpenseNotes(expKey,token);
						
		String data ="<div class=\"box_shadow1 relative_box mb10\"><div class=\"sms_head note_box\">\r\n"
				+ "		<p contenteditable=\"false\">Milestone : "+milestone+" by "+addedBy+"<br><b>Comment : </b>"+expNotes+"</p> \r\n"
				+ "		</div>\r\n"
				+ "		<div class=\"sms_title\"> \r\n"
				+ "		<label class=\"pad-rt10\">New</label>  \r\n"
				+ "		<span class=\"gray_txt bdr_bt pad-rt10\" style=\"float: right;\">"+postDate+"</span>\r\n"
				+ "		</div></div>";		
		
		String comment[][]=TaskMaster_ACT.getExpenseComments(expKey,token);
		
		if(comment!=null&&comment.length>0) {
			for(int i=0;i<comment.length;i++) {
				data+="<div class=\"box_shadow1 relative_box mb10\"><div class=\"sms_head note_box\">\r\n"
					+ "		<p contenteditable=\"false\">Milestone : "+milestone+" by "+comment[i][2]+"<br><b>Comment : </b>"+comment[i][1]+"</p> \r\n"
					+ "		</div>\r\n"
					+ "		<div class=\"sms_title\"> \r\n"
					+ "		<label class=\"pad-rt10\">"+comment[i][0]+"</label>  \r\n"
					+ "		<span class=\"gray_txt bdr_bt pad-rt10\" style=\"float: right;\">"+comment[i][3]+"</span>\r\n"
					+ "		</div></div>";
		}}
		
		out.write(expHead+"#"+data);
	}

}