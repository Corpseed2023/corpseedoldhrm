package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.master.Usermaster_ACT;
import admin.task.TaskMaster_ACT;
import commons.DateUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@SuppressWarnings("serial")
public class GetUpcomingDeadlineCTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

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
			
			String todayRev=DateUtil.getCurrentDateIndianReverseFormat();
            String upcomingTask[][]=TaskMaster_ACT.get5UpcomingTask(role,uaid,teamKey,token,todayRev);
			
            if(upcomingTask!=null&&upcomingTask.length>0){
				for(int i=0;i<upcomingTask.length;i++){
				  String userName="Unassigned";
         		   if(!upcomingTask[i][1].equalsIgnoreCase("NA")){
         			   userName=Usermaster_ACT.getLoginUserName(upcomingTask[i][1], token);
         		   }
					json.put("name",upcomingTask[i][0]);
					json.put("user", userName);
					json.put("deliveryDate", upcomingTask[i][2]);
					
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