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
public class RecentProjectCTRL extends HttpServlet {

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
			
			String recentProjects[][]=TaskMaster_ACT.getAllRecentProjects(role,uaid,teamKey,"NA","NA",token);
			
            if(recentProjects!=null&&recentProjects.length>0){
				for(int i=0;i<recentProjects.length;i++){
					
					json.put("date",recentProjects[i][7]);
					json.put("projectNo",recentProjects[i][1]);
					json.put("projectName",recentProjects[i][5]);
					json.put("client",recentProjects[i][3]);
					json.put("progress",recentProjects[i][8]);
					json.put("status",recentProjects[i][9]);
					json.put("team",recentProjects[i][10]);
					
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