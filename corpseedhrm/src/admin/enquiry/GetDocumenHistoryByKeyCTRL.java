package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.task.TaskMaster_ACT;
import commons.CommonHelper;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@SuppressWarnings("serial")
public class GetDocumenHistoryByKeyCTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			
			String salesrefid=request.getParameter("salesrefid").trim();
//			System.out.println("pid="+pid);
			String token = (String)session.getAttribute("uavalidtokenno");
			
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
			String azure_key=properties.getProperty("azure_key");
			String azure_container=properties.getProperty("azure_container");
			
			String history[][]=null;
			if(!salesrefid.equalsIgnoreCase("NA"))
					history=TaskMaster_ACT.getDocumentActionHistory(salesrefid, token);
			else {
				String estKey=request.getParameter("estkey");
				history=TaskMaster_ACT.getDocumentActionHistoryByEstimate(estKey, token);
			}
			
			if(history!=null&&history.length>0){
				for(int i=0;i<history.length;i++){	
					json.put("id", history[i][0]);
					json.put("date", history[i][7]);
					json.put("name", history[i][2]);
					boolean exist=CommonHelper.isFileExists(history[i][9], azure_key, azure_container);
					if(exist) {
						json.put("exist", 1);
					}else {
						json.put("exist",2);
					}
					json.put("type", history[i][3]);
					json.put("actionby", history[i][5]);
					json.put("docName", history[i][9]);
					
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