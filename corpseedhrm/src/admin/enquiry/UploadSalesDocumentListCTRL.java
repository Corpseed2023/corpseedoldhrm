package admin.enquiry;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
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
import admin.task.TaskMaster_ACT;
import commons.AzureBlob;
import commons.DateUtil;

@SuppressWarnings("serial")
public class UploadSalesDocumentListCTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
//			String delimgname="NA";
			HttpSession session = request.getSession(); 
			String token = (String)session.getAttribute("uavalidtokenno");			
			String loginuid = (String)session.getAttribute("loginuaid");
			String today=DateUtil.getCurrentDateIndianFormat1();
			boolean flag=false;
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
			String docpath=properties.getProperty("path")+"documents";
			String azure_key=properties.getProperty("azure_key");
			String azure_container=properties.getProperty("azure_container");
			
			MultipartRequest m=new MultipartRequest(request,docpath,1024*1024*50);
			String docrefid=m.getParameter("docrefid");
			if(docrefid!=null)docrefid=docrefid.trim();
			
			String filebox=m.getParameter("docfileInputBoxId");
			if(filebox!=null)filebox=filebox.trim();
			
			File file=m.getFile(filebox);
//			System.out.println(docrefid+"-"+filebox+"/"+file);
//			String filename=Enquiry_ACT.getFileName(docrefid,token);
//			if(!filename.equalsIgnoreCase("NA")){
//				File file1 = new File(docpath+"/"+filename);
//				flag=file1.delete();				
//			}			
//			System.out.println("filename="+filename+"/"+flag);
			String imgname="NA";
			if(file!=null){
				imgname=file.getName();
				file = new File(docpath+File.separator+imgname);
				String key =RandomStringUtils.random(20, true, true);
				imgname=imgname.replaceAll("\\s", "-");
				imgname=key+"_"+imgname;
				File newFile = new File(docpath+File.separator+imgname);
				file.renameTo(newFile);
				BlobClientBuilder client=AzureBlob.getBlobClient(azure_key, azure_container);
		        client.connectionString(azure_key);
		        client.containerName(azure_container);
		        InputStream targetStream = new FileInputStream(newFile);
		        client.blobName(imgname).buildClient().upload(targetStream,newFile.length());
				
				targetStream.close();
				newFile.delete();
				}
			String date=DateUtil.getCurrentDateIndianFormat1();
				flag=Enquiry_ACT.updateDocumentName(docrefid,imgname,loginuid,date,token,"NA","0");
				//if image uploaded by it's name then delete
//				if(!delimgname.equalsIgnoreCase("NA")){
//					File file1 = new File(docpath+"/"+delimgname);
//					file1.delete();				
//				}	
				
				if(flag) {
					//getting sales key
					String salesKey[]=TaskMaster_ACT.getSalesKeyByDocKey(docrefid,token);
					//inserting upload action in document action history
					String userName=Usermaster_ACT.getLoginUserName(loginuid, token);
					String estKey=salesKey[3];
					
					if(salesKey[0]!=null)
					TaskMaster_ACT.saveDocumentActionHistory(salesKey[0],salesKey[1],"Upload",loginuid,userName,token,docrefid,today,imgname,estKey);
					
					//checking all document uploaded
					boolean docUploaded=TaskMaster_ACT.isAllClientDocumentUploaded(salesKey[1],token);
					if(docUploaded)
						TaskMaster_ACT.updateDocUploadStatus(salesKey[1],token,today,DateUtil.getCurrentTime24Hours());
					
					//checking document re-upload requested
					boolean reUploadStatus=TaskMaster_ACT.findReUploadRequested(docrefid,token);
					if(reUploadStatus) {
						Enquiry_ACT.updateDocumentReUploadStatus(docrefid,token);
						//updating person doc. uploaded
						//updating person doc. uploaded
						String doc[]=TaskMaster_ACT.findSalesDocDetails(docrefid, token);
						
						String nKey=RandomStringUtils.random(40,true,true);
						String message="<span class=\"text-info\">"+doc[0]+"</span> is uploaded, do needful.";
						TaskMaster_ACT.addNotification(nKey,today,doc[1],"2",""+doc[2]+"?reupload=done",message,token,loginuid,"fa fa-file");
					}
					
					//checking all reupload document done
					boolean reUploadDone=TaskMaster_ACT.isAllReUploadDone(salesKey[1],token);
					if(!reUploadDone) {
						TaskMaster_ACT.updateDocReUploadStatus(salesKey[1],token, "2");
					}
										
				}
			PrintWriter pw=response.getWriter();
			if(flag){
				pw.write("success");
			}else{
				pw.write("fail");
			}			
		}
		catch (Exception e) {
			e.printStackTrace();
		}

	}
}