package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.master.Usermaster_ACT;

@SuppressWarnings("serial")
public class GetExpenseDetails_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out=response.getWriter();
		HttpSession session=request.getSession();
				
		String token = (String) session.getAttribute("uavalidtokenno");
		
		String expKey=request.getParameter("expKey").trim();
		String data="";		
		String expense[][]=TaskMaster_ACT.getExpenseData(expKey,token);
		if(expense!=null&&expense.length>0) {	
			String status="Approved";
			if(expense[0][11].equals("2"))status="Awating for action";
			if(expense[0][11].equals("3"))status="Declined";
			if(expense[0][11].equals("4"))status="On-Hold";
			String contactKey=TaskMaster_ACT.getSalesContactrefid(expense[0][18], token);
			String contact[]=TaskMaster_ACT.getContactDetails(contactKey,token);
			String cname="";
			String cmobile="";
			String cemail="";
			if(contact[0]!=null&&contact[0].length()>0&&!contact[0].equalsIgnoreCase("NA"))cname=contact[0];
			if(contact[1]!=null&&contact[1].length()>0&&!contact[1].equalsIgnoreCase("NA"))cemail=contact[1];
			if(contact[2]!=null&&contact[2].length()>0&&!contact[2].equalsIgnoreCase("NA"))cemail+=","+contact[2];
			if(contact[3]!=null&&contact[3].length()>0&&!contact[3].equalsIgnoreCase("NA"))cmobile=contact[3];
			if(contact[4]!=null&&contact[4].length()>0&&!contact[4].equalsIgnoreCase("NA"))cmobile+=","+contact[4];
		
			String services=TaskMaster_ACT.getSalesServices(expense[0][18], token);
			String uname=Usermaster_ACT.getLoginUserName(expense[0][15], token);
			
		data ="<div class=\"col-md-6\">\n"
				+ "    <div class=\"row mb-10\"><b>Client :</b> <span>"+expense[0][3]+"</span></div>\n"
				+ "    <div class=\"row mb-10\"><b>Contact Name :</b> <span>"+cname+"</span></div>\n"
				+ "    <div class=\"row mb-10\"><b>Contact :</b> <span>"+cmobile+"</span></div>\n"
				+ "    <div class=\"row mb-10\"><b>Email :</b> <span>"+cemail+"</span></div>\n"
				+ "    <div class=\"row mb-10\"><b>Department :</b> <span>"+expense[0][8]+"</span></div>\n"
				+ "    <div class=\"row mb-10\"><b>Account :</b> <span>"+expense[0][9]+"</span></div>\n"				
				+ "    </div>\n"
				+ "    <div class=\"col-md-6\">\n"
				+ "    <div class=\"row mb-10\"><b>Service Name :</b> <span>"+services.substring(0, services.length()-1)+"</span></div>\n"
				+ "    <div class=\"row mb-10\"><b>Added by :</b> <span>"+uname+"</span></div>\n"
				+ "    <div class=\"row mb-10\"><b>Expense Category :</b> <span>"+expense[0][6]+"</span></div>\n"
				+ "    <div class=\"row mb-10\"><b>Expense amount :</b> <span class=\"fas fa-inr\">&nbsp;"+expense[0][5]+"</span></div>\n"
				+ "    <div class=\"row mb-10\"><b>Added Date :</b> <span>"+expense[0][2]+"</span></div>\n"
				+ "    <div class=\"row mb-10\"><b>Status :</b> <span>"+status+"</span></div>    \n"
				+ "    </div> \n"
				+ "    <div class=\"row mb-10\">\n"
				+ "      <div class=\"col-md-12\"><b>Notes :</b> \n"
				+ "      <span>"+expense[0][10]+"</span></div>\n"
				+ "    </div>";		
		}
		
		out.write(data);
	}

}