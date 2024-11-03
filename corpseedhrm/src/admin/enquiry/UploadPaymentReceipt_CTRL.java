package admin.enquiry;

import java.io.File;
import java.io.IOException;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;
import org.apache.log4j.Logger;

import com.oreilly.servlet.MultipartRequest;

import admin.Login.LoginAction;
import commons.DateUtil;

@SuppressWarnings("serial")
public class UploadPaymentReceipt_CTRL extends HttpServlet {
	private static Logger log = Logger.getLogger(LoginAction.class);

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		HttpSession session = request.getSession();
try{
		String imgname="NA";		
		String loginid = (String) session.getAttribute("loginuID");		
		String token = (String) session.getAttribute("uavalidtokenno");	
		
		String key="NA";
		String enqrefid="NA";
		Properties properties = new Properties();
		properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
		String docpath=properties.getProperty("path")+"documents";

		
		MultipartRequest m=new MultipartRequest(request,docpath,1024*1024*50);
		File file=m.getFile("payfile");
		enqrefid=m.getParameter("sref");
		if(file!=null){
		imgname=file.getName();
		file = new File(docpath+imgname);
		key =RandomStringUtils.random(20, true, true);
		
		imgname=key+"_"+imgname;
		File newFile = new File(docpath+imgname);
		file.renameTo(newFile);
		
		
        
        
        
        
		
		
		newFile.delete();
		}
		//inserting record into salesestimatepayment table
		key =RandomStringUtils.random(40, true, true);
		String today=DateUtil.getCurrentDateIndianFormat1();
		Enquiry_ACT.uploadSalesPaymentDoc(key,today,enqrefid,"Not Approved",loginid,token,imgname);
		
}catch(Exception e){
	log.info("Error in NewFile_CTRL \n"+e);
}
	
	}

}
