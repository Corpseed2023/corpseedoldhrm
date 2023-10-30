package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

@SuppressWarnings("serial")
public class AddNewCompliance_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			
			String productName=request.getParameter("productName").trim();
			String serviceName=request.getParameter("serviceName").trim();
			String intendedUse=request.getParameter("intendedUse").trim();
			String testingFee=request.getParameter("testingFee").trim();
			String governmentFee=request.getParameter("governmentFee").trim();
			String ckey=request.getParameter("ckey");
			if(ckey==null||ckey=="")ckey="NA";
			
//			System.out.println("ckey="+ckey);
			String token = (String)session.getAttribute("uavalidtokenno");
			String uaid = (String)session.getAttribute("loginuaid");
						
			boolean flag=false;
			
			if(ckey.equalsIgnoreCase("NA")) {			
				String key =RandomStringUtils.random(40, true, true);
				flag=Enquiry_ACT.saveCompliance(key,productName,serviceName,intendedUse,testingFee,governmentFee,token,uaid);
			}else {
				flag=Enquiry_ACT.updateCompliance(ckey,productName,serviceName,intendedUse,testingFee,governmentFee,token,uaid);
			}
			if(flag){
				out.write("pass");
			}else{
				out.write("fail");
			}
		}

		catch (Exception e) {
				e.printStackTrace();
		}

	}
}