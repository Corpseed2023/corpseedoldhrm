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
public class GetEstimatePriceList_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();		
			
			HttpSession session = request.getSession(); 
			
			String saleno=request.getParameter("saleno").trim();

			String token = (String)session.getAttribute("uavalidtokenno");
			String estimateprice[][]=Enquiry_ACT.getEstimateProductList(saleno,token);
			
			int k=1;
				if(estimateprice!=null&&estimateprice.length>0){
					for(int j=0;j<estimateprice.length;j++){	
						if(k==1){
						String client[]=Enquiry_ACT.getClientsDetail(estimateprice[j][4],token);
						String name="";
						String address="";
						String state="";
						String stateCode="";
						String gstin="";
						if(client[0]==null||client[0].length()<=0||client[0].equalsIgnoreCase("NA")) {
							client=Enquiry_ACT.getContactDetail(estimateprice[j][8],token);
						}						
						name=client[0];
						address=client[1];
						state=client[2];
						stateCode=client[3];
						gstin="NA";
						
						double saleprice=Enquiry_ACT.getProductPrice(saleno, token);
						
						json.put("cregname", name);
						json.put("cregaddress", address);
						json.put("cregstate", state);
						json.put("cregstatecode", stateCode);
						json.put("cregistin", gstin);
						json.put("subtotalprice", saleprice);
						k++;
						}
						json.put("refid", estimateprice[j][0]);
						
						if(estimateprice[j][12].equals("1"))
							json.put("name", estimateprice[j][1]);
						else
							json.put("name", "Consultation Service");
						json.put("qty", estimateprice[j][2]);
						json.put("date", estimateprice[j][3]);		
						json.put("clientrefid", estimateprice[j][4]);	
						json.put("invoiceNotes", estimateprice[j][7]);
						json.put("orderNo", estimateprice[j][10]);
						json.put("purchaseDate", estimateprice[j][11]);
						
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