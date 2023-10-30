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
public class GetEstimateDocument_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();		
			
			HttpSession session = request.getSession(); 
			
			String estKey=request.getParameter("estKey").trim();

			String token = (String)session.getAttribute("uavalidtokenno");
			String document[][]=Enquiry_ACT.getEstimateDocument(estKey,token);
				if(document!=null&&document.length>0){
					for(int j=0;j<document.length;j++){
						json.put("key", document[j][0]);	
						json.put("uploaddocname", document[j][1]);
						json.put("docname", document[j][2]);
						json.put("date", document[j][3]);
						
						jsonArr.add(json);
					}
					out.println(jsonArr);
				}
				}		

		catch (Exception e) {
				e.printStackTrace();
		}

	}
}