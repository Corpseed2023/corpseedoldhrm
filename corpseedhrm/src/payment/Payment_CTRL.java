package payment;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import com.paytm.pg.merchant.PaytmChecksum;

import commons.DateUtil;
import hcustbackend.ClientACT;
import paytm_java.PaytmConstants;

public class Payment_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		try {
		HttpSession session=request.getSession();
//		String mobile=request.getParameter("MOBILE_NO");
//		String amount=request.getParameter("TXN_AMOUNT");
		String salesKey=(String)session.getAttribute("SalesKey");
		String ORDER_ID=request.getParameter("ORDER_ID");
		String txn_amount=request.getParameter("TXN_AMOUNT");
		String token=(String)session.getAttribute("uavalidtokenno");
		String loginuaid = (String) session.getAttribute("loginuaid");
		String today=DateUtil.getCurrentDateIndianFormat1();
		String uuid=RandomStringUtils.random(40,true,true);
		//adding order details
		ClientACT.saveTxnDetails(uuid,salesKey,ORDER_ID,txn_amount,loginuaid,token,today);
		
		
		HttpSession sess1=request.getSession(true);
		sess1.setAttribute("SalesKey", salesKey);
		PrintWriter out=response.getWriter();
		
		Enumeration<String> paramNames = request.getParameterNames();
		Map<String, String[]> mapData = request.getParameterMap();
		TreeMap<String,String> parameters = new TreeMap<String,String>();
//		String paytmChecksum =  "";
		while(paramNames.hasMoreElements()) {
			String paramName = (String)paramNames.nextElement();
			parameters.put(paramName,mapData.get(paramName)[0]);	
		}

		parameters.put("MID",PaytmConstants.MID);
		parameters.put("CHANNEL_ID",PaytmConstants.CHANNEL_ID);
		parameters.put("INDUSTRY_TYPE_ID",PaytmConstants.INDUSTRY_TYPE_ID);
		parameters.put("WEBSITE",PaytmConstants.WEBSITE);
		parameters.put("EMAIL","ajay.kumar@corpseed.com");
		parameters.put("CUST_ID", PaytmConstants.CUST_ID);
		parameters.put("CALLBACK_URL", PaytmConstants.CALLBACK_URL);


		String checkSum = PaytmChecksum.generateSignature(parameters, PaytmConstants.MERCHANT_KEY); 


		StringBuilder outputHtml = new StringBuilder();
		outputHtml.append("<!DOCTYPE html PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN' 'http://www.w3.org/TR/html4/loose.dtd'>");
		outputHtml.append("<html>");
		outputHtml.append("<head>");
		outputHtml.append("<title>Merchant Check Out Page</title>");
		outputHtml.append("</head>");
		outputHtml.append("<body>");
		outputHtml.append("<center><h1>Please do not refresh this page...</h1></center>");
		outputHtml.append("<form method='post' action='"+ PaytmConstants.PAYTM_URL +"' name='f1'>");
		outputHtml.append("<table border='1'>");
		outputHtml.append("<tbody>");

		for(Map.Entry<String,String> entry : parameters.entrySet()) {
			String key = entry.getKey();
			String value = entry.getValue();
			outputHtml.append("<input type='hidden' name='"+key+"' value='" +value+"'>");	
		}	  
			  


		outputHtml.append("<input type='hidden' name='CHECKSUMHASH' value='"+checkSum+"'>");		
		outputHtml.append("</tbody>");
		outputHtml.append("</table>");
		outputHtml.append("<script type='text/javascript'>");
		outputHtml.append("document.f1.submit();");
		outputHtml.append("</script>");
		outputHtml.append("</form>");
		outputHtml.append("</body>");
		outputHtml.append("</html>");
		out.println(outputHtml);		
		
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
	}	

}
