package client_master;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
public class ConvertToPdf_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
//			String refid = request.getParameter("refid").trim();
//			URL url=new URL("http://localhost:8080/itswshrm/billreceiptprint.html?refid="+refid);
//			System.out.println(url);
//			String dest ="D:/ITSWS/ITSWS NEW/itswshrm/itswshrm/WebContent/pdfreceipt/Billing-Receipt.pdf";
//			
//			    ConverterProperties properties = new ConverterProperties();
//			    MediaDeviceDescription mediaDeviceDescription =
//			        new MediaDeviceDescription(MediaType.PRINT);
//			    properties.setMediaDeviceDescription(mediaDeviceDescription);
//			    HtmlConverter.convertToPdf(url.openStream(), new FileOutputStream(dest), properties);
//				
//			
		RequestDispatcher rd=request.getRequestDispatcher("/billing.html");
		rd.forward(request, response);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
	
}
