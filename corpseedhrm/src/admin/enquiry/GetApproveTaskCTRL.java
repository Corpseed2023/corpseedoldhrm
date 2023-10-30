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
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@SuppressWarnings("serial")
public class GetApproveTaskCTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			
			String token = (String)session.getAttribute("uavalidtokenno");
			
			String task[][]=Enquiry_ACT.getApproveTask(token);
			if(task!=null&&task.length>0){
				for(int i=0;i<task.length;i++){
					json.put("key", task[i][0]);
					json.put("date", task[i][4]);
					json.put("teamAdminUid", TaskMaster_ACT.getTeamLeaderId(task[i][7], token));
					json.put("projectNo", TaskMaster_ACT.getinvoiceNoByKey(task[i][1],token));
					json.put("taskName", task[i][3]);
					json.put("assignedBy", Usermaster_ACT.getLoginUserName(task[i][5], token));
					json.put("assignedTo", Usermaster_ACT.getLoginUserName(task[i][6], token));
					json.put("approveStatus", task[i][8]);
					
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