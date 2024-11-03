package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import admin.master.CloudService;
import commons.CommonHelper;

public class DeleteSalesHistoryDocument_CTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 9185283983751521231L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			PrintWriter pw=response.getWriter();
			
			String docId=request.getParameter("docId").trim();
			String docName=request.getParameter("docName").trim();
			
			boolean flag=Enquiry_ACT.deleteSalesDocumentHistory(docId);
			
			if(flag){
				boolean isDeleted = CloudService.deleteFileIfExist(docName);	
				if(isDeleted) {
					pw.write("pass");
				}else {
					pw.write("fail");
				}
				
			}else{pw.write("fail");}
		}
		catch (Exception e) {

		}

	}
}