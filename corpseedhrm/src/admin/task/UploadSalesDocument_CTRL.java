package admin.task;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import com.oreilly.servlet.MultipartRequest;

import admin.enquiry.Enquiry_ACT;
import admin.master.CloudService;
import admin.master.Usermaster_ACT;
import commons.DateUtil;

public class UploadSalesDocument_CTRL extends HttpServlet {	
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
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
			String docpath=properties.getProperty("path")+"documents";
		MultipartRequest m=new MultipartRequest(request,docpath,1024*1024*48);		
		
			String docKey = m.getParameter("docKey").trim();
			String fileBoxName = m.getParameter("file").trim();
			String assignKey=m.getParameter("assignKey");
			if(assignKey==null)assignKey="NA";
			String workStartPrice=m.getParameter("workStartPrice");
			if(workStartPrice==null)workStartPrice="0";
//			System.out.println("fileBoxName="+fileBoxName);
			File file=m.getFile(fileBoxName);
			String imgname="NA";
			
			if(file!=null){
				imgname=file.getName();
				file = new File(docpath+File.separator+imgname);
				String key =RandomStringUtils.random(20, true, true);
				imgname=imgname.replaceAll("\\s", "-");
				imgname=key+"_"+imgname;
				File newFile = new File(docpath+File.separator+imgname);
				file.renameTo(newFile);
				
				CloudService.uploadDocument(newFile, imgname);
				newFile.delete();
				}
			//getting old file name
//			String oldFileName=TaskMaster_ACT.getOldFileName(docKey,uavalidtokenno);
//			if(oldFileName!=null&&oldFileName.length()>0&&!oldFileName.equalsIgnoreCase("NA")) {
//				File delFile=new File(docuploadpath+"/"+oldFileName);
//				if(delFile.exists()) {delFile.delete();
//				}
//			}
			
//			System.out.println(docKey+"/"+imgname);
			
			//getting current date
			String today=DateUtil.getCurrentDateIndianFormat1();
			//update file name in salesdocument table
			if(imgname!=null&&imgname.length()>0&&!imgname.equalsIgnoreCase("NA")) {
//			flag=TaskMaster_ACT.updateSalesDocument(docKey,imgname,today,uavalidtokenno,loginuaid,assignKey,workStartPrice);
//			System.out.println("dockey==="+docKey);				
				
				flag=Enquiry_ACT.updateDocumentName(docKey,imgname,loginuaid,today,uavalidtokenno,assignKey,workStartPrice);
			}
			if(flag) {	
				
				//getting sales key
				String salesKey[]=TaskMaster_ACT.getSalesKeyByDocKey(docKey,uavalidtokenno);
				//inserting upload action in document action history
				String userName=Usermaster_ACT.getLoginUserName(loginuaid, uavalidtokenno);
				String estKey=salesKey[3];
				if(salesKey[0]!=null)
					TaskMaster_ACT.saveDocumentActionHistory(salesKey[0],salesKey[1],"Upload",loginuaid,userName,uavalidtokenno,docKey,today,imgname,estKey);
				
				//checking all document uploaded
				boolean docUploaded=TaskMaster_ACT.isAllClientDocumentUploaded(salesKey[1],uavalidtokenno);
//				System.out.println("docUploaded==="+docUploaded+"#=="+salesKey[1]);
				if(docUploaded) {
					TaskMaster_ACT.updateDocUploadStatus(salesKey[1],uavalidtokenno,today,DateUtil.getCurrentTime24Hours());					
				}
				
				//checking document re-upload requested
				boolean reUploadStatus=TaskMaster_ACT.findReUploadRequested(docKey,uavalidtokenno);
				if(reUploadStatus) {
					Enquiry_ACT.updateDocumentReUploadStatus(docKey,uavalidtokenno);
					//updating person doc. uploaded
					String doc[]=TaskMaster_ACT.findSalesDocDetails(docKey, uavalidtokenno);
					
					String nKey=RandomStringUtils.random(40,true,true);
					String message="<span class=\"text-info\">"+doc[0]+"</span> is uploaded, do needful.";
					TaskMaster_ACT.addNotification(nKey,today,doc[1],"2",""+doc[2]+"?reupload=done",message,uavalidtokenno,loginuaid,"fa fa-file");
				}
				
				//checking all reupload document done
				boolean reUploadDone=TaskMaster_ACT.isAllReUploadDone(salesKey[1],uavalidtokenno);
				if(!reUploadDone) {
					TaskMaster_ACT.updateDocReUploadStatus(salesKey[1],uavalidtokenno, "2");
				}
				
				pw.write("pass#"+imgname);
			}
			else pw.write("fail#0");
		}catch(Exception e) {
			e.printStackTrace();
		}
	}

}