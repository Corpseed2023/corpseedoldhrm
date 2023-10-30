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


public class GetServiceRatingAboutCTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();		
			
			HttpSession session = request.getSession(); 
			String token = (String)session.getAttribute("uavalidtokenno");
			
			String serviceRatingKey=request.getParameter("serviceRatingKey");
			if(serviceRatingKey!=null)serviceRatingKey=serviceRatingKey.trim();
			
			String type=request.getParameter("type");
			if(type!=null)type=type.trim();
			
			String uaid=request.getParameter("uaid");
			if(uaid!=null)uaid=uaid.trim();
			
				String ratingAbout[][]=ClientACT.getServiceRatingAbout(type,serviceRatingKey,token,uaid);
				if(ratingAbout!=null&&ratingAbout.length>0) {	
					for(int i=0;i<ratingAbout.length;i++) {
						json.put("value", ratingAbout[i][0]);										
						jsonArr.add(json);
					}
					out.println(jsonArr);
				}				
			
		}catch (Exception e) {
				e.printStackTrace();
		}
	}

}
