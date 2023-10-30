package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@SuppressWarnings("serial")
public class GetSalesContactDetails_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();		
			
			HttpSession session = request.getSession(); 
			
			String contactKey=request.getParameter("contactKey").trim();

			String token = (String)session.getAttribute("uavalidtokenno");
			String contact[][]=Enquiry_ACT.getSalesContactByKey(contactKey,token);
					
				if(contact!=null&&contact.length>1){
					for(int j=1;j<contact.length;j++){
						json.put("email", contact[j][0]);
						jsonArr.add(json);
					}
					out.println(jsonArr);
				}
		}catch (Exception e) {
				e.printStackTrace();
		}

	}
}