package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.enquiry.Enquiry_ACT;
import admin.master.Usermaster_ACT;
import commons.DateUtil;

public class ShareDocumentToClient_CTRL extends HttpServlet {	
	/**
	 * 
	 */
	private static final long serialVersionUID = -7474919985231846028L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 PrintWriter pw=response.getWriter();
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String loginuaid = (String) session.getAttribute("loginuaid");		
		
		boolean flag=false;
		try {
			
			String salesKey = request.getParameter("salesKey").trim();
			String name = request.getParameter("name").trim();
			String email=request.getParameter("email");
			String docKey=request.getParameter("docKey");			
			String document[]=TaskMaster_ACT.getSalesKeyByDocKey(docKey, uavalidtokenno);
			
			//getting today's date
			String today=DateUtil.getCurrentDateIndianFormat1();
			
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));
			String azure_path=properties.getProperty("azure_path");
			
			String message="<table border=\"0\" style=\"margin:0 auto; min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\r\n"
					+ "        <tbody><tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\r\n"
					+ "                <a href=\"#\" target=\"_blank\">\r\n"
					+ "                <img src=\"https://www.corpseed.com/assets/img/logo.png\"></a>\r\n"
					+ "            </td></tr>\r\n"
					+ "            <tr>\r\n"
					+ "              <td style=\"text-align: center;\">\r\n"
					+ "                <h1>SHARED DOCUMENT</h1>\r\n"
					+ "              <p style=\"font-size: 18px; line-height: 20px;color: #353637;\">Everything is processing well with your order</p></td></tr>\r\n"
					+ "        <tr>\r\n"
					+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\r\n"
					+ "            Hi "+name+",</td></tr>"
					+ "             <tr>"
					+ "                    <td style=\"padding: 10px 0;color: #353637;\"> \r\n"
					+ "                     <p>"+document[0]+" is shared with you, You can download the file by clicking on <a href=\""+azure_path+""+document[2]+"\" download=\"download\">download</a> button.</p>\r\n"
					+ "                     <p>Note : </b>This is an auto generated email. Do not reply on this email.\r\n"
					+ "                     </p>\r\n"
					+ "                    </td></tr>  \r\n"
					+ "             <tr><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\r\n"
					+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\r\n"
					+ "    </td></tr> \r\n"
					+ "    </tbody></table>";				
			
			flag = Enquiry_ACT.saveEmail(email,"empty","Document Notification", message,2,uavalidtokenno);
			
			
			if(flag) {
				//inserting upload action in document action history
				String userName=Usermaster_ACT.getLoginUserName(loginuaid, uavalidtokenno);
				String estKey=TaskMaster_ACT.getEstimateKey(salesKey,uavalidtokenno);
				if(salesKey==null)
				TaskMaster_ACT.saveDocumentActionHistory(document[0],salesKey,"Share",loginuaid,userName,uavalidtokenno,docKey,today,document[2],estKey);
				
				pw.write("pass");
			}
			else pw.write("fail");
		}catch(Exception e) {
			e.printStackTrace();
		}
	}

}