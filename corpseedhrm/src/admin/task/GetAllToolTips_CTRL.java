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
public class GetAllToolTips_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		JSONArray jsonArr = new JSONArray();
		JSONObject json=new JSONObject();
		PrintWriter out=response.getWriter();	   
		
		String token = (String) session.getAttribute("uavalidtokenno");
		try{		
		String milestoneKey = request.getParameter("salesmilestonekey").trim();
		String jurisdiction=request.getParameter("jurisdiction").trim();
		//getting product key and milestome name 
		String milestoneData[]=TaskMaster_ACT.getMilestoneData(milestoneKey,token);
		String toolTip[][]=null;
		if(milestoneData[0]!=null&&milestoneData[1]!=null){
			toolTip=TaskMaster_ACT.getAllStepGuide(milestoneData[0],milestoneData[1],token,jurisdiction);
		}
		 
		if(toolTip!=null&&toolTip.length>0){
			for(int i=0;i<toolTip.length;i++){
				json.put("content", toolTip[i][0]);
				json.put("document", toolTip[i][1]);
				json.put("step", toolTip[i][2]);
				
				jsonArr.add(json);
			}
			out.print(jsonArr);
		}
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}

}