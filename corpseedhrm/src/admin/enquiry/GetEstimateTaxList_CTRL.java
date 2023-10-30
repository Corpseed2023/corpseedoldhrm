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
public class GetEstimateTaxList_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();		
			
			HttpSession session = request.getSession(); 
			
			String salesNo=request.getParameter("salesNo").trim();
//System.out.println("refid=="+refid);
			String token = (String)session.getAttribute("uavalidtokenno");
			String estimatetaxData[][]=Enquiry_ACT.getEstimateTaxList(salesNo,token);
					
				if(estimatetaxData!=null&&estimatetaxData.length>0){
					for(int j=0;j<estimatetaxData.length;j++){
						json.put("hsn", estimatetaxData[j][0]);
						json.put("cgst", estimatetaxData[j][1]);
						json.put("sgst", estimatetaxData[j][2]);
						json.put("igst", estimatetaxData[j][3]);				
						
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