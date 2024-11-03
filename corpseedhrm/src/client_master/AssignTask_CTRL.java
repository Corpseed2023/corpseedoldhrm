package client_master;

import java.io.File;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
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
import admin.master.Usermaster_ACT;
import admin.seo.SeoOnPage_ACT;
import admin.task.TaskMaster_ACT;
import commons.DateUtil;
import hcustbackend.ClientACT;

@SuppressWarnings("serial")
public class AssignTask_CTRL extends HttpServlet {
	private static Logger log = Logger.getLogger(LoginAction.class);

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		boolean status = true;
		HttpSession session = request.getSession();
try{
		
		DateFormat df = new SimpleDateFormat("dd-MM-yyyy");
		Calendar calobj = Calendar.getInstance();
		String assdate = df.format(calobj.getTime());
		
		Properties properties = new Properties();
		properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
		String docpath=properties.getProperty("path")+"documents";
		String docBasePath=properties.getProperty("docBasePath");
		
		String imgname="NA";
		String fpath="NA";
		String loginuaid = (String) session.getAttribute("loginuaid");
		String loginid = (String) session.getAttribute("loginuID");
		String uacompany= (String)session.getAttribute("uacompany");
		String token = (String) session.getAttribute("uavalidtokenno");			
		MultipartRequest m=new MultipartRequest(request,docpath,1024*1024*50);
		File file=m.getFile("files");
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
		String pfupid = m.getParameter("pfupid");
		String pfuato = m.getParameter("pfuato");
		String pfuatoid = m.getParameter("pfuatoid");
		String taskdetails =m.getParameter("tasks");
		String pfuremark = m.getParameter("pfuremark");
		String pfuddate = m.getParameter("pfuddate");		
		String pfupname =m.getParameter("pfupname");		
		String projectid=m.getParameter("projectid");
		String pfucid=m.getParameter("pfucid");
		
			String task[]=taskdetails.split(",");
				
				String ptltuid = TaskMaster_ACT.getmanifescode(token);
				String start=Usermaster_ACT.getStartingCode(token,"imtaskkey");
				if (ptltuid == null) {
					ptltuid = start+"1";
				} else {
					String c=ptltuid.substring(start.length());
					int j=Integer.parseInt(c)+1;
					ptltuid=start+Integer.toString(j);
					
				}
				String today = DateUtil.getCurrentDateIndianFormat1();
				String ptlname= pfupname+DateUtil.getCurrentDateIndianFormat2();
				
				String id = Clientmaster_ACT.saveManageTask(ptltuid, pfupid, loginuaid,projectid,ptlname, pfuremark, today, pfuddate, loginid, uacompany,token);
				//saving document into document_master table
				if(!imgname.equalsIgnoreCase("NA")){
					String folder[]=Clientmaster_ACT.getFolderDetails(projectid,token);
					if(folder.length>0)
				SeoOnPage_ACT.saveDocument(folder[0],folder[1],imgname,fpath,token,loginid,"NA","NA",pfucid,today);
				}
				//assign task and id				
				for(int i=0;i<task.length;i++){
					Clientmaster_ACT.assignTask(id,projectid,task[i],pfuatoid,assdate,pfuddate,imgname,"1",loginid,token,pfuremark);
					String taskname=TaskMaster_ACT.getTaskNameById(task[i], token);
					//add notification 'assign task ...'
					String pagename="mytask.html";
					String accesscode="MT00";
					String uuid =RandomStringUtils.random(30, true, true);	
					String assignby=Usermaster_ACT.getLoginUserName(loginuaid,token);				
					String msg="<b>"+projectid+" : "+taskname+"</b> task assign by  <b>"+assignby+"</b> to <b>"+pfuato+"</b>";
					ClientACT.addNotification(uuid,projectid,msg,pagename,"assigntask","0",pfucid,"1","1",loginid,token,"NA",loginuaid,accesscode,"1","0");					
				}
					Clientmaster_ACT.saveAssignedId(ptltuid,pfuatoid,"1",loginid,token);					
					
					
			}catch(Exception e){
				log.info("Error in AssignTask_CTRL \n"+e);
			}

		if (status){
		response.sendRedirect(request.getContextPath()+"/assigntask-project.html");
		}
		else {
			session.setAttribute("ErrorMessage", "Project Follow Up Failed!");
			response.sendRedirect(request.getContextPath()+"/notification.html");			
		}		
	}

}
