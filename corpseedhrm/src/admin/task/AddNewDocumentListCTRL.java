package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.enquiry.Enquiry_ACT;
import admin.master.Usermaster_ACT;
import commons.DateUtil;


@SuppressWarnings("serial")
public class AddNewDocumentListCTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 PrintWriter pw=response.getWriter();
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String loginuaid = (String) session.getAttribute("loginuaid");	
		String loginuID = (String) session.getAttribute("loginuID");		
		String today=DateUtil.getCurrentDateIndianFormat1();
		
			String key = request.getParameter("key").trim();
			String salesrefid = request.getParameter("salesrefid").trim();
			String docname = request.getParameter("docname").trim();
			String UploadBy = request.getParameter("UploadBy").trim();
			String Remarks = request.getParameter("Remarks").trim();
			String estKey="";
			
			if(salesrefid.equalsIgnoreCase("NA")) {
				estKey=request.getParameter("estKey").trim();
				salesrefid=Enquiry_ACT.getSalesKeyByEstimateKey(estKey,uavalidtokenno);				
			}
			else
				estKey=TaskMaster_ACT.getEstimateKey(salesrefid,uavalidtokenno);
		
			boolean flag=TaskMaster_ACT.addDocumentList(key,salesrefid,docname,UploadBy,Remarks,loginuID,uavalidtokenno,estKey);		
			
			if(flag) {
				//inserting upload action in document action history
				String userName=Usermaster_ACT.getLoginUserName(loginuaid, uavalidtokenno);
				TaskMaster_ACT.saveDocumentActionHistory(docname,salesrefid,"Create",loginuaid,userName,uavalidtokenno,key,today,"NA",estKey);
				
				pw.write("pass");
			}
			else pw.write("fail");
	}

}