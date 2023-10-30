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
public class GetCompanyByRefid_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			String token = (String)session.getAttribute("uavalidtokenno");
			
			String clientkey=request.getParameter("clientkey").trim();
			String invoice=request.getParameter("invoice");
			
			if(invoice!=null)invoice=invoice.trim();
			
			String contactKey=Enquiry_ACT.getSalesContactKeyByInvoice(invoice, token);
//			System.out.println("pid="+pid);
			Thread.sleep(600);
			
			String company[][]=Enquiry_ACT.getCompanyByKey(clientkey,token);
			if(company!=null&&company.length>0){
				if(company[0][1]==null||company[0][1].equalsIgnoreCase("NA")||company[0][1].length()<=0) {
					String client[]=Enquiry_ACT.getContactDetail(contactKey,token);
					if(client[0]!=null&&!client[0].equalsIgnoreCase("NA")&&client[0].length()>0) {
						json.put("name", client[0]);						
						json.put("address", client[1]);
						json.put("state", client[2]);
						json.put("stateCode", client[3]);
						json.put("pan", client[4]);
						json.put("city", client[5]);
						json.put("country", TaskMaster_ACT.getCountryByName(client[6]));	
					}
				}else {
					json.put("name", company[0][1]);
					json.put("state", company[0][6]);
					json.put("address", company[0][8]);
					json.put("stateCode", company[0][10]);
					json.put("pan", company[0][3]);
					json.put("city", company[0][5]);
					json.put("country", TaskMaster_ACT.getCountryByName(company[0][7]));	
				}
					json.put("clientkey", company[0][0]);					
					json.put("industry", company[0][2]);					
					json.put("gst", company[0][4]);
					json.put("compAge", company[0][9]);
					json.put("superUserUaid", company[0][11]);
					
					jsonArr.add(json);
				out.println(jsonArr);
			}else {
				String client[]=Enquiry_ACT.getContactDetail(contactKey,token);
				if(client[0]!=null&&!client[0].equalsIgnoreCase("NA")&&client[0].length()>0) {
					json.put("name", client[0]);						
					json.put("address", client[1]);
					json.put("state", client[2]);
					json.put("stateCode", client[3]);
					json.put("pan", client[4]);	
					json.put("city", client[5]);
					json.put("country", TaskMaster_ACT.getCountryByName(client[6]));	
					
					json.put("industry", "NA");					
					json.put("gst", "NA");
										
					json.put("country", "NA#NA");					
					json.put("compAge", "0");
					
					jsonArr.add(json);
					out.println(jsonArr);
				}
			}
		}

		catch (Exception e) {
				e.printStackTrace();
		}

	}
}