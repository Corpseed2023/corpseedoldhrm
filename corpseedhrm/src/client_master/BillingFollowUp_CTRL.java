package client_master;

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

import com.azure.storage.blob.BlobClientBuilder;
import com.oreilly.servlet.MultipartRequest;

import admin.master.Usermaster_ACT;
import admin.seo.SeoOnPage_ACT;
import commons.DateUtil;
import hcustbackend.ClientACT;

@SuppressWarnings("serial")
public class BillingFollowUp_CTRL extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		boolean status = false;

		Properties properties = new Properties();
		properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
		String docpath=properties.getProperty("path")+"documents";
		String azure_key=properties.getProperty("azure_key");
		String azure_container=properties.getProperty("azure_container");
		
		HttpSession session = request.getSession();

		String imgname="NA";
		String fpath="NA";	
		String pfuatoid = "NA";
		String loginid = (String) session.getAttribute("loginuID");
		String token = (String) session.getAttribute("uavalidtokenno");
		String uarefid = (String) session.getAttribute("uarefid");
		String today=DateUtil.getCurrentDateIndianFormat1();
		
		MultipartRequest m=new MultipartRequest(request,docpath,1024*1024*50);
		File file=m.getFile("files");
		if(file!=null){
		imgname=file.getName();
		file = new File(docpath+imgname);
		String key =RandomStringUtils.random(20, true, true);
		
		imgname=key+"_"+imgname;
		File newFile = new File(docpath+imgname);
		file.renameTo(newFile);
		fpath="https://corpseed.blob.core.windows.net/"+azure_container+File.separator+imgname;
		
		BlobClientBuilder client = new BlobClientBuilder();
        client.connectionString(azure_key);
        client.containerName(azure_container);
        InputStream targetStream = new FileInputStream(newFile);
        client.blobName(imgname).buildClient().upload(targetStream,newFile.length());
		
		targetStream.close();
		newFile.delete();
		}
		String pfupid = m.getParameter("pfupid");
		String projectno =m.getParameter("projectno");
		String pfuddate =m.getParameter("pfuddate");
		String clientid =m.getParameter("clientid");
		if(pfuddate==null||pfuddate.length()<=0)pfuddate=m.getParameter("deliverydate");
//		if(pfupid!=""||pfupid!=null){
//			String x[]=pfupid.split("#");
//			pfupid=x[0];
//			projectno=x[1];
//			pfuddate=x[2];
//		}
		String msgfor=m.getParameter("pfumsgfor");
		String pfustatus = m.getParameter("pfustatus");
		String pfudate = m.getParameter("pfudate");
		String pfuremark = m.getParameter("pfuremark");
		String followupby = m.getParameter("followupby");		
		String showclient = m.getParameter("showclient");		
		String fromfollowup=m.getParameter("fromfollowup");	
		String transferpage=m.getParameter("transferpage");	

		status = Clientmaster_ACT.saveFollowUp(msgfor,pfupid, pfustatus, pfudate, pfuremark, loginid, pfuatoid,followupby, pfuddate, showclient,token,fromfollowup,imgname,uarefid);
				
		if(!imgname.equalsIgnoreCase("NA")){
			String pfrefid[]=Clientmaster_ACT.getFolderDetails(projectno, token);
			if(pfrefid[0]!=null&&pfrefid[1]!=null)
			SeoOnPage_ACT.saveDocument(pfrefid[0],pfrefid[1],imgname,fpath,token,loginid,"NA","NA",clientid,today);
		}
		status = Clientmaster_ACT.saveFollowUpinProjectMaster(pfupid, pfustatus, pfuddate, "NA", "0");
		
		//add notification '.. comented on project nunmber ...'
		String loginuaid = (String) session.getAttribute("loginuaid");
		String pagename="mytask.html";
		String accesscode="MT00";
		String clpage="NA";
		if(showclient.equalsIgnoreCase("1"))clpage="client_inbox.html";
		String uuid =RandomStringUtils.random(30, true, true);	
		String assignby=Usermaster_ACT.getLoginUserName(loginuaid,token);				
		String msg="<b>"+assignby+"</b> commented on Project No : <b>"+projectno+"</b>";
		ClientACT.addNotification(uuid,projectno,msg,pagename,"assigntask",showclient,clientid,"1","1",loginid,token,clpage,loginuaid,accesscode,"1","1");
		
		
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
