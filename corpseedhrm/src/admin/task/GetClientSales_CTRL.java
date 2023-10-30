package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.master.Usermaster_ACT;
import client_master.Clientmaster_ACT;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


@SuppressWarnings("serial")
public class GetClientSales_CTRL extends HttpServlet {	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		JSONArray jsonArr = new JSONArray();
		JSONObject json=new JSONObject();
		PrintWriter out=response.getWriter();	   
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		
		try{	
			String type = request.getParameter("type").trim();
			String name = request.getParameter("name").trim();
			String id = request.getParameter("id").trim();
			String superUserId=Usermaster_ACT.fetchSuperUserByUserId(id,uavalidtokenno);
			if(!superUserId.equalsIgnoreCase("NA")) {		
		
			if(type.equalsIgnoreCase("sales")) {			
				String sales[][]=TaskMaster_ACT.fetchSalesByName(superUserId,name,uavalidtokenno); 
				if(sales!=null&&sales.length>0){
					for(int i=0;i<sales.length;i++){
						json.put("id", sales[i][0]);
						json.put("name", sales[i][1]);
						
						jsonArr.add(json);
					}
					out.print(jsonArr);
				}
			}else if(type.equalsIgnoreCase("company")) {
				String company[][]=Clientmaster_ACT.fetchAllClientsBySuperUser(superUserId, uavalidtokenno);
				if(company!=null&&company.length>0){
					for(int i=0;i<company.length;i++){
						json.put("id", company[i][1]);
						json.put("name", company[i][0]);
						
						jsonArr.add(json);
					}
					out.print(jsonArr);
				}				
			}			
		}
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}

}