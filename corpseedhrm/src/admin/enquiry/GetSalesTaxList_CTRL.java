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
public class GetSalesTaxList_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();		
			
			HttpSession session = request.getSession(); 
			
			String invoice=request.getParameter("invoice").trim();
//System.out.println("refid=="+refid);
			String token = (String)session.getAttribute("uavalidtokenno");
			String salesTaxData[][]=Enquiry_ACT.getSalesInvoiceTaxList(invoice,token);
					
				if(salesTaxData!=null&&salesTaxData.length>0){
					for(int j=0;j<salesTaxData.length;j++){
						json.put("hsn", salesTaxData[j][0]);
						json.put("cgst", salesTaxData[j][1]);
						json.put("sgst", salesTaxData[j][2]);
						json.put("igst", salesTaxData[j][3]);				
						
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