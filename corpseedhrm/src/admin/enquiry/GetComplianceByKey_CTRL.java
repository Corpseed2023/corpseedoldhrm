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
public class GetComplianceByKey_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			
			String ckey=request.getParameter("ckey").trim();
//			System.out.println("pid="+pid);
			String token = (String)session.getAttribute("uavalidtokenno");
			
			String compliance[][]=Enquiry_ACT.getComplianceByKey(ckey,token);
			if(compliance!=null&&compliance.length>0){				
					json.put("uuid", compliance[0][1]);
					json.put("product_name", compliance[0][2]);
					json.put("service_name", compliance[0][3]);
					json.put("indended_use", compliance[0][4]);
					json.put("testing_fee", compliance[0][5]);
					json.put("government_fee", compliance[0][6]);
					
					jsonArr.add(json);
				out.println(jsonArr);
			}
		}

		catch (Exception e) {
				e.printStackTrace();
		}

	}
}