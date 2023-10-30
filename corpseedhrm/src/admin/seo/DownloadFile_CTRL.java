package admin.seo;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class DownloadFile_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		try
		{
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
			String docuploadpath=properties.getProperty("path")+"documents";
			
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			String filename=request.getParameter("file");
			String filepath=docuploadpath+File.separator;
			response.setContentType("APPLICATION/OCTET-STREAM");
			response.setHeader("Content-Disposition", "attachment; filename=\""
					+ filename + "\"");
			FileInputStream fileInputStream = new FileInputStream(filepath
					+ filename);
			int i;
			while ((i = fileInputStream.read()) != -1) {
				out.write(i);
			}
			fileInputStream.close();
			out.close();
	}
		catch(Exception e)
		{
				e.printStackTrace();
		}
		
	}

}
