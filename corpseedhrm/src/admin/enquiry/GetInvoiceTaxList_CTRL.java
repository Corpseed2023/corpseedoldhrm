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
public class GetInvoiceTaxList_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();		
			
			HttpSession session = request.getSession(); 
			
			String invoice=request.getParameter("invoice").trim();
//System.out.println("refid=="+refid);
			String token = (String)session.getAttribute("uavalidtokenno");
			String invoiceTaxData[][]=Enquiry_ACT.getInvoiceTaxList(invoice,token);
					
				if(invoiceTaxData!=null&&invoiceTaxData.length>0){
					for(int j=0;j<invoiceTaxData.length;j++){
						json.put("hsn", invoiceTaxData[j][0]);
						json.put("cgst", invoiceTaxData[j][1]);
						json.put("sgst", invoiceTaxData[j][2]);
						json.put("igst", invoiceTaxData[j][3]);				
						
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