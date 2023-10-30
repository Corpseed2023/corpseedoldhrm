package Company_Login;

import java.io.File;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;

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
import org.apache.commons.io.FilenameUtils;

import admin.master.Usermaster_ACT;

public class UploadClientDocumentsCTRL  extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1565254520395873525L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession();
		String dmtype = "";
		String passid = "";
		String imagename = "";
		String companyregistration = "";
		String pancard = "";
		String aadharcard = "";
		String chequecopy = "";
		String imageurl = "";
		String addedby = (String) session.getAttribute("loginuID");

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
				if(item.getFieldName().equals("type")) dmtype = item.getString();
				else if(item.getFieldName().equals("companyregistrationfilename")) companyregistration = item.getString();
				else if(item.getFieldName().equals("panfilename")) pancard = item.getString();
				else if(item.getFieldName().equals("aadharfilename")) aadharcard = item.getString();
				else if(item.getFieldName().equals("chequefilename")) chequecopy = item.getString();
				else if(item.getFieldName().equals("passid")) passid = item.getString();
			}
		}

		String UPLOAD_DIRECTORY = "/home/itsws/hrm/documents/"+dmtype+"/";

		Iterator itr2 = items.iterator();
		while (itr2.hasNext()) {
			FileItem item = (FileItem) itr2.next();
			if (!item.isFormField()) {
				try {
					if(item.getFieldName().equals("companyregistrationfile")) imagename=companyregistration;
					else if(item.getFieldName().equals("panfile")) imagename=pancard;
					else if(item.getFieldName().equals("aadharfile")) imagename=aadharcard;
					else if(item.getFieldName().equals("chequefile")) imagename=chequecopy;
					imageurl = (passid+"-"+dmtype+"-"+imagename+"."+FilenameUtils.getExtension(item.getName())).toLowerCase().replaceAll(" ", "-");
					File savedFile = new File(UPLOAD_DIRECTORY+imageurl);
					item.write(savedFile);
					Usermaster_ACT.SaveDocument(dmtype, passid, imagename, imageurl, addedby);
				} catch (Exception e) {
				}
			}
		}

		response.sendRedirect(request.getContextPath()+"/company-details.html");
	}
}