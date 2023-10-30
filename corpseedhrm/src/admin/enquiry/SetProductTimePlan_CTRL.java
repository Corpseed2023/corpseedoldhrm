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
public class SetProductTimePlan_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			
			String pricerefid=request.getParameter("pricerefid").trim();
			String x[]=pricerefid.split("#");

			String token = (String)session.getAttribute("uavalidtokenno");
			
			String productplan[][]=Enquiry_ACT.getSalesProductTimePlan(x[0],token);
						
			if(productplan!=null&&productplan.length>0){
					
						json.put("qty", productplan[0][0]);
						json.put("plan", productplan[0][1]);
						json.put("period", productplan[0][2]);
						json.put("time", productplan[0][3]);
						json.put("jurisdiction", productplan[0][4]);
						
						jsonArr.add(json);
				
				out.println(jsonArr);
			}
			
		}catch (Exception e) {
				e.printStackTrace();
		}

	}
}