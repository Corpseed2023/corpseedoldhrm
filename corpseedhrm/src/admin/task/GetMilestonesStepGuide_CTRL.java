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


@SuppressWarnings("serial")
public class GetMilestonesStepGuide_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		JSONArray jsonArr = new JSONArray();
		JSONObject json=new JSONObject();
		PrintWriter out=response.getWriter();	   
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		try{	
			String milestoneId=request.getParameter("milestoneId").trim();
			String jurisdiction=request.getParameter("jurisdiction");
			if(jurisdiction!=null)jurisdiction=jurisdiction.trim();
			
			String[][] milestones=TaskMaster_ACT.getMilestonesStepGuide(milestoneId,uavalidtokenno,jurisdiction);
			
		if(milestones!=null&&milestones.length>0){
			for(int i=0;i<milestones.length;i++){
				json.put("key", milestones[i][0]);
				json.put("prodkey", milestones[i][1]);
				json.put("milestonename", milestones[i][2]);
				json.put("stepno", milestones[i][3]);
				json.put("contents", milestones[i][4]);
				json.put("document", milestones[i][5]);
				
				jsonArr.add(json);
			}
			out.print(jsonArr);
		}
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}

}