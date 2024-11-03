package hcustbackend;

import java.io.File;
import java.io.IOException;
import java.util.Properties;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import com.oreilly.servlet.MultipartRequest;

import admin.master.CloudService;

@SuppressWarnings("serial")
public class AddClientDocument_CTRL extends HttpServlet {
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher rd=request.getRequestDispatcher("/client_documents.html");
		rd.forward(request, response);
	}
	
	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		   		
		try {
			String imgname=null;
			String clientid=null;
			String path="";
			String key="";
			
			HttpSession session = request.getSession();
			String addedby= (String)session.getAttribute("loginuID");
			
			//get token no from session
			String token=(String)session.getAttribute("uavalidtokenno");
			
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
			String docpath=properties.getProperty("path")+"documents";	
			String docBasePath=properties.getProperty("docBasePath");
			
			MultipartRequest m=new MultipartRequest(request,docpath,1024*1024*50);
			File file=m.getFile("files");
			if(file!=null){
			imgname=file.getName();
			file = new File(docpath+imgname);
			key =RandomStringUtils.random(20, true, true);
			
			imgname=key+"_"+imgname;
			File newFile = new File(docpath+imgname);
			file.renameTo(newFile);
			path=docBasePath+imgname;
			
			CloudService.uploadDocument(newFile, imgname);
			newFile.delete();
			}
			clientid = m.getParameter("clientid");	
			String documentname = m.getParameter("documentname");
			if(documentname!=null)documentname=documentname.trim();
			
			String documenttype = m.getParameter("documenttype");
			if(documenttype!=null)documenttype=documenttype.trim();
			
			String folderdetails = m.getParameter("folderdetails");
			if(folderdetails!=null)folderdetails=folderdetails.trim();
			
			ClientACT.saveDocument(clientid,path,token,documentname,documenttype,folderdetails,addedby,imgname);
			
	
			RequestDispatcher rd=request.getRequestDispatcher("/client_documents.html");
			rd.forward(request, response);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
