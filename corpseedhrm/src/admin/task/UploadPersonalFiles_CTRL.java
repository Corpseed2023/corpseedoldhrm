package admin.task;

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
import commons.AzureBlob;
import commons.DateUtil;


@SuppressWarnings("serial")
public class UploadPersonalFiles_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 PrintWriter pw=response.getWriter();
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String loginuaid = (String) session.getAttribute("loginuaid");	
		String loginuID = (String) session.getAttribute("loginuID");
		
		boolean flag=false;
		try {
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
			String docpath=properties.getProperty("path")+"documents";
			String azure_key=properties.getProperty("azure_key");
			String azure_container=properties.getProperty("azure_container");
		MultipartRequest m=new MultipartRequest(request,docpath,1024*1024*50);		
		
			
			File file=m.getFile("folder_file_name");
			String imgname="NA";
			
			if(file!=null){
				imgname=file.getName();
				file = new File(docpath+"/"+imgname);
				String key =RandomStringUtils.random(20, true, true);
				imgname=imgname.replaceAll("\\s", "-");
				imgname=key+"_"+imgname;
				File newFile = new File(docpath+"/"+imgname);
				file.renameTo(newFile);
								
				BlobClientBuilder client=AzureBlob.getBlobClient(azure_key, azure_container);
		        client.connectionString(azure_key);
		        client.containerName(azure_container);
		        InputStream targetStream = new FileInputStream(newFile);
		        client.blobName(imgname).buildClient().upload(targetStream,newFile.length());
				
				targetStream.close();
				newFile.delete();
				}
//			System.out.println(imgname);
			String fileName=m.getParameter("file_name");
			String description=m.getParameter("file_description");
			String salesKey=m.getParameter("salesKey");
			
			//getting current date
			String today=DateUtil.getCurrentDateIndianFormat1();
			//update file name in salesdocument table
			if(imgname!=null&&imgname.length()>0&&!imgname.equalsIgnoreCase("NA")){
				String fileKey=RandomStringUtils.random(40,true,true);
				String uploadBy="Agent";
				boolean status=Usermaster_ACT.isThisClient(loginuaid, uavalidtokenno);
				if(status)uploadBy="Client";
				flag=TaskMaster_ACT.addPersonalFiles(fileKey,salesKey,fileName, description, uploadBy, imgname, loginuaid, today, loginuID, uavalidtokenno);
			}
			if(flag)pw.write("pass");
			else pw.write("fail");
		}catch(Exception e) {
			e.printStackTrace();
		}
	}

}