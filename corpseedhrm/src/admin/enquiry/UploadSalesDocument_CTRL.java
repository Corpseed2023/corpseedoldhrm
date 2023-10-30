package admin.enquiry;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;
import org.apache.log4j.Logger;

import com.azure.storage.blob.BlobClientBuilder;
import com.oreilly.servlet.MultipartRequest;

import admin.Login.LoginAction;
import admin.seo.SeoOnPage_ACT;
import commons.AzureBlob;

@SuppressWarnings("serial")
public class UploadSalesDocument_CTRL extends HttpServlet {
	private static Logger log = Logger.getLogger(LoginAction.class);

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		HttpSession session = request.getSession();
try{
	String fpath="";
		String imgname="NA";		
		String loginid = (String) session.getAttribute("loginuID");		
		String token = (String) session.getAttribute("uavalidtokenno");	
		
		Properties properties = new Properties();
		properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
		String docpath=properties.getProperty("path")+"documents";
		String azure_key=properties.getProperty("azure_key");
		String azure_container=properties.getProperty("azure_container");
		String azure_path=properties.getProperty("azure_path");
		
		MultipartRequest m=new MultipartRequest(request,docpath,1024*1024*50);
		File file=m.getFile("documentfile");
		if(file!=null){
		imgname=file.getName();
		file = new File(docpath+imgname);
		String key =RandomStringUtils.random(20, true, true);
		
		imgname=key+"_"+imgname;
		File newFile = new File(docpath+imgname);
		file.renameTo(newFile);
		fpath=azure_path+azure_container+File.separator+imgname;
		
		BlobClientBuilder client=AzureBlob.getBlobClient(azure_key, azure_container);
        client.connectionString(azure_key);
        client.containerName(azure_container);
        InputStream targetStream = new FileInputStream(newFile);
        client.blobName(imgname).buildClient().upload(targetStream,newFile.length());
		
		targetStream.close();
		newFile.delete();
		}
		String refid ="NA";
		String fname ="NA";
		String clientid="NA";
		String doctype = m.getParameter("doctype");
		if(doctype!=null)doctype=doctype.trim();
		
		String docname=m.getParameter("docname");
		if(docname!=null)docname=docname.trim();
		
		String docdate=m.getParameter("docdate");
		if(docdate!=null)docdate=docdate.trim();
		
		String salerefid=m.getParameter("salerefid");
		if(salerefid!=null)salerefid=salerefid.trim();
		
		String doc[]=Enquiry_ACT.getFolderDetails(salerefid,token);
		if(doc!=null&&doc[0]!=null&&doc[1]!=null){
			refid =doc[0];
			fname =doc[1];
		}				
		SeoOnPage_ACT.saveDocument(refid,fname,imgname,fpath,token,loginid,doctype,docname,clientid,docdate);
						
		
}catch(Exception e){
	log.info("Error in NewFile_CTRL \n"+e);
}
	
	}

}
