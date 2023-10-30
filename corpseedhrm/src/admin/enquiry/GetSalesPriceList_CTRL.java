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

public class GetSalesPriceList_CTRL extends HttpServlet {

	
	private static final long serialVersionUID = -1120683023975950723L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();		
			
			HttpSession session = request.getSession(); 
			
			String invoice=request.getParameter("invoice").trim();

			String token = (String)session.getAttribute("uavalidtokenno");
			String salesList[][]=Enquiry_ACT.getSalesInvoiceProductList(invoice,token);
			
				if(salesList!=null&&salesList.length>0){
					for(int j=0;j<salesList.length;j++){						
						json.put("refid", salesList[j][0]);
						json.put("name", salesList[j][1]);
						
						jsonArr.add(json);
					}
					out.println(jsonArr);
				}
				}catch (Exception e) {
				e.printStackTrace();
		}

	}
}