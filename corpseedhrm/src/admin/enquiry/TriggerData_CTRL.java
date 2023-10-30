package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import admin.task.TaskMaster_ACT;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class TriggerData_CTRL extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();
			
			String triggerKey=request.getParameter("triggerKey").trim();
			String type=request.getParameter("type").trim();
			if(type.equals("condition")) {
			String conditions[][]=TaskMaster_ACT.getTriggerConditions(triggerKey);
			if(conditions!=null&&conditions.length>0){
				for(int i=0;i<conditions.length;i++){
					
					json.put("id", conditions[i][0]);
					json.put("main", conditions[i][2]);
					json.put("sub", conditions[i][3]);
					json.put("child", conditions[i][4]);
					
					jsonArr.add(json);
					
				}
				out.println(jsonArr);
			}
			}else if(type.equals("action")){
				String actions[][]=TaskMaster_ACT.getAllActions(triggerKey);
				if(actions!=null&&actions.length>0){
					for(int i=0;i<actions.length;i++){
						
						json.put("main", actions[i][0]);
						json.put("apply", actions[i][1]);
						json.put("subject", actions[i][2]);
						json.put("body", actions[i][3]);
						json.put("id", actions[i][4]);
						
						jsonArr.add(json);
						
					}
					out.println(jsonArr);
				}
			}
		}

		catch (Exception e) {
				e.printStackTrace();
		}

	}
}