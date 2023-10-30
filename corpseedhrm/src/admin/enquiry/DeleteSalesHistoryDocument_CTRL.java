package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
				Properties properties = new Properties();
				properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
				String azure_key=properties.getProperty("azure_key");
				String azure_container=properties.getProperty("azure_container");
				if(CommonHelper.isFileExists(docName, azure_key, azure_container)) {
					CommonHelper.deleteAzureFile(docName,azure_key, azure_container);
				}
				
				
				pw.write("pass");
			}else{pw.write("fail");}
		}
		catch (Exception e) {

		}

	}
}