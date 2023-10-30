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
public class GetEstimateSummary_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			
			String salesNo=request.getParameter("salesNo").trim();
			int pageNo=Integer.parseInt(request.getParameter("pageNo").trim());
			
			String token = (String)session.getAttribute("uavalidtokenno");
			
			String summary[][]=Enquiry_ACT.getEstimateSalesSummary(salesNo,pageNo,token);
						
			if(summary!=null&&summary.length>0){
				for(int i=0;i<summary.length;i++){
						json.put("date", summary[i][0]);
						json.put("remarks", summary[i][1]);
						
						jsonArr.add(json);
				}
				out.println(jsonArr);
			}
			
		}catch (Exception e) {
				e.printStackTrace();
		}

	}
}