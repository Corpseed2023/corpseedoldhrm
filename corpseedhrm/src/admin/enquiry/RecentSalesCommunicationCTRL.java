package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.task.TaskMaster_ACT;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@SuppressWarnings("serial")
public class RecentSalesCommunicationCTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			
			String token = (String)session.getAttribute("uavalidtokenno");
			String role=request.getParameter("role");			
			String uaid=request.getParameter("uaid");
			if(uaid==null||uaid.length()<=0||uaid.equalsIgnoreCase("NA"))uaid=(String)session.getAttribute("loginuaid");
			String teamKey=request.getParameter("teamKey");
			if(teamKey==null||teamKey.length()<=0)teamKey="NA";
			
			String projectsCommunication[][]=TaskMaster_ACT.getAllRecentProjectsCommunication(role,uaid,teamKey,"NA","NA",token);
			
            if(projectsCommunication!=null&&projectsCommunication.length>0){
				for(int i=0;i<projectsCommunication.length;i++){
				  
					json.put("key",projectsCommunication[i][0]);
					json.put("name",projectsCommunication[i][1]);
					json.put("projectNo",projectsCommunication[i][2]);
					
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