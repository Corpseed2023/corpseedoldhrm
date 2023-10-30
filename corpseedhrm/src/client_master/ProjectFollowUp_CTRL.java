package client_master;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import com.azure.storage.blob.BlobClientBuilder;
import com.oreilly.servlet.MultipartRequest;

import admin.seo.SeoOnPage_ACT;
import commons.AzureBlob;
import commons.DateUtil;

@SuppressWarnings("serial")
public class ProjectFollowUp_CTRL extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		RequestDispatcher rd = null;
		boolean status = false;

		Properties properties = new Properties();
		properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
		String docpath=properties.getProperty("path")+"documents";
		String azure_key=properties.getProperty("azure_key");
		String azure_container=properties.getProperty("azure_container");
		String azure_path=properties.getProperty("azure_path");
		
		HttpSession session = request.getSession();

		String imgname="NA";
		String fpath="NA";
		String pfuato = "NA";
		String pfuatoid = "NA";
		String loginuaid = (String) session.getAttribute("loginuaid");
		String loginid = (String) session.getAttribute("loginuID");
		String uacompany= (String)session.getAttribute("uacompany");
		String token = (String) session.getAttribute("uavalidtokenno");
		String today=DateUtil.getCurrentDateIndianFormat1();
		
		MultipartRequest m=new MultipartRequest(request,docpath,1024*1024*50);
		File file=m.getFile("files");
		if(file!=null){
		imgname=file.getName();
		file = new File(docpath+imgname);
		String key =RandomStringUtils.random(15, true, true);
		
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
		String pfupid = m.getParameter("pfupid");
		String pfustatus = m.getParameter("pfustatus");
		String pfudate = m.getParameter("pfudate");
		String pfuremark = m.getParameter("pfuremark");
		String followupby = m.getParameter("followupby");
		String pfuddate = m.getParameter("pfuddate");
		String deliverydate = m.getParameter("deliverydate");
		String showclient = m.getParameter("showclient");		
		String projectno =m.getParameter("projectno");
		String fromfollowup=m.getParameter("fromfollowup");	
		String transferpage=m.getParameter("transferpage");	

		if(!pfustatus.equalsIgnoreCase("Hold")) pfuddate=deliverydate;

//		status = Clientmaster_ACT.saveFollowUp(pfupid, pfustatus, pfudate, pfuremark, loginid, pfuatoid,followupby, pfuddate, showclient,token,fromfollowup,imgname);
		status = Clientmaster_ACT.saveFollowUpinProjectMaster(pfupid, pfustatus, pfuddate, pfuato, "0");
		if(!imgname.equalsIgnoreCase("NA")){
			String pfrefid[]=Clientmaster_ACT.getFolderDetails(projectno, token);
			if(pfrefid.length>0)
			SeoOnPage_ACT.saveDocument(pfrefid[0],pfrefid[1],imgname,fpath,token,loginid,"NA","NA","NA",today);
		}
		if(pfustatus.equalsIgnoreCase("Delivered")){
//			Clientmaster_ACT.updateRenewalDate(pfupid,pfuddate,token);
		}

//		if(!pfuato.equals("Pending")||!pfuatoid.equals("Pending")) Clientmaster_ACT.saveManageTask(ptltuid, pfupid, loginuaid,pfuatoid,ptlname, pfuremark, today, pfuddate, loginid, uacompany,token);
//		String pfuid = Clientmaster_ACT.getLastFollowUp(pfupid);



		if (status){
		response.sendRedirect(request.getContextPath()+"/"+transferpage);
		}
		else {
			session.setAttribute("ErrorMessage", "Project Follow Up Failed!");
			response.sendRedirect(request.getContextPath()+"/notification.html");			
		}		
	}

}
