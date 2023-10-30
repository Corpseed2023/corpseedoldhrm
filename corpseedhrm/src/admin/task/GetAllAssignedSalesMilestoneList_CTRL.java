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
public class GetAllAssignedSalesMilestoneList_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		JSONArray jsonArr = new JSONArray();
		JSONObject json=new JSONObject();
		PrintWriter out=response.getWriter();	   
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		
		try{		
		String salesrefid = request.getParameter("salesrefid").trim();
		String leaderUid = request.getParameter("leaderUid").trim();
		
//		String invoice=TaskMaster_ACT.getSalesInvoiceNumber(salesrefid, uavalidtokenno);
		String milestone[][]=TaskMaster_ACT.getAllAssignedSalesMilestone(leaderUid,salesrefid, uavalidtokenno); 	
		double salesPaid=TaskMaster_ACT.getMainDispersedAmount(salesrefid,uavalidtokenno);
		String invoiceno=TaskMaster_ACT.getinvoiceNoByKey(salesrefid, uavalidtokenno);
		double orderAmount=TaskMaster_ACT.getOrderAmount(invoiceno, uavalidtokenno);
//		double orderAmount=Enquiry_ACT.getProductAmount(salesrefid, uavalidtokenno);
		if(milestone!=null&&milestone.length>0){
			for(int i=0;i<milestone.length;i++){
				double workPercentage=Double.parseDouble(milestone[i][4]);
				double percentAmt=(orderAmount*workPercentage)/100;
				if(salesPaid>=percentAmt) {					
					json.put("refid", milestone[i][0]);
					json.put("milestonename", milestone[i][1]);
					json.put("mamemberassigndate", milestone[i][2]);				
					json.put("workPercent", milestone[i][3]);
					json.put("salesmilestonekey", milestone[i][5]);
									
					jsonArr.add(json);
				}
			}
			out.print(jsonArr);
		}
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}

}