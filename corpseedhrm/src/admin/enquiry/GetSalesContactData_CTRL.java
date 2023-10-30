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
public class GetSalesContactData_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();		
			
			HttpSession session = request.getSession(); 
			
			String contactKey=request.getParameter("contactKey").trim();

			String token = (String)session.getAttribute("uavalidtokenno");
			String client[]=Enquiry_ACT.getContactDetail(contactKey,token);
				if(client[0]!=null&&client[0].length()>0){		
						
						json.put("name", client[0]);
						json.put("address", client[1]);
						json.put("state", client[2]);
						json.put("statecode", client[3]);						
						
						jsonArr.add(json);
					
					out.println(jsonArr);
				}
				}		

		catch (Exception e) {
				e.printStackTrace();
		}

	}
}