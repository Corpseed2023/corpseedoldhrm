package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import client_master.Clientmaster_ACT;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


@SuppressWarnings("serial")
public class GetCompanyData_CTRL extends HttpServlet {	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		JSONArray jsonArr = new JSONArray();
		JSONObject json=new JSONObject();
		PrintWriter out=response.getWriter();	   
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		try{	
			String companyId=request.getParameter("companyId").trim();
			
			String companyData[][]=Clientmaster_ACT.getClientDetails(Integer.parseInt(companyId), uavalidtokenno); 
			if(companyData!=null&&companyData.length>0){
				json.put("name", companyData[0][0]);
				json.put("clientNo", companyData[0][1]);
				json.put("mobile", companyData[0][2]);
				json.put("email", companyData[0][3]);
				json.put("address", companyData[0][4]);
				json.put("industry", companyData[0][5]);
				json.put("country", TaskMaster_ACT.getCountryByName(companyData[0][6]));
				json.put("state", companyData[0][7]);
				json.put("city", companyData[0][8]);
				json.put("pan", companyData[0][9]);
				json.put("gstin", companyData[0][10]);
				json.put("cage", companyData[0][11]);
				json.put("stateCode", companyData[0][12]);
				
				jsonArr.add(json);
				
			out.print(jsonArr);
		}
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}

}