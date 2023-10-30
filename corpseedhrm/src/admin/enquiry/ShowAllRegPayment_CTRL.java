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
public class ShowAllRegPayment_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			
			String estimateno=request.getParameter("estimateno").trim();
//			System.out.println("pid="+pid);
			String token = (String)session.getAttribute("uavalidtokenno");
			
			String payment[][]=Enquiry_ACT.getRegisteredPayment(estimateno,token);
			if(payment!=null&&payment.length>0){
				for(int i=0;i<payment.length;i++){
					
					json.put("srefid", payment[i][0]);
					json.put("date", payment[i][1]);
					json.put("saleno", payment[i][2]);
					json.put("mode", payment[i][3]);
					json.put("transactionid", payment[i][4]);
					json.put("amount", payment[i][5]);
					json.put("status", payment[i][6]);
					json.put("docname", payment[i][7]);
					json.put("comment", payment[i][8]);
					json.put("holdcomment", payment[i][9]);
					
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