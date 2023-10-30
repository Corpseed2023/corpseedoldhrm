package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.master.Usermaster_ACT;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


@SuppressWarnings("serial")
public class GetAllTeamMemberList_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		JSONArray jsonArr = new JSONArray();
		JSONObject json=new JSONObject();
		PrintWriter out=response.getWriter();	   
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		try{		
		String teamrefid = request.getParameter("teamrefid").trim();
		
		String member[][]=TaskMaster_ACT.getAllTeamMembers(teamrefid, uavalidtokenno);
		if(member!=null&&member.length>0){
			for(int i=0;i<member.length;i++){
				json.put("userId", member[i][0]);
				json.put("name", member[i][1]);
				
				jsonArr.add(json);
			}
			
			String leaderId=TaskMaster_ACT.getTeamLeaderId(teamrefid, uavalidtokenno);
			String leaderName=Usermaster_ACT.getLoginUserName(leaderId, uavalidtokenno);
			json.put("userId", leaderId);
			json.put("name", leaderName);
			jsonArr.add(json);
			out.print(jsonArr);
		}
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}

}