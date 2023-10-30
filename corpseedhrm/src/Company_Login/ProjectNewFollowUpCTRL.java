package Company_Login;

import java.io.File; 
import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import admin.master.Usermaster_ACT;
import client_master.Clientmaster_ACT;

public class ProjectNewFollowUpCTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		RequestDispatcher rd = null;
		boolean status = false;

		HttpSession session = request.getSession();

		String token = (String) session.getAttribute("uavalidtokenno");
		String addedby = (String) session.getAttribute("loginuID");
		//String UPLOAD_DIRECTORY = "/home/itsws/hrm/documents/projectfollowup/";
		String UPLOAD_DIRECTORY = "C:/";
		String pfupid = "";
		String pfuato = "";
		String pfuatoid = "";
		String pfustatus = "";
		String pfudate = "";
		String pfuremark = "";
		String pfuchanges = "";
		String followupby = "";
		String pfuddate = "";
		String showclient = "";
		String imagename = "";
		String imageurl = "";

		FileItemFactory factory = new DiskFileItemFactory();
		ServletFileUpload upload = new ServletFileUpload(factory);
		List items = null;
		try {
			items = upload.parseRequest(request);
		} catch (FileUploadException e) {
		}

		Iterator itr = items.iterator();
		while (itr.hasNext()) {
			FileItem item = (FileItem) itr.next();
			if (item.isFormField()) {
				if(item.getFieldName().equals("pfupid")) pfupid = item.getString();
				else if(item.getFieldName().equals("pfuato")) pfuato = item.getString();
				else if(item.getFieldName().equals("pfuatoid")) pfuatoid = item.getString();
				else if(item.getFieldName().equals("pfustatus")) pfustatus = item.getString();
				else if(item.getFieldName().equals("pfudate")) pfudate = item.getString();
				else if(item.getFieldName().equals("pfuremark")) pfuremark = item.getString();
				else if(item.getFieldName().equals("pfuchanges")) pfuchanges = item.getString();
				else if(item.getFieldName().equals("followupby")) followupby = item.getString();
				else if(item.getFieldName().equals("pfuddate")) pfuddate = item.getString();
				else if(item.getFieldName().equals("showclient")) showclient = item.getString();
			}

		}

//		status = Clientmaster_ACT.saveFollowUp(pfupid, pfustatus, pfudate, pfuremark, addedby, pfuatoid, pfuchanges, followupby, pfuddate, showclient,token,"project");

		status = Clientmaster_ACT.saveFollowUpinProjectMaster(pfupid, pfustatus, pfudate, pfuato, "1");

		String pfuid = Clientmaster_ACT.getLastFollowUp(pfupid);

		Iterator itr2 = items.iterator();
		while (itr2.hasNext()) {
			FileItem item = (FileItem) itr2.next();
			if(!item.isFormField()) {
				try {
					imagename = item.getName();
					if(!imagename.equals("")) {
						imageurl = imagename.toLowerCase().replaceAll(" ", "-");
						File savedFile = new File(UPLOAD_DIRECTORY+imageurl);
						Usermaster_ACT.SaveDocument("projectfollowup", pfuid, imagename, imageurl, addedby);
						item.write(savedFile);
					}
				} catch (Exception e) {
				}
			}
		}

		rd = request.getRequestDispatcher("/projectfollowup.html");
		rd.forward(request, response);

	}

}