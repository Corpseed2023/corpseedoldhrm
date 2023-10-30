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
public class GetFolderAccessUser_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();		
			
			HttpSession session = request.getSession(); 
			
			String fkey=request.getParameter("fkey").trim();
//System.out.println("refid=="+refid);
			String token = (String)session.getAttribute("uavalidtokenno");
			
			String folderAccess[][]=Enquiry_ACT.getFolderAccessUser(fkey,token);
					
				if(folderAccess!=null&&folderAccess.length>0){
					for(int j=0;j<folderAccess.length;j++){
						json.put("id", folderAccess[j][0]);
						json.put("name", folderAccess[j][1]);			
						
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