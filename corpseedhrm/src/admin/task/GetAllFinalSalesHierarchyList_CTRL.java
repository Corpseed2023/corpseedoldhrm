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

public class GetAllFinalSalesHierarchyList_CTRL extends HttpServlet {	
	
	private static final long serialVersionUID = 3127610225461843376L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		JSONArray jsonArr = new JSONArray();
		JSONObject json=new JSONObject();
		PrintWriter out=response.getWriter();	   
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		try{		
		String salesinvoice = request.getParameter("salesinvoice").trim();
		
		String hierarchylist[][]=TaskMaster_ACT.getAllFinalSalesHierarchyList(salesinvoice, uavalidtokenno);
		if(hierarchylist!=null&&hierarchylist.length>0){
			for(int i=0;i<hierarchylist.length;i++){
				String prodname=TaskMaster_ACT.getSalesProductName(hierarchylist[i][1],uavalidtokenno);
				json.put("hrefid", hierarchylist[i][0]);
				json.put("salesrefid", hierarchylist[i][1]);		
				json.put("htype", hierarchylist[i][2]);
				json.put("holdstatus", hierarchylist[i][3]);	
				json.put("hdate", hierarchylist[i][4]);
				json.put("prodname", prodname);
				
				jsonArr.add(json);
			}
			out.print(jsonArr);
		}
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}

}