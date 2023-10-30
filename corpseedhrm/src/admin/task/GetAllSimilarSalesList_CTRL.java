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

public class GetAllSimilarSalesList_CTRL extends HttpServlet {	
	
	private static final long serialVersionUID = 3127610225461843376L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		JSONArray jsonArr = new JSONArray();
		JSONObject json=new JSONObject();
		PrintWriter out=response.getWriter();	   
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		try{		
		String salesinvoice = request.getParameter("salesinvoice").trim();
		
		String Sales[][]=TaskMaster_ACT.getAllSalesList(salesinvoice, uavalidtokenno);
		if(Sales!=null&&Sales.length>0){
			for(int i=0;i<Sales.length;i++){
				json.put("refid", Sales[i][0]);
				json.put("name", Sales[i][1]);		
				
				jsonArr.add(json);
			}
			out.print(jsonArr);
		}
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}

}