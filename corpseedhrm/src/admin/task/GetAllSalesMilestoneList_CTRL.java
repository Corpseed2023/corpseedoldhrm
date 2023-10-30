package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.master.Usermaster_ACT;
import commons.CommonHelper;
import commons.DateUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


@SuppressWarnings("serial")
public class GetAllSalesMilestoneList_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		JSONArray jsonArr = new JSONArray();
		JSONObject json=new JSONObject();
		PrintWriter out=response.getWriter();	   
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		try{	
		String workStartPrice="100";
		String salesrefid = request.getParameter("salesrefid").trim();
		String name = request.getParameter("name").trim();
		String today=DateUtil.getCurrentDateIndianReverseFormat();
		String time=DateUtil.getCurrentTime24Hours();
		String milestone[][]=TaskMaster_ACT.getAllSalesMilestone(name,salesrefid, uavalidtokenno); 
		if(milestone!=null&&milestone.length>0){
			for(int i=0;i<milestone.length;i++){
				String startDate=(milestone[i][11]!=null&&!milestone[i][11].equals("NA")
						&&!milestone[i][11].equals("00-00-0000"))?
						milestone[i][11].substring(6)+milestone[i][11].substring(2,6)+milestone[i][11].substring(0,2):"NA";
				String startTime=(milestone[i][14]!=null&&!milestone[i][14].equals("NA"))?milestone[i][14]:"09:00";
				String deliveryDate=(milestone[i][18]!=null&&!milestone[i][18].equals("NA"))?milestone[i][18]:today;
				String deliveryTime=(milestone[i][19]!=null&&!milestone[i][19].equals("NA"))?milestone[i][19]:time;
				json.put("consumed", CommonHelper.calculateTime(startDate,startTime,deliveryDate,deliveryTime));				
				json.put("milestonerefid", milestone[i][0]);
				json.put("name", milestone[i][1]);
				json.put("memberid", milestone[i][2]);
				json.put("tat", milestone[i][16].equals("1")?milestone[i][16]+" "+milestone[i][17]:milestone[i][16]+" "+milestone[i][17]+"s");
				
				if(milestone[i][2]!=null&&!milestone[i][2].equalsIgnoreCase("NA"))
					json.put("memberName", Usermaster_ACT.getLoginUserName(milestone[i][2], uavalidtokenno));	
				else
					json.put("memberName", "Unassigned");	
				json.put("memberassigndate", milestone[i][3]);	
				json.put("aassignDate", milestone[i][4]);
				json.put("assignkey", milestone[i][5]);
				json.put("childTeamKey", milestone[i][6]);	
				json.put("massignDate", milestone[i][7]);
				json.put("workPercent", milestone[i][8]);
				json.put("workStatus", milestone[i][9]);
				
				String product[]=TaskMaster_ACT.getProductNameAndKey(milestone[i][0],uavalidtokenno);
				if(product[0]!=null&&!product[0].equalsIgnoreCase("NA")) {
					String salesPayType="NA";
					if(!salesrefid.equalsIgnoreCase("NA"))
						salesPayType=TaskMaster_ACT.getSalesPayType(salesrefid,uavalidtokenno);
					
					if(salesPayType.equalsIgnoreCase("Milestone Pay"))
						workStartPrice=milestone[i][10];
					else
						workStartPrice=TaskMaster_ACT.getWorkPricePercentage(product[0],product[1],uavalidtokenno);
				}
				
				json.put("workStartedPercentage", workStartPrice);
				json.put("workStartedDate", milestone[i][11]);
				json.put("workStartedTime", milestone[i][14]);
				json.put("progressStatus", milestone[i][15]);
				
				/* System.out.println(milestone[i][1]+"="+milestone[i][4]); */
				
				jsonArr.add(json);
				
				
			}
			out.print(jsonArr);
		}
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}

}