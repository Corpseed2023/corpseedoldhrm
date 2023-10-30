package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.task.TaskMaster_ACT;
import client_master.Clientmaster_ACT;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@SuppressWarnings("serial")
public class GetContactByRefid_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			
			String contactrefid=request.getParameter("key").trim();
//			System.out.println("pid="+pid);
			String token = (String)session.getAttribute("uavalidtokenno");
			
			String contact[][]=Enquiry_ACT.getContactByKey(contactrefid,token);
			if(contact.length>0){
				String compAddress=Enquiry_ACT.getCompanyAddress(contact[0][11],token);
				int i=0;
					json.put("key", contact[i][0]);
					json.put("firstname", contact[i][1]);
					json.put("lastname", contact[i][2]);
					json.put("email1", contact[i][3]);
					json.put("email2", contact[i][4]);
					json.put("workphone", contact[i][5]);
					json.put("mobilephone", contact[i][6]);
					json.put("addresstype", contact[i][7]);
					json.put("city", contact[i][8]);
					json.put("state", contact[i][9]);
					json.put("address", contact[i][10]);
					json.put("company", contact[i][11]);
					json.put("clientRefid", contact[i][12]);
					json.put("country", TaskMaster_ACT.getCountryByName(contact[i][13]));
					json.put("compAddress", compAddress);
					json.put("pan", contact[i][14]);
					json.put("stateCode", contact[i][15]);
					json.put("super_user_id", Clientmaster_ACT.findClientSuperUserByKey(contact[i][12], token));
					
					jsonArr.add(json);
				out.println(jsonArr);
			}
		}

		catch (Exception e) {
				e.printStackTrace();
		}

	}
}