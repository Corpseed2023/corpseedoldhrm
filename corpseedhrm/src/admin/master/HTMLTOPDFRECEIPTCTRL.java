package admin.master;

import java.awt.Insets;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URL;
import java.util.Enumeration;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;
import org.zefer.pd4ml.PD4Constants;
import org.zefer.pd4ml.PD4ML;

import admin.enquiry.Enquiry_ACT;
import commons.DateUtil;

@SuppressWarnings("serial")
public class HTMLTOPDFRECEIPTCTRL extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session=request.getSession();
		PrintWriter pw=response.getWriter();
				
		try {  
            
            String url="NA";
            String outputPath="NA";
            
    		Properties properties = new Properties();
    		properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
    		Enumeration<?> enumeration =properties.propertyNames();
    		while (enumeration.hasMoreElements()) {
    			String key = (String) enumeration.nextElement();
    			if(key.equalsIgnoreCase("url"))
    				url=properties.getProperty(key);	
    			if(key.equalsIgnoreCase("docpath"))
    				outputPath=properties.getProperty(key);	
    		}
    		String refid = request.getParameter("refid").trim();   		
    		
    		//adding estimate invoice details
    		String uarefid=(String)session.getAttribute("loginuarefid");
    		String uavalidtokenno=(String)session.getAttribute("uavalidtokenno");
    		String today=DateUtil.getCurrentDateIndianFormat1();
    		String key =RandomStringUtils.random(30, true, true);
    		
    		//estimate invoice no
    		String start=Usermaster_ACT.getStartingCode(uavalidtokenno,"imestimatebillingkey");
    		String estinvoice=Enquiry_ACT.getuniquecode(uavalidtokenno);
    		if (estinvoice==null) {	
    			estinvoice=start+"1";
    		}
    		else {
    			String c=estinvoice.substring(start.length());
    		int j=Integer.parseInt(c)+1;
    		estinvoice=start+Integer.toString(j);
    		}
    		boolean estinv=Enquiry_ACT.isEstimateInvoiceSend(refid);
    		if(!estinv)
    		Enquiry_ACT.addEstimatedInvoice(key,refid,today,uarefid,uavalidtokenno,"1",estinvoice);
    		
    		
    		url+="?refid="+refid+"&estInv="+estinvoice;
    		outputPath+="estimate_invoice.pdf";
    		
            File output = new File(outputPath);  
            java.io.FileOutputStream fos = new java.io.FileOutputStream(output);  

            PD4ML pd4ml = new PD4ML();  
//            pd4ml.setPageSize(pd4ml.changePageOrientation(PD4Constants.A4)); 
            pd4ml.setPageSize(PD4Constants.A3);
            pd4ml.setPageInsetsMM(new Insets(10, 10, 0, 0));  
            pd4ml.setHtmlWidth(1124);
            pd4ml.addStyle("BODY {margin: 0}", true);  
            
            pd4ml.enableImgSplit( false );
            pd4ml.useTTF( "java:fonts", true );  
            pd4ml.setDefaultTTFs("Times New Roman", "Arial", "Courier New");
          
            pd4ml.render(new URL(url), fos);
            fos.close(); 
            
            pw.write("pass");
//          
//                        
//            RequestDispatcher rd=request.getRequestDispatcher("/billing.html");
//            rd.forward(request, response);
            
        } catch (Exception e) {  
            e.printStackTrace(); 
        } 

	}

}
