package hcustbackend;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Properties;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class DownloadClientDocument_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//		String path=request.getContextPath()+"/documents/"+request.getParameter("filename");
//		try (BufferedInputStream inputStream = new BufferedInputStream(new URL("D:/ITSWS/ITSWS NEW/Client_LoginWebContent/documents"+request.getParameter("filename")).openStream());
//				  FileOutputStream fileOS = new FileOutputStream(path)) {
//				    byte data[] = new byte[1024];
//				    int byteContent;
//				    while ((byteContent = inputStream.read(data, 0, 1024)) != -1) {
//				        fileOS.write(data, 0, byteContent);
//				    }
//				} catch (IOException e) {
//				    // handles IO exceptions
//				}
		try {
			HttpSession session=request.getSession();
			// reads input file from an absolute path
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
			String filePath=properties.getProperty("path")+"documents"+File.separator;
			
	        File downloadFile = new File(filePath);
	        if(downloadFile.exists()){
	        FileInputStream inStream = new FileInputStream(downloadFile);
	        
	        // obtains ServletContext
	        ServletContext context = getServletContext();
	         
	        // gets MIME type of the file
	        String mimeType = context.getMimeType(filePath);
	        if (mimeType == null) {        
	            // set to binary type if MIME mapping not found
	            mimeType = "application/octet-stream";
	        }
	        // modifies response
	        response.setContentType(mimeType);
	        response.setContentLength((int) downloadFile.length());
	         
	        // forces download
	        String headerKey = "Content-Disposition";
	        String headerValue = String.format("attachment; filename=\"%s\"", downloadFile.getName());
	        response.setHeader(headerKey, headerValue);
	         
	        // obtains response's output stream
	        OutputStream outStream = response.getOutputStream();
	         
	        byte[] buffer = new byte[4096];
	        int bytesRead = -1;
	         
	        while ((bytesRead = inStream.read(buffer)) != -1) {
	            outStream.write(buffer, 0, bytesRead);
	        }
	         
	        inStream.close();
	        outStream.close();
	        }else{
	        	session.setAttribute("errorMsg","File Doesn't Exists.");
	        	session.setAttribute("page","client_documents.html");
	        	RequestDispatcher rd=request.getRequestDispatcher("/client_error_page.html");
	        	rd.forward(request, response);
	        }
		} catch (Exception e) {e.printStackTrace();
			// TODO: handle exception
		}
	}

}
