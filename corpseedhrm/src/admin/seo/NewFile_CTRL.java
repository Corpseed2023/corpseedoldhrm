package admin.seo;

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
import admin.master.CloudService;
import commons.DateUtil;

@SuppressWarnings("serial")
public class NewFile_CTRL extends HttpServlet {
	private static Logger log = Logger.getLogger(LoginAction.class);

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		HttpSession session = request.getSession();
try{
	String fpath="";
		String imgname="NA";		
		String loginid = (String) session.getAttribute("loginuID");		
		String token = (String) session.getAttribute("uavalidtokenno");
		String today=DateUtil.getCurrentDateIndianFormat1();
		
		Properties properties = new Properties();
		properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
		String docpath=properties.getProperty("path")+"documents";
		String docBasePath=properties.getProperty("docBasePath");

		//Kaushal
	
		
		MultipartRequest m=new MultipartRequest(request,docpath,1024*1024*50);
		File file=m.getFile("document");
		if(file!=null){
		imgname=file.getName();
		file = new File(docpath+imgname);
		String key =RandomStringUtils.random(20, true, true);
		
		imgname=key+"_"+imgname;
		File newFile = new File(docpath+imgname);
		file.renameTo(newFile);
		fpath=docBasePath+imgname;
		
		CloudService.uploadDocument(newFile, imgname);
	
		newFile.delete();
		}
		String x[]=null;
		String refid =null;
		String fname =null;
		String clientid="NA";
		String doctype = m.getParameter("doctype");
		String docname=m.getParameter("docname");
		String folder = m.getParameter("folder");	
		String subfolder=m.getParameter("subfolder");
		if(subfolder.equalsIgnoreCase("NA")){
		x=folder.split("#");
		refid =x[0];
		fname =x[1];		
		}else{
			x=subfolder.split("#");
			refid =x[0];
			fname =x[1];
		}
		clientid=SeoOnPage_ACT.getClientId(folder,token);
		SeoOnPage_ACT.saveDocument(refid,fname,imgname,fpath,token,loginid,doctype,docname,clientid,today);
								
			
}catch(Exception e){
	log.info("Error in NewFile_CTRL \n"+e);
}

//		if (status){
//		response.sendRedirect(request.getContextPath()+"/mydocument.html");
//		}
//		else {
//			session.setAttribute("ErrorMessage", "Document Not Uploaded !");
//			response.sendRedirect(request.getContextPath()+"/notification.html");			
//		}		
	}

}
