package admin.seo;

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

import admin.master.Usermaster_ACT;
import client_master.Clientmaster_ACT;
import commons.DateUtil;
import hcustbackend.ClientACT;

@SuppressWarnings("serial")
public class TaskStatus_CTRL extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			boolean status = false;
			
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
			String docpath=properties.getProperty("path")+"documents";
			String azure_key=properties.getProperty("azure_key");
			String azure_container=properties.getProperty("azure_container");
			String imgname="NA";
			String fpath="NA";
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
			fpath="https://corpseednew.blob.core.windows.net/"+azure_container+File.separator+imgname;
			
			BlobClientBuilder client = new BlobClientBuilder();
	        client.connectionString(azure_key);
	        client.containerName(azure_container);
	        InputStream targetStream = new FileInputStream(newFile);
	        client.blobName(imgname).buildClient().upload(targetStream,newFile.length());
			
			targetStream.close();
			newFile.delete();
			}
			HttpSession session = request.getSession();

			String loginuaid=(String)session.getAttribute("loginuaid");
			String token=(String)session.getAttribute("uavalidtokenno");
			String loginid = (String) session.getAttribute("loginuID");
			String emproleid=(String)session.getAttribute("emproleid");
			
			String ptstid = m.getParameter("ptstid").trim();
			String ptsremarks = m.getParameter("ptsremarks").trim();
			String ptsstatus = m.getParameter("ptsstatus").trim();
			String ptsaddedby = m.getParameter("ptsaddedby").trim();
			String mid = m.getParameter("mid").trim();
			String taskname="NA";
			if(mid!=null&&mid.length()>0){
				String x[]=mid.split("#");
				mid=x[0];
				taskname=x[1];
			}
			String deliverydate = m.getParameter("deliverydate").trim();
			String preguid=m.getParameter("preguid");
			String pregno=m.getParameter("pregno");
			String loginname=m.getParameter("loginname");
			String showclient=m.getParameter("showclient");
			String pregcuid=m.getParameter("pregcuid");
			String uarefid= (String)session.getAttribute("uarefid");
			
			status = SeoOnPage_ACT.saveProjectStatus(ptstid,ptsremarks,ptsstatus,ptsaddedby,mid,token,preguid,loginname,deliverydate,showclient,taskname,imgname,uarefid);
			
			if(!imgname.equalsIgnoreCase("NA")){
				String pfrefid[]=Clientmaster_ACT.getFolderDetails(pregno, token);
				if(pfrefid[0]!=null&&pfrefid[1]!=null)
				SeoOnPage_ACT.saveDocument(pfrefid[0],pfrefid[1],imgname,fpath,token,loginid,"NA","NA",pregcuid,today);
			}
			
			//add notification '.. comented on project nunmber ...'
			String pagename="mytask.html";
			String accesscode="MT00";
			String clpage="NA";
			if(showclient.equalsIgnoreCase("1"))clpage="client_inbox.html";
			String uuid =RandomStringUtils.random(30, true, true);	
			String assignby=Usermaster_ACT.getLoginUserName(loginuaid,token);				
			String msg="<b>"+assignby+"</b> commented on Project No : <b>"+pregno+"</b>";
			ClientACT.addNotification(uuid,pregno,msg,pagename,"assigntask",showclient,pregcuid,"1","1",loginid,token,clpage,loginuaid,accesscode,"1","1");
						
			
			if(!ptsstatus.equalsIgnoreCase("Completed"))
			SeoOnPage_ACT.updateProjectStatusList(ptstid,ptsstatus,token);	
			else if(ptsstatus.equalsIgnoreCase("Completed")){
				SeoOnPage_ACT.updateProjectTaskStatus(ptstid,token);
				
				//if all task completed of project then update status completed and update deliveredon date
				int completedtask=0;
				int milestone=0;
				milestone=Clientmaster_ACT.getAllMileStone(preguid,token);
				completedtask=Clientmaster_ACT.getAllCompletedTask(pregno,token);
				String pstatus=Clientmaster_ACT.getProjectStatus(preguid,token);
				if(milestone==completedtask&&milestone!=0&&completedtask!=0&&!pstatus.equalsIgnoreCase("Delivered")){					
					//update project Completed in project table 
					Clientmaster_ACT.updateProjectStatusDate(preguid,today,token); 
					//counting total project price items
					int tppi=Clientmaster_ACT.getCountAllPriceItems(preguid,token);
					//counting total project price items paid
					int tppip=Clientmaster_ACT.getCountAllPriceItemsPaid(preguid,token,"billing");
					
					if(tppi==tppip){
					//update project delivered in project table
					Clientmaster_ACT.updateProjectStatusDelivered(preguid,token); 
					//updating renewal daTE
					Clientmaster_ACT.updateRenewalDate(preguid,today,token);	
				  }
				}
				
			}
			
			if(ptsstatus.equalsIgnoreCase("On Hold")){
				//updating assigned task's  delivery date
				SeoOnPage_ACT.updateTaskDeliveryDate(ptstid,deliverydate,token);				
				//updating assigned milestone's delivery date
				SeoOnPage_ACT.updateDeliveryDate(ptstid,mid,deliverydate,token,emproleid,loginuaid);
				//updating project's delivery date
				SeoOnPage_ACT.updteProjectDeliveryDate(ptstid,token);
			}
			
			RequestDispatcher rd=request.getRequestDispatcher("/viewdetails.html");
			rd.forward(request, response);
		}

		catch (Exception e) {
			e.printStackTrace();
		}

	}

}