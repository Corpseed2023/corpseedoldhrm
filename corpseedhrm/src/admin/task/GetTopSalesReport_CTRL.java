package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class GetTopSalesReport_CTRL extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			
			HttpSession session=request.getSession();
			PrintWriter out=response.getWriter();
			String token=(String)session.getAttribute("uavalidtokenno");
			String role=request.getParameter("role");	
			if(role!=null)role=role.trim();
			
			String uaid=request.getParameter("uaid");
			if(uaid!=null)uaid=uaid.trim();
			
			if(uaid==null||uaid.length()<=0||uaid.equalsIgnoreCase("NA"))uaid=(String)session.getAttribute("loginuaid");
			String teamKey=request.getParameter("teamKey");
			if(teamKey==null||teamKey.length()<=0)teamKey="NA";
			else teamKey=teamKey.trim();
		
			String topSales[][]=TaskMaster_ACT.getTopFiveSalesProduct(role,uaid,teamKey,token);
			if(topSales!=null&&topSales.length>0){
				for(int i=0;i<topSales.length;i++){
					json.put("name", topSales[i][0]);
					json.put("count", topSales[i][1]);					
					
					jsonArr.add(json);
				}
				out.println(jsonArr);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}

	}

}