package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import admin.Login.LoginAction;

@SuppressWarnings("serial")
public class updateTransactionStatusCTRL extends HttpServlet {
	private static Logger log = Logger.getLogger(LoginAction.class);

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		HttpSession session = request.getSession();
		PrintWriter pw=response.getWriter();
try{		
		String token = (String) session.getAttribute("uavalidtokenno");	
		String value=request.getParameter("value").trim();
		String refid=request.getParameter("refid").trim();
		if(value==null||value=="")value="NA";
		boolean status=Enquiry_ACT.updatePayments(refid,value,token);
		if(status){
			pw.write("pass");
		}else{
			pw.write("fail");
		}
}catch(Exception e){
	log.info("Error in NewFile_CTRL \n"+e);
}
	
	}

}
