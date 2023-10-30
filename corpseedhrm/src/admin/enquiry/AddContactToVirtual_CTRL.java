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
public class AddContactToVirtual_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {

			boolean status = false;
			
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			
			String contactid=request.getParameter("contactid").trim();
			String name=request.getParameter("name").trim();
			String email=request.getParameter("email").trim();
			String mobile=request.getParameter("mobile").trim();
			String salesid=request.getParameter("salesid").trim();
			String ckey=request.getParameter("key").trim();
			
			String key =RandomStringUtils.random(40, true, true);
//			System.out.println("ckey="+ckey);
			String token = (String)session.getAttribute("uavalidtokenno");
			String addedby = (String)session.getAttribute("loginuID");
			if(ckey!=null&&ckey.length()>0) {
				status=Enquiry_ACT.isContactExist(mobile,salesid,token,addedby,email);
				if(!status){
					//adding new contact
					status=Enquiry_ACT.addSalesContactToVirtual(key,contactid,name,email,mobile,mobile,salesid,token,addedby,ckey);
	//				System.out.println("add executed....");
				}else{
					//updating added contact details
					status=Enquiry_ACT.updateSalesContactToVirtual(contactid,name,email,mobile,mobile,salesid,token,addedby);
	//				System.out.println("updating contact....");
				}
			}
			if(status){
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