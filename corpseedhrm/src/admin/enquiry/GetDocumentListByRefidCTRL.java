package admin.enquiry;

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
public class GetDocumentListByRefidCTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			
			String salesrefid=request.getParameter("salesrefid").trim();
//			System.out.println("pid="+pid);
			String token = (String)session.getAttribute("uavalidtokenno");
			
			String documentlist[][]=Enquiry_ACT.getDocumentListByKey(salesrefid,token);
			if(documentlist!=null&&documentlist.length>0){
				for(int i=0;i<documentlist.length;i++){
					
					json.put("refid", documentlist[i][0]);
					json.put("uploaddocname", documentlist[i][1]);
					json.put("description", documentlist[i][2]);
					json.put("uploadby", documentlist[i][3]);
					json.put("uploaddoc", documentlist[i][4]);
					json.put("uploaddate", documentlist[i][5]);
					json.put("reupload", documentlist[i][6]);
					
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