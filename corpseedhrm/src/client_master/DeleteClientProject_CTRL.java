package client_master;

import java.io.IOException;
import java.util.Enumeration;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class DeleteClientProject_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			
			String docpath="NA";
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
			Enumeration<?> enumeration =properties.propertyNames();
			while (enumeration.hasMoreElements()) {
				String key = (String) enumeration.nextElement();
				if(key.equalsIgnoreCase("docpath"))
					docpath=properties.getProperty(key);	
				
			}
			
			HttpSession session=request.getSession();
			String token=(String)session.getAttribute("uavalidtokenno");
			String pid = request.getParameter("info").trim();	
			String pregpuno = request.getParameter("pregpuno").trim();	
			String cid = request.getParameter("cid").trim();	
			Clientmaster_ACT.deleteClientProject(pid,token,pregpuno,cid);
			Clientmaster_ACT.deleteSubFolder(cid,pregpuno,token,docpath);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}
