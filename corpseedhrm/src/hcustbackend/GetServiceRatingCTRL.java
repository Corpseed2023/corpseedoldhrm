package hcustbackend;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


public class GetServiceRatingCTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();		
			
			HttpSession session = request.getSession(); 
			String token = (String)session.getAttribute("uavalidtokenno");
			
			
			String type=request.getParameter("type");
			if(type.equalsIgnoreCase("service")) {
				String salesKey=request.getParameter("salesKey");
				String serviceRating[][]=ClientACT.getServiceRating(salesKey,token);
				if(serviceRating!=null&&serviceRating.length>0) {					
						json.put("uuid", serviceRating[0][1]);
						json.put("rating", serviceRating[0][4]);
						json.put("comment", serviceRating[0][5]);						
						jsonArr.add(json);
					
					out.println(jsonArr);
				}				
			}else if(type.equalsIgnoreCase("executive")) {
				String serviceRatingKey=request.getParameter("serviceRatingKey");
				String uaid=request.getParameter("e_uaid");
				String serviceRating[][]=ClientACT.getExecutiveRating(serviceRatingKey,token,uaid);
				if(serviceRating!=null&&serviceRating.length>0) {					
						json.put("uuid", serviceRating[0][0]);
						json.put("rating", serviceRating[0][1]);		
						json.put("uaid", serviceRating[0][2]);		
						jsonArr.add(json);
					
					out.println(jsonArr);
				}
			}
		}catch (Exception e) {
				e.printStackTrace();
		}
	}

}
