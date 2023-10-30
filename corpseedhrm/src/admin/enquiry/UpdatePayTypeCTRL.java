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

public class UpdatePayTypeCTRL extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = -6916845011953035425L;
	private static Logger log = Logger.getLogger(LoginAction.class);

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		HttpSession session = request.getSession();
		PrintWriter pw=response.getWriter();
try{		
		String token = (String) session.getAttribute("uavalidtokenno");	
		String salesKey=request.getParameter("salesKey").trim();
		String payType=request.getParameter("payType").trim();	
//		System.out.println("salesKey="+salesKey);
		boolean status=false;
		boolean status1=Enquiry_ACT.isEstimateInvoiced(salesKey,token);
			if(!status1)	
				status=Enquiry_ACT.updatePayTypeStatus(salesKey,payType,token);
		if(status){
			pw.write("pass");
		}else{
			pw.write("fail");
		}
}catch(Exception e){
	log.info("Error in UpdatePayTypeCTRL \n"+e);
}
	
	}

}
